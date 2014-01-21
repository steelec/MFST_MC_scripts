function [acc, lag1, lag2, dur, vel, accel, jerk, iti] = WindowSlidingScore2(dataDir, subjectID, day, seqsPerBlock, scoringWindowOffset, ISI, suppressOutput,keyorder,parseType,showVisuals)
% New scoring function to accompany python-based MFST and resulting log
% files. Simpler in many ways than the previous scoring method.
% INPUTS:
% subjectID (string)
% day (int)
% seqsPerBlock (int)
% scoringWindowOffset (int) -- ms around the stim in which a response will
% be associated with that stim.
% ISI (int) ms of inter-stimulus-interval

% OUTPUTS
% acc, lag1, lag2, dur, vel, iti --- formatted similar to old code.
%

% Input validity checking:
if (scoringWindowOffset > ISI/2)
    disp('Overlap Detected! Using a smaller scoring window offset!')
    scoringWindowOffset = ISI/2;
end

% First determine the datafile name based on given data
filename = [dataDir subjectID '_day' num2str(day) '_testing.txt']

% Next, parse the log file and retrieve all the stims and responses
[stims, responses] = MFSTParseLogFn(filename,keyorder,parseType,showVisuals);

% Prep data structures
%FIXME
acc = zeros(length(stims)/seqsPerBlock,seqsPerBlock);
lag1 = zeros(length(stims)/seqsPerBlock,seqsPerBlock).*NaN;
lag2 = lag1;
dur = lag1;
vel = lag1;
accel = lag1;
jerk = lag1;
iti = zeros(length(stims)/seqsPerBlock,seqsPerBlock-1).*NaN;

% Loop through the stims, scoring the entire day.
for stim = 1:length(stims)
    if (stim==length(stims)-14)
        x= 5;
    end
    seqPos = mod(stim-1,seqsPerBlock)+1;
    seqNum = floor((stim-1)/seqsPerBlock) + 1;
    winStart = stims(stim,1) - scoringWindowOffset;
    winEnd = stims(stim,2) + scoringWindowOffset;
    
    responsesInWin = responses(find((responses(:,1) >= winStart) & (responses(:,1) <= winEnd)),:);
    
    % DEBUG: Plot this window
%     figure(99);
%     close;
%     figure(99);
%     stem(stims(stim,1:2),[stims(stim,end) stims(stim,end)],'k-^');
%     hold on
%     stem(responsesInWin(:,1),responsesInWin(:,end),'r:*');
%     hold off
    
    % if we find an answer, score it
    if(~isempty(responsesInWin))
        % get the first response
        answer = responsesInWin(1,:);
        % determine correctness based on the ID of the stim and response
        if(answer(end) == stims(stim,end))
            acc(seqNum,seqPos) = 1;

            % calculate metrics
            lag1(seqNum,seqPos) = answer(1) - stims(stim,1);
            lag2(seqNum,seqPos) = answer(2) - stims(stim,2);
            dur(seqNum,seqPos) = answer(2) - answer(1);
            vel(seqNum,seqPos) = answer(3);
            accel(seqNum,seqPos) = answer(4);
            jerk(seqNum,seqPos) = answer(5);
            % if the last answer was also correct, calculate iti
            if((seqPos > 1) && (acc(seqNum,seqPos-1) == 1))
                iti(seqNum,seqPos-1) = answer(1) - lastAnswer(1);
            end
            lastAnswer = answer;
        else
            % otherwise mark it as incorrect
            acc(seqNum,seqPos) = 0;
        end % checking correctness
    else
        % otherwise mark it as no response
        acc(seqNum,seqPos) = -1;
    end % checking for response
end %for each stim

% right before returning, reshape the scoring to fit the number of
% sequences per block
% acc = seqsToRows(acc,seqsPerBlock);
% lag1 = seqsToRows(lag1,seqsPerBlock);
% lag2 = seqsToRows(lag2,seqsPerBlock);
% dur = seqsToRows(dur,seqsPerBlock);
% vel = seqsToRows(vel,seqsPerBlock);
% accel = seqsToRows(accel,seqsPerBlock);
% jerk = seqsToRows(jerk,seqsPerBlock);
% iti = seqsToRows(iti,seqsPerBlock);

% Original Script Uses Cell Structures, so we will too.
acc = {acc};
lag1 = {lag1};
lag2 = {lag2};
dur = {dur};
vel = {vel};
accel = {accel};
jerk = {jerk};
iti = {iti};

end %function

% function out = seqsToRows(in,seqsPerBlock)
%    out = reshape(in,seqsPerBlock,length(in)/seqsPerBlock)';
% end