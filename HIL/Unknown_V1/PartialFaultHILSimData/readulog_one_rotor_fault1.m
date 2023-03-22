% 单个旋翼失效恢复实验
% 电机顺序为从右前方顺时针计数依次为1 2 3 4 
clear
clc
figure_configuration_IEEE_standard
%% 机体模型数据
c  = (0.0166);
l  = (0.125);
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
%% log说明：两个均为单旋翼失效的瞬间切换，不是逐渐切换过程，参数和实验保持一致
% k_rotor = 2.0(log_6) k_omega = 12

ulogOBJ = ulogreader("log_0_2021-6-30-08-02-46.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
% 生成相对时间
log_time = vehicle_attitude.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);
%% 数据获取:
q = vehicle_attitude.q;

log_time = sensor_combined.timestamp;
time_sensor_combined = seconds(log_time);
[time_size_sensor_combined,~] = size(time_sensor_combined);
gyro_rad=sensor_combined.gyro_rad;

log_time = unknown_logger.timestamp;
time_unknown_logger = seconds(log_time);
[time_size_unknown_logger,~] = size(unknown_logger);
Tdes = unknown_logger.tdes;
%% 数据处理:
shownHome = 1500;
shownEnd = 2400;
shownlength = shownEnd-shownHome+1; 
shownlengthRange = shownHome:shownEnd;
n = zeros(time_size,3);
n_b_e = zeros(time_size,3);
for i = 1:time_size
    DCM = quat2dcm(q(i,:));
    n(i,:) = DCM'*[0 0 1]';
    n_b_e(i,:) = DCM*[0 0 1]';
end
% 画图
s = figure(1);
s.Position = [0,0,30,15];
clf

%% 角速率
subplot(3,3,[1,2,3])
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-')

areamin = -45;
areamax = 5;
hold on
area([0,8.3],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([8.3,28.5],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([28.5,58],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([58,78.5],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([78.5,98],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([98,120],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

% xlabel("Time [s]")
legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Body Angular Rate (rad/s)")
ylim([areamin,areamax])
xlim([0,120])
% 属性设置
ax = gca;
ax.GridLineStyle = '--';

%% 主轴
subplot(3,3,[4,5,6])
plot(time(:)-time(1),n_b_e(:,1),'LineStyle','-')
hold on
plot(time(:)-time(1),n_b_e(:,2),'LineStyle','--')
hold on
plot(time(:)-time(1),n_b_e(:,3),'LineStyle','-.')

areamin = -0.5;
areamax = 1;
hold on
area([0,8.3],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([8.3,28.5],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([28.5,58],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([58,78.5],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([78.5,98],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([98,120],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

% xlabel("Time [s]")
legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Rotation Axis")
xlim([0,120])
ylim([areamin,areamax])
%属性设置
ax = gca;
ax.GridLineStyle = '--';

%% 期望的电机拉力
subplot(3,3,[7,8,9])
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

areamin = 0;
areamax = 10;
hold on
area([0,8.3],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([8.3,28.5],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([28.5,58],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([58,78.5],[areamax,areamax],areamin,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([78.5,98],[areamax,areamax],areamin,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([98,120],[areamax,areamax],areamin,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ylim([0,areamax])
title("Desired Rotors Thrust (N)")
xlim([0,120])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal','Location','best')
ax = gca;
ax.GridLineStyle = '--';

%% 绘制球面
function drawsphere(a,b,c,R)
% 以(a,b,c)为球心，R为半径

    % 生成数据
    [x,y,z] = sphere(35);

    % 调整半径
    x = R*x; 
    y = R*y;
    z = R*z;

    % 调整球心
    x = x+a;
    y = y+b;
    z = z+c;

    % 使用mesh绘制
    axis equal;
    mesh(x,y,z,'LineStyle','-','FaceAlpha','0.2','FaceColor','flat','EdgeAlpha','0.25','EdgeColor','flat');

    % 使用surf绘制
%     axis equal;
%     surf(x,y,z,'LineStyle','none','FaceAlpha','0.3');
end