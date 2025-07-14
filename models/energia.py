
import datetime
import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class EnergiaModel:
    
    DATA_PATH = os.path.join(DATA_DIR, 'power.json')

    def __init__(self):
        os.makedirs(DATA_DIR, exist_ok=True)
        self.status = self._load()

    def _load(self):
        
        if not os.path.exists(self.DATA_PATH):
            return "desligado"  

        try:
            with open(self.DATA_PATH, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
                return data.get('status', 'desligado')
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