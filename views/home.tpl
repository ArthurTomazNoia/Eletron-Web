<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laser Alarm</title>
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
            margin-bottom: 40px;
        }

        .status {
            font-size: 1.3em;
            margin-bottom: 25px;
        }

        .status .active {
            color: #32CD32; /* Verde */
            font-weight: 700;
        }

        .status .inactive {
            color: #DC143C; /* Vermelho */
            font-weight: 700;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 15px; /* Espaçamento entre os botões */
        }

        .btn {
            background-color: #FEEA62; /* Amarelo */
            color: #000;
            border: none;
            padding: 20px 0;
            width: 350px; /* Largura dos botões */
            font-size: 2em;
            font-weight: 700;
            font-family: 'Heebo', sans-serif;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #e8d65a; /* Um tom de amarelo mais escuro para o efeito hover */
        }

        .info-link {
            color: #00BFFF; /* Azul claro */
            text-decoration: none;
            margin-top: 40px;
            font-size: 1em;
            font-weight: 700;
        }

        .info-link:hover {
            text-decoration: underline;
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

        <p class="status">
            Situação atual:
            <span class="active">Ativo</span>/
            <span class="inactive">inativo</span>/
            ...
        </p>

        <div class="button-container">
            <a href="manual" button class="btn">Energia</button>

            <button class="btn">Histórico</button>

            <button class="btn">Manual</button>

        </div>

        <a href="#" class="info-link">Como funciona?</a>
    </div>

</body>
</html>