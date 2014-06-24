#!/bin/python

import sys
import os
import re
from datetime import datetime
from time import mktime

# get filename from input
fname = sys.argv[1]

# get descriptor
desc = sys.argv[2]

print('parsing fie: (%s) for (%s)' % (fname, desc) )

# open outputfile
outname = fname + '.cleaned.%s' % desc
fout = open(outname,'w')


with open(fname) as f:
	for line in f:
		tokens = line.split(';')
		descstring = tokens[-2].split('|')
		desclast = descstring[-1]

		# write to file if matches desc
		if desclast == desc:
			try:
				# format timestamp
				
				timestring = tokens[2]
				year = timestring.split('T')[0].split('-')[0]
				month = timestring.split('T')[0].split('-')[1]
				day = timestring.split('T')[0].split('-')[2]
				# get time
				timevals = re.split('[-+]', timestring.split('T')[1] )
				time = timevals[0].split(':')
				hour = time[0]
				minute = time[1]
				second = time[2]
				zone = timevals[1]
				zonepol = timestring[-5]
				formatted = year + ',' + month + ',' + day + ',' + zonepol + zone +',' + \
						hour + ',' + minute + ',' + second +',' + tokens[-1]
				fout.write(formatted)
			except:
				print 'skipping bad line: (%s)' % line

					
print('DONE')
