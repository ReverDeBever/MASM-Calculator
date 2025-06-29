# MASM-Calculator

A Calculator written in MASM (Microsoft Macro Assembler). It’s a tool used to write programs in assembly language for Intel x86 and x64 processors.

MASM is a low-level programming tool that lets you write instructions very close to what the computer actually understands (machine code). It’s mostly used when you need very fast, efficient, or hardware-specific programming.


## Authors

- [@ReverDeBever](https://www.github.com/ReverDeBever)

## Demo

![cal](https://github.com/user-attachments/assets/d85bcd70-bf6d-427f-8791-766e89e488ca)


## Build

I build ```calc.asm``` with MASM Runner Extension by istareatscreens (https://marketplace.visualstudio.com/items?itemName=istareatscreens.masm-runner) in VsCode.

When build, it uses the MASM assembler to translate the ```calc.asm``` source code into an ```.obj``` file. The ```.obj``` file contains machine code, but it's not executable yet.

To make it executable (```.exe``` file), a linker combines the ```.obj``` file with other needer code like system binaries or startup code to produce the final ```.exe``` file.

The extension I used runs both the assembler and linker together.

The latest build is already made.

