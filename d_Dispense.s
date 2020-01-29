@Filename: d_Dispense
@Author: Houston Calvert
@Purpose: Soft Drink Machine
@as -o d_Dispense.o d_Dispense.s
@gcc -o d_Dispense d_Dispense.o
@./d_Dispense

.global main
main:
		@Create instances of drinks
	mov r4, #5 @coke
	mov r5, #5 @sprite
	mov r6, #5 @dr.pepper
	mov r7, #5 @dietcoke
	mov r8, #5 @mellow yellow
		@Instantiate drink counter
	mov r10, #0
	bl mainloop
	b myexit

mainloop:			@Mainloop for program

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
	
	ldr r9,=in
	ldr r9, [r9]
	mov r11, #0
				@For each instance, add 1 to r11 to check for validity
	cmp r9, #'N'
	addeq r10, r10, #5
	moveq r11, #1
	cmp r9, #'n'
	addeq r10, r10, #5
	moveq r11, #1
	cmp r9, #'D'
	addeq r10, r10, #10
	moveq r11, #1
	cmp r9, #'d'
	addeq r10, r10, #10
	moveq r11, #1
	cmp r9, #'Q'
	addeq r10, r10, #25
	moveq r11, #1
	cmp r9, #'q'
	addeq r10, r10, #25
	moveq r11, #1
	cmp r9, #'B'
	addeq r10, r10, #100
	moveq r11, #1
	cmp r9, #'b'
	addeq r10, r10, #100
	moveq r11, #1
	cmp r9, #'O'				@O is the hidden code
	beq hidden_code
	moveq r11, #1
	cmp r9, #'o'
	beq hidden_code
	moveq r11, #1
	cmp r9, #'X'
	beq myexit
	moveq r11, #1
	cmp r9, #'x'
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
	
	ldr r0, =input1
	ldr r1, =in
	bl scanf
	ldr r12,=in
	ldr r12, [r12]
	mov r11, #0				@Reset r11 to 0 for validation checking

	cmp r12, #'C'
	beq sub_coke
	moveq r11, #1
	cmp r12, #'S'
	beq sub_sprite
	moveq r11, #1
	cmp r12, #'P'
	beq sub_dr_pepper
	moveq r11, #1
	cmp r12, #'D'
	beq sub_diet_coke
	moveq r11, #1
	cmp r12, #'M'
	beq sub_mellow_yellow
	moveq r11, #1
	cmp r12, #'O'
	beq hidden_code2
	moveq r11, #1
	cmp r12, #'X'
	beq myexit
	moveq r11, #1
	cmp r12, #'c'
	beq sub_coke
	moveq r11, #1
	cmp r12, #'s'
	beq sub_sprite
	moveq r11, #1
	cmp r12, #'p'
	beq sub_dr_pepper
	moveq r11, #1
	cmp r12, #'d'
	beq sub_diet_coke
	moveq r11, #1
	cmp r12, #'m'
	beq sub_mellow_yellow
	moveq r11, #1
	cmp r12, #'o'
	beq hidden_code2
	moveq r11, #1
	cmp r12, #'x'
	beq myexit
	moveq r11, #1
	ldr r0, =change
	mov r1, r10
	bl printf

	cmp r11, #1
	bne wrong_input2

	mov r11, #0
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
	
	mov r10, #0
	b mainloop
	pop {lr}
	mov pc, lr

sub_mellow_yellow:

	push {lr}
	ldr r0, =confirmation5
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

	cmp r8, #0
	beq empty_drinks
	subgt r8, r8, #1
	ldr r0, =dispense_mellow
	bl printf
	sub r10, r10, #55
	ldr r0, =change
	mov r1, r10
	bl printf
	
	mov r10, #0
	b mainloop
	pop {lr}
	mov pc, lr

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
	cmp r8, #0
	addeq r11, #1
	
	cmp r11, #5
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
myexit:
	
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
instruct: .asciz "Enter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end\n"
.balign 4
input_wrong: .asciz "The input was wrong, please enter another value\n\n"
.balign 4
drink_instruct: .asciz "Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end \n"
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

//Sample execution

/*
--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
m
Are you sure you want a mellow yellow? Y/N 
n
Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
m
Are you sure you want a mellow yellow? Y/N 
y
mellow yellow has been dispensed.

45 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
y
The input was wrong, please enter another value


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
x
0 cents dispensed.
--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
o
5 cokes || 5 sprites || 5 dr.pepper
5 diet cokes || 5 mellow yellow 


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
n
5 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
d
15 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
q
40 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
140 cents entered.

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
c
Are you sure you want a coke? Y/N 
n
Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
s
Are you sure you want a sprite? Y/N 
y
sprite has been dispensed.

85 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
Are you sure you want a dr.pepper? Y/N 
y
dr.pepper has been dispensed.

45 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
n
5 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
q
30 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
d
40 cents entered.

Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
140 cents entered.

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
o
5 cokes || 4 sprites || 4 dr.pepper
5 diet cokes || 5 mellow yellow 

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
Are you sure you want a dr.pepper? Y/N 
y
dr.pepper has been dispensed.

85 cents dispensed.


--------------------------------------------------------------------------------

Welcome to a soft drink vending machine!
The cost of coke, sprite, dr.pepper, diet coke, and mellow yellow is 55 cents
Ënter money nickel (N), dime (D), quarter (Q), dollar (B), or (X) to end
b
100 cents entered.

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
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

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
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

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
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

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
Are you sure you want a dr.pepper? Y/N 
y
There are no more drinks of this type, please make another choice

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
o
5 cokes || 4 sprites || 0 dr.pepper
5 diet cokes || 5 mellow yellow 

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
p
Are you sure you want a dr.pepper? Y/N 
y
There are no more drinks of this type, please make another choice

Please select (C) Coke, (S) Sprite, (P) Dr.Pepper, (D) Diet coke, (M) Mellow yellow, or (X) to end 
*/


