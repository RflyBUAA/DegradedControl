clear
clc

i = 1;
for pitch = 0:.2:60
    for roll = 0:.2:60
        u = angle2dcm(0, deg2rad(pitch), deg2rad(roll));
        % Calculate minimum angle
        y = abs([2000/u(3,1); 2000/u(3,2); 2000/u(3,3)]);
        miny = min(y);
        anglegroup(i,:) = [pitch,roll,miny];
        i= i+1;
    end
end
max = i-1;
%%
figure(1)
grid on
for i=1:max
    if(anglegroup(i,3)>2900)
        select(i,:) = anglegroup(i,:);
    else
%         scatter3(anglegroup(i,1),anglegroup(i,2),anglegroup(i,3),'.','b')
%         hold on
    end
end
scatter3(select(:,1),select(:,2),select(:,3),'.','r')
grid on