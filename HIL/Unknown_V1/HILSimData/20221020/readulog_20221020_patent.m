% 主轴跟踪仿真
% 电机顺序为从右前方顺时针计数依次为1 2 3 4 
clear
clc
figure_configuration_IEEE_standard
%% 画图 一个旋翼失效
figure(1);
clf

shownHome = 3000;
shownEnd = 4000;
shownlength = shownEnd-shownHome+1; 
shownlengthRange = shownHome:shownEnd;

[time, n, n_b_e] = readn("log_0_2021-6-30-08-02-50.ulg");
% subplot(4,4,[1,5,9])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(1, 1, length(colorMarker));
% scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
% hold on
% drawsphere(0,0,0,1)
% hold on
% quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
% quiver3(0,0,0,-0.1,0,0.995, ...
%     'LineWidth',3,'Color','#D95319','AutoScale','on','AutoScaleFactor',1,'ShowArrowHead','on')
% xlabel("x")
% ylabel("y")
% zlabel("z")
% title("One Rotor Failure")
%属性设置
% ax = gca;
% ax.GridLineStyle = '-';
% ax.View = [52.7013669854862 29.4383187247844];

% subplot(2,2,1)
scatter(n(shownlengthRange,1),n(shownlengthRange,2),sizeMarker)
hold on 
scatter(0,0,'o','filled','MarkerFaceColor','#0072BD','MarkerEdgeColor','#FFFFFF')
% hold on
% scatter(-0.1,0,'o','filled','MarkerFaceColor','#D95319','MarkerEdgeColor','#FFFFFF')
xlabel("$n_{3,x}$","Interpreter","latex")
ylabel("$n_{3,y}$","Interpreter","latex")
xlim([-0.25,0.25])
ylim([-0.25,0.25])
% title("一个旋翼失效")
%属性设置
ax = gca;
ax.GridLineStyle = ':';
%% 两个相邻旋翼失效
shownHome = 3000;
shownEnd = 4000;
shownlength = shownEnd-shownHome+1; 
shownlengthRange = shownHome:shownEnd;

[time, n, n_b_e,~,~,Tdes] = readn("log_1_2021-6-30-08-03-38.ulg");
% subplot(4,4,[2,6,10])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(1, 1, length(colorMarker));
% scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
% hold on
% drawsphere(0,0,0,1)
% hold on
% quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
% quiver3(0,0,0,-0.1,0,0.995, ...
%     'LineWidth',3,'Color','#D95319','AutoScale','on','AutoScaleFactor',1,'ShowArrowHead','on')
% xlabel("x")
% ylabel("y")
% zlabel("z")
% title("Two Adjacent Rotor Failure")
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';
% % ax.View = [52.7013669854862 29.4383187247844];

figure(2)
scatter(n(shownlengthRange,1),n(shownlengthRange,2),sizeMarker)
hold on 
scatter(0,0,'o','filled','MarkerFaceColor','#0072BD','MarkerEdgeColor','#FFFFFF')
% hold on
% scatter(-0.1,0,'o','filled','MarkerFaceColor','#D95319','MarkerEdgeColor','#FFFFFF')
xlabel("$n_{3,x}$","Interpreter","latex")
ylabel("$n_{3,y}$","Interpreter","latex")
xlim([-0.25,0.25])
ylim([-0.25,0.25])
% title("相邻两个旋翼失效")
%属性设置
ax = gca;
ax.GridLineStyle = ':';
%% 两个对角旋翼失效
shownHome = 2500;
shownEnd = 3500;
shownlength = shownEnd-shownHome+1; 
shownlengthRange = shownHome:shownEnd;

