% Loads washington trajectories with lengths less than max_length

n_samples = 2381;

lengths = zeros(n_samples,1);

for k = 1 : n_samples
    
[f1, ~, ~, ~] = textread(['data/washington/features_' num2str(k) '.dat'], '%f %f %f %f', 'headerlines', 1);

lengths(k) = size(f1,1);
    
end

curve_X = zeros(4, 969, n_samples);

for k = 1 : n_samples;
    
    [f1, f2, f3, f4] = textread(['data/washington/features_' num2str(k) '.dat'], '%f %f %f %f', 'headerlines', 1);
    
    curve_X(1, 1:lengths(k), k) = f1;
    curve_X(2, 1:lengths(k), k) = f2;
    curve_X(3, 1:lengths(k), k) = f3;
    curve_X(4, 1:lengths(k), k) = f4;
end


% LOAD GROUND TRUTH LABELS

fid = fopen('data/washington/relevance_judgment.txt');

A = fscanf(fid, '%d %s %d %d\n');

fclose(fid);

all_cluster_data = reshape(A, 5, size(A,1)/5)';

ind_mapping = all_cluster_data(:,[1 4]);

% graph = sparse(ind_mapping(:,1), ind_mapping(:,2), ones(size(ind_mapping,1), 1), 2381, 2381);
% graph = graph + graph';

ground_truth = zeros(2381, 1);

n_classes = 0;

for k = 1 : size(ind_mapping, 1)
    
    cur_ind = ind_mapping(k, 1);
    nbor_ind = ind_mapping(k, 2);
    
    if (ground_truth(cur_ind) == 0)
        % if not assigned a class
        
        if (ground_truth(cur_ind) ~= ground_truth(nbor_ind))
             % ground_truth something below first assign to that class
            ground_truth(cur_ind) = ground_truth(nbor_ind);

        else
           % hits itself
            % then there are no inds below it that fit the same class and
            % we need to create a new class
            n_classes = n_classes + 1;
            ground_truth(cur_ind) = n_classes;
            
        end
        
    end
    
end


class_totals = zeros(n_classes, 1);

for k = 1 : nbor_ind
    
    class_totals(ground_truth(k)) = class_totals(ground_truth(k)) + 1;
    
end

clear A all_cluster_data ans cur_ind f1 f2 f3 f4 fid ind_mapping k nbor_ind

save('data/washington');
