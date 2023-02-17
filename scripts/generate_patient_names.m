function [patnamelist] = generate_patient_names(TOFgroup,CTEPHgroup,HFgroup,flag)


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

end
end