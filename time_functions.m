function psoc_time=get_psoc_time(row_indx,dataset)
    psoc_time=dataset{13}(row_indx)+dataset{12}(row_indx)*256+dataset{11}(row_indx)*256*256+dataset{10}(row_indx)*256*256*256;
end


function PC_time=get_PC_time(row_indx,dataset)
    PC_time=dataset{4}(row_indx)+dataset{3}(row_indx)*1000+dataset{2}(row_indx)*1000*60+dataset{1}(row_indx)*1000*60*60;
end