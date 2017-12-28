function [action, ratio]=myStrategy2(pastData)
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
    buy_s = 10;
    sell_s = 68;

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
    
    if preAction == -1
        tmp_s = buy_s;
    elseif preAction == 1
        tmp_s = sell_s;
    end
   
    if bitand(tmp_s, 1)
        tmp_f = 1;
        if bitand(tmp_s, 2)
            if sr > U
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
        if bitand(tmp_s, 4)
            if sr < D
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
        if bitand(tmp_s, 8)
            if cur_p > ma5
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
        if bitand(tmp_s, 16)
            if cur_p < ma5
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
        if bitand(tmp_s, 32)
            if cur_p > ma10
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
        if bitand(tmp_s, 64)
            if cur_p < ma10
                tmp_f = bitand(tmp_f, 1);
            else
                tmp_f = bitand(tmp_f, 0);
            end
        end
    else
        tmp_f = 0;
        if bitand(tmp_s, 2)
            if sr > U
                tmp_f = bitor(tmp_f, 1);
            end
        end
        if bitand(tmp_s, 4)
            if sr < D
                tmp_f = bitor(tmp_f, 1);
            end
        end
        if bitand(tmp_s, 8)
            if cur_p > ma5
                tmp_f = bitor(tmp_f, 1);
            end
        end
        if bitand(tmp_s, 16)
            if cur_p < ma5
                tmp_f = bitor(tmp_f, 1);
            end
        end
        if bitand(tmp_s, 32)
            if cur_p > ma10
                tmp_f = bitor(tmp_f, 1);
            end
        end
        if bitand(tmp_s, 64)
            if cur_p < ma10
                tmp_f = bitor(tmp_f, 1);
            end
        end 
    end
    
    if preAction == -1
        if tmp_f
            action = 1;
            preAction = 1;
        else
            action = 0;
        end
    elseif preAction == 1
        if tmp_f
            action = -1;
            preAction = -1;
        else
            action = 0;
        end
    end
    ratio = sr;
end