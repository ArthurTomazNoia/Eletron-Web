from bottle import Bottle, request
import requests
from .base_controller import BaseController

# Após conectar o ESP32, o 'esp32_ip' será encontrado no Monitor Serial da IDE
# Substitua pelo IP da sua ESP32

class EspController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.esp32_ip = "192.168.0.130"
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/esp/control', method=['GET', 'POST'], callback=self.control_esp32)
        self.app.route('/esp/ldr', method='GET', callback=self.read_ldr)
        self.app.route('/esp/manual_mode', method='GET', callback=self.set_manual_mode)
        self.app.route('/esp/auto_mode', method='GET', callback=self.set_auto_mode)
        self.app.route('/esp/off_mode', method='GET', callback=self.set_off_mode)
        self.app.route('/esp/reset_alarm', method='GET', callback=self.reset_alarm)
        self.app.route('/esp/toggle_laser', method=['GET', 'POST'], callback=self.toggle_laser)
    
    def _send_request(self, url, method=["GET"], data = None):
        try:
            if method == "POST":
                response = requests.post(url, data=data)
            else:
                response = requests.get(url)
            response.raise_for_status()
            return response.text
        except requests.exceptions.RequestException as e:
            print(f"ERRO ao comunicar com ESP32 em {url}: {e}")
            return f"ERRO: ESP32 não conectada ou request falhou ({e})"

    def control_esp32(self):
        cmd = request.query.get('cmd') or request.forms.get('acao')
        url = ""
        method = "GET"

        if cmd == 'manual':
            url = f"http://{self.esp32_ip}/manual"
        elif cmd == 'auto':
            url = f"http://{self.esp32_ip}/mode?set=auto"
        elif cmd == 'off':
            url = f"http://{self.esp32_ip}/mode?set=off"
        elif cmd == "reset_alarm":
            url = f"http://{self.esp32_ip}/get_alarm_status?action=reset"
        elif cmd == "toggle_laser":
            url = f"http://{self.esp32_ip}/toggle_laser"
            method = "POST"
        else:
            return "Invalid command"

        response = self._send_request(url, method)
        if "Error" not in response:
            return self.redirect('/home')
        return response

    def read_ldr(self):
        url = f"http://{self.esp32_ip}/read_ldr"
        response = self._send_request(url)
        return response

    def set_manual_mode(self):
        url = f"http://{self.esp32_ip}/manual"
        response = self._send_request(url)
        if "Error" not in response:
             return self.redirect('/home')
        return response

    def set_auto_mode(self):
        url = f"http://{self.esp32_ip}/mode?set=auto"
        response = self._send_request(url)
        if "Error" not in response:
             return self.redirect('/home')
        return response

    def set_off_mode(self):
        url = f"http://{self.esp32_ip}/mode?set=off"
        response = self._send_request(url)
        if "Error" not in response:
             return self.redirect('/home')
        return response

    def reset_alarm(self):
        url = f"http://{self.esp32_ip}/get_alarm_status?action=reset"
        response = self._send_request(url)
        if "Error" not in response:
             return self.redirect('/home')
        return response

    def toggle_laser(self):
        url = f"http://{self.esp32_ip}/toggle_laser"
        method = "POST" if request.method == 'POST' else "GET" # Use POST for the actual action
        response = self._send_request(url, method)
        if "Error" not in response:
             return self.redirect('/home')
        return response


esp_routes = Bottle()
esp_controller = EspController(esp_routes)