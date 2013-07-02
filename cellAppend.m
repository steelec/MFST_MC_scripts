function out_newCell=cellAppend(in_cellArray, in_direction, in_newData, in_splitStrings)
%out_newCell=cellAppend(in_cellArray, in_direction, in_newData [, in_splitStrings] )
%
%Author: Alejandro Endo
%Date: January 10th, 2008
%Description: Appends a new column or row to the end of a cell array but by
%separating elements in a numeric (or char) matrix into separate elements
%in the cell Array. Useful to write a matrix with string headers for
%example. See also cell2csv to write to a file
%
%Parameters:
% <in_cellArray>: Cell array to append to
% <in_direction>: Direction where the new data is appended. It can be 'right' or 'down'
% <in_newData>: vector with the new data to append.
% <in_splitStrings> Flag to indicate if strings should be split into 1 char
% per cell. If false, a string will be completely in 1 cell element and
% only numerical matrices will be split. By default it is false
%% Constants

ROW = 'down';
COLUMN = 'right';

%% Check arguments
error(nargchk(3,4, nargin));

if (~iscell(in_cellArray))
    error('CellAppend:Parameters', 'Invalid argument: <in_cellArray> should be a Cell Array\nUsage: cellAppend(in_cellArray, in_direction, in_newData)');
end
if ((strcmp(in_direction, ROW) || strcmp(in_direction, COLUMN)) == 0)
    error('CellAppend:Parameters', 'Invalid argument: <in_direction> should be ''down'' or ''right''\nUsage: cellAppend(in_cellArray, in_direction, in_newData)');

end

if (nargin == 3)
    in_splitStrings = false;
end

%% Code
out_newCell = in_cellArray;

if (strcmp(in_direction, ROW))
    %down
    row = size(in_cellArray, 1) + 1; %row index in <in_cellArray>
    newDataRow = 1; %row index in <in_newData>


    while (row <= size(in_cellArray, 1) + size(in_newData,1))
        col = 1;

        if (~ischar(in_newData(newDataRow,1)) || (in_splitStrings && ischar(in_newData(newDataRow,1))))
            %            split it so that 1 element goes in 1 element
            while (col <= size(in_newData,2))
                if (iscell(in_newData(newDataRow, col)))
                    out_newCell{row, col} = in_newData{newDataRow, col};
                else
                    out_newCell{row, col} = in_newData(newDataRow, col);
                end
                col = col+1;
            end
        else
            %don't split, the whole row goes in column 1
            out_newCell{row,1} = in_newData(newDataRow, :);
        end
        row = row+1;
        newDataRow = newDataRow+1;
    end
else
    %right
    col = size(in_cellArray, 2) + 1; %col index in <in_cellArray>
    newDataCol = 1; %row index in <in_newData>

    while (col <= size(in_cellArray, 2) + size(in_newData,2))
        row = 1;

        if (~ischar(in_newData(1,newDataCol)) || (in_splitStrings && ischar(in_newData(1,newDataCol))))
            %split it so that 1 element goes in 1 element
            while (row <= size(in_newData,1))
                if (iscell(in_newData(row, newDataCol)))
                    out_newCell{row, col} = in_newData{row, newDataCol};
                else
                    out_newCell{row, col} = in_newData(row, newDataCol);
                end
                row = row+1;
            end
        else
            %don't split, the whole column goes in row 1
            out_newCell{1, col} = in_newData(newDataCol, :);
        end
        col = col+1;
        newDataCol = newDataCol+1;
    end
end