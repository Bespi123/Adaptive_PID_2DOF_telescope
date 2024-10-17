function u = controlLaw(entr)
% controlLaw - Calculates the control input 'u' based on the parameters provided in 'entr'.
%
% Syntax: u = controlLaw(entr)
%
% Inputs:
%   entr - Vector containing the following parameters:
%       entr(1:3) = theta : Vector of control parameters [theta1; theta2; theta3]
%       entr(4:6) = myPi  : Vector of coefficients [pi1; pi2; pi3]
%
% Output:
%   u - Control input calculated as the dot product of 'theta' and 'myPi'

    % Assign the first three elements of 'entr' to the vector 'theta'
    theta = [entr(1); entr(2); entr(3)];

    % Assign the next three elements of 'entr' to the vector 'myPi'
    myPi  = [entr(4); entr(5); entr(6)];

    % Calculate the control input 'u' as the dot product of 'theta' and 'myPi'
    u = theta' * myPi;  % This is equivalent to summing the element-wise products of 'theta' and 'myPi'

end