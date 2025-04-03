#include "include/keyboard.h"
#include "include/ports.h"
#include "include/screen.h"

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

void init_keyboard(void)
{
    print("Keyboard initialized\n");
}

/* Returns the raw scancode if available; 0 otherwise. */
unsigned char poll_keyboard_raw(void)
{
    if (port_byte_in(KEYBOARD_STATUS_PORT) & 0x01)
    {
        return port_byte_in(KEYBOARD_DATA_PORT);
    }
    return 0;
}

/* Converts the scancode to an ASCII character for a US QWERTY keyboard.
   Returns 0 if no key press is detected or if the scancode corresponds to a key release. */
char poll_keyboard(void)
{
    unsigned char scancode = poll_keyboard_raw();
    if (scancode == 0)
        return 0;

    // Ignore key release events (scancode high bit set)
    if (scancode & 0x80)
        return 0;

    /* Complete scancode-to-ASCII table for US QWERTY (Set 1).
       Keys with no ASCII representation return 0. */
    static char scancode_to_ascii[] = {
        /* 0x00 */ 0,  // No key
        /* 0x01 */ 27, // ESC
        /* 0x02 */ '1',
        /* 0x03 */ '2',
        /* 0x04 */ '3',
        /* 0x05 */ '4',
        /* 0x06 */ '5',
        /* 0x07 */ '6',
        /* 0x08 */ '7',
        /* 0x09 */ '8',
        /* 0x0A */ '9',
        /* 0x0B */ '0',
        /* 0x0C */ '-',
        /* 0x0D */ '=',
        /* 0x0E */ '\b', // Backspace
        /* 0x0F */ '\t', // Tab
        /* 0x10 */ 'q',
        /* 0x11 */ 'w',
        /* 0x12 */ 'e',
        /* 0x13 */ 'r',
        /* 0x14 */ 't',
        /* 0x15 */ 'y',
        /* 0x16 */ 'u',
        /* 0x17 */ 'i',
        /* 0x18 */ 'o',
        /* 0x19 */ 'p',
        /* 0x1A */ '[',
        /* 0x1B */ ']',
        /* 0x1C */ '\n', // Enter
        /* 0x1D */ 0,    // Left Control
        /* 0x1E */ 'a',
        /* 0x1F */ 's',
        /* 0x20 */ 'd',
        /* 0x21 */ 'f',
        /* 0x22 */ 'g',
        /* 0x23 */ 'h',
        /* 0x24 */ 'j',
        /* 0x25 */ 'k',
        /* 0x26 */ 'l',
        /* 0x27 */ ';',
        /* 0x28 */ '\'',
        /* 0x29 */ '`',
        /* 0x2A */ 0, // Left Shift
        /* 0x2B */ '\\',
        /* 0x2C */ 'z',
        /* 0x2D */ 'x',
        /* 0x2E */ 'c',
        /* 0x2F */ 'v',
        /* 0x30 */ 'b',
        /* 0x31 */ 'n',
        /* 0x32 */ 'm',
        /* 0x33 */ ',',
        /* 0x34 */ '.',
        /* 0x35 */ '/',
        /* 0x36 */ 0,   // Right Shift
        /* 0x37 */ '*', // Keypad *
        /* 0x38 */ 0,   // Left Alt
        /* 0x39 */ ' ', // Spacebar
        /* 0x3A */ 0,   // Caps Lock
        /* 0x3B */ 0,   // F1
        /* 0x3C */ 0,   // F2
        /* 0x3D */ 0,   // F3
        /* 0x3E */ 0,   // F4
        /* 0x3F */ 0,   // F5
        /* 0x40 */ 0,   // F6
        /* 0x41 */ 0,   // F7
        /* 0x42 */ 0,   // F8
        /* 0x43 */ 0,   // F9
        /* 0x44 */ 0,   // F10
        /* 0x45 */ 0,   // Num Lock
        /* 0x46 */ 0,   // Scroll Lock
        /* 0x47 */ 0,   // Keypad 7 / Home
        /* 0x48 */ 0,   // Keypad 8 / Up Arrow
        /* 0x49 */ 0,   // Keypad 9 / Page Up
        /* 0x4A */ '-', // Keypad -
        /* 0x4B */ 0,   // Keypad 4 / Left Arrow
        /* 0x4C */ 0,   // Keypad 5
        /* 0x4D */ 0,   // Keypad 6 / Right Arrow
        /* 0x4E */ '+', // Keypad +
        /* 0x4F */ 0,   // Keypad 1 / End
        /* 0x50 */ 0,   // Keypad 2 / Down Arrow
        /* 0x51 */ 0,   // Keypad 3 / Page Down
        /* 0x52 */ 0,   // Keypad 0 / Insert
        /* 0x53 */ 0,   // Keypad . / Delete
        /* 0x54 */ 0,   // Unused
        /* 0x55 */ 0,
        /* 0x56 */ 0,
        /* 0x57 */ 0,
        /* 0x58 */ 0 // F11 (if present)
        // Extend further if needed.
    };

    if (scancode < sizeof(scancode_to_ascii))
        return scancode_to_ascii[scancode];
    return 0;
}