			area mycode, code, readonly
			; maybe thumb?
				
				
		; This program is meant to set an input ( digits) that needs to be matched in order to turn on/off 
		; a security system.
		
		
count		equ 	5						; ( # of digits)  leave at 2 for testing purposes
codeG		dcb		0xAA					; security code that needs to be matched to the testing digits.

			export __main
__main 		 proc
	
			;r0 base address for keycode inputs
			;r1 fake for work
			;r2 scratch
			;r3 base for outputs
			;r4 base address for PIR inputs
			;r5 location in memory for numpad to be tested
	
; first step is to turn on a light by using the 1 button. acitvates pin 10001000 
; input P2.5,6 are set up		
			ldr r0, =0x40004C21			;p4 address 0x21
			mov r1, #0x00
			strb r1, [r0, #4]			;p4 all are input pins. 0x00 DIR
			strb r1, [r0, #2]			; P4 pull down resistor set, maybe?
			mov r1, #0xFF				; 0-7 pins 
			strb r1, [r0, #6]			; P4REN for all pins

			

; setting output as P2.0 ( built in LED)
			mov r2, #0x01				; 0x01 pin 1 on.
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
			

; set for on and off test.
			
			mov r1, #0x01
			ldr r5, =0x40002000
			
again		
			ldrb r2, [r0]				; whatever is stored at 40004C21 (input pins P4) is now at r2			
			and r2, #0xFF				; keep all pins
			
			cmp r2, #0x28
			beq CH0			
			cmp r2, #0x11
			beq CH1
			cmp r2, #0x21
			beq CH2
			cmp r2, #0x41
			beq CH3			
			cmp r2, #0x12
			beq CH4
			cmp r2, #0x22
			beq CH5
			cmp r2, #0x42
			beq CH6			
			cmp r2, #0x14
			beq CH7
			cmp r2, #0x24
			beq CH8
			cmp r2, #0x44
			beq CH9
			
			mov r1, #0x00
			strb r1, [r3, #2]
			b again
			
CH0			mov r1, #0x01				; currently going to CH0
			strb r1, [r3, #2]
			b again			
		
CH1			mov r1, #0x01
			strb r1, [r3, #2]
			b again
			
CH2			mov r1, #0x01
			strb r1, [r3, #2]
			b again


CH3


CH4


CH5


CH6



CH7


CH8


CH9
			


			endp
			end
			
			
			
		
