function [population] = G_Acheck(population,maxpose,minpose, node_cor_opt, start_nodeA,start_nodeB, GA_step,bond)
%G_ACHECK 此处显示有关此函数的摘要
%   此函数保证点的位置不超过网络位置
% population,maxpose, 
% node_cor_opt, 
% populationSize, 
% GA_range, 
% total_points,
% start_nodeA,
% start_nodeB,
% GA_step
% n 边界点个数

%% 将生成的population加到初始结构上去
[num , move_num, cor_di ] = size(population);

population_check = population*GA_step; % 转化到真实空间运动

base_coordinates_expanded = repmat(node_cor_opt, [1, 1, num]); %扩张维度

base_coordinates_expanded = permute(base_coordinates_expanded, [3, 1, 2]);

node_cor_all = population_check + base_coordinates_expanded;


%% 因为点坐标堆成，只需要提取左半部分的点坐标判断

node_cor_check = node_cor_all(:,start_nodeA :start_nodeB-1,:);
%% 提取所有超出边界的点以及他们和边界的距离存在一个列表中

% 从 node_cor_check 中找打x小于0或x>bond或y<0或y>bond的点填到 OutrangePoint 前三行中
ifind1 = find(node_cor_check > maxpose(1));
[x,y,z] = ind2sub(size(node_cor_check), ifind1);

ifind2 = find(node_cor_check < minpose(1));
[x1,y1,z1] = ind2sub(size(node_cor_check), ifind2);

OutrangePoint = zeros(length(x)+length(x1),11);

OutrangePoint(:, 1) = [x;x1];
OutrangePoint(:, 2) = [y;y1];
OutrangePoint(:, 3) = [z;z1];


% [种群位置,(a,b,c) 
% x , y ,
% x与左边界的距离，y与下边界的距离，
% y与上边界的距离，种群x的正方向变化量，种群中y的正方向变化量，种群中y的负方向变化量]


% 计算 OutrangePoint第4，5列
for ip = 1 : size(OutrangePoint , 1)

    OutrangePoint(ip,4) = node_cor_check(OutrangePoint(ip,1), OutrangePoint(ip, 2), 1);
    OutrangePoint(ip,5) = node_cor_check(OutrangePoint(ip,1), OutrangePoint(ip, 2), 2);
end


OutrangePoint(:,6) = 0 - OutrangePoint(:,4);
OutrangePoint(:,7) = 0 - OutrangePoint(:,5);
OutrangePoint(:,8) = OutrangePoint(:,5) - bond;

% 计算 OutrangePoint第7-9列 
% x+
OutrangePoint(:, 9) = max(0, OutrangePoint(:, 6));
% y+
OutrangePoint(:, 10) = max(0, OutrangePoint(:, 7));
% y-
OutrangePoint(:, 11) = max(0, OutrangePoint(:, 8));

OutrangePoint(:,9)  = ceil(OutrangePoint(:,9)/GA_step);
OutrangePoint(:,10)  = ceil(OutrangePoint(:,10)/GA_step);
OutrangePoint(:,11)  = ceil(OutrangePoint(:,11)/GA_step);


NonzeroPos = OutrangePoint(:,9:11)~=0;

randomInteger = randi([1, 10]);

OutrangePoint(:,9:11) = OutrangePoint(:,9:11) + randomInteger*NonzeroPos;

%% 将这些种群变化加到Population上，注意对称
% 确定
for i = 1: size(OutrangePoint , 1)
    %x
    population(OutrangePoint(i, 1), OutrangePoint(i, 2)+start_nodeA-1, 1) = ...
        population(OutrangePoint(i, 1),OutrangePoint(i, 2)+start_nodeA-1,1) + OutrangePoint(i, 9);
    %y+
    population(OutrangePoint(i, 1),OutrangePoint(i, 2)+start_nodeA-1,2) = ...
        population(OutrangePoint(i, 1),OutrangePoint(i, 2)+start_nodeA-1,2) + OutrangePoint(i, 10);
    %y-
    population(OutrangePoint(i, 1),OutrangePoint(i, 2)+start_nodeA-1,2) = ...
        population(OutrangePoint(i, 1),OutrangePoint(i, 2)+start_nodeA-1,2) - OutrangePoint(i, 11);
   
end


%%对称x
population(:, start_nodeB:end, 1) = - population(:, start_nodeA:start_nodeB-1, 1);
population(:, start_nodeB:end, 2) =   population(:, start_nodeA:start_nodeB-1, 2);

end

