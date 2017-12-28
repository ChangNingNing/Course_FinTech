function [action, ratio]=myStrategy(pastData)
    function ratio=SharpRatio(S, index, n)
        if index < n+2
            ratio = 0;
        else
            mu = 0;
            for i=index-n-1:index-2
                mu = mu + (S(i+1).AdjClose - S(i).AdjClose)/S(i).AdjClose;
            end
            mu = mu / n;
            
            sigma = 0;
            for i=index-n-1:index-2
                sigma = sigma + ((S(i+1).AdjClose - S(i).AdjClose)/S(i).AdjClose - mu)^2;
            end
            sigma = (sigma / (n-1))^(1/2);
            ratio = mu/sigma;
        end
    end

    function ma=MA(S, index, n)
        r = index-1;
        l = r - n + 1;
        if l < 1
            ma = 0;
            return
        end
        sum = 0;
        for i=l:r
            sum = sum + S(i).AdjClose;
        end
        ma = sum / n;
    end
    persistent preAction;
    if isempty(preAction)
        preAction = -1;
    end
    N = 359;
    U = 0.000497;
    D = -0.000986;
    buy_s = 6;
    sell_s = 10;

    size = length(pastData);
    if size < 1
        action = 0;
        ratio = 0;
        return;
    end
    cur_p = pastData(size).AdjClose;
    ma5 = MA(pastData, size+1, 5);
    ma10 = MA(pastData, size+1, 10);
    sr = SharpRatio(pastData, size+1, N);
   
    if bitand(buy_s, 1)
        buy_f = 1;
        if bitand(buy_s, 2)
            if sr > U
                buy_f = bitand(buy_f, 1);
            else
                buy_f = bitand(buy_f, 0);
            end
        end
        if bitand(buy_s, 4)
            if cur_p > ma5
                buy_f = bitand(buy_f, 1);
            else
                buy_f = bitand(buy_f, 0);
            end
        end
        if bitand(buy_s, 8)
            if cur_p > ma10
                buy_f = bitand(buy_f, 1);
            else
                buy_f = bitand(buy_f, 0);
            end
        end
    else
        buy_f = 0;
        if bitand(buy_s, 2)
            if sr > U
                buy_f = bitor(buy_f, 1);
            end
        end
        if bitand(buy_s, 4)
            if cur_p > ma5
                buy_f = bitor(buy_f, 1);
            end
        end
        if bitand(buy_s, 8)
            if cur_p > ma10
                buy_f = bitor(buy_f, 1);
            end
        end 
    end
    
    if bitand(sell_s, 1)
        sell_f = 1;
        if bitand(sell_s, 2)
            if sr < D
                sell_f = bitand(sell_f, 1);
            else
                sell_f = bitand(sell_f, 0);
            end
        end
        if bitand(sell_s, 4)
            if cur_p < ma5
                sell_f = bitand(sell_f, 1);
            else
                sell_f = bitand(sell_f, 0);
            end
        end
        if bitand(sell_s, 8)
            if cur_p < ma10
                sell_f = bitand(sell_f, 1);
            else
                sell_f = bitand(sell_f, 0);
            end
        end
    else
        sell_f = 0;
        if bitand(sell_s, 2)
            if sr < D
                sell_f = bitor(sell_f, 1);
            end
        end
        if bitand(sell_s, 4)
            if cur_p < ma5
                sell_f = bitor(sell_f, 1);
            end
        end
        if bitand(sell_s, 8)
            if cur_p < ma10
                sell_f = bitor(sell_f, 1);
            end
        end
    end
    
    if buy_f && preAction==-1
        action = 1;
        preAction = 1;
    elseif sell_f && preAction==1
        action = -1;
        preAction = -1;
    else
        action = 0;
    end
    ratio = sr;
end