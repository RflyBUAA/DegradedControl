%% 数据部分
x=0:0.1:2*pi; %X
y=sin(x); %Y
lw=0.1/2; % 线宽

%% 方案1
lx=diff(x);
ly=diff(y);
lr=sqrt(lx.^2+ly.^2);
lx=lx./lr;
ly=ly./lr;
X=x([2:end,end:-1:2])+lw*[ly,-ly(end:-1:1)];
Y=y([2:end,end:-1:2])+lw*[-lx,lx(end:-1:1)];
fill(X,Y,'-r','EdgeColor','none','FaceAlpha',0.5)
%% 方案2
LinAlpha=0.25;           
ColorValue=[1,0,0];
plot(x,y,'-','Color',(1.0-LinAlpha)*(1.0-ColorValue),'EraseMode','xor','LineWidth',5)  
plot(x,y,'-','Color',1.0-ColorValue,'EraseMode','xor','LineWidth',5) 

% plot(x,y,'-','Color',1.0-LinAlpha*(1.0-ColorValue),'EraseMode','xor')
%%
% scatter1 = scatter(x,y,'MarkerFaceColor','r','MarkerEdgeColor','r'); 
% % Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
% scatter1.MarkerFaceAlpha = .2;
% scatter1.MarkerEdgeAlpha = .2;
% %or
% scatter1 = scatter(x,y,'MarkerFaceColor','r','MarkerEdgeColor','r'); 
% alpha(scatter1,.2)
%%
x = linspace(0,10);
y1 = 4 + sin(x).*exp(0.1*x);
area(x,y1,'FaceColor','b','FaceAlpha',.3,'EdgeAlpha',.3)

y2 = 4 + cos(x).*exp(0.1*x);
hold on
area(x,y2,'FaceColor','r','FaceAlpha',.3,'EdgeAlpha',.3)
hold off