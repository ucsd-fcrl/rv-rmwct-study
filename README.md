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
Myocardial work is calculated in <MWCT_calculations.m>. Required data:
1. CT_time_frames
2. RV_pressure
3. RSCT_data

Data is loaded in and MWCT is generated with the function calculateMWCT.m. We compute regional myocardial work as the area of the RV pressure-regional strain loop. 

First, the RV pressure waveform is simplified to inlcude only the pressure values acquired at times closest to the CT timing data. This simplification allows the pressure and RSCT data to be aligned in time. Then, MWCT is computed as the integral of the RSCT and simplified pressure data. 

### Analyzing RV performance based on work and strain
describe what the RV performance script does. what does the whole RV analysis do and how is it different than the segmental analysis?
mention that some of the whole rv data is included in the segmental rv results (RV mean MW, % unproductive work, %dyskinesia)

### Additional scripts
The statistics calculated for this paper are provided in script xx.m
the script where figure 3 was created is also provided. this script also holds the correlation tests between the extent of impairment (%dyskinesia/%unproductive work) and global function

