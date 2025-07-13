from bottle import Bottle
from .base_controller import BaseController
from services.energia_service import EnergiaService

class EnergiaController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.energia_service = EnergiaService()
        self.setup_routes()

    def setup_routes(self):
        """
        Mapeia as URLs da API. Note o prefixo /api.
        """
        # Rota para a PÁGINA HTML
        self.app.route('/energia', method='GET', callback=self.render_energia_page)

        # Rotas para a API (retornam JSON)
        self.app.route('/api/energia/status', method='GET', callback=self.get_status)
        self.app.route('/api/energia/on', method='POST', callback=self.turn_on)
        self.app.route('/api/energia/off', method='POST', callback=self.turn_off)

    def render_energia_page(self):
        """
        Esta é a "porta da frente". Ela renderiza o arquivo HTML para o usuário.
        """
        # Supondo que seu template se chama 'energia.html' e está na pasta 'templates'
        return self.render('energia') # O BaseController precisa ter esse método 'render'

    def get_status(self):
        status_atual = self.energia_service.obter_status_atual()
        return {'status': status_atual}

    def turn_on(self):
        self.energia_service.ligar_energia()
        return {'status': 'ligado', 'message': 'Energia ativada.'}

    def turn_off(self):
        self.energia_service.desligar_energia()
        return {'status': 'desligado', 'message': 'Energia desativada.'}

# Nota: Para o self.render('energia') funcionar, seu BaseController precisa de um método render:
#
# class BaseController:
#     def __init__(self, app):
#         self.app = app
#
#     def render(self, template_name, **kwargs):
#         # Importe a função 'template' do bottle
#         from bottle import template
#         return template(template_name, **kwargs)

energia_routes = Bottle()
energia_controller = EnergiaController(energia_routes)