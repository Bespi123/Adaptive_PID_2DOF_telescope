function data = readFrd(name)
%**************************************************************************
% AUTHOR: Brayan Espinoza 17/10/2024
% DESCRIPTION: 
% This program reads the .frd files which contains the azimuth and elevation
% angles for the TLRS-3 telescope. The angles were calculated by the computer
% from the AREL laser estation.
% IMPORTANT: 
%
% *************************************************************************
    %% Open file 
    fileID = fopen(name, 'r');  % Add 'r' to indicate read mode.
    if fileID == -1
        error('Cannot open file: %s', name);
    end
    
    %% Data containers
    data.name = '';  % Initialize as an empty string
    data.sod = [];   % Seconds of Day
    data.az = [];    % Azimuth
    data.el = [];    % Elevation

    %% Read Data
    while ~feof(fileID)
        tline = fgetl(fileID);  % Read line-by-line
        if length(tline) > 10
            switch tline(1:2)
                case 'h1'
                    % Parse station and satellite information (commented out).
                    % temp = sscanf(tline, '      Station = %s       Satellite = %s', 2);
                    % data.station = temp(1:4);
                    % data.satellite = temp(5:end);
                case 'h2'
                    % Parse OAM optical path (commented out).
                    % data.OAMopticalPath = sscanf(tline, '      OAM Optical Path = %f meters', 1);
                case 'h3'
                    % Parse the name (if 'h3' contains name information).
                    temp = sscanf(tline, 'h3 %s', 1);
                    data.name = temp;  % Save the name in the data structure.
                case 'h4'
                    % Parse target range and refraction index (commented out).
                    % data.range = sscanf(tline, '      Target Range = %f', 1);
                    % tline = fgetl(fileID);
                    % data.refractionIndex = sscanf(tline, '      Index of Refraction = %f', 1);
                case 'c0'
                    % Parse pre-calibration target (commented out).
                    % data.precalTarget = sscanf(tline, '     Pre Calibration     Target = %s', 1);
                case 'c1'
                    % Reserved for 'c1' processing (currently no operation).
                case 'c2'
                    % Reserved for 'c2' processing (currently no operation).
                case 'c3'
                    % Reserved for 'c3' processing (currently no operation).
                case '40'
                    % Reserved for '40' processing (currently no operation).
                case '30'
                    % Parse seconds of day (sod), azimuth (az), and elevation (el).
                    temp = sscanf(tline, '30 %f %f %f %d %d %d', [1 6]);
                    data.sod = [data.sod; temp(1)];
                    data.az = [data.az; temp(2)];
                    data.el = [data.el; temp(3)];
            end
        end
    end
    
    %% Close the file
    fclose(fileID);
end
