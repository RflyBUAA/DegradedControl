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
%% log序号中：画图：体现位置控制 角速率增益14 电机增益1.3
% log_3 一个旋翼损坏位置跟踪
ulogOBJ = ulogreader("log_3_2022-11-1-20-15-42.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
input_rc = msg.TopicMessages{findtopic(msg.TopicNames, 'input_rc')};
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
Pos = unknown_logger.pos;
Posd = unknown_logger.posd;

CH7 = input_rc.values(:,7);
CH6 = input_rc.values(:,6);
log_time = input_rc.timestamp;
time_input_rc = seconds(log_time);
%% 数据处理:
shownHome = 1;
shownEnd = 3000;
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
s = figure(2);
s.Position = [0,0,60,18];
clf
subplot(4,4,1)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,1),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,1))

hold on
area([0,12.5],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,80],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title(['One Rotor Failure';'Position X(m)    ']);
xlim([5,80])
ylim([-3,15])

subplot(4,4,5)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,2),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,2))

hold on
area([0,12.5],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,80],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Position Y(m)")
xlim([5,80])
ylim([-24,15])

subplot(4,4,9)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,12.5],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,80],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([5,80])
ylim([0,12])
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal')
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,13)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,12.5],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,80],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

xlabel("Time [s]")
legend("$p$","$q$","$r$","fault-free","\#1 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',3)
title("Body Angular Rate (rad/s)")
xlim([5,80])
ylim([-25, 12])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

%%
%% log序号中：画图：体现位置控制 角速率增益14 电机增益1.3 
% log_4 相邻两个旋翼损坏位置跟踪
ulogOBJ = ulogreader("log_4_2022-11-1-20-20-02.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
input_rc = msg.TopicMessages{findtopic(msg.TopicNames, 'input_rc')};
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
Pos = unknown_logger.pos;
Posd = unknown_logger.posd;

CH7 = input_rc.values(:,7);
CH6 = input_rc.values(:,6);
log_time = input_rc.timestamp;
time_input_rc = seconds(log_time);
%% 数据处理:
shownHome = 1;
shownEnd = 3000;
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
subplot(4,4,2)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,1),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,1))

hold on
area([0,14.8],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.8,23.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([23.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title(['Two Adjacent Rotor Failure';'Position X(m)             ']);
xlim([0,90])
ylim([-4,25])

subplot(4,4,6)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,2),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,2))

hold on
area([0,14.8],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.8,23.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([23.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Position Y(m)")
xlim([0,90])
ylim([-25,15])

subplot(4,4,10)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,14.8],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.8,23.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([23.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([0,90])
ylim([0,12])
% xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal')
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,14)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,14.8],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.8,23.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([23.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

xlabel("Time [s]")
legend("$p$","$q$","$r$","fault-free","\#1 fails","\#1,\#2 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',3)
title("Body Angular Rate (rad/s)")
xlim([0,90])
ylim([-45,30])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

%% log序号中：画图：体现位置控制 角速率增益14 电机增益1.3
% log_12 对角旋翼失效
ulogOBJ = ulogreader("log_12_2022-11-1-21-22-56.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
input_rc = msg.TopicMessages{findtopic(msg.TopicNames, 'input_rc')};
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
Pos = unknown_logger.pos;
Posd = unknown_logger.posd;

CH7 = input_rc.values(:,7);
CH6 = input_rc.values(:,6);
log_time = input_rc.timestamp;
time_input_rc = seconds(log_time);
%% 数据处理:
shownHome = 1;
shownEnd = 3000;
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
subplot(4,4,3)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,1),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,1))

hold on
area([0,11.2],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11.2,21.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([21.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title(['Two Opposite Rotor Failure';'Position X(m)             ']);
xlim([10,50])
ylim([-8,10])

subplot(4,4,7)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,2),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,2))

hold on
area([0,11.2],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11.2,21.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([21.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Position Y(m)")
xlim([10,50])

subplot(4,4,11)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,11.2],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11.2,21.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([21.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([10,50])
ylim([0,12])
% xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal')
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,15)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,11.2],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11.2,21.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([21.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

xlabel("Time [s]")
legend("$p$","$q$","$r$","fault-free","\#1 fails","\#1,\#3 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',3)
title("Body Angular Rate (rad/s)")
xlim([10,50])
ylim([-45,18])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

%%
%% log序号中：画图：体现位置控制 角速率增益14 电机增益1.3
% log_13 三个旋翼失效 
ulogOBJ = ulogreader("log_13_2022-11-1-23-50-06.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
input_rc = msg.TopicMessages{findtopic(msg.TopicNames, 'input_rc')};
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
Pos = unknown_logger.pos;
Posd = unknown_logger.posd;

CH7 = input_rc.values(:,7);
CH6 = input_rc.values(:,6);
log_time = input_rc.timestamp;
time_input_rc = seconds(log_time);
%% 数据处理:
shownHome = 1;
shownEnd = 3000;
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
subplot(4,4,4)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,1),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,1))

hold on
area([0,14.2],[50,50],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.2,27.4],[50,50],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([27.4,100],[50,50],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title(['Three Rotor Failure';'   Position X(m)   ']);
xlim([10,80])

subplot(4,4,8)
plot(time_unknown_logger-time_unknown_logger(1),Posd(:,2),'--')
hold on 
plot(time_unknown_logger-time_unknown_logger(1),Pos(:,2))

hold on
area([0,14.2],[30,30],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.2,27.4],[30,30],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([27.4,100],[30,30],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

ax = gca;
ax.GridLineStyle = '-';
legend("Reference","Measurement",'Interpreter',"latex",'Orientation','horizontal','Location','best')
title("Position Y(m)")
xlim([10,80])
ylim([-18,5])

subplot(4,4,12)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,14.2],[30,30],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.2,27.4],[30,30],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([27.4,100],[30,30],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([10,80])
ylim([0,12])
% xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal')
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,16)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,14.2],[30,30],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([14.2,27.4],[30,30],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([27.4,100],[30,30],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

xlabel("Time [s]")
legend("$p$","$q$","$r$","fault-free","\#1 fails","\#1,\#2,\#3 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',3)

title("Body Angular Rate (rad/s)")
xlim([10,80])
ylim([-45,25])
%属性设置
ax = gca;
ax.GridLineStyle = '-';