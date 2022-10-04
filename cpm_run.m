%% Written by Suyeon Ju, 7.18.22

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% general script info
%
% inputs:
%   `param_list` = cell array of parameters to be tested
%       i.e., `{'ravlt','neon'}`
%   `scan_type_list` = cell array containing names of different scan types 
%       i.e., `{'rfMRI_REST1_AP', 'tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'}`
%   `var_list` = cell array containing names of variables to group subjects by 
%       i.e., `{'all', 'sex'}`
%
% outputs:
%   saves a .mat file for each parameter in param_list with structs holding all pt info ('pt_struct') and connectivity matrices ('conn_mat_struct')
%
% fxns within this fxn:
%   get_param_scores: collects parameter scores
%   get_conn_mats: constructs struct of 3D connectivity matrices for each scan type
% 
% example command line (for Suyeon's HCP-A project):
% >> cpm_run({'ravlt','neon'},{'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'},{'all', 'sex'})
%
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% Implementation
function cpm_run(param_list, scan_type_list, var_list, hcp_a_or_a4)
tic;

%% SET UP ALL ARGUMENTS FOR CPM RUNS
if strcmp(hcp_a_or_a4,'hcp_a')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/';
end
if strcmp(hcp_a_or_a4,'a4')
    path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/a4_cpm/';
end

% set pathway strings
CPM_HCP_Aging_path = '/data23/mri_researchers/fredericks_data/shared/hcp_aging_analyses/hcp-a_cpm/CPM_HCP-Aging/';

% user input booleans (based on var_list contents)
allsubj_inp = any(strcmp(var_list,'all'));
sex_inp = any(strcmp(var_list,'sex'));
% age_inp = any(strcmp(var_list,'age')); % haven't made the pt_struct or conn_mat_struct script for this yet!

% set desired number of CPM runs, p-value threshold, and k for k-folds CV
n_runs = 100;
p_thresh = 0.01;
k_folds = 5;

%% FOR-LOOP THROUGH EACH PARAMETER IN PARAM_LIST
for param = 1:length(param_list)
    cd(CPM_HCP_Aging_path)
    
%% PT LIST SETUP
    % collect subj demographic info
    all_pt_demos_temp = readtable(strcat(path,'HCP-A_cpm_pt_demos.csv'));
    all_pt_demos = table(all_pt_demos_temp.interview_age, all_pt_demos_temp.sex, 'RowNames',all_pt_demos_temp.src_subject_id);
    all_pt_demos.Properties.VariableNames = ["age", "sex"];
    
    % collect all subj ID lists
    all_param_pt = readtable(strcat(path,'HCP-A_cpm_project_exclusion_criteria.csv'));
    
    % set up array for correct subj list from all_subjs
    pt = [];
    
    % set up array for parameter data for each subj
    param_data = [];
    
    % set pt array and param_data array to correct subj list/param scores, depending on input params (using 'get_param_scores' fxn)
    if strcmp(param_list{param},'ravlt_ir')
        pt_list = all_param_pt.ravlt;
        n_pt = 566; % number of pt's that have RAVLT scores
        param_txt_filename = 'ravlt01_ir_pf.txt'; % filename of RAVLT behavioral data (from 2.0 release, column added for sum of trials 1-5)
        param_score_col_name = 'pea_ravlt_sd_tc_ir'; % RAVLT Immediate (sum of Trials 1-5)
        
        % collect parameter scores
        [pt,param_data] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name); 
    end
    if strcmp(param_list{param},'ravlt_pf')
        pt_list = all_param_pt.ravlt;
        n_pt = 565; % number of pt's that have RAVLT scores
        param_txt_filename = 'ravlt01_ir_pf.txt'; % filename of RAVLT behavioral data (from 2.0 release, column added for sum of trials 1-5)
        param_score_col_name = 'pea_ravlt_sd_tc_pf'; % RAVLT Percent Forgetting ((Trial 5 - delayed recall) / Trial 5) 
        
        % collect parameter scores
        [pt,param_data] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name); 
    end
    if strcmp(param_list{param},'neon')
        pt_list = all_param_pt.neon;
        n_pt = 579; % number of pt's that have RAVLT scores
        param_txt_filename = 'nffi01.txt'; % filename of NEO-N behavioral data (from 2.0 release)
        param_score_col_name = 'neo2_score_ne'; % Neuroticism score
        
        % collect parameter scores
        [pt,param_data] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name);
    end
    if strcmp(param_list{param},'facename')
        pt_list = all_param_pt.facename;
        n_pt = 559; % number of pt's that have FACENAME scores
        param_txt_filename = 'facename_final.txt'; % filename of FACENAME behavioral data (generated using Python)
        param_score_col_name = 'Score'; % FACENAME Score
        
        % collect parameter scores
        [pt,param_data] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name); 
    end
