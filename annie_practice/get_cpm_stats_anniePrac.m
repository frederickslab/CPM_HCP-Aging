% read in cpm output .mat file

n_runs = 100;
param_list = {'ravlt','neon','facename'}; % CHANGE THIS LINE TO INCLUDE FACENAME!
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};

%% collect ravlt corrs for all subject groups (ie, whole group, sex-based, etc)
load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{1})),'cpm_output')
ravlt_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

%% collect neon corrs for all subject groups (ie, whole group, sex-based, etc)
load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{2})),'cpm_output')
neon_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

%% collect facename corrs for all subject groups (ie, whole group, sex-based, etc)
load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{3})),'cpm_output')
facename_corrs = cpm_output_stats(scan_type_list, cpm_output, n_runs);

%% collect matrices of R values
all_R_arrays = struct();

% ravlt
all_R_arrays.(char('ravlt_R')) = get_R_arrays(ravlt_corrs, scan_type_list);

% neon
all_R_arrays.(char('neon_R')) = get_R_arrays(neon_corrs, scan_type_list);

% facename
all_R_arrays.(char('facename_R')) = get_R_arrays(facename_corrs, scan_type_list); %going to go through all the correlations we got from CPM output and then it will pick each group of 100 CPM runs and pick the median performing model 


%% save median R arrays to .mat file
save('../BIG_data_from_CPM_HCP-Aging/all_medianR.mat', 'all_R_arrays','-v7.3')
disp('Median R values saved!')

%% function to construct all R arrays
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