function [stims,responses] = MFSTParseLogFn(filepath,keyorder,parseType,showVisuals)

% Function to efficiently parse mocap data files based on script by avrum
% hollinger

% author: Joseph Thibodeau
% 2012 - 01 - 26

% Not yet a function! 
% Optional filename if you know what you want, otherwise we
% will prompt you for a file.

%%

% Format info for the parsing
% IMPORTANT: Files must be TAB DELIMITED not COLON DELIMITED!
% Assuming the labels column is not the first column. Would need to tweak the
% first part of this code if we move it to the first column.
if(strcmp(parseType,'ascii'))
    % ASCII format string:
    format_string = '%f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
    % column holding least significant PSoC timestamp value (us)
    PSoC_LSCol = 13;
elseif(strcmp(parseType,'binaryRS'))
    % Binary format string:
    format_string = '%f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f';
    % column holding least significant PSoC timestamp value (us)
    PSoC_LSCol = 16;
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end

% column holding text labels
label_column = 5;
% column holding least significant PC timestamp value (ms)
PC_LSCol = 4;



%%
% If we provided an input argument, use it for filename. Otherwise prompt.
if(nargin > 0)
    f_name = filepath;
else
% Prompt for file and open
    [f_name, path, filter] = uigetfile('*.txt');
    f_name = [path f_name];
end

f_id=fopen(f_name);
f_data=textscan(f_id,format_string);
num_columns = length(f_data);
fclose(f_id);

% extract the event labels
labels = f_data{label_column};

% extract the rest of the data
data = [];
for column = 1:length(f_data)
    % if this is the label column, fill with zeros
    if(column == label_column)
        data = [data zeros(length(labels),1)];
    % otherwise fill with appropriate data
    else
        data = [data f_data{column}];
    end
end

%%

% sort out PC timestamps
temp = data(:,PC_LSCol-3:PC_LSCol);
% PC_time = data(:,PC_LSCol) + (data(:,PC_LSCol-1) + (data(:,PC_LSCol-2) + data(PC_LSCol-3).*60).*60).*1000;
PC_time = temp(:,4) + 1000.*(temp(:,3) + 60.*(temp(:,2) + 60.*temp(:,1)));

% sort out PSoC timestamps

if(strcmp(parseType,'ascii'))
    % \/\/\/ ASCII timestamp only has 4 columns of a byte each
    temp = data(:,PSoC_LSCol-3:PSoC_LSCol);
    PSoC_time = temp(:,4) + 256.*(temp(:,3) + 256.*(temp(:,2) + 256.*temp(:,1)));
elseif(strcmp(parseType,'binaryRS'))
    % \/\/\/ Binary timestamp has 8 columns of a nibble each
    temp = data(:,PSoC_LSCol-7:PSoC_LSCol);
    PSoC_time = temp(:,8) + 16*(temp(:,7)+16*(temp(:,6)+16*(temp(:,5)+16*(temp(:,4)+16*(temp(:,3)+16*(temp(:,2)+16*(temp(:,1))))))));
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end

% check for PSoC rollover:
MAXIMUM_CLOCKVAL = 4294967295;
timediff = [0 ; diff(PSoC_time)];
[mindiff,mindiffidx] = min(timediff);
if(mindiff < (MAXIMUM_CLOCKVAL*-0.5)) % rollover detected if there is a big negative jump of 50% or more of the maximum representable clock value
    PSoC_time(mindiffidx:end) = PSoC_time(mindiffidx:end) + MAXIMUM_CLOCKVAL; % maximum 32-bit value.
end

% convert from microseconds to milliseconds
PSoC_time = PSoC_time ./ 1000;

% % EXPERIMENTAL set start time to T+00
PC_time = PC_time - min(PC_time);
% % and synchronize first PSoC timestamp with PC timestamp
% [min_time synch_idx] = min(PSoC_time);
% % synch_idx = find(~isnan(PSoC_time),1)
% % min_time = PSoC_time(synch_idx);
% synch_time = PC_time(synch_idx);
% PSoC_time = PSoC_time - min_time + synch_time;

% Get Incremental Differences between THIS and LAST timestamps
PC_timediff = [0 ; diff(PC_time)];
PSoC_timediff = [0 ; diff(PSoC_time)];

%% TRUST THE PSoC CLOCK!!!

% Use the PSoC Clock for all timestamps and infer the equivalent PSoC time
% for PC-only events (stims etc) using the following observation: over a
% short time period, the PC clock drifts negligibly

disp('Synchronizing Timestamps...');

