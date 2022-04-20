int vib0 = A0;
int vib1 = A1;
int vib2 = 4;
int vib3 = 5;
int vib4 = 18; 
int vib5 = 19;
int vib6 = 16; 
int vib7 = 17;
int vib8 = 21; 
int vib9 = 13;
int vib10 = 14;

int inByte;

void setup() {
//   put your setup code here, to run once:
  Serial.begin(115200);
  while (!Serial) {};
 
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
  pinMode (vib9, OUTPUT);
  pinMode (vib10, OUTPUT);

}

void loop() { 
  if (Serial.available() > 0) {
    inByte = Serial.read();
    if (inByte == 7) {
      startStroke();
      }
   }
}

void startStroke() {
  digitalWrite(vib0, HIGH);
      delay(100);
      digitalWrite(vib0, LOW);
      delay(5);
      digitalWrite(vib1, HIGH);
      delay(100);
      digitalWrite(vib1, LOW);
      delay(5);
      digitalWrite(vib2, HIGH);
      delay(100);
      digitalWrite(vib2, LOW);
      delay(5);
      digitalWrite(vib3, HIGH);
      delay(100);
      digitalWrite(vib3, LOW);
      delay(5);
      digitalWrite(vib4, HIGH);
      delay(100);
      digitalWrite(vib4, LOW);
      delay(5);
      digitalWrite(vib5, HIGH);
      delay(100);
      digitalWrite(vib5, LOW);
      delay(5);
      digitalWrite(vib6, HIGH);
      delay(100);
      digitalWrite(vib6, LOW);
      delay(5);
      digitalWrite(vib7, HIGH);
      delay(100);
      digitalWrite(vib7, LOW);
      delay(5);
      digitalWrite(vib8, HIGH);
      delay(100);
      digitalWrite(vib8, LOW);
      delay(5);
      digitalWrite(vib9, HIGH);
      delay(100);
      digitalWrite(vib9, LOW);
      delay(5);
      digitalWrite(vib10, HIGH);
      delay(100);
      digitalWrite(vib10, LOW);
      delay(5);
      digitalWrite(vib9, HIGH);
      delay(100);
      digitalWrite(vib9, LOW);
      delay(5);
      digitalWrite(vib8, HIGH);
      delay(100);
      digitalWrite(vib8, LOW);
      delay(5);
      digitalWrite(vib7, HIGH);
      delay(100);
      digitalWrite(vib7, LOW);
      delay(5);
      digitalWrite(vib6, HIGH);
      delay(100);
      digitalWrite(vib6, LOW);
      delay(5);
      digitalWrite(vib5, HIGH);
      delay(100);
      digitalWrite(vib5, LOW);
      delay(5);
      digitalWrite(vib4, HIGH);
      delay(100);
      digitalWrite(vib4, LOW);
      delay(5);
      digitalWrite(vib3, HIGH);
      delay(100);
      digitalWrite(vib3, LOW);
      delay(5);
      digitalWrite(vib2, HIGH);
      delay(100);
      digitalWrite(vib2, LOW);
      delay(5);
      digitalWrite(vib1, HIGH);
      delay(100);
      digitalWrite(vib1, LOW);
      delay(5);
      digitalWrite(vib0, HIGH);
      delay(100);
      digitalWrite(vib0, LOW);
      delay(5);
      digitalWrite(vib2, HIGH);
      delay(100);
      digitalWrite(vib2, LOW);
      delay(5);
      digitalWrite(vib3, HIGH);
      delay(100);
      digitalWrite(vib3, LOW);
      delay(5);
      digitalWrite(vib4, HIGH);
      delay(100);
      digitalWrite(vib4, LOW);
      delay(5);
      digitalWrite(vib5, HIGH);
      delay(100);
      digitalWrite(vib5, LOW);
      delay(5);
      digitalWrite(vib6, HIGH);
      delay(100);
      digitalWrite(vib6, LOW);
      delay(5);
      digitalWrite(vib7, HIGH);
      delay(100);
      digitalWrite(vib7, LOW);
      delay(5);
      digitalWrite(vib8, HIGH);
      delay(100);
      digitalWrite(vib8, LOW);
      delay(5);
      digitalWrite(vib9, HIGH);
      delay(100);
      digitalWrite(vib9, LOW);
      delay(5);
      digitalWrite(vib10, HIGH);
      delay(100);
      digitalWrite(vib10, LOW);
      delay(5);
}
