%% create bar graphs to display and compare median Pearson R of each group's CPM runs/predictive models

close all

param_list = {'ravlt_L','ravlt_IR','neon','facename'};
% scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};
scan_type_list = {'REST1_AP','REST1_PA','REST2_AP','REST2_PA','CARIT','FACENAME','VISMOTOR'};

load('../BIG_data_from_CPM_HCP-Aging/all_medianR.mat', 'all_R_arrays');

%% whole group R values (median Pearson correlation vs. behavioral scores across all scans)
fig = figure();
% set(gcf, 'Position', [1000, 500, 2000, 250],'color','w');
set(gcf, 'Position', [1000, 500, 1500, 350],'color','w'); % fullforpptsize
t = tiledlayout(1,4,'TileSpacing','compact');

whole_group_clr = [167 250 186; %rfMRI_REST1_AP
    110 228 137; %rfMRI_REST1_PA
    54 210 90; %rfMRI_REST2_AP
    7 182 48; %rfMRI_REST2_PA
    252 207 157; %tfMRI_CARIT
    239 161 72; %tfMRI_FACENAME
    220 120 6] / 255; %tfMRI_VISMOTOR

% ravlt_L subplot
nexttile
b1 = bar(all_R_arrays.ravlt_L_R.arr_all(:,1), 'facecolor', [0.4940 0.1840 0.5560]);
% b1.CData = whole_group_clr;
ax1 = gca; % gca = get current axes
set(ax1,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('RAVLT Learning (Sum of Trials 1-5)');
xtickangle(20);

% ravlt_IR subplot
nexttile
b2 = bar(all_R_arrays.ravlt_IR_R.arr_all(:,1), 'facecolor', [0.4940 0.1840 0.5560]);
% b2.CData = whole_group_clr;
ax2 = gca; % gca = get current axes
set(ax2,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('RAVLT Immediate Recall (Trial 7 [Short Delay])');
xtickangle(20);

% facename subplot
nexttile
b4 = bar(all_R_arrays.facename_R.arr_all(:,1), 'facecolor', [0.4940 0.1840 0.5560]);
% b4.CData = whole_group_clr;
ax4 = gca;
set(ax4,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('FACENAME');
xtickangle(20);

% neon subplot
nexttile
b3 = bar(all_R_arrays.neon_R.arr_all(:,1), 'facecolor', [0.4940 0.1840 0.5560]);
% b3.CData = whole_group_clr;
ax3 = gca;
set(ax3,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('NEO-N');
xtickangle(20);

% link y-axes of all subplots
linkaxes([ax1 ax2 ax3 ax4], 'y');

% % set title for whole subplot
% sgtitle('Median Pearson correlation vs. behavioral scores across all scans');

% % set x and y labels for all subplots
% han=axes(fig,'visible','off'); 
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Pearson correlation values (R)');
% xlabel(han,'Scan type');

% set custom legend for each scan type
% lgd = legend(scan_type_list,'Location', 'eastoutside','Interpreter','none');

% save figure
saveas(fig,'../cpm_figures/R_comparison_all_subjs.png')

%% sex-based group R values (median Pearson correlation vs. behavioral scores across all scans by sex)

% combine female and male arrays to create stacked bar graphs
ravlt_L_FM_arr = cat(2, all_R_arrays.ravlt_L_R.arr_F(:,1),all_R_arrays.ravlt_L_R.arr_M(:,1));
ravlt_IR_FM_arr = cat(2, all_R_arrays.ravlt_IR_R.arr_F(:,1),all_R_arrays.ravlt_IR_R.arr_M(:,1));
neon_FM_arr = cat(2, all_R_arrays.neon_R.arr_F(:,1),all_R_arrays.neon_R.arr_M(:,1));
facename_FM_arr = cat(2, all_R_arrays.facename_R.arr_F(:,1),all_R_arrays.facename_R.arr_M(:,1));

fig2 = figure();
% set(gcf, 'Position', [1000, 100, 2000, 250],'color','w');
set(gcf, 'Position', [1000, 100, 1500, 350],'color','w'); % fullforppt size
t = tiledlayout(1,4,'TileSpacing','compact');

% ravlt_L subplot
nexttile
b1 = bar(ravlt_L_FM_arr, 'facecolor', 'flat'); 
b1(1).FaceColor = 'r';
b1(2).FaceColor = 'b';
ax1 = gca; % gca = get current axes
set(ax1,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none','Ylim',[-0.05 0.45]);
title('RAVLT Learning (Sum of Trials 1-5)');
xtickangle(20);

% ravlt_IR subplot
nexttile
b2 = bar(ravlt_IR_FM_arr, 'facecolor', 'flat'); 
b2(1).FaceColor = 'r';
b2(2).FaceColor = 'b';
ax2 = gca; % gca = get current axes
set(ax2,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none','Ylim',[-0.05 0.45]);
title('RAVLT Immediate Recall (Trial 7 [Short Delay])');
xtickangle(20);

% facename subplot
nexttile
b4 = bar(facename_FM_arr, 'facecolor', 'flat');
b4(1).FaceColor = 'r';
b4(2).FaceColor = 'b';
ax4 = gca;
set(ax4,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('FACENAME');
xtickangle(20);

% neon subplot
nexttile
b3 = bar(neon_FM_arr, 'facecolor', 'flat');
b3(1).FaceColor = 'r';
b3(2).FaceColor = 'b';
ax3 = gca;
set(ax3,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('NEO-N');
xtickangle(20);

% link y-axes of all subplots
linkaxes([ax1 ax2 ax3 ax4], 'y');

% % set title for whole subplot
% sgtitle('Median Pearson correlation vs. behavioral scores across all scans by sex');

% % set x and y labels for all subplots
% han=axes(fig3,'visible','off'); 
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Pearson correlation values (R)');
% xlabel(han,'Scan type');

% set custom legend for each sex
lgd = legend(b3, {'F','M'},'Location', 'eastoutside');

% save figure
saveas(fig2,'../cpm_figures/R_comparison_by_sex.png')