% init a final data structure called "master time" to equal PSoC time
Master_Time = PSoC_time;

% find the last valid PSoC timestamp
lastValid = find(~isnan(PSoC_time));
lastValid = lastValid(end);

% scrub through the time vectors and fill in missing PSoC times
for t = lastValid:-1:1
    % if no PSoC timestamp for this event (PC only)
    if isnan(PSoC_time(t))
        % propagate back from the "next" timestamp using PC increment
        Master_Time(t) = Master_Time(t+1) - PC_timediff(t+1);
    end
    % if not NaN, we use the existing PSoC timestamp (already set just
    % prior to this for-structure
end

% and then scrub forwards
for t = lastValid:length(PSoC_time)
    % if no PSoC timestamp for this event (PC only)
    if isnan(PSoC_time(t))
        % propagate froward from the last timestamp using this PC increment
        Master_Time(t) = Master_Time(t-1) + PC_timediff(t);
    end
    % if not NaN, we use the existing PSoC timestamp (already set just
    % prior to this for-structure
end

Master_Time = Master_Time - min(Master_Time);
Master_Timediff = [0 ; diff(Master_Time)];

if(showVisuals)
    % Diagnostic Plotting
    figure(99)
    close(99)
    figure(99)
    time_index = 1:length(Master_Time);
    subplot(2,1,1)
    plot(Master_Time,PC_time,'b-o')
    hold on
    % plot(Master_Time,PSoC_time,'r--x')
    plot(Master_Time,Master_Time,'g->')
    title('Timer comparison');
    legend('PC Timer','Master Timer');
    ylabel('milliseconds');
    xlabel('milliseconds');
    hold off

    subplot(2,1,2)
    hold on
    stairs(Master_Time,PC_timediff,'b--s')
    % stairs(Master_Time,PSoC_timediff,'r--x')
    stairs(Master_Time,Master_Timediff,'m--o')
    stairs(Master_Time,PC_time-Master_Time,'k-s')
    % stairs(Master_Time,Master_Time-PSoC_time,'b-o');
    legend('PC diff','Master diff','PC-Master');
    title('Timer Difference');
    ylabel('milliseconds');
    xlabel('milliseconds');
    grid on;
    hold off
end




% \/\/\/\/\/ LEAVING THIS OUT FOR NOW \/\/\/\/\/\/
% EXPERIMENTAL events for which there is no PSoC timestamp, approximate the
% PSoC timestamp using the assumption that the last known PSoC timestamp
% will increment in synchrony with the PC timestamp.
% PC_timediff = [0 ; diff(PC_time)];
% 
% for(idx = 1:length(PSoC_time))
%    if(isnan(PSoC_time(idx)))
%        % if first element, synch to PC_time
%         if(idx == 1)
%             PSoC_time(idx) = PC_time(idx);
%        % otherwise just propagate increment of PC time
%         else
%             PSoC_time(idx) = PSoC_time(idx-1) + PC_timediff(idx);
%         end
%    end
% end

% sort out PSoC key info
% PSoC_key_type = data(:,6);
% PSoC_key_pos = data(:,7);

%%
if(strcmp(parseType,'ascii'))
    % Major sorting of event info -- old parsing
    stim_on_mask = strcmp(labels,'Stim');
    stim_off_mask = strcmp(labels,'Blank');
    block_start_mask = strcmp(labels,'FLASH');
    block_end_mask = strcmp(labels,'BLOCKBREAK');
    key_mask = strcmp(labels,'Key');   
elseif(strcmp(parseType,'binaryRS'))
    % Major sorting of event information into categories -- new parsing
    stim_on_mask = strcmp(labels,'Stim');
    stim_off_mask = strcmp(labels,'Clear');
    block_start_mask = strcmp(labels,'FLASH');
    block_end_mask = strcmp(labels,'BLOCKBREAK');
    keyDN_mask = strcmp(labels,'keyDN');
    keyUP_mask = strcmp(labels,'keyUP');
    keyPOS_mask = strcmp(labels,'keyPOS');
    trigger_mask = strcmp(labels,'keyTRIG');    
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end

% stim onset info: time, stimID, highValue (1), DEBUG: OLD TIMECODE
stim_on = [Master_Time(stim_on_mask) data(stim_on_mask,6), Master_Time(stim_on_mask).*0+1 PC_time(stim_on_mask)];

% unique stim IDs
stim_uniques = unique(stim_on(:,2));
if(strcmp(parseType,'ascii'))
    % stim off info: time, stimID (to be filled in the next step), lowValue
    % (0), DEBUG: OLD TIMECODE
    stim_off = [Master_Time(stim_off_mask) Master_Time(stim_off_mask).*0 Master_Time(stim_off_mask).*0 PC_time(stim_off_mask)];
elseif(strcmp(parseType,'binaryRS'))
    % NEW: time, stimID , lowValue
    stim_off = [Master_Time(stim_off_mask) data(stim_off_mask,6) Master_Time(stim_off_mask).*0 PC_time(stim_off_mask)];
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end

% stim onOff is an interleaved list of stim ons and stim offs --- we will
% then insert the stim IDs
stim_onOff = sortrows([stim_on ; stim_off],1);
% \/\/ NO LONGER VALID 2012 
% assuming the integrity of the statement "every stim is followed by a
% corresponding stim off" -- which is not foolish considering the python
% script times and logs and presents all the stims -- we can propagate the
% stim on IDs to the ID-less stim offs: copy odd values to the following
% even values
stim_onOff(2:2:end,2) = stim_onOff(1:2:end,2);

% now revise the original stim OFF data structure so that it includes IDs
stim_off = stim_onOff(2:2:end,:);

% combined data structure much better for output:
% time on, time off, id
% assuming equal number of stim ons and stim offs
stims = [stim_on(:,1) stim_off(:,1) stim_on(:,2)];

% block start info: time of flash
block_start = Master_Time(block_start_mask);

% block end info: time of BLOCKBREAK
block_end = Master_Time(block_end_mask);

blocks = [block_start block_end];

if(strcmp(parseType,'ascii'))
    % \/\/\/ OLD VERSION
    % key events: Master time, Master time time, keyID, key Position
    key_messages = [Master_Time(key_mask) Master_Time(key_mask) data(key_mask,6) data(key_mask,7)];
    key_messages = [Master_Time(key_mask) PSoC_time(key_mask) data(key_mask,6:end)];  
elseif(strcmp(parseType,'binaryRS'))
    % \/\/\/ NEW VERSION
    key_off = [Master_Time(keyDN_mask) PSoC_time(keyDN_mask) data(keyDN_mask,6:end)];
    key_on = [Master_Time(keyUP_mask) PSoC_time(keyUP_mask) data(keyUP_mask,6:end)];
    key_pos = [Master_Time(keyPOS_mask) PSoC_time(keyPOS_mask) data(keyPOS_mask,6:end)];
    % convert key position to a single byte value (currently split between two
    % nibbles)
    key_pos(:,4) = key_pos(:,5) + 16.*key_pos(:,4);
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end

%%

% Detailed sorting of key messages
if(strcmp(parseType,'ascii'))
    % \/\/\/ OLD VERSION
    % Triggers where keyID == 0
    trigger = key_messages(key_messages(:,3) == 0,:);  
    % Key events and positions
    key_uniques = unique(key_messages(:,3));
    key_on = key_messages((key_messages(:,4) == 127),:);
    key_off = key_messages((key_messages(:,4) == 0),:);
    key_pos = key_messages((key_messages(:,4) < 127) & (key_messages(:,4) > 0),:);
elseif(strcmp(parseType,'binaryRS'))
    % \/\/\/ NEW VERSION
    trigger = [Master_Time(trigger_mask) PSoC_time(trigger_mask) data(trigger_mask,6:end)];    
else
    disp(['Parsing type: ' parseType]);
    error('Invalid parsing type');
end



% make sure the key IDs comply with the (possibly reversed)
TEMP_OFFSET = 5;
for key = 1:4
    key_off(key_off(:,3)==key,3) = keyorder(key) + TEMP_OFFSET;
    key_on(key_on(:,3)==key,3) = keyorder(key) + TEMP_OFFSET;
    key_pos(key_pos(:,3)==key,3) = keyorder(key) + TEMP_OFFSET;
end

key_off(:,3) = key_off(:,3) - TEMP_OFFSET;
key_on(:,3) = key_on(:,3) - TEMP_OFFSET;
key_pos(:,3) = key_pos(:,3) - TEMP_OFFSET;

%%

% Some preliminary plotting
if(showVisuals)
    % set colourmap
    key_colourmap = colormap(hsv(length(stim_uniques))).*0.75;

    figure(1)
    close
    figure(1)
    hold on

    % start by plotting triggers and block start/stop markers
    temp = stem(trigger(:,1),trigger(:,end)-10,'k--^');
    temp = stem(block_start(:,1),block_start(:,1).*0+80,'k-d');
    set(temp,'LineWidth',2.0);
    temp = stem(block_end(:,1),block_end(:,1).*0+80,'k-d');
    set(temp,'LineWidth',2.0);


    %plot each key and stim
    for key = 1:length(stim_uniques)
        % Keys:

        % position
        mask = key_pos(:,3)==key;
        temp = stem(key_pos(mask,1),key_pos(mask,4),':x');
        set(temp,'Color',key_colourmap(key,:));

        % key on
        mask = key_on(:,3)==key;
        temp = stem(key_on(mask,1),key_on(mask,end).*0+64,'->');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:));

        % key off
        mask = key_off(:,3)==key;
        temp = stem(key_off(mask,1),key_off(mask,end)+64,'-<');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:));

        % Stims:

        % Stair plot of old stim on/offs
        mask = stim_onOff(:,2) == key;
        temp = stairs(stim_onOff(mask,end),stim_onOff(mask,3).*72,':');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*0.75);

        % Stair plot of stim on/offs
        mask = stim_onOff(:,2) == key;
        temp = stairs(stim_onOff(mask,1),stim_onOff(mask,3).*72,'-');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*0.75);

        % Block start / stop markers
    end
    hold off
