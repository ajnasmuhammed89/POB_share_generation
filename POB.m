function [S,A]=POB(number)
%S = 182;
K = num2str(dec2bin(number,8));

n = 4;

%step 1 : Assign n null strings of size 9
for i = 1:n % n
    A{i}='000000000';
end

%step2:  Randomly assign n-2 POB(9,4)-numbers one for each of Ai
%, 2 ≤ i ≤ n − 1.
%Let r =ceil(V (A2)+1/14)

for i=2:n-1
    p = randperm(9,4);
    A{i}(p) = '1'; 
end

r = ceil((POB_N(A{2})+1)/14);

%step3 Expanding K to T
% check partity of K
T='000000000';
parity = checkParity(K);

%expanding
for i = 1:r-1
    T(i)=K(i);
end

T(r)=num2str(parity);

for i=r+1:9
    T(i)=K(i-1);
end
% step4 :calculate W
W=T;
for i=2:n-1
    for j=1:9
        W(j)=num2str(xor(str2num(W(j)),str2num(A{i}(j)))); 
    end
end

%step5 calculate A1

noOfOne=0;
for i=1:9
    if W(i)=='1'
        noOfOne=noOfOne+1;
        if mod(noOfOne,2)==1
            A{1}(i)='1';
        else
            A{1}(i)='0';
        end
    else
        A{1}(i)='x';
    end
end

%complete A1
noOfOne=0;
positionOfX='000000000';
for i=1:9
    if A{1}(i)=='1'
        noOfOne=noOfOne+1;
    elseif A{1}(i)=='x'
        positionOfX(i)='1';
    end
end
if noOfOne<4
    oneNeeded=4-noOfOne;
    for i=1:9
        if A{1}(i)=='x'
            A{1}(i)='1';
            oneNeeded=oneNeeded-1;
            if oneNeeded==0
                break;
            end
        end
    end
end

for i=1:9
    if A{1}(i)=='x'
        A{1}(i)='0';
    end
end

%Step 7 compute An

for j=1:9
    A{n}(j)=num2str(xor(str2num(W(j)),str2num(A{1}(j)))); 
end

%step8 Compute shares

for i=1:n
    S(i)=POB_N(A{i});
end

% s1=S(1);
% s2=S(2);
% s3=S(3);
% s4=S(4);
end