%% PT STRUCT SETUP
    pt_id = pt;
    age = all_pt_demos{pt,'age'};
    sex = all_pt_demos{pt,'sex'};
    y = param_data;

    % constuct table with all pt info (whole group for selected param)
    pt_table = table(pt_id, age, sex, y);
    
    % add more pt_table groupings here for other variables of interest (ie, age bins, years of education, handedness, etc.)
    %   DISCLAIMER: need to collect more demographic info in line 34 for pt_table groupings other than sex or age! - suyeon, 7.18.22
    pt_table_F = pt_table(strcmp(pt_table.sex, 'F'),:); % makes new pt_table with only female subjects
    pt_table_M = pt_table(strcmp(pt_table.sex, 'M'),:); % makes new pt_table with only male subjects

    % collect whole-group pt_table and all other pt_table groups in pt_struct
    pt_struct = struct('pt_all',pt_table, 'pt_F',pt_table_F, 'pt_M',pt_table_M);

%% CONN MAT STRUCT SETUP
    cd(CPM_HCP_Aging_path)
    
    % construct conn_mat_structs across whole group
    if allsubj_inp
        conn_mat_struct_all = get_conn_mats(scan_type_list,'hcp_a',pt_table);
        cd(CPM_HCP_Aging_path)
    end
    
    % construct conn_mat_structs grouped by sex
    if sex_inp
        conn_mat_struct_F = get_conn_mats(scan_type_list,'hcp_a',pt_table_F);
        cd(CPM_HCP_Aging_path)
        conn_mat_struct_M = get_conn_mats(scan_type_list,'hcp_a',pt_table_M);
        cd(CPM_HCP_Aging_path)
    end
    
    % combine all conn_mat_structs (groups for now: all + female + male)
    conn_mat_struct = struct('all_conn_mats',conn_mat_struct_all,'F_conn_mats',conn_mat_struct_F,'M_conn_mats',conn_mat_struct_M);
    
%% RUN CPM ON DESIRED GROUPS
    % cpm model across whole group
    if allsubj_inp
        % whole group model
        cpm_output_all = get_cpm_outputs(scan_type_list,pt_struct.pt_all,conn_mat_struct.all_conn_mats,n_runs,p_thresh,k_folds);
        disp('Finished cpm_output_all')
    end
    
    % cpm model for each sex
    if sex_inp
        % female subjects model
        cpm_output_F = get_cpm_outputs(scan_type_list,pt_struct.pt_F,conn_mat_struct.F_conn_mats,n_runs,p_thresh,k_folds);
        disp('Finished cpm_output_F')
        
        % male subjects model
        cpm_output_M = get_cpm_outputs(scan_type_list,pt_struct.pt_M,conn_mat_struct.M_conn_mats,n_runs,p_thresh,k_folds);
        disp('Finished cpm_output_M')
    end
    
    cpm_output = struct('all_cpm_output',cpm_output_all,'F_cpm_output',cpm_output_F,'M_cpm_output',cpm_output_M);
           
%% COLLECT CPM OUTPUTS
    if strcmp(param_list{param},'ravlt_ir')
        save('ravlt_ir_cpm_output.mat', 'pt_struct', 'cpm_output','-v7.3')
        disp('RAVLT-IR results saved!')
    end
    if strcmp(param_list{param},'ravlt_pf')
        save('ravlt_pf_cpm_output.mat', 'pt_struct', 'cpm_output','-v7.3')
        disp('RAVLT-PF results saved!')
    end
    if strcmp(param_list{param},'neon')
        save('neon_cpm_output.mat', 'pt_struct', 'cpm_output','-v7.3')
        disp('NEO-N results saved!')
    end
    if strcmp(param_list{param},'facename')
        save('facename_cpm_output.mat', 'pt_struct', 'cpm_output','-v7.3')
        disp('FACENAME results saved!')
    end
end

toc;
end

% fxn to collect parameter scores (y)
function [pt,y] = get_param_scores(pt_list, n_pt, param_txt_filename, param_score_col_name)

behavioralData_path = '/data23/mri_group/an_data/HCP-A2.0/behavioralData/';

pt = pt_list(1:n_pt,:);
opts = detectImportOptions(strcat(behavioralData_path, param_txt_filename));
opts.DataLines = 3;
opts.VariableNamesLine = 1;
data = readtable(strcat(behavioralData_path, param_txt_filename),opts);
y = NaN(length(pt),1);
for i = 1:length(pt)
    y(i) = data{strcmp(data.src_subject_id, pt(i)),param_score_col_name};
end

end

% fxn to construct struct of cpm outputs for all runs for each scan type
function cpm_output_struct = get_cpm_outputs(scan_type_list,pt_table,conn_mat_struct,n_runs,p_thresh,k_folds)

for st = 1:length(scan_type_list)
    y_hat_output = zeros(length(pt_table.y),n_runs);
    corr_output = zeros(2, n_runs);
    pmask_output = zeros(35778,k_folds,n_runs);
    for i = 1:n_runs
        [y_hat,corr,pmask] = cpm_main(conn_mat_struct.(char(scan_type_list(st))),pt_table.y','pthresh',p_thresh,'kfolds',k_folds);
        y_hat_output(:,i) = y_hat;
        corr_output(1,i) =  corr(1);
        corr_output(2,i) =  corr(2);
        pmask_output(:,:,i) = pmask;
    end

    cpm_output_struct.(char('y_hat_struct')).(char(scan_type_list(st))) = y_hat_output;
    cpm_output_struct.(char('corr_struct')).(char(scan_type_list(st))) = corr_output;
    cpm_output_struct.(char('pmask_struct')).(char(scan_type_list(st))) = pmask_output;
end

end