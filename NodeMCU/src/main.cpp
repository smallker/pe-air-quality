/*
  --- LED ---
  -LED   -> D2 
  -- LoRa ---
  -RST   -> D0
  -DIO0  -> D1
  -CLK   -> D5
  -MISO  -> D6
  -MOSI  -> D7
  -NSS   -> D8 
*/
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <SPI.h>
#include <Wire.h>
#include <LoRa.h>
#include <ArduinoJson.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

#define LED D2
#define ssid "bolt"
#define pass "11111111"

bool dataReceived;
int gas, temp, hum;
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
  DeserializationError error = deserializeJson(output, temporary);
  if (!error)
  {
    gas = output["gas"];
    temp = output["temp"];
    hum = output["hum"];
    String timestamp = (String)timeClient.getEpochTime();
    Serial.println(timestamp);
    data = "{\"co\":" + (String)gas + ",\"humidity\":" + (String)hum + ",\"temperature\":" + (String)temp + ",\"timestamp\":" + (String)timestamp + "}";
    // Serial.println(data);
    dataReceived = true;
  }
  Serial.println(temporary);
}
void setup()
{
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  if (!LoRa.begin(415E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }

  /*
      Inisialisasi WiFi
  */
  WiFi.begin(ssid, pass);

  /*
      Inisialisasi callback LoRa
  */
  LoRa.onReceive(onReceive);
  LoRa.receive();
}

void loop()
{
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.println("Connecting to WiFi..");
    digitalWrite(LED, HIGH);
    delay(100);
    digitalWrite(LED, LOW);
    delay(3000);
  }
  digitalWrite(LED, HIGH);
  timeClient.update();
  if (dataReceived)
  {
    /*
        Mengirim data ke fireabase
    */
    client.setInsecure();
    client.connect(host, 443);
    http.begin(client, host);
    int response_code = http.POST(data);
    if (response_code == HTTP_CODE_OK)
    {
      Serial.println(http.getString());
    }
    http.end();
    dataReceived = false;
  }
  delay(1000);
}