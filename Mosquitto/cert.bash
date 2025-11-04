# 1. Generate CA key & certificate
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 -out ca.crt -subj "/CN=MyMQTTCA"

# 2. Generate server key & CSR
openssl genrsa -out mosquitto.key 2048
openssl req -new -key mosquitto.key -out mosquitto.csr -subj "/CN=localhost"

# 3. Sign server certificate with CA
openssl x509 -req -in mosquitto.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out mosquitto.crt -days 365 -sha256

# To fix ownership, Run: sudo chown -R user:user ~/iot-monitoring/mosquitto/config/certs

# To verify ownership run:
# ls -ld ~/iot-monitoring/mosquitto/config/certs
# ls -l ~/iot-monitoring/mosquitto/config/certs/
