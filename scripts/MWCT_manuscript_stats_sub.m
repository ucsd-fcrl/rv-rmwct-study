%Kruskal-Wallis test performed on each parameter. Post-hoc analysis was
%performed when p<0.05.

clear; clc

%Start in any subfolder of this repo
addpath(genpath('../scripts'))
addpath(genpath('../results'))
%cd('../results/');
resultspath = cd('../results/');


%% Demographic stats
%load patient history table
hx = readtable([resultspath,'/Table1_results/patient_history.csv']);

%cd('../scripts/');

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
    if arrhy(i) == "No"
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
    if pm(i) == "No"
        pace(i) = 1;
    else
        pace(i) = 2;
    end
end
results_pm = data_analysis(pace(1:8),pace(9:16),pace(17:end));

%nyha fc
fc = table2array(hx(:,13)); 
results_fc = data_analysis(fc(1:8),fc(9:16),fc(17:end));

%AFib status
af = table2array(hx(:,16));
af = string(af);
afib = zeros(length(af),1);
for i = 1:length(af)
    if af(i) == "No"
        afib(i) = 1;
    else
        afib(i) = 2;
    end
end
results_af = data_analysis(afib(1:8),afib(9:16),afib(17:end));

%PR severity
pr = table2array(hx(:,17));
pr = string(pr);
pulmregurg = zeros(length(pr),1);
for i = 1:length(pr)
    if pr(i) == "Trace"
        pulmregurg(i) = 1;
    elseif pr(i) == "Mild"
        pulmregurg(i) = 2;
    elseif pr(i) == "Moderate"
        pulmregurg(i) = 3;
    elseif pr(i) == "Severe"
        pulmregurg(i) = 4;
    elseif pr(i) == "Mild/Moderate"
        pulmregurg(i) = 2;
    elseif pr(i) == "None"
        pulmregurg(i) = 0;
    end
end
results_pr = data_analysis(pulmregurg(1:8),pulmregurg(9:16),pulmregurg(17:end));

%TR severity
tr = table2array(hx(:,18));
tr = string(tr);
triregurg = zeros(length(tr),1);
for i = 1:length(tr)
    if tr(i) == "Trace"
        triregurg(i) = 1;
    elseif tr(i) == "Mild"
        triregurg(i) = 2;
    elseif tr(i) == "Moderate"
        triregurg(i) = 3;
    elseif tr(i) == "Severe"
        triregurg(i) = 4;
    elseif tr(i) == "Mild/Moderate"
        triregurg(i) = 2;
    elseif tr(i) == "None"
        triregurg(i) = 0;
    end
end
results_tr = data_analysis(triregurg(1:8),triregurg(9:16),triregurg(17:end));

%% CT measurements
ct_data = readmatrix([resultspath,'/Table1_results/ct_measurements.csv']);
%RV end-diastolic volume index
edvi = ct_data(:,2); 
results_edvi = data_analysis(edvi(1:8),edvi(9:16),edvi(17:end));

%RV stroke volume index
svi = ct_data(:,3);
results_svi = data_analysis(svi(1:8),svi(9:16),svi(17:end));

%RVEF
ef = ct_data(:,4);
results_ef = data_analysis(ef(1:8),ef(9:16),ef(17:end));

%CT HR
hr_ct = ct_data(:,5);
results_hr_ct = data_analysis(hr_ct(1:8),hr_ct(9:16),hr_ct(17:end));

%% RHC measurements
rhc = readmatrix([resultspath,'/Table1_results/rhc_measurements.csv']);
%heart rate
hr = rhc(:,2);
results_hr = data_analysis(hr(1:8),hr(9:16),hr(17:end));
%cardiac output
co = rhc(:,3);
results_co = data_analysis(co(1:8),co(9:16),co(17:end));
%cardiac index
ci = rhc(:,4);
results_ci = data_analysis(ci(1:8),ci(9:16),ci(17:end));
%mean pulmonary partery pressure
mpap = rhc(:,5);
results_mpap = data_analysis(mpap(1:8),mpap(9:16),mpap(17:end));
%right atrial pressure
rap = rhc(:,6);
results_rap = data_analysis(rap(1:8),rap(9:16),rap(17:end));
%pulmonary capillary wedge pressure
pcwp = rhc(:,7);
results_pcwp = data_analysis(pcwp(1:8),pcwp(9:16),pcwp(17:end));
%pulmonary vascular resistance
pvr = rhc(:,8);
results_pvr = data_analysis(pvr(1:8),pvr(9:16),pvr(17:end));

%% Whole RV stats
RVperformance = readmatrix([resultspath,'/Table2_figure2_results/RVfunctional_categories_results.csv']);

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
meanMW = readmatrix([resultspath,'/Figure3_results/mean_MW_results.csv']);

%mean MW analysis in rTOF cohort
meanMW_tof = meanMW(1:8,2:end);
results_meanMW_tof = segmental_data_analysis(meanMW_tof(:,1),meanMW_tof(:,2),meanMW_tof(:,3),meanMW_tof(:,4));

