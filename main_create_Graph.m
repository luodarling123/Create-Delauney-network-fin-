%% 创建德劳内三角晶格
%%%%%%%%%%%%%%
clc
clear 

%% 扭曲晶格基本信息
num = 1; % 数量
n = 20 ; % 边界点数量
bond = 12; % 边界位置
n_inside = (n-2)^2; % 内部点数量，必须为偶数
Dis = bond/sqrt(n_inside)/2;% bond/sqrt(n_inside)-0.05; % 尽可能让点间距宽一些，所以减去0.05
%% 预存数据
DataInform = zeros(num,14); %% 前6列为温度和Z，后4列为热阻，约化热阻，对流换热系数，约化对流换热系数，最后4列为约化表面积和约化体积 连接信息
%% 存储位置
path = 'F:\FEM\GraphAnalysis2\CreateGraph\Graph\20_\';
node_name = 'df_Random_net_xy';
bond_name = 'original_Network';
%% 开始画图
parfor i = 1 : num
    % 创建对称扭曲晶格
    [node_cor,bond_cor] = FunCreateGraph(n,bond,n_inside,Dis); 
    % 数据记录
    Temperature  = CalculateTemperature(bond_cor, node_cor);
    [GlobalBondLength,AverageBondLength]  = Calculatebondlength(bond_cor); %连接信息
    [S,A] = FunCalculateVolAre(bond_cor,node_cor);
    Nor_surface = S/(121.6*121.6*2+121.6*2*3);
    Nor_volume = A/121.6^2;
    h_avg = 20/(Temperature(1,2)*(S/1e6));
    Nor_h = h_avg/(20/(138.05*((121.6*121.6*2+121.6*2*3)/1e6)));
    R = Temperature(1,2)/20;
    Nor_R = R/(138.05/20);
    DataInform(i,:) = [Temperature,R,Nor_R,h_avg,Nor_h,Nor_surface,Nor_volume,GlobalBondLength,AverageBondLength];
    Writefile(node_cor,bond_cor,path,node_name,bond_name,i);
end
%initial_Plot(bond_cor)
writematrix(DataInform,...
    'F:\FEM\GraphAnalysis2\CreateGraph\Graph\20_\20_Graph.txt','Delimiter',' ');

