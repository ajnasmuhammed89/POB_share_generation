function value = POB_N(A)
    value = 0;
    count = 5;
    for i=1:length(A)
        if A(i)=='1'
            count=count-1;
            p=length(A)-i;
            if p>=count
                if p>0
                    combination=factorial(p)/(factorial(p-count)*factorial(count));
                else
                    combination=0;
                end
            else
                combination=0;
            end
            value=value+combination;
        end
    end
end