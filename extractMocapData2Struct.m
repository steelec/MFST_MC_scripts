function out = extractMocapData2Struct(directory, markers, createFile)
%Author: Alejandro Endo
%Function to extract the motion capture data and group it per subject using
%structs
%Date:18 January, 2007
%
%Matlab Dependencies:
%extractMocapData
%
%Parameters:
%<directory> Subject's directory where the mocap files are
% Mocap files are assumed to have the pattern *_mocap_*.txt in its name
% <markers> Vector of markers to extract
%<createFile> Flag to indicate if the results should be stored in a matlab
%file for later use. If omitted, false
%
%Return:
%The resulting struct gets it name from the directory where the files are
%The take names come from the filename part after _mocap_

%Hierarchy of the struct:
%   Subject
%       Takes
%           Marker

if (nargin < 2) 
error('Incorrect number of parameters, at least the first 2 parameters are required');
end
if (nargin == 2)
    createFile = false;
end

if (directory(end) ~= '\' && directory(end) ~= '/')
    directory = [directory '\'];
end
fullPath = [directory '*_mocap_*.txt'];
storeFile = directory(find(directory == '\', 2, 'last')+1:end-1);
if (isempty(storeFile))
    storeFile = 'defaultFile'; %in case it doesnt parse the var name
end
files = dir(fullPath);
count = 1;
while (count <= length(files))
    takeName = files(count).name(find(files(count).name == '_', 1, 'last')+1:end-4); % -4 to get ride of '.txt' or any 3 letter extension + period
    oneFileData = extractMocapData([directory '\' files(count).name]);
    markerCount = 1;
    while (markerCount <= length(markers))
        command = ['out.' takeName '.marker' num2str(markers(markerCount)) ' = oneFileData(oneFileData(:,1) == ' num2str(markers(markerCount)) ', 2:end); '];
        eval(command);
        markerCount = markerCount + 1;
    end
    count = count + 1;
end

if (createFile) 
save([directory storeFile], 'out'); 
end