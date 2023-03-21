clear
clc
% [p11, p21, p31, Qc1, Q1] = unknownDOC3(0.6,-20);
% [p12, p22, p32, Qc2, Q2] = controldeg2(0.0104, 0.0056, -20, 0, 0.6);
% eigQ1 = abs(eig(Q1))
% eigQ2 = abs(eig(Q2))

k_cp = 0:0.01:1;
[~,n] = size(k_cp);
for i = 1:n
    [~, p1(i),~,~,~] = controldeg2(0.0104, 0.0056, -20, 0, k_cp(i));
end
figure(1)
plot(k_cp, p1)
%%
figure(2)
r = 0:0.01:40;
[~, n] = size(r);
k_cp = 0:0.2:1;
[~, n2] = size(k_cp);
j = 1:n2
for i = 1:n
    [~,~, p1(i),~,~] = controldeg2(0.0104, 0.0056, -r(i), 0, k_cp(1));
end
plot(r,p1)
hold on

for i = 1:n
    [~,~,p2(i),~,~] = controldeg2(0.0104, 0.0056, -r(i), 0, k_cp(2));
end
plot(r,p2)
hold on

for i = 1:n
    [~, ~,p3(i),~,~] = controldeg2(0.0104, 0.0056, -r(i), 0, k_cp(3));
end
plot(r,p3)
hold on

for i = 1:n
    [~, ~,p4(i),~,~] = controldeg2(0.0104, 0.0056, -r(i), 0, k_cp(4));
end
plot(r,p4)
hold on

for i = 1:n
    [~, ~, p5(i),~,~] = controldeg2(0.0104, 0.0056, -r(i), 0, k_cp(5));
end
plot(r,p5)
hold on

%%


function [p1, p2, p3, Qc, Q] = unknownDOC3(k_cp, r)
J_x = 0.0056;
J_y = 0.0056;
J_z = 0.0104;

A_2 = [0     -(k_cp+1)*(J_z-J_y)/J_x*r; 
       -(k_cp+1)*(J_x-J_z)/J_y*r     0];

B_2 = [1/J_x  0;
       0      1/J_y];

AA = A_2;
BB = B_2;

Qc = [BB, AA*BB];
Q = Qc'*Qc;
p1 = min((eig(Qc'*Qc)));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);
end

function [p1, p2, p3, Qc, Q] = controldeg2(J_z, J, omega_0z, kr, kcp)
k = (kcp+1)*(J_z/J-1);
k_rJ = kr/J;

A = [0     -k*omega_0z;...
     k*omega_0z  0];
B = [1/J;
    0 ];

Qc = [B, A*B];
Q = Qc'*Qc;
% 计算可控度
p1 = min((eig(Qc'*Qc)));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);
end