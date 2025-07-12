from bottle import Bottle, request
from .base_controller import BaseController
from services.energia_service import EnergiaService

class EnergiaController(BaseController):
    def __init__(self, app):
        super().__init__(app)

        self.setup_routes()
        self.energia_service = EnergiaService()


    # Rotas User
    def setup_routes(self):
        self.app.route('/energia', method='GET', callback=self.list_energia)
    

    def list_energia(self):
        energia = self.energia_service.get_all()
        return self.render('energia', energia=energia)


energia_routes = Bottle()
energia_controller = EnergiaController(energia_routes)
