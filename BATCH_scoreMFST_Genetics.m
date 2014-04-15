%% Batch scoring for MFST_Genetics
%
%
% Requires that the sequences structure has been created with
% gen13ElementSeqs (note that this generates a particular set of sequences
% based on particular random seed - for Chris' MFST_MC experiment the seed
% was 19750909

% %setup basic path information

addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/'); %path to the scoring scripts
dataDir='/scr/alaska1/steele/Projects/Working/MFST_Genetics/source/bx/pilot/';

%initialise vars for creation of xml file.
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment - essentially hard-coded b/c this is the first sequence slot available after the two familiarisation sequences
stimDuration=300;
isi=200;
WRITEFLAG=1; %output xml to file in dataDir, or not {0,1}



% setup basic information for data structure
[scoring_seq allSeq]=gen13ElementSeqs(LRNSeqID,stimDuration,isi,WRITEFLAG,dataDir);
PPs.stimuli=scoring_seq;
PPs.date=date;
PPs.time=clock;
PPs.name='PPs';


kc=zeros(length(allSeq),1);
%check kolmogorov complexity
for count=1:length(allSeq)
    kc(count)=kolmogorov(allSeq(count,:));
end

hist(kc);
%some have kc of ~2.56 (about 200) and some of ~2.2 (about 300)
% sequence 1 is 2.56 and 241 and 197 (LRN2 and LRN3) are both 2.2

clear WRITEFLAG;

% now need to add LRN2 and LRN3 into d3d4 and d5d6 respectively
% do this now by replacing all entries in PPs.stimuli.scoring (d4-5) that
% refer to the first LRN sequence with the 2nd
% these two sequences have one number in common (the 2 right in the middle)
% but do not overlap with LRN1 (LRN1_idx=1)

LRN1_idx=1; %2 in xml file
LRN2_idx=197; %idx in allSeq that is the LRN2 sequence (198 in xml file)
LRN3_idx=241; % 242 in the xml file
LRN4_idx=330; % 331 in xml file
LRN5_idx=55;  % 56 in xml file

PPs.stimuli.scoring.d3b1(PPs.stimuli.id.d3b1==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d3b2(PPs.stimuli.id.d3b2==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d3b3(PPs.stimuli.id.d3b3==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d3b4(PPs.stimuli.id.d3b4==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d3b5(PPs.stimuli.id.d3b5==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d3b6(PPs.stimuli.id.d3b6==2,:)=repmat(allSeq(LRN2_idx,:),10,1);

PPs.stimuli.scoring.d4b1(PPs.stimuli.id.d4b1==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d4b2(PPs.stimuli.id.d4b2==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d4b3(PPs.stimuli.id.d4b3==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d4b4(PPs.stimuli.id.d4b4==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d4b5(PPs.stimuli.id.d4b5==2,:)=repmat(allSeq(LRN2_idx,:),10,1);
PPs.stimuli.scoring.d4b6(PPs.stimuli.id.d4b6==2,:)=repmat(allSeq(LRN2_idx,:),10,1);

PPs.stimuli.scoring.d5b1(PPs.stimuli.id.d5b1==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d5b2(PPs.stimuli.id.d5b2==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d5b3(PPs.stimuli.id.d5b3==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d5b4(PPs.stimuli.id.d5b4==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d5b5(PPs.stimuli.id.d5b5==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d5b6(PPs.stimuli.id.d5b6==2,:)=repmat(allSeq(LRN3_idx,:),10,1);

PPs.stimuli.scoring.d6b1(PPs.stimuli.id.d6b1==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d6b2(PPs.stimuli.id.d6b2==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d6b3(PPs.stimuli.id.d6b3==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d6b4(PPs.stimuli.id.d6b4==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d6b5(PPs.stimuli.id.d6b5==2,:)=repmat(allSeq(LRN3_idx,:),10,1);
PPs.stimuli.scoring.d6b6(PPs.stimuli.id.d6b6==2,:)=repmat(allSeq(LRN3_idx,:),10,1);


PPs.stimuli.scoring.d7b1(PPs.stimuli.id.d7b1==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d7b2(PPs.stimuli.id.d7b2==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d7b3(PPs.stimuli.id.d7b3==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d7b4(PPs.stimuli.id.d7b4==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d7b5(PPs.stimuli.id.d7b5==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d7b6(PPs.stimuli.id.d7b6==2,:)=repmat(allSeq(LRN4_idx,:),10,1);

PPs.stimuli.scoring.d8b1(PPs.stimuli.id.d8b1==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d8b2(PPs.stimuli.id.d8b2==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d8b3(PPs.stimuli.id.d8b3==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d8b4(PPs.stimuli.id.d8b4==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d8b5(PPs.stimuli.id.d8b5==2,:)=repmat(allSeq(LRN4_idx,:),10,1);
PPs.stimuli.scoring.d8b6(PPs.stimuli.id.d8b6==2,:)=repmat(allSeq(LRN4_idx,:),10,1);

PPs.stimuli.scoring.d9b1(PPs.stimuli.id.d9b1==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d9b2(PPs.stimuli.id.d9b2==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d9b3(PPs.stimuli.id.d9b3==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d9b4(PPs.stimuli.id.d9b4==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d9b5(PPs.stimuli.id.d9b5==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d9b6(PPs.stimuli.id.d9b6==2,:)=repmat(allSeq(LRN5_idx,:),10,1);

PPs.stimuli.scoring.d10b1(PPs.stimuli.id.d10b1==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d10b2(PPs.stimuli.id.d10b2==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d10b3(PPs.stimuli.id.d10b3==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d10b4(PPs.stimuli.id.d10b4==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d10b5(PPs.stimuli.id.d10b5==2,:)=repmat(allSeq(LRN5_idx,:),10,1);
PPs.stimuli.scoring.d10b6(PPs.stimuli.id.d10b6==2,:)=repmat(allSeq(LRN5_idx,:),10,1);



% XXX 
% and now replace the RND that was presented once as LRN4? XXX
% THIS SHOULD BE DONE AFTER YOU RUN THE PARTICIPANTS FROM PILOT2 THROUGH
% THE ADDITIONAL TWO DAYS OF THE TASK (bilat tDCS and sham bilat)
% XXX

%add in the RND blocks that bracket each 2-day set of LRN sequences
PPs.stimuli.scoring.d1famil1=allSeq(146:155,:);
PPs.stimuli.scoring.d2famil1=allSeq(156:165,:);
PPs.stimuli.scoring.d3famil1=allSeq(166:175,:);
PPs.stimuli.scoring.d4famil1=allSeq(176:185,:);
PPs.stimuli.scoring.d5famil1=allSeq(186:195,:);
PPs.stimuli.scoring.d6famil1=allSeq([196 206 198:205],:);
% now these RND count from the end of the possible sequences to make the
% counting a bit easier :( 
% forgot the offset when adding this to the config file, so these numbers
% do not include the final trial (496) as it is indexed as 497 in the xml
% file
PPs.stimuli.scoring.d7famil1=allSeq(486:495,:);
PPs.stimuli.scoring.d8famil1=allSeq(476:485,:);
PPs.stimuli.scoring.d9famil1=allSeq(466:475,:);
PPs.stimuli.scoring.d10famil1=allSeq(456:465,:);


% the RND sequences are off from d7 onwards (b/c I added 6 10-trial blocks of random for "famil" trials
% this needs to be corrected in stimuli.id and stimuli.scoring 
PPs.stimuli.scoring.d7b1(PPs.stimuli.id.d7b1~=2,:)=allSeq(207:210,:);
PPs.stimuli.scoring.d7b2(PPs.stimuli.id.d7b2~=2,:)=allSeq(211:214,:);
PPs.stimuli.scoring.d7b3(PPs.stimuli.id.d7b3~=2,:)=allSeq(215:218,:);
PPs.stimuli.scoring.d7b4(PPs.stimuli.id.d7b4~=2,:)=allSeq(219:222,:);
PPs.stimuli.scoring.d7b5(PPs.stimuli.id.d7b5~=2,:)=allSeq(223:226,:);
PPs.stimuli.scoring.d7b6(PPs.stimuli.id.d7b6~=2,:)=allSeq(227:230,:);

PPs.stimuli.scoring.d8b1(PPs.stimuli.id.d8b1~=2,:)=allSeq(231:234,:);
PPs.stimuli.scoring.d8b2(PPs.stimuli.id.d8b2~=2,:)=allSeq(235:238,:);
PPs.stimuli.scoring.d8b3(PPs.stimuli.id.d8b3~=2,:)=allSeq([239,240,242,243],:); %sequence 241 is a LRN sequence, skip it here
PPs.stimuli.scoring.d8b4(PPs.stimuli.id.d8b4~=2,:)=allSeq(244:247,:);
PPs.stimuli.scoring.d8b5(PPs.stimuli.id.d8b5~=2,:)=allSeq(248:251,:);
PPs.stimuli.scoring.d8b6(PPs.stimuli.id.d8b6~=2,:)=allSeq(252:255,:);

PPs.stimuli.scoring.d9b1(PPs.stimuli.id.d9b1~=2,:)=allSeq(256:259,:);
PPs.stimuli.scoring.d9b2(PPs.stimuli.id.d9b2~=2,:)=allSeq(260:263,:);
PPs.stimuli.scoring.d9b3(PPs.stimuli.id.d9b3~=2,:)=allSeq(264:267,:);
PPs.stimuli.scoring.d9b4(PPs.stimuli.id.d9b4~=2,:)=allSeq(268:271,:);
PPs.stimuli.scoring.d9b5(PPs.stimuli.id.d9b5~=2,:)=allSeq(272:275,:);
PPs.stimuli.scoring.d9b6(PPs.stimuli.id.d9b6~=2,:)=allSeq(276:279,:);

PPs.stimuli.scoring.d10b1(PPs.stimuli.id.d10b1~=2,:)=allSeq(280:283,:);
PPs.stimuli.scoring.d10b2(PPs.stimuli.id.d10b2~=2,:)=allSeq(284:287,:);
PPs.stimuli.scoring.d10b3(PPs.stimuli.id.d10b3~=2,:)=allSeq(288:291,:);
PPs.stimuli.scoring.d10b4(PPs.stimuli.id.d10b4~=2,:)=allSeq(292:295,:);
PPs.stimuli.scoring.d10b5(PPs.stimuli.id.d10b5~=2,:)=allSeq(296:299,:);
PPs.stimuli.scoring.d10b6(PPs.stimuli.id.d10b6~=2,:)=allSeq(300:303,:);

%save('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/2013_03_MFST_Genetics_ScoringSetup_FINAL.mat');

%% the code here was used to figure out which sequences to use as LRN2... LRN5
% basically I tried to ensure that the sequences were as different as
% possible by checking to see which ones had the same fingerpresses in
% the same position(s) within the sequence. There is some overlap, but it
% is minimised and *should* be restricted to a single key without having
% two consecutive keys repeated across 2 sequences (that is definitely the
% case for LRN4 and LRN5, should also be the case for LRN1,2,3

a=[];
a(:,1)=sum(abs(allSeq(1:496,:)-repmat(allSeq(1,:),496,1)),2); %subtract all from first sequence, sum the abs value to find those that are farthest
a(:,2)=sum(abs(allSeq(1:496,:)-repmat(allSeq(LRN2_idx,:),496,1)),2);
a(:,3)=sum(abs(allSeq(1:496,:)-repmat(allSeq(LRN3_idx,:),496,1)),2);
%a(:,4)=min(sum(a,2)); %the sequences that show the least similarity to the three that are already chosen (all =42, which means that these first three sequences are as dissimilar as possible

b=[allSeq(1,:); allSeq(LRN2_idx,:);allSeq(LRN3_idx,:)]

c=allSeq(a(:,2)>20 & allSeq(:,1)==3,:); %all sequences where LRN2 has little similarity that start with 3 (the last number that we have not yet started with

d=[];
for idx=1:size(c,1)
    temp=[allSeq(1,:) - c(idx,:) ; allSeq(LRN2_idx,:) - c(idx,:) ;allSeq(LRN3_idx,:) - c(idx,:)];
    d=[d;temp; zeros(1,13)*NaN];
    e(idx)=sum(sum(temp'==0));
end

%checked this, the 4th row in b has the least similarity (least number of
%keys that are in the same positions in the sequence as those of the other
%sequences, no two in a row

c(4,:)
%this provides the index (330)
[bob1 bob]=ismember(allSeq,c(4,:),'rows');
find(bob==1)

LRN4_idx=330;
%now do the same thing for the 5th sequence! :(
b=[allSeq(1,:); allSeq(LRN2_idx,:);allSeq(LRN3_idx,:);allSeq(LRN4_idx,:)]
a(:,4)=sum(abs(allSeq(1:496,:)-repmat(allSeq(LRN4_idx,:),496,1)),2);
a(:,5)=sum(a,2); %5th column now has the sums of these sequences (i.e., the largest differences over all four sequences (or a close approximation))

c=allSeq(a(:,5)>73,:); %highest number of diffs (used max() to find it)

d=[];
e=[];
for idx=1:size(c,1)
    temp=[allSeq(1,:) - c(idx,:) ; allSeq(LRN2_idx,:) - c(idx,:) ;allSeq(LRN3_idx,:) - c(idx,:);allSeq(LRN4_idx,:) - c(idx,:)];
    d=[d;temp; zeros(1,13)*NaN];
    e(idx)=sum(sum(temp'==0));
end

%checked this, and chose the one that had the least similarity AND did not
%have two keys that were in the same position as any of the other sequences

c(2,:)
%this provides the index (55) <------------------------- SHIT! This means
%that they have actually seent his sequence once before.... This will need
%to be corrected for future studies
[bob1 bob]=ismember(allSeq,c(2,:),'rows');
find(bob==1)

LRN_idx5=55;


% a=allSeq(1:496,:)-repmat(allSeq(175,:),496,1)
% b(:,3)=sum(a'==0)'
% a=allSeq(1:496,:)-repmat(allSeq(183,:),496,1)
% b(:,4)=sum(a'==0)'
% a=allSeq(1:496,:)-repmat(allSeq(197,:),496,1)
% b(:,5)=sum(a'==0)'
% a=allSeq(1:496,:)-repmat(allSeq(216,:),496,1)
% b(:,6)=sum(a'==0)'
% a=allSeq(1:496,:)-repmat(allSeq(217,:),496,1)
% b(:,7)=sum(a'==0)'
% a=allSeq(1:496,:)-repmat(allSeq(241,:),496,1)
% b(:,8)=sum(a'==0)'
% c=sum(b')'
% c==13
% b(c==13,:)
% allSeq(c==13,:)
% allSeq(c==14,:)
% allSeq(c==15,:)
% allSeq(c<15,:)
% allSeq(c<14,:)
% allSeq(c<13,:)
% allSeq(c<12,:)
% allSeq(c<16,:)
% allSeq(c<15,:)
% allSeq(241,:)
% allSeq(197,:)
% b
% c
% c=sum(b'==0)'
% freqnum(c)
% freqnum(c')
% plot(c)
% allSeq(105,:)-allSeq(307,:)
% allSeq(397,:)-allSeq(168,:)
% allSeq(397,:)-allSeq(197,:)
% allSeq(397,:)-allSeq(241,:)
% allSeq(1,:)-allSeq(241,:)
% allSeq(1,:)-allSeq(307,:)
% allSeq(168,:)-allSeq(307,:)
% allSeq(197,:)-allSeq(307,:)
% allSeq(216,:)-allSeq(307,:)
% allSeq([168 197 216 241],:)
% allSeq([168 197 216 241 307],:)
% allSeq(197,:)-allSeq(307,:)
% allSeq(168,:)-allSeq(307,:)
% allSeq(168,:)-allSeq(197,:)

%% for the 2nd pilot where 2 sequences were used, 9 subjects, and each sequence bracketed by a block of random trials
% % setup basic path information
% this workspace contains a variable called "allsSeq" which contains all of
% the possible sequences, starting from 1 (LRN1) which is index 2 for
% scoring and use in configurations xml file.

addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/'); %path to the scoring scripts

load('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/2013_03_MFST_Genetics_ScoringSetup_FINAL.mat');
dataDir='/scr/alaska1/steele/Projects/Working/MFST_Genetics/source/bx/pilot2';

IDs={'Pilot01' 'Pilot02' 'Pilot03' 'Pilot04' 'Pilot05' 'Pilot06' 'Pilot07' 'Pilot08' 'Pilot09'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']
%IDs={'Pilot03' 'Pilot06' 'Pilot07' 'Pilot09'}; %ids of those who completed an extra 2 sequences (4 more days) with bilateral m1 stim vs sham
PPs.IDs=IDs;

% create and save tDCS stimulation matrix in data structure
% 0 1 2
% no-stim, bilat m1 1mA, bilat m1 sham
% ordered by numerical ID, listed for each sequence (LRN1..4)
PPs.tDCS.measures={'0 = no stimulation' '1 = bilateral m1 1mA' '2 = bilateral m1 sham'};
PPs.tDCS.schedule=[
    0 0 1 2;
    0 0 1 2;
    0 0 2 1;
    0 0 1 2;
    ];



%Pilot03 does not have ANY data collected for d1, change below

%'Pilot05' has no d2b1 file... check original?
% this data does not appear to have been collected, copying and renaming
% d1b1 here for a quick "fix" for the moment

% Pilot06 is missing a single trial at the end of d6b2
% replaced last trial with last trial of previous block (d6b1)
%
%

%'Pilot08' has something wrong with their d4b5 file
% the program hiccuped, skipped a trial, and printed it during the next trial trial in the wrong place (and did not
% collect the final one) - all shifted, so removed the empty trial and
% tacked on an extra response at the end from previous block's response
% (d4b4)


days=4;
blocks=6;
famil_blocks=1; %number of "famil" blocks presented each day (i.e., full block of 10 RND sequences)
stimDuration = 300; %duration of the stimulus
beforeTrialDelay = 200; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses

%use a new way of selecting sequence ID b/c we presented two different
%types of seqeunces during the experiment (4th and 5th days are the second
%ID)
% modifided MFST_MC_prepareData to take account of this change
LRNSeqID=[2]; %set the index for the location (0-based) of the LRN sequence used in this experiment (NOTE: this still scores the three different LRN sequences correctly b/c of how they were setup in PPs.stimuli.scoring


doTFR=false; % don't look at any transfer sequences
doJerk=false; % don't try to calculate jerk? (you jerk!)
trialSelect=false; % don't select a subset of LRN trials for averages/plotting, use them all
numTrialSelect=4; %number of trials to select if necessary (only curre  ntly supports 4) (NOTE: if trialSelect=false this number does not matter)


PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);
PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,doTFR,doJerk); % for scoring into a single variable

% Now do the same scoring setup for the famil blocks (10 trials of RND
% before or after training on each day)
PPs=MFST_MC_prepareRNDblockData(dataDir,PPs,IDs,days,famil_blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);
PPs=MFST_MC_scoreRNDblockDataMatrix2(PPs,IDs,days,famil_blocks); % for scoring into a single variable

%fix Pilot03_d1 b1-b6 b/c no data was collected
%first loop through the PIDs to find which one to remove
theID=NaN;
for ID=1:length(IDs)
    if sum(PPs.IDs{ID}=='Pilot03')==7
        theID=ID;
    end
end
%now set the data to NaN
PPs.all.data.LRN(theID,:,1,:,:,:)=NaN;
PPs.all.data.famil(theID,:,1,:,:,:)=NaN;
clear ID theID

MFST_MC_plotData2(PPs,1,doTFR,trialSelect,numTrialSelect);
MFST_MC_plotData2(PPs,2,doTFR,trialSelect,numTrialSelect);

%save('/scr/alaska1/steele/Projects/Working/MFST_Genetics/processing/bx/2013_03_MFST_Genetics_Pilot2.mat');

%% PILOT3 data that was collected primarily by Elli K, with help from Chris S
% This data was properly collected and had LM1 anode and RM1 cathode or
% sham, within-subjects design with 10 pilots (2 days of training per
% condition)
addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/'); %path to the scoring scripts

%load('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/2013_03_MFST_Genetics_ScoringSetup_FINAL.mat');
load('/home/raid1/steele/Documents/Projects/Working/Scripts/MFST/MC_and_Genetics/matlab/2013_03_MFST_Genetics_ScoringSetup_FINAL.mat')
dataDir='/scr/alaska1/steele/Projects/Working/MFST_Genetics/source/bx/pilot3';

IDs={'Pilot10' 'Pilot11' 'Pilot12' 'Pilot13' 'Pilot14' 'Pilot15' 'Pilot16' 'Pilot17' 'Pilot18' 'Pilot19' 'Pilot20'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']
IDs={'Pilot10' 'Pilot11' 'Pilot12' 'Pilot13' 'Pilot14' 'Pilot15' 'Pilot16' 'Pilot17' 'Pilot18' 'Pilot19' 'Pilot20' 'Pilot22' 'Pilot23' 'Pilot24'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']

%Pilot21 withdrew

%IDs([2,10])=[]; % participants who do not learn across the course of the experiment, either with or without tDCS

PPs.IDs=IDs;

%Pilot08 d3b6 was partially done twice (?)
%Pilot19_d4b5 - trial 12 had no data, copied over it with trial 13

% create and save tDCS stimulation matrix in data structure
% 0 1 2
% no-stim, bilat m1 1mA, bilat m1 sham
% ordered by numerical ID, listed for each sequence (LRN1..4)
PPs.tDCS.measures={'0 = no stimulation' '1 = bilateral m1 1mA' '2 = bilateral m1 sham'};
PPs.tDCS.schedule=[
    2,1;
    2,1;
    1,2;
    2,1;
    1,2;
    2,1;
    1,2;
    2,1;
    2,1;
    1,2;
    2,1;
    1,2;
    1,2;
    1,2;]
   



%Pilot03 does not have ANY data collected for d1, change below

%'Pilot05' has no d2b1 file... check original?
% this data does not appear to have been collected, copying and renaming
% d1b1 here for a quick "fix" for the moment

% Pilot06 is missing a single trial at the end of d6b2
% replaced last trial with last trial of previous block (d6b1)
%
%

%'Pilot08' has something wrong with their d4b5 file
% the program hiccuped, skipped a trial, and printed it during the next trial trial in the wrong place (and did not
% collect the final one) - all shifted, so removed the empty trial and
% tacked on an extra response at the end from previous block's response
% (d4b4)


days=4;
blocks=6;
famil_blocks=1; %number of "famil" blocks presented each day (i.e., full block of 10 RND sequences)
stimDuration = 300; %duration of the stimulus
beforeTrialDelay = 200; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses

%use a new way of selecting sequence ID b/c we presented two different
%types of seqeunces during the experiment (4th and 5th days are the second
%ID)
% modifided MFST_MC_prepareData to take account of this change
LRNSeqID=[2]; %set the index for the location (0-based) of the LRN sequence used in this experiment (NOTE: this still scores the three different LRN sequences correctly b/c of how they were setup in PPs.stimuli.scoring


doTFR=false; % don't look at any transfer sequences
doJerk=false; % don't try to calculate jerk? (you jerk!)
trialSelect=false; % don't select a subset of LRN trials for averages/plotting, use them all
numTrialSelect=4; %number of trials to select if necessary (only curre  ntly supports 4) (NOTE: if trialSelect=false this number does not matter)


PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);
PPs=MFST_MC_prepareRNDblockData(dataDir,PPs,IDs,days,famil_blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);

PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,doTFR,doJerk); % for scoring into a single variable
PPs=MFST_MC_scoreRNDblockDataMatrix2(PPs,IDs,days,famil_blocks); % for scoring into a single variable


MFST_MC_plotData2(PPs,1,doTFR,trialSelect,numTrialSelect);
MFST_MC_plotData2(PPs,2,doTFR,trialSelect,numTrialSelect);

%save('/scr/alaska1/steele/Projects/Working/MFST_Genetics/processing/bx/2013_07_MFST_Genetics_Pilot3.mat');
%fprintf('The scored data has been saved to: %s\n','/scr/alaska1/steele/Projects/Working/MFST_Genetics/processing/bx/2013_03_MFST_Genetics_Pilot3.mat');

%% Working with Pilot3 data, norming it so that we can compare the two sets of days (1-2 without stim, to 3-4 with)
addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/'); %path to the scoring scripts

load('/scr/alaska1/steele/Projects/Working/MFST_Genetics/processing/bx/2013_07_MFST_Genetics_Pilot3.mat');

[CORm CORsd CORn]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[SYNm SYNsd SYNn]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[rCORm rCORsd rCORn]=MFST_MC_selectData(PPs.all.data.RND,1,'Individual','Block',false);
[rSYNm rSYNsd rSYNn]=MFST_MC_selectData(PPs.all.data.RND,2,'Individual','Block',false);

[fCORm fCORsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);
[fSYNm fSYNsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);

clear Fn;

%hadShamFirst=logical([1 1 0 1 0 1 0 0 1 0 1]);

SI=100*CORm./SYNm; % repeated LRN sequences SI
rSI=100*rCORm./rSYNm; %rand sequences SI
fSI=100*fCORm./fSYNm; %famil SI 

%coefficient of variation
%checked this, doesn't seem to add any useful information (March 15, 2013)
CORcv=CORsd./CORm;
SYNcv=SYNsd./SYNm;
rCORcv=rCORsd./rCORm;
rSYNcv=rSYNsd./rSYNm;
fCORcv=fCORsd./fCORm;
fSYNcv=fSYNsd./fSYNm;

% plot the RAW data with each block of data and the bracketing RND data
figure('name','LRN sequence performance by block bracketed by RND famil blocks');
%total blocks over the experiment
total_blocks=days*blocks+days;

x=1:total_blocks; %total number of blocks presented over experiment
Lx=logical([0 ones(1,12) 0 0 ones(1,12) 0]); %denote which blocks are famil1 blocks and which are the standard learning blocks
if total_blocks==56
    Lx=[Lx Lx];
end

%COR
subplot(2,1,1); hold on; box off;
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);
Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');
ylabel('COR (%)');
%SYN
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);
subplot(2,1,2); hold on; box off;
Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');
xlabel('Block');ylabel('SYN (ms)');
hold off;

%create a summary measure for the amount of "learning" on RND
for ID = 1:length(PPs.IDs)
    fCORchg(ID,:) = [fCORm(ID,4)-fCORm(ID,1)];
    fSYNchg(ID,:) = [fSYNm(ID,1)-fSYNm(ID,4)]; %this is a reverse measure, so reverse it here too
end

%now we need to swap the days around so that the day with 1mA stimulation
%comes on the 3rd day in this sample
%uses PPs.tDCS.schedule
for ID=1:length(PPs.IDs)
    if PPs.tDCS.schedule(ID,1)==1 %if the first sequence was with active tDCS, move to the 2nd sequence
        tDCSdata=SI(ID,1:12);
        SI(ID,1:12)=SI(ID,13:24);
        SI(ID,13:24)=tDCSdata;

        tDCSdata=rSI(ID,1:12);
        rSI(ID,1:12)=rSI(ID,13:24);
        rSI(ID,13:24)=tDCSdata;

        tDCSdata=CORm(ID,1:12);
        CORm(ID,1:12)=CORm(ID,13:24);
        CORm(ID,13:24)=tDCSdata;

        tDCSdata=rCORm(ID,1:12);
        rCORm(ID,1:12)=rCORm(ID,13:24);
        rCORm(ID,13:24)=tDCSdata;

        tDCSdata=SYNm(ID,1:12);
        SYNm(ID,1:12)=SYNm(ID,13:24);
        SYNm(ID,13:24)=tDCSdata;

        tDCSdata=rSYNm(ID,1:12);
        rSYNm(ID,1:12)=rSYNm(ID,13:24);
        rSYNm(ID,13:24)=tDCSdata;
                      
        %now for famil blocks
        tDCSdata=fSI(ID,1:2);
        fSI(ID,1:2)=fSI(ID,3:4);
        fSI(ID,3:4)=tDCSdata;
        
        tDCSdata=fCORm(ID,1:2);
        fCORm(ID,1:2)=fCORm(ID,3:4);
        fCORm(ID,3:4)=tDCSdata;
        
        tDCSdata=fSYNm(ID,1:2);
        fSYNm(ID,1:2)=fSYNm(ID,3:4);
        fSYNm(ID,3:4)=tDCSdata;
        
        clear tDCSdata;
        fprintf('---> Subject ID: %s had tDCS stim data moved from d1 (sham) to d2 (1mA).\n',PPs.IDs{ID});
    end
    fprintf('\n');
end

%now do some cool plotting

% COR plot
temp.v1=CORm;
temp.v2=fCORm;
temp.v3=rCORm;

figure('name', 'COR for LRN vs RND across blocks'); box off;
subplot(3,1,1); hold on;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;

for ID = 1:length(IDs)
    temp.v1(ID,1:12) = temp.v1(ID,1:12)-(temp.v2(ID,2)-temp.v2(ID,1));
    temp.v1(ID,13:24) = temp.v1(ID,13:24)-(temp.v2(ID,4)-temp.v2(ID,3));
end

subplot(3,1,2); hold on;
title('Remove the effect of increases through familiarisation');
%plot(temp.v1'); 
plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);

temp.v1=CORm;
temp.v2=fCORm;
temp.v3=rCORm;

subplot(3,1,3); hold on;
title('Normalise performance to 1st RND block performance for each sequence');
temp.sham = temp.v1(:,1:12);
temp.stim = temp.v1(:,13:24);

for ID = 1:length(IDs)
	temp.sham(ID,:) = temp.sham(ID,:)./temp.v2(ID,1); %divide by the first day of the manip's RND block performance
    temp.stim(ID,:) = temp.stim(ID,:)./temp.v2(ID,3); %divide by the first day of the manip's RND block perforamnce
%     temp.sham(ID,:) = temp.sham(ID,:)-fCORchg(ID); 
%     temp.stim(ID,:) = temp.stim(ID,:)-fCORchg(ID); 
end
plot([1:12], nanmean(temp.sham,1),'ko-','markersize',8,'linewidth',2); %sham in black
plot([1:12], nanmean(temp.stim,1),'ro-','markersize',8,'linewidth',2); %stim in red


% SYN plot
temp.v1=SYNm;
temp.v2=fSYNm;
temp.v3=rSYNm;

figure('name', 'SYN for LRN vs RND across blocks'); box off;
subplot(3,1,1); hold on;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;

for ID = 1:length(IDs)-1
    temp.v1(ID,1:12) = temp.v1(ID,1:12)-(temp.v2(ID,2)-temp.v2(ID,1));
    temp.v1(ID,13:24) = temp.v1(ID,13:24)-(temp.v2(ID,4)-temp.v2(ID,3));
end

subplot(3,1,2); hold on;
title('Remove the effect of increases through familiarisation');
%plot(temp.v1'); 
plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);

temp.v1=SYNm;
temp.v2=fSYNm;
temp.v3=rSYNm;

subplot(3,1,3); hold on;
title('Normalise performance to 1st RND block performance for each sequence');
temp.sham = temp.v1(:,1:12);
temp.stim = temp.v1(:,13:24);

for ID = 1:length(IDs)
     temp.sham(ID,:) = temp.sham(ID,:)./temp.v2(ID,1); %divide by the first day of the manip's RND block performance
     temp.stim(ID,:) = temp.stim(ID,:)./temp.v2(ID,3); %divide by the first day of the manip's RND block perforamnce
%     temp.sham(ID,:) = temp.sham(ID,:)-fSYNchg(ID); 
%     temp.stim(ID,:) = temp.stim(ID,:)-fSYNchg(ID); 
end
plot([1:12], nanmean(temp.sham,1),'ko-','markersize',8,'linewidth',2); %sham in black
plot(temp.sham','kx:');
plot([1:12], nanmean(temp.stim,1),'ro-','markersize',8,'linewidth',2); %stim in red
plot(temp.stim','rx:');

% SI plot
temp.v1=SI;
temp.v2=fSI;
temp.v3=rSI;

figure('name', 'Skill Index (SI) for LRN vs RND across blocks'); 
subplot(3,1,1); hold on; box off;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;
for ID = 1:length(IDs)
    temp.v1(ID,1:12) = temp.v1(ID,1:12)-(temp.v2(ID,2)-temp.v2(ID,1));
    temp.v1(ID,13:24) = temp.v1(ID,13:24)-(temp.v2(ID,4)-temp.v2(ID,3));
end

subplot(3,1,2); hold on;
title('Remove the effect of increases through familiarisation');
%plot(temp.v1'); 
plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);

temp.v1=SI;
temp.v2=fSI;
temp.v3=rSI;

subplot(3,1,3); hold on;
title('Normalise performance to 1st RND block performance for each sequence');
temp.sham = temp.v1(:,1:12);
temp.stim = temp.v1(:,13:24);

for ID = 1:length(IDs)
	temp.sham(ID,:) = temp.sham(ID,:)./temp.v2(ID,1); %divide by the first day of the manip's RND block performance
    temp.stim(ID,:) = temp.stim(ID,:)./temp.v2(ID,3); %divide by the first day of the manip's RND block perforamnce
end
plot([1:12], nanmean(temp.sham,1),'ko-','markersize',8,'linewidth',2); %sham in black
plot([1:12], nanmean(temp.stim,1),'ro-','markersize',8,'linewidth',2); %stim in red

%% Pilot 3 - look at trial raw data
[CORm CORsd CORn]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Trial',false);
[rCORm rCORsd rCORn]=MFST_MC_selectData(PPs.all.data.RND,1,'Individual','Trial',false);

[SYNm SYNsd SYNn]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Trial',false);
[rSYNm rSYNsd rSYNn]=MFST_MC_selectData(PPs.all.data.RND,2,'Individual','Trial',false);

for ID=1:length(PPs.IDs)
    if PPs.tDCS.schedule(ID,1)==1 %if the first sequence was with active tDCS, move to the 2nd sequence
        tDCSdata=SYNm(:,1:120); %grab the 120 trials of LRN from the 1mA session
        SYNm(:,1:120)=SYNm(:,121:240);
        SYNm(:,121:240)=tDCSdata;
        
        tDCSdata=rSYNm(:,1:48); %grab the 120 trials of LRN from the 1mA session
        rSYNm(:,1:48)=rSYNm(:,49:96);
        rSYNm(:,49:96)=tDCSdata;
        
        tDCSdata=CORm(:,1:120); %grab the 120 trials of LRN from the 1mA session
        CORm(:,1:120)=CORm(:,121:240);
        CORm(:,121:240)=tDCSdata;
        
        tDCSdata=rCORm(:,1:48); %grab the 120 trials of LRN from the 1mA session
        rCORm(:,1:48)=rCORm(:,49:96);
        rCORm(:,49:96)=tDCSdata;
        
        fprintf('---> Subject ID: %s had tDCS stim data moved from d1 (sham) to d2 (1mA).\n',PPs.IDs{ID});
    end
end
clear tDCSdata;

figure('name','Mean SYN for LRN trials for sham (black) and stim (red)');
hold on
plot(nanmean(SYNm(:,1:120)),'ko-');
%plot(nanmean(rSYNm(:,1:48)),'bx-');
plot(nanmean(SYNm(:,121:240)),'ro-');
%plot(nanmean(rSYNm(:,49:96)),'gs-');

figure('name','Mean COR for LRN trials for sham (black) and stim (red)');
hold on
plot(nanmean(CORm(:,1:120)),'ko-');
%plot(nanmean(rCORm(:,1:48)),'bx-');
plot(nanmean(CORm(:,121:240)),'ro-');
%plot(nanmean(rCORm(:,49:96)),'gs-');

%replace NaNs with something that can be used in an analysis
SYNm_corrected=SYNm;
for id=1:length(IDs)
    for block = 1:6
        start=(block-1)*10+1
        stop=start+9
        SYNm(id,isnan(SYNm(id,:)))=mean(SYNm(id,start:stop));
    end
end

%% create data format for input to SPSS for linear mixed modeling (LRN trials)
trials_per_block=10;
blocks_per_day = 6;
days_per_experiment = 2;
days_per_condition = 2;

trials=repmat(1:trials_per_block,1,blocks_per_day*days_per_condition*days_per_experiment);

blocks=[];

%blocks for each day
for idx=1:blocks_per_day
    blocks=[blocks repmat(idx,1,trials_per_block)];
end
blocks=repmat(blocks,1,days_per_condition*days_per_experiment);

days = [];
for idx=1:days_per_experiment
    days=[days repmat(idx,1,trials_per_block*blocks_per_day)];
end
days=repmat(days,1,days_per_condition);

%conditions for each experiment (w/in Ss)
conditions=[];
for idx=1:days_per_condition
    conditions=[conditions repmat(idx,1,trials_per_block*blocks_per_day*days_per_condition)];
end

%same for the IDs
the_IDs=[];
for idx=1:length(IDs)
    new_ID=repmat(str2num(IDs{idx}(6:end)),1,trials_per_block*blocks_per_day*days_per_experiment*days_per_condition);
    the_IDs=[the_IDs new_ID];
end

conditions_per_ID=[conditions;days;blocks;trials];
SPSS_conditions=[the_IDs; repmat(conditions_per_ID,1,length(IDs))];

CORm=CORm';
SYNm=SYNm';
SPSS_CORm=[SPSS_conditions' CORm(:) SYNm(:)];

CORm_filt=CORm;
CORm_filt(CORm<std(CORm(:))/sqrt(14)*2)=NaN;
CORm_filt=CORm_filt(:);
clear trials blocks days conditions idx

%another way, trials for each individual
trials1=repmat(1:240,1,length(PPs.IDs))'; 
%trials for each condition
trials2=repmat([1:120 1:120],1,length(PPs.IDs))'; 

%include the ordering of stim vs sham
total_trials_cond=trials_per_block*blocks_per_day*days_per_experiment;
tDCS_stim=[]; %ordering of stimulation - 1 for the first experimental condition the P was exposed to, and 2 for the second
for ID=1:length(IDs)
    if PPs.tDCS.schedule(ID,1)==1 %if the first day was a tDCS day, 3rd was sham. sham listed 1st in SPSS so 
        %make that note here first
        tDCS_stim=[tDCS_stim; ones(total_trials_cond,1)*2; ones(total_trials_cond,1)*1];
    elseif PPs.tDCS.schedule(ID,1)==2 %if the first day was a sham day, 3rd was tDCS. sham is listed 1st in SPSS so 
        %make that note here first
        tDCS_stim=[tDCS_stim; ones(total_trials_cond,1)*1; ones(total_trials_cond,1)*2];
    end
end

%same for RND
total_trials_cond=48;
tDCS_stim_RND=[]; %ordering of stimulation - 1 for the first experimental condition the P was exposed to, and 2 for the second
for ID=1:length(IDs)
    if PPs.tDCS.schedule(ID,1)==1 %if the first day was a tDCS day, 3rd was sham. sham listed 1st in SPSS so 
        %make that note here first
        tDCS_stim_RND=[tDCS_stim_RND; ones(total_trials_cond,1)*2; ones(total_trials_cond,1)*1];
    elseif PPs.tDCS.schedule(ID,1)==2 %if the first day was a sham day, 3rd was tDCS. sham is listed 1st in SPSS so 
        %make that note here first
        tDCS_stim_RND=[tDCS_stim_RND; ones(total_trials_cond,1)*1; ones(total_trials_cond,1)*2];
    end
end

clear total_trials_cond, ID;

%% create data format for input to SPSS for linear mixed modeling (RND trials)

trials_per_block=4;
blocks_per_day = 6;
days_per_experiment = 2;
days_per_condition = 2;

trials=repmat(1:trials_per_block,1,blocks_per_day*days_per_condition*days_per_experiment);

blocks=[];

%blocks for each day
for idx=1:blocks_per_day
    blocks=[blocks repmat(idx,1,trials_per_block)];
end
blocks=repmat(blocks,1,days_per_condition*days_per_experiment);

days = [];
for idx=1:days_per_experiment
    days=[days repmat(idx,1,trials_per_block*blocks_per_day)];
end
days=repmat(days,1,days_per_condition); 

%conditions for each experiment (w/in Ss)
conditions=[];
for idx=1:days_per_condition
    conditions=[conditions repmat(idx,1,trials_per_block*blocks_per_day*days_per_condition)];
end

%same for the IDs
the_IDs=[];
for idx=1:length(IDs)
    new_ID=repmat(str2num(IDs{idx}(6:end)),1,trials_per_block*blocks_per_day*days_per_experiment*days_per_condition);
    the_IDs=[the_IDs new_ID];
end

conditions_per_ID=[conditions;days;blocks;trials];
SPSS_conditions=[the_IDs; repmat(conditions_per_ID,1,length(IDs))];

rCORm=rCORm';
rSYNm=rSYNm';

rSPSS_out=[SPSS_conditions' rCORm(:) rSYNm(:) rCORm(:)./rSYNm(:)];
%another way, trials for each individual
trials1=repmat(1:96,1,length(PPs.IDs))'; 
%trials for each condition
trials2=repmat([1:48 1:48],1,length(PPs.IDs))'; 
%% work with the processed data from Pilot2 (4 Ps)
% plot LRN vs bracketed RND trials
addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/'); %path to the scoring scripts


load('/scr/alaska1/steele/Projects/Working/MFST_Genetics/processing/bx/2013_03_MFST_Genetics_Pilot2.mat');

figure('name','LRN sequence performance by block bracketed by RND famil blocks');
%total blocks over the experiment
total_blocks=days*blocks+days;

x=1:total_blocks; %total number of blocks presented over experiment
Lx=logical([0 ones(1,12) 0 0 ones(1,12) 0]); %denote which blocks are famil1 blocks and which are the standard learning blocks
if total_blocks==56
    Lx=[Lx Lx];
end

%COR
subplot(2,1,1); hold on; box off;
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);
Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');

%SYN
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);
subplot(2,1,2); hold on; box off;
Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');

hold off;

% NORMALISE THEM
%
%now normalise to the famil1 block presented before the 1st LRN? sequence
figure('name','Normalised LRN sequence performance by block bracketed by RND famil blocks');


%COR
subplot(2,1,1); hold on; box off;
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);

for ID=1:length(IDs) %XXX HARD CODED for the number of blocks in each case
    Lm(ID,1:12)=Lm(ID,1:12)-Fm(ID,1);
    Lm(ID,13:24)=Lm(ID,13:24)-Fm(ID,3);
    Fm(ID,1:2)=Fm(ID,1:2)-Fm(ID,1);
    Fm(ID,3:4)=Fm(ID,3:4)-Fm(ID,3);
end

if total_blocks > 28
    for ID=1:length(IDs)
        Lm(ID,25:36)=Lm(ID,25:36)-Fm(ID,5);
        Lm(ID,37:48)=Lm(ID,37:48)-Fm(ID,7);
        Fm(ID,5:6)=Fm(ID,5:6)-Fm(ID,5);
        Fm(ID,7:8)=Fm(ID,7:8)-Fm(ID,7);
    end
end

Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');

%SYN
subplot(2,1,2); hold on; box off;
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);
for ID=1:length(IDs) %XXX HARD CODED for the number of blocks in each case
    Lm(ID,1:12)=Lm(ID,1:12)-Fm(ID,1);
    Lm(ID,13:24)=Lm(ID,13:24)-Fm(ID,3);
    Fm(ID,1:2)=Fm(ID,1:2)-Fm(ID,1);
    Fm(ID,3:4)=Fm(ID,3:4)-Fm(ID,3);
end

if total_blocks > 28
    for ID=1:length(IDs)
        Lm(ID,25:36)=Lm(ID,25:36)-Fm(ID,5);
        Lm(ID,37:48)=Lm(ID,37:48)-Fm(ID,7);
        Fm(ID,5:6)=Fm(ID,5:6)-Fm(ID,5);
        Fm(ID,7:8)=Fm(ID,7:8)-Fm(ID,7);
    end
end

Lci=nanmean(Lsd)./sqrt(sum(Ln>0,1)).*tinv(.95,sum(Ln>0,1)-1); %calc the number of individuals that have data on this block
Fci=nanmean(Fsd)./sqrt(sum(Fn>0,1)).*tinv(.95,sum(Fn>0,1)-1); %calc the number of individuals that have data on this block
errorbar(x(Lx), nanmean(Lm,1), Lci,'ko');
errorbar(x(not(Lx)), nanmean(Fm,1),Fci,'ro');

hold off;

% plot change between d1famil1 and d2famil1 and d1b1 and d2b6 on LRN1 and
% LRN2
%
%

figure('name','RND change vs. LRN absolute change (COR & SYN)');
subplot(2,1,1); hold on; box off;

%COR
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);

% d1, d2 change LRN; d1, d2 change RND (famil probes)
Ld=ones(length(IDs),4)*NaN;
for ID=1:length(IDs) 
    Ld(ID,1)=Lm(ID,12)-Lm(ID,1); %last - first
    Ld(ID,2)=Lm(ID,24)-Lm(ID,13); %last - first
    Ld(ID,3)=Fm(ID,2)-Fm(ID,1); %2nd - first
    Ld(ID,4)=Fm(ID,4)-Fm(ID,3); %2nd - first
end

if total_blocks > 28
    for ID=1:length(IDs)
        Ld(ID,5)=Lm(ID,36)-Lm(ID,25); %last - first
        Ld(ID,6)=Lm(ID,48)-Lm(ID,37); %last - first
        Ld(ID,7)=Fm(ID,6)-Fm(ID,5); %2nd - first
        Ld(ID,8)=Fm(ID,8)-Fm(ID,7); %2nd - first
    end
    plot(ones(1,length(IDs))*3,Ld(:,5),'ko');
    plot(3,nanmean(Ld(:,5)),'kx');
    
    plot(ones(1,length(IDs))*4,Ld(:,6),'ko');
    plot(4,nanmean(Ld(:,6)),'kx');
    
    plot(ones(1,length(IDs))*3.5,Ld(:,7),'ro');
    plot(3.5,nanmean(Ld(:,7)),'rx');
    
    plot(ones(1,length(IDs))*4.5,Ld(:,8),'ro');
    plot(4.5,nanmean(Ld(:,8)),'rx');
end


plot(ones(1,length(IDs)),Ld(:,1),'ko');
plot(1,nanmean(Ld(:,1)),'kx');

plot(ones(1,length(IDs))*2,Ld(:,2),'ko');
plot(2,nanmean(Ld(:,2)),'kx');

plot(ones(1,length(IDs))*1.5,Ld(:,3),'ro');
plot(1.5,nanmean(Ld(:,3)),'rx');

plot(ones(1,length(IDs))*2.5,Ld(:,4),'ro');
plot(2.5,nanmean(Ld(:,4)),'rx');

xlim([0.5,5]);

% SYN
subplot(2,1,2); hold on; box off;

[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);

% d1, d2 change LRN; d1, d2 change RND (famil probes)

Ld=ones(length(IDs),4)*NaN;
for ID=1:length(IDs) 
    Ld(ID,1)=Lm(ID,1)-Lm(ID,12); % first - last
    Ld(ID,2)=Lm(ID,13)-Lm(ID,24); % first - last (b/c last is smaller)
    Ld(ID,3)=Fm(ID,2)-Fm(ID,1); %2nd - first
    Ld(ID,4)=Fm(ID,4)-Fm(ID,3); %2nd - first
end

if total_blocks > 28
    for ID=1:length(IDs)
        Ld(ID,5)=Lm(ID,25)-Lm(ID,36);
        Ld(ID,6)=Lm(ID,37)-Lm(ID,48);
        Ld(ID,7)=Fm(ID,5)-Fm(ID,6);
        Ld(ID,8)=Fm(ID,7)-Fm(ID,8);
    end
    plot(ones(1,length(IDs))*3,Ld(:,5),'ko');
    plot(3,nanmean(Ld(:,5)),'kx');
    
    plot(ones(1,length(IDs))*4,Ld(:,6),'ko');
    plot(4,nanmean(Ld(:,6)),'kx');
    
    plot(ones(1,length(IDs))*3.5,Ld(:,7),'ro');
    plot(3.5,nanmean(Ld(:,7)),'rx');
    
    plot(ones(1,length(IDs))*4.5,Ld(:,8),'ro');
    plot(4.5,nanmean(Ld(:,8)),'rx');
end

plot(ones(1,length(IDs)),Ld(:,1),'ko');
plot(1,nanmean(Ld(:,1)),'kx');

plot(ones(1,length(IDs))*2,Ld(:,2),'ko');
plot(2,nanmean(Ld(:,2)),'kx');

plot(ones(1,length(IDs))*1.5,Ld(:,3),'ro');
plot(1.5,nanmean(Ld(:,3)),'rx');

plot(ones(1,length(IDs))*2.5,Ld(:,4),'ro');
plot(2.5,nanmean(Ld(:,4)),'rx');

xlim([0.5,5]);
hold off;

% same thing, but use (last-first)/first to calculate proportion
% IMPROVEMENT (so it works as positive for both COR and SYN)
figure('name','RND change vs. LRN proportion change (COR & SYN)');
subplot(2,1,1); hold on; box off;

%COR
[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);

% d1, d2 change LRN; d1, d2 change RND (famil probes)
Ld=ones(length(IDs),4)*NaN;
for ID=1:length(IDs) 
    Ld(ID,1)=(Lm(ID,12)-Lm(ID,1))/Lm(ID,1);
    Ld(ID,2)=(Lm(ID,24)-Lm(ID,13))/Lm(ID,13);
    Ld(ID,3)=(Fm(ID,2)-Fm(ID,1))/Fm(ID,1); 
    Ld(ID,4)=(Fm(ID,4)-Fm(ID,3))/Fm(ID,3);
end

if total_blocks > 28
    for ID=1:length(IDs)
        Ld(ID,5)=(Lm(ID,36)-Lm(ID,25))/Lm(ID,25); 
        Ld(ID,6)=(Lm(ID,48)-Lm(ID,37))/Lm(ID,37); 
        Ld(ID,7)=(Fm(ID,6)-Fm(ID,5))/Fm(ID,5); 
        Ld(ID,8)=(Fm(ID,8)-Fm(ID,7))/Fm(ID,7);
    end
    plot(ones(1,length(IDs))*3,Ld(:,5),'ko');
    plot(3,nanmean(Ld(:,5)),'kx');
    
    plot(ones(1,length(IDs))*4,Ld(:,6),'ko');
    plot(4,nanmean(Ld(:,6)),'kx');
    
    plot(ones(1,length(IDs))*3.5,Ld(:,7),'ro');
    plot(3.5,nanmean(Ld(:,7)),'rx');
    
    plot(ones(1,length(IDs))*4.5,Ld(:,8),'ro');
    plot(4.5,nanmean(Ld(:,8)),'rx');
end

plot(ones(1,length(IDs)),Ld(:,1),'ko');
plot(1,nanmean(Ld(:,1)),'kx');

plot(ones(1,length(IDs))*2,Ld(:,2),'ko');
plot(2,nanmean(Ld(:,2)),'kx');

plot(ones(1,length(IDs))*1.5,Ld(:,3),'ro');
plot(1.5,nanmean(Ld(:,3)),'rx');

plot(ones(1,length(IDs))*2.5,Ld(:,4),'ro');
plot(2.5,nanmean(Ld(:,4)),'rx');

xlim([0.5,5]);

% SYN
subplot(2,1,2); hold on; box off;

[Lm Lsd Ln]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[Fm Fsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);

% d1, d2 change LRN; d1, d2 change RND (famil probes)
Ld=ones(length(IDs),4)*NaN;
for ID=1:length(IDs) 
    Ld(ID,1)=(Lm(ID,12)-Lm(ID,1))/Lm(ID,12);
    Ld(ID,2)=(Lm(ID,24)-Lm(ID,13))/Lm(ID,24);
    Ld(ID,3)=(Fm(ID,2)-Fm(ID,1))/Fm(ID,1); 
    Ld(ID,4)=(Fm(ID,4)-Fm(ID,3))/Fm(ID,3);
end

if total_blocks > 28
    for ID=1:length(IDs)
        Ld(ID,5)=(Lm(ID,36)-Lm(ID,25))/Lm(ID,36);
        Ld(ID,6)=(Lm(ID,48)-Lm(ID,37))/Lm(ID,48);
        Ld(ID,7)=(Fm(ID,6)-Fm(ID,5))/Fm(ID,5);
        Ld(ID,8)=(Fm(ID,8)-Fm(ID,7))/Fm(ID,7);
    end
    plot(ones(1,length(IDs))*3,Ld(:,5),'ko');
    plot(3,nanmean(Ld(:,5)),'kx');
    
    plot(ones(1,length(IDs))*4,Ld(:,6),'ko');
    plot(4,nanmean(Ld(:,6)),'kx');
    
    plot(ones(1,length(IDs))*3.5,Ld(:,7),'ro');
    plot(3.5,nanmean(Ld(:,7)),'rx');
    
    plot(ones(1,length(IDs))*4.5,Ld(:,8),'ro');
    plot(4.5,nanmean(Ld(:,8)),'rx');
end

plot(ones(1,length(IDs)),Ld(:,1),'ko');
plot(1,nanmean(Ld(:,1)),'kx');

plot(ones(1,length(IDs))*2,Ld(:,2),'ko');
plot(2,nanmean(Ld(:,2)),'kx');

plot(ones(1,length(IDs))*1.5,Ld(:,3),'ro');
plot(1.5,nanmean(Ld(:,3)),'rx');

plot(ones(1,length(IDs))*2.5,Ld(:,4),'ro');
plot(2.5,nanmean(Ld(:,4)),'rx');

xlim([0.5,5]);
%% Calculate the speed accuracy trade off Skill Index (SI)
% PCOR/meanRT (as per Wendenworth article)
%

[CORm CORsd CORn]=MFST_MC_selectData(PPs.all.data.LRN,1,'Individual','Block',false);
[SYNm SYNsd SYNn]=MFST_MC_selectData(PPs.all.data.LRN,2,'Individual','Block',false);
[rCORm rCORsd rCORn]=MFST_MC_selectData(PPs.all.data.RND,1,'Individual','Block',false);
[rSYNm rSYNsd rSYNn]=MFST_MC_selectData(PPs.all.data.RND,2,'Individual','Block',false);

[fCORm fCORsd Fn]=MFST_MC_selectData(PPs.all.data.famil,1,'Individual','Block',false);
[fSYNm fSYNsd Fn]=MFST_MC_selectData(PPs.all.data.famil,2,'Individual','Block',false);

clear Fn;

SI=100*CORm./SYNm; % repeated LRN sequences SI
rSI=100*rCORm./rSYNm; %rand sequences SI
fSI=100*fCORm./fSYNm; %famil SI 

%coefficient of variation
%checked this, doesn't seem to add any useful information (March 15, 2013)
CORcv=CORsd./CORm;
SYNcv=SYNsd./SYNm;
rCORcv=rCORsd./rCORm;
rSYNcv=rSYNsd./rSYNm;
fCORcv=fCORsd./fCORm;
fSYNcv=fSYNsd./fSYNm;

% % zscore the data as a way to compare days - hmmmmm. could also use the cov?
%zscoreing does NOT work
% just demeaned the data to look at it
for ID=1:size(SI,1)
    SI(ID,1:12)=detrend(SI(ID,1:12),'constant');
    SI(ID,13:24)=detrend(SI(ID,13:24),'constant');
    SI(ID,25:36)=detrend(SI(ID,25:36),'constant');
    SI(ID,37:48)=detrend(SI(ID,37:48),'constant');
    rSI(ID,1:12)=detrend(rSI(ID,1:12),'constant');
    rSI(ID,13:24)=detrend(rSI(ID,13:24),'constant');
    rSI(ID,25:36)=detrend(rSI(ID,25:36),'constant');
    rSI(ID,37:48)=detrend(rSI(ID,37:48),'constant');
    fSI(ID,1:2)=detrend(fSI(ID,1:2),'constant');
    fSI(ID,3:4)=detrend(fSI(ID,3:4),'constant');
    fSI(ID,5:6)=detrend(fSI(ID,5:6),'constant');
    fSI(ID,7:8)=detrend(fSI(ID,7:8),'constant');

    CORm(ID,1:12)=detrend(CORm(ID,1:12),'constant');
    CORm(ID,13:24)=detrend(CORm(ID,13:24),'constant');
    CORm(ID,25:36)=detrend(CORm(ID,25:36),'constant');
    CORm(ID,37:48)=detrend(CORm(ID,37:48),'constant');
    rCORm(ID,1:12)=detrend(rCORm(ID,1:12),'constant');
    rCORm(ID,13:24)=detrend(rCORm(ID,13:24),'constant');
    rCORm(ID,25:36)=detrend(rCORm(ID,25:36),'constant');
    rCORm(ID,37:48)=detrend(rCORm(ID,37:48),'constant');
    fCORm(ID,1:2)=detrend(fCORm(ID,1:2),'constant');
    fCORm(ID,3:4)=detrend(fCORm(ID,3:4),'constant');
    fCORm(ID,5:6)=detrend(fCORm(ID,5:6),'constant');
    fCORm(ID,7:8)=detrend(fCORm(ID,7:8),'constant');
    
    SYNm(ID,1:12)=detrend(SYNm(ID,1:12),'constant');
    SYNm(ID,13:24)=detrend(SYNm(ID,13:24),'constant');
    SYNm(ID,25:36)=detrend(SYNm(ID,25:36),'constant');
    SYNm(ID,37:48)=detrend(SYNm(ID,37:48),'constant');
    rSYNm(ID,1:12)=detrend(rSYNm(ID,1:12),'constant');
    rSYNm(ID,13:24)=detrend(rSYNm(ID,13:24),'constant');
    rSYNm(ID,25:36)=detrend(rSYNm(ID,25:36),'constant');
    rSYNm(ID,37:48)=detrend(rSYNm(ID,37:48),'constant');
    fSYNm(ID,1:2)=detrend(fSYNm(ID,1:2),'constant');
    fSYNm(ID,3:4)=detrend(fSYNm(ID,3:4),'constant');
    fSYNm(ID,5:6)=detrend(fSYNm(ID,5:6),'constant');
    fSYNm(ID,7:8)=detrend(fSYNm(ID,7:8),'constant');
end

% create and save tDCS stimulation matrix in data structure
% 0 1 2
% no-stim, bilat m1 1mA, bilat m1 sham
% ordered by numerical ID, listed for each sequence (LRN1..4)
PPs.tDCS.measures={'0 = no stimulation' '1 = bilateral m1 1mA' '2 = bilateral m1 sham'};
PPs.tDCS.schedule=[
    0 0 1 2;
    0 0 1 2;
    0 0 2 1;
    0 0 1 2;
    ];

%now we need to swap the days around so that the day with 1mA stimulation
%comes on the 3rd day in this sample
%uses PPs.tDCS.schedule
for ID=1:length(PPs.IDs)
    if PPs.tDCS.schedule(ID,4)==1 %if the last day was tDCS (again, this is specific to this sample) 
        tDCSdata=SI(ID,37:48);
        SI(ID,37:48)=SI(ID,25:36);
        SI(ID,25:36)=tDCSdata;

        tDCSdata=rSI(ID,37:48);
        rSI(ID,37:48)=rSI(ID,25:36);
        rSI(ID,25:36)=tDCSdata;

        tDCSdata=CORm(ID,37:48);
        CORm(ID,37:48)=CORm(ID,25:36);
        CORm(ID,25:36)=tDCSdata;

        tDCSdata=rCORm(ID,37:48);
        rCORm(ID,37:48)=rCORm(ID,25:36);
        rCORm(ID,25:36)=tDCSdata;
        
        tDCSdata=SYNm(ID,37:48);
        SYNm(ID,37:48)=SYNm(ID,25:36);
        SYNm(ID,25:36)=tDCSdata;
        
        tDCSdata=rSYNm(ID,37:48);
        rSYNm(ID,37:48)=rSYNm(ID,25:36);
        rSYNm(ID,25:36)=tDCSdata;
        clear tDCSdata;
        
        %now for famil blocks
        tDCSdata=fSI(ID,7:8);
        fSI(ID,7:8)=fSI(ID,5:6);
        fSI(ID,5:6)=tDCSdata;
        
        tDCSdata=fCORm(ID,7:8);
        fCORm(ID,7:8)=fCORm(ID,5:6);
        fCORm(ID,5:6)=tDCSdata;
        
        tDCSdata=fSYNm(ID,7:8);
        fSYNm(ID,7:8)=fSYNm(ID,5:6);
        fSYNm(ID,5:6)=tDCSdata;
        
        clear tDCSdata;
        fprintf('---> Subject ID: %s had tDCS stim data moved from d4 to d3.\n',PPs.IDs{ID});
    end
end
        
% SI plot
temp.v1=SI(1:12);
temp.v2=fSI(1:12);
temp.v3=rSI(1:12);

figure('name', 'Skill Index (SI) for LRN vs RND across blocks'); hold on; box off;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24 25 36 37 48],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;

% COV doesn't seem to give anything useful at all
% COVcv plot
temp.v1=CORm;
temp.v2=fCORm;
temp.v3=rCORm;

figure('name', 'COR for LRN vs RND across blocks'); hold on; box off;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24 25 36 37 48],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;

% SYNcv plot
temp.v1=SYNm;
temp.v2=fSYNm;
temp.v3=rSYNm;

figure('name', 'SYN for LRN vs RND across blocks'); hold on; box off;
plot(temp.v1'); plot(nanmean(temp.v1,1),'kx-','markersize',8,'linewidth',2);
%plot(temp.v3',':'); plot(nanmean(temp.v3,1),'rx:','markersize',8,'linewidth',2);
plot([1 12 13 24 25 36 37 48],nanmean(temp.v2),'bx:','markersize',12,'linewidth',2);
hold off;

%compare SI
fprintf('\n========== 2-tailed paired t-tests of Skill Index differences: ==========\n');
%LRN sequences
fprintf('LRN sequences only\n');
[h p ci stats]=ttest(SI(:,12), SI(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(SI(:,1), SI(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%RND sequences
fprintf('\nRND sequences only\n');
[h p ci stats]=ttest(rSI(:,12), rSI(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(rSI(:,1), rSI(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%compare COR
fprintf('\n========== 2-tailed paired t-tests of COR differences: ==========\n');
%LRN sequences
fprintf('LRN sequences only\n');
[h p ci stats]=ttest(CORm(:,12), CORm(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(CORm(:,1), CORm(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%RND sequences
fprintf('\nRND sequences only\n');
[h p ci stats]=ttest(rCORm(:,12), rCORm(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(rCORm(:,1), rCORm(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%compare SYN
fprintf('\n========== 2-tailed paired t-tests of SYN differences: ==========\n');
%LRN sequences
fprintf('LRN sequences only\n');
[h p ci stats]=ttest(SYNm(:,12), SYNm(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(SYNm(:,1), SYNm(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%RND sequences
fprintf('\nRND sequences only\n');
[h p ci stats]=ttest(rSYNm(:,12), rSYNm(:,24),.05,'both');
fprintf('  Block 12 to block 24: t=%f.2, p=%f.2\n',stats.tstat, p);

[h p ci stats]=ttest(rSYNm(:,1), rSYNm(:,13),.05,'both');
fprintf('  Block 1 to block 13: t=%f.2, p=%f.2\n',stats.tstat, p);

%calculate slopes, compare
%initialise
slp.COR.LRN1=ones(size(CORm,1),1)*NaN;
slp.COR.LRN2=slp.COR.LRN1;
slp.SYN.LRN1=slp.COR.LRN1;
slp.SYN.LRN2=slp.COR.LRN1;
slp.SI.LRN1=slp.COR.LRN1;
slp.SI.LRN2=slp.COR.LRN1;

temp.LRN1=slp.COR.LRN1;
temp.LRN2=slp.COR.LRN1;

tmp.slpData=CORm;
%calc for each sequence for each individual
for ID=1:size(CORm,1)
    betas=polyfit([1:12],tmp.slpData(ID,1:12),1);
    temp.LRN1(ID)=betas(1);
    betas=polyfit([1:12],tmp.slpData(ID,13:24),1);
    temp.LRN2(ID)=betas(1);
end
slp.COR.LRN1=temp.LRN1;
slp.COR.LRN2=temp.LRN2;


tmp.slpData=SYNm;
%calc for each sequence for each individual
for ID=1:size(CORm,1)
    betas=polyfit([1:12],tmp.slpData(ID,1:12),1);
    temp.LRN1(ID)=betas(1);
    betas=polyfit([1:12],tmp.slpData(ID,13:24),1);
    temp.LRN2(ID)=betas(1);
end
slp.SYN.LRN1=temp.LRN1;
slp.SYN.LRN2=temp.LRN2;

tmp.slpData=SI;
%calc for each sequence for each individual
for ID=1:size(CORm,1)
    betas=polyfit([1:12],tmp.slpData(ID,1:12),1);
    temp.LRN1(ID)=betas(1);
    betas=polyfit([1:12],tmp.slpData(ID,13:24),1);
    temp.LRN2(ID)=betas(1);
end
slp.SI.LRN1=temp.LRN1;
slp.SI.LRN2=temp.LRN2;

%compare slopes on two LRN sequences
fprintf('\n========== 2-tailed paired t-tests of slope differences between 2 LRN sequences: ==========\n');
%LRN sequences
fprintf('LRN sequences only\n');
[h p ci stats]=ttest(slp.COR.LRN1, slp.COR.LRN2,.05,'both');
fprintf('  COR: t=%f.2, p=%f.2\n',stats.tstat, p);
[h p ci stats]=ttest(slp.SYN.LRN1, slp.SYN.LRN2,.05,'both');
fprintf('  SYN: t=%f.2, p=%f.2\n',stats.tstat, p);
[h p ci stats]=ttest(slp.SI.LRN1, slp.SI.LRN2,.05,'both');
fprintf('  SI: t=%f.2, p=%f.2\n',stats.tstat, p);
% % calculate the CoV and plot
% %sd/m
% CORcov=CORsd./CORm;
% SYNcov=SYNsd./SYNm;
% rCORcov=rCORsd./rCORm;
% rSYNcov=rSYNsd./rSYNm;
% 
% figure('name', 'COR Coefficient of variation (COV) for LRN vs RND across blocks'); hold on; box off;
% plot(CORcov'); plot(nanmean(CORcov,1),'kx-','markersize',8,'linewidth',2);
% plot(rCORcov',':'); plot(nanmean(rCORcov,1),'rx:','markersize',8,'linewidth',2);
% 
% figure('name', 'SYN Coefficient of variation (COV) for LRN vs RND across blocks'); hold on; box off;
% plot(SYNcov'); plot(nanmean(SYNcov,1),'kx-','markersize',8,'linewidth',2);
% plot(rSYNcov',':'); plot(nanmean(rSYNcov,1),'rx:','markersize',8,'linewidth',2);
% ylim([0 2]);

% %normalise SI for each sequence to their own starting points
% %unfortunately does not look as nice as the zscored data :(
% for ID=1:size(SI,1)   
%     SI(ID,1:12)=SI(ID,1:12)./SI(ID,1);
%     SI(ID,13:24)=SI(ID,13:24)./SI(ID,13);
% end

%% THIS IS OLDER PILOT DATA
% % setup basic path information
% this workspace contains a variable called "allsSeq" which contains all of
% the possible sequences, starting from 1 (LRN1) which is index 2 for
% scoring and use in configurations xml file.

addpath('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/'); %path to the scoring scripts
dataDir='/scr/alaska1/steele/Projects/Working/MFST_Genetics/source/bx/pilot/';
load('/scr/alaska1/steele/Projects/Working/MFST_Genetics/scripts/matlab/2013_02_MFST_Genetics_ScoringSetup_FINAL.mat');

IDs={'Pilot_00' 'Pilot_01' 'Pilot_02' 'Pilot_03'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']
IDs={'CS'}; 
IDs={'AS', 'KG', 'tim', 'MT' 'BS'};

IDs={  'BS' 'EK'};
%IDs={'KG'}
days=4;
blocks=6;
stimDuration = 300; %duration of the stimulus
beforeTrialDelay = 200; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses

%use a new way of selecting sequence ID b/c we presented two different
%types of seqeunces during the experiment (4th and 5th days are the second
%ID)
% modifided MFST_MC_prepareData to take account of this change
LRNSeqID=[2]; %set the index for the location (0-based) of the LRN sequence used in this experiment (NOTE: this still scores the three different LRN sequences correctly b/c of how they were setup in PPs.stimuli.scoring


doTFR=false; % don't look at any transfer sequences
doJerk=false; % don't try to calculate jerk? (you jerk!)
trialSelect=false; % don't select a subset of LRN trials for averages/plotting, use them all
numTrialSelect=4; %number of trials to select if necessary (only curre  ntly supports 4) (NOTE: if trialSelect=false this number does not matter)


PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);






PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,doTFR,doJerk); % for scoring into a single variable
MFST_MC_plotData2(PPs,1,doTFR,trialSelect,numTrialSelect);
MFST_MC_plotData2(PPs,2,doTFR,trialSelect,numTrialSelect);



