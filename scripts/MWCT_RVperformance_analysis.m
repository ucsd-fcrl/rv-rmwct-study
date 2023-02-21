%Performs RV functional categorization across the whole RV and for RV
%segments

clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper';
cd(home)
addpath(genpath(home))
datapath = [home,'/data/'];
savepath = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper/';

TOFpats = dir([datapath,'RSCT_data/rTOF*']);
CTEPHpats = dir([datapath,'RSCT_data/CTEPH*']);
HFpats = dir([datapath,'RSCT_data/HF*']);
patnames = generate_patient_names(TOFpats,CTEPHpats,HFpats,1);
seg_patsIndx = 1:length(patnames);

%% Whole RV analysis
VentricleMeanMW = zeros(length(seg_patsIndx),1);
Ventricle_kinetic = zeros(length(seg_patsIndx),1);
Ventricle_dyskinetic = zeros(length(seg_patsIndx),1);
Ventricle_negWork = zeros(length(seg_patsIndx),1);

per_kin_pw = zeros(length(seg_patsIndx),1);
per_kin_nw = zeros(length(seg_patsIndx),1);
per_dyskin_pw = zeros(length(seg_patsIndx),1);
per_dyskin_nw = zeros(length(seg_patsIndx),1);
dice = zeros(length(seg_patsIndx),1);
disp('Starting whole RV analysis')
for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])
%     [flag,flag1,flag2] = identify_pat_path(q,patnamelist); 

%     %%%Load in RV data points%%%
    framepts = readmatrix([datapath,'RV_framepts/',patnames{patient},'_RV_framepts.csv']);
    %identify points labeled right atrium or pulmonary artery and their
    %adjacent points (removing lids)
    includedpts_lid = readmatrix([datapath,'lid_framepts/',patnames{patient},'_lid_framepts.csv']);

    %%%Load in volume data%%%
    vol = readmatrix([datapath,'RV_volumes/',patnames{patient},'_volumes.csv']);

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,'RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing
   
    %%Load in MWCT data%%%
    MW_CT = readmatrix([datapath,'MWCT_data/',patnames{patient},'_MWCT.csv']);

    %%%Whole RV analysis%%%
    [kinetic_pw,kinetic_nw,dyskinetic_pw,dyskinetic_nw,meanMW,...
        kineticPW_ind, kineticNW_ind,dyskineticPW_ind, dyskineticNW_ind] = categorizeMW(MW_CT,RS_CT_array,vol,datapath,patnames{patient},'RV'); 
   
     %%%Collect data%%%
     VentricleMeanMW(q) = meanMW;
     Ventricle_kinetic(q) = kinetic_pw+ kinetic_nw;
     Ventricle_dyskinetic(q) = dyskinetic_pw+ dyskinetic_nw;
     Ventricle_negWork(q) = kinetic_nw+ dyskinetic_nw; 

     per_kin_pw(q) = kinetic_pw;
     per_kin_nw(q) = kinetic_nw;
     per_dyskin_pw(q) = dyskinetic_pw;
     per_dyskin_nw(q) = dyskinetic_nw;
     dice(q) = (2*numel(dyskineticNW_ind))./(numel(dyskineticPW_ind)+numel(dyskineticNW_ind)+numel(kineticNW_ind));
end
disp('Whole RV analysis completed')
%% Save whole RV performance analysis
patnamelist = generate_patient_names(TOFpats,CTEPHpats,HFpats,2);

   RVperformance = table(patnamelist, per_kin_pw, per_dyskin_pw,per_kin_nw, per_dyskin_nw,dice,'VariableNames',...
       {'Patients','Kinetic-Productive (%)', 'Dyskinetic-Productive (%)','Kinetic-Unproductive (%)', 'Dyskinetic-Unproductive (%)','Dyskinesia-Unproductive Overlap'});
   writetable(RVperformance,[savepath,'results/Table2_Figure2_results/','RVfunctional_categories_results.csv'])

%% Segmental RV analysis (free wall, septal wall, RVOT)

FWMeanMW = zeros(length(seg_patsIndx),1);
FW_kinetic = zeros(length(seg_patsIndx),1);
FW_dyskinetic = zeros(length(seg_patsIndx),1);
FW_negWork = zeros(length(seg_patsIndx),1);

SWMeanMW = zeros(length(seg_patsIndx),1);
SW_kinetic = zeros(length(seg_patsIndx),1);
SW_dyskinetic = zeros(length(seg_patsIndx),1);
SW_negWork = zeros(length(seg_patsIndx),1);

