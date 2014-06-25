# Authors: Lucas Wanner, Salma Elmalaki, and Mark Gottscho
# mgottscho@ucla.edu
# Based on NESL code at UCLA

import argparse
import sys
import array
from Keithley2602A import *

# when feeding parameters to the python script,
# only put the numbers according to the below order.
# do not put the name of label of the parameter

# e.g. python keithley-2602A-sourceV-measureVI.py b 1000 1000 10 1 5

parser = argparse.ArgumentParser(description='Source Voltage, Measure Voltage and Current with Keithley 2602A Source Measure Unit on channel B')
parser.add_argument('nplc', metavar='-f', nargs='+',
                   help='nplc for data acquisition')
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
script = "source_v_measure_iv_b_nplc"
dmm_cmd = "source_v_measure_iv_nplc("+args.nplc[0]+","+args.n_samples[0]+","+args.voltage_range[0]+","+args.current_range[0]+","+args.voltage_level[0]+")"
print >> sys.stderr, "Command:", dmm_cmd

kei.run(script,dmm_cmd)
print kei.recvbuffer
#print array.array('B', kei.recvbuffer)
#filebyte_array = bytearray(kei.recvbuffer)
#file = open('test.dat', "wb")
#file.write(filebyte_array)
