#include <Wire.h>
#include <SoftwareSerial.h>

#define Addr (0xF6>>1)
#define TASTER          3
#define LED             13
#define I2C_DEVICEID  0x00
#define I2C_POWERMODE 0x01
#define I2C_FREQUENCY 0x02
#define I2C_SHAPE 0x03
#define I2C_BOOST 0x04
#define I2C_PVOLTAGE  0x06
#define I2C_P3VOLTAGE 0x06
#define I2C_P2VOLTAGE 0x07
#define I2C_P1VOLTAGE 0x08
#define I2C_P4VOLTAGE 0x09
#define I2C_UPDATEVOLTAGE 0x0A
#define I2C_AUDIO       0x05

int debounce = 0; 
unsigned long time;
int timerSchedule = 10;
int timerCounter=0;
bool dispenseMode=false;
int dispenseCounter=0;
int dispenseSchedule=3;
int mode = 0;
int num = -1; //num receving from the bt

SoftwareSerial bluetooth(15,14);

#define MODE_OFF  0
#define MODE_50   1
#define MODE_100  2
#define MODE_200  3
#define MODE_400  4
#define MODE_800  5
#define MODE_MAX  6

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  Wire.begin();
  Serial.begin(9600);
  bluetooth.begin(9600);
  
  
  Serial.println();
  pinMode(LED, OUTPUT);
  pinMode (TASTER,INPUT_PULLUP);
  
  pinMode (16,OUTPUT);
  pinMode (17,OUTPUT);
  pinMode (A6,INPUT);

  Wire.beginTransmission(Addr);
  Wire.write(I2C_POWERMODE);                  // write address = 0x01
  Wire.write(0x00);                             // Adress 0x01 = 0x01 (enable)
  Wire.write(0x40);                                 // Adress 0x02 = 0x40 (100Hz)
  Wire.write(0x00);                             // Adress 0x03 = 0x00 (sine wave)
  Wire.write(0x00);                             // Adress 0x04 = 0x00 (800KHz)
  Wire.write(0x00);                             // Adress 0x05 = 0x00 (audio off)
  Wire.write(0x1F);                             // Adress 0x06 = 0x00 (EL1)
  Wire.write(0x1F);                             // Adress 0x07 = 0x00 (EL2)
  Wire.write(0x1F);                             // Adress 0x08 = 0x00 (EL3)
  Wire.write(0x1F);                             // Adress 0x09 = 0x00 (EL4)
  Wire.write(0x01);                             // Adress 0x0A = 0x00 (update)
  Wire.endTransmission();
  
  analogWrite(17,255);
  analogWrite(16,0);

  noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;

  OCR1A = 62500;//31250;            // compare match register 16MHz/256/2Hz
  TCCR1B |= (1 << WGM12);   // CTC mode
  TCCR1B |= (1 << CS12);    // 256 prescaler 
  TIMSK1 |= (1 << OCIE1A);  // enable timer compare interrupt
  interrupts();             // enable all interrupts
}

ISR(TIMER1_COMPA_vect)          // timer compare interrupt service routine
{
  if(dispenseMode){
    //set mode to run
    mode=1;
    if(dispenseCounter%dispenseSchedule==0){
      dispenseMode=false;
      mode=0; //turn off pump
    }
    dispenseCounter++;
   }
   
  else{
    digitalWrite(LED, digitalRead(LED) ^ 1);   // toggle LED pin
    if (timerCounter%timerSchedule == 0){
      dispenseMode=true;
      Serial.print("\nTime: ");
      time = millis();
      Serial.print(time);
    }
    timerCounter++;
  }
  
}

// test

void loop() {  
  char c;
        if(mode == MODE_OFF){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_POWERMODE);   // start adress
          Wire.write(0x00);            // disable
          Wire.endTransmission();
          digitalWrite(LED,LOW);
        }
        else if(mode == MODE_50){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_POWERMODE);   // start adress
          Wire.write(0x01);            // enable
          Wire.write(0x00);            // 50 Hz
          Wire.endTransmission();
          digitalWrite(LED,HIGH);
        }
  
  if (Serial.available()) {
    c = Serial.read();
    bluetooth.print(c);
  }
  if (bluetooth.available()) {
    c = bluetooth.read();

    if (c == 'R'){
      
      int sensorValue = analogRead(A6);
      int outputValue = map(sensorValue, 0, 1023, 0, 255);
      bluetooth.println(sensorValue);
      Serial.println("sending EMG data ...");
    }
    
    else if(c != '\n'){
      if (num != -1){
        num = num*10+int(c) - 48; // convert from ascii table
        Serial.println("find non -1 " + c);
      }
      else{
        Serial.println("find -1");
        num = int(c) - 48; // convert from ascii table
      }
    }
    else{
      Serial.print(num);
      Serial.print("another one");
      Serial.print(c);
      timerSchedule = num;
      timerCounter = 0;
      
      num = -1;
    }
    

  }

}

/*
// the loop routine runs over and over again forever:
void loop() {
      if(mode == MODE_OFF){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_POWERMODE);   // start adress
          Wire.write(0x00);            // disable
          Wire.endTransmission();
          digitalWrite(LED,LOW);
        }
        else if(mode == MODE_50){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_POWERMODE);   // start adress
          Wire.write(0x01);            // enable
          Wire.write(0x00);            // 50 Hz
          Wire.endTransmission();
          digitalWrite(LED,HIGH);
        }
        else if(mode == MODE_100){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_FREQUENCY);   // start adress
          Wire.write(0x40);            // 100 Hz
          Wire.endTransmission();
          Serial.println(mode);
          digitalWrite(LED, digitalRead(LED) ^ 1);   // toggle LED pin
          }
        else if(mode == MODE_200){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_FREQUENCY);   // start adress
          Wire.write(0x80);            // 200 Hz
          Wire.endTransmission();
        }
        else if(mode == MODE_400){
          Wire.beginTransmission(Addr);
          Wire.write(I2C_FREQUENCY);   // start adress
          Wire.write(0xC0);            // 400 Hz
          Wire.endTransmission();
        }
       else{
          Wire.beginTransmission(Addr);
          Wire.write(I2C_FREQUENCY);   // start adress
          Wire.write(0xFF);            // 800 Hz
          Wire.endTransmission();
       }
       delay(100);
}
*/

