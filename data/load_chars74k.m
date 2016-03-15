n_chars = 62;

n_samples = 55;


curve_X = zeros(2, 365, n_chars*n_samples);

count = 1;

for i = 1 : n_chars
    
    for k = 1 : n_samples
        
        run(['data/chars74k/Trj/Sample' num2str(i,'%03d') '/img' num2str(i,'%03d') '_' num2str(k,'%03d') '.m']);
        
        curve_X(1, 1:length(rows{1}), count) = rows{1}';
        curve_X(2, 1:length(rows{1}), count) = cols{1}';
        
        count = count + 1;
        
    end
    
end

ground_truth = reshape(repmat( 1:n_chars, n_samples, 1), 1, n_chars*n_samples);

clear cols rows i k count

save('data/chars74k');