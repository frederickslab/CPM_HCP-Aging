%% create bar graphs to display and compare median Pearson R of each group's CPM runs/predictive models

close all

param_list = {'ravlt','neon','facename'};
% scan_type_list = {'rfMRI_REST1_AP','rfMRI_REST1_PA','rfMRI_REST2_AP','rfMRI_REST2_PA','tfMRI_CARIT','tfMRI_FACENAME','tfMRI_VISMOTOR'};
scan_type_list = {'REST1_AP','REST1_PA','REST2_AP','REST2_PA','CARIT','FACENAME','VISMOTOR'};

load('../BIG_data_from_CPM_HCP-Aging/all_medianR.mat', 'all_R_arrays');

%% whole group R values (median Pearson correlation vs. behavioral scores across all scans)
fig = figure;
set(gcf, 'Position', [1000, 500, 1500, 300],'color','w');

whole_group_clr = [167 250 186; %rfMRI_REST1_AP
    110 228 137; %rfMRI_REST1_PA
    54 210 90; %rfMRI_REST2_AP
    7 182 48; %rfMRI_REST2_PA
    252 207 157; %tfMRI_CARIT
    239 161 72; %tfMRI_FACENAME
    220 120 6] / 255; %tfMRI_VISMOTOR

% ravlt subplot
sp1 = subplot(1,3,1);
sp1.Position = sp1.Position + [.01 .05 0 -0.1];
b1 = bar(all_R_arrays.ravlt_R.arr_all(:,1), 'facecolor', 'flat');
b1.CData = whole_group_clr;
ax1 = gca; % gca = get current axes
set(ax1,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('RAVLT (Sum of Trials 1-5)');
xtickangle(20);

% neon subplot
sp2 = subplot(1,3,2);
sp2.Position = sp2.Position + [.01 .05 0 -0.1];
b2 = bar(all_R_arrays.neon_R.arr_all(:,1), 'facecolor', 'flat');
b2.CData = whole_group_clr;
ax2 = gca;
set(ax2,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('NEO-N');
xtickangle(20);

% facename subplot
sp3 = subplot(1,3,3);
sp3.Position = sp3.Position + [.01 .05 0 -0.1];
b3 = bar(all_R_arrays.facename_R.arr_all(:,1), 'facecolor', 'flat');
b3.CData = whole_group_clr;
ax3 = gca;
set(ax3,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('FACENAME');
xtickangle(20);

% link y-axes of all subplots
linkaxes([ax1 ax2 ax3], 'y');

% set title for whole subplot
sgtitle('Median Pearson correlation vs. behavioral scores across all scans');

% set x and y labels for all subplots
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Pearson correlation values (R)');
xlabel(han,'Scan type');

% set custom legend for entire figure that labels all seven colors as each
%   scan type!
% [DO THISSSSS!!!]

% add save line (save as png!)


%% sex-based group R values (median Pearson correlation vs. behavioral scores across all scans by sex)

% combine female and male arrays to create stacked bar graphs
ravlt_FM_arr = cat(2, all_R_arrays.ravlt_R.arr_F(:,1),all_R_arrays.ravlt_R.arr_M(:,1));
neon_FM_arr = cat(2, all_R_arrays.neon_R.arr_F(:,1),all_R_arrays.neon_R.arr_M(:,1));
facename_FM_arr = cat(2, all_R_arrays.facename_R.arr_F(:,1),all_R_arrays.facename_R.arr_M(:,1));

fig2 = figure;
set(gcf, 'Position', [1000, 100, 1500, 300],'color','w');

% ravlt subplot
sp1 = subplot(1,3,1);
sp1.Position = sp1.Position + [.01 .05 0 -0.1];
b1 = bar(ravlt_FM_arr, 'facecolor', 'flat'); % DON'T FORGET TO SET THE RED AND BLUE COLORS MANUALLY!!
ax1 = gca; % gca = get current axes
set(ax1,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none','Ylim',[-0.05 0.45]);
title('RAVLT (Sum of Trials 1-5)');
xtickangle(20);

% neon subplot
sp2 = subplot(1,3,2);
sp2.Position = sp2.Position + [.01 .05 0 -0.1];
b2 = bar(neon_FM_arr, 'facecolor', 'flat');
ax2 = gca;
set(ax2,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('NEO-N');
xtickangle(20);

% facename subplot
sp3 = subplot(1,3,3);
sp3.Position = sp3.Position + [.01 .05 0 -0.1];
b3 = bar(facename_FM_arr, 'facecolor', 'flat');
ax3 = gca;
set(ax3,'XTick',1:numel(scan_type_list),'XTickLabel',scan_type_list,'TickLabelInterpreter', 'none');
title('FACENAME');
xtickangle(20);

% link y-axes of all subplots
linkaxes([ax1 ax2 ax3], 'y');

% set title for whole subplot
sgtitle('Median Pearson correlation vs. behavioral scores across all scans by sex');

% set x and y labels for all subplots
han=axes(fig2,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Pearson correlation values (R)');
xlabel(han,'Scan type');

% set custom legend for each sex
% [DO THISSSSS!!!]

% add save line (save as png!)

