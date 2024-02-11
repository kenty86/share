//
// Seminer :Key & LED Program for 16F84A
//             7/3/2003
// Key & LED Replace Version 11/05/2003
#include <16f819.h>
#fuses   NOWDT,NOPROTECT,NOPUT,INTRC_IO,NOMCLR
#use     delay(clock=8000000)
#include <stdlib.h>

// 16F84 Definition

#DEFINE  PORTA 0x05        // Define Port A Reg. Address
#DEFINE  PORTB 0x06        // Define Port B Reg. Address
//#DEFINE  PORTC 0x07        // Define Port B Reg. Address
#DEFINE  STATUS 0x03       // Define STATUS Reg. Address
#DEFINE  TRISA  0x85       // Define TRISA Reg. Address
#DEFINE  TRISB  0x86       // Define TRISB Reg. Address
//#DEFINE  TRISC   0x87      // Define TRISB Reg. Address
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
   //IrDA read
   long pulsec;
   int dumy1,dumy2;
   START:
   CHK_START_BIT:
   	pulsec = 0;
   	while(BIT_TEST(*PORTA,7));//IrDA High:＝ No Work
   	while(!BIT_TEST(*PORTA,7)) //IRDA Low: Count signals
   	{
   		delay_us(10);
   		pulsec++;
   	}
   	if(pulsec<500)  	//JUDGE START BIT                  
   		GOTO CHK_START_BIT;
   //
   // Read Fisrt Parameter(CH1)
   //
   	while(BIT_TEST(*PORTA,7));// Next Bit Waiting
   	dumy1 = 0;
   	while(!BIT_TEST(*PORTA,7))
   	{
   		dumy1++;
   		delay_us(9);
   	}
   //
   // Read Second Parameter(CH2)
   //
   	dumy2 = 0;					//Temp Param CLR
   	while(BIT_TEST(*PORTA,7));//Next Bit Waiting
   	while(!BIT_TEST(*PORTA,7))
   	{
   		dumy2++;
   		delay_us(9);
   	}
   //
   // Read Stop Bit 
   //
   	CHK_STOP_BIT:
   	pulsec = 0;
   	while(BIT_TEST(*PORTA,7));
   	while(!BIT_TEST(*PORTA,7))
   	{
   		delay_us(10); //10 us Interrive
   		pulsec++;
   	}
   	if(pulsec < 105)  	//Judge Stop Bit    
   		GOTO CHK_STOP_BIT;
   //
   //Arrange
   //
    //ON:920us OFF:310us
   	//CH1
   	if(dumy1>50) //judge 500us
   		BIT_CLEAR(*PORTB,1); //LED:ON
   	else
   		BIT_SET(*PORTB,1);//LED:OFF
   	//CH2   
   	if(dumy2>50) 
   		BIT_CLEAR(*PORTB,2);//LED:ON
   	else
   		BIT_SET(*PORTB,2);//LED:OFF
   //Back Routine
   GOTO START;
}