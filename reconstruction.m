[m,n]=size(img);

A1=POB_num1;
A2=POB_num2;
A3=POB_num3;
A4=POB_num4;

S1=imgShare1;
S2=imgShare2;
S3=imgShare3;
S4=imgShare4;

for i=1:m
    for j=1:n
        K_binary{i,j}=POB_reconstruction(A1{i,j},A2{i,j},A3{i,j},A4{i,j},S2(i,j));
        recon_img(i,j)=bin2dec((K_binary{i,j}));
    end
end