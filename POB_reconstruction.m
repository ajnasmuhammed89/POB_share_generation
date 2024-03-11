function K = POB_reconstruction(A1,A2,A3,A4,S2)
    n=4;
    %compute r
    r=ceil((S2+1)/14);
    %compute T 
    for j=1:9
        T(j)=num2str(xor(str2num(A1(j)),xor(str2num(A2(j)),xor(str2num(A3(j)),str2num(A4(j)))))); 
    end
    
    for i=1:8
        if (i>=r)
            j=i+1;
        else
            j=i;
        end
        K(i)=T(j);
    end
end