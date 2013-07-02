function ret=vectorizedReadf(in_file, in_delimiter)
%ret=vectorizedReadf(in_file, in_delimiter)
%
%Author: Alejandro Endo
%Date: 9/9/05
%Description: Script to read text from a file and put it in a matrix
%(actually cell array) where each word (chars until a <in_delimiter> is in a cell and every new line is a
%new row. It can be used nicely with strmatch, but remember that strmatch
%will return a vector so to jump to the next column you have to add
%the total number of rows
%Parameters:
% <in_file> Input text file to process
% <delimiters> Separating character between elements (words)

if (nargin < 2)
    error(['Invalid number of arguments:' num2str(nargin) '\nUsage: vectorizedReadf(in_file, in_delimiter)'], 'Parameters Validation');
end
if (~ischar(in_file) || ~ischar(in_delimiter))
    error(['Invalid type of parameters' '\nUsage: vectorizedReadf(in_file, in_delimiter)'], 'Parameters Validation');
end

%matlab doesnt like '\t'
if (strcmp(in_delimiter,'\t'))
    in_delimiter = char(9);
end

fid = fopen(in_file);

if (fid == -1)
    error(['File specified was not found (' in_file ')']);
end

row = 1;
ret = {};
while (feof(fid) == 0)
    line = fgetl(fid); %first line
    column= find(line ~= in_delimiter);
    if (isempty(column))
        column = 1;
    else
        column = column(1) ; %just get the first non-delimiter pos
    end
    while (~isempty(line)) %break the line into tokens
        [word line] = strtok(line, in_delimiter);

        if (isempty(word))
            ret{row, column} = '';
        else
            if (isstrnumeric(word)) % check to see if the string can be converted to a number, if it can then convert it
                ret{row, column} = str2double(word);
            else
                ret{row, column} = word;
            end
        end

        offset = find(line ~= in_delimiter); %this is so that 5/t/t/t6 would create 2 empty cells between 5 and 6, if this is not done strtok will make it 5 6 because /t/t/t6 will return 6
        if (isempty(offset))
            offset = 1;
        else 
            offset = offset(1)-1; %just get the first non-delimiter pos but skipping the following delimiter (-1)
        end
        column = column+offset;
    end
    row = row+1;
    %    line = fgetl(fid);
end

fclose(fid);



