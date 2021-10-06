clc
clear all
close all
%% This script allows drawing the figure 6
% Use Section 1 to estimate the energy transfer as a function
% of ageing limit. (data generation)

% Otherwise, you can dircetly launch section 2 to construct the figure "ageing 
% limit vs Energy transfer" from precalculated data.('ONAN_interm_results.mat')

% Section 3 draws the figure: Energy transfer as a function of time

% Section 4 prepares the data for Figure 8 
%% Section 1: Generation of data
% Initial data 
TIM=linspace(1,1440,1440)'; % time in minutes for 1 day
Temperature=-50:1:50;       % Full range of ambient temperatures
Ageing_limit=0.1:0.1:12.7;  % Range of Ageing_limits 
AMB=linspace(20,20,24)';    % Fixed ambient temperature, hour time step

% Finding the energy transfer for each ageing limit
for i=1:length(Ageing_limit) % for ageing limit
    
    % Solve the optimization problem for 1  day
    [Energy_limit,HST_limit,AEQ_limit,TOT_limit,Energy]=optimal_energy_limitFig6(AMB,Ageing_limit(i));
    
    % Save energy transfer. So far, units are  pu*1min but later we will
    % normalize them
    Energy_result(i)=Energy;
    
    % Energy limit (loading profile of transformer in pu)
    PUL_result(1:1440,i)=Energy_limit;
    
    % Loss of Life results
    LoL_result(i)=AEQ_limit;
    
    % caclulate the ageing acceleration factor (DL)
    for m=1:length(HST_limit)
        DL(m,:) = (2^((HST_limit(m)-98)/6));
    end
    
    % Calculate value of cummulated ageing at each moment
    Current_ageing=0;
    for j=1:length(DL)
        Current_ageing(j)=Current_ageing(end)+DL(j);
    end
    
    %Save the result of cummulated ageing for given ageing limit (i)
    Current_ageing_result(1:1440,i)=Current_ageing;
    i % show the iteration
end
%% Section 2: Construct the figure ageing limit vs Energy transfer 
clear;clc;close all
% Load the results from previous section
load('ONAN_interm_results.mat')


% Choose the calendar life left (see cases in Table 1 of the paper)
studied_case=1; % 1,2 or 3

if studied_case==1
    % I case
    calendar_time_left=50;   % 50%
    insulation_time_left=70; % 70%
    
elseif studied_case==2
    % II case
    calendar_time_left=50;   % 50%
    insulation_time_left=50; % 70%
    
elseif studied_case==3
    % III case
    calendar_time_left=50;   % 50%
    insulation_time_left=30; % 70%
else
    error('Check the value of studied_case. It shoul be 1,2 or 3')
end

% Find the ratio (optimal ageing limit)
ratio=insulation_time_left/calendar_time_left;

% Find the calendar life in minutes of days
calendar_time_left_min=calendar_time_left*1440/100;

% Find the index which shows how fast insulation life left will be consumed at
% given ageing limit
for i=1:length(Ageing_limit)
    index(i)=(insulation_time_left*1440/100)/Ageing_limit(i);
end

% Round the index to get an integer (approximation!)
index=round(index);

% Find time for which insulation resource can be used. 
time_percent=(index./1440); % in pu
% Note that we calculate it relatively to 1 day 1440. Units are pu!

% Find how much energy is transfered for each ageing limit
for i=1:length(Ageing_limit)
    if index(i)>calendar_time_left_min
        ind=calendar_time_left_min;
    else
        ind=index(i);
    end
    Energy_day(i)=ind/calendar_time_left_min*sum(PUL_result(:,i));
end

% Energy_day=Energy_result;

% Normalize the energy transfer relatively to ageing limit =1 pu
Energy_day_percent=Energy_day/Energy_day(10)*100;

plot(Ageing_limit,Energy_day_percent)
ylabel('Energy, % of Energy at Ageing limit=1')
xlabel('Ageing limit(AAF), pu')

% time_percent=index/1440*100;
%% Section 3:Energy transfer as a function of time (additonal figure)
% Assumption: we assume that for each day the loading profile (and thus energy
% transfer) are the same. Thus, we can estimate how much energy can be
% transfered during the entire life if we multiply the energy trasnfer for
% 1 day on possible operation at given ageing limit (in per units!)
Energy_all_life=time_percent.*Energy_day;

% Normalize the energy transfer for each ageing limit (relatively to ageing
% limit = 1pu)
Energy_all_life=Energy_all_life./Energy_all_life(10)*100;

% Convert time_percent from pu into percent
time_percent=time_percent*100;

% Set the intitial position 
start=[0 0];

figure % create the figure
hold on 

% Draw a figure: Energy transfer as a function of time (for each ageing
% limit)
for i=1:length(Ageing_limit)
    name=['Ageing limit ',num2str(Ageing_limit(i))];
   plot([50 50+time_percent(i)], [30 30+Energy_all_life(i)],'DisplayName',name)
end

ylabel('Energy, % of Energy at Ageing limit=1')
xlabel('Time, % of Time at Ageing limit=1')
