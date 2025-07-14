from bottle import Bottle
from controllers.user_controller import user_routes
from controllers.home_controller import home_routes
from controllers.energia_controller import energia_routes   
from controllers.logs_controller import log_routes
from controllers.settings_controller import settings_routes




def init_controllers(app: Bottle):
    app.merge(user_routes)
    app.merge(home_routes)
    app.merge(energia_routes)
    app.merge(log_routes)
    app.merge(settings_routes)
    
