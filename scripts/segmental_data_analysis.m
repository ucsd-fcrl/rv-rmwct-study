function [result_vector] = segmental_data_analysis(group1,group2,group3,group4)
%%%Goal%%%
%Perform Kriuskal-Wallis analysis on data and post-hoc analysis when
%necessary. This analysis is for segmental RV datasets; statistical analysis is performed across the RV segments (free wall, septal wall, and RVOT).
% Whole RV data is an input, but only to calculate median and interquartile
% ranges of the whole RV data. It is not included in statistical analysis.
%%%Input%%%
%Group 1: Whole RV data
%Group 2: Free wall data
%Group 3: Septal wall data
%Group 4: RVOT data
%%%Output%%%
%Median (val1a, val2a, val3a, val4a) values of each group
%Q1: (val1b, val2b, val3b, val4b) values
%Q3: (val1c, val2c, val3c, val4c) values
%comp1: p-value of Kruskal-Wallis
%p-vals: p-values between groups from post-hoc analysis

%Find median and interquartile ranges of each group
val1a=nanmedian(group1);
val1b=prctile(group1,25);
val1c=prctile(group1,75);

val2a=nanmedian(group2);
val2b=prctile(group2,25);
val2c=prctile(group2,75);

val3a=nanmedian(group3);
val3b=prctile(group3,25);
val3c=prctile(group3,75);

val4a=nanmedian(group4);
val4b=prctile(group4,25);
val4c=prctile(group4,75);

% Do a non-parametric comparison
if numel(find(~isnan(group2)))*numel(find(~isnan(group3)))*numel(find(~isnan(group4))) > 0
    for i = 1:sum([length(group2),length(group3),length(group4)])
        if i <= length(find(~isnan(group2)))
            grp_vec{i} = 'FW';
        elseif i > length(group2) && i <= sum([length(group2),length(group3)])
            grp_vec{i} = 'SW';
        else
            grp_vec{i} = 'RVOT';
        end
    end

    gen_vec=[group2; group3; group4];
    [comp1,~,stats]=kruskalwallis(gen_vec,grp_vec);

    if comp1<0.05
        c=multcompare(stats);
        pair_c=c(:,6)<0.05;
        p_vals=c(:,6)';
    else
        pair_c=zeros(3,1);
        p_vals=ones(3,1)';
    end


    result_vector=[val1a val1b val1c val2a val2b val2c val3a val3b val3c val4a val4b val4c comp1 pair_c' p_vals];
end