function sumChunks = findChunksInTrial(this_trial,RNDstd)
    % This function takes a vector of reaction times (ms)
    % and determines the chunks in it
    % then outputs the same size of vector
    % with each chunk size placed at the "head" position of each chunk
    % Joseph Thibodeau 2014

    % SET UP OUTPUT STRUCTURE
    chunks = zeros(size(this_trial));

    % SOME CONFIG VARS
    % maybe base the rxLowThresh on the window size?
    %rxLowThresh = -1000; %ms threshold for "best" reaction times --- arbitrary
    %rxHighThresh = 0; %ms threshold that is still considered a chunk even if it's higher
    minChunkSize = 2; %how many elements are required for a chunk
    
    % restricting chunking definition to require a certain degree of change
    minChangeReq = RNDstd;
    
    % MARK FIRST ELEMENT WITH CHUNKNUM 1 IF VALID
    if(~isnan(this_trial(1)))
        chunkID = 1;
        chunks(1) = chunkID;
    else
        chunkID = 2;
    end

    % FOR EACH SUBSEQUENT ELEMENT
    for (elem = 2:length(this_trial))

        % IF this reaction time is valid (correct),
        %  AND EITHER lower than the previous one
        %       OR higher within a small tolerance
        %       OR within an acceptable low (close to zero) range
        if (~isnan(this_trial(elem))) ...
                && ((this_trial(elem) < (this_trial(elem-1) - minChangeReq)))       
            % THEN MARK WITH CURRENT CHUNKNUM
            chunks(elem) = chunkID;

        % ELSE IF THIS IS A VALID REACTION TIME, MARK AS NEW CHUNK
        elseif (~isnan(this_trial(elem)))
            chunkID = elem;
            chunks(elem) = chunkID;
        % OTHERWISE IT'S A NAN AND WE DON'T DO ANYTHING (LEAVE ZERO)
        % ENDIF
        end

    % END FOR ELEMENT
    end
    
    % NOW COMPRESS THIS ANALYSIS INTO A MORE COMPREHENSIVE FORM

    % GET the unique nonzero elements in this trial
    uniqueChunks = unique(chunks(chunks > 0));
    % PREP data struct
    sumChunks = zeros(size(chunks));

    % IF there are valid chunks
    if (~isempty(uniqueChunks))
        % FOR each unique chunk ID
        for (chunk = 1:length(uniqueChunks))
            % SUM the number of chunks bearing this ID
            % and STORE the result in the leading element
            sumChunks(uniqueChunks(chunk)) = sum(chunks == uniqueChunks(chunk));
        % END FOR CHUNK
        end
    %ENDIF
    end

    % DISCARD chunks that are too small (not a chunk)
    sumChunks = sumChunks.*(sumChunks >= minChunkSize);

% END FUNCTION
end