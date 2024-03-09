%% 增加连接信息
num = 12; %%点数量


%% 大循环
for i = 1:7
%% 预存连接信息
lengthdata = zeros(5000,2);

% 数据位置
base_path = 'G:\FEM\GraphAnalysis2\CreateGraph\symGraph\';
sub_path = num2str(num);
edge_path = [base_path, sub_path,'_\edges\'];


%% 循环
for n = 1:5000
file_path = [edge_path,'\','original_Network',num2str(n-1),'.txt'];
% 提取数据
bond_cor = load(file_path);
[GlobalBondLength,AverageBondLength]  = Calculatebondlength(bond_cor); %连接信息
lengthdata(n,:) = [GlobalBondLength,AverageBondLength];

end

% 载入datainformation
old_path = [base_path, sub_path,'_\',num2str(num),'_symGraph.txt'] ;
new_path = [base_path, sub_path,'_\',num2str(num),'_symGraph_new.txt'] ;
DataInform = load(old_path);
DataInform = [DataInform lengthdata];
writematrix(DataInform,...
    new_path,'Delimiter',' ');

num = num+2;
end



