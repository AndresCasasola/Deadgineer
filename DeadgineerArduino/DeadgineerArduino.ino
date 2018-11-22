
#define SENSOR_1_MAX_VALUE  500
#define SENSOR_2_MAX_VALUE  500
#define SENSOR_1_MIN_VALUE  50
#define SENSOR_2_MIN_VALUE  50
#define SENSOR_1_PIN        A0
#define SENSOR_2_PIN        A1

#include <SoftwareSerial.h>

int s1_value, s2_value;
int time1, time2;;

void setup() {
  pinMode(SENSOR_1_PIN, INPUT);
  pinMode(SENSOR_2_PIN, INPUT);
  Serial.begin(9600);
  while (!Serial);
  s1_value, s2_value = 0;
  time1 = time2 = 0;
  Serial.println("Working!");
}

void loop() {

  if(millis()-time1 > 1000){
    s1_value = analogRead(SENSOR_1_PIN);
  }

  if(millis()-time2 > 1000){
    s2_value = analogRead(SENSOR_2_PIN);
  }

  if(s1_value > SENSOR_1_MIN_VALUE){
    Serial.write(1);
    //Serial.print("Sensor 1: ");
    //Serial.println(s1_value);
    s1_value = 0;
    time1 = millis();
  }

  if(s2_value > SENSOR_2_MIN_VALUE){
    Serial.write(2);
    //Serial.print("Sensor 2: ");
    //Serial.println(s2_value);
    s2_value = 0;
    time2 = millis();
  }
  delay(100);

}
