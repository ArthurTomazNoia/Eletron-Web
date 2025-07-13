# Ficheiro: services/logs_service.py
import datetime
import uuid
from models.logs import LogModel

class LogService:
    """
    Contém a lógica de negócio para criar e obter logs.
    """
    def __init__(self):
        self.log_model = LogModel()

    def create_log_entry(self, event: str, user: str, details: str):
        """Cria uma nova entrada de log com data e hora atuais."""
        log_data = {
            "id": str(uuid.uuid4()),
            "timestamp": datetime.datetime.now().isoformat(),
            "event": event,
            "user": user,
            "details": details
        }
        self.log_model.add_log_entry(log_data)
        print(f"Log criado: {event}")

    def get_all_logs(self):
        """Busca todos os logs através do model."""
        return self.log_model.get_all()