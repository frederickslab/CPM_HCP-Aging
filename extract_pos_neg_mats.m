%% Written by Suyeon Ju, 7.10.22, adapted from Corey Horien's scripts

%% general script info

% fxn to get positive and negative matrices of significant edges from cpm

% inputs: none

% outputs:
%   saves .csv files of positive and negative matrices for each scan type
%   of each parameter in `param_list` (for later use in BIS Connviewer)

%% Implementation

param_list = {'ravlt','neon'};
scan_type_list = {'rfMRI_REST1_AP', 'rfMRI_REST1_PA', 'rfMRI_REST2_AP', 'rfMRI_REST2_PA','tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'};

for n = 1:length(param_list)
    load(sprintf('../BIG_data_from_CPM_HCP-Aging/%s_cpm_output.mat',char(param_list{n})),'cpm_output')

    %% set all necessary variables
    p_thresh = 0.01; % p threshold used for CPM run
    k_folds = 5; % number of k folds used in CPM run
    param = char(param_list{n}); % char variable with name of param
    trial_count = 100; % number of CPM runs
    thresholder = 50; % number of degrees (number of edges of node) to threshold by

    %% get positive and negative pmasks and their sizes
    for i = 1:length(scan_type_list)
        % whole group (all)
        [pos_mat_all,neg_mat_all,pos_mat_size_all,neg_mat_size_all] = get_consensus_mask(cpm_output.all_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        save_pos_neg_mats('whole_group', param, scan_type_list{i}, pos_mat_all, neg_mat_all);
        
        % F group
        [pos_mat_F,neg_mat_F,pos_mat_size_F,neg_mat_size_F] = get_consensus_mask(cpm_output.F_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        save_pos_neg_mats('F_group', param, scan_type_list{i}, pos_mat_F, neg_mat_F);
        
        % M group
        [pos_mat_M,neg_mat_M,pos_mat_size_M,neg_mat_size_M] = get_consensus_mask(cpm_output.M_cpm_output.pmask_struct.(char(scan_type_list{i})),k_folds,trial_count,thresholder);
        save_pos_neg_mats('M_group', param, scan_type_list{i}, pos_mat_M, neg_mat_M);
    end

end

%% fxn to easily name and save .csv files containing our pos and neg mats 
function save_pos_neg_mats(g, p, st, pm, nm)
    csv_pos_filename = sprintf('../cpm_figures/pos_neg_mats/%s/%s_%s_pos_mat.csv', g, p, st);
    csv_neg_filename = sprintf('../cpm_figures/pos_neg_mats/%s/%s_%s_neg_mat.csv', g, p, st);

    csvwrite(csv_pos_filename,pm);
    csvwrite(csv_neg_filename,nm);
    
    disp(sprintf('pos and neg mats saved successfully for %s - %s - %s!', g, p, st))
end
