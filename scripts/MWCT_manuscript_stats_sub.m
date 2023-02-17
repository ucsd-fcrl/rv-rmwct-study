%Kruskal-Wallis test performed on each parameter. Post-hoc analysis was
%performed when p<0.05.

clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper';
cd(home)
savepath = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper/';

%% Demographic stats
%load patient history table
hx = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/Additional data files/Table1_data/patient_history.csv');

%sex
sex = table2array(hx(:,2));
sex = string(sex);
sexnum = zeros(length(sex),1);
for i = 1:length(sex)
    if sex(i) == 'F'
        sexnum(i) = 1;
    else
        sexnum(i) = 2;
    end
end
results_sex = data_analysis(sexnum(1:8),sexnum(9:16),sexnum(17:end));

%age
age = table2array(hx(:,3));
results_age = data_analysis(age(1:8),age(9:16),age(17:end));

%BMI
bmi = table2array(hx(:,4));
results_bmi = data_analysis(bmi(1:8),bmi(9:16),bmi(17:end));

%time
time = table2array(hx(:,10));
results_time = data_analysis(time(1:8),time(9:16),time(17:end));

%presence of conductance disorders
arrhy = table2array(hx(:,11));
arrhy = string(arrhy);
arr = zeros(length(arrhy),1);
for i = 1:length(arrhy)
    if arrhy(i) == 'No'
        arr(i) = 1;
    else
        arr(i) = 2;
    end
end
results_arrhy = data_analysis(arr(1:8),arr(9:16),arr(17:end));

%pacemaker status
pm = table2array(hx(:,12));
pm = string(pm);
pace = zeros(length(pm),1);
for i = 1:length(pm)
    if pm(i) == 'No'
        pace(i) = 1;
    else
        pace(i) = 2;
    end
end
results_pm = data_analysis(pace(1:8),pace(9:16),pace(17:end));

%nyha fc
fc = table2array(hx(:,13)); 
results_fc = data_analysis(fc(1:8),fc(9:16),fc(17:end));

%% CT measurements
ct_data = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/Additional data files/Table1_data/ct_measurements.csv');
%RV end-diastolic volume index
edvi = table2array(ct_data(:,2)); 
results_edvi = data_analysis(edvi(1:8),edvi(9:16),edvi(17:end));

%RV stroke volume index
svi = table2array(ct_data(:,3));
results_svi = data_analysis(svi(1:8),svi(9:16),svi(17:end));

%RVEF
ef = table2array(ct_data(:,4));
results_ef = data_analysis(ef(1:8),ef(9:16),ef(17:end));

%% RHC measurements
rhc = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/Additional data files/Table1_data/rhc_measurements.csv');
%heart rate
hr = table2array(rhc(:,2));
results_hr = data_analysis(hr(1:8),hr(9:16),hr(17:end));
%cardiac output
co = table2array(rhc(:,3));
results_co = data_analysis(co(1:8),co(9:16),co(17:end));
%cardiac index
ci = table2array(rhc(:,4));
results_ci = data_analysis(ci(1:8),ci(9:16),ci(17:end));
%mean pulmonary partery pressure
mpap = table2array(rhc(:,5));
results_mpap = data_analysis(mpap(1:8),mpap(9:16),mpap(17:end));
%right atrial pressure
rap = table2array(rhc(:,6));
results_rap = data_analysis(rap(1:8),rap(9:16),rap(17:end));
%pulmonary capillary wedge pressure
pcwp = table2array(rhc(:,7));
results_pcwp = data_analysis(pcwp(1:8),pcwp(9:16),pcwp(17:end));
%pulmonary vascular resistance
pvr = table2array(rhc(:,8));
results_pvr = data_analysis(pvr(1:8),pvr(9:16),pvr(17:end));

%% Whole RV stats
RVperformance = readmatrix([home,'/Table2_figure2_data/table2_figure2_data.csv']);

%Kinetic-productive RV
kin_pw = RVperformance(:,2);
results_kin_pw = data_analysis(kin_pw(1:8),kin_pw(9:16),kin_pw(17:end));

%Kinetic-unproductive RV
kin_nw = RVperformance(:,4);
results_kin_nw = data_analysis(kin_nw(1:8),kin_nw(9:16),kin_nw(17:end));

%Dyskinetic-productive RV
dyskin_pw = RVperformance(:,3);
results_dyskin_pw = data_analysis(dyskin_pw(1:8),dyskin_pw(9:16),dyskin_pw(17:end));

%Dysinetic-unproductive RV
dyskin_nw = RVperformance(:,5);
results_dyskin_nw = data_analysis(dyskin_nw(1:8),dyskin_nw(9:16),dyskin_nw(17:end));

%Dyskinesia_Unprodcutive Overlap
dice = RVperformance(:,6);
results_dice = data_analysis(dice(1:8),dice(9:16),dice(17:end));

%Discordant RV
discord = kin_nw + dyskin_pw;
results_discord = data_analysis(discord(1:8),discord(9:16),discord(17:end));


%% Segmental RV stats
% Here, statistical analysis is performed across the RV segments (free wall, septal wall, and RVOT). 
% We evaluate differences across RV segments in each clinical cohort, and we
% Evaluate differences in each RV segment across clinical cohorts.
% The median and IQR results for the whole RV data are calcuated, but are not included in the Kruskal-Wallis test.  

%%%Mean MW%%%
meanMW = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files/Figure3_data/mean_MW_results.csv');

