function [U,Q,H,sum_err] = DACK(X,Q,r,sum_num)%,sum_err
% MCDACK
% Multi-view Clustering via Data-driven Auto-weighted Constrained K-means
%Objective function:
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
for i=1:p
    D(1,i)=1/p;
end
H(:,1)=D;
for i = 1:MaxIter
    for j = 1:p
        QTQ=Q'*Q;
        U{j}=X{j}*(Q*inv(QTQ));
        BB{j}=U{j};
    end
    for N=sum_num+1:n
        for k=1:r
            J(1,k)=0;
            for kk=1:p
                AAA=X{kk};BBB=BB{kk};
                J(1,k)=J(1,k)+D(1,kk)*norm(AAA(:,N)-BBB(:,k),'fro'); %1*c
            end
        end
        Q(N,:)=0;
        Q(N,J==min(J))=1;
    end
    err=0;
    for j=1:p
        DD = norm(X{j}-U{j}*Q','fro');
        err = D(1,j)*DD^2+err;
        D(1,j) = 1/(2*DD);
    end
    H(:,i+1)=normalize(D,'norm',1);
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
