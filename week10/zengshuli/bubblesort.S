.text
addi x2, x0, 1
addi x3, x0, 0
addi x21, x0, 0
#获取用户输入
input:
sw  x2, 0x404(x0)
valid:                   #用valid控制外设交互
lw  x20, 0x410(x0)
beq x20, x0, valid
lw  x18, 0x40c(x0)
sw  x18, 0x408(x0)
sw  x18, 0(x21)
addi x21, x21, 4
sw  x0, 0x404(x0)
validreset:
lw  x20, 0x410(x0)
beq x20, x2, validreset
beq x3, x2, inputNum
inputLength:
addi x17, x18, 0
addi x3, x0, 1
addi x16, x17, 0
addi x16, x16, 1
inputNum:
addi x16, x16, -1
beq x16, x0, main
jal input
#开始执行冒泡
main:
addi x21, x0, 4
bubblesort:
addi x16, x17, 0
addi x13, x0, 1
nextloop:
addi x11, x21, 0 
addi x16, x16, -1
addi x12, x0, 1 
nextnum:
lw  x18, 0(x11)
lw  x15, 4(x11)
blt x18, x15, dont
swap:
sw  x18, 4(x11)
sw  x15, 0(x11)
dont:
beq  x16, x13, output
beq  x12, x16, nextloop
addi x11, x11, 4
addi x12, x12, 1
jal nextnum
valid1:
lw  x20, 0x410(x0)
beq x20, x0, valid1
sw  x18, 0x408(x0)
valid1wait:
lw  x20, 0x410(x0)
beq x20, x2, valid1wait
sw  x17, 0x408(x0)
addi x11, x21, 0
#开始输出
output:
lw  x18, 0(x11)
valid2:                        #用valid控制外设交互
lw  x20, 0x410(x0)
beq x20, x0, valid2
sw  x18, 0x408(x0)
valid2wait:
lw  x20, 0x410(x0)
beq x20, x2, valid2wait
addi x17, x17, -1
addi x11, x11, 4
beq x17, x0, Exit
jal output
Exit:
addi x2, x0, 2
addi x3, x0, 3
jal Exit
