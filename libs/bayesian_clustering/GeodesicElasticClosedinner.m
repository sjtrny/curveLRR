function d = GeodesicElasticClosedinner(b_0,b_1)

% input p1 and p2 as 2xn matrices

[m, n] = size(b_0);

q_0 = curve_to_q(b_0);   
q_1 = curve_to_q(b_1);

gam = DynamicProgrammingQ(q_0, q_1, [], []);
gamI = invertGamma(gam);
gamI = (gamI-gamI(1))/(gamI(end)-gamI(1));
b_1_aligned = Group_Action_by_Gamma_Coord(b_1, gamI);
q_1_aligned = curve_to_q(b_1_aligned);

d = sum(sum(q_0.*q_1_aligned))/n;

