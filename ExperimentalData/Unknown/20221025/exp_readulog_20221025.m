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
%% log说明：两个均为单旋翼失效的瞬间切换，不是逐渐切换过程
ulogOBJ = ulogreader("log_6_2022-10-25-22-51-22.ulg");
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
shownHome = 3000;
shownEnd = 3700;
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

subplot(3,2,2)
plot(time(:)-time(1),n_b_e)
% xlabel("Time [s]")
legend("$n_x$","$n_y$","$n_z$",'Interpreter',"latex",'Orientation','horizontal')
title("Rotation Axis")
xlim([0,20])
%属性设置
ax = gca;
ax.GridLineStyle = '-';

subplot(3,2,4)
plot( time_sensor_combined(:)-time_sensor_combined(1), gyro_rad)
xlabel("Time [s]")
legend("$p$","$q$","$r$",'Interpreter',"latex",'Orientation','horizontal')
title("Body Angular Rate (rad/s)")
xlim([0,20])
%属性设置
ax = gca;
ax.GridLineStyle = '-';
% ax.View = [52.7013669854862 29.4383187247844];


subplot(3,2,[5,6])
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,1),'-')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,2),'--')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,3),'-.')
hold on
plot(time_unknown_logger-time_unknown_logger(1),Tdes(:,4),':')
title("Rotors Thrust (N)")
xlim([0,20])
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