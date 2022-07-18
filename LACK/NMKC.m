function [U,V] = NMKC(X,r,ii)
%Objective function:
%           ||X_p-U_pV^T||_{F}^{2}
MaxIter = 50;
p=numel(X);
for i=1:p
    m{i}=size(X{i},1);
    AA{i}=X{i};
end
n=size(X{1},2);
Tol = 1e-4;
U{p}=[];Alpha{p}=[];
V=zeros_ones(r,n,ii)';
for i=1:p
    D(1,i)=1/p;
    Alpha{i}=1;
end
for i = 1:MaxIter
    for j = 1:p
        VTV=V'*V;
        U{j}=X{j}*(V*inv(VTV));
        BB{j}=U{j};
    end
    for N=1:n
        for k=1:r
            J(1,k)=0;
            for kk=1:p
                AAA=X{kk};BBB=BB{kk};
                J(1,k)=J(1,k)+D(1,kk)*norm(AAA(:,N)-BBB(:,k),'fro'); %1*c
            end
        end
        V(N,:)=0;
        V(N,J==min(J))=1;
    end
    err=0;
    for j=1:p
        DD = norm(X{j}-U{j}*V','fro');
        err = D(1,j)*DD+err;
        D(1,j) = 1/(2*DD/m{j});
    end
    H(:,i+1)=normalize(D,'norm',1);
    if i>1
        if norm(V(:)-V_old(:),'fro')==0
            break;
        end
    end
%     fprintf('it:%d, err=%f\n',i,err);
    V_old = V;
end
end