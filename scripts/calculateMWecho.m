function [MWecho] = calculateMWecho(echo_strain,mean_echo_strain,datapath,patnames,i)

%%%Goal%%%
% Calculate myocardial work (MW) from echo based strain measurements and RV
% pressures.

%%%Inputs%%%
% 1. echo_strain = echo-based RV strain dataset
% 2. mean_echo_strain = mean RV strain measurement from echo
% 3. datapath = file path that holds the data
% 4. patnames = patient name
% 5. i = patient index

%%%Outputs%%%
% 1. MWecho = RV MW measurement acquired with echo strain data


%load in CT timings
CTtiming = readmatrix([datapath, '/CT_time_frames/CT_time_frames.csv']);
%remove cases with no imaging or poor imaging
CTtiming([3,8,10,15,17],:) = [];


CTtime = CTtiming(i,:);
CTtime = CTtime(~isnan(CTtime));
%identify pressure timings
RVpressure = readmatrix([datapath,'/RV_pressure/',patnames{i},'_RVpressure.csv']);
%select RV pressure points that align with CT acquisition timings
[unique_time, unique_time_index, ~] = unique(RVpressure(:,1)); %remove any duplicates
unique_pressure = RVpressure(unique_time_index, 2);
RR_int_pressure = zeros(1,length(CTtime));
for k = 1:length(CTtime)
    [~,RR_int_pressure(k)] = min(abs(unique_time - CTtime(k)));
end
RR_pressure = unique_pressure(RR_int_pressure)';



echotime = echo_strain(:,1); %timing of the R-R interval
%select echo strain points that align with CT acquisition timings
RRechotime = 100*(echotime./echotime(end));
RR_int_echo = zeros(1,length(CTtime));
for k = 1:length(CTtime)
    [~,RR_int_echo(k)] = min(abs(RRechotime - CTtime(k)));
end
%RV FW MW with echo
MWecho = -trapz(mean_echo_strain(RR_int_echo),RR_pressure);

end