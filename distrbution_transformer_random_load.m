function [HST_max,TOT_max,AEQ,Energy_transfer,Current_ageing]=distrbution_transformer_random_load(PUL,AMB)
% This function calculates thermal mode for ONAN distrbution transformer based on IEC 60076-7
% Input data:
%    PUL - loading of transformer in pu
%    AMB - ambient temperature, degC

% Output data:
%    HST_max - maximal hot-spot temerature of winding, degC
%    TOT_max - maximal top-oil temperature, degC
%    AEQ - ageing equivalent, pu relatve to normal ageing 
%    Energy_transfer - energy transfer
%    Current_ageing - ageing at each moment
%
% Thermal characteristics of ONAN distrbution transformer
delta_theta_or = 55;     % Top-oil (in tank) temperature rise in steady state at rated losses (no-load losses + load losses),K
delta_theta_hr = 23;     % Hot-spot-to-top-oil (in tank) gradient at rated current, K
tao_0 = 180;             % Average oil time constant, min
tao_w = 4;               % Winding time constant, min
R = 5;                   % Ratio of load losses at rated current to no-load losses
x = 0.8;                 % Exponential power of total losses versus top-oil (in tank) temperature rise (oil exponent)
y = 1.6;                 % Exponential power of current versus winding temperature rise (winding exponent)
k11 = 1;                 % Thermal model constant
k21 = 1;                 % Thermal model constant
k22 = 2;                 % Thermal model constant

NPUL=length(PUL); % Finding the length of load data
NAMB=length(AMB); % Finding the length of ambient temperature data

% Checking that input data is in minute format
if NPUL==1440 && NAMB==1440 || NPUL==2880 && NAMB==2880
    % do nothing
elseif NPUL==24 && NAMB==24
    PUL=PUL_to_1min(PUL,60); % Convert loading data to minute format
    AMB=PUL_to_1min(AMB,60); % Convert amb. temperature data to minute format
elseif NPUL==1440 && NAMB==24
    AMB=PUL_to_1min(AMB,60); % Convert amb. temperature data to minute format
elseif NPUL==24 && NAMB==1440
    PUL=PUL_to_1min(PUL,60); % Convert loading data to minute format
elseif NPUL==48 && NAMB==48
    PUL=PUL_to_1min(PUL,30); % Convert loading data to minute format
    AMB=PUL_to_1min(AMB,30); % Convert amb. temperature data to minute format
elseif NPUL==96 && NAMB==96
    PUL=PUL_to_1min(PUL,15); % Convert loading data to minute format
    AMB=PUL_to_1min(AMB,15); % Convert amb. temperature data to minute format
elseif NPUL==288 && NAMB==288
    PUL=PUL_to_1min(PUL,5); % Convert loading data to minute format
    AMB=PUL_to_1min(AMB,5); % Convert amb. temperature data to minute formatelse 
else
    PUL=PUL_to_1min(PUL,60); % Convert loading data to minute format
    AMB=PUL_to_1min(AMB,60); % Convert amb. temperature data to minute format
%     error('Check the length of input data')
end

% Change the variable
K=PUL;
theta_a=AMB;
% load('initial_data.mat','TIM')
Dt=1;% time step 1 minute


% Although the system may not strictly be in the steady state at the start of a calculation period,
% this is usually the best one can assume, and it has little effect on the result.
K_0=K(1);
theta_a_0=theta_a(1);
theta_0 = ((1+K_0.^2.*R)./(1+R)).^x.*delta_theta_or+theta_a_0;    % top-oil temperature
delta_theta_h1 = k21*K_0.^y*delta_theta_hr;                       % Hot-spot-to-top-oil (in tank) gradient at start
delta_theta_h2 = (k21-1)*K_0.^y*delta_theta_hr;                   % Hot-spot-to-top-oil (in tank) gradient at start
Loss_of_life = 0;

% Create an array of hot-spot temperature and top-oil temperature
HST=NaN(length(K),1);
TOT=NaN(length(K),1);

% Solving difference (not differentiate) equations: iterative approach (see
% Annex C in IEC 60076-7 for equations)
for i=1:1:length(K)
    
    D_theta_0 = (Dt./(k11.*tao_0)).*((((1+K(i).^2.*R)./(1+R)).^x).*(delta_theta_or)-(theta_0-theta_a(i)));
    theta_0 = theta_0+D_theta_0;
    
    D_delta_theta_h1 = Dt./(k22.*tao_w).*(k21.*delta_theta_hr.*K(i).^y-delta_theta_h1);
    delta_theta_h1 = delta_theta_h1+D_delta_theta_h1;
    
    D_delta_theta_h2 = Dt./(1./k22.*tao_0).*((k21-1).*delta_theta_hr.*K(i).^y-delta_theta_h2);
    delta_theta_h2 = delta_theta_h2+D_delta_theta_h2;
    
    delta_theta_h = delta_theta_h1-delta_theta_h2;
    
    HST(i,:) = theta_0+delta_theta_h;   % hot spot temperature 
    TOT(i,:)=theta_0; % top oil temperature
end

% Calculating ageing
DL=NaN(length(K),1);
for i=1:1:length(HST)
%     DL(i,:) = (exp((15000./(110+273)-15000./(HST(i)+273)))).*Dt;
    DL(i,:) = (2^((HST(i)-98)/6)).*Dt;
end
Loss_of_life = Loss_of_life+DL; % loss of insulation life
ASUM=sum(Loss_of_life); % cummulative loss of insulation life
Current_ageing=0;
for i=1:length(DL)
    Current_ageing(i,1)=Current_ageing(end,1)+DL(i);
end

% Output
Current_ageing=Current_ageing/length(Current_ageing); % ageing at each time
AEQ=ASUM/length(K); % ageing equivalent, pu relatve to normal ageing 
HST_max=max(HST); % Maximal hot spot temperature
TOT_max=max(TOT); % Maximal top oil temperature
Energy_transfer=sum(PUL); % energy transfer (NB: units are pu*min!!! not MWh)
end


