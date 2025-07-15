<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm</title>
    <style>
        
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@700;900&display=swap');
        body { background-color: #000; color: #fff; font-family: 'Heebo', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; text-align: center; }
        .container { display: flex; flex-direction: column; align-items: center; }
        .title { font-size: 3em; font-weight: 900; text-transform: uppercase; letter-spacing: 2px; text-shadow: 0 0 8px rgba(255, 255, 255, 0.7); margin-bottom: 40px; }
        .status { font-size: 1.3em; margin-bottom: 25px; }
        .status .active { color: #32CD32; font-weight: 700; }
        .status .inactive { color: #DC143C; font-weight: 700; }
        .button-container { display: flex; flex-direction: column; gap: 15px; }
        .btn { background-color: #FEEA62; color: #000; border: none; padding: 20px 0; width: 350px; font-size: 2em; font-weight: 700; font-family: 'Heebo', sans-serif; cursor: pointer; transition: background-color 0.3s ease; text-decoration: none; display: inline-block; }
        .btn:hover { background-color: #e8d65a; }
        .info-link { color: #00BFFF; text-decoration: none; margin-top: 40px; font-size: 1em; font-weight: 700; }
        .info-link:hover { text-decoration: underline; }
        .imagem-fixa { position: fixed; top: 20px; right: 20px; width: 150px; height: auto; z-index: 1000; }
        .btn-disabled 
        {
            background-color: #cccccc;
            color: #666666;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>
</head>
<body>

    <img style="width:20%" src="/static/img/Eletro.png" alt="Logo-eletronjun" class="imagem-fixa">

    <div class="container">
        <h1 class="title">Laser Alarm</h1>

        <p class="status">
            Situação atual:
            <span id="status-display">Verificando...</span>
        </p>

        <div class="button-container">
            <a href="/energia" class="btn">Energia</a>
            <a href="/logs" class="btn">Histórico</a>
           
            <a href="/manual" class="btn">Manual</a>
           
                
              


            <a href="/configuracoes" class="btn">Config</a>
        </div>

        <a href="/tut" class="info-link">Como funciona?</a>
    </div>

    <script>
        
        function atualizarStatusNaTela(status) {
            const statusDisplay = document.getElementById('status-display');
            if (status === 'ligado') {
                statusDisplay.textContent = 'Ativo';
                statusDisplay.className = 'active'; 
            } else {
                statusDisplay.textContent = 'Inativo';
                statusDisplay.className = 'inactive'; 
            }
        }

        
        async function verificarStatusDoServidor() {
            try {
                
                const response = await fetch('/api/energia/status');
                if (!response.ok) {
                    throw new Error('Erro de rede.');
                }
                const data = await response.json();
                atualizarStatusNaTela(data.status);

            } catch (error) {
                console.error("Falha ao buscar status:", error);
                const statusDisplay = document.getElementById('status-display');
                statusDisplay.textContent = 'Erro de conexão';
                statusDisplay.className = 'inactive';
            }
        }

        
        document.addEventListener('DOMContentLoaded', verificarStatusDoServidor);
    </script>
</body>
</html>