function [patnamelist] = generate_patient_name_column(TOFgroup,CTEPHgroup,HFgroup)
patnamelist = strings(sum([length(TOFgroup) length(CTEPHgroup) length(HFgroup)]),1);
    for j = 1:length(patnamelist)

        if j <= length(TOFgroup)
            patnamelist(j) = ['rTOF patient ', num2str(j)];
        elseif j > length(TOFgroup) && j <= sum([length(TOFgroup) length(CTEPHgroup)])
            patnamelist(j) = ['CTEPH patient ',num2str(j-length(TOFgroup))];
        else
        %elseif q < sum([length(TOFgroup) length(CTEPHgroup)])
            patnamelist(j) = ['HF patient ',num2str(j-sum([length(TOFgroup) length(CTEPHgroup)]))];
            
        end

    end

end