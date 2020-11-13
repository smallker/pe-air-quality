#include <Arduino.h>
#include <ESP8266WiFi.h>
// #include <PubSubClient.h>
#include <SPI.h>
#include <LoRa.h>

const char *ssid = "KEDUBES";      // Enter your WiFi name
const char *password = "rahasiaa"; // Enter WiFi password
const char *mqttServer = "broker.hivemq.com";
const int mqttPort = 1883;
const char *mqttUser = "";
const char *mqttPassword = "";
WiFiClient espClient;
// PubSubClient client(espClient);

int counter = 0;
void onReceive(int packetSize)
{
  // received a packet
  char sensor[packetSize];
  Serial.print("Received packet '");
  // read packet
  for (int i = 0; i < packetSize; i++)
  {
    sensor[i] = (char)LoRa.read();
  }
  Serial.print(sensor);
  Serial.println("'");
  // client.publish("esppub_smallker", String(sensor).c_str());
}
void setup()
{
  Serial.begin(115200);
  if (!LoRa.begin(915E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("Connected to the WiFi network");
  // client.setServer(mqttServer, mqttPort);
  // client.setCallback(callback);
  // while (!client.connected())
  // {
  //   Serial.println("Connecting to MQTT...");
  //   if (client.connect("ESP8266", mqttUser, mqttPassword))
  //   {
  //     Serial.println("connected");
  //   }
  //   else
  //   {
  //     Serial.print("failed with state ");
  //     Serial.print(client.state());
  //     delay(1000);
  //   }
  // }

  LoRa.onReceive(onReceive);
  LoRa.receive();

  // client.subscribe("espsub");
}

void loop()
{
  // client.loop();
  // while (WiFi.status() != WL_CONNECTED)
  // {
  //   delay(500);
  //   Serial.println("Connecting to WiFi..");
  // }
  // while (!client.connected())
  // {
  //   Serial.println("Connecting to MQTT...");
  //   if (client.connect("ESP8266Client", mqttUser, mqttPassword))
  //   {
  //     Serial.println("connected");
  //   }
  //   else
  //   {
  //     Serial.print("failed with state ");
  //     Serial.print(client.state());
  //     delay(1000);
  //   }
  // }
  //   client.publish("esppub_smallker", "start");
  //   delay(5000);
}