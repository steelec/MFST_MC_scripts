function PPs=MFST_MC_scoreData(PPs,IDs,days,blocks)
% score the data and create summaries
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
% PPs.name='PPs'; %name of data structure that will hold all of the results
seqlength=13;
LRNseqID=2; %index of the LRN sequence in the config file. Should be the 1st sequence after the two practice sequences
daySeq=[];

for ID=1:length(IDs) %loop on each individual
    for day=1:days %loop on each day
        thisDayLRN=[];
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
        
        %grab the day's order of presentation in each block (1=repeat;
        %0=random) and convert to logical for use in separating responses
        for block=1:blocks
            cmd=['aBlock=' PPs.name '.stimuli.id.d' num2str(day) 'b' num2str(block) ';'];
            eval(cmd);
            daySeq(block,:)=aBlock==LRNseqID;
        end
        
        for block=1:blocks %loop on each block
            % calculate measures per trial
            % at this point all repeated and random sequences are included
            for trial=1:size(dayAcc,1)
                accT(trial)=sum(cell2mat(dayAcc(trial,:))==1)/size(dayAcc,2);
                lag1T(trial)=mean(abs(cell2mat(dayLag1(trial,:))));
                lag2T(trial)=mean(abs(cell2mat(dayLag2(trial,:))));
                durT(trial)=mean(cell2mat(dayDur(trial,:)));
                velT(trial)=mean(cell2mat(dayVel(trial,:)));
                itiT(trial)=mean(cell2mat(dayIti(trial,:)));
            end
            
            
            %now create the block averages
            
            % the identification of the sequence trials
            thisBlockLRN=logical(daySeq(block,:))';
            
            startTrial=(block-1)*size(dayAcc,1)/blocks+1; %calculate start and stop trials for each block
            endTrial=block*(size(dayAcc,1)/blocks);
            
            %Acc
            thisBlockAcc=cell2mat(dayAcc(startTrial:endTrial,:));
            accB(1,block)=sum(sum(thisBlockAcc(thisBlockLRN,:)==1))/(sum(thisBlockLRN)*seqlength);
            accBRND(1,block)=sum(sum(thisBlockAcc(~thisBlockLRN,:)==1))/(sum(thisBlockLRN)*seqlength);
            
            %Lag1
            %XXX currently taking the mean of the abs value of resp
            tmp=dayLag1(startTrial:endTrial,:);
            thisBlockLag1=reshape(tmp(thisBlockLRN,:),1,[]);
            thisBlockLag1RND=reshape(tmp(~thisBlockLRN,:),1,[]);
            lag1B(1,block)=mean(abs(cell2mat(thisBlockLag1)));
            lag1BRND(1,block)=mean(abs(cell2mat(thisBlockLag1RND)));
            lag1B(2,block)=std(abs(cell2mat(thisBlockLag1)));
            lag1BRND(2,block)=std(abs(cell2mat(thisBlockLag1RND)));
            lag1B(3,block)=length(abs(cell2mat(thisBlockLag1)));
            lag1BRND(3,block)=length(abs(cell2mat(thisBlockLag1RND)));
            
            
            %Lag2
            tmp=dayLag2(startTrial:endTrial,:);
            thisBlockLag2=reshape(tmp(thisBlockLRN,:),1,[]);
            thisBlockLag2RND=reshape(tmp(~thisBlockLRN,:),1,[]);
            lag2B(1,block)=mean(abs(cell2mat(thisBlockLag2)));
            lag2BRND(1,block)=mean(abs(cell2mat(thisBlockLag2RND)));
            lag2B(2,block)=std(abs(cell2mat(thisBlockLag2)));
            lag2BRND(2,block)=std(abs(cell2mat(thisBlockLag2RND)));
            lag2B(3,block)=length(abs(cell2mat(thisBlockLag2)));
            lag2BRND(3,block)=length(abs(cell2mat(thisBlockLag2RND)));
            
            %thisBlockLag2=reshape(dayLag2(startTrial:endTrial,:),1,[]);
            %thisBlockVel=reshape(dayVel(startTrial:endTrial,:),1,[]);
            %thisBlockIti=reshape(dayIti(startTrial:endTrial,:),1,[]);
            
            %Dur
            tmp=dayDur(startTrial:endTrial,:);
            thisBlockDur=reshape(tmp(thisBlockLRN,:),1,[]);
            thisBlockDurRND=reshape(tmp(~thisBlockLRN,:),1,[]);
            durB(1,block)=mean(cell2mat(thisBlockDur));
            durBRND(1,block)=mean(cell2mat(thisBlockDurRND));
            durB(2,block)=std(cell2mat(thisBlockDur));
            durBRND(2,block)=std(cell2mat(thisBlockDurRND));
            durB(3,block)=length(cell2mat(thisBlockDur));
            durBRND(3,block)=length(cell2mat(thisBlockDurRND));
            
            %Vel
            tmp=dayVel(startTrial:endTrial,:);
            thisBlockVel=reshape(tmp(thisBlockLRN,:),1,[]);
            thisBlockVelRND=reshape(tmp(~thisBlockLRN,:),1,[]);
            velB(1,block)=mean(cell2mat(thisBlockVel));
            velBRND(1,block)=mean(cell2mat(thisBlockVelRND));
            velB(2,block)=std(cell2mat(thisBlockVel));
            velBRND(2,block)=std(cell2mat(thisBlockVelRND));
            velB(3,block)=length(cell2mat(thisBlockVel));
            velBRND(3,block)=length(cell2mat(thisBlockVelRND));
            %XXX look into NaN case in Velocity (when no keys were pressed correctly?)
            %
            
            %Iti
            tmp=dayIti(startTrial:endTrial,:);
            thisBlockIti=reshape(tmp(thisBlockLRN,:),1,[]);
            thisBlockItiRND=reshape(tmp(~thisBlockLRN,:),1,[]);
            itiB(1,block)=mean(cell2mat(thisBlockIti));
            itiBRND(1,block)=mean(cell2mat(thisBlockItiRND));
            itiB(2,block)=std(cell2mat(thisBlockIti));
            itiBRND(2,block)=std(cell2mat(thisBlockItiRND));
            itiB(3,block)=length(cell2mat(thisBlockIti));
            itiBRND(3,block)=length(cell2mat(thisBlockItiRND));
            
            %keep track of the sequence trials for the entire day to use
            %below
            thisDayLRN=[thisDayLRN;thisBlockLRN];
                        tmp=dayLag1(startTrial:endTrial,:);
            thisBlockLag1=reshape(tmp(thisBlockLRN,:),1,[]);
        end
        %now create the day averages
        thisDayLRN=logical(thisDayLRN);
        
        %Acc
        thisDayAcc(day)=sum(sum(cell2mat(dayAcc(thisDayLRN,:))==1))/(size(cell2mat(dayAcc(thisDayLRN,:)),1)*seqlength);
        thisDayAccRND(day)=sum(sum(cell2mat(dayAcc(~thisDayLRN,:))==1))/(size(cell2mat(dayAcc(~thisDayLRN,:)),1)*seqlength);
        
        %Lag1
        %XXX currently taking the mean of the abs value of resp
        thisDayLag1(1,day)=mean(abs(cell2mat(reshape(dayLag1(thisDayLRN,:),1,[]))));
        thisDayLag1RND(1,day)=mean(abs(cell2mat(reshape(dayLag1(~thisDayLRN,:),1,[]))));
        thisDayLag1(2,day)=std(abs(cell2mat(reshape(dayLag1(thisDayLRN,:),1,[]))));
        thisDayLag1RND(2,day)=std(abs(cell2mat(reshape(dayLag1(~thisDayLRN,:),1,[]))));
        thisDayLag1(3,day)=length(abs(cell2mat(reshape(dayLag1(thisDayLRN,:),1,[]))));
        thisDayLag1RND(3,day)=length(abs(cell2mat(reshape(dayLag1(~thisDayLRN,:),1,[]))));
        %Lag2
        % XXX currently taking the mean of the abs value of resp
        thisDayLag2(1,day)=mean(abs(cell2mat(reshape(dayLag2(thisDayLRN,:),1,[]))));
        thisDayLag2RND(1,day)=mean(abs(cell2mat(reshape(dayLag2(~thisDayLRN,:),1,[]))));
        thisDayLag2(2,day)=std(abs(cell2mat(reshape(dayLag2(thisDayLRN,:),1,[]))));
        thisDayLag2RND(2,day)=std(abs(cell2mat(reshape(dayLag2(~thisDayLRN,:),1,[]))));
        thisDayLag2(3,day)=length(abs(cell2mat(reshape(dayLag2(thisDayLRN,:),1,[]))));
        thisDayLag2RND(3,day)=length(abs(cell2mat(reshape(dayLag2(~thisDayLRN,:),1,[]))));
        
        %Dur
        thisDayDur(1,day)=mean(cell2mat(reshape(dayDur(thisDayLRN,:),1,[])));
        thisDayDurRND(1,day)=mean(cell2mat(reshape(dayDur(~thisDayLRN,:),1,[])));
        thisDayDur(2,day)=std(cell2mat(reshape(dayDur(thisDayLRN,:),1,[])));
        thisDayDurRND(2,day)=std(cell2mat(reshape(dayDur(~thisDayLRN,:),1,[])));
        thisDayDur(3,day)=length(cell2mat(reshape(dayDur(thisDayLRN,:),1,[])));
        thisDayDurRND(3,day)=length(cell2mat(reshape(dayDur(~thisDayLRN,:),1,[])));        
        
        %Vel
        thisDayVel(1,day)=mean(cell2mat(reshape(dayVel(thisDayLRN,:),1,[])));
        thisDayVelRND(1,day)=mean(cell2mat(reshape(dayVel(~thisDayLRN,:),1,[])));
        thisDayVel(2,day)=std(cell2mat(reshape(dayVel(thisDayLRN,:),1,[])));
        thisDayVelRND(2,day)=std(cell2mat(reshape(dayVel(~thisDayLRN,:),1,[])));
        thisDayVel(3,day)=length(cell2mat(reshape(dayVel(thisDayLRN,:),1,[])));
        thisDayVelRND(3,day)=length(cell2mat(reshape(dayVel(~thisDayLRN,:),1,[])));
        
        %Iti
        thisDayIti(1,day)=mean(cell2mat(reshape(dayIti(thisDayLRN,:),1,[])));
        thisDayItiRND(1,day)=mean(cell2mat(reshape(dayIti(~thisDayLRN,:),1,[])));
        thisDayIti(2,day)=std(cell2mat(reshape(dayIti(thisDayLRN,:),1,[])));
        thisDayItiRND(2,day)=std(cell2mat(reshape(dayIti(~thisDayLRN,:),1,[])));
        thisDayIti(3,day)=length(cell2mat(reshape(dayIti(thisDayLRN,:),1,[])));
        thisDayItiRND(3,day)=length(cell2mat(reshape(dayIti(~thisDayLRN,:),1,[])));
        
        % write to data structure
        % by trial
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.accT=accT;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.lag1T=lag1T;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.lag2T=lag2T;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.durT=durT;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.velT=velT;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.itiT=itiT;'];
        eval(cmd);
        
        % by block
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.accB=accB;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.lag1B=lag1B;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.lag2B=lag2B;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.durB=durB;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.velB=velB;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.LRN.itiB=itiB;'];
        eval(cmd);
        
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.accB=accBRND;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.lag1B=lag1BRND;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.lag2B=lag2BRND;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.durB=durBRND;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.velB=velBRND;'];
        eval(cmd);
        cmd=[PPs.name '.' IDs{ID} '.scored.d' num2str(day) '.RND.itiB=itiBRND;'];
        eval(cmd);
    end
    % by day
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.accD=thisDayAcc;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.lag1D=thisDayLag1;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.lag2D=thisDayLag2;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.durD=thisDayDur;'];
    eval(cmd);   
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.velD=thisDayVel;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.itiD=thisDayIti;'];
    eval(cmd);
    
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.accD=thisDayAccRND;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.lag1D=thisDayLag1RND;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.lag2D=thisDayLag2RND;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.durD=thisDayDurRND;'];
    eval(cmd);    
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.velD=thisDayVelRND;'];
    eval(cmd);
    cmd=[PPs.name '.' IDs{ID} '.scored.RND.itiD=thisDayItiRND;'];
    
    %all trials by day
    cmd=[PPs.name '.' IDs{ID} '.scored.LRN.accT=thisDayAcc;'];
    eval(cmd);
end
%PPs.header={'ID' 'DV' 'Day' 'Block' 'Trial' 'Value'};