% clear
% clc
% QGC Param
% 在系统输入延迟相同的情况下(采样率0.025  delay 10ms(四个延迟)和采样率0.001 delay10ms(10个延迟)),
% 采样率更高的更稳定. 同时延迟较大的情况下, 降低控制参数的大小更有助于收敛. 也就是延迟越大对参数最
% 大值限制越强烈
MY_ATT_P = Pixhawk_CSC.Parameter( {single(3), 'MY_ATT_P'}  );
MY_ATT_P_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_ATT_P_YAW'}  );

MY_POS_P = Pixhawk_CSC.Parameter( {single(0.8), 'MY_POS_P'}  );

MY_RATE_P = Pixhawk_CSC.Parameter( {single(12), 'MY_RATE_P'}  );
MY_RATE_P_YAW = Pixhawk_CSC.Parameter( {single(0.3), 'MY_RATE_P_YAW'}  );

MY_SAT_AD = Pixhawk_CSC.Parameter({single(0.13), 'MY_SAT_AD'} );

MY_TAU_P_A = Pixhawk_CSC.Parameter( {single(0), 'MY_TAU_P_A'}  );
MY_TAU_P_A_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_TAU_P_A_YAW'}  );
MY_TAU_P_P = Pixhawk_CSC.Parameter( {single(1.2), 'MY_TAU_P_P'}  );
MY_TAU_P_P_YAW = Pixhawk_CSC.Parameter( {single(0.1), 'MY_TAU_P_P_YAW'}  );

MY_VEL_P = Pixhawk_CSC.Parameter( {single(0.8), 'MY_VEL_P'}  );

% MY_K_W = Pixhawk_CSC.Parameter({single(0.0), 'MY_K_W'} );
MY_K_CP = Pixhawk_CSC.Parameter({single(1.2), 'MY_K_CP'} );

% MY_UL = Pixhawk_CSC.Parameter({single(1000), 'MY_UL'} );
MY_W_T = Pixhawk_CSC.Parameter({single(0), 'MY_W_T'} );
MY_W_S = Pixhawk_CSC.Parameter({single(0), 'MY_W_S'} );

Ts = 1/400;
Tmotorbar = (0.025);%模拟实际下的Tmotor的估计值原先是0.035
% Tmotorbar = (0.0214);%模拟实际下的Tmotor的估计值

Tf = 0.06;% 之前都是0.06, 但是怀疑这个参数太大, 在大转速的情况下会导致延迟过大

g = (9.8);
m = (0.700);
% m = (1.31);
c = (0.0166);
l = (0.125);
% l = (0.225);
J = (diag([0.0056 0.0056 0.0104]));
% J = (diag([0.0194 0.0194 0.0291]));
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
      
% B = [0.25   -1.4142/(4*l)     1.4142/(4*l)     1/(4*c);
%      0.25   -1.4142/(4*l)    -1.4142/(4*l)    -1/(4*c);
%      0.25    1.4142/(4*l)    -1.4142/(4*l)     1/(4*c);   
%      0.25    1.4142/(4*l)     1.4142/(4*l)    -1/(4*c)];
    
T00 = single([m*g/4 m*g/4 m*g/4 m*g/4]');

%% EKF Param
ModelParam_envLongitude = 116.2593683;
ModelParam_envLatitude = 40.1540302;
ModelParam_GPSLatLong = [ModelParam_envLatitude ModelParam_envLongitude];
ModelParam_envAltitude = 0; %参考高度，即当前位置海拔高度，也可认为是起飞前初始高度。向下为正