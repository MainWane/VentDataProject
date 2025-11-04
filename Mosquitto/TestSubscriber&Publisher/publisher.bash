mosquitto_pub -h localhost -p 8883 -t "test/topic" -m "Hello TLS" \
  -u edgeuser -P Optilogic25 \
  --cafile ~/iot-monitoring/mosquitto/config/certs/ca.crt
