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
  fill(random(50, 250));
  text(wordsStronger[int(random(wordsStronger.length))], wordX, strongerY);//strongerY+350
  text(wordsStronger[int(random(wordsStronger.length))], wordX+100, strongerY+200);//wordX+250,strongerY+200
  text(wordsStronger[int(random(wordsStronger.length))], wordX+200, strongerY+400);//wordX+500, strongerY+500
  //println(wordsStronger.length);
  //println(index);
  //index++;
  //if (index == ) {
  //  index = 0;
  //} else {
    //index++;
  //}
if(frameCount%9==1){
  wordX = random(0, width);//width*.2, width
  strongerY = random(0, height*.6);//height*.2, height*.8
}
if(frameCount%7==2){
  wordX = random(0, width);
  strongerY = random(0, height*.8);
}
if(frameCount%8==7){
  wordX = random(0, width);
  strongerY = random(0, height*.8);
}

}
