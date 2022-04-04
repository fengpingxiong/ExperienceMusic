class Flower {
  int len;
  String s;
  PVector[] pos;
  float[] radii;

  float slice, cx, cy;
  float rAngle, rSpeed, rand;

  float minS = 0;
  float maxS = 255;
  float minR = 30;
  float maxR = 70;

  float size;
  color col;

  Flower (String _s, float _cx, float _cy) {
    s = _s;
    len = s.length();
    pos = new PVector[len];
    radii = new float[len];

    slice = radians(360/(float)len);

    cx = _cx;
    cy = _cy;

    init();

    rand = random(1);
    rAngle = random(TWO_PI);
    rSpeed = random(0.005, 0.025);

    size = random(0.25, 1);
    col = cols[(int)random(cols.length)];
  }
  
  //initialize values
  void init() {
    for (int i = 0; i < len; i++) {
      float angle = i * slice;
      radii[i] = byte(s.charAt(i));
      radii[i] = map(radii[i], minS, maxS, minR, maxR);

      float xpos = cos(angle) * radii[i];
      float ypos = sin(angle) * radii[i];
      pos[i] = new PVector(xpos, ypos);
    }
  }

  void style(boolean f) {
    if (f) {
      noStroke();
      fill(col);
    } else

    {
      noFill();
      strokeWeight(size);
      stroke(col);
    }
  }

  void display() {
    beginShape();
    curveVertex(pos[len-1].x, pos[len-1].y);

    for (int i = 0; i < len; i++ ) {
      char c = s.toLowerCase().charAt(0);
      switch (c) {
      case 'a' :
      case 'e' :
      case 'i' :
      case 'o' :
      case 'u' :
        style(true);
        break;

      default:
        style(false);
      }

      curveVertex(pos[i].x, pos[i].y);
    }
    curveVertex(pos[0].x, pos[0].y);
    curveVertex(pos[1].x, pos[1].y);
    endShape();
  }

  void update() {
    push();
    if (rand > 0.5 ) {
      rAngle +=rSpeed;
    } else {
      rAngle -= rSpeed;
    }
    translate(cx, cy);
    rotate(rAngle);
    display();
    pop();
  }
}

void flowerSetup() {
  //choose the poem/song file
  //lines = loadStrings(poem[fileCount % poem.length]);
  lines = loadStrings(poem[round(random(0, 7))]);
  flowers = new Flower[lines.length];
  float slice = radians(360/(float)lines.length);

  for (int i = 0; i < lines.length; i++) {
    float angle = i * slice;

    float radius = 500;
    int charCount = lines[i].length();
    if (charCount > 0 && charCount <=15) {
      radius = random((displayWidth/2-1000), (displayWidth/2 - 800));
    } else if (charCount > 15 && charCount <=30) {
      radius = random((displayWidth/2-800), (displayWidth/2 - 600));
    } else if (charCount > 30 && charCount <=45) {
      radius = random((displayWidth/2-600), (displayWidth/2 - 400));
    } else if (charCount > 45 && charCount <=70) {
      radius = random((displayWidth/2-400), (displayWidth/2 - 200));
    } else if (charCount > 70 && charCount <=100) {
      radius = random((displayWidth/2-200), (displayWidth/2));
    }

    //starting center position
    float xpos = width/2 + cos(angle) * radius;
    float ypos = height/2 + sin(angle) * radius;

    flowers[i] = new Flower(lines[i], xpos, ypos);
  }
}
