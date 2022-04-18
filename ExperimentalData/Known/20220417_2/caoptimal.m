function [T, iter, fval] = caoptimal(fd, taop, taoq, taor, W_T, W_S, M, T0)
%CAOPTIMAL 此处显示有关此函数的摘要
%   用于离线计算控制分配结果
vd = [fd; taop; taoq; taor];
W=diag([100 10000 10000 1]);% W=diag([1 20 20 0.9]);
w_T = W_T;% 最小化输出权重
w_S = W_S;% 平滑因子权重
H = M'*W*M + diag([w_T w_T w_T w_T]);
f = -(vd'*W*M + w_T*[0,0,0,0])';
% Td = B*vd;
lb  = [0 0 0 0]';
% ub  = [8.5 8.5 8.5 8.5]';%h250 8.5 8.5 8.5 8.5 %h333 16
ub  = [5 5 5 5]';

% if (max(B*vd)>3)||(min(B*vd)<0)
    options = optimoptions(@quadprog,'Algorithm','active-set','MaxIterations',10);

    [T,fval,~,output] = quadprog(H, f, [], [], [], [], lb, ub, T0, options);
     iter = output.iterations;
end

