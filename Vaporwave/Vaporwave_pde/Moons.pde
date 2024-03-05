class Moon {
  int startX;
  float moonSpeed;
  int t = 0;
  int size;
  int moonHeight;
  color moonColor = color(150, 100, 250);

  Moon () {
    startX = (int)random(0, 1200);
    size = (int)random(10, 40);
    moonSpeed = random(-5, 5);
    moonHeight = (int)random(0, 150);
  }

  void drawMoon () {
    pushMatrix();
    if(t+startX>1220 || t+startX<0){
    moonSpeed*=-1;
    }
    translate(t+startX, 1100, 180+moonHeight);
    
    if(mousePressed){
      t += moonSpeed*5;
    } else {
    t += moonSpeed;
    }
    
    stroke(moonColor);
    fill(moonColor);
    sphere(size);
    popMatrix();
  }
}
