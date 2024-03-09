%%
clc
clear

%% 提取data
base_path = 'F:\FEM\GraphAnalysis2\CreateGraph\';
symLsub_name = 'symLattice';
Lsub_name = 'Lattice';
symGsub_name = 'symGraph';
Gsub_name = 'Graph';
num = 12;


%% 预存空间
TemValue =zeros(7,3);
TherValue =zeros(7,6);
EdgeValue =zeros(7,2);
SizeValue =zeros(7,6);
%% 计算数据
for i = 1 : 7
Path = [base_path,symGsub_name ,'\',num2str(num),'_','\',num2str(num),...
    '_',symGsub_name,'_new.txt'];
% [Temflatinfo,thermalflatinfo,edgeinfo,Sizeinfo] = getDataInform(Path)
[Temflatinfo,thermalflatinfo,edgeinfo,Sizeinfo] = getDataInformWithoutNor(Path);
% 求普通平均
TemValue(i,:) = Temflatinfo;
EdgeValue(i,:) = edgeinfo;
% 计算正负差值
TherValue(i,:) = [ thermalflatinfo(:,1) thermalflatinfo(:,2)-thermalflatinfo(:,1) thermalflatinfo(:,2)-thermalflatinfo(:,3)...
    thermalflatinfo(:,4) thermalflatinfo(:,5)-thermalflatinfo(:,4) thermalflatinfo(:,4)-thermalflatinfo(:,6) ];


SizeValue(i,:) = [ Sizeinfo(:,1) Sizeinfo(:,2)-Sizeinfo(:,1) Sizeinfo(:,2)-Sizeinfo(:,3)...
    Sizeinfo(:,4) Sizeinfo(:,5)-Sizeinfo(:,4) Sizeinfo(:,4)-Sizeinfo(:,6) ];


num=num+2;

end



