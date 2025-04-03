#ifndef KEYBOARD_H
#define KEYBOARD_H

/* Initializes the keyboard. */
void init_keyboard(void);

/* Polls the keyboard and returns the corresponding ASCII character, or 0 if none.
   This function ignores key release events. */
char poll_keyboard(void);

/* Polls the keyboard and returns the raw scancode, or 0 if no data is available.
   This function can be used for low-level debugging. */
unsigned char poll_keyboard_raw(void);

#endif