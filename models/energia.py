import json, os
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
class Energia:
    def __init__(self,user):
        self.user=user
    def to_dict(self):
        return{
            'user': self.user
        }
    @classmethod
    def from_dict(cls,data):
                return cls(
            user=data['user']
        )
class EnergiaModel:
    DATA_PATH = os.path.join(DATA_DIR, 'energia.json')
    def __init__(self):
        self.energia = self._load()

    def _load(self):
        if not os.path.exists(self.DATA_PATH):
            return []
        with open(self.DATA_PATH, 'r', encoding='utf-8') as f:
            return [Energia.from_dict(item) for item in json.load(f)]
        
    def get_all(self):
        return self.energia