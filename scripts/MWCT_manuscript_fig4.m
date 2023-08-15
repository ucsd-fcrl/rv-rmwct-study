%Generates Figure 4 plots

clear; clc

%Start in any subfolder of this repo
addpath(genpath('../results'))
addpath(genpath('../scripts'))
cd('../results/');
resultspath = cd('../results');

RS = readmatrix([resultspath,'/Figure4_results/RVFW_peak_strain_results.csv']);
peakCTstrain = RS(:,2);
peak_echo_strain = RS(:,3);


MW = readmatrix([resultspath,'/Figure4_results/RVFW_MW_results.csv']);
meanMWCT = MW(:,2);
MWecho = MW(:,3);

% Peak Strain Scatter Plot
figure; set(gcf,'Position',[50, 200, 1700, 580])
%Strain Scatter Plot
subplot(1,2,1)
plot(peak_echo_strain(1:6),peakCTstrain(1:6),'b.'); hold on;
plot(peak_echo_strain(7:13),peakCTstrain(7:13),'r.'); hold on;
plot(peak_echo_strain(14:30),peakCTstrain(14:30),'.','Color',[0.9290 0.6940 0.1250]); hold on;
ylim([-0.3 0.05]);
yticks([-0.3 -0.2 -0.1 0])
xlim([-0.3 0.05])
[rRS,p] = corr(peak_echo_strain,peakCTstrain,'type','Pearson'); %if outlier is removed, r = 0.63, r^2 = 0.40, p < 0.01
fit = polyfit(peak_echo_strain,peakCTstrain,1);
yfit = polyval(fit,peak_echo_strain);
plot(peak_echo_strain,yfit,'k')
text(0.04,0.032,['r^2 = ',num2str(rRS.^2,'%.2f')],'HorizontalAlignment','right')
if p < 0.01
    text(0.04,0.002,'p < 0.01','HorizontalAlignment','right')
else
    text(0.04,0.002,['p = ',num2str(p,'%.2f')],'HorizontalAlignment','right')
end
if fit(2) < 0
    text(0.04,-0.026,['y = ',num2str(fit(1),'%.2f'),'x - ',num2str(abs(fit(2)),'%.2f')],'HorizontalAlignment','right') 
else
    text(0.04,-0.026,['y = ',num2str(fit(1),'%.2f'),'x + ',num2str(fit(2),'%.2f')],'HorizontalAlignment','right')
end
    legend('rTOF','CTEPH','HF','Location','Northwest')
axis('square')
ylabel('Peak RVFW RS_C_T'); xlabel('Peak RVFW Echo Longitudinal Strain')


%Peak Strain Bland-Altman
subplot(1,2,2)
meanstrain = mean(RS(:,2:3),2);
diffstrain = peak_echo_strain- peakCTstrain;
std2 = 1.96.*std(diffstrain);
% if outlier removed, mean bias is 0.07, LoA is -0.03 - 0.16

plot(meanstrain(1:6),diffstrain(1:6),'b.'); hold on;
plot(meanstrain(7:13),diffstrain(7:13),'r.'); hold on;
plot(meanstrain(14:end),diffstrain(14:end),'.','Color',[0.9290 0.6940 0.1250]); hold on;
yline(mean(diffstrain),'b')
yline(mean(diffstrain)+std2,'.r'); hold on;
yline(mean(diffstrain)-std2,'.r')

text(0, 0.18,['1.96SD = ',num2str(mean(diffstrain)+std2,'%.2f')],'HorizontalAlignment','right','Color','r')
text(0, 0.09,['Mean = ',num2str(mean(diffstrain),'%.2f')],'HorizontalAlignment','right','Color','b')
text(0, -0.045,['-1.96SD = ',num2str(mean(diffstrain)-std2,'%.2f')],'HorizontalAlignment','right','Color','r')

xlim([-0.25 0.005]);
ylim([-0.1 0.27])
%title('Bland-Altman Plot of RV FW Peak Strain')
xlabel('Average of Peak RVFW RS_C_T and Echo Strain')
ylabel('RVFW Echo Strain - RS_C_T')

