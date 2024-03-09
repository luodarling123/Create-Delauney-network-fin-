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
%%%%%%%            
%}




%% Initial info


file_dirname = 'F:\FEM\GraphAnalysis2\Optimiztion\symGraph\22_';
node_subname = '\nodes\';
edge_subname = '\edges\';
n = 41; %% 第n个，文件名为n-1
network_data = [file_dirname , edge_subname , 'original_Network', num2str(n-1),'.txt'];
xy_data = [file_dirname , node_subname , 'df_Random_net_xy', num2str(n-1),'.txt'];

bond_cor_ori=load(network_data);
bond_cor=load(network_data);
node_cor=load(xy_data);
%% 调用非本文件夹函数
addpath(genpath('F:\FEM\GraphAnalysis2\Optimiztion\Function'));

%匹配初始连接表顺序，方便可视化处理
minpose = 0;
maxpose = 12;
[maxboundarynode,L,R,B,T] = FoundBoundaryNode(bond_cor,minpose,maxpose);   %确定边界点，内部点
[bond_bound_ori,bond_internal_ori] = ...
    FoundBoundaryEdge(bond_cor_ori, maxboundarynode);
bond_cor_ori = [bond_internal_ori;bond_bound_ori];



% 网络信息初始 
initial_tem =  CalculateTemperatureForOpt(bond_cor, node_cor, minpose, maxpose);
[S,A] = FunCalculateVolAre(bond_cor,node_cor);
Nor_surface_i = S/(121.6*121.6*2+121.6*2*3);
Nor_volume_i = A/121.6^2;
h_avg_i = 20/(initial_tem(1,2)*(S/1e6));
Nor_h_i = h_avg_i/(20/(131.57*((121.6*121.6*2+121.6*2*3)/1e6)));


% 迭代信息
PerDelete = 1; %每次迭代删除的连接数
iteration = 3 ; % 总共迭代次数


%% initial state
% plot initial
initial_Plot(bond_cor_ori);



%%
% 预存最大温度,网络大小，对流换热系数
Temp_info = zeros(iteration,6);
Temp_info(1,:) = initial_tem;

Size_info = zeros(iteration,2);
Size_info(1,:) = [Nor_surface_i, Nor_volume_i]; 

h_info = zeros(iteration,2);
h_info(1,:) = [h_avg_i ,Nor_h_i];


%Delete_bondlen = zeros(iteration,1);  
Delete_Edge = zeros(iteration,6);


I = 0; %可视化循环进程
for i = 1:iteration


%% 贪心算法去除连接
tem = Temp_info(i,:); % 当前热阻
[bond_cor, node_cor, DeleteEdge, ThermalResistenceGradient ] = ...
    GreedyRandomdelete(bond_cor, node_cor, tem, maxboundarynode, minpose,maxpose);

%% Record
Delete_Edge(i,:) = DeleteEdge;
Temp_info(i+1,:) = CalculateTemperatureForOpt(bond_cor, node_cor, minpose, maxpose);
[Network_Area, Network_vol] = FunCalculateVolAre(bond_cor,node_cor);
Size_info(i+1,1)  = Network_Area/(121.6*121.6*2+121.6*2*3) ;
Size_info(i+1,2)  = Network_vol/121.6^2;
h_avg_Porcess = 20/(Temp_info(i+1,2)*(Network_Area/1e6));
h_info(i+1,:) = [h_avg_Porcess, h_avg_Porcess/(20/(138.05*((121.6*121.6*2+121.6*2*3)/1e6))) ];

I = I + 1;

%% 输出进度
disp(I)
disp(Temp_info(i+1,2))

%% 终止条件
    if Temp_info(i+1,2) >= 138.05 
        break
    end



end




% plot last
ProcessPlot(bond_cor, i, Delete_Edge);
writematrix(bond_cor,'GreedyNetworkDeletebondcor_22_edge.txt');
writematrix(Size_info,'GreedyNetworkDeletebondcor_22_Size.txt');
writematrix(h_info,'GreedyNetworkDeletebondcor_22_havg.txt');
writematrix(Temp_info,'GreedyNetworkDeletebondcor_22_Temp.txt');
