# -*- coding: utf-8 -*-
#
# UC Berkeley Memory Compiler v081610a
# Rimas Avizienis, Yunsup Lee, and Kyle Wecker
#
# Python driver for the lib file
#

import math
import datetime
import os
import sys
from Cheetah.Template import Template

lg = lambda x: int(math.ceil(math.log(x)/math.log(2)))

read_energy  = 50.0
write_energy = 50.0
access_time  = 2.0
instrinsic_rise = 0.1
intrinsic_fall = 0.1
rise_resistance = 0.1
fall_resistance = 0.1

def convertToDB(fileName):
  path = os.path.dirname(__file__)
  tlist = locals().copy()
  t = Template(file=path+'/tmpl/tmpl.lc.tcl', searchList=tlist)

  f = open('%s.tcl' % fileName, 'w')
  f.write(str(t))
  f.close()
  os.system('lc_shell -f %s.tcl' % fileName)
  os.remove('%s.tcl' % fileName)
  os.remove('command.log')

def make_lib(fileName, area = 1, wordLength = 32, numWords = 512, numRWPorts = 1, numRPorts = 0, numWPorts = 0, readEnergy = 10.0, writeEnergy = 10.0, leakagePower = 10.0, accessDelay = 10.0, opCond = 'Typical', debug = False, noBM = False, technology = None):
  global read_energy, write_energy, leakage_power, access_time, setup_time, hold_time

  setup_time = 0.01
  hold_time = 0.01
  read_energy = readEnergy
  write_energy = writeEnergy
  leakage_power = leakagePower
  access_time = accessDelay

  if leakage_power > 1e20 or leakage_power <= 0:
    leakage_power = 6.22e6
    raw_input('Error in Cacti energy report. Leakage power defaulting to 6.22e6. (Press enter to continue)')
  if access_time > 1e20 or access_time <= 0:
    access_time = 2.0
    raw_input('Error in Cacti access time report. Access time defaulting to 2.0ns. (Press enter to continue)')

  f = open('%s.lib' % fileName, 'w')

  if technology == 45:
    initial_voltage = 1.05
  elif technology == 65:
    initial_voltage = 1.05
  elif technology == 90:
    initial_voltage = 1.2
  elif technology == 32:
    initial_voltage = 1.05
  else:
    raise Exception, "Techonolgy must be specified"

  if opCond == 'Typical':
    libNameEnd  = ''
    voltage     = initial_voltage
    temperature = 25
    transition  = 2
  elif opCond == 'BEST' :
    libNameEnd = '_max'
    voltage     = initial_voltage*1.1
    temperature = -40
    transition  = 1.6
  elif opCond == 'WORST':
    libNameEnd = '_min'
    voltage     = initial_voltage*0.9
    temperature = 125
    transition  = 2.4
  else                  :
    libNameEnd = opCond
    voltage     = 9999
    temperature = 9999
    transition  = 9999

  now = datetime.datetime.now()
  if write_energy > 999999999 or write_energy <= 0:
    write_energy = 50
    raw_input('Error in Cacti energy report. Write energy defaulting to 50.0. (Press enter to continue)')
  if read_energy  > 999999999 or read_energy <= 0:
    read_energy  = 50
    raw_input('Error in Cacti energy report. Read energy defaulting to 50.0. (Press enter to continue)')

  rw_inputpins = ['WEB','OEB','CSB']
  r_inputpins  = ['OEB','CSB']
  w_inputpins  = ['WEB','CSB']
  
  rw_inputbuses = [ [True,'A','A_bus_%d_to_0'%(lg(numWords)-1)], [True,'I','IO_bus_%d_to_0'%(wordLength-1)], [False,'WBM','BM_bus_%d_to_0'%((wordLength/8)-1)] ]
  r_inputbuses  = [ [True,'A','A_bus_%d_to_0'%(lg(numWords)-1)] ]

  outputbus = ['O','IO_bus_%d_to_0'%(wordLength-1)]

  path = os.path.dirname(__file__)
  tlist = globals().copy()
  tlist['fileName'] = fileName
  tlist['now'] = now
  tlist['wordLength'] = wordLength
  tlist['lgnumWords'] = lg(numWords)
  tlist['area'] = '%.3f'%area
  tlist['access_time'] = '%.3f'%access_time
  tlist['setup_time'] = '%.3f'%setup_time
  tlist['hold_time'] = '%.3f'%hold_time
  tlist['read_energy'] = '%.1f'%read_energy
  tlist['write_energy'] = '%.1f'%write_energy
  tlist['leakage_power'] = '%.3f'%leakage_power
  tlist['noBM'] = noBM
  tlist['numRWPorts'] = numRWPorts
  tlist['numRPorts'] = numRPorts
  tlist['numWPorts'] = numWPorts
  tlist['rw_inputpins'] = rw_inputpins
  tlist['r_inputpins']  = r_inputpins
  tlist['w_inputpins']  = w_inputpins  
  tlist['rw_inputbuses'] = rw_inputbuses
  tlist['r_inputbuses']  = r_inputbuses  
  tlist['outputbus'] = outputbus
  tlist['voltage'] = voltage
  tlist['temperature'] = temperature
  tlist['opCond'] = opCond.upper()
  
  t = Template(file=path+'/tmpl/tmpl.lib', searchList=tlist)

  f = open('%s.lib' % fileName, 'w')
  f.write(str(t))
  f.close()

  convertToDB(fileName)
