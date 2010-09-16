[BITS 32]
global loader           ; making entry point visible to linker
loader:
    mov esp, _sys_stack
    jmp stublet

align 4
multiboot:
    PAGEALIGN	equ 1<<0				; align loaded modules on page boundaries
    MEMINFO	equ 1<<1				; provide memory map
    FLAGS	equ PAGEALIGN | MEMINFO			; the Multiboot 'flag' field
    MAGIC	equ 0x1BADB002				; lets bootloader find the header
    CHECKSUM	equ -(MAGIC + FLAGS)			; checksum required

    dd MAGIC
    dd FLAGS
    dd CHECKSUM

stublet:
    extern kmain
    call  kmain			; call kernel proper
    jmp $			; loop forever in case kernel ends unexpexted

SECTION .bss
    resb 8192		; reserve 16k stack on a quadword boundary
_sys_stack
