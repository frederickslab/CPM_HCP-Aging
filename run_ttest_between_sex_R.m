scan_type_list = {'rfMRI_REST1_AP', 'rfMRI_REST1_PA', 'rfMRI_REST2_AP', 'rfMRI_REST2_PA','tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'};
p_values = [];

load('../BIG_data_from_CPM_HCP-Aging/neon_by_sex_cpm_output.mat')

for i = 1:7
    arr1 = cpm_output_by_sex.F.corr_struct.(char(scan_type_list{i}))(1,:);
    arr2 = cpm_output_by_sex.M.corr_struct.(char(scan_type_list{i}))(1,:);
    
    [h,p,ci,stats] = ttest(arr1,arr2);
    p_values = [p_values, p];
end
