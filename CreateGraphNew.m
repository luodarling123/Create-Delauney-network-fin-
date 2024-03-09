clc
clear 

%% 分配内存

%% 开始循环

 
%% 定义边长 
% a = 12
n = 25; % 点数量
bond = 12; % 边界点位置
% 定义边上的点
a = linspace(0,bond,n); % 边界点坐标
b = linspace(12,bond,n); % 最远边界点坐标
c = linspace(0,0,n);% 最远边界点坐标
% 载入点：底(a,c)+左(c,a)+右(b,a)+顶(a,b)
Bottomp = [a' c'];
Bottomp(end,:) = []; % 去除重复点 ➡
 
Leftp = [c' a'];
Leftp(1,:) = []; % 去除重复点 ⬆

Rightp = [b' a'];
Rightp(end,:) = []; % 去除重复点 ⬆

Topp = [a' b'];
Topp(1,:) = []; % 去除重复点 ➡

% 汇总 逆时针顺序
Boundpoint  =  [Bottomp;Rightp;flipud(Topp);flipud(Leftp)];

% 建立连接表
bond_cor = zeros(length(Boundpoint),9);
for i = 1 : length(Boundpoint)
    % 连接表
    if i ~= length(Boundpoint)
    bond_cor(i,1) = i;
    bond_cor(i,2) = i + 1;
    % 坐标
    bond_cor(i,3) = Boundpoint(i,1);
    bond_cor(i,4) = Boundpoint(i,2);
    bond_cor(i,5) = Boundpoint(i+1,1);
    bond_cor(i,6) = Boundpoint(i+1,2);
    else
        % 连接表
    bond_cor(i,1) = i;
    bond_cor(i,2) = 1;
    % 坐标
    bond_cor(i,3) = Boundpoint(i,1);
    bond_cor(i,4) = Boundpoint(i,2);
    bond_cor(i,5) = Boundpoint(1,1);
    bond_cor(i,6) = Boundpoint(1,2);

    end
end

%initial_Plot(bond_cor)
hold on

%% 撒点
% 设置区域尺寸和点的数量
height = bond;
width = bond/2;
numPoints = 300;

% 最小间距
minLeftTopBottomDistance = 0.2;
minRightDistance = 0.08;
minPointDistance = 0.2;

% 生成随机点
points = zeros(numPoints, 2);
for i = 1:numPoints
    while true
        % 生成随机点坐标
        x = rand() * (width - minRightDistance - minLeftTopBottomDistance) + minLeftTopBottomDistance; % 考虑右边的距离要求
        y = rand() * (height - 2 * minLeftTopBottomDistance) + minLeftTopBottomDistance; % 考虑上边和下边的距离要求
        
        % 检查该点与已有点的最小距离
        distances = sqrt((points(:,1) - x).^2 + (points(:,2) - y).^2);
        
        % 检查该点与上边和下边的距离
        topDistance = y;
        bottomDistance = height - y;
        
        % 检查该点与右边的距离
        rightDistance = width - x;
        
        % 检查该点与其他点的距离
        if isempty(distances) && topDistance >= minLeftTopBottomDistance && ...
           bottomDistance >= minLeftTopBottomDistance && rightDistance >= minRightDistance || ...
           all(distances >= minPointDistance) && topDistance >= minLeftTopBottomDistance && ...
           bottomDistance >= minLeftTopBottomDistance && rightDistance >= minRightDistance
            points(i, :) = [x, y];
            break;
        end
    end
end


% 镜像另一边点的位置
% 翻转另一半 

Point = [points(:,1) points(:,2);12 - points(:,1) points(:,2) ];


%% 画图

scatter(Point(:,1),Point(:,2),'filled','MarkerFaceColor',[0 .7 .7]);
hold on
triPoint = [Point;Boundpoint];%%加入边界点
node_cor = triPoint; %%加入边界点
t = delaunayTriangulation(triPoint);
triplot(t);

