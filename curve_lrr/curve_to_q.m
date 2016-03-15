function [q,len] = curve_to_q(beta)

[n,T] = size(beta);

v = x_diff(beta);

if n == 1
    len = sum(abs(v))/T;
else  
    len = sum(sqrt(sum(v.*v)))/T;
end

v = v/len;

q = v ./ (max(sqrt(sqrt(sum(v.^2, 1))), 0.0001)' * ones(1, n) )';

