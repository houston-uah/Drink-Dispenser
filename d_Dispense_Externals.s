@Filename: d_Dispense_Externals.s
@Author: Houston Calvert
@Purpose: Soft Drink Machine
@as -o d_Dispense_Externals.o d_Dispense_Externals.s -lwiringPi
@gcc -o d_Dispense_Externals d_Dispense_Externals.o
@sudo ./d_Dispense_Externals

OUTPUT = 1
.global main
main:
		@Create instances of drinks
	mov r4, #1 @coke
	mov r5, #1 @sprite
	mov r6, #1 @dr.pepper
	mov r7, #1 @dietcoke
		
	bl wiringPiSetup
	mov r1, #-1
	cmp r0, r1
	beq error
	bl init
	
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite
	mov r0, #5000
	bl delay
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	mov r10, #0
	bl mainloop
	b myexit 

mainloop:			@Mainloop for program
	
	cmp r9, #4
	beq empty_machine
	bl welcome_Prompt
	bl money_Input 
	bl drink_Input
	b mainloop


welcome_Prompt:			@Enter welcome prompt

	push {lr}
	ldr r0, =format
	bl printf
	ldr r0, =welcome1
	bl printf
	ldr r0, =welcome2
	bl printf
	pop {lr}
	mov pc, lr

money_Input:			@Function for money input
	
	push {lr}
	ldr r0, =instruct
	bl printf
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	
	ldr r2,=in
	ldr r2, [r2]
	mov r11, #0
				@For each instance, add 1 to r11 to check for validity
	cmp r2, #'N'
	addeq r10, r10, #5
	moveq r11, #1
	cmp r2, #'n'
	addeq r10, r10, #5
	moveq r11, #1
	cmp r2, #'D'
	addeq r10, r10, #10
	moveq r11, #1
	cmp r2, #'d'
	addeq r10, r10, #10
	moveq r11, #1
	cmp r2, #'Q'
	addeq r10, r10, #25
	moveq r11, #1
	cmp r2, #'q'
	addeq r10, r10, #25
	moveq r11, #1
	cmp r2, #'B'
	addeq r10, r10, #100
	moveq r11, #1
	cmp r2, #'b'
	addeq r10, r10, #100
	moveq r11, #1
	cmp r2, #'O'				@O is the hidden code
	beq hidden_code
	moveq r11, #1
	cmp r2, #'o'
	beq hidden_code
	moveq r11, #1
	cmp r2, #'X'
	beq myexit
	moveq r11, #1
	cmp r2, #'x'
	beq myexit
	moveq r11, #1

	cmp r11, #1
	bne wrong_Input
	
	ldr r0, =change_Entered			@display how much change has been entered
	mov r1, r10
	bl printf

	pop {lr}
	cmp r10, #55				@Check how much change has been entered
	blt money_Input
	mov r11, #0
	mov pc, lr
	
wrong_Input:

	ldr r0, =input_wrong
	bl printf
	b mainloop
	pop {lr}
	mov pc, lr

drink_Input:

	push {lr}
	ldr r0, =drink_instruct
	bl printf

	ldr  r0, =buttonBlue
   	ldr  r0, [r0]
    	mov  r1, #PUD_UP
    	BL   pullUpDnControl 

    	ldr  r0, =buttonGreen
    	ldr  r0, [r0]
    	mov  r1, #PUD_UP
    	BL   pullUpDnControl 

    	ldr  r0, =buttonYellow
    	ldr  r0, [r0]
    	mov  r1, #PUD_UP
    	BL   pullUpDnControl 

    	ldr  r0, =buttonRed
    	ldr  r0, [r0]
    	mov  r1, #PUD_UP
    	BL   pullUpDnControl 

	b ButtonLoop
	@ldr r0, =input1
	@ldr r1, =in
	@bl scanf
	@ldr r12,=in
	@ldr r12, [r12]
	@mov r11, #0				@Reset r11 to 0 for validation checking

	@cmp r12, #'C'
	@beq sub_coke
	@moveq r11, #1
	@cmp r12, #'S'
	@beq sub_sprite
	@moveq r11, #1
	@cmp r12, #'P'
	@beq sub_dr_pepper
	@moveq r11, #1
	@cmp r12, #'D'
	@beq sub_diet_coke
	@moveq r11, #1
	@cmp r12, #'O'
	@beq hidden_code2
	@moveq r11, #1
	@cmp r12, #'X'
	@beq myexit
	@moveq r11, #1
	@cmp r12, #'c'
	@beq sub_coke
	@moveq r11, #1
	@cmp r12, #'s'
	@beq sub_sprite
	@moveq r11, #1
	@cmp r12, #'p'
	@beq sub_dr_pepper
	@moveq r11, #1
	@cmp r12, #'d'
	@beq sub_diet_coke
	@moveq r11, #1
	@cmp r12, #'o'
	@beq hidden_code2
	@moveq r11, #1
	@cmp r12, #'x'
	@beq myexit
	@moveq r11, #1
	@ldr r0, =change
	@mov r1, r10
	@bl printf

	@cmp r11, #1
	@bne wrong_input2

	@mov r11, #0
	pop {lr}
	mov pc, lr
	
				@Begin dispense functions
				@Each will show how much money is dispensed
