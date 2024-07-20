function [x_dot] = telescopeModel(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
I_1 = diag([input(1),input(2),input(3)]);
l1  = input(4);
m1  = input(5);
I_2 = diag([input(6),input(7),input(8)]);
l2  = input(9);
m2  = input(10);
cg2 = input(11);
u = [input(12);input(13)];
q = input(14:17);

theta = [q(1);q(2)];
theta_dot = [q(3);q(4)];

g = 9.81;

M=[I_1(3,3)^2+m2*l2^2*cos(theta(2))^2+I_2(3,3), 0
    0, m2*l2^2+I_2(2,2)];
C=[0; -m2*l2^2*cos(theta(2))*sin(theta(2))*theta_dot(1)^2];
G=[0; m2*g*cg2*cos(theta(2))];
%disp(M)
%%x_dot = [theta,theta_dot]
x_dot=[theta_dot;M\(u-C-G)];
end