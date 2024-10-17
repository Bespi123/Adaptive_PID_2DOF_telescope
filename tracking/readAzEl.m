%% Read Az and El files
%**************************************************************************
% AUTHOR: Brayan Espinoza 17/10/2024
% DESCRIPTION: 
% This program reads the .frd files which contains the azimuth and elevation
% angles for the TLRS-3 telescope. The angles were calculated by the computer
% from the AREL laser estation.
% IMPORTANT: 
%
% *************************************************************************

%Read .sm files
frdFiles = dir('tracking/BRAYAN/*/*e?????????.frd'); %% Read Laser files
%Read .frd files
%%Change to your data directory

for i=1:length(frdFiles)
    disp(frdFiles(i).name)
    satData(i) = readFrd(strcat(frdFiles(i).folder,'\',frdFiles(i).name));
end

%%% Plot azimuth and elevation data for all satellites
for i = 1:length(satData)
    figure();
    sp1 = subplot(2, 1, 1);
        plot(satData(i).sod - satData(i).sod(1), satData(i).az,'LineStyle','--','LineWidth',2); 
        grid on;
        title(satData(i).name);  % Use the satellite name for the title
        xlabel('Seconds (s)'); 
        ylabel('Azimuth (deg)');
    
    sp2 = subplot(2, 1, 2);
        plot(satData(i).sod - satData(i).sod(1), satData(i).el,'LineStyle','--','LineWidth',2); 
        grid on;
        xlabel('Seconds (s)'); 
        ylabel('Elevation (deg)');
    linkaxes([sp1,sp2],'x');
end