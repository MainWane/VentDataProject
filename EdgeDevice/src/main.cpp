#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = ""; // insert SSID here
const char* password = ""; // insert Password here

const char* mqtt_server = "192.168.1.100"; // Debian server IP
const char* mqtt_user = "edgeuser";
const char* mqtt_pass = "Optilogic25";

WiFiClient espClient;
PubSubClient client(espClient);

void reconnect() {
  while (!client.connected()) {
    if (client.connect("olimex-esp32", mqtt_user, mqtt_pass)) {
      Serial.println("Connected to MQTT");
    } else {
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("WiFi connected");

  client.setServer(mqtt_server, 1883);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  int sensorValue = analogRead(34);  // Example analog input
  char payload[64];
  sprintf(payload, "olimex:%d", sensorValue);

  client.publish("sensors/olimex", payload);
  delay(5000);
}

