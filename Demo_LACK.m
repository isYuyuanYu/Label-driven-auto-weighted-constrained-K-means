%Demo for LACK
%Yu Y, Zhou G, Huang H, et al. Multi-view Data Classification with a Label-driven Auto-weighted Strategy[J]. arXiv preprint arXiv:2201.00714, 2022.
%
% GDUT, Yuyuan Yu, 2022/07/13

clear
clc
%% Loading data
load('.\Caltech101-20_6_2386_alllei.mat')
% load('Caltech101-7_6_1474_alllei.mat')
X = data'; gt = label'; d = numel(X);
for i =1:d X{i} = normalize(X{i},1); end

%% Experiment settings
Label_ratio = 0.1;% the label ratio $\tau$ (0~1).
Maxiter = 1;% number of experiment.

%% Classification
disp('------');
[~,~,~] = clustering_multi_view_semi(X,'NMKC',gt,Maxiter,Label_ratio);
disp('------');
[~,~,~] = clustering_multi_view_semi(X,'MLCK',gt,Maxiter,Label_ratio);
disp('------');
[~,~,~] = clustering_multi_view_semi(X,'DACK',gt,Maxiter,Label_ratio);
disp('------');
[~,~,~] = clustering_multi_view_semi(X,'LACK',gt,Maxiter,Label_ratio);
