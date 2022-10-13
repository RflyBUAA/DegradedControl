% clear
clc
% Param on QGC
MY_TAU_P_P = Pixhawk_CSC.Parameter( {single(1.3), 'MY_TAU_P_P'}  );
MY_TAU_P_A = Pixhawk_CSC.Parameter( {single(0.0), 'MY_TAU_P_A'}  );
MY_TAU_P_P_YAW = Pixhawk_CSC.Parameter( {single(0.1), 'MY_TAU_P_P_YAW'}  );
MY_TAU_P_A_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_TAU_P_A_YAW'}  );

MY_RATE_P = Pixhawk_CSC.Parameter( {single(14), 'MY_RATE_P'}  );
MY_RATE_P_YAW = Pixhawk_CSC.Parameter( {single(1), 'MY_RATE_P_YAW'}  );

MY_ATT_P = Pixhawk_CSC.Parameter( {single(3), 'MY_ATT_P'}  );
MY_ATT_P_YAW = Pixhawk_CSC.Parameter( {single(0), 'MY_ATT_P_YAW'}  );

MY_POS_P = Pixhawk_CSC.Parameter( {single(0.1), 'MY_POS_P'}  );
MY_VEL_P = Pixhawk_CSC.Parameter( {single(0.15), 'MY_VEL_P'}  );
MY_POS_ALT = Pixhawk_CSC.Parameter( {single(0.6), 'MY_POS_ALT'}  );
MY_VEL_ALT = Pixhawk_CSC.Parameter( {single(1), 'MY_VEL_ALT'}  );

MY_SAT_AD = Pixhawk_CSC.Parameter({single(0.13), 'MY_SAT_AD'} );

MY_K_CP = Pixhawk_CSC.Parameter({single(-1.4), 'MY_K_CP'} );

Ts = 1/400;%1/400
% 虽然理论推导显示，Tmotor=Tmotorbar=Tkd
% 但是实际仿真发现，Tmotorbar=Tkd>Tmotor的时候位置收敛会变快，超调会减少，其他参数搭配方式目前还没尝试
Tmotorbar = (0.025);%0.032模拟实际下的Tmotor的估计值

Tf = 0.06;

g  = (9.81);
m  = (0.752);
c  = (0.0166);
l  = (0.125);
J  = (diag([0.0056 0.0056 0.0104]));
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
      
B = [0.25   -1.4142/(4*l)     1.4142/(4*l)     1/(4*c);
     0.25   -1.4142/(4*l)    -1.4142/(4*l)    -1/(4*c);
     0.25    1.4142/(4*l)    -1.4142/(4*l)     1/(4*c);   
     0.25    1.4142/(4*l)     1.4142/(4*l)    -1/(4*c)];
    
T00 = single([m*g/4 m*g/4 m*g/4 m*g/4]');

%% EKF Param
ModelParam_envLongitude = 116.2593683;
ModelParam_envLatitude = 40.1540302;
ModelParam_GPSLatLong = [ModelParam_envLatitude ModelParam_envLongitude];
ModelParam_envAltitude = 0; %参考高度，即当前位置海拔高度，也可认为是起飞前初始高度。向下为正

