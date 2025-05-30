clc
clear

addpath("XDF_functions/")

% Paths
data_folder_path = fullfile(pwd, 'output');
data_file = fullfile(data_folder_path, 'eda.csv');

% Reading in csv
full_raw_data = readmatrix(data_file);

% Edit THESE TIMES

%start_unix = 1746563941060330; % Beginning of Start High Trial
%end_unix = 1746563945810330; % End of Start High Trial

start_unix = 1732043405627670; % Beginning of End High Trial
end_unix = 1732044873127670; % End of End High Trial


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

% Use this line if Embrace
raw_data = full_raw_data(start_idx:end_idx, :) / 1000000;

% Use this line if XDF
raw_data = full_raw_data(start_idx:end_idx, :);

raw_data(raw_data(:,2) <= 0, 2) = 0;


% Parameters
order = 4;              
cutoff = .5;           
fs = 4;               

Wn = cutoff / (fs/2);   

[b, a] = butter(order, Wn, 'high');
y = abs(filtfilt(b, a, raw_data(:,2)));

[value, x] = findpeaks(y, 'MinPeakProminence', .001);

num_peaks = length(value);

real_eda = raw_data(x, 2);

figure;

plot(y)