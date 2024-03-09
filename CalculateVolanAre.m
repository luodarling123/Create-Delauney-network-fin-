file_dirname = 'F:\FEM\GCN\12p175_5000_0.02';
node_subname = '\nodes\';
edge_subname = '\edges\';
n = 3196;
network_data = [file_dirname , edge_subname , 'original_Network', num2str(n-1),'.txt'];
xy_data = [file_dirname , node_subname , 'df_Random_net_xy', num2str(n-1),'.txt'];

bond_cor=load(network_data);
node_cor=load(xy_data);

[Br, Bc] = size(bond_cor); %% 行：连接数
[Nr, Nc] = size(node_cor); %% 行：节点数

d = 0.16; %% 矩形宽度
% 创建连接矩形和节点圆形的多边形对象
polygons = cell(Br+Nr, 1);

% 创建连接矩形的多边形对象
 for i = 1:Br
    start_node = bond_cor(i, 1);
    end_node = bond_cor(i, 2);
    x1 = bond_cor(i, 3);
    y1 = bond_cor(i, 4);
    x2 = bond_cor(i, 5);
    y2 = bond_cor(i, 6);
    thetai = atan2(y2 - y1, x2 - x1);
    % 创建连接矩形的多边形对象
    rect_x = [x1+ d/2 * -sin(thetai), x1 - d/2 * -sin(thetai), x2- d/2 * -sin(thetai), x2+d/2 * -sin(thetai)];
    rect_y = [y1+ d/2 * cos(thetai), y1 - d/2 * cos(thetai), y2- d/2 * cos(thetai), y2+d/2 * cos(thetai)];
    rect = polyshape(rect_x,rect_y);
    polygons{i} = rect;
 end

% 创建节点圆形的多边形对象

for i = 1:Nr
    x = node_cor(i, 1);
    y = node_cor(i, 2);
    
    % 创建节点圆形的多边形对象
    circle = polyshape(x + d/2 * cosd(0:5:360), y + d/2 * sind(0:5:360));
    polygons{Br + i} = circle;
end

% 逐个进行布尔运算并合并多边形对象
combined_polygon = polygons{1};
for i = 2:numel(polygons)
    combined_polygon = union(combined_polygon, polygons{i});
end

% 计算周长和面积
P = perimeter(combined_polygon);
A = area(combined_polygon);

% 显示多边形
figure;
plot(combined_polygon);
%title('Combined Polygon');
axis tight
axis equal
axis off



eps_file = 'combined_polygon.eps';
exportgraphics(gcf, eps_file, 'ContentType', 'vector');
