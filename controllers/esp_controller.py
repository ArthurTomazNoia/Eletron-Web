from bottle import Bottle, request, route, redirect, response
import json

from services.esp_service import EspService 

ESP32_TARGET_IP = "192.168.0.130" 

esp_service = EspService(esp32_ip=ESP32_TARGET_IP)
esp_ctl_app = Bottle()

@esp_ctl_app.route('/api/status')
def api_get_status():
    """
    Busca o status atual da ESP32 e retorna como JSON.
    """
    status_result = esp_service.get_esp_status()

    response.content_type = 'application/json'
    if status_result["success"]:
        return json.dumps(status_result["data"])
    else:
        response.status = 500
        return json.dumps({"error": status_result["error"]})

@esp_ctl_app.route('/action/<device>/<action_type>', method=['GET', 'POST'])
def perform_action(device, action_type):
    """
    Rota genérica para executar ações nos componentes da ESP32.
    """
    query_params = dict(request.query)
    if request.method == 'POST':
        query_params.update(dict(request.forms))

    action_result = esp_service.perform_esp_action(device, action_type, query_params)

    if action_result["success"]:
        redirect(f'/?message={action_result["message"]}')
    else:
        redirect(f'/?message=Erro: {action_result["error"]}')

# Rota para /manual
@esp_ctl_app.route('/manual')
def original_manual_link():
    """
    Ativa o modo manual na ESP32 diretamente e redireciona para a página principal.
    """
    try:
        # Chama o endpoint /manual diretamente na ESP32
        # O esp_service._send_request já lida com a comunicação HTTP e exceções.
        esp_service._send_request(f"{esp_service.esp32_base_url}/manual")
        redirect(f'/?message=Modo Manual ativado com sucesso!')
    except ConnectionError as e:
        # Se houver um erro de conexão, redireciona com a mensagem de erro
        redirect(f'/?message=Erro ao ativar Modo Manual: {e}')
    except Exception as e:
        # Para outros erros inesperados
        redirect(f'/?message=Erro inesperado ao ativar Modo Manual: {e}')
