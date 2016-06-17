//using code from Robert Zacharias <rz@rzach.me>
//https://github.com/robzach/drawingWithHeart/blob/master/drawingWithHeart.pde

//UNITS: 
//   1 = 1/1000 of an inch
//   10 = 1/100 of an inch

//Press 's' to start or stop scribbling


import processing.serial.*;
Serial plotterPort; // to talk to US Cutter MH871-MK2

long timer;
int wait = 20; // milliseconds between sending commands to plotter. Works fine for short distances between points.

//coordinate variables
int sheetHeight = 23000; //23000 = 23", so fits a 24" sheet of paper
int y=0;
Boolean drawOnPlot=true; //plotter will begin drawing immediately;
float amplitude = 500;
long rowNumber = 0;

void setup() {
  //println(Serial.list()); // for finding serial devices' names. Can also look in /dev/tty.*
  String serialPort = "/dev/tty.KeySerial1"; // fixed alias for US Cutter MH871-MK2 via Keyspan USA-19HS serial adapter
  plotterPort = new Serial(this, serialPort, 19200); // set this speed on the plotter's interface!
  println("plotterPort = " + plotterPort); // diagnostic, to confirm connection

  plotterPort.write("IN;PU;PA0,0;"); // start communication, go to home position 
  plotterPort.write("PD"); // put down pen
  println("homed");
  timer = millis();
}

void draw() {
  // block below is activated only when drawOnPlot is true (see keyPressed section)
  if ( y < sheetHeight && drawOnPlot) { // don't run off the edge of the paper
    if (millis() - timer > wait ) {
      float t = millis()/1000.0;
      float x = amplitude*noise(t);
      y += 10; // move 1/100 of an inch down the value
      long xWithRow = int(x  + (amplitude * rowNumber));
      String message = "PA" + xWithRow + "," + y + ";";
      plotterPort.write(message);
      timer = millis();
      //println(xWithRow + ", " + y);
    }
  } else if (y >= sheetHeight && drawOnPlot) {
    rowNumber++; // move one row up
    float xRowDisplacement = (amplitude * rowNumber);
    plotterPort.write("PU;PA" + xRowDisplacement + ",0;");
    delay(2000); // give it time to get back to the start of the row;
    plotterPort.write("PD");
    y = 0;
  } else {
    plotterPort.write("PA0,0;");//home again
  }
}

// keyboard commands
void keyPressed() {
  if (key == 'q') {
    drawOnPlot = !drawOnPlot;
    if (drawOnPlot == true) plotterPort.write("PD;");
    else plotterPort.write("PU;");
  }
}