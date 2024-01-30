[org 0x1000] ; 并不是随便放置的

dw 0x55aa; 魔术，用于判断错误

; 打印字符串
mov si, loading
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


loading:
    db "Loading MyOS...", 10, 13, 0; \n\r