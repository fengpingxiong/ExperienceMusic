#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"
//#include "spo2_algorithm.h"

MAX30105 particleSensor;

//#if defined(__AVR_ATmega328P__) || defined(__AVR_ATmega168__)
////Arduino Uno doesn't have enough SRAM to store 100 samples of IR led data and red led data in 32-bit format
////To solve this problem, 16-bit MSB of the sampled data will be truncated. Samples become 16-bit data.
//uint16_t irBuffer[100]; //infrared LED sensor data
//uint16_t redBuffer[100];  //red LED sensor data
//#else
//uint32_t irBuffer[100]; //infrared LED sensor data
//uint32_t redBuffer[100];  //red LED sensor data
//#endif
//
//int32_t bufferLength; //data length
//int32_t spo2; //SPO2 value
//int8_t validSPO2; //indicator to show if the SPO2 calculation is valid
//int32_t heartRate; //heart rate value
//int8_t validHeartRate; 

const byte RATE_SIZE = 4; //Increase this for more averaging. 4 is good.
byte rates[RATE_SIZE]; //Array of heart rates
byte rateSpot = 0;
long lastBeat = 0; //Time at which the last beat occurred

float beatsPerMinute;
int beatAvg;
int beatvalues[10];

int vib0 = A0;//Shoulder button 1 motors front  left 
int vib1 = 4;// Shoulder button 1 motors back  left 
int vib2 = 16;// lower waist 2 button motors
int vib3 = 18;// back coreless  4 motors 
int vib4 = 21;// Shoulder button motors 1 front  right
int vib5 = 12;// Shoulder button 1 motors back   right 
int vib6 = 13;// Back button 2 motors left  
int vib7 = 14;// Upper Belly 1 button motor 
int vib8 = 15;// Upper Belly 1 coreless motor
int vib9 = 27;// lower waist 2 coreless motor
int vib10 = 33;// Upper heart 1 coreless motor
int vib11 = 17;// Back button motors 2 right
int freq = 30000;
int vib0Channel = 0;
int vib1Channel = 1;
int vib2Channel = 2;
int vib3Channel = 3;
int vib4Channel = 4;
int vib5Channel = 5;
int vib6Channel = 6;
int vib7Channel = 7;
int vib8Channel = 8;
int vib9Channel = 9;
int vib10Channel = 10;
int vib11Channel = 11;
int resolution = 8;

int inByte;

int lowPWM = 175;//160 is the lowest PWM for fal motor. 170 is for two gear heads motor
int midPWM = 204;
int fullPWM = 255;

boolean flag = true;
boolean cuckoo = true;
boolean cow = true;
boolean Oxygen = true;
boolean Temper = true;
boolean heart = true;

void setup() {
  Serial.begin(115200);
  while (!Serial) {};

  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) //Use default I2C port, 400kHz speed
  {
    Serial.println("MAX30105 was not found. Please check wiring/power. ");
    while (1);
  } 
  Serial.println("Place your index finger on the sensor with steady pressure.");

//  byte ledBrightness = 60; //Options: 0=Off to 255=50mA
//  byte sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
//  byte ledMode = 2; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
//  byte sampleRate = 100; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
//  int pulseWidth = 411; //Options: 69, 118, 215, 411
//  int adcRange = 4096; //Options: 2048, 4096, 8192, 16384
  
//  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these s
  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x0A); //Turn Red LED to low to indicate sensor is running
  particleSensor.setPulseAmplitudeGreen(0);
  particleSensor.enableDIETEMPRDY();

  establishContact();
  
  pinMode (vib0, OUTPUT);
  pinMode (vib1, OUTPUT);
  pinMode (vib2, OUTPUT);
  pinMode (vib3, OUTPUT);
  pinMode (vib4, OUTPUT);
  pinMode (vib5, OUTPUT);
  pinMode (vib6, OUTPUT);
  pinMode (vib7, OUTPUT);
  pinMode (vib8, OUTPUT);
  pinMode (vib9, OUTPUT);
  pinMode (vib10, OUTPUT);
  pinMode (vib11, OUTPUT);
  ledcSetup(vib0Channel, freq, resolution);
  ledcSetup(vib1Channel, freq, resolution);
  ledcSetup(vib2Channel, freq, resolution);
  ledcSetup(vib3Channel, freq, resolution);
  ledcSetup(vib4Channel, freq, resolution);
  ledcSetup(vib5Channel, freq, resolution);
  ledcSetup(vib6Channel, freq, resolution);
  ledcSetup(vib7Channel, freq, resolution);
  ledcSetup(vib8Channel, freq, resolution);
  ledcSetup(vib9Channel, freq, resolution);
  ledcSetup(vib10Channel, freq, resolution);
  ledcSetup(vib11Channel, freq, resolution);
  ledcAttachPin(vib0, vib0Channel);
  ledcAttachPin(vib1, vib1Channel);
  ledcAttachPin(vib2, vib2Channel);
  ledcAttachPin(vib3, vib3Channel);
  ledcAttachPin(vib4, vib4Channel);
  ledcAttachPin(vib5, vib5Channel);
  ledcAttachPin(vib6, vib6Channel);
  ledcAttachPin(vib7, vib7Channel);
  ledcAttachPin(vib8, vib8Channel);
  ledcAttachPin(vib9, vib9Channel);
  ledcAttachPin(vib10, vib10Channel);
  ledcAttachPin(vib11, vib11Channel);
}

