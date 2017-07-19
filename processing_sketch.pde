  /*
   Saving Values from Arduino to "file.csv " File Using Processing

   This sketch provides a basic framework to read data from Arduino over the serial port and save it to .csv file on your computer.
   The .csv file will be saved in the same folder as your Processing sketch.

   This sketch takes advantage of Processing 2.0's built-in Table class.

   Each reading will have it's own row and timestamp in the resulting csv file. This sketch will write a new file a set number of times. Each file will contain all records from the beginning of the sketch's run.  

   This is a beginning level sketch.

   The hardware:
   * Sensors connected to Arduino input pins
   * Arduino connected to computer via USB cord

   The software:
   *Arduino programmer
   *Processing (download the Processing software here: https://www.processing.org/download/
   */

  import processing.serial.*;
  Serial myPort; //creates a software serial port on which you will listen to Arduino
  Table dataTable; //dataTable where we will read in and store values. You can name it something more creative!

  int numReadings = 15; //keeps track of how many readings you'd like to take before writing the file. 
  int readingCounter = 0; //counts each reading to compare to numReadings. 
  String fileName;

  void setup()
  {
    dataTable = new Table();
    String portName = Serial.list()[0]; //CAUTION: your Arduino port number is probably different! Mine happened to be 0.
    
    myPort = new Serial(this, portName, 9600); //set up your port to listen to the serial port

    //the following adds column for the time. 
    dataTable.addColumn("Time");

    //the following is a dummy column for the data values. Customize the name as needed.
    dataTable.addColumn("Temperature");
  }

  void serialEvent(Serial myPort) {
    String data = myPort.readStringUntil('\n'); //The newline separator separates each Arduino loop. We will parse the data by each newline separator. 
    
    if (data!= null) { //We have a reading! Record it.
      data = trim(data); //gets rid of any whitespace or Unicode nonbreakable space
      println(data); //Optional, useful for debugging. If you see this, you know data is being sent. You can delete it if  you like. 

      float sensorVals = float(data); // Convert the String to float 

      TableRow newRow = dataTable.addRow(); //add a row for this new reading

      //record time stamp HH:mm
      newRow.setString("Time", hour() + ":" + minute());

      //record sensor information. Customize the name so it match your sensor column name. 
      newRow.setFloat("Temperature", sensorVals);

      readingCounter++; //optional, use if you'd like to write your file every numReadings reading cycles

      //saves the dataTable as a csv in the same folder as the sketch every numReadings. 
      if (readingCounter % numReadings ==0)//The % is a modulus, a math operator that signifies remainder after division. The if statement checks if readingCounter is a multiple of numReadings (the remainder of readingCounter/numReadings is 0)
      {
        saveTable(dataTable, "file"); //Woo! save it to your computer. It is ready for all your spreadsheet dreams.
        println("Records saved.");  
      }
    }
  }

  void draw()
  { 
    //visualize your sensor data in real time here!
  }
