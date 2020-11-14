#include <Arduino.h>
#include <SPI.h>
#include <LoRa.h>
#include <DHT.h>
#define DHTPIN 25
#define MQPIN 36
int counter = 0;
DHT dht(DHTPIN, DHT11);

void setup()
{
  Serial.begin(115200);
  dht.begin();
  while (!Serial)
    ;
  Serial.println("LoRa Sender");
  pinMode(MQPIN, INPUT);
  // while (true)
  // {
  //   int mq = map(analogRead(MQPIN), 0,4095, 0, 1023);
  //   float hum = dht.readHumidity();
  //   float temp = dht.readTemperature();
  //   Serial.println("MQ : "+(String)mq+"  Hum : "+(String)hum+"%  Temp : "+(String)temp);
  //   delay(100);
  // }

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