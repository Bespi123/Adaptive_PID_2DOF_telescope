%% Read Az and El files
%Read .sm files
frdFiles = dir('BRAYAN/*/*e?????????.frd'); %% Read Laser files
%Read .frd files
%%Change to your data directory
for i=1:length(frdFiles)
    disp(frdFiles(i).name)
    satData(i) = readFrd(strcat(frdFiles(i).folder,'\',frdFiles(i).name));
end

%%%Plot read az and elevation Read
figure()
subplot(2,1,1)
plot(satData(1).sod-satData(1).sod(1), satData(1).az); grid on;
title(satData(1).name);
xlabel('seconds (s)'); ylabel('Azimuth (deg)');
subplot(2,1,2)
plot(satData(1).sod-satData(1).sod(1), satData(1).el); grid on;
xlabel('seconds (s)'); ylabel('Elevation (deg)');

figure()
subplot(2,1,1)
plot(satData(2).sod-satData(2).sod(1), satData(2).az); grid on;
title(satData(2).name);
xlabel('seconds (s)'); ylabel('Azimuth (deg)');
subplot(2,1,2)
plot(satData(2).sod-satData(2).sod(1), satData(2).el); grid on;
xlabel('seconds (s)'); ylabel('Elevation (deg)');

figure()
subplot(2,1,1)
plot(satData(3).sod-satData(3).sod(1), satData(3).az); grid on;
title(satData(3).name);
xlabel('seconds (s)'); ylabel('Azimuth (deg)');
subplot(2,1,2)
plot(satData(3).sod-satData(3).sod(1), satData(3).el); grid on;
xlabel('seconds (s)'); ylabel('Elevation (deg)');

figure()
subplot(2,1,1)
plot(satData(4).sod-satData(4).sod(1), satData(4).az); grid on;
title(satData(4).name);
xlabel('seconds (s)'); ylabel('Azimuth (deg)');
subplot(2,1,2)
plot(satData(4).sod-satData(4).sod(1), satData(4).el); grid on;
xlabel('seconds (s)'); ylabel('Elevation (deg)');