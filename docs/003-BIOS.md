# 主引导扇区

## BIOS

Basic Input Output System

BIOS 在加电自检将主引导扇区读 0x7c00 位置，跳转到这里执行

    int 0x10 ;BIOS 系统调用，显示器相关功能


## 实模式

8086模式，16位，保护模式

- real mode
- protected mode

```s
; 0xb8000 文本显示器的内存区域
mov ax, 0xb800
mov ds, ax
mov byte [0], 'H'
```

## 实模式的寻址方式

本质就是16位地址线要访问20位的内存

> 有效地址 = 段地址 * 16 + 偏移地址

EA = 0xb800 * 0x10 + 0 = 0xb8000

EA (Effective Address)

16 bit - 1M - 20 bit

20 - 16 = 4

段地址 << 4

## 保护模式

32 bit - 4G

## 主引导扇区结构

- 代码：446B
- 硬盘分区表：64B = 4 * 16B  (有些硬件没有硬盘分区表无法启动)
- 魔数：2B  (0xaa55 - 0x55 0xaa)


## 主引导扇区功能

- 读取内核加载器，并执行
