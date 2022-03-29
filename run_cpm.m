%% Written by Suyeon Ju, 1.10.22
% This script will take in the following inputs to run CPM:
% 
% Inputs: 
%   subj_list = list of all subject IDs (should be file name of .txt file that
%       has list of all subject IDs ['HCA#######'])
%   behav_param = behavioral parameter to be tested (should  match with the file 
%       name of the .txt file from HCP-A dataset with that parameter's data)
%   scan_type = one of the following: 'rfMRI_REST', 'tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'

% Example command line:
% >> run_cpm('all_subjs_ravlt_hcp-a_2.txt', 'ravlt','tfMRI_CARIT')

%% Pseudocode

% step 1: create string array with all subj IDs from subj_list

% step 2: create for loop where:
%   - iterative variable = all subj IDs
%   - conn_mat_single matrix variable = connectivity matrix for each subj ID for
%       specified scan_type; each conn_mat_single matrix is added in 3rd
%       dimension to conn_mat (which holds all conn mats across all subjs)
%   - collect subj IDs of all subjs in conn_mat (conn_subj_array)

% step 3: create matrix listing all subj IDs in conn_subj_array (in col 1) 
%   and corresponding behavioral parameter data pulled from behav_param (in col 2)

% step 4: call cpm_main function from constable's CPM matlab code

%% Implementation

function run_cpm(subj_list, behav_param, scan_type)
    
% step 1:
    subj_array = readtable(subj_list, 'ReadVariableNames', false);

% step 2
    CM_dir = sprintf('/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/conn_mat_%s/conn_mat_output/', scan_type);
    cd(CM_dir)
    conn_mat = [];
    conn_subj_array = {};
    for h = 1:size(subj_array,1)
        try
            CM_filename = sprintf('%s_bis_matrix_1_matrix.txt', string(subj_array{h,:}));
            conn_mat_single = load(CM_filename);
            conn_mat = cat(3,conn_mat,conn_mat_single);
            conn_subj_array{end+1} = subj_array{h,:};
        catch
            continue;
        end
    end
    
% step 3:
    behav_scores = cell(size(conn_subj_array,1),2);
    if strcmp(behav_param, 'ravlt')
        opts = detectImportOptions('/data23/mri_group/an_data/HCP-A2.0/behavioralData/ravlt01.txt');
        opts.DataLines = 3;
        opts.VariableNamesLine = 1;
        ravlt_data = readtable('/data23/mri_group/an_data/HCP-A2.0/behavioralData/ravlt01.txt',opts);
        for i = 1:size(conn_subj_array,2)
            behav_scores(i,1) = conn_subj_array{i};
            behav_scores(i,2) = num2cell(ravlt_data{strcmp(ravlt_data.src_subject_id, conn_subj_array{i}),'pea_ravlt_sd_tc'}); % RAVLT Short Delay Total Correct
        end
    elseif strcmp(behav_param, 'psm') 
        opts = detectImportOptions('/data23/mri_group/an_data/HCP-A2.0/behavioralData/psm01.txt');
        opts.DataLines = 3;
        opts.VariableNamesLine = 1;
        psm_data = readtable('/data23/mri_group/an_data/HCP-A2.0/behavioralData/psm01.txt',opts);
        for i = 1:size(conn_subj_array,2)
            behav_scores(i,1) = conn_subj_array{i};
            behav_scores(i,2) = num2cell(psm_data{strcmp(psm_data.src_subject_id, conn_subj_array{i}),'nih_picseq_ageadjusted'}); % Age Adjusted scaled score for PicSeq subtest 
        end
    elseif strcmp(behav_param, 'pcps') 
        opts = detectImportOptions('/data23/mri_group/an_data/HCP-A2.0/behavioralData/pcps01.txt');
        opts.DataLines = 3;
        opts.VariableNamesLine = 1;
        pcps_data = readtable('/data23/mri_group/an_data/HCP-A2.0/behavioralData/pcps01.txt',opts);
        for i = 1:size(conn_subj_array,2)
            behav_scores(i,1) = conn_subj_array{i};
            behav_scores(i,2) = num2cell(pcps_data{strcmp(pcps_data.src_subject_id, conn_subj_array{i}),'nih_patterncomp_ageadjusted'}); % Age Adjusted scaled score for PatternComp subtest
        end
    elseif strcmp(behav_param, 'nffi')
        opts = detectImportOptions('/data23/mri_group/an_data/HCP-A2.0/behavioralData/nffi01.txt');
        opts.DataLines = 3;
        opts.VariableNamesLine = 1;
        nffi_data = readtable('/data23/mri_group/an_data/HCP-A2.0/behavioralData/nffi01.txt',opts);
        for i = 1:size(conn_subj_array,2)
            behav_scores(i,1) = conn_subj_array{i};
            behav_scores(i,2) = num2cell(nffi_data{strcmp(nffi_data.src_subject_id, conn_subj_array{i}),'neo2_score_ne'}); % Neuroticism score
        end
    else
        disp('error: please enter a valid behavioral parameter! (either ravlt, pcps, or nffi)')
    end

% step 4:
    cd ../../CPM/matlab/func/
    [y_hat,corr] = cpm_main(conn_mat, behav_scores(:,2)');
    size(y_hat)
    size(corr)
    cd(CM_dir)
    cd /data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/
    
end