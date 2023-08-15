%Calculates regional myocardial work given the patient-specific regional strain
%measurments, RV pressure waveforms, and timing of the CTs across the
%cardiac cycle. User can select which study they want to calculate MWCT for on line 9.  

clear; clc

%Select the study group you want to calculate MWCT for:
studytype = [{''},{'/Intraobserver Study'},{'/Interobserver Study'}];
studytype_indx = 3;

%Start in any subfolder of this repo
addpath('../scripts')
addpath(genpath('../data'))
cd('../data/');
datapath = cd('../data');

% Make a list of patient names for each cohort
TOFpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/rTOF*']);
CTEPHpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/CTEPH*']);
HFpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/HF*']);
patnames = generate_patient_names(TOFpats,CTEPHpats,HFpats,4);
seg_patsIndx = 1:length(patnames);

%%%Load in CT acquisition across the RR interval%%%
CT_timing_array = readmatrix([datapath,studytype{studytype_indx},'/CT_time_frames/CT_time_frames.csv']);
CT_timing_array(:,1) = []; %remove patient indexing

for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    MW_CT = [];
    MW_CT_table = [];
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,studytype{studytype_indx},'/RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing

    %%%Load in RV pressure data%%%
    RVpressure = readmatrix([datapath,studytype{studytype_indx},'/RV_pressure/',patnames{patient},'_RVpressure.csv']);

    %%%Calculate MWCT%%%
    MW_CT = calculateMWCT(RS_CT_array,RVpressure,CT_timing_array(q,:));

    %%%Save MWCT calculations
    %MW_CT_table = table(MW_CT);
    MW_CT_table = table((1:length(MW_CT))',MW_CT,'VariableNames',{'Patch Number','Myocardial work value'});
    writetable(MW_CT_table,[datapath,studytype{studytype_indx},'/MWCT_data/',patnames{patient},'_MWCT.csv'])

end