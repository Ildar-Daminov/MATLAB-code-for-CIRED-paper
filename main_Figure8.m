clc; 
clear all 
close all

%% Purpose
% This script builds the Figure 8 (Energy transfer as a function of ageing
% limit and calendar life)

%% Load data from previous calculations
load('ONAN_interm_results.mat')

%% 
% Find the index  in pu 
for i=1:length(Ageing_limit)
    index(i)=1440/Ageing_limit(i);
end

% Round the index to get the integer 
index=round(index);

% Change the variable name 
Energy_day=Energy_result;

% Find the time in % of possible operation of transformer at given ageing limit 
time_percent=index/1440*100;

% Normalize the energy tranfer for 1 day  relatively to the energy transfer at ageing
% limit =1pu
Energy_day_percent=Energy_day/Energy_day(10)*100;

% Find the  energy transfer for the entire life (pu*min)
Energy_all_life=(time_percent.*Energy_day)/100;

% Convert from pu*min to pu*h
Energy_all_life=(Energy_all_life/60);

% Normalize the energy tranfer for entire life   relatively to the energy transfer at ageing
% limit =1pu
Energy_all_life=(Energy_all_life/Energy_all_life(10))*100;

% Change the variable 
AAF=Ageing_limit;

% This generates the actual grid of x and y values (future  x-axis, y-axis).
[X_aaf,Y_time] = meshgrid (AAF,time_percent); 
%% Generating Z Data (Energy transfer)

% Create the first point with coordinates 0 and 0
point1 = [0, 0];
x1 = point1(1);
y1 = point1(2);

% For each ageing limit (AAF) find the point 2 and the slope of the line
% (from point 1 to point 2)
for i=1:length(AAF)
    point2 = [time_percent(i), Energy_all_life(i)];
    x2 = point2(1);
    y2 = point2(2);
    slope(i) = (y2 - y1) ./ (x2 - x1);
end

% Find the energy transfer for each point at surface
for i=1:length(AAF)
    for j=1:length(AAF)
        Z_energy(j,i)=slope(i)*time_percent(j);
    end
end

% For those points where  aditionnal energy transfer is impossible e.g
% because all insulation resource is consumed at given ageing limit, it is
% neccesary to keep the last value for energy transfer. 
for i=1:length(AAF)
    index=find(Z_energy(:,i)>Energy_all_life(i));
    Z_energy(index,i)=Energy_all_life(i);
%     Z_energy(index,i)=NaN;
end

%% Constractuing the surface 
 createfigure8(X_aaf, Y_time, Z_energy, AAF, time_percent, Energy_all_life)
