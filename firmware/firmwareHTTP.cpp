#include <Arduino.h>
#include <WiFi.h>
#include "esp_http_server.h"
#include <LittleFS.h>

// =========================================================================
//                  DEFINIÇÃO DOS PINOS DO ESP32
// =========================================================================
static uint8_t pinoLDR = 18;       // LDR digital conectado ao pino digital GPIO1 (ATENÇÃO: pode haver conflito com TX)
static uint8_t pinoBuzzer = 15;    // Buzzer conectado ao pino digital GPIO3 (ATENÇÃO: pode haver conflito com RX)
static uint8_t pinoLEDVerde = 21;  // LED Verde conectado ao pino digital GPIO17
static uint8_t pinoLEDAmarelo = 5; // LED Amarelo conectado ao pino digital GPIO18
static uint8_t pinoLEDVermelho = 2; // LED Vermelho conectado ao pino digital GPIO16
static uint8_t pinoBotao = 0;      // Botão (Reset/Manual) conectado ao pino digital GPIO0
static uint8_t pinoLaser = 23;      // Módulo Laser conectado ao pino digital GPIO4

// =========================================================================
//                  CONFIGURAÇÃO DO WIFI E DO SERVIDOR HTTP
// =========================================================================
const char* ssid = "CLARO_2G57D978"; // SSID da internet local
const char* password = "Wlrl120239"; // Senha da internet local

httpd_handle_t server = NULL; // Declaração do manipulador do servidor HTTP
httpd_req_t *req; // Declaração do ponteiro struct para a requisição HTTP

// =========================================================================
//                  PROTÓTIPOS DAS FUNÇÕES
// =========================================================================
// Declaramos as funções antes de usá-las para que o compilador as conheça.
bool lerLdr();
void laser(bool estado);
void buzzer(bool estado);
void ctlLED(const char* cor, bool estado);
void allLEDs(bool green, bool yellow, bool red);
void startServer();

// =========================================================================
//                  VARIÁVEIS GLOBAIS
// =========================================================================
bool manualInterrupt = false; // Variável para armazenar interrrupção no modo manual
bool laserAtual = false; // Variável para armazenar o estado atual do laser

enum DeviceMode {
  MODE_OFF,
  MODE_MANUAL,
  MODE_AUTOMATIC
};
DeviceMode currentMode = MODE_OFF; // Variável para armazenar o modo atual do dispositivo(OFF por padrão)

// =========================================================================
//                  MANIPULADORES DE REQUISIÇÃO HTTP
// =========================================================================

// Funções para lidar com requisições HTTP
// Esta função será chamada quando o servidor receber uma requisição GET na rota "/"
// Função auxiliar para redirecionar para a página inicial
void redirectIndex(httpd_req_t *req) {
  httpd_resp_set_status(req, "302 Found");
  httpd_resp_set_hdr(req, "Location", "/");
  httpd_resp_sendstr(req, "Redirecionando...");
}
static esp_err_t index_handler(httpd_req_t *req) {
    File file = LittleFS.open("/index.html", "r");
  if (!file) {
    Serial.println("Falha ao abrir index.html no LittleFS!");
    httpd_resp_send_500(req);
    return ESP_FAIL;
  }

  // Prepara o cabeçalho HTTP
  httpd_resp_set_type(req, "text/html");

  // Lê o conteúdo do arquivo e envia
  String content = file.readString();
  file.close();

  // Substitui placeholders no HTML para mostrar o modo atual e status de interrupção
  String currentModeStr;
  if (currentMode == MODE_OFF) currentModeStr = "DESLIGADO";
  else if (currentMode == MODE_MANUAL) currentModeStr = "MANUAL";
  else currentModeStr = "AUTOMATICO";
  
  content.replace("{CURRENT_MODE}", currentModeStr);

  if (currentMode == MODE_MANUAL && manualInterrupt) {
      content.replace("{MANUAL_ALERT_STYLE}", "style=\"color: red; font-weight: bold;\"");
      content.replace("{MANUAL_ALERT_MESSAGE}", "ALERTA: Interrupcao detectada no Modo Manual!");
      content.replace("{MANUAL_ALERT_RESET_LINK}", "<p><a href=\"/get_alarm_status?action=reset\">Limpar Alerta Manual</a></p>");
  } else {
      content.replace("{MANUAL_ALERT_STYLE}", "");
      content.replace("{MANUAL_ALERT_MESSAGE}", "");
      content.replace("{MANUAL_ALERT_RESET_LINK}", "");
  }

  httpd_resp_sendstr(req, content.c_str());
  return ESP_OK;
}
// Manipulador para ligar/desligar o laser (POST/GET)
static esp_err_t toggle_laser_handler(httpd_req_t *req){
  if (req->method == HTTP_POST) {
    if (currentMode == MODE_MANUAL) { // Somente permite controle manual do laser no modo manual
      laser(!laserAtual);
      // httpd_resp_sendstr(req, laserAtual ? "Laser Ligado!" : "Laser Desligado!");
      redirectIndex(req);
    } else {
      httpd_resp_sendstr(req, "Laser so pode ser controlado manualmente no Modo Manual.");
    }
  } else {
    httpd_resp_sendstr(req, "Use POST para controlar o laser.");
  }
  return ESP_OK;
}

