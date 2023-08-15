%MWCT agreement between the original dataset and a second analysis on a subset of the study cohort 

clear; clc

study_type_indx = 1;
study_type = [{'Intraobserver'},{'Interobserver'}];
resultspath_study1 = '../results/';
resultspath_study2 = ['../results/',study_type{study_type_indx},' Study/'];

%%% Load in the second dataset %%%
RVperformance2 = readmatrix([resultspath_study2,'RVfunctional_categories_results.csv']);
dyskin2 = readmatrix([resultspath_study2,'dyskinesia_results.csv']);
meanMW2 = readmatrix([resultspath_study2,'mean_MW_results.csv']);
unprod2 = readmatrix([resultspath_study2,'unproductive_work_results.csv']);

%%% Load in the orginial dataset of the patients included in the second
%dataset %%%
RVperformance1 = readmatrix([resultspath_study1,'Table2_Figure2_results/RVfunctional_categories_results.csv']);
RVperformance1 = RVperformance1([1,3,4,7,10,12,14,16,17,20,21,24,27,30,32,34],:);
dyskin1 = readmatrix([resultspath_study1,'Figure3_results/dyskinesia_results.csv']);
dyskin1 = dyskin1([1,3,4,7,10,12,14,16,17,20,21,24,27,30,32,34],:);
meanMW1 = readmatrix([resultspath_study1,'Figure3_results/mean_MW_results.csv']);
meanMW1 = meanMW1([1,3,4,7,10,12,14,16,17,20,21,24,27,30,32,34],:);
unprod1 = readmatrix([resultspath_study1,'Figure3_results/unproductive_work_results.csv']);
unprod1 = unprod1([1,3,4,7,10,12,14,16,17,20,21,24,27,30,32,34],:);

%% Calculate bias

%Mean MW
meanMWbias = calculateObserverBias(meanMW1(:,2:end),meanMW2(:,2:end));

% %Dyskinesia
dyskinbias = calculateObserverBias(dyskin1(:,2:end),dyskin2(:,2:end));

% %Unproductive Work
unprodbias = calculateObserverBias(unprod1(:,2:end),unprod2(:,2:end));

%% Intraclass correlation coefficient (ICC) 
% two-way mixed-effects, absolute agreement, single rater/measurement
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4913118/pdf/main.pdf
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6645485/pdf/pone.0219854.pdf

% mean MW
meanMWICC = calculateICCtable(meanMW1(:,2:end),meanMW2(:,2:end));

% %Dyskinesia
dyskinICC = calculateICCtable(dyskin1(:,2:end),dyskin2(:,2:end));

% %Unproductive Work
unprodICC = calculateICCtable(unprod1(:,2:end),unprod2(:,2:end));


%% %% Bland Altman Plots for Whole RV MWCT Measurements
title = 'Whole RV Mean MW_C_T Agreement';
xmin = 0;xmax = 18;ymin = -4.5;ymax = 4.5;
[fig_meanMWRV] = makeBlandAltmanPlot(meanMW1(:,2),meanMW2(:,2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);

title = 'Whole RV %Dyskinesia Agreement';
xmin = 0;xmax = 100;ymin = -15;ymax = 15;
[fig_dyskinRV] = makeBlandAltmanPlot(dyskin1(:,2),dyskin2(:,2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);

title = 'Whole RV %Unproductive Work Agreement';
xmin = 0;xmax = 100;ymin = -15;ymax = 15;
[fig_unprodRV] = makeBlandAltmanPlot(unprod1(:,2),unprod2(:,2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);


%% %% Bland Altman Plots for Segmental RV MWCT Measurements

segment = [{'Free Wall'};{'Septal Wall'};{'RVOT'}];
for i = 1:3
%mean MWCT
title = [segment{i}, ' mean MW_C_T'];
xmin = 0; xmax = 18;ymin = -5.5; ymax = 4.8;
[fig_meanMWseg] = makeBlandAltmanPlot(meanMW1(:,i+2),meanMW2(:,i+2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);

% %Dyskinesia
title = [segment{i}, ' %Dyskinesia'];
xmin = -1; xmax = 100; ymin = -30; ymax = 60;
[fig_dyskinseg] = makeBlandAltmanPlot(dyskin1(:,i+2),dyskin2(:,i+2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);

% %Unproductive Work
title = [segment{i}, ' %Unproductive Work'];
xmin = 0; xmax = 45; ymin = -20; ymax = 50;
[fig_unprodseg] = makeBlandAltmanPlot(unprod1(:,i+2),unprod2(:,i+2),xmin,xmax,...
    ymin,ymax,title,study_type{study_type_indx},1,0);
end


