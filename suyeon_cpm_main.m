% executable file for all scripts to run in MRRC server

clear all

% all options:
run_all_conn_mats_bool = 0; % includes 'get_all_conn_mats' fxn
setup_for_cpm_run_bool = 0;
cpm_run_bool = 1;

% all lists:
% param_list = {'ravlt','neon'};
param_list = {'ravlt'};
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};
% scan_type_list = {'rfMRI_REST1_AP'};
var_list = {'all', 'sex'};

% all functions:
if run_all_conn_mats_bool
    run_all_conn_mats;
end

if setup_for_cpm_run_bool
    [pt_struct,conn_mat_struct] = setup_for_cpm_run(param_list, scan_type_list, var_list);
    disp('Finished running setup_for_cpm_run')
end

if cpm_run_bool
    cpm_run(param_list, scan_type_list, var_list);
end
