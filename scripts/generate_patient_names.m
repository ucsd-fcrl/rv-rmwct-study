function [patnamelist] = generate_patient_names(TOFgroup,CTEPHgroup,HFgroup,flag)
%%%Goal%%%
% Writes a list of the patient names to load in patient data files. There
% are three options of patient lists based on what the list is needed for. 

%%%Inputs%%%
% TOFgroup = list of rTOF patients
% CTEPHgroup = list of CTEPH patients
% HFgroup = list of HF patients
% Flag 1 = to mimic the patient names in the data files in order to load
% data (ex. rTOF1)
% Flag 2 = a more formal patient list to save as a column in results tables
% (ex. rTOF patient 1)
% Flag 3 = a list without numbers, just identifies the disease type (ex. rTOF)

%%%Outputs%%%
% patnamelist = list of patients

if flag == 1 %to read in data files 
patnamelist = cell(sum([length(TOFgroup) length(CTEPHgroup) length(HFgroup)]),1);
    for j = 1:length(patnamelist)

        if j <= length(TOFgroup)
            patnamelist{j} = ['rTOF', num2str(j)];
        elseif j > length(TOFgroup) && j <= sum([length(TOFgroup) length(CTEPHgroup)])
            patnamelist{j} = ['CTEPH',num2str(j-length(TOFgroup))];
        else
            patnamelist{j} = ['HF',num2str(j-sum([length(TOFgroup) length(CTEPHgroup)]))];
            
        end

    end
elseif flag == 2 %to save results to tables
    patnamelist = strings(sum([length(TOFgroup) length(CTEPHgroup) length(HFgroup)]),1);
    for j = 1:length(patnamelist)

        if j <= length(TOFgroup)
            patnamelist{j} = ['rTOF patient ', num2str(j)];
        elseif j > length(TOFgroup) && j <= sum([length(TOFgroup) length(CTEPHgroup)])
            patnamelist{j} = ['CTEPH patient ',num2str(j-length(TOFgroup))];
        else
            patnamelist{j} = ['HF patient ',num2str(j-sum([length(TOFgroup) length(CTEPHgroup)]))];
            
        end

    end
elseif flag == 3 %to make a list of patient groups without numbers 
    patnamelist = strings(sum([length(TOFgroup) length(CTEPHgroup) length(HFgroup)]),1);
    for j = 1:length(patnamelist)

        if j <= length(TOFgroup)
            patnamelist(j) = 'rTOF';
        elseif j > length(TOFgroup) && j <= sum([length(TOFgroup) length(CTEPHgroup)])
            patnamelist(j) = 'CTEPH';
        else
            patnamelist(j) = 'HF';
            
        end

    end

elseif flag == 4 %to make a list of patient groups without numbers
    patnamelist = strings(sum([length(TOFgroup) length(CTEPHgroup) length(HFgroup)]),1);
    for j = 1:length(patnamelist)

        if j <= length(TOFgroup)
            name = TOFgroup(j).name;
            patnamelist(j) = erase(name,"_RSCT.csv");
        elseif j > length(TOFgroup) && j <= sum([length(TOFgroup) length(CTEPHgroup)])
            namecount = j-length(TOFgroup);
            name = CTEPHgroup(namecount).name;
            patnamelist(j) = erase(name,"_RSCT.csv");
        else
            namecount = j- sum([length(TOFgroup) length(CTEPHgroup)]);
            name = HFgroup(namecount).name;
            patnamelist(j) = erase(name,"_RSCT.csv");

        end
      
    end
    patnamelist(9:end) = [patnamelist(13:end); patnamelist(9:12)];

end
end