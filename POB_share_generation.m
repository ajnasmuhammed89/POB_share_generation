[m,n]=size(img);
POB_num1=cell(m,n);
POB_num2=cell(m,n);
POB_num3=cell(m,n);
POB_num4=cell(m,n);
for i=1:m
    for j=1:n
        [Shares,POB_number]=POB(img(i,j));
        imgShare1(i,j)=Shares(1);
        imgShare2(i,j)=Shares(2);
        imgShare3(i,j)=Shares(3);
        imgShare4(i,j)=Shares(4);
        POB_num1{i,j}=POB_number{1,1};
        POB_num2{i,j}=POB_number{1,2};
        POB_num3{i,j}=POB_number{1,3};
        POB_num4{i,j}=POB_number{1,4};
    end
end