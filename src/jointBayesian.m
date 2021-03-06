% todo: decompose G (not really necessary

% results:              100d_lr     100d_mx    2000d_lr     2000d_mx
% 1. EM init with I:    0.8073      na         0.8910       0.8937
% 2. LDA matrices:      0.8077      0.8097     0.8788       0.8800
% 3. LDA + EM:          0.8073      0.8117     0.8930       0.8933
% however according to the paper it should be around 0.8938~0.8940

clear all;
data_dir = '../../../data/JointBayesian/';
load([data_dir 'WDRef_pca_100.mat']);

% EM
epoch = 10;
thres = 0; % convergence threshold
feature_dim = size(train_x,1);
dat_num = size(train_x,2);
sub_num = max(train_lbl); % number of subjects (assume id number increases consectively
data_mean = mean(train_x,2); % should be zero if already subtracted
x_cell = cell(sub_num,1);
for i=1:sub_num
    x_cell{i} = train_x(:,train_lbl==i);
end

[A,G,S_mu,S_eps] = jointBayesianEM(x_cell,data_mean,epoch,thres,feature_dim,dat_num,sub_num);
Sig_i = [S_mu+S_eps S_mu; S_mu S_mu+S_eps];
Sig_e = [S_mu+S_eps zeros(size(S_mu)); zeros(size(S_mu)) S_mu+S_eps];

% test
% todo: decompose positive definite
test_pairs = [test_intra; test_extra];
test_lbl = [ones(size(test_intra,1),1);zeros(size(test_extra,1),1)];
test_r = zeros(size(test_lbl));
test_data_num = size(test_pairs,1);
for i=1:test_data_num
        test_r(i) = computeR(A,G,test_x(:,test_pairs(i,1)),test_x(:,test_pairs(i,2)));
end
% max threshold (100d: 0.8117
[mx_acc,mx_thres] = maxAcc(test_r,test_lbl);

% logistic regression (100d: 0.8073
[lr_acc,lr_thres] = lrAcc(test_r,test_lbl);

% probabilities too close to zero
% mvnpdf([test_x(:,test_pairs(3000,1));test_x(:,test_pairs(300,2))],zeros(2*dim_feature,1),Sig_i)