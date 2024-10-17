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

%%Read simulation parameters
parameters;

%%Read Az and El parameters calculated for satellites.
readAzEl;
close all;

%%Organize signals to send to Simulink
signalAz = [(satData(2).sod-satData(2).sod(1)), satData(2).az]; 
signalEl = [(satData(2).sod-satData(2).sod(1)), satData(2).el]; 

%%%Elimination of magnetic Field
%%% PID Simulation
salidas=sim('adaptiveTracking.slx','SrcWorkspace','current');

 yout       = salidas.get('yout');
 t          = yout{1}.Values.Time;
 y          = yout{1}.Values.Data;
 u          = yout{2}.Values.Data;
 e          = yout{3}.Values.Data;
 flag       = yout{4}.Values.Data;
 theta1     = yout{5}.Values.Data;
 theta2     = yout{6}.Values.Data;

% It is common to have the system error as out1, the controller output u as
% out2, and the output y as out3
u1=u(:,1); y1=y(:,1); e1=e(:,1);%Define error, control signal and output
u2=u(:,2); y2=y(:,2); e2=e(:,2);%Define error, control signal and output
%% 

figure()
sp1 = subplot(2,1,1);
    p1 = plot(t,rad2deg(y(:,1)),'LineWidth',2); hold on;
    p11 = plot(signalAz(:,1),signalAz(:,2),'LineWidth',2,'LineStyle','--');
    p2 = plot(t,rad2deg(y(:,2)),'LineWidth',2); grid on;
    p22 = plot(signalEl(:,1),signalEl(:,2),'LineWidth',2,'LineStyle','--');
    title('Azimuth and Elevation Angles');
    xlabel('time (s)'); ylabel('Angle(deg)')
    legend([p1,p2],'Azimuth','Elevation')
sp2 = subplot(2,1,2);
    p1=plot(t,u(:,1),'LineWidth',2); hold on;
    p2=plot(t,u(:,2),'LineWidth',2); grid on;
    xlabel('time (s)'); ylabel('Torque(Nm)')
    legend([p1,p2],'Azimuth','Elevation')
linkaxes([sp1,sp2],'x');

%% 
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
%%
 figure()
 sp1=subplot(2,1,1);
     p1=plot(t,e1*180/pi,'LineWidth',2); hold on;grid on;
     title('Controller Errors'); 
     xlabel('time (s)'); ylabel('Link 1 error (deg)');
     legend('e_{az}');
 sp2=subplot(2,1,2);
     p2=plot(t,e2*180/pi,'LineWidth',2); hold on;grid on;
     xlabel('time (s)'); ylabel('Link 2 error (deg)');
     legend('e_{el}');
     linkaxes([sp1,sp2],'x');

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