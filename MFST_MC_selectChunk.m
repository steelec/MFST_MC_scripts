function [m sd n]=MFST_MC_selectChunk(data,summaryType,trialSelect,numTrialSelect)
% Function to select chunking data and return in a format that is closer to useable. 
% This function averages across blocks for each individual. Returns mean, stddev,
% and n. Removes NaNs from the data set prior to averaging.
%
%
% input:
% <data>        - all data to be averaged over [ID, measure, day, block, trial, mean/SD]
% <summaryType> - request extraction of {'Individual', 'Group'} average data
% <trialSelect>   - select a particular number of trials per block to create averages from {true,false}
% <numTrialSelect>- the number of trials to select
%
% REMOVED <level>       - level at which the data should be averaged {'Block', 'Day'}
%
% output: <ID,blocks,stimNumber>
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

% data=PPs.all.data.chunk.LRN;


dataSize=size(data); %assumes the proper data structure from MFST_MC scoring

if nargin == 2
    trialSelect=false;
    numTrialSelect=NaN;
end

selectedTrials=logical(ones(dataSize(4),1));

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

for ID=1:dataSize(1)
    for day=1:dataSize(2)
        dayOffset=(day-1)*dataSize(3);
        for block=1:dataSize(3)
            idx=dayOffset+block;
            for stim=1:dataSize(5)
                stimData=squeeze(data(ID,day,block,selectedTrials,stim));
                m(ID,idx,stim)=mean(stimData(~isnan(stimData)));
                sd(ID,idx,stim)=std(stimData(~isnan(stimData)));
                n(ID,idx,stim)=numel(stimData(~isnan(stimData)));
            end
        end
    end
end

if strcmp(summaryType,'Group') %average over all participants for each block
    for block=1:size(m,2)
        for stim=1:size(m,3)
            thisData=squeeze(m(:,block,stim));
            grpM(block,stim)=mean(thisData(~isnan(thisData)));
            grpSD(block,stim)=std(thisData(~isnan(thisData)));
            grpN(block,stim)=numel(thisData(~isnan(thisData)));
        end
    end
    m=grpM;
    sd=grpSD;
    n=grpN;
elseif strcmp(summaryType,'Individual')
    %do nothing
else
    warning('You have not selected a valid summaryType. Please choose Individual/Group');
end