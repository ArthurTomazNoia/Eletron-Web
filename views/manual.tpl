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

        %if defined('message') and message:
            <p class="message-display {{'error-message' if 'Erro' in message else ''}}">{{message}}</p>
        %end

        <div class="status-section">
            <p id="loading-status">Carregando status...</p>
            <div id="actual-status-content" style="display: none;">
                <p>Modo Atual: <span class="mode-status" id="current-mode-display">MANUAL</span></p>
                <p>Laser: <span id="laser-status-display">?</span> | LDR: <span id="ldr-status-display">?</span></p>
                <p>LED Amarelo: <span id="led-yellow-display">?</span></p> 
                
                <div id="manual-alert-section">

                </div>
            </div>
        </div>

        <h2>Ações do Modo Manual:</h2>
        <div class="button-grid">
            <button id="updateStatusBtn" class="btn btn-action">Atualizar Status Agora</button>

            <a href="/esp/action/manual_alert/reset" class="manual-button">Resetar Intrusão</a>
        </div>

        <h2>Opções de Saída:</h2>
        <div class="button-grid">
            <a href="/" class="btn">Voltar ao Menu Principal</a>

        </div>
    </div>
    
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            const loadingStatus = document.getElementById('loading-status');
            const actualStatusContent = document.getElementById('actual-status-content');
            const currentModeDisplay = document.getElementById('current-mode-display');
            const laserStatusDisplay = document.getElementById('laser-status-display');
            const ldrStatusDisplay = document.getElementById('ldr-status-display');
            const ledYellowDisplay = document.getElementById('led-yellow-display');
            const manualAlertSection = document.getElementById('manual-alert-section');

            async function fetchAndRenderStatus() {
                loadingStatus.style.display = 'block'; 
                actualStatusContent.style.display = 'none'; 
                manualAlertSection.innerHTML = ''; 

                try {
                    const response = await fetch('/esp/api/status'); 
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const status = await response.json(); 

                    if (status.error) {
                        loadingStatus.textContent = 'Erro: ' + status.error;
                        loadingStatus.classList.add('error-message');
                    } else {
                        currentModeDisplay.textContent = status.mode.toUpperCase();
                        laserStatusDisplay.textContent = status.laser_active ? 'ATIVO' : 'INATIVO';
                        ldrStatusDisplay.textContent = status.ldr_status ? 'INTERROMPIDO' : 'NORMAL';
                        // Apenas o LED Amarelo é relevante para intrusão manual
                        ledYellowDisplay.textContent = status.led_amarelo ? 'ON' : 'OFF'; 

                        if (status.mode === 'manual' && status.manual_interruption_detected) {
                            manualAlertSection.innerHTML = `
                                <p class="alert-message">ALERTA: Intrusão detectada!</p>
                                <a href="/esp/action/manual_alert/reset" class="btn btn-action">Limpar Alerta Manual</a>
                            `;
                        }
                        
                        loadingStatus.style.display = 'none'; 
                        actualStatusContent.style.display = 'block'; 
                    }

                } catch (error) {
                    console.error('Erro ao buscar status:', error);
                    loadingStatus.textContent = 'Erro ao carregar status: ' + error.message;
                    loadingStatus.classList.add('error-message');
                }
            }

            const updateBtn = document.getElementById('updateStatusBtn');
            if (updateBtn) {
                updateBtn.addEventListener('click', fetchAndRenderStatus);
            }

            fetchAndRenderStatus();
        });

    </script>
</body>
</html>