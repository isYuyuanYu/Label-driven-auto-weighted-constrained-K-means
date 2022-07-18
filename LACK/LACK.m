function [U,Q,H,sum_err] = LACK(X,Q,r,sum_num)%,sum_err
% rand('twister',1);randn('seed',1);
% MCLACK
% Multi-view Clustering via Label-driven Auto-weighted Constrained K-means
% Objective function:
%           d_{p}||X^p-U^pQ^T||_{F}^{2}
%
MaxIter = 50; 
p=numel(X);
for i=1:p
    m{i}=size(X{i},1);
end
Q=Q';
n=size(X{1},2);
U{p}=[];
C=Q(1:sum_num,:);
for i = 1:MaxIter
    for j = 1:p
        QTQ=Q'*Q;
        U{j}=X{j}*(Q*inv(QTQ));
        BB{j}=U{j};
    end
    F={};
    for j=1:p
        E = zeros(sum_num,r);
        AAA=X{j};BBB=BB{j};
        for N=1:sum_num
            for k=1:r
                J(1,k)=norm(AAA(:,N)-BBB(:,k),'fro');
            end
            E(N,J==min(J))=1;
        end
        F{j}=E;
        clear E
        D(1,j)=sum(sum(F{j}.*C));
    end
    for N=sum_num+1:n
        for k=1:r
            J(1,k)=0;
            for j=1:p
                AAA=X{j};BBB=BB{j};
                J(1,k)=J(1,k)+D(1,j)*norm(AAA(:,N)-BBB(:,k),'fro'); %1*c
            end
        end
        Q(N,:)=0;
        Q(N,J==min(J))=1;
    end
    err=0;
    H(:,i)=normalize(D,'norm',1);
    for j=1:p
        DD = norm(X{j}-U{j}*Q','fro');
        err = D(1,j)*DD^2+err;
    end
    if i>1
        if norm(Q(:)-Q_old(:),'fro')==0
            break;
        end
    end
    Q_old = Q;
%     fprintf('it:%d, err=%f\n',i,err);
    sum_err(i)=err;
end
end