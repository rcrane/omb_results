import os
import json
import glob
import pandas as pd

def get_json_logs():
    directory = os.path.dirname(os.path.abspath(__file__)) + '/'
    extension = '*.json'
    
    file_list = glob.glob(os.path.join(directory, extension))
    file_list.sort()
    return file_list

def get_testcase(file_path):
    directory = os.path.dirname(os.path.abspath(__file__)) + '/'
    return file_path.replace(directory, '')[0:4]

def get_metadata():
    tmp       = os.path.dirname(os.path.abspath(__file__))
    directory = os.path.abspath(os.path.join(tmp, '..', '..'))
    meta_file = directory + '/benchmark.csv'
    
    return pd.read_csv(meta_file)

def get_production_rate(df, test_case):
    df = df[ df['Test_Case'] == test_case]['Production_Rate']
    return df.iloc[0]

report_data = {
    'Test_Case': [],
    'Production_Rate': [],
    'Latency_50': [],
    'Latency_75': [],
    'Latency_95': [],
    'Latency_99': [],
    'Message_Size': [],
    'Sent_Messages': [],
    'Sent_Bytes': [],
    'Duration': [],
    'Throughout': []
}

meta_data = get_metadata()
file_list = get_json_logs()
for file_path in file_list:
    with open(file_path, 'r') as file:
        data = json.load(file)
    
    name = get_testcase(file_path)
    report_data['Test_Case'].append(name)
    report_data['Production_Rate'].append( get_production_rate(meta_data, name) )
    report_data['Latency_50'].append( data.get('aggregatedPublishLatency50pct') )
    report_data['Latency_75'].append( data.get('aggregatedPublishLatency75pct') )
    report_data['Latency_95'].append( data.get('aggregatedPublishLatency95pct') )
    report_data['Latency_99'].append( data.get('aggregatedPublishLatency99pct') )
    report_data['Message_Size'].append( data.get('messageSize') )
    report_data['Sent_Messages'].append( data.get('totalMessagesSent') )
    
    Sent_Bytes = data.get('totalBytesSent')
    Duration   = 5
    Throughout = (Sent_Bytes*0.000001)/(Duration*60)
    report_data['Sent_Bytes'].append( Sent_Bytes )
    report_data['Duration'].append( Duration )
    report_data['Throughout'].append( (Sent_Bytes*0.000001)/(Duration*60) )

df = pd.DataFrame(report_data)
df.to_csv('result.csv', index=False)
print('Metrics written in result.csv')
