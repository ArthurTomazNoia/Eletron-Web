import os

class Config:
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    ESP32_IP = '192.168.0.130'  # IP do ESP32 na rede local

    # Configurações do servidor
    HOST = 'localhost'
    PORT = 8080
    DEBUG = True
    RELOADER = True

    # Paths
    TEMPLATE_PATH = os.path.join(BASE_DIR, 'views')
    STATIC_PATH = os.path.join(BASE_DIR, 'static')
    DATA_PATH = os.path.join(BASE_DIR, 'data')

    # Outras configurações
    SECRET_KEY = 'sua-chave-secreta-aqui'
