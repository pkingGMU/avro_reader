# Global Imports
from avro.datafile import DataFileReader
from avro.io import DatumReader
import json
import csv
import os
import pandas as pd

def avro_to_dataframe(current_file):

    temp_df_list = []

    ## Read Avro file
    reader = DataFileReader(open(current_file, 'rb'), DatumReader())
    schema = json.loads(reader.meta.get('avro.schema').decode('utf-8'))
    data = next(reader)

    # Init dataframe
    df_accel = pd.DataFrame()
    df_tags = pd.DataFrame()
    df_eda = pd.DataFrame()
    df_temps = pd.DataFrame()
    df_bvp = pd.DataFrame()
    df_sys_peaks = pd.DataFrame()
    df_steps = pd.DataFrame()
    # Print avro schema
    # print(schema)

    ## Export sensors data to csv

    # Accelerometer
    acc = data['rawData']['accelerometer']
    timestamp = [round(acc['timestampStart'] + i * (1e6 / acc['samplingFrequency'])) for i in range(len(acc['x']))]

    # Convert ADC counts in g
    delta_physical = acc['imuParams']['physicalMax'] - acc['imuParams']['physicalMin']
    delta_digital = acc['imuParams']['digitalMax'] - acc['imuParams']['digitalMin']
    x_g = [val * delta_physical / delta_digital for val in acc['x']]
    y_g = [val * delta_physical / delta_digital for val in acc['y']]
    z_g = [val * delta_physical / delta_digital for val in acc['z']]

    df_accel['ts'] = timestamp
    df_accel['accel_x'] = x_g
    df_accel['accel_y'] = y_g
    df_accel['accel_z'] = z_g

    # Gyroscope
    gyro = data['rawData']['gyroscope']
    timestamp = [round(gyro['timestampStart'] + i * (1e6 / gyro['samplingFrequency'])) for i in range(len(gyro['x']))]

    # Add to df
    #df['gyro_x'] = gyro['x']
    #df['gyro_x'] = gyro['y']
    #df['gyro_x'] = gyro['z']

    # EDA
    eda = data['rawData']['eda']
    timestamp = [round(eda['timestampStart'] + i * (1e6 / eda['samplingFrequency'])) for i in range(len(eda['values']))]
    print(len(eda['values']))

    df_eda['ts'] = timestamp
    df_eda['EDA'] = eda['values']
    df_eda['EDA'] = df_eda['EDA'] * 1000000

    # Temperature
    tmp = data['rawData']['temperature']
    timestamp = [round(tmp['timestampStart'] + i * (1e6 / tmp['samplingFrequency'])) for i in range(len(tmp['values']))]

    df_temps['ts'] = timestamp
    df_temps['Temp'] = tmp['values']

    # Tags
    tags = data['rawData']['tags']
    df_tags['tags'] = tags=['tagsTimeMicros']

    # BVP
    bvp = data['rawData']['bvp']
    timestamp = [round(bvp['timestampStart'] + i * (1e6 / bvp['samplingFrequency'])) for i in range(len(bvp['values']))]

    df_bvp['ts'] = timestamp
    df_bvp['BVP'] = bvp['values']

    # Systolic peaks
    sys = data['rawData']['systolicPeaks']
    df_sys_peaks['Systolic Peaks Timestamps'] =  sys["peaksTimeNanos"]

    # Steps
    steps = data["rawData"]["steps"] 
    timestamp = [round(steps["timestampStart"] + i * (1e6 / steps["samplingFrequency"])) for i in range(len(steps["values"]))]

    df_steps['ts'] = timestamp
    df_steps['STEPS'] = steps['values']

    temp_df_list.append(df_accel)
    temp_df_list.append(df_bvp)
    temp_df_list.append(df_eda)
    temp_df_list.append(df_temps)
    # temp_df_list.append(df_sys_peaks)
    # temp_df_list.append(df_tags)
    # temp_df_list.append(df_steps)

    # Reverse the order of each dataframe based on the timestamp
    

    return temp_df_list