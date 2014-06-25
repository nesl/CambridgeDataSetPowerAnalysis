# Author: Lucas Wanner
# Updated by Mark Gottscho
# mgottscho@ucla.edu
# Based on NESL code at UCLA

import argparse
import sys
from Keithley2602A import *

# when feeding parameters to the python script,
# only put the numbers according to the below order.
# do not put the name of label of the parameter

# e.g. python keithley-2602A-sourceV-measureVI.py b 1000 1000 10 1 5

parser = argparse.ArgumentParser(description='Source Voltage, Measure Voltage and Current with Keithley 2602A Source Measure Unit')
parser.add_argument('channel', metavar='-c', nargs='+',
                   help='channel (a or b)')
parser.add_argument('sampling_frequency', metavar='-f', nargs='+',
                   help='sampling rate for data aquisition')
parser.add_argument('n_samples', metavar='-n', nargs='+',
                   help='number of samples')                   
parser.add_argument('voltage_range', metavar='-v', nargs='+',
                   help='voltage range')
parser.add_argument('current_range', metavar='-i', nargs='+',
                   help='current limit')
parser.add_argument('voltage_level', metavar='-V', nargs='+',
                   help='output voltage level')

args = parser.parse_args()

kei = Keithley2602A("kei-dmm")
script = "source_v_measure_iv_"+args.channel[0]
dmm_cmd = "source_v_measure_iv("+args.sampling_frequency[0]+","+args.n_samples[0]+","+args.voltage_range[0]+","+args.current_range[0]+","+args.voltage_level[0]+")"
print >> sys.stderr, "Command:", dmm_cmd

try :
	kei.runForever(script,dmm_cmd)
	print kei.recvbuffer
except KeyboardInterrupt :
	kei.abortScript()
	print >> sys.stderr,  "Stopping"
	sys.exit(0)
