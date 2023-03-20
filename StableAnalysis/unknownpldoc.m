[p1 p2 p3] = unknownDOC3(0.6)
% [p1, p2, p3] = controldeg3(0.0104, 0.0056, -20, 0.001, 0.6)

function [p1, p2, p3] = unknownDOC(k_cp)
J_x = 0.0056;
J_y = 0.0056;
J_z = 0.0104;

k_omega = 14;
k_v_z = 1;
K_2 = diag([k_v_z, k_omega, k_omega]);

% k_cp = 0.6;
r = -20;
A_2 = [0 0 0;
       0 0 -r*(J_z-J_y)/J_x; 
       0 -r*(J_x-J_z)/J_y 0];

n_3_z = 0.9;
k_n_3 = 3;
G_3 = [0 0 0;
        0 -n_3_z*k_n_3 0;
        0 0 -n_3_z*k_n_3];
syms A B C D
A_1 = [-C A;-D B]*[zeros(2,1) eye(2)];

AA = [zeros(2,2) A_1;zeros(3,2) (-K_2 + k_cp*A_2 + G_3)];
BB = [zeros(2,3);(K_2 - k_cp*A_2)];
Qc = [BB, AA*BB, AA*AA*BB AA*AA*AA*BB AA*AA*AA*AA*BB]
p1 = min(eig(Qc'*Qc));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);
end


function [p1, p2, p3] = unknownDOC2(k_cp)
J_x = 0.0056;
J_y = 0.0056;
J_z = 0.0104;

k_omega = 14;
k_v_z = 1;
K_2 = diag([k_v_z, k_omega, k_omega]);

% k_cp = 0.6;
r = -20;
A_2 = [0 0 0;
       0 0 -r*(J_z-J_y)/J_x; 
       0 -r*(J_x-J_z)/J_y 0];

n_3_z = 0.9;
k_n_3 = 3;
G_3 = [0 0 0;
        0 -n_3_z*k_n_3 0;
        0 0 -n_3_z*k_n_3];
syms A B C D
A_1 = [-C A;-D B]*[zeros(2,1) eye(2)];
m=0.710;
B_2 = [-n_3_z/m 0 0;0 1/J_x 0;0 0 1/J_y];
AA = [zeros(2,2) A_1;zeros(3,2) (k_cp+1)*A_2];
BB = [zeros(2,3); B_2];
Qc = [BB, AA*BB, AA*AA*BB AA*AA*AA*BB AA*AA*AA*AA*BB]
p1 = min(eig(Qc'*Qc));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);

end

function [p1, p2, p3] = unknownDOC3(k_cp)
J_x = 0.0056;
J_y = 0.0056;
J_z = 0.0104;

k_omega = 14;
k_v_z = 1;
K_2 = diag([k_v_z, k_omega, k_omega]);

% k_cp = 0.6;
r = -20;
A_2 = [0 0 0;
       0 0 -r*(J_z-J_y)/J_x; 
       0 -r*(J_x-J_z)/J_y 0];

n_3_z = 0.9;
k_n_3 = 3;
G_3 = [0 0 0;
        0 -n_3_z*k_n_3 0;
        0 0 -n_3_z*k_n_3];
syms A B C D
A_1 = [-C A;-D B]*[zeros(2,1) eye(2)];
m=0.710;
B_2 = [-n_3_z/m 0 0;0 1/J_x 0;0 0 1/J_y];
AA = [(k_cp+1)*A_2];
BB = [B_2];
Qc = [BB, AA*BB, AA*AA*BB]
p1 = min(eig(Qc'*Qc));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);

end

function [p1, p2, p3] = controldeg3(J_z, J, omega_0z, kr, kcp)
k = kcp*(J_z/J-1);
k_rJ = kr/J;

A = [0   omega_0z   0     -1;...
     -omega_0z   0   1     0;...
     0    0    -k_rJ     -k*omega_0z;...
     0    0   k*omega_0z  -k_rJ];
B = [0;0;J^-1;0];

Qc = [B, A*B, A*A*B, A*A*A*B]
% 计算可控度
p1 = min(eig(Qc'*Qc));
p2 = 3/trace(inv(Qc'*Qc));
p3 = (abs(det(Qc'*Qc)))^(1/3);
end