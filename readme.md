## 说明

这里是RflySim课程容错控制教学内容源文件 ,也是论文中的部分源码.

## 目录结构
- `Model`:四旋翼模型\模型参数脚本\RflySim3D软件显示接口模型文件\用于生成模型DLL文件的p脚本文件
- `Control`:控制器\控制器参数脚本\控制器QGC地面站参数定义c文件
- `MIL`:软件仿真程序
- `HIL`:半物理仿真程序
- `PriviteLib`:一些自编的函数

## 软硬件说明

- MATLAB 2020b
- RflySim[高级版](https://rflysim.com/en/index.html): 需要使用生成DLL文件功能, RflySim3D显示功能(可选)
- Windows10
- Pixhawk 4 (Pixhawk 2.4.8可能性能不够用, 可以降低控制器频率运行)
- PX4 1.8.2 (其他PX4版本在处理QGC参数定义的部分会编译报错, 不同的版本需要修改QGC参数定义文件中的同文件引用路径)

## 源码说明

该源码使用了Simulink工程创建, 使用前需要打开Simulink工程文件, 这样可以自动添加引用目录. 项目开启后会默认运行模型参数文件, 之后请手动运行控制器脚本文件, 最后根据需要选择MIL和HIL. MIL可以在电脑上直接运行在RflySim3D中看到效果. HIL需要运行编译(预先安装好RflySim), 同时编译四旋翼模型,并使用脚本生成模型DLL文件, 将模型DLL文件放入CopterSim指定目录中, 同时将控制器生成的PX4固件烧录到飞控. 飞控USB连接电脑后,即可开始HIL仿真. HIL仿真依赖于RflySim平台, 该平台使用教程请参照 [官方文档](https://rflysim.com/en/index.html). 如有问题也可联系本人: kcx064@163.com

## MIL运行步骤

1.使用MATLAB在该目录下打开项目文件`RflySimDegradedControl.prj`

2.运行控制器文件夹中的控制器脚本文件

3.运行MIL文件夹中的模型, 进行仿真.

> 无论是HIL还是MIL在本套源码中,均调用了唯一的控制器文件和唯一的四旋翼模型文件, 也就是如果在MIL程序中打开并修改了控制器或者模型, 那么在HIL中也会生效. 原理是MIL和HIL通过Subsystem Reference调用了控制器, MIL通过Reference Model调用了四旋翼的模型

