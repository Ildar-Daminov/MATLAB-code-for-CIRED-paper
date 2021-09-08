function [PUL]=PUL_to_1min(PUL,t)
%% Purpuse
% This function allows converting data from different resolution (t) into 1-
% minute resolution. 
% -------------------------------------------------------------------------
% PUL - input and output data
% t - a time step of PUL in minutes (5,15,60)

% Example: if PUL is given in hour format e.g. 24 hours [24x1] then
% [PUL_minute]=PUL_to_1min(PUL_hour,60)
% -------------------------------------------------------------------------
N=length(PUL)*60;
n=fix(N/t);
Pt=zeros(N,1);
for i=1:n
    Pt(((i-1)*t+1):i*t)=PUL(i);
end
PUL=Pt;
end
