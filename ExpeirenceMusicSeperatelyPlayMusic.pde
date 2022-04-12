import processing.sound.*;
//import processing.serial.*;
//Serial myPort;
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
float x1,y1, x2, y2,x, y, z;
float xs=9, ys=8.1, zs=7;
float rotz=0, rotx=0, roty=0;
float dia = 300;
float sw = 10;
float angle1, angle2;

int segments;

ArrayList<Float> threeHeartbeat = new ArrayList<Float>();
ArrayList<Float> temperature = new ArrayList<Float>();
ArrayList<Float> oxygen = new ArrayList<Float>();

int new_rms_scaled;
int new_DaboTwoRms_scaled;
int new_SingRms_scaled;
int DaboTwoRms_rms;

boolean flag = true;
boolean swift = true;
boolean temper = true;
boolean oxy = true;

//flower colors
color[] cols = {#279A8B, #E13F88, #FFBB3E, #DE0150, #D6E679, #BB86EE};
//background color
color bg = #28282D;

//Poetry Array
String[] poem = {"Stronger.txt", "HerKind.txt", "StillIRise.txt", 
"LadyLazarus.txt", "AWomanSpeaks.txt", "WeSinfulWomen.txt", 
"ISingTheBodyElectric.txt", "Brave.txt"};

int fileCount = 0;
//Lines array
String[] lines;

//Flowers array
Flower[] flowers;

PFont theFont;
ArrayList<Stream> streams;
int fontInc;
boolean rainStart = false;

Stem myStem;
Circle circles[];
Flower1 flowers1 = new Flower1();
float scaleFactor=0.5;
int myCountForGrow=0;

PImage history;
PImage brave;
PImage sinful;
PImage rise;
PImage woman;
PImage her;
PImage body;

int lighten = 255;

void setup() {
  //fullScreen();
  size(displayWidth, displayHeight, P3D);
  background(#28282d);

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
  sampleDaboTwo = new SoundFile(this, "DaboTwo.mp3");
  sampleRain = new SoundFile(this, "Rain.mp3");
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
  RainbeatDetector.sensitivity(30);

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
  PFont f = createFont("Montserrat-MediumItalic", 64);

  brave = loadImage("BraveT.png");
  sinful = loadImage("WeSinfulWomenT.png");
  rise = loadImage("StillIRiseT.png");
  woman = loadImage("AWomanSpeaksT.png");
  her = loadImage("HerKindT.png");
  body = loadImage("ISingTheBodyElectricT.png");

  myStem = new Stem(400, height);
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

  Position = sampleDance.position();
  drawRms();
  drawDaboTwoRms();
  drawSingRms();
  playSoundFiles();

  if (rainStart == true) {
    background(bg);
    textSize(20);
    for (Stream s : streams) {
      s.update();
    }
    if(Position>90){
      //if (frameCount%9>7) {
        if(RainbeatDetector.isBeat()){
    displayPoetry();
  }
  lighten--;


  float grow = 0;
  //translate(myStem.initalloX, myStem.initalloY);
  myStem.drawStem();

  translate(myStem.initalloX, myStem.initalloY-(myCountForGrow));
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
  //if ((Position >= 10.24) && (Position < 16.006)) {
  //  myPort.write(new_rms_scaled);
  //}
  if ((Position >= 16.111) && (Position < 16.211)) {
    if (flag == true) {
      sampleCow.play();
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
      //println("cuckoo");
      //println("flag " + flag);
       
    } else {
    }
  }
  if ((Position >= 20.610) && (Position < 20.70)) {
   
    if (flag == true) {
      //myPort.write(4);//comment out if vest not attached
      flag = false;
      println("cuckooHaptic");
      //println("flag " + flag); 
    } else {
    }
  }
  if ((Position >= 29.185) && (Position < 50.6)) {
    
    if (flag == false) {
      sampleDaboOne.play();
      //println("Dabo");
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
    //    println(temperature.get(0));
    //  } 
    //  if ((readNumber >= 50.0) && (readNumber < 200.0)) {
    //    threeHeartbeat.add(readNumber/80);
    //    println(threeHeartbeat.get(0));
    //  }
    //  if ((readNumber >= 200.0) && (readNumber < 1000.0)) {
    //    oxygen.add(readNumber/10);
    //    println(oxygen.get(0));
    //  }
    //} //end of comment out for no vestnn
    if (DabobeatDetector.isBeat()) {
      //myPort.write(6);//comment out if vest not attached
      //println("6");
      beginShape();
      noFill();
      stroke(240, 245, 241);
      strokeWeight(0.2);
      curveVertex(x1, y1);
      curveVertex(x1, y1);
      int R = 110;//170
      int G = 43;//67
      int B = 56;//88
      for (int i = 0; i < segments; i++){
        float xRandom = random(-(width * 0.04), width * 0.04);
        float yRandom = random(-(height * 0.05), height * 0.05);// value smaller the more curve
        float x = (x1 += xRandom);
        float y = (y1 += yRandom);
    // Add point to curve
        stroke(R, G, B, random(10,20));
        strokeWeight(random(10, 60));
        curveVertex(x, y); 
      //point(x + 8, y + 8);
        R += random(-3,3);
        G += random(-3,3);
        B -= random(-3,3);
    }
    curveVertex(x1, y1); 
    endShape(); 
    x1 = random(width * 0.3, width * 0.4);
    y1 = random(height * 0.3, height * 0.55);
    } else {
    }
  }
  if ((Position >= 52.50) && (Position < 58)) {
    if (flag == true) {
      saveFrame("abstractHeart.png");
      if (threeHeartbeat.size() > 0) {
        float number = threeHeartbeat.get(0);
        heart = loadImage("abstractHeart.png");
        sampleHeartbeat.play();
        sampleHeartbeat.rate(number);
        //println("detected");
        flag = false;
      } else {
        heart = loadImage("abstractHeart.png");
        sampleHeartbeat.play();
        sampleHeartbeat.rate(1.0);
        flag = false;
      }  
    } 
    if (HeartbeatDetector.isBeat()) {
       image(heart, 30, 30, width - 100, height -100);
     } else {
       image(heart, 0, 0, width, height);
    }
  }
  if ((Position >= 61.0) && (Position < 61.2)) {
    if (swift == true) {
      background(25, 28, 26); 
      sampleDaboTwo.play();
      swift = false;
      //println("DaboTwo");
     
    } else {
    }
  }
  if ((Position >= 61.2) && (Position < 67.0)) {
     //myPort.write(new_DaboTwoRms_scaled);
     background(25, 28, 26);  
      //red
     int R = 110;//170
     int G = 43;//67
     int B = 56;//88
     if (new_DaboTwoRms_scaled == 255) {
       beginShape();
       noFill();
       stroke(R, G, B, random(10,255));
       strokeWeight(random(5,30));
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
         R += random(-5,5);
         G += random(-5,5);
         B -= random(-5,5);
         //ellipse(x1 + xRandom, y1 + xRandom, random(10,100), random(10,100));
       }
       //beginShape();
       curveVertex(x1, y1); 
       endShape();
       }
  } 
  if ((Position >= 67.0) && (Position < 75.0)) {
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
      stroke(#279A8B,10);
      strokeWeight(10);
      bezier(x3, y3, x3 + x_, y3, x3, y3 + y_, x3 + xyVar, y3 + xyVar);  
   } 
  }
  if ((Position >= 75.0) && (Position < 79.0)) {
    //myPort.write(new_DaboTwoRms_scaled);
    translate(width/2, height/2);
    for (int n = 0; n < 10; n++) {
    strokeWeight(5);
    stroke(#6be758,255);
      angle1 = random(TWO_PI);
      angle2 = random(TWO_PI);
   
      float x3 = dia * sin(angle1);
      float y3 = dia * cos(angle1);
      float x4 = dia * sin(angle2);
      float y4 = dia * cos(angle2);
      line(x3, y3, x4, y4);
   }
    
  }
  if ((Position >= 79.0) && (Position < 79.736)) {
    background(25, 28, 26); 
    noStroke();
    lights();
    directionalLight(250, 254, 151, 0, -2, 0);
    spotLight(255, 255, 255, width/2, 600, 200, 0, -1, 0, PI/8, 10);
    pushMatrix();
    translate(width/2, height/2, 0);
    fill(#6be758);
    sphere(dia);
    popMatrix();
    if (swift == false) {
    //myPort.clear();
    //myPort.stop();
    //String portName = Serial.list()[4];
    //myPort = new Serial(this, portName, 115200);
    swift = true;
    println("Swift to stroke");
    println("swift "+swift);
    }
  }
  if ((Position >= 79.736) && (Position < 79.8)) {
    if (swift == true) {
      //myPort.write(7);//comment out if vest not attached
      swift = false;
    } else {
    }
  }
  if ((Position >= 79.8) && (Position < 84.0)) {
      background(25, 28, 26); 
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
      rectMode(CENTER);
      noStroke();
      fill(#6be758);
      lights();
      sphere(dia);
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
  if ((Position >= 84.0) && (Position < 85.0)) {
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
  if ((Position >= 103.671) && (Position < 103.8)) {
  
    if (swift == true) {
      rainStart = false;
    
      sampleSingIlomilo.play();
      sampleSingIlomilo.rate(1.1);
      swift = false;
      //println("file # " +frameCount%7);
      println("Sing");
    } else {
    }
  }
  if ((Position >= 103.8)) {
    if (SingbeatDetector.isBeat()) {
      //myPort.write(8);//comment out if vest not attached
      //println("8");
      if(Position > 110){
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
      }
    } else {
    }
  }
  //if (Position >= 204.0) {
  //  if (!sampleSingIlomilo.isPlaying()) {
  //    myPort.clear();//comment out if vest not attached
  //    myPort.stop();//comment out if vest not attached
  //  } else {
  //  }
  //} else {
  //}
}//end Play Sound Files
