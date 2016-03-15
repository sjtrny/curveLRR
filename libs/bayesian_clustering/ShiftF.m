function pn = ShiftF(p,tau)

[n,T] = size(p);
if(tau == 0)
    pn = p;
    return;
end

if tau > 0
    pn(:,1:T-tau) = p(:,tau+1:T);
    pn(:,T-tau+1:T) = p(:,1:tau);
else
    t = abs(tau)+1;
    pn(:,1:T-t+1) = p(:,t:T);
    pn(:,T-t+2:T) = p(:,1:t-1);
end