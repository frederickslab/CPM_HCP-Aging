% fxn to collect parameter scores (y)

function [pt,y] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name)

behavioralData_path = '/data23/mri_group/an_data/HCP-A2.0/behavioralData/';

pt = pt_list(1:n_pt,:);
opts = detectImportOptions(strcat(behavioralData_path, param_txt_filename));
opts.DataLines = 3;
opts.VariableNamesLine = 1;
data = readtable(strcat(behavioralData_path, param_txt_filename),opts,'InputFormat','MM/dd/uuuu');
y = NaN(length(pt),1);
for i = 1:length(pt)
    y(i) = data{strcmp(data.src_subject_id, pt(i)),param_score_col_name}; % see if this gets caught with src_subject_id; it hopefully shouldn't
end

end