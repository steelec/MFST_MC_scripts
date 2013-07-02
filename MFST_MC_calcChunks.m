function PPs=MFST_MC_calcChunks(PPs,makePlots)

% MFST_MC_calcChunks
% Jun 2013, Chris Steele
% Script to calculate chunk sizes based on the code of Tim Verstyen
% First calculates lag correlations, then uses paired t-tests to calculate
% the size of the chunks.
%
% Input the standard processed PPs data structure
% Many settings can be changed directly in this file, they are denoted
% below at "START Change settings here"
%
%

temp.LRN=PPs.all.data.chunk.LRN;
temp.RND=PPs.all.data.chunk.RND;
dataSizeLRN=size(temp.LRN);

temp.N=dataSizeLRN(1);
days=dataSizeLRN(2);
blocks=dataSizeLRN(3);
trials=dataSizeLRN(4);
elements=dataSizeLRN(5);

temp.chunk.settings.makePlots=makePlots; %you figure out what this means yet?

%%%
% START Change settings here
%%%
temp.dayAvg=false; %if you want to look at the day rather than the block average
temp.replaceMissingWithMean=true; %otherwise fill with MAX value (500ms)
temp.regressOutLinear=true; % regress out a linear trend from the data (probably unecessary with small number of elements in each trial?)
temp.Mu='allSs_allDays'; % 'allSs_allDays' 'all' %only this or default, which is 'specificSs_specificDays' %'all' 'allSs_specificDays' 'specificSs_allDays' 'specificSs_specificDays' % population average for ttest calculation
temp.tcrit = abs(tinv(.05,1)); %6.3138 %t-critical for evaluating whether the chunk differed or not
temp.chunk.settings.xcorrBYtrial=true; %true if you want to calculate the xcorr over each trial, false if you are happy to throw them all into blocks (refer to conversation with Larry on this)
%%%
% END Change settings here
%%%


