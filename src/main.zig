comptime {
    asm (
        \\.section .text.boot
        \\.global _start
        \\_start:
        \\b main 
    );
}

export fn main() void {
    while (true) {}
}
