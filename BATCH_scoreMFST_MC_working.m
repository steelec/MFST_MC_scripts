load /scr/alaska1/steele/MFST_MC/processing/bx/2013_06_PreprocessedBxData_withCNK.mat
scripts_path='/home/raid1/steele/Documents/Projects/Working/Scripts/MFST/MC_and_Genetics/matlab';
addpath(scripts_path);
cd(scripts_path); %we do this so that any output is put directly into the /pics subdirectory
%restoredefaultpath;
%rehash toolboxcache;
%savepath;

%XXX check out how the means are calculated, this seems like it is
%incorrect. Should be reporting a max for each trial and or block? XXX
[PPs2 CNK_mean CNK_num]=New_Chunks_20140507(PPs,0) %process chunks with visualisation, data out to /pics dir
MFST_MC_plotData2(PPs,1,false,false,10)
MFST_MC_plotData2(PPs,2,false,false,10)

%% now extract the data for LRN and RND for each participant, each trial and then block it for correlational analyses
PPs=PPs2;
days=[1 2 3 4 5 6];
blocks=6;

clear temp
clear out
temp.outBlockMaxSsLRN=[];
temp.outBlockMaxSsRND=[];
temp.outTrialMaxSsLRN=[];
temp.outTrialMaxSsRND=[];

for ID=1:length(PPs.IDs) %loop over subjects
    temp.TrialMaxLRN=[];
    temp.TrialMaxRND=[];
    temp.BlockMaxLRN=[];
    temp.BlockMaxRND=[];
    for day=1:length(days) %loop over days    
        %LRN seq position
        cmd = ['LRNmask = PPs.' PPs.IDs{ID} '.results.d' num2str(day) '.LRNSeqPosn;'];
        eval(cmd);
        
        cmd=['temp.chkLRN=PPs.' PPs.IDs{ID} '.results.d' num2str(day) '.chkLRN;'];
        eval(cmd);
        cmd=['temp.chkRND=PPs.' PPs.IDs{ID} '.results.d' num2str(day) '.chkRND;'];
        eval(cmd);
        
        LRNmask=LRNmask';
        LRNmask=logical(LRNmask(:)); %now in column format, like chkLRN/RND
        
        temp.chkLRN=temp.chkLRN(logical(LRNmask),:);
        temp.chkRND=temp.chkRND(not(logical(LRNmask)),:);

        %trial-wise calculations of maximum chunk
        temp.chkLRN_trialMax=nanmax(temp.chkLRN'); %max number in a chunk for each trial
        temp.chkRND_trialMax=nanmax(temp.chkRND');
        temp.TrialMaxLRN=[temp.TrialMaxLRN temp.chkLRN_trialMax];
        temp.TrialMaxRND=[temp.TrialMaxRND temp.chkRND_trialMax];
        
        
        %blockwise calculation of maximum chunk
        temp.chkLRN_block=reshape(temp.chkLRN_trialMax,length(temp.chkLRN_trialMax)/blocks,blocks)'; %now rows for each block, each trial is a column
        temp.chkRND_block=reshape(temp.chkRND_trialMax,length(temp.chkRND_trialMax)/blocks,blocks)'; %now rows for each block, each trial is a column
        temp.BlockMaxLRN=[temp.BlockMaxLRN max(temp.chkLRN_block,[],2)'];
        temp.BlockMaxRND=[temp.BlockMaxRND max(temp.chkRND_block,[],2)'];

    end
    %block-wise, for all subjects
    temp.outBlockMaxSsLRN=[temp.outBlockMaxSsLRN; temp.BlockMaxLRN];
    temp.outBlockMaxSsRND=[temp.outBlockMaxSsRND; temp.BlockMaxRND];
    %trial-wise, for all subjects
    temp.outTrialMaxSsLRN=[temp.outTrialMaxSsLRN; temp.TrialMaxLRN];
    temp.outTrialMaxSsRND=[temp.outTrialMaxSsRND; temp.TrialMaxRND];
    %size(temp.outTrialMaxSsLRN);
end

figure;
plot(temp.outBlockMaxSsLRN','o:')
hold on; 
errorbar(mean(temp.outBlockMaxSsLRN),std(temp.outBlockMaxSsLRN)/sqrt(size(temp.outBlockMaxSsLRN,1)),'ko-','linewidth',3)
title('Max chunks by block (LRN)');

figure;
plot(temp.outBlockMaxSsRND','o:')
hold on; 
plot(mean(temp.outBlockMaxSsRND),'ko-','linewidth',3)
title('Max chunks by block (RND)');


figure
hold on; plot(temp.outTrialMaxSsLRN','o:')
plot(mean(temp.outTrialMaxSsLRN),'ko-','linewidth',3)
%errorbar(mean(temp.outTrialMaxSsLRN),std(temp.outTrialMaxSsLRN)/sqrt(size(temp.outTrialMaxSsLRN,1)),'ko-','linewidth',3); % adds too much noise to see anything properly
title('Max chunks by trial (LRN)');

figure
plot(temp.outTrialMaxSsRND','o:')
hold on
plot(nanmean(temp.outTrialMaxSsRND),'ko-','linewidth',3)
title('Max chunks by trial (RND)');

%% try to understand what it is that these variables are doing over time
%COR and SYN
figure;
plot3(time2(:,:)',SYN(:,:)',COR(:,:)',':o')
title('COR x SYN x Block 1-36');
figure;
plot3(time2(:,1:6)',SYN(:,1:6)',COR(:,1:6)',':o')
title('COR x SYN x Block 1-6');
figure;
plot3(time2(:,31:36)',SYN(:,31:36)',COR(:,31:36)',':o')
title('COR x SYN x Block 31-36');