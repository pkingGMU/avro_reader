%%% Ledalab Preprocess %%%
clc
clear

% Paths
data_folder_path = fullfile(pwd, 'output');
data_file = fullfile(data_folder_path, 'eda.csv');

% Reading in csv
full_raw_data = readmatrix(data_file);

% Edit THESE TIMES
start_unix = 1747319720046162;
end_unix = 1747319747974771;

% Edit this FILE NAME
file_name = 'trial1_test';

timestamps = full_raw_data(:, 1);

[~, start_idx] = min(abs(timestamps - start_unix));

[~, end_idx] = min(abs(timestamps - end_unix));

if start_idx > end_idx
    temp = start_idx;
    start_idx = end_idx;
    end_idx = temp;
end

raw_data = full_raw_data(start_idx:end_idx, :);

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
save(file_name, "data");






