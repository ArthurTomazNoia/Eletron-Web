from bottle import request
from models.energia import EnergiaModel, Energia
class EnergiaService:
    def __init__(self):
        self.EnergiaModel = EnergiaModel()

    def get_all(self):
        return self.EnergiaModel.get_all()
    