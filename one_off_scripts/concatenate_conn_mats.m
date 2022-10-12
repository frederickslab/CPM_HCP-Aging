% concatenate all of the connmats into one large 3D matrix (268 x 268 x n_subs) for each scan type!

data_path = '/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/';
load([data_path, 'all_conn_mats_indiv.mat'], 'conn_mat_struct_all');

scan_types = fieldnames(conn_mat_struct_all);

%rest1_AP
rest1_AP_fn = fieldnames(conn_mat_struct_all.rfMRI_REST1_AP);
rest1_AP_mat_all = zeros(268,268,size(rest1_AP_fn,1));
for s = 1:length(rest1_AP_fn)
    rest1_AP_mat_all(:,:,s) = conn_mat_struct_all.rfMRI_REST1_AP.(char(rest1_AP_fn{s}));
end

%rest1_PA
rest1_PA_fn = fieldnames(conn_mat_struct_all.rfMRI_REST1_PA);
rest1_PA_mat_all = zeros(268,268,size(rest1_PA_fn,1));
for s = 1:length(rest1_PA_fn)
    rest1_PA_mat_all(:,:,s) = conn_mat_struct_all.rfMRI_REST1_PA.(char(rest1_PA_fn{s}));
end

%rest2_AP
rest2_AP_fn = fieldnames(conn_mat_struct_all.rfMRI_REST2_AP);
rest2_AP_mat_all = zeros(268,268,size(rest2_AP_fn,1));
for s = 1:length(rest2_AP_fn)
    rest2_AP_mat_all(:,:,s) = conn_mat_struct_all.rfMRI_REST2_AP.(char(rest2_AP_fn{s}));
end

%rest2_PA
rest2_PA_fn = fieldnames(conn_mat_struct_all.rfMRI_REST2_PA);
rest2_PA_mat_all = zeros(268,268,size(rest2_PA_fn,1));
for s = 1:length(rest2_PA_fn)
    rest2_PA_mat_all(:,:,s) = conn_mat_struct_all.rfMRI_REST2_PA.(char(rest2_PA_fn{s}));
end

%carit
carit_fn = fieldnames(conn_mat_struct_all.tfMRI_CARIT);
carit_mat_all = zeros(268,268,size(carit_fn,1));
for s = 1:length(carit_fn)
    carit_mat_all(:,:,s) = conn_mat_struct_all.tfMRI_CARIT.(char(carit_fn{s}));
end

%facename
facename_fn = fieldnames(conn_mat_struct_all.tfMRI_FACENAME);
facename_mat_all = zeros(268,268,size(facename_fn,1));
for s = 1:length(facename_fn)
    facename_mat_all(:,:,s) = conn_mat_struct_all.tfMRI_FACENAME.(char(facename_fn{s}));
end

%vismotor
vismotor_fn = fieldnames(conn_mat_struct_all.tfMRI_VISMOTOR);
vismotor_mat_all = zeros(268,268,size(vismotor_fn,1));
for s = 1:length(vismotor_fn)
    vismotor_mat_all(:,:,s) = conn_mat_struct_all.tfMRI_VISMOTOR.(char(vismotor_fn{s}));
end

all_connmats = struct(scan_types{1}, rest1_AP_mat_all, scan_types{2}, rest1_PA_mat_all, scan_types{3}, rest2_AP_mat_all, scan_types{4}, rest2_PA_mat_all, scan_types{5}, carit_mat_all, scan_types{6}, facename_mat_all, scan_types{7}, vismotor_mat_all);