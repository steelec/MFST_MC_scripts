function [RT, lag2, dur, assignment, windowScore, warn]=windowSlidingScoring(in_presentation, in_responsesTimes, in_responseOffsets, in_windowOffset, in_stimSequence, in_responseSequence, stimDuration)
%
%Author: Alejandro Endo
%Date: 30/06/08
%Description: Function to score a SINGLE trial using the sliding window
%technique used in the lab. The idea in this technique is to split the
%response timeline in windows (or sliding a single window, same thing) and
%match a response to a stim based on in which window the response ocurred.
%If there is more than one response in the window, only the first response
%is considered. On top of the time (or synchro) score, the script considers if 
%the actual response is the supposed response when scoring
%
%Parameters:
% <in_presentation>: Array of stimulus presentation times in chronological
% order
% <in_responsesTimes>: Array of response timestamps
% <in_windowOffset>: Start of the scoring window relative to its stim. e.g.
% -100 would make a response 30ms before the stim correct whereas a value of 
% 0 would make it incorrect
% <in_stimSequence>: Stim Sequence presented
% <in_responseSequence>: Response sequence
%
%Returns:
%<RT>: Reaction time for VALID responses only (a valid response is a
%first response within a window. Here the key ID is not considered (i.e if
%they were presented with 2 but pressed 4 the RT for that particular
%response is included). The number of elements in the array is the number
%of responses that fullfilled the time requirements (a response, wheather
%correct or incorrect, was made in the apppropiate time)
%
%<assignment>: Assignment of EVERY response to a window. If a response was
%not the first one in the window it is tagged with a "-" sign. The number
%of positive responses matches the number of RTs
%
%<windowScore>: Score of each window in the trial. This score considers the
%response time AND the response ID (right key at the right time).
%1=correct, 0=incorrect, -1=no response in window
%
%<warn>: Number of pre/post trial warnings (event before/after first/last window)

error(nargchk(7,7,nargin));

if (~issorted(in_presentation))
    error('windowSlidingScoring:ArgumentsCheck', '<in_presentation> has to be an ordered array of timestamps');
end

count = 1; %counts responses, NOT STIMS
responsesMinusOffset = in_responsesTimes - in_windowOffset; %remove offset

%preallocate
assignment = zeros(1, length(in_responsesTimes));
windowScore =  zeros(1, length(in_stimSequence)); %score for every window (i.e. stim, NOT response)

RT = [];
lag2=[];
dur=[];
event_after_window_warn=0;
event_before_window_warn=0;
%% Analyse time
while (count <= length(in_responsesTimes))
    tmp = find(responsesMinusOffset(count) < in_presentation);
    if (isempty(tmp))
        %event ocurred after the ONSET of the last window
        if (responsesMinusOffset(count)-in_presentation(end) > in_presentation(end)-in_presentation(end-1))
            %this is checking if the event occurred after the OFFSET (i.e. outside) of the last window.
            %Since we don't have the window size, i do a crude estimate by finding
            %the window size in the (n-1)th presentation. The result of this hack
            %determines only if the warning is issued; the actual result is equal
            %for both of them (inside and outside of window) since even if outside the last window, the event is
            %assummed to belong to the last window
            
            %warning('windowSlidingScoring:EventOutOfRangeCheck', 'Found event after the last window. Assuming it belongs to the last window...');
            event_after_window_warn=event_after_window_warn+1;
        end

        if (isempty(find(assignment == length(in_presentation), 1)))
            %this is the first (and only acceptable) response for this
            %window

            RT = [RT in_responsesTimes(count)-in_presentation(end)];
            lag2= [lag2 in_responseOffsets(count)-(stimDuration + in_presentation(end))];
            dur = [dur in_responseOffsets(count)-in_responsesTimes(count)];
            assignment(count) = length(in_presentation);
        else
            assignment(count) = -length(in_presentation); %add the position but negative to indicate it should be dropped
        end
        assignment(count) = length(in_presentation);
    else
        windowIndex = tmp(1)-1;

        if (windowIndex == 0) %check if event occurred before the first window started (which is before the first presentation OR BETWEEN THE FIRST PRESENTATION AND THE START OF THE FIRST WINDOW)
            %warning('windowSlidingScoring:EventOutOfRangeCheck', 'Found event before the first window. Assuming it belongs to the first window...');
            event_before_window_warn=event_before_window_warn+1;
        else
            %most common branch. Regular case
            if (isempty(find(assignment == windowIndex, 1)))
                %this is the first (and only acceptable) response for this
                %window

                RT = [RT in_responsesTimes(count)-in_presentation(windowIndex)];
                lag2= [lag2 in_responseOffsets(count)-(stimDuration + in_presentation(windowIndex))];
                dur = [dur in_responseOffsets(count)-in_responsesTimes(count)];
                assignment(count) = windowIndex;
            else
                assignment(count) = -windowIndex;%add the position but negative to indicate it should be dropped
            end

        end
    end
    count = count+1;
end

%% Analize responses

%make sure responses and stims are normalized (1-based)
if (isempty(find(in_stimSequence == 1, 1)) && isempty(find(in_stimSequence == 2, 1)))
    warning('windowSlidingScoring:dataPrecheck', 'Stimulus sequence does not seem to be normalized');
    disp(in_stimSequence);
end
if (isempty(find(in_responseSequence == 1, 1)) && isempty(find(in_responseSequence == 2, 1)))
    warning('windowSlidingScoring:dataPrecheck', 'Response sequence does not seem to be normalized');
    disp(in_responseSequence);
end

count = 1;

while (count <= length(in_stimSequence))
    if (isempty(find(count==assignment, 1)))%if there is no response for the current stim
        windowScore(count) = -1; %no response
    else
        if (in_responseSequence(count ==assignment) == in_stimSequence(count)) % if the response matches the stim
            windowScore(count) = 1; %correct
        else
            windowScore(count) = 0; %incorrect
        end

    end
    count = count+1;
end

warn=[event_before_window_warn event_after_window_warn];
