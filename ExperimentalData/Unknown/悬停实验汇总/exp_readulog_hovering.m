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
%% log说明：主线的单个旋翼失效
% log_0 是单个旋翼瞬间切换 
ulogOBJ = ulogreader("log_0_2022-10-26-19-40-46.ulg");%log_0_2022-10-26-19-40-46.ulg
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
shownHome = 3500;
shownEnd = 4350;
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
s=figure(1);
s.Position = [0,0,60,25];
clf
subplot(4,4,[1,5])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(100, 30, length(colorMarker));
scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
hold on
% colormap(colorMarker');
% colorbar('north','Ticks',[-1 1],'TickLabels',{'4s','0s'},'Direction','reverse')
drawsphere(0,0,0,1)
hold on
quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
quiver3(0,0,0,n(shownEnd,1),n(shownEnd,2),n(shownEnd,3), ...
    'LineWidth',2,'Color','#D95319','AutoScale','on','AutoScaleFactor',1)
xlabel("x")
ylabel("y")
zlabel("z")
%属性设置
ax = gca;
ax.GridLineStyle = '-';
ax.View = [-135.240692185176 38.0033333851553];
title("Recovery From One Rotor Failure")

% subplot(5,4,9)
% plot(time(:)-time(1),n_b_e)
% % xlabel("Time [s]")
% legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
% title("Rotation Axis")
% xlim([12,35])
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';

subplot(4,4,9)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,13.3],[20,20],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([13.3,40],[20,20],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
% annotation('textbox',[0.324515941476541 0.46672512808502 0.0330729158124369 0.0306916660673917],'Color','#ffa04d','String','#1 fails','FaceAlpha',0,'EdgeColor','none');

legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([12,35])
ylim([-30,10])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,13)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,13.3],[10,10],'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([13.3,40],[10,10],'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([12,35])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$","fault-free","\#1 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',4)
ax = gca;
ax.GridLineStyle = '-';


%% log序号中：画图：两个相邻旋翼失效的 角速率增益14 电机增益1.3
ulogOBJ = ulogreader("log_1_2022-10-31-21-37-30.ulg");
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
shownHome = 8000;
shownEnd = 9000;
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
subplot(4,4,[2,6])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(100, 30, length(colorMarker));
scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
hold on
% colormap(colorMarker');
% colorbar('north','Ticks',[-1 1],'TickLabels',{'4s','0s'},'Direction','reverse')
drawsphere(0,0,0,1)
hold on
quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
quiver3(0,0,0,n(shownEnd,1),n(shownEnd,2),n(shownEnd,3), ...
    'LineWidth',2,'Color','#D95319','AutoScale','on','AutoScaleFactor',1)
xlabel("x")
ylabel("y")
zlabel("z")
%属性设置
ax = gca;
ax.GridLineStyle = '-';
title("Two Adjacent Rotor Failure")

% subplot(5,4,10)
% plot(time(:)-time(1),n_b_e)
% % xlabel("Time [s]")
% legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
% title("Rotation Axis")
% xlim([10,40])
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';

subplot(4,4,10)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,12.5],[20,20],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,19.3],[20,20],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([19.3,40],[20,20],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([10,40])
ylim([-43,20])
%属性设置
ax = gca;
ax.GridLineStyle = '-';
% ax.View = [52.7013669854862 29.4383187247844];


subplot(4,4,14)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,12.5],[10,10],'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([12.5,19.3],[10,10],'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([19.3,40],[10,10],'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([10,40])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$","fault-free","\#1 fails","\#1,\#2 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',4)
ax = gca;
ax.GridLineStyle = '-';

