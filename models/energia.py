# Ficheiro: model/energia_model.py
import datetime
import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')

class EnergiaModel:
    """
    Camada de acesso aos dados. Lida diretamente com o arquivo power.json.
    """
    DATA_PATH = os.path.join(DATA_DIR, 'power.json')

    def __init__(self):
        os.makedirs(DATA_DIR, exist_ok=True)
        self.status = self._load()

    def _load(self):
        """
        Carrega o status do arquivo power.json.
        """
        if not os.path.exists(self.DATA_PATH):
            return "desligado"  # Retorna o padrão se o arquivo não existir

        try:
            with open(self.DATA_PATH, 'r', encoding='utf-8') as f:
                data = json.load(f)
                # CORREÇÃO: Pega o valor da chave 'status' do dicionário.
                # Retorna 'desligado' se a chave não existir ou o arquivo for inválido.
                return data.get('status', 'desligado')
        except (json.JSONDecodeError, TypeError):
            # Retorna o padrão se o arquivo estiver vazio ou for um JSON inválido.
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