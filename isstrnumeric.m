function out=isstrnumeric(in_str)
%out=isstrnumeric(in_str)
%
%Author: Alejandro Endo
%Date: January 10th
%Description: True for strings that contain only numbers.
% If there are surrounding spaces around the string, consider using strtrim
%
%Parameters:
% <in_str>: String to check whether it is numeric or not

if (~ischar(in_str))
    error('Input argument is not a string');
end

if (isnan(str2double(in_str)))
    out = false;
else
    out = true;
end
%out = prod(+isstrprop(in_str, 'digit'));