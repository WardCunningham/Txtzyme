/* Simple example for Teensy USB Development Board
 * http://www.pjrc.com/teensy/
 * Copyright (c) 2008 PJRC.COM, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdint.h>
#include <util/delay.h>
#include "usb_serial.h"
#include "analog.h"

#define LED_CONFIG	(DDRD |= (1<<6))
#define LED_OFF		(PORTD &= ~(1<<6))
#define LED_ON		(PORTD |= (1<<6))
#define CPU_PRESCALE(n) (CLKPR = 0x80, CLKPR = (n))

#define INPUT_MODE_DEC 0
#define INPUT_MODE_HEX 1

void send_str(const char *s);
uint8_t recv_str(char *buf, uint8_t size);
void parse(const char *buf);

// Basic command interpreter for controlling port pins
int main(void) {
	char buf[64];
	uint8_t n;

	// set for 16 MHz clock, and turn on the LED
	CPU_PRESCALE(0);
	LED_CONFIG;
	LED_ON;

	// initialize the USB, and then wait for the host
	// to set configuration.  If the Teensy is powered
	// without a PC connected to the USB port, this
	// will wait forever.
	usb_init();
	while (!usb_configured()) /* wait */ ;
	_delay_ms(1000);

	while (1) {
		// wait for the user to run their terminal emulator program
		// which sets DTR to indicate it is ready to receive.
		while (!(usb_serial_get_control() & USB_SERIAL_DTR)) /* wait */ ;

		// discard anything that was received prior.  Sometimes the
		// operating system or other software will send a modem
		// "AT command", which can still be buffered.
		// usb_serial_flush_input();

		// and then listen for commands and process them
		while (1) {
			// send_str(PSTR("> "));
			n = recv_str(buf, sizeof(buf));
			if (n == 255) break;
			// send_str(PSTR("\r\n"));
			parse(buf);
		}
	}
}

// Send a string to the USB serial port.  The string must be in
// flash memory, using PSTR
//
void send_str(const char *s) {
	char c;
	while (1) {
		c = pgm_read_byte(s++);
		if (!c) break;
		usb_serial_putchar(c);
	}
}

void send_num(const uint16_t num) {
	if (num > 9) {
		send_num(num/10);
	}
	usb_serial_putchar('0' + num%10);
}

// Receive a string from the USB serial port.  The string is stored
// in the buffer and this function will not exceed the buffer size.
// A carriage return or newline completes the string, and is not
// stored into the buffer.
// The return value is the number of characters received, or 255 if
// the virtual serial connection was closed while waiting.
//
uint8_t recv_str(char *buf, uint8_t size) {
	int16_t r;
	uint8_t count=0;

	while (count < (size-1)) {
		r = usb_serial_getchar();
		if (r != -1) {
			if (r == '\r' || r == '\n') break;
			if (r >= ' ' && r <= '~') {
				*buf++ = r;
				// usb_serial_putchar(r);
				count++;
			}
		} else {
			if (!usb_configured() ||
			  !(usb_serial_get_control() & USB_SERIAL_DTR)) {
				// user no longer connected
				*buf = 0;
				return 255;
			}
			// just a normal timeout, keep waiting
		}
	}
	*buf = 0;
	return 0;
}

// parse a user command and execute it, or print an error message
//

uint8_t port = 'd'-'a';
uint8_t pin = 6;
uint16_t x = 0;
uint8_t input_mode = 0;

void parse(const char *buf) {
	uint16_t count = 0;
	char *loop;
	char ch;
	while ((ch = *buf++)) {
		switch (ch) {
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
			case 'A':
			case 'B':
			case 'C':
			case 'D':
			case 'E':
			case 'F':
                if (input_mode == INPUT_MODE_DEC) {
                    if ( ch > '9' ) {                   //make sure we have a decimal number
                        x = 0;                          //fail with a known output
                        break;
                    }
                    x = ch - '0';
                    while (*buf >= '0' && *buf <= '9') {
                        x = x*10 + (*buf++ - '0');
                    }
                }
                if (input_mode == INPUT_MODE_HEX) {
                    if ( ch < 'A' ) x = ch - '0';
                    else x = ch - 55;                   // 'A'=65 but it need to be equal 10
                    while ( (*buf >= '0' && *buf <= '9') || (*buf >= 'A' && *buf <= 'F') ) {
                        if ( *buf < 'A' ) x = x*16 + (*buf++ - '0');
                        else x = x*16 + (*buf++ - 55);
                    }
                    input_mode = INPUT_MODE_DEC;
                }
				break;
			case 'p':
				send_num(x);
				send_str(PSTR("\r\n"));
				break;
			case 'a':
			case 'b':
			case 'c':
			case 'd':
			case 'e':
			case 'f':
				port = ch - 'a';
				pin = x % 8;
				break;
			case 'i':
				*(uint8_t *)(0x21 + port * 3) &= ~(1 << pin);		// direction = input
				x = *(uint8_t *)(0x20 + port * 3) & (1 << pin) ? 1 : 0;	// x = pin
				break;
			case 'o':
				if (x % 2) {
					*(uint8_t *)(0x22 + port * 3) |= (1 << pin);	// pin = hi
				} else {
					*(uint8_t *)(0x22 + port * 3) &= ~(1 << pin);	// pin = low
				}
				*(uint8_t *)(0x21 + port * 3) |= (1 << pin);		// direction = output
				break;
			case 'm':
				_delay_ms(x);
				break;
			case 'u':
				_delay_loop_2(x*(F_CPU/4000000UL));
				break;
			case '{':
				count = x;
				loop = buf;
				while ((ch = *buf++) && ch != '}') {
				}
			case '}':
				if (count) {
					count--;
					buf = loop;
				}
				break;
			case 'k':
				x = count;
				break;
			case '_':
				while ((ch = *buf++) && ch != '_') {
					usb_serial_putchar(ch);
				}
				send_str(PSTR("\r\n"));
				break;
			case 's':
				x = analogRead(x);
				break;
            case 'x':
                if (x == 0) input_mode = INPUT_MODE_HEX;
                break;
            case 'S':
                if ( (x==9999) || (x==0x9999) ) {       //disable SPI port
                    SPCR = 0;
                    break;
                }
                if (x > 8999) {                         //this can catch 9000+config and 0x9000+config
                    DDRB |= (1<<PORTB2);                // MOSI output
                    DDRB &= ~(1<<PORTB3);               // MISO input  these pins valid for Teensy 2.0 and Teensy++ 2.0
                    DDRB |= (1<<PORTB1);                // SCLK output
                    DDRB |= (1<<PORTB0);                // SS output (safer as output, needs to be high if an input)

                    x = (x & 0x0007);                   //keep only lowest three bits
                    if (x > 3) x = 8 + (x & 0x0003);    //move the direction bit one higher
                    SPCR = 0x53 + (int8_t) (x << 2);
                    SPSR = 0;
                    break;
                }
                if (x > 255) {                         //this can catch 256+data and 0x100+data
                    x = x & 0x00FF;
                    SPDR = (int8_t)x;
                    while (!(SPSR & (1<<SPIF)));
                    x = SPDR;
                    break;
                }
                if (x < 256) {
                    SPDR = (int8_t)x;
                    while (!(SPSR & (1<<SPIF)));
                    break;
                }
		}
	}
}


