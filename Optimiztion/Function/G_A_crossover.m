function crossoveredPopulation = G_A_crossover(selectedPopulation, crossoverRate, start_nodeA, start_nodeB)

% selectedPopulation, 继承下来的个体
% crossoverRate, 交叉率
%  start_nodeA, 可变基因起始点
%  start_nodeB, 不可边基因起始点

    [populationSize, point_num, ~] = size(selectedPopulation);

    % 初始化交叉后的种群
    crossoveredPopulation = zeros(size(selectedPopulation));

    % 遍历每对父代个体
    for i = 1:2:populationSize
        % 复制父代
        crossoveredPopulation(i, :, :) = selectedPopulation(i, :, :);
        crossoveredPopulation(i+1, :, :) = selectedPopulation(i+1, :, :);

        % 随机决定是否进行交叉
        if rand() < crossoverRate
            % 随机选择交叉点
            crossoverPoint = randi([start_nodeA, start_nodeB-1]);

            % 交叉操作
            temp = crossoveredPopulation(i, crossoverPoint:end, :);
            crossoveredPopulation(i, crossoverPoint:end, :) = crossoveredPopulation(i+1, crossoverPoint:end, :);
            crossoveredPopulation(i+1, crossoverPoint:end, :) = temp;

            % 确保对称性
              % 第i+1个
              crossoveredPopulation(i+1, start_nodeB:end, :) = crossoveredPopulation(i+1, start_nodeA:start_nodeB-1, :); 
              crossoveredPopulation(i+1, start_nodeB:end, 1) = - crossoveredPopulation(i+1, start_nodeA:start_nodeB-1, 1);  % 保证和x对称
             
              % 第i个
              crossoveredPopulation(i, start_nodeB:end, :) = crossoveredPopulation(i, start_nodeA:start_nodeB-1, :);
              crossoveredPopulation(i, start_nodeB:end, 1) = - crossoveredPopulation(i, start_nodeA:start_nodeB-1, 1);     % 保证和x对称
        end
    end
end