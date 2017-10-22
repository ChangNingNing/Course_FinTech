function [index, distance] = knnSearch(x, X, k)
    Y = X - x;
    for i=1:length(Y)
        distY(i) = norm(Y(:,i));
    end
    for i=1:k
        [td,ti] = min(distY);
        distance(i) = td;
        index(i) = ti;
        distY(ti) = intmax;
    end
end