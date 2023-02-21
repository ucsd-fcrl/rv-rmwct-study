%Generates Figure 3 subplots

clear all
clc

home = '/Users/amandacraine/Documents/ContijochLab/repos/ac-MWCT-paper/';
cd(home)
addpath(genpath(home))

%%% Figure 3A: Segmental mean MWCT across populations
meanMW = readmatrix([home,'/results/Figure3_results/mean_MW_results.csv']);
TOF_meanMW = meanMW(1:8,2:end);
CTEPH_meanMW = meanMW(9:16,2:end);
HF_meanMW = meanMW(17:end,2:end);

unprod_work = readmatrix([home,'results/Figure3_results/unproductive_work_results.csv']);
TOF_unprod_work = unprod_work(1:8,2:end);
CTEPH_unprod_work = unprod_work(9:16,2:end);
HF_unprod_work = unprod_work(17:end,2:end);

%%%Boxplot displaying the range of Mean MW across the whole RV, free wall, septal wall, and RVOT for each population
figure; set(gcf,'Position',[0 0 3000 1000])
subplot_tight(2,3,1,[0.08 0.08]);
boxplot([TOF_meanMW],'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel('Mean Pressure-Strain Area');axis('square');
title('rTOF')
text(2.5,17.8,'p = 0.01')
line([2 4],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([4 4],[16.6 16.1],'Color','black')

subplot_tight(2,3,2,[0.08 0.08]);
boxplot([CTEPH_meanMW],'Labels', {'RV','FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel('Mean Pressure-Strain Area'); %title('CTEPH');axis('square');
title('CTEPH')
text(1.95,17.8,'p = 0.01')
line([2 3],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([3 3],[16.6 16.1],'Color','black')

subplot_tight(2,3,3,[0.08 0.08]);
boxplot([HF_meanMW],'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel('Mean Pressure-Strain Area');
title('HF')
text(2.95,17.8,'p = 0.03')
line([3 4],[16.5 16.5],'Color','black'); line([3 3],[16.6 16.1],'Color','black'); line([4 4],[16.6 16.1],'Color','black')

%%% Figure 3B: Extent of RV unproductive work across populations
%%% Boxplot displaying the ranges of the extent of unproductive work across
%%% the RV for each population
patnames = generate_patient_names(TOF_meanMW,CTEPH_meanMW,HF_meanMW,3);

subplot_tight(2,3,4, [0.08 0.08]);
boxplot([TOF_unprod_work(:,1); CTEPH_unprod_work(:,1); HF_unprod_work(:,1)],patnames,'whisker',1000); axis('square');
ylabel('% Unproductive work'); 

%%% Figure 3C: Agreement between extent of impaired MWCT and RSCT with RVEF
%%%Scatter plots displying correlation between global impairment via MWCT
%%%analysis and global function

%load in RVEF info
ct_data = readmatrix([home,'/results/Table1_results/ct_measurements.csv']);
TOFrvef = ct_data(1:8,4);
CTEPHrvef = ct_data(9:16,4);
HFrvef = ct_data(17:end,4);

%load in the strain data
dyskinesia = readmatrix([home,'results/Figure3_results/dyskinesia_results.csv']);
TOF_dyskinesia = dyskinesia(1:8,2:end);
CTEPH_dyskinesia = dyskinesia(9:16,2:end);
HF_dyskinesia = dyskinesia(17:end,2:end);

%%% extent of dyskinesia vs RVEF
y1 = [TOF_dyskinesia(:,1); CTEPH_dyskinesia(:,1); HF_dyskinesia(:,1)]; % extent dyskinesia list
x1 = [TOFrvef; CTEPHrvef; HFrvef]; %Rvef list
%find correlation coefficient between %dyskinesia and RVEF
[rtot1,ptot_corr1] = corrcoef(x1,y1);
%linear fit to the data
ptot1 = polyfit(x1,y1,1);
ftot1 = polyval(ptot1,linspace(0,100));
%display the r squared, p value, and linear fit equation to the
%correlation in the plot
r1 = ['r^2 = ', num2str(rtot1(1,2)^2,'%.2f')]; %r squared
if ptot_corr1(1,2) < 0.01
    p1 = ['p < 0.01'];
else
    p1 = ['p = ', num2str(ptot_corr1(1,2),'%.2e')]; %p value
end
y1 = ['y = ',num2str(ptot1(1),'%.2f'), '+ ', num2str(ptot1(2),'%.2f')]; %linear fit equation

subplot_tight(2,3,6,[0.08 0.08]);
plot(TOFrvef, TOF_dyskinesia(:,1),'b.'); hold on; plot(CTEPHrvef,CTEPH_dyskinesia(:,1),'.r'); hold on; plot(HFrvef,HF_dyskinesia(:,1),'.','Color',[0.9290 0.6940 0.1250]); hold on
plot(linspace(0,100),ftot1,'k');
text(29.5,94,y1)
text(48,85, r1)
text(49, 73.5, p1)
ylim([-10 100]); xlim([0 70])
ylabel('% Dyskinesia')
xlabel('RVEF (%)')
axis('square')

%
%%% extent of unproductive work vs rvef
y2 = [TOF_unprod_work(:,1); CTEPH_unprod_work(:,1); HF_unprod_work(:,1)];
x2 = [TOFrvef; CTEPHrvef; HFrvef];
[rtot2,ptot_corr2] = corrcoef(x2,y2);
ptot2 = polyfit(x2,y2,1);
ftot2 = polyval(ptot2,linspace(0,100));
r2 = ['r^2 = ', num2str(rtot2(1,2)^2,'%.2f')];
if ptot_corr2(1,2) < 0.01
    p2 = ['p < 0.01'];
else
    p2 = ['p = ', num2str(ptot_corr2(1,2),'%.2e')];
end
y2 = ['y = ',num2str(ptot2(1),'%.2f'), '+ ', num2str(ptot2(2),'%.2f')];

subplot_tight(2,3,5,[0.08 0.08]);
plot(TOFrvef, TOF_unprod_work(:,1),'b.'); hold on; plot(CTEPHrvef,CTEPH_unprod_work(:,1),'.r'); hold on; plot(HFrvef,HF_unprod_work(:,1),'.','Color',[0.9290 0.6940 0.1250]); hold on
plot(linspace(0,100),ftot2,'k');
text(29.5,47,y2)
text(48,42.5,r2)
text(49,36.75,p2)
 axis('square');
ylim([-5 50]);xlim([0 70])
ylabel('% Unproductive work')
xlabel('RVEF (%)')
legend('rTOF','CTEPH','HF','location','northwest');
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)
%%
%%% Fisher r to z transformation %%%
% 2 = unproductive work vs RVEF
% 1 = dyskinesia vs RVEF 
z2 = atanh(rtot2(1,2));
z1 = atanh(rtot1(1,2));
n = numel(x1);
z = (z2 - z1)./sqrt((1./(n-3))+(1./(n-3)));
%p-value
p = (1-normcdf(abs(z),0,1))*2;

error2 = 1/(sqrt(numel(x1))-3);
error1 = 1/(sqrt(numel(x1))-3);

%%% confidence interval test %%%
alpha = 0.05;
ci_l = z - 1.96*error1;
ci_u = z + 1.96*error1;

r_l = tanh(ci_l);
r_u = tanh(ci_u);