% fxn to get all connectivity matrices for each scan type (with pt IDs as struct fields)

function conn_mat_struct = get_all_conn_mats(pt_list, scan_type_list, hcp_a_or_a4)

conn_mat_struct = struct();

if strcmp(hcp_a_or_a4,'hcp_a')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/';
end
if strcmp(hcp_a_or_a4,'a4')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/a4_cpm/';
end

for st = 1:length(scan_type_list)
    i = 0;
    for sub = 1:length(pt_list)
        try
            conn_mat_dir = sprintf('%s%s/connmat_output', path, scan_type_list{st});
            cd(conn_mat_dir)

            conn_mat_filename = sprintf('%s_bis_matrix_1_matrix.txt', char(pt_list(sub)));
            conn_mat_single = load(conn_mat_filename);
            conn_mat_struct.(char(scan_type_list(st))).(char(pt_list(sub))) = conn_mat_single;
        catch
            i = i+1;
            continue;
        end
    end
    n_connmats = length(pt_list) - i;
    sprintf('Total conn mats saved in %s: %f', scan_type_list{st},n_connmats)
end

cd /data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/CPM_HCP-Aging/

end