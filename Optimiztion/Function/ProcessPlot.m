function  ProcessPlot(bond_cor, i ,Delete_Edge)
%UNTITLED 此处显示有关此函数的摘要
% 区分删除的边和没删除的边
%   此处显示详细说明
figure;

%% 删除以后的图
x_1 = bond_cor(:,3);
y_1 = bond_cor(:,4);

x_2 = bond_cor(:,5);
y_2 = bond_cor(:,6);

f = [x_1 x_2]';
s = [y_1 y_2]';
xlim([0,12]);
ylim([0,12]);

%% 删除的线
line_delete = Delete_Edge(1:i,:);
x_1d = line_delete(:,3);
y_1d = line_delete(:,4);

x_2d = line_delete(:,5);
y_2d = line_delete(:,6);

f_d = [x_1d x_2d]';
s_d = [y_1d y_2d]';

line(f,s,'color','k',linewidth=2);

hold on 
line(f_d,s_d,'color','r',linewidth=4);

% 设置坐标轴位置
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

axis equal
axis off



end

