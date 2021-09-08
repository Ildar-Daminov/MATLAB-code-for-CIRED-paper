clc
clear all
close all
%% Purpose of the script: 
% This script finds an random hourly load profile complying with temperature and
% ageing limitations

%% Initial data
% Setting the ambient temperature = 20 degC for  24 hours
AMB=linspace(20,20,24)';
% Create a few variables for time throughout the day
nHours = numel(AMB);
Time = (1:nHours)';
%% Define the optimization problem and the optimization variables
Rand_load_profile=optimproblem('ObjectiveSense','maximize'); 
% Load_profile variable for 24 hours with upper bound = 1.5 pu
Load_profile = optimvar('Load_profile',nHours,'LowerBound',0,'UpperBound',1.5);
%% Define the objective function
% Energy_transfer maximization;
Energy_transfer = sum(Load_profile);

% set objective
Rand_load_profile.Objective = Energy_transfer;

%% Define the problem constraints
% Using the function distrbution_transformer_random_load.m as function to
% generate state variables
[HST_max,TOT_max,AEQ,~,~]=fcn2optimexpr(@distrbution_transformer_random_load,Load_profile,AMB);
% Ageing should be equal to normal ageing (1 pu)
Rand_load_profile.Constraints.ageing=AEQ==1;
% Hot spot temperature must be below or equal 120 degC
Rand_load_profile.Constraints.hst=HST_max<=120;
% Top oil temperature must be below or equal to 105 degC
Rand_load_profile.Constraints.tot=TOT_max<=105;

% Setting random loading limit constraints between to limits
low_limit = 0.7;
high_limit = 1.5;
loading_limit = (high_limit-low_limit).*rand(24,1) + low_limit;

% Setting the ramp constraints for loadings
dif=0.1;
Rand_load_profile.Constraints.Load=Load_profile<=loading_limit;
Rand_load_profile.Constraints.dif1=Load_profile(1)-Load_profile(2)<=dif;
Rand_load_profile.Constraints.dif2=Load_profile(2)-Load_profile(3)<=dif;
Rand_load_profile.Constraints.dif3=Load_profile(3)-Load_profile(4)<=dif;
Rand_load_profile.Constraints.dif4=Load_profile(4)-Load_profile(5)<=dif;
Rand_load_profile.Constraints.dif5=Load_profile(5)-Load_profile(6)<=dif;
Rand_load_profile.Constraints.dif6=Load_profile(6)-Load_profile(7)<=dif;
Rand_load_profile.Constraints.dif7=Load_profile(7)-Load_profile(8)<=dif;
Rand_load_profile.Constraints.dif8=Load_profile(8)-Load_profile(9)<=dif;
Rand_load_profile.Constraints.dif9=Load_profile(9)-Load_profile(10)<=dif;
Rand_load_profile.Constraints.dif10=Load_profile(10)-Load_profile(11)<=dif;
Rand_load_profile.Constraints.dif11=Load_profile(11)-Load_profile(12)<=dif;
Rand_load_profile.Constraints.dif12=Load_profile(12)-Load_profile(13)<=dif;
Rand_load_profile.Constraints.dif13=Load_profile(13)-Load_profile(14)<=dif;
Rand_load_profile.Constraints.dif14=Load_profile(14)-Load_profile(15)<=dif;
Rand_load_profile.Constraints.dif15=Load_profile(15)-Load_profile(16)<=dif;
Rand_load_profile.Constraints.dif16=Load_profile(16)-Load_profile(17)<=dif;
Rand_load_profile.Constraints.dif17=Load_profile(17)-Load_profile(18)<=dif;
Rand_load_profile.Constraints.dif18=Load_profile(18)-Load_profile(19)<=dif;
Rand_load_profile.Constraints.dif19=Load_profile(19)-Load_profile(20)<=dif;
Rand_load_profile.Constraints.dif20=Load_profile(20)-Load_profile(21)<=dif;
Rand_load_profile.Constraints.dif21=Load_profile(21)-Load_profile(22)<=dif;
Rand_load_profile.Constraints.dif22=Load_profile(22)-Load_profile(23)<=dif;
Rand_load_profile.Constraints.dif23=Load_profile(23)-Load_profile(24)<=dif;

