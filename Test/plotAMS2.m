% Control Allocation Matrix
g  = (9.81);
m  = (0.752);
c  = (0.0166);
l  = (0.125);
M = ([ 1          1          1         1;
      -0.7071*l  -0.7071*l   0.7071*l  0.7071*l;
       0.7071*l  -0.7071*l  -0.7071*l  0.7071*l;
       c         -c          c        -c]);
% Rotor Thrust
T_min = 0;
T_max = 5;
T_1 = T_min:0.25:T_max;
T_2 = T_min:0.25:T_max;
T_3 = T_min:0.25:T_max;
T_4 = T_min:0.25:T_max;

%
[~,n1] = size(T_1);
[~,n2] = size(T_2);
[~,n3] = size(T_3);
[~,n4] = size(T_4);
u = zeros(4,n1*n2*n3*n4);


%% 1
figure(1)
clf
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_max;T_max;T_max;T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 2
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 3
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 4
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 5
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 6
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 7
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
hold on
%% 8
k = 0;
for m1 = 1:n1
    for m2 = 1:n2
        for m3 = 1:n3
            for m4 = 1:n4
                k = k+1;
                u(:,k) = M*[T_1(1,m1);T_2(1,m2);T_3(1,m3);T_4(1,m4)];
            end
        end
    end
end
scatter3(u(3,:),u(2,:),u(1,:))
%%
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
% ax.ZAxisLocation = 'origin';