%mean MW analysis in rTOF cohort
meanMW_tof = table2array(meanMW(1:8,2:end));
results_meanMW_tof = segmental_data_analysis(meanMW_tof(:,1),meanMW_tof(:,2),meanMW_tof(:,3),meanMW_tof(:,4));

%mean MW analysis in CTEPH cohort
meanMW_cteph = table2array(meanMW(9:16,2:end));
results_meanMW_cteph = segmental_data_analysis(meanMW_cteph(:,1),meanMW_cteph(:,2),meanMW_cteph(:,3),meanMW_cteph(:,4));

%mean MW analysis in HF cohort
meanMW_hf = table2array(meanMW(17:end,2:end));
results_meanMW_hf = segmental_data_analysis(meanMW_hf(:,1),meanMW_hf(:,2),meanMW_hf(:,3),meanMW_hf(:,4));

%mean MW analysis of the whole RV
meanMW_RV = table2array(meanMW(:,2));
results_meanMW_RV = data_analysis(meanMW_RV(1:8),meanMW_RV(9:16),meanMW_RV(17:end));

%mean MW analysis of the free wall
meanMW_FW = table2array(meanMW(:,3));
results_meanMW_FW = data_analysis(meanMW_FW(1:8),meanMW_FW(9:16),meanMW_FW(17:end));

%mean MW analysis of the septal wall
meanMW_SW = table2array(meanMW(:,4));
results_meanMW_SW = data_analysis(meanMW_SW(1:8),meanMW_SW(9:16),meanMW_SW(17:end));

%mean MW analysis of the RVOT
meanMW_RVOT = table2array(meanMW(:,5));
results_meanMW_RVOT = data_analysis(meanMW_RVOT(1:8),meanMW_RVOT(9:16),meanMW_RVOT(17:end));

%%%Unproudctive work%%%
unprod_work = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files/Figure3_data/unproductive_work_results.csv');

%unproductive work analysis in rTOF cohort
unrprod_tof = table2array(unprod_work(1:8,2:end));
results_unprod_tof = segmental_data_analysis(unrprod_tof(:,1),unrprod_tof(:,2),unrprod_tof(:,3),unrprod_tof(:,4));

%unproductive work analysis in CTEPH cohort
unrprod_cteph = table2array(unprod_work(9:16,2:end));
results_unprod_cteph = segmental_data_analysis(unrprod_cteph(:,1),unrprod_cteph(:,2),unrprod_cteph(:,3),unrprod_cteph(:,4));

%unproductive work analysis in HF cohort
unrprod_hf = table2array(unprod_work(17:end,2:end));
results_unprod_hf = segmental_data_analysis(unrprod_hf(:,1),unrprod_hf(:,2),unrprod_hf(:,3),unrprod_hf(:,4));

%unproductive work analysis of the whole RV
unprod_RV = table2array(unprod_work(:,2));
results_unprod_RV = data_analysis(unprod_RV(1:8),unprod_RV(9:16),unprod_RV(17:end));

%unproductive work analysis of the free wall
unprod_FW = table2array(unprod_work(:,3));
results_unprod_FW = data_analysis(unprod_FW(1:8),unprod_FW(9:16),unprod_FW(17:end));

%unproductive work analysis of the septal wall
unprod_SW = table2array(unprod_work(:,4));
results_unprod_SW = data_analysis(unprod_SW(1:8),unprod_SW(9:16),unprod_SW(17:end));

%unproductive work analysis of the RVOT
unprod_RVOT = table2array(unprod_work(:,5));
results_unprod_RVOT = data_analysis(unprod_RVOT(1:8),unprod_RVOT(9:16),unprod_RVOT(17:end));

%%%Dyskinesia%%%
dyskin = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/MWCT_manuscript_data_files/Figure3_data/dyskinesia_results.csv');

%dyskinesia analysis in rTOF cohort
dyskin_tof = table2array(dyskin(1:8,2:end));
results_dyskin_tof = segmental_data_analysis(dyskin_tof(:,1),dyskin_tof(:,2),dyskin_tof(:,3),dyskin_tof(:,4));

%dyskinesia analysis in CTEPH cohort
dyskin_cteph = table2array(dyskin(9:16,2:end));
results_dyskin_cteph = segmental_data_analysis(dyskin_cteph(:,1),dyskin_cteph(:,2),dyskin_cteph(:,3),dyskin_cteph(:,4));

%dyskinesia analysis in HF cohort
dyskin_hf = table2array(dyskin(17:end,2:end));
results_dyskin_hf = segmental_data_analysis(dyskin_hf(:,1),dyskin_hf(:,2),dyskin_hf(:,3),dyskin_hf(:,4));

%dyskinesia analysis of the whole RV
dyskin_RV = table2array(dyskin(:,2));
results_dyskin_RV = data_analysis(dyskin_RV(1:8),dyskin_RV(9:16),dyskin_RV(17:end));

%dyskinesia analysis of the free wall
dyskin_FW = table2array(dyskin(:,3));
results_dyskin_FW = data_analysis(dyskin_FW(1:8),dyskin_FW(9:16),dyskin_FW(17:end));

%dyskinesia analysis of the septal wall
dyskin_SW = table2array(dyskin(:,4));
results_dyskin_SW = data_analysis(dyskin_SW(1:8),dyskin_SW(9:16),dyskin_SW(17:end));

%dyskinesia analysis of the RVOT
dyskin_RVOT = table2array(dyskin(:,5));
results_dyskin_RVOT = data_analysis(dyskin_RVOT(1:8),dyskin_RVOT(9:16),dyskin_RVOT(17:end));