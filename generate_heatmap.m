%% Written by Jordan Galbraith, 7.17.22; updated by Suyeon Ju, 9.23.22

%example command line: generate_heatmap("rfMRI_REST1_AP","HCA6002236")
%Purpose: create full 268x268 heatmap separated out by network
%Inputs: scan type of interest ('rfMRI_REST1_AP', 'rfMRI_REST1_PA', 'rfMRI_REST2_AP',
    %'rfMRI_REST2_PA','tfMRI_CARIT', 'tfMRI_FACENAME', 'tfMRI_VISMOTOR'), and
    %pt number
%Output: prints out heatmap


function generate_heatmap(scan,pt)

% load conn mat of interest
% load(sprintf('C:/Users/jogal/Yale University/Ju, Suyeon - CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/all_conn_mats.mat'), 'conn_mat_struct_all');
load(sprintf('/Users/sj737/Library/CloudStorage/OneDrive-YaleUniversity/Fredericks_Lab_files/CPM_HCP-A/BIG_data_from_CPM_HCP-Aging/all_conn_mats_indiv.mat'), 'conn_mat_struct_all');
conn_matrix = conn_mat_struct_all.(scan).(pt);

%reorder to put 10 networks in order
look_table = dlmread('Shen268_10network');
correct_Shen_order = look_table(:,1)';
conn_matrix = conn_matrix(correct_Shen_order,correct_Shen_order);

%get rid of correlations of nodes to themselves
conn_matrix(conn_matrix > 6) = 0;

%create heatmap with no grid lines
conn_heatmap = heatmap(conn_matrix,'GridVisible','off','Colormap', jet);

%Get rid of x labels
cdl = conn_heatmap.XDisplayLabels;                                    
conn_heatmap.XDisplayLabels = repmat(' ',size(cdl,1), size(cdl,2));

%Get rid of y labels
cd2 = conn_heatmap.YDisplayLabels;                                    
conn_heatmap.YDisplayLabels = repmat(' ',size(cd2,1), size(cd2,2));

%create lines and tick labels to overlay on heatmap
a2 = axes('Position', conn_heatmap.Position);               
a2.Color = 'none';   %new axis transparent

%Place lines to separate networks - based on Shen atlas excel doc
yline(a2,[29 63 83 133 151 160 178 208 237],'LineWidth', 0.9); 
xline(a2,[29 63 83 133 151 160 178 208 237],'LineWidth', 0.9);

%Halfway between each line to add in network labels
a2.YTick = [14.5 46 73 108 142 155.5 169 193 222.5 252.5];              
a2.XTick = [14.5 46 73 108 142 155.5 169 193 222.5 252.5]; 

%So we don't see the ticks and just use them to place labels
a2.XAxis.TickLength = [0 0];
a2.YAxis.TickLength = [0 0];

%flip your y axis to correspond with heatmap's
a2.YDir = 'Reverse';       

%Add in labels for networks
a2.YTickLabel = {'MF','FP','DMN','Mot','VI','VII','VAs','SAL','SC','CBL'}; 
a2.XTickLabel = {'MF','FP','DMN','Mot','VI','VII','VAs','SAL','SC','CBL'};

%center the tick marks - otherwise leaves out CBL for some reason
ylim(a2, [0.5, size(conn_heatmap.ColorData,1)+.5])         
xlim(a2, [0.5, size(conn_heatmap.ColorData,1)+.5])          






