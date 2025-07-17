import smtplib
import ssl
from email.message import EmailMessage
import os
from services.settings_service import SettingsService

# --- INFORMAÇÕES SENSÍVEIS (DO REMETENTE) ---
EMAIL_SENDER = os.environ.get('GMAIL_USER') or 'alarmenotificacoes@gmail.com'
EMAIL_PASSWORD = os.environ.get('GMAIL_APP_PASSWORD') or 'exhr uenuoyjijjmc'

class EmailService:
    def __init__(self):
        # O EmailService agora precisa do SettingsService para saber para quem enviar
        self.settings_service = SettingsService()

    def send_notification_email(self, subject: str, body: str):
        if not all([EMAIL_SENDER, EMAIL_PASSWORD]):
            print("--- SERVIÇO DE EMAIL: Email do remetente não configurado. ---")
            return

        email_receiver = self.settings_service.get_notification_email()

        if not email_receiver:
            print("--- SERVIÇO DE EMAIL: Email do destinatário não configurado. Email não enviado. ---")
            return

        em = EmailMessage()
        em['From'] = EMAIL_SENDER
        em['To'] = email_receiver
        em['Subject'] = subject
        em.set_content(body)

        context = ssl.create_default_context()
        try:
            print(f"--- EMAIL: Conectando ao servidor para enviar para {email_receiver}... ---")
            with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
                smtp.login(EMAIL_SENDER, EMAIL_PASSWORD)
                smtp.send_message(em)
            print("--- EMAIL: Mensagem enviada com sucesso! ---")
        except Exception as e:
            print(f"!!!!!!!!!! ERRO AO ENVIAR EMAIL: {e} !!!!!!!!!!!")