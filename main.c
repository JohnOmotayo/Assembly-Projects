#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include<stdio.h>


//getting sample based on frequency and index using linear interpolation
double sine_wave(float f, int i) {
	
 	float index = ((int)f*i)%48000; //compute index from 0-47999 in wavetable
	float decimalIndex = (f*i) -(int)(f*i);
	float signal = (1.0 - decimalIndex) * sine[(int)index] + decimalIndex * sine[(int)index +1];
	
	return signal;
}


int main() {

	//int sampleRate = 48000;
	//int sample = 240;
	//float f = 30;
	//int amplitude = 100;
	//int notes[8] [48000]; //array with notes
	//float f = 0; //frequency of note to play
	//int bc = 0; //has a key been released flag
	int samples = 0;
	int x[8] = {0,0,0,0,0,0,0,0}; //array of notes
	char input; //character for keyboard data
	int t = 0;
	double history[320] = { 0 };
	double v = 5; // volume control multiplier
	float sounds[8] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};

	/*int_setup(1, (int []){199}); //setting up timer 0
	HPS_TIM_config_t hps_tim; //time configuration for tim0
	hps_tim.tim = TIM0;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
	hps_tim.timeout = 20; //really small...could be larger

	HPS_TIM_config_ASM(&hps_tim);

	*/
		VGA_clear_pixelbuff_ASM();
		VGA_clear_charbuff_ASM();

		while(1) {
			float f = 0;
			//	MAKE PROJECT!
			
				if (read_ps2_data_ASM(&input)){
					if(input == 0xF0){
					while(!read_ps2_data_ASM(&input));
					if(input == 0x1C) { 
							x[0] = 0; //note off
						}else if (input == 0x1B) {
							x[1] = 0;
						}else if (input == 0x23) {
							x[2] = 0;
						}else if (input == 0x2B) {
							x[3] = 0;
						}else if (input == 0x3B) {
							x[4] = 0;
						}else if (input == 0x42) {
							x[5] = 0;
						}else if (input == 0x4B) {
							x[6] = 0;
						}else if (input == 0x4C) {
							x[7] = 0;
						}
				}else{
						if(input == 0x1C) { 
							x[0] = 1; //note off
						}else if (input == 0x1B) {
							x[1] = 1;
						}else if (input == 0x23) {
							x[2] = 1;
						}else if (input == 0x2B) {
							x[3] = 1;
						}else if (input == 0x3B) {
							x[4] = 1;
						}else if (input == 0x42) {
							x[5] = 1;
						}else if (input == 0x4B) {
							x[6] = 1;
						}else if (input == 0x4C) {
							x[7] = 1;
						}else if (input == 0x32) { //'B' key for volume up
						v++; //volume amplitude times 2
					}else if (input == 0x2A) { //'V' key for volume down
						v--; //volume amplitude divided by 2
							if (v < 0.01){
								v = 0.01;
							}		
						}
				}
			}


		//adding notes together
		register int sum = 0;
		int i = 0;
		for (i = 0; i < 8; i++){
			if (x[i]) {
				sum += sine_wave(sounds[i],t);
			}
		}

		sum *= v; //scales sum to volume level
		while(!audio_write_data_ASM(sum, sum));
		int drawIndex = 0;
		double valToDraw = 0;
		
		t = (t+1)%48000;	
		if((t%10 == 0)){
			drawIndex = (t/10)%320;
			//clear drawn points
			VGA_draw_point_ASM(drawIndex, history[drawIndex], 0);
			//120 centers the signal on the screen, 2000000 is abitrary to make it fit
			valToDraw = 120 + sum/2000000;
			//add new points to history array
			history[drawIndex] = valToDraw;
			//draw new points
			VGA_draw_point_ASM(drawIndex, valToDraw, 0xFFFFFFFF);
		}

		}

	return 0;
}



