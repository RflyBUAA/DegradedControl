# 更新记录

### 20221110

基于V2版本修改一个版本V4，V4基于V2，主要修改位置控制部分，试图获得更好的位置控制效果

### 20221007

**故障未知的控制器新增了两套仿真文件**，一个是V2一个是V3都位于Control文件夹，V1是之前的旧版本进行过户外实飞实验验证过得。V3则是根据新修改论文做出的调整后的版本

##### 1. FTC_UnknownV3.slx文件对应的算法理论上为如下形式，具体还需要参考具体论文

1. 扰动估计为

$$
\begin{aligned}
            \hat{\mathbf{d}}_1 &= \frac{1}{\epsilon s+1}(\mathbf{u}_{\mathrm{d},1} - \mathbf{u}_1)\\
            &=\frac{1}{\epsilon s+1}\mathbf{u}_{\mathrm{d},1} - \frac{\tau_\mathrm{m}s+1}{\epsilon s+1}\mathbf{u}_\mathrm{dyn}\\
            &=\frac{1}{\epsilon s+1}\mathbf{E}_1\mathbf{M}\mathbf{T}_\mathrm{d} -\mathbf{B}_2^{-1}\frac{s(\tau_\mathrm{m}s+1)}{\epsilon s+1}\mathbf{x}_2\\
            &\quad +\frac{\tau_\mathrm{m}s+1}{\epsilon s+1}\mathbf{B}_2^{-1}(\mathbf{A}_2\mathbf{x}_2+\mathbf{D}_2)\\
            \hat{{d}}_{\tau_r} &= \frac{1}{\epsilon s+1}\mathbf{E}_2\mathbf{M}\mathbf{T}_\mathrm{d}- J_z\frac{s(\tau_\mathrm{m}s+1)}{\epsilon s+1}r + \frac{\tau_\mathrm{m}s+1}{\epsilon s+1}(J_x-J_y)pq
        \end{aligned}
$$

2. 控制器设计为

$$
\begin{aligned}
        \mathbf{u}_{0,1} &= \frac{1}{\epsilon s+1}\mathbf{u}_{\mathrm{c},1}+\hat{\mathbf{d}}_1\\
    \tau_{r,0} &= \frac{1}{\epsilon s+1}\tau_{r,\mathrm{c}}+\hat{d}_{\tau_r}
    \end{aligned}
$$

3. 虚拟控制反馈

$$
\mathbf{u}_{\mathrm{d}}=\mathbf{K}_\mathrm{rotor}(\mathbf{u}_{0}-\frac{1}{\epsilon s +1}\mathbf{u}_{\mathrm{d}})
$$

##### 2. FTC_UnknownV2.slx与前面的类似，

与前面的类似，但是V2做了妥协，因为$\frac{s(\tau_m s+1)}{\epsilon s+1}$在数学上不好实现，前面的实现采用的是数值微分实现的。而V2的思路则是在原来基础上对所有符号（除了$\mathbf{u}_\mathrm{c}$相关的（当然加上也可以不过会进一步拖慢响应速度））乘以$\tau_m s+1$，来实现控制器，这样的结果就是会影响总体响应速度，但是依旧可以HIL仿真通过验证，其实效果和V1是相同的，V2相比V1只是在控制器上做了稳定性证明，添加了一下补偿项，但是依旧需要耦合项进行调节，区别是这里耦合项的系数由原来的0.6变成了-0.8或者-1.0。

##### 3. 总之

- V3的控制器的实现是最尊重原文的，并且实现起来相比V2、V1，相同参数情况下更能实现旋翼的瞬间完全失效，而不是逐步失效的那种情况。

- V2和V3相比于V1对参数的适应性更强，V1情况只能适应是失效系数是0 1 1 1的情况。而V2和V3可以适应更多种故障情况，比如0 0.8 0.6 0.9之类的效率系数。和V1比较之下可以得知V2和V3也就是论文在Lyapunov下推导出来的控制器u_c多出的一些补偿项是起到了作用的（具体参看论文），当然这种前提下依旧需要增加耦合项并且此时耦合项系数为0.6，仿真中0也是可以的。

- ~~实际上耦合项在李亚普诺夫证明过程中耦合项构成的矩阵A_2最终是自消除的（本质上是李雅普诺夫并非渐进稳定也就是不是指数收敛的，耦合项实际上提供了无阻尼震荡特性，这种特性在李雅普诺夫稳定性下是稳定的，但是却不是渐进稳定的，所以手动增加耦合项补偿是不影响李雅普诺夫稳定性证明的，但是耦合项本身确实可以影响系统的稳定性或者可控度，这点在李雅普诺夫的分析中是会被忽略掉的，印象中李雅普诺夫稳定性前需要先对系统做可控性分析把）~~说法存疑

### 20221006

- 删除了UnknownV2相关文件

- 删除了H330的模型脚本和控制脚本

- 删除了F450的模型脚本

- 删除了H250 3S电池的模型脚本（实际只使用4S电池）

# 说明

这里是RflySim课程容错控制教学内容源文件 ,也是论文中的部分源码.

# 目录结构

- `Model`:四旋翼模型\模型参数脚本\RflySim3D软件显示接口模型文件\用于生成模型DLL文件的p脚本文件
- `Control`:控制器\控制器参数脚本\控制器QGC地面站参数定义c文件
- `MIL`:软件仿真程序
- `HIL`:半物理仿真程序
- `PriviteLib`:一些自编的函数

# 软硬件说明

- MATLAB 2020b
- RflySim[高级版](https://rflysim.com/en/index.html): 需要使用生成DLL文件功能, RflySim3D显示功能(可选)
- Windows10
- Pixhawk 4 (Pixhawk 2.4.8可能性能不够用, 可以降低控制器频率运行)
- PX4 1.8.2 (其他PX4版本在处理QGC参数定义的部分会编译报错, 不同的版本需要修改QGC参数定义文件中的同文件引用路径)

# 源码说明

该源码使用了Simulink工程创建, 使用前需要打开Simulink工程文件, 这样可以自动添加引用目录. 项目开启后会默认运行模型参数文件, 之后请手动运行控制器脚本文件, 最后根据需要选择MIL和HIL. MIL可以在电脑上直接运行在RflySim3D中看到效果. HIL需要运行编译(预先安装好RflySim), 同时编译四旋翼模型,并使用脚本生成模型DLL文件, 将模型DLL文件放入CopterSim指定目录中, 同时将控制器生成的PX4固件烧录到飞控. 飞控USB连接电脑后,即可开始HIL仿真. HIL仿真依赖于RflySim平台, 该平台使用教程请参照 [官方文档](https://rflysim.com/en/index.html). 如有问题也可联系本人: kcx064@163.com

# MIL运行步骤

1.使用MATLAB在该目录下打开项目文件`RflySimDegradedControl.prj`

2.运行控制器文件夹中的控制器脚本文件

3.运行MIL文件夹中的模型, 进行仿真.

> 无论是HIL还是MIL在本套源码中,均调用了唯一的控制器文件和唯一的四旋翼模型文件, 也就是如果在MIL程序中打开并修改了控制器或者模型, 那么在HIL中也会生效. 原理是MIL和HIL通过Subsystem Reference调用了控制器, MIL通过Reference Model调用了四旋翼的模型

# 关键

*控制频率*和*截止频率*对这些控制都有很大影响,选择不同对仿真的影响也很大

# 一些前置条件

- 如果增加了自定义log功能，那么需要按照PPT中的指引完成对固件源代码的修改

- 若使用FPGA 的HIL仿真，则需要使用修改固件中的启动脚本。早期只支持1.11版本。