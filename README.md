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
3. "results" holds performance categorization results and patient demographic data. Results calculated using this repo are saved to the "results" folder.

### Data provided


### Calculating myocardial work
explain all the data needed to do that, mention that MWCT data is already provided but you can calculate it yourself

### Analyzing RV performance based on work and strain
describe what the RV performance script does. what does the whole RV analysis do and how is it different than the segmental analysis?
mention that some of the whole rv data is included in the segmental rv results (RV mean MW, % unproductive work, %dyskinesia)

### Additional scripts
The statistics calculated for this paper are provided in script xx.m
the script where figure 3 was created is also provided. this script also holds the correlation tests between the extent of impairment (%dyskinesia/%unproductive work) and global function

