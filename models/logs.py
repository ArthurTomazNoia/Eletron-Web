# Ficheiro: models/logs_model.py
import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
LOG_FILE_PATH = os.path.join(DATA_DIR, 'logs.json')

class LogModel:
    """
    Gerencia o acesso ao arquivo de logs (logs.json).
    Este modelo é 'stateless', ele lê o arquivo a cada operação.
    """
    def __init__(self):
        # Garante que o diretório exista. Não precisa mais carregar na inicialização.
        os.makedirs(DATA_DIR, exist_ok=True)

    def _load(self):
        """Carrega a lista de logs do arquivo JSON."""
        if not os.path.exists(LOG_FILE_PATH):
            return []
        try:
            with open(LOG_FILE_PATH, 'r', encoding='utf-8') as f:
                content = f.read()
                if not content:
                    return []
                # O 'seek' não é estritamente necessário aqui, mas é uma boa prática
                # se você for ler o arquivo múltiplas vezes dentro do mesmo 'with'.
                # Para este caso, poderíamos simplesmente fazer data = json.loads(content).
                f.seek(0) 
                data = json.load(f)
                return sorted(data, key=lambda x: x.get('timestamp', ''), reverse=True)
        except (json.JSONDecodeError, TypeError):
            return []

    def _save(self, logs_data: list):
        """Salva uma lista de logs no arquivo."""
        with open(LOG_FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump(logs_data, f, indent=4, ensure_ascii=False)

    def get_all(self):
        """
        MODIFICADO: Sempre carrega os logs do arquivo para garantir dados frescos.
        """
        return self._load()

    def add_log_entry(self, log_entry: dict):
        """
        MODIFICADO: Carrega os logs atuais, adiciona o novo e salva tudo.
        """
        # 1. Carrega a lista mais recente do arquivo
        current_logs = self._load()
        # 2. Adiciona a nova entrada no início
        current_logs.insert(0, log_entry)
        # 3. Salva a lista completa e atualizada
        self._save(current_logs)