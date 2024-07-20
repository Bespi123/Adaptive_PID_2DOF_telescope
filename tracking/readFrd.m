function data = readFrd(name)
    %% Open file 
    fileID = fopen(name);
    
    %% Data containers
    data.name='';
    data.sod=[]; %%seconds of Day
    data.az=[]; %%Azimuth
    data.el=[]; %%Elevation

    %% Read Data
    while ~feof(fileID)    
        tline = fgetl(fileID);
        if(length(tline)>10)
            if (strcmp(tline(1:2),'h1'))
                %temp = sscanf(tline,'      Station = %s       Satellite = %s  ', 2);
                %data.station=temp(1:4);
                %data.satellite=temp(5:end);
            elseif (strcmp(tline(1:2),'h2'))
                %data.OAMopticalPath = sscanf(tline,'      OAM Optical Path        =   %f meters', 1);
            elseif (strcmp(tline(1:2),'h3'))
                temp = sscanf(tline,'h3 %s', 1);
                data.name=temp;
            elseif (strcmp(tline(1:2),'h4'))
                %data.range=sscanf(tline,'      Target Range =  %f', 1);
                %tline = fgetl(fileID);
                %data.refractionIndex=sscanf(tline,'      Index of Refraction =  %f', 1);
            elseif (strcmp(tline(1:2),'c0'))
                %data.precalTarget = sscanf(tline,'     Pre Calibration     Target = %s', 1);
            elseif (strcmp(tline(1:2),'c1'))
            
            elseif (strcmp(tline(1:2),'c2'))
            
            elseif (strcmp(tline(1:2),'c3'))
                        
            elseif (strcmp(tline(1:2),'40'))
            
            elseif (strcmp(tline(1:2),'30'))
                temp = sscanf(tline,'30 %f %f  %f %d %d %d',[1 6]);
                data.sod=[data.sod;temp(1)];
                data.az=[data.az;temp(2)];
                data.el=[data.el;temp(3)];
            end
        end
    end
    fclose(fileID);
end