#include <Arduino.h>
#include <SPI.h>
#include <LoRa.h>
#include <DHT.h>
#define DHTPIN  25
#define MQPIN   36
int counter = 0;
DHT dht(DHTPIN, DHT11);

void setup() {
  Serial.begin(115200);
  dht.begin();
  while (!Serial);
  Serial.println("LoRa Sender");
  pinMode(MQPIN, INPUT);
  while (true)
  {
    int mq = map(analogRead(MQPIN), 0,4095, 0, 1023);
    float hum = dht.readHumidity();
    float temp = dht.readTemperature();
    Serial.println("MQ : "+(String)mq+"  Hum : "+(String)hum+"%  Temp : "+(String)temp);
    delay(100);
  }
  
  if (!LoRa.begin(915E6)) {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
}

void loop() {
  Serial.print("Sending packet: ");
  Serial.println(counter);
  LoRa.beginPacket();
  LoRa.print("hello ");
  LoRa.print(counter);
  LoRa.endPacket();
  counter++;
  delay(5000);
}