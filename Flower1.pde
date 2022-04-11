class Flower1 {
  float centerX;
  float centerY;
  float posX;
  float posY;
  float maxSize = 65;
  float maxFactor = 40;
  float sizes = 0;
  float factor = 0;
  float speed = 0.08;
  Flower1() {
  }
  Flower1(float _centerX, float _centerY)
  {
    centerX = _centerX;
    centerY = _centerY;
  }
  void setCenter(float x, float y)
  {
    centerX = x;
    centerY = y;
  }
  void display()
  {
    for (int i = -18; i < 360; i+=72)
    {
      posX = centerX + cos(radians(i)) * factor;
      posY = centerY + sin(radians(i)) * factor;
      noStroke();
      //fill(170, 14, 24); // blue
      fill(#BB86EE);//purple
      ellipse(posX, posY, sizes, sizes);
    }
    //fill(14, 17, 170);
    
    fill(#E13F88);
    ellipse(centerX, centerY, sizes, sizes );
  }
  void grow()
  {
    factor = (factor < maxFactor )?  factor + speed: maxFactor;
    sizes = (sizes < maxSize )?  sizes + speed*1.3 : maxSize;
  }
}// end of Flower1
