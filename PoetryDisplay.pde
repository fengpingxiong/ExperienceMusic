void displayPoetry() {
  background(0);
  int alpha = 1;
  noStroke();

  image(woman, -50, -50, displayWidth*.3, displayWidth*.45);
  image(brave, displayWidth*.9, 0, displayWidth*.3, displayWidth*.6);
  image(sinful, displayWidth*.36, -10, displayWidth*.34, displayWidth*.34);
  image(rise, displayWidth*.1, displayHeight*.36, displayWidth*.25, displayWidth*.5);
  image(her, displayWidth*.65, displayHeight*.3, displayWidth*.25, displayWidth*.25);
  image(body, displayWidth*.36, displayHeight*.4, displayWidth*.4, displayWidth*.4);

  alpha--;

  fill(bg, lighten);
  //rectMode(CORNER);
  rect(0, 0, displayWidth, displayHeight);
  if (Position > 100) {
    rainStart=false;
  }
}

void wordDraw() {
  fill(random(150, 250));
  text(wordsStronger[int(random(wordsStronger.length))], wordX, strongerY);
  text(wordsStronger[int(random(wordsStronger.length))], wordX+250, strongerY);
  text(wordsStronger[int(random(wordsStronger.length))], wordX+500, strongerY);
  //println(wordsStronger.length);
  //println(index);
  //index++;
  //if (index == ) {
  //  index = 0;
  //} else {
    //index++;
  //}
if(frameCount%9==1){
  wordX = random(width*.5, width);
  strongerY = random(height*.2, height*.8);
}
}
