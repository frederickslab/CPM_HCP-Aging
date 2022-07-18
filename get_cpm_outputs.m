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