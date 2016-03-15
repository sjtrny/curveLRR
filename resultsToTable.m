mean_col = (1 - mean([missrate_kmeans(1:k), missrate_dtw(1:k), missrate_lrr(1:k), missrate_bayes(1:k), missrate_curve(1:k)])) * 100;

median_col = (1 - median([missrate_kmeans(1:k), missrate_dtw(1:k), missrate_lrr(1:k), missrate_bayes(1:k), missrate_curve(1:k)])) * 100;

min_col = (1 - min([missrate_kmeans(1:k), missrate_dtw(1:k), missrate_lrr(1:k), missrate_bayes(1:k), missrate_curve(1:k)])) * 100;

max_col = (1 - max([missrate_kmeans(1:k), missrate_dtw(1:k), missrate_lrr(1:k), missrate_bayes(1:k), missrate_curve(1:k)])) * 100;

std_col = std([missrate_kmeans(1:k), missrate_dtw(1:k), missrate_lrr(1:k), missrate_bayes(1:k), missrate_curve(1:k)]) * 100;

mean_time = mean([runtime_kmeans(1:k), runtime_dtw(1:k), runtime_lrr(1:k), runtime_bayes(1:k), runtime_curve(1:k)]);

names = {'kmeans', 'DTW', 'LRR', 'Bayesian', 'CurveLRR'};


for table_cnt = 1 : 5

    fprintf('%s & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.2f \\\\ \n', names{table_cnt}, mean_col(table_cnt), median_col(table_cnt), min_col(table_cnt), max_col(table_cnt), std_col(table_cnt), mean_time(table_cnt));
    
end


% mean_col_smooth = (1 - mean([missrate_kmeans_smooth(1:k), missrate_dtw_smooth(1:k), missrate_lrr_smooth(1:k), missrate_bayes_smooth(1:k), missrate_curve_smooth(1:k)])) * 100;
% 
% median_col_smooth = (1 - median([missrate_kmeans_smooth(1:k), missrate_dtw_smooth(1:k), missrate_lrr_smooth(1:k), missrate_bayes_smooth(1:k), missrate_curve_smooth(1:k)])) * 100;
% 
% min_col_smooth = (1 - min([missrate_kmeans_smooth(1:k), missrate_dtw_smooth(1:k), missrate_lrr_smooth(1:k), missrate_bayes_smooth(1:k), missrate_curve_smooth(1:k)])) * 100;
% 
% max_col_smooth = (1 - max([missrate_kmeans_smooth(1:k), missrate_dtw_smooth(1:k), missrate_lrr_smooth(1:k), missrate_bayes_smooth(1:k), missrate_curve_smooth(1:k)])) * 100;
% 
% std_col_smooth = std([missrate_kmeans_smooth(1:k), missrate_dtw_smooth(1:k), missrate_lrr_smooth(1:k), missrate_bayes_smooth(1:k), missrate_curve_smooth(1:k)]) * 100;
% 
% mean_time_smooth = mean([runtime_kmeans_smooth(1:k), runtime_dtw_smooth(1:k), runtime_lrr_smooth(1:k), runtime_bayes_smooth(1:k), runtime_curve_smooth(1:k)]);
% 
% 
% for table_cnt = 1 : 5
% 
%     fprintf('%s & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.1f\\%% & %.2f \\\\ \n', names{table_cnt}, mean_col_smooth(table_cnt), median_col_smooth(table_cnt), min_col_smooth(table_cnt), max_col_smooth(table_cnt), std_col_smooth(table_cnt), mean_time_smooth(table_cnt));
%     
% end
