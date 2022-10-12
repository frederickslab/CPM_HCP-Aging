% visualize pmasks of significant edges from cpm

% outputs:
%   saves 10-network consensus heatmaps of positive and negative matrices for each scan type
%   of each parameter in `param_list` (for later use in BIS Connviewer)

%% Implementation

close all

param_list = {'ravlt_L','ravlt_IR','neon','facename'};
scan_type_list = {'rfMRI_REST1_AP', 'rfMRI_REST1_PA', 'rfMRI_REST2_AP', 'rfMRI_REST2_PA','tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'};

for n = 1:1%length(param_list)
    load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{n})),'cpm_output')
    
    %% set all necessary variables
    p_thresh = 0.01; % p threshold used for CPM run
    k_folds = 5; % number of k folds used in CPM run
    param = char(param_list{n}); % char variable with name of param
    trial_count = 100; % number of CPM runs
    thresholder = 0; % number of degrees (number of edges of node) to threshold by
        
    %% get positive and negative pmasks and their sizes
    for i = 6 %1:length(scan_type_list)
        % whole group (all)
        [pos_mat_all,neg_mat_all,pos_mat_size_all,neg_mat_size_all] = get_consensus_mask(cpm_output.all_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        pmask_visualization(pos_mat_all,neg_mat_all, param, scan_type_list{i},'all');
        
        % F group
        [pos_mat_F,neg_mat_F,pos_mat_size_F,neg_mat_size_F] = get_consensus_mask(cpm_output.F_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        pmask_visualization(pos_mat_F,neg_mat_F, param, scan_type_list{i},'F');
        
        % M group
        [pos_mat_M,neg_mat_M,pos_mat_size_M,neg_mat_size_M] = get_consensus_mask(cpm_output.M_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        pmask_visualization(pos_mat_M,neg_mat_M, param, scan_type_list{i},'M');
    end
end