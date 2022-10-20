clear
clc
figure_configuration_IEEE_standard
%%
figure(1)
subplot(7,2,1)
[n,time] = readn("log_0_2021-6-30-08-01-52.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,2)
[n,time] = readn("log_4_2021-6-30-08-08-14.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,3)
[n,time] = readn("log_7_2021-6-30-08-14-34.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,4)
[n,time] = readn("log_11_2021-6-30-08-21-04.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,5)
[n,time] = readn("log_1_2021-6-30-08-02-22.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,6)
[n,time] = readn("log_5_2021-6-30-08-08-44.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,7)
[n,time] = readn("log_8_2021-6-30-08-15-04.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,8)
[n,time] = readn("log_12_2021-6-30-08-21-34.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,9)
[n,time] = readn("log_2_2021-6-30-08-02-52.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,10)
[n,time] = readn("log_9_2021-6-30-08-15-34.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,11)
[n,time] = readn("log_3_2021-6-30-08-03-22.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,12)
[n,time] = readn("log_6_2021-6-30-08-09-14.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,13)
[n,time] = readn("log_10_2021-6-30-08-16-04.ulg");
plot(time-time(1),n(:,3))
hold on

subplot(7,2,14)
[n,time] = readn("log_13_2021-6-30-08-22-04.ulg");
plot(time-time(1),n(:,3))
hold on

%%
function [n,time] = readn(ulogfile)
ulogOBJ = ulogreader(ulogfile);
msg = readTopicMsgs(ulogOBJ);
% 获取 vehicle_attitude 数据
vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
% 生成相对时间
log_time = vehicle_attitude.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);
% 数据获取:
q = vehicle_attitude.q;
% 数据处理
n = zeros(time_size,3);
for i = 1:time_size
    DCM = quat2dcm(q(i,:));
    n(i,:) = DCM'*[0 0 1]';
end
end