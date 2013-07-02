function [keyOn, keyOff, delays]=extractMidiData(dataFile)
%Author: Alejandro Endo
%Date:28 February, 2006
%Extracts the data from keyboard experiments for the lab
%Note: It is assumed that each trial has an initial delay
%Example of a line in the dataFile:
%   trial #1(1324):  4 42 1878   4 0 2181   1 56 2926   1 0 3196   3 39 3881   3 0 4160
%
%Parameters: 
%<datafile> File with the raw data
%
%Output:
%<keyOn> 3-d Array with the data of key presses in it
%       First dimension is trial #
%       Second dimension is key press #
%       Third dimension is type of value (Key pressed, Force used, Time RELATIVE TO THE ACK SIGNAL!)
%
%<KeyOff> 3-d Array with the data of the key releses in it
%       First dimension is trial #
%       Second dimension is key press #
%       Third dimension is type of value (Key pressed, Force used, Time RELATIVE TO THE ACK SIGNAL!)
%
%<delays> Vector with the delays of each trial
%       This delay is the time when the first stimulus was presented relative to the ACK signal

fid = fopen(dataFile);
if (fid == -1)
error([dataFile ' was not found in the current path'])
end
fgetl(fid); %first line is the path to the config file, do nothing
line = fgetl(fid);
trial = 1;
while (line ~= -1) %loop through each trial
    
    [dumpToken, line] = strtok(line, '('); %"trial #X"
    [trialDelay, line] = strtok(line(2:length(line)), ')'); %remove the first character "(" left by the last line strtok
    delays(trial) = str2num(trialDelay); %the delay for this specific trial
    [dumpToken, line] = strtok(line); %remove first garbage "): "
    onPos = 1;
    offPos = 1;
    while (strtok(line) ~= -1)
        [keyID, line] = strtok(line);
        [force, line] = strtok(line);
        [time, line] = strtok(line);
        if (str2double(force) > 0)
            keyOn(trial, onPos, 1) = str2double(keyID);
            keyOn(trial, onPos, 2) = str2double(force);
            keyOn(trial, onPos, 3) = str2double(time);
            onPos = onPos+1;
        else
            keyOff(trial, offPos, 1) = str2double(keyID);
            keyOff(trial, offPos, 2) = str2double(force);
            keyOff(trial, offPos, 3) = str2double(time);
            offPos = offPos+1;
        end
    end
    line = fgetl(fid);
    trial = trial+1;
end
fclose(fid);