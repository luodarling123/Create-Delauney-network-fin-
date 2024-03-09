function [bond_cor] = FunExtractbondcor(node_cor)
%FUNEXTRACTBONDCOR 的老内三角化后快速形成连接表
%   此处显示详细说明
t = delaunayTriangulation(node_cor);
% 坐标
bond_cor = edges(t);
% 左边输进去
bond_cor(:,3) = node_cor(bond_cor(:,1),1);
bond_cor(:,4) = node_cor(bond_cor(:,1),2);
bond_cor(:,5) = node_cor(bond_cor(:,2),1);
bond_cor(:,6) = node_cor(bond_cor(:,2),2);
end

