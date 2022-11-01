%%% 故障未知HIL用于验证
%% 获取数据
clear
clc
[time_0, h3_0] = obtainh3("log_0_2021-6-30-08-01-42.ulg"); %$\mathbf{\Lambda} = diag(0,0.8,0.6,0.9)$
[time_1, h3_1] = obtainh3("log_1_2021-6-30-08-01-40.ulg"); %$\mathbf{\Lambda} = diag(0,0.7,0.5,0.8)$
[time_2, h3_2] = obtainh3("log_2_2021-6-30-08-01-24.ulg"); %$\mathbf{\Lambda} = diag(0,0.6,0.5,1)$
[time_3, h3_3] = obtainh3("log_3_2021-6-30-08-01-34.ulg"); %$\mathbf{\Lambda} = diag(0,0.7,1,0.6)$
[time_4, h3_4] = obtainh3("log_4_2021-6-30-08-01-30.ulg"); %$\mathbf{\Lambda} = diag(0,0.6,1,0.5)$
[time_5, h3_5] = obtainh3("log_5_2021-6-30-08-01-28.ulg"); %$\mathbf{\Lambda} = diag(0,0.6,0.6,0.5)$
[time_6, h3_6] = obtainh3("log_6_2021-6-30-08-04-24.ulg"); %$\mathbf{\Lambda} = diag(0,0,0,1)$
%% 处理数据 图一
figure(1)
clf
subplot(3,2,1)
plot(time_0, h3_0);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([65,95])
legend('$1$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")

subplot(3,2,2)
plot(time_1, h3_1);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([70,100])
legend('$2$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")

subplot(3,2,3)
plot(time_2, h3_2);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([50,80])
legend('$3$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")

subplot(3,2,4)
plot(time_3, h3_3);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([55,85])
legend('$4$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")

subplot(3,2,5)
plot(time_4, h3_4);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([53,83])
legend('$5$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")

subplot(3,2,6)
plot(time_5, h3_5);
xlabel('Time [s]','Interpreter',"latex")
ylabel('$h_3$','Interpreter','latex')
xlim([50,80])
legend('$6$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")
%% 处理数据 图二
s = figure(2);
s.Position = [0 0 13.2 10];
clf
plot(time_2-50, h3_2,"-");

hold on
plot(time_3-55, h3_3,"--");

hold on
plot(time_4-53, h3_4,"-.");

hold on
plot(time_5-50, h3_5,":");

% hold on
% plot(time_6-210, h3_6);

xlim([0,30])
xlabel('Time [s]','Interpreter',"latex")
ylim([0.9,1])
ylabel('$n_{3,z}$','Interpreter','latex')
legend(...
    '$\mathbf{\Lambda} = \mathrm{diag}(0,0.6,0.5,1)$', ...
    '$\mathbf{\Lambda} = \mathrm{diag}(0,0.7,1,0.6)$', ...
    '$\mathbf{\Lambda} = \mathrm{diag}(0,0.6,1,0.5)$', ...
    '$\mathbf{\Lambda} = \mathrm{diag}(0,0.6,0.6,0.5)$', ...
    'Interpreter',"latex",'Location',"best")

%% read h3 from unknown_logger
function [time, h3] = obtainh3(str)
ulogOBJ = ulogreader(str);
msg = readTopicMsgs(ulogOBJ);
% 获取unknown_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
% [time_size,~] = size(time);

h3 = unknown_logger.h3;
end