import requests # type: ignore
import json

ESP32_IP = "192.168.0.130"
url = f"http://{ESP32_IP}/get_status_json"

try:
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    print("Resposta da ESP32 (texto):", response.text)
    print("Resposta da ESP32 (JSON):", response.json())
except requests.exceptions.Timeout:
    print("Erro: Timeout ao conectar com a ESP32.")
except requests.exceptions.ConnectionError:
    print("Erro: Conexão recusada ou falha de rede.")
except requests.exceptions.RequestException as e:
    print(f"Erro na requisição: {e}")
except json.JSONDecodeError:
    print("Erro: Resposta não é um JSON válido.")