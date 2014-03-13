% Loading processed data

%%load /home/PENHUNE/MFST_MC/processing/bx/pilot/2011_06_Processed_18Ps.mat
%%
uiload()

chunkfoldername = 'ChunkingData/';

% Start with LRN data

data=PPs.all.data.chunk.LRN;
[m sd n]=MFST_MC_selectChunk(data,'Individual',true,4);
% output a file for each subject

for(ID_index = 1:length(IDs))
    this_m=squeeze(m(ID_index,:,:));
    this_n=squeeze(n(ID_index,:,:));
    subjname = IDs{ID_index};
    
    % before we write the outputs, we need to exclude elements that fall
    % beyond 2SDs from the columnwise mean.
    this_sd = std(this_m);
    this_mean = mean(this_m);
    
    
    % expand to the right size
    this_sd = this_sd(ones(size(this_m,1),1),:);
    this_mean = this_mean(ones(size(this_m,1),1),:);
    
    % subtract mean, do absolute value, then subtract 2SDs.
    this_nan = abs(this_m - this_mean) - (2.*this_sd);
    
    % any positive values are NaNs
    this_nan(this_nan > 0) = NaN;
    this_nan(this_nan <= 0) = 1;
    
    this_m = this_m.*this_nan;
    
    
    dlmwrite(strcat(chunkfoldername, subjname, '_chunking_LRN.txt'),this_m,'\t');
    dlmwrite(strcat(chunkfoldername, subjname, '_chunking_LRN_numel.txt'),this_n,'\t');
end


% Start with RND data

data=PPs.all.data.chunk.RND;
[m sd n]=MFST_MC_selectChunk(data,'Individual');

% output a file for each subject

for(ID_index = 1:length(IDs))
    this_m=squeeze(m(ID_index,:,:));
    this_n=squeeze(n(ID_index,:,:));
    subjname = IDs{ID_index};
    dlmwrite(strcat(chunkfoldername, subjname, '_chunking_RND.txt'),this_m,'\t');
    dlmwrite(strcat(chunkfoldername, subjname, '_chunking_LRN_numel.txt'),this_n,'\t');
end