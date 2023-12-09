## 创建boot文件
- 编译 nasm -f bin boot.asm -o boot.bin


## 创建硬盘镜像

- bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img

- 将boot.bin 写入主引导扇区
  dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc


## 配置bochs
- ata0-master: type=disk, path=master.img, mode=flat 
- 修改bochsrc 文件 

  - ![Alt text](image.png)
  - ![Alt text](image-1.png)
  - ![Alt text](image-2.png)

## 备注
- nasm：汇编语言编译器
- bochs：调试器