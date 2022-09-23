% 故障未知HIL用于验证u u_c hat_d之间的关系
clear
clc
ulogOBJ = ulogreader("log_1_2021-6-30-08-04-36.ulg");
msg = readTopicMsgs(ulogOBJ);

%% unknown_logger
clc
% 获取unknown_logger数据
unknown_logger = msg.TopicMessages{findtopic(msg.TopicNames, 'unknown_logger')};
% 生成相对时间
log_time = unknown_logger.timestamp;
time = seconds(log_time);
[time_size,~] = size(time);

u = unknown_logger.u;
u_c = unknown_logger.u_c;
hat_d = unknown_logger.hat_d;
d = unknown_logger.d;
Tdes = unknown_logger.tdes;

k_rotor = 1.3;
k_u0 = k_rotor/(1+k_rotor);

% k_d1 = 1.14;
y_u1 = zeros(time_size,1);
for i = 1:time_size
    if abs(d(i,1))<0.05
        k_d1= 1;
    else
        k_d1 = hat_d(i,1)/d(i,1);
    end
    y_u1(i) = k_u0*u_c(i,1)+((1-k_d1*k_u0)/k_d1)*(-hat_d(i,1));
end

y_u2 = zeros(time_size,1);
for i = 1:time_size
    if abs(d(i,2))<0.05
        k_d2= 1;
    else
        k_d2 = hat_d(i,2)/d(i,2);
    end
    y_u2(i) = k_u0*u_c(i,2)+((1-k_d2*k_u0)/k_d2)*(-hat_d(i,2));
end


figure(1)
clf
subplot(2,1,1)
plot(time, u(:,1));
hold on 
plot(time, y_u1 );
xlabel('Time [s]','Interpreter',"latex")
ylabel('$\tau_p$','Interpreter','latex')
xlim([20,90])

subplot(2,1,2)
plot(time, u(:,2));
hold on 
plot(time, y_u2 );
xlabel('Time [s]','Interpreter',"latex")
ylabel('$\tau_q$','Interpreter','latex')
xlim([20,90])

legend('$\mathbf{u}$','$k_{\mathbf{u}_0}\mathbf{u}_\textrm{c}+\frac{(1-\eta k_{\mathbf{u}_0})}{\eta}(-\hat{\mathbf{d}})$' ...
    ,'Orientation',"horizontal",'Interpreter',"latex",'Location',"bestoutside")
%%
% figure(2)
% clf
% plot(time,d(:,2));
% hold on
% plot(time,hat_d(:,2));

figure(3)
clf
plot(time, Tdes)
