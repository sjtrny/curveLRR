
function Xn = ReSampleCurve(X,N)

    T = length(X);
    del(1)=0;
    for r = 2:T
        del(r) = norm(X(:,r) - X(:,r-1));
    end
    cumdel = cumsum(del)/sum(del);
    
    %keyboard;
    
    
    newdel = [1:N]/(N);
    
    Xn(1,:) = spline(cumdel,X(1,1:T),newdel);
    Xn(2,:) = spline(cumdel,X(2,1:T),newdel);
    q = curve_to_q(Xn);
    qn = ProjectC(q);
    Xn = q_to_curve(qn);
    
    %Xn(3,:) = spline(cumdel,X(3,2:T),newdel);
    
%     figure(1); clf;
%     z = plot3(X(1,:),X(2,:),X(3,:),'r');
%     set(z,'LineWidth',[2]);
%     axis equal;
%     hold on;
%     z = plot3(Xn(1,:),Xn(2,:),Xn(3,:),'b');
%     set(z,'LineWidth',[2]);
%     pause;