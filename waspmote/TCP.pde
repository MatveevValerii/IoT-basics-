
#include <Wasp4G.h>
#include <WaspFrame.h>
#include <WaspIndustry.h>
IndustrySDI12 sensorSDI12(IND_SOCKET_C);




// debug
#define DEBUG

// SENSOR DATA
char node_ID[] = "Node_01";
char AsciiFrame[256] ="WM_ID:";

timestamp_t time;
uint32_t loop_counter;

// APNSETTINGS
char apn[] = "internet";
char login[] = "";
char password[] = "";


// SERVER settings
///////////////////////////////////////
char host[] = "_______";
uint16_t remote_port = 80;
///////////////////////////////////////

// define Socket ID (from 'CONNECTION_1' to 'CONNECTION_6')
///////////////////////////////////////
uint8_t connId = Wasp4G::CONNECTION_1;


// define data to send through TCP socket
///////////////////////////////////////
char http_format[] =
  "GET /_____/____/__"\
  "Host: _____________\r\n"\
  "Content-Length: 0\r\n\r\n";
  
///////////////////////////////////////
// define variables
int error;
uint32_t previous_millis;
uint32_t current_millis;
uint32_t previous;
uint8_t  socketIndex;
char data[500];
char command_01[] = "%cM2!"; // SDI-12 measurement of PTU
char command_06[] = "%cM1!"; // SDI-12 measurement of wind
char command_02[] = "%cD0!";// SDI-12 data
char command_07[] = "%cM3!"; //rain
char command_03[] = "Ab!";  // SDI-12 change address
char command_04[] = "?!";   // SDI-12 address query
char command_05[] = "?I!";  // SDI-12 info
char check_wind_info[] = "%cXWU!"; 
char check_rain_info[] = "%cXRU!"; 
char command[30];
char temp[5];
char temp_digits[] = "%c%c%c%c";
char hum[5];
char hum_digits[]=  "%c%c%c%c";
char pres[10];
char pres_digits[]= "%c%c%c%c%c%c";
char Dn[4];
char wind_digits[] = "%c%c%c";
char Dm[4];
char Dx[4];
char Sn[4];
char Sm[4];
char Sx[4];
char Rc[5];
char Rc_digits[] = "%c%c%c%c";
char Rd[2];
char Rd_digits[] = "%c";
char Ri[5];
char Ri_digits[] = "%c%c%c";
char Hc[5];
char Hc_digits[] = "%c%c%c";
char Hd[2];
char Hd_digits[] = "%c";
char Hi[5];
char Hi_digits[] = "%c%c%c";
double response_length = 120;
double timeout = 1000;
double measurement_time = 7000;




