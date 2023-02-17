function [segment_MW_CT,segment_RS_CT,poi_framepts] = isolate_poi(foldpath,poi,flag,poi2,patient,all_framepts, MW_CT, RS_CT_array)

%%%Goal%%%
%Isolate points within a region of interest on the RV (free wall, septal wall, RVOT)
%Obtain work and strain values for the region of interest

%%%Input%%%
% 1. all_framepts: points that make up the whole RV
%segment_framepts: points that make up a region of interest
% 2. MW_CT: myocardial work for each point
% 3. RS_CT_array = regional strain (RS) over time for each point. Each row is
% a point on the RV. Each column is the strain achieved at each time frame
% of the cardiac cycle with respect to the end-diastolic frame.

%%%Output%%%
% 1. segment_MW_CT: myocardial work for each point in the region of interest
% 2. segment_RS_CT: regional strain for each point in the region of
% interest
%table2array(readtable([home,'/RV_framepts/',flag1,patnames{patient},'_framepts.csv']));
%Load in the framepts for the region of interest
segment_framepts = table2array(readtable([foldpath,poi,flag,patient,'_',poi2,'_framepts.csv']));
%segment_framepts_table = table(FWframepts(:,1),FWframepts(:,2),FWframepts(:,3),'VariableNames',{'x coordinate','y coordinate','z coordinate'});
%writetable(segment_framepts_table,[savepath,poi,'_framepts/',flag2,patnames{patient},'_',poi,'_framepts.csv'])

% Find points on the RV that are near the points defined as the region of
% interest, preset to include any points that are within a radius of four
% of segment points
radius = 4; 
poi_framepts = [];
for k = 1:length(all_framepts)
    %for every point in the RV, calculate its distance to every point in
    %the segment
    dist2seg = sqrt(sum((segment_framepts - all_framepts(k,:)).^2,2));
    if sum(dist2seg < radius) > 0
        poi_framepts = [poi_framepts, k];
    end
end


%%%% Test that the region is correct %%%%
% figure; 
% plot3(all_framepts(:,1),all_framepts(:,2),all_framepts(:,3),'r.')
% hold on
% plot3(all_framepts(shared_framepts,1),all_framepts(shared_framepts,2),all_framepts(shared_framepts,3),'bo')
% pause
% close all
%%%%%%%%%%%%%%%%%%%%%

%Isolate work and strain from the points of interest
segment_MW_CT = MW_CT(poi_framepts);
segment_RS_CT = RS_CT_array(poi_framepts,:);

end(framepts,triangulation,PSAvsRS,RS_CT_array,z,patientname,poi,path)
ExpandedRadiusFlag = 0;
%%%Goal%%% 
% Isolate points labeled or near a region of interest. Region of interest could be the free wall, septal wall, or RVOT
%%%Inputs%%% 
% framepts = original points
% triangulation = triangulation of og ventricle
% PSAvsRS = holds MWCT for each point
% RS_CT_array = regional strain for each point over the cardiac cycle
% z = total number of points
% patientname should be 'CVCxxxxxxxxxxFW'
% poi is either the SW, FW, or RVOT
%%%Outputs%%%
% poiPSA = MWCT for the points in the region of interest
% poiRS = RSCT over time for the points in the region of interest
% includedtri = triangulations included in the region of interest
% includedpts = points included in the region of interest


% Isolate points within the region of interest
results = dir([path,poi,'_analysis/',patientname,'/MAT/MeshPoints*']);
load([results(1).folder,'/',results(1).name])
framepts_poi = mesh_pts{1}.vertex;

% Find vertices near the points included in the region of
% interest, preset to a radius of four points
radius = 4; 
includedpts = [];
for k = 1:length(framepts)
    dist2fw = sqrt(sum((framepts_poi - framepts(k,:)).^2,2));
    if sum(dist2fw < radius) > 0
        includedpts = [includedpts, k];
    end
end

%%%% FOR TESTING %%%%
% figure; 
% plot3(framepts(:,1),framepts(:,2),framepts(:,3),'r.')
% hold on
% plot3(framepts(includedpts,1),framepts(includedpts,2),framepts(includedpts,3),'bo')
% pause
% close all
%%%%%%%%%%%%%%%%%%%%%

% Find all triangles that include those points
includedtri = [];
for l = 1:length(includedpts)
    includedtri = [includedtri; find(sum(triangulation == includedpts(l),2))];
end
includedtri = unique(includedtri); 

%Add MW for FW and septal wall
%maybe add breakdown of the different categories too 

poiPSA = PSAvsRS(:,includedpts);
poiRS = RS_CT_array(includedpts,:);

end