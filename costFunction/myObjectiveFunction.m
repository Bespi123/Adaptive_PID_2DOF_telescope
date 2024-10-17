% % function J=myObjectiveFunction(k)
% % % Template for Creating an Objective Function Using a Simulink Block Diagram
% % % x contains all the controller variables of the problem in a column vector.
% % % Acknoledgment: 
% % % Professor Juan Pablo Requez Vivas for the Intelligent Control
% % % course - UNEXPO - 2023 - jrequez@unexpo.edu.ve
% % % Modified by Bespi123 on 26/02/2024
% % 
% % %%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
% % % Separate the variables into their appropriate names, according to the
% % % problem at hand. These variables correspond to the elements of x, which
% % % must be n different elements.
% % parameters;
% % 
% % %%%Adaptation Law gains
% % q1.lambda = k(1);
% % q1.n = k(2);
% % q1.alpha = k(3);
% % q1.beta = k(4);
% % q1.epsilon = k(5); %Pequeño
% % 
% % q2.lambda = k(6);
% % q2.n = k(7);
% % q2.alpha = k(8);
% % q2.beta = k(9);
% % q2.epsilon = k(10);
% % 
% % %%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
% % % Simulink is called to simulate the process of interest and calculate the
% % % simulation outputs
% % % WARNING!!! The model name must be changed in the following line
% % try
% %    salidas=sim('adaptivePID.slx','SrcWorkspace','current');
% %    stable = 1;
% % catch exception
% % 
% %    if strcmp(exception.identifier,'Simulink:Engine:DerivNotFinite')
% %     stable = 0;
% %     disp('System No stable')
% %    else
% %        stable = 0;
% %        disp('Otro error')
% %    end
% % end
% % 
% % if(stable == 1)
% % % The simulation outputs are divided into two groups, the time and the
% % % outputs themselves
% %  yout   = salidas.get('yout');
% %  t      = yout{1}.Values.Time;
% %  y      = yout{1}.Values.Data;
% %  u      = yout{2}.Values.Data;
% %  e      = yout{3}.Values.Data;
% %  flag   = yout{4}.Values.Data;
% % 
% % % It is common to have the system error as out1, the controller output u as
% % % out2, and the output y as out3
% % u=u(:,1); y=y(:,1); e=e(:,1);%Define error, control signal and output
% % 
% % %%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
% % % The response of the process is now analyzed. If the input is not a step, 
% % % other variables or representative calculations must be chosen in this
% % % section and what is shown may not be applicable.
% % 
% % %-----Indice preestablecido------------
% % %digamos que se desea que el tiempo de establecimiento sea un valor
% % %específico
% % %desired_setlement_time = 376;
% % %desired_rising_time    = 80;
% % desired_setlement_time = 0;
% % desired_rising_time    = 0;
% % 
% % % calculate rising time
% % tr = calculateRisingTime(e, t, 50/100);
% % d_tr = abs(desired_rising_time-tr);
% % 
% % % Calculate settlement time
% % ts = calculateSettlementTime(e, t, 5/100);
% % d_ts = abs(desired_setlement_time-ts);
% % 
% % %-----índices de error integral --------
% % itse = trapz(t,e.^2);
% % itsy = trapz(t,y.^2);
% % 
% % entropy = calculate_entropy(y);
% % % % %-----
% % %overshoot = max(y);
% % [overshoot, ~] = calculateOvershoot(y);
% % 
% % uwork = trapz(t,u.^2);
% % 
% % %%%-----Elección del índice deseado como fitness-------
% % %%% Se determina la salida del la función fitness
% % %%%J=itse+overshoot+umax+uwork+timeWorking;
% % %%%J=itse+setlement_time_error+overshoot+rising_time_error;
% % %%%J=itse+setlement_time_error+rising_time_error;
% % if isempty(tr) || isempty(ts) || flag(end)==1
% % %if isempty(tr) || isempty(ts) 
% %     J = Inf;
% % else
% %     J = d_tr+10*d_ts+itse+uwork+itsy+entropy+10*overshoot; %%%High value of J
% % end
% % else
% %     J = Inf;
% % end
% % 
% % end

function J = myObjectiveFunction(k)
% Template for Creating an Objective Function Using a Simulink Block Diagram
% 'k' is a vector containing controller parameters. The objective function
% evaluates the performance of the control system based on these parameters.

% Acknowledgment: 
% Professor Juan Pablo Requez Vivas for the Intelligent Control course 
% UNEXPO - 2023 - jrequez@unexpo.edu.ve
% Modified by Bespi123 on 26/02/2024

%%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
% Separate the variables into their appropriate names for the control problem.
% The vector 'k' contains all the controller gains (10 elements in this case).
parameters;  % Call external parameters (assumed to be set elsewhere in the workspace).

%%% Adaptation Law gains
% The elements of 'k' are assigned to different variables corresponding to
% two controllers (q1 and q2) with different gain parameters.
q1.lambda  = k(1);
q1.n       = k(2);
q1.alpha   = k(3);
q1.beta    = k(4);
q1.epsilon = k(5);  % Small value for q1

q2.lambda  = k(6);
q2.n       = k(7);
q2.alpha   = k(8);
q2.beta    = k(9);
q2.epsilon = k(10);

%%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
% Run the Simulink model 'adaptivePID.slx' with the current parameters to
% simulate the system's response. 'salidas' contains the simulation results.

try
    salidas = sim('adaptivePID.slx', 'SrcWorkspace', 'current');
    stable = 1;  % If the simulation runs successfully, mark the system as stable.
catch exception
    % If there is an error during simulation, handle it accordingly.
    if strcmp(exception.identifier, 'Simulink:Engine:DerivNotFinite')
        stable = 0;
        disp('System is not stable');
    else
        stable = 0;
        disp('Another error occurred during simulation');
    end
