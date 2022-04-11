void displayPoetry(){
background(0);
    image(woman, -50, -50, displayWidth*.3, displayWidth*.45);
    image(brave, displayWidth*.36, -10, displayWidth*.3, displayWidth*.6);
    image(sinful, displayWidth*.66, 0, displayWidth*.34, displayWidth*.34);
    image(rise, displayWidth*.1, displayHeight*.36, displayWidth*.25, displayWidth*.5);
    image(her, displayWidth*.6, 430, displayWidth*.25,  displayWidth*.25);
    image(body, displayWidth*.8, displayHeight*.4, displayWidth*.4, displayWidth*.4);


    fill(bg, lighten);
    rect(0, 0, width, height);
    if(Position > 100){
    rainStart=false;
  }


}
