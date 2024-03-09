function [bond_bound,bond_internal] = FoundBoundaryEdge(bond_cor, maxboundarynode)
%FOUNDBOUNDARY 此处显示有关此函数的摘要
%   此处显示详细说明


%% 找到边界上连接的序号
bond_bond_inedx = zeros(length(bond_cor),1);
for i = 1 : length(bond_cor)
    node1 = bond_cor(i,1);
    node2 = bond_cor(i,2);
    if node1 <= maxboundarynode && node2 <= maxboundarynode
        bond_bond_inedx(i,1) = 1;
    end


%% 形成新矩阵
bond_internal = bond_cor(~bond_bond_inedx(:,1)==1,:);
bond_bound = bond_cor(bond_bond_inedx(:,1)==1,:);
end


end


