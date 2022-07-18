% executable file for collecting all connectivity matrices

hcp_a_cpm_path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/';

% collect subj demographic info (from 2.0 release)
all_pt_demos = readtable(strcat(hcp_a_cpm_path,'HCP-A_cpm_pt_demos.csv'));

% list of all scan types
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};

% get all connectivity matrices
conn_mat_struct_all = get_all_conn_mats(all_pt_demos.src_subject_id,scan_type_list,'hcp_a');

% save struct of all connectivity matrices
save('all_conn_mats.mat', 'conn_mat_struct_all','-v7.3')
disp('all connectivity matrices saved!')