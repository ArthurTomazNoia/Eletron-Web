from bottle import route, redirect, request
import requests

# Após conectar o ESP32, o IP será encontrado no Monitor Serial da IDE
# Substitua pelo IP da sua ESP32
ESP32_IP = "192.168.0.130"

@route('/ctl', methods=['GET', 'POST'])
def controlar_esp32():
    cmd = request.query.get('cmd')
    if request.method == 'POST':
        # Se for um POST (como o toggle_laser original)
        if request.forms.get('acao') == 'toggle_laser':
            cmd = 'toggle_laser'

    url = ""
    method = "GET"
    if cmd == 'manual':
        url = f"http://{ESP32_IP}/mode?set=manual"
    elif cmd == 'auto':
        url = f"http://{ESP32_IP}/mode?set=auto"
    elif cmd == 'off':
        url = f"http://{ESP32_IP}/mode?set=off"
    
    if cmd == "reset_alarm":
        url = f"http//{ESP32_IP}/get_alarm_status?action=reset"
    
    if cmd == "toggle_laser":
        url = f"http://{ESP32_IP}/toggle_laser"
        method = "POST"

    
