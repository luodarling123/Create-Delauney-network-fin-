function Temperature  = CalculateTemperature(bond_cor, node_cor)
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
% 3,5 x ; 4,6 y

%y
maxTop1 = max(bond_cor(:,4));
maxTop2 = max(bond_cor(:,6));
maxTop = max(maxTop1,maxTop2);

%x
maxRight1 = max(bond_cor(:,3));
maxRight2 = max(bond_cor(:,5));
maxRight  = max(maxRight1,maxRight2);

%y
minBottom1 = min(bond_cor(:,4));
minBottom2 = min(bond_cor(:,6));
minBottom  = min(minBottom1,minBottom2);

%x
minLeft1 = min(bond_cor(:,3));
minLeft2 = min(bond_cor(:,5));
minLeft  = min(minLeft1,minLeft2);


L1 = bond_cor(bond_cor(:,3)==minLeft,1);
L2 = bond_cor(bond_cor(:,5)==minLeft,2);
L = unique([L1; L2]);

R1 = bond_cor(bond_cor(:,3)==maxRight,1);
R2 = bond_cor(bond_cor(:,5)==maxRight,2);
R = unique([R1; R2]);

B1 = bond_cor(bond_cor(:,4)==minBottom,1);
B2 = bond_cor(bond_cor(:,6)==minBottom,2);
B = unique([B1; B2]);

T1 = bond_cor(bond_cor(:,4)==maxTop,1);
T2 = bond_cor(bond_cor(:,6)==maxTop,2);
T = unique([T1; T2]);
%% Generate Matrix

% 定义fin底端和顶端
for idx_b = 1:Num_bond
    if bond_cor(idx_b,4)>=bond_cor(idx_b,6) %%y1>=y2 means y1 reprsent tip. colume 2 is colume tip
        temp = bond_cor(idx_b,2);
        bond_cor(idx_b,2) = bond_cor(idx_b,1);
                bond_cor(idx_b,1) = temp;
    end
end

% extract cor
x1 = bond_cor(:,3);
y1 = bond_cor(:,4);

x2 = bond_cor(:,5);
y2 = bond_cor(:,6);

heat_source = zeros(Num_point,1); 


% build Y-g 
% build Y-single fin
bond_length = sqrt((10*x1-10*x2).*(10*x1-10*x2)+(10*y1-10*y2).*(10*y1-10*y2))/1000; %% comsol 中坐标被放大了10倍。键长b units:m

Y_g = zeros(Num_point*2);  % create a zero matrix

for idx_b_l = 1:length(bond_length)

    Y_g(2*idx_b_l-1,2*idx_b_l-1) = Y_0*coth(m*bond_length(idx_b_l,1));
    Y_g(2*idx_b_l-1,2*idx_b_l) = -Y_0*csch(m*bond_length(idx_b_l,1));
    Y_g(2*idx_b_l,2*idx_b_l-1) = Y_0*csch(m*bond_length(idx_b_l,1));
    Y_g(2*idx_b_l,2*idx_b_l) = -Y_0*coth(m*bond_length(idx_b_l,1));
    
end
    


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




