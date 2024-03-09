clc
clear


%% 用这个文件寻找最值

pos = 'F:\FEM\GraphAnalysis2\CreateGraph\symGraph\16_\16_symGraph_new.txt';
info = load(pos);


%% 找到最低温度
min= min(info(:,2));
x = find(info(:,2)==min);