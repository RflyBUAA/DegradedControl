% 该脚本目前的计算结果不符合预期，应该是计算方式有问题
J = 0.0056;
c  = (0.0166);
l  = (0.125);
% M = [1/J 0;0 1/J]*...
%     ([-0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
%        0.7071*l  -0.7071*l  -0.7071*l  0.7071*l]);
M = [1/J 0;0 1/J]*...
    ([-0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l])*...
     diag([0 0 0 1]);
[p1, p2, p3, Qc] = calDOC(0.0104,0.0056,-30,M)
function [p1, p2, p3, Qc] = calDOC(J_z, J, omega_0z, B)
k = (J_z/J-1);
% k_rJ = kr/J;

A = [0 -k*omega_0z;...
     k*omega_0z  0];
% B = [1/J;1/J];
% A = [0   omega_0z   0     -1;...
%      -omega_0z   0   1     0;...
%      0    0    -k_rJ     -k*omega_0z;...
%      0    0   k*omega_0z  -k_rJ];
% B = [0;0;J^-1;0];

Qc = [B, A*B];
% isControllable = det(Qc);
% 计算可控度
p1 = min(eig(Qc'*Qc));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);
end