function [  ] = play_sign( X, sign_n )
%PLAY_SIGN Summary of this function goes here
%   Detailed explanation goes here

channel = 12;

for k = 1 : size(X,2)
    
    scatter3( X(channel,k,sign_n), X(channel,k,sign_n), X(channel,k,sign_n));
    
    pause(0.02);
end


end

