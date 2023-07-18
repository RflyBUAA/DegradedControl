The code will be further updated on https://github.com/RflyBUAA/DegradedControl.git

If you have any questions, please contact me by email at kcx064@163.com or kechenxu@buaa.edu.cn or ke_chenxu@buaa.edu.cn

## Passive Fault Tolerant Control MIL
Step: run in order

1. `Model/H250ModelParam4S.m`
2. `Control/H250_LOEUnknown_400HzParam.m`
3. `MIL/Unknown_V1/H250_LOEUnknown_400HzV2.slx`

## CodeGen
If you want to run the controller in Pixhawk

1. Pixhawk 4 (used in my experiment; v1.11.3; controller 400Hz; **LPE 400Hz or higher, EKF2 is not stable subject to rotor failure**)
2. RflySim is used for CodeGen
3. `HIL/Unknown_V1/H250_LOEUnknown_400HzHILV2.slx` is the main file used for CodeGen

## Additional info
- `Control/FTC_UnknownV2.slx` is the core controller used in the paper "Uniform Passive Fault-Tolerant Control of a Quadcopter with One, Two, or Three Rotor Failure."

- `Control/FTC.slx` is the core controller used in the paper "Uniform Fault-Tolerant Control of a Quadcopter with rotor failure"