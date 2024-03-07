//todo:
//clean up code
//adaptive to window size

int centerY, centerX;

// set vertex scale of the landscape

int scl = 15;

int cols, rows;
int w, h;
float hillHeight;
float moving = 0;

float [][] landscape;

Moon [] moons = new Moon[10];

void setup() {
  size(1000, 600, P3D);
  centerY = height/2;
  centerX = width/2;

  //The height, width and number of rows and columns on the grid is dependant on the window size
  w = (int)(width*1.2);
  h =  (int)(height*5);
  cols = w/scl;
  rows = h/scl;

  //create moon objects
  for (int i = 0; i < moons.length; i++) {
    moons[i] = new Moon();
  }
  
  //Creating the right amount of indexes for the columns and rows for the landscape grid
  landscape = new float[cols][rows];
}
void draw () {

  // Clear the background with a color
  background(255);

  //Lights are required to make the spheres look 3d
  lights();

  drawSky();


  //rotate the camera to tilt the landscape
  translate(width/2, height/2);
  rotateX(PI/2.5);

  //generate the perlin noise map that with determine the Z coordiantes for each corner in the landscape grid
  generateNoiseMap();

  drawGrid();

  for (Moon m : moons) {
    m.drawMoon();
  }
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




void generateNoiseMap(){
  // "moving" sets the speed of the landscape

  moving -= 0.008;

  // magnitude of hills

  hillHeight = 10;

  // perlin noise map generation. perlin noise is preffered over purely random values because there is less chaos, in perlin noise maps, adjacent values are near eachother, which makes them great for simulating landscapes.
  // xoff and yoff help set the offset on the noise map. if there wasn no increasing offset to the the vertex's "linked" Z coordinate, the landscape would not simulate movement. yoff is multiplied by "moving", allowing us to control the speed of the y axis movement.
  // now, we can use a nested for loop to determine Z values for the grid in each draw iteration.
  float yoff = moving;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x< cols; x++) {
      // a triple conditional is used to divide the landscape into a left, right and center part, where hillHeight is tied to different values.
      if ( x < 37) {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, 0, hillHeight *(38-x));
      } else if ( x > 43) {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, hillHeight *(-43+x), 0);
      } else {
        landscape [x] [y] = map(noise(xoff, yoff), 0, 1, 0, 0);
      }
      // the offsets will increase in each loop to make sure the entire grid is not tied to the same Z value
      xoff += 0.1;
    }
    yoff += 0.1;
    // hold to speed up, draws two triangles to show a fast forward effect.
    if (mousePressed) {
      moving -= 0.001;
      fill(255);
      triangle(width-50, 50, width-50, 90, width-30, 70);
      triangle(width-80, 50, width-80, 90, width-60, 70);
    }
  }
}

  // the drawGrid function will draw the grid, using the Z values generated from the generateNoiseMap() function.
void drawGrid() {
  translate(-w/2, -h/2 +350, -70);
  for (int y = 0; y < rows-1; y++) {
    // we draw a triangle vertex, using the unchanging values for x and y, and the changing Z values from the landscape double array.
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x< cols; x++) {
      stroke(100, 100, 250);
      fill(40, 20, 120);
      vertex(x*scl, y*scl, landscape[x][y]);
      vertex(x*scl, (1+y)*scl, landscape[x][y+1]);
    }
    endShape();
  }
}