void loop() {
  if (Serial.available() > 0) {
    inByte = Serial.read();
    if (inByte == 0) {
      startBeatLeft();
      }
    if (inByte == 1) {
      startBeatRight();
      }
    if (inByte == 2) {
      startMid();
      }
    if (inByte == 3) {
      if (cow == true) {
        startCowCorelessMotorVibration();
        cow = false;
        }
      }
    if (inByte == 4) {
      if (cuckoo == true) {
        startCuckoo();
        cuckoo = false;
        } 
      }
    if (inByte >= 160) {
      //parse and interpret data
      startDidgeridoo(inByte);// full
      } 
    if (inByte == 6) {
      startDaboBeat();
      }
    if (inByte == 8) {
      startSing(); 
      } 
    if (inByte == 5) {
        if (heart == true) {
        startHeartbeat();
      } 
      if (Temper == true) {
        startTemp();
      }
//      if (Oxygen == true) {
//        startOxygen(); 
//        }
      }


   } else {
   }
}

void startBeatLeft() {
  ledcWrite(vib0Channel, 255);
  ledcWrite(vib1Channel, 255);
  delay(60);
  ledcWrite(vib0Channel, 0);
  ledcWrite(vib1Channel, 0);
}
void startBeatRight() {
  ledcWrite(vib4Channel, 255);
  ledcWrite(vib5Channel, 255);
  delay(60);
  ledcWrite(vib4Channel, 0);
  ledcWrite(vib5Channel, 0);
}
void startMid() {
  ledcWrite(vib7Channel, 255);
  delay(60);
  ledcWrite(vib7Channel, 0);
}
void startCowCorelessMotorVibration() {
  for(int dutyCycle = 60; dutyCycle <= 180; dutyCycle++) {
//    ledcWrite(vib2Channel, dutyCycle);//button motors
//    ledcWrite(vib7Channel, dutyCycle);//button motors
    ledcWrite(vib9Channel, dutyCycle);
    delay(6.6);
    }
//  ledcWrite(vib2Channel, 0);
//  ledcWrite(vib7Channel, 0);
    ledcWrite(vib9Channel, 0);
  delay(995);
  for(int dutyCycle = 100; dutyCycle <= 255; dutyCycle++) {
//    ledcWrite(vib2Channel, dutyCycle);
//    ledcWrite(vib7Channel, dutyCycle);
    ledcWrite(vib9Channel, dutyCycle);
    delay(13);
    }
//  ledcWrite(vib2Channel, 0);
//  ledcWrite(vib7Channel, 0);
    ledcWrite(vib9Channel, 0);
}
void startDidgeridoo(int d) {
  ledcWrite(vib0Channel, d);
  ledcWrite(vib1Channel, d);
  ledcWrite(vib2Channel, d);
  ledcWrite(vib4Channel, d);
  ledcWrite(vib5Channel, d);
  ledcWrite(vib6Channel, d);
  ledcWrite(vib7Channel, d);// Upper Belly 1 button motor 
  ledcWrite(vib11Channel, d);
  delay(5);//5 works
  ledcWrite(vib0Channel, 0);
  ledcWrite(vib1Channel, 0);
  ledcWrite(vib2Channel, 0);
  ledcWrite(vib4Channel, 0);
  ledcWrite(vib5Channel, 0);
  ledcWrite(vib6Channel, 0);
  ledcWrite(vib7Channel, 0);
  ledcWrite(vib11Channel, 0);
}
void startCuckoo() {
  ledcWrite(vib8Channel, 200);
  delay(132);
  ledcWrite(vib8Channel, 0);
  delay(252);

  ledcWrite(vib8Channel, 200);
  delay(258);
  ledcWrite(vib8Channel, 0);
  delay(2252);

  ledcWrite(vib8Channel, 200);
  delay(132);
  ledcWrite(vib8Channel, 0);
  delay(276);

  ledcWrite(vib8Channel, 200);
  delay(198);
  ledcWrite(vib8Channel, 0);
  delay(2526);

  ledcWrite(vib8Channel, 200);
  delay(122);
  ledcWrite(vib8Channel, 0);
  delay(298);

  ledcWrite(vib8Channel, 200);
  delay(192);
  ledcWrite(vib8Channel, 0);
  delay(754);//

  ledcWrite(vib8Channel, 200);
  delay(102);
  ledcWrite(vib8Channel, 0);
  delay(294);

  ledcWrite(vib8Channel, 200);
  delay(174);
  ledcWrite(vib8Channel, 0);
  delay(10);
}
void startDaboBeat() {
  ledcWrite(vib0Channel, fullPWM);
  ledcWrite(vib1Channel, fullPWM);
  ledcWrite(vib4Channel, fullPWM);
  ledcWrite(vib5Channel, fullPWM);
  ledcWrite(vib2Channel, fullPWM);
  ledcWrite(vib6Channel, fullPWM);
  ledcWrite(vib7Channel, fullPWM);
  ledcWrite(vib11Channel, fullPWM);
  delay(60);
  ledcWrite(vib0Channel, 0);
  ledcWrite(vib1Channel, 0);
  ledcWrite(vib4Channel, 0);
  ledcWrite(vib5Channel, 0);
  ledcWrite(vib2Channel, 0);
  ledcWrite(vib6Channel, 0);
  ledcWrite(vib7Channel, 0);
  ledcWrite(vib11Channel, 0);
}
void startHeartbeat() {
  long irValue = particleSensor.getIR();

  if (checkForBeat(irValue) == true)
  {
    for (int i = 0; i < 20; i ++) {
      //We sensed a beat!
      long delta = millis() - lastBeat;
      lastBeat = millis();

      beatsPerMinute = 60 / (delta / 1000.0);

      if (beatsPerMinute < 170 && beatsPerMinute > 50)
      {
        rates[rateSpot++] = (byte)beatsPerMinute; //Store this reading in the array
        rateSpot %= RATE_SIZE; //Wrap variable

        //Take average of readings
        beatAvg = 0;
        for (byte x = 0 ; x < RATE_SIZE ; x++)
          beatAvg += rates[x];
        beatAvg /= RATE_SIZE;
        if (beatAvg < 170 && beatAvg > 50) {
         Serial.print(beatAvg);
        }
     }
    }

    
  if (irValue < 50000)
    Serial.print(" No finger?");

  Serial.println();

  }
}

