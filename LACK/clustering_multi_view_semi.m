function[Cluster_AC_NMI_Pur Cluster_ARI_F_PRE_REC Time] = clustering_multi_view_semi(fea,Method,gnd,Maxiter,rate)
nClass = length(unique(gnd));%标签数
d = numel(fea);%视角数
n=size(fea{1},2);%样本数
for a = 1:nClass
    m(a) = length(find(gnd==a));%每类的样本个数
    number(a) = ceil(rate*m(a));%每类样本取出来的个数，算已知标签
end
sum_num = sum(number);%已知标签样本总数
noisy_label_rate=0;
Time=0;
z=1;
H=rand(d,1);
switch Method
    case {'MLCK','DACK','LACK'} 
        for a = 1:d
            [X{a},~,gnd_clean,~,Q,~,~] = generate_semi_sup_matrix_unbalance(fea{a},gnd,rate,noisy_label_rate,z);
        end
    case {'NMKC'}
        X = fea;gnd_clean=gnd;Q=zeros_ones(nClass,n,1);
otherwise
end
fprintf('Method=%s, rate=%f',Method,rate);
for i = 1:Maxiter
    switch Method
        case 'MLCK'
            t1=clock;[~,V] = MLCK(X,Q,nClass,sum_num);t2=clock;
            gnd1 = gnd_clean(sum_num+1:end,:);
            feature = V(sum_num+1:end,:)';
            [ac,nmi,pur,ari,f,pre,rec] = evalResults_binary(feature,gnd1');
        case 'NMKC'
            t1=clock;[~,V] = NMKC(X,nClass,i);t2=clock;
            feature = V';gnd1 = gnd_clean;
            [ac,nmi,pur,ari,f,pre,rec] = evalResults_multiview(feature,gnd1');
        case 'DACK'
            t1=clock;[~,V] = DACK(X,Q,nClass,sum_num);t2=clock;
            gnd1 = gnd_clean(sum_num+1:end,:);
            feature = V(sum_num+1:end,:)';
            [ac,nmi,pur,ari,f,pre,rec] = evalResults_binary(feature,gnd1');
        case 'LACK'
            t1=clock;[~,fe] = LACK(X,Q,nClass,sum_num);t2=clock;
            gnd1 = gnd_clean(sum_num+1:end,:);feature = fe(sum_num+1:end,:)';
            [ac,nmi,pur,ari,f,pre,rec] = evalResults_binary(feature,gnd1');
      
        otherwise
            fprintf('Error')
    end
    AC_sum(i)=ac;MIhat_sum(i)=nmi;Pur_sum(i)=pur;Ari_sum(i)=ari;F_sum(i)=f;Pre_sum(i)=pre;Rec_sum(i)=rec;
    Time=Time+etime(t2,t1);
end
Time = Time/Maxiter;
AC = sum(AC_sum)/i;AC_s = std(AC_sum)*100;AC = AC*100;
MIhat = sum(MIhat_sum)/i;MIhat_s = std(MIhat_sum)*100;MIhat = MIhat*100;
PUR = sum(Pur_sum)/i;PUR_s = std(Pur_sum)*100;PUR = PUR*100;
ARI = sum(Ari_sum)/i;ARI_s = std(Ari_sum)*100;ARI = ARI*100;
F = sum(F_sum)/i;F_s = std(F_sum)*100;F = F*100;
PRE = sum(Pre_sum)/i;PRE_s = std(Pre_sum)*100;PRE = PRE*100;
REC = sum(Rec_sum)/i;REC_s = std(Rec_sum)*100;REC = REC*100;
Cluster_AC_NMI_Pur = [AC AC_s MIhat MIhat_s PUR PUR_s];
Cluster_ARI_F_PRE_REC = [ARI ARI_s F F_s PRE PRE_s REC REC_s];
fprintf('\nACC=%4.2f, NMI=%4.2f, PUR=%4.2f, ARI=%4.2f, \nF=%4.2f, PRE=%4.2f, REC=%4.2f, Time=%4.2f\n',AC,MIhat,PUR,ARI,F,PRE,REC,Time)
end
