%%
clc
clear

%% 提取data
base_path = 'G:\FEM\GraphAnalysis2\CreateGraph\';
symGsub_name = 'symGraph';
Gsub_name = 'Graph';
num = 12;


%% 预存空间
pearson_corr = [];
pearson_corrforTem = zeros(7,4);
%% 计算皮尔森相关系数
for i = 1 : 7
    Path = [base_path, symGsub_name ,'\',num2str(num),'_','\',num2str(num),...
        '_',symGsub_name,'_new.txt'];
    datainfo = load(Path);
    % 最高温度，表面积，体积，总长度，平均长度
    corr_matrix = corr([datainfo(:,2) datainfo(:,11) datainfo(:,12) datainfo(:,13) datainfo(:,14)]);
    pearson_corr = [pearson_corr; corr_matrix ];


    % 最高温度，表面积，体积，总长度，平均长度
    pearson_corrforTem(i,1) = corr(datainfo(:,2), datainfo(:,11));
    pearson_corrforTem(i,2) = corr(datainfo(:,2), datainfo(:,12));
    pearson_corrforTem(i,3) = corr(datainfo(:,2), datainfo(:,13));
    pearson_corrforTem(i,4) = corr(datainfo(:,2), datainfo(:,14));
    
num=num+2;

end





