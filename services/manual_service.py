from bottle import request
from models.manual import ManualModel, Manual
class ManualService:
    def __init__(self):
        self.ManualModel = ManualModel()

    def get_all(self):
        return self.ManualModel.get_all()