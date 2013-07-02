function consol=selectConsolData(data,blocks,pctChng)
% Function to work with MFST_MC data to calculate between-day change
% calculates as either difference between two blocks or % change relative
% to first block
% 
% input:
% <data>     - matrix of data (Ss X blocks)
% <blocks>   - number of blocks per day in this data 
% <pctChng>  - set to calculate as proportion change {true, false}
%
% output:
% <consol>   - matrix of consolidation values      

%initialise vars
%calculate size for display
days=size(data,2)/blocks;
for day=1:days-1
    idx=(day-1)*blocks+blocks; %index to last block of the day
    if pctChng
        consol(:,day)=(data(:,idx+1)-data(:,idx))./data(:,idx+1);
    else
        consol(:,day)=data(:,idx+1)-data(:,idx);
        %consol(:,day)=mean(data(:,idx+1:idx+2),2)-mean(data(:,idx-1:idx),2)
    end
end