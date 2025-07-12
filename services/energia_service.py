# Ficheiro: service/energia_service.py

from models.energia import EnergiaModel

class EnergiaService:
    """
    Camada de lógica de negócio. Orquestra as operações de energia.
    """
    def __init__(self):
        self.energia_model = EnergiaModel()

    def ligar_energia(self):
        """Regra de negócio para ligar a energia."""
        self.energia_model.set_status("ligado")
        print("Serviço: Energia LIGADA.")
        # Aqui poderia haver outra lógica, como enviar um email, logar, etc.

    def desligar_energia(self):
        """Regra de negócio para desligar a energia."""
        self.energia_model.set_status("desligado")
        print("Serviço: Energia DESLIGADA.")

    def obter_status_atual(self):
        """Busca o status atual através do model."""
        print(f"Serviço: Verificando status. Atual: {self.energia_model.get_status()}")
        return self.energia_model.get_status()