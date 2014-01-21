% Here is where we interpolate missing key ON and key OFF messages:

% Key ON and OFF messages get sent when a certain threshold is met, it
% depends on the calibration of the PSoC board. So our first step here is
% to determine the approximate ON and OFF thresholds.

% key ON: each key on message will be bracketed by two position
% measurememtns. So find these measures and then linearly interpolate the
% threshold using the position of existing ON events

% will do a separate process for each key so that we avoid confusion if two
% keys are down simultaneously

recovered_onsets = [];
recovered_releases = [];
responses = [];

key_thresh = [];
key_lag = [];

for key = 1:length(stim_uniques)
%     disp(['key: ' num2str(key)]); %DEBUG
    % extract events for this key
    mask_on = key_on(:,3) == key;
    mask_off = key_off(:,3) == key;
    mask_pos = key_pos(:,3) == key;
    
    this_on = key_on(mask_on,:);
    this_off = key_off(mask_off,:);
    this_pos = key_pos(mask_pos,:);
    
    % prepare threshold accumulator
    thresh_accum = [];
    
    % for each key ON we find the key positions close by
    for onset = 1:size(this_on,1)
%        disp(['onsets:' num2str(onset/length(this_on))]); %DEBUG
       event = this_on(onset,:);
       % find the position just before the key ON:
       before = find(this_pos(:,1) < event(1));
       if(length(before)==0)
           continue;
       end
       before = before(end);
       
       % find the position just after the key ON:
       after = find(this_pos(:,1) > event(1),1);
       
       % calculate timing ratio of event between before and after
       ratio = (event(1) - this_pos(before,1)) / (this_pos(after,1) - this_pos(before,1));
       
       % calculate positional difference between before and after
       pos_diff = this_pos(after,4) - this_pos(before,4);
       
       % now find this interpolated positional threshold
       thresh = this_pos(before,4) + (pos_diff*ratio);
       
       % accumulate
       thresh_accum = [thresh_accum thresh];
    end
    
    % calculate the mean threshold for this key
    key_thresh = [key_thresh mean(thresh_accum)];
    
    % prepare timelag accumulator
    lag_accum = [];
    
    %for each key OFF we find the mean lag between the key OFF and the
    %positional measure that comes just before it (the key OFF is always
    %after the last positional measure in a burst).
    for release = 1:size(this_off,1)
%        disp(['releases: ' num2str(release/length(this_off))]); %DEBUG
       event = this_off(release,:);
       
       %find the position just before the event
       before = find(this_pos(:,1) < event(1));
       before = before(end);
       
       %store the time lag between the two:
       lag = event(1) - this_pos(before,1);
       lag_accum = [lag_accum lag];
    end
    
    % calculate mean time lag for this key
    key_lag = [key_lag mean(lag_accum)];
    
    
    %% Recovery 
    % now we have all the information we need to insert the missing events.
    % we need to segment the data into zones where these events occur. for
    % each key.
    
    % --- we look for keyON events between the start and end of a given
    % burst of positional information
    
    % --- we look for keyOFF events between the end of a positional burst
    % and the start of the next burst (this filters out false positives due
    % to positional values of 0).
    
    this_pos_time_diff = [0 ; diff(this_pos(:,1))];
    
    % time between bursts interpreted as a break between bursts
    % HARD CODED FOR NOW TO THE SIZE OF AN ISI
    inter_burst_threshold = 200;
    
    % first and last index will be search points, as will any large
    % spike in the time diffs between position values
    search_points = [1 ; find(this_pos_time_diff > inter_burst_threshold) ; length(this_pos_time_diff)];

    % number of bursts equals one less than the number of search points
    num_bursts = length(search_points)-1;
    
    last_burst = 0;

    for burst = 1:num_bursts
        % Get elements and time stamps for search points of this burst
        burst_start = search_points(burst);
        burst_end = search_points(burst+1)-1;
        burst_start_time = this_pos(burst_start,1);
        burst_end_time = this_pos(burst_end,1);

        % Talking about the last burst
        if (burst == num_bursts)
            last_burst = 1;
        else
            burst_next_time =this_pos(search_points(burst+1),1);
        end

        this_burst = this_pos(burst_start:burst_end,:);

        % Check for missing keyON
        burst_keyon = this_on(find((this_on(:,1) > burst_start_time) & (this_on(:,1) < burst_end_time),1));
        recover_onset = isempty(burst_keyon);

        % Recover missing keyON if needed
        if(recover_onset)
            % use the mean threshold to find the index just past the
            % crossing point
            cross = find(this_burst(:,4) < key_thresh(key),1);
            
            % if the first value is already below the threshold, we are
            % probably missing some positional data --- just put the key
            % onset at the same position as the first positional point.
            % This could be made better by back-propagating the slope of
            % the first two positional points to find the approximate time
            % when the threshold would have been crossed.
            if (cross == 1)
                burst_keyon = this_burst(cross,1:2);
                recovered_onsets = [recovered_onsets ; this_burst(cross,1:2) key 127];
            elseif (isempty(cross))
                % we have been unable to find an onset for this burst here.
                % use the same approach as above for now
                burst_keyon = this_burst(1,1:2);
                recovered_onsets = [recovered_onsets ; this_burst(1,1:2) key 127];
            else
                % linear interp to find the right timestamp for the keyON
                ratio = (key_thresh(key) - this_burst(cross-1,4))/(this_burst(cross,4)-this_burst(cross-1,4));
                on_time_PC = this_burst(cross-1,1) + ratio*(this_burst(cross,1)-this_burst(cross-1,1));
                on_time_PSoC = this_burst(cross-1,2) + ratio*(this_burst(cross,2)-this_burst(cross-1,2));
                
                % interpolated keyon
                burst_keyon = [on_time_PC on_time_PSoC];

                % insert new onset into the recovered onset data structure
                % PC timestamp, PSoC timestamp, keyID, highValue
                recovered_onsets = [recovered_onsets ; on_time_PC on_time_PSoC key 127];
            end
        end % recover keyon
        
        % if we never managed to recover a burst keyon, for example if the
        % positional data that we have never went below the "down"
        % threshold, we mark this as a nan. It will be filtered out later.
        if(isempty(burst_keyon))
            burst_keyon = NaN;
        end

        % Destroy spurious keyOFFs in this burst
        %DEBUG:
        num_extra_offs = length(key_off((key_off(:,1) > burst_start_time) & (key_off(:,1) < this_burst(end,1)) & (key_off(:,3) == key)));
        if (num_extra_offs > 0)
            temp = key_off((key_off(:,1) > burst_start_time) & (key_off(:,1) < this_burst(end,1)) & (key_off(:,3) == key),:);
            disp(['Spurious KeyOffs destroyed: ' num2str(num_extra_offs) ' in response ' num2str(burst)]);
            
