<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Laser Alarm - Configurações</title>
    <style>
        /* Você pode usar o mesmo estilo das outras páginas */
        @import url('https://fonts.googleapis.com/css2?family=Heebo:wght@400;700;900&display=swap');
        body{background-color:#000;color:#fff;font-family:'Heebo',sans-serif;padding-top:50px;text-align:center;}
        .container{max-width:600px;margin:auto;}
        .title{font-size:3em;font-weight:900;text-transform:uppercase;letter-spacing:2px;text-shadow:0 0 8px rgba(255,255,255,0.7);margin-bottom:40px;}
        .page-subtitle{font-size:1.8em;margin-bottom:20px;text-align:left;}
        form{display:flex;flex-direction:column;align-items:flex-start;gap:15px;}
        label{font-size:1.2em;}
        input[type="email"]{width:100%;padding:10px;font-size:1.1em;background-color:#333;border:1px solid #555;color:#fff;border-radius:5px;}
        .btn{background-color:#32CD32;color:#fff;border:none;padding:15px 30px;font-size:1.2em;font-weight:700;cursor:pointer;align-self:flex-start;}
        .back-link{color:#00BFFF;text-decoration:none;font-size:1.2em;display:inline-block;margin-top:40px;}
    </style>
</head>
<body>
    <div class="container">
        <h1 class="title">Laser Alarm</h1>
        <h2 class="page-subtitle">Configurações de Notificação:</h2>
        
        <form action="/configuracoes/salvar" method="POST">
            <label for="notification_email">Enviar alertas para o e-mail:</label>
            <input type="email" id="notification_email" name="notification_email" 
                   value="{{ current_email }}" 
                   placeholder="Digite o e-mail para receber alertas" required>
            
            <button type="submit" class="btn">Salvar</button>
        </form>

        <a href="/home" class="back-link">&larr; Voltar</a>
    </div>
</body>
</html>