sgtitle('Agreement between CT and Echo based RV Free Wall Peak Strain')

set(findall(gcf,'-property','MarkerSize'),'MarkerSize',45)
set(findall(gcf,'-property','FontSize'),'FontSize',33)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)

figure; set(gcf,'Position',[50, 200, 1700, 580])
%MW Scatter Plot
subplot(1,2,1)
plot(MWecho(1:6),meanMWCT(1:6),'b.'); hold on;
plot(MWecho(7:13),meanMWCT(7:13),'r.'); hold on;
plot(MWecho(14:end),meanMWCT(14:end),'.','Color',[0.9290 0.6940 0.1250]); hold on;
ylim([-1 17]); xlim([-2 8])
[rMW,p] = corr(MWecho,meanMWCT,'type','Pearson'); %if outlier is removed, r = 0.66, r^2 = 0.44, p < 0.01
fit = polyfit(MWecho,meanMWCT,1);
yfit = polyval(fit,MWecho);
plot(MWecho,yfit,'k')
text(-1.4,15.7,['r^2 = ',num2str(rMW.^2,'%.2f')])
if p < 0.01
    text(-1.4,14.26,'p < 0.01')
else
    text(-1.4,14.26,['p = ',num2str(p,'%.2f')])
end
if fit(2) < 0
    text(-1.4,12.82,['y = ',num2str(fit(1),'%.2f'),'x - ',num2str(abs(fit(2)),'%.2f')])
else
    text(-1.4,12.82,['y = ',num2str(fit(1),'%.2f'),'x + ',num2str(fit(2),'%.2f')])
end
ylabel('RVFW MW_C_T (mmHg)'); xlabel('RVFW Echo MW (mmHg)')
axis('square')


%MW Bland-Altman
subplot(1,2,2)
meanwork = mean(MW(:,2:3),2);
diffwork = MWecho- meanMWCT;
std2 = 1.96.*std(diffwork);

plot(meanwork(1:6),diffwork(1:6),'b.'); hold on;
plot(meanwork(7:13),diffwork(7:13),'r.'); hold on;
plot(meanwork(14:end),diffwork(14:end),'.','Color',[0.9290 0.6940 0.1250]); hold on;
yline(mean(diffwork),'b')
yline(mean(diffwork)+std2,'.r');hold on;
yline(mean(diffwork)-std2,'.r')

text(11.8, 3.31,['1.96SD = ',num2str(mean(diffwork)+std2,'%.2f')],'HorizontalAlignment','right','Color','r')
text(11.8, -1.32,['Mean = ',num2str(mean(diffwork),'%.2f')],'HorizontalAlignment','right','Color','b')
text(11.8, -5.95,['-1.96SD = ',num2str(mean(diffwork)-std2,'%.2f')],'HorizontalAlignment','right','Color','r')

xlim([0 12]);
ylim([-12 10]);
yticks([-10 -5 0 5])
xlabel('Average of RVFW MW_C_T and Echo MW')
ylabel('RVFW Echo MW - MW_C_T')

sgtitle('Agreement between CT and Echo based RV Free Wall MW')

set(findall(gcf,'-property','MarkerSize'),'MarkerSize',45)
set(findall(gcf,'-property','FontSize'),'FontSize',33)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)

%%
%%% Fisher r to z transformation %%%
% 2 = unproductive work vs RVEF
% 1 = dyskinesia vs RVEF 
z2 = atanh(rMW);
z1 = atanh(rRS);
n = numel(MWecho);
z = (z2 - z1)./sqrt((1./(n-3))+(1./(n-3)));
%p-value
p = (1-normcdf(abs(z),0,1))*2;

error2 = 1/(sqrt(numel(MWecho))-3);
error1 = 1/(sqrt(numel(MWecho))-3);

%%% confidence interval test %%%
alpha = 0.05;
ci_l = z - 1.96*error1;
ci_u = z + 1.96*error1;

r_l = tanh(ci_l);
r_u = tanh(ci_u);
