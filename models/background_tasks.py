import time
import datetime
from services.esp_service import EspService
from services.logs_service import LogService
from services.email_service import EmailService

class StatusMonitor:
    """
    Um "vigia" que roda em background, monitorando o status da ESP32
    e disparando ações quando eventos importantes ocorrem.
    """
    def __init__(self, esp_service: EspService, log_service: LogService, email_service: EmailService):
        self.esp_service = esp_service
        self.log_service = log_service
        self.email_service = email_service
        self.last_alarm_state = False

    def check_status_and_act(self):
        """Verifica o status e age se necessário."""
        print("--- VIGIA: Verificando status da ESP32... ---")
        
        status_result = self.esp_service.get_esp_status()

        if not status_result["success"]:
            print(f"--- VIGIA: Não foi possível obter status. Erro: {status_result['error']} ---")
            return

        current_alarm_state = status_result["data"].get('alarm_triggered', False)

        if current_alarm_state and not self.last_alarm_state:
            print("!!!!!!!!!! INTRUSÃO DETECTADA !!!!!!!!!!")
            
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
        """Inicia o loop infinito de monitoramento."""
        print("--- VIGIA: Serviço de monitoramento em background iniciado. ---")
        while True:
            try:
                self.check_status_and_act()
            except Exception as e:
                print(f"--- VIGIA: Erro inesperado no loop: {e} ---")
            
            time.sleep(5)