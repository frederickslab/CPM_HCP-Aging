% executable file for all scripts to run in MRRC server

clear all

% all options:
run_all_conn_mats_bool = 0; % includes 'get_all_conn_mats' fxn
cpm_run_bool = 1;

% all arguments:
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};
param_list = {'ravlt_ir','ravlt_pf'};
var_list = {'all', 'sex'};
hcp_a_or_a4 = 'hcp_a';

% all functions:
if run_all_conn_mats_bool
    run_all_conn_mats(scan_type_list, hcp_a_or_a4);
end

if cpm_run_bool
    cpm_run(param_list, scan_type_list, var_list, hcp_a_or_a4);
end
