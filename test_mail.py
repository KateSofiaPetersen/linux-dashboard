import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Konfig
SMTP_SERVER = "smtp.strato.com"
SMTP_PORT = 587
EMAIL_USER = "kontakt@katepetersen.se"
EMAIL_PASS = "DITT_LÖSENORD_HÄR"  # <-- Byt ut detta

# Mottagare och innehåll
receiver_email = "dinprivata@gmail.com"  # <-- testa gärna till dig själv
subject = "Testmail från Python via Strato"
body = "Hej! Detta är ett testmail skickat från mitt Python-script via Strato."

# Bygg meddelandet
msg = MIMEMultipart()
msg['From'] = EMAIL_USER
msg['To'] = receiver_email
msg['Subject'] = subject
msg.attach(MIMEText(body, 'plain'))

# Skicka
try:
    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
        server.starttls()
        server.login(EMAIL_USER, EMAIL_PASS)
        server.send_message(msg)
        print("✅ E-post skickad!")
except Exception as e:
    print("❌ Något gick fel:", e)
