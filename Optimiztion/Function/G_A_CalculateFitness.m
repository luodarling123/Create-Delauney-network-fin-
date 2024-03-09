function [fitness_normalize, fitness_absolute] = G_A_CalculateFitness(node_cor_opt ,population, GA_step,  minpose, maxpose)
%FUNCALCULATEHAVG 计算以体积为约化的对流换热系数
%   此处显示详细说明
%   Attention node_cor 的排列必须为 [边界上的点 ; 左边的点 ; 右边的点]
%   Attention nodeCor  的维度为 num 种群数量 * move_num 需要移动点数 * cor_di 坐标维度（默认2）
addpath('F:\FEM\GraphAnalysis2\Optimiztion\Function')
%% 给每个位移都加上坐标
[num , move_num, cor_di ] = size(population);

population = population*GA_step; % 转化到真实空间运动

base_coordinates_expanded = repmat(node_cor_opt, [1, 1, num]); %扩张维度

base_coordinates_expanded = permute(base_coordinates_expanded, [3, 1, 2]);

node_cor_all = population + base_coordinates_expanded;


fitness_all_1 = zeros(size(node_cor_all, 1), 1);
fitness_all_2 = zeros(size(node_cor_all, 1), 1);


%% 遍历每个基因，计算适应度
for i = 1:size(node_cor_all, 1)
    % 提取当前基因
    current_node_cor = squeeze(node_cor_all(i, :, :));  % 将矩阵中的单一维度移除

    % 步骤1: 使用当前基因计算 bond_cor
    current_bond_cor = FunExtractbondcor(current_node_cor);
    

    % 步骤2: 使用当前基因和 bond_cor 计算适应度 
    Tem = CalculateTemperatureForOpt(current_bond_cor, current_node_cor, minpose, maxpose);
    [~,A] = FunCalculateVolAre(current_bond_cor, current_node_cor);
    [V] = G_A_CalculateVbybond(current_bond_cor, current_node_cor);
    Havg_volume_1 = 20/(Tem(1,2)*(V*2*1e-9));
    % Havg_surface = 20/(Tem(1,2)*(S/1e6));
    Havg_volume_2 = 20/(Tem(1,2)*(A*2*1e-9));
    
    % 存储适应度
    fitness_all_1(i) = Havg_volume_1;
    fitness_all_2(i) = Havg_volume_2;
end

%% 归一化适应度
fitness_absolute = [fitness_all_1,fitness_all_2];
fitness_all_1 = mapminmax(fitness_all_1',0,1);
fitness_all_2 = mapminmax(fitness_all_2',0,1);
fitness_normalize = [fitness_all_1', fitness_all_2'];




end

