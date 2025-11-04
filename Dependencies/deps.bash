#!/bin/bash
set -e  # Stop scriptet hvis noget fejler

echo "[1/6] Opdaterer system..."
sudo apt update && sudo apt upgrade -y

echo "[2/6] Installerer basale værktøjer..."
sudo apt install -y git curl wget unzip python3 python3-pip docker.io docker-compose mosquitto mosquitto-clients

echo "[3/6] Aktiverer tjenester..."
sudo systemctl enable docker --now
sudo systemctl enable mosquitto --now

echo "[4/6] Installerer Python-pakker til FastAPI..."
python3 -m pip install --upgrade pip
pip install fastapi uvicorn[standard] paho-mqtt questdb

echo "[5/6] Installerer Grafana..."
# Grafana fra officiel repo (seneste stable)
sudo apt install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana

echo "[6/6] Aktiverer Grafana ved opstart..."
sudo systemctl enable grafana-server --now

echo
echo "-------------------------------------------------------------"
echo "Installation færdig!"
echo "Docker, Mosquitto, FastAPI og Grafana er sat op."
echo "FastAPI kan startes med: uvicorn app:app --reload --host 0.0.0.0 --port 8000"
echo "Grafana kører på: http://localhost:3000  (login: admin / admin)"
echo "-------------------------------------------------------------"
