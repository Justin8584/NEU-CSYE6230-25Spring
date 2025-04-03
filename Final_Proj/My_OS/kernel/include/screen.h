#ifndef SCREEN_H
#define SCREEN_H

/* Clears the screen and resets the cursor. */
void clear_screen(void);

/* Prints a null‐terminated string at the current cursor position. */
void print(const char *message);

/* Prints a string at the given column and row (if col or row are negative, uses current cursor). */
void print_at(const char *message, int col, int row);

#endif