// Manipulador para ligar e desligar o buzzer (GET)
// http://<IP>/buzzer?state=on|off
static esp_err_t buzzer_control_handler(httpd_req_t *req) {
  char* buf;
  size_t buf_len;

  buf_len = httpd_req_get_url_query_len(req) + 1;
  if (buf_len > 1) {
    buf = (char*)malloc(buf_len);
    if (httpd_req_get_url_query_str(req, buf, buf_len) == ESP_OK) {
      char param[32];
      if (httpd_query_key_value(buf, "state", param, sizeof(param)) == ESP_OK) {
        if (currentMode == MODE_MANUAL) {
          if (strcmp(param, "on") == 0) {
            buzzer(true);
          } else if (strcmp(param, "off") == 0) {
            buzzer(false);
          } else {
            httpd_resp_sendstr(req, "Parametro 'state' invalido. Use 'on' ou 'off'.");
            free(buf);
            return ESP_OK;
          }
          redirectIndex(req);
        } else {
          httpd_resp_sendstr(req, "Buzzer so pode ser controlado manualmente no Modo Manual.");
        }
      }
      free(buf);
    }
  }
  return ESP_OK;
}
// Manipulador para ler o estado do LDR (GET)
static esp_err_t read_ldr_handler(httpd_req_t *req){
  if (currentMode != MODE_OFF) { // LDR pode ser lido nos modos Manual e Automatico
    bool estadoLDR = lerLdr();
    if (estadoLDR) {
      httpd_resp_sendstr(req, "LDR detectou luz (Estado: HIGH)!");
    } else {
      httpd_resp_sendstr(req, "LDR nao detectou luz (Estado: LOW)!");
    }
  } else {
    httpd_resp_sendstr(req, "LDR esta desativado no Modo Desligado.");
  }
  return ESP_OK;
}
// Manipulador para obter/resetar o status do alarme manual
// http://<IP>/get_alarm_status?action=reset
static esp_err_t get_alarm_status_handler(httpd_req_t *req) {
    char* buf;
    size_t buf_len;
    buf_len = httpd_req_get_url_query_len(req) + 1;

    if (buf_len > 1) {
      buf = (char*)malloc(buf_len);
      if (httpd_req_get_url_query_str(req, buf, buf_len) == ESP_OK) {
        char action_param[32];
        if (httpd_query_key_value(buf, "action", action_param, sizeof(action_param)) == ESP_OK) {
          if (strcmp(action_param, "reset") == 0) {
            manualInterrupt = false; // Reseta a flag de interrupção
            allLEDs(false, false, false); // Desliga todos os LEDs
            // httpd_resp_sendstr(req, "Status de interrupcao manual resetado.");
            redirectIndex(req);
          }
        }
        free(buf);
      }
    } else {
      // Se nenhuma query, apenas retorna o status atual
      if (manualInterrupt) {
        httpd_resp_sendstr(req, "Interrupcao detectada no Modo Manual.");
      } else {
        httpd_resp_sendstr(req, "Nenhuma interrupcao detectada no Modo Manual.");
      }
    }
  return ESP_OK;
}
// Manipulador para alternar entre os modos de operação.
// http://<IP>/mode?set=off|auto
static esp_err_t mode_control_handler(httpd_req_t *req) {
  char* buf;
  size_t buf_len;

  buf_len = httpd_req_get_url_query_len(req) + 1;
  if (buf_len > 1) {
    buf = (char*)malloc(buf_len);
    if (httpd_req_get_url_query_str(req, buf, buf_len) == ESP_OK) {
      char set_param[32];
      if (httpd_query_key_value(buf, "set", set_param, sizeof(set_param)) == ESP_OK) {
        if (strcmp(set_param, "off") == 0) {
          currentMode = MODE_OFF;
          // Modo DESLIGADO: Desativa todos os componentes
          laser(false);
          buzzer(false);
          allLEDs(false, false, false); // Desliga todos os LEDs
          manualInterrupt = false; // Zera status de interrupção
          httpd_resp_sendstr(req, "Modo alterado para DESLIGADO!");
        } else if (strcmp(set_param, "auto") == 0) {
          currentMode = MODE_AUTOMATIC;
          // Modo automático: Laser ativo, buzzer e LEDs controlados pelo LDR
          laser(true);
          buzzer(false);
          allLEDs(true, false, false); // LED verde
          manualInterrupt = false; // Zera status de interrupção
          httpd_resp_sendstr(req, "Modo alterado para AUTOMATICO!");
        }
        redirectIndex(req);
      }
      free(buf);
    }
  }
  return ESP_OK;
}

