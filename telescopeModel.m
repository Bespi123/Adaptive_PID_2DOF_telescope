function [x_dot] = telescopeModel(input)
%TELESCOPEMODEL Computes the state derivative for a two-link telescope model.
%
% This function models the dynamics of a two-link system (such as a telescope),
% calculating the time derivatives of the joint angles and angular velocities.
%
% INPUT:
%   input - A vector containing the following elements:
%       [1-3]   I_1: Moments of inertia for link 1 (diagonal elements)
%       [4]     l1: Length of link 1
%       [5]     m1: Mass of link 1
%       [6-8]   I_2: Moments of inertia for link 2 (diagonal elements)
%       [9]     l2: Length of link 2
%       [10]    m2: Mass of link 2
%       [11]    cg2: Center of gravity of link 2 (distance from joint 2)
%       [12-13] u: Control torques applied to the system [u1; u2]
%       [14-17] q: Joint states [theta1; theta2; theta1_dot; theta2_dot]
%
% OUTPUT:
%   x_dot - Time derivatives of the system's states:
%           [theta1_dot; theta2_dot; theta1_ddot; theta2_ddot]

% Extract parameters from input
I_1 = diag([input(1), input(2), input(3)]);  % Inertia matrix for link 1
l1 = input(4);                               % Length of link 1 (not used in this example)
m1 = input(5);                               % Mass of link 1 (not used in this example)
I_2 = diag([input(6), input(7), input(8)]);  % Inertia matrix for link 2
l2 = input(9);                               % Length of link 2
m2 = input(10);                              % Mass of link 2
cg2 = input(11);                             % Center of gravity of link 2
u = [input(12); input(13)];                  % Control torques [u1; u2]
q = input(14:17);                            % Joint states [theta1; theta2; theta1_dot; theta2_dot]

% Extract joint angles and angular velocities
theta = [q(1); q(2)];          % Joint angles [theta1; theta2]
theta_dot = [q(3); q(4)];      % Joint angular velocities [theta1_dot; theta2_dot]

% Gravitational acceleration
g = 9.81;  % m/s^2

% Mass matrix (M)
M = [I_1(3, 3) + m2 * l2^2 * cos(theta(2))^2 + I_2(3, 3), 0;
     0, m2 * l2^2 + I_2(2, 2)];

% Coriolis and centrifugal forces matrix (C)
C = [0;
     -m2 * l2^2 * cos(theta(2)) * sin(theta(2)) * theta_dot(1)^2];

% Gravitational forces matrix (G)
G = [0;
     m2 * g * cg2 * cos(theta(2))];

% Compute the state derivatives
% x_dot contains [theta1_dot; theta2_dot; theta1_ddot; theta2_ddot]
x_dot = [theta_dot; M \ (u - C - G)];

end
