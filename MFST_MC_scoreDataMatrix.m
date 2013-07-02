function PPs=MFST_MC_scoreDataMatrix(PPs,IDs,days,blocks)
% score the data and store it in a single 6D matrix, append to structure
%
% Data output to the struture is in the following form:
%PPs
%----<ID>
%--------Results (raw results read in from file)
%--------Scored (scored results)
%--------------D? (contains trial and block averages for all measures in LRN (trial/block) RND(block)
%--------------LRN/RND (contains day averages for LRN/RND)
%
% All scored data follows the form of row1:mean; row2:sd;
% row3:nummeasurements
% strucName='PPs'; %name of data structure that will hold all of the results
% 1,2,3,4,5,6 correspond to acc, lag1, lag2, dur, vel, iti
%
%

LRNseqID=2; %index of the LRN sequence in the config file. Should be the 1st sequence after the two practice sequences
cmd=['trials=size(' PPs.name '.' IDs{1} '.results.d1.acc,1);']; %get number of trials per block
eval(cmd);
cmd=['elements=size(' PPs.name '.' IDs{1} '.results.d1.acc,2);']; %get number of elements per trial
eval(cmd);
trialsPerBlock=trials/blocks;
%initialise matrix of ID,trialType,Measure,days,blocks,trials,elements)
bigDaddy={}; %zeros(size(IDs,2),2,6,days,blocks,trials,seqLength);
daySeq=[];

for ID=1:length(IDs) %loop on each individual
    for day=1:days %loop on each day
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
        
        %replace empty data w/ NaN
        dayLag1(cellfun(@isempty,dayLag1))={NaN};
        dayLag2(cellfun(@isempty,dayLag1))={NaN};
        dayDur(cellfun(@isempty,dayLag1))={NaN};
        dayVel(cellfun(@isempty,dayLag1))={NaN};
        dayIti(cellfun(@isempty,dayLag1))={NaN};
        
        %to see if I can do this without looping
        % XXX works, but difficult to pull out all vals for plotting/avging
        test=reshape(dayLag1,[elements trialsPerBlock blocks]);
        testp=permute(test,[3 2 1]);
        
        
        %grab the day's order of presentation in each block (1=repeat;
        %0=random) and convert to 1=LRN; 2=RND for indexing within the cell
        %array
        for block=1:blocks
            cmd=['aBlock=' PPs.name  '.stimuli.id.d' num2str(day) 'b' num2str(block) ';'];
            eval(cmd);
            daySeq=[daySeq (aBlock~=LRNseqID)+1];
        end
        
        % calc measures per block
        % necessary to loop b/c different number of trials/blocks must be
        % indexed
        for block=1:blocks %loop on each block
            % calculate measures per trial
            for trial=1:trialsPerBlock
                bigDaddy(ID,daySeq(trial),1,day,block,trial,:)=dayAcc(trial,:);
                bigDaddy(ID,daySeq(trial),2,day,block,trial,:)=dayLag1(trial,:);
                bigDaddy(ID,daySeq(trial),3,day,block,trial,:)=dayLag2(trial,:);
                bigDaddy(ID,daySeq(trial),4,day,block,trial,:)=dayDur(trial,:);
                bigDaddy(ID,daySeq(trial),5,day,block,trial,:)=dayVel(trial,:);
                bigDaddy(ID,daySeq(trial),6,day,block,trial,:)=cellAppend(dayIti(trial,:),'right',{[]});
                %                 accT(trial)=sum(cell2mat(dayAcc(trial,:))==1)/size(dayAcc,2);
                %                 lag1T(trial)=mean(abs(cell2mat(dayLag1(trial,:))));
                %                 lag2T(trial)=mean(abs(cell2mat(dayLag2(trial,:))));
                %                 durT(trial)=mean(cell2mat(dayDur(trial,:)));
                %                 velT(trial)=mean(cell2mat(dayVel(trial,:)));
                %                 itiT(trial)=mean(cell2mat(dayIti(trial,:)));                
            end %trial
        end %block
    end %day
end %participant
PPs.all.header={'ID' 'Sequence Type' 'DV' 'Day' 'Block' 'Trial' 'Element' };
PPs.all.IDs=IDs;
PPs.all.measures={'Correct' 'Onset Lag' 'Offset Lag' 'Velocity' 'Duration' 'Intertap Interval'};
PPs.all.data=bigDaddy;