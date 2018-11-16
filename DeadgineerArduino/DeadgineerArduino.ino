
#define SENSOR_1_MAX_VALUE  500
#define SENSOR_2_MAX_VALUE  500
#define SENSOR_1_MIN_VALUE  50
#define SENSOR_2_MIN_VALUE  50
#define SENSOR_1_PIN        A0
#define SENSOR_2_PIN        A1

#include <SoftwareSerial.h>

int s1_value, s2_value;

void setup() {
  pinMode(SENSOR_1_PIN, OUTPUT);
  pinMode(SENSOR_2_PIN, OUTPUT);
  Serial.begin(9600);
  while (!Serial);
  s1_value, s2_value = 0;
}

void loop() {

  s1_value = analogRead(SENSOR_1_PIN);
  s2_value = analogRead(SENSOR_2_PIN);

  if(s1_value > SENSOR_1_MIN_VALUE){
    Serial.println("S1");
  }

  if(s2_value > SENSOR_2_MIN_VALUE){
    Serial.println("S2");
  }

  //Serial.println("Deadgineer is awesome!");
  delay(1);

}
