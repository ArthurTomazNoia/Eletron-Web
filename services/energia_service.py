

from models.energia import EnergiaModel
from services.logs_service import LogService

class EnergiaService:
    
    def __init__(self):
        self.energia_model = EnergiaModel()
        self.log_service = LogService()


    def ligar_energia(self):
        """Regra de negócio para ligar a energia."""
        self.energia_model.set_status("ligado")
        self.log_service.create_log_entry(
            event="Sistema ligado", user="admin", details="Energia ativada."
        )
        print("Serviço: Energia LIGADA.")
        

    def desligar_energia(self):
        
        self.energia_model.set_status("desligado")
        self.log_service.create_log_entry(
            event="Sistema desligado", user="admin", details="Energia desativada."
        )
        print("Serviço: Energia DESLIGADA.")

    def obter_status_atual(self):
        
        print(f"Serviço: Verificando status. Atual: {self.energia_model.get_status()}")
        return self.energia_model.get_status()