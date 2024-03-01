class Moon {
  int nature;
  float moonSpeed;
  int t = 0;
  int size;

  Moon () {
    size = (int)random(10, 80);
    nature = (int)random(-5, 5);
    moonSpeed = random(1, 10);
  }

  void drawMoon () {
    pushMatrix();
    if(t>1220 || t<0){
    moonSpeed*=-1;
    }
    translate(t, 1000, 240);
    t += moonSpeed;
    fill(200, 150, 100);
    sphere(size);
    popMatrix();
  }
}
