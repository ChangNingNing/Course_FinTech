function [minValue, minIndex] = minxy(matrix)

% implement your code here
[a, b] = min(matrix);
[minValue, y] = min(a);
minIndex = [b(y), y];

end