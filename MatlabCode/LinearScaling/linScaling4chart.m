function [distMin, queryTransformedBest]=linScaling4chart(query, dbVec, sfMin, sfMax, sfCount, alphaMin)
% linScaling: Linear scaling for chart detection
%
%	Usage:
%		[distMin, queryTransformedBest, distAll]=linScaling4chart(query, dbVec, sfMin, sfMax, sfCount, alphaMin)

sf=linspace(sfMin, sfMax, sfCount);	% scaling factors
queryLen=length(query);
distAll=inf*ones(1, sfCount);
queryTransformedAll=cell(1, sfCount);
alphaAll=zeros(1, sfCount);

for i=1:sfCount
	queryScaledLen=round(queryLen*sf(i));	% Length of the length-scaled query
    % Break if the length is too long
    if queryScaledLen > length(dbVec)
            break;
    end
    % Length-scaled query (compressed or expanded)
    queryScaled = interp1(1:queryLen, query, linspace(1,queryLen,queryScaledLen));
    seg=dbVec(1:queryScaledLen);	% A segmeng of dbVec for comparison
	queryMean=mean(queryScaled);	% Mean of query
	segMean=mean(seg);				% Mean of seg
    queryJustified=queryScaled(:)-queryMean;	% Zero-justified query
	segJustified=seg(:)-segMean;				% Zero-justified seg
	% Find alpha such that ||queryJustified*alpha-dbJustified|| is minimized
    alpha = dot(segJustified, queryJustified) / (norm(queryJustified)^2);
    diff=queryJustified.*alpha-segJustified;		% Difference between queryJustified*alpha-segJustified 
	% root mean squared error
    rmse = (sum(diff .^ 2) / queryScaledLen) ^ (1/2);
    
    distAll(i)=rmse/abs(alpha);		% Normalized RMSE
	% Set the distance to infinite if alpha is too small
    if alpha < alphaMin
           distAll(i) = inf;
    end
	% Record the transformed query
    queryTransformedAll{i} = queryJustified*alpha + segMean;
	alphaAll(i)=alpha;		% Record alpha
end
[distMin, minIndex]=min(distAll);	% Find the min distance
queryTransformedBest=queryTransformedAll{minIndex};		% Find the best transformed query
alphaBest=alphaAll(minIndex);	% Find the best alpha