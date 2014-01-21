function PPs=MFST_MC_prepareData2(dataDir,PPs,IDs,days,blocks,elemsPerSeq,scoringWindowOffset,ISI,repeatedSequenceID,suppressOutput,keyorder,parseType,showVisuals)
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
%   <elemsPerSeq>           - # of elements per sequence
%   <scoringWindowOffset>   - time b4 stim onset to consider keypress correct (in ms)
%   <ISI>                   - time between stims
%   <repeatedSequenceID>    - id of sequence that is repeated (LRN sequence)
%   <suppresOutput>         - suppress informational output to the screen (speeds it up!) (default is false)
%
% output:
%   <PPs>                   - data structure for prepared output for these
%                             participants
%
if nargin==9
    suppressOutput=false;
    showVisuals = false;
end

for ID=1:length(IDs) %loop on each individual
    if ~suppressOutput
        fprintf(2,'Participant %s\n',IDs{ID})
    end
    for i=1:length(days) %loop on each day that we are interested in
        day = days(i); %which day are we talking about here
        % intialise all variables for each day
        acc={};
        lag1={};
        lag2={};
        dur={};
        vel={};
        accel={};
        jerk={};
        iti={};
        LRNSeqPosn=[];
        if ~suppressOutput
            fprintf('Day %i\n',day);
        end
        
        [dacc, dlag1, dlag2, ddur, dvel, daccel, djerk, diti] = WindowSlidingScore2(dataDir,IDs{ID}, day, elemsPerSeq, scoringWindowOffset, ISI, suppressOutput,keyorder,parseType,showVisuals);
        
        acc=cellAppend(acc, 'down', dacc{1});
        lag1=cellAppend(lag1, 'down', dlag1{1});
        lag2=cellAppend(lag2, 'down', dlag2{1});
        dur=cellAppend(dur, 'down', ddur{1});
        vel=cellAppend(vel, 'down', dvel{1});
        accel=cellAppend(accel, 'down', daccel{1});
        jerk=cellAppend(jerk, 'down', djerk{1});
        iti=cellAppend(iti, 'down', diti{1});
        
        for block = 1:blocks
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
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.accel=accel;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.jerk=jerk;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.iti=iti;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.LRNSeqPosn=LRNSeqPosn;'];
        eval(cmd);
    end % for each day
    disp(['ID #' num2str(ID)]);
end % for each subject