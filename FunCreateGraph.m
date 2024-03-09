function [node_cor,bond_cor] = FunCreateGraph(n,bond,n_inside,Dis)
%FUNCREATEGRAPH 此处显示有关此函数的摘要
%   此处显示详细说明
%FUNCREATEGRAPH 此处显示有关此函数的摘要
%   此处显示详细说明
%% 定义边长 
% a = 12

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





%% 撒点
% 设置区域尺寸和点的数量
height = bond;
width = bond;
numPoints = n_inside;

% 最小间距
minLeftTopBottomDistance = 0.2;
% minRightDistance = 0.02; 非对称，四周间距一样
minPointDistance = Dis;

% 生成随机点
points = zeros(numPoints, 2);

for i = 1:numPoints  
    while true
        % 生成随机点坐标
        x = rand() * (width - 2 * minLeftTopBottomDistance) + minLeftTopBottomDistance; % 考虑右边的距离要求
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
           bottomDistance >= minLeftTopBottomDistance && rightDistance >= minLeftTopBottomDistance  || ...
           all(distances >= minPointDistance) && topDistance >= minLeftTopBottomDistance && ...
           bottomDistance >= minLeftTopBottomDistance && rightDistance >= minLeftTopBottomDistance
            points(i, :) = [x, y];
            break;
        end
    end
end

% 镜像另一边点的位置
% 翻转另一半 
Point = [points(:,1) points(:,2)];


%% 德劳内
triPoint = [Boundpoint ; Point];
node_cor = triPoint; %% 加入边界段
t = delaunayTriangulation(triPoint);


%% 提取坐标

bond_cor = edges(t);
% 左边输进去
bond_cor(:,3) = node_cor(bond_cor(:,1),1);
bond_cor(:,4) = node_cor(bond_cor(:,1),2);
bond_cor(:,5) = node_cor(bond_cor(:,2),1);
bond_cor(:,6) = node_cor(bond_cor(:,2),2);

end

