# Author: Lucas Wanner
# Code from NESL at UCLA

import struct
import socket
import time
import sys
import re
import numpy

class Keithley2602A:
    PORT = 5025

    def __init__(self, host, port=PORT):
        self.host = host
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((host, port))
        #self.s.settimeout(100)
        self.recvbuffer = ""
        pass

    def abortScript(self) :
        self.s.send("*RST\n")				
        self.s.send("abort\n")
        self.s.send("*CLS\n")		
        self.s.close()
        sys.stdout.flush()
        
        
    def run(self, scriptname, command) :
        receiving = False
        self.s.send("abort\n")
        self.s.send("*CLS\n")
        self.s.send(scriptname+".run()\n")
        self.s.send(command+"\n")
        while(1) :
            buf = self.s.recv(4096)
            if buf.startswith("Starting...") :
                receiving = True  
                buf = ''
                print >> sys.stderr, "Started script", scriptname
                continue          
            if buf.startswith("Done!") :
                #self.s.close()
                print >> sys.stderr, "Finished receiving"
                break
            if receiving :
                print >> sys.stderr, "Received data"
                self.recvbuffer += buf
        self.s.send("*RST\n")				
        self.s.send("abort\n")
        self.s.send("*CLS\n")		
        self.s.close()
            
    def processOneIteration(self, buf) :
		lines = buf.rsplit('\n', 1)[0]
		lines =  lines.split('\n')
		
		

		printcols = []

		
		startTime = float(lines[0]);
		ts = lines[1].split(', ')
		ncols = len(ts)
		
		#printcols.append(ts);
		
		 
		x = numpy.array(ts)
		timestamps = x.astype(numpy.float)		 
		 
		#print timestamps
		timestamps = numpy.add(timestamps, startTime);
		#print timestamps
		
		printcols.append(timestamps);
		
		for i in range(2,len(lines)) :
			cols = lines[i].split(', ')
			printcols.append(cols);
			#print len(cols)
			#print cols
			
		for i in range(0, ncols) :
			pbuf = ''
			for c in printcols :
				try :
					pbuf += str(c[i]) + ',\t'
				except IndexError :
					print >> sys.stderr, "IndexError"
					continue;
			print pbuf.rsplit(',\t', 1)[0]

		    
    def runForever(self, scriptname, command) :
        receiving = False
        self.s.send("abort\n")
        self.s.send("*CLS\n")
        self.s.send(scriptname+".run()\n")
        self.s.send(command+"\n")
        while(1) :
            buf = self.s.recv(4096)
            if buf.startswith("Starting...") :
                receiving = True  
                buf = ''
                print >> sys.stderr, "Started script", scriptname
                continue          
            if buf.startswith("Done!") :
                self.s.close()
                print >> sys.stderr, "Finished receiving"
                break
            if buf.startswith("Iteration") :
                print >> sys.stderr, "Completed Iteration"
                singleBuf = self.recvbuffer
                self.processOneIteration(singleBuf)
                self.recvbuffer = ""
                continue                
            if receiving :
                print >> sys.stderr, "Received data"
                self.recvbuffer += buf
            
