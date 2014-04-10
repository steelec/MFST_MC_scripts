function sumChunks = findChunksInTrial_20140327(this_trial,RNDmean,RNDstd)
    % This function takes a vector of reaction times (ms)
    % and determines the chunks in it
    % then outputs the same size of vector
    % with each chunk size placed at the "head" position of each chunk
    % Joseph Thibodeau 2014
    
%     Using a new approach in this one:
%     1) a new chunk starts when an RT falls below the mean RND RT minus one
%     standard dev
%     2) subsequent RT is included in the chunk if it:
%         a. is lower than the running mean of all elements in the chunk or
%         b. up to one SD above that running mean
%         *. also should be below some upper bound, right now being the
%         first RT in the chunk plus one RND SD

    % SET UP OUTPUT STRUCTURE
    chunks = zeros(size(this_trial));

    % SOME CONFIG VARS
    minChunkSize = 1; %how many elements are required for a chunk
    
    % Other vars
    isChunking = false; % start out by not chunking
    chunkCeiling = inf; % this will be reset to a more reasonable upper limit
    
    % FOR each element
    for (elem = 1:length(this_trial))
        this_RT = this_trial(elem);
        % Are we in a chunk?
        if(isChunking == true)
            % Check if this element is a member of the current chunk
            if(~isnan(this_RT) && (this_RT < (chunkMean + RNDstd)) && (this_RT < chunkCeiling))
            % If so, add it to the current chunk
                chunks(elem) = chunkID;
                % update chunking params
                chunkRunSum = chunkRunSum + this_RT;
                chunkSize = chunkSize + 1;
                chunkMean = chunkRunSum / chunkSize;
            % Otherwise, exit the chunk
            else
                isChunking = false;
            end%if
        else %isChunking == false
            % Check if this element is the start of a new chunk
            if(~isnan(this_RT) && (this_RT < (RNDmean - RNDstd)))
                % If so, enter the chunk and start chunking!
                chunkID = elem;
                chunks(elem) = chunkID;
                isChunking = true;
                % update chunking params
                chunkCeiling = this_RT + RNDstd;
                chunkRunSum = this_RT;
                chunkSize = 1;
                chunkMean = chunkRunSum / chunkSize;
            end%if
        end%if
    end%for each element
    
%     % MARK FIRST ELEMENT WITH CHUNKNUM 1 IF VALID AND WITHIN CHUNK START
%     % CONDITIONS
%     if(~isnan(this_trial(1)) && (this_trial(1) < (RNDmean - RNDstd)))
%         chunkID = 1;
%         chunks(1) = chunkID;
%     else
%         % Otherwise consider the following element
%         chunkID = 2;
%     end
% 
%     % FOR EACH SUBSEQUENT ELEMENT
%     for (elem = 2:length(this_trial))
% 
%         % IF this reaction time is valid (correct),
%         %  AND EITHER lower than the previous one
%         %       OR higher within a small tolerance
%         %       OR within an acceptable low (close to zero) range
%         if (~isnan(this_trial(elem))) ...
%                 && ((this_trial(elem) < (this_trial(elem-1) - minChangeReq)))       
%             % THEN MARK WITH CURRENT CHUNKNUM
%             chunks(elem) = chunkID;
% 
%         % ELSE IF THIS IS A VALID REACTION TIME, MARK AS NEW CHUNK
%         elseif (~isnan(this_trial(elem)))
%             chunkID = elem;
%             chunks(elem) = chunkID;
%         % OTHERWISE IT'S A NAN AND WE DON'T DO ANYTHING (LEAVE ZERO)
%         % ENDIF
%         end
% 
%     % END FOR ELEMENT
%     end
    
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