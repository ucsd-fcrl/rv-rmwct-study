function [flag, flag1,flag2] = identify_pat_path(patnumber,patnamelist)
%%%Goal%%%
%Identify the correct patient file path based on your position in the
%patient list.

%%%Input%%%
%patnumber = index of patient list
%patnamelist = patient list

%%%Output%%%
%two separate flags for different file paths

if strfind(patnamelist(patnumber),"rTOF") == 1
    flag = 'TOF/RV/with_RHC/';
    flag1 =  'rTOF/';
    flag2 = 'TOF/';
elseif strfind(patnamelist(patnumber),"CTEPH") == 1
    flag = 'CTEPH/RV/';
    flag1 =  'CTEPH/';
    flag2 =  'CTEPH/';
elseif strfind(patnamelist(patnumber),"HF") == 1 
    flag = 'LVADs/RV/';
    if patnumber >= 17 & patnumber <= 22
        flag1 =  'HF/ischemicCM/';
    elseif patnumber >= 22 & patnumber <= 35
        flag1 =  'HF/nonischemicCM/';
    end
    flag2 = 'LVADs/';
end


