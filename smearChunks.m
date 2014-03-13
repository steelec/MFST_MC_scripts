function outStruct = smearChunks(inStruct)

% for visualization purposes, smears the chunks in a matrix
% so that they look better in a greyscale 2d representation

outStruct = zeros(size(inStruct));

% FOR ROWS
for (r = 1:size(inStruct,1))
    % FOR COLUMNS
    for(c = 1:size(inStruct,2))
        % IF THIS IS NONZERO and NOTNAN
        if ((inStruct(r,c) ~= 0) && (~isnan(inStruct(r,c))))
            n = inStruct(r,c);
            % SMEAR THIS ACROSS THE NEXT N COLUMNS
            outStruct(r,c:c+n-1) = n;
        %ENDIF
        end
    %END COLUMNS
    end
% END ROWS
end