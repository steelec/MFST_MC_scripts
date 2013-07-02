function MFST_MC_plotData2(PPs,measure,doTFR,trialSelect, numTrialSelect)
% Function to work with data structure for MFST_MC and output summary
% graphs for a quick look at the selected measure
%
% input:
% <PPs>     - MFST_MC data structure
% <measure> - numerical ID of behavioural measure to create summary for display
%             {1,2,3,4,5,6} ->
%             {Proportion Correct,Lag1 (RT),Lag2 (offset RT),Duration,Velocity,Intertap Interval}
%
% output:
%           - displays figure with 2 rows of three plots for behavioural
%             measure that was requested
%           - top row plots each subject's LRN trials by trial, block, day
%           - bottom row plots mean of LRN trials by trial, then mean of
%           LRN (+/-SEM) and RND trials by block and day

if nargin==2
    doTFR=true;
    trialSelect=true;
    numTrialSelect=4;
elseif nargin<4
    trialSelect=true;
    numTrialSelect=4;
end

%initialise vars
%calculate size for display
sz=get(0,'screensize');
xloc=sz(1);
yloc=sz(1);
xsize=sz(3)-30;
ysize=sz(4)-30;

%initialise variables and select data
data=PPs.all.data;
measureName=PPs.all.measures{measure};
legendText=strrep(PPs.all.IDs(:),'_',' ');

LRN=data.LRN;
RND=data.RND;

if doTFR
    TFR=data.TFR;
    numTFR=size(TFR.LRN,4);
end

dataSize=size(LRN);
dataSizeRND=size(LRN);

figure;
%1st row of plots (individuals) - LRN sequence only
%calculate and plot average over each trial for each participant
level='Trial';
summaryType='Individual';

[m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect);

