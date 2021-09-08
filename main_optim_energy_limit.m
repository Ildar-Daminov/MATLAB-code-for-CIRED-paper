clc
clear all
close all
%% Purpose: 
% This script finds the optimal loadings profile maximizing the energy
% transfer at the given horizon

%% The choice of horizon and ambient temperature  
% Set the horizon of optimization problem
days=7; % use days=1 or days=7 for this case study!

% Set a variable ambient temperature for 7 days
load('Variable_ambient_temperature.mat')

if days==1
    AMB=AMB(1:24,1);
else % if days==7
    % do nothing 
end

% Set a constant (rated) ambient temperature 
% AMB=linspace(20,20,days*24)';

%% Solving the optimization problem
% INPUT: AMB and Ageing limit in pu
% OUTPUT: Energy_limit - optimal load profile; Energy - energy transfer;
% exitflag - indicator 1: optimum found
Ageing_limit=1;
[Energy_limit,Energy,exitflag]=optimal_energy_limit(AMB,Ageing_limit);
%% Postanalysis 
% Set the nominal rating of transformer, kVA
Nominal_rating=1000;
% Calculate the temprature and ageing 
[HST_max,TOT_max,HST,TOT,AEQ,Current_ageing]=distrbution_transformer_optim(Energy_limit,AMB);

% Convert optimal load profile from a hour resulution to 1-min resolution
PUL_optim=PUL_to_1min(Energy_limit*Nominal_rating,60);

% Preparing the datetime (x-axis) for figures
start_date = datetime('01-Jan-2021 00:00:00');
tstart=1;
timestep=1;   
tend=1;
dt=0.001;
dt(end+1:length(PUL_optim)+1)=tstart:timestep:tend*length(PUL_optim);dt=dt';
time_IEC=start_date+minutes(dt);

% Setting loading, cumulative ageing at t=00:00
PUL_optim(2:length(PUL_optim)+1)=PUL_optim;
Current_ageing(2:length(Current_ageing)+1)=Current_ageing;
Current_ageing(1,1)=0;
subplot(2,1,1)

% plotting optimal load profile 
plot(time_IEC,PUL_optim,'linewidth',2)
% prepare vector for nominal rating 
Nominal_rating=linspace(Nominal_rating,Nominal_rating,length(PUL_optim))';
hold on 
% plotting nominal rating
plot(time_IEC,Nominal_rating,'--k','linewidth',2)
ylabel('Transflormer loading, kVA')
xlabel('Time')
grid on
yyaxis right
% Adjust x axis for ambient temperature
time_AMB=time_IEC(2):hours(1):time_IEC(end);
%plot ambient temperature 
plot(time_AMB,AMB,'--r','linewidth',2)
ylabel('Ambient temperature, degC')

subplot(2,1,2)
% ploting cumulative ageing 
plot(time_IEC,Current_ageing,'linewidth',2)
ylabel('Cummulative ageing, pu')
xlabel('Time')
yyaxis right 

% Setting hot spot temperature and top-oil temperature at t=00:00
HST(2:length(HST)+1)=HST;
TOT(2:length(TOT)+1)=TOT;

% ploting hot spot temperature
plot(time_IEC,HST,'linewidth',2)
hold on
% ploting top-oil temperature
plot(time_IEC,TOT,'linewidth',2)
ylabel('Temperature, ℃')
grid on
