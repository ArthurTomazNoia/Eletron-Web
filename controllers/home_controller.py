

from bottle import Bottle
from .base_controller import BaseController 


class HomeController(BaseController):
    def __init__(self, app):
        
        super().__init__(app) 
        self._setup_home_routes()

    def _setup_home_routes(self):
        
        self.app.route('/home', method='GET', callback=self.home)
        
        self.app.route('/manual', method='GET', callback=self.manual)
        
        self.app.route('/tut', method='GET', callback=self.tut)
        
    def home(self):
        
        return self.render('home') 
    
    
    
    def manual(self):
        return self.render('manual')
   
    
    def tut(self):
        return self.render('tut')
    

    
    


home_routes = Bottle()
home_controller = HomeController(home_routes)