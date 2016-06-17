# MH871-MK2 Pen Plotting Templates
Basic templates for the US Cutter MH871-MK2 pen plotter, intended for Golan Levin's intermediate creative coding class' #plottertwitter project.

2016 [Johanna McAllister](https://github.com/sarjomac), et al.

The setup instructions for US Cutter MH871-MK2 pen plotter adapted from the directions of [Dan Moore](https://github.com/danzeeeman/ofxMH871)

#MH871-MK2

The MH871-MKII supports the HPGL (Hewlett-Packard Graphics Language) and uses a limited subset of the HPGL standard: 

1. Initialize the machine- IN;
2. Pen Up command - PU
2. Pen Down command - PD
3. Pen moves to x,y position, absolute from origin - PAx,y
4. Pen moves to x,y position, relative from current position - PRx,y

## HOW TO SETUP CONNECTION TO PLOTTER

### Connecting to the device

Please look in [/manuals](https://github.com/CreativeInquiry/-plottertwitter-Templates/tree/master/manuals) for the MH871 manual and how to setup the Mk2 on OSX.
* if you are using a Keyspan Adapter, [install the Keyspan driver](http://www.tripplite.com/support/downloads/tab/1/mid/USA19HS) for your adapter's specific model  

#### Connect to the MH871-MKII Pen Plotter via the COM port.  This will require a USB to Serial device.  

![COM PORT](/images/IMG_1608.JPG)
![USB To Serial](/images/IMG_1609.JPG)

#### Power on the Plotter

![POWER](/images/IMG_1610.JPG)

#### Press the Setup Button

![SELECT](/images/IMG_1624.JPG)

#### Change the Serial BaudRate to 19200

![BaudRate](/images/IMG_1625.JPG)

#### On your Mac or Linux Terminal

bash$ ls /dev/tty.*

####  Copy the name for your USB to Serial Device for when you setup the MH871 object
e.g. "/dev/tty.KeySerial1"

in ofx:

string serialPort = "PASTE SERIAL NAME HERE"
plotter.setup(serialPort)
in processing:

String serialPort = "PASTE SERIAL NAME HER";
plotterPort = new Serial(this, serialPort, 19200);

For ofx, download and use Dan Moore's [openFrameworks addon](https://github.com/danzeeeman/ofxMH871). Move it to your addon folder.
This addon drives the [MH871-MKII Pen Plotter and Vinyl Cutter](http://www.uscutter.com/USCutter-MH-Series-Vinyl-Cutter-w-VinylMaster-Cut-Design-Cut-Software)