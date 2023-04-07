function [Xmissing,tmissing,ridx] = helperRandomMissing(X,t,ndecim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newidx = (1:ndecim:length(t));
nperiods = 3;
ridx = newidx + randi(nperiods,1,length(newidx));
ridx(ridx > length(t)) = [];
tmissing = t(ridx);
Xmissing = X(ridx);

end

