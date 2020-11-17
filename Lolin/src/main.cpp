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
#define DHTPIN    25
#define MQPIN     36
DHT dht(DHTPIN, DHT11);

void setup()
{
  Serial.begin(115200);
  dht.begin();
  while (!Serial)
    ;
  Serial.println("LoRa Sender");
  pinMode(MQPIN, INPUT);

  if (!LoRa.begin(915E6))
  {
    Serial.println("Starting LoRa failed!");
    while (1)
      ;
  }
}

void loop()
{
  int mq = map(analogRead(MQPIN), 0, 4095, 0, 1023);
  int hum = dht.readHumidity();
  int temp = dht.readTemperature();
  char data[50];
  sprintf(data,"{\"gas\":%d,\"temp\":%d,\"hum\":%d}",mq,temp,hum);
  Serial.println(data);
  LoRa.beginPacket();
  LoRa.print(data);
  LoRa.endPacket();
  delay(5000);
}