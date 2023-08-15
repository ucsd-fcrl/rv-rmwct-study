%Performs RV functional categorization across the whole RV and for RV
%segments

clear; clc

%Select the study group you want to calculate MWCT for:
studytype = [{''},{'/Intraobserver Study'},{'/Interobserver Study'}];
studytype_indx = 1;

%Start in any subfolder of this repo
warning('Make sure you are in one of the three main subfolders of this repo before running (scripts, data, or results)')
addpath(genpath('../data'))
cd('../data/');
datapath = cd('../data/');
addpath(genpath('../results'))
cd('../results/');
resultspath = cd('../results/');
cd('../scripts');

%Generate patient names
TOFpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/rTOF*']);
CTEPHpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/CTEPH*']);
HFpats = dir([datapath,studytype{studytype_indx},'/RSCT_data/HF*']);

TOFpatnames = cell(length(TOFpats),1);
CTEPHpatnames = cell(length(CTEPHpats),1);
HFpatnames = cell(length(HFpats),1);
for i = 1:length(TOFpats)
    TOFpatnames{i} = TOFpats(i).name(1:5);
    CTEPHpatnames{i} = CTEPHpats(i).name(1:6);
end

for i = 1:length(HFpats)
    HFpatnames{i} = HFpats(i).name(1:4);
    if HFpatnames{i}(end) == '_'
        HFpatnames{i}(end) = [];
    end
end

[~,sort_indx] = sort(str2double(regexp(HFpatnames,'\d+','match','once')));
HFpatnames = HFpatnames(sort_indx);

patnames = [TOFpatnames;CTEPHpatnames;HFpatnames];
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

    %%%Load in volume data%%%
    vol = readmatrix([datapath,studytype{studytype_indx},'/RV_volumes/',patnames{patient},'_volumes.csv']);

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,studytype{studytype_indx},'/RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing
   
    %%Load in MWCT data%%%
    MW_CT = readmatrix([datapath,studytype{studytype_indx},'/MWCT_data/',patnames{patient},'_MWCT.csv']);
    MW_CT = MW_CT(:,2);

    %%%Whole RV analysis%%%
    if studytype_indx == 1
        fig_flag = 1; %this flag generates Figure 2A-C. Set this equal to 0 if you don't want to make them.
    else
        fig_flag = 0;
    end
    [kinetic_pw,kinetic_nw,dyskinetic_pw,dyskinetic_nw,meanMW,...
        kineticPW_ind, kineticNW_ind,dyskineticPW_ind, dyskineticNW_ind] = categorizeMW(MW_CT,RS_CT_array,vol,[datapath,studytype{studytype_indx}],patnames{patient},'RV',fig_flag,q); 
   
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
   writetable(RVperformance,[resultspath,studytype{studytype_indx},'/Table2_Figure2_results/','RVfunctional_categories_results.csv'])

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
    vol = readmatrix([datapath,studytype{studytype_indx},'/RV_volumes/',patnames{patient},'_volumes.csv']);

    %%%Load in RSCT data%%%
    RS_CT_array = readmatrix([datapath,studytype{studytype_indx},'/RSCT_data/',patnames{patient},'_RSCT.csv']);
    RS_CT_array(:,1) = []; %remove point indexing
   
    %%Load in MWCT data%%%
    MW_CT = readmatrix([datapath,studytype{studytype_indx},'/MWCT_data/',patnames{patient},'_MWCT.csv']);
    MW_CT = MW_CT(:,2);

    %%%Isolate free wall function and categorize%%%
    % Note that the figure flag is set to zero. Figure 2A-C in the paper
    % is mapping the whole RV.
    [FW_kinetic_pw,FW_kinetic_nw,FW_dyskinetic_pw, FW_dyskinetic_nw,FW_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,[datapath,studytype{studytype_indx}],patnames{patient},'FW',0,q);

     %%%Isolate the septal wall%%%
    [SW_kinetic_pw,SW_kinetic_nw,SW_dyskinetic_pw, SW_dyskinetic_nw,SW_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,[datapath,studytype{studytype_indx}],patnames{patient},'SW',0,q);

     %%%Isolate the RVOT%%%  
    [RVOT_kinetic_pw,RVOT_kinetic_nw,RVOT_dyskinetic_pw, RVOT_dyskinetic_nw,RVOT_meanMW] = categorizeMW(MW_CT,RS_CT_array,vol,[datapath,studytype{studytype_indx}],patnames{patient},'RVOT',0,q);

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
   writetable(meanMWresults,[resultspath,studytype{studytype_indx},'/Figure3_results/','mean_MW_results.csv'])

    negworkresults = table(patnamelist,Ventricle_negWork, FW_negWork,...
       SW_negWork, RVOT_negWork,'VariableNames',...
       {'Patients','RV unproductive work (%)','FW unproductive work (%)','SW unproductive work (%)','RVOT unproductive work (%)'});
   writetable(negworkresults,[resultspath,studytype{studytype_indx},'/Figure3_results/','unproductive_work_results.csv'])

    dyskinesiaresults = table(patnamelist,Ventricle_dyskinetic,FW_dyskinetic,...
        SW_dyskinetic,RVOT_dyskinetic,'VariableNames',...
       {'Patients','RV dyskinesia (%)','FW dyskinesia (%)','SW dyskinesia (%)','RVOT dyskinesia (%)'});
    writetable(dyskinesiaresults,[resultspath,studytype{studytype_indx},'/Figure3_results/','dyskinesia_results.csv'])
