//using code from Robert Zacharias <rz@rzach.me>
//https://github.com/robzach/drawingWithHeart/blob/master/drawingWithHeart.pde

//UNITS: 
//   1 = 1/1000 of an inch
//   10 = 1/100 of an inch

//pen arm controls y direction
//rollers control x direction
//ie with a roll of paper, the x direction is much greater 


//Press 'q' to quit plotter drawOnPlotter


import processing.serial.*;
Serial plotterPort; // to talk to US Cutter MH871-MK2

long timer;
int wait = 20; // milliseconds between sending commands to plotter. Works fine for short distances between points.

//coordinate variables
//23000 = 23", so fits a 24" sheet of paper
int sheetH = 23000/16;//1.5"
int sheetW = 23000/8;//3"
Boolean drawOnPlot=false; //plotter will begin drawing when choose lissajous;

//lissajous variables and constants;
int nPoints; 
float offsetxScreen, offsetyScreen; 
float radiusx; 
float radiusy;
float A; 
float B;
float phiA; 
float phiB; 
int closeGap;

float[] ljxScreen, ljyScreen;
float[] ljxPlot, ljyPlot;

int index = 1;

void setup() {
  size(800, 400);
  
  //change these lissajous constants as you like
  nPoints = 360; 
  radiusx = 150; 
  radiusy = 150;//must be less than sheetH/2;
  A = 2.0; 
  B = 7.0;
  offsetxScreen = width/2;
  offsetyScreen = height/2;
  
  closeGap = 1;
  if (A%2==1 || B%2==1) closeGap++;
  ljxScreen = new float[nPoints+closeGap+1];
  ljyScreen = new float[nPoints+closeGap+1];
  ljxPlot = new float[nPoints+closeGap+1];
  ljyPlot = new float[nPoints+closeGap+1];
  
  //println(Serial.list()); // for finding serial devices' names. Can also look in /dev/tty.*
  String serialPort = "/dev/tty.KeySerial1"; // fixed alias for US Cutter MH871-MK2 via Keyspan USA-19HS serial adapter
  plotterPort = new Serial(this, serialPort, 19200); // set this speed on the plotter's interface!
  println("plotterPort = " + plotterPort); // diagnostic, to confirm connection

  plotterPort.write("IN;PU;PA0,0;"); // start communication, go to home position 
  println("homed");
  timer = millis();
}

void draw() {  
  if (!drawOnPlot){
    drawOnScreen();
  }else{
    stroke(255, 0, 0);
    drawOnPlotter();
    //drawOnPlotterTest();
  }
  
}

//animation of lissajous figures controlled by mouse position
//Tool to decide which lissajous figure to plot
//click to select
void drawOnScreen() {
  background(255); 
  noFill(); 
  stroke(0); 
  
  phiA = mouseX/100.0; 
  phiB = mouseY/100.0; 
  
  beginShape();
  for (int i=0; i<=nPoints+closeGap; i++) {
    float t = map(i, 0, nPoints, 0, TWO_PI); 
    float x = offsetxScreen + radiusx * cos(phiA + A*t); 
    float y = offsetyScreen + radiusy * sin(phiB + B*t); 
    if ((i> 0) && (i%2 == 0)) {
      vertex (x, y);
    }
  }
  endShape();
}

//at each time intervals designated by wait, draws next segment on plotter
void drawOnPlotter() {
  if (index>nPoints+closeGap) {//if finished drawing
    print("Done.");
    drawOnPlot = false;
    plotterPort.write("PU;");
    plotterPort.write("PA0,0;");//home again
  }else if ((millis()-timer > wait)) {
      //drawOnPlot with the plotter
    if ((index> 0) && (index%2 == 0)) {
      long x = int(ljxPlot[index]);
      float y = ljyPlot[index];
      String message = "PA" + x + "," + y + ";";
      //println(message);
      plotterPort.write(message);
    }
    timer = millis();
    index++;
  } 
}

//to test on screen what vertices the plotter will draw lines through
void drawOnPlotterTest() {
  if (index>nPoints) {//if finished drawing
    print("Done.");
    drawOnPlot = false;
    print("PU;");
    println("PA0,0;");//home again
  }else if ((millis()-timer > wait)) {
      //drawOnPlot with the plotter
    if ((index> 0) && (index%2 == 0)) {
      float x = int(ljxScreen[index]);
      float y = ljyScreen[index];
      ellipse(x,y, 3, 3);//imitates plotterPort.write(message);
    }

    timer = millis();
    index++;
  } 
}

// keyboard commands
void keyPressed() {
  if (key == 'q') { // press q to quit the plotter drawing
    drawOnPlot = false;
    plotterPort.write("PU;");
    plotterPort.write("PA0,0;");//home again
  }
}

//click to select the shape you desire and start the plotter
void mouseClicked() {
  println("shape selected");
  createPointArray();
  println("point array ready");
  drawOnPlot = true;
  String message = "PA" + ljxPlot[0] + "," + ljyPlot[0] + ";";
  plotterPort.write(message);
  plotterPort.write("PD;");
}

//collect vertices to draw on the plotter
void createPointArray() {

  //first collect points on screen
  for (int i=0; i<=nPoints+closeGap; i++) {
    float t = map(i, 0, nPoints, 0, TWO_PI); 
    float x = offsetxScreen + radiusx * cos(phiA + A*t);
    float y = offsetyScreen + radiusy * sin(phiB + B*t);
    ljxScreen[i] = x;
    ljyScreen[i] = y;
    vertex(x,y);
  }
  
  mapPointsScreenToPlot();
}


//The screen and the plotter are of different scales
void mapPointsScreenToPlot(){
  for (int i=0; i<=nPoints+closeGap; i++) {
    ljxPlot[i] = map(ljxScreen[i], 0, width, 0, sheetW);
    ljyPlot[i] = map(ljyScreen[i], 0, height, 0, sheetH);
  }
}