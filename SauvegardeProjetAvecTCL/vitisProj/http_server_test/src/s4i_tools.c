/*
 * s4i_tools.c
 *
 *  Created on: 21 fÃ©vr. 2020
 *      Author: francoisferland
 */

#include "s4i_tools.h"
#include "xparameters.h"

#include <xgpio.h>
#include "myADCip.h"

#include "xil_printf.h"

XGpio s4i_xgpio_input_;

#define MY_AD1_IP_BASEADDRESS  XPAR_MYADCIP_0_S00_AXI_BASEADDR
#define AD1_NUM_BITS 	12
const float ReferenceVoltage = 3.3;

void s4i_init_hw()
{
    // Initialise l'accï¿½s au matÅ½riel GPIO pour s4i_get_sws_state().
	XGpio_Initialize(&s4i_xgpio_input_, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&s4i_xgpio_input_, 1, 0xF);
}


int s4i_is_api_get(char *buf)
{
    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/sws".
    // Retourner 0 si ce n'est pas le cas.
    // Attention: la chaâ€�ne possï¿½de la requï¿½te complï¿½te (ex. "GET cmd/sws").
    // Un indice : Allez voir les mÅ½thodes similaires dans web_utils.c.

	/* skip past 'GET /' */
	buf += 5;

	/* then check for cmd/printxhr */
	return (!strncmp(buf, "api", 3));
}

int s4i_is_api_full(char *buf)
{
    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/sws".
    // Retourner 0 si ce n'est pas le cas.
    // Attention: la chaâ€�ne possï¿½de la requï¿½te complï¿½te (ex. "GET cmd/sws").
    // Un indice : Allez voir les mÅ½thodes similaires dans web_utils.c.

	/* skip past 'GET /' */
	buf += 5;

	/* then check for cmd/printxhr */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "full", 4));
}

int s4i_is_api_temp_max(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/temperature/max */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "temperature", 10) && !strncmp(buf + 16, "max", 3));
}

int s4i_is_api_temp_min(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/temperature/min */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "temperature", 10) && !strncmp(buf + 16, "min", 3));
}

int s4i_is_api_temp_avg(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/temperature/max */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "temperature", 10) && !strncmp(buf + 16, "avg", 3));
}

int s4i_is_api_sound_max(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/sound/max */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "sound", 5) && !strncmp(buf + 10, "max", 3));
}

int s4i_is_api_sound_min(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/sound/min */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "sound", 5) && !strncmp(buf + 10, "min", 3));
}

int s4i_is_api_sound_avg(char *buf)
{
	/* skip past 'GET /' */
	buf += 5;

	/* then check for api/sound/max */
	return (!strncmp(buf, "api", 3) && !strncmp(buf + 4, "sound", 5) && !strncmp(buf + 10, "avg", 3));
}

unsigned int s4i_get_sws_state()
{
    // Retourne l'Å½tat des 4 interrupteurs dans un entier (un bit par
    // interrupteur).
    return XGpio_DiscreteRead(&s4i_xgpio_input_, 1);
}

u8 AD1_GetSampleRaw(u8 address, bool first)
{
	if (address < 4)
	{
		u32 rawData =  MYADCIP_mReadReg(MY_AD1_IP_BASEADDRESS, address);

		if (address == 0x0)
		{
			xil_printf("registre: %x\r\n", rawData);
		}

		if (first)
		{
			rawData &= 0x00000FF0;
			rawData >>= 4;
		} else {
			rawData &= 0x0FF00000;
			rawData >>= 20;
		}

		return (u8) rawData;
	}
	return -1;
}

