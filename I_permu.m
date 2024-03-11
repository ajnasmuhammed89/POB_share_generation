function I_permuted=I_permu(A,B)
    [M, N]= size(A);
    i=[1:M*N];
    B=reshape(B,[1,M*N]);
    i_permute=B;
    A_1D=reshape(A, [1, M*N]);
    for j=1:size(A_1D,2)
        A_permuted(j)=A_1D(i_permute(j));
    end
    I_permuted=reshape(A_permuted,[M N]);
end

%     for j=1:size(A_1D,2)
%          InveseNumber(j)=A_permuted(i_permuted(j));
%     end
%     A_og=reshape(InverseNumber,[3 3]);
%end