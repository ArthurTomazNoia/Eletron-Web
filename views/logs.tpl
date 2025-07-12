<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Histórico</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@400;700;900&display=swap');

        body {
            background-color: #000;
            color: #fff;
            font-family: 'Heebo', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 900px; /* Largura máxima do conteúdo */
        }

        .title {
            font-size: 3em;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            /* Efeito de brilho sutil no título */
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
        }

        .page-subtitle {
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 20px;
            width: 100%; /* Para alinhar à esquerda do container */
            text-align: left;
        }

        .log-table {
            width: 100%;
            border-collapse: collapse; /* Une as bordas das células */
            font-size: 1em;
        }

        .log-table th, .log-table td {
            border: 1px solid #ccc; /* Linhas brancas/cinzas da grade */
            padding: 12px;
            text-align: left;
        }

        .log-table th {
            font-weight: 700;
            text-transform: uppercase;
        }

        /* Linhas vazias para preencher espaço, como na imagem */
        .log-table .empty-row td {
            /* O &nbsp; (non-breaking space) garante que a célula mantenha sua altura */
            padding: 16px; 
        }

        .back-link {
            color: #00BFFF;
            text-decoration: none;
            margin-top: 40px;
            font-size: 1.2em;
            font-weight: 700;
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
        <h2 class="page-subtitle">Histórico(logs):</h2>

        <table class="log-table">
            <thead>
                <tr>
                    <th>Data/Hora</th>
                    <th>Evento</th>
                    <th>Usuário</th>
                    <th>Detalhes</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>12/07/2025 12:05:10</td>
                    <td>Alarme Desativado</td>
                    <td>admin</td>
                    <td>Desativação via modo manual.</td>
                </tr>
                <tr>
                    <td>12/07/2025 12:02:45</td>
                    <td>INTRUSÃO DETECTADA</td>
                    <td>Sistema</td>
                    <td>Sensor B-07 ativado.</td>
                </tr>
                <tr>
                    <td>12/07/2025 10:00:00</td>
                    <td>Sistema Ligado</td>
                    <td>admin</td>
                    <td>Energia ativada.</td>
                </tr>

                <tr class="empty-row"><td>&nbsp;</td><td></td><td></td><td></td></tr>
                <tr class="empty-row"><td>&nbsp;</td><td></td><td></td><td></td></tr>
                <tr class="empty-row"><td>&nbsp;</td><td></td><td></td><td></td></tr>
                <tr class="empty-row"><td>&nbsp;</td><td></td><td></td><td></td></tr>
                <tr class="empty-row"><td>&nbsp;</td><td></td><td></td><td></td></tr>
            </tbody>
        </table>

        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>
</body>
</html>