Rand_load_profile.Constraints.dif1=Load_profile(1)-Load_profile(2)>=-dif;
Rand_load_profile.Constraints.dif2=Load_profile(2)-Load_profile(3)>=-dif;
Rand_load_profile.Constraints.dif3=Load_profile(3)-Load_profile(4)>=-dif;
Rand_load_profile.Constraints.dif4=Load_profile(4)-Load_profile(5)>=-dif;
Rand_load_profile.Constraints.dif5=Load_profile(5)-Load_profile(6)>=-dif;
Rand_load_profile.Constraints.dif6=Load_profile(6)-Load_profile(7)>=-dif;
Rand_load_profile.Constraints.dif7=Load_profile(7)-Load_profile(8)>=-dif;
Rand_load_profile.Constraints.dif8=Load_profile(8)-Load_profile(9)>=-dif;
Rand_load_profile.Constraints.dif9=Load_profile(9)-Load_profile(10)>=-dif;
Rand_load_profile.Constraints.dif10=Load_profile(10)-Load_profile(11)>=-dif;
Rand_load_profile.Constraints.dif11=Load_profile(11)-Load_profile(12)>=-dif;
Rand_load_profile.Constraints.dif12=Load_profile(12)-Load_profile(13)>=-dif;
Rand_load_profile.Constraints.dif13=Load_profile(13)-Load_profile(14)>=-dif;
Rand_load_profile.Constraints.dif14=Load_profile(14)-Load_profile(15)>=-dif;
Rand_load_profile.Constraints.dif15=Load_profile(15)-Load_profile(16)>=-dif;
Rand_load_profile.Constraints.dif16=Load_profile(16)-Load_profile(17)>=-dif;
Rand_load_profile.Constraints.dif17=Load_profile(17)-Load_profile(18)>=-dif;
Rand_load_profile.Constraints.dif18=Load_profile(18)-Load_profile(19)>=-dif;
Rand_load_profile.Constraints.dif19=Load_profile(19)-Load_profile(20)>=-dif;
Rand_load_profile.Constraints.dif20=Load_profile(20)-Load_profile(21)>=-dif;
Rand_load_profile.Constraints.dif21=Load_profile(21)-Load_profile(22)>=-dif;
Rand_load_profile.Constraints.dif22=Load_profile(22)-Load_profile(23)>=-dif;
Rand_load_profile.Constraints.dif23=Load_profile(23)-Load_profile(24)>=-dif;

% showproblem(Rand_load_profile)
%% Finding the optimal solution

% Making a first approximation
x0.Load_profile=loading_limit;

% setting the solver algorithm 
options.Algorithm='sqp';

% call the optimization solver to find the best solution
[sol,~,~,~] = solve(Rand_load_profile,x0,'Options',options);

%% Postprocessing
% setting the nominal rating of transformer
Nominal_rating=1000;% kVA

% find the temperature and ageings
[HST_max,TOT_max,AEQ,Energy,Current_ageing]=distrbution_transformer_random_load(sol.Load_profile,AMB);

% Convert optimal load profile to 1-min time resolution
[PUL_optim]=PUL_to_1min(sol.Load_profile*Nominal_rating,60);

% Ploting the resuts
start_date = datetime('01-Jan-2021 00:00:00');
tstart=60;
timestep=60;   % pas de temps, second?
tend=60;
dt=0.001;
dt(end+1:length(PUL_optim)+1)=tstart:timestep:tend*length(PUL_optim);dt=dt';
time_IEC=start_date+seconds(dt);
PUL_optim(2:length(PUL_optim)+1)=PUL_optim;
Current_ageing(2:length(Current_ageing)+1)=Current_ageing;
Current_ageing(1,1)=0;
subplot(2,1,1)
plot(time_IEC,PUL_optim,'linewidth',2)
Nominal_rating=linspace(Nominal_rating,Nominal_rating,length(PUL_optim))';
hold on 
plot(time_IEC,Nominal_rating,'--k','linewidth',2)
ylabel('Transflormer loading, pu')
xlabel('Time')
subplot(2,1,2)
plot(time_IEC,Current_ageing,'linewidth',2)
ylabel('Cummulative ageing, pu')
xlabel('Time')