//
// Seminer :Key & LED Program for 16F84A
//             7/3/2003
// Key & LED Replace Version 11/05/2003
#include <16f819.h>
#fuses   NOWDT,NOPROTECT,NOPUT,INTRC_IO,NOMCLR
#use     delay(clock=8000000)
#include <stdlib.h>
#include <stled.c>         // External Subrutine Files, Include

// 16F84 Definition

#DEFINE  PORTA 0x05        // Define Port A Reg. Address
#DEFINE  PORTB 0x06        // Define Port B Reg. Address
//#DEFINE  PORTC 0x07        // Define Port B Reg. Address
#DEFINE  STATUS 0x03       // Define STATUS Reg. Address
#DEFINE  TRISA  0x85       // Define TRISA Reg. Address
#DEFINE  TRISB  0x86       // Define TRISB Reg. Address
//#DEFINE  TRISC   0x87      // Define TRISB Reg. Address

//
// Hard Ware Definition RA 3-0
//
#define  _KEY0   0         // L:No Push, H:Push(Activate)
#define  _KEY1   1         // L:No Push, H:Push(Activate)
#define  _KEY2   2         // L:No Push, H:Push(Activate)
#define  _KEY3   3         // L:No Push, H:Push(Activate)
#define  _KEY4   4         // L:No Push, H:Push(Activate)
//
// Hard Ware Definition RB 6-0
//
#define  _LED0   0    // LED0 (Connect to RB0), H:ON, L:OFF
#define  _LED1   1    // LED1 (Connect to RB1), H:ON, L:OFF
#define  _LED2   2    // LED2 (Connect to RB2), H:ON, L:OFF
#define  _LED3   3    // LED3 (Connect to RB3), H:ON, L:OFF
#define  _LED4   4    // LED4 (Connect to RB4), H:ON, L:OFF
#define  _LED5   5    // LED5 (Connect to RB5), H:ON, L:OFF
#define  _LED6   6    // LED6 (Connect to RB6), H:ON, L:OFF
#define  _LED7   7    // LED7 (Connect to RB7), H:ON, L:OFF
//
// Flag Condition Deffnitions
//
#define  K0    0     //Key 0 Flag Bit
#define  K1    1     //Key 1 Flag Bit
#define  K2    2     //Key 2 Flag Bit
#define  K3    3     //Key 3 Flag Bit
#define  K4    4     //Key 4 Flag Bit
//
//   IO Init :   Subrutines Example
//
void INT_IO(void){
   #use fast_io(A)
   #use fast_io(B)
   //#use fast_io(C)
   // RA4, RA3, RA2, RA1, RA0, Push SW Info Obtain. Set to INPUT.
   // TRISA ***1 1111   0x1F

   set_tris_A(0xFF);        // Set Port A Conditions(Mode)

   // RB6-RB0:OUT, RB7:OUT    LED Control
   // TRISB 0000 0000, 0x00

   set_tris_B(0x00);       // Set Port B Conditions

   //set_tris_C(0x00);
   
   setup_oscillator(OSC_8MHZ);
   
   return;
}
//
//    Main Programs Begin from Here.
//
void   main()
{
   	INT_IO();    // Call INT_IO() subrutines for INITIALIZE PORTs.
   	int pre0 = 0 , pre1 = 0 , pre2 = 0 ,pre4 = 0, pre5 = 0,pre6 = 0;
   	int trig = 0;//0:Time setting 1:count time
   	int count = 0 ,minute = 0;
   	//time setting
	while(1)
	{
		OUTPUT_B(count);
   		//minute lighter
   		if(minute == 1){BIT_SET(*PORTB,6);}
   		if(minute == 2){BIT_SET(*PORTB,7);}
		if(minute == 3)
   		{
			BIT_SET(*PORTB,6);
			BIT_SET(*PORTB,7);
   		}
		while(trig == 1)
   		{
   			//counting
      		OUTPUT_B(count);
      		//minute lighter
      		if(minute == 1){BIT_SET(*PORTB,6);}
    		if(minute == 2){BIT_SET(*PORTB,7);}
      		if(minute == 3)
			{
      			BIT_SET(*PORTB,6);
      			BIT_SET(*PORTB,7);
			}
      		//stop button
      		if(BIT_TEST(*PORTA,3) == 0){trig = 0;}               
     		//minute -1 or end of timer
      		if(count == -1)//count -1 to avoid timer end first 
			{
      			//end of timer
      			minute = minute - 1;
      			if(minute == -1)
				{
					//minute = -1 to avoid end without second = 0;
         			OUTPUT_B(255);
         			delay_ms(1000);                        
         			OUTPUT_B(0);
         			delay_ms(1000);
         			count = 0;
      			}
      			//1 minute -> 59 second
      			else{count = 59;}
      		}	
      		//Prepare of next
      		delay_ms(1000);
      		count = count - 1;
      		//To The Next
		}
    	//start button
    	if (BIT_TEST(*PORTA,0)== 0)
		{
      		if (pre0 == 0)
			{
        		if (trig == 0){trig = 1;}
				else {trig = 0;}
      		}
    	}
    	else{pre0 = 0;}
      		//time setting
      		//count+1 button(second + 1)
    	if(BIT_TEST(*PORTA,1)== 0)
    	{
    		if(pre1== 0){count = count + 1;}
      		pre1 = 1;
    	}
    	else{pre1 = 0;}
    	//count-1 button (second + 1)                       
    	if(BIT_TEST(*PORTA,2)==0)
		{
      		if(pre2 == 0)
			{
      			trig = 0;
      			count = count - 1;
      		}
      		pre2 = 1;
      	}
    	else{pre2 = 0;}
      	//minute +1 button
    	if(BIT_TEST(*PORTA,4)==0)
    	{
    		if(pre4 == 0)
    		{
    			trig  = 0;
    			minute = minute + 1;
    		}
    		pre4 = 1;
 		}
    	else{pre4 = 0;}
    	//minute -1 button
    	if(BIT_TEST(*PORTA,5)==0)
    	{
      		if(pre5== 0)
      		{
      			trig  = 0;
      			minute = minute - 1;
      		}
      		pre5 = 1;
    	}
    	else{pre5 = 0;}
    	//reset button
    	if(BIT_TEST(*PORTA,6)==0)
		{
    		if(pre6 == 0)
    		{
      			trig = 0;  
      			minute = 0;
      			count = 0;
      		}
      		pre6 = 1;
    	}
    	else{pre6 = 0;}
		//minute + 1
    	if(count == 60)
    	{
      		minute = minute + 1;
      		count = 0;
    	}
    	//regulate minutes
    	if(minute == 4){minute = 3;}
	}
}