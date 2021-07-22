/*
 * s4i_tools.h
 *
 *  Created on: 21 févr. 2020
 *      Author: francoisferland
 */

#ifndef SRC_S4I_TOOLS_H_
#define SRC_S4I_TOOLS_H_

#define S4I_NUM_SWITCHES	4

#include "xil_printf.h"
#include <stdbool.h>

void			s4i_init_hw();
//int 			s4i_is_cmd_sws(char *buf);

int				s4i_is_api_get(char *buff);
int				s4i_is_api_full(char *buff);

int				s4i_is_api_temp_max(char *buff);
int				s4i_is_api_temp_min(char *buff);
int				s4i_is_api_temp_avg(char *buff);

int				s4i_is_api_sound_max(char *buff);
int				s4i_is_api_sound_min(char *buff);
int				s4i_is_api_sound_avg(char *buff);

unsigned int 	s4i_get_sws_state();

u8 AD1_GetSampleRaw(u8 address, bool first);

int getCurrentTemp();
int getMaxTemp();
int getMinTemp();
int getAvgTemp();
int getCurrentSound();
int getMaxSound();
int getMinSound();
int getAvgSound();


#endif /* SRC_S4I_TOOLS_H_ */