sub_coke:				

	push {lr}
	ldr r0, =confirmation1
	bl printf
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	ldr r1,=in
	ldr r1, [r1]
	mov r11, #0

	cmp r1, #'N'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'Y'	
	moveq r11, #1
	cmp r1, #'n'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'y'	
	moveq r11, #1
	
	cmp r11, #1
	bne wrong_input2

	mov r11, #0
	cmp r4, #0
	beq empty_drinks
	subgt r4, r4, #1
	ldr r0, =dispense_coke
	bl printf
	sub r10, r10, #55
	ldr r0, =change
	mov r1, r10
	bl printf
	mov r10, #0
	bl blinkLight1
	cmp r4, #0
	addeq r9, #1
	b mainloop
	pop {lr}
	mov pc, lr

sub_sprite:

	push {lr}
	ldr r0, =confirmation2
	bl printf
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	ldr r1,=in
	ldr r1, [r1]
	mov r11, #0

	cmp r1, #'N'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'Y'	
	moveq r11, #1
	cmp r1, #'n'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'y'	
	moveq r11, #1
	
	cmp r11, #1
	bne wrong_input2

	cmp r5, #0
	beq empty_drinks
	subgt r5, r5, #1
	ldr r0, =dispense_sprite
	bl printf
	sub r10, r10, #55
	ldr r0, =change
	mov r1, r10
	bl printf
	
	mov r10, #0
	bl blinkLight2
	cmp r5, #0
	addeq r9, #1
	b mainloop
	pop {lr}
	mov pc, lr

sub_dr_pepper:

	push {lr}
	ldr r0, =confirmation3
	bl printf
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	ldr r1,=in
	ldr r1, [r1]
	mov r11, #0

	cmp r1, #'N'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'Y'	
	moveq r11, #1
	cmp r1, #'n'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'y'	
	moveq r11, #1
	
	cmp r11, #1
	bne wrong_input2

	cmp r6, #0
	beq empty_drinks
	subgt r6, r6, #1
	ldr r0, =dispense_dp
	bl printf
	sub r10, r10, #55
	ldr r0, =change
	mov r1, r10
	bl printf
	
	mov r10, #0
	bl blinkLight3
	cmp r6, #0
	addeq r9, #1
	b mainloop
	pop {lr}
	mov pc, lr

sub_diet_coke:

	push {lr}
	ldr r0, =confirmation4
	bl printf
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	ldr r1,=in
	ldr r1, [r1]
	mov r11, #0

	cmp r1, #'N'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'Y'	
	moveq r11, #1
	cmp r1, #'n'
	beq drink_Input
	moveq r11, #1
	cmp r1, #'y'	
	moveq r11, #1
	
	cmp r11, #1
	bne wrong_input2

	cmp r7, #0
	beq empty_drinks
	subgt r7, r7, #1
	ldr r0, =dispense_diet
	bl printf
	sub r10, r10, #55
	ldr r0, =change
	mov r1, r10
	bl printf
	bl blinkLight4
	mov r10, #0
	cmp r7, #0
	addeq r9, #1
	b mainloop
	pop {lr}
	mov pc, lr

blinkLight1:
	push {lr}
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	mov r0, #5000
	bl delay
	
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	pop {lr}
	mov pc, lr

blinkLight2:
	push {lr}
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	mov r0, #5000
	bl delay
	
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	pop {lr}
	mov pc, lr

blinkLight3:
	push {lr}
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	mov r0, #5000
	bl delay
	
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	pop {lr}
	mov pc, lr

blinkLight4:
	push {lr}
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay
	
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr     r0, =delayMs
        ldr     r0, [r0]
        bl      delay

	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite

	mov r0, #5000
	bl delay
	
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	pop {lr}
	mov pc, lr

