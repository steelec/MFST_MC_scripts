load /scr/alaska1/steele/MFST_MC/processing/bx/2013_06_PreprocessedBxData_withCNK.mat
addpath('/home/raid1/steele/Documents/Projects/Working/Scripts/MFST/MC_and_Genetics/matlab')
%restoredefaultpath;
%rehash toolboxcache;
%savepath;

%XXX check out how the means are calculated, this seems like it is
%incorrect. Should be reporting a max for each trial and or block? XXX
[PPs2 CNK_mean CNK_num]=New_Chunks_20140327(PPs,0) %process chunks with visualisation, data out to /pics dir

%% now extract the data for LRN and RND for each participant, each trial and then block it for correlational analyses
PPs=PPs2;
days=[1 2 3 4 5 6];
blocks=6;

clear temp
clear out
temp.outTrialMaxSsLRN=[];
temp.outTrialMaxSsRND=[];

for ID=1:length(PPs.IDs) %loop over subjects
    temp.outTrialMaxLRN=[];
    temp.outTrialMaxRND=[];
    
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

        temp.chkLRN_trialMax=nanmax(temp.chkLRN'); %max number in a chunk for each trial
        temp.chkRND_trialMax=nanmax(temp.chkRND');
        
        temp.chkLRN_block=reshape(temp.chkLRN_trialMax,length(temp.chkLRN_trialMax)/blocks,blocks)'; %now rows for each block, each trial is a column
        temp.chkRND_block=reshape(temp.chkRND_trialMax,length(temp.chkRND_trialMax)/blocks,blocks)'; %now rows for each block, each trial is a column
        temp.outTrialMaxLRN=[temp.outTrialMaxLRN temp.chkLRN_trialMax];
        temp.outTrialMaxRND=[temp.outTrialMaxRND temp.chkRND_trialMax];
    end
    temp.outTrialMaxSsLRN=[temp.outTrialMaxSsLRN; temp.outTrialMaxLRN];
    temp.outTrialMaxSsRND=[temp.outTrialMaxSsRND; temp.outTrialMaxRND];
    %size(temp.outTrialMaxSsLRN);
end
