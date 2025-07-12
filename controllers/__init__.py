from bottle import Bottle
from controllers.user_controller import user_routes
from controllers.home_controller import home_routes
from controllers.manual_controller import manual_routes
from controllers.energia_controller import energia_routes

def init_controllers(app: Bottle):
    app.merge(user_routes)
    app.merge(home_routes)
    app.merge(manual_routes)
    app.merge(energia_routes)
