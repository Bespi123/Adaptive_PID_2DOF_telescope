%**************************************************************************
% AUTHOR: Brayan Espinoza 17/10/2024
% DESCRIPTION: 
% This program perform the attitude simulation between three diferent 
% control laws. The CubeSat rigid body model takes into acount the reaction
% wheels inertia contributions to the Body inertia tensor. The inertial frame 
% and the reference frame in this simulation are considered equal and all
% the paramteters are expresed in the body frame. The script also models
% the gravity gradient torque and the disturbances produced by reaction
% wheels misaligments.
% IMPORTANT: 
% The CubeSat model doesn't takes into account the electric torque and
% the dinamic model for brushless motor used in reaction wheels. The rw
% friction is removed because this will be take into account in the
% brushless motor model that will be implemeted in the later versions.
% *************************************************************************


%%% Read simulation parameters
parameters

%%% PID Simulation
salidas=sim('adaptivePID.slx','SrcWorkspace','current');

 yout       = salidas.get('yout');
 t      = yout{1}.Values.Time;
 y      = yout{1}.Values.Data;
 u  = yout{2}.Values.Data;
 e      = yout{3}.Values.Data;
 flag   = yout{4}.Values.Data;
 theta1 = yout{5}.Values.Data;
 theta2 = yout{6}.Values.Data;

 % It is common to have the system error as out1, the controller output u as
% out2, and the output y as out3
u1=u(:,1); y1=y(:,1); e1=e(:,1);%Define error, control signal and output
u2=u(:,2); y2=y(:,2); e2=e(:,2);%Define error, control signal and output
%% 

figure()
sp1 = subplot(2,1,1);
    p1 = plot(t,rad2deg(y(:,1)),'LineWidth',2); hold on;
    p11 = plot(t,60*ones(1,length(y)),'LineWidth',2,'LineStyle','--');
    p2 = plot(t,rad2deg(y(:,2)),'LineWidth',2); grid on;
    p22 = plot(t,45*ones(1,length(y)),'LineWidth',2,'LineStyle','--');
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

     ts1 = calculateSettlementTime(e1, t, 5/100)
     ts2 = calculateSettlementTime(e2, t, 5/100)

     uwork1 = trapz(t,u1.^2)
     uwork2 = trapz(t,u2.^2)

     itse1 = trapz(t,e1.^2)
     itse2 = trapz(t,e2.^2)