RVOTMeanMW = zeros(length(seg_patsIndx),1);
RVOT_kinetic = zeros(length(seg_patsIndx),1);
RVOT_dyskinetic = zeros(length(seg_patsIndx),1);
RVOT_negWork = zeros(length(seg_patsIndx),1);

disp('Starting segmental RV analysis')
for q = 1:length(seg_patsIndx)
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])

    %%%Load in volume data%%%
    vol = readmatrix([datapath,'RV_volumes/',patnames{patient},'_volumes.csv']);

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,'RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing
   
    %%Load in MWCT data%%%
    MW_CT = readmatrix([datapath,'MWCT_data/',patnames{patient},'_MWCT.csv']);

    %%%Isolate free wall function and categorize%%%
%    [FW_MW_CT,FW_RS_CT,FWframepts] = isolate_poi(datapath,'FW_framepts/',flag1,'FW',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [FW_kinetic_pw,FW_kinetic_nw,FW_dyskinetic_pw, FW_dyskinetic_nw,FW_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,datapath,patnames{patient},'FW');

     %%%Isolate the septal wall%%%
     % [SW_MW_CT,SW_RS_CT,SWframepts] = isolate_poi(datapath,'SW_framepts/',flag1,'SW',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [SW_kinetic_pw,SW_kinetic_nw,SW_dyskinetic_pw, SW_dyskinetic_nw,SW_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,datapath,patnames{patient},'SW');

     %%%Isolate the RVOT%%%  
      %[RVOT_MW_CT,RVOT_RS_CT,RVOTframepts] = isolate_poi(datapath,'RVOT_framepts/',flag1,'RVOT',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [RVOT_kinetic_pw,RVOT_kinetic_nw,RVOT_dyskinetic_pw, RVOT_dyskinetic_nw,RVOT_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,datapath,patnames{patient},'RVOT');

     %%%Collect data%%%
     FWMeanMW(q) = FW_meanMW;
     FW_kinetic(q) = FW_kinetic_pw+FW_kinetic_nw;
     FW_dyskinetic(q) = FW_dyskinetic_pw+ FW_dyskinetic_nw;
     FW_negWork(q) = FW_kinetic_nw+FW_dyskinetic_nw;
     
     SWMeanMW(q) = SW_meanMW;
     SW_kinetic(q) = SW_kinetic_pw+SW_kinetic_nw;
     SW_dyskinetic(q) = SW_dyskinetic_pw+  SW_dyskinetic_nw;
     SW_negWork(q) = SW_kinetic_nw+SW_dyskinetic_nw;

     RVOTMeanMW(q) = RVOT_meanMW;
     RVOT_kinetic(q) = RVOT_kinetic_pw+ RVOT_kinetic_nw;
     RVOT_dyskinetic(q) = RVOT_dyskinetic_pw+ RVOT_dyskinetic_nw;
     RVOT_negWork(q) = RVOT_kinetic_nw+RVOT_dyskinetic_nw;
end
disp('Segmental RV analysis completed')

%% Save segmental RV performance analysis 
patnamelist = generate_patient_names(TOFpats,CTEPHpats,HFpats,2);
  meanMWresults = table(patnamelist,VentricleMeanMW,FWMeanMW,...
        SWMeanMW,RVOTMeanMW,'VariableNames',...
        {'Patients','RV mean MW','FW mean MW','SW mean MW','RVOT mean MW'});
   writetable(meanMWresults,[savepath,'results/Figure3_results/','mean_MW_results.csv'])

    negworkresults = table(patnamelist,Ventricle_negWork, FW_negWork,...
       SW_negWork, RVOT_negWork,'VariableNames',...
       {'Patients','RV unproductive work (%)','FW unproductive work (%)','SW unproductive work (%)','RVOT unproductive work (%)'});
   writetable(negworkresults,[savepath,'results/Figure3_results/','unproductive_work_results.csv'])

    dyskinesiaresults = table(patnamelist,Ventricle_dyskinetic,FW_dyskinetic,...
        SW_dyskinetic,RVOT_dyskinetic,'VariableNames',...
       {'Patients','RV dyskinesia (%)','FW dyskinesia (%)','SW dyskinesia (%)','RVOT dyskinesia (%)'});
    writetable(dyskinesiaresults,[savepath,'results/Figure3_results/','dyskinesia_results.csv'])