%%%%%
%%% START make lag correlations for each trial
%%%%%
for ID = 1:dataSizeLRN(1)
    for day=1:days
        temp.trials=[];
        temp.theRaw=[];
        temp.theRawRND=[];
        temp.RNDtrials=[];
        
        for block=1:blocks
            temp.theRaw=squeeze(temp.LRN(ID,day,block,:,:)); %all trials for one individual on one block
            temp.theRawRND=squeeze(temp.RND(ID,day,block,:,:));
            
            if temp.chunk.settings.xcorrBYtrial %if we are calculating the xcorr for each and every trial separately
                for trial=1:size(temp.theRaw,1) %now loop over each trial to calculate this lag for each trial
                    
                    temp.trials=temp.theRaw(trial,:)'; %convert to a single column
                    
                    %replace missing responses with max time or mean time that it would have
                    %taken to respond
                    if temp.replaceMissingWithMean
                        temp.trials(isnan(temp.trials))=nanmean(temp.trials); %XXX TIM actually used the mean of the responses
                    else
                        temp.trials(isnan(temp.trials))=500; %nanmean(temp.trials);
                    end
                    % remove the mean
                    temp.trials=temp.trials - mean(temp.trials);
                    
                    % regress out linear trend, pass temp.trials as a column
                    if temp.regressOutLinear
                        [temp.b,temp.bint,temp.trials]=regress(temp.trials,[1:length(temp.trials)]');
                    end
                    %
                    %get the autocorrelation for 13 lags out, excluding the first trial (13
                    %responses)
                    [C, lags] = xcorr(temp.trials,12,'coeff');
                    temp.chunk.xcorr.LRN(ID,(day-1)*6+block,trial,:) = C(13+1:end);
                    
                end
            else
                temp.trials=temp.theRaw'; %this makes sure that when we use :, we put one trial after another
                temp.trials=temp.trials(:); %convert all trials to a single column
                
                %replace missing responses with max time or mean time that it would have
                %taken to respond
                if temp.replaceMissingWithMean
                    temp.trials(isnan(temp.trials))=nanmean(temp.trials); %XXX TIM actually used the mean of the responses
                else
                    temp.trials(isnan(temp.trials))=500; %nanmean(temp.trials);
                end
                % remove the mean
                temp.trials=temp.trials - mean(temp.trials);
                
                % regress out linear trend, pass temp.trials as a column
                if temp.regressOutLinear
                    [temp.b,temp.bint,temp.trials]=regress(temp.trials,[1:length(temp.trials)]');
                end
                %
                %get the autocorrelation for 13 lags out, excluding the first trial (13
                %responses)
                [C, lags] = xcorr(temp.trials,12,'coeff');
                temp.chunk.xcorr.LRN(ID,(day-1)*6+block,:) = C(13+1:end);
                
            end
            %now the RND trials
            if temp.chunk.settings.xcorrBYtrial %if we are calculating the xcorr for each and every trial separately
                for trial=1:size(temp.theRawRND,1)
                    temp.RNDtrials=temp.theRawRND(trial,:)';
                    if temp.replaceMissingWithMean
                        temp.RNDtrials(isnan(temp.RNDtrials))=nanmean(temp.RNDtrials);
                    else
                        temp.RNDtrials(isnan(temp.RNDtrials))=500; %nanmean(temp.RNDtrials);
                    end
                    
                    
                    temp.RNDtrials=temp.RNDtrials - mean(temp.RNDtrials);
                    if temp.regressOutLinear
                        [temp.b,temp.bint,temp.RNDtrials]=regress(temp.RNDtrials,[1:length(temp.RNDtrials)]');
                    end
                    [RNDC, RNDlags] = xcorr(temp.RNDtrials,12,'coeff');
                    temp.chunk.xcorr.RND(ID,(day-1)*6+block,trial,:) = RNDC(13+1:end);
                end
            else
                temp.RNDtrials=temp.theRawRND';
                temp.RNDtrials=temp.RNDtrials(:);
                if temp.replaceMissingWithMean
                    temp.RNDtrials(isnan(temp.RNDtrials))=nanmean(temp.RNDtrials);
                else
                    temp.RNDtrials(isnan(temp.RNDtrials))=500; %nanmean(temp.RNDtrials);
                end
                
                
                temp.RNDtrials=temp.RNDtrials - mean(temp.RNDtrials);
                if temp.regressOutLinear
                    [temp.b,temp.bint,temp.RNDtrials]=regress(temp.RNDtrials,[1:length(temp.RNDtrials)]');
                end
                [RNDC, RNDlags] = xcorr(temp.RNDtrials,12,'coeff');
                temp.chunk.xcorr.RND(ID,(day-1)*6+block,:) = RNDC(13+1:end);
            end
        end
    end
end
%%%%%
%%% END make lag correlations for each trial
%%%%%

% % PLOTTING average over individuals
% m=[];RNDm=[];
% figure('name','Autocorrelation across blocks (LRN RND LRN-RND');
% clims=[-.5 .5]
% for ID = 1:length(IDs)
%     m=squeeze(temp.chunk.xcorr.LRN(ID,:,:,:))
%     m=squeeze(nanmean(m,2)); %avg across all trials in each block, I think XXX check this
%     %RNDm=squeeze(nanmean(temp.chunk.xcorr.RND,1));
%     RNDm=squeeze(temp.chunk.xcorr.RND(ID,:,:,:))
%     RNDm=squeeze(nanmean(RNDm,2)); %avg across all trials in each block, I think XXX check this
%     subplot(1,3,1);
%     imagesc(m,clims);
%     subplot(1,3,2);
%     imagesc(RNDm,clims);
%     subplot(1,3,3);
%     imagesc(m-RNDm,clims);
%     pause
% end

%%%%%
%%% START t-tests to calculate chunks
%%%%%

% %now run a bunch of ttests to see how many responses are chunked together
% %use the RAND m and sd from entire group as the null hypothesis, then do
% %t-test comparisons for each individual

% first, caculate the RND trials corr values for each block and day, per participant
% this serves as the null for comparison of LRN lag correlations

for ID=1:temp.N
    day=1;
    for block=1:days*blocks
        if temp.chunk.settings.xcorrBYtrial %then we need to do some averaging
            temp.chunk.xcorr.LRN_blockAvg_m(ID,block,:) = nanmean(squeeze((temp.chunk.xcorr.LRN(ID,block,:,:))),1); %one value per correlation per block
            temp.chunk.xcorr.LRN_blockAvg_sd(ID,block,:) = nanstd(squeeze((temp.chunk.xcorr.LRN(ID,block,:,:))),1);
            temp.chunk.xcorr.RND_blockAvg_m(ID,block,:) = nanmean(squeeze((temp.chunk.xcorr.RND(ID,block,:,:))),1); %one value per correlation per block
            temp.chunk.xcorr.RND_blockAvg_sd(ID,block,:) = nanstd(squeeze((temp.chunk.xcorr.RND(ID,block,:,:))),1);
        else %we already did the averaging in the step above
            temp.chunk.xcorr.LRN_blockAvg_m(ID,block,:) = squeeze((temp.chunk.xcorr.LRN(ID,block,:))); %one value per correlation per block
            temp.chunk.xcorr.LRN_blockAvg_sd(ID,block,:) = squeeze((temp.chunk.xcorr.LRN(ID,block,:)));
            
            temp.chunk.xcorr.RND_blockAvg_m(ID,block,:) = squeeze((temp.chunk.xcorr.RND(ID,block,:,:))); %one value per correlation per block
            temp.chunk.xcorr.RND_blockAvg_sd(ID,block,:) = squeeze((temp.chunk.xcorr.RND(ID,block,:,:)));
        end
        
        if sum(block == 1:6:days*blocks) == 1 %if we are at a block that starts a day
            %temp.chunk.xcorr.RND_dayAvg_m(ID,day,:) = nanmean(squeeze((temp.chunk.xcorr.RND(ID,block:block+5,:,:))),1)
            temp.theVal=squeeze((temp.chunk.xcorr.LRN(ID,block:block+5,:,:)));
            temp.theValRND=squeeze((temp.chunk.xcorr.RND(ID,block:block+5,:,:)));
            temp.a=[];
            temp.b=[];
            for ablock=1:blocks %create a matrix for all trials for each day
                temp.a=[temp.a ; squeeze(temp.theVal(ablock,:,:))];
                temp.b=[temp.b ; squeeze(temp.theValRND(ablock,:,:))];
            end
            %average across it
            temp.chunk.xcorr.LRN_dayAvg_m(ID,day,:) = nanmean(temp.a,1);
            temp.chunk.xcorr.LRN_dayAvg_sd(ID,day,:) = nanstd(temp.a,1);
            temp.chunk.xcorr.RND_dayAvg_m(ID,day,:) = nanmean(temp.b,1);
            temp.chunk.xcorr.RND_dayAvg_sd(ID,day,:) = nanstd(temp.b,1);
            day=day+1;
        end
    end
end

%%%%%
%%% START some plotting
%%%%%

% t(squeeze(temp.chunk.xcorr.RND_dayAvg_m(2,:,:))')
% figure;
% imagesc(squeeze(temp.chunk.xcorr.RND_blockAvg_m(6,:,:)),clims)

% figure;
% for ID=1:length(IDs)
%     subplot(1,3,1);
%     imagesc(squeeze(temp.chunk.xcorr.LRN_dayAvg_m(ID,:,:)),clims);
%     subplot(1,3,2);
%     imagesc(squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:)),clims)
%     subplot(1,3,3);
%     imagesc(squeeze(temp.chunk.xcorr.LRN_dayAvg_m(ID,:,:))-squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:)),clims)
%     pause;
% end


clims=[-.5 .5];
if temp.chunk.settings.makePlots
    if temp.dayAvg
        figure('name','group mean lag correlation (LRN, RND, LRN-RND)');
        subplot(1,3,1);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_dayAvg_m),1)),clims);
        subplot(1,3,2);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_m),1)),clims)
        subplot(1,3,3);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_dayAvg_m),1))-squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_m),1)),clims)
        figure('name','Correlation vs Lag in sequence'); %each line is a day
        errorbar(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_dayAvg_m),1))',squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_dayAvg_sd)./sqrt(temp.N),1))','o-'); hold on;
        errorbar(squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_m),1))',squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_sd)./sqrt(temp.N),1))','o:');
        hold off;
    else
        figure('name','group mean lag correlation (LRN, RND, LRN-RND)');
        subplot(1,3,1);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_blockAvg_m),1)),clims);
        subplot(1,3,2);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_blockAvg_m),1)),clims)
        subplot(1,3,3);
        imagesc(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_blockAvg_m),1))-squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_blockAvg_m),1)),clims)
        figure('name','Correlation vs Lag in sequence (by block)'); %each line is a day
        errorbar(squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_blockAvg_m),1))',squeeze(nanmean(squeeze(temp.chunk.xcorr.LRN_blockAvg_sd)./sqrt(temp.N),1))','o-'); hold on;
        errorbar(squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_blockAvg_m),1))',squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_blockAvg_sd)./sqrt(temp.N),1))','o:');
        hold off;
    end
