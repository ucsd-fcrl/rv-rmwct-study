%Generates Figure 3 plots

clear; clc

%Start in any subfolder of this repo
addpath(genpath('../results'))
addpath(genpath('../scripts'))
cd('../results/');
resultspath = cd('../results');

%%% Figure 3A: Segmental mean MWCT across populations
meanMW = readmatrix([resultspath,'/Figure3_results/mean_MW_results.csv']);
TOF_meanMW = meanMW(1:8,2:end);
CTEPH_meanMW = meanMW(9:16,2:end);
HF_meanMW = meanMW(17:end,2:end);

unprod_work = readmatrix([resultspath,'/Figure3_results/unproductive_work_results.csv']);
TOF_unprod_work = unprod_work(1:8,2:end);
CTEPH_unprod_work = unprod_work(9:16,2:end);
HF_unprod_work = unprod_work(17:end,2:end);

%%%Boxplot displaying the range of Mean MW across the whole RV, free wall, septal wall, and RVOT for each population
figure; set(gcf,'Position',[500 400 760 900])
boxplot(TOF_meanMW,'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel({'Mean Pressure-Strain Area'; '(mmHg)'});axis('square');
title('rTOF')
text(2.5,17.8,'p = 0.01')
line([2 4],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([4 4],[16.6 16.1],'Color','black')
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)

figure; set(gcf,'Position',[500 400 760 900])
boxplot(CTEPH_meanMW,'Labels', {'RV','FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel({'Mean Pressure-Strain Area'; '(mmHg)'}); %title('CTEPH');axis('square');
title('CTEPH')
text(1.95,17.8,'p = 0.01')
line([2 3],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([3 3],[16.6 16.1],'Color','black')
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)

figure; set(gcf,'Position',[500 400 760 900])
boxplot(HF_meanMW,'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel({'Mean Pressure-Strain Area'; '(mmHg)'});
title('HF')
text(1.95,17.8,'p = 0.02')
line([2 3],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([3 3],[16.6 16.1],'Color','black')
text(2.95,15,'p < 0.01')
line([3 4],[13.7 13.7],'Color','black'); line([3 3],[13.8 13.3],'Color','black'); line([4 4],[13.8 13.3],'Color','black')
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)

%%% Figure 3B: Extent of RV unproductive work across populations
%%% Boxplot displaying the ranges of the extent of unproductive work across
%%% the RV for each population
patnames = generate_patient_names(TOF_meanMW,CTEPH_meanMW,HF_meanMW,3);

figure; set(gcf,'Position',[500 400 700 700])
boxplot([TOF_unprod_work(:,1); CTEPH_unprod_work(:,1); HF_unprod_work(:,1)],patnames,'whisker',1000); axis('square');
ylabel('% Unproductive work'); 
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)

%%% Figure 3C: Agreement between extent of impaired MWCT and RSCT with RVEF
%%%Scatter plots displying correlation between global impairment via MWCT
%%%analysis and global function

%load in RVEF info
ct_data = readmatrix([resultspath,'/Table1_results/ct_measurements.csv']);
TOFrvef = ct_data(1:8,4);
CTEPHrvef = ct_data(9:16,4);
HFrvef = ct_data(17:end,4);

%load in the strain data
dyskinesia = readmatrix([resultspath,'/Figure3_results/dyskinesia_results.csv']);
TOF_dyskinesia = dyskinesia(1:8,2:end);
CTEPH_dyskinesia = dyskinesia(9:16,2:end);
HF_dyskinesia = dyskinesia(17:end,2:end);

%%% extent of dyskinesia vs RVEF
y1 = [TOF_dyskinesia(:,1); CTEPH_dyskinesia(:,1); HF_dyskinesia(:,1)]; % extent dyskinesia list
x1 = [TOFrvef; CTEPHrvef; HFrvef]; %Rvef list
%find correlation coefficient between %dyskinesia and RVEF
[rtot1,ptot_corr1] = corr(x1,y1,'type','Spearman');
%linear fit to the data
ptot1 = polyfit(x1,y1,1);
ftot1 = polyval(ptot1,linspace(0,100));
%display the r squared, p value, and linear fit equation to the
%correlation in the plot
r1 = ['r^2 = ', num2str(rtot1^2,'%.2f')]; %r squared
if ptot_corr1 < 0.01
    p1 = 'p < 0.01';
else
    p1 = ['p = ', num2str(ptot_corr1,'%.2e')]; %p value
end
y1 = ['y = ',num2str(ptot1(1),'%.2f'), '+ ', num2str(ptot1(2),'%.2f')]; %linear fit equation

figure; set(gcf,'Position',[500 400 700 700])
plot(TOFrvef, TOF_dyskinesia(:,1),'b.'); hold on; plot(CTEPHrvef,CTEPH_dyskinesia(:,1),'.r'); hold on; plot(HFrvef,HF_dyskinesia(:,1),'.','Color',[0.9290 0.6940 0.1250]); hold on
plot(linspace(0,100),ftot1,'k'); hold on;
xline([40 49],'Color',[0.5 0.5 0.5]); hold on;
plot([40 49],[-10 -10],'Color',[0.5 0.5 0.5]); hold on;
plot([40 49],[99.9 99.9],'Color',[0.5 0.5 0.5]); hold on;
text(29.5,94,y1)
text(48,85, r1)
text(49, 73.5, p1)
ylim([-10 99.9]); xlim([0 70])
ylabel('% Dyskinesia')
xlabel('RVEF (%)')
axis('square')
set(findall(gcf,'-property','FontSize'),'FontSize',40)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',35)

%
%%% extent of unproductive work vs rvef
y2 = [TOF_unprod_work(:,1); CTEPH_unprod_work(:,1); HF_unprod_work(:,1)];
x2 = [TOFrvef; CTEPHrvef; HFrvef];
[rtot2,ptot_corr2] = corr(x2,y2,'type','Spearman');
ptot2 = polyfit(x2,y2,1);
ftot2 = polyval(ptot2,linspace(0,100));
r2 = ['r^2 = ', num2str(rtot2^2,'%.2f')];
if ptot_corr2 < 0.01
    p2 = 'p < 0.01';
else
    p2 = ['p = ', num2str(ptot_corr2,'%.2e')];
end
y2 = ['y = ',num2str(ptot2(1),'%.2f'), '+ ', num2str(ptot2(2),'%.2f')];

figure; set(gcf,'Position',[500 400 700 700])
plot(TOFrvef, TOF_unprod_work(:,1),'b.'); hold on; plot(CTEPHrvef,CTEPH_unprod_work(:,1),'.r'); hold on; plot(HFrvef,HF_unprod_work(:,1),'.','Color',[0.9290 0.6940 0.1250]); hold on
plot(linspace(0,100),ftot2,'k'); hold on;
xline([40 49],'Color',[0.5 0.5 0.5]); hold on;
plot([40 49],[-5 -5],'Color',[0.5 0.5 0.5]); hold on;
plot([40 49],[50 50],'Color',[0.5 0.5 0.5]); hold on;
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
z2 = atanh(rtot2);
z1 = atanh(rtot1);
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