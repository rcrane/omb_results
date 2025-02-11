import os
import json
import glob
import pandas as pd

directory = './'
extension = '*.json'


report_data = {
    'Test_Case': [],
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

file_list = glob.glob(os.path.join(directory, extension))
file_list.sort()
for file_path in file_list:
    with open(file_path, 'r') as file:
        data = json.load(file)
    
    report_data['Test_Case'].append(file_path[2:6])
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
