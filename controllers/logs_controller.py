# Ficheiro: controllers/logs_controller.py
from bottle import Bottle, HTTPResponse, request, response
from .base_controller import BaseController
from services.logs_service import LogService

class LogController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.log_service = LogService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/logs', method='GET', callback=self.render_logs_page)

    def render_logs_page(self):
        """Busca todos os logs e renderiza a página de histórico."""
        all_logs = self.log_service.get_all_logs()
        # Passa a lista de logs para o template
        return self.render('logs', logs=all_logs)
    
log_routes = Bottle()
logs_controller = LogController(log_routes)
    
