# Ficheiro: controllers/settings_controller.py

from bottle import Bottle, request, redirect
from .base_controller import BaseController
from services.settings_service import SettingsService

class SettingsController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.settings_service = SettingsService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/configuracoes', method='GET', callback=self.render_settings_page)
        self.app.route('/configuracoes/salvar', method='POST', callback=self.save_settings)

    def render_settings_page(self):
        """Mostra a página de configurações com o email atual."""
        current_email = self.settings_service.get_notification_email()
        return self.render('configuracoes', current_email=current_email or "")

    def save_settings(self):
        """Salva o novo email enviado pelo formulário."""
        new_email = request.forms.get('notification_email')
        self.settings_service.update_notification_email(new_email)
        return redirect('/configuracoes')
    
settings_routes = Bottle()
settings_controller = SettingsController(settings_routes)    