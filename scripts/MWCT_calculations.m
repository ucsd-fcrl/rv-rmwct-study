clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files';
cd(home)

% Make a list of patient names for each cohort
TOFpats = dir([home,'/MWCT_data/rTOF/CVC*']); %/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/TOF/RV/with_RHC/CVC*');
TOFpatnames = cell(length(TOFpats),1);
for i = 1:length(TOFpats)
    TOFpatnames{i} = TOFpats(i).name(1:13);
end

CTEPHpats = dir([home,'/MWCT_data/CTEPH/CVC*']); %dir('/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/CTEPH/RV/CVC*');
CTEPHpatnames = cell(length(CTEPHpats),1);
for i = 1:length(CTEPHpats)
    CTEPHpatnames{i} = CTEPHpats(i).name(1:13);
end

ICMpats = dir([home,'/MWCT_data/HF/ischemicCM/CVC*']);
nonICMpats = dir([home,'/MWCT_data/HF/nonischemicCM/CVC*']); %dir('/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/CTEPH/RV/CVC*');
HFpats = [ICMpats;nonICMpats];
HFpatnames = cell(length(HFpats),1);
for i = 1:length(HFpats)
    HFpatnames{i} = HFpats(i).name(1:13);
end

patnames = [TOFpatnames; CTEPHpatnames; HFpatnames]; 
seg_patsIndx = 1:length(patnames);

% Set up patient name column for saved data table
[patnamelist] = generate_patient_name_column(TOFpats,CTEPHpats,HFpats);

%%%Load in CT acquisition across the RR interval%%%
CTtiming = readtable([home,'/CT_time_frames/CT_time_frames.csv']);
CT_timing_patnames = table2array(CTtiming(:,1));
CT_timing_array = table2array(CTtiming(:,2:end));

for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])
    [flag,flag1] = identify_pat_path(q,patnamelist); 

    %%%Load in RV data points%%%
    framepts = table2array(readtable([home,'/RV_framepts/',flag1,patnames{patient},'_framepts.csv']));

    %%%Load in volume data%%%
    vol = table2array(readtable([home,'/RV_volumes/',flag1,patnames{patient},'_volumes.csv']));

    %%%Load in RSCT data%%%
    RS_CT_data = readtable([home,'/RSCT_data/',flag1,patnames{patient},'_RSCT.csv']);
    RS_CT_array = table2array(RS_CT_data(:,2:end));

    %%%Load in RV pressure data%%%
    RVpressure = table2array(readtable([home,'/RV_pressure/',flag1,patnames{patient},'_RVpressure.csv']));

    %%%Calculate MWCT%%%
    MW_CT = calculateMWCT(RS_CT_array,RVpressure,CT_timing_array(q,:));

    %%%Save MWCT calculations
    MW_CT_table = table(MW_CT);
    writetable(MW_CT_table,[home,'/MWCT_data/',flag1,patnames{patient},'_MWCT.csv'])

end