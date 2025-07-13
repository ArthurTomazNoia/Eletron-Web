<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Histórico</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@400;700;900&display=swap');
        body{background-color:#000;color:#fff;font-family:'Heebo',sans-serif;padding-top:50px;text-align:center;}
        .container{max-width:900px;margin:auto;}
        .title{font-size:3em;font-weight:900;text-transform:uppercase;letter-spacing:2px;text-shadow:0 0 8px rgba(255,255,255,0.7);margin-bottom:40px;}
        .page-subtitle{font-size:1.8em;margin-bottom:20px;text-align:left;}
        table{width:100%;border-collapse:collapse;margin-bottom:40px;}
        th,td{border:1px solid #fff;padding:12px;text-align:left;}
        th{background-color:#222;font-weight:700;}
        tr:nth-child(even){background-color:#1a1a1a;}
        .back-link{color:#00BFFF;text-decoration:none;font-size:1.2em;}
    </style>
</head>
<body>
    <div class="container">
        <h1 class="title">Laser Alarm</h1>
        <h2 class="page-subtitle">Histórico (logs):</h2>
        <table>
            <thead>
                <tr>
                    <th>DATA/HORA</th>
                    <th>EVENTO</th>
                    <th>USUÁRIO</th>
                    <th>DETALHES</th>
                </tr>
            </thead>
            <tbody>
                <% for log in logs: %>
                    <tr>
                        <td>{{ log.get('timestamp', '').replace('T', ' ').split('.')[0] }}</td>
                        <td>{{ log.get('event', 'N/A') }}</td>
                        <td>{{ log.get('user', 'N/A') }}</td>
                        <td>{{ log.get('details', 'N/A') }}</td>
                    </tr>
                <% end %>
                % if not logs:
                    <tr>
                        <td colspan="4" style="text-align: center;">Nenhum registro encontrado.</td>
                    </tr>
                % end
            </tbody>
        </table>
        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>
</body>
</html>