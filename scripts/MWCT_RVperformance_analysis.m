clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files';
cd(home)
%foldpath = '/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/';

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


foldpath = '/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/';

for q = 1:length(patnames) %analyzing patients who fit study inclusion criteria
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])
    [flag,flag1,flag2] = identify_pat_path(q,patnamelist); 

%     %%%Load in RV data points%%%
    framepts = table2array(readtable([home,'/RV_framepts/',flag1,patnames{patient},'_framepts.csv']));
    %remove the lids before saving
    includedpts_lid = isolate_poi_lids(framepts,patnames{patient},flag2);

    %%%Load in volume data%%%
    vol = table2array(readtable([home,'/RV_volumes/',flag1,patnames{patient},'_volumes.csv']));

    %%%Load in RSCT data%%%
    RS_CT_data = readtable([home,'/RSCT_data/',flag1,patnames{patient},'_RSCT.csv']);
    RS_CT_array = table2array(RS_CT_data(:,2:end));
   
    %%Load in MWCT data%%%
    MW_CT_data = readtable([home,'/MWCT_data/',flag1,patnames{patient},'_MWCT.csv']);
    MW_CT = table2array(MW_CT_data);

    %%%Whole RV analysis%%%
    [kinetic_pw,kinetic_nw,dyskinetic_pw,dyskinetic_nw,meanMW,...
        kineticPW_ind, kineticNW_ind,dyskineticPW_ind, dyskineticNW_ind] = categorizeMW(MW_CT,RS_CT_array,vol,includedpts_lid,framepts,framepts); 
   
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
%% Save whole RV performance analysis

   RVperformance = table(patnamelist, per_kin_pw, per_dyskin_pw,per_kin_nw, per_dyskin_nw,dice,'VariableNames',...
       {'Patients','Kinetic-Productive (%)', 'Dyskinetic-Productive (%)','Kinetic-Unproductive (%)', 'Dyskinetic-Unproductive (%)','Dyskinesia-Unproductive Overlap'});
   writetable(RVperformance,['/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files/Table2_Figure2_data/Table2_Figure2_data.csv'])

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

for q = 1:length(seg_patsIndx)
    patient = seg_patsIndx(q);
     disp(['analyzing patient ',patnames{patient},'...'])
    [flag,flag1,flag2] = identify_pat_path(q,patnamelist);

    %%%Load in volume data%%%
    vol = table2array(readtable([home,'/RV_volumes/',flag1,patnames{patient},'_volumes.csv']));

    %%%Load in RSCT data%%%
    RS_CT_data = readtable([home,'/RSCT_data/',flag1,patnames{patient},'_RSCT.csv']);
    RS_CT_array = table2array(RS_CT_data(:,2:end));

    %%Load in MWCT data%%%
    MW_CT_data = readtable([home,'/MWCT_data/',flag1,patnames{patient},'_MWCT.csv']);
    MW_CT = table2array(MW_CT_data);


    %%%Load in framepts for the whole RV and its segments to determine which points belong to each
    %%%segment
    RVframepts = table2array(readtable([home,'/RV_framepts/',flag1,patnames{patient},'_framepts.csv']));
    FWframepts = table2array(readtable([home,'/free_wall_framepts/',flag1,patnames{patient},'_FW_framepts.csv'])); 
    SWframepts = table2array(readtable([home,'/septal_wall_framepts/',flag1,patnames{patient},'_SW_framepts.csv'])); 
    RVOTframepts = table2array(readtable([home,'/RVOT_framepts/',flag1,patnames{patient},'_RVOT_framepts.csv'])); 
    includedpts_lid = isolate_poi_lids(RVframepts,patnames{patient},flag2);

       %RV framepts
