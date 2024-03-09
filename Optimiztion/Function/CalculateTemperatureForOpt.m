function Temperature  = ...
    CalculateTemperatureForOpt(bond_cor, node_cor, minpose, maxpose)

%%% 专门用来进行优化的计算温度函数

%%  Calculate tem

%% Global variable
P_0 = 20; % W 输入功率
delta1 = 2/1000; % m bond thickness
delta2 = 1.6/1000;  % m fin thickness
kappa = 155; % w/mk Themal conductivity
h = 5; % w/m^2k convection conductivity
m = sqrt(2*h*(delta1+delta2)/(kappa*delta1*delta2)); % Charactistic value
Y_0 = sqrt(2*h*kappa*delta1*delta2*(delta1+delta2)); % Charactistic admittance



%% get matrix info
Num_bond = length(bond_cor);
Num_point = length(node_cor);

% 找到模型边长
[~,L,R,B,T] = FoundBoundaryNode(bond_cor, minpose, maxpose);
%% Generate Matrix

% 定义fin底端和顶端
for idx_b = 1:Num_bond
    if bond_cor(idx_b,4)>=bond_cor(idx_b,6) %%y1>=y2 means y1 reprsent tip. colume 2 is colume tip
        temp = bond_cor(idx_b,2);
        bond_cor(idx_b,2) = bond_cor(idx_b,1);
                bond_cor(idx_b,1) = temp;
    end
end


heat_source = zeros(Num_point,1); 

% build Y-g 
% build Y-single fin
bond_length = sqrt((10*bond_cor(:,3)-10*bond_cor(:,5)).*(10*bond_cor(:,3)-10*bond_cor(:,5))+(10*bond_cor(:,4)-10*bond_cor(:,6)).*(10*bond_cor(:,4)-10*bond_cor(:,6)))/1000; %% comsol 中坐标被放大了10倍。键长b units:m


Y_0_coth = Y_0 * coth(m*bond_length);
Y_0_up   = -Y_0 * csch(m*bond_length);

ZeroMatrix = zeros(Num_bond,1);

diag_ele = reshape([Y_0_coth, -Y_0_coth].', [], 1);
diag_upele = reshape([Y_0_up, ZeroMatrix].', [], 1);
diag_upele(end) = []; % 去掉最后一行0
Y_g  = diag(diag_upele,1) + diag(diag_ele) + diag(-diag_upele,-1);




% build adjacent matrix
Ma_adj = zeros(Num_point,2*Num_bond);
% improt tip-node and baes-node
for idex_b_ele = 1:Num_bond
    Ma_adj(bond_cor(idex_b_ele,1),2*idex_b_ele-1)=1; %% base-node
    Ma_adj(bond_cor(idex_b_ele,2),2*idex_b_ele)=1; %% tip-node
end

% build sign-correcting matrix
size_Y_g = size(Y_g); 
S = eye(size_Y_g); 
S(2:2:size_Y_g,:) = -S(2:2:size_Y_g,:); % 修改偶数行的元素

% inject heat flux
for idx_L = 1:length(B)
    heat_source(B(idx_L),1) = P_0/length(B); % inject heat flux in the left side 20W
end

%% calculate temp
paraMatrix = Ma_adj*S*Y_g*Ma_adj';
TemperatureEveryPoint = pinv(paraMatrix)*heat_source; % K

%% output
Temperature = [mean(TemperatureEveryPoint(B)) max(TemperatureEveryPoint(B)) mean(TemperatureEveryPoint(T)) max(TemperatureEveryPoint(T)) mean(TemperatureEveryPoint(:,1))  2*Num_bond/Num_point];
end




