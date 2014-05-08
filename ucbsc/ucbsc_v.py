# -*- coding: utf-8 -*-
#
# UC Berkeley Memory Compiler v081610a
# Rimas Avizienis, Yunsup Lee, and Kyle Wecker
#
# Python driver for the verilog file
#

import os
import sys
import math
from Cheetah.Template import Template

lg = lambda x: int(math.ceil(math.log(x)/math.log(2)))

def make_v(fileName, wordLength = 32, numWords = 512, numRWPorts = 2, numRPorts = 0, numWPorts = 0, debug = False, noBM = False):
  numPorts = numRWPorts + numRPorts + numWPorts
  numAddr = int(lg(numWords))
  bmWidth = wordLength / 8
  
  rw_ports = ['A','CE','WEB','WBM','OEB','CSB','I','O']
  rw_lastport = 'O'
  
  r_ports = ['A','CE','OEB','CSB','O']
  r_lastport = 'O'

  w_ports = ['A','CE','WEB','WBM', 'CSB', 'I']
  w_lastport = 'I'

  rw_singleports = ['CE','WEB','OEB','CSB']
  r_singleports  = ['CE','OEB','CSB']
  w_singleports  = ['CE','WEB','CSB']

  if int(bmWidth) != bmWidth or noBM:
    noBM = True
    bmWidth = 0
    rw_ports.remove('WBM')
    w_ports.remove('WBM')
    
  path = os.path.dirname(__file__)
  tlist = locals().copy()
  t = Template(file=path+'/tmpl/tmpl.v', searchList=tlist)

  f = open(fileName + '.v', 'w')
  f.write(str(t))
  f.close()
