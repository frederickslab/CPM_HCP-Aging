%% Written by Suyeon Ju, 7.18.22

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% general script info
%
% inputs:
%   `param_list` = cell array of parameters to be tested
%       i.e., "{'ravlt','neon'}"
%   `scan_type_list` = cell array containing names of different scan types 
%       i.e., "{'rfMRI_REST1_AP', 'tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'}"
%   `var_list` = cell array containing names of variables to group subjects by 
%       i.e., "{'all', 'sex'}"
%
% outputs:
%   saves a .mat file for each parameter in param_list with structs holding all pt info ('pt_struct') and connectivity matrices ('conn_mat_struct')
%
% fxns within this fxn:
%   get_param_scores: collects parameter scores
%   get_conn_mats: constructs struct of 3D connectivity matrices for each scan type
% 
% example command line (for Suyeon's HCP-A project):
% >> run_cpm({'ravlt','neon'},{'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'},{'all', 'sex'})
%
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% Implementation
function cpm_run(param_list, scan_type_list, var_list)
tic;

% set pathway strings
% CPM_HCP_Aging_path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/CPM_HCP-Aging/';

%% user input booleans (based on var_list contents)
allsubj_inp = any(strcmp(var_list,'all'));
sex_inp = any(strcmp(var_list,'sex'));
% age_inp = any(strcmp(var_list,'age')); % haven't made the pt_struct or conn_mat_struct script for this yet!

% set desired number of CPM runs, p-value threshold, and k for k-folds CV
n_runs = 100;
p_thresh = 0.01;
k_folds = 5;

for param = 1:length(param_list)
    load(sprintf('%s_by_sex_pt_conn_mat.mat',char(param_list{param})),'pt_struct', 'conn_mat_struct')
    
    % construct conn_mat_structs across whole group
    if allsubj_inp
        % whole group model
        cpm_output_all = get_cpm_outputs(scan_type_list,pt_struct.pt_all,conn_mat_struct.all_conn_mats,n_runs,p_thresh,k_folds)
    end
    
    % construct conn_mat_structs grouped by sex
    if sex_inp
        % female subjects model
        cpm_output_F = get_cpm_outputs(scan_type_list,pt_struct.pt_F,conn_mat_struct.F_conn_mats,n_runs,p_thresh,k_folds)
        
        % male subjects model
        cpm_output_M = get_cpm_outputs(scan_type_list,pt_struct.pt_M,conn_mat_struct.M_conn_mats,n_runs,p_thresh,k_folds)
    end
    
    cpm_output = struct('all_cpm_output',cpm_output_all,'F_cpm_output',cpm_output_F,'M_cpm_output',cpm_output_M);
           
    %% COLLECT CPM OUTPUTS!
    if strcmp(param_list{param},'ravlt')
        save('ravlt_by_sex_cpm_output.mat', 'cpm_output')
        disp('RAVLT results saved!')
    end
    if strcmp(param_list{param},'neon')
        save('neon_by_sex_cpm_output.mat', 'cpm_output')
        disp('NEO-N results saved!')
    end
end

toc;
end