end

%%%%%
%%% END some plotting
%%%%%


%%%%%
%%% CONTINUE ttesting to evaluate chunks
%%%%%

temp.chunk.t_vals=[];

temp.chunk.size = ones(temp.N,days);
temp.chunk.t_vals.byBlock=[];
RNDm=[];
RNDsd=[];


%now run those t-tests for each subject in each block
for ID=1:temp.N
    if strcmp(temp.Mu,'allSs_allDays')
        RNDm=squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:)),1)); %grab RNDm and sd for each participant (day avgs), average over all participants
        RNDsd=squeeze(nanmean(squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:)),1));
    elseif strcmp(temp.Mu,'all') %throw all correlation values into one
        RNDm=nanmean(temp.chunk.xcorr.RND_dayAvg_m(:)); %grab RNDm and sd for each participant (day avgs)
        RNDsd=nanmean(temp.chunk.xcorr.RND_dayAvg_m(:));
    else
        RNDm=squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:)); %grab RNDm and sd for each participant (day avgs)
        RNDsd=squeeze(temp.chunk.xcorr.RND_dayAvg_m(ID,:,:));
    end
    
    % check if we want to use the day or the block averages
    if temp.dayAvg
        looper=days;
        temp.theVal = squeeze(temp.chunk.xcorr.LRN_dayAvg_m(ID,:,:)); %grab by block for LRN trials
    else
        looper=blocks*days;
        temp.theVal = squeeze(temp.chunk.xcorr.LRN_blockAvg_m(ID,:,:)); %grab by block for LRN trials
    end
    
    %now calculate the mean and sd for LRN and RND xcorr for this subject
    day=1;
    for block=1:looper
        temp.t_val=[];
        temp.m= temp.theVal(block,:);
        %temp.m=temp.m(:,2:end); %cut off the 1st correlation (position 1 to 1)
        %sd= nanstd(temp.theVal((day-1)*blocks+1:(day-1)*blocks+6,:),1);
        
        %loop over each element for ttests
        for elem=1:length(temp.m)
            if strcmp(temp.Mu,'allSs_allDays') %if we have already pulled all the data together, never changes for th
                temp.t_val(elem)=(temp.m(elem) - RNDm(elem))/(RNDsd(elem)./sqrt(temp.N));
            elseif strcmp(temp.Mu,'all')
                temp.t_val(elem)=(temp.m(elem) - RNDm)/(RNDsd./sqrt(temp.N));
            else
                temp.t_val(elem)=(temp.m(elem) - RNDm(day,elem))/(RNDsd(day,elem)./sqrt(temp.N));
                %temp.t_val(elem)=(temp.m(elem) - mean(RNDm(:)))/(mean(RNDsd(day,elem))./sqrt(temp.N));
            end
        end
        
        temp.t_val(temp.t_val<temp.tcrit)=0;
        temp.t_val(isnan(temp.t_val)) = 0; %set nans to 0 too
        
        temp.counter=0; %initialise to no sig chunks
        for pos=1:length(temp.t_val)
            if temp.t_val(pos) > 0
                temp.counter = temp.counter + 1;
            end
        end
        temp.chunk.size(ID,block) = temp.counter;
        %plot(temp.t_val,'o-'); hold on;
        temp.chunk.t_vals.byBlock(ID,block,:)=temp.t_val;
        %pause
        
        if temp.dayAvg %need this to make sure that days are counted when averaged across days
            day=day+1;
        end
        
        if sum(block == 7:6:days*blocks) == 1 %if we are at a block that starts a day
            day=day+1; %increment our day counter for the RNDm and RNDsd
        end
    end
    %pause
    hold off;
