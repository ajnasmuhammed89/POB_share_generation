i=[1:10];
numbers=[11:20];
permuted=randperm(size(i,2));
permuNumber=zeros(size(i,2));
InverseNumber=zeros(i,2);

for j=1:size(i,2)
    permuNumber(permuted(j))=numbers(j);
end

for j=1:size(i,2)
    InverseNumber(j)=permuNumber((permuted(j)))
end


    