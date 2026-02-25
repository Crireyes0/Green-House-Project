#include "DHT.h"



DHT dht(2, DHT11);
unsigned long lastReadTime = 0;  
const unsigned long readInterval = 5000;

 void setup() {
  // put your setup code here, to run once:
  dht.begin();
  Serial.begin(115200);
  randomSeed(analogRead(A0) ^ micros());
  
 pinMode(4, OUTPUT); 
}

void loop() {
    if (millis() - lastReadTime >= readInterval) {
        lastReadTime = millis();
 
        float h = dht.readHumidity();
        float t = dht.readTemperature();

        // Save TRUE readings for fan control
        float h_raw = h;
        float t_raw = t;

        // Replace NaN ONLY for MATLAB
        if (isnan(h) || isnan(t)) {
            h = -1;
            t = -1;
        }

        // --- Send data to MATLAB ---
        Serial.print(h);
        Serial.print(",");
        Serial.print(t);
        Serial.print(",");
        Serial.print(random(-2,2));
        Serial.print(",");
        Serial.print(4);
        Serial.println();

        // --- Fan control using REAL values ---
        if (!isnan(h_raw) && !isnan(t_raw)) {
            if (h_raw > 30 || t_raw > 80) {
                digitalWrite(4, HIGH);
            } else {
                digitalWrite(4, LOW);
            }
        }
    }
}
