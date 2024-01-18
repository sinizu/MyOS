# 实模式

- ah: 0x0e
- al: 字符
- int 0x10

# 设置魔术断点

- magic_break: enabled=1
- xchg bx, bx

```s
    ; 代码在内存中的位置
    [org 0x7c00]

    ; 设置屏幕为文本模式，清除屏幕
    mov ax, 3
    int 0x10

    ; 初始化寄存器
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; bochs 的魔术断点
    xchg bx, bx


    mov si, booting
    call print


    ; 阻塞
    jmp $

    print:
        mov ah, 0x0e
    .next:
        mov al, [si]
        cmp al, 0
        jz .done
        ; 打印到屏幕
        int 0x10
        ; 将si移动到下一个字符
        inc si
        jmp .next
    .done:
        ret


    booting:
        db "Booting MyOS...", 10, 13, 0; \n\r

    ; 填充 0
    times 510 - ($ - $$) db 0

    ; 主引导扇区的最后两个字节必须是0x55, 0xaa
    ; dw 0xaa55  (小端存储等)
    db 0x55, 0xaa
```