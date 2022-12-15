/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/5/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
enum States{s0,s1,s2,s3,s4,s5,s6}state=s0;
#define C0 PINC.4
#define C1 PINC.5
#define C2 PINC.6
#define C3 PINC.7

// Declare your global variables here
flash char shift[4]={0xFE,0xFD,0xFB,0xF7};
flash char layout[16]={'7','8','9','/',
                       '4','5','6','*',
                       '1','2','3','-',
                       'C','0','=','+'};
                       
char num[2];
char motor[16];
char dis1[16];
char dis2[16];
char dis3[16];
char keypad(void);
int i=0,tin_high=0,tin_low=0,t_highint=0,t_lowint=0,speed=127;
int temp,t1,t2,t3,t4;

void StateMachine(char input){
    switch(state)
    {
    case s0:
        if(input=='/') state=s1;
        if(input=='*') state=s4;
    break;
    
    case s1:
        if(input=='+') state=s2; 
        if(input=='-') state=s3;
        if(input=='C') state=s0;
    break;
    
    case s4:
        if(input=='+') state=s5;
        if(input=='-') state=s6;
        if(input=='C') state=s0;
    break;
    
    case s2:
    if(input=='C') state=s1;
    if(input=='-') state=s3;
    if(input=='='){ tin_high = ((num[0]-48)*10 + (num[1]-48));}
    break;
    
    case s3:
    if(input=='C') state=s1;
    if(input=='+') state=s2;
    if(input=='='){ tin_low = ((num[0]-48)*10 + (num[1]-48));}
    break;

    case s5:
    if(input=='C') state=s4;
    if(input=='-') state=s6;
    if(input=='='){ t_highint = ((num[0]-48)*10 + (num[1]-48));}
    break; 

    case s6:
    if(input=='C') state=s4;
    if(input=='+') state=s5;
    if(input=='='){ t_lowint = ((num[0]-48)*10 + (num[1]-48));}
    break;
    }  
}  

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
char ch=keypad();
StateMachine(ch);

if(ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9')
    { num[i]=ch; i++;}
if(i>1){i=0;}
}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Phase correct PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 0.51 ms
// Output Pulse(s):
// OC0 Period: 0.51 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 500.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")
DDRC = 0x0F;
PORTC = 0xF0;
DDRB.0=1;
DDRB.1=1;
PORTB.0=1;
PORTB.1=0;
OCR0=0;

while (1)
      {
      temp=read_adc(0)/2.05; 
           
      t4 = tin_high + t_highint;
      t3 = tin_high - t_highint;
      t2 = tin_low + t_lowint;
      t1 = tin_low - t_lowint;

      if(temp>t4)
        {OCR0=200; sprintf(motor,"mode:high");}
      if((temp<t4 && temp>t2) || (temp<t2 && temp>t1))
        {OCR0=speed; sprintf(motor,"mode:normal");}
      if(temp<t1)
        {OCR0=0; sprintf(motor,"mode:off");;}  
        
      switch(state){

        case s0:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("/: Temp");
            lcd_gotoxy(0,1);
            lcd_puts("*: Interval");
            lcd_gotoxy(0,2);
            sprintf(dis3,"Temp= %d",temp);
            lcd_puts(dis3);
            lcd_gotoxy(0,3);
            lcd_puts(motor);
            delay_ms(100);
        break;
        
        case s1:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("+: High");
            lcd_gotoxy(0,1);
            lcd_puts("-: Low");
            lcd_gotoxy(0,2);
            sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
            lcd_puts(dis1);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100);            
        break;

        case s2: 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("=: in high temp");
            lcd_gotoxy(0,1);
            lcd_puts("-: Low");
            lcd_gotoxy(0,2);
            sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
            lcd_puts(dis1);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100);   
        break;
        
        case s3:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("=: in low temp");
            lcd_gotoxy(0,1);
            lcd_puts("+: high");
            lcd_gotoxy(0,2);
            sprintf(dis1,"Temp: +%d -%d",tin_high,tin_low);
            lcd_puts(dis1);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100); 
        break;
        
        case s4:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("+: upper interval");
            lcd_gotoxy(0,1);
            lcd_puts("-: lower interval");
            lcd_gotoxy(0,2);
            sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
            lcd_puts(dis2);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100);
        break;
        
        case s5:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("=: in high interval");
            lcd_gotoxy(0,1);
            lcd_puts("-: low interval");
            lcd_gotoxy(0,2);
            sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
            lcd_puts(dis2);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100);
        break;
        
        case s6:
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("=: save interval");
            lcd_gotoxy(0,1);
            lcd_puts("+: high interval");
            lcd_gotoxy(0,2);
            sprintf(dis2,"interval: +%d -%d",t_highint,t_lowint);
            lcd_puts(dis2);
            lcd_gotoxy(0,3);
            lcd_puts("C: Back");
            delay_ms(100);
        break;
        }
      }
}

char keypad(void)
{
    int row=0,column=-1,position=0;
    
    while(1){
    for (row=0;row<4;row++)
        {
        PORTC=shift[row];
        if(C0==0){column=0;}
        if(C1==0){column=1;}
        if(C2==0){column=2;}
        if(C3==0){column=3;}
        if(column != -1){
             position= row*4 + column;
             column=-1;
             while(C0==0){}
             while(C1==0){}
             while(C2==0){}
             while(C3==0){}
             PORTC=0xF0;
             delay_ms(50);
             return layout[position];
             }
            }
        }
}


