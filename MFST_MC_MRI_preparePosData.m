function PPs=MFST_MC_MRI_preparePosData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,repeatedSequenceID,suppressOutput,CONV)
% Prepare MFST data for scoring
%
% Requires that the sequences structure has been created with
% gen13ElementSeqs (note that this generates a particular set of sequences
% based on particular random seed - for Chris' MFST_MC experiment the seed
% was 19750909
% Edited to work with new data files from LabView MRI program
% Works with PARSED data files of the following format: [IDs{ID} '_d' num2str(day) 'b' num2str(block) '_PARSED.txt'];
% file format: 3 columns with {keyID Position PSOCTimestamp}
% keyID {0..4} (where 0=MRI trigger, 1-4=keys)
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
% W
%
%
if nargin==9
    suppressOutput=false;
    CONV=true;
end

fprintf('Participant position data is being read and preapared');
for ID=1:length(IDs) %loop on each individual
    if ~suppressOutput
        fprintf(2,'Participant %s\n',IDs{ID})
    end
    for day=1:days %loop on each day
        % intialise all variables for each day
        LRNSeqPosn=[];
        if ~suppressOutput
            fprintf('Day %i\n',day);
        end
        for block=1:blocks %loop on each block
            if ~suppressOutput
                fprintf('Block %i ',block);
            end
            fileName=[IDs{ID} '_d' num2str(day) 'b' num2str(block) '_PARSED.txt'];
            cmd=['presentedSequences=' PPs.name '.stimuli.scoring.d' num2str(day) 'b' num2str(block) ';'];
            eval(cmd);
            %DO PROCESSING HERE
            %scoreMFST_MC_MRI_Pos(strcat(dataDir,fileName));
            data = load(strcat(dataDir,fileName), '\t'); %this throws out all of the information about trials that was saved as text
            k0.raw=sortrows(data(data(:,1)==0,:),3);
            k1.U=data(data(:,2)==0 & data(:,1)==1,:); %keyup
            k1.D=data(data(:,2)==127 & data(:,1)==1,:); %keydown
            
            k2.U=data(data(:,2)==0 & data(:,1)==2,:);
            k2.D=data(data(:,2)==127 & data(:,1)==2,:);

            k3.U=data(data(:,2)==0 & data(:,1)==3,:);
            k3.D=data(data(:,2)==127 & data(:,1)==3,:);

            k4.U=data(data(:,2)==0 & data(:,1)==4,:);
            k4.D=data(data(:,2)==127 & data(:,1)==4,:);
            
            data(data(:,2)==127 | data(:,2)==0,:)=[]; % cut out the key up and key down vals
            k1.pos=sortrows(data(data(:,1)==1,:),3);
            k2.pos=sortrows(data(data(:,1)==2,:),3);
            k3.pos=sortrows(data(data(:,1)==3,:),3);
            k4.pos=sortrows(data(data(:,1)==4,:),3);
        end
%         %DO UPDATING OF STRUCTURE HERE
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.acc=acc;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag1=lag1;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag2=lag2;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.dur=dur;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.vel=vel;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.iti=iti;'];
%         eval(cmd);
%         cmd=[PPs.name '.' IDs{ID} '.results.d' num2str(day) '.LRNSeqPosn=LRNSeqPosn;'];
%         eval(cmd);
    end
end