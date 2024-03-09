clc
clear


%% 网络信息
n = 18; %% 网络尺寸
m = 2607;%% 网络编号
path = ['F:\FEM\GraphAnalysis2\Optimiztion\symGraph\',num2str(n),'_\'];
nodefile = [path,'nodes\df_Random_net_xy',num2str(m),'.txt'];
edgefileori = [path,'edges\original_Network',num2str(m),'.txt'];
edgefile = [path,'GreedyNetworkDeletebondcor_',num2str(n),'_edge.txt'];
Size_info = [path,'GreedyNetworkDeletebondcor_',num2str(n),'_Size.txt'];
h_info = [path,'GreedyNetworkDeletebondcor_',num2str(n),'_havg.txt'];
T_info = [path,'GreedyNetworkDeletebondcor_',num2str(n),'_Temp.txt'];
node_cor = load(nodefile);
bond_cor = load(edgefile);
bond_ori = load(edgefileori);


%% 画图
% 原始
[Sori,Aori] = FunCalculateVolArePaint(bond_ori,node_cor);

% 贪心算法
[S,A] = FunCalculateVolArePaint(bond_cor,node_cor);

%% 数据画图
Size = load(Size_info);
h_ = load(h_info);
Temp = load(T_info);

% 尺寸
% 提取x、y1和y2

 % 除去带有0的部分
nonZeroIndex_y1 = find(Size(:,1) ~= 0);
nonZeroIndex_y2 = find(Size(:,2) ~= 0);


% 提取非零元素的行数、y1和y2
x = 1:numel(nonZeroIndex_y1);
y1 = Size(nonZeroIndex_y1,1);
y2 = Size(nonZeroIndex_y2,2);

% 对流换热系数
y_h1 = h_(1:length(x),1);
y_h2 = h_(1:length(x),2);
maxh = max(y_h2);
% debug
y_h2(1,1) = y_h2(2,1);

% 温度
yT = Temp(1:length(x),2)/138.05; %% 约化 


%% 创建散点图1 温度+尺寸
scatter(x, y1, 'o', 'filled', 'DisplayName', '表面积');
hold on;
scatter(x, y2, 'x', 'DisplayName', '体积');
hold off;

% 添加图例
lgdST = legend;
lgdST.FontSize = 20;

% 添加轴标签和标题
xlabel('迭代次数');
axis tight

title('贪心算法优化尺寸变化');

hold on
% 温度变化图
sT=scatter(x, yT, 'o', 'filled', 'DisplayName', '约化最大温升');
sT.MarkerFaceColor = [0 0.54 0.54];

%% 创建散点图2 对流换热系数

figure;
Nors = scatter(x, y_h2, '^',  'DisplayName', '约化对流换热系数');
Nors.MarkerEdgeColor = 'r';

% hold on
% yyaxis right
% scatter(x, y_h1, '^', 'filled','DisplayName', '对流换热系数');
% yylabel('W/(m^2\cdotK)');



lgdH = legend;
lgdH.FontSize = 20;
lgdH.Location = "southeast";


% 添加轴标签和标题
xlabel('迭代次数');
axis tight

title('贪心算法优化对流换热系数','FontSize', 16);








