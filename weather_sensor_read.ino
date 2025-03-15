#include <DHT.h>

#define DHTPIN 2  
#define DHTTYPE DHT11  
#define LDR_PIN A0  
#define TRIG_PIN 3  
#define ECHO_PIN 4  
#define RED_LED 6  

DHT dht(DHTPIN, DHTTYPE);

void setup() {
    Serial.begin(9600);
    pinMode(TRIG_PIN, OUTPUT);
    pinMode(ECHO_PIN, INPUT);
    pinMode(RED_LED, OUTPUT);
    dht.begin();
}

void loop() {
    // Read DHT11 Temperature & Humidity
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    // Read Photoresistor Light Level
    int lightLevel = analogRead(LDR_PIN);

    // Read Ultrasonic Sensor for Water Level
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);
    long duration = pulseIn(ECHO_PIN, HIGH);
    float distance = duration * 0.034 / 2;  
    float maxTankHeight = 10.0;  
    float waterLevel = maxTankHeight - distance;

    // Send formatted data to Processing (Comma-separated)
    Serial.print(temperature); Serial.print(",");
    Serial.print(humidity); Serial.print(",");
    Serial.print(lightLevel); Serial.print(",");
    Serial.println(waterLevel);  // End with new line

    // Red LED Alert for Water Level
    if (waterLevel > maxTankHeight * 0.9 || waterLevel < maxTankHeight * 0.2) {
        digitalWrite(RED_LED, HIGH);
    } else {
        digitalWrite(RED_LED, LOW);
    }

    delay(2000);
}
