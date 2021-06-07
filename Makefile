AVR_PATH = /home/luan/Documents/Development/Embedded/avr/avr8-gnu-toolchain-linux_x86_64/
AVRDUDE_PATH = /home/luan/Documents/Development/Embedded/avr/avrdude-6.3

DEVICE = attiny85
CLOCK = 16000000

CC = ${AVR_PATH}/bin/avr-gcc
OBJCOPY = ${AVR_PATH}/bin/avr-objcopy
AVRDUDE = ${AVRDUDE_PATH}/avrdude

PORT = /dev/ttyACM0

COMPILE = $(CC) -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

all: blink.hex

blink.hex: blink.elf
	${OBJCOPY} -j .text -j .data -O ihex blink.elf blink.hex

blink.elf: blink.o
	${COMPILE} -o blink.elf blink.o

blink.o:
	$(COMPILE) -c blink.c -o blink.o

clean:
	rm -rf *.o *.elf *.hex


install: blink.hex
	$(AVRDUDE) -v -V -p attiny85 -P /dev/ttyUSB0 -V -c arduino -b 19200 -U lfuse:w:0xF1:m -U flash:w:blink.hex -C $(AVRDUDE_PATH)/avrdude.conf