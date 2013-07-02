function out= cellTrim(cellArray)
%Author: Alejandro Endo
%Function to remove empty items in a cell array that are at the beginning and the end
%It can be used only with 1-dimensional arrays because you can not have a
%jagged array in matlab
%Date: March 14, 2007
%
%Parameters:
%<cellArray> Cell array to trim
%
%Returns:
% <out> Same as <cellArray> but without leading or trailing empty elements

if (length(find(size(cellArray) > 1)) > 1)
    error('Cell array can only be 1-dimensional (There are no jagged arrays in matlab)');
end
if (~iscell(cellArray))
    error('The argument given is not a cell array');
end

start = 1;

while (start <= length(cellArray))
    if (~isempty(cellArray{start}))
        break;
    end
    start = start + 1;
end

stop = length(cellArray);
while (stop > 0)
    if (~isempty(cellArray{stop}))
        break;
    end
    stop = stop - 1;
end

out = cellArray(start:stop);