end
if temp.chunk.settings.makePlots
    figure;
    plot(temp.chunk.size','o-'); hold on;
    errorbar(mean(temp.chunk.size,1),std(temp.chunk.size,1)./sqrt(temp.N),'kx-','markersize',8,'linewidth',2);
    %plot(nanmean(m(:,15:end),1),'ko-','markersize',8,'linewidth',2);
end

fprintf('tcrit = %f.2 for pairwise comparisons of each lag correlation (LRN to RND)\n',temp.tcrit);
[h p ci stats]=ttest((temp.chunk.size(:,1)),(temp.chunk.size(:,end)));
fprintf('Ttest comparing 1st to last on number of chunks t=%f.2, p=%f.2\n',stats.tstat,p);

%%%%%
%%%  END t-tests to calculate chunks
%%%%%

%%%%%
%%%  START update structure
%%%%%
PPs.all.data.chunk.RTxcorr=temp.chunk;
PPs.all.data.chunk.RTxcorr.xcorr.header={'ID' 'Day' 'Block' 'Trial'};
PPs.all.data.chunk.RTxcorr.t_vals.header={'ID' 'Day/Block' 'Trial'};
PPs.all.data.chunk.RTxcorr.sizeHeader={'ID' 'Day/Block' 'Trial'};
%PPs.IDs = IDs;
%%%%%
%%%  END update structure
%%%%%
