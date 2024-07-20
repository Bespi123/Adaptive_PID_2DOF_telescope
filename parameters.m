%%%Simulation Parameters
telescopeParam.m1  = 7;
telescopeParam.m2  = 10;
telescopeParam.l1  = 0.2; 
telescopeParam.l2  = 0.8;
%telescopeParam.l2  = 0;
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

%%%PID controller
%q1.PID.Kp = 100;
%q1.PID.Ki = 0;
%q1.PID.Kd = 1000;
q1.PID.Kp = 2.3868;
q1.PID.Ki = 0;
q1.PID.Kd = 11.8644;

q2.PID.Kp = 9.999661870002747e+02;
q2.PID.Ki = 7.000191211700440;
q2.PID.Kd = 9.999661621093750e+03;
%  q2.PID.Kp = 1000;
%  q2.PID.Ki = 7;
%  q2.PID.Kd = 10000;


%%%Adaptation Law gains
% q1.lambda = 5;
% q1.n = 20;
% q1.alpha = 8;
% q1.beta = 5;
% q1.epsilon = 0.01; %Pequeño
 q1.lambda = 0.7738;
 q1.n = 8.2246;
 q1.alpha = 2.8389;
 q1.beta = 0.0171;
 q1.epsilon = 0.0578; %Pequeño


q2.lambda = 9.3296;
q2.n = 38.0034;
q2.alpha = 1.7763;
q2.beta = 12.0062;
q2.epsilon = 0.4231;

%9.3296   38.0034    1.7763   12.0062    0.4231
%%%Initial Conditions
q1.kd_init = 0.1;
q1.ki_init = 0.1;
q1.kp_init = 0.1;

q2.kd_init = 0.1;
q2.ki_init = 0.1;
q2.kp_init = 0.1;

%%% Gravity
g = 9.81;

%%%Matrix example

theta2 = pi/2;
thetha1_dot = 0;

 M=[telescopeParam.I_1(1,3)^2+telescopeParam.m2*telescopeParam.l2^2*cos(theta2)^2+telescopeParam.I_2(1,3), 0
     0, telescopeParam.m2*telescopeParam.l2^2+telescopeParam.I_2(1,2)];
 C=[0; -telescopeParam.m2*telescopeParam.l2^2*cos(theta2)*sin(theta2)*thetha1_dot^2];
 G=[0; -telescopeParam.m2*g*telescopeParam.l2/2*cos(theta2)];

 f_x = M\(-C-G)
 G_x = inv(M)

 %9.3296   38.0034    1.7763   12.0062    0.4231