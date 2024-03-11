function p=checkParity(num)
    t = 0;
    for i = 1:length(num) %can replace this 'for' loop just by t=sum(x)        
        if(num(i)=='1')
            t = t + 1; %increment by one if a bit is one
        end
    end
    if mod(t,2)==0
        p=0;
    else
        p=1;
    end
end