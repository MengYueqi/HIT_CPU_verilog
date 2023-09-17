# HIT_CPU_design
哈工大2023处理器设计和计算机体系结构实验verilog设计代码和激励文件。处理器设计在开学的前两周开设，是计算机体系结构实验的前置课程，故将两个实验的内容放在一起。
- 处理器设计是哈工大2023年第一次开设的课程，在这里把verilog设计代码分享给大家，仅供参考。
Lab1-3中每个文件夹有两个文件，其中一个为设计文件，另一个有下划线标注后缀的为激励文件。
- 计算机体系结构

## 处理器设计实验

### CPU_design_Lab1 ###
Lab1共有两个实验，选择器和节拍发生器。

### CPU_design_Lab2 ###
Lab2为模拟ALU。


### CPU_design_Lab3 ###
Lab3共有两个实验，寄存器堆和RAM。寄存器堆比较好实现，RAM需要导入IP核，在导入的时候注意，要严格按照指导书进行，否则可能出现问题。

### CPU_design_Lab4 ###
Lab4为MIPS无流水CPU设计，用verilog完成CPU，可执行主要的MIPS指令。设计的CPU结构如下：
![图片](./CPU_design_lab4/lab4_arc.png)
Lab4文件夹内有处理器设计文件和仿真文件两个文件夹，仿真文件为测试样例，当输出"--PASS"时即为成功。设计文件中从外部导入的初值已被隐去，请自行设置初值的路径。测试的指令如下：
``` 
// 非流水线CPU实验测试

LW   $1,  4($0)
LW   $2,  8($0)
ADD  $3,  $1,  $2
SUB  $4,  $1,  $2
AND  $5,  $1,  $2
OR   $6,  $1,  $2
XOR  $7,  $1,  $2
SLT  $8,  $1,  $2
SLL  $9,  $1,  0x2  // $9 <- $1 << 2
SW   $1,  8($0)
SW   $2,  4($0)
BNE  $0,  $6,  0x2  // taken to 0x38
SW   $1,  0($0)
J    0              // back to start
J    0x10           // jumps to 0x40
SW   $1,  0($0)
LW   $0,  0($0)
NOP
J    0              // back to start
``` 
## 参考资料
- <a href="https://verilogguide.readthedocs.io/en/latest/">FPGA designs with Verilog</a>
- <a href="https://blog.csdn.net/zhang_qing_yun/article/details/121049946">设计并实现一个单周期非流水的CPU（哈工大计组实验二：给定指令系统的处理器设计）</a>
- 感谢<a href="https://claude.ai/chats">Claude</a>对项目的大力支持。