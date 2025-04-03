#ifndef PORTS_H
#define PORTS_H

/* Reads a byte from the given port. */
unsigned char port_byte_in(unsigned short port);

/* Writes a byte to the given port. */
void port_byte_out(unsigned short port, unsigned char data);

/* Reads a word (2 bytes) from the given port. */
unsigned short port_word_in(unsigned short port);

/* Writes a word (2 bytes) to the given port. */
void port_word_out(unsigned short port, unsigned short data);

#endif