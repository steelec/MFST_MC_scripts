function data4plot=MFST_MC_plotData(PPs,measure)
%
%
%
%
%
%
%

%initialise vars

%calculate size for display
sz=get(0,'screensize');
xloc=round(sz(3)/2)+10;
yloc=5;
xsize=sz(3)-xloc-20;
ysize=sz(4)-30;

data=PPs.all.data;
measureName=PPs.all.measures{measure};
legendText=strrep(PPs.all.IDs(:),'_',' ');
% break down to just talk about day/blk/trial mean&sd for each participant
LRN=data.LRN;
RND=data.RND;
dataSize=size(LRN);
dataSizeRND=size(LRN);

data4plot=[];
%trial averages
figure;
for ID=1:dataSize(1)
    for day=1:dataSize(3)
        for block=1:dataSize(4)
            for trial=1:dataSize(5)
                dayOffset=(day-1)*dataSize(4)*dataSize(5);
                blockOffset=(block-1)*dataSize(5);
                idx=dayOffset+blockOffset+trial;
                trialData4plot(ID,idx)=LRN(ID,measure,day,block,trial,1);
            end
        end
    end
end
%size(data4plot)
mysubplot(3,3,1); set(gcf,'Name',measureName,'OuterPosition', [xloc yloc xsize ysize]); hold on;
color=[linspace(1,.1,dataSize(1))' linspace(.1,1,dataSize(1))' linspace(.1,1,dataSize(1))'];
for ID=1:dataSize(1)
    plot(trialData4plot(ID,:),':o','Color',color(ID,:));
end
level='Trial';
title([measureName ' by ' level]); xlabel(level); ylabel(measureName);
%axis square;
hold off;

data4plot=[];
%block averages
for ID=1:dataSize(1)
    for day=1:dataSize(3)
        for block=1:dataSize(4)
            dayOffset=(day-1)*dataSize(4);
            idx=dayOffset+block;
            %clear NaN from data before averaging - lost data XXX
            blockData=squeeze(LRN(ID,measure,day,block,:,1)); %grab data
            blockData=reshape(blockData,1,numel(blockData)); %make a single line
            blockData(isnan(blockData))=[]; %get rid of NaNs
            blockData4plot(ID,idx)=mean(blockData);
            %data4plot(ID,idx)=mean(squeeze(LRN(ID,measure,day,block,:,1)));
        end
    end
end

mysubplot(3,3,2); hold on;
for ID=1:dataSize(1)
    plot(blockData4plot(ID,:),':o','Color',color(ID,:));
end
level='Block';
title([measureName ' by ' level]); xlabel(level);%axis square;
hold off;

data4plot=[];
%day averages
for ID=1:dataSize(1)
    for day=1:dataSize(3)
        dayData=squeeze(LRN(ID,measure,day,:,:,1));
        dayData=reshape(dayData,1,numel(dayData));
        dayData(isnan(dayData))=[];
        dayData4plot(ID,day)=mean(mean(dayData));
    end
end

mysubplot(3,3,3); hold on;
for ID=1:dataSize(1)
    plot(dayData4plot(ID,:),':o','Color',color(ID,:));
end
level='Day';
title([measureName ' by ' level]); xlabel(level); %axis square;
legend(gca,legendText);
hold off;

%% now plot averages for each trial/block/day
mysubplot(2,3,4);
for trial=1:size(trialData4plot,2)
    %get rid of NaNs
    temp=trialData4plot(:,trial);
    temp(isnan(temp))=[];
    data4plot(trial)=mean(temp);
end
plot(data4plot,':ko','MarkerEdgeColor','k');
title([measureName ' by Trial']); %axis square;

% % mean block data (LRN)
% mysubplot(3,3,5);
% data4plot=mean(blockData4plot);
% plot(data4plot,':ko','MarkerEdgeColor','k'); hold on;
%
% % w/ stderr
% sdev=std(blockData4plot)/sqrt(size(blockData4plot,1));
% data4plot=data4plot+sdev;
% plot(data4plot,'*g');
% data4plot=data4plot-2*sdev;
% plot(data4plot,'*g');
% title([measureName ' by Block']); axis square;
%
% % mean day data (LRN)
% mysubplot(3,3,6);
% data4plot=mean(dayData4plot);
% plot(data4plot,':ko','MarkerEdgeColor','k');
% title([measureName ' by Day']); axis square;
% hold off;

%% to plot LRN against RND block averages
mysubplot(2,3,5); title('LRN vs RND');
data4plot=mean(blockData4plot);
plot(data4plot,':ko','MarkerEdgeColor','k'); hold on;
% w/ stderr
sdev=std(blockData4plot)/sqrt(size(blockData4plot,1));
data4plot=data4plot+sdev;
plot(data4plot,'*g');
data4plot=data4plot-2*sdev;
plot(data4plot,'*g');
title([measureName ' by Block']); %axis square;

for ID=1:dataSizeRND(1)
    for day=1:dataSizeRND(3)
        for block=1:dataSizeRND(4)
            dayOffset=(day-1)*dataSizeRND(4);
            idx=dayOffset+block;
            %clear NaN from data before averaging - lost data XXX
            blockData=squeeze(RND(ID,measure,day,block,:,1)); %grab data
            blockData=reshape(blockData,1,numel(blockData)); %make a single line
            blockData(isnan(blockData))=[]; %get rid of NaNs
            blockData4plot(ID,idx)=mean(blockData);
        end
    end
end
data4plot=mean(blockData4plot);
plot(data4plot,':ko','MarkerEdgeColor','r'); hold on;

% w/ stderr
sdev=std(blockData4plot)/sqrt(size(blockData4plot,1));
data4plot=data4plot+sdev;
%plot(data4plot,'*r');
data4plot=data4plot-2*sdev;
%plot(data4plot,'*r');
title([measureName ' by Block']); axis square;
hold off;

%% to plot LRN against RND day averages
mysubplot(2,3,6);
data4plot=mean(dayData4plot);
%data4plot=zscore(data4plot')';
LRNplot=plot(data4plot,':ko','MarkerEdgeColor','k'); hold on;
sdev=std(dayData4plot)/sqrt(size(dayData4plot,1));
data4plot=data4plot+sdev;
plot(data4plot,'*g');
data4plot=data4plot-2*sdev;
plot(data4plot,'*g');
title([measureName ' by Day']); %axis square;
hold on;

data4plot=[];
%day averages
for ID=1:dataSizeRND(1)
    for day=1:dataSizeRND(3)
        dayData=squeeze(RND(ID,measure,day,:,:,1));
        dayData=reshape(dayData,1,numel(dayData));
        dayData(isnan(dayData))=[];
        dayData4plot(ID,day)=mean(mean(dayData));
    end
end
data4plot=mean(dayData4plot);
%data4plot=zscore(data4plot')';
RNDplot=plot(data4plot,':ko','MarkerEdgeColor','r');
legend([LRNplot RNDplot],'LRN','RND');
hold off;



