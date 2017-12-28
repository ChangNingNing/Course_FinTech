% Main program for testing myStrategy01.m
%	Roger Jang, 20171110

close all; clear all;
%% Parameters and data
capital=1;	% Initial cash
file='spy.csv';
fprintf('Reading %s...\n', file);
file='SPY.csv';
spyTable=readtable(file);
pastData=table2struct(spyTable);
%[num, str, raw]=xlsread(file, 'spy');
%adjClose=num(:,5)';
%% Start rolling
dataCount=length(pastData);
suggestedAction=zeros(dataCount,1);	% suggested actions based on sharpe ratio, 1 for buy, -1 for sell
ratio=zeros(dataCount,1);	% sharpe ratio
unit=zeros(dataCount,1);	% unit of stock in hand
total=zeros(dataCount,1);	% total assets
realAction=zeros(dataCount,1);	% real actions
total(1)=capital;
for i=400:dataCount
    [suggestedAction(i), ratio(i)]=myStrategy(pastData(1:i-1));	% Suggested action
    currPrice=pastData(i).AdjClose;	% Today's price
	if i>1, unit(i)=unit(i-1); end		% Initial holding from yesterday
	switch suggestedAction(i)
		case 1	% "buy"
			if unit(i)==0
				unit(i)=capital/currPrice;
				capital=0;
				realAction(i)=1;
			end
		case -1	% "sell"
			if unit(i)>0
				capital=unit(i)*currPrice;
				unit(i)=0;
				realAction(i)=-1;
			end
		case 0	% Do nothing
		otherwise
			disp('Unknown action!');
	end
	total(i)=capital+unit(i)*currPrice;
%	fprintf('%d/%d: suggestedAction=%d, unit=%g, capital=%g, realAction=%d, total=%g\n', i, dataCount, suggestedAction(i), unit(i), capital, realAction(i), total(i));
end
%fprintf('Count of "suggested buy" = %g\n', sum(suggestedAction==1));
%fprintf('Count of "suggested sell" = %g\n', sum(suggestedAction==-1));
fprintf('Count of "buy" = %g\n', sum(realAction==1));
fprintf('Count of "sell" = %g\n', sum(realAction==-1));
fprintf('Total assets = %g\n', total(end));
%% Plotting
subplot(511); plot([pastData.AdjClose]); title('Adj close'); set(gca, 'xlim', [1, dataCount]);
subplot(512); plot(ratio); title('Sharpe ratio');  set(gca, 'xlim', [1, dataCount]);
axisLimit=axis;
line(axisLimit(1:2), 0*[1 1], 'color', 'r');
%hU=text(axisLimit(2), U, sprintf('U=%g', U));
%hD=text(axisLimit(2), D, sprintf('D=%g', D));
%line(axisLimit(1:2), D*[1 1], 'color', 'g');
color={'g', 'b', 'r'};
subplot(513); plot(realAction); title('Action'); set(gca, 'xlim', [1, dataCount]);
for i=1:length(suggestedAction)
	if realAction(i)==0; continue; end
	line(i, realAction(i), 'marker', '.', 'color', color{realAction(i)+2});
end
subplot(514); plot(unit); title('Stock holdings'); set(gca, 'xlim', [1, dataCount]);
subplot(515); plot(total); title('Total asset'); set(gca, 'xlim', [1, dataCount]);
line(axisLimit(1:2), total(1)*[1 1], 'color', 'r');
xlabel('Data index');