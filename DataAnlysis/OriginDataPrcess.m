function [Temflatinfo,thermalflatinfo,edgeinfo,Sizeinfo] = OriginDataPrcess(Path)
%ORIGINDATAPRCESS 此处显示有关此函数的摘要
%   此函数专门用来输出给origin画图的数据 约化过后的
%   此处显示详细说明
%GETDATAINFORM 扁平化每一个txt文件
%   此处显示详细说明
datainfo = load(Path);
%% 提取 [全局高温升 约化热阻 约化对流换热系数 约化表面积 约化体积 连接总长 平均链接长度 ]
datainfo = [datainfo(:,2)/138.05 datainfo(:,8) datainfo(:,10) ...
    datainfo(:,11) datainfo(:,12) datainfo(:,13) datainfo(:,14)];

% (,1) 确保哪怕只有一个样本也能正确求均值,注意min 和mean函数的区别
avgflatinfo = mean(datainfo,1);
maxflatinfo = max(datainfo,[],1);
minflatinfo = min(datainfo,[],1);

%% 整理数据
% 温度
Temflatinfo = [avgflatinfo(:,1) maxflatinfo(:,1)-avgflatinfo(:,1) avgflatinfo(:,1)-minflatinfo(:,1)];

% 热阻 对流换热系数
thermalflatinfo = [avgflatinfo(:,2) maxflatinfo(:,2)-avgflatinfo(:,2) avgflatinfo(:,2)-minflatinfo(:,2) ...
    avgflatinfo(:,3) maxflatinfo(:,3)-avgflatinfo(:,3) avgflatinfo(:,3)-minflatinfo(:,3)];

% 连接信息
edgeinfo = [avgflatinfo(:,6) avgflatinfo(:,7)];

% 尺寸信息
Sizeinfo = [avgflatinfo(:,4) maxflatinfo(:,4)-avgflatinfo(:,4) avgflatinfo(:,4)-minflatinfo(:,4) ...
    avgflatinfo(:,5) maxflatinfo(:,5)-avgflatinfo(:,5) avgflatinfo(:,5)-minflatinfo(:,5)];
end

