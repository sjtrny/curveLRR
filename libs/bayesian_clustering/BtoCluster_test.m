function [c,cn,thrd] = BtoCluster_test(B,N,realCN)
% function for converting partition matrix B to cluster vector c and cn
M = 1;
c = zeros(1,N);
idx = 1:N;
cn = [];

max_ele = B(1,1);

thrd = 1;
tt =1;
while (thrd < max_ele)
    thrd = thrd+1;
M = 1;
c = zeros(1,N);
idx = 1:N;
cn = [];

for i=1:N
    if(idx(i)>0)
       tmp_v = B(idx(i),:);
       c(find(tmp_v>thrd)) = M;
       idx(find(tmp_v>thrd)) = 0; % delete current clustering;

       cn(M) = length(find(tmp_v>thrd));

        M = M + 1;
    end;
end;
if(length(cn)==realCN)
    record_td(tt) = thrd;
    tt = tt+1;
end;

end;


M = 0;
c = zeros(1,N);
idx = 1:N;
cn = [];

thrd =  max(record_td(2:end));


for i=1:N
    if(idx(i)>0)
        M = M +1;
       tmp_v = B(idx(i),:);
       c(find(tmp_v>=thrd)) = M;
       if(length(find(c==M)) ~= length(find(tmp_v>=thrd)))
           keyboard;
       end;
       
       idx(find(tmp_v>=thrd)) = 0; % delete current clustering;

       
       cn(M) = length(find(c==M));
       
       %special cases;
       if(length(find(idx>0)) + sum(cn)>79)
           MM = zeros(1,M);
           for tn = 1:M
           MM(tn) = length(find(c==tn));
           end;
           cn = MM;
       end;
       
    end;
end;