[time, n, n_b_e] = readn("log_2_2021-6-30-08-04-20.ulg");
% subplot(4,4,[3,7,11])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(1, 1, length(colorMarker));
% scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
% hold on
% drawsphere(0,0,0,1)
% hold on
% quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
% quiver3(0,0,0,-0.1,0,0.995, ...
%     'LineWidth',3,'Color','#D95319','AutoScale','on','AutoScaleFactor',1,'ShowArrowHead','on')
% xlabel("x")
% ylabel("y")
% zlabel("z")
% title("Two Opposite Rotor Failure")
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';
% % ax.View = [52.7013669854862 29.4383187247844];

figure(3)
scatter(n(shownlengthRange,1),n(shownlengthRange,2),sizeMarker)
hold on 
scatter(0,0,'o','filled','MarkerFaceColor','#0072BD','MarkerEdgeColor','#FFFFFF')
% hold on
% scatter(-0.1,0,'o','filled','MarkerFaceColor','#D95319','MarkerEdgeColor','#FFFFFF')
xlabel("$n_{3,x}$","Interpreter","latex")
ylabel("$n_{3,y}$","Interpreter","latex")
xlim([-0.25,0.25])
ylim([-0.25,0.25])
% title("对角两个旋翼失效")
%属性设置
ax = gca;
ax.GridLineStyle = ':';
%% 三个旋翼失效
shownHome = 2500;
shownEnd = 3500;
shownlength = shownEnd-shownHome+1; 
shownlengthRange = shownHome:shownEnd;
[time, n, n_b_e] = readn("log_3_2021-6-30-08-05-06.ulg");
% subplot(4,4,[4,8,12])
samplevectorcolorR = linspace(0,0.850,shownlength);
samplevectorcolorG = linspace(0.447,0.325,shownlength);
samplevectorcolorB = linspace(0.741,0.0890,shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
colorMarker = samplevectorcolor;
sizeMarker = linspace(1, 1, length(colorMarker));
% scatter3(n(shownlengthRange,1),n(shownlengthRange,2),n(shownlengthRange,3), sizeMarker, colorMarker','.')
% hold on
% drawsphere(0,0,0,1)
% hold on
% quiver3(0,0,0,0,0,1,'-','LineWidth',2,'Color','#0072BD','AutoScale','on','AutoScaleFactor',1)
% quiver3(0,0,0,-0.1,0,0.995, ...
%     'LineWidth',3,'Color','#D95319','AutoScale','on','AutoScaleFactor',1,'ShowArrowHead','on')
% xlabel("x")
% ylabel("y")
% zlabel("z")
% title("Three Rotor Failure")
% %属性设置
% ax = gca;
% ax.GridLineStyle = '-';
% % ax.View = [52.7013669854862 29.4383187247844];

figure(4)
scatter(n(shownlengthRange,1),n(shownlengthRange,2),sizeMarker)
hold on 
scatter(0,0,'o','filled','MarkerFaceColor','#0072BD','MarkerEdgeColor','#FFFFFF')
% hold on
% scatter(-0.1,0,'o','filled','MarkerFaceColor','#D95319','MarkerEdgeColor','#FFFFFF')
xlabel("$n_{3,x}$","Interpreter","latex")
ylabel("$n_{3,y}$","Interpreter","latex")
xlim([-0.25,0.25])
ylim([-0.25,0.25])
% title("三个旋翼失效")
%属性设置
ax = gca;
ax.GridLineStyle = ':';
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
%%
function [time, n, n_b_e,h1d,h2d,Tdes] = readn(ulogfile)
ulogOBJ = ulogreader(ulogfile);
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = vehicle_attitude.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);
% 数据获取:
q = vehicle_attitude.q;
h1d = unknown_logger.h1d;
h2d = unknown_logger.h2d;
Tdes = unknown_logger.tdes;
% 数据处理:
n = zeros(time_size,3);
n_b_e = zeros(time_size,3);
for i = 1:time_size
    DCM = quat2dcm(q(i,:));
    n(i,:) = DCM'*[0 0 1]';
    n_b_e(i,:) = DCM*[0 0 1]';
end
end