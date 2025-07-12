# Ficheiro: model/energia_model.py
import datetime
import json
import os
from home_controller import HomeController, Home 

# Ajusta o caminho para encontrar a pasta 'data' a partir da raiz do projeto
# __file__ se refere a 'energia_model.py' -> dirname é 'model/' -> '..' sobe um nível
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class EnergiaModel:
    """
    Camada de acesso aos dados. Lida diretamente com o arquivo power.json.
    """
    DATA_PATH = os.path.join(DATA_DIR, 'power.json')

    def __init__(self):
        # Garante que o diretório exista ao instanciar
        os.makedirs(DATA_DIR, exist_ok=True)
        self.status = self._load()

    def _load(self):
        if not os.path.exists(self.DATA_PATH):
            return "desligado"
        try:
            with open(self.DATA_PATH, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
                sorted_data = sorted(data, key=lambda x: x.get('id', 0), reverse=True)
               
                return [Home.from_dict(item) for item in sorted_data]
        except (json.JSONDecodeError, TypeError):
            return "desligado"

    def _save(self):
        with open(self.DATA_PATH, 'w', encoding='utf-8') as f:
            data_to_save = {'status': self.status}
            json.dump(data_to_save, f, indent=4, ensure_ascii=False)

    def get_status(self):
        return self.status

    def set_status(self, new_status):
        if new_status in ["ligado", "desligado"]:
            self.status = new_status
            self._save()