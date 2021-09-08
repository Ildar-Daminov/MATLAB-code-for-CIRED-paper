function [Energy_limit,Energy,exitflag]=optimal_energy_limit(AMB,AAF_limit)
%% Problem-based for DTR transformer
nHours = numel(AMB);
%% Define the optimization problem and the optimization variables
DTRprob=optimproblem('ObjectiveSense','maximize'); 
% DTR in an hour for transformer
DTR = optimvar('DTR',nHours,'LowerBound',0,'UpperBound',1.5);
%% Define the objective function
% Energy_transfer maximization;
Energy_transfer = sum(DTR);

% showexpr(Energy_transfer)
% set objective
DTRprob.Objective = Energy_transfer;

%% DTR constraints
%type OF
[HST_max,TOT_max,~,~,AEQ,~]=fcn2optimexpr(@distrbution_transformer_optim,DTR,AMB);
% Ageing below or equal normal
DTRprob.Constraints.ageing=AEQ<=AAF_limit;
% HST below or equal 120 
DTRprob.Constraints.hst=HST_max<=120;
% TOT below or equal to 105
DTRprob.Constraints.tot=TOT_max<=105;
% HST start equal to HST end
% DTRprob.Constraints.hst_equality1=HST_1==HST_end;
% showconstr(DTRprob.Constraints.ageing)

% showproblem(DTRprob)
%% OPtimal solution

% First apprximation
% [DTR_approx]=method1_IEC_improved(AMB);
DTR_approx=linspace(1,1,length(AMB))';
x0.DTR=DTR_approx';

% call the optimization solver to find the best solution

% [sol,TotalCost,exitflag,output] = solve(DTRprob,x0,'Options',options);
options=optimset('disp','iter','LargeScale','off','TolFun',.001,'MaxIter',100000000,'MaxFunEvals',1000000000);
options.Algorithm='sqp';
[sol,~,exitflag,~] = solve(DTRprob,x0,'Options',options);
%% Energy comparison;
Energy_limit=sol.DTR;
Energy=sum(sol.DTR);

end