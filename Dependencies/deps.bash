sudo apt update && sudo apt upgrade -y
sudo apt install git curl wget unzip python3 python3-pip docker.io docker-compose mosquitto mosquitto-clients -y
sudo systemctl enable docker --now
sudo systemctl enable mosquitto --now
