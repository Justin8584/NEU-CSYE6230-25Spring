#include "include/screen.h"
#include "include/ports.h"

#define VIDEO_MEMORY 0xB8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0F

/* Global variables to keep track of the cursor position. */
static int cursor_x = 0;
static int cursor_y = 0;

/* Update the hardware cursor via VGA ports. */
static void update_cursor(void)
{
    int pos = cursor_y * MAX_COLS + cursor_x;
    port_byte_out(0x3D4, 14);
    port_byte_out(0x3D5, pos >> 8);
    port_byte_out(0x3D4, 15);
    port_byte_out(0x3D5, pos & 0xFF);
}

void clear_screen(void)
{
    unsigned char *vidmem = (unsigned char *)VIDEO_MEMORY;
    for (int row = 0; row < MAX_ROWS; row++)
    {
        for (int col = 0; col < MAX_COLS; col++)
        {
            int index = (row * MAX_COLS + col) * 2;
            vidmem[index] = ' ';
            vidmem[index + 1] = WHITE_ON_BLACK;
        }
    }
    cursor_x = 0;
    cursor_y = 0;
    update_cursor();
}

void print(const char *message)
{
    unsigned char *vidmem = (unsigned char *)VIDEO_MEMORY;
    for (int i = 0; message[i] != '\0'; i++)
    {
        char c = message[i];
        if (c == '\n')
        {
            cursor_x = 0;
            cursor_y++;
        }
        else
        {
            int index = (cursor_y * MAX_COLS + cursor_x) * 2;
            vidmem[index] = c;
            vidmem[index + 1] = WHITE_ON_BLACK;
            cursor_x++;
        }
        if (cursor_x >= MAX_COLS)
        {
            cursor_x = 0;
            cursor_y++;
        }
        if (cursor_y >= MAX_ROWS)
        {
            /* Simple scrolling: reset to top */
            cursor_y = 0;
        }
    }
    update_cursor();
}

void print_at(const char *message, int col, int row)
{
    if (col >= 0 && row >= 0)
    {
        cursor_x = col;
        cursor_y = row;
    }
    print(message);
}