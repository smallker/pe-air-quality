#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <SPI.h>
#include <LoRa.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

#define ssid "bolt"
#define pass "11111111"

String host = "https://pe-air-quality.firebaseio.com/sensor/0/logs.json";
String data;
HTTPClient http;
WiFiClientSecure client;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 0);
void onReceive(int packetSize)
{
  
  DynamicJsonDocument output(1024);
  String temporary = LoRa.readString();
  deserializeJson(output, temporary);
  int gas = output["gas"];
  int temp = output["temp"];
  int hum = output["hum"];
  String timestamp = (String)timeClient.getEpochTime();
  Serial.println(timestamp);
  data = "{\"co\":"+(String)gas+",\"humidity\":"+(String)hum+",\"temperature\":"+(String)temp+",\"timestamp\":"+(String)timestamp+"}";
  Serial.println(data);
}
void setup()
{
  Serial.begin(115200);

  if (!LoRa.begin(915E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("IP : " + WiFi.localIP().toString());
  LoRa.onReceive(onReceive);
  LoRa.receive();
}

void loop()
{
  timeClient.update();
  if (data != "" || data != NULL)
  {
    client.setInsecure();
    client.connect(host, 443);
    http.begin(client, host);
    int response_code = http.POST(data);
    if (response_code == HTTP_CODE_OK)
    {
      Serial.println(http.getString());
    }
    http.end();
  }
}