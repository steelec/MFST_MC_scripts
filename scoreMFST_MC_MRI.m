function [acc, lag1, lag2, dur, vel, iti] = scoreMFST_MC_MRI(in_file, out_file, in_sequences, in_windowOffset, beforeTrialDelay, stimDuration,suppressOutput,CONV)
% Example to run use: scoreAdaptiveMFST('C:\Documents and Settings\Alejandro\My Documents\Matlab\adapt\RG19\RG19_B1.txt', 'C:\Documents and Settings\Alejandro\My Documents\Matlab\adapt\RG19\RG19_B1out-tmp4.txt', sequencesb1, -100)
% Note: need to define sequencesb1 = [4 1 3 4 2 3 1 2 4 3; 4 1 3 4 2 3 1 2 4 3; 1  2  4  2  3  1  4  3  4  1; 4 1 3 4 2 3 1 2 4 3; 4 1 3 4 2 3 1 2 4 3;
%4 1 3 4 2 3 1 2 4 3; 2  1  3  1  4  3  2  3  4  2 ;4 1 3 4 2 3 1 2 4 3;4 1 3 4 2 3 1 2 4 3; 2  1  4  1  3  2  4  3  4  2; 4 1 3 4 2 3 1 2 4 3;4 1 3 4 2 3 1 2 4 3;3  1  3  2  4  2  1  4  3  4 ; 4 1 3 4 2 3 1 2 4 3]
%
% Extensively Modified by Chris Steele (July 2, 2011)
% Extra code removed, made compliant with LabView program used for MRI
% acquisition.
%
%Author: Alejandro Endo
%Date: 2/07/08
%Description:
%
% input:
%   <in_file>           - input file
%   <out_file>          - output file
%   <in_sequences>      - sequences that were presented, will be used to score
%   <in_windowOffset>   - scoring window offset for considering keypresses as correct prior to stimulus onset (in ms)
%   <beforeTrialDelay>  - time before presentation of 1st element (in ms)
%   <stimDuration>      - duration of stimuli
%   <suppressOutput>    - suppress output true/false
%   <CONV>              - set to true/false if need to multiply stim onset times by 1000 to convert to ms
%
% output:
%   <acc lag1 lag2 dur vel iti>
%                       - scored variables accuracy, onset lat, offset lag,
%                       duration, velocity, intertap interval
%
% XXX Chris initialised output vars.
% And added everything to do with lag2, dur, vel, and output of ITI.
% the function windowSlidingScoring was also substantially altered to
% produce equivalent outputs for these measures.
% beforeTrialDelay variable added to re-align timers

acc={};
lag1={};
lag2={};
dur={};
vel={};
iti={};
warn_total=0;

