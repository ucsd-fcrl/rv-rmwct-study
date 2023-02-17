clear all
clc

%%% Figure 3A: Segmental mean MWCT across populations
%load in the segmental work analysis data
load("TOF_regional_work_table.mat");
TOF_segments = table2array(work_data_TOF);

load("CTEPH_regional_work_table.mat");
CTEPH_segments = table2array(work_data_CTEPH);


load("LVAD_regional_work_table.mat");
LVAD_segments = table2array(work_data_LVAD);


%%%Boxplot displaying the range of Mean MW across the whole RV, free wall, septal wall, and RVOT for each population
figure; set(gcf,'Position',[0 0 3000 1000])
subplot_tight(2,3,1,[0.08 0.08]);
boxplot([TOF_segments(:,1:4)],'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel('Mean Pressure-Strain Area');axis('square');
title('rTOF')
text(2.5,17.8,'p < 0.01')
line([2 4],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([4 4],[16.6 16.1],'Color','black')

subplot_tight(2,3,2,[0.08 0.08]);
boxplot([CTEPH_segments(:,1:4)],'Labels', {'RV','FW','SW','RVOT'},'whisker',1000); axis('square');
ylim([-5 19]); ylabel('Mean Pressure-Strain Area'); %title('CTEPH');axis('square');
title('CTEPH')
text(1.95,17.8,'p = 0.01')
line([2 3],[16.5 16.5],'Color','black'); line([2 2],[16.6 16.1],'Color','black'); line([3 3],[16.6 16.1],'Color','black')

subplot_tight(2,3,3,[0.08 0.08]);
boxplot([LVAD_segments(:,1:4)],'Labels', {'RV', 'FW','SW','RVOT'},'whisker',1000); axis('square');
title('HF')
ylim([-5 19]); ylabel('Mean Pressure-Strain Area'); axis('square');

%%% Figure 3B: Extent of RV unproductive work across populations
%%% Boxplot displaying the ranges of the extent of unproductive work across
%%% the RV for each population
g = strings(sum([length(TOF_segments) length(CTEPH_segments) length(LVAD_segments)]),1);
for i = 1:length(g)
    if i <= length(TOF_segments)        
        g{i} = 'TOF';
    elseif i >= length(TOF_segments) && i <= sum([length(TOF_segments) length(CTEPH_segments)])
      
        g{i} = 'CTEPH';
    else 
        g{i} = 'HF';
    end
end

subplot_tight(2,3,4, [0.08 0.08]);
boxplot([TOF_segments(:,5); CTEPH_segments(:,5); LVAD_segments(:,5)],g,'whisker',1000); axis('square');
ylabel('% Unproductive work'); 

%%% Figure 3C: Agreement between extent of impaired MWCT and RSCT with RVEF
%%%Scatter plots displying correlation between global impairment via MWCT
%%%analysis and global function

%load in dempgraphic data to extact RVEF info
T = readtable('/Users/amandacraine/Documents/ContijochLab/MW_CT_manuscript/Data Sheets/MWCT manuscript Demographic Table.csv');
T(27,:) = []; T(18,:) = [];

%load in the strain data
load("TOF_regional_strain_table.mat");
TOF_RSsegments = table2array(strain_data_TOF);

load("CTEPH_regional_strain_table.mat");
CTEPH_RSsegments = table2array(strain_data_CTEPH);

load("LVAD_regional_strain_table.mat");
LVAD_RSsegments = table2array(strain_data_LVAD);

%TOF
tofEF = table2array(T(1:8,27));
tof_dyskin = TOF_RSsegments(:,2);
tof_negwork = TOF_segments(:,5);

%CTEPH
ctephEF = table2array(T(9:17,27)); ctephEF(4) = [];
cteph_dyskin = CTEPH_RSsegments(:,2);
cteph_negwork = CTEPH_segments(:,5);

%LVAD
lvadEF = table2array(T(18:end,27)); 
lvadEF(13) = []; lvadEF(5) = []; lvadEF(2) = [];
lvad_dyskin = LVAD_RSsegments(:,2);
lvad_negwork = LVAD_segments(:,5);

%%% extent of dyskinesia vs RVEF
y1 = [tof_dyskin; cteph_dyskin; lvad_dyskin]; % extent dyskinesia list
x1 = [tofEF; ctephEF; lvadEF]; %Rvef list
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
plot(tofEF, tof_dyskin,'b.'); hold on; plot(ctephEF,cteph_dyskin,'.r'); hold on; plot(lvadEF,lvad_dyskin,'.','Color',[0.9290 0.6940 0.1250]); hold on
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
y2 = [tof_negwork; cteph_negwork; lvad_negwork];
x2 = [tofEF; ctephEF; lvadEF];
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
plot(tofEF, tof_negwork,'b.'); hold on; plot(ctephEF,cteph_negwork,'.r'); hold on; plot(lvadEF,lvad_negwork,'.','Color',[0.9290 0.6940 0.1250]); hold on
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