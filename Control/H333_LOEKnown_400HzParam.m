% clear
% clc
% QGC Param
% 电机环
MY_TAU_P_P = Pixhawk_CSC.Parameter( {single(1.5), 'MY_TAU_P_P'}  );
MY_TAU_P_A = Pixhawk_CSC.Parameter( {single(0), 'MY_TAU_P_A'}  );
MY_TAU_P_P_YAW = Pixhawk_CSC.Parameter( {single(0.1), 'MY_TAU_P_P_YAW'}  );
MY_TAU_P_A_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_TAU_P_A_YAW'}  );
% 角速率环
MY_RATE_P = Pixhawk_CSC.Parameter( {single(12), 'MY_RATE_P'}  );
MY_RATE_P_YAW = Pixhawk_CSC.Parameter( {single(0.3), 'MY_RATE_P_YAW'}  );
% 姿态环
MY_ATT_P = Pixhawk_CSC.Parameter( {single(8), 'MY_ATT_P'}  );
MY_ATT_P_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_ATT_P_YAW'}  );
% 位置速度环
MY_POS_P = Pixhawk_CSC.Parameter( {single(0.5), 'MY_POS_P'}  );
MY_VEL_P = Pixhawk_CSC.Parameter( {single(0.8), 'MY_VEL_P'}  );
% 加速度饱和
MY_SAT_AD = Pixhawk_CSC.Parameter({single(0.13), 'MY_SAT_AD'} );

Ts = 1/400;
Tmotorbar = (0.035);%模拟实际下的Tmotor的估计值

Tf = 0.06;

g  = (9.8);
m  = (1.13);
c  = (0.0165);
l  = (0.1665);
J  = (diag([0.012 0.0120 0.02]));
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
      
% B = [0.25   -1.4142/(4*l)     1.4142/(4*l)     1/(4*c);
%      0.25   -1.4142/(4*l)    -1.4142/(4*l)    -1/(4*c);
%      0.25    1.4142/(4*l)    -1.4142/(4*l)     1/(4*c);   
%      0.25    1.4142/(4*l)     1.4142/(4*l)    -1/(4*c)];
    
T00  =single([m*g/4 m*g/4 m*g/4 m*g/4]');

%% EKF Param
ModelParam_envLongitude = 116.2593683;
ModelParam_envLatitude = 40.1540302;
ModelParam_GPSLatLong = [ModelParam_envLatitude ModelParam_envLongitude];
ModelParam_envAltitude = 0; %参考高度，即当前位置海拔高度，也可认为是起飞前初始高度。向下为正