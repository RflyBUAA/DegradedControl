clear
clc
ulogOBJ = ulogreader("log_1_2021-6-30-08-03-46.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取unknown_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
% [time_size,~] = size(time);

u_d = unknown_logger.u_d;
% 
%% 
figure(1)
plot(time,u_d)