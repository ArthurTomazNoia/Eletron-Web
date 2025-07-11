from bottle import Bottle, request
from .base_controller import BaseController
from services.home_service import HomeService

class HomeController(BaseController):
    def __init__(self, app):
        super().__init__(app)

        self.setup_routes()
        self.home_service = HomeService()


    # Rotas User
    def setup_routes(self):
        self.app.route('/home', method='GET', callback=self.list_home)
    

    def list_home(self):
        home = self.home_service.get_all()
        return self.render('home', home=home)


home_routes = Bottle()
home_controller = HomeController(home_routes)
