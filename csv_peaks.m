clc
clear

% Paths
data_folder_path = fullfile(pwd, 'output');
data_file = fullfile(data_folder_path, 'eda.csv');

% Reading in csv
full_raw_data = readmatrix(data_file);

% Edit THESE TIMES
%start_unix = 1746563941060330; % Beginning of Low Trial
%end_unix = 1746563945810330; % Beginning of Low Trial

%start_unix = 1747323829084160; % Beginning of High Trial
%end_unix = 1747323833834170; % Beginning of High Trials

start_unix = 1747324105084210; % End of High Trial
end_unix = 1747324108834210; % End of Low Trial


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

raw_data = full_raw_data(start_idx:end_idx, :) / 1000000;
%raw_data = full_raw_data(:, :) / 1000000;

raw_data(raw_data(:,2) <= 0, 2) = 0;

% Add fake zero column
zero_col = zeros(height(raw_data), 1);

% Combine zero column to data 
data_zero = [raw_data zero_col];

% Remove random negative
data_zero(data_zero(:,2) <= 0, 2) = 0;

% Parameters
order = 3;              
cutoff = 0.5;           
fs = 4;               

Wn = cutoff / (fs/2);   

[b, a] = butter(order, Wn, 'high');
y = abs(filtfilt(b, a, raw_data(:,2)));

[value, x] = findpeaks(y, 'MinPeakProminence', .001);

num_peaks = length(value);

real_eda = raw_data(x, 2);

figure;

plot(y)