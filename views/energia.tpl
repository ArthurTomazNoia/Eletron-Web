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
        .message-display { 
            background-color: rgba(40, 167, 69, 0.2);
            color: #28a745;
            border: 1px solid #28a745;
            padding: 10px;
            border-radius: 5px;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
            display: none; /* Escondido por padrão, mostrado pelo JS */
        }
        .error-message {
            background-color: rgba(220, 53, 69, 0.2);
            color: #dc3545;
            border: 1px solid #dc3545;
        }
    </style>
</head>
<body>
     <img style="width:20%" src="http://localhost:8080/static/img/Eletro.png" alt="Logo-eletronjun" class="imagem-fixa">
    <div class="container">
        <h1 class="title">Laser Alarm</h1>
        <p class="page-subtitle">Energia:</p>

        <p class="message-display" id="energia-message-display"></p>

        <div class="button-container">
            <button id="btn-ligar" class="btn btn-yellow">Ligar (AUTO)</button>
            <button id="btn-desligar" class="btn btn-red">Desligar (OFF)</button>
        </div>
        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const botaoLigar = document.getElementById('btn-ligar');
            const botaoDesligar = document.getElementById('btn-desligar');

            function showDynamicMessage(msg, isError = false) {
                if (!messageDisplay) return;
                messageDisplay.textContent = msg;
                messageDisplay.classList.remove('error-message');
                if (isError) {
                    messageDisplay.classList.add('error-message');
                }
                messageDisplay.style.display = 'block';
                setTimeout(() => { messageDisplay.style.display = 'none'; }, 5000);
            }

            async function sendAction(url, successMessage, errorMessage, navigateTo = null) {
                try {
                    const response = await fetch(window.location.origin + url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const result = await response.json();

                    if (result.success) {
                        showDynamicMessage(successMessage || result.message);
                        if (navigateTo) {
                            window.location.href = navigateTo;
                        } else {
                            fetchCurrentMode();
                        }
                    } else {
                        showDynamicMessage(errorMessage || result.error, true);
                    }
                } catch (error) {
                    console.error('Erro ao enviar ação:', error);
                    showDynamicMessage(errorMessage || 'Erro ao enviar comando: ' + error.message, true);
                }
            }

            async function fetchCurrentMode() {
                try {
                    const response = await fetch('/esp/api/status');
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const data = await response.json();
                    document.getElementById('current-mode-display').textContent = data.mode.toUpperCase();
                } catch (error) {
                    console.error('Erro ao buscar modo atual:', error);
                    document.getElementById('current-mode-display').textContent = 'Erro';
                }
            }

            if (botaoLigar){
                botaoLigar.addEventListener('click', async function() {
                    try {
                        const response = await fetch('/api/energia/on', { method: 'POST' });

                        sendAction('/esp/action/mode/set?set=auto', 
                                'Alarme LIGADO com sucesso! (Modo Automático)', 
                                'Falha ao ligar alarme. Verifique a ESP32.', 
                                '/');
                        
                        alert('Alarme LIGADO com sucesso! (Modo Automático)');
                    } catch (error) {
                        
                    }
                });
            }
            if (botaoDesligar){
                botaoDesligar.addEventListener('click', async function() {
                    try {
                        const response = await fetch('/api/energia/off', { method: 'POST' });

                        sendAction('/esp/action/mode/set?set=off', 
                                'Alarme DESLIGADO com sucesso! (Modo OFF)', 
                                'Falha ao desligar alarme. Verifique a ESP32.', 
                                '/');

                        alert('Alarme DESLIGADO com sucesso!');
                    } catch (error) {
                        
                    }
                });
            }

            fetchCurrentMode()
            setInterval(fetchCurrentMode, 10000)
        });
        
    </script>
</body>
</html>