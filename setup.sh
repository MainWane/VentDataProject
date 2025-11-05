#!/bin/bash
set -e

echo "──────────────────────────────────────────────"
echo "  VentDataProject – Automated Setup Script "
echo "──────────────────────────────────────────────"
sleep 1

# --- 1. Install dependencies ---
echo "[+] Installing system dependencies..."
sudo apt update -y
sudo apt install -y git curl wget python3 python3-pip docker.io docker-compose openssl

# Enable Docker
sudo systemctl enable docker --now

# --- 2. Clone repo if not already cloned ---
if [ ! -d "$HOME/VentDataProject" ]; then
    echo "[+] Cloning VentDataProject repository..."
    git clone https://github.com/MainWane/VentDataProject.git "$HOME/VentDataProject"
fi
cd "$HOME/VentDataProject"

# --- 3. Create project directories ---
echo "[+] Creating project structure..."
mkdir -p iot-monitoring-system/{mosquitto/{config,certs,data,log},questdb/data,backend,frontend,grafana/provisioning,logs}
cd iot-monitoring-system

# --- 4. Generate TLS certificates for Mosquitto ---
echo "[+] Generating TLS certificates..."
cd mosquitto/certs
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt \
    -subj "/C=DK/ST=Denmark/L=Copenhagen/O=VentData/CN=VentData-CA"
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr \
    -subj "/C=DK/ST=Denmark/L=Copenhagen/O=VentData/CN=localhost"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out server.crt -days 3650
chmod 644 *.crt && chmod 600 *.key
cd ../../

# --- 5. Copy configuration files (if they exist) ---
echo "[+] Copying configuration files..."
cp ../mosquitto.conf ./mosquitto/config/mosquitto.conf 2>/dev/null || true
cp ../docker-compose.yml ./docker-compose.yml 2>/dev/null || true
cp ../main.py ./backend/main.py 2>/dev/null || true

# --- 6. Setup Python backend (optional) ---
echo "[+] Setting up Python virtual environment..."
cd backend
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install fastapi paho-mqtt uvicorn questdb psycopg2-binary
deactivate
cd ..

# --- 7. Launch Docker services ---
echo "[+] Building and starting Docker services..."
sudo docker compose up -d --build

# --- 8. Final info ---
echo "──────────────────────────────────────────────"
echo " ✅ Setup complete!"
echo "──────────────────────────────────────────────"
echo " • Grafana → http://localhost:3000"
echo " • FastAPI → http://localhost:8000"
echo " • QuestDB → http://localhost:9000"
echo "──────────────────────────────────────────────"
