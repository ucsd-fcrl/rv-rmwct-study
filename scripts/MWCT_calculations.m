clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper';
cd(home)
addpath(genpath(home))
datapath = [home,'/data/'];

% % Make a list of patient names for each cohort
% TOFpats = dir([home,'/MWCT_data/rTOF/CVC*']); %/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/TOF/RV/with_RHC/CVC*');
% TOFpatnames = cell(length(TOFpats),1);
% for i = 1:length(TOFpats)
%     TOFpatnames{i} = TOFpats(i).name(1:13);
% end
% 
% CTEPHpats = dir([home,'/MWCT_data/CTEPH/CVC*']); %dir('/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/CTEPH/RV/CVC*');
% CTEPHpatnames = cell(length(CTEPHpats),1);
% for i = 1:length(CTEPHpats)
%     CTEPHpatnames{i} = CTEPHpats(i).name(1:13);
% end
% 
% ICMpats = dir([home,'/MWCT_data/HF/ischemicCM/CVC*']);
% nonICMpats = dir([home,'/MWCT_data/HF/nonischemicCM/CVC*']); %dir('/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/CTEPH/RV/CVC*');
% HFpats = [ICMpats;nonICMpats];
% HFpatnames = cell(length(HFpats),1);
% for i = 1:length(HFpats)
%     HFpatnames{i} = HFpats(i).name(1:13);
% end
% 
% patnames = [TOFpatnames; CTEPHpatnames; HFpatnames]; 
% seg_patsIndx = 1:length(patnames);

% Make a list of patient names for each cohort
TOFpats = dir([datapath,'RSCT_data/rTOF*']);
CTEPHpats = dir([datapath,'RSCT_data/CTEPH*']);
HFpats = dir([datapath,'RSCT_data/HF*']);
patnames = generate_patient_names(TOFpats,CTEPHpats,HFpats,1);
seg_patsIndx = 1:length(patnames);

%%%Load in CT acquisition across the RR interval%%%
CT_timing_array = readmatrix([datapath,'CT_time_frames/CT_time_frames.csv']);
CT_timing_array(:,1) = []; %remove patient indexing

for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])

    %%%Load in RV data points%%%
    framepts = readmatrix([datapath,'RV_framepts/',patnames{patient},'_RV_framepts.csv']);

    %%%Load in volume data%%%
    vol = readmatrix([datapath,'RV_volumes/',patnames{patient},'_volumes.csv']);

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,'/RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing

    %%%Load in RV pressure data%%%
    RVpressure = readmatrix([datapath,'/RV_pressure/',patnames{patient},'_RVpressure.csv']);

    %%%Calculate MWCT%%%
    MW_CT = calculateMWCT(RS_CT_array,RVpressure,CT_timing_array(q,:));

    %%%Save MWCT calculations
    MW_CT_table = table(MW_CT);
    writetable(MW_CT_table,[datapath,'MWCT_data/',patnames{patient},'_MWCT.csv'])

end