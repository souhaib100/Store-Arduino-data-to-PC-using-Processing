/*
  Sending Data to Processing via the Serial Port
*/

const int sensor = A0; //Assigning analog pin A0 to variable 'sensor'
const int second = 1000;
const int delayRead = 60 * second; //delay before read the temperature from the sensor in second 
									//in this example 60 seconds (1 minute)
const int readsBeforeSend = 10; //number of reads before sending data
								// in this example we read every 1 minute, so we will send the data every 10 minutes  
float tmpTemp; //temporary variable to hold sensor reading
float tempSum; //variable to store the sum of temperatures in degree Celsius
  
void setup() {
  pinMode(sensor, INPUT); // Configuring pin A0 as input
  Serial.begin(9600); //This line tells the Serial port to begin communicating at 9600 bauds
}

//
void loop() {
  tempSum = 0;
  for (int i = 0; i < readsBeforeSend; i++) {
    //getting the voltage reading from the temperature sensor
    tmpTemp = analogRead(sensor);    
   
    // converting that reading to voltage
   	tmpTemp = tmpTemp * 5.0;
   	tmpTemp /= 1024.0; 

   	tmpTemp = (tmpTemp - 0.5) * 100 ;  //converting from 10 mv per degree with 500 mV offset
                                       //to degrees ((voltage - 500mV) times 100)
   
    tempSum = tempSum + tmpTemp; //Add the corrunt read to the sum variable
    
   	delay(delayRead); //delay before the next read
  }

  //print over the serial line to send to Processing. 
  Serial.println(tempSum/readsBeforeSend);
}
