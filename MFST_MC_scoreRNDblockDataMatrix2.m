function PPs=MFST_MC_scoreRNDblockDataMatrix2(PPs,IDs,days,blocks)
% Score the element-wise data available in the input data matrix PPs as
% trial-specific mean and stdev, then store it in a single 6D matrix.
% Appends output to the input data structure (PPs).
%
% input:
% <PPs>     - data structure for MFST_MC
% <IDs>     - cell of text containing all subject IDs (e.g., Pilot_01)
% <days>    - number of days in the experiment
% <blocks>  - number of blocks of RND (famil) per day
%
% output:
% <PPs>     - updated MFST_MC data structure
%
% Data output to the struture is in the following form:
% adds:
%       - PPs.all.data.famil 6D matrix of data
%       - PPs.all.header - includes header for dimensions of
%         PPs.all.data.famil
%       - PPs.all.measures - includes measure names, here we don't look at
%       ACCELERATION or JERK so there are two fewer entries in
%       PPs.all.data.famil in "measures"
%
% See PPs.all.header for ordered dimensions of the array, PPs.all.measures
% for list of measure names
%




%initialise variables
LRNseqID=2; %index of the LRN sequence in the config file. Should be the 1st sequence after the two practice sequences (0,1,->2<-)
cmd=['trials=size(' PPs.name '.' IDs{1} '.results.d1famil1.acc,1);']; %get number of trials per block
eval(cmd);
% cmd=['elements=size(' PPs.name '.' IDs{1} '.results.d1famil1.acc,2);']; %get number of elements per trial
% eval(cmd);

for ID=1:length(IDs) %loop on each individual
    for day=1:days %loop on each day
        
        % calc measures per block (looped b/c I didn't feel like changing
        % the code after copying from script that does this for both LRN
        % and RND (all RND here, just do it)
        for block=1:blocks %loop on each block
            %get day values for each variable
            cmd=['dayAcc=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.acc;'];
            eval(cmd);
            cmd=['dayLag1=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.lag1;'];
            eval(cmd);
            cmd=['dayLag2=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.lag2;'];
            eval(cmd);
            cmd=['dayDur=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.dur;'];
            eval(cmd);
            cmd=['dayVel=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.vel;'];
            eval(cmd);
            cmd=['dayIti=' PPs.name '.' IDs{ID} '.results.d' num2str(day) 'famil' num2str(block) '.iti;'];
            eval(cmd);            
            
            % calculate measures per trial
            for trial=1:trials
                bigDaddy(ID,1,day,block,trial,1)=sum(cell2mat(dayAcc(trial,:))==1)/size(dayAcc,2);
                bigDaddy(ID,2,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag1(trial,:))));
                bigDaddy(ID,3,day,block,trial,1)=nanmean(squeeze(cell2mat(dayLag2(trial,:))));
                bigDaddy(ID,4,day,block,trial,1)=nanmean(squeeze(cell2mat(dayDur(trial,:))));
                bigDaddy(ID,5,day,block,trial,1)=nanmean(squeeze(cell2mat(dayVel(trial,:))));
                bigDaddy(ID,6,day,block,trial,1)=nanmean(squeeze(cell2mat(dayIti(trial,:))));
                
                %stdev
                bigDaddy(ID,1,day,block,trial,2)=0; %std always 0
                bigDaddy(ID,2,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag1(trial,:))));
                bigDaddy(ID,3,day,block,trial,2)=nanstd(squeeze(cell2mat(dayLag2(trial,:))));
                bigDaddy(ID,4,day,block,trial,2)=nanstd(squeeze(cell2mat(dayDur(trial,:))));
                bigDaddy(ID,5,day,block,trial,2)=nanstd(squeeze(cell2mat(dayVel(trial,:))));
                bigDaddy(ID,6,day,block,trial,2)=nanstd(squeeze(cell2mat(dayIti(trial,:))));
                
            end %trial
        end %block
    end %day
    fprintf('Scoring of famil RND blocks complete for participant %s\n',IDs{ID});
end %participant

PPs.all.data.famil=bigDaddy;
fprintf('All done, you can be happy now!! :-)\n');