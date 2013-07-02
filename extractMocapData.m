function out= extractMocapData(in_mocapFile, in_quiet, in_limits, in_skip)
%out= extractMocapData(in_mocapFile, in_limits, in_skip)
%
%Author: Alejandro Endo
%Date:13 March, 2006
%Description:
% Function to extract the motion capture data from an ASCII exported file
% from VZSoft.
% Note that this function will remove bad samples. It will also make timestamps
% relative to the time of the first sample (wheather good or bad)
%
%Non-Matlab Dependencies:
%
%Parameters:
%<in_mocapFile> Exported data file from VZSoft
%<in_quiet> Flag to indicate if the program should run in quiet mode
%<in_limits> 1-by-2 Vector with the limits of the FRAMES to take (inclusive limits). If
%it is empty, the whole file is read but be careful, it may take a long time. If <in_limits>
%is 'auto', the program will try to find the position on the trial
%<in_skip> lapse of time that must be skipped (estimate of when the desired trial begins)

if (nargin > 2)
    if (strcmp(in_limits,'auto'))

        %in_limits = [1 300]; %for now
    elseif (length(in_limits) ~= 2)
        error('You must provide 2 limits only. If uncertain just let the program guess the trial position');
    end
    fid = fopen(in_mocapFile);
    if (fid == -1)
        error([dataFile ' was not found in the current path'])
    else
        line = fgetl(fid); %first line
    end
end

if (nargin == 1)
    in_quiet = false;
end

if (~in_quiet)
    disp('Extracting MoCap Data, this may take some time...');
    tic
end

if (nargin > 2)
    while (line ~= -1)
        if (findstr('Total Markers Used', line) ~= -1) %find out how many markers were used
            [tmp, tmp, tmp, tmp, numMarkers] = strread(line, '%s %s %s %s %d');
            if (strcmp(in_limits,'auto')) %estimate position of the wanted trial
                %skipBytes = sum(in_skip(1:length(in_skip)-1))*50/1000 * (numMarkers+1) * 34 + 3686; %34 = 31 (avg of chars per line) + 2 (end of line chars) + 1 (empirical) | 3686: approx. of # of bytes in the preceeding data (metadata) | 1 char = 1 byte, fseek needs bytes
                skipRows = sum(in_skip(1:length(in_skip)-1))*50/1000 * (numMarkers);
                %fseek(fid, floor(skipBytes), 'bof');
                %line = fgetl(fid); %read the rest of the line
                %line = fgetl(fid) %read the next line to see where we are
                in_limits = [floor(skipRows+1) ceil(skipRows+(in_skip(length(in_skip))*50/1000 * numMarkers))];
                break;
            end
        end
        line = fgetl(fid);
    end
    fclose(fid);
end

out = load(in_mocapFile); %load everything

mocapTimeStart = out(1,7);
out = out(out(:,1) == 1, 3:7); %remove the first two columns and bad samples


%fix timer turnover
turnover = find(out(:,5)-mocapTimeStart < 0);
out(turnover, 5) = round(out(turnover, 5)+ 2^32/20); %32 bits counter (register) in the machine, (why divided by 20? that range is used for some control logic)...
out = [out(:, 1:4) (out(:, 5)-mocapTimeStart)]; %convert time to relative to first frame
%this is realiable because the timer turns over only once. it can count for 35 minutes so it will do it once only unless a take is more than double that length.


out(:, 5) = out(:, 5) / 1000; %micro to milli

if (nargin > 2)
    out = out(in_limits(1):in_limits(2), :); %filter out unwanted data
end

if (~in_quiet)
    disp('Extraction finished.');
    toc
end