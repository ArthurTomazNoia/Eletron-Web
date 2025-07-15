
import requests
import json 

# Após conectar o ESP32, o 'esp32_ip' será encontrado no Monitor Serial da IDE
# Substitua pelo IP da sua ESP32

class EspService():
    def __init__(self, esp32_ip="192.168.0.130"): # O IP agora é passado na inicialização
        self.esp32_ip = esp32_ip # O usuário deve substituir este IP
        self.esp32_base_url = f"http://{self.esp32_ip}"

    def _send_request(self, url, method="GET", data=None):
        """
        Função auxiliar para enviar requisições HTTP para a ESP32.
        Retorna o texto da resposta ou levanta uma exceção em caso de erro.
        """
        try:
            print(f"DEBUG: Enviando {method} request para ESP32 URL: {url}")
            if method == "POST":
                res = requests.post(url, data=data, timeout=10) # Adicionado timeout
            else:
                res = requests.get(url, timeout=10) # Adicionado timeout
            res.raise_for_status()
            print(f"DEBUG: Resposta da ESP32 para {url} (Status: {res.status_code}): {res.text[:200]}...")
            return res.text
        except requests.exceptions.Timeout:
            print(f"ERRO: Timeout ao comunicar com ESP32 em {url}")
            raise ConnectionError(f"Timeout: ESP32 não respondeu em tempo. Verifique a conexão Wi-Fi da ESP32.")
        except requests.exceptions.ConnectionError as e:
            print(f"ERRO: Conexão recusada ou falha de rede ao comunicar com ESP32 em {url}: {e}")
            raise ConnectionError(f"Conexão recusada/falha de rede: ESP32 pode estar offline ou IP incorreto. Detalhes: {e}")
        except requests.exceptions.RequestException as e:
            print(f"ERRO geral ao comunicar com ESP32 em {url}: {e}")
            raise ConnectionError(f"Erro na requisição HTTP para ESP32: {e}")

    def _send_request_json(self, url, method="GET", data=None):
        """
        Função auxiliar para enviar requisições HTTP para a ESP32 e esperar JSON.
        Retorna o dicionário Python do JSON ou levanta uma exceção.
        """
        try:
            res_text = self._send_request(url, method, data)
            return json.loads(res_text)
        except json.JSONDecodeError as e:
            print(f"ERRO ao decodificar JSON da ESP32 em {url}: {e}. Resposta: '{res_text[:100]}...'")
            raise ValueError(f"Resposta JSON inválida da ESP32: {e}")
        except ConnectionError as e:
            raise e

    def get_esp_status(self):
        """
        Busca o status atual da ESP32 e retorna o dicionário Python.
        Lida com erros e os retorna no dicionário.
        """
        try:
            status_data = self._send_request_json(f"{self.esp32_base_url}/get_status_json")
            return {"success": True, "data": status_data}
        except (ConnectionError, ValueError) as e:
            return {"success": False, "error": str(e)}
        except Exception as e:
            return {"success": False, "error": f"Erro inesperado: {e}"}

    def perform_esp_action(self, device, action_type, query_params=None):
        """
        Executa uma ação nos componentes da ESP32.
        query_params: dicionário de parâmetros de query (ex: {'set': 'manual'})
        """
        esp32_url = ""
        method = "GET"
        
        if query_params is None:
            query_params = {}
        
        print(f"DEBUG: perform_esp_action chamado. Device: {device}, Action: {action_type}, Params: {query_params}")

        try:
            if device == 'mode':
                mode_set = query_params.get('set')
                if not mode_set:
                    raise ValueError("Parâmetro 'set' de modo ausente.")
                if mode_set == 'manual':
                    esp32_url = f"{self.esp32_base_url}/manual"
                else:
                    esp32_url = f"{self.esp32_base_url}/mode?set={mode_set}"
            elif device == 'laser' and action_type == 'toggle':
                esp32_url = f"{self.esp32_base_url}/toggle_laser"
                method = "POST" 
            elif device == 'buzzer':
                state = query_params.get('state')
                if not state:
                    raise ValueError("Parâmetro 'state' do buzzer ausente.")
                esp32_url = f"{self.esp32_base_url}/buzzer?state={state}"
            elif device == 'manual_alert' and action_type == 'reset':
                esp32_url = f"{self.esp32_base_url}/get_alarm_status?action=reset"
            else:
                raise ValueError("Ação ou dispositivo desconhecido.")

            self._send_request(esp32_url, method) # A ESP32 redireciona após a ação
            return {"success": True, "message": "Comando enviado com sucesso!"}

        except ValueError as e:
            return {"success": False, "error": str(e)}
        except ConnectionError as e:
            return {"success": False, "error": str(e)}
        except Exception as e:
            return {"success": False, "error": f"Erro inesperado: {e}"}