%     results = dir([foldpath,flag,patnames{patient},'/MAT/ParWarp*']);
%     load([results(1).folder,'/',results(1).name])
%     framepts_all = Warp_Result{1}.transform.Y; %individual pts
%     triangulation = Warp_Result{1,1}.tem_face;
%     %remove the lids before saving
%     includedpts_lid = isolate_poi_lids(framepts_all,patnames{patient},flag2);
%     RVframepts(includedpts_lid,:) = [];

    %%%Isolate free wall function and categorize%%%
    [FW_MW_CT,FW_RS_CT,FWframepts] = isolate_poi(home,'/free_wall_framepts/',flag1,'FW',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [FW_kinetic_pw,FW_kinetic_nw,FW_dyskinetic_pw, FW_dyskinetic_nw,FW_meanMW] = categorizeMW(FW_MW_CT,FW_RS_CT,vol,includedpts_lid,FWframepts,RVframepts);

     %%%Isolate the septal wall%%%
      [SW_MW_CT,SW_RS_CT,SWframepts] = isolate_poi(home,'/septal_wall_framepts/',flag1,'SW',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [SW_kinetic_pw,SW_kinetic_nw,SW_dyskinetic_pw, SW_dyskinetic_nw,SW_meanMW] = categorizeMW(SW_MW_CT,SW_RS_CT,vol,includedpts_lid,SWframepts,RVframepts);

     %%%Isolate the RVOT%%%  
      [RVOT_MW_CT,RVOT_RS_CT,RVOTframepts] = isolate_poi(home,'/rvot_framepts/',flag1,'RVOT',patnames{patient},RVframepts, MW_CT, RS_CT_array);
    [RVOT_kinetic_pw,RVOT_kinetic_nw,RVOT_dyskinetic_pw, RVOT_dyskinetic_nw,RVOT_meanMW] = categorizeMW(RVOT_MW_CT,RVOT_RS_CT,vol,includedpts_lid,RVOTframepts,RVframepts);

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


%% Save segmental RV performance analysis 
%TOF
    work_data_TOF = table(VentricleMeanMW(1:8),FWMeanMW(1:8),SWMeanMW(1:8),RVOTMeanMW(1:8),Ventricle_negWork(1:8), FW_negWork(1:8), SW_negWork(1:8), RVOT_negWork(1:8),...
        'VariableNames',{'RV mean MW','FW mean MW','SW mean MW','RVOT mean MW','RV neg work','FW neg work','SW neg work','RVOT neg work'});
    save('TOF_regional_work_table.mat','work_data_TOF')
    strain_data_TOF = table(Ventricle_kinetic(1:8,:),Ventricle_dyskinetic(1:8,:),FW_kinetic(1:8,:),FW_dyskinetic(1:8,:),SW_kinetic(1:8,:),SW_dyskinetic(1:8,:),RVOT_kinetic(1:8,:),RVOT_dyskinetic(1:8,:),...
        'VariableNames',{'RV kinetic','RV dyskinetic','FW kinetic','FW dyskinetic','SW kinetic','SW dyskinetic','RVOT kinetic','RVOT dyskinetic'});
    save('TOF_regional_strain_table.mat','strain_data_TOF')
%CTEPH
    work_data_CTEPH = table(VentricleMeanMW(9:16),FWMeanMW(9:16),SWMeanMW(9:16),RVOTMeanMW(9:16),Ventricle_negWork(9:16), FW_negWork(9:16), SW_negWork(9:16), RVOT_negWork(9:16),...
        'VariableNames',{'RV mean MW','FW mean MW','SW mean MW','RVOT mean MW','RV neg work','FW neg work','SW neg work','RVOT neg work'});
    save('CTEPH_regional_work_table.mat','work_data_CTEPH')
    strain_data_CTEPH = table(Ventricle_kinetic(9:16,:),Ventricle_dyskinetic(9:16,:),FW_kinetic(9:16,:),FW_dyskinetic(9:16,:),SW_kinetic(9:16,:),SW_dyskinetic(9:16,:),RVOT_kinetic(9:16,:),RVOT_dyskinetic(9:16,:),...
        'VariableNames',{'RV kinetic','RV dyskinetic','FW kinetic','FW dyskinetic','SW kinetic','SW dyskinetic','RVOT kinetic','RVOT dyskinetic'});
    save('CTEPH_regional_strain_table.mat','strain_data_CTEPH')
%HF
      work_data_HF = table(VentricleMeanMW(17:end),FWMeanMW(17:end),SWMeanMW(17:end),RVOTMeanMW(17:end),Ventricle_negWork(17:end), FW_negWork(17:end), SW_negWork(17:end), RVOT_negWork(17:end),...
        'VariableNames',{'RV mean MW','FW mean MW','SW mean MW','RVOT mean MW','RV neg work','FW neg work','SW neg work','RVOT neg work'});
    save('HF_regional_work_table.mat','work_data_HF')
    strain_data_HF = table(Ventricle_kinetic(17:end,:),Ventricle_dyskinetic(17:end,:),FW_kinetic(17:end,:),FW_dyskinetic(17:end,:),SW_kinetic(17:end,:),SW_dyskinetic(17:end,:),RVOT_kinetic(17:end,:),RVOT_dyskinetic(17:end,:),...
        'VariableNames',{'RV kinetic','RV dyskinetic','FW kinetic','FW dyskinetic','SW kinetic','SW dyskinetic','RVOT kinetic','RVOT dyskinetic'});
    save('HF_regional_strain_table.mat','strain_data_HF')

%%
    savepath = ['/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files/'];

  meanMWresults = table(patnamelist,VentricleMeanMW,FWMeanMW,...
        SWMeanMW,RVOTMeanMW,'VariableNames',...
        {'Patients','RV mean MW','FW mean MW','SW mean MW','RVOT mean MW'});
   writetable(meanMWresults,[savepath,'Figure3_data/','mean_MW_results.csv'])

    negworkresults = table(patnamelist,Ventricle_negWork, FW_negWork,...
       SW_negWork, RVOT_negWork,'VariableNames',...
       {'Patients','RV unproductive work (%)','FW unproductive work (%)','SW unproductive work (%)','RVOT unproductive work (%)'});
   writetable(negworkresults,[savepath,'Figure3_data/','unproductive_work_results.csv'])

    dyskinesiaresults = table(patnamelist,Ventricle_dyskinetic,FW_dyskinetic,...
        SW_dyskinetic,RVOT_dyskinetic,'VariableNames',...
       {'Patients','RV dyskinesia (%)','FW dyskinesia (%)','SW dyskinesia (%)','RVOT dyskinesia (%)'});
    writetable(dyskinesiaresults,[savepath,'Figure3_data/','dyskinesia_results.csv'])
