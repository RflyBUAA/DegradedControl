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
%% log说明：14（角速率环）1.3（电机环）三个旋翼失效画图
% log_0：主要为一侧旋翼失效，两个旋翼失效，两个在转 
% log_1：时间较短
% log_2: 对角旋翼失效
% log_3：三个旋翼失效（伪，有静速） 
% log_4-8是去除loe ch7 log连线后的测试，发现控制效果变好了。可能是加log后不同采样率导致的，遥控器采样率很低
% log_4也是双旋翼失效的情况，但是两个旋翼都在转，和28日的比较就很奇怪，难道是电量的问题？
% 基于log_8，log_9-10是三个旋翼失效（真）的
% log_11是两个对角旋翼失效的

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
s=figure(1);
% s.PaperPosition(3) = 40;
clf
subplot(3,2,[1,3])
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

subplot(3,2,2)
plot(time(:)-time(1),n_b_e)
% xlabel("Time [s]")
legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
title("Rotation Axis")
xlim([14,40])
ylim([-0.8,1])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(3,2,4)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad)
xlabel("Time [s]")
legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([14,40])
ylim([-43,24])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(3,2,[5,6])
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')
title("Desired Rotors Thrust (N)")
xlim([14,40])
xlabel("Time [s]")
legend("$\#1$","$\#2$","$\#3$","$\#4$",'Interpreter',"latex",'Orientation','horizontal')
ax = gca;
ax.GridLineStyle = '-';

% figure(2)
% plot(time(:)-time(1),n)
% xlabel("Time [s]")
% legend("$n_{3,x}$","$n_{3,y}$","$n_{3,z}$",'Interpreter',"latex",'Orientation','horizontal')
% title("Primary Axis")
% xlim([0,50])
% % 属性设置
% ax = gca;
% ax.GridLineStyle = '-';

figure(2)
clf
plot(time_input_rc-time_input_rc(1),CH7)
hold on
plot(time_input_rc-time_input_rc(1),CH6)
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