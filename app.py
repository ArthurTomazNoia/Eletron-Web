from bottle import Bottle
from config import Config
import threading 

from services.esp_service import EspService
from services.logs_service import LogService
from services.email_service import EmailService
from models.background_tasks import StatusMonitor


class App:
    def __init__(self):
        self.bottle = Bottle()
        self.config = Config()


    def setup_routes(self):
        from controllers import init_controllers
        from controllers.esp_controller import esp_ctl_app

        print('🚀 Inicializa rotas!')
        init_controllers(self.bottle)
        self.bottle.mount('/esp', esp_ctl_app)


    def run(self):
        self.setup_routes()
          # --- LÓGICA DO VIGIA EM BACKGROUND ---
        print("🔧 Inicializando serviços para o monitor...")
       
        esp_service = EspService(esp32_ip=getattr(self.config, 'ESP32_IP', '192.168.0.130'))
        log_service = LogService()
        email_service = EmailService()

        monitor = StatusMonitor(
            esp_service=esp_service,
            log_service=log_service,
            email_service=email_service
        )

        print("🚦 Iniciando monitor em background...")
        monitor_thread = threading.Thread(target=monitor.run, daemon=True)
        monitor_thread.start()
        
        # --- FIM DA LÓGICA DO VIGIA ---

        print(f"🛰️  Servidor web iniciado em http://{self.config.HOST}:{self.config.PORT}")
        if self.config.RELOADER:
            print("⚠️  AVISO: Reloader está ativo. Para evitar múltiplas threads, defina RELOADER = False em config.py")

        self.bottle.run(
            host=self.config.HOST,
            port=self.config.PORT,
            debug=self.config.DEBUG,
            reloader=self.config.RELOADER
        )


def create_app():
    return App()
