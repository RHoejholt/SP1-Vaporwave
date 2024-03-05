
class Clouds{
  int startX;
  float cloudSpeed;
  int t = 0;
  int size;
  int cloudHeight;
  color cloudColor = color(200, 150, 250);

  Clouds () {
    startX = (int)random(0, 1200);
    size = (int)random(10, 40);
    cloudSpeed = random(-5, 5);
    cloudHeight = (int)random(0, 150);
  }

  void drawClouds () {
    if(t+startX>1220 || t+startX<0){
    cloudSpeed*=-1;
    }
    
    if(mousePressed){
      t += cloudSpeed*5;
    } else {
    t += cloudSpeed;
    }
    
    stroke(cloudColor);
    fill(cloudColor);  
    ellipse(width*0.2, centerY, 200, 200);
    ellipse(t, 200, size, size);
  }
  
}
