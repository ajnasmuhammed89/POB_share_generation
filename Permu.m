% i=[1:10];
% numbers=[11:20];
% permuted=randperm(size(i,2));
% permuNumber=zeros(size(i,2));
% InverseNumber=zeros(i,2);
% 
% for j=1:size(i,2)
%     permuNumber(permuted(j))=numbers(j);
% end
% 
% for j=1:size(i,2)
%     InverseNumber(j)=permuNumber((permuted(j)))
% end
% 
% A=[1 2 3;4 5 6;7 8 9];
% B=reshape(A,[1 9])
% A1=reshape(B,[3 3]);

function [PermutedMat,i_permuted] = Permu(A,permu_seq)
    [M, N]= size(A);
    i=[1:M*N];
    if nargin==2
        i_permuted=permu_seq;
    else
        i_permuted=randperm(size(i,2));
    end
    A_1D=reshape(A, [1, M*N]);
    for j=1:size(A_1D,2)
        A_permuted(i_permuted(j))=A_1D(j);
    end
    PermutedMat=reshape(A_permuted,[M N]);
    i_permuted=reshape(i_permuted,[M,N]);
end

%     for j=1:size(A_1D,2)
%          InveseNumber(j)=A_permuted(i_permuted(j));
%     end
%     A_og=reshape(InverseNumber,[3 3]);
    