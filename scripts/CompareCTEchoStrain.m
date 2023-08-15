% Performs agreement analysis between CT-based measurements of strain and
% MW and echocardiography-based measurements of strain and MW.

clear; clc

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
TOFpats = dir([datapath,'/Echo_strain_data/rTOF*']);
CTEPHpats = dir([datapath,'/Echo_strain_data/CTEPH*']);
HFpats = dir([datapath,'/Echo_strain_data/HF*']);

TOFpatnames = cell(length(TOFpats),1);
CTEPHpatnames = cell(length(CTEPHpats),1);
HFpatnames = cell(length(HFpats),1);
for i = 1:length(TOFpats)
    TOFpatnames{i} = TOFpats(i).name(1:5);
end

for i = 1:length(CTEPHpats)
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


meanCTstrain = cell(length(patnames),1);
peakCTstrain = zeros(length(patnames),1);
meanMWCT = zeros(length(patnames),1);
mean_echo_strain = cell(length(patnames),1);
peak_echo_strain = zeros(length(patnames),1);
MWecho = zeros(length(patnames),1);
echotime = cell(length(patnames),1);
patnamelist = cell(length(patnames),1);

for i = 1:length(patnames)
    pat_type = regexp(patnames(i),'[a-zA-Z]','Match');
    pat_num = regexp(patnames(i),'\d*','Match');
    disp(['Evaluating ',[pat_type{1}{:}] ,' patient ',pat_num{1}{:}])

    %get RV Free Wall RSCT
    [RS_CT,MW_CT] = getRVFW_function(datapath,patnames,i);

    %load in echo strain data
    echo_strain = readmatrix([datapath,'/Echo_strain_data/',patnames{i},'_RvAp4_strain.csv']);

    meanCTstrain{i} = mean(RS_CT);
    peakCTstrain(i) = min(meanCTstrain{i});
    meanMWCT(i) = mean(MW_CT);

    %calculate echo RV free wall strain
    mean_echo_strain{i} = mean(echo_strain(:,(2:4)),2); %average RV free wall strain
    peak_echo_strain(i) = min(mean_echo_strain{i});

    MWecho(i) = calculateMWecho(echo_strain,mean_echo_strain{i},datapath,patnames,i);

    patnamelist{i} = string([[pat_type{1}{:}] ,' patient ',pat_num{1}{:}]);

end
%write a table that saves strain results: one column is CT and one column
%is echo
RV_FW_peak_strain = table(patnamelist, peakCTstrain,peak_echo_strain,'VariableNames',...
       {'Patients','Peak RV FW CT strain','Peak RV FW Echo Strain'});
   writetable(RV_FW_peak_strain,[resultspath,'/Figure4_results/','RVFW_peak_strain_results.csv'])
%write a table that saves MW results
RV_FW_MW = table(patnamelist, meanMWCT,MWecho,'VariableNames',...
       {'Patients','Peak RV FW CT MW','Peak RV FW Echo MW'});
   writetable(RV_FW_MW,[resultspath,'/Figure4_results/','RVFW_MW_results.csv'])



