function [ v, dist ] = inverse_exp( b_0, b_1 )
%INVERSE_EXP Summary of this function goes here
%   Detailed explanation goes here

[m, n] = size(b_0);

% b_0_centred = b_0 - repmat(calculateCentroid(b_0), 1, m);
% b_1_centred = b_1 - repmat(calculateCentroid(b_1), 1, m);

q_0 = curve_to_q(b_0);   
q_1 = curve_to_q(b_1);

gam = DynamicProgrammingQ(q_0, q_1, [], []);
gamI = invertGamma(gam);
gamI = (gamI-gamI(1))/(gamI(end)-gamI(1));
b_1_aligned = Group_Action_by_Gamma_Coord(b_1, gamI);
q_1_aligned = curve_to_q(b_1_aligned);

inner_prod = sum(sum(q_0.*q_1_aligned))/n;

dist = acos(inner_prod);

if inner_prod>1
    inner_prod=1;
end
u = q_1_aligned - inner_prod * q_0;
normu = sqrt(sum(sum(u.*u))/n);
if normu>10^-4
    v = u * acos(inner_prod) / normu;
else
    v = zeros(m, n);
end

% v2 = dist * csc(dist) * (q_1_aligned - trace(q_0' * q_1_aligned) * q_0 );

end

