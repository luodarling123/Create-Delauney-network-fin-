function [node_cor] = G_A_AddDisplacement(node_cor_opt, nodeCor,random_vectorL)
%UNTITLED 产生的随机位移加到每一个点上
%   遗传算法加坐标专用
%   bondpos 边界上最后一个点的序号
%   node_cor 坐标表
%   random_vectorL 随机位移，一般为左边

%   Attention node_cor 的排列必须为 [边界上的点 ; 左边的点 ; 右边的点]
%   Attention nodeCor  的维度为 num 种群数量 * move_num 需要移动点数/2 * cor_di 坐标维度（默认2）



%% 分离边界上的点和中心的点
node_inter = node_cor(bondpos+1:end,:);

%% 调整位移表
random_vectorR = [-random_vectorL(:,1) random_vectorL(:,2)];
random_displacement = [ random_vectorL ; random_vectorR ];

%% 加和坐标
node_cor = [ node_cor(1:bondpos,:) ; node_inter + random_displacement ];
end