mysubplot(3,3,1); set(gcf,'Name',measureName,'OuterPosition', [xloc yloc xsize ysize]); hold on;
color=[linspace(1,.1,dataSize(1))' linspace(.1,1,dataSize(1))' linspace(.1,1,dataSize(1))'];

for ID=1:dataSize(1)
    plot(m(ID,:),':o','Color',color(ID,:));
end
title([measureName ' by ' level]); xlabel(level); ylabel(measureName);
hold off;


%alculate and plot average over each block for each participant
level='Block';
[m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect);

mysubplot(3,3,2); hold on;
for ID=1:dataSize(1)
    plot(m(ID,:),':o','Color',color(ID,:));
end
title([measureName ' by ' level]); xlabel(level);
hold off;


%alculate and plot average over each day for each participant
level='Day';
[m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect);
mysubplot(3,3,3); hold on;
for ID=1:dataSize(1)
    plot(m(ID,:),':o','Color',color(ID,:));
end
title([measureName ' by ' level]); xlabel(level);
legend(gca,legendText);
hold off;

%2nd row of plots (averaged across individuals)
% average over each trial for all participants (LRN sequence only)
summaryType='Group';
mysubplot(3,3,4);
level='Trial';
[m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect);
plot(m,':ko','MarkerEdgeColor','k'); hold on;
[m sd n] = MFST_MC_selectData(RND,measure,summaryType,level);
plot(m,':ro','MarkerEdgeColor','r');
title([measureName ' by Trial']); %axis square;

%CoV plot
mysubplot(3,3,7);
plot(sd.^2,':ko','MarkerEdgeColor','k');
title([measureName ' Variance (SD^2) by Trial']); %axis square;

% average over each block for all participants - LRN(+/-95%CI) & RND sequences
mysubplot(3,3,5); title('LRN vs RND');
level='Block';

%%%LRN
[m1 sd1 n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect); %get LRN avg
x=[1:length(m1)];
%smo=supsmu(x,m1);
errorbar(m1,sd1./sqrt(n)*tinv(.95,n-1),':ko');
hold on;
%plot(x,smo,'-k');

%95% CI
% u=m1+sd1./sqrt(n)*tinv(.95,n-1);
% l=m1-sd1./sqrt(n)*tinv(.95,n-1);
% ciplot(l,u,1:length(l),'k');

%%%RND
level='Block';
[m2 sd2 n] = MFST_MC_selectData(RND,measure,summaryType,level); %get RND avg
%smo=supsmu(x,m2);
errorbar(m2,sd2./sqrt(n)*tinv(.95,n-1),':ro');
hold on;
%plot(x,smo,'-r');

%95% CI
% u=m2+sd2./sqrt(n)*tinv(.95,n-1);
% l=m2-sd2./sqrt(n)*tinv(.95,n-1);
% ciplot(l,u,1:length(l),'r');
title([measureName ' by Block']); %axis square;

%plot the transfer (TFR) block(s) separately (no CI)
%block 1 is TFR1, block 2 is TFR2
if doTFR
    x=[size(m1,2)+1: size(m1,2)+numTFR]; %display to the right of the last block
    
    [m sd n] = MFST_MC_selectData(TFR.LRN,measure,summaryType,level,trialSelect, numTrialSelect);
    errorbar(x,m,sd./sqrt(n)*tinv(.95,n-1),'ks','MarkerEdgeColor','k');
    fprintf('Transfer blocks have only been displayed for those blocks that ALL participants completed.\n');
    %w/ stderr
    % data4plot=m+sd./sqrt(n);
    % plot(x,data4plot,'*k');
    % data4plot=m-sd./sqrt(n);
    % plot(x,data4plot,'*k');
    
    [m sd n] = MFST_MC_selectData(TFR.RND,measure,summaryType,level);
    errorbar(x,m,sd./sqrt(n)*tinv(.95,n-1),'rs','MarkerEdgeColor','r');
    
    %w/ stderr
    % data4plot=m+sd./sqrt(n);
    % plot(x,data4plot,'*r');
    % data4plot=m-sd./sqrt(n);
    % plot(x,data4plot,'*r');
end
hold off;

%%%CoV plot
mysubplot(3,3,8);
plot(sd1.^2,':ko','MarkerEdgeColor','k'); hold on;
plot(sd2.^2,':ro','MarkerEdgeColor','r'); hold off;
title([measureName ' Variance (SD^2) by Block']); %axis square;



% average over each day for all participants - LRN(+/-SEM) & RND sequences
mysubplot(3,3,6);
level='Day';
%%%LRN
[m1 sd1 n] = MFST_MC_selectData(LRN,measure,summaryType,level,trialSelect, numTrialSelect); %get LRN avg

LRNplot=errorbar(m1,sd1./sqrt(n)*tinv(.95,n-1),':ko','MarkerEdgeColor','k'); hold on;

% data4plot=m+sd./sqrt(n);
% plot(data4plot,'*g');
% data4plot=data4plot-2*sd./sqrt(n);
% plot(data4plot,'*g');
title([measureName ' by Day']); %axis square;
%95% CI
% u=m1+sd1./sqrt(n)*tinv(.95,n-1);
% l=m1-sd1./sqrt(n)*tinv(.95,n-1);
% ciplot(l,u,1:length(l),'k');
hold on;

%%%RND
level='Day';
[m2 sd2 n] = MFST_MC_selectData(RND,measure,summaryType,level); %get RND avg
% RNDplot=plot(m2,':ko','MarkerEdgeColor','r');
RNDplot=errorbar(m2,sd2./sqrt(n)*tinv(.95,n-1),':ko','MarkerEdgeColor','r');

legend([LRNplot RNDplot],'LRN','RND');
% %95% CI
% u=m2+sd2./sqrt(n)*tinv(.95,n-1);
% l=m2-sd2./sqrt(n)*tinv(.95,n-1);
% ciplot(l,u,1:length(l),'r');
hold off;

%%%CoV plot
mysubplot(3,3,9);
plot(sd1.^2,':ko','MarkerEdgeColor','k'); hold on;
plot(sd2.^2,':ro','MarkerEdgeColor','r');
title([measureName ' Variance (SD^2) by Day']); %axis square;
hold off;

text(0,0,'Error bars represent 95% CIs');