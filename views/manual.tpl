<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm - Modo Manual</title>
    <style>
        /* Importa uma fonte do Google Fonts parecida com a da imagem */
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
            /* Efeito de brilho sutil no título */
            text-shadow: 0 0 8px rgba(255, 255, 255, 0.7);
            margin-bottom: 30px;
        }

        .mode-text {
            font-size: 1.8em;
            margin-bottom: 50px;
        }

        .manual-button {
            background-color: #FEEA62; /* Amarelo */
            color: #000;
            border: 2px solid #9400D3; /* Borda roxa */
            padding: 25px 50px;
            font-size: 2.5em;
            font-weight: 700;
            font-family: 'Heebo', sans-serif;
            cursor: pointer;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .manual-button:hover {
            background-color: #e8d65a;
            border-color: #800080; /* Roxo mais escuro no hover */
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
        <button class="manual-button">Desativar</button>
    </div>

</body>
</html>