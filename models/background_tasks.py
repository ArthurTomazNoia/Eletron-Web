import time
import datetime
from services.esp_service import EspService
from services.logs_service import LogService
from services.email_service import EmailService

class StatusMonitor:
    def __init__(self, esp_service: EspService, log_service: LogService, email_service: EmailService):
        self.esp_service = esp_service
        self.log_service = log_service
        self.email_service = email_service
        self.last_alarm_state = False

        # --- NOVAS VARIÁVEIS DE CONTROLE DE FALHAS ---
        self.consecutive_failures = 0
        self.max_failures_before_pause = 5  # Pausa após 5 falhas seguidas
        self.is_monitoring_paused = False
        self.pause_duration_seconds = 300   # Pausa por 5 minutos (300 segundos)

    def check_status_and_act(self):
        """Verifica o status e age se necessário."""
        print("--- VIGIA: Verificando status da ESP32... ---")
        
        status_result = self.esp_service.get_esp_status()

        # --- LÓGICA DE CONTROLE DE FALHAS ---
        if not status_result["success"]:
            self.consecutive_failures += 1
            print(f"--- VIGIA: Falha de comunicação nº {self.consecutive_failures}. Erro: {status_result['error']} ---")
            
            if self.consecutive_failures >= self.max_failures_before_pause:
                print(f"!!!!!!!!!! VIGIA: Limite de {self.max_failures_before_pause} falhas atingido. Pausando o monitoramento por {self.pause_duration_seconds} segundos. !!!!!!!!!!")
                self.is_monitoring_paused = True # Ativa o modo de pausa
            return # Interrompe a execução deste ciclo

        # Se a comunicação foi um sucesso, reseta o contador de falhas
        if self.consecutive_failures > 0:
            print("--- VIGIA: Conexão com a ESP32 reestabelecida. ---")
            self.consecutive_failures = 0
            
        # --- LÓGICA DE DETECÇÃO DE INTRUSÃO (continua igual) ---
        current_alarm_state = status_result["data"].get('alarm_triggered', False)
        if current_alarm_state and not self.last_alarm_state:
            print("!!!!!!!!!! INTRUSÃO DETECTADA !!!!!!!!!!")
            # (O código para criar log e enviar email continua aqui...)
            timestamp = datetime.datetime.now().strftime("%d/%m/%Y às %H:%M:%S")

            self.log_service.create_log_entry(
                event="INTRUSÃO DETECTADA",
                user="Sistema",
                details="O sensor laser foi interrompido."
            )
            self.email_service.send_notification_email(
                subject="[ALERTA MÁXIMO] INTRUSÃO DETECTADA NO LASER ALARM!",
                body=f"Atenção! Uma intrusão foi detectada pelo sensor laser em {timestamp}."
            )

        self.last_alarm_state = current_alarm_state

    def run(self):
        """Inicia o loop infinito de monitoramento com lógica de pausa."""
        print("--- VIGIA: Serviço de monitoramento em background iniciado. ---")
        while True:
            try:
                if self.is_monitoring_paused:
                    # Se estiver pausado, apenas espera e tenta novamente depois
                    time.sleep(self.pause_duration_seconds)
                    self.is_monitoring_paused = False # Libera para a próxima tentativa
                    self.consecutive_failures = 0
                    print("--- VIGIA: Fim da pausa. Retomando o monitoramento. ---")
                else:
                    self.check_status_and_act()
                    # Espera o intervalo normal entre verificações
                    time.sleep(5)
            except Exception as e:
                print(f"--- VIGIA: Erro crítico no loop de monitoramento: {e} ---")
                time.sleep(60) # Em caso de erro inesperado, espera 1 minuto