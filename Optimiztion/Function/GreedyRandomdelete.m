function [bond_cor, node_cor, DeleteEdge, ThermalResistenceGradient ] = ...
    GreedyRandomdelete(bond_cor,node_cor, tem,maxboundarynode, minpose,maxpose)
%GREEDYRANDOMDELETE 此处显示有关此函数的摘要
%   此处显示详细说明

%% 计算邻接矩阵

Num_bond = length(bond_cor);
Num_point = length(node_cor);

Connect_Ma = zeros(Num_point,Num_point);
for i_sequence = 1:Num_bond
    Connect_Ma(bond_cor(i_sequence,1),bond_cor(i_sequence,2)) = 1;
    Connect_Ma(bond_cor(i_sequence,2),bond_cor(i_sequence,1)) = 1;
end    

%% 选择要删除的键
% 计算每个点的连接数量
Degreeforeverypoint = sum(Connect_Ma,2);


%% 确定一定不能删除的连接
[bond_bound,bond_internal] = FoundBoundaryEdge(bond_cor, maxboundarynode);
%% 删除过程
% 找到每轮中所有可以删除的连接编号
delete_pos = zeros(length(bond_internal),1);
for i = 1 : length(bond_internal)
    node1 = bond_internal(i,1);
    node2 = bond_internal(i,2);
    if ((node1 > maxboundarynode && node2 > maxboundarynode) || ...
        (node1 < maxboundarynode && node2 > maxboundarynode) || ...
        (node1 > maxboundarynode && node2 < maxboundarynode)) && ...
        (Degreeforeverypoint(node1,1) > 3 && Degreeforeverypoint(node2,1) > 3)
        delete_pos(i,:) = 1;
    end
end

% 找到可以删除的连接编号组成一个新的列表
delete_index = find(delete_pos(:,1)==1);


% 遍历删除每一条连接后热阻上升的程度
ThermalResistenceGradient =  zeros(length(delete_index),2); %% 第一列为热阻上升的梯度，第二列为对应删除连接的序号。
Temp_info_for_delete = zeros(length(delete_index),6);



for j = 1 : length(delete_index) 
    
    Deleteidx = delete_index(j,1);

    Deletebond_cor = bond_internal; % 寄存连接表

    % 计算删除连接的长度
    bond_length = sqrt((10*bond_internal(Deleteidx,3)-10*bond_internal(Deleteidx,5))^2 ...
                  +(10*bond_internal(Deleteidx,4)-10*bond_internal(Deleteidx,6))^2)/1000;
    Deletebond_cor(Deleteidx,:) = []; % 删除连接
    
    
    
    % 计算删除后连接的温升
    % 组合删除后的内部连接表和边界连接表
    bond_test = [Deletebond_cor; bond_bound];
    Temp_info_for_delete(j,:) = CalculateTemperatureForOpt...
        (bond_test, node_cor, minpose, maxpose);
    ThermalResistenceGradient(j,:) = [(Temp_info_for_delete(j,2)-tem(1,2))/...
                                     bond_length Deleteidx];

end

% 找到热阻上升最小的删除连接
Deleteidx = ThermalResistenceGradient...
    (ThermalResistenceGradient(:,1) == min(ThermalResistenceGradient(:,1)),2);

% 删除连接
DeleteEdge = bond_internal(Deleteidx,:);
bond_internal(Deleteidx,:) = [];
% Output
bond_cor = [bond_internal; bond_bound];
%

end

