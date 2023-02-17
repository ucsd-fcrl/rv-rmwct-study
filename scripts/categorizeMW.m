function [kinetic_pw,kinetic_nw,dyskinetic_pw,dyskinetic_nw,meanMW, kineticPW_ind, kineticNW_ind, dyskineticPW_ind, dyskineticNW_ind]...
    = categorizeMW(MW_CT,RS_CT_array,vol,includedpts_lid,poi_framepts,RVframepts)
%%%Goal%%% 
% Perform RV functional categorization on selected points for a given RV segment. 
%%%Inputs%%% 
% 1. PSAvsRS holds MWCT for each point
% 2. RS_CT_array = regional strain (RS) over time for each point
% 3. vol = volume over time
%%%Outputs%%% 
% 1. kinetic_pw = extent of the RV segment that's kinetic-productive
% 2. kinetic_nw = extent of the RV segment that's kinetic-unproductive
% 3. dyskinetic_pw = extent of the RV segment that's dyskinetic-productive
% 4. dyskinetic_nw = extent of the RV segment that's dyskinetic-unproductive
% 5. kineticPW_ind = index of points labeled kinetic-productive
% 6. kineticNW_ind = index of points labeled kinetic-unproductive
% 7. dyskineticPW_ind = index of points labeled dyskinetic-productive
% 8. dyskineticNW_ind = index of points labeled dyskinetic-unproductive

%find volumetric end-systole
[~,ES_frame] = min(vol);
%First we want to know if there is any overlap between the lids and the RV
%segments:
if length(poi_framepts) == length(RVframepts)  %For analysis of the whole RV
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
else
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