init:
	push {lr}
	
	ldr r0, =pin2	@blue
	ldr r0, [r0]
	mov r1, #OUTPUT
	bl pinMode
	
	ldr r0, =pin3	@green
	ldr r0, [r0]
	mov r1, #OUTPUT
	bl pinMode
	
	ldr r0, =pin4	@yellow
	ldr r0, [r0]
	mov r1, #OUTPUT
	bl pinMode
	
	ldr r0, =pin5	@red
	ldr r0, [r0]
	mov r1, #OUTPUT
	bl pinMode

	ldr     r0, =buttonBlue
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

        ldr     r0, =buttonGreen
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

        ldr     r0, =buttonYellow
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

        ldr     r0, =buttonRed
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode
	mov r8,  #0xff 
    	mov r6,  #0xff
    	mov r11, #0xff    
    	mov r12, #0xff 
	
	pop {lr}
	mov pc, lr

ButtonLoop:

    ldr  r0, =delayMs2
    ldr  r0, [r0]
    BL   delay

ReadBLUE:
@ Read the value of the blue button. If it is HIGH (i.e., not
@ pressed) read the next button and set the previous reading
@ value to HIGH. 
@ Otherwise the current value is LOW (pressed). If it was LOW
@ that last time the button is still pressed down. Do not record
@ this as a new pressing.
@ If it was HIGH the last time and LOW now then record the 
@ button has been pressed.
@
    ldr    r0,  =buttonBlue
    ldr    r0,  [r0]
    BL     digitalRead 
    cmp    r0, #HIGH   @ Button is HIGH read next button
    moveq  r6, r0      @ Set last time read value to HIGH 
    beq    ReadGREEN

    @ The button value is LOW.
    @ If it was LOW the last time it is still down. 
    cmp    r6, #LOW    @ was the last time it was called also
                       @ down?
    beq    ReadGREEN   @ button is still down read next button
                       @ value. 
     
    mov    r6, r0  @ This is a new button press. 
    b      PedBLUE @ Branch to print the blue button was pressed. 

ReadGREEN:
@ See comments on BLUE button on how this code works. 
@
    ldr    r0,  =buttonGreen
    ldr    r0,  [r0]
    BL     digitalRead  
    cmp    r0, #HIGH
    moveq  r11, r0
    beq    ReadYELLOW   

    cmp    r11, #LOW
    beq    ReadYELLOW  

    mov    r11, r0
    b      PedGREEN 

ReadYELLOW:
@ See comments on BLUE button on how this code works. 
@
    ldr    r0,  =buttonYellow
    ldr    r0,  [r0]
    BL     digitalRead 
    cmp    r0, #HIGH
    moveq  r12, r0
    beq    ReadRED 
 
    cmp    r12, #LOW
    beq    ReadRED

    mov    r12, r0
    b      PedYELLOW 

ReadRED:
@ See comments on BLUE button on how this code works. 
@
    	ldr    r0,  =buttonRed
    	ldr    r0,  [r0]
    	BL     digitalRead 
    	cmp    r0, #HIGH
    	moveq  r8, r0
    	beq    ButtonLoop
 
   	cmp    r8, #LOW
    	beq    ButtonLoop
 
    	mov    r8, r0
	b PedRED

PedBLUE:
    b sub_diet_coke

PedGREEN:
    b sub_dr_pepper

PedYELLOW:
    b sub_sprite

PedRED:
    b sub_coke

wrong_input2:

	ldr r0, =wrong_ip
	bl printf
	b drink_Input
	pop {lr}
	mov pc, lr

empty_drinks:
	
	push {lr}
	cmp r4, #0
	addeq r11, #1
	cmp r5, #0
	addeq r11, #1
	cmp r6, #0
	addeq r11, #1
	cmp r7, #0
	addeq r11, #1
	
	cmp r11, #4
	beq empty_machine

	ldr r0, =empty
	bl printf
	b drink_Input
	pop {lr}
	mov pc, lr
empty_machine:
	
	ldr r0, =empty_m
	bl printf
	b myexit

hidden_code:			@Hidden code function

	push {lr}
	ldr r0, =hidden
	mov r1, r4
	mov r2, r5
	mov r3, r6
	bl printf
	ldr r0, =hidden2
	mov r1, r7
	mov r2, r8
	bl printf
	b mainloop
	pop {lr}
	mov pc, lr

hidden_code2:			@Hidden code function for drink choice

	push {lr}
	ldr r0, =hidden3
	mov r1, r4
	mov r2, r5
	mov r3, r6
	bl printf
	ldr r0, =hidden4
	mov r1, r7
	mov r2, r8
	bl printf
	b drink_Input
	pop {lr}
	mov pc, lr

