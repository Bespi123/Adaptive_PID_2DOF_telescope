function pos = directKinematics(entr)
l1 = entr(1);
l2 = entr(2);
q1 = entr(3);
q2 = entr(4);
q_dot = entr(5:6);
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
pos = [l2*cos(q1)*cos(q2);l2*sin(q1)*cos(q2);l1+l2*sin(q2)];
end