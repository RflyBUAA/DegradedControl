% 故障系数切换代码如下，电机顺序为从右前方顺时针计数依次为1 2 3 4 
% if LOE>0.3 %fault-free and 0.5 fault
%     if LOE>0.8
%         Lambda=diag([single(1),single(1),single(1),single(1)]);
%     else
%         Lambda=diag([single(1),single(1),single(1),single(0)]);
%     end
% else % one, two, and three rotors failure
%     if CH7<1300
%         Lambda=diag([single(1),single(1),single(0),single(0)]);
%     else
%         if CH7<1700 %1300<=CH7<1700
%             Lambda=diag([single(0),single(0),single(0),single(1)]);
%         else%CH7>=1700
%             Lambda=diag([single(0),single(0),single(1),single(0)]);
%         end
%     end
% end
%%
clear
clc
ulogOBJ = ulogreader("log_0_2021-6-30-08-03-18.ulg");
msg = readTopicMsgs(ulogOBJ);
% 获取unknown_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);
%% 数据获取
tdes = unknown_logger.tdes;
LOE = unknown_logger.loe;
ch7 = unknown_logger.ch7;
%% 数据处理 计算实际的期望电机拉力
T_fault = zeros(time_size,4);
for i = 1:time_size
    if LOE(i)>0.3 %fault-free and 0.5 fault
        if LOE(i)>0.8
            Lambda=diag([single(1),single(1),single(1),single(1)]);
        else
            Lambda=diag([single(0),single(1),single(1),single(1)]);
        end
    else % one, two, and three rotors failure
        if CH7(i)<1300
            Lambda=diag([single(0),single(0),single(1),single(1)]);
        else
            if CH7(i)<1700 %1300<=CH7<1700
                Lambda=diag([single(0),single(1),single(0),single(1)]);
            else%CH7>=1700
                Lambda=diag([single(1),single(1),single(1),single(0)]);
            end
        end
    end
    T_fault(i,:) = Lambda*tdes(i,:)';
end
% 机体模型数据
c  = (0.0166);
l  = (0.125);
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
%% 实际的期望力矩u_1
u = zeros(time_size,4);
for i = 204:631
    u(i,:) = M*T_fault(i,:)';
end
% 画图
figure(1)

scatter(u(:,3),u(:,2),'^', 'filled')
xlim([-1,1])
ylim([-1,1])
% 设置坐标轴位置
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

