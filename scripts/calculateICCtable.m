function [ICCtable] = calculateICCtable(read1,read2)
%%%Goal%%%
% Calculate the intraclass correlation coefficient (ICC) and 95% confidence 
% interval (CI) between two readers for a given MWCT measurement.

%%%Inputs%%%
% 1. read1 = measurements made by reader 1, the initial study.
% 2. read2 = measurement made by reader 2, either the intraobserver or the
% interobserver.

%%%Outputs%%%
% 1. ICCtable = table displaying the ICC, CI, and p value for a given
% MWCT measurement for the whole RV, free wall (FW), septal wall (SW), and
% RV outflow tract (RVOT). 


ICC_col = zeros(4,size(read1,2));
alpha = 0.05;
null = 0;
for col = 1:size(read1,2)
    data = [read1(:,col),read2(:,col)];
    [r, LB, UB, ~, ~, ~, pval] = ICC(data, 'A-1', alpha, null);
    ICC_col(:,col) = [r;LB;UB;pval];

end

%Segment = ["whole RV","Free Wall","Septal Wall"]
ICCcalculation = ["ICC";"5th percentile";"95th percentile"; "p value"];
RV = ICC_col(:,1);
FW = ICC_col(:,2);
SW = ICC_col(:,3);
RVOT = ICC_col(:,4);

ICCtable =  table(ICCcalculation,RV,FW,SW,RVOT);