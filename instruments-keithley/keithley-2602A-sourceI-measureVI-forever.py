import argparse
import sys
from Keithley2602A import *
import signal 



parser = argparse.ArgumentParser(description='Source Voltage, Measure Voltage and Current with Keithley DMM')
parser.add_argument('nplc', metavar='-f', nargs='+',
                   help='number of power line cycles for data aquisition')
parser.add_argument('n_samples', metavar='-n', nargs='+',
                   help='number of samples')                   
parser.add_argument('voltage_range', metavar='-v', nargs='+',
                   help='voltage range')
parser.add_argument('current_range', metavar='-i', nargs='+',
                   help='current range')
parser.add_argument('current', metavar='-I', nargs='+',
                   help='current level')

args = parser.parse_args()


kei = Keithley2602A("kei-dmm")
script = "battery"
dmm_cmd = "source_i_measure_iv("+args.nplc[0]+","+args.n_samples[0]+","+args.voltage_range[0]+","+args.current_range[0]+","+args.current[0]+")"
print >> sys.stderr, "Command:", dmm_cmd

try :
	kei.runForever(script,dmm_cmd)
	print kei.recvbuffer
except KeyboardInterrupt :
	kei.abortScript()
	print >> sys.stderr,  "Stopping"
	sys.exit(0)
