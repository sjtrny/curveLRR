load mixoutALL_shifted.mat

% A
traj = mixout{1, 10};

pos = zeros(2, size(traj,2));

cur_pos = [0; 0];

for k = 1 : size(traj,2)
    
    cur_pos = cur_pos + traj(1:2, k);
    
    pos(:, k) = cur_pos;
end

figure, scatter(pos(1,:), pos(2,:));
print(gcf, '-depsc2', 'char_scatter_a.eps');

figure, plot(traj(1:2, :)')
print(gcf, '-depsc2', 'char_plot_a.eps');

% B
traj = mixout{1, 100};

pos = zeros(2, size(traj,2));

cur_pos = [0; 0];

for k = 1 : size(traj,2)
    
    cur_pos = cur_pos + traj(1:2, k);
    
    pos(:, k) = cur_pos;
end

figure, scatter(pos(1,:), pos(2,:));
print(gcf, '-depsc2', 'char_scatter_b.eps');

figure, plot(traj(1:2, :)')
print(gcf, '-depsc2', 'char_plot_b.eps');

% C
traj = mixout{1, 193};

pos = zeros(2, size(traj,2));

cur_pos = [0; 0];

for k = 1 : size(traj,2)
    
    cur_pos = cur_pos + traj(1:2, k);
    
    pos(:, k) = cur_pos;
end

figure, scatter(pos(1,:), pos(2,:));
print(gcf, '-depsc2', 'char_scatter_c.eps');

figure, plot(traj(1:2, :)')
print(gcf, '-depsc2', 'char_plot_c.eps');



close all

