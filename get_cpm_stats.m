% collect the median Pearson R and p value of each predictive model (one per CPM run)

%% setup variables
% adjust the variables below as needed!
n_runs = 100;
param_list = {'ravlt_L','ravlt_IR','neon','facename'};
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};

%% collect median R and p values for every param in param_list into all_R_arrays struct
all_R_arrays = struct();

for i = 1:length(param_list)
    if strcmp(param_list{i}, 'ravlt_L')
        % collect ravlt_L corrs for all subject groups (ie, whole group, sex-based, etc)
        load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{i})),'cpm_output')
        ravlt_L_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);
        
        % collect matrices of R values
        all_R_arrays.(char('ravlt_L_R')) = get_R_arrays(ravlt_L_corrs, scan_type_list);
    elseif strcmp(param_list{i}, 'ravlt_IR')
        % collect ravlt_IR corrs for all subject groups (ie, whole group, sex-based, etc)
        load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{i})),'cpm_output')
        ravlt_IR_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

        % collect matrices of R values
        all_R_arrays.(char('ravlt_IR_R')) = get_R_arrays(ravlt_IR_corrs, scan_type_list);
    elseif strcmp(param_list{i}, 'neon')
        % collect neon corrs for all subject groups (ie, whole group, sex-based, etc)
        load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{i})),'cpm_output')
        neon_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

        % collect matrices of R values
        all_R_arrays.(char('neon_R')) = get_R_arrays(neon_corrs, scan_type_list);
    elseif strcmp(param_list{i}, 'facename')
        % collect facename corrs for all subject groups (ie, whole group, sex-based, etc)
        load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{i})),'cpm_output')
        facename_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

        % collect matrices of R values
        all_R_arrays.(char('facename_R')) = get_R_arrays(facename_corrs, scan_type_list);
    end
end

%% save median R arrays to .mat file
save('../BIG_data_from_CPM_HCP-Aging/all_medianR.mat', 'all_R_arrays','-v7.3')
disp('Median R values saved!')

%% fxn to collect all corr (R and p) averages and standard deviations
function corrs = cpm_output_stats(scan_type_list, cpm_output_struct, n_runs)

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

%% fxn to construct all R arrays
function arr_struct = get_R_arrays(corrs_struct, scan_type_list)
    arr_all = [];
    arr_F = [];
    arr_M = [];
    for i = 1:length(scan_type_list)
        arr_all = [arr_all; corrs_struct.all_corrs.R_median.(char(scan_type_list{i})),  corrs_struct.all_corrs.p_median.(char(scan_type_list{i}))];
        arr_F = [arr_F; corrs_struct.F_corrs.R_median.(char(scan_type_list{i})),  corrs_struct.F_corrs.p_median.(char(scan_type_list{i}))];
        arr_M = [arr_M; corrs_struct.M_corrs.R_median.(char(scan_type_list{i})),  corrs_struct.M_corrs.p_median.(char(scan_type_list{i}))];
    end
    
    arr_struct = struct('arr_all', arr_all, 'arr_F', arr_F, 'arr_M', arr_M);
end