static esp_err_t manual_handler(httpd_req_t *req) {
  currentMode = MODE_MANUAL;
  // Modo manual: Laser ativo, buzzer e LEDs desligados, espera acao do usuario
  laser(true);
  buzzer(false);
  allLEDs(false, false, false);
  manualInterrupt = false; // Zera status de interrupção
  httpd_resp_sendstr(req, "Modo alterado para MANUAL!");
  return ESP_OK;
}

// Manipulador para controlar os LEDs por cor e estado
// http://<IP>/led?color=verde|amarelo|vermelho&state=on|off
static esp_err_t led_control_handler(httpd_req_t *req) {
  char* buf;
  size_t buf_len;

  buf_len = httpd_req_get_url_query_len(req) + 1;
  if (buf_len > 1) {
    buf = (char*)malloc(buf_len);
    if (httpd_req_get_url_query_str(req, buf, buf_len) == ESP_OK) {
      char color_param[32];
      char state_param[32];

      if (httpd_query_key_value(buf, "color", color_param, sizeof(color_param)) == ESP_OK &&
        httpd_query_key_value(buf, "state", state_param, sizeof(state_param)) == ESP_OK) {
        
        if (currentMode == MODE_MANUAL) {
          bool state = (strcmp(state_param, "on") == 0);
          ctlLED(color_param, state);
          // httpd_resp_sendstrf(req, "LED %s definido para %s!", color_param, state_param);
          redirectIndex(req);
        } else {
          httpd_resp_sendstr(req, "LEDs so podem ser controlados manualmente no Modo Manual.");
        }
      }
      free(buf);
    }
  }
  return ESP_OK;
}

