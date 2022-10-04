% clear
% clc

%% conn mat stuff
% 1. use the individual connectivity matrix .mat file to make stacked (3D)
% matrices in this script run's workspace
% 2. run the association ratio script on each stacked matrix
% 3. somehow collect all of the association ratio values and run t-tests

%% load the 268 atlas based connectivity matrices
data_path = '/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/';
load([data_path, 'all_conn_mats_indiv.mat'], 'all_connmats');



% mat_all = all_connmats.tfMRI_VISMOTOR;

%% set up variables for number of subjects, nodes, and networks
no_sub = size( mat_all, 3);
no_nodes = size( mat_all, 1);
no_net = 10;

%% load the network labels for the 268 parcellation
% first column is the ROI index
% second column is the 10 network labels (full network names commented below)
% convert the two column lookup table to 1D label
%     1 = medial frontal
%     2 = frontoparietal
%     3 = default mode
%     4 = motor cortex, 
%     5 = visual A
%     6 = visual B
%     7 = visual association
%     8 = salience
%     9 = subcortical
%     10 = cerebellum
look_table = dlmread('Shen268_10network');

%% set sigma ***SUYEON, FIGURE OUT WHAT THIS IS EXACTLY...
sigma = mean( 1- mat_all(1:50:end));

%% 
label = zeros(1, no_nodes);
for i = 1:no_net
    cur_id= find( look_table(:,2) ==i);
    label( look_table(cur_id,1)) = i;
end

%% initialize association ratio matrix (no_sub x no_net)
ass_ratio = zeros(no_sub, no_net);

%% fill in association ratio matrix
for i = 1:no_sub
    cur_mat = squeeze( mat_all(:,:,i));
    ass_ratio(i, :) = association( cur_mat, sigma, label);
end
mat fi
plot_association_ratio_hm(ass_ratio)

%% fxn to plot heatmap of association ratios across all networks for each scan type
function plot_association_ratio_hm(A_ratio)
    fig = figure;
    set(gcf, 'Position', [0, 0, 500, 1500]);
    
    hm = heatmap(A_ratio,'Colormap', jet);
    hm.Title = ['tfMRI\_VISMOTOR']; % fix this line to incorporate scan type name
    hm.XDisplayLabels = {'MF','FP','DMN','Mot','VI','VII','VAs','SAL','SC','Cer'};
    hm.XLabel = '10 networks';
    hm.YLabel = 'subject number';
    
    saveas(fig,'../cpm_figures/network_segregation_heatmaps/netseg_hm_tfMRI_VISMOTOR.png') % fix this line to incorporate scan type name
end

%% fxn to run t-tests on association ratios between sexes