%             %Sanity checking...
            if(showVisuals)
                figure(3)
                stem(temp(:,1),temp(:,4)+65,'r--<');
                hold on
                stem(this_burst(:,1),this_burst(:,4),':o');
                hold off
            end
%             pause(0.3);
            
            key_off((key_off(:,1) > burst_start_time) & (key_off(:,1) < this_burst(end,1)) & (key_off(:,3) == key),:) = [];
        end
        
        % Check for missing keyOFF
        if(last_burst)
            % for last burst, look for keyoff to the end of time
            burst_keyoff = this_off(find((this_off(:,1) > burst_end_time) & (this_off(:,1) < Master_Time(end)),1));
            recover_release = isempty(burst_keyoff);
        else
            burst_keyoff = this_off(find((this_off(:,1) > burst_end_time) & (this_off(:,1) < burst_next_time),1));
            recover_release = isempty(burst_keyoff);
        end

        % Recover missing keyOFF if needed
        if(recover_release)
           % use mean keyOFF lag to determine placement
           on_time_PC = this_burst(end,1) + key_lag(key);
           on_time_PSoC = this_burst(end,2) + key_lag(key);

           burst_keyoff = [on_time_PC on_time_PSoC];
           recovered_releases = [recovered_releases ; burst_keyoff key 0];
        end
        
        % if we never managed to recover a burst keyoff, we mark this as a 
        % nan. It will be filtered out later.
        if(isempty(burst_keyoff))
            burst_keyoff = NaN;
        end
        
        %% CALCULATING KINEMATIC MEASURES
        % UPDATE: this is not usable right now because we don't have a way
        % of accurately relating positional data to absolute physical
        % measures.
        % using PSoC clock for this because it will be closer to the true
        % time of measurement
        
        % mm of real travel for the key
%         max_value = 63; % was max of 63 for the MFSTMoCap trials at McGill
        max_value = 127; % should be 127 (as of 2012-04)
        distance_conversion = 12; %mm
        normPos = this_burst(:,4)./max_value;
        % TODO: ******insert linearization curve here******
        % get difference of position with timestamps in mm/s
        posdiffs = [diff(this_burst(:,2))./1000, diff(normPos.*distance_conversion)];
        if(~isempty(posdiffs))
            % vector of every finite velocity, calculated as the difference
            % in position divided by the difference in time
            allVelocity = posdiffs(:,2)./posdiffs(:,1);

            % get difference of difference of position now mm/s/s
            veldiffs = [posdiffs(2:end,1) diff(posdiffs(:,2))];
            
            if(~isempty(veldiffs))
                % vector of finite acceleration measures
                allAccel = veldiffs(:,2)./veldiffs(:,1);

                % get difference of difference of acceleration now mm/s/s/s
                accdiffs = [veldiffs(2:end,1) diff(veldiffs(:,2))];
                
                if(~isempty(accdiffs))
                    % vector of finite jerk measures
                    allJerk = accdiffs(:,2)./accdiffs(:,1);

                else %can't calc jerk
                    disp(['Not enough data to calculate jerk (not yoU!) for response ' num2str(burst)]);
                    jerkMeasure = NaN;
                    allJerk = NaN;
                end
            else %can't calc accel
                disp(['Not enough data to calculate acceleration for response ' num2str(burst)]);
                accelMeasure = NaN;
                allAccel = NaN;
                allJerk = NaN;
            end
        else %can't calc vel
            disp(['Not enough data to calculate velocity for response ' num2str(burst)]);
            velocityMeasure = NaN;
            allVelocity = NaN;
            allAccel = NaN;
            allJerk = NaN;
        end
        
        %=============%
        % Here is where you decide what measure you want to extract from
        % the kinematics
        velocityMeasure = max(allVelocity);
        if(velocityMeasure < max(abs(allVelocity)))
            velocityMeasure = min(allVelocity);
        end
        
        accelMeasure = max(allAccel);
        if(accelMeasure < max(abs(allAccel)))
            accelMeasure = min(allAccel);
        end
        
        jerkMeasure = max(allJerk);
        if(jerkMeasure < max(abs(allJerk)))
            jerkMeasure = min(allJerk);
        end
        
        % now we have all the info necessary to make an entry in the
        % responses data structure:
        % PCtime_on PCtime_off velocityMeasure accelMeasure jerkMeasure keyID
        responses = [responses ; burst_keyon(1) burst_keyoff(1) velocityMeasure accelMeasure jerkMeasure key];

        % simpler version:
%         responses = [responses ; burst_keyon(1) burst_keyoff(1) key];

    end % for each burst
end  % for each key

% finally sort the responses by onset time
responses = sortrows(responses,1);