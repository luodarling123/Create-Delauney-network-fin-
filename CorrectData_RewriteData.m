%% 调整data数据
num = 12; %% 点数量初始
% 提取txt文件
for i = 1:7

base_path = 'F:\FEM\GraphAnalysis2\CreateGraph\symGraph\';
sub_path = num2str(num);
old_path = [base_path, sub_path,'_\',num2str(num),'_symGraph.txt'] ;

% 写入一个新的文件
new_path = [base_path, sub_path,'_\',num2str(num),'_symGraph_new.txt'] ;
DataInform = load(old_path);
% [热源平均值，热源最大值，顶端平均，顶端最大，全局平均，Z，热阻，约化热阻，对流换热系数，约化对流换热系数，约化表面积，约化体积，连接总长，平均连接长度]
%% 需要修改
%热阻
DataInform(:,8) = DataInform(:,7)/(157.47/20);
%对流换热系数
DataInform(:,10) = DataInform(:,9)/(20/(138.05*((121.6*121.6*2+121.6*2*3)/1e6)));
%体积
% DataInform(:,12) = DataInform(:,12)/121.6; %%原数据少除一个121.6
writematrix(DataInform,...
    new_path,'Delimiter',' ');

num=num+2

end