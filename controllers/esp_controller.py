from bottle import request, route, redirect, response
import json

from services.esp_service import EspService 

ESP32_TARGET_IP = "192.168.0.130" 

esp_service = EspService(esp32_ip=ESP32_TARGET_IP)

@route('/api/status')
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

@route('/action/<device>/<action_type>', method=['GET', 'POST'])
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
@route('/manual')
def original_manual_link():
    redirect('/action/mode/set?set=manual')


