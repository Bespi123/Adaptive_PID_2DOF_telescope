%**************************************************************************
% AUTHOR: Brayan Espinoza 17/10/2024
% DESCRIPTION: 
% This program performs the simulation of an adaptive PID control algorithm 
% for a 2DOF telescope modeled as a 2DOF robotic arm using Lagrange
% equations.
% IMPORTANT: 
% The telescope is modeled without taking into consideration the actuators
% and sensor errors, so the required torque is used as input.
%
% *************************************************************************

%%% Read simulation parameters
parameters;

%%% Adaptive PID Simulation performing regulation maneuvers
salidas=sim('adaptivePID.slx','SrcWorkspace','current');

%%% Read signals obtained from the simulation
 yout   = salidas.get('yout');
 t      = yout{1}.Values.Time;
 y      = yout{1}.Values.Data;
 u      = yout{2}.Values.Data;
 e      = yout{3}.Values.Data;
 flag   = yout{4}.Values.Data;
 theta1 = yout{5}.Values.Data;
 theta2 = yout{6}.Values.Data;

%%% Read and store signals in variables
u1=u(:,1); y1=y(:,1); e1=e(:,1);  %Define error, control signal and output
u2=u(:,2); y2=y(:,2); e2=e(:,2);  %Define error, control signal and output

%% Plot Figures obtained from data
figure()
sp1 = subplot(2,1,1);
    p1 = plot(t, rad2deg(y(:,1)), 'LineWidth', 2); hold on;
    p11 = plot(t, 60 * ones(1, length(y)), 'LineWidth', 2, 'LineStyle', '--');
    p2 = plot(t, rad2deg(y(:,2)), 'LineWidth', 2); grid on;
    p22 = plot(t, 45 * ones(1, length(y)), 'LineWidth', 2, 'LineStyle', '--');
    title('Azimuth and Elevation Angles');
    xlabel('Time (s)'); ylabel('Angle (deg)');
    legend([p1, p2], 'Azimuth', 'Elevation');

sp2 = subplot(2,1,2);
    p1 = plot(t, u(:,1), 'LineWidth', 2); hold on;
    p2 = plot(t, u(:,2), 'LineWidth', 2); grid on;
    xlabel('Time (s)'); ylabel('Torque (Nm)');
    legend([p1, p2], 'Azimuth', 'Elevation');

linkaxes([sp1, sp2], 'x');


 figure()
 sp1=subplot(2,1,1);
     p1=plot(t,theta1,'LineWidth',2); hold on;grid on;
     title('Links PID gains'); 
     xlabel('time (s)'); ylabel('Link 1 PID gains');
     legend('K_p','K_i','K_d');
 sp2=subplot(2,1,2);
     p1=plot(t,theta2,'LineWidth',2); hold on;grid on;
     xlabel('time (s)'); ylabel('Link 2 PID gains');
     legend('K_p','K_i','K_d');
     
%% Calculate the measured parameters
%%%%Calculate settlement time
ts1 = calculateSettlementTime(e1, t, 5/100);
ts2 = calculateSettlementTime(e2, t, 5/100);
%%%%Calculate the u^2_int
uwork1 = trapz(t,u1.^2);
uwork2 = trapz(t,u2.^2);
%%%%Calculate the e^2_int
itse1 = trapz(t,e1.^2);
itse2 = trapz(t,e2.^2);
%%%%Crea la tabla
T = table(ts1, ts2, uwork1, uwork2, itse1, itse2);
%%%%Muestra la tabla
disp(T);