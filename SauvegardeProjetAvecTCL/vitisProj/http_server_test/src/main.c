/*
 * main.c
 *
 * Atelier #3 - Projet S4 Génie informatique - H21
 *
 *  Author: Larissa Njejimana
 */



#include <xgpio.h>
#include <stdio.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "PmodGPIO.h"
//#include "PmodOLED.h"
#include "myADCip.h"

u16 AD1_GetSampleRaw();
float AD1_GetSampleVoltage();
void DisplayVoltage(float value, char *voltage_char);

#define MY_AD1_IP_BASEADDRESS  XPAR_MYADCIP_0_S00_AXI_BASEADDR
#define AD1_NUM_BITS 	12

const float ReferenceVoltage = 3.3;


int main()
{
	XGpio inputSW, outputLED;
	PmodGPIO pmod8LD;
	//PmodOLED oledDevice;
	int sw_data = 0;
	u8 pmod8LDvalue = 0;
	float currentVoltage = 0;
	char voltageChar[5];
	u16 rawDataNext = 0;
	u16 rawData = 0;

    print("Bienvenue\n\r");


    // Initialiser AXI_GPIO  IPs
	XGpio_Initialize(&inputSW, XPAR_AXI_GPIO_0_DEVICE_ID);		// switches
	XGpio_Initialize(&outputLED, XPAR_AXI_GPIO_1_DEVICE_ID);	// leds

	XGpio_SetDataDirection(&inputSW, 1, 0xF); 		//Fixer la direction du port 1 de l'AXI_GPIO_0 comme input
	XGpio_SetDataDirection(&outputLED, 1, 0x0);		//Fixer la direction du port 1 de l'AXI_GPIO_1 comme output

	// Initialiser PmodGPIO pour le Pmod_8LD
	GPIO_begin(&pmod8LD, XPAR_PMODGPIO_0_AXI_LITE_GPIO_BASEADDR, 0x00);

	// Initialiser le Pmod Oled
	//OLED_Begin(&oledDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
	// Désactiver la mise à jour automatique de l'écran de l'OLED
	//OLED_SetCharUpdate(&oledDevice, 0);
	// Préparer l'écran pour afficher l'état des boutons et des switch
	//OLED_ClearBuffer(&oledDevice);
	//OLED_SetCursor(&oledDevice, 0, 3);
	//OLED_PutString(&oledDevice, "Voltage = ");
	//OLED_Update(&oledDevice);

	print("Initialisation finie\n\r");

	while(1){

		// Lire puis afficher les valeurs des switch sur les leds
		sw_data = XGpio_DiscreteRead(&inputSW, 1);
		XGpio_DiscreteWrite(&outputLED, 1, sw_data);
		//xil_printf("Switch value = 0x%X\n\r", sw_data);


		// lire la tension provenant du PmodAD1
		currentVoltage = AD1_GetSampleVoltage();


		// Affichage graduel du voltage sur le Pmod 8LD
		// 3.3V => tous les leds allumés
		// 0.0V => tous les leds éteints
		pmod8LDvalue = 0xFF << (8 - (u8)(currentVoltage / ReferenceVoltage * 8));
		GPIO_setPins(&pmod8LD,pmod8LDvalue);


		// Affichage du voltage sur le Pmod OLED
		//sprintf(voltageChar,"%2.2f",currentVoltage);
		//OLED_SetCursor(&oledDevice, 10, 3);
		//OLED_PutString(&oledDevice, voltageChar);
		//OLED_Update(&oledDevice);

		//OLED_SetCursor(&oledDevice, 15, 3);
		//OLED_PutString(&oledDevice, "V");
		//OLED_Update(&oledDevice);

		rawDataNext = AD1_GetSampleRaw();

		printf("Entre hexa : %03x\n", rawDataNext);

		sleep(1);



		/*if(rawDataNext != rawData) {
			rawData = rawDataNext;
			//printf("Entre volt: %f\n", AD1_GetSampleVoltage());
			//printf("Entre : %d\n", AD1_GetSampleRaw());
			printf("Entre hexa : %03x\n", rawData);

			/*float temp = (50*((int16_t)rawData)/4095.f) - 25;
			printf("Value: %03x <-> %2.2f\r\n", rawData, temp);
		}*/

		//printf("Entre : %d\n", AD1_GetSampleRaw());
		//printf("Entre hexa : %03x\n", AD1_GetSampleRaw());
		//printf("Entre volt: %f\n", AD1_GetSampleVoltage());
	}

    return 0;
}


u16 AD1_GetSampleRaw()
{
	u16 rawData =  MYADCIP_mReadReg(MY_AD1_IP_BASEADDRESS, 0x0) & 0xFFF;
	return rawData;
}


float AD1_GetSampleVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << AD1_NUM_BITS) - 1);

	u16 rawSample = AD1_GetSampleRaw();

	return (float)rawSample * conversionFactor;

}
