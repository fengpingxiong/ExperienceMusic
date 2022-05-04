import processing.sound.*;
import processing.serial.*;
//Serial myPort;
SoundFile sampleDance;
SoundFile sampleCow;
SoundFile sampleBirds;
//SoundFile sampleFullfill;
SoundFile sampleDaboOne;
SoundFile sampleHeartbeat;
SoundFile sampleHeartbeatDwon;
SoundFile sampleDaboTwo;
SoundFile sampleRain;
SoundFile sampleRainShort;
SoundFile sampleSingIlomilo;
SoundFile sampleHalfOne;

BeatDetector DancebeatDetector;
BeatDetector DabobeatDetector;
BeatDetector HeartbeatDetector;
BeatDetector SingbeatDetector;
BeatDetector RainbeatDetector;

Amplitude rms;
//Amplitude birdRms;
Amplitude DaboTwoRms;
Amplitude SingRms;

PImage heart;

float Position;
float smoothingFactor = 0.25;
float sum;
float DaboSum;
float SingSum;
float readNumber;
float x1, y1, x2, y2, x, y, z;
float xs=9, ys=8.1, zs=7;
float rotz=0, rotx=0, roty=0;
float dia = 300;
float sw = 10;
float angle1, angle2;

int segments;
int colorR;
int colorG;
int colorB;
int k = 0;

ArrayList<Float> threeHeartbeat = new ArrayList<Float>();
ArrayList<Float> temperature = new ArrayList<Float>();
//ArrayList<Float> oxygen = new ArrayList<Float>();

int new_rms_scaled;
int new_DaboTwoRms_scaled;
int new_SingRms_scaled;
int DaboTwoRms_rms;

boolean flag = true;
boolean swift = true;
boolean temper = true;
boolean playRain = true;
boolean playHeart = true;
//boolean oxy = true;
boolean shape = false;

