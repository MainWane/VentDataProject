from fastapi import FastAPI
import paho.mqtt.client as mqtt
import psycopg2
from datetime import datetime

app = FastAPI()

# QuestDB connection
conn = psycopg2.connect(
    dbname="qdb",
    user="admin",
    password="quest",
    host="localhost",
    port=8812
)
cur = conn.cursor()

def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    device, value = payload.split(":")  # format "device:value"
    ts = datetime.utcnow().isoformat()
    cur.execute("INSERT INTO sensors (ts, device, value) VALUES (%s, %s, %s)",
                (ts, device, float(value)))
    conn.commit()

client = mqtt.Client()
client.username_pw_set("edgeuser", "Optilogic25")
client.on_message = on_message
client.connect("localhost", 1883)
client.subscribe("sensors/#")
client.loop_start()

@app.get("/")
def root():
    return {"status": "Backend running"}

