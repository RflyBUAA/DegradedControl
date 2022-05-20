%% 
% 障已知的实验, log2时间久
clear
clc
ulogOBJ = ulogreader("log_1_2022-5-19-22-25-06.ulg");
msg = readTopicMsgs(ulogOBJ);
%% 
s = figure(11);
s.Units = 'centimeters';
s.Position = [0,0,13.2,16.5];
%% known_logger
% 更换log文件后需要修改下面的数值，找到msg中对应的known_logger的序号是多少。

% 获取known_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);

%% 电机推力图
% 读取数据
tDes = unknown_logger.tdes;
iter = unknown_logger.iter;
subplot(5,1,1)
cla
% plot(time,tDes(:,1))
% hold on
plot(time,tDes(:,3),'--')
hold on
plot(time,tDes(:,4),'--')
hold on
plot(time,tDes(:,2),'--')
ylabel('Rotor Force(N)','Interpreter',"latex")
legend('#2','#3','#4','Location',"best",'Orientation',"horizontal")

% subplot(8,1,2)
% plot(time, iter,'--o','LineWidth',0.5)
% legend('Iterations')
% ylim([0,10])
% c = (0.0166);
% l = (0.125);
% M = ([ 1          1          1         1;
%       -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
%        0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
%        c         -c          c        -c]);
% for i=1:time_size
%     vAct(:,i) = M*tDes(i,:)';
% end

% subplot(4,1,1)
% cla
% plot(time,vAct(2:4,:))

%% 位置跟踪图
pos = unknown_logger.pos;
posd = unknown_logger.posd;

subplot(5,1,4)
cla
plot(time,pos(:,1))
hold on 
plot(time,posd(:,1),'--')
legend('Measuremant','Reference','Location','best')
ylabel('Pos X [m]','Interpreter',"latex")

subplot(5,1,5)
cla
plot(time,pos(:,2))
hold on 
plot(time,posd(:,2),'--')
legend('Measuremant','Reference','Location','best')
ylabel('Pos Y [m]','Interpreter',"latex")
xlabel('Time [s]','Interpreter',"latex")
%% vehicle_attitude

vehicle_attitude = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_attitude')};
% 生成相对时间
time = seconds(vehicle_attitude.timestamp);

% 获取数据
[size_time,~] = size(time);
quate = vehicle_attitude.q;
angle = quat2dcm(quate);

primary_axis = zeros(size_time,3);
for i=1:size_time
    primary_axis(i,:) = angle(:,:,i)*[0,0,1]';
end

subplot(5,1,3)
cla
plot(time,primary_axis(:,1))
hold on
plot(time,primary_axis(:,2))
hold on
plot(time,primary_axis(:,3))
ylabel('$\mathbf{n}_3$','Interpreter',"latex")
legend('$h_1$','$h_2$','$h_3$','Orientation',"horizontal",'Interpreter',"latex",'Location',"best")
%% sensor_combined

sensor_combined = msg.TopicMessages{findtopic(msg.TopicNames, 'sensor_combined')};
% 生成相对时间
time = seconds(sensor_combined.timestamp);

% 获取数据 
gyro = sensor_combined.gyro_rad;

subplot(5,1,2)
cla
plot(time, gyro)
legend('p','q','r','Orientation',"horizontal",'Location','best')
ylabel('[rad/s]','Interpreter',"latex")
%% input_rc

% input_rc = msg.TopicMessages{findtopic(msg.TopicNames, 'input_rc')};
% % 生成相对时间
% log_time = input_rc.timestamp;
% time = seconds(log_time);
% [sample_count,~] = size(log_time);
% % 获取数据
% rc = input_rc.values;
% 
% subplot(8,1,5)
% 
% % plot(time,rc(:,4),'--')
% % hold on
% % plot(time,rc(:,5),'--')
% % hold on
% plot(time,rc(:,6),'--','LineWidth',2)
% legend('Fault Switch','Location',"best",'Orientation',"horizontal")
% xlabel('Time(s)')
% 
% subplot(8,1,6)
% plot(time,(rc(:,1)-1500)/500*20,'LineWidth',1)
% hold on
% subplot(8,1,7)
% plot(time,(rc(:,2)-1500)/500*20,'LineWidth',1)
% hold on
% subplot(8,1,8)
% plot(time,rc(:,3),'--')
% hold on

% vehicle_local_position

% vehicle_local_position = msg.TopicMessages{findtopic(msg.TopicNames, 'vehicle_local_position')};
% % 生成相对时间
% log_time = vehicle_local_position.timestamp;
% time = seconds(log_time);
% [sample_count,~] = size(log_time);
% % 获取数据
% pos_x = vehicle_local_position.x;
% pos_y = vehicle_local_position.y;
% pos_z = vehicle_local_position.z;
% 
% % 
% % figure(11)
% % clf
% subplot(8,1,6)
% plot(time, pos_y)
% subplot(8,1,7)
% plot(time, pos_x)
% subplot(8,1,8)
% plot(time, pos_z)

%%
figure(12)
cla
plot(posd(:,1),posd(:,2))
hold on
plot(pos(:,1),pos(:,2))
