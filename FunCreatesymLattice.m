function [node_cor,bond_cor] = FunCreatesymLattice(n,bond,n_inside,Dis)
%FUNCREATELATTICE 此处显示有关此函数的摘要
%   此处显示详细说明
%   创建对称扭曲晶格
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


% 检查
%initial_Plot(bond_cor)
%hold on

%% 撒点 


% 平均点间距,间距比点数多1
y_1 = bond/(sqrt(n_inside)+1);
x_1 = bond/(sqrt(n_inside)+1);

% 平均点位置
X = x_1:x_1:(sqrt(n_inside))*x_1/2;
Y = y_1:y_1:bond-y_1;
[x,y] =  meshgrid(X,Y);

% 翻转另一半  
PointX = reshape(x,[],1);
PointY = reshape(y,[],1);


Point = [PointX PointY;12 - PointX PointY ];
%% 加入随机位置
randomVector = rand(length(PointX), 2) * Dis-Dis/2-0.005; 
  % 保证位移能为有可能为负
  % 上下左右移动都为0.1
    %% length(PontX)保证左右随机分布一致
randomVector_another = randomVector;
randomVector_another(:,1) = -randomVector_another(:,1);

randomVector = [randomVector;randomVector_another]; %% 复制生成的随机数

Point = Point+randomVector;


%% 画图
% figure
% scatter(Point(:,1),Point(:,2));
% hold on
triPoint = [Point;Boundpoint];
node_cor = triPoint;
t = delaunayTriangulation(triPoint);
% triplot(t);
% 
% close gcf
%% 提取坐标

bond_cor = edges(t);
% 左边输进去
bond_cor(:,3) = node_cor(bond_cor(:,1),1);
bond_cor(:,4) = node_cor(bond_cor(:,1),2);
bond_cor(:,5) = node_cor(bond_cor(:,2),1);
bond_cor(:,6) = node_cor(bond_cor(:,2),2);

end

