# Evaluation of regional right ventricular performance with myocardial work
### **Author: Amanda Craine**

Will fill in paper details associated with this repo after submission/publication.

## Description
We developed a method to estimate regional RV myocardial work as the area of the RV pressure-regional strain loop. This myocardial work measurement is combined with a previously validated, cardiac CT-based measurement of regional strain (if citing, which paper to cite?) to develop patient-specific profiles of regional RV function. This repo includes 1) the calculation of myocardial work, 2) the categorization of RV performance based on work and strain, and 3) the analysis of RV performance across the whole RV and specific RV segments, such as the free wall, the septal wall, and RV outflow tract.

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

Patient data is anonymized. Data belonging to each patient is labeled by their disease type and a number, ex. rTOF1

### Calculating myocardial work
Myocardial work is calculated in ./scripts/MWCT_calculations.m. 
Required data:
1. CT_time_frames
2. RV_pressure
3. RSCT_data

We compute regional myocardial work as the area of the RV pressure-regional strain loop with the function ./scripts/calculateMWCT.m.  

First, the RV pressure waveform is simplified to inlcude only the pressure values acquired at times closest to the CT timing data. This simplification allows the pressure and RSCT data to be aligned in time. Then, MWCT is computed as the integral of the RSCT and simplified pressure data. 

Note: A MWCT dataset is provided in this repo. Calculating MWCT yourself will overwrite the provided MWCT data. 

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

Results of whole RV analysis include the percent of the RV that falls into each category as well as the Dyskinesia-Unproductive Overlap (Dice coefficient). Results of segmental RV analysis include the average MWCT in each segment, the percent of unproductive work in each segment, and the percent of dyskinesia in each segment. Note that the segmental RV results also include the whole RV.


### Additional scripts
1. The statistics calculated for this paper are provided in ./scripts/MWCT_manuscript_stats_sub.m
2. Figure 3 in the paper was generated with ./scripts/MWCT_manuscript_fig3.m 
      * This script also computes the correlation between the extent of work and strain impairment (% dyskinesia and % unproductive work) and global function

### Additional guidelines
Please see the comments in the scripts.

Please contact acraine@eng.ucsd.edu or fcontijoch@ucsd.edu for any further questions.
