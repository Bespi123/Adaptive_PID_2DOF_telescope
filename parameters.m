%%% Simulation Parameters
telescopeParam.m1 = 7;    % Mass of link 1 (kg)
telescopeParam.m2 = 10;   % Mass of link 2 (kg)
telescopeParam.l1 = 0.2;  % Length of link 1 (m)
telescopeParam.l2 = 0.8;  % Length of link 2 (m)
telescopeParam.r1 = 0.20; % Radius of link 1 (m)
telescopeParam.r2 = 0.15; % Radius of link 2 (m)

%%%% New rotation center (center of gravity of link 2)
telescopeParam.cg2 = telescopeParam.l2 / 2;
cd = [0, 0, -telescopeParam.cg2]';  % Displacement vector for link 2 center of mass

%%%% Inertia of the links (cylindrical assumption)
% Inertia of link 1 (I_1) about the center of mass
telescopeParam.I_1 = ...
   [1/12 * telescopeParam.m1 * (3 * telescopeParam.r1^2 + telescopeParam.l1^2), ...
    1/12 * telescopeParam.m1 * (3 * telescopeParam.r1^2 + telescopeParam.l1^2), ...
    1/2 * telescopeParam.m1 * telescopeParam.r1^2]; 

% Inertia of link 2 (I_2) at joint 2
I_c = diag([...
    1/12 * telescopeParam.m2 * (3 * telescopeParam.r2^2 + telescopeParam.l2^2), ...
    1/12 * telescopeParam.m2 * (3 * telescopeParam.r2^2 + telescopeParam.l2^2), ...
    1/2 * telescopeParam.m2 * telescopeParam.r2^2]); 

% Applying the parallel axis theorem to shift the inertia from the center of gravity
I_2 = I_c + telescopeParam.m2 * skew(cd) * skew(cd)';    % I_2 adjusted by parallel axis theorem
telescopeParam.I_2 = [I_2(1, 1), I_2(2, 2), I_2(3, 3)];  % Only diagonal elements used

%%% PID Controller gains
q1.PID.Kp = 2.3868;   % Proportional gain for joint 1
q1.PID.Ki = 0;        % Integral gain for joint 1
q1.PID.Kd = 11.8644;  % Derivative gain for joint 1

q2.PID.Kp = 999.966;   % Proportional gain for joint 2
q2.PID.Ki = 7.0002;    % Integral gain for joint 2
q2.PID.Kd = 9999.6616; % Derivative gain for joint 2

%%% Adaptation Law gains for joint 1 and joint 2
q1.lambda = 0.7738;
q1.n = 8.2246;
q1.alpha = 2.8389;
q1.beta = 0.0171;
q1.epsilon = 0.0578; % Small value for adaptive control

q2.lambda = 9.3296;
q2.n = 38.0034;
q2.alpha = 1.7763;
q2.beta = 12.0062;
q2.epsilon = 0.4231;

%%% Initial Conditions for adaptive controller gains
q1.kd_init = 0.1;
q1.ki_init = 0.1;
q1.kp_init = 0.1;

q2.kd_init = 0.1;
q2.ki_init = 0.1;
q2.kp_init = 0.1;

%%% Gravity
g = 9.81;  % Gravitational acceleration (m/s^2)

%%% Example matrix for dynamic calculations
theta2 = pi / 2;  % Example angle for joint 2 (90 degrees)
thetha1_dot = 0;  % Example angular velocity for joint 1

% Mass matrix (M)
M = [telescopeParam.I_1(3) + telescopeParam.m2 * telescopeParam.l2^2 * cos(theta2)^2 + telescopeParam.I_2(3), 0;
     0, telescopeParam.m2 * telescopeParam.l2^2 + telescopeParam.I_2(2)];

% Coriolis and centrifugal forces matrix (C)
C = [0; -telescopeParam.m2 * telescopeParam.l2^2 * cos(theta2) * sin(theta2) * thetha1_dot^2];

% Gravitational forces matrix (G)
G = [0; -telescopeParam.m2 * g * telescopeParam.l2 / 2 * cos(theta2)];

% Control input f_x (acceleration)
f_x = M \ (-C - G);

% Gain matrix G_x (inverse of mass matrix)
G_x = inv(M);