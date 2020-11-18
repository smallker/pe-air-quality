/*
  --- LCD ---
  SCL   -> D1
  SDA   -> D2
  
  -- LoRa ---
  -RST   -> D0
  -DIO0  -> D2
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
#include <LiquidCrystal_I2C.h>
#define ssid "bolt"
#define pass "11111111"

// LiquidCrystal_I2C lcd(0x27, 16, 2);

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
  // lcd.begin();
  // lcd.backlight();
  // lcd.setCursor(0, 0);
  // lcd.print("Kelompok 6");
  if (!LoRa.begin(915E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }

  /*
      Inisialisasi WiFi
  */
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("IP : " + WiFi.localIP().toString());
  
  /*
      Inisialisasi callback LoRa
  */
  LoRa.onReceive(onReceive);
  LoRa.receive();
}

void loop()
{
  timeClient.update();
  if (dataReceived)
  {
    /*
        Mencetak karakter di LCD
    */
    // lcd.clear();
    // char buff[17];
    // lcd.setCursor(0, 0);
    // sprintf(buff, "Hum:%d Temp:%d C", hum, temp);
    // lcd.println(buff);
    // lcd.setCursor(0, 1);
    // char buff2[16];
    // sprintf(buff2, "CO : %d ppm     ", gas);
    // lcd.println(buff2);

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