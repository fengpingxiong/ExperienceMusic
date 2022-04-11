class Circle {
  int c1 = 0;
  int c2 = -40;
  float c3 = 50;
  float c4 = 50;
  Circle(int tc1, int tc2, float tc3, float tc4) {
    c1 = tc1;
    c2 = tc2;
    c3 = tc3;
    c4 = tc4;
  }
  void display()
  {
    ellipse(c1, c2, c3, c4);
  }
}
