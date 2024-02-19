# Micro_CSE4117
 special microprocessor design
 
![WhatsApp Görsel 2024-01-22 saat 04 52 48_9401df08](https://github.com/ATalhaTimur/Micro_CSE4117/assets/93510585/3d9e9fca-8107-40a4-84d4-0223f6aa809d)

HW1

In this assignment, you will increase the data on the seven-segment display. You will also
manipulate scan speed. For this purpose, you will use two push buttons that are on the DE0-
nano FPGA board.
Realize the following instructions with SystemVerilog and FPGA:
1) Initially, a constant value (e.g. F7A2) will be displayed on the seven-segment display.
2) If you press the left push button, the data on the display will be incremented by one.
When data reaches 0xFFFF, it will roll over to 0x0000 in the next button press.
3) If you press the right push button, scan speed of the grounds will change.
a. Initially, the scan speed must be sufficient for flicker-free display.
b. When you press the button, the scan speed will drop, and the digits start to flicker.
c. When you press it again, the scan speed will drop so low that only a single digit on
the seven-segment display will be seen.
d. If you press it once more, go to a.

HW2

PART 2 (FPGA) (50 points or 75 points)
You will implement in FPGA a system which has a CPU and its associated I/O circuits. You
will also write the specified software that will run on this system.
You MUST write your program in SystemVerilog, NOT in Verilog.
Implement a CPU on FPGA and connect it with a 4x7-segment display. You will also use the two
buttons on the FPGA board.
At the start, CPU must display the number 1 on 4x7 segment. When the user presses the left button,
the number on display is incremented by 1. When the user presses the right button, the number will
be multiplied by 2.
--- If you do this by continually polling both buttons, and use BIRD, you will get 50 points.
--- If instead you do this by controlling increment button with polling but multiply by 2 button with
interrupt and use Vertebrate, you will get 75 points.
As in question 1, you have to update the assembler and display all your numbers in decimal.
Conversion to decimal must be done by a software subroutine.

FINAL PROJECT

In this project, you will use Bird-CPU to read keystrokes from a ps2 keyboard and draw a scene
on a VGA monitor.
Your system will draw
 A spaceship bitmap
 and a planet bitmap
 on a green background.
Spaceship bitmap will be 16 pixels wide and 16 pixels high, and will be exactly at the center
of the screen at the start up. Its design is given below (or, you can design your own). It will
be red.
0000000010000000

0000000111000000

0000000111000000

0000000111000000

0000000111000000

0000001111100000

0000011111110000

0000111111111000

0001111111111100

0000000111000000

0000000111000000

0000000111000000

0000000111000000

0000001111100000

0000011111110000

0000000111000000

Planet bitmap is again 16x16, and it is of shape circle. Design one of your own. It is yellow. It
will also start at the center of the VGA screen.
Motion of spaceship
The motions of spaceship will be controlled by the keyboard input:
--When the key W is pressed, the spaceship will move 4 pixels up.
--When the key S is pressed, the spaceship will move 4 pixels down.
--When the key A is pressed, the spaceship will move 4 pixels left.
--When the key D is pressed, the spaceship will move 4 pixels right.
-- spaceship should not pass the edges of the screen.
When the keys are released, no extra movement will occur (ie, you will disregard the second
scan code which comes when you release the key).

Motion of the planet
The planet will move 10 pixels/second up in the vertical direction and 20 pixels/second to the
right in the horizontal direction (these numbers are only approximate, do not try to make
them exact). Whenever the planet hits left or right edge, its horizontal speed reverses.
Whenever the planet hits top or bottom edge, its vertical speed reverses.
Hardware you will build
You can use the Verilog codes for the keyboard host controller interface and Mammal CPU
without change from the website. The CPU will poll the keyboard for keypresses.
VGA module has the registers
Logic [15:0] x_spaceship, y_spaceship, x_planet, y_planet
Logic [15:0] spaceship_bitmap[0:15]
Logic [15:0] planet_bitmap[0:15]
VGA module will print the contents of the spaceship_bitmap and planet_bitmap to screen at
every frame in such a way that the upper left hand corner of planet_bitmap will be at pixel
(x_planet, y_planet) and the upper left hand corner of spaceship_bitmap will be at pixel
(x_spaceship, y_spaceship). The algorithm will be

Infinite loop {
For each (x,y)
If pixel (x,y) is contained in spaceship bitmap
--paint the pixel to the colour of the spaceship (red)
elseif pixel (x,y) is contained in planet bitmap
--paint the pixel to the colour of the planet (yellow)
else
--paint the pixel to the background color (green)
}
Note that the spaceship will always be at the front of the planet.
CPU will have two duties:
 During initialization, CPU will initialize spaceship_bitmap and planet_bitmap to the
appropriate figures. This will require 16 store operations for each bitmap. Also don’t
forget that stack and IDT must be also initialized.
 During operation, CPU will change the registers x_spaceship, y_spaceship, x_planet,
y_planet for each frame, hence cause the spaceship and the planet to move.
Communication between the Mammal CPU and the VGA module will be via interrupts. If CPU
modifies the registers x_spaceship, y_spaceship, x_planet, y_planet while the cpu draws the

frame, artefacts could occur. Hence the modification of these registers should be done during
the vertical flyback. When the vga module starts vertical flyback, it will send an interrupt to
the CPU. CPU, on receiving the interrupt, will modify the registers in the ISR. During the
modification, the VGA module will lower the interrupt signal. In all the other times, the CPU
will poll the keyboard.

You could use the codes for the PS2 keyboard module and Mammal CPU without change (or,
with very little change). You have to modify the top module which "glues" the CPU, keyboard,
and monitor significantly. You are also required to modify the VGA module. Assign addresses
to the keyboard and VGA registers.

On the software side, you have to write the assembly code which manages the hardware for
the given task. Modify the assembler codes given in the lecture notes suitably, and fill in the
blank parts to assemble your code.

![WhatsApp Görsel 2024-01-22 saat 04 57 13_6cb4abc4](https://github.com/ATalhaTimur/Micro_CSE4117/assets/93510585/9a2bdbea-ad69-4b3d-83a8-29a241db8bb3)
