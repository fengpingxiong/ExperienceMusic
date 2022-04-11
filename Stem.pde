class Stem {
  int initalloX=0;
  int initalloY=0;
  Stem(int tempInitalloX, int tempInitalloY) {
    initalloX = tempInitalloX;
    initalloY = tempInitalloY;
  }
  void drawStem() {
    //background(#0DBADB);
    scale(scaleFactor, scaleFactor);
    //stroke (12, 149, 11);
    stroke(#279A8B);//green
    //fill (12, 149, 11);
    fill(#279A8B);//green
    strokeWeight(10);
    //line(initalloX, initalloY, initalloX, ((myCountForGrow>250)?initalloY-500:initalloY-(2*myCountForGrow)));
    /*
    if (myCountForGrow>250)
     line(initalloX, initalloY, initalloX, (initalloY-500));
     else
     line(initalloX, initalloY, initalloX, (initalloY-(2*myCountForGrow)));
     */
    line(initalloX, initalloY, initalloX, (initalloY-(myCountForGrow)));
    //stem1
    if (myCountForGrow>101) {
      noStroke();
      translate(initalloX, initalloY-myCountForGrow*.53);
      scale(min((float)(myCountForGrow-100)/100, 1), min((float)(myCountForGrow-100)/100, 1));
      beginShape();
      vertex(0, 0);
      // leaf left
      bezierVertex(-40, -5, -30, -40, -80, -20);
      bezierVertex(-47, -16, -52, 8, 0, 0);
      endShape(CLOSE);
      scale(1/min((float)(myCountForGrow-100)/100, 1), 1/min((float)(myCountForGrow-100)/100, 1));
      translate(-initalloX, -(initalloY-myCountForGrow*.53));
      noStroke();
    }
    //stem2
    if (myCountForGrow>151) {
      //  noStroke();
      translate(initalloX, initalloY-myCountForGrow*.26-30);
      scale(-min((float)(myCountForGrow-110)/150, 1), min((float)(myCountForGrow-110)/150, 1));
      beginShape();
      vertex(0, 0);
      // leaf right
      bezierVertex(-40, -5, -30, -40, -80, -20);
      bezierVertex(-47, -16, -52, 8, 0, 0);
      endShape(CLOSE);
      scale(-1/min((float)(myCountForGrow-110)/150, 1), 1/min((float)(myCountForGrow-110)/150, 1));
      translate(-initalloX, -(initalloY-myCountForGrow*.26-30));
    }
  }
}
