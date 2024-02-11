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

   set_tris_A(0x00);        // Set Port A Conditions(Mode)

   // RB6-RB0:OUT, RB7:OUT    LED Control
   // TRISB 0000 0000, 0x00

   set_tris_B(0xFF);       // Set Port B Conditions

   //set_tris_C(0x00);
   
   setup_oscillator(OSC_8MHZ);
   
   return;
}
//
// IrDA Burst Routine
// 
void Burst()
{
    BIT_SET(*PORTA,6);
   delay_us(12);
   BIT_CLEAR(*PORTA,6);
   delay_us(12);
}
//
//    Main Programs Begin from Here.
//
void   main()
{
   INT_IO();    // Call INT_IO() subrutines for INITIALIZE PORTs.
   //IrDA send
   long int i;//count times of burst
   long int n,m;//times of burst
   START:
// Wait 100ms
   delay_ms(100);
//
// Search Switch and Judge ON/OFF ON:0 OFF:1
//
    //CH1 ON/OFF ON:25 OFF:7 
    if(BIT_TEST(*PORTB,1) == 0){n = 25;} 
    else{n = 7;}
    //CH2 ON/OFF ON:25 OFF:7
    if(BIT_TEST(*PORTB,2) == 0){m = 25;}
    else{m = 7;}
//
// Start Bit(6.7ms)
//
   for(i=0;i<203;i++)
   {
   	Burst();
   }
   delay_us(600);
//
// CH1 Burst loop(500us)
//
   for(i=0;i<n;i++)
   {
   	Burst();
   }
   delay_us(600);
//
// CH2 Burst loop(310us)
//
   for(i=0;i<m;i++)
   { 
   	Burst();
   }
   delay_us(600);
//
// Stop Bit(1.2ms)
//
   for(i=0;i<35;i++)
   { 
   	Burst();
   }
// Back Routine
   GOTO START;
}