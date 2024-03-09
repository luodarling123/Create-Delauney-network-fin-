function population = G_A_initializePopulation(populationSize, GA_range, total_points,start_nodeA,start_nodeB)
%  populationSize, 种群数量
%  GA_range, 位移空间划分数量，基因范围
%  total_points, 总点数
%  start_nodeA, 可变基因起始点
%  start_nodeB, 不可边基因起始点

% 初始化种群，每个染色体是一个 total_points 行2列的矩阵

    % 设置每个基因的范围
    geneRange = [-GA_range/2, GA_range/2];

    % 初始化种群
    population = zeros(populationSize, total_points, 2);

    % 保留前 68 行的点，它们的基因都是 (0,0)
    population(:, 1:start_nodeA-1, :) = zeros(populationSize, start_nodeA-1, 2);

    % 对第 69 行到第 196 行的点，按照之前的方式添加随机位移
    population(:, start_nodeA :start_nodeB-1, :) = randi(geneRange, [populationSize, start_nodeB-start_nodeA, 2]);

    % 对第 197 行到第 324 行的点，位移与第 69 行到第 196 行的点关于 y 轴对称
    symmetrical_moves = population(:, start_nodeA:start_nodeB-1, :);
    symmetrical_moves(:, :, 1) = -symmetrical_moves(:, :, 1);
    population(:, start_nodeB:total_points, :) = symmetrical_moves;
end