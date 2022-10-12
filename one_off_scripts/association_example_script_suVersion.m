% clear
% clc

% load the 268 atlas based connectivity matrices
% assume the connectivity matrices are organized as mat_all
% of size 268*268*no_sub;
% here is an example:
%--------------this part should be replaced with your own conn data-------------------
% data_path = '/mridata2/mri_group/xilin_data/alex/';
% load([data_path, 'all_mats_cov5_regressed'], 'res_mat_all');
% mat_all = squeeze(res_mat_all(:,:,:,1));

data_path = '/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/';
% load([data_path, 'all_conn_mats.mat'], 'all_connmats');
mat_all = all_connmats.tfMRI_VISMOTOR;
%--------------------------------------------------------------------------------------

no_sub = size( mat_all, 3);
no_nodes = size( mat_all, 1);
sigma = mean( 1- mat_all(1:50:end));

no_net = 10;
% load the network labels for the 268 parcellation
% 1 = medial frontal
% 2 = frontoparietal
% 3 = default mode
% 4 = motor cortex, 
% 5 = visual A
% 6 = visual B
% 7 = visual association
% 8 = salience
% 9 = subcortical
% 10 = cerebellum

look_table = dlmread('Shen268_10network');
% first column is the ROI index
% second column is the 10 network labels
% convert the two column lookup table to 1D label
label = zeros(1, no_nodes);
for i = 1:no_net
    cur_id= find( look_table(:,2) ==i);
    label( look_table(cur_id,1)) = i;
end

ass_ratio = zeros(no_sub, no_net);

for i = 1:no_sub
    
    cur_mat = squeeze( mat_all(:,:,i));
    ass_ratio(i, :) = association( cur_mat, sigma, label);
end

% seems like the edges may not be normalized?
fig = figure;
set(gcf, 'Position', [0, 0, 500, 1500]);

hm = heatmap(ass_ratio,'Colormap', jet);
hm.Title = 'tfMRI VISMOTOR';
hm.XDisplayLabels = {'MF','FP','DMN','Mot','VI','VII','VAs','SAL','SC','Cer'};
hm.XLabel = '10 networks';
hm.YLabel = 'node number';

saveas(fig,'../cpm_figures/network_segregation_heatmaps/netseg_hm_tfMRI_VISMOTOR.png')