<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Modo Manual</title>
    <style>
        
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@700;900&display=swap');

        body {
            background-color: #000;
            color: #fff;
            font-family: 'Heebo', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .title {
            font-size: 3em;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
        }

        .mode-text {
            font-size: 1.8em;
            margin-bottom: 50px;
        }

        .manual-button {
            background-color: #FEEA62; 
            color: #000;
            border: 2px solid #9400D3; 
            padding: 25px 50px;
            font-size: 2.5em;
            font-weight: 700;
            font-family: 'Heebo', sans-serif;
            cursor: pointer;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .manual-button:hover {
            background-color: #e8d65a;
            border-color: #800080; 
        }
        .back-link {
            color: #00BFFF; 
            text-decoration: none;
            margin-top: 50px;
            font-size: 1.2em;
        }
         .imagem-fixa {
            position: fixed;
            top: 20px;
            right: 20px;
            width: 100px;
            height: auto; 
            z-index: 1000;
        }
    </style>
</head>
<body>
    <img style="width:20%" src="http://localhost:8080/static/img/Eletro.png" alt="Logo-eletronjun" class="imagem-fixa">
    <div class="container">
        <h1 class="title">Laser Alarm</h1>
        <p class="mode-text">Modo Manual:</p>
        <button id="off_button"class="manual-button">Desativar</button>
        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>
    
    <script>
        async function setEspMode(mode) {
            let url = '';
            if (mode === 'off') {
                url = '/esp/off_mode';
            } else {
                console.error('Modo inválido para o ESP32:', mode);
                return;
            }
            try {
                const response = await fetch(url, { method: 'GET' });
                const data = await response.text();
                console.log(`Resposta do ESP32 para modo ${mode}:`, data);
                alert(`Modo do ESP32 alterado para: ${mode.toUpperCase()}`);
                loadPowerStatusOnPageLoad();
            } catch (error) {
                console.error(`Erro ao mudar modo do ESP32 para ${mode}:`, error);
                alert('Erro ao comunicar com o dispositivo ESP32.');
            }
        }

        const sair_manual = document.getElementById('off_button')
        if (sair_manual){
            sair_manual.addEventListener('click', () => setEspMode('off'))
        }

    </script>
</body>
</html>