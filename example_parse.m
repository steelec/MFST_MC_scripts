%avrum hollinger
%behavioural parsing script, mri-compatible keyboard, python-controlled
%experiment
%plot(squeeze(subject3_day1_fam0001.Trajectories.Labeled.Data(9,:,:))')
%f_list=['01';'09';'10']
f_list=['10']
for file_indx=1:length(f_list(:,1))
        
    f_list(file_indx,:)
    f_name=strcat('example_parse_P',f_list(file_indx,:),'_day1_familiarization.txt')
    f_id=fopen(f_name)
    f_data=textscan(f_id,'%u %u %u %u %s %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u');
    fclose(f_id);
    f_length=length(f_data{1});
    num_stim=[0,0,0,0];
    num_trig_on=[0,0,0,0];
    num_trig_off=[0,0,0,0];
    num_val=[0,0,0,0];
   
    num_frames=0;
    num_ISI=0;
    num_blank=0;
    stims=[0,0,0,0]; % PC timestamp for columns corresponding to channel
    frames=[0,0]; %PSoC timestamp, PC timestamp
    ISI=[0,0];
    blank=[0,0];

    triggers_on_psoc=[0,0,0,0]; %PSoC timestamp
    triggers_on_PC=[0,0,0,0]; %PC timestamp
    triggers_off_psoc=[0,0,0,0]; % PSoC timestamp
    triggers_off_PC=[0,0,0,0]; % PC timestamp

    key_vals=[0,0,0,0]; %key number, key val, PSoC timestamp, PC timestamp
    key_psoc=[0,0,0,0];
    key_PC=[0,0,0,0];



    for indx = 1:f_length
        if strcmp(char(f_data{5}(indx)),'Stim')
            stim_ch=f_data{6}(indx);
            num_stim(stim_ch)=num_stim(stim_ch)+1;
        %    stims(sum(num_stim),1)=stim_ch;
            %stims(sum(num_stim),2)=get_PC_time(indx,f_data);
            stims(num_stim(stim_ch),stim_ch)=get_PC_time(indx,f_data);


        elseif strcmp(char(f_data{5}(indx)),'Key')
            key_ch=f_data{6}(indx);
            key_val=f_data{7}(indx);

            if key_ch ==0
                num_frames=num_frames+1;
                frames(num_frames,1)=get_psoc_time(indx,f_data);
                frames(num_frames,2)=get_PC_time(indx,f_data);

            elseif (key_val==0)
                num_trig_off(key_ch)=num_trig_off(key_ch)+1;
                triggers_off_psoc(num_trig_off(key_ch),key_ch)=get_psoc_time(indx,f_data);
                triggers_off_PC(num_trig_off(key_ch),key_ch)=get_PC_time(indx,f_data);


            elseif (key_val==127)
                num_trig_on(key_ch)=num_trig_on(key_ch)+1;
                triggers_on_psoc(num_trig_on(key_ch),key_ch)=get_psoc_time(indx,f_data);
                triggers_on_PC(num_trig_on(key_ch),key_ch)=get_PC_time(indx,f_data);

            else 
                num_val(key_ch)=num_val(key_ch)+1;
                key_vals(num_val(key_ch),key_ch)=key_val;
                key_psoc(num_val(key_ch),key_ch)=get_psoc_time(indx,f_data);
                key_PC(num_val(key_ch),key_ch)=get_PC_time(indx,f_data);

            end

        elseif strcmp(char(f_data{5}(indx)),'ISI')
            num_ISI=num_ISI+1;
            ISI(num_ISI,1)=get_psoc_time(indx,f_data);
            ISI(num_ISI,2)=get_PC_time(indx,f_data);
        elseif strcmp(char(f_data{5}(indx)),'Blank')
            num_blank=num_blank+1;
            blank(num_blank,1)=get_psoc_time(indx,f_data);
            blank(num_blank,2)=get_PC_time(indx,f_data);
        end
    end


    key_vals(key_vals==0)=nan;
    key_psoc(key_psoc==0)=nan;
    key_PC(key_PC==0)=nan;
    triggers_off_PC(triggers_off_PC==0)=nan;
    triggers_on_PC(triggers_on_PC==0)=nan;
    triggers_off_psoc(triggers_off_psoc==0)=nan;
    triggers_on_psoc(triggers_on_psoc==0)=nan;
    stims(stims==0)=nan;

    min_vals=min(key_vals);
    max_vals=max(key_vals);
    scaled_vals=zeros(size(key_vals));
    
    
    
    
    for key_ch=1:4
    
        
        start_time=stims(1,key_ch)+0
        end_time=stims(1,key_ch)+1000
    
    
        fsamp=find(key_PC(:,key_ch)>=start_time,1,'first')
        lsamp=find(key_PC(:,key_ch)<=end_time,1,'last')
        if (isempty(lsamp)||lsamp<fsamp)
            lsamp=fsamp+1
        end
        figure
        hold
       
        delta_frames=frames(fsamp+1:lsamp,2)-frames(fsamp:lsamp-1,2);
        first_good_stamp_indx=find(delta_frames<=25,1,'first');
        first_good_stamp_PC=frames(first_good_stamp_indx,2);
        
        scaled_vals(:,key_ch)=(127*(key_vals(:,key_ch)-min_vals(key_ch))/(max_vals(key_ch)-min_vals(key_ch)));
        
        plot(key_PC(fsamp:lsamp,key_ch)-frames(1,2),scaled_vals(fsamp:lsamp,key_ch),'k')
        
        %t_on_s=find(triggers_on_PC(:,key_ch)>=key_PC(fsamp,key_ch),1,'first');
        %t_on_f=find(triggers_on_PC(:,key_ch)<=key_PC(lsamp,key_ch),1,'last');
        t_on_s=find(triggers_on_PC(:,key_ch)>=start_time,1,'first');
        t_on_f=find(triggers_on_PC(:,key_ch)<=end_time,1,'last');
        if (isempty(t_on_f)||t_on_f<t_on_s)
            t_on_f=t_on_s
        end
        %t_off_s=find(triggers_off_PC(:,key_ch)>=key_PC(fsamp,key_ch),1,'first');
        %t_off_f=find(triggers_off_PC(:,key_ch)<=key_PC(lsamp,key_ch),1,'last');
        t_off_s=find(triggers_off_PC(:,key_ch)>=start_time,1,'first');
        t_off_f=find(triggers_off_PC(:,key_ch)<=end_time,1,'last');
        if (isempty(t_off_f)||t_off_f<t_off_s)
            t_off_f=t_off_s
        end
    %    s_on_s=find(stims(:,key_ch)>=key_PC(fsamp,key_ch),1,'first');
     %   s_on_f=find(stims(:,key_ch)<=key_PC(lsamp,key_ch),1,'last');
        s_on_s=find(stims(:,key_ch)>=start_time,1,'first');
        s_on_f=find(stims(:,key_ch)<=end_time,1,'last');
        
         if (isempty(s_on_f)||s_on_f<s_on_s)
            s_on_f=s_on_s
         end
        frame_first=find(frames(:,2)>=start_time,1,'first');
        frame_last=find(frames(:,2)<=end_time,1,'last');
        
        %plot(stims(s_on_s:s_on_f,key_ch)-frames(1,2),127,'gx')
       % plot(stims(s_on_s:s_on_f,key_ch)-frames(1,2)+500,0,'rx')
        plot(triggers_on_PC(t_on_s:t_on_f,key_ch)-frames(1,2),127,'c.')
        plot(triggers_off_PC(t_off_s:t_off_f,key_ch)-frames(1,2),0,'m.')
        
        %plot(frames(frame_first:frame_last,2)-frames(1,2),127,'bo')

        
        

    end
end
%plot(key_PC(1370:1474,key_ch)-key_PC(1379,4),scaled_vals(1370:1474,key_ch),'k')