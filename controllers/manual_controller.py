from bottle import Bottle, request
from .base_controller import BaseController
from services.manual_service import ManualService

class ManualController(BaseController):
    def __init__(self, app):
        super().__init__(app)

        self.setup_routes()
        self.manual_service = ManualService()


    # Rotas User
    def setup_routes(self):
        self.app.route('/manual', method='GET', callback=self.list_manual)
    

    def list_manual(self):
        manual = self.manual_service.get_all()
        return self.render('manual', manual=manual)


manual_routes = Bottle()
manual_controller = ManualController(manual_routes)