error:
	ldr r0, =errorLights
	bl printf
	b myexit

myexit:

	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite
	mov r0, #5000
	bl delay
	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr r0, =pin5
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	ldr r0, =pin4
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	ldr r0, =pin3
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	ldr r0, =pin2
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite

	ldr r0, =change
	mov r1, r10
	bl printf
	mov r7, #0x01
	svc 0

.data
.balign 4
format: .asciz "\n--------------------------------------------------------------------------------\n\n"
.balign 4
welcome1: .asciz "Welcome to a soft drink vending machine!\n"
.balign 4
welcome2: .asciz "The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents\n"
.balign 4
instruct: .asciz "Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end\n"
.balign 4
input_wrong: .asciz "The input was wrong, please enter another value\n\n"
.balign 4
drink_instruct: .asciz "Please select (Red) Coke, (Yellow) Sprite, (Green) Dr.Pepper, (Blue) Diet coke\n"
.balign 4
change_Entered: .asciz "%d cents entered.\n\n"
.balign 4
dispense_coke: .asciz "coke has been dispensed.\n\n"
.balign 4
dispense_sprite: .asciz "sprite has been dispensed.\n\n"
.balign 4
dispense_dp: .asciz "dr.pepper has been dispensed.\n\n"
.balign 4
dispense_diet: .asciz "diet coke has been dispensed.\n\n"
.balign 4
dispense_mellow: .asciz "mellow yellow has been dispensed.\n\n"
.balign 4
wrong_ip: .asciz "Please select one of the choices\n\n"
.balign 4
empty: .asciz "There are no more drinks of this type, please make another choice\n\n"
.balign 4
empty_m: .asciz "There are no more drinks availiable\n"
.balign 4
hidden: .asciz "%d cokes || %d sprites || %d dr.pepper\n"
.balign 4
hidden2: .asciz "%d diet cokes || %d mellow yellow \n\n"
.balign 4
hidden3: .asciz "%d cokes || %d sprites || %d dr.pepper\n"
.balign 4
hidden4: .asciz "%d diet cokes || %d mellow yellow \n\n"
.balign 4
change: .asciz "%d cents dispensed.\n\n"
.balign 4
errorLights: .asciz "There was a problem initializing the lights.\n"
.balign 4
confirmation1: .asciz "Are you sure you want a coke? Y/N \n"
.balign 4
confirmation2: .asciz "Are you sure you want a sprite? Y/N \n"
.balign 4
confirmation3: .asciz "Are you sure you want a dr.pepper? Y/N \n"
.balign 4
confirmation4: .asciz "Are you sure you want a diet coke? Y/N \n"
.balign 4
confirmation5: .asciz "Are you sure you want a mellow yellow? Y/N \n"
.balign 4
input1: .asciz "%s"
in: .word 0
.balign 4
pin2: .word 2
.balign 4
pin3: .word 3
.balign 4
pin4: .word 4
.balign 4
pin5: .word 5
.balign 4
delayMs: .word 1000
delayMs2: .word 250
buttonBlue:   .word 7 @Blue button
buttonGreen:  .word 0 @Green button
buttonYellow: .word 6 @Yellow button
buttonRed:    .word 1 @Red button

OUTPUT = 1 
INPUT  = 0  

PUD_UP   = 2  
PUD_DOWN = 1 

LOW  = 0 
HIGH = 1

.text
.global printf
.global scanf
.extern pinMode
.extern wiringPiSetup
.extern delay
.extern digitalWrite

.extern pinMode

/*
--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (Red) Coke, (Yellow) Sprite, (Green) Dr.Pepper, (Blue) Diet coke
Are you sure you want a coke? Y/N 
y
coke has been dispensed.

45 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (Red) Coke, (Yellow) Sprite, (Green) Dr.Pepper, (Blue) Diet coke
Are you sure you want a sprite? Y/N 
y
sprite has been dispensed.

45 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (Red) Coke, (Yellow) Sprite, (Green) Dr.Pepper, (Blue) Diet coke
Are you sure you want a dr.pepper? Y/N 
y
dr.pepper has been dispensed.

45 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (Red) Coke, (Yellow) Sprite, (Green) Dr.Pepper, (Blue) Diet coke
Are you sure you want a diet coke? Y/N 
y
diet coke has been dispensed.

45 cents dispensed.

There are no more drinks availiable
0 cents dispensed.

*/

