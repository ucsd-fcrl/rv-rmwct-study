function [kinetic_pw,kinetic_nw,dyskinetic_pw,dyskinetic_nw,meanMW, kineticPW_ind, kineticNW_ind, dyskineticPW_ind, dyskineticNW_ind]...
    = categorizeMW(MW_CT,RS_CT_array,vol,datapath,patient,poi)
%%%Goal%%% 
% Perform RV functional categorization on selected points for a given RV segment. 
%%%Inputs%%% 
% 1. MW_CT =  regional myocardial work for each point
% 2. RS_CT_array = regional strain (RS) over time for each point
% 3. vol = volume over time
% 4. patient = patient label (e.g. rTOF1)
% 5. poi = label for region of interest we're working on (RV, FW, SW, or RVOT)
%%%Outputs%%% 
% 1. kinetic_pw = extent of the RV segment that's kinetic-productive
% 2. kinetic_nw = extent of the RV segment that's kinetic-unproductive
% 3. dyskinetic_pw = extent of the RV segment that's dyskinetic-productive
% 4. dyskinetic_nw = extent of the RV segment that's dyskinetic-unproductive
% 5. meanMW = mean myocardial work calculation
% 6. kineticPW_ind = index of points labeled kinetic-productive
% 7. kineticNW_ind = index of points labeled kinetic-unproductive
% 8. dyskineticPW_ind = index of points labeled dyskinetic-productive
% 9. dyskineticNW_ind = index of points labeled dyskinetic-unproductive

%load in the framepts for the whole RV surface
RVframepts = readmatrix([datapath,'/RV_framepts/',patient,'_RV_framepts.csv']);
%load in points that make up the RV lids
includedpts_lid = readmatrix([datapath,'/lid_framepts/',patient,'_lid_framepts.csv']);
%load in the points labeled at the region of interest
poi_framepts = readmatrix([datapath,'/',poi,'_framepts/',patient,'_',poi,'_framepts.csv']);


%find volumetric end-systole
[~,ES_frame] = min(vol);
%First we want to know if there is any overlap between the lids and the RV
%segments:
%if we're analyzing the whole RV
if length(poi_framepts) == length(RVframepts)
    poi_framepts = 1:length(RVframepts);
    shared_points = intersect(includedpts_lid,poi_framepts);
    if isempty(shared_points) == 1 %if there are no shared points, we can ignore the lids
        ESRS = [RS_CT_array(:,(ES_frame - 1)) RS_CT_array(:,ES_frame) RS_CT_array(:,(ES_frame + 1))];
    else %if there are shared points, we need to find them and remove them
        [~,~,shared_ind] = intersect(includedpts_lid,poi_framepts);
        ESRS = [RS_CT_array(:,(ES_frame - 1)) RS_CT_array(:,ES_frame) RS_CT_array(:,(ES_frame + 1))];
        ESRS(shared_ind,:) = [];
        MW_CT(shared_ind) = [];

    end
%if we're analyzing RV segments 
else
    RS_CT_array = RS_CT_array(poi_framepts,:);
    MW_CT = MW_CT(poi_framepts);
    shared_points = intersect(includedpts_lid,poi_framepts);
    if isempty(shared_points) == 1 %if there are no shared points, we can ignore the lids
        ESRS = [RS_CT_array(:,(ES_frame - 1)) RS_CT_array(:,ES_frame) RS_CT_array(:,(ES_frame + 1))];
    else %if there are shared points, we need to find them and remove them
        [~,~,shared_ind] = intersect(includedpts_lid,poi_framepts);
        ESRS = [RS_CT_array(:,(ES_frame - 1)) RS_CT_array(:,ES_frame) RS_CT_array(:,(ES_frame + 1))];
        ESRS(shared_ind,:) = [];
        MW_CT(shared_ind) = [];
    end
end
meanMW = mean(MW_CT,1);
kinetic_ind_es = find(ESRS(:,1) < -0.1 | ESRS(:,2) < -0.1 | ESRS(:,3) < -0.1);
dyskinetic_ind_es = find(ESRS(:,1) >= -0.1 & ESRS(:,2) >= -0.1 & ESRS(:,3) >= -0.1);

%identify kinetic patches performing productive work and unproductive work
kineticPW_ind = find(MW_CT(kinetic_ind_es) > 0);
kineticNW_ind = find(MW_CT(kinetic_ind_es) <= 0);
%identify dyskinetic patches performing productive work and unproductive work
dyskineticPW_ind = find(MW_CT(dyskinetic_ind_es) > 0);
dyskineticNW_ind = find(MW_CT(dyskinetic_ind_es) <= 0);

%calculate the % of the RV surface that falls into each category
tot = length(MW_CT); %total # patches
kinetic_pw = 100.*(numel(kineticPW_ind)./tot); % extent segment that's kinetic-productive
kinetic_nw = 100.*(numel(kineticNW_ind)./tot); % extent segment that's kinetic-unproductive
dyskinetic_pw = 100.*(numel(dyskineticPW_ind)./tot); % extent segment that's dyskinetic-productive
dyskinetic_nw = 100.*(numel(dyskineticNW_ind)./tot); % extent segment that's dyskinetic-unproductive


end