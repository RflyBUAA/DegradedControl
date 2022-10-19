% 故障系数切换代码如下，电机顺序为从右前方顺时针计数依次为1 2 3 4 
clear
clc
figure_configuration_IEEE_standard
%% log中电机故障的序号具体查看README文档，日志是在飞行过程中直接记录的，不包括起飞的状态，只记录了故障过程中的数据
% 控制器中的耦合项补偿使用的是A_2(omega-omega_d)的形式
% 机体模型数据
c  = (0.0166);
l  = (0.125);
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
%% 画图1
s=figure(1);
s.Position(4) = 8.0;
[u] = readtdes("log_0_2021-6-30-08-01-52.ulg",diag([0,1,1,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_4_2021-6-30-08-08-14.ulg",diag([1,1,0,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_7_2021-6-30-08-14-34.ulg",diag([1,0,1,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_11_2021-6-30-08-21-04.ulg",diag([1,1,1,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on
% 设置坐标轴位置
xlim([-0.4 0.4])
ylim([-0.4 0.4])
xlabel("$\tau_q$",'Interpreter',"latex")
ylabel("$\tau_p$",'Interpreter',"latex")
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
annotation('arrow',[0.266025641025641 0.923076933822953],...
    [0.591592592592593 0.591592592592593]);
annotation('arrow',[0.594551282051282 0.594551282051282],...
    [0.226513227513228 0.96031746031746]);
legend("\#1 failure","\#3 failure","\#2 failure","\#4 failure", ...
    'Position',[0.477437740820779 0.101149425518512 0.448671786925395 0.124404766029782],...
    'Interpreter',"latex",'Orientation','horizontal','NumColumns',2);
%% 画图2
s = figure(2);
s.Position(4) = 8.0;
[u] = readtdes("log_1_2021-6-30-08-02-22.ulg",diag([0,0,1,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_5_2021-6-30-08-08-44.ulg",diag([1,1,0,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_8_2021-6-30-08-15-04.ulg",diag([0,0,1,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_12_2021-6-30-08-21-34.ulg",diag([1,1,0,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on
% 设置坐标轴位置
xlim([-0.8 0.8])
ylim([-0.8 0.8])
xlabel("$\tau_q$",'Interpreter',"latex")
ylabel("$\tau_p$",'Interpreter',"latex")
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
annotation('arrow',[0.264423076923077 0.924679487179487],...
    [0.58894708994709 0.58894708994709]);
annotation('arrow',[0.594551282051282 0.594551282051282],...
    [0.226513227513228 0.957671957671957]);
legend("\#1 \#2 failure","\#3 \#4 failure","\#2 \#1 failure","\#4 \#3 failure", ...
    'Position',[0.386464921835241 0.103795258851845 0.540819445098491 0.124404766029782],...
    'Interpreter',"latex",'Orientation','horizontal','NumColumns',2);
%% 画图3
s = figure(3);
s.Position(4) = 8.0;
[u] = readtdes("log_2_2021-6-30-08-02-52.ulg",diag([0,1,0,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_9_2021-6-30-08-15-34.ulg",diag([1,0,1,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on
% 设置坐标轴位置
xlim([-0.3 0.3])
ylim([-0.3 0.3])
xlabel("$\tau_q$",'Interpreter',"latex")
ylabel("$\tau_p$",'Interpreter',"latex")
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
annotation('arrow',[0.266025641025641 0.923076923076923],...
    [0.591592592592593 0.591592592592593]);
annotation('arrow',[0.596153846153846 0.596153846153846],...
    [0.223867724867725 0.957671957671957]);
legend("\#1 \#3 failure","\#2 \#4 failure", ...
    'Position',[0.384862357732677 0.155812455650296 0.540819445098491 0.067989420051928],...
    'Interpreter',"latex",'Orientation','horizontal');
%% 画图4
s =figure(4);
s.Position(4) = 8.0;
[u] = readtdes("log_3_2021-6-30-08-03-22.ulg",diag([0,0,0,1]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_6_2021-6-30-08-09-14.ulg",diag([0,1,0,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_10_2021-6-30-08-16-04.ulg",diag([0,0,1,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on

[u] = readtdes("log_13_2021-6-30-08-22-04.ulg",diag([1,0,0,0]),M);
sizeMarker = linspace(1, 10, length(u));
scatter(u(:,3),u(:,2),sizeMarker,'o', 'filled')
hold on
% 设置坐标轴位置
xlim([-0.6 0.6])
ylim([-0.6 0.6])
xlabel("$\tau_q$",'Interpreter',"latex")
ylabel("$\tau_p$",'Interpreter',"latex")
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
annotation('arrow',[0.264423076923077 0.923076923076923],...
    [0.591592592592593 0.591592592592593]);
annotation('arrow',[0.594551282051282 0.594551282051282],...
    [0.226513227513228 0.96031746031746]);
legend("\#1 \#2 \#3 failure","\#3 \#4 \#1 failure","\#2 \#1 \#4 failure","\#4 \#3 \#2 failure", ...
    'Position',[0.293888591949356 0.101149425518512 0.63296705436521 0.124404766029782],...
    'Interpreter',"latex",'Orientation','horizontal','NumColumns',2);
%%
function [u] = readtdes(ulogfile,Lambda,M)
ulogOBJ = ulogreader(ulogfile);
msg = readTopicMsgs(ulogOBJ);
% 获取unknown_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);
% 数据获取
tdes = unknown_logger.tdes;
% 数据处理 计算实际的期望电机拉力
T_fault = zeros(time_size,4);
    for i = 1:time_size
        T_fault(i,:) = Lambda*tdes(i,:)';
    end

% 实际的期望力矩u_1
u = zeros(time_size,4);
    for i = 1:time_size
        u(i,:) = M*T_fault(i,:)';
    end
end