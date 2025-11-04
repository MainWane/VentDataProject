docker run -d --name mosquitto \
  -p 1883:1883 \
  -v ~/iot-monitoring/mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf \
  -v ~/iot-monitoring/mosquitto/config:/mosquitto/config \
  -v ~/iot-monitoring/mosquitto/data:/mosquitto/data \
  -v ~/iot-monitoring/mosquitto/log:/mosquitto/log \
  eclipse-mosquitto
