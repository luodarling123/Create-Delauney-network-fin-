clc

clear
%%
%{
1.温度单位K
2.TRG变化单位为K/m
3.计算约化单位时用的单位为mm
4.预分配内存时创建的矩阵长度多为迭代次数+10
5.Label为平均对流换热系数

%%%%%%% Attention: 不同点数的边边界位置不同
%%%%%%%            此程序只适用于边界上16*4-4=60点网络
%}


%% read info
file_dirname = 'F:\FEM\GraphAnalysis2\Optimiztion\symGraph\16_';
node_subname = '\nodes\';
edge_subname = '\edges\';
n = 1;
network_data = [file_dirname , edge_subname , 'original_Network', num2str(n-1),'.txt'];
xy_data = [file_dirname , node_subname , 'df_Random_net_xy', num2str(n-1),'.txt'];

%寄存最原始的连接表
bond_cor_ori = load(network_data);  

%读取连接表和点坐标
bond_cor=load(network_data);
node_cor=load(xy_data);


%% initial state
% plot
% extract cor
ProcessPlot(bond_cor, 0)

% 初始温度
initial_tem =  CalculateTemperature(bond_cor, node_cor);
% 初始尺寸,% 初始连接长度
[Network_Area_inital, Network_vol_intial, GlobalBondLength] = CalculateSize(bond_cor, node_cor);


 

% 退火算法信息
% PerDelete = 1; %每次迭代删除的连接数 default = 1
iteration = 3; % 总共迭代次数
QforAnnealing = initial_tem(1,2)/GlobalBondLength; %好坏判断标准
AnnealingRatio = 0.96; % 降温效率


AnnealingTemVar = zeros(iteration+10,1); %% 退火降温信息
AnnealingTemVar(1,:) = 1000; %设定出来温度

%% 停止条件：体积分数过小或者温度过低
condtion = [0.4,20];

%% 分配内存
% 预存最大温度
Temp_info = zeros(iteration+1,6);
Temp_info(1,:) = initial_tem; % 把初始热阻存入，后面每一次迭代序号加1

% 预存尺寸变化 第一列为表面积变化，第二列为体积变化
SizeVar = zeros(iteration+10,2);
SizeVar(1,1) = Network_Area_inital;
SizeVar(1,2) = Network_vol_intial;

Delete_bondlen = zeros(iteration,1);
Delete_index = zeros(iteration,1);


%% 开始退火
for i = 1:iteration
%% 判断退火结果
% 提取可以删除的所有链接
[Delete_index, TRG, StatusTem] = AnnealingChose(bond_cor,node_cor, initial_tem);
% 计算概率
PforChose = exp(Temp_info(i,2) - StatusTem)/AnnealingTem;
randomNum = rand;

    % 判断
    if TRG <= QforAnnealing || randomNum <= PforChose %% 删除bond 的条件，TRG小于平均水平或者概率达到。
    % 删除连接
        bond_cor(Delete_index,:) = [];
        Delete_index(i,:) = Delete_index;
    end

% 记录这一次迭代信息
% 记录删除连接后的变化
Temp_info(i+1,:) = CalculateTemperature(bond_cor, node_cor); % 最大温度变化

%% 存网络尺寸
[Area, vol] = CalculateSize(bond_cor, node_cor);
SizeVar(i+1,1) = Area;
SizeVar(i+1,2) = vol;


%% 降温
AnnealingTemVar(i+1,:) = AnnealingTemVar(i,:)*AnnealingRatio;

% 去除连接体积降至要求或温度过低中断循环
if vol <= condtion(1,1) || AnnealingTemVar(i+1,:) <= condtion(1,2)
    break
end

end

%% 画图
%% 画图
ProcessPlot(bond_cor,iteration);

