# controllers/home_controller.py

from bottle import Bottle
from .base_controller import BaseController # Importa a classe base

# HomeController HERDA de BaseController
class HomeController(BaseController):
    def __init__(self, app):
        # O super().__init__(app) chama o construtor da classe pai (BaseController)
        # Isso é importante para que as rotas base (como a de arquivos estáticos) sejam configuradas
        super().__init__(app) 
        self._setup_home_routes()

    def _setup_home_routes(self):
        """Configura as rotas específicas desta página."""
        self.app.route('/home', method='GET', callback=self.home)
        
        self.app.route('/manual', method='GET', callback=self.manual)
        self.app.route('/logs', method='GET', callback=self.logs)
        self.app.route('/tut', method='GET', callback=self.tut)
        
    def home(self):
        # A função render espera o NOME do arquivo de template, sem a barra inicial.
        # Ex: 'home.tpl' ou 'views/home.html'
        return self.render('home') 
    
    
    
    def manual(self):
        return self.render('manual')
    
    def logs(self):
        return self.render('logs')
    
    def tut(self):
        return self.render('tut')
    

    
    

# Instancia o Bottle e o controller para serem importados no init
home_routes = Bottle()
home_controller = HomeController(home_routes)