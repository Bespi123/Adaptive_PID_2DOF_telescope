%**************************************************************************
% AUTHOR: Brayan Espinoza 17/10/2024
% DESCRIPTION: 
% This program runs a genetic algorithm for tunning an adaptive PID control 
% algorithm for a 2DOF telescope modeled as a 2DOF robotic arm using Lagrange
% equations.
% IMPORTANT: 
% The telescope is modeled without taking into consideration the actuators
% and sensor errors, so the required torque is used as input.
% *************************************************************************

parameters;

no_var = 10;  %number of variables
lb = [0 0 0.5 0 0  0 0 8 0 0]; % lower bound
up = [Inf Inf Inf Inf 0.1 Inf Inf Inf Inf 0.1]; % high bound
initial = [q1.lambda q1.n q1.alpha q1.beta q1.epsilon ... 
           q2.lambda q2.n q2.alpha q2.beta q2.epsilon]; %Pequeño

%GA OPTIONS
%try
ga_opt = gaoptimset('Display','off','Generations',10,'PopulationSize',20, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf); 
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);