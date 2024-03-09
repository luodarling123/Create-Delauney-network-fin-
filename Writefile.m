function Writefile(node_cor,bond_cor,path,node_name,bond_name,i)
%WRITEFILE 此处显示有关此函数的摘要
%   此处显示详细说明
%% 保存文件node_cor,bond_cor

nodefile = [path,'nodes\',node_name,num2str(i-1),'.txt'];
writematrix(node_cor,...
    nodefile,'Delimiter','space')
edgefile = [path,'edges\',bond_name,num2str(i-1),'.txt'];
writematrix(bond_cor,...
    edgefile,'Delimiter','space')

end

