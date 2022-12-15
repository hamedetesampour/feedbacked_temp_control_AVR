# Feedbacked_temp_control_AVR_PCB_out
## Feedbacked temperature control using Atmega16 microcontroller (including final PCB desing with Altium Designera) - a ready to use project
In this project we are going to program an Atmega16 microcontroller that uses LM35 sensor to watch the temperature and (or any other sensors) to control the Motor speed regarding the temp. The motor that has been mounted by L298 driver. The system's setting (including upper/lower temp and relative margins) is accessible by the designed menu, which can be controlled via the keypad signs (*/+-=). 

This program has been tested and applied to a real system. The code got written in CodeVisionAVR compiler and then uploaded to Atmega16 using USB programmer and "progisp" application. All the relative source codes, and also the simulation files are uploaded in the directory. 

## Overall code method & structures 
System is running by a microcontroller that handles the menu and temp setting while getting sensor's signal as input and controling the output signal of the motor driver. This specific driver is capable of handling two motors, however in this project we need just one.  
The sensor gives an Analoge signal as the output, hence we use the controller's A/D pin to convert the signal to it's general form. For running the LCD we are using the 4bit data exchange method via 'alcd.h' library to use as less pins as possible. Then for the keypad, for opptimum usage of the microcontroller's memory we use Interupts (instead of checking the keys continuously). 

The original temp and it's marginal interval is definable by user via 4\*4 digital keypad. Then, considering the present temp, the fan will work on 3 modes to *stabilize*, *increase* or *decrease* the temp. The system's info is displayed over a 16\*2 character LCD module.


## System functional test
For applying the specific temperature setting, the user has to work with the menu of the system to define the upper/lower temp and the relative intervals. (intervals are implemented to prevent the motor speed to change too rapidly, sine it can annoy useres and also damage the motor)
To declare the variables:
1. User has to enter the desired temperature (upper and lower temp).
2. Then has to choose upper and lower temp margin.
3. The system's result would be:  high_temp(+/-interval_high)  &  low_temp(+/-interval_low) 

for the below system setting are: high => 26(+/- 1)    low =>  21(+/- 1)

<p align="center">
<img src="https://user-images.githubusercontent.com/108813301/207882128-6d2b9f6a-ee60-4b53-ab35-5cd6e91bd396.JPG" width="465" height="329" />
<img src="https://user-images.githubusercontent.com/108813301/207882151-7c572adf-74c0-493b-9a33-589022bfa049.JPG" width="465" height="329" />
</p>  <br />

The relative system simulation is demonstrated in *Proteus* to test and visualize the project's implementation. The test results are shown as below: 

<p align="center">
<img src="https://user-images.githubusercontent.com/108813301/207883269-0de174f0-0710-4f54-83aa-3d0b935d8078.JPG" width="389" height="273" />
<img src="https://user-images.githubusercontent.com/108813301/207883285-76b792db-5242-47a7-a506-7f8d31ea2abb.JPG" width="389" height="273" />
<img src="https://user-images.githubusercontent.com/108813301/207883302-3d8206bc-3590-4500-ac24-b0a376a37653.JPG" width="389" height="273" />
</p>  <br />

## Complete PCB design
Designing the needed component footprints and importing the needed libraries. The Schematic, PCB and 3D Model output are as shown below:

<p align="center">
<img src="https://user-images.githubusercontent.com/108813301/207894073-ea105877-463d-4c07-86b2-dabdd100ebdd.JPG" width="465" height="329" />
<img src="https://user-images.githubusercontent.com/108813301/207894061-0a9f9d14-3d9e-421f-809b-9d69666b0062.JPG" width="465" height="329" />
</p>  <br />


All of the Altium custom librarires ,AVR codes, simulation and tests are included in the project's directory.
