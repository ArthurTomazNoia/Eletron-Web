<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Energia</title>
    <style>
        
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@700;900&display=swap');
        body{background-color:#000;color:#fff;font-family:'Heebo',sans-serif;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;text-align:center;}
        .container{display:flex;flex-direction:column;align-items:center;}
        .title {
            font-size: 3em;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.7);
            margin-bottom: 40px;
        }
        .page-subtitle{font-size:1.8em;margin-bottom:30px;}
        .button-container{display:flex;flex-direction:column;gap:20px;}
        .btn{border:none;padding:20px 0;width:350px;font-size:2.2em;font-weight:700;font-family:'Heebo',sans-serif;cursor:pointer;transition:opacity .3s ease;}
        .btn:hover{opacity:.9;}
        .btn-yellow{background-color:#FEEA62;color:#000;}
        .btn-red{background-color:#DC143C;color:#fff;}
        .back-link{color:#00BFFF;text-decoration:none;margin-top:50px;font-size:1.2em;}
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
        <p class="page-subtitle">Energia:</p>
        <div class="button-container">
            <button id="btn-ligar" class="btn btn-yellow">Ligar</button>
            <button id="btn-desligar" class="btn btn-red">Desligar</button>
        </div>
        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>

    <script>

        async function setEspMode(mode) {
            let url = '';
            if (mode === 'auto') {
                url = '/esp/auto_mode';
            } else if (mode === 'off') {
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

        const botaoLigar = document.getElementById('btn-ligar');
        const botaoDesligar = document.getElementById('btn-desligar');

        botaoLigar.addEventListener('click', async function() {
            try {

                setEspMode('auto')
                const response = await fetch('/api/energia/on', { method: 'POST' });
                
                alert('Alarme LIGADO com sucesso!');
                window.location.href = '/home';
            } catch (error) {
                
            }
        });
        botaoDesligar.addEventListener('click', async function() {
            try {

                setEspMode('off')
                const response = await fetch('/api/energia/off', { method: 'POST' });
                
                alert('Alarme DESLIGADO com sucesso!');
                window.location.href = '/home';
            } catch (error) {
                
            }
        
        });
    </script>
</body>
</html>