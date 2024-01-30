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


mov si, booting
call print

; bochs 的魔术断点
xchg bx, bx

mov edi, 0x1000 ; 读取目标内存
mov ecx, 2 ; 起始扇区(其中应当包含3*8=24位的信息)
mov bl, 4 ; 扇区数量
call read_disk

; 魔术字的错误保护
cmp word [0x1000], 0x55aa
jnz error

; 将魔术字跳过
jmp 0:0x1002

; bochs 的魔术断点
xchg bx, bx

; 阻塞
jmp $

read_disk:
    ; 1.设置读写扇区的数量
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    ; 2.起始扇区的前八位
    inc dx; 0x1f3
    mov al, cl
    out dx, al 

    ; 3.起始扇区的中八位
    inc dx ; 0x1f4
    shr ecx, 8; 保证cl是对应的ecx的中8位
    mov al, cl
    out dx, al 

    ; 4.起始扇区的高八位
    inc dx; 0x1f5
    shr ecx, 8; 
    mov al, cl
    out dx, al 

    ; 5.主盘 - LBA模式
    inc dx; 0x1f6
    shr ecx, 8
    and cl, 0b0000_1111; 将高4位置为零，注意是二进制
    mov al, 0b1110_0000; 
    or al, cl
    out dx, al

    ; 6.开始读硬盘
    inc dx; 0x1f7
    mov al, 0x20; 读硬盘
    out dx, al

    xor ecx, ecx; ecx值为零，性能比较高
    ; loop指令用来实现循环功能，cx (寄存器)存放循环次数
    mov cl, bl; 得到读写扇区的数量

    ; .开头的事函数内部的标记点，不是函数
    .read:
        push cx; 因为.read内部会将cx进行修改
        call .waits; 等待数据准备完毕
        call .reads; 读取一个扇区
        pop cx
        loop .read

    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx; 从端口输入
            jmp $ + 2; nop 直接跳转到下一行
            jmp $ + 2; 作用是给一定延迟
            jmp $ + 2

            and al, 0b1000_1000; 保留第3位和第7位
            cmp al, 0b0000_1000; 取出第3位
            jnz .check; 如果第3位不满足条件会一直check

        ret

    .reads:
        ; 用于读写数据的端口
        mov dx, 0x1f0
        mov cx, 256; 一个扇区256 字
        .readw:
            in ax, dx
            jmp $ + 2; nop 直接跳转到下一行
            jmp $ + 2; 作用是给一定延迟
            jmp $ + 2
            mov [edi], ax; 将值读取到目标内存中
            add edi, 2; 移动到下一个地址，但是为什么是2？？

            loop .readw
        ret

write_disk:
    ; TODO


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

error:
    mov si, .msg
    call print
    hlt; 让CPU停止
    jmp $
    .msg db "Booting Error!", 10, 13, 0; \n\r

; 填充 0
times 510 - ($ - $$) db 0

; 主引导扇区的最后两个字节必须是0x55, 0xaa
; dw 0xaa55  (小端存储等)
db 0x55, 0xaa