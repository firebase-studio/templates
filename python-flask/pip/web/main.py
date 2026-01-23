import os

from flask import Flask, send_file, request, jsonify
import firebase_admin
from firebase_admin import credentials, auth

# Initialize Firebase Admin SDK
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)

app = Flask(__name__)

@app.route("/")
def index():
    return send_file('src/index.html')

@app.route('/login', methods=['POST'])
def login():
    id_token = request.json['idToken']
    try:
        decoded_token = auth.verify_id_token(id_token)
        email = decoded_token['email']
        return jsonify({'email': email})
    except auth.InvalidIdTokenError:
        return jsonify({'error': 'Invalid ID token'}), 401

def main():
    app.run(port=int(os.environ.get('PORT', 80)))

if __name__ == "__main__":
    main()
