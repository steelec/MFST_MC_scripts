function PPs=MFST_MC_prepareRNDblockData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,repeatedSequenceID,suppressOutput,CONV)
% Prepare MFST PRE/POST RND block data for scoring
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
%   <blocks>                - # of blocks/day of RND blocks "famil" in this experiment
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

fprintf(2,'Scoring pre/post random blocks for %i participants. (P??_d?famil?.txt)\n',length(IDs));

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
            fileName=[IDs{ID} '_d' num2str(day) 'famil' num2str(block) '.txt'];
            outName=strrep(fileName,'.txt','.xls'); %cut off the .txt from the filename
            
            cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d' num2str(day) 'famil' num2str(block) ';'];
            eval(cmd);

            [bacc, blag1, blag2, bdur, bvel, biti] = scoreAdaptiveMFST([dataDir '/' fileName],[dataDir '/' outName], presentedSequences, scoringWindowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV);
            acc=cellAppend(acc, 'down', bacc);
            lag1=cellAppend(lag1, 'down', blag1);
            lag2=cellAppend(lag2, 'down', blag2);
            dur=cellAppend(dur, 'down', bdur);
            vel=cellAppend(vel, 'down', bvel);
            iti=cellAppend(iti, 'down', biti);
        end
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.acc=acc;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.lag1=lag1;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.lag2=lag2;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.dur=dur;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.vel=vel;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.iti=iti;'];
        eval(cmd);

    end
end