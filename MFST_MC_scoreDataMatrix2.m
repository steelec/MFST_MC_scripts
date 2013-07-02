function PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,doTFR,doJerk)
% Score the element-wise data available in the input data matrix PPs as
% trial-specific mean and stdev, then store it in a single 6D matrix.
% Appends output to the input data structure (PPs).
%
% input:
% <PPs>     - data structure for MFST_MC
% <IDs>     - cell of text containing all subject IDs (e.g., Pilot_01)
% <days>    - number of days in the experiment
% <blocks>  - number of blocks per day
%
% output:
% <PPs>     - updated MFST_MC data structure
%
% Data output to the struture is in the following form:
% adds:
%       - PPs.all.data.{LRN, RND} 6D matrix of data
%       - PPs.all.header - includes header for dimensions of
%         PPs.all.data.{LRN, RND}
%       - PPs.all.measures - includes measure names
%
% See PPs.all.header for ordered dimensions of the array, PPs.all.measures
% for list of measure names
%
%
if nargin==4
    doTFR=true; %default is to score the transfer blocks as well
    doJerk=false;
end
if nargin==5
    doJerk=false;
end
%initialise variables
LRNseqID=2; %index of the LRN sequence in the config file. Should be the 1st sequence after the two practice sequences (0,1,->2<-)
cmd=['trials=size(' PPs.name '.' IDs{1} '.results.d1.acc,1);']; %get number of trials per block
eval(cmd);
cmd=['elements=size(' PPs.name '.' IDs{1} '.results.d1.acc,2);']; %get number of elements per trial
eval(cmd);
chunkLRN=[];
chunkRND=[];
bob=0;
for ID=1:length(IDs) %loop on each individual
    for day=1:days %loop on each day
        %get day values for each variable
        cmd=['dayAcc=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.acc;'];
        eval(cmd);
        cmd=['dayLag1=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag1;'];
        eval(cmd);
        cmd=['dayLag2=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.lag2;'];
        eval(cmd);
        cmd=['dayDur=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.dur;'];
        eval(cmd);
        cmd=['dayVel=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.vel;'];
        eval(cmd);
        cmd=['dayIti=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.iti;'];
        eval(cmd);
        
        if doJerk %this data was collected MoCap as well, so calculate all the way to jerk (vel, accel, jerk)
            cmd=['dayAccel=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.accel;'];
            eval(cmd);
            cmd=['dayJerk=' PPs.name '.' IDs{ID} '.results.d' num2str(day) '.jerk;'];
            eval(cmd);
        end
        
        if doTFR
            %get day values for TFR block 1
            cmd=['TFR1Acc=' PPs.name '.' IDs{ID} '.results.TFR1.acc;'];
            eval(cmd);
            cmd=['TFR1Lag1=' PPs.name '.' IDs{ID} '.results.TFR1.lag1;'];
            eval(cmd);
            cmd=['TFR1Lag2=' PPs.name '.' IDs{ID} '.results.TFR1.lag2;'];
            eval(cmd);
            cmd=['TFR1Dur=' PPs.name '.' IDs{ID} '.results.TFR1.dur;'];
            eval(cmd);
            cmd=['TFR1Vel=' PPs.name '.' IDs{ID} '.results.TFR1.vel;'];
            eval(cmd);
            cmd=['TFR1Iti=' PPs.name '.' IDs{ID} '.results.TFR1.iti;'];
            eval(cmd);
            
            %get day values for the second TFR block if it exists
            cmd=['test=isempty(' PPs.name '.' IDs{ID} '.results.TFR2);'];
            eval(cmd)
            if test==0
                TFR2Flag=true;
                cmd=['TFR2Acc=' PPs.name '.' IDs{ID} '.results.TFR2.acc;'];
                eval(cmd);
                cmd=['TFR2Lag1=' PPs.name '.' IDs{ID} '.results.TFR2.lag1;'];
                eval(cmd);
                cmd=['TFR2Lag2=' PPs.name '.' IDs{ID} '.results.TFR2.lag2;'];
                eval(cmd);
                cmd=['TFR2Dur=' PPs.name '.' IDs{ID} '.results.TFR2.dur;'];
                eval(cmd);
                cmd=['TFR2Vel=' PPs.name '.' IDs{ID} '.results.TFR2.vel;'];
                eval(cmd);
                cmd=['TFR2Iti=' PPs.name '.' IDs{ID} '.results.TFR2.iti;'];
                eval(cmd);
            else %no TFR2 files or scoring
                TFR2Flag=false; %XXX testing this
                TFR2_padding=cell(trials,elements);
                TFR2Acc=TFR2_padding;
                TFR2Lag1=TFR2_padding;
                TFR2Lag2=TFR2_padding;
                TFR2Dur=TFR2_padding;
                TFR2Vel=TFR2_padding;
                TFR2Iti=cell(trials,elements-1); %b/c there is one less data point for ITI
                clear TFR2_padding;
            end
        end
        %grab the day's order of presentation in each block (1=repeat;
        %0=random) and convert to 1=LRN; 2=RND for indexing
        daySeq=[];
        for block=1:blocks
            cmd=['aBlock=' PPs.name  '.stimuli.id.d' num2str(day) 'b' num2str(block) ';'];
            eval(cmd);
            daySeq=[daySeq (aBlock~=LRNseqID)+1];
        end
        
        %index LRN and RND trials in day's data
        idxLRN=find(daySeq==1);
        idxRND=find(daySeq==2);
        trialsPerBlockLRN=length(idxLRN)/blocks;
        trialsPerBlockRND=length(idxRND)/blocks;
        
        % calc measures per block
        % necessary to loop b/c different number of trials/blocks must be
        % indexed for LRN and RND
        for block=1:blocks %loop on each block
            % calculate measures per trial for LRN
            for trial=1:trialsPerBlockLRN
                idx=(block-1)*trialsPerBlockLRN+trial; %convert block and trial information into index for day
                bigDaddyLRN(ID,1,day,block,trial,1)=sum(cell2mat(dayAcc(idxLRN(idx),:))==1)/size(dayAcc,2);
                bigDaddyLRN(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag1(idxLRN(idx),:))));
                bigDaddyLRN(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag2(idxLRN(idx),:))));
                bigDaddyLRN(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(dayDur(idxLRN(idx),:))));
                bigDaddyLRN(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(dayVel(idxLRN(idx),:))));
                bigDaddyLRN(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(dayIti(idxLRN(idx),:))));
                if doJerk
                    bigDaddyLRN(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(dayAccel(idxLRN(idx),:))));
                    bigDaddyLRN(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(dayJerk(idxLRN(idx),:))));
                end
                
                %stdev
                bigDaddyLRN(ID,1,day,block,trial,2)=0; %std always 0
                bigDaddyLRN(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag1(idxLRN(idx),:))));
                bigDaddyLRN(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag2(idxLRN(idx),:))));
                bigDaddyLRN(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(dayDur(idxLRN(idx),:))));
                bigDaddyLRN(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(dayVel(idxLRN(idx),:))));
                bigDaddyLRN(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(dayIti(idxLRN(idx),:))));
                if doJerk
                    bigDaddyLRN(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(dayAccel(idxLRN(idx),:))));
                    bigDaddyLRN(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(dayJerk(idxLRN(idx),:))));
                end
                
                %basic RTs for chunking analyses
                temp=dayLag1(idxLRN(idx),:);
                temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data
                % fprintf('Idx %i\n',idx); %for testing purposes
                chunkLRN(ID,day,block,trial,:)=cell2mat(temp);
                
                %bigDaddy for transfer blocks (2)
                %scoring matrix not setup...
                if doTFR
                    if day==1 && block==1 %same design as d1b1 for TFR1
                        %mean
                        TFRLRN(ID,1,day,block,trial,1)=sum(cell2mat(TFR1Acc(idxLRN(idx),:))==1)/size(dayAcc,2);
                        TFRLRN(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Lag1(idxLRN(idx),:))));
                        TFRLRN(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Lag2(idxLRN(idx),:))));
                        TFRLRN(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Dur(idxLRN(idx),:))));
                        TFRLRN(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Vel(idxLRN(idx),:))));
                        TFRLRN(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Iti(idxLRN(idx),:))));
                        if doJerk
                            TFRLRN(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Accel(idxLRN(idx),:))));
                            TFRLRN(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Jerk(idxLRN(idx),:))));
                        end
                        %stdev
                        TFRLRN(ID,1,day,block,trial,2)=0;
                        TFRLRN(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Lag1(idxLRN(idx),:))));
                        TFRLRN(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Lag2(idxLRN(idx),:))));
                        TFRLRN(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Dur(idxLRN(idx),:))));
                        TFRLRN(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Vel(idxLRN(idx),:))));
                        TFRLRN(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Iti(idxLRN(idx),:))));
                        if doJerk
                            TFRLRN(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Accel(idxLRN(idx),:))));
                            TFRLRN(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Jerk(idxLRN(idx),:))));
                        end
                        
                        %basic RTs for chunking analyses
                        temp=TFR1Lag1(idxLRN(idx),:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data
                        TFR1chunkLRN(ID,day,block,trial,:)=cell2mat(temp);
                    elseif day==1 && block==2 && TFR2Flag %same design as d1b2 for TFR2
                        idx_correction=trialsPerBlockLRN+trialsPerBlockRND; %correction b/c this is the 2nd block (hence trial 15+) but TFR2Acc just contains a single block of data
                        %mean
                        %fprintf('TFR2 LRN trials: %i\n',idxLRN(idx)-idx_correction);
                        TFRLRN(ID,1,day,block,trial,1)=sum(cell2mat(TFR2Acc(idxLRN(idx)-idx_correction,:))==1)/size(dayAcc,2);
                        TFRLRN(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Lag1(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Lag2(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Dur(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Vel(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Iti(idxLRN(idx)-idx_correction,:))));
                        if doJerk
                            TFRLRN(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Accel(idxLRN(idx)-idx_correction,:))));
                            TFRLRN(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Jerk(idxLRN(idx)-idx_correction,:))));
                        end
                        
                        %stdev
                        TFRLRN(ID,1,day,block,trial,2)=0;
                        TFRLRN(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Lag1(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Lag2(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Dur(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Vel(idxLRN(idx)-idx_correction,:))));
                        TFRLRN(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Iti(idxLRN(idx)-idx_correction,:))));
                        if doJerk
                            TFRLRN(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Accel(idxLRN(idx)-idx_correction,:))));
                            TFRLRN(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Jerk(idxLRN(idx)-idx_correction,:))));
                        end
                        
                        %basic RTs for chunking analyses
                        temp=TFR2Lag1(idxLRN(idx)-idx_correction,:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data
                        TFR2chunkLRN(ID,day,block,trial,:)=cell2mat(temp);
                    elseif day==1 && block==2 && ~TFR2Flag %same design as d1b2 for TFR2
                        %mean
                        TFRLRN(ID,:,day,block,trial,1)=NaN;
                        
                        %stdev
                        TFRLRN(ID,:,day,block,trial,2)=NaN;
                        
                        %basic RTs for chunking analyses
                        temp=TFR2Lag1(idxLRN(idx),:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data
                        TFR2chunkLRN(ID,day,block,trial,:)=cell2mat(temp);
                    end
                end
            end %trial
            
            %RND trials
            for trial=1:trialsPerBlockRND
                idx=(block-1)*trialsPerBlockRND+trial; %convert block and trial information into index for day
                bigDaddyRND(ID,1,day,block,trial,1)=sum(cell2mat(dayAcc(idxRND(idx),:))==1)/size(dayAcc,2);
                bigDaddyRND(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag1(idxRND(idx),:))));
                bigDaddyRND(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag2(idxRND(idx),:))));
                bigDaddyRND(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(dayDur(idxRND(idx),:))));
                bigDaddyRND(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(dayVel(idxRND(idx),:))));
                bigDaddyRND(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(dayIti(idxRND(idx),:))));
                if doJerk
                    bigDaddyRND(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(dayAccel(idxRND(idx),:))));
                    bigDaddyRND(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(dayJerk(idxRND(idx),:))));
                end
                %stdev
                bigDaddyRND(ID,1,day,block,trial,2)=0; %std always 0
                bigDaddyRND(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag1(idxRND(idx),:))));
                bigDaddyRND(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag2(idxRND(idx),:))));
                bigDaddyRND(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(dayDur(idxRND(idx),:))));
                bigDaddyRND(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(dayVel(idxRND(idx),:))));
                bigDaddyLRN(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(dayIti(idxRND(idx),:))));
                if doJerk
                    bigDaddyRND(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(dayAccel(idxRND(idx),:))));
                    bigDaddyLRN(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(dayJerk(idxRND(idx),:))));
                end
                
                %basic RTs for chunking analyses
                temp=dayLag1(idxRND(idx),:);
                temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data (10s)
                chunkRND(ID,day,block,trial,:)=cell2mat(temp);
                
                                %bigDaddy for transfer blocks (2)
                %scoring matrix not setup...
                if doTFR
                    if day==1 && block==1 %same design as d1b1 for TFR1
                        %mean
                        TFRRND(ID,1,day,block,trial,1)=sum(cell2mat(TFR1Acc(idxRND(idx),:))==1)/size(dayAcc,2);
                        TFRRND(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Lag1(idxRND(idx),:))));
                        TFRRND(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Lag2(idxRND(idx),:))));
                        TFRRND(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Dur(idxRND(idx),:))));
                        TFRRND(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Vel(idxRND(idx),:))));
                        TFRRND(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Iti(idxRND(idx),:))));
                        if doJerk
                            TFRRND(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Accel(idxRND(idx),:))));
                            TFRRND(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR1Jerk(idxRND(idx),:))));
                        end
                        
                        %stdev
                        TFRRND(ID,1,day,block,trial,2)=0;
                        TFRRND(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Lag1(idxRND(idx),:))));
                        TFRRND(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Lag2(idxRND(idx),:))));
                        TFRRND(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Dur(idxRND(idx),:))));
                        TFRRND(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Vel(idxRND(idx),:))));
                        TFRRND(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Iti(idxRND(idx),:))));
                       if doJerk
                           TFRRND(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Accel(idxRND(idx),:))));
                           TFRRND(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR1Jerk(idxRND(idx),:))));
                       end
                       
                        %basic RTs for chunking analyses
                        temp=TFR1Lag1(idxRND(idx),:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data (10s)
                        TFR1chunkRND(ID,day,block,trial,:)=cell2mat(temp);
                    elseif day==1 && block==2 && TFR2Flag %same design as d1b2 for TFR2
                        idx_correction=trialsPerBlockLRN+trialsPerBlockRND;
                        %fprintf('TFR2 RND trials: %i\n',idxRND(idx)-idx_correction);
                        %mean
                        TFRRND(ID,1,day,block,trial,1)=sum(cell2mat(TFR2Acc(idxRND(idx)-idx_correction,:))==1)/size(dayAcc,2);
                        TFRRND(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Lag1(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Lag2(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Dur(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Vel(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Iti(idxRND(idx)-idx_correction,:))));
                        if doJerk
                            TFRRND(ID,7,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Accel(idxRND(idx)-idx_correction,:))));
                            TFRRND(ID,8,day,block,trial,1)=nanmean(squeeze(cell2mat(TFR2Jerk(idxRND(idx)-idx_correction,:))));
                        end
                        
                        %stdev
                        TFRRND(ID,1,day,block,trial,2)=0;
                        TFRRND(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Lag1(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Lag2(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Dur(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Vel(idxRND(idx)-idx_correction,:))));
                        TFRRND(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Iti(idxRND(idx)-idx_correction,:))));
                        if doJerk
                            TFRRND(ID,7,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Accel(idxRND(idx)-idx_correction,:))));
                            TFRRND(ID,8,day,block,trial,2)=nanstd(squeeze(cell2mat(TFR2Jerk(idxRND(idx)-idx_correction,:))));
                        end
                        
                        %basic RTs for chunking analyses
                        temp=TFR2Lag1(idxRND(idx)-idx_correction,:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data (10s)
                        TFR2chunkRND(ID,day,block,trial,:)=cell2mat(temp);
                    elseif day==1 && block==2 && ~TFR2Flag %same design as d1b2 for TFR2
                        %mean
                        TFRRND(ID,:,day,block,trial,1)=NaN;
                        
                        %stdev
                        TFRRND(ID,:,day,block,trial,2)=NaN;
                        
                        %basic RTs for chunking analyses
                        temp=TFR2Lag1(idxRND(idx),:);
                        temp(cellfun('isempty',temp))={NaN}; %insert nan as placeholder for missing data
                        TFR2chunkRND(ID,day,block,trial,:)=cell2mat(temp);
                    end
                end
            end %trial
            
            %reporting accuracy for each element in each block of practice
            %used to complement the chunking analysis
            %could also do this for TFR sequences if you cared...
            %ID, day, block, element
            if sum(idxLRN) == 0 %if we only presented random seqeunces
                chunkACCRND(ID,day,block,:)=sum(cell2mat(dayAcc(idxRND,:))==1)/size(dayAcc(idxRND,1),1); %do the RND ones
                chunkACCLRN(ID,day,block,:)=ones(size(chunkACCRND(ID,day,block,:))).*NaN; %set the LRN to NaN
            elseif sum(idxRND) ==0 % or no RNDs
                chunkACCLRN(ID,day,block,:)=sum(cell2mat(dayAcc(idxLRN,:))==1)/size(dayAcc(idxLRN,1),1);
                chunkACCRND(ID,day,block,:)=ones(size(chunkACCLRN(ID,day,block,:))).*NaN; %set the LRN to NaN
            else
                chunkACCLRN(ID,day,block,:)=sum(cell2mat(dayAcc(idxLRN,:))==1)/size(dayAcc(idxLRN,1),1);
                chunkACCRND(ID,day,block,:)=sum(cell2mat(dayAcc(idxRND,:))==1)/size(dayAcc(idxRND,1),1); %do the RND ones
            end
            
        end %block
    end %day
    fprintf('Scoring complete for participant %s\n',IDs{ID});
end %participant
% chunkLRN(chunkLRN==10000)=NaN;
PPs.all.header={'ID' 'DV/Measure' 'Day' 'Block' 'Trial' 'Mean or SD'};
PPs.all.IDs=IDs;

if ~doJerk %if the mocap data was not collected
    PPs.all.measures={'Correct' 'Onset Lag' 'Offset Lag' 'Duration' 'Velocity' 'Intertap Interval'};
else
    PPs.all.measures={'Correct' 'Onset Lag' 'Offset Lag' 'Duration' 'Velocity' 'Intertap Interval' 'Acceleration' 'Jerk'};
end

PPs.all.data.LRN=bigDaddyLRN;
PPs.all.data.RND=bigDaddyRND;
PPs.all.data.chunk.chunkHeader={'ID' 'Day' 'Block' 'Trial' 'Element'};
PPs.all.data.chunk.LRN=chunkLRN;
PPs.all.data.chunk.RND=chunkRND;
if doTFR
    PPs.all.data.chunk.TFR1LRN=TFR1chunkLRN;
    PPs.all.data.chunk.TFR1RND=TFR1chunkRND;
    if TFR2Flag
        PPs.all.data.chunk.TFR2LRN=TFR2chunkLRN;
        PPs.all.data.chunk.TFR2RND=TFR2chunkRND;
    end
end
PPs.all.data.chunk.chunkAccHeader={'ID' 'Day' 'Block' 'Element'};
PPs.all.data.chunk.LRNacc=chunkACCLRN;
PPs.all.data.chunk.RNDacc=chunkACCRND;
if doTFR
    PPs.all.data.TFR.LRN=TFRLRN;
    PPs.all.data.TFR.RND=TFRRND;
end
fprintf('All done, you can be happy now!! :-)\n');