void measurements()
{ 
  sprintf(command, command_01, sensorSDI12._rxBuffer[0]); //start measurements
  sensorSDI12.sendCommand(command, strlen(command));
  sensorSDI12.readCommandAnswer(response_length, measurement_time); //vaisala response 
  USB.println(F("started measurments PTU"));
  
  
  sprintf(command, command_02, sensorSDI12._rxBuffer[0]);//forming the request
  
  sensorSDI12.sendCommand(command, strlen(command));//pls give me results
  sensorSDI12.readCommandAnswer(response_length, timeout); //response
  USB.println(sensorSDI12._rxBuffer);
  USB.print(F("Temperature:  "));
  sprintf(temp, temp_digits, sensorSDI12._rxBuffer[2], sensorSDI12._rxBuffer[3], sensorSDI12._rxBuffer[4], sensorSDI12._rxBuffer[5] );
  USB.print(temp);
  USB.println(F("C"));
  
  USB.print(F("Humidity:  "));
  sprintf(hum, hum_digits, sensorSDI12._rxBuffer[7], sensorSDI12._rxBuffer[8], sensorSDI12._rxBuffer[9], sensorSDI12._rxBuffer[10]);
  USB.print(hum);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  sprintf(pres, pres_digits, sensorSDI12._rxBuffer[12], sensorSDI12._rxBuffer[13], sensorSDI12._rxBuffer[14], sensorSDI12._rxBuffer[15],sensorSDI12._rxBuffer[16],sensorSDI12._rxBuffer[17]);
  USB.print(pres);
  USB.println(F(" mm Hg"));

USB.println();
/*
USB.println(F("settings of wind sensor"));
sprintf(command, check_wind_info, sensorSDI12._rxBuffer[0]);
sensorSDI12.sendCommand(command, strlen(command));
sensorSDI12.readCommandAnswer(response_length, measurement_time); //vaisala response 
USB.println(sensorSDI12._rxBuffer);
*/
USB.println(F("starting wind measurement..."));
sprintf(command, command_06, sensorSDI12._rxBuffer[0]);
sensorSDI12.sendCommand(command, strlen(command));
sensorSDI12.readCommandAnswer(response_length, measurement_time); //vaisala response 


sprintf(command, command_02, sensorSDI12._rxBuffer[0]);//forming the request
sensorSDI12.sendCommand(command, strlen(command));//pls give me results
sensorSDI12.readCommandAnswer(response_length, timeout); //response

USB.print(F("Dn Wind direction minimum: "));
sprintf(Dn, wind_digits, sensorSDI12._rxBuffer[2], sensorSDI12._rxBuffer[3], sensorSDI12._rxBuffer[4]);
USB.print(Dn);
USB.println();
 
USB.print(F("Dm Wind direction average: "));
sprintf(Dm, wind_digits, sensorSDI12._rxBuffer[6], sensorSDI12._rxBuffer[7], sensorSDI12._rxBuffer[8]);
USB.println(Dm);  

USB.print(F("Dx Wind direction maximum: "));
sprintf(Dx, wind_digits, sensorSDI12._rxBuffer[10], sensorSDI12._rxBuffer[11], sensorSDI12._rxBuffer[12]);
USB.println(Dx); 

USB.print(F("Sn Speed minimum: "));
sprintf(Sn, wind_digits, sensorSDI12._rxBuffer[14], sensorSDI12._rxBuffer[15], sensorSDI12._rxBuffer[16]);
USB.println(Sn); 
USB.print(F("Sm Speed average: "));
sprintf(Sm, wind_digits, sensorSDI12._rxBuffer[18], sensorSDI12._rxBuffer[19], sensorSDI12._rxBuffer[20]);
USB.println(Sm);
 
USB.print(F("Sx Speed maximum: "));
sprintf(Sx, wind_digits, sensorSDI12._rxBuffer[22], sensorSDI12._rxBuffer[23], sensorSDI12._rxBuffer[24], sensorSDI12._rxBuffer[25]);
USB.println(Sx); 
USB.println();

USB.println(F("starting rain measurement..."));
sprintf(command, command_07, sensorSDI12._rxBuffer[0]);
sensorSDI12.sendCommand(command, strlen(command));
sensorSDI12.readCommandAnswer(response_length, measurement_time); //vaisala response 
//USB.println(sensorSDI12._rxBuffer);

sprintf(command, command_02, sensorSDI12._rxBuffer[0]);//forming the request
sensorSDI12.sendCommand(command, strlen(command));//pls give me results
sensorSDI12.readCommandAnswer(response_length, timeout); //response
USB.print(F("Rc Rain amount: "));
sprintf(Rc, Rc_digits, sensorSDI12._rxBuffer[2], sensorSDI12._rxBuffer[3], sensorSDI12._rxBuffer[4], sensorSDI12._rxBuffer[25]);

USB.println(Rc); 

USB.print(F("Rd Rain duration: "));
USB.println(sensorSDI12._rxBuffer[7]);


USB.print(F("Ri Rain intensity: "));
sprintf(Ri, Ri_digits, sensorSDI12._rxBuffer[9], sensorSDI12._rxBuffer[10], sensorSDI12._rxBuffer[11]);
USB.println(Ri); 
USB.print(F("Hc Hail amount: "));
sprintf(Hc, Hc_digits, sensorSDI12._rxBuffer[13], sensorSDI12._rxBuffer[14], sensorSDI12._rxBuffer[15]);
USB.println(Hc); 

USB.print(F("Hd Hail duration: "));
USB.println(sensorSDI12._rxBuffer[17]);

USB.print(F("Hi Hail intensity: "));
sprintf(Hi, Hi_digits, sensorSDI12._rxBuffer[19], sensorSDI12._rxBuffer[20], sensorSDI12._rxBuffer[21]);
USB.println(Hi); 
/*
USB.println(F("settings of rain sensor"));
sprintf(command, check_rain_info, sensorSDI12._rxBuffer[0]);
sensorSDI12.sendCommand(command, strlen(command));
sensorSDI12.readCommandAnswer(response_length, measurement_time); //vaisala response 
USB.println(sensorSDI12._rxBuffer);
*/

}
void Frame()
{
frame.addSensor(SENSOR_TCA, atof(temp));
frame.addSensor(SENSOR_HUMA, atof(hum)); //ADD ALL SENSORS
frame.addSensor(SENSOR_PA, atof(pres));
frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

frame.addTimestamp();

frame.showFrame();

 // define aux buffer
char frame_string[frame.length*2 + 1];
memset(frame_string, 0x00, sizeof(frame_string));

// convert frame from bytes to ASCII representation
Utils.hex2str((uint8_t*)frame.buffer, (char*)frame_string, frame.length);

snprintf( data, sizeof(data), http_format, frame_string);
USB.print(F("data to send:"));
USB.println(data);
}
void wakeup()
{ 
  
  sensorSDI12.ON();
  sensorSDI12.setPowerSocket(SWITCH_ON);
  delay(2000);
  sensorSDI12.sendCommand(command_05, strlen(command_05)); // requesting info
  sensorSDI12.readCommandAnswer(response_length, timeout); // reading info
  USB.println(sensorSDI12._rxBuffer);    
}
void knockdown()
{
  sensorSDI12.setPowerSocket(SWITCH_OFF);
  sensorSDI12.OFF();
}