%mean MW analysis in CTEPH cohort
meanMW_cteph = meanMW(9:16,2:end);
results_meanMW_cteph = segmental_data_analysis(meanMW_cteph(:,1),meanMW_cteph(:,2),meanMW_cteph(:,3),meanMW_cteph(:,4));

%mean MW analysis in HF cohort
meanMW_hf = meanMW(17:end,2:end);
results_meanMW_hf = segmental_data_analysis(meanMW_hf(:,1),meanMW_hf(:,2),meanMW_hf(:,3),meanMW_hf(:,4));

%mean MW analysis of the whole RV
meanMW_RV = meanMW(:,2);
results_meanMW_RV = data_analysis(meanMW_RV(1:8),meanMW_RV(9:16),meanMW_RV(17:end));

%mean MW analysis of the free wall
meanMW_FW = meanMW(:,3);
results_meanMW_FW = data_analysis(meanMW_FW(1:8),meanMW_FW(9:16),meanMW_FW(17:end));

%mean MW analysis of the septal wall
meanMW_SW = meanMW(:,4);
results_meanMW_SW = data_analysis(meanMW_SW(1:8),meanMW_SW(9:16),meanMW_SW(17:end));

%mean MW analysis of the RVOT
meanMW_RVOT = meanMW(:,5);
results_meanMW_RVOT = data_analysis(meanMW_RVOT(1:8),meanMW_RVOT(9:16),meanMW_RVOT(17:end));

%%%Unproudctive work%%%
unprod_work = readmatrix([resultspath,'/Figure3_results/unproductive_work_results.csv']);

%unproductive work analysis in rTOF cohort
unrprod_tof = unprod_work(1:8,2:end);
results_unprod_tof = segmental_data_analysis(unrprod_tof(:,1),unrprod_tof(:,2),unrprod_tof(:,3),unrprod_tof(:,4));

%unproductive work analysis in CTEPH cohort
unrprod_cteph = unprod_work(9:16,2:end);
results_unprod_cteph = segmental_data_analysis(unrprod_cteph(:,1),unrprod_cteph(:,2),unrprod_cteph(:,3),unrprod_cteph(:,4));

%unproductive work analysis in HF cohort
unrprod_hf = unprod_work(17:end,2:end);
results_unprod_hf = segmental_data_analysis(unrprod_hf(:,1),unrprod_hf(:,2),unrprod_hf(:,3),unrprod_hf(:,4));

%unproductive work analysis of the whole RV
unprod_RV = unprod_work(:,2);
results_unprod_RV = data_analysis(unprod_RV(1:8),unprod_RV(9:16),unprod_RV(17:end));

%unproductive work analysis of the free wall
unprod_FW = unprod_work(:,3);
results_unprod_FW = data_analysis(unprod_FW(1:8),unprod_FW(9:16),unprod_FW(17:end));

%unproductive work analysis of the septal wall
unprod_SW = unprod_work(:,4);
results_unprod_SW = data_analysis(unprod_SW(1:8),unprod_SW(9:16),unprod_SW(17:end));

%unproductive work analysis of the RVOT
unprod_RVOT = unprod_work(:,5);
results_unprod_RVOT = data_analysis(unprod_RVOT(1:8),unprod_RVOT(9:16),unprod_RVOT(17:end));

%%%Dyskinesia%%%
dyskin = readmatrix([resultspath,'/Figure3_results/dyskinesia_results.csv']);

%dyskinesia analysis in rTOF cohort
dyskin_tof = dyskin(1:8,2:end);
results_dyskin_tof = segmental_data_analysis(dyskin_tof(:,1),dyskin_tof(:,2),dyskin_tof(:,3),dyskin_tof(:,4));

%dyskinesia analysis in CTEPH cohort
dyskin_cteph = dyskin(9:16,2:end);
results_dyskin_cteph = segmental_data_analysis(dyskin_cteph(:,1),dyskin_cteph(:,2),dyskin_cteph(:,3),dyskin_cteph(:,4));

%dyskinesia analysis in HF cohort
dyskin_hf = dyskin(17:end,2:end);
results_dyskin_hf = segmental_data_analysis(dyskin_hf(:,1),dyskin_hf(:,2),dyskin_hf(:,3),dyskin_hf(:,4));

%dyskinesia analysis of the whole RV
dyskin_RV = dyskin(:,2);
results_dyskin_RV = data_analysis(dyskin_RV(1:8),dyskin_RV(9:16),dyskin_RV(17:end));

%dyskinesia analysis of the free wall
dyskin_FW = dyskin(:,3);
results_dyskin_FW = data_analysis(dyskin_FW(1:8),dyskin_FW(9:16),dyskin_FW(17:end));

%dyskinesia analysis of the septal wall
dyskin_SW = dyskin(:,4);
results_dyskin_SW = data_analysis(dyskin_SW(1:8),dyskin_SW(9:16),dyskin_SW(17:end));

%dyskinesia analysis of the RVOT
dyskin_RVOT = dyskin(:,5);
results_dyskin_RVOT = data_analysis(dyskin_RVOT(1:8),dyskin_RVOT(9:16),dyskin_RVOT(17:end));