//void startOxygen() {
//  bufferLength = 100; //buffer length of 100 stores 4 seconds of samples running at 25sps
//
//  //read the first 100 samples, and determine the signal range
//  for (byte i = 0 ; i < bufferLength ; i++)
//  {
//    while (particleSensor.available() == false) //do we have new data?
//      particleSensor.check(); //Check the sensor for new data
//
//    redBuffer[i] = particleSensor.getRed();
//    irBuffer[i] = particleSensor.getIR();
//    particleSensor.nextSample(); //We're finished with this sample so move to next sample
//  }
//
//  //calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
//  maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
//
//  //Continuously taking samples from MAX30102.  Heart rate and SpO2 are calculated every 1 second
//  while (1)
//  {
//    //dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
//    for (byte i = 25; i < 100; i++)
//    {
//      redBuffer[i - 25] = redBuffer[i];
//      irBuffer[i - 25] = irBuffer[i];
//    }
//
//    //take 25 sets of samples before calculating the heart rate.
//    for (byte i = 75; i < 100; i++)
//    {
//      while (particleSensor.available() == false) //do we have new data?
//        particleSensor.check(); //Check the sensor for new data
//
//      redBuffer[i] = particleSensor.getRed();
//      irBuffer[i] = particleSensor.getIR();
//      particleSensor.nextSample(); //We're finished with this sample so move to next sample
//
//      //send samples and calculation result to terminal program through UART
//      Serial.println(spo2, DEC);
//    }
//
//    //After gathering 25 new samples recalculate HR and SP02
//    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
//  }
//}

void startTemp() {
  float temperature = particleSensor.readTemperature();

//  Serial.print("temperatureC=");
  Serial.println(temperature, 4);

//  float temperatureF = particleSensor.readTemperatureF(); //Because I am a bad global citizen
//
//  Serial.print(" temperatureF=");
//  Serial.print(temperatureF, 4);

//  Serial.println();
}

void startSing() {
  ledcWrite(vib10Channel, 220);
  delay(60);
  ledcWrite(vib10Channel, 0);
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}
void stop()
{
}
