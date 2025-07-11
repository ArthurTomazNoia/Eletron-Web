from bottle import request
from models.home import HomeModel, Home
class HomeService:
    def __init__(self):
        self.HomeModel = HomeModel()

    def get_all(self):
        return self.HomeModel.get_all()
    