 function [final_c,final_cn]=WishartCluster(d,theta_vect,r0,s0,xi,iter,M,S)
 % function for clustering given inner product matrix S
 % input parameters:
 % d:
 %theta_vect
 %r0,s0:
 %xi
 % M
 %S: inner product matrix
 dispmcmc = 1;
 
 if isempty(iter)
     iter = 2000;
 end;
 
N = size(S,1);
J = length(theta_vect);


dd=1.000;

    
    pp = 1;
    fd = 1;
    final_B = zeros(N,N);
    record = 0;
    final_rd = 0;
    
    % s is assignment
    for i=1:N
       c(i) = mod(i,M) + 1;
    end;

    for i=1:M
        cn(i) = sum(c==i);
    end;

while (iter)
    % update parameters
     d =dd*d;
    iter = iter - 1;
    % update Theta
    log_lktheta = zeros(1,J);
    for j=1:J
%             detPhi = 1;
%             sumSB = 0;
%             theta = theta_vect(j); % for each theta;
%             for i = 1:M
%                 detPhi = detPhi*(1/(1+theta*cn(i)));
%                 Ib = zeros(N,1);
%                 Ib(find(c==i)) = 1;
%                 sumSB=sumSB+(theta/(1+cn(i)*theta))*Ib'*S*Ib;
%             end;
%             log_detPhi = (d/2)*log(detPhi);
%             tr_PhiS = (trace(S) - sumSB);
%             log_trPhiS = (log(tr_PhiS + s0) + log(d/2))*(-(N+r0)*d/2);
%             log_lkhood = log_trPhiS + log_detPhi;
%             log_lktheta(j) = log_lkhood;
%             
            logPhi = 0;
            sumSB = 0;
            theta = theta_vect(j);
            
            for i=1:M
                logPhi = logPhi + log(1+theta*cn(i));
                Ib = zeros(N,1);
                Ib(find(c==i)) = 1;
                sumSB=sumSB+(theta/(1+cn(i)*theta))*Ib'*S*Ib;
            end;
            
            log_lkhood = (d/2)*(-logPhi-(N+r0)*(log(d/2)+log(trace(S)-sumSB+s0)));
            log_lktheta(j) = log_lkhood;
    end
        log_lktheta = log_lktheta - max(log_lktheta); % prior of theta is uniform
        lktheta = exp(log_lktheta);
        lktheta = lktheta/sum(lktheta);
        theta_idx = discreternd(lktheta, 1);
         %final theta
        theta = theta_vect(theta_idx);
         
         % clear parameters
         lkhoodp = 0;
         pb = 0;
    %update B
    for j=1:N
      cn(c(j)) = cn(c(j))-1; % update distribution
      % remove cluster associated with none elements
      if(cn(c(j))==0)
          oldind = c(j);
          % move last one to the removed space
          cn(oldind) = cn(M);
          c(c==M) = oldind;
          M = M-1;
      end;
      catp = zeros(1,M+1);
      log_p = zeros(1,M+1);
    
      for k=1:M
          % temp clustering
            tmpc = c;
            tmpc(j) = k;
            tmpcn = cn;
            tmpcn(k) = tmpcn(k)+1;
      
             logPhi = 0;
             sumSB = 0;
            for i = 1:M
                logPhi = logPhi + log(1+theta*cn(i));
                Ib = zeros(N,1);
                Ib(find(tmpc==i)) = 1;
                sumSB=sumSB+(theta/(1+tmpcn(i)*theta))*Ib'*S*Ib;
                
            end;
            log_lkhood = (d/2)*(-logPhi-(N+r0)*(log(d/2)+log(trace(S)-sumSB+s0)));
            
            %log_p(k) = log((cn(k)/(N-1+xi)))+log_lkhood;
            log_p(k) = log_lkhood;
            % keyboard;
      end
            tmpc = c;
            tmpc(j) = M+1;
            tmpcn = cn;
            tmpcn(M+1) = 1;
            
            detPhi = 1;
            sumSB = 0;
            for i = 1:M+1
                detPhi = detPhi*(1/(1+theta*tmpcn(i)));
                Ib = zeros(N,1);
                Ib(find(tmpc==i)) = 1;
                sumSB=sumSB+(theta/(1+tmpcn(i)*theta))*Ib'*S*Ib;
            end;
            log_detPhi = (d/2)*log(detPhi);
            tr_PhiS = (trace(S) - sumSB);
            log_trPhiS = (log(tr_PhiS + s0) + log(d/2)) *(-(N+r0)*d/2);
            log_lkhood = log_trPhiS + log_detPhi;
            log_p(M+1) = log_lkhood;
            %log_catp(M+1) = log((xi/(N-1+xi))) + log_lkhood;

            log_p = log_p - max(log_p); % normalize log_lkhood function;
            lkhoodp = exp(log_p);
            lkhoodp = lkhoodp/sum(lkhoodp);

%             clear logpb pb catp;
%             for k=1:M
%                 logpb(k) = d*log(cn(k)/(N-1+xi));
%             end;
%             logpb(M+1) = d*log(xi/(N-1+xi));
%             if(length(logpb)>length(lkhoodp))
%                 keyboard;
%             end;
%             
%             logpb = logpb - max(logpb);
%             pb = exp(logpb)./sum(exp(logpb));
%             
%             catp = pb.*lkhoodp;
%             
            for k=1:M
                catp(k) = (cn(k)/(N-1+xi))*lkhoodp(k); % no d here
            end;
            catp(M+1) = (xi/(N-1+xi))*lkhoodp(M+1); % no d here

           % log_catp = log_catp + abs(maxlogp);
           % catp = exp(log_catp);
            c(j) = discreternd(catp, 1);
            % if cj falls in the new category
            if c(j)>M
                M = M+1;
                cn(M) = 1;
            else
                cn(c(j)) = cn(c(j)) + 1;
            end;
    end
    
    record(pp) = M;
    if(dispmcmc == 1)
%      disp(M);
    end;
    
    % disp(cn(1:M));
    pp = pp+1;
    
      if(iter<2000) % for last 100 iterations
        tmp_B = calculate_B(c,N);
        final_B = final_B + tmp_B;
        final_rd(fd) = M;
        fd = fd+1;
      end;
    
end;
% [f_c,f_cn] = BtoCluster(final_B,N);
% M = length(f_cn);

ddd = hist(final_rd,1:20);
[~,cluster_mod] = max(ddd);
% cluster_nm = M

[final_c,final_cn] = BtoCluster_test(final_B,N,cluster_mod);
 
% figure, hist(final_rd,max(1,(M-4)):(M+6));
