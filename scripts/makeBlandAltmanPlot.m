function [fig] = makeBlandAltmanPlot(data1,data2,xmin,xmax,ymin,ymax,titlename,study,legend_indx,normality)
%%%Goal%%%
% Generate Bland-Altman Plots for interobserver and interobserver analysis
% of MWCT measurements

%%%Inputs%%%
% 1. data1 = dataset from original study
% 2. data2 = dataset from secondary study, could be data from the 
% interobserver or intraobserver study
% 3. xmin = minimum x value on the plot
% 4. xmax = maximum x value on the plot
% 5. ymin = minimum y value on the plot
% 6. ymax = maximum y value on the plot
% 7. titlename = desired title for the plot, formatted as a string
% 8. study = study type, either interobserver or intraobserver, formatted
% as a string
% 9. legend_indx = binary. 1 for legend, 0 for no legend.
% 10. normality = normality index, binary. 1 for normal data, 0 for non
% normal data.

%%%Outputs%%%
%1. fig = final Bland Altman plot

fig = figure; set(gcf,'Position',[100, 200, 1000, 600])

mean_data = mean([data1,data2],2);
bias = data1 - data2;
if normality == 1
    mean_bias = mean(bias);
    q1_bias = mean_bias - 1.96*std(bias);
    q4_bias = 1.96*std(bias)+ mean_bias;
else
    mean_bias = median(bias);
    q1_bias = prctile(bias,2.5);
    q4_bias = prctile(bias,97.5);
end

plot(mean_data(1:4),bias(1:4),'b.'); hold on;
plot(mean_data(5:8),bias(5:8),'r.'); hold on;
plot(mean_data(9:end),bias(9:end),'.','Color',[0.9290 0.6940 0.1250]); hold on;
yline(mean_bias,'b'); hold on;
yline(q4_bias,'r');
yline(q1_bias,'r');

axis([xmin,xmax,ymin, ymax])

xtext = xmax - 0.01*(xmax-xmin);
ytext1 = mean_bias + 0.1*(mean_bias-ymin);
ytext2 = q4_bias + 0.08*(q4_bias - ymin);
ytext3 = q1_bias + 0.085*(ymax - q1_bias);

if normality == 1
    text(xtext,ytext1 ,['Mean = ', num2str(mean_bias,'%.2f')],'HorizontalAlignment','right','color','b')
    text(xtext,ytext2 ,['1.96\sigma = ', num2str(q4_bias,'%.2f')],'HorizontalAlignment','right','color','r')
    text(xtext,ytext3 ,['1.96\sigma = ', num2str(q1_bias,'%.2f')],'HorizontalAlignment','right','color','r')
else
    text(xtext,ytext1 ,['Median = ', num2str(mean_bias,'%.2f')],'HorizontalAlignment','right','color','b')
    text(xtext,ytext2 ,['97.5% = ', num2str(q4_bias,'%.2f')],'HorizontalAlignment','right','color','r')
    text(xtext,ytext3 ,['2.5% = ', num2str(q1_bias,'%.2f')],'HorizontalAlignment','right','color','r')
end

if legend_indx == 1
    legend('rTOF','CTEPH','HF','location','northwest')
else
    legend('off')
end
title(titlename)
xlabel(['Average of ',study,' Measurements'])
ylabel({'Difference between ';[study,' Measurements']})

set(findall(gcf,'-property','FontSize'),'FontSize',35)
set(findall(gcf,'-property','LineWidth'),'LineWidth',4)
set(findall(gcf,'-property','MarkerSize'),'MarkerSize',45)
end