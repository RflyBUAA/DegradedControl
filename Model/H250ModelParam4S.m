% Multicopter Model Parameter
% clear
clc
load MavLinkStruct;
Ts = 1/1000;
MulticopterLayoutConfig = 7;
RflySimDisplayUAVType = 3;
%% 1.Battery Model
% Model Param

% Fail Param

%% 2.ESC&Motor Model Parameter
% Initial Param
ModelInit_motorInitRate = 0;
% Model Param
ModelParam_motorMinThr = 0.148;% 油门死区范围：0-1
ModelParam_motorFitType = 2;% 1表示使用线性拟合，2表示二次曲线拟合
ModelParam_motorCr = 0.0;
ModelParam_motorWb = 0;
ModelParam_motorRateCurveCoeffi = [-2143 5113 -458.4];%[p1 p2 p3]: f(x) = p1*x^2 + p2*x + p3

ModelParam_motorTc = 0.032;
ModelParam_rotorCt = 1.345e-06;
ModelParam_motorJm = 8.8493e-06;
% Fail Param
ModelFail_motor_isEnable = 0;
ModelFail_motor_kw  = [1 1 1 1 1 1 1 1];%[0,1]
ModelFail_motor_kTc = [1 1 1 1 1 1 1 1];%[1,100]过大的参数是不现实的，因为在这种情况下飞行效果会非常差
ModelFail_motor_kCt = [1 1 1 1 1 1 1 1];%[0,1]

%% 3.Environment Model
% Model Param
ModelParam_envLongitude = 116.259368300000;
ModelParam_envLatitude = 40.1540302;
ModelParam_GPSLatLong = [ModelParam_envLatitude ModelParam_envLongitude];
ModelParam_envAltitude = 0; %参考高度，即当前位置海拔高度，也可认为是起飞前初始高度。向下为正
ModelParam_envC_d = 0.055;%0.055;
ModelParam_envC_md = [0.001 0.001 0.00040];%[0.0035 0.0039 0.0034];
    % Wind Param
    ModelParam_timeSampTurbWind = 1/200;
% Fail Param
ModelFail_env_P_wind = [0 0 0];
    % Wind Fail Param
    ModelFailWind_isEnable = boolean(0);
    ModelFailWind_isConstWind = boolean(0);
    ModelFailWind_isGustWind = boolean(0);
    ModelFailWind_isTurbWind = boolean(0);
    ModelFailWind_isSheerWind = boolean(0);
    
    ModelFailWind_ConstWindX = 0;
    ModelFailWind_ConstWindY = 0;
    ModelFailWind_ConstWindZ = 0;
    
    ModelFailWind_GustWindStrength = 0;
    ModelFailWind_GustWindFreq = 0;
    ModelFailWind_SheerWindDirec = 0;
    ModelFailWind_SheerWindStrength = 0;
    ModelFailWind_TurbWindStrength = 0;
    ModelFailWind_TurbWindDirec = 0;
   
%% 4.Airframe Model
% Model Param
ModelParam_Airframe_CMP = [0 0 0];
ModelParam_Airframe_m = 0.752;
ModelParam_Airframe_J = [0.0056 0 0;0 0.0056 0;0 0 0.0104];                                                
% Fail Param
ModelFail_Airframe_load_P = [0 0 0] + ModelParam_Airframe_CMP;
ModelFail_Airframe_load_m = 0;
ModelFail_Airframe_load_J = [0 0 0;0 0 0;0 0 0]; % 视负载为质点时，惯性张量为0
ModelFail_Airframe_load_Type = 1;%1 represent mass add -1 represent mass reduce 

%% 5.Sensor Model
% Model Param
 % GPS
ModelParam_GPSEphFinal=0.3;
ModelParam_GPSEpvFinal=0.4;
ModelParam_GPSFix3DFix=3;
ModelParam_GPSSatsVisible=10;

ModelParam_NoiseVarGPS_P0 = [1e-5 1e-5 1e-5];
ModelParam_WalkNoiseVarGPS_P0 = [0.01 0.01 0.01];
ModelParam_NoiseVarGPS_V0 = [1e-5 1e-5 1e-5];
ModelParam_WalkNoiseVarGPS_V0 = [0.01 0.01 0.01];
 % Acc
ModelParam_NoiseVarAcc0 = [0.1 0.1 0.1];
ModelParam_WalkNoiseVarAcc0 = [0.001 0.001 0.001];
ModelParam_PositionAcc0 = [0.071  0  -0.1365]; %加速度计相对形心的位置
ModelParam_NoiseVarAcc1 = [0.1 0.1 0.1];
ModelParam_WalkNoiseVarAcc1 = [0.001 0.001 0.001];
ModelParam_PositionAcc1 = [0.071  0  -0.1365]; %加速度计相对形心的位置

 % Gyro
ModelParam_NoiseVarGyro0 = [0.0005 0.0005 0.0005];
ModelParam_WalkNoiseVarGyro0 = [0.00004 0.00004 0.00004];
ModelParam_NoiseVarGyro1 = [0.004 0.004 0.004];
ModelParam_WalkNoiseVarGyro1 = [0.00004 0.00004 0.00004];
 % Mag
ModelParam_NoiseVarMag0 = [0.000002 0.000002 0.000002];
ModelParam_WalkNoiseVarMag0 = [0.000001 0.000001 0.000001];
ModelParam_NoiseVarMag1 = [0.0001 0.0001 0.0001];
ModelParam_WalkNoiseVarMag1 = [0.000001 0.000001 0.000001];
 % Baro
ModelParam_NoiseVarBaro0 = 0.02;
ModelParam_WalkNoiseVarBaro0 = 0.002;
 % Fail Param

%% 6.Kinematics 6DOF Model
% Model Param
ModelInit_PosE=[0,0,0];
ModelInit_VelB=[0,0,0];
ModelInit_AngEuler=[0,0,0];
ModelInit_RateB=[0,0,0];
    