# Global Imports
from avro.datafile import DataFileReader
from avro.io import DatumReader
import json
import csv
import os
import pandas as pd

# Local Imports
import avro_to_dataframe

pwd = os.getcwd()
avro_file_folder_dir = pwd + '/Data/'
output_dir = pwd + '/Output'

thirty_min_files = os.listdir(avro_file_folder_dir)
thirty_min_files.remove('.gitkeep')

# List to hold filenames and their associated Unix timestamps
sorting_list = []

# Extract Unix timestamps and store the original filenames
for file in range(len(thirty_min_files)):
    filename = thirty_min_files[file]
    # Extract the Unix timestamp from the filename
    timestamp = filename.split('.avro')[0].split('_')[-1]
    
    # Append a tuple (timestamp, filename) to sorting_list
    sorting_list.append((int(timestamp), filename))

sorting_list.sort(key=lambda x: x[0])

# Extract the sorted filenames after sorting by timestamp
thirty_min_files = [file[1] for file in sorting_list]
    

df_list = []

# Init dataframe
df_accel = pd.DataFrame()
df_tags = pd.DataFrame()
df_eda = pd.DataFrame()
df_temps = pd.DataFrame()
df_bvp = pd.DataFrame()
df_sys_peaks = pd.DataFrame()
df_steps = pd.DataFrame()

for file in thirty_min_files:

    current_file = os.path.join(avro_file_folder_dir, file)
    temp_df_list = avro_to_dataframe.avro_to_dataframe(current_file)

    df_list.append(temp_df_list)

for df in temp_df_list:
        df.sort_values(by='ts', ascending=True, inplace=True)

for thirty_trial in df_list:
   df_accel = pd.concat([df_accel, thirty_trial[0]], ignore_index=True)
   # df_tags = pd.concat([df_tags, thirty_trial[5]], ignore_index=True)
   df_bvp = pd.concat([df_bvp, thirty_trial[1]], ignore_index=True)
   df_temps = pd.concat([df_temps, thirty_trial[3]], ignore_index=True)
   df_eda = pd.concat([df_eda, thirty_trial[2]], ignore_index=True)
   # df_sys_peaks = pd.concat([df_sys_peaks, thirty_trial[4]], ignore_index=True)
   # df_steps = pd.concat([df_steps, thirty_trial[6]], ignore_index=True)

print(df_accel)





# Exports
df_accel.to_csv(os.path.join(output_dir, 'accel.csv'), index=False)
df_tags.to_csv(os.path.join(output_dir, 'tags.csv'), index=False)
df_bvp.to_csv(os.path.join(output_dir, 'bvp.csv'), index=False)
df_temps.to_csv(os.path.join(output_dir, 'tmp.csv'), index=False)
df_eda.to_csv(os.path.join(output_dir, 'eda.csv'), index=False)
df_sys_peaks.to_csv(os.path.join(output_dir, 'sys_peaks.csv'), index=False)
df_steps.to_csv(os.path.join(output_dir, 'steps.csv'), index=False)





    
