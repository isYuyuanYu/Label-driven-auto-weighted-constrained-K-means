function [U,Q,H,sum_err] = MLCK(X,Q,r,sum_num)%sum_err
% Multi-view Clustering via Constrained K-means
%Objective function:
%           ||X^p-U^pQ^T||_{F}^{2}
MaxIter = 50;
p=numel(X);
for i=1:p
    m{i}=size(X{i},1);
    AA{i}=X{i};
    H(i,1)=1/p;
end
Q=Q';
n=size(X{1},2);
U{p}=[];Alpha{p}=[];
for i=1:p
    Alpha{i}=1;
end
err=0;
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
                AAA=AA{kk};BBB=BB{kk};
                J(1,k)=J(1,k)+norm(AAA(:,N)-BBB(:,k),'fro'); %1*c
            end
        end
        Q(N,:)=0;
        Q(N,J==min(J))=1;
    end
    for j=1:p
        err = norm(X{j}-U{j}*Q','fro')^2+err;
    end
    if i>1
        if norm(Q(:)-Q_old(:),'fro')==0
            break;
        end
    end
    Q_old = Q;
    err=0;
    sum_err(i)=err;
    H(:,i+1)=H(:,i);
end
end