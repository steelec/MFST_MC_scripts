function PPs = New_Chunks_201402(PPs)
% MFST @ BNI 2012 analysis
% Calculate and save new chunking data from existing PPs file
% Joseph Thibodeau 2014

% START BY LOADING THE PPS FILE
% for now, loading manually outside of this script.

% auto-load, if desired:
%uiload();

% DEFINE LIST OF SUBJECTS and DAYS
IDs = PPs.IDs;
Days = [1 2 3 4 5 6];

% FOR EACH SUBJECT
for (ID = 1:length(IDs))

    % FOR VISUALIZATION OF CHUNKING
    currentFigure = figure(ID);
    
    % FOR EACH DAY
    for (day = 1:length(Days))
        
    % GET INPUT STRUCTURES
    % REACTION TIMES
    cmd = ['lags = PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.lag1;'];
    eval(cmd);
    lags = cell2mat(lags);
    
    % LEARN SEQUENCE POSITIONS
    cmd = ['LRNMask = PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.LRNSeqPosn;'];
    eval(cmd);
    %LRNMask = cell2mat(LRNMask);
    LRNMask = reshape(LRNMask, size(LRNMask,1)*size(LRNMask,2),1);

    % CREATE OUTPUT STRUCTURES
    chk_temp = zeros(size(lags));
    chk_full = zeros(size(lags));
    chkLRN = zeros(size(lags));
    chkRND = zeros(size(lags));
    tempLRN = zeros(size(lags));
    tempRND = zeros(size(lags));
    
%     % BEFORE WE LOOK FOR CHUNKS, DETREND THE REACTION TIMES
%     % reshape to a vector before cutting out NaNs
%     dtlags = reshape(lags',size(lags,1)*size(lags,2),1);
%     % detrend without NaNs
%     temp = detrend(dtlags(~isnan(dtlags)));
%     % re-insert into non-NaN dtlags elements
%     dtlags(~isnan(dtlags)) = temp;
%     % reshape again into the original size
%     dtlags = reshape(dtlags,size(lags,2),size(lags,1));
%     dtlags = dtlags';
%     % overwrite original lags
%     lags = dtlags;
    
        % FOR EACH TRIAL (row)
        for (trial = 1:size(lags,1))
        
            % FIND the chunk sizes and locations in this trial
            sumChunks = findChunksInTrial(lags(trial,:));
            chk_full(trial,:) = sumChunks;
            
            % IF this is a LEARNED sequence ADD it to the LRN structures
            % AND invalidate it in the RND structures
            if (LRNMask(trial) == 1)
                chkLRN(trial,:) = sumChunks;
                chkRND(trial,:) = sumChunks.*NaN;
                
                tempLRN(trial,:) = (lags(trial,:));
                tempRND(trial,:) = (lags(trial,:)).*NaN;
                
            % ELSE do the opposite: ADD to RND and invalidate LRN
            else
                chkRND(trial,:) = sumChunks;
                chkLRN(trial,:) = sumChunks.*NaN;
                
                tempRND(trial,:) = (lags(trial,:));
                tempLRN(trial,:) = (lags(trial,:)).*NaN;
            %ENDIF
            end       
            
        % END FOR TRIAL
        end
        
    % CALCULATE MEANS FOR LRN AND RND
    meanLRN = nanmean(tempLRN);
    meanRND = nanmean(tempRND);
    
    % NOW DO THE SAME ELEMENT-BY-ELEMENT ALGORITHM AS BEFORE
    % BUT ON THE DAILY MEANS
    dayChkLRN = findChunksInTrial(meanLRN);
    dayChkRND = findChunksInTrial(meanRND);
    
    
    % SAVE OUTPUT STRUCTURES
    cmd = ['PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.chkLRN = chkLRN;'];
    eval(cmd);
    cmd = ['PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.chkRND = chkRND;'];
    eval(cmd);
    cmd = ['PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.dayChkLRN = dayChkLRN;'];
    eval(cmd);
    cmd = ['PPs.' IDs{ID} '.results.d' num2str(Days(day)) '.dayChkRND = dayChkRND;'];
    eval(cmd);
    
    % VISUALIZATION
    subplot(2,length(Days),day);
    tempout = smearChunks(chkLRN);
    tempimg = mat2gray(tempout);
    imshow(tempimg);
    title([IDs{ID} 'LRNd' num2str(Days(day))]);
    
    subplot(2,length(Days),day+length(Days));
    tempout2 = smearChunks(chkRND);
    tempimg2 = mat2gray(tempout2);
    imshow(tempimg2);
    title([IDs{ID} 'RNDd' num2str(Days(day))]);
    
    % END FOR DAY
    end
    
    % SAVE VISUALIZATION
    saveas(currentFigure,['pics/' IDs{ID} '_chk.jpg']);
    
% END FOR SUBJECT
end