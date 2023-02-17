function [includedpts,includedtris,ExpandedRadiusFlag] = isolate_poi_lids(framepts,patientname,flag)
ExpandedRadiusFlag = 0;
%Goal: isolate points labeled and near the RA and PA to eliminate them from
%analysis
%Inputs:
% framepts = original points
% flag = labels which population we're analyzing
%Outputs: framepts and triangulations included in and adjacent to the RA and PA label



% Now isolate the RA and PA
results = dir(['/Users/amandacraine/Documents/ContijochLab/SQUEEZ_Analysis/',flag,'RA+PAs/',patientname,'/MAT/MeshPoints*']);
load([results(1).folder,'/',results(1).name])
frameptsRA = mesh_pts{1}.vertex;
load([results(2).folder,'/',results(2).name])
frameptsPA = mesh_pts{1}.vertex;

% Find vertices near the points defined as the RA or PA
radius = 4; 
includedpts = [];
for k = 1:length(framepts)
    dist2RA = sqrt(sum((frameptsRA - framepts(k,:)).^2,2));
    dist2RVOT = sqrt(sum((frameptsPA - framepts(k,:)).^2,2));
    if sum(dist2RA < radius) > 0 || sum(dist2RVOT < radius) > 0
        includedpts = [includedpts, k]; %index of included points i think from the original frame points?
    end
end


%%%% FOR TESTING %%%%
% figure; plot3(framepts(:,1),framepts(:,2),framepts(:,3),'r.')
% hold on
% plot3(framepts(includedpts,1),framepts(includedpts,2),framepts(includedpts,3),'bo')
% pause
% close all
%%%%%%%%%%%%%%%%%%%%%


end