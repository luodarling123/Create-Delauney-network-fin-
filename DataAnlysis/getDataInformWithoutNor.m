function [Temflatinfo,thermalflatinfo,edgeinfo,Sizeinfo] = getDataInformWithoutNor(Path)

%GETDATAINFORM 扁平化每一个txt文件 同时吧约化数值变为绝对值
%   此处显示详细说明
datainfo = load(Path);
%% 提取 [全局高温升 约化热阻 约化对流换热系数 约化表面积 约化体积 连接总长 平均链接长度 ]
datainfo = [datainfo(:,2) datainfo(:,7) datainfo(:,9) ...
    datainfo(:,11)*(121.6*121.6*2+121.6*2*3) datainfo(:,12)*121.6^2*2 datainfo(:,13) datainfo(:,14)];

% (,1) 确保哪怕只有一个样本也能正确求均值,注意min 和mean函数的区别
avgflatinfo = mean(datainfo,1);
maxflatinfo = max(datainfo,[],1);
minflatinfo = min(datainfo,[],1);

%% 整理数据
% 温度
Temflatinfo = [avgflatinfo(:,1) maxflatinfo(:,1) minflatinfo(:,1)];

% 热阻 对流换热系数
thermalflatinfo = [avgflatinfo(:,2) maxflatinfo(:,2) minflatinfo(:,2) ...
    avgflatinfo(:,3) maxflatinfo(:,3) minflatinfo(:,3)];

% 连接信息
edgeinfo = [avgflatinfo(:,6) avgflatinfo(:,7)];

% 尺寸信息
Sizeinfo = [avgflatinfo(:,4) maxflatinfo(:,4) minflatinfo(:,4) ...
    avgflatinfo(:,5) maxflatinfo(:,5) minflatinfo(:,5)];
end




