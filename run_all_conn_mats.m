% fxn to collect all connectivity matrices
function run_all_conn_mats(scan_type_list, hcp_a_or_a4)
tic;

if strcmp(hcp_a_or_a4,'hcp_a')
%     path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/original_conn_mats/';
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/';
end
if strcmp(hcp_a_or_a4,'a4')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/a4_cpm/';
end

% collect subj demographic info (from 2.0 release)
% all_pt_demos = readtable(strcat('/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/','HCP-A_cpm_pt_demos.csv'));
all_pt_demos = readtable(strcat(path,'HCP-A_cpm_pt_demos.csv'));

% get all connectivity matrices
conn_mat_struct_all = get_all_conn_mats(all_pt_demos.src_subject_id,scan_type_list,path);

% save struct of all connectivity matrices
cd /data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/CPM_HCP-Aging/
save('all_conn_mats.mat', 'conn_mat_struct_all','-v7.3')
disp('all connectivity matrices saved!')

toc;
end