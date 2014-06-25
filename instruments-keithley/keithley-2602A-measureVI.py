import argparse
import sys
from Keithley2602A import *

parser = argparse.ArgumentParser(description='Measure Voltage and Current with Keithley DMM')
parser.add_argument('sampling_frequency', metavar='-f', nargs='+',
                   help='sampling rate for data aquisition')
parser.add_argument('n_samples', metavar='-n', nargs='+',
                   help='number of samples')                   
parser.add_argument('voltage_range', metavar='-v', nargs='+',
                   help='voltage range')
parser.add_argument('current_range', metavar='-i', nargs='+',
                   help='current range')


args = parser.parse_args()

kei = Keithley2602A("kei-dmm")
script = "curr_volt"
dmm_cmd = "measure_curr_volt("+args.sampling_frequency[0]+","+args.n_samples[0]+","+args.voltage_range[0]+","+args.current_range[0]+")"
print >> sys.stderr, "Command:", dmm_cmd


kei.run(script,dmm_cmd)
print kei.recvbuffer
