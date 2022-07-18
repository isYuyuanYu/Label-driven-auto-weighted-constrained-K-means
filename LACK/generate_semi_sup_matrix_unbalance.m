function [fea_new,gnd_dirty,gnd_clean,A,Q,Index_labels,Index_samples] = generate_semi_sup_matrix_unbalance(fea,gnd,rate,noisy_label_rate,i)
rand('twister',i);%randn('seed',i)
n = size(fea,2);%样本数
nClass = length(unique(gnd));%类别
% m = n/nClass; %每一类的样本个数
% number = ceil(m*rate); %每个类别取出来的个数，算已知标签
for a = 1:nClass
    m(a) = length(find(gnd==a));%每类的样本个数
    number(a) = ceil(rate*m(a));%每类样本取出来的个数，算已知标签
end
fea_new = zeros(size(fea));
gnd_new = zeros(size(gnd));
l = sum(number);%已知标签的样本总数量
A = zeros(n,n-l+nClass);
noisy_sum = ceil(noisy_label_rate*l);Index_first=0;
Index_labels = [];Index_middle = [];
for a = 1:nClass
%     a = order1(i); order = find(gnd==a);
    order = find(gnd==a);
    randIndex = randperm(size(order,1));
    order = order(randIndex,:);
    Index_label = order(1:number(a))';Index_unlabel = order(number(a)+1:m(a))';Index_first=length(Index_unlabel)+Index_first;
    Index_labels = [Index_labels Index_label];Index_middle{a}=Index_unlabel;
    fea_new(:,sum(number(1:a-1))+1:sum(number(1:a-1))+length(Index_label)) = fea(:,Index_label);
    fea_new(:,Index_first+l-length(Index_unlabel)+1:Index_first+l) = fea(:,Index_unlabel);
    gnd_new(sum(number(1:a-1))+1:sum(number(1:a-1))+length(Index_label),:) = gnd(Index_label,:);
    gnd_new(Index_first+l-length(Index_unlabel)+1:Index_first+l,:) = gnd(Index_unlabel,:);
    for aa = sum(number(1:a-1))+1:sum(number(1:a))
        A(aa,a)=1;
    end
end
Index_samples = Index_labels;
for a = 1:nClass
    Index_samples = [Index_samples Index_middle{a}];
end
% Q1 = A';Q = Q1(1:nClass,:);
for aa = 1:n-l
    A(l+aa,nClass+aa)=1;
end
gnd_clean = gnd_new;
rand_perm = randperm(l);
for a =1:noisy_sum-1
    b = rand_perm(a);c = rand_perm(a+1);
    middle = gnd_new(b,:);gnd_new(b,:) = gnd_new(c,:);gnd_new(c,:) = middle;
    clear middle
    middle = A(b,:);A(b,:) = A(c,:);A(c,:) = middle;
    clear middle
end
Q1 = A';Q = Q1(1:nClass,:);
gnd_dirty = gnd_new;