addpath ../../MatlabToolbox/utility	% Utility Toolbox is available at http://mirlab.org/jang/matlab/toolbox/utility

clear all; close all;
%% Define the query (or chart, or pattern) to be detected
T=20;
t=(0:2*T-1)';
chartW=cos(2*pi*(1/T)*t);			% Chart of "W"
chartM=cos(2*pi*(1/T)*(t-T/2));		% Chart of "M"
figure; plot(t, [chartW, chartM], 'marker', '.'); 
legend({'W', 'M'}, 'location', 'northOutside', 'orientation', 'horizontal');
%% Define variables and parameters
query=chartW;
dbVec=[74.4803 74.2668 74.9943 75.9871 75.1369 75.6966 73.8111 74.9851 74.6717 74.29 75.25 75.0641 74.4171 73.2131 74.3657 74.1497 74.2871 74.3763 75.4514 74.9987 74.0899 74.2214 73.5714 74.448 74.2571 74.82 76.2 77.9943 79.4386 78.7471 80.9031 80.7143 81.1287 80.0029 80.9186 80.7929 80.1943 80.0771 79.2043 79.6429 79.2843 78.6814 77.78 78.4314 81.4414 81.0957 80.5571 80.0129 79.2171 80.1457 79.0186 77.2829 77.7043 77.1482 77.6371 76.6456 76.1343 76.5329 78.0557 79.6229 79.1786 77.2386 78.4386 78.7871 79.4543 78.01 78.6429 72.3571 71.5357 71.3974 71.5143 71.6471 72.6843 73.2271 73.2157 74.24 75.57 76.5657 76.56 77.7757 77.7129 77.9986 76.7671 75.8786 75.0357 75.3643 74.58 73.9071 75.3814 75.1771 75.3943 75.8914 76.0514 75.8214 75.7771 75.8457 76.5843 76.6586 75.8071 74.9557 75.2486 75.9143 75.8943 75.5286 76.1243 77.0271 77.8557 77.1114 76.78 76.6943 76.6771 77.3786 77.5071 76.97 75.9743 74.7814 74.7771 75.76 74.7829 74.23 74.5257 73.9943 74.1443 74.9914 75.8814 75.957 74.9643 81.11 81.7057 84.87 84.6186 84.2986 84.4971 84.6543 85.8514 84.9157 84.6186 83.9986 83.6489 84.69 84.8229 84.8386 84.1171 85.3586 86.37 86.3871 86.6157 86.7529 87.7329 89.3757 89.1443 90.7686 90.4286 89.8071 91.0771 92.1171 92.4786 92.2243 93.7 94.25 93.86 92.29 91.28 92.2 92.08 92.18 91.86 90.91 90.83 90.28 90.36 90.9 91.98 92.93 93.52 93.48 94.03 95.968 95.35 95.39 95.035 95.22 96.45 95.32 94.78 93.0899 94.43 93.939 94.72 97.19 97.03 97.671 99.02 98.38 98.15 95.6 96.13 95.59 95.12 94.96 94.48 94.74 95.99 95.97 97.24 97.5 97.98 99.16 100.53 100.57 100.58 101.32 101.54 100.889 102.13 102.25 102.5 103.3 98.94 98.12 98.97 98.36 97.99 101 101.43 101.66 101.63 100.86 101.58 101.79 100.96 101.06 102.64 101.75 97.87 100.75 100.11 100.75 99.18 99.9 99.62 99.62 98.75 100.8 101.02 100.73 99.81 98.75 97.54 96.26 97.67 99.76 102.47 102.99 104.83 105.22 105.11 106.74 107.34 106.98 108 109.4 108.6 108.86 108.7 109.01 108.83 109.7 111.25 112.82 114.18 113.99 115.47 114.67 116.31 116.47 118.625 117.6 119 118.93 115.07 114.63 115.93 115.49 115 112.4 114.12 111.95 111.62 109.73 108.225 106.745 109.41 112.65 111.78 112.94 112.54 112.01 113.99 113.91 112.52];
sfMin=0.5;	% Min of scaling factor
sfMax=1.5;	% Max of scaling factor
sfCount=51;	% Count of scaling factors
minAlpha=0.0;		% Minimum value of alpha
%%
distance=zeros(length(dbVec), 1);
startPos=zeros(length(dbVec), 1);
queryTransformed=cell(length(dbVec), 1);
theDbLen=round(length(query)*sfMax);
for i=1:length(dbVec)
%	fprintf('%d/%d\n', i, length(dbVec));
	theDbVec=dbVec(i:min(i+theDbLen-1, length(dbVec)));
	[distance(i), queryTransformed{i}]=linScaling4chart(query, theDbVec, sfMin, sfMax, sfCount, minAlpha);
	startPos(i)=i;
end
localMinIndex=find(localMin(distance));
distance2=distance(localMinIndex);
[~, sortIndex]=sort(distance2);
fprintf('distance=%s\n', mat2str(distance));

n=10;	% No of transformed queries to be plotted
subplot(211);
plot(dbVec)
for i=1:n
	j=localMinIndex(sortIndex(i));
	xIndex=startPos(j):startPos(j)+length(queryTransformed{j})-1;
	line(xIndex, queryTransformed{j}, 'color', getColor(i), 'lineWidth', 2);
end
line(1:length(dbVec), dbVec, 'color', 'k');
title('dbVec and identified charts');
subplot(212); localMin(distance, 1); set(gca, 'yscale', 'log');
for i=1:n
	j=localMinIndex(sortIndex(i));
	line(j, distance(j), 'color', 'k', 'marker', '*'); 
end
xlabel('Data index'); title('Distance and local minima');