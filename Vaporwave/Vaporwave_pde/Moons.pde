class Moon {
  int w;
  int nature;
  float moonSpeed;


  Moon (int size) {
    nature = (int)random(-5, 5);
    moonSpeed = random(1, 10);
    fill(200, 150, 100);
    sphere(size);
    
  }
}
