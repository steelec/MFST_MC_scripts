function out=cell2num(in_cellArray)
%out=cell2num(in_cellArray)
%
%Author: Alejandro Endo
%Description:
%Converts a Cell Array to a numeric matrix. R
% It replaces empty and non-numeric elements with NaN
%Date:21 February, 2006
%Parameters:
%<in_cellArray> Cell Array to be converted to numeric Array

if (~iscell(in_cellArray))
    error('Invalid parameter type. <in_cellArray> should be of type Cell Array');
end

out = zeros(size(in_cellArray));
row = 1;
while (row <= size(in_cellArray, 1))
    col = 1;
    while (col <= size(in_cellArray, 2))
        
        if (isempty(in_cellArray{row, col}))
            out(row, col) = NaN;
        elseif (isnumeric(in_cellArray{row, col}))
            %it's already a number
            out(row, col) = in_cellArray{row, col};
        elseif (ischar(in_cellArray{row, col}) && isstrnumeric(in_cellArray{row, col}))
            %it's a string with a number inside
            out(row, col) = char(in_cellArray{row, col});

        end

        col = col + 1;
    end
    row = row + 1;
end