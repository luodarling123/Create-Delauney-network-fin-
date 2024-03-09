function [V]  = G_A_CalculateVbybond(bond_cor, node_cor)
%% 计算约化面积和约化体积以及连接总长度
% 面积体积： %
% 总长度： mm

x1 = bond_cor(:,3);
y1 = bond_cor(:,4);

x2 = bond_cor(:,5);
y2 = bond_cor(:,6);


bond_length = sqrt((10*x1-10*x2).*(10*x1-10*x2)+(10*y1-10*y2).*(10*y1-10*y2));
V = pi*0.8^2*size(node_cor,1) + sum(bond_length-1.6)*1.6;

% comsol 中坐标被放大了10倍。键长b units:mm





end