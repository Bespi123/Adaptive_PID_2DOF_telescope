function J=myObjectiveFunction(k)
% Template for Creating an Objective Function Using a Simulink Block Diagram
% x contains all the controller variables of the problem in a column vector.
% Acknoledgment: 
% Professor Juan Pablo Requez Vivas for the Intelligent Control
% course - UNEXPO - 2023 - jrequez@unexpo.edu.ve
% Modified by Bespi123 on 26/02/2024

%%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
% Separate the variables into their appropriate names, according to the
% problem at hand. These variables correspond to the elements of x, which
% must be n different elements.
%x.PID.Kp = k(1); x.PID.Ki = k(2); x.PID.Kd = k(3);     %Pid gains 
%y.PID.Kp = k(1); y.PID.Ki = k(2); y.PID.Kd = k(3);     %Pid gains 
%q1.PID.Kp = k(1); q1.PID.Ki = k(2); q1.PID.Kd = k(3);     %Pid gains 
%q2.PID.Kp = 1; q2.PID.Ki = 1; q2.PID.Kd = 1;     %Pid gains 

%q1.PID.Kp = 2.3868;
%q1.PID.Ki = 0;
%q1.PID.Kd = 11.8644;

%%%Adaptation Law gains
%q2.lambda = k(1);
%q2.n = k(2);
%q2.alpha = k(3);
%q2.beta = k(4);
%q2.epsilon = k(5);
%disp(k);

%%%Adaptation Law gains
q1.lambda = k(1);
q1.n = k(2);
q1.alpha = k(3);
q1.beta = k(4);
q1.epsilon = k(5); %Pequeño

%q2.lambda = k(1);
%q2.n = k(2);
%q2.alpha = k(3);
%q2.beta = k(4);
%q2.epsilon = k(5);

q2.lambda = 9.3296;
q2.n = 38.0034;
q2.alpha = 1.7763;
q2.beta = 12.0062;
q2.epsilon = 0.4231;


%%%Initial Conditions
q1.kd_init =  0.1;
q1.ki_init =  0.1;
q1.kp_init =  0.1;

q2.kd_init = 0.0;
q2.ki_init = 0.0;
q2.kp_init = 0.0;

%q2.PID.Kp = k(1); q2.PID.Ki = k(2); q2.PID.Kd = k(3);     %Pid gains 


%%%%%%%%%%%%%%%%%%%     SECTION 2: Conditions         %%%%%%%%%%%%%%%%%%%%%
% Operating conditions of the problem. If the problem has parameters or 
% data that you need to add, place them in this section.
%%%Simulation Parameters
telescopeParam.m1  = 7;
telescopeParam.m2  = 10;
telescopeParam.l1  = 0.2; 
telescopeParam.l2  = 0.8;
telescopeParam.r1  = 0.20; 
telescopeParam.r2  = 0.15;

%%%%%new rotation center
telescopeParam.cg2 = telescopeParam.l2/2;
cd  = [0,0,-telescopeParam.cg2]';

%%%%%Inertia joints
%%%%%Inercia del cilindro
%%%%%Inercia de eslabon 1
telescopeParam.I_1 = ...
   [1/12*telescopeParam.m1*(3*telescopeParam.r1^2+telescopeParam.l1^2),...
    1/12*telescopeParam.m1*(3*telescopeParam.r1^2+telescopeParam.l1^2),...
    1/2*telescopeParam.m1*telescopeParam.r1^2]; 
%%%%%Inercia de eslabon 2 at joint 2
I_c = diag([...
     1/12*telescopeParam.m2*(3*telescopeParam.r2^2+telescopeParam.l2^2),...
     1/12*telescopeParam.m2*(3*telescopeParam.r2^2+telescopeParam.l2^2),...
     1/2*telescopeParam.m2*telescopeParam.r2^2]); 
%%%%%Paralel theorem to get the position at CG
I_2 = I_c+telescopeParam.m2*skew(cd)*skew(cd)';
telescopeParam.I_2=[I_2(1,1),I_2(2,2),I_2(3,3)];


%%%%%%%%%%%%%%%%%%%     SECTION 3: Pre-Calculations   %%%%%%%%%%%%%%%%%%%%%
% Pre-calculations
% If the problem requires performing pre-calculations to facilitate the
% evaluation of the objective function, place them here.

%%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
% Simulink is called to simulate the process of interest and calculate the
% simulation outputs
% WARNING!!! The model name must be changed in the following line
try
   %%salidas=sim('PID_sintonization.slx','SrcWorkspace','current');
   salidas=sim('adaptivePID.slx','SrcWorkspace','current');
   stable = 1;
catch exception
   
   if strcmp(exception.identifier,'Simulink:Engine:DerivNotFinite')
    stable = 0;
    disp('System No stable')
   else
       stable = 0;
       disp('Otro error')
   end
end

if(stable == 1)
% The simulation outputs are divided into two groups, the time and the
% outputs themselves
 yout       = salidas.get('yout');
 t      = yout{1}.Values.Time;
 y      = yout{1}.Values.Data;
 u  = yout{2}.Values.Data;
 e      = yout{3}.Values.Data;
 flag   = yout{4}.Values.Data;
 
 %u    = zeros(size(tempu, 3),2);
% Display each slice of the 3D array
 %numSlices = size(tempu, 3);
  %  for j = 1:numSlices
   %     u(j,:) = tempu(:, :, j)';
   % end

% It is common to have the system error as out1, the controller output u as
% out2, and the output y as out3
u=u(:,1); y=y(:,1); e=e(:,1);%Define error, control signal and output

%%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
% The response of the process is now analyzed. If the input is not a step, 
% other variables or representative calculations must be chosen in this
% section and what is shown may not be applicable.

%-----Indice preestablecido------------
%digamos que se desea que el tiempo de establecimiento sea un valor
%específico
%desired_setlement_time = 376;
%desired_rising_time    = 80;
desired_setlement_time = 0;
desired_rising_time    = 0;

% calculate rising time
tr = calculateRissingTime(e, t, 50/100);
d_tr = abs(desired_rising_time-tr);

% Calculate settlement time
ts = calculateSettlementTime(e, t, 5/100);
d_ts = abs(desired_setlement_time-ts);

%-----índices de error integral --------
%itse=trapz(t,t.*e.^2);
itse = trapz(t,e.^2);

itsy = trapz(t,y.^2);

entropy = calculate_entropy(y);
% % %-----
%overshoot = max(y);
[overshoot, ~] = calculateOvershoot(y);

uwork = trapz(t,u.^2);

%%%-----Elección del índice deseado como fitness-------
%%% Se determina la salida del la función fitness
%%%J=itse+overshoot+umax+uwork+timeWorking;
%%%J=itse+setlement_time_error+overshoot+rising_time_error;
%%%J=itse+setlement_time_error+rising_time_error;
if isempty(tr) || isempty(ts) || flag(end)==1
%if isempty(tr) || isempty(ts) 
    J = Inf;
else
    J = d_tr+10*d_ts+itse+uwork+itsy+entropy+10*overshoot; %%%High value of J
end
else
    J = Inf;
end

end

function entropy = calculate_entropy(signal)
    % Calculate the Shannon entropy of a signal.
    % Input: signal (1D array)
    % Output: entropy

    unique_values = unique(signal);
    probabilities = histcounts(signal, unique_values) / numel(signal);
    entropy = -sum(probabilities .* log2(probabilities));
end