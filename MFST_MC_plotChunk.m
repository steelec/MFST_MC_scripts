function MFST_MC_plotChunk(PPs,trialSelect,numTrialSelect)
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
%           

if nargin==1
    trialSelect=true;
    numTrialSelect=4;
end

%initialise vars
%calculate size for display
sz=get(0,'screensize');
xloc=round(sz(3)/2)+10;
yloc=5;
xsize=sz(3)-xloc-20;
ysize=sz(4)-30;


%initialise variables and select data
data=PPs.all.data.chunk;

LRN=data.LRN;
RND=data.RND;
dataSizeLRN=size(LRN);
days=dataSizeLRN(2);
blocks=dataSizeLRN(3);
LRNacc=data.LRNacc;
RNDacc=data.RNDacc;


figure; set(gcf,'Name','Chunking Plots','OuterPosition', [xloc yloc xsize ysize]);
%alculate and plot average over each block for the entire group
level='Block';
summaryType='Group';

[m sd n]=MFST_MC_selectChunk(LRN,summaryType,trialSelect,numTrialSelect);
[RNDm RNDsd RNDn]=MFST_MC_selectChunk(RND,summaryType);

mysubplot(2,2,1);
plot(m',':o'); box off;
title(['Chunking by ' level]); ylabel('Synchronisation (ms)'); xlabel('Sequence Element');
%legend(gca,leg);



% Not so useful, replaced with another plot
%set the offset for more readable display
% offset=repmat([0:-50:-(size(m,1)-1)*50]',1,size(m,2));
% plot([m+offset]',':o');
% title(['Chunking by ' level ', offset by -50ms for each block']); xlabel('Sequence Element');

%% calculate and plot group average over each day for the group

level='Day';
summaryType='Group';
legendText={};
for day=1:days
    legendText{day}=['Day ' num2str(day)];
end
%legendText=strrep(PPs.all.IDs(:),'_',' ');
% [m sd n]=MFST_MC_selectChunk(LRN,summaryType); %unecessary, already exists from before

if size(m,1)>days %if there is more than one block of practice per day
    for day=1:days
        count_idx=1+(day-1)*blocks;
        day_m(day,:)=mean(m(count_idx:(count_idx+blocks-1),:));
        RND_day_m(day,:)=mean(RNDm(count_idx:(count_idx+blocks-1),:));
        day_sd(day,:)=mean(sd(count_idx:(count_idx+blocks-1),:));
        day_n(day,:)=mean(n(count_idx:(count_idx+blocks-1),:));
    end
elseif size(m,1)==days
    day_m=m;
    RND_day_m=RNDm;
    day_sd=sd;
    day_n=n;
else
    warning('You must have an equal number of blocks on each day of testing');
end

mysubplot(2,2,2);
%f1=figure('visible','off','name','Chunking');
plot(day_m','-o'); hold on; plot(RND_day_m',':x');
box off;
%title(['Chunking by ' level]); 
ylabel('Synchronisation (ms)','FontSize',18,'FontWeight','Bold'); xlabel('Sequence Element','FontSize',18,'FontWeight','Bold');
%set(gca,'XTick',[1:13],'LineWidth',1,'FontSize',18);
%saveas(f1,'/home/PENHUNE/MFST_MC/processing/bx/pilot/Chunk.eps','psc2');
%legend(gca,leg);

%set the offset for more readable display
offset=repmat([0:-50:-(size(day_m,1)-1)*50]',1,size(m,2));



mysubplot(2,2,3);
plot([day_m+offset]','-o'); hold on; plot([RND_day_m+offset]',':x');
title(['Chunking by ' level ', offset by -50ms for each day']); xlabel('Sequence Element');

% SD data
data4plot=day_m+offset+day_sd./sqrt(day_n);
plot(data4plot','*g');
data4plot=day_m+offset-day_sd./sqrt(day_n);
plot(data4plot','*g');
box off;
hold off;

%plot the element-wise accuracy with the chunking RTs
mysubplot(2,2,4);

for day=1:days
    LRNdata(day,:)=mean(squeeze(mean(squeeze(PPs.all.data.chunk.LRNacc(:,day,:,:)),1)),1);
    RNDdata(day,:)=mean(squeeze(mean(squeeze(PPs.all.data.chunk.RNDacc(:,day,:,:)),1)),1);
end
plot(LRNdata','-o'); hold on;
plot(RNDdata',':x');
title('Accuracy of Each Sequence Element (all 10 trials)'); xlabel('Sequence Element'); ylabel('Proportion Correct');
legend(gca,legendText);
box off;
hold off;
