function mutatedPopulation = G_A_mutation(crossoveredPopulation, mutationRate, GA_range, start_nodeA,start_nodeB)
% crossoveredPopulation, 变异后的种群
% mutationRate, 变异几率
%  GA_range , 位移空间划分数量，基因范围
%  start_nodeA, 可变基因起始点
%  start_nodeB, 不可边基因起始点

% mute_start,mute_end 是变异发生的区间，此程序适用于对称图
    [populationSize, point_num, ~] = size(crossoveredPopulation); % 种群数量，点总数，坐标维度

    % 初始化变异后的种群
    mutatedPopulation = zeros(size(crossoveredPopulation));

    % 遍历每个个体
    for i = 1:populationSize
        % 复制个体
        mutatedPopulation(i, :, :) = crossoveredPopulation(i, :, :);

        % 随机决定是否进行变异
        if rand() < mutationRate
            % 随机选择变异的基因位置
            mutationPoint = randi([start_nodeA,start_nodeB-1]);

            % 随机生成变异值
            mutationValue = randi([-GA_range/2, GA_range/2], 1, 2);

            % 进行变异
            mutatedPopulation(i, mutationPoint, 1) = mutatedPopulation(i, mutationPoint, 1) + mutationValue(1,1);
            mutatedPopulation(i, mutationPoint, 2) = mutatedPopulation(i, mutationPoint, 2) + mutationValue(1,2);
            
            mutatedPopulation(i, point_num-mutationPoint+start_nodeA, 1) = -mutatedPopulation(i, mutationPoint, 1); % 保持关于y轴对称
        end
    end
end













