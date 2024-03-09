%% 本程序用来分析不同点数网络散热能力
% symlattice

%% 提取文件
%前6列为温度和Z，后4列为热阻，约化热阻，对流换热系数，约化对流换热系数，约化表面积，约化体积，连接总长，平均连接长度
path = 'F:\FEM\GraphAnalysis2\CreateGraph\lattcie\';
info12 = load([path,'12_\12_symlattice.txt']);
info14 = load([path,'14_\14_symlattice.txt']);
info16 = load([path,'16_\16_symlattice.txt']);
info18 = load([path,'18_\18_symlattice.txt']);
info20 = load([path,'20_\20_symlattice.txt']);
info22 = load([path,'20_\20_symlattice.txt']);
info24 = load([path,'20_\20_symlattice.txt']);

%% 平均
% 预存
DataTem = zeros(7,7);
DataSize = zeros(7,6);
DataHeat = zeros(7,6);
DataCorr = zeros(7,4);

%% 循环
i=1;
for i_file = 0:2:12

    info = eval(['info',num2str(i_file+12)]);

DataTem(i,:) = [mean(info(:,2)) max(info(:,2)) min(info(:,2))...
    mean(info(:,2)) max(info(:,2)) min(info(:,2)) mean(info(:,6))];
DataSize(i,:) = [mean(info(:,11)) max(info(:,11)) min(info(:,11))...
    mean(info(:,12)) max(info(:,12)) min(info(:,12)) ];
DataHeat(i,:) = [mean(info(:,8)) max(info(:,8)) min(info(:,8))...
    mean(info(:,10)) max(info(:,10)) min(info(:,10)) ];
DataCorr(i,:) = [corr(info(:,2),info(:,13),'type','Pearson') corr(info(:,2),info(:,14),'type','Pearson')...
    corr(info(:,2),info(:,11),'type','Pearson') corr(info(:,2),info(:,12),'type','Pearson')];

i= i+1;
end


