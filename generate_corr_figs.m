%% create bar graphs to display and compare median Pearson R of each group's CPM runs/predictive models

param_list = {'ravlt','neon'};
scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};

load('../BIG_data_from_CPM_HCP-Aging/all_medianR.mat', 'all_R_arrays');

%% whole group R values (median Pearson correlation vs. behavioral scores across all scans)
figure()
hold on

% ravlt subplot
subplot(1,2,1)
