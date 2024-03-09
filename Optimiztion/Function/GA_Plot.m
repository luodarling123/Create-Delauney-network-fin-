function GA_Plot(bond_cor)
%PROCESSPLOT 此处显示有关此函数的摘要
% plot network
%   此处显示详细说明
figure;
x_1 = bond_cor(:,3);
y_1 = bond_cor(:,4);

x_2 = bond_cor(:,5);
y_2 = bond_cor(:,6);

f = [x_1 x_2]';
s = [y_1 y_2]';
xlim([0,12]);
ylim([0,12]);


line(f,s,'color','k',linewidth=1);
set(gca,'Color','w')
set(gcf,'Color','w')

% 设置坐标轴位置
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

axis equal
axis off
% title('initial Plot');



end

