%Calculates regional myocardial work given the patient-specific regional strain
%measurments, RV pressure waveforms, and timing of the CTs across the
%cardiac cycle

clear; clc

%Start in any subfolder of this repo
addpath(genpath('../data'))
cd('../data/');
datapath = cd('../data/');

% Make a list of patient names for each cohort
TOFpats = dir([datapath,'/RSCT_data/rTOF*']);
CTEPHpats = dir([datapath,'/RSCT_data/CTEPH*']);
HFpats = dir([datapath,'/RSCT_data/HF*']);
patnames = generate_patient_names(TOFpats,CTEPHpats,HFpats,1);
seg_patsIndx = 1:length(patnames);

%%%Load in CT acquisition across the RR interval%%%
CT_timing_array = readmatrix([datapath,'/CT_time_frames/CT_time_frames.csv']);
CT_timing_array(:,1) = []; %remove patient indexing

for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,'/RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing

    %%%Load in RV pressure data%%%
    RVpressure = readmatrix([datapath,'/RV_pressure/',patnames{patient},'_RVpressure.csv']);

    %%%Calculate MWCT%%%
    MW_CT = calculateMWCT(RS_CT_array,RVpressure,CT_timing_array(q,:));

    %%%Save MWCT calculations
    MW_CT_table = table(MW_CT);
    writetable(MW_CT_table,[datapath,'/MWCT_data/',patnames{patient},'_MWCT.csv'])

end