end

% return the following:
% block_start
% block_end
% stim_on
% stim_off
% key_on
% key_off
% key_pos

%%

% Here is where we interpolate missing key ON and key OFF messages:

% Key ON and OFF messages get sent when a certain threshold is met, it
% depends on the calibration of the PSoC board. So our first step here is
% to determine the approximate ON and OFF thresholds.

% key ON: each key on message will be bracketed by two position
% measurememtns. So find these measures and then linearly interpolate the
% threshold using the position of existing ON events

% will do a separate process for each key so that we avoid confusion if two
% keys are down simultaneously

MFSTParse_InterpolateMissingOnOff;

%%

% Second round of plotting
if(showVisuals)
    figure(2)
    close
    figure(2)
    hold on

    % start by plotting triggers and block start/stop markers
    temp = stem(trigger(:,1),trigger(:,end)-10,'k--^');
    temp = stem(block_start(:,1),block_start(:,1).*0+80,'k-d');
    set(temp,'LineWidth',2.0);
    temp = stem(block_end(:,1),block_end(:,1).*0+80,'k-d');
    set(temp,'LineWidth',2.0);


    %plot each key and stim
    for key = 1:length(stim_uniques)
        % Keys:

        % position
        mask = key_pos(:,3)==key;
        temp = stem(key_pos(mask,1),key_pos(mask,4),':x');
        set(temp,'Color',key_colourmap(key,:));

        % key on
        mask = key_on(:,3)==key;
        temp = stem(key_on(mask,1),key_on(mask,end).*0+64,'->');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:));

        % recovered key on
        mask = recovered_onsets(:,3)==key;
        temp = stem(recovered_onsets(mask,1),recovered_onsets(mask,end).*0+64,'-->');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*1.25);

        % key off
        mask = key_off(:,3)==key;
        temp = stem(key_off(mask,1),key_off(mask,end)+64,'-<');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:));

        % recovered key off
        mask = recovered_releases(:,3)==key;
        temp = stem(recovered_releases(mask,1),recovered_releases(mask,end).*0+64,'--<');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*1.25);

        % Stims:

        % Stair plot of stim scoring window thresh
        mask = stim_on(:,2) == key;
        temp = stem(stim_on(mask,1)-100,stim_on(mask,3).*0+72,':');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*0.75);

        mask = stim_on(:,2) == key;
        temp = stem(stim_off(mask,1)+100,stim_off(mask,3).*0+72,':');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*0.75);

        % Stair plot of stim on/offs
        mask = stim_onOff(:,2) == key;
        temp = stairs(stim_onOff(mask,1),stim_onOff(mask,3).*72,'-');
        set(temp,'LineWidth',2.0);
        set(temp,'Color',key_colourmap(key,:).*0.75);

        % Block start / stop markers
    end

    hold off
end

% The following is not even necessary based on analysis of MFST Adaptive
% Scoring script.

% numTrialsPerBlock = length(stims)/length(blocks);
% numElementsPerSeq = 13;
% for block = 1:size(blocks,1)
%     % mark the stims and responses with block numbers, trial numbers and
%     % element numbers
%     stim_mask = (stims(:,1) > blocks(block,1)) & (stims(:,1) < blocks(block,2));
%     resp_mask = (responses(:,1) > blocks(block,1)) & (responses(:,1) < blocks(block,2));
%     
%     % get the number of stims for this block
%     num_stims = find(stim_mask == 1);
%     
%     
% end

% return the following:
% stims
% responses
end