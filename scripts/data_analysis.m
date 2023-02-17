function [result_vector] = data_analysis(group1,group2,group3)
%%%Goal%%%
%Perform Kriuskal-Wallis analysis on data and post-hoc analysis when
%necessary
%%%Input%%%
%Group 1: rTOF group data
%Group 2: CTEPH group data
%Group 3: HF group data
%%%Output%%%
%Median (val1a, val2a, val3a) values of each group
%Q1: (val1b, val2b, val3b) values
%Q3: (val1c, val2c, val3c) values
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

% Do a non-parametric comparison
if numel(find(~isnan(group1)))*numel(find(~isnan(group2)))*numel(find(~isnan(group3))) > 0
    for i = 1:sum([length(group1),length(group2),length(group3)])
        if i <= length(find(~isnan(group1)))
            grp_vec{i} = 'TOF';
        elseif i > length(group1) && i <= sum([length(group1),length(group2)])
            grp_vec{i} = 'CTEPH';
        else
            grp_vec{i} = 'HF';
        end
    end

    gen_vec=[group1; group2; group3];
    [comp1,~,stats]=kruskalwallis(gen_vec,grp_vec);

    if comp1<0.05
        c=multcompare(stats);
        pair_c=c(:,6)<0.05;
        p_vals=c(:,6)';
    else
        pair_c=zeros(3,1);
        p_vals=ones(3,1)';
    end


    result_vector=[val1a val1b val1c val2a val2b val2c val3a val3b val3c comp1 pair_c' p_vals];
end