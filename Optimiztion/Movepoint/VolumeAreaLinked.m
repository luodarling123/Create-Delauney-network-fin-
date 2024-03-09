clc
clear

%% 检查18*18网络体积和表面积的皮尔森相关系数
id = 12;
main_path = 'F:\FEM\GraphAnalysis2\CreateGraph\symGraph\';



pearson_corr = zeros(7,2);
%%
for i = 1:7
subpath = [num2str(id),'_\',num2str(id),'_symGraph_new.txt'];   
path = [main_path,subpath];
info = load(path);
pearson_corr(i,1) = id;
pearson_corr(i,2) = corr(info(:,11), info(:,12));

id = id+2;

end

%% 加入x
x = pearson_corr(:,1)';
y = pearson_corr(:,2)';

bar(x,y);
ylabel('网络面积和网络体积的 Pearson Correlation Coefficient')
xlabel('边界节点数')