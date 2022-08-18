% fxn to construct struct of 3D connectivity matrices for each scan type

function conn_mat_struct = get_conn_mats(scan_type_list, hcp_a_or_a4, pt_table)

conn_mat_struct = struct();

if strcmp(hcp_a_or_a4,'hcp_a')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/CPM_HCP-Aging/';
end
if strcmp(hcp_a_or_a4,'a4')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/a4_cpm/CPM_A4/';
end

cd(path)
load('all_conn_mats.mat','conn_mat_struct_all')

for st = 1:length(scan_type_list)
    %% CONN_MAT SETUP/COLLECTION
    conn_mat = [];
    for sub = 1:size(pt_table,1)
        conn_mat = cat(3,conn_mat,conn_mat_struct_all.(char(scan_type_list(st))).(char(pt_table.pt_id{sub})));
    end
    %% CONN_MAT STRUCT POPULATION
    conn_mat_struct.(char(scan_type_list(st))) = conn_mat;
end

end