%%% Ledalab Preprocess %%%
clc
clear

% Paths
data_folder_path = fullfile(pwd, 'data');
data_file = fullfile(data_folder_path, 'eda.csv');

% Reading in csv
raw_data = readmatrix(data_file);

% Add fake zero column
zero_col = zeros(height(raw_data), 1);

% Combine zero column to data 
data_zero = [raw_data zero_col];

% Remove random negative
data_zero(data_zero(:,2) <= 0, 2) = 0;

% Create data Struct
data = struct();
time = ((data_zero(:,1) / 1000000) - (data_zero(1,1) / 1000000));
data.conductance = (data_zero(:, 2))' / 1000000;
data.time = time';
data.timeoff = 0;

% Event Struct within data Struct
data.event = struct();
data.event.time = [];
data.event.nid = [];
data.event.name = [];
data.event.extension = [];

% Save mat file
save("eda_preprocess", "data");






