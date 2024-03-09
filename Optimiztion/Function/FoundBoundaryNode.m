function [maxboundarynode,L,R,B,T] = FoundBoundaryNode(bond_cor,minpose,maxpose)
%FOUNDBOUNDARYNONDE 此处显示有关此函数的摘要
%   此处显示详细说明
%   找到最大节点序号
% 屏蔽边界点
L1 = bond_cor(bond_cor(:,3)==minpose,1);
L2 = bond_cor(bond_cor(:,5)==minpose,2);
L = unique([L1; L2]);

R1 = bond_cor(bond_cor(:,3)==maxpose,1);
R2 = bond_cor(bond_cor(:,5)==maxpose,2);
R = unique([R1; R2]);

B1 = bond_cor(bond_cor(:,4)==minpose,1);
B2 = bond_cor(bond_cor(:,6)==minpose,2);
B = unique([B1; B2]);

T1 = bond_cor(bond_cor(:,4)==maxpose,1);
T2 = bond_cor(bond_cor(:,6)==maxpose,2);
T = unique([T1; T2]);

boundarynode = [L;R;B;T];
maxboundarynode = max(boundarynode);
end

