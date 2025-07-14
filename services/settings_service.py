# Ficheiro: services/settings_service.py
from models.settings import SettingsModel

class SettingsService:
    def __init__(self):
        self.settings_model = SettingsModel()
        self.NOTIFICATION_EMAIL_KEY = "notification_email"

    def get_notification_email(self):
        """Retorna o email de notificação configurado."""
        return self.settings_model.get_setting(self.NOTIFICATION_EMAIL_KEY)

    def update_notification_email(self, new_email: str):
        """Valida e atualiza o email de notificação."""
        if new_email and '@' in new_email: # Validação simples
            self.settings_model.update_setting(self.NOTIFICATION_EMAIL_KEY, new_email)
            print(f"Email de notificação atualizado para: {new_email}")
            return True
        return False