void close_TCP_socket()
{
 error = _4G.closeSocketClient(connId);

    if (error == 0)
    {
      USB.println(F(" Socket closed OK"));
    }
    else
    {
      USB.print(F("Error closing socket. Error code: "));
      USB.println(error, DEC);
    }
}
void send_Data_get_response()
{
   error = _4G.send(connId, data);
      if (error == 0)
      {
        USB.println(F("Sending a frame... done!"));
      }
      else
      {
        USB.print(F(" Error sending a frame. Code: "));
        USB.println(error, DEC);
      }

    USB.print(F("Waiting to receive data..."));

      error = _4G.receive(connId, 60000);

      if (error == 0)
      {
        if (_4G.socketInfo[connId].size > 0)
        {
          USB.println(F("\n-----------------------------------"));
          USB.print(F("Data received:"));
          USB.println(_4G._buffer, _4G._length);
          USB.println(F("-----------------------------------"));
        }
        else
        {
          USB.println(F("NO data received"));
        }
      }
      else
      {
        USB.println(F("No data received."));
        USB.println(error, DEC);
      }
}
void get_duration()
{
  current_millis = millis();
#ifdef DEBUG
  USB.print("Time used: ");
  USB.print(current_millis - previous_millis, DEC);
  USB.println("ms");
  previous_millis = current_millis;
#endif
}



void setup()
{   
  USB.ON();
  
  USB.println(F("Valerii's attempt to send Vaisala measurements to the server"));
  USB.println(F("******************************************************"));

  
 // Sets operator parameters
  _4G.set_APN(apn, login, password);
  _4G.show_APN();   
  
}
  


void loop()
{
  error = _4G.ON();
  USB.println(F("Entering PIN code..."));
      if (_4G.enterPIN("1234") == 0)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
if (error == 0)
  {
    USB.println(F("4G module ready..."));
    ////////////////////////////////////////////////
    // 2. TCP socket
    ////////////////////////////////////////////////
    error = _4G.openSocketClient(connId, Wasp4G::TCP, host, remote_port);
    if (error == 0)
    {
      USB.println(F("Opening a socket... done!"));
      USB.print(F("IP address:"));
      USB.println(_4G._ip);
       //////////////////////////////////////////////
      // 2.2. Create a frame and data to send via HTTP request
      //////////////////////////////////////////////
      RTC.ON();
      RTC.getTime();
      wakeup();
      measurements();
      Frame();
      send_Data_get_response();
      close_TCP_socket();
      knockdown();
      delay(3000);
    }
    else
    {
      USB.println(F("error"));
    }
}
}
