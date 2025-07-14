
import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
LOG_FILE_PATH = os.path.join(DATA_DIR, 'logs.json')

class LogModel:
    
    def __init__(self):
        
        os.makedirs(DATA_DIR, exist_ok=True)

    def _load(self):
        if not os.path.exists(LOG_FILE_PATH):
            return []
        try:
            with open(LOG_FILE_PATH, 'r', encoding='utf-8') as f:
                content = f.read()
                if not content:
                    return []
              
                f.seek(0) 
                data = json.load(f)
                return sorted(data, key=lambda x: x.get('timestamp', ''), reverse=True)
        except (json.JSONDecodeError, TypeError):
            return []

    def _save(self, logs_data: list):
        
        with open(LOG_FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump(logs_data, f, indent=4, ensure_ascii=False)

    def get_all(self):
        
        return self._load()

    def add_log_entry(self, log_entry: dict):
        
        current_logs = self._load()
        
        current_logs.insert(0, log_entry)
        
        self._save(current_logs)