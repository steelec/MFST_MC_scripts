function MFST_MC_plotConsol(PPs,measure,blocks,pctChng)
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
%TFR=data.TFR;
%numTFR=size(TFR.LRN,4);
dataSize=size(LRN);
dataSizeRND=size(LRN);

figure;
color=[linspace(1,.1,dataSize(1))' linspace(.1,1,dataSize(1))' linspace(.1,1,dataSize(1))'];

%alculate and plot consol for each day for each participant
level='Block';
summaryType='Individual';
[m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level);
m=selectConsolData(m,blocks,pctChng);

mysubplot(2,1,1); hold on;
for ID=1:dataSize(1)
    plot(m(ID,:),':o','Color',color(ID,:));
end
title([measureName ' by ' level]); xlabel(level);
hold off;


% average over each consol for all participants - LRN(+/-95%CI) & RND sequences
mysubplot(2,1,2); hold on;
title('LRN vs RND');
level='Block';
summaryType='Individual'; %still need to use the individual summaries
sd1=std(m); %b/c the sd of the consol measure is not returned by selectData
n=size(m,1);
m1=mean(m);
%%%LRN
errorbar(m1,sd1./sqrt(n)*tinv(.95,n-1),':ko'); 
hold on;


%%%RND
[m2 sd n] = MFST_MC_selectData(RND,measure,summaryType,level);
m2=selectConsolData(m2,blocks,pctChng);
n=size(m2,1);
sd2=std(m2);
m2=mean(m2);
errorbar(m2,sd2./sqrt(n)*tinv(.95,n-1),':ro');


% %alculate and plot average over each day for each participant
% level='Day';
% [m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level);
% mysubplot(3,3,3); hold on;
% for ID=1:dataSize(1)
%     plot(m(ID,:),':o','Color',color(ID,:));
% end
% title([measureName ' by ' level]); xlabel(level);
% legend(gca,legendText);
% hold off;
% 
% %2nd row of plots (averaged across individuals)
% % average over each trial for all participants (LRN sequence only)
% summaryType='Group';
% mysubplot(3,3,4);
% level='Trial';
% [m sd n] = MFST_MC_selectData(LRN,measure,summaryType,level);
% plot(m,':ko','MarkerEdgeColor','k');
% title([measureName ' by Trial']); %axis square;
% 
% %CoV plot
% mysubplot(3,3,7);
% plot(sd.^2,':ko','MarkerEdgeColor','k');
% title([measureName ' Variance (SD^2) by Trial']); %axis square;
% 
% % average over each block for all participants - LRN(+/-95%CI) & RND sequences
% mysubplot(3,3,5); title('LRN vs RND');
% level='Block';
% 
% %%%LRN
% [m1 sd1 n] = MFST_MC_selectData(LRN,measure,summaryType,level); %get LRN avg
% x=[1:length(m1)];
% smo=supsmu(x,m1);
% errorbar(m1,sd1./sqrt(n)*tinv(.95,n-1),':ko'); 
% hold on;
% plot(x,smo,'-k');
% 
% %95% CI
% % u=m1+sd1./sqrt(n)*tinv(.95,n-1);
% % l=m1-sd1./sqrt(n)*tinv(.95,n-1);
% % ciplot(l,u,1:length(l),'k');
% 
% %%%RND
% level='Block';
% [m2 sd2 n] = MFST_MC_selectData(RND,measure,summaryType,level); %get RND avg
% smo=supsmu(x,m2);
% errorbar(m2,sd2./sqrt(n)*tinv(.95,n-1),':ro');
% hold on;
% plot(x,smo,'-r'); 
% 
% %95% CI
% % u=m2+sd2./sqrt(n)*tinv(.95,n-1);
% % l=m2-sd2./sqrt(n)*tinv(.95,n-1);
% % ciplot(l,u,1:length(l),'r');
% title([measureName ' by Block']); %axis square; 
% 
% %plot the transfer (TFR) block(s) separately (no CI)
% %block 1 is TFR1, block 2 is TFR2
% x=[size(m1,2)+1: size(m1,2)+numTFR]; %display to the right of the last block
% 
% [m sd n] = MFST_MC_selectData(TFR.LRN,measure,summaryType,level);
% errorbar(x,m,sd./sqrt(n)*tinv(.95,n-1),'ks','MarkerEdgeColor','k');
% fprintf('Transfer blocks have only been displayed for those blocks that ALL participants completed.\n');
% %w/ stderr
% % data4plot=m+sd./sqrt(n);
% % plot(x,data4plot,'*k');
% % data4plot=m-sd./sqrt(n);
% % plot(x,data4plot,'*k');
% 
% [m sd n] = MFST_MC_selectData(TFR.RND,measure,summaryType,level);
% errorbar(x,m,sd./sqrt(n)*tinv(.95,n-1),'rs','MarkerEdgeColor','r');
% 
% %w/ stderr
% % data4plot=m+sd./sqrt(n);
% % plot(x,data4plot,'*r');
% % data4plot=m-sd./sqrt(n);
% % plot(x,data4plot,'*r');
% hold off;
% 
% %%%CoV plot
% mysubplot(3,3,8);
% plot(sd1.^2,':ko','MarkerEdgeColor','k'); hold on;
% plot(sd2.^2,':ro','MarkerEdgeColor','r'); hold off;
% title([measureName ' Variance (SD^2) by Block']); %axis square;
% 
% 
% 
% % average over each day for all participants - LRN(+/-SEM) & RND sequences
% mysubplot(3,3,6);
% level='Day';
% %%%LRN
% [m1 sd1 n] = MFST_MC_selectData(LRN,measure,summaryType,level); %get LRN avg
% 
% LRNplot=errorbar(m1,sd1./sqrt(n)*tinv(.95,n-1),':ko','MarkerEdgeColor','k'); hold on;
% 
% % data4plot=m+sd./sqrt(n);
% % plot(data4plot,'*g');
% % data4plot=data4plot-2*sd./sqrt(n);
% % plot(data4plot,'*g');
% title([measureName ' by Day']); %axis square;
% %95% CI
% % u=m1+sd1./sqrt(n)*tinv(.95,n-1);
% % l=m1-sd1./sqrt(n)*tinv(.95,n-1);
% % ciplot(l,u,1:length(l),'k');
% hold on;
% 
% %%%RND
% level='Day';
% [m2 sd2 n] = MFST_MC_selectData(RND,measure,summaryType,level); %get RND avg
% % RNDplot=plot(m2,':ko','MarkerEdgeColor','r');
% RNDplot=errorbar(m2,sd2./sqrt(n)*tinv(.95,n-1),':ko','MarkerEdgeColor','r');
% 
% legend([LRNplot RNDplot],'LRN','RND');
% % %95% CI
% % u=m2+sd2./sqrt(n)*tinv(.95,n-1);
% % l=m2-sd2./sqrt(n)*tinv(.95,n-1);
% % ciplot(l,u,1:length(l),'r');
% hold off;
% 
% %%%CoV plot
% mysubplot(3,3,9);
% plot(sd1.^2,':ko','MarkerEdgeColor','k'); hold on;
% plot(sd2.^2,':ro','MarkerEdgeColor','r');
% title([measureName ' Variance (SD^2) by Day']); %axis square; 
% hold off;
% 
% text(0,0,'Error bars represent 95% CIs');