%%
ulogOBJ = ulogreader("log_11_2022-10-27-20-18-22.ulg");
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
% LOE = unknown_logger.loe;
% CH7 = unknown_logger.ch7;
CH7 = input_rc.values(:,7);
%% 数据处理:
shownHome = 5000;
shownEnd = 6000;
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
subplot(4,4,[3,7])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(100, 30, length(colorMarker));
scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
hold on
% colormap(colorMarker');
% colorbar('north','Ticks',[-1 1],'TickLabels',{'4s','0s'},'Direction','reverse')
drawsphere(0,0,0,1)
hold on
quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
quiver3(0,0,0,n(shownEnd,1),n(shownEnd,2),n(shownEnd,3), ...
    'LineWidth',2,'Color','#D95319','AutoScale','on','AutoScaleFactor',1)
xlabel("x")
ylabel("y")
zlabel("z")
%属性设置
ax = gca;
ax.GridLineStyle = '-';
ax.View = [-135.240692185176 38.0033333851553];
title("Two Opposite Rotor Failure")

% subplot(5,4,11)
% plot(time(:)-time(1),n_b_e)
% % xlabel("Time [s]")
% legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
% title("Rotation Axis")
% xlim([10,28])
% ylim([-0.8,1])
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';

subplot(4,4,11)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,11],[20,20],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11,15.4],[20,20],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([15.4,40],[20,20],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([10,28])
ylim([-43,15])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,15)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,11],[10,10],'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([11,15.4],[10,10],'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([15.4,40],[10,10],'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([10,28])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$","fault-free","\#1 fails","\#1,\#3 fails",'Interpreter',"latex",'Orientation','vertical','NumColumns',4)
ax = gca;
ax.GridLineStyle = '-';

%%
ulogOBJ = ulogreader("log_10_2022-10-27-20-16-24.ulg");%log_10_2022-10-27-20-16-24
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
% LOE = unknown_logger.loe;
% CH7 = unknown_logger.ch7;
CH7 = input_rc.values(:,7);
CH6 = input_rc.values(:,6);
log_time = input_rc.timestamp;
time_input_rc = seconds(log_time);
%% 数据处理:
shownHome = 7000;
shownEnd = 8000;
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
subplot(4,4,[4,8])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(100, 30, length(colorMarker));
scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
hold on
% colormap(colorMarker');
% colorbar('north','Ticks',[-1 1],'TickLabels',{'4s','0s'},'Direction','reverse')
drawsphere(0,0,0,1)
hold on
quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
quiver3(0,0,0,n(shownEnd,1),n(shownEnd,2),n(shownEnd,3), ...
    'LineWidth',2,'Color','#D95319','AutoScale','on','AutoScaleFactor',1)
xlabel("x")
ylabel("y")
zlabel("z")
%属性设置
ax = gca;
ax.GridLineStyle = '-';
ax.View = [-135.240692185176 38.0033333851553];
title("Three Rotor Failure")

% subplot(5,4,12)
% plot(time(:)-time(1),n_b_e)
% % xlabel("Time [s]")
% legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
% title("Rotation Axis")
% xlim([14,40])
% ylim([-0.8,1])
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';

subplot(4,4,12)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,1),'-')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,2),'--')
hold on
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad(:,3),'-.')

hold on
area([0,15],[20,20],-50,'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([15,22.5],[20,20],-50,'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([22.5,40],[20,20],-50,'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([14,40])
ylim([-43,20])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(4,4,16)
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')

hold on
area([0,15],[10,10],'FaceColor','#c0e2c0','EdgeColor','#c0e2c0','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([15,22.5],[10,10],'FaceColor','#ffd8b7','EdgeColor','#ffd8b7','FaceAlpha',.3,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)
hold on
area([22.5,40],[10,10],'FaceColor','#A2142F','EdgeColor','#A2142F','FaceAlpha',.15,'EdgeAlpha',.0, ...
    'ShowBaseLine',"off",'LineWidth',5)

title("Desired Rotors Thrust (N)")
xlim([14,40])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$","fault-free","\#1 fails","\#1,\#2,\#3 fail",'Interpreter',"latex",'Orientation','vertical','NumColumns',4)
ax = gca;
ax.GridLineStyle = '-';
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