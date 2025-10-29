from flask import Flask, request, jsonify
from flask_cors import CORS
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os

app = Flask(__name__)
CORS(app)

# === Konfiguration ===
SMTP_SERVER = "smtp.strato.com"
SMTP_PORT = 587
EMAIL_USER = "kontakt@katepetersen.se"   # din Strato-adress
EMAIL_PASS = "DIN_LÖSENKOD_HÄR"          # byt ut till ditt riktiga lösenord eller app-lösenord

@app.route('/send_mail', methods=['POST'])
def send_mail():
    data = request.json
    mentor_email = data.get('mentor_email')
    subject = data.get('subject', 'Mentor Feedback')
    message = data.get('message', '')
    attachment_info = data.get('attachment', None)

    if not mentor_email:
        return jsonify({"status": "error", "message": "Ingen mottagare angiven"}), 400

    msg = MIMEMultipart()
    msg['From'] = EMAIL_USER
    msg['To'] = mentor_email
    msg['Subject'] = subject
    msg.attach(MIMEText(message, 'html'))

    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(EMAIL_USER, EMAIL_PASS)
            server.send_message(msg)
        return jsonify({"status": "success", "message": "E-post skickad till mentorn"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
