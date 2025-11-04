docker run -d --name questdb \
  -p 9000:9000 -p 8812:8812 -p 9009:9009 \
  -v ~/iot-monitoring/db:/root/.questdb \
  questdb/questdb
