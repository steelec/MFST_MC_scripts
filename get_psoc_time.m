function psoc_time=get_psoc_time(row_indx,dataset)
    psoc_time=dataset{13}(row_indx)+dataset{12}(row_indx)*256+dataset{11}(row_indx)*256*256+dataset{10}(row_indx)*256*256*256;
end


