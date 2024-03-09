function [node_cor_complete,bond_cor_plot ] = G_A_Postprocess(idx,population,node_cor_opt,GA_step)
%G_A_POSTPROCESS 此处显示有关此函数的摘要
% 本函数用来画图，对遗传算法生成的网络进行可视化
% idx 种群序号
% population 种群  
% node_cor_opt 最初网络坐标
% GA_step 基因切分步长

[num , move_num, cor_di ] = size(population);

% 坐标处理
Network_nodecor = population(idx,:,:);
Network_nodecor = Network_nodecor*GA_step; % 转化到真实空间运动
Network_nodecor = squeeze(Network_nodecor); %拉伸维度
node_cor_complete = Network_nodecor + node_cor_opt;

% 连接生成
bond_cor_plot = FunExtractbondcor(node_cor_complete);

% 画图
GA_Plot(bond_cor_plot);
end

