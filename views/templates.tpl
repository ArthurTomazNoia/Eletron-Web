<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Energia</title>
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
            /* Efeito de brilho e borda roxa */
            border: 2px solid #9400D3;
            text-shadow: 0 0 8px rgba(148, 0, 211, 0.7);
            padding: 10px 25px;
            margin-bottom: 40px;
        }

        .page-subtitle {
            font-size: 1.8em;
            margin-bottom: 30px;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 20px; /* Espaçamento entre os botões */
        }
        
        .btn {
            border: none;
            padding: 20px 0;
            width: 350px;
            font-size: 2.2em;
            font-weight: 700;
            font-family: 'Heebo', sans-serif;
            cursor: pointer;
            transition: opacity 0.3s ease;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-yellow {
            background-color: #FEEA62;
            color: #000;
        }
        
        .btn-red {
            background-color: #DC143C; /* Vermelho Crimson */
            color: #fff;
        }

        .back-link {
            color: #00BFFF; /* Azul claro */
            text-decoration: none;
            margin-top: 50px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="title">Laser Alarm</h1>
        <p class="page-subtitle">Energia:</p>
        <div class="button-container">
            <button class="btn btn-yellow">Ligar</button>
            <button class="btn btn-red">Desligar</button>
        </div>
        <a href="/home" class="back-link">&larr; Voltar</a>
        
    </div>
</body>
</html>