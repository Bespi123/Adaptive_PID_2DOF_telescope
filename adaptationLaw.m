function theta_dot = adaptationLaw(entr)
% adaptationLaw - Calculates the adaptation law theta_dot based on several input parameters.
%
% Syntax: theta_dot = adaptationLaw(entr)
%
% Inputs:
%   entr - Vector containing the following parameters:
%       entr(1) = n     : Scaling factor
%       entr(2) = alpha : Constant for the proportional term
%       entr(3) = beta  : Constant for the hyperbolic term
%       entr(4) = s     : Sliding surface value
%       entr(5) = s_dot : Derivative of the sliding surface
%       entr(6) = e     : Smoothing constant for the tanh function
%       entr(7:9) = myPi: Vector of adaptive parameters [pi1; pi2; pi3]
%
% Output:
%   theta_dot - Derivative of the adaptive parameters calculated using the adaptation law

    % Assigning parameters to local variables for better readability
    n     = entr(1);  % Scaling factor
    alpha = entr(2);  % Proportional term constant
    beta  = entr(3);  % Hyperbolic term constant
    s     = entr(4);  % Sliding surface value
    s_dot = entr(5);  % Derivative of the sliding surface
    e     = entr(6);  % Smoothing parameter for tanh function
    myPi  = [entr(7); entr(8); entr(9)];  % Vector of adaptive parameters
    
    % Calculation of theta_dot using the adaptation law
    % The equation is: theta_dot = n * myPi * (s_dot + alpha * s + beta * tanh(s / e))
    theta_dot = n * myPi * (s_dot + alpha * s + beta * tanh(s / e));

end
