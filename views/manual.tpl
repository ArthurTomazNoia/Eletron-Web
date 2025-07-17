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

        .action-button {
            background-color: #FEEA62;
            color: #000;
            border: 2px solid #9400D3;
            padding: 25px 50px;
            font-size: 1.5em;
            font-weight: 700;
            font-family: 'Heebo', sans-serif;
            cursor: pointer;
            transition: background-color 0.3s ease, border-color 0.3s ease, transform 0.1s ease;
            text-decoration: none;
            display: inline-block;
            min-width: 150px;
            box-sizing: border-box;
        }

        .action-button:hover {
            background-color: #e8d65a;
            border-color: #800080;
            transform: translateY(-2px);
        }

        .action-button:active {
            transform: translateY(0);
        }

        .button-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .button-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* Ajustado para 2 colunas */
            gap: 15px;
            margin-bottom: 20px;
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

        /* Estilos para Status Section */
        .status-section {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
        }
        .status-section p {
            margin: 8px 0;
            font-size: 1.1em;
        }
        .mode-status {
            font-weight: 900;
            color: #00BFFF;
        }
        .alert-message {
            color: #FF4500;
            font-weight: 900;
            text-shadow: 0 0 5px rgba(255, 69, 0, 0.7);
            animation: pulse 1.5s infinite alternate;
        }
        @keyframes pulse {
            from { transform: scale(1); opacity: 1; }
            to { transform: scale(1.05); opacity: 0.8; }
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
        }
        .error-message {
            background-color: rgba(220, 53, 69, 0.2);
            color: #dc3545;
            border: 1px solid #dc3545;
        }
        h2 {
            font-size: 2em;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 40px;
            margin-bottom: 20px;
            color: #00BFFF;
            text-shadow: 0 0 5px rgba(0, 191, 255, 0.5);
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
        <div class="button-container">
            <button id="updateStatusBtn" class="action-button">Atualizar Status Agora</button>

            <button id="resetIntrusionBtn" class="action-button">Resetar Intrusão</button>
        </div>

        <h2>Saída:</h2>
        <div class="button-grid">
            <button id="backToMainBtn" class="action-button">Voltar ao Menu Principal</button>

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
            const messageDisplay = document.querySelector('.message-display');

            const updateStatusBtn = document.getElementById('updateStatusBtn');
            const resetIntrusionBtn = document.getElementById('resetIntrusionBtn');
            const backToMainBtn = document.getElementById('backToMainBtn');

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

            async function fetchAndRenderStatus() {
                loadingStatus.style.display = 'block'; 
                actualStatusContent.style.display = 'none'; 
                manualAlertSection.innerHTML = ''; 

                try {
                    const response = await fetch(window.location.origin + '/esp/api/status'); 
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
                        ledYellowDisplay.textContent = status.led_amarelo ? 'ON' : 'OFF'; 

                        if (status.mode === 'manual' && status.manual_interruption_detected) {
                            manualAlertSection.innerHTML = `
                                <p class="alert-message">ALERTA: Intrusão detectada!</p>
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

            async function sendAction(url, successMessage, errorMessage, navigateTo = null) {
                try {
                    // Tornando a URL absoluta para evitar erros de parsing
                    const response = await fetch(window.location.origin + url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const result = await response.json();

                    if (result.success) {
                        showDynamicMessage(successMessage || result.message);
                        if (navigateTo) {
                            window.location.href = navigateTo; // Navega para a nova página
                        } else {
                            fetchAndRenderStatus(); // Atualiza o status após a ação
                        }
                    } else {
                        showDynamicMessage(errorMessage || result.error, true);
                    }
                } catch (error) {
                    console.error('Erro ao enviar ação:', error);
                    showDynamicMessage(errorMessage || 'Erro ao enviar comando: ' + error.message, true);
                }
            }

            if (updateStatusBtn) {
                updateStatusBtn.addEventListener('click', fetchAndRenderStatus);
            }

            if (resetIntrusionBtn) {
                resetIntrusionBtn.addEventListener('click', () => {
                    sendAction('/esp/action/manual_alert/reset', 'Alerta de intrusão resetado!', 'Falha ao resetar intrusão.');
                });
            }

            if (backToMainBtn) {
                backToMainBtn.addEventListener('click', () => {
                    // ATIVA O MODO OFF DA ESP ANTES DE VOLTAR AO MENU PRINCIPAL
                    sendAction('/esp/action/mode/set?set=off', 
                               'Modo Desligado ativado. Voltando ao Menu Principal...', 
                               'Falha ao desativar modo. Verifique a ESP32.',
                               '/');
                });
            }

            fetchAndRenderStatus();
        });

    </script>
</body>
</html>