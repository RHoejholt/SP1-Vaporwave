class Moon {
  int w;
  int nature;
  float moonSpeed;
  int t = 0;
  int size;

  Moon (int size) {

    // set new position for moons
    this.size = size;
    nature = (int)random(-5, 5);
    moonSpeed = random(1, 10);
  }


  void drawMoon () {
    pushMatrix();
    translate(t, 1000, 240);
    t += moonSpeed;

    fill(200, 150, 100);
    sphere(size);
    popMatrix();
  }
}
