function PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,repeatedSequenceID,suppressOutput,CONV)
% Prepare MFST data for scoring
%
% Requires that the sequences structure has been created with
% gen13ElementSeqs (note that this generates a particular set of sequences
% based on particular random seed - for Chris' MFST_MC experiment the seed
% was 19750909
%
% input:
%   <dataDir>               - directory where data resides
%   <PPs>                   - input data structure with stim presentation
%                             information
%   <IDs>                   - cell of participant IDs, corresponds to head of
%                             filename (e.g., 'Pilot00' for PilotOO_d1b1.txt)
%   <days>                  - # of days of data
%   <blocks>                - # of blocks/day in this experiment
%   <beforeTrialDelay>      - delay before 1st element appears, in ms
%   <stimDuration>          - duration, in ms
%   <scoringWindowOffset>   - time b4 stim onset to consider keypress correct (in ms)
%   <repeatedSequenceID>    - id of sequence that is repeated (LRN sequence)
%   <suppresOutput>         - suppress informational output to the screen (speeds it up!) (default is false)
%   <CONV>                  - set to true/false if need to multiply stimonset times by 1000 to convert to ms (ricco's version) (default is true)
%
% output:
%   <PPs>                   - data structure for prepared output for these
%                             participants
%
if nargin==9
    suppressOutput=false;
    CONV=true;
end

for ID=1:length(IDs) %loop on each individual
    if ~suppressOutput
        fprintf(2,'Participant %s\n',IDs{ID})
    end
    for day=1:days %loop on each day
        
        % intialise all variables for each day
        acc={};
        lag1={};
        lag2={};
        dur={};
        vel={};
        iti={};
        LRNSeqPosn=[];
        if ~suppressOutput
            fprintf('Day %i\n',day);
        end
        for block=1:blocks %loop on each block
            if ~suppressOutput
                fprintf('Block %i ',block);
            end
            fileName=[IDs{ID} '_d' num2str(day) 'b' num2str(block) '.txt'];
            outName=strrep(fileName,'.txt','.xls'); %cut off the .txt from the filename
            
            cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d' num2str(day) 'b' num2str(block) ';'];
            eval(cmd);
            
% removed this b/c these subjects are long gone!
%             %check for 2 participants who were given the wrong block of
%             %trials for particular days, change the scoring block
%             %accordingly
%             if strcmp(IDs{ID},'P11') && day==2 && block==1
%                 %participant P11 received d1b1 stimuli for d2b1
%                 cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d1b1;'];
%                 if ~suppressOutput
%                     fprintf('Participant %s scoring modification in place.',IDs{ID});
%                 end
%                 eval(cmd);
%             elseif strcmp(IDs{ID},'P07') && day==5 && block==4
%                 %participant P07 received d5b3 stimuli for d5b4 (see notes
%                 %in source data
%                 cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d5b3;'];
%                 eval(cmd);
%                 
%             end
% removed this b/c these subjects are long gone!

            [bacc, blag1, blag2, bdur, bvel, biti] = scoreAdaptiveMFST([dataDir '/' fileName],[dataDir '/' outName], presentedSequences, scoringWindowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV);
            acc=cellAppend(acc, 'down', bacc);
            lag1=cellAppend(lag1, 'down', blag1);
            lag2=cellAppend(lag2, 'down', blag2);
            dur=cellAppend(dur, 'down', bdur);
            vel=cellAppend(vel, 'down', bvel);
            iti=cellAppend(iti, 'down', biti);
            cmd=['trialLRNSeqPosn=' PPs.name '.stimuli.id.d' num2str(day) 'b' num2str(block) '==' num2str(repeatedSequenceID) ';'];
            eval(cmd);
            LRNSeqPosn=[LRNSeqPosn; trialLRNSeqPosn]; % these three commands give me the positions (1s) of the repeated sequences in each block
        end
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.acc=acc;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag1=lag1;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag2=lag2;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.dur=dur;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.vel=vel;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.iti=iti;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.LRNSeqPosn=LRNSeqPosn;'];
        eval(cmd);
    end
    % calculate values for the transfer sequences
    %appears to work!
    TFR1=[]; TFR2=[]; mirrorTFRSeq=[];
    fileName=[IDs{ID} '_tfr_d1b1.txt'];
    if exist([dataDir '/' IDs{ID} '_tfr_d1b1.txt'],'file') && exist([dataDir '/' IDs{ID} '_tfr2.txt'],'file') % both tfr 1 and tfr2 were collected
        fprintf('TFR Blocks\n');
        %do it for the TFR sequence (TFR1) based on d1b1
        fileName=[IDs{ID} '_tfr_d1b1.txt'];
        cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d1b1;'];
        eval(cmd);
        [TFR1.acc, TFR1.lag1, TFR1.lag2, TFR1.dur, TFR1.vel, TFR1.iti] = scoreAdaptiveMFST([dataDir '/' fileName],[dataDir '/' outName], presentedSequences, scoringWindowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV);
        
        %do it for mirrored TFR (TFR2) based on d1b2
        fileName=[IDs{ID} '_tfr2.txt'];
        cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d1b2;'];
        eval(cmd);
        cmd=['trialLRNSeqPosn=' PPs.name '.stimuli.id.d1b2;'];
        eval(cmd);
        
        %not efficient but gets the job done
        LRNSeq=presentedSequences(1,:);
        mirror=zeros(size(LRNSeq));
        aList=max(LRNSeq):-1:1; %create the reverse list
        for num=1:max(LRNSeq)
            mirror(LRNSeq==num)=aList(num);
        end
        mirror=repmat(mirror,sum(trialLRNSeqPosn==repeatedSequenceID),1); %create same number as number of LRN sequences per block
        presentedSequences(trialLRNSeqPosn==repeatedSequenceID,:)=mirror;
        mirrorTFRSeq=presentedSequences;
        [TFR2.acc, TFR2.lag1, TFR2.lag2, TFR2.dur, TFR2.vel, TFR2.iti] = scoreAdaptiveMFST([dataDir '/' fileName],[dataDir '/' outName], mirrorTFRSeq, scoringWindowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV);
        fprintf('Both transfer sequences found and scored.\n');
    elseif exist([dataDir '/' fileName],'file');
        fprintf('TFR Blocks\n');
        cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d1b1;'];
        eval(cmd);
        [TFR1.acc, TFR1.lag1, TFR1.lag2, TFR1.dur, TFR1.vel, TFR1.iti] = scoreAdaptiveMFST([dataDir '/' fileName],[dataDir '/' outName], presentedSequences, scoringWindowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV);
        fprintf('One transfer sequence found and scored.\n');
    else
        fprintf('Transfer sequence files not found.\n');
    end
    cmd=[PPs.name '.' IDs{ID} '.results.TFR1=TFR1;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.results.TFR2=TFR2;'];
    eval(cmd);
end
%this updates the structure to enable scoring (added here rather than
%in the gen13ElementXXX function.
% XXX this will need to be changed if blocks other than d1b1 and d1b2
% are used! XXX
cmd=[PPs.name '.stimuli.id.TFR1=' PPs.name '.stimuli.id.d1b1;'];
eval(cmd);
cmd=[PPs.name '.stimuli.scoring.TFR1=' PPs.name '.stimuli.scoring.d1b1'];
eval(cmd);
cmd=[PPs.name '.stimuli.id.TFR2=' PPs.name '.stimuli.id.d1b2;'];
eval(cmd);
cmd=[PPs.name '.stimuli.scoring.TFR2=mirrorTFRSeq;'];
eval(cmd);