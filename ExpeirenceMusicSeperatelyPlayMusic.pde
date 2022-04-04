import processing.sound.*;
import processing.serial.*;
Serial myPort;
SoundFile sampleDance;
SoundFile sampleCow;
SoundFile sampleBirds;
//SoundFile sampleFullfill;
SoundFile sampleDaboOne;
SoundFile sampleHeartbeat;
SoundFile sampleDaboTwo;
SoundFile sampleRain;
SoundFile sampleSingIlomilo;
SoundFile sampleHalfOne;

BeatDetector DancebeatDetector;
BeatDetector DabobeatDetector;
BeatDetector SingbeatDetector;

Amplitude rms;
//Amplitude birdRms;
Amplitude DaboTwoRms;
Amplitude SingRms;

float Position;
float smoothingFactor = 0.25;
float sum;
float DaboSum;
float SingSum;
float newNumber;

ArrayList<Float> threeHeartbeat = new ArrayList<Float>();

int new_rms_scaled;
int new_DaboTwoRms_scaled;
int new_SingRms_scaled;
int DaboTwoRms_rms;

boolean flag = true;
boolean swift = true;

//flower colors
color[] cols = {#279A8B, #E13F88, #FFBB3E, #DE0150, #D6E679, #BB86EE};
//background color
color bg = #28282D;
//color bg = #E9D3B8;

//Poetry Array
String[] poem = {"Stronger.txt", "HerKind.txt", "StillIRise.txt", "LadyLazarus.txt", "AWomanSpeaks.txt", "WeSinfulWomen.txt", "ISingTheBodyElectric.txt", "Brave.txt"};


int fileCount = 0;
//Lines array
String[] lines;

//Flowers array
Flower[] flowers;

PFont theFont;
ArrayList<Stream> streams;
int fontInc;
boolean rainStart = false;


void setup() {
  //fullScreen();
  size(displayWidth, displayHeight);
  background(bg);

  //String portName = Serial.list()[5];
  //myPort = new Serial(this, portName, 115200);
  //printArray(Serial.list());
  //myPort.bufferUntil('\n');

  //printArray(Sound.list());

  sampleDance = new SoundFile(this, "DanceOneLonger2.wav");
  sampleCow = new SoundFile(this, "cowleft.mp3");
  sampleBirds = new SoundFile(this, "cuckoo.mp3");
  //sampleFullfill = new SoundFile(this, "fullfill.mp3");
  sampleDaboOne = new SoundFile(this, "DaboOne.mp3");
  sampleHeartbeat = new SoundFile(this, "heartbeat6.mp3");
  sampleDaboTwo = new SoundFile(this, "DaboTwo.mp3");
  sampleRain = new SoundFile(this, "Rain.mp3");
  sampleSingIlomilo = new SoundFile(this, "SingIlomilo.mp3");
  //sampleHalfOne = new SoundFile(this, "HalfOne.mp3");

  sampleDance.play();
  //println(sampleDance.channels());

  rms = new Amplitude(this);
  rms.input(sampleDance);

  DancebeatDetector = new BeatDetector(this);
  DancebeatDetector.input(sampleDance);
  DancebeatDetector.sensitivity(200);

  DabobeatDetector = new BeatDetector(this);
  DabobeatDetector.input(sampleDaboOne);
  DabobeatDetector.sensitivity(50);

  SingbeatDetector = new BeatDetector(this);
  SingbeatDetector.input(sampleSingIlomilo);
  SingbeatDetector.sensitivity(50);

  DaboTwoRms = new Amplitude(this);
  DaboTwoRms.input(sampleDaboTwo);

  SingRms = new Amplitude(this);
  SingRms.input(sampleSingIlomilo);

  flowerSetup();
  
  fontInc = 20;
  theFont = createFont("Arial Unicode MS", fontInc);
  textFont(theFont);
  textAlign(CENTER, TOP);
  
  streams = new ArrayList<Stream>();

  for (int x=fontInc/2; x < width; x+=fontInc) {
    streams.add(new Stream(x));
  }
  
}//END SETUP

void draw() {
  //background(bg);

  Position = sampleDance.position();
  //println(Position);
  drawRms();
  drawDaboTwoRms();
  drawSingRms();
  playSoundFiles();
  
  if(rainStart == true){
    background(0);
  for (Stream s : streams) {
    s.update();
    
  }
  }
}// END DRAW

void drawRms() {
  // smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothingFactor;

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a fixed scale factor
  float rms_scaled = (sum * (height/2) * 5) * 1.5;
  new_rms_scaled = int(rms_scaled);
  //println(new_rms_scaled);
  if (rms_scaled >= 255) {
    new_rms_scaled = 255;
  }
}

void drawDaboTwoRms() {
  // smooth the rms data by smoothing factor
  DaboSum += (DaboTwoRms.analyze() - DaboSum) * smoothingFactor;

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a fixed scale factor
  float rms_scaled = (DaboSum * (height/2) * 5) / 2.5;
  new_DaboTwoRms_scaled = int(rms_scaled);
  //println(new_DaboTwoRms_scaled);
  if (rms_scaled >= 255) {
    new_DaboTwoRms_scaled = 255;
  }
}

void drawSingRms() {
  // smooth the rms data by smoothing factor
  SingSum += (SingRms.analyze() - SingSum) * smoothingFactor;

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a fixed scale factor
  float rms_scaled = (SingSum * (height/2) * 5) / 2;
  new_SingRms_scaled = int(rms_scaled);
  //println(new_DaboTwoRms_scaled);
  if (rms_scaled >= 255) {
    new_SingRms_scaled = 255;
  }
}

void playSoundFiles() {
  if ((Position >= 0.0) && (Position < 3.271)) {
    sampleDance.pan(-1.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(0); //upper left
      println("0");
    } else {
    }
  }
  if ((Position >= 3.271) && (Position < 5.29)) {
    sampleDance.pan(1.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(1); // upper right
      println("1");
    } else {
    }
  }
  if ((Position >= 5.29) && (Position < 7.253)) {
    sampleDance.pan(-1.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(0);//upper left
      println("0");
    } else {
    }
  }
  if ((Position >= 7.253) && (Position < 10.24)) {//8.01
    sampleDance.pan(0.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(2);//mid belly button motor
      println("2");
    } else {
    }
  }
  if ((Position >= 10.24) && (Position < 16.006)) {
    //myPort.write(new_rms_scaled);
  }
  if ((Position >= 16.111) && (Position < 16.211)) {
    if (flag == true) {
      sampleCow.play();
      //sampleFullfill.play();
      //myPort.write(3);
      flag = false;
      println("Cow");
    } else {
    }
  }
  if ((Position >= 19.360) && (Position < 19.6)) {
    if (flag == false) {
      sampleBirds.play();
      flag = true;
      println("cuckoo");
    } else {
    }
  }
  if ((Position >= 20.610) && (Position < 20.70)) {
    if (flag == true) {
      //myPort.write(4);//comment out if vest not attached
      flag = false;
      println("cuckooHaptic");
    } else {
    }
  }
  if ((Position >= 29.185) && (Position < 50.6)) {
    if (flag == false) {
      sampleDaboOne.play();
      println("Dabo");
      flag = true;
    }
    textSize(14);
    text("Put your finger on the red light, and please don't move", width/6, height/2);
    fill(0, 408, 612);
    //myPort.write(5);//comment out if vest not attached
    //if ( myPort.available() > 0) {  // If data is available,
    //  String value = myPort.readString();         // read it and store it in val
    //  value.trim();
    //  println(value);
    //  newNumber = float(value);
    //  if (newNumber > 0) {
    //    threeHeartbeat.add(newNumber/80);
    //    //println(threeHeartbeat.get(0));
    //  }
    //} end of comment out for no vestnn
    if (DabobeatDetector.isBeat()) {
      //myPort.write(6);//comment out if vest not attached
      //println("6");
    } else {
    }
  }
  if ((Position >= 52.50) && (flag == true) && (threeHeartbeat.size() > 0)) {
    if (flag == true) {
      textSize(14);
      text("You could move your finger from the red light", width/6, height/2);
      fill(0, 408, 612);
      float number = threeHeartbeat.get(1);
      sampleHeartbeat.play();
      sampleHeartbeat.rate(number);
      flag = false;
    } else {
    }
  }
  if ((Position >= 59.957) && (Position < 60.1)) {
    if (swift == true) {
      sampleDaboTwo.play();
      swift = false;
      println("DaboTwo");
    } else {
    }
  }
  if ((Position >= 60.1) && (Position < 78.375)) {
    //myPort.write(new_DaboTwoRms_scaled);//comment out if vest not attached
  }
  if ((Position >= 78.375) && (Position < 79.736)) {
    //if (swift == false) {
    //myPort.clear();
    //myPort.stop();
    //String portName = Serial.list()[4];
    //myPort = new Serial(this, portName, 115200);
    swift = true;
    println("Swift to stroke");
    //} else {
    //}
  }
  if ((Position >= 79.736) && (Position < 79.8)) {
    if (swift == true) {
      //myPort.write(7);//comment out if vest not attached
      swift = false;
      println("Stroke");
    } else {
    }
  }
  if ((Position >= 82.218) && (Position < 82.250)) {
    if (swift == false) {
      sampleRain.play();
      rainStart = true;
      //myPort.clear();
      //myPort.stop();
      //String portName = Serial.list()[5];
      //myPort = new Serial(this, portName, 115200);
      println("rain");
      println("swift" + swift);
      swift = true;
      //} else {
    }
  }
  if ((Position >= 103.671) && (Position < 103.8)) {
    if (swift == true) {
      rainStart = false;
      sampleSingIlomilo.play();
      sampleSingIlomilo.rate(1.1);
      swift = false;
      //flowerSetup();
      //println("file # " +frameCount%7);
      println("Sing");
    } else {
    }
  }
  if ((Position >= 103.8)) {
    if (SingbeatDetector.isBeat()) {
      //myPort.write(8);//comment out if vest not attached
      //println("8");
      push();
      noStroke();
      flowerSetup();
      //vary the transparancy of the faux bg layer
      float t = map(sin(radians(frameCount)), -1, 1, 10, 45);
      fill(bg, t);
      //shadow faux background layer
      rect(0, 0, width, height);
      
      for (Flower flower : flowers ) {
        flower.update();
      }
      pop();
    } else {
    }
  }
  if (Position >= 204.0) {
    if (!sampleSingIlomilo.isPlaying()) {
      //myPort.clear();//comment out if vest not attached
      //myPort.stop();//comment out if vest not attached
    } else {
    }
  } else {
  }
}
