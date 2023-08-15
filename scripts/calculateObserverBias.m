function [bias_summary] = calculateObserverBias(read1, read2)
%%%Goal%%%
% Calculate the bias between two readers for a given MWCT measurement.

%%%Inputs%%%
% 1. read1 = measurements made by reader 1, the initial study.
% 2. read2 = measurement made by reader 2, either the intraobserver or the
% interobserver.

%%%Outputs%%%
% 1. bias_summary = median bais, the 2.5th percentile of bias, and the 97.5th
% percentile of bias.

bias = read1 - read2;
median_bias = median(bias);
q1_bias = prctile(bias,2.5);
q4_bias = prctile(bias,97.5);

bias_calculation = ["Median Bias";"2.5th percentile";"97.5th percentile"];


RV = [median_bias(:,1); q1_bias(:,1); q4_bias(:,1)];
FW = [median_bias(:,2); q1_bias(:,2); q4_bias(:,2)];
SW = [median_bias(:,3); q1_bias(:,3); q4_bias(:,3)];
RVOT = [median_bias(:,4); q1_bias(:,4); q4_bias(:,4)];

bias_summary =  table(bias_calculation,RV,FW,SW,RVOT);

end