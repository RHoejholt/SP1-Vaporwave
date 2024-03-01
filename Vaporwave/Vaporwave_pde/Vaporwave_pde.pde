//todo:
//clean up code
//adaptive to window size
//moon + cloud behavior and array


int centerY, centerX;

// set vertex scale

int scl = 15;
int cols, rows;
int w, h;


float hillHeight;
float moving = 0;

float [][] landscape;

Moon m1;
Moon m2;

void setup() {
  w = 1200;
  h = 3000;
  cols = w/scl;
  rows = h/scl;




  size(1000, 600, P3D);
  centerY = height/2;
  centerX = width/2;

  //create moon objects
  m1 = new Moon(25);
  m2 = new Moon(45);

  landscape = new float[cols][rows];
}
void draw () {

  // Clear the background with a color
  background(255);

  lights();

  drawSky();

  //Draw the ground

  // drawGradient(height/1.5, height, 40, 24, 80, 80, 85, 180 );



  // moving sets the speed

  moving -= 0.008;

  // magnitude of hills

  hillHeight = 10;

  // perlin noise map generation

  float yoff = moving;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x< cols; x++) {
      if ( x < 37) {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, 0, hillHeight *(38-x));
      } else if ( x > 43) {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, hillHeight *(-43+x), 0);
      } else {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, 0, 0);
      }
      xoff += 0.1;
    }
    yoff += 0.1;
    // hold to speed up
    if (mousePressed) {
      moving -= 0.001;
      fill(255);
      triangle(width-50, 50, width-50, 90, width-30, 70);
      triangle(width-80, 50, width-80, 90, width-60, 70);
    }
  }
  drawClouds();
  translate(width/2, height/2);
  rotateX(PI/2.5);

  //Draw the grid

  drawGrid();

  // draw the moons

  m1.drawMoon();
  m2.drawMoon();
}

void drawSky() {

  //define the start and end colors of the sky

  color startColor = color(40, 24, 80);
  color endColor = color(240, 85, 100);

  drawGradient(0, height, startColor, endColor);

  //Draw the sun

  shapeMode(CENTER);
  fill(255, 200, 150);
  ellipse(centerX, centerY-160, 200, 200);

  //Draw the lines covering the sun

  drawGradientLines(0, height, startColor, endColor);
}
void drawGradient (float startY, float endY, color colorStart, color colorEnd) {
  for (int y = int(startY); y < 20*int(endY); y++) {
    float inter = map(y, startY, endY*10, 0, 1);
    color c = lerpColor(colorStart, colorEnd, inter);
    stroke(c);
    line(-82110, 11111+y, 5*width, y+500, -1000, -1000);
  }
}
void drawGradientLines (float startY, float endY, color colorStart, color colorEnd) {
  for (int y = 0; y < height/1.5; y++) {
    if (y > centerY+20 && y<centerY+45 || y > centerY+55 && y<centerY+75 ||  y > centerY+80 && y<centerY+95 || y > centerY+100 && y<centerY+102) {
      float inter = map(y, startY-20, endY-170, 0, 1);
      color c = lerpColor(colorStart, colorEnd, inter);
      stroke(c);
      line(390, y-200, width-390, y-200);
    }
  }
}



void drawGrid() {
  translate(-w/2, -h/2 +350, -70);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x< cols; x++) {
      stroke(100, 100, 250);
      fill(40, 20, 120);
      vertex(x*scl, y*scl, landscape[x][y]);
      vertex(x*scl, (1+y)*scl, landscape[x][y+1]);
      //rect(x * scl, y * scl, scl, scl);
    }
    endShape();
  }
}




void  drawClouds() {
  fill(255);
  ellipse(width*0.2, centerY, 200, 200);
}
