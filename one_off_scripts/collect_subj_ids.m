% script to collect all subject id's with existing connectivity matrices and group them as we need

% load in struct holding all existing HCP-A 2.0 connectivity matrices
data_path = '/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/';
load([data_path, 'all_conn_mats_indiv.mat'], 'conn_mat_struct_all');

% collect subj demographic info
cpm_path = '/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/HCP-A_info/';
all_pt_demos_temp = readtable(strcat(cpm_path,'HCP-A_cpm_pt_demos.csv'));
all_pt_demos = table(all_pt_demos_temp.interview_age, all_pt_demos_temp.sex, 'RowNames',all_pt_demos_temp.src_subject_id);
all_pt_demos.Properties.VariableNames = ["age", "sex"];

% get scan type names from conn mat struct
scan_types = fieldnames(conn_mat_struct_all);

%rest1_AP
rest1_AP_allsubjs = fieldnames(conn_mat_struct_all.rfMRI_REST1_AP);
[rest1_AP_F, rest1_AP_M] = group_by_sex(all_pt_demos, rest1_AP_allsubjs);

pt_id_connmat_struct.(char(scan_types{1})).('all_subs') = rest1_AP_allsubjs;
pt_id_connmat_struct.(char(scan_types{1})).('F_subs') = rest1_AP_F;
pt_id_connmat_struct.(char(scan_types{1})).('M_subs') = rest1_AP_M;

%rest1_PA
rest1_PA_allsubjs = fieldnames(conn_mat_struct_all.rfMRI_REST1_PA);
[rest1_PA_F, rest1_PA_M] = group_by_sex(all_pt_demos, rest1_PA_allsubjs);

pt_id_connmat_struct.(char(scan_types{2})).('all_subs') = rest1_PA_allsubjs;
pt_id_connmat_struct.(char(scan_types{2})).('F_subs') = rest1_PA_F;
pt_id_connmat_struct.(char(scan_types{2})).('M_subs') = rest1_PA_M;

%rest2_AP
rest2_AP_allsubjs = fieldnames(conn_mat_struct_all.rfMRI_REST2_AP);
[rest2_AP_F, rest2_AP_M] = group_by_sex(all_pt_demos, rest2_AP_allsubjs);

pt_id_connmat_struct.(char(scan_types{3})).('all_subs') = rest2_AP_allsubjs;
pt_id_connmat_struct.(char(scan_types{3})).('F_subs') = rest2_AP_F;
pt_id_connmat_struct.(char(scan_types{3})).('M_subs') = rest2_AP_M;

%rest2_PA
rest2_PA_allsubjs = fieldnames(conn_mat_struct_all.rfMRI_REST2_PA);
[rest2_PA_F, rest2_PA_M] = group_by_sex(all_pt_demos, rest2_PA_allsubjs);

pt_id_connmat_struct.(char(scan_types{4})).('all_subs') = rest2_PA_allsubjs;
pt_id_connmat_struct.(char(scan_types{4})).('F_subs') = rest2_PA_F;
pt_id_connmat_struct.(char(scan_types{4})).('M_subs') = rest2_PA_M;

%carit
carit_allsubjs = fieldnames(conn_mat_struct_all.tfMRI_CARIT);
[carit_F, carit_M] = group_by_sex(all_pt_demos, carit_allsubjs);

pt_id_connmat_struct.(char(scan_types{5})).('all_subs') = carit_allsubjs;
pt_id_connmat_struct.(char(scan_types{5})).('F_subs') = carit_F;
pt_id_connmat_struct.(char(scan_types{5})).('M_subs') = carit_M;

%facename
facename_allsubjs = fieldnames(conn_mat_struct_all.tfMRI_FACENAME);
[facename_F, facename_M] = group_by_sex(all_pt_demos, facename_allsubjs);

pt_id_connmat_struct.(char(scan_types{6})).('all_subs') = facename_allsubjs;
pt_id_connmat_struct.(char(scan_types{6})).('F_subs') = facename_F;
pt_id_connmat_struct.(char(scan_types{6})).('M_subs') = facename_M;

%vismotor
vismotor_allsubjs = fieldnames(conn_mat_struct_all.tfMRI_VISMOTOR);
[vismotor_F, vismotor_M] = group_by_sex(all_pt_demos, vismotor_allsubjs);

pt_id_connmat_struct.(char(scan_types{7})).('all_subs') = vismotor_allsubjs;
pt_id_connmat_struct.(char(scan_types{7})).('F_subs') = vismotor_F;
pt_id_connmat_struct.(char(scan_types{7})).('M_subs') = vismotor_M;

% save struct of subject id's for all existing connectivity matrices
save('../BIG_data_from_CPM_HCP-Aging/pt_id_connmat_grouped.mat', 'pt_id_connmat_struct','-v7.3')
disp('Grouped subject IDs saved!')

% fxn to group subject id's by sex
function [F_subs, M_subs] = group_by_sex(pt_demos, all_subs)
F_subs = {};
M_subs = {};
for i = 1:length(all_subs)
    if strcmp(pt_demos{char(all_subs{i}),2},'F')
        F_subs = [F_subs; all_subs{i}];
    end
    if strcmp(pt_demos{char(all_subs{i}),2},'M')
        M_subs = [M_subs; all_subs{i}];
    end
end
end
