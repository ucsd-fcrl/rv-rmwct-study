function [MW_CT] = calculateMWCT(RS_CT_array,RVpressure,CT_timing_array)
%%%Goal%%%
% Calculate regional myocardial work as the integral of the RV
% pressure-RV regional strain relationship.

%%%Inputs%%%
% 1. RS_CT_array = regional strain (RS) over time for each point. Each row is
% a point on the RV. Each column is the strain achieved at each time frame
% of the cardiac cycle with respect to the end-diastolic frame.
% 2. RVpressure = digitized RV pressure waveform acquired from right heart
% catheterization. column 1 is time, displayed as % of the RR interval.
% column 2 is RV pressure.
% 3. CT_timing_array = time in the cardiac cycle each stack of 3D CTs is
%acquired. Displayed as % of the RR interval

%%%Outputs%%%
%1. Calculated MW

%remove unacquired frames
CTtiming = CT_timing_array(~isnan(CT_timing_array)); 
[unique_time, unique_time_index, ~] = unique(RVpressure(:,1));
    unique_pressure = RVpressure(unique_time_index,2);
    %Fit the waveform to the CT timing data
    RR_interval = zeros(1,length(CTtiming));
    for i = 1:length(CTtiming)
        [~,RR_interval(i)] = min(abs(unique_time - CTtiming(i)));
    end
    RR_pressure_simp = unique_pressure(RR_interval)'; 
    MW_CT = zeros(length(RS_CT_array),1);
    for i = 1:length(RS_CT_array)
        MW_CT(i) = -trapz(RS_CT_array(i,:),RR_pressure_simp,2);
    end

end