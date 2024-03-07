class Moon {
  int startX;
  float moonSpeed;
  int t = 0;
  int size;
  int moonHeight;
  //set the color of the moon, both its fill and stroke
  color moonColor = color(150, 100, 250);

  Moon () {
    // the starting position, size and speed are each generated randomly for each new moon, inside the constructor
    startX = (int)random(0, width*1.22);
    size = (int)random(10, 40);
    moonSpeed = random(-5, 5);
    moonHeight = (int)random(0, height/4);
  }
  
  //function to draw the moons as spheres
  void drawMoon () {
    //pushmatrix saves the current camera position
    pushMatrix();
    //make them bounce on the edges by reversing their speed whenever they get out of bounds.
    if(t+startX>width*1.22 || t+startX<0){
    moonSpeed*=-1;
    }
    //move the camera position slightly before drawing each moon, simluating movement
    translate(t+startX, 1100, 180+moonHeight);
    
    //multiply the moon speed by 5, to compliment the fast forward function for the landscape.
    if(mousePressed){
      t += moonSpeed*5;
    } else {
    t += moonSpeed;
    }
    
    stroke(moonColor);
    fill(moonColor);
    sphere(size);
    //popmatrix will reset the camera position after the moon is drawn, this avoid messing everything else up with the contantly changing camera
    //yes, there is no better way to do this in processing. i looked.
    popMatrix();
  }
}
