%% Written by Suyeon Ju, 7.10.22, adapted from Corey Horien's scripts

%% Implementation
function corrs = cpm_output_stats(scan_type_list, cpm_output_struct, n_runs)

% collect all corr (R and p) averages and standard deviations
all_corrs = struct();
F_corrs = struct();
M_corrs = struct();

for s = 1:length(scan_type_list)
    corr_sorted = sort(cpm_output_struct.all_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:));
    median_R = corr_sorted((n_runs/2) + 1);
    all_corrs.('R_median').(char(scan_type_list{s})) = median_R;
    all_corrs.('R_median_index').(char(scan_type_list{s})) = find(cpm_output_struct.all_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:) == median_R);
    all_corrs.('p_median').(char(scan_type_list{s})) = cpm_output_struct.all_cpm_output.corr_struct.(char(scan_type_list{s}))(2,all_corrs.('R_median_index').(char(scan_type_list{s})));

    corr_sorted = sort(cpm_output_struct.F_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:));
    median_R_F = corr_sorted((n_runs/2) + 1);
    F_corrs.('R_median').(char(scan_type_list{s})) = median_R_F;
    F_corrs.('R_median_index').(char(scan_type_list{s})) = find(cpm_output_struct.F_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:) == median_R_F);
    F_corrs.('p_median').(char(scan_type_list{s})) = cpm_output_struct.F_cpm_output.corr_struct.(char(scan_type_list{s}))(2,F_corrs.('R_median_index').(char(scan_type_list{s})));

    corr_sorted = sort(cpm_output_struct.M_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:));
    median_R_M = corr_sorted((n_runs/2) + 1);
    M_corrs.('R_median').(char(scan_type_list{s})) = median_R_M;
    M_corrs.('R_median_index').(char(scan_type_list{s})) = find(cpm_output_struct.M_cpm_output.corr_struct.(char(scan_type_list{s}))(1,:) == median_R_M);
    M_corrs.('p_median').(char(scan_type_list{s})) = cpm_output_struct.M_cpm_output.corr_struct.(char(scan_type_list{s}))(2,M_corrs.('R_median_index').(char(scan_type_list{s})));
end

corrs = struct('all_corrs', all_corrs, 'F_corrs', F_corrs, 'M_corrs', M_corrs);

end