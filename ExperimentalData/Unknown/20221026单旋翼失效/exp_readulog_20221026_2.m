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
%% log说明：单旋翼失效的瞬间切换，不是逐渐切换过程，参数和实验保持一致
% k_rotor = 1.6(log_) k_omega = 12 1号旋翼失效

ulogOBJ = ulogreader("log_0_2022-10-26-19-40-46.ulg");
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
LOE = unknown_logger.loe;
CH7 = unknown_logger.ch7;
time_unknown_logger = seconds(log_time);
[time_size_unknown_logger,~] = size(unknown_logger);
Tdes = unknown_logger.tdes;

% 数据处理 计算实际的期望电机拉力
T_fault = zeros(time_size_unknown_logger,4);
for i = 1:time_size_unknown_logger
    Lambda = diag([LOE(i) 1 1 1]);
    T_fault(i,:) = Lambda*Tdes(i,:)';
end

% 实际的期望力矩u_1
u = zeros(time_size_unknown_logger,4);
for i = 1:time_size_unknown_logger
    u(i,:) = M*T_fault(i,:)';
end
%% 数据处理:
shownHome = 113;
shownEnd = 240;
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
s.Position(4) = 8.0;
clf

% 第一条线的颜色大小
samplevectorcolorR = linspace(1, 1, shownlength);
samplevectorcolorG = linspace(0.8, 0, shownlength);
samplevectorcolorB = linspace(0.8, 0, shownlength);
samplevectorcolor = [samplevectorcolorR; samplevectorcolorG; samplevectorcolorB];
% PosEcolor = 0:(1/(out.PosE.Length-1)):1;
colorMarker = samplevectorcolor;   % 颜色渐变
sizeMarker = linspace(10, 50, length(colorMarker));

scatter(u(shownlengthRange,3), u(shownlengthRange,2), sizeMarker, colorMarker','^', 'filled')
% scatter(vActFault(samplevector,3),vActFault(samplevector,2),'o','MarkerEdgeColor','#edb120');
xlim([-0.4 0.4])
ylim([-0.4 0.4])
xlabel("$\tau_q$",'Interpreter',"latex")
ylabel("$\tau_p$",'Interpreter',"latex")
colormap(colorMarker');
colorbar( 'south','Ticks',[0,1],'TickLabels',{'12s','25s'})
legend("Moment Point", 'Interpreter',"latex",'Location',"northeast",'Box',"on","FontSize",9)
%属性设置
ax = gca;
ax.GridLineStyle = ':';
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.FontSize = 9;
annotation('arrow',[0.5949 0.5949],[0.2234 0.9835])
annotation('arrow',[0.2562 0.9553],[0.5950 0.5950])


