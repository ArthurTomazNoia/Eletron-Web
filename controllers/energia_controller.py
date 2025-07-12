from bottle import Bottle, request
from .base_controller import BaseController
from services.energia_service import EnergiaService

class EnergiaController(BaseController):
    """
    Controller para gerenciar as rotas relacionadas ao status de energia.
    """
    def __init__(self, app):
        
        super().__init__(app)
        
        self.energia_service = EnergiaService()
        
        self.setup_routes()

    def setup_routes(self):
        """
        Mapeia as URLs (rotas) para os métodos correspondentes deste controller.
        """
        self.app.route('/energia/status', method='GET', callback=self.get_status)
        self.app.route('/energia/on', method='POST', callback=self.turn_on)
        self.app.route('/energia/off', method='POST', callback=self.turn_off)

    def get_status(self):
        """
        Endpoint para verificar o status atual da energia.
        Usa o serviço para obter os dados e retorna em formato JSON.
        """
        status_atual = self.energia_service.obter_status_atual()
        return {'status': status_atual}

    def turn_on(self):
        """
        Endpoint para ligar a energia.
        Chama o serviço para executar a ação e retorna o novo status.
        """
        self.energia_service.ligar_energia()
        status_atual = self.energia_service.obter_status_atual()
        return {'status': status_atual, 'message': 'Energia ativada com sucesso.'}

    def turn_off(self):
        """
        Endpoint para desligar a energia.
        Chama o serviço para executar a ação e retorna o novo status.
        """
        self.energia_service.desligar_energia()
        status_atual = self.energia_service.obter_status_atual()
        return {'status': status_atual, 'message': 'Energia desativada com sucesso.'}
    
energia_routes = Bottle()
energia_controller = EnergiaController(energia_routes)