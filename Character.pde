class Char {

  char theChar;
  int x, y;

  Char(int tempX, int tempY) {
    x=tempX;
    y=tempY;
    getRandomChar();
  }

  void show() {
    text(theChar, x, y);
  }

  void getRandomChar() {
    //int [] charPick = {10061, 9891, 9899};
    //int rndChar = int(random(charPick.length));
    int charType = round(random(4));
    if (charType ==0 || charType == 4) {
      //int rndChar = round(random(48, 90));
            int rndChar = round(random(9898,9899));
      theChar = char(rndChar);
    } 
    else if (charType==1) {
                  
      //int rndChar = round(random(12449, 12615));
      theChar = char(10061);
    }
    else if(charType ==2){
    int rndChar = round(random(48,90));
    theChar = char(rndChar);
    }
    else if(charType ==3){
    int rndChar = round(random(12449,12615));
    theChar = char(rndChar);
    }
  }
}