%if the old program was used to collect this data (with stim ons in seconds
%and all other times in ms, then set the conversion value.
if CONV == true
    CONV_VAL=1000;
else
    CONV_VAL=1;
end

data = vectorizedReadf(in_file, '\t');

row = 9; %stims start in row 9
trialOffset=6; %num rows from one trial's stimons to subsequent
trialCount = 1;

%% Process Data
while (row <= size(data,1)) %loop for every trial
    stims = cell2num(cellTrim(data(row,:))); %stim times
    stims = stims*CONV_VAL; %convert to ms, if required
    keys = cell2num(cellTrim(data(row+1,:)));
    speeds = cell2num(cellTrim(data(row+4,:)));
    speedsOn = speeds(speeds ~= 0);
    timestamps = cell2num(cellTrim(data(row+2,:)))+beforeTrialDelay; %responses times + beforeTrialDelay to account for timer mismatch in Adaptive MFST
    %this is the PSOC timestamp, in ms (used b/c should be more acc. than LV but may be problematic b/c we need to link PSOC response times to LV stim presentation times
    checkTimestamps(cell2num(cellTrim(data(row+3,:)))+beforeTrialDelay,cell2num(cellTrim(data(row+2,:)))); %labview time, then PSOC time
    if (length(keys) ~= length(speeds) || length(speeds) ~= length(timestamps))
        warning('scoreAdaptiveMFST:dataValidation',['Data mismatch, Length of data does not agree in ' in_file]);
    end
    
    
    responseSeq = keys(speeds ~=0); %sequence of response onsets
    responseTimes = timestamps(speeds ~=0); %time of response onsets
    responseOffsets= timestamps(speeds ==0); %time of response offsets
    responseSeqNormal = normalizeSequence(responseSeq); %normalize responses to 1-based
    
    
    %check to make sure that an equal number of key on and keyoff's were
    %recorded - sometimes keyoff is missed if trial finishes while key
    %depressed and sometimes there is an offset at the start of the trial -
    %this cuts off all of the extra partial key onset/offsets
    %this has no effect on the accuracy measure, but can effect the extra
    %keys calculation when an onset is cut from the end of the trial.
    doneChop=false;
    idx=0; %how many times have we checked...?
    while ~doneChop
        %for cases where the number of onsets/offsets is exactly equal, but
        %there is a partial response at the beginning AND at the end of the
        %trial (NOT COVERED IN cutPartialResp) (determined by velocity check)
        if speeds(1+idx) == 0 && speeds(end-idx) ~= 0
            responseOffsets=responseOffsets(1,2:end); % chop
            responseTimes=responseTimes(1,1:(end-1)); % chop
            doneChop=false; %changed something, check again
            idx=idx+1; %update this counter to check if another pair of partial offset/onsets exist
        else
            doneChop=true; %nothing to change here
        end
        [responseOffsets responseTimes doneChop] = cutPartialResp(responseOffsets, responseTimes);
    end
    
    badDurs=false; %initialise that there are no bad duration responses (<0) for this trial
    
    %do sliding scoring
    %Note that the RT, lag2temp variables kept for output here are
    %NOT USED for MFST_MC b/c there is a second type of scoring based on whether or not
    %the correct key was pressed. assignment and score are used.
    [RT, lag2temp, durtemp, assignment, score, warn] = windowSlidingScoring(stims, responseTimes, responseOffsets, in_windowOffset, in_sequences(trialCount, :), responseSeqNormal, stimDuration);
    
    warn_total=warn+warn_total;
    
    if ~isempty(durtemp(durtemp<0))
        warning('The duration information for at least some of this trial is not valid.');
        fprintf('Durations and offset lag measures have been set to [] for this trial.\nThere is no effect on the other measures.\n\n');
        badDurs=true;
    end
    %Find RTs
    correctPositions = find(score == 1);
    RTs = cell(1, length(stims));
    lag2s = cell(1, length(stims));
    durs = cell(1, length(stims));
    speedsGood = cell(1, length(stims));
    %     if length(unique(assignment(assignment>0)))<length(assignment(assignment>0)) %if all responses are not unique, we need to do something (error occured in windowSlidingScoring that attached 2 resp to 1 stim)
    %         warning('More than one "correct" response was attached to a single stim. This needs to be corrected. I just cut one of them out as a quick fix.');
    %
    %     end
    for count=1:length(correctPositions)
        responseInWindow = find(correctPositions(count) == assignment); %find response # in that window
        if length(responseOffsets(correctPositions(count) == assignment))>1
            warning('More than one "correct" response was attached to a single stim. This needs to be corrected. The first response has been retained.');
            tempTime=responseTimes(correctPositions(count) == assignment);
            tempOffs=responseOffsets(correctPositions(count) == assignment);
            RTs{correctPositions(count)} = tempTime(1)-stims(correctPositions(count));
            lag2s{correctPositions(count)} = tempOffs(1)-(stims(correctPositions(count))+stimDuration);
            durs{correctPositions(count)} = tempOffs(1) - tempTime(1);    
        else
            RTs{correctPositions(count)} = responseTimes(correctPositions(count) == assignment)-stims(correctPositions(count));
            lag2s{correctPositions(count)} = responseOffsets(correctPositions(count) == assignment)-(stims(correctPositions(count))+stimDuration);
            durs{correctPositions(count)} = responseOffsets(correctPositions(count) == assignment) - responseTimes(correctPositions(count) == assignment);
            speedsGood{correctPositions(count)} = speedsOn(correctPositions(count) == assignment);
        end
    end
    
    %if duration information is bad, re-initialise to empty
    if badDurs
        durs = cell(1, length(stims));
        lag2s = cell(1, length(stims));
    end
    
    oneLine = {['Trial ' num2str(trialCount)], ' ' };
    oneLine = cellAppend(oneLine,'right', score);
    oneLine = cellAppend(oneLine, 'right', {[], length(find(score == 1))/length(score), length(responseSeq)-length(stims), [],[]});
    oneLine = cellAppend(oneLine, 'right', RTs);
    oneLine = cellAppend(oneLine, 'right', cell(1,2));
    oneLine = cellAppend(oneLine, 'right', speedsGood);
    oneLine = cellAppend(oneLine, 'right', cell(1,2));
    
    
    %Find ITI in correct responses only
    ITI = cell(1, length(stims)-1);
    ITIable = find(diff(correctPositions) == 1); %find positions where the ITI can be computed (n and n+1 are correct)
    for count = 1:length(ITIable) %loop for every position where an ITI can be calculated (n and n+1 are correct)
        ITI{correctPositions(ITIable(count))} = responseTimes(assignment == (correctPositions(ITIable(count))+1)) - responseTimes(assignment == (correctPositions(ITIable(count)))); %for every ITIable position, find the timestamp of the next one and subtract the current one
    end
    oneLine = cellAppend(oneLine, 'right', ITI);
    
    trialCount = trialCount+1;
    
    row = row + trialOffset; %trial to trial stride
    
    %XXX Chris modifications for output
    acc=cellAppend(acc,'down',score);
    lag1=cellAppend(lag1, 'down', RTs);
    lag2=cellAppend(lag2, 'down', lag2s);
    dur=cellAppend(dur, 'down', durs);
    vel=cellAppend(vel,'down',speedsGood);
    iti=cellAppend(iti, 'down',ITI);
end

if (trialCount ~= size(in_sequences,1)+1)
    warning('scoreAdaptiveMFST:dataVerification', 'Unexpected end of data. More stimulus sequences were given than trials'' data found');
end
%XXX Chris removed this
%cell2csv(out_file, buffer, '\t');
%print out the number of warnings for this block
if ~suppressOutput
    fprintf('\nNumber of responses that occurred prior to 1st window: %i\t after last window: %i \n',warn_total(1),warn_total(2));
end
end



function [responseOffsets responseTimes doneChop] = cutPartialResp(responseOffsets, responseTimes)
% remove extra partial onset/offset responses
partialResp=length(responseTimes)-length(responseOffsets); %find number of partial responses by comparing num onsets to offsets
if partialResp < 0 %extra at the beginning
    % % for testing
    %         warning('There is a mismatch between the number of keypresses/keyreleases.');
    %         fprintf('length(responseTimes) = %i \t length(responseOffsets) = %i\n', length(responseTimes), length(responseOffsets));
    %         fprintf('Assuming that the first offset belonged somewhere else, removing the keypress response to correct.\n');
    responseOffsets=responseOffsets(1,(1+abs(partialResp)):end); % chop
    doneChop=false; %something changed
elseif partialResp > 0 %extra at the end
    % % for testing
    %         warning('There is a mismatch between the number of keypresses/keyreleases.');
    %         fprintf('length(responseTimes) = %i \t length(responseOffsets) = %i\n', length(responseTimes), length(responseOffsets));
    %         fprintf('Assuming that the final response was not fully recorded because the trial ended, removing the keypress response to correct.\n');
    responseTimes=responseTimes(1,1:end-(1+abs(partialResp))); % chop
    doneChop=false; %something changed
else
    doneChop=true; %nothing changed, we are done here
end
end

function checkTimestamps(std,oth)
%take standard timestamp vector and compare with other
%std=std/10^8; %magic number to convert to ms XXX correct???
d=std-oth;
fprintf('%.2f,',mean(d));
end
