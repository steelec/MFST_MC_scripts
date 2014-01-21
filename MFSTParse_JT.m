% Script to efficiently parse mocap data files based on script by avrum
% hollinger

% author: Joseph Thibodeau
% 2012 - 01 - 26

%%

% Format info for the parsing
% Assuming the data column is not the first column. Would need to tweak the
% first part of this code if we move it to the first column.
format_string = '%f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
% column holding text labels
label_column = 5;
% column holding least significant PC timestamp value (ms)
PC_LSCol = 4;
% column holding least significant PSoC timestamp value (us)
PSoC_LSCol = 13;

%%

% Prompt for file and open
[f_name, path, filter] = uigetfile('*.txt');
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
PC_time = data(:,PC_LSCol) + (data(:,PC_LSCol-1) + (data(:,PC_LSCol-2) + data(PC_LSCol-3).*60).*60).*1000;

% sort out PSoC timestamps
PSoC_time = data(:,PSoC_LSCol) + (data(:,PSoC_LSCol-1) + (data(:,PSoC_LSCol-2) + data(PSoC_LSCol-3).*256).*256).*256;
% convert from microseconds to milliseconds
PSoC_time = PSoC_time ./ 1000;

% sort out PSoC key info
% PSoC_key_type = data(:,6);
% PSoC_key_pos = data(:,7);

%%

% Major sorting of event information into categories
stim_on_mask = strcmp(labels,'Stim');
stim_off_mask = strcmp(labels,'Blank');
block_start_mask = strcmp(labels,'FLASH');
block_end_mask = strcmp(labels,'BLOCKBREAK');
key_mask = strcmp(labels,'Key');

% stim onset info: time, stimID, highValue (1)
stim_on = [PC_time(stim_on_mask) data(stim_on_mask,6), PC_time(stim_on_mask).*0+1];

% unique stim IDs
stim_uniques = unique(stim_on(:,2));

% stim off info: time, stimID (to be filled in the next step), lowValue (0)
stim_off = [PC_time(stim_off_mask) PC_time(stim_off_mask).*0 PC_time(stim_off_mask).*0];

% stim onOff is an interleaved list of stim ons and stim offs --- we will
% then insert the stim IDs
stim_onOff = sortrows([stim_on ; stim_off],1);
% assuming the integrity of the statement "every stim is followed by a
% corresponding stim off" -- which is not foolish considering the python
% script times and logs and presents all the stims -- we can propagate the
% stim on IDs to the ID-less stim offs: copy odd values to the following
% even values
stim_onOff(2:2:end,2) = stim_onOff(1:2:end,2);

% block start info: time of flash
block_start = PC_time(block_start_mask);

% block end info: time of BLOCKBREAK
block_finish = PC_time(block_end_mask);

% key events: PC time, PSoC time, keyID, key Position
key_messages = [PC_time(key_mask) PSoC_time(key_mask) data(key_mask,6) data(key_mask,7)];

%%

% Detailed sorting of key messages

% Triggers where keyID == 0
trigger = key_messages(key_messages(:,3) == 0,:);

% Key events and positions
key_uniques = unique(key_messages(:,3));
key_on = key_messages((key_messages(:,4) == 127),:);
key_off = key_messages((key_messages(:,4) == 0),:);
key_pos = key_messages((key_messages(:,4) < 127) & (key_messages(:,4) > 0),:);

%%

% Some preliminary plotting

% set colourmap
key_colourmap = colormap(hsv(length(stim_uniques))).*0.75;

figure(1)
hold on

% start by plotting triggers
temp = stem(trigger(:,1),trigger(:,end)-10,'k--^');

% plot each key and stim
for key = 1:length(stim_uniques)
    % Keys:
    
    % position
    mask = key_pos(:,3)==key;
    temp = stem(key_pos(mask,1),key_pos(mask,end),':x');
    set(temp,'Color',key_colourmap(key,:));
    
    % key on
    mask = key_on(:,3)==key;
    temp = stem(key_on(mask,1),key_on(mask,end).*0+64,'->');
    set(temp,'Color',key_colourmap(key,:));
    
    % key off
    mask = key_off(:,3)==key;
    temp = stem(key_off(mask,1),key_off(mask,end)+64,'-<');
    set(temp,'Color',key_colourmap(key,:));
    
    % Stims:
    
    % Stair plot of stim on/offs
    mask = stim_onOff(:,2) == key;
    temp = stairs(stim_onOff(mask,1),stim_onOff(mask,3).*72,'-');
    set(temp,'LineWidth',1.0);
    set(temp,'Color',key_colourmap(key,:).*0.75);
end

hold off