mosquitto_sub -h localhost -p 8883 -t "test/topic" \
  -u edgeuser -P Optilogic25 \
  --cafile ~/iot-monitoring/mosquitto/config/certs/ca.crt