//flower colors Green, Red, orange, dark red
color[] cols = {#279A8B, #E13F88, #FFBB3E, #DE0150, #D6E679, #BB86EE};
//textrain colors
color[] cols2 = {#1F7A6E, #912958, #805E1F, #DE0150, #9C0036, #745394};
//background color
color bg;

//Poetry Array
String[] poem = {"Stronger.txt", "HerKind.txt", "StillIRise.txt",
  "LadyLazarus.txt", "AWomanSpeaks.txt", "WeSinfulWomen.txt",
  "ISingTheBodyElectric.txt", "Brave.txt"};

String[] wordList = {"Words.txt"};
String[] wordsStronger;
String strongerAll;

int fileCount = 0;
//Lines array
String[] lines;
String[] words;


//Flowers array
Flower[] flowers;
firstFlower[] firstFlowers;

PFont theFont;
ArrayList<Stream> streams;
int fontInc;
boolean rainStart = false;

Stem myStem;
Circle circles[];
Flower1 flowers1 = new Flower1();
float scaleFactor=0.5;
int myCountForGrow=0;
float wordX= 500;
float strongerY = random(150, 650);

PImage history;
PImage brave;
PImage sinful;
PImage rise;
PImage woman;
PImage her;
PImage body;

int lighten = 255;
int index =0;

void setup() {
  //fullScreen();
  size(displayWidth, displayHeight, P3D);
  colorR = 25;
  colorG = 28;
  colorB = 26;
  bg = color(colorR, colorG, colorB);
  background(bg);
  //background(#28282d);

  //String portName = Serial.list()[5];
  //myPort = new Serial(this, portName, 115200);
  //printArray(Serial.list());
  //myPort.bufferUntil('\n');

  //printArray(Sound.list());

  sampleDance = new SoundFile(this, "DanceOneLonger2.wav");
  sampleCow = new SoundFile(this, "cowleft.mp3");
  sampleBirds = new SoundFile(this, "cuckoo.mp3");
  sampleDaboOne = new SoundFile(this, "DaboOne.mp3");
  sampleHeartbeat = new SoundFile(this, "heartbeat6.mp3");
  sampleHeartbeatDwon = new SoundFile(this, "heartBeatDown.wav");
  sampleDaboTwo = new SoundFile(this, "DaboTwo.mp3");
  sampleRain = new SoundFile(this, "Rain.mp3");
  sampleRainShort = new SoundFile(this, "RainShort.wav");
  sampleSingIlomilo = new SoundFile(this, "SingIlomilo.mp3");

  sampleDance.play();

  rms = new Amplitude(this);
  rms.input(sampleDance);

  DancebeatDetector = new BeatDetector(this);
  DancebeatDetector.input(sampleDance);
  DancebeatDetector.sensitivity(200);

  DabobeatDetector = new BeatDetector(this);
  DabobeatDetector.input(sampleDaboOne);
  DabobeatDetector.sensitivity(50);

  HeartbeatDetector = new BeatDetector(this);
  HeartbeatDetector.input(sampleHeartbeat);
  HeartbeatDetector.sensitivity(20);

  SingbeatDetector = new BeatDetector(this);
  SingbeatDetector.input(sampleSingIlomilo);
  SingbeatDetector.sensitivity(50);

  RainbeatDetector = new BeatDetector(this);
  RainbeatDetector.input(sampleRain);
  RainbeatDetector.sensitivity(15);

  DaboTwoRms = new Amplitude(this);
  DaboTwoRms.input(sampleDaboTwo);

  SingRms = new Amplitude(this);
  SingRms.input(sampleSingIlomilo);

  flowerSetup();
  firstFlowerSetup();

  fontInc = 20;
  theFont = createFont("Arial Unicode MS", fontInc);
  textFont(theFont);
  textAlign(CENTER, TOP);

  streams = new ArrayList<Stream>();

  for (int x=fontInc/2; x < width; x+=fontInc) {
    streams.add(new Stream(x));
  }
  PFont f = createFont("Montserrat-MediumItalic", 64);

  brave = loadImage("BraveT.png");
  sinful = loadImage("WeSinfulWomenT.png");
  rise = loadImage("StillIRiseT.png");
  woman = loadImage("AWomanSpeaksT.png");
  her = loadImage("HerKindT.png");
  body = loadImage("ISingTheBodyElectricT.png");

//String[] stronger = loadStrings("Stronger.txt");
String[] stronger = loadStrings("Words.txt");
  strongerAll = join(stronger, " ");
  wordsStronger = split(strongerAll, " ");

  myStem = new Stem(round(displayWidth*0.4), round(displayHeight*0.4));


  flowers1 = new Flower1 (0, 0);
  //moved this to setup, no need to recreate each frame
  circles = new Circle[6];
  circles[0]  = new Circle(0, -40, 50, 50);
  circles[1]  = new Circle(0, -40, 50, 50);
  circles[2]  = new Circle(0, -40, 50, 50);
  circles[3]  = new Circle(0, -40, 50, 50);
  circles[4]  = new Circle(0, -40, 50, 50);
  circles[5]  = new Circle(0, 0, 50, 50);
  // also smooth only needs to be called once
  // unless ther is a noSmooth() somewhere
  smooth();

  segments = 10;
  x1 = random(width * 0.30, width * 0.4);// need to change it to random later
  y1 = random(height * 0.30, height * 0.55);// need to change it to random later
}//END SETUP

void draw() {
  //background(bg);
  //println("mouseX " +mouseX);
  //  println("mouseY " +mouseY);
  Position = sampleDance.position();
  drawRms();
  drawDaboTwoRms();
  drawSingRms();
  playSoundFiles();

  if (DancebeatDetector.isBeat() && shape == true) {
    //push();
    noStroke();
    firstFlowerSetup();
    //vary the transparancy of the faux bg layer
    float t = map(sin(radians(frameCount)), -1, 1, 10, 45);
    fill(bg, t);
    for (firstFlower firstFlower : firstFlowers ) {
      firstFlower.update();
      //rectMode(CORNER);

      rect(0, 0, width, height);
    }
    //pop();
    
  }
if (frameCount%6>=1 && shape==true) {
  wordDraw();
  if (wordX < -100) {
    wordX = height/2;
  }
   }

  if (rainStart == true) {
    background(bg);
    textSize(20);
    for (Stream s : streams) {
      s.update();
    }

    if (Position>90) {
      //if (frameCount%9>7) {
      if (RainbeatDetector.isBeat()) {
        displayPoetry();
      }

      lighten--;

      float grow = 0;
      //translate(myStem.initalloX, myStem.initalloY);
      myStem.drawStem();

      translate(myStem.initalloX, myStem.initalloY-(myCountForGrow)-40);
      //translate(myStem.initalloX, myStem.initalloY);
      if (frameCount>10) {
        flowers1.grow();
        flowers1.display();
      }

      if (myCountForGrow<200)
        myCountForGrow+=1.28;
    }
  }
}// END DRAW

void drawRms() {
  // smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothingFactor;

  float rms_scaled = (sum * (height/2) * 5) * 1.5;
  new_rms_scaled = int(rms_scaled);
  if (rms_scaled >= 255) {
    new_rms_scaled = 255;
  }
}

void drawDaboTwoRms() {
  // smooth the rms data by smoothing factor
  DaboSum += (DaboTwoRms.analyze() - DaboSum) * smoothingFactor;
  float rms_scaled = (DaboSum * (height/2) * 5) / 2.5;
  new_DaboTwoRms_scaled = int(rms_scaled);
  if (rms_scaled >= 255) {
    new_DaboTwoRms_scaled = 255;
  }
}

void drawSingRms() {
  // smooth the rms data by smoothing factor
  SingSum += (SingRms.analyze() - SingSum) * smoothingFactor;

  float rms_scaled = (SingSum * (height/2) * 5) / 2;
  new_SingRms_scaled = int(rms_scaled);
  if (rms_scaled >= 255) {
    new_SingRms_scaled = 255;
  }
}

void playSoundFiles() {
  if ((Position >= 0.0) && (Position < 3.271)) {
    sampleDance.pan(-1.0);
    shape = true;
    if (DancebeatDetector.isBeat()) {
      //myPort.write(0); //upper left
      //println("0");
    } else {
    }
  }
  if ((Position >= 3.271) && (Position < 5.29)) {
    sampleDance.pan(1.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(1); // upper right
      //println("1");
    } else {
    }
  }
  if ((Position >= 5.29) && (Position < 7.253)) {
    sampleDance.pan(-1.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(0);//upper left
      //println("0");
    } else {
    }
  }
  if ((Position >= 7.253) && (Position < 10.24)) {//8.01
    sampleDance.pan(0.0);
    if (DancebeatDetector.isBeat()) {
      //myPort.write(2);//mid belly button motor
      //println("2");
    } else {
    }
  }
  if ((Position >= 10.24) && (Position < 16.006)) {
    //myPort.write(new_rms_scaled);
  }
  if ((Position >= 16.111) && (Position < 16.211)) {
    if (flag == true) {
      sampleCow.play();
      //myPort.write(3);
      flag = false;
    } else {
    }
  }
  if ((Position >= 19.360) && (Position < 19.6)) {

    if (flag == false) {
      sampleBirds.play();
      flag = true;
    } else {
    }
  }
  if ((Position >= 20.610) && (Position < 20.70)) {
    shape = false;
    if (flag == true) {
      //myPort.write(4);//comment out if vest not attached
      flag = false;
    } else {
    }
  }
  if ((Position >= 29.0) && (Position < 29.185)) {
    if (playRain == true) {
      sampleRainShort.play(1.0, 0.3);
      playRain = false;
    } else {
    }
  }
  if ((Position >= 39.185) && (Position < 60.6)) {
    if (flag == false) {
      sampleDaboOne.play();
      flag = true;
    }
    //myPort.write(5);//comment out if vest not attached
    //if ( myPort.available() > 0) {  // If data is available,
    //  String value = myPort.readString();         // read it and store it in val
    //  value.trim();
    //  //println(value);
    //  readNumber = float(value);
    //  readNumber = abs(readNumber);
    //  if ((readNumber >= 15.0) && (readNumber < 50.0)) {
    //    temperature.add(readNumber);
    //    //println(temperature.get(0));
    //  } 
    //  if ((readNumber >= 50.0) && (readNumber < 200.0)) {
    //    threeHeartbeat.add(readNumber/80);
    //    //println(threeHeartbeat.get(0));
    //  }
    //}
    if (DabobeatDetector.isBeat()) {
      //myPort.write(6);//comment out if vest not attached
      beginShape();
      noFill();
      stroke(240, 245, 241);
      strokeWeight(0.2);
      curveVertex(x1, y1);
      curveVertex(x1, y1);
      int R = 110;//170
      int G = 43;//67
      int B = 56;//88
      for (int i = 0; i < segments; i++) {
        float xRandom = random(-(width * 0.04), width * 0.04);
        float yRandom = random(-(height * 0.05), height * 0.05);// value smaller the more curve
        float x = (x1 += xRandom);
        float y = (y1 += yRandom);
        // Add point to curve
        stroke(R, G, B, random(10, 20));
        strokeWeight(random(10, 60));
        curveVertex(x, y);
        R += random(-3, 3);
        G += random(-3, 3);
        B -= random(-3, 3);
      }
      curveVertex(x1, y1);
      endShape();
      x1 = random(width * 0.3, width * 0.4);
      y1 = random(height * 0.3, height * 0.55);
    } else {
    }
  }
  if ((Position >= 62.50) && (Position < 68)) {
    if (flag == true) {
      saveFrame("abstractHeart.png");
      if (threeHeartbeat.size() > 0) {
        float number = threeHeartbeat.get(0);
        heart = loadImage("abstractHeart.png");
        sampleHeartbeat.play();
        sampleHeartbeat.rate(number);
        flag = false;
      } else {
        heart = loadImage("abstractHeart.png");
        sampleHeartbeat.play();
        //sampleHeartbeat.rate(1.0);
        flag = false;
      }
    }
    if (HeartbeatDetector.isBeat()) {
      image(heart, 30, 30, width - 100, height -100);
    } else {
      image(heart, 0, 0, width, height);
    }
  }
  if ((Position >= 71.0) && (Position < 71.2)) {
    if (swift == true) {
      background(bg);
      sampleDaboTwo.play();
      swift = false;
    } else {
    }
  }
  if ((Position >= 71.2) && (Position < 77.0)) {
    //myPort.write(new_DaboTwoRms_scaled);
    background(bg);
    //red
    int R = 110;//170
    int G = 43;//67
    int B = 56;//88
    if (new_DaboTwoRms_scaled == 255) {
      beginShape();
      noFill();
      stroke(R, G, B, random(10, 255));
      strokeWeight(random(5, 30));
      x1 = random(width * 0.35, width * 0.65);// need to change it to random later
      y1 = random(height * 0.35, height * 0.65);
      curveVertex(x1, y1);
      for (int h = 0; h < 4; h++) {
        float xRandom = random(-(width * 0.5), width * 0.5);
        float yRandom = random(-(height * 0.5), height * 0.5);// value smaller the more curve
        float x = (x1 += xRandom);
        float y = (y1 += yRandom);
        //beginShape();
        curveVertex(x, y);
        R += random(-5, 5);
        G += random(-5, 5);
        B -= random(-5, 5);
        //ellipse(x1 + xRandom, y1 + xRandom, random(10,100), random(10,100));
      }
      //beginShape();
      curveVertex(x1, y1);
      endShape();
    }
  }
  if ((Position >= 77.0) && (Position < 85.0)) {
    //myPort.write(new_DaboTwoRms_scaled);
    translate(width/2, height/2);
    for (int n = 0; n < 5; n++) {
      rotate(TWO_PI/(n+1));
      angle1 = random(TWO_PI);
      angle2 = random(TWO_PI);

      float x3 = dia * sin(angle1);
      float y3 = dia * cos(angle1);
      float x4 = dia * sin(angle2);
      float y4 = dia * cos(angle2);
      line(x3, y3, x4, y4);
      float xyVar = random(200, 400);
      float x_ = random(-xyVar, xyVar);
      float y_ = random(-xyVar, xyVar);
      noFill();
      stroke(#993247, 10);
      strokeWeight(10);
      bezier(x3, y3, x3 + x_, y3, x3, y3 + y_, x3 + xyVar, y3 + xyVar);
    }
  }
  if ((Position >= 85.0) && (Position < 89.0)) {
    //myPort.write(new_DaboTwoRms_scaled);
    translate(width/2, height/2);
    for (int n = 0; n < 10; n++) {
      strokeWeight(5);
      stroke(#ba344f, 255);
      angle1 = random(TWO_PI);
      angle2 = random(TWO_PI);

      float x3 = dia * sin(angle1);
      float y3 = dia * cos(angle1);
      float x4 = dia * sin(angle2);
      float y4 = dia * cos(angle2);
      line(x3, y3, x4, y4);
    }
  }
  if ((Position >= 89.0) && (Position < 89.736)) {
    //if (k < (temperature.get(0)*2)) {
    //  colorR = int(25 + k + 1);
    //  colorG = int(28 + k);
    //  colorB = int(26 + k);
    //  bg = color(colorR, colorG, colorB);
    //  background(bg);
    //  k += 1;
    //}
    noStroke();
    lights();
    directionalLight(250, 254, 151, 0, -2, 0);
    spotLight(255, 255, 255, width/2, 600, 200, 0, -1, 0, PI/8, 10);
    pushMatrix();
    translate(width/2, height/2, 0);
    fill(#c93251);
    sphere(dia-19);
    popMatrix();
    if (swift == false) {
      //myPort.clear();
      //myPort.stop();
      //String portName = Serial.list()[4];
      //myPort = new Serial(this, portName, 115200);
      swift = true;
    }
  }
  if ((Position >= 89.736) && (Position < 89.8)) {
    if (swift == true) {
      //myPort.write(7);//comment out if vest not attached
      swift = false;
    } else {
    }
  }
  if ((Position >= 89.8) && (Position < 94.0)) {
    //if (k < (temperature.get(0)*7)) {
    //  colorR = int(25 + 1.2*k + 1);
    //  colorG = int(28 + 1.15*k);
    //  colorB = int(26 + 1.1*k);
    //  bg = color(colorR, colorG, colorB);
    //  background(bg);
    //  k += 1;
    //}
    background(bg);
    translate(width/2, height/2, 0);
    rotateX(rotx);
    rotateY(roty);
    rotateZ(rotz);
    lights();
    directionalLight(250, 254, 151, 0, -2, 0);
    spotLight(255, 255, 255, width/2, 600, 200, 0, -1, 0, PI/8, 10);
    pushMatrix();
    rotateX(-PI/8);
    translate(x, y, z);
    noStroke();
    fill(#c93251);
    lights();
    sphere(dia-19);
    popMatrix();
    x=x+xs;
    if (x>230 || x<-230) {
      x=x-xs;
      xs=-xs;
      dia = dia -60;
    }
    y=y+ys;
    if (y>230 || y<-230) {
      y=y-ys;
      ys=-ys;
    }
    z=z+zs;
    if (z>230 || z<-230) {
      z=z-zs;
      zs=-zs;
    }
    // Rotate scene
    rotx+=0.005;
    roty+=0.0011;
    rotz+=0.0013;
  }
  if ((Position >= 94.0) && (Position < 95.0)) {
    if (swift == false) {
      sampleRain.play();
      rainStart = true;

      //myPort.clear();
      //myPort.stop();
      //String portName = Serial.list()[5];
      //myPort = new Serial(this, portName, 115200);
      swift = true;
    }
  }
  if ((Position >= 113.671) && (Position < 113.8)) {

    if (swift == true) {
      rainStart = false;

      sampleSingIlomilo.play();
      sampleSingIlomilo.rate(1.1);
      swift = false;
    } else {
    }
  }
  if (Position >= 113.8) {
    //myPort.write(new_SingRms_scaled);
    if (SingbeatDetector.isBeat()) {
      //myPort.write(8);//comment out if vest not attached
      if (Position > 110) {
    //myPort.write(new_SingRms_scaled);) {
        push();
        noStroke();
        flowerSetup();
        //vary the transparancy of the faux bg layer
        float t = map(sin(radians(frameCount)), -1, 1, 10, 45);
        fill(bg, t);
        //shadow faux background layer
        //rectMode(CORNER);
        //rect(0, 0, displayWidth, displayHeight);

        for (Flower flower : flowers ) {
          flower.update();
        }
        pop();
      }
    } else {
    }
  }
  
  if ((Position >= 212.0) && (Position < 212.1)) {
    if (playHeart == true) {
      background(bg);
      if (threeHeartbeat.size() > 0) {
        float number = threeHeartbeat.get(0);
        sampleHeartbeatDwon.play();
        sampleHeartbeatDwon.rate(number);
        playHeart = false;
      } else {
        sampleHeartbeatDwon.play();
        //sampleHeartbeatDwon.rate(1.0);
        playHeart = false;
      }
    }
  }
}//end Play Sound Files
