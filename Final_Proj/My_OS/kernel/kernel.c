#include "include/screen.h"
#include "include/keyboard.h"
#include "include/ports.h"

void wait_for_key(void)
{
    char c;
    // Busy-wait until a key press is detected.
    while ((c = poll_keyboard()) == 0)
    {
        // Optionally, add a small delay here.
    }
    // Echo the pressed key to the screen.
    char str[2] = {c, '\0'};
    print(str);
}

int main(void)
{
    clear_screen();
    print("Welcome to MyOS!\n");
    print("This is a simple operating system from scratch.\n\n");
    print("Type something: ");

    while (1)
    {
        wait_for_key();
    }

    return 0;
}