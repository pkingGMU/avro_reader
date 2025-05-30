%% Cognitive Workload Data Parser
% Connor Delaney

close all
clear
clc
format longG

addpath("XDF_functions/")

%% Load Data
% Use xdf file full path
file = fullfile(pwd, "/xdf_input/LLPVR007_VR.xdf");
streams = load_xdf(file);

% Set file save name
saveFileName = "testxdfcsv";

%% Collect indices of each stream
% Find the data from each of the devices
% Record the meta-information for the streams
% Ensure the data is in the correct order
for i = 1:length(streams)
    stream = streams{1,i};
    
    if ~isempty(stream.time_series)
        % Empatica Streams
        if contains(stream.info.name,'Empatica_Acc')
            Data.Emp.Acc.time_series = stream.time_series;
            Data.Emp.Acc.time_stamps = stream.time_stamps;
            [Data.Emp.Acc.time_stamps, sortedInds] = sort(Data.Emp.Acc.time_stamps);
            Data.Emp.Acc.time_series = Data.Emp.Acc.time_series(:,sortedInds);
            Data.Emp.Acc.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Emp.Acc.channel_labels = {'X'; 'Y'; 'Z'};
            Data.Emp.Acc.channel_units = {'1/64g'; '1/64g'; '1/64g'};
        end

        if contains(stream.info.name,'Empatica_BVP')
            Data.Emp.BVP.time_series = stream.time_series;
            Data.Emp.BVP.time_stamps = stream.time_stamps;
            [Data.Emp.BVP.time_stamps, sortedInds] = sort(Data.Emp.BVP.time_stamps);
            Data.Emp.BVP.time_series = Data.Emp.BVP.time_series(:,sortedInds);
            Data.Emp.BVP.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Emp.BVP.channel_labels = {'BVP'};
            Data.Emp.BVP.channel_units = {'unitless'};
        end

        if contains(stream.info.name,'Empatica_IBI')
            Data.Emp.IBI.time_series = stream.time_series;
            Data.Emp.IBI.time_stamps = stream.time_stamps;
            [Data.Emp.IBI.time_stamps, sortedInds] = sort(Data.Emp.IBI.time_stamps);
            Data.Emp.IBI.time_series = Data.Emp.IBI.time_series(:,sortedInds);
            Data.Emp.IBI.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Emp.IBI.channel_labels = {'Time Between Beats'};
            Data.Emp.IBI.channel_units = {'Seconds'};
        end

        if contains(stream.info.name,'Empatica_GSR')
            Data.Emp.EDA.time_series = stream.time_series;
            Data.Emp.EDA.time_stamps = stream.time_stamps;
            [Data.Emp.EDA.time_stamps, sortedInds] = sort(Data.Emp.EDA.time_stamps);
            Data.Emp.EDA.time_series = Data.Emp.EDA.time_series(:,sortedInds);
            Data.Emp.EDA.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Emp.EDA.channel_labels = {'Electrodermal Activity'};
            Data.Emp.EDA.channel_units = {'Microsiemens (\muS)'};
        end

        if contains(stream.info.name,'Empatica_Tmp')
            Data.Emp.Temp.time_series = stream.time_series;
            Data.Emp.Temp.time_stamps = stream.time_stamps;
            [Data.Emp.Temp.time_stamps, sortedInds] = sort(Data.Emp.Temp.time_stamps);
            Data.Emp.Temp.time_series = Data.Emp.Temp.time_series(:,sortedInds);
            Data.Emp.Temp.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Emp.Temp.channel_labels = {'Skin Temperature'};
            Data.Emp.Temp.channel_units = {'Degrees Celsius'};
        end
    
        % Muse Streams
        if contains(stream.info.name,'Muse','IgnoreCase',true) && contains(stream.info.name,'EEG','IgnoreCase',true)
            Data.Muse.EEG.time_series = stream.time_series;
            Data.Muse.EEG.time_stamps = stream.time_stamps;
            [Data.Muse.EEG.time_stamps, sortedInds] = sort(Data.Muse.EEG.time_stamps);
            Data.Muse.EEG.time_series = Data.Muse.EEG.time_series(:,sortedInds);
            Data.Muse.EEG.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Muse.EEG.channel_labels = {stream.info.desc.channels.channel{1,1}.label; stream.info.desc.channels.channel{1,2}.label; stream.info.desc.channels.channel{1,3}.label; stream.info.desc.channels.channel{1,4}.label; stream.info.desc.channels.channel{1,5}.label};
            Data.Muse.EEG.channel_units = {stream.info.desc.channels.channel{1,1}.unit; stream.info.desc.channels.channel{1,2}.unit; stream.info.desc.channels.channel{1,3}.unit; stream.info.desc.channels.channel{1,4}.unit; stream.info.desc.channels.channel{1,5}.unit};
        end

        if contains(stream.info.name,'Muse','IgnoreCase',true) && contains(stream.info.name,'PPG','IgnoreCase',true)
            Data.Muse.PPG.time_series = stream.time_series;
            Data.Muse.PPG.time_stamps = stream.time_stamps;
            [Data.Muse.PPG.time_stamps, sortedInds] = sort(Data.Muse.PPG.time_stamps);
            Data.Muse.PPG.time_series = Data.Muse.PPG.time_series(:,sortedInds);
            Data.Muse.PPG.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Muse.PPG.channel_labels = {'PPG Ambient'; 'PPG IR'; 'PPG Red'};
            Data.Muse.PPG.channel_units = {stream.info.desc.channels.channel{1,1}.unit; stream.info.desc.channels.channel{1,2}.unit; stream.info.desc.channels.channel{1,3}.unit};
        end
    
        if contains(stream.info.name,'Muse','IgnoreCase',true) && contains(stream.info.name,'Accelerometer','IgnoreCase',true)
            Data.Muse.Acc.time_series = stream.time_series;
            Data.Muse.Acc.time_stamps = stream.time_stamps;
            [Data.Muse.Acc.time_stamps, sortedInds] = sort(Data.Muse.Acc.time_stamps);
            Data.Muse.Acc.time_series = Data.Muse.Acc.time_series(:,sortedInds);
            Data.Muse.Acc.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Muse.Acc.channel_labels = {stream.info.desc.channels.channel{1,1}.label; stream.info.desc.channels.channel{1,2}.label; stream.info.desc.channels.channel{1,3}.label};
            Data.Muse.Acc.channel_units = {stream.info.desc.channels.channel{1,1}.unit; stream.info.desc.channels.channel{1,2}.unit; stream.info.desc.channels.channel{1,3}.unit};
        end

        if contains(stream.info.name,'Muse','IgnoreCase',true) && contains(stream.info.name,'Gyroscope','IgnoreCase',true)
            Data.Muse.Gyro.time_series = stream.time_series;
            Data.Muse.Gyro.time_stamps = stream.time_stamps;
            [Data.Muse.Gyro.time_stamps, sortedInds] = sort(Data.Muse.Gyro.time_stamps);
            Data.Muse.Gyro.time_series = Data.Muse.Gyro.time_series(:,sortedInds);
            Data.Muse.Gyro.sampling_rate = str2num(stream.info.nominal_srate);
            Data.Muse.Gyro.channel_labels = {stream.info.desc.channels.channel{1,1}.label; stream.info.desc.channels.channel{1,2}.label; stream.info.desc.channels.channel{1,3}.label};
            Data.Muse.Gyro.channel_units = {stream.info.desc.channels.channel{1,1}.unit; stream.info.desc.channels.channel{1,2}.unit; stream.info.desc.channels.channel{1,3}.unit};
        end

        % Time Stream
        if contains(stream.info.name,'Time') && contains(stream.info.type,'Markers')
            Data.Time.time_series = stream.time_series;
            Data.Time.time_stamps = stream.time_stamps;
            [Data.Time.time_stamps, sortedInds] = sort(Data.Time.time_stamps);
            Data.Time.time_series = Data.Time.time_series(:,sortedInds);
            Data.Time.labels = {'Time'};
        end

        % Audio Stream
        if contains(stream.info.name,'Audio')
            Data.Audio.time_series = stream.time_series;
            Data.Audio.time_stamps = stream.time_stamps;
            [Data.Audio.time_stamps, sortedInds] = sort(Data.Audio.time_stamps);
            Data.Audio.time_series = Data.Audio.time_series(:,sortedInds);
            Data.Audio.labels = {'Amplitude'};
        end
    end

end

%% Align Empatica and Muse time stamps to PC time
% Get actual recording start time
StartTimes = split(Data.Time.time_series(1));
Data.Time.RealStartTime = str2double(StartTimes(2,1));

%% Correct Muse and Empatica Times to Local Time
if isfield(Data,'Muse')
    MuseTimeConversion = -4 * 60 * 60;
    Data.Muse.Acc.time_stamps = Data.Muse.Acc.time_stamps + MuseTimeConversion;
    Data.Muse.EEG.time_stamps = Data.Muse.EEG.time_stamps + MuseTimeConversion;
    Data.Muse.Gyro.time_stamps = Data.Muse.Gyro.time_stamps + MuseTimeConversion;
    Data.Muse.PPG.time_stamps = Data.Muse.PPG.time_stamps + MuseTimeConversion;
end

if isfield(Data,'Emp')
    EmpTimeConversion = -4 * 60 * 60;
    Data.Emp.Acc.time_stamps = Data.Emp.Acc.time_stamps + EmpTimeConversion;
    Data.Emp.EDA.time_stamps = Data.Emp.EDA.time_stamps + EmpTimeConversion;
    Data.Emp.Temp.time_stamps = Data.Emp.Temp.time_stamps + EmpTimeConversion;
    Data.Emp.BVP.time_stamps = Data.Emp.BVP.time_stamps + EmpTimeConversion;
    if isfield(Data.Emp,'IBI')
        Data.Emp.IBI.time_stamps = Data.Emp.IBI.time_stamps + EmpTimeConversion;
    end
end

%% Correct Muse and Empatica internal clocks by a few seconds
% Corrects the time difference between device times and PC times

% Muse
if isfield(Data,'Muse')
    Data.Muse.EEG.time_diff = Data.Time.RealStartTime - Data.Muse.EEG.time_stamps(1);
    Data.Muse.EEG.time_stamps = Data.Muse.EEG.time_stamps + Data.Muse.EEG.time_diff;
    
    Data.Muse.Acc.time_diff = Data.Time.RealStartTime - Data.Muse.Acc.time_stamps(1);
    Data.Muse.Acc.time_stamps = Data.Muse.Acc.time_stamps + Data.Muse.Acc.time_diff;
    
    Data.Muse.Gyro.time_diff = Data.Time.RealStartTime - Data.Muse.Gyro.time_stamps(1);
    Data.Muse.Gyro.time_stamps = Data.Muse.Gyro.time_stamps + Data.Muse.Gyro.time_diff;
    
    Data.Muse.PPG.time_diff = Data.Time.RealStartTime - Data.Muse.PPG.time_stamps(1);
    Data.Muse.PPG.time_stamps = Data.Muse.PPG.time_stamps + Data.Muse.PPG.time_diff;
end

% Empatica
if isfield(Data,'Emp')
    Data.Emp.Acc.time_diff = Data.Time.RealStartTime - Data.Emp.Acc.time_stamps(1);
    Data.Emp.Acc.time_stamps = Data.Emp.Acc.time_stamps + Data.Emp.Acc.time_diff;
    
    Data.Emp.BVP.time_diff = Data.Time.RealStartTime - Data.Emp.BVP.time_stamps(1);
    Data.Emp.BVP.time_stamps = Data.Emp.BVP.time_stamps + Data.Emp.BVP.time_diff;
    
    if isfield(Data.Emp,'IBI')
        Data.Emp.IBI.time_diff = Data.Time.RealStartTime - Data.Emp.IBI.time_stamps(1);
        Data.Emp.IBI.time_stamps = Data.Emp.IBI.time_stamps + Data.Emp.IBI.time_diff;
    end 
    
    Data.Emp.Temp.time_diff = Data.Time.RealStartTime - Data.Emp.Temp.time_stamps(1);
    Data.Emp.Temp.time_stamps = Data.Emp.Temp.time_stamps + Data.Emp.Temp.time_diff;
    
    Data.Emp.EDA.time_diff = Data.Time.RealStartTime - Data.Emp.EDA.time_stamps(1);
    Data.Emp.EDA.time_stamps = Data.Emp.EDA.time_stamps + Data.Emp.EDA.time_diff;
end

% Audio
if isfield(Data,'Audio')
    Data.Audio.time_diff = Data.Time.RealStartTime - Data.Audio.time_stamps(1);
    Data.Audio.time_stamps = Data.Audio.time_stamps + Data.Audio.time_diff;
end

%%

save_data_time = double(Data.Emp.EDA.time_stamps') * 1000000;
%%
save_data = double(Data.Emp.EDA.time_series');

save_table = table();
save_table(:,1) = table(save_data_time);
save_table(:,2) = table(save_data);


%%
writetable(save_table, fullfile(pwd, "Output", "eda.csv"))


