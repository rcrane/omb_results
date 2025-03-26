import numpy as np 
import pandas as pd
from matplotlib import pyplot as plt

def get_dfs(data):
    #data1 = data[ data['Security'] == 'Non-Secure' ]
    #data2 = data[ data['Security'] == 'Secure' ]
    data1 = data[ (data['Security'] == 'Non-Secure') & (data['Test_Case'] != 'TC12') ]
    data2 = data[ (data['Security'] == 'Secure') & (data['Test_Case'] != 'TC12') ]
    return data1, data2

def get_security(data):
    return data['Security'].iloc[0]

def get_label(row):
    if int(row['Message_Size']) == 100:
        size = '100B'
    elif int(row['Message_Size']) == 1024:
        size = '1KB'
    elif int(row['Message_Size']) == 10240:
        size = '10KB'
    elif int(row['Message_Size']) == 102400:
        size = '100KB'
    return size + ' | ' + str(int(row['Producer_Rate'])) + ' m/s'

def plot_two_classes(data1, data2, row, label, title):
    labels = list(data1.apply(get_label, axis=1))
    
    #plt.step(labels, data1[row], where='post', label=get_security(data1) )
    #plt.step(labels, data2[row], where='post', label=get_security(data2))
    plt.plot(labels, data1[row], label=get_security(data1) )
    plt.plot(labels, data2[row], label=get_security(data2) )
    
    plt.legend()
    plt.xticks(rotation=90)
    plt.ylabel(label)
    plt.title(title)
    plt.grid(True)
    plt.savefig(label + '.png', bbox_inches='tight')
    plt.clf()
    print('Plot ' + label + '.png generated')

df = pd.read_csv('result_mean.csv')
df1, df2 = get_dfs(df)

plot_two_classes(df1, df2, 'OMB_Latency_50', 'Write Latency 50', 'OpenMessaging Benchmark: Secured vs Non-Securde')
plot_two_classes(df1, df2, 'OMB_Latency_75', 'Write Latency 75', 'OpenMessaging Benchmark: Secured vs Non-Securde')
plot_two_classes(df1, df2, 'OMB_Latency_95', 'Write Latency 95', 'OpenMessaging Benchmark: Secured vs Non-Securde')
plot_two_classes(df1, df2, 'OMB_Latency_99', 'Write Latency 99', 'OpenMessaging Benchmark: Secured vs Non-Securde')
plot_two_classes(df1, df2, 'OMB_Throughout', 'Throughout',       'OpenMessaging Benchmark: Secured vs Non-Securde')

#-----------------------------------------------------------------------

def transform_df(data):
    res = {
        'Latency': ['Latency 50', 'Latency 75', 'Latency 95', 'Latency 99'],
        'Secure': [],
        'Non-Secure': []
    }
    
    row = data['OMB_Latency_50']
    res['Non-Secure'].append( row.iloc[0] )
    res['Secure'].append( row.iloc[1] )
    row = data['OMB_Latency_75']
    res['Non-Secure'].append( row.iloc[0] )
    res['Secure'].append( row.iloc[1] )
    row = data['OMB_Latency_95']
    res['Non-Secure'].append( row.iloc[0] )
    res['Secure'].append( row.iloc[1] )
    row = data['OMB_Latency_99']
    res['Non-Secure'].append( row.iloc[0] )
    res['Secure'].append( row.iloc[1] )
    return pd.DataFrame(res)

def tc_12(data):
    labels = ['50%', '75%', '95%', '99%']
    
    plt.plot(labels, data['Non-Secure'], label='Non-Secure')
    plt.plot(labels, data['Secure'], label='Secure')
    plt.ylabel('Write Latencies')
    plt.title('Test Case: File Size 100KB and Producer Rate 10000 m/s')
    plt.legend()
    plt.grid(True)
    plt.savefig('TC12.png', bbox_inches='tight')
    plt.clf()
    print('Plot TC12.png generated')

df = pd.read_csv('result_mean.csv')
df = df[ df['Test_Case'] == 'TC12' ]
res = transform_df(df)
tc_12(res)

#-----------------------------------------------------------------------

def plot_cdf(data1, data2, row):
    count, bins_count = np.histogram(data1[row], bins=10)
    pdf = count / sum(count)
    cdf = np.cumsum(pdf)
    plt.plot(bins_count[1:], cdf, label='Non-Secured')

    count, bins_count = np.histogram(data2[row], bins=10)
    pdf = count / sum(count)
    cdf = np.cumsum(pdf)
    plt.plot(bins_count[1:], cdf, label='Secured')
    
    plt.legend()
    plt.xlabel(row)
    plt.title('Write Latencies CDF')
    plt.grid(True)
    
    plt.savefig('CDF ' + row + '.png', bbox_inches='tight')
    plt.clf()
    print('Plot CDF ' + row + '.png generated')

df = pd.read_csv('result.csv')
df1, df2 = get_dfs(df)
plot_cdf(df1, df2, 'OMB_Latency_50')
plot_cdf(df1, df2, 'OMB_Latency_75')
plot_cdf(df1, df2, 'OMB_Latency_95')
plot_cdf(df1, df2, 'OMB_Latency_99')
