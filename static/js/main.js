/**
 * Efeitos Visuais para o Sistema Bottle
 * 
 * Inclui:
 * - Animação de carregamento suave
 * - Efeito de hover em botões/tabelas
 * - Feedback visual para formulários
 * - Botão de scroll para topo
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Página carregada no navegador!')
    
    // 1. Efeito de fade-in ao carregar a página
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.5s ease-in-out';
        document.body.style.opacity = '1';
    }, 100);

    window.toggleEspLaser = async function() {
        try {
            const response = await fetch('/esp/toggle_laser', { method: 'POST' });
            const data = await response.json();
            alert(`Laser: ${data.status || data.message}`);
            console.log('Resposta do toggle_laser:', data);
            loadPowerStatusOnPageLoad();
        } catch (error) {
            console.error('Erro ao controlar o laser do ESP32:', error);
            alert('Erro ao comunicar com o dispositivo.');
        }
    }

    async function activateEspManualMode() {
        if (window.location.pathname === '/manual') {
            console.log('Detected /manual page. Activating ESP Manual Mode...');
            try {
                const response = await fetch('/esp/manual_mode', { method: 'GET' });
                const data = await response.text();
                console.log('ESP Manual Mode Activation Response:', data);
                alert('Modo Manual do ESP32 ativado!');
            } catch (error) {
                console.error('Error activating ESP Manual Mode:', error);
                alert('Erro ao ativar o Modo Manual do ESP32.');
            }
        }
    }

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

    loadPowerStatusOnPageLoad();

    activateEspManualMode();

    // Exemplo de como você conectaria a segunda função a um botão HTML (se houver um)
    const toggleLaserButton = document.getElementById('toggleLaserButton');
    if (toggleLaserButton) {
        toggleLaserButton.addEventListener('click', window.toggleEspLaser);
    }
    // <div class="object_centered">
    //  <h4>Controle do Laser</h4>
    //  <button id="toggleLaserButton" onclick="window.toggleEspLaser()">Ligar/Desligar Laser</button>
    // </div>
});
