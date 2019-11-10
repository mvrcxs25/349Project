			area mycode, code, readonly
			; maybe thumb?
				
				
; This program is meant to set an input ( digits) that needs to be matched in order to turn on/off 
; a security system.
		
		
count		equ 	2						; ( # of digits)  leave at 2 for testing purposes
codeG		dcb		0x02, 0x05				; security code that needs to be matched to the testing digits.
counter		RN		r12		
			export __main
__main 		 proc
	
			;r0 base address for keycode inputs
			;r1 fake for work
			;r2 scratch
			;r3 base for outputs
			;r4 base address for PIR inputs
			;r5 location in memory for numpad to be tested
			;r6 codeG
			;r7 location in memory for code given
			;r8
			;r9
			;r10
			;r11
			;r12 counter for test.
; setting up a pointer for codeG

			ldr r6, =codeG
			mov r2, #0
			ldr r7, =0x20001000
moveAgain
			ldrb r1,[r6]
			strb r1, [r7]
			
			add r7, #1
			add r6, #1
			
			add r2, #1
			cmp r2, #count
			bne moveAgain
			
			ldr r7, =0x20001000
			
			
			
; input P4 set up		
			ldr r0, =0x40004C21			;p4 address 0x21
			mov r1, #0x00
			strb r1, [r0, #4]			;p4 all are input pins. 0x00 DIR
			strb r1, [r0, #2]			; P4REN for all pins
			mov r1, #0xFF				; 0-7 pins 
			strb r1, [r0, #6]			; P4 pull up resistor set, maybe?
			

; setting output as P2.0 ( built in LED)
			mov r2, #0x01				; 0x01 pin 0 on.
			ldr r3, =0x40004C01			; port 2 base address
			strb r2, [r3, #4]			; set DIR pins




; PIR setup
; 1st pin is 5v, 2nd is output ( on or off), 3rd pin is ground
; it will operate as an input pin
; PIR is only to be activated once keycode is correct.

			ldr r4, =0x40004C41			;P6 address
			mov r1, #0x00
			strb r1,[r4, #4]			; DIR input pins
			strb r1,[r4, #2]			; pull up resistor set.
			mov r1, #0x01
			strb r1, [r4, #6]			; P6REN for pin 1.
			
			ldr r5, =0x20000000
			mov r12, #0x00

			
again		
			mov r2, #0xFF
			cmp counter, #count			; once count is reach will branch to test statement
			beq Test
			ldrb r2, [r0]				; whatever is stored at 40004C21 (input pins P4) is now at r2			
			and r2, #0xFF				; keep all pins
			
			cmp r2, #0x01
			beq CH0			
			cmp r2, #0x02
			beq CH1
			cmp r2, #0x04
			beq CH2
			cmp r2, #0x08
			beq CH3			
			cmp r2, #0x10
			beq CH4
			cmp r2, #0x20
			beq CH5
			cmp r2, #0x40
			beq CH6			
			cmp r2, #0x80
			beq CH7
			cmp r2, #0x50
			beq CH8
			cmp r2, #0xA0
			beq CH9

			
			mov r1, #0x00
			strb r1, [r3, #2]
			b again
			
; Channels below have values from 0-9, and will store a Hex number 
; in memory depending on which channel is entered.
			
CH0			
			mov r1, #0x00
			strb r1,[r5,counter]
			add counter, #1			
			b delay	
CH1			
			mov r1, #0x01
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH2			
			mov r1, #0x02
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH3			
			mov r1, #0x03
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH4			
			mov r1, #0x04
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH5			
			mov r1, #0x05
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH6			
			mov r1, #0x06
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH7			
			mov r1, #0x07
			strb r1,[r5, counter]
			add counter, #1	
			b delay
CH8			
			mov r1, #0x08
			strb r1,[r5,counter]
			add counter, #1	
			b delay
CH9			
			mov r1, #0x09
			strb r1,[r5,counter]
			add counter, #1	
			b delay
						
; Test is when counter has reached the count number and will test the 
; security code entered vs the one given

Test
			mov counter, #0
			mov r1, #0x01

			
			;ldr r5, =0x20000000
			;ldr r7, =0x20001000
			
true		ldrb r1, [r5, counter]				; load r1 with code entered
			ldrb r2, [r7, counter]				; load r2 with code given
			cmp r1, r2				
			bne exit							
			add counter, #1
			cmp counter, #count
			beq lightUp
			b true 

			
			

		
; exit is when the entered code does not match the one given

exit
			mov counter, #0
			mov r1, #0x01
			strb r1, [r3, #2]
			ldr r5, =0x20000000
			mov r1, #0x00
			
exit2
			strb r1, [r5, counter]
			add counter, #1
			cmp counter, #count
			beq exit3
			b exit2
exit3
			mov counter, #0
			b again
			
; will light up to show that the code works, and that the 			
; security system code matches the one given.			
lightUp										
			mov r1, #0x01			
			strb r1,[ r3, #2]
											; will need to compare to leave the statment and 
											; possibly move to PIR detection system?
			b lightUp
			
			
; leave at b again, needs to start at beginning, because delay is
; only used when an input is sensed. 
			
delay
			mov r1, #10000
outer
			mov r2, #250
			
inner
			subs r2, #1
			bne inner
			subs r1,#1
			bne outer
			b again
			
	


			endp
			end
				
		
			
			
			
		
