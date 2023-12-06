; 代码在内存中的位置
[org 0x7c00]

; 设置屏幕模式为文本模式，清除屏幕
mov ax, 3
int 0x10

; 初始化段寄存器，（如果不初始化会出错）
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
; 初始化栈的位置
mov sp, 0x7c00

; 初始化数据段的位置，0xb8000 文本显示器的内存区域
mov ax, 0xb800
mov ds, ax
; 显示一个H
mov byte [0], 'H'

; 阻塞
jmp $

; 填充 0 (除开最后两个字节外，从开头到现在)
times 510 - ($ - $$) db 0

; 主引导扇区的最后两个字节必须是0x55, 0xaa
; dw 0xaa55  (小端存储等)
db 0x55, 0xaa
