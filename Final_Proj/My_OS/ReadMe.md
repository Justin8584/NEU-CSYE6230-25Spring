# CSYE6230 Final Project - Create My Own Operating System

This project implements a basic operating system with a bootloader, kernel, and basic drivers. The OS is built using a cross-compiler and can be run using QEMU.

## Prerequisites

### Required Tools
- NASM (Netwide Assembler)
- GCC Cross-Compiler (x86_64-elf-gcc)
- Make
- QEMU

## Installation Instructions

### macOS (M-Series Chip ARM)
1. Install Homebrew if you haven't already:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install required packages:
   ```bash
   brew install nasm
   brew install qemu
   ```

3. Install GCC Cross-Compiler:
   ```bash
   brew install x86_64-elf-gcc
   ```

### Windows (TODO)
1. Install Chocolatey (Windows package manager) from https://chocolatey.org/

2. Install required packages:
   ```powershell
   choco install nasm
   choco install qemu
   ```

3. For the cross-compiler, you'll need to:
   - Download and install MSYS2 from https://www.msys2.org/
   - Open MSYS2 terminal and run:
     ```bash
     pacman -S mingw-w64-x86_64-gcc
     ```

### Linux (Ubuntu/Debian) (TODO)
1. Install required packages:
   ```bash
   sudo apt update
   sudo apt install nasm qemu-system-x86 make gcc
   ```

2. Install GCC Cross-Compiler:
   ```bash
   sudo apt install gcc-multilib
   ```

## Building the OS

1. Clone the repository:
   ```bash
   git clone [your-repository-url]
   cd My_OS
   ```

2. Build the OS:
   ```bash
   make
   ```

## Running the OS

### macOS
```bash
make run
```

### Windows
```powershell
make run
```

### Linux
```bash
make run
```

## Project Structure

- `boot/` - Contains bootloader and boot-related assembly files
- `kernel/` - Contains the kernel source code
- `drivers/` - Contains device drivers
- `libc/` - Contains C library implementations
- `Makefile` - Build configuration
- `link.ld` - Linker script

## Cleaning Up

To clean build artifacts:
```bash
make clean
```

## Troubleshooting

1. If you encounter permission issues on Linux/macOS:
   ```bash
   chmod +x boot/*.asm
   ```

2. If QEMU fails to start, ensure you have the correct permissions and QEMU is properly installed.

3. For cross-compiler issues, verify your PATH includes the cross-compiler's bin directory.

## Contributing

[Add contribution guidelines if applicable]

## License

[Add license information]
