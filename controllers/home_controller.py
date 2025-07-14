

from bottle import Bottle
from .base_controller import BaseController
import controllers.esp_controller as esp_c


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
        manual_set_result = esp_c.esp_service.perform_esp_action('mode', 'set', {'set': 'manual'})
        message = ""
        if not manual_set_result["success"]:
            message = f"Erro ao ativar modo manual na ESP32: {manual_set_result['error']}"
        else:
            message = manual_set_result["message"]
        return self.render('manual', message=message)
   
    
    def tut(self):
        return self.render('tut')
    

    
    


home_routes = Bottle()
home_controller = HomeController(home_routes)