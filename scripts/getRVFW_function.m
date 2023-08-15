function [RS_CT,MW_CT] = getRVFW_function(datapath,patnames,i)

%%%Goal%%%
% Isolate the RSCT and MWCT measurements for just the RV free wall (FW)
% points.

%%%Inputs%%%
% 1. datapath = file path that holds the data
% 2. patnames = patient name
% 3. i = patient index

%%%Outputs%%%
% 1. RS_CT = regional strain measurements for the RV FW points
% 2. MW_CT = regional myocardial work (MW) measurements for the FW FW points

 %load in RSCT data
    RS_CT = readmatrix([datapath,'/RSCT_data/',patnames{i},'_RSCT.csv']);

    %load in MWCT data
    MW_CT = readmatrix([datapath,'/MWCT_data/',patnames{i},'_MWCT.csv']);
    MW_CT = MW_CT(:,2);
   
    %get RSCT and MWCT of the RV FW
    FWframepts = readmatrix([datapath,'/FW_framepts/',patnames{i},'_FW_framepts.csv']);
    lid_framepts = readmatrix([datapath,'/lid_framepts/',patnames{i},'_lid_framepts.csv']);

    RS_CT = RS_CT(FWframepts,:);
    MW_CT = MW_CT(FWframepts,:);

    %check to see if there are any points that were labeled both FW and
    %part of the valve plane (lid)
    shared_points = intersect(lid_framepts,FWframepts);
    if isempty(shared_points) == 1 %if there are no shared points, we can ignore the lids
    else %if there are shared points, we need to find them and remove them from our FW RSCT and MWCT
        [~,~,shared_ind] = intersect(lid_framepts,FWframepts);
        RS_CT(shared_ind,:) = [];
        MW_CT(shared_ind,:) = [];
    end

end