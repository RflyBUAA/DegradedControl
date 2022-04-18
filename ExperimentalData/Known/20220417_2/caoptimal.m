function [T, iter, fval] = caoptimal(fd, taop, taoq, taor, W_T, W_S, M, T0)
%CAOPTIMAL �˴���ʾ�йش˺�����ժҪ
%   �������߼�����Ʒ�����
vd = [fd; taop; taoq; taor];
W=diag([100 10000 10000 1]);% W=diag([1 20 20 0.9]);
w_T = W_T;% ��С�����Ȩ��
w_S = W_S;% ƽ������Ȩ��
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

