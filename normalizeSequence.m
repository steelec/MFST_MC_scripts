function normalSeq = normalizeSequence(in_sequence)
%
%Author: Alejandro Endo
%Date: 8/07/08
%Description:
%Normalizes a sequence of IDs (stims, responses, etc) by finding the used
%IDs in the sequence and substituting them with a 1-based sequence where 1
%corresponds to the lowest ID (e.g. 67 65 69 67 --> 2 1 3 2)

%% Check arguments
error(nargchk(1,1, nargin));

if (~isnumeric(in_sequence))
    error('normalizeSeq:parameterCheck', '<in_sequence> is not a numeric array');
end

%% Process sequence

keys = unique(in_sequence);

normalSeq = zeros(1,length(in_sequence));
for count=1:length(in_sequence)
    normalSeq(count) = find(in_sequence(count) == keys);
end