// =========================================================================
//                  FUNÇÃO DE CONFIGURAÇÃO (SETUP)
// =========================================================================
void setup() {
  
  Serial.begin(115200); // Inicia a comunicação serial para ver mensagens no Monitor Serial
  Serial.println("Iniciando configuracao...");

  // Configurações dos Pinos:
  pinMode(pinoLDR, INPUT_PULLUP);       // LDR é uma ENTRADA (lê o estado)
  pinMode(pinoBuzzer, OUTPUT);          // Buzzer é uma SAÍDA (o ESP32 o controla)
  pinMode(pinoLEDVerde, OUTPUT);        // LEDs são SAÍDAS
  pinMode(pinoLEDAmarelo, OUTPUT);
  pinMode(pinoLEDVermelho, OUTPUT);
  pinMode(pinoBotao, INPUT_PULLUP);     // Botão é ENTRADA com resistor pull-up interno
  pinMode(pinoLaser, OUTPUT);           // MÓDULO LASER É UMA SAÍDA (o ESP32 o controla)

  // Garante que todos os componentes controlados estejam DESLIGADOS no início:
  digitalWrite(pinoBuzzer, LOW);
  digitalWrite(pinoLEDVerde, LOW);
  digitalWrite(pinoLEDAmarelo, LOW);
  digitalWrite(pinoLEDVermelho, LOW);
  digitalWrite(pinoLaser, LOW);         // Laser DESLIGADO ao iniciar
  Serial.println("Configuracao concluida. Componentes desligados.");

  LittleFS.begin(); // Inicia o sistema de arquivos LittleFS - arquivo index.html é lido aqui
  if(!LittleFS.begin()){
    Serial.println("ERRO: Falha ao montar LittleFS!");
    return;
  }
  Serial.println("LittleFS montado com sucesso.");

  // Configuração do Wi-Fi:
  WiFi.begin(ssid, password); // Conecta à rede Wi-Fi
  Serial.print("Conectando ao WiFi");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Conectado ao WiFi!");
  WiFi.mode(WIFI_STA); // Configura o ESP32 como um cliente Wi-Fi

  // Inicia o servidor HTTP
  startServer();
  Serial.print("Acesse http://");
  Serial.print(WiFi.localIP());
  Serial.println(" para acessar o servidor.");


}

// =========================================================================
//                  FUNÇÃO PRINCIPAL (LOOP)
// =========================================================================
void loop() {
  static unsigned long lastLdrCheck = 0;
  const long ldrInterval = 100; // Frequência de leitura do LDR

  if (millis() - lastLdrCheck >= ldrInterval) {
    lastLdrCheck = millis();
    bool ldrStatus = lerLdr(); // Lê o estado do LDR uma vez por intervalo

    if (currentMode == MODE_AUTOMATIC) {
      if (ldrStatus == true) {
        Serial.println("ALARME: Laser interrompido! Acionando Buzzer e LED Vermelho.");
        buzzer(true);
        allLEDs(false, false, true); // Desliga Verde/Amarelo, Liga Vermelho
      } else {
        buzzer(false);
        allLEDs(true, false, false); // Liga Verde, Desliga Amarelo/Vermelho
      }
      delay(100);
    } else if (currentMode == MODE_MANUAL) {
      if (ldrStatus == true) {
        if (!manualInterrupt) {
          manualInterrupt = true;
          Serial.println("ALERTA MANUAL: Interrupcao de laser detectada.");
          allLEDs(false, true, false);
        }
      } else {
        if (manualInterrupt && digitalRead(pinoLEDAmarelo) == HIGH) {
          allLEDs(false, false, false); // Desliga todos os LEDs (incluindo o amarelo)
        }
      }
    } else {
      currentMode = MODE_OFF;
    }
  }
  delay(100);
}

// =========================================================================
//                  FUNÇÃO PARA LER O LDR
// =========================================================================
bool lerLdr() {
  // digitalRead retorna HIGH (1) ou LOW (0).
  bool ldrEstado = digitalRead(pinoLDR);
  return ldrEstado;
}

// =========================================================================
//                  FUNÇÃO PARA CONTROLAR O LASER
// =========================================================================
void laser(bool estado) {
  digitalWrite(pinoLaser, estado ? HIGH : LOW);
  laserAtual = estado; // Atualiza o estado atual do laser
  Serial.print("Laser definido para: ");
  Serial.println(estado ? "LIGADO" : "DESLIGADO");
}

// =========================================================================
//                  FUNÇÃO PARA CONTROLAR O Buzzer
// =========================================================================
void buzzer(bool estado) {
  digitalWrite(pinoBuzzer, estado ? HIGH : LOW);
  Serial.print("Buzzer definido para: ");
  Serial.println(estado ? "LIGADO" : "DESLIGADO");
}

