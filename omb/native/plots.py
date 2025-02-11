import pandas as pd
from matplotlib import pyplot as plt

def set_label(row):
    if row['Message_Size'] > 1000:
        val = int(row['Message_Size'] / 1024)
        label = str( val ) + "KB"
    else:
        label = str( int(row['Message_Size']) ) + "B"
    
    return str(int(row['Production_Rate'])) + ' m/s ' + label

def plot_row(row):
    df = pd.read_csv('result.csv')
    grouped_df = df.groupby('Test_Case').mean().reset_index()
    grouped_df['label'] = grouped_df.apply( set_label, axis=1 )
    
    plt.step(grouped_df['Test_Case'], grouped_df[row])
    plt.xticks(ticks=grouped_df['Test_Case'], labels=grouped_df['label'], rotation=90)
    plt.xlabel('Test Cases')
    plt.ylabel(row)
    plt.grid(True)
    plt.savefig(row + '.png', bbox_inches='tight')
    plt.clf()
    print('Plot ' + row + '.png generated')

plot_row('Latency_50')
plot_row('Latency_75')
plot_row('Latency_95')
plot_row('Latency_99')
