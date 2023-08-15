# Evaluation of regional right ventricular performance with myocardial work
### **Author: Amanda Craine**

Will fill in paper details associated with this repo after submission/publication.

## Description
We developed a method to estimate regional RV myocardial work as the area of the RV pressure-regional strain loop. In this study, RV pressure was obtained from right heart catheterization reports. Regional strain was estimated by tracking regional deformation of the RV endocardial surface from cardiac cineCT derived volumes (1). This method (RS<sub>CT</sub>) has been previously validated (2), is reproducible (3), and agrees with magnetic resonance-based metrics of myocardial strain (4,5). RS<sub>CT</sub> has also previously been applied to the RV of adult tetralogy of Fallot patients (6).  

We combine our regional myocardial work measurement (MW<sub>CT</sub>) with RS<sub>CT</sub> to develop patient-specific profiles of regional RV function in three clinical cohorts: adult repaired tetraolgy of Fallot (rTOF), chronic thromboembolic pulmonary hypertension (CTEPH), and left-sided heart failure (HF). This repo includes 1) the calculation of myocardial work, 2) the categorization of RV performance based on work and strain, and 3) the analysis of RV performance across the whole RV and specific RV segments, such as the free wall, the septal wall, and RV outflow tract. Additionally, we include agreement between our CT derived measurements of RV free wall function and echocardiography derived measurements, and intra- and inter-observer variability of MW<sub>CT</sub> measurements in the RV and RV segments.

## User Guideline
### Environment Setup
All scripts and data files needed for RV performance analysis are provided. There are three folders in this repo:
1. "data" holds the data provided, 
2. "scripts" holds analysis scripts and necessary functions
3. "results" holds performance categorization results and patient demographic data
    * results are organized into subfolders based on how they are displayed in the manuscript

### Data provided
Here is a list of data provided to calculate myocardial work and analyze RV performance:
1. CT_time_frames: the time each stack of CT images was collected over the cardiac cycle, reported as a percent of the R-R interval
2. RV_volumes: volume of the RV bloodpool over time
3. RV_pressure: RV pressure waveform for one cardiac cycle, reported as pressure with respect to percent of the R-R interval
4. RSCT_data: regional strain, reported as the regional deformation with respect to percent of the R-R interval
5. MWCT_data: regional myocardial work, reported as the areas of the pressure-regional strain loop
6. RV_framepts: points that make up the 3D volume of the RV, reported as x, y, and z coordinates
7. FW_framepts: RV_framepts labeled free wall, reported as an index of RV_framepts positioned in the free wall space
8. RVOT_framepts: RV_framepts labeled RV outflow tract, reported as an index of RV_framepts positioned in the RVOT space 
9. SW_framepts: RV_framepts labeled septal wall, reported as an index of RV_framepts positioned in the septal wall space
10. lid_framepts: RV_framepts labeled "lids", which includes the tricuspid and pulmonary valve planes. Reported as an index of RV_framepts positioned in the lids space
11. Echo_strain_data: RV strain acquired with speckle-tracking echocardiography and analyzed in Epsilon EchoInsight, reported as segmental deformations with respect to the R-R interval
12. Intraobserver Study: containins all the RV RS<sub>CT</sub>, MW<sub>CT</sub>, and RV point information acquired by the intraobserver.
13. Interobserver Study: containins all the RV RS<sub>CT</sub>, MW<sub>CT</sub>, and RV point information acquired by the interobserver.

Patient data is anonymized. Data belonging to each patient is labeled by their disease type and a number, ex. rTOF1

### Calculating myocardial work
Myocardial work is calculated in ./scripts/MWCT_calculations.m. 
Required data:
1. CT_time_frames
2. RV_pressure
3. RSCT_data

We compute regional myocardial work as the area of the RV pressure-regional strain loop with the function ./scripts/calculateMWCT.m.  

First, the RV pressure waveform is simplified to inlcude only the pressure values acquired at times closest to the CT timing data. This simplification allows the pressure and RS<sub>CT</sub> data to be aligned in time. Then, MW<sub>CT</sub> is computed as the integral of the RS<sub>CT</sub> and simplified pressure data. 

MW<sub>CT</sub> can be calculated for the intraobserver and interobserver datasets in this script as well.

Note: A MW<sub>CT</sub> dataset is provided in this repo. Calculating MW<sub>CT</sub> yourself will overwrite the provided MW<sub>CT</sub> data. 

### Analyzing RV performance based on work and strain
RV performance is categorized in ./scripts/MWCT_RVperformance_analysis.m. Regional RV performance is organzied into 4 different categories with the function ./scripts/categorizeMWCT.m. The categories are based on regional work and strain values. Please see the Methods section of the paper for details on each category.
Required data:
1. RV_volumes
2. RSCT_data
3. MWCT_data
4. RV_framepts
5. lid_framepts

Segmental RV analysis also requires the framepts of the free wall, septal wall, and RVOT.

Whole RV analysis categorizes all RV_framepts. Points labeled as "lid" are removed. Segmental RV analysis categorizes the framepts of each segment of interest. The framepts for each segment are compared to the lid framepts. Any shared points are removed.

Results of whole RV analysis include the percent of the RV that falls into each category as well as the Dyskinesia-Unproductive Overlap (Dice coefficient). Results of segmental RV analysis include the average MW<sub>CT</sub> in each segment, the percent of unproductive work in each segment, and the percent of dyskinesia in each segment. Note that the segmental RV results also include the whole RV.

Whole and segmental RV performance of the intraobserver and interobserver data can also be evaluated in this script. 

### Agreement between CT and echocardiography derived RV free wall function
Agreement of RV FW function between imaging modalities is calculated in ./scripts/MWCT_manuscript_fig4.m. RV FW function is calculated and organized in ./scripts/CompareCTEchoStrain.m
Required data: 
1. CT_time_frames
2. RV_pressure
3. RSCT_data
4. MWCT_data
5. FW_framepts
6. lid_framepts
7. Echo_strain_data

Agreement is calculated with the Pearson correlation and Bland-Altman analysis. This script generates scatter plots and Bland-Altman plots comparing CT and echo derived RV FW strain (Figure 4 A-B) and MW (Figure 4C-D).

### Additional scripts
1. The statistics calculated for this paper are provided in ./scripts/MWCT_manuscript_stats_sub.m
2. Figure 3 in the paper was generated with ./scripts/MWCT_manuscript_fig3.m 
      * This script also computes the correlation between the extent of work and strain impairment (% dyskinesia and % unproductive work) and global function
3. Intra-and inter-observer variability analysis is conducted in .scripts/MWCT_intraobserver_variability_study.m

### Additional guidelines
Please see the comments in the scripts.

Please contact acraine@ucsd.edu or fcontijoch@ucsd.edu for any further questions.

### References
1. PMID: 22342945
2. PMID: 31824981
3. PMID: 34541443
4. PMID: 26706935
5. PMID: 35751864
6. PMID: 28970037
