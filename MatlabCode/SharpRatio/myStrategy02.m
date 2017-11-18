function [action,ratio]=myStrategy02(pastData)
    function ratio=SharpRatio(S, index, n)
        if index < n+2
            ratio = 0;
        else
            mu = 0;
            for i=index-n-1:index-2
                mu = mu + (S(i+1) - S(i))/S(i);
            end
            mu = mu / n;
            
            sigma = 0;
            for i=index-n-1:index-2
                sigma = sigma + ((S(i+1) - S(i))/S(i) - mu)^2;
            end
            sigma = (sigma / (n-1))^(1/2);
            ratio = mu/sigma;
        end
    end
    N = 121;
    U = 0.000796;
    D = -0.000685;
    ratio = SharpRatio(pastData, length(pastData)+1, N);
    if ratio > U
        action = 1;
    elseif ratio < D
        action = -1;
    else
        action = 0;
    end
end