function [m sd n] = MFST_MC_selectData(data, measure, summaryType, level, trialSelect, numTrialSelect)
% Function to select a subset of data from the data matrix. This function
% averages across levels of summaryType and level. Returns mean, stddev,
% and n. Removes NaNs from the data set prior to averaging.
%
%
% input:
% <data>        - all data to be averaged over [ID, measure, day, block, trial, mean/SD]
% <measure>     - which DV to index
% <summaryType> - request extraction of {'Individual', 'Group'} average data
% <level>       - level at which the data should be averaged {'Trial', 'Block', 'Day'}
% <trialSelect>   - select a particular number of trials per block to create averages from {true,false}
% <numTrialSelect>- the number of trials to select
%
% output:
% <m>           - mean
% <sd>          - standard deviation
% <n>           - number of observations included in m/sd
%
% --
% example usage
% figure; hold on;
% measure = 1; %select proportion correct in this case
% [m sd n] = MFST_MC_selectData(PPs.all.data.LRN,measure,'Individual','Day');
% for idx=1:size(m,1)
%     plot(m(idx,:), 'bo:');
% end
% hold off;

if nargin == 4
    trialSelect=false;
    numTrialSelect=NaN;
end

dataSize=size(data); %assumes the proper data structure from MFST_MC scoring
selectedTrials=logical(ones(dataSize(5),1));

if trialSelect
    %XXX hard-coding alert
    %set random seed so that we can always replicate the randomisation used for
    %selecting the same number of LRN sequences as RND sequences (of which
    %there are four XXXX)
    if numTrialSelect==4
        selectedTrials=logical([1 0 0 1 0 0 1 0 0 1]); %1st, 4th, 7th, 10th trials used
    else
        warning('This program can currently only handle 4 RND/LRN sequences');
    end
end

m=[]; sd=[]; n=[];
%trial averages
for ID=1:dataSize(1)
    for day=1:dataSize(3)
        if strcmp(level, 'Day')
            dayData=squeeze(data(ID,measure,day,:,selectedTrials,1));
            dayData=reshape(dayData,1,numel(dayData));
            dayData(isnan(dayData))=[];
            m(ID,day)=nanmean(dayData);
            sd(ID,day)=nanstd(dayData);
            n(ID,day)=numel(dayData);
        else
            for block=1:dataSize(4)
                if strcmp(level, 'Block')
                    dayOffset=(day-1)*dataSize(4);
                    idx=dayOffset+block;
                    %clear NaN from data before averaging - this is lost data XXX
                    blockData=squeeze(data(ID,measure,day,block,selectedTrials,1)); %grab data
                    blockData=reshape(blockData,1,numel(blockData)); %make a single line
                    blockData(isnan(blockData))=[]; %get rid of NaNs
                    m(ID,idx)=nanmean(blockData);
                    sd(ID,idx)=nanstd(blockData);
                    n(ID,idx)=numel(blockData);
                elseif strcmp(level, 'Trial') % they should have then selected 'trial', but checking just in case
                    n=1; % n also not important as each is a single trial
                    for trial=1:dataSize(5)
                        dayOffset=(day-1)*dataSize(4)*dataSize(5);
                        blockOffset=(block-1)*dataSize(5);
                        idx=dayOffset+blockOffset+trial;
                        m(ID,idx)=data(ID,measure,day,block,trial,1);
                        sd(ID,idx)=data(ID,measure,day,block,trial,2); %SD only valid for trial information, calc for block/day
                        % n also not important as each is a single trial
                    end
                else
                    warning('You have not selected a valid level to output. Please choose Trial/Block/Day');
                end
            end
        end
    end
end

% average over individuals if group data if requested
if strcmp(summaryType, 'Group')
    if strcmp(level,'Trial') %trials could still have NaN, strip and calculate values
        for trial=1:size(m,2)
            %get rid of NaNs
            temp=m(:,trial);
            temp(isnan(temp))=[];
            temp_m(trial)=nanmean(temp);
            temp_sd(trial)=nanstd(temp);
            temp_n(trial)=numel(temp);
        end
        m=temp_m;
        sd=temp_sd;
        n=temp_n;
    else %actually still need to get rid of the nans here, but have to do so on a column by column basis
        %m(isnan(m))=[]; %get rid of NaNs
        sd=nanstd(m);
        n=size(m,1); %number of participants that you are averaging over
        m=nanmean(m);
    end
end