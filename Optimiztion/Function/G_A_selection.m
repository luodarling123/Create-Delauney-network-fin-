function selectedPopulation = G_A_selection(population, fitness)
%G_A_SELECTION 此处显示有关此函数的摘要
% 轮盘赌选择
    [populationSize, ~, ~] = size(population);
    
    % 计算适应度总和
    totalFitness = sum(fitness(:,1));

    % 初始化选择的种群
    selectedPopulation = zeros(size(population));

    % 选择个体
    for i = 1:populationSize
        % 随机选择一个概率值
        rouletteSpin = rand() * totalFitness;
        
        % 根据轮盘赌选择个体
        cumulativeFitness = 0;
        for j = 1:populationSize
            cumulativeFitness = cumulativeFitness + fitness(j);
            if cumulativeFitness >= rouletteSpin
                selectedPopulation(i, :, :) = population(j, :, :);
                break;
            end
        end
    end
end
