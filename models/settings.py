# Ficheiro: models/settings_model.py
import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
SETTINGS_FILE_PATH = os.path.join(DATA_DIR, 'settings.json')

class SettingsModel:
    def _load_settings(self):
        """Carrega as configurações do arquivo JSON."""
        if not os.path.exists(SETTINGS_FILE_PATH):
            return {}
        try:
            with open(SETTINGS_FILE_PATH, 'r', encoding='utf-8') as f:
                return json.load(f)
        except (json.JSONDecodeError, TypeError):
            return {}

    def _save_settings(self, settings_data: dict):
        """Salva as configurações no arquivo."""
        with open(SETTINGS_FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump(settings_data, f, indent=4, ensure_ascii=False)

    def get_setting(self, key: str):
        """Busca o valor de uma configuração específica."""
        settings = self._load_settings()
        return settings.get(key)

    def update_setting(self, key: str, value):
        """Atualiza uma configuração e salva o arquivo."""
        settings = self._load_settings()
        settings[key] = value
        self._save_settings(settings)