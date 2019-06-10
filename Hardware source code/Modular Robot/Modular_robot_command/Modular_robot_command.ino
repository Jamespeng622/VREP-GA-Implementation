/*
 * This program is dedicated to the modular robot designed based on dtto project
 * The long-term target of this project is to develop a modular robot for evolutionary research verification
 * 
 */

#include <SoftwareSerial.h>  
#include <Servo.h>

/* 
 * The XON/XOFF handshake characters
 */
char XON = 0x11;
char XOFF = 0x13;

/*
 * declare servo objects
 */

Servo Mservo;   //Male side servo motor
Servo Fservo;   //Female side servo motor

char servo_gender=' ';    // the gender of the incomming commnad

int Mstate = 0;    //the position state of the MALE servo
int Fstate = 0;    //the position state of the FEMALE servo

char BT_command_char = ' ';   // the command character received through BT
/*
 * For simpifying the code, I use only one character to refer the command from PC.
 * Every command in numbers would be consider as the direct command in dservo positions
 */


/*
 * Enable Softwareserial of bluetooth connection
 */
SoftwareSerial BT(7, 8); // on Arduino Nano: RX pin, TX pin

/*
 * A simple function for checking the free memory available
 */
int freeRam () {
  extern int __heap_start, *__brkval; 
  int v; 
  return (int) &v - (__brkval == 0 ? (int) &__heap_start : (int) __brkval); 
}






void setup() {
  /*
   * Starting the bluetooth connection
   */
  BT.begin(9600);   // Bluetooth Serial connection begins
  BT.println("BT is ready!");

  /*
   * Connect the servo object with pin & wires
   */
  Mservo.attach(6);
  Fservo.attach(5);
  
  Mservo.write(90);   // Move both M and F servo to 90 degrees
  Fservo.write(90);
  
}

void loop() {

  /*
   * Waiting  for Bluetooth command
   */
  //BT.println("Modular robot standby, Waiting for Bluetooth command"); 
  while(!BT.available()){}  // Stall the program until some command is received
  
  //BT_command_char = BT.read();
  
/************* Check the available positions of the servo **************/
  /*
  if(){
    
  }
  for(pos = 0; pos <= 180; pos += 1){
    Mservo.write(0);
    Fservo.write(0);
    delay(1000);
    
    Mservo.write(180);
    Fservo.write(180);
    delay(1000);
    
    Mservo.write(90);
    Fservo.write(90);
    delay(1000);
    
  }
``*/
/****************** Extract the received command **********************/
// Arduino Nano with HC-05 can only process two commands a time.
// Note: BT.parseInt() will return a 0 when the time-out  


  if(BT.available() > 0){
    Mstate = BT.parseInt();
    Fstate = BT.parseInt();
    /*
     * debug message
    if(Mstate!=0 && Fstate!=0){
      BT.println("The received command is:");
      BT.print(Mstate);
      BT.print(".");
      BT.println(Fstate);
      BT.println("The free memory is:");
      BT.println(freeRam());
    }
    */
  }

/*************************** Execute the commands *********************/

    if (Mstate >= 1 && Mstate <= 180 || Fstate >= 1 && Fstate <= 180){
      BT.print("M: ");
      BT.print(Mstate);
      BT.print(", ");
      BT.print("F: ");
      BT.print(Fstate);
      BT.println(".");
      Mservo.write(Mstate); 
      Fservo.write(Fstate); 
    }
    //TODO: The calibration mode should be able to change the relative 
    //      position of the servo by adding some offsets
    else if (Mstate == 181 && Fstate == 181){
      BT.println("Calibration Mode");
      Mservo.write(90); 
      Fservo.write(90); 
    }
    else {
      BT.print(">");
      BT.print(Mstate);
      BT.println(Fstate);
      BT.println("cannot execute command");
    }
   BT.print(XON);

}

