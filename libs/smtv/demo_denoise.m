paths = ['common:'];
addpath(paths);

im = double(imread('~/Desktop/11370981_434376496748640_2096913164_n.jpg'))/255;

[m, n, d] = size(im);

images = {reshape(im, m*n, d)'};
good_entries = {ones(1, m*n)};

lambda_1 = 0.015;
lambda_2 = ones(1,1);

tic;
R = get_R(m, n);
toc;

tic;
A = smtv(m*n, 1, images, R, lambda_1, lambda_2, good_entries, 'aniso');
toc;

fused = reshape(A', [m, n, d]);

figure, imshow(fused);