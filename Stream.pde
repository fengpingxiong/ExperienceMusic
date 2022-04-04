class Stream {
  ArrayList<Char> chars;
  int numChar;
  int speed;
  color col;
  
  Stream(int tempX) {
    chars = new ArrayList<Char>();
    numChar = round(random(10, 30));
    speed = round(random(10, 30));
    for ( int y = 0; y < numChar*fontInc; y+=fontInc) {
      chars.add(new Char(tempX, y-400));
    }
    col = cols[(int)random(cols.length)];
  }

  void update() {

    for (int i = 0; i < chars.size(); i++) {
      //color them green
      float alpha = map(i, 0, chars.size()-1, 0, 255);
      fill(col,alpha);
      //fill(0, 250, 80, alpha);
      if (i==chars.size()-1) {
        //color the last one white
        fill(250, 255, 250);
      }
      chars.get(i).show();

      //move characters
      if (frameCount % speed == 0) {
        chars.get(i).y += fontInc;
        //change the random char
        if (i==chars.size()-1) {
          chars.get(i).getRandomChar();
        } else {
          chars.get(i).theChar = chars.get(i+1).theChar;
        }
      }
      if (random(1) < 0.01) {
        chars.get(i).getRandomChar();
      }
      if (chars.get(0).y > height) {
        for (int j = 0; j < chars.size(); j++) {
          chars.get(j).y =((chars.size()-1)-j)*-20;
        }
      }
    }
  }
}