end

if stable == 1
    % Extract simulation outputs: time, output signals, control effort, error, and stability flag.
    yout = salidas.get('yout');
    t = yout{1}.Values.Time;
    y = yout{1}.Values.Data;
    u = yout{2}.Values.Data;
    e = yout{3}.Values.Data;
    flag = yout{4}.Values.Data;
    
    % Extract only the first columns of output, control signal, and error.
    u1 = u(:,1);
    y1 = y(:,1);
    e1 = e(:,1);
    
    u2 = u(:,2);
    y2 = y(:,2);
    e2 = e(:,2);

%%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
% Calculate key performance indices to evaluate the control system.
% These include rising time, settling time, integral errors, and overshoot.

    % Set desired settling time and rising time (can be adjusted as needed).
    desired_settlement_time = 0;
    desired_rising_time     = 0;

    J1 = calculateFitness(e1, y1, u1, t, desired_settlement_time,...
                                                      desired_rising_time);
    J2 = calculateFitness(e2, y2, u2, t, desired_settlement_time,...
                                                      desired_rising_time);
    J = J1+J2;
else
    J = Inf;  % Assign a high fitness value if the system is unstable.
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

function tr = calculateRisingTime(e, t, rising)
    % This function calculates the rising time (tr) of a signal 'e', 
    % which is the time it takes for 'e' to go from a low threshold
    % to a high threshold. The 'rising' parameter defines the thresholds.
    
    % Define the bounds for rising time as [-rising, rising].
    % This is used to find the time when 'e' first enters the specified range.
    % Typically, rising time might be calculated between, for example, 10% and 90% of a final value.
    boundsris = [-rising rising];
    
    % Find the indices where the signal 'e' is within the rising bounds.
    % This condition checks if the values of 'e' are between the lower and upper bounds.
    inBounds = (e >= boundsris(1) & e <= boundsris(2));
    
    % If no values of 'e' are within bounds, return NaN to indicate no valid rising time.
    if ~any(inBounds)
        tr = NaN;  % No rising time found.
    else
        % Find the first index where the signal enters the rising bounds.
        % 'min(x)' gives the earliest time the signal enters the bounds.
        tr = t(find(inBounds, 1, 'first'));
    end
end


function ts = calculateSettlementTime(e, t, tol)
    % This function calculates the settlement time (ts) of a signal 'e' based on
    % a tolerance 'tol'. The settlement time is the last time the signal 'e' 
    % goes outside the tolerance bounds.

    % Set bounds for the acceptable range [-tol, tol]
    bounds = [-tol tol];
    
    % Create a logical array indicating whether the values of 'e' are outside the bounds.
    % If a value of 'e' is out of bounds, the corresponding value in 'outOfBounds' will be true (1).
    % The condition checks if 'e' is less than -tol or greater than tol.
    outOfBounds = ~(e >= bounds(1) & e <= bounds(2));
    
    % If all values of 'e' are within bounds (no true values in 'outOfBounds'),
    % it means the signal settles within the tolerance throughout, so return NaN.
    if ~any(outOfBounds)
        ts = NaN;  % No settlement time found, as the signal remains within bounds.
    else
        % Find the last time the signal was out of bounds.
        % The function 'find' returns the index of the last out-of-bounds value.
        ts = t(find(outOfBounds, 1, 'last'));
    end
end

function [overshoot, timeIndex] = calculateOvershoot(y)
    % This function calculates the overshoot of a response signal 'y'.
    % The overshoot is the maximum value of the signal, and 'timeIndex' is
    % the index at which this maximum value occurs.
    
    % Check if the input 'y' is non-empty
    if isempty(y)
        overshoot = NaN;
        timeIndex = NaN;
        return;  % Exit early if 'y' is empty
    end
    
    % Find the maximum value (overshoot) and the index where it occurs
    [overshoot, timeIndex] = max(y);
    
    % The variable 'overshoot' is the maximum value of the signal.
    % The variable 'timeIndex' is the index at which the maximum occurs.
end

function J = calculateFitness(e, y, u, t, desired_settlement_time, desired_rising_time)
    % This function calculates the fitness value for a system based on the input
    % signals: error (e1), output (y1), control effort (u1), and time (t).
    % The desired_settlement_time and desired_rising_time are provided as inputs.

    % Calculate the rising time using 50% of the final value as the threshold.
    tr   = calculateRisingTime(e, t, 50 / 100);
    d_tr = abs(desired_rising_time - tr);  % Difference between actual and desired rising time.

    % Calculate the settling time using 5% tolerance.
    ts   = calculateSettlementTime(e, t, 5 / 100);
    d_ts = abs(desired_settlement_time - ts);  % Difference between actual and desired settling time.

    % Calculate integral of squared error (ITSE) and squared output (ITSY).
    itse = trapz(t, e.^2);  % Integral of squared error
    itsy = trapz(t, y.^2);  % Integral of squared output
    
    % Calculate entropy of the output signal (a measure of signal complexity).
    entropy = calculate_entropy(y);

    % Calculate the maximum overshoot (the peak value of the output).
    [overshoot, ~] = calculateOvershoot(y);
    
    % Calculate the control effort as the integral of the square of the control signal.
    uwork = trapz(t, u.^2);

    % Calculate the final fitness value (J1) based on the errors, control effort, and overshoot.
    if isempty(tr) || isempty(ts)
        J = Inf;  % Assign a high penalty if the system is unstable or critical times are undefined.
    else
        % The fitness function adds penalties for large errors or overshoot.
        J = d_tr + d_ts + itse + uwork + itsy + entropy + overshoot;
    end
end