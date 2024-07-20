no_var = 10;  %number of variables
%lb = [0 0 0.5 0 0]; % lower bound
lb = [0 0 0.5 0 0  0 0 8 0 0]; % lower bound
%up = [Inf Inf Inf Inf 0.5]; % high bound
up = [Inf Inf Inf Inf 0.1 Inf Inf Inf Inf 0.1]; % high bound
%initial = [2.3868 0 11.8644];
%initial = [9.999687500000000e+02 7.000088691711426 9.999865722656250e+03];
%initial = [1 10 8 5 0.01];
initial = [0.7738 11.0166 2.8389 0.5171 0.0804 0.7738 8.2246 2.8389 0.0171 0.0578];
%GA OPTIONS
%try
ga_opt = gaoptimset('Display','off','Generations',10,'PopulationSize',20, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf); 
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);