//  please feel free to open up an RGB color picker to play around with all the colors here, and at the top of the Moons class.
//  hold down mouse1 to fast forward!

  //set the starting color and end color of the background gradient
color startColor = color(225, 24, 200);
color endColor = color(0, 185, 230);

  //set the colors of the landscape grid.
color gridFill = color(80, 20, 120);
color gridStroke = color(100, 100, 250);

  //set the color of the sun
color sunColor = color(255, 245, 190);

  // set vertex scale of the landscape
int scl = 15;

int centerY, centerX;
int cols, rows;
int w, h;
float sunRadius = 100;
float hillHeight;
float moving = 0;

float [][] landscape;

  // create moons array, and decide the amount of moons
Moon [] moons = new Moon[16];

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
  drawGradient(1700, height, startColor, endColor);

  drawSun();
}
void drawGradient (float startY, float endY, color colorStart, color colorEnd) {

  // loops, drawing a line at each y coordiante, since there is no way to outright draw gradients within processing.
  for (int y = int(startY); y < 20*int(endY); y++) {

    // maps y's position within startY and endY within a range of 0-1
    float inter = map(y, startY, endY*10, 0, 1);

    // interpolates the color values relative to the mapped "inter", which is shwoing how far we are between startX and startY, helping us in picking a corresponding color
    color c = lerpColor(colorStart, colorEnd, inter);
    stroke(c);

    // the values here are bit high since we need it far into the background.
    line(-82110, 11111+y, 5*width, y+900, -1000, -1000);
  }
}

void drawSun() {
  shapeMode(CENTER);
  stroke(sunColor);
  
    // to see the background through the sun in horizontal lines, and without having to panstakenly draw parts of the background on top of the sun, we instead draw it line by line in a for loop
    // we can calculate the x coordinates of the startng and ending point with some clever use of maths: 
    // 1. y - centerY calculates the vertical distance from the center
    // 2. then we square the circle's radius
    // 3. then we square the vertical distance, and subtract it from the square of the circle's radius. the result is the distance from the center to the start/endpoint, squared
    // 4. we take the square root of that value, giving us the actual distance, essentially undoing the two square-operations we did before.
    // 5. we add/subtract this result from the center to get the end/startpoint.
    // 6. draw the line :)!
  for (int y = int(centerY - sunRadius); y <= centerY + sunRadius; y++) {
    if (!(y > centerY+35 && y<centerY+45 || y > centerY+60 && y<centerY+75 ||  y > centerY+80 && y<centerY+95 || y > centerY+100 && y<centerY+102)) {
      float x1 = centerX - sqrt(sq(sunRadius) - sq(y - centerY));
      float x2 = centerX + sqrt(sq(sunRadius) - sq(y - centerY));
      line(x1, y-170, x2, y-170);
    }
  }
}

void generateNoiseMap() {
  // "moving" sets the speed of the landscape

  moving -= 0.008;

  // magnitude of hills

  hillHeight = 10;

  // perlin noise map generation. perlin noise is preffered over purely random values because there is less chaos, in perlin noise maps, adjacent values are near eachother, which makes them great for simulating landscapes.
  // xoff and yoff help set the offset on the noise map. if there wasn no increasing offset to the the vertex's "linked" Z coordinate, the landscape would not simulate movement. yoff is multiplied by "moving", allowing us to  
  // control the speed of the y axis movement.
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
      stroke(gridStroke);
      fill(gridFill);
      vertex(x*scl, y*scl, landscape[x][y]);
      vertex(x*scl, (1+y)*scl, landscape[x][y+1]);
    }
    endShape();
  }
}
