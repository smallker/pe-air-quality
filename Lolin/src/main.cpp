/*
  --LoRa---
  RST   -> 2
  DIO0  -> 13
  SS    -> 5
  MOSI  -> 23
  MISO  -> 19
  SCK   -> 18

  --DHT11--
  DATA  -> 25

  ---MQ2---
  DATA  -> VP

*/

#include <Arduino.h>
#include <SPI.h>
#include <LoRa.h>
#include <DHT.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "polines.h"
#define DHTPIN 25
#define MQPIN 36
DHT dht(DHTPIN, DHT11);
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
#define OLED_RESET -1 // Reset pin # (or -1 if sharing Arduino reset pin)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
void setup()
{
  Wire.begin(12, 14);
  Serial.begin(115200);
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
  {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ; // Don't proceed, loop forever
  }
  dht.begin();
  while (!Serial)
    ;
  Serial.println("LoRa Sender");
  pinMode(MQPIN, INPUT);

  if (!LoRa.begin(415E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }
}

void loop()
{
  int mq = analogRead(MQPIN);
  int hum = dht.readHumidity();
  int temp = dht.readTemperature();
  if (hum <= 100)
  {
    char data[50];
    sprintf(data, "{\"gas\":%d,\"temp\":%d,\"hum\":%d}", mq, temp, hum);
    Serial.println(data);
    display.clearDisplay();
    display.drawBitmap(49, 0, polines_small, 30, 32, SSD1306_WHITE);
    display.setCursor(0, 40);
    display.setTextSize(1);              // Normal 1:1 pixel scale
    display.setTextColor(SSD1306_WHITE); // Draw white text
    display.setTextSize(1);              // Normal 1:1 pixel scale
    display.setTextColor(SSD1306_WHITE); // Draw white text
    display.setCursor(0, 40);             // Start at top-left corner
    display.println("Suhu       : " + (String)temp + " C");
    display.println("Kelembaban : " + (String)hum + "%");
    display.println("CO         : " + (String)mq + " ppm");
    display.display();
    LoRa.beginPacket();
    LoRa.print(data);
    LoRa.endPacket();
    delay(5000);
  }
}