// =========================================================================
//                  FUNÇÕES PARA CONTROLAR LEDS
// =========================================================================
void ctlLED(const char* cor, bool estado) {
  uint8_t pino = -1; // Valor inválido inicial

  if (strcmp(cor, "verde") == 0) {
    pino = pinoLEDVerde;
  } else if (strcmp(cor, "amarelo") == 0) {
    pino = pinoLEDAmarelo;
  } else if (strcmp(cor, "vermelho") == 0) {
    pino = pinoLEDVermelho;
  }

  if (pino != (uint8_t)-1) {
    digitalWrite(pino, estado ? HIGH : LOW);
    Serial.printf("LED %s definido para: %s\n", cor, estado ? "LIGADO" : "DESLIGADO");
  } else {
    Serial.printf("Cor de LED '%s' invalida.\n", cor);
  }
}

void allLEDs(bool verde, bool amarelo, bool vermelho) {
  digitalWrite(pinoLEDVerde, verde);
  digitalWrite(pinoLEDAmarelo, amarelo);
  digitalWrite(pinoLEDVermelho, vermelho);
  Serial.printf("LEDs: Verde %s, Amarelo %s, Vermelho %s\n",
                verde ? "ON" : "OFF", amarelo ? "ON" : "OFF", vermelho ? "ON" : "OFF");
}

// =========================================================================
//                  FUNÇÃO PARA INICIAR O SERVIDOR HTTP
// =========================================================================
void startServer() {
  // Configuração do servidor HTTP
  httpd_config_t config = HTTPD_DEFAULT_CONFIG();

  Serial.printf("Iniciando webserver http na porta: %d", config.server_port);
  Serial.println();

  // Manipulador de URL
  httpd_uri_t index_uri = {
    .uri       = "/",
    .method    = HTTP_GET,
    .handler   = index_handler,
    .user_ctx  = NULL
  };
  // Manipulador para ligar/desligar o laser
  httpd_uri_t toggle_laser_uri = {
    .uri       = "/toggle_laser",
    .method    = HTTP_POST,
    .handler   = toggle_laser_handler,
    .user_ctx  = NULL
  };
  // Manipulador para ligar o buzzer
  httpd_uri_t buzzer_control_uri = {
    .uri       = "/buzzer",
    .method    = HTTP_GET,
    .handler   = buzzer_control_handler,
    .user_ctx  = NULL
  };
  // Manipulador para ler o estado do LDR
  httpd_uri_t read_ldr_uri = {
    .uri       = "/read_ldr",
    .method    = HTTP_GET,
    .handler   = read_ldr_handler,
    .user_ctx  = NULL
  };
  // Manipulador para controlar o modo de operação
  httpd_uri_t mode_control_uri = {
    .uri       = "/mode",
    .method    = HTTP_GET,
    .handler   = mode_control_handler,
    .user_ctx  = NULL
  };
  // Manipulador para controlar o modo manual
  httpd_uri_t manual_uri = {
    .uri       = "/manual",
    .method    = HTTP_GET,
    .handler   = manual_handler,
    .user_ctx  = NULL
  };
  // Manipulador para obter/resetar o status do alarme manual
  httpd_uri_t get_alarm_status_uri = {
    .uri       = "/get_alarm_status",
    .method    = HTTP_GET,
    .handler   = get_alarm_status_handler,
    .user_ctx  = NULL
  };
  // Manipulador para controlar LEDs por cor e estado
  httpd_uri_t led_control_uri = {
    .uri       = "/led",
    .method    = HTTP_GET,
    .handler   = led_control_handler,
    .user_ctx  = NULL
  };
  if(httpd_start(&server, &config) == ESP_OK) { // Registro dos manipuladores de URI
    httpd_register_uri_handler(server, &index_uri);

    httpd_register_uri_handler(server, &toggle_laser_uri);

    httpd_register_uri_handler(server, &buzzer_control_uri);

    httpd_register_uri_handler(server, &read_ldr_uri);

    httpd_register_uri_handler(server, &mode_control_uri);

    httpd_register_uri_handler(server, &manual_uri);

    httpd_register_uri_handler(server, &get_alarm_status_uri);

    httpd_register_uri_handler(server, &led_control_uri);
  } else {
    Serial.println("Falha ao iniciar o servidor HTTP");
  }
}
