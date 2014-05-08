# -*- coding: utf-8 -*-
#
# UC Berkeley Memory Compiler v081610a
# Rimas Avizienis, Yunsup Lee, and Kyle Wecker
#
# Python driver for the cacti run
#

import os
import sys
import tempfile
import shutil
import re
from Cheetah.Template import Template

def getModelValues(wordLength = 32, depth = 128, numRWPorts = 1, numRPorts = 1, numWPorts = 1, debug = False, technology = None):

#  cactiDir = '%s/tools/cacti' % os.environ.get('UCB_VLSI_HOME')
#  cactiDir = '/scratch/rimas/maven/ucbmc/cacti65'
#  cactiDir = '/home/eecs/yunsup/memcompiler/cacti65'
  cactiDir = os.path.join(os.path.dirname(__file__), './cacti65')

  bytes = wordLength / 8.0
  if bytes != int(bytes):
    bytes = int(bytes) + 1
    wordLength = ( (wordLength/8)*8 ) + 8

  bytes = int(bytes)

  C                                    = depth * bytes
  B                                    = bytes
  A                                    = 1

  RWP                                  = numRWPorts
  ERP                                  = numRPorts
  EWP                                  = numWPorts

  NSER                                 = 0
  NBANKS                               = 1
  TECH                                 = technology

  PAGE_SIZE                            = 8192
  BURST_LENGTH                         = 8
  PRE_WIDTH                            = 8

  OUTPUT_WIDTH                         = wordLength
  SPECIFIC_TAG                         = 0
  TAG_WIDTH                            = 0

  ACCESS_MODE                          = 0
  CACHE                                = 0
  MAIN_MEM                             = 0

  OBJ_FUNC_DELAY                       = 0
  OBJ_FUNC_DYN_POWER                   = 0
  OBJ_FUNC_LEAK_POWER                  = 50
  OBJ_FUNC_AREA                        = 50
  OBJ_FUNC_CYCLE_TIME                  = 0

  DEV_FUNC_DELAY                       = 50
  DEV_FUNC_DYN_POWER                   = 1000
  DEV_FUNC_LEAK_POWER                  = 100
  DEV_FUNC_AREA                        = 1000
  DEV_FUNC_CYCLE_TIME                  = 1000

#  OBJ_FUNC_DELAY                       = 100
#  OBJ_FUNC_DYN_POWER                   = 20
#  OBJ_FUNC_LEAK_POWER                  = 20
#  OBJ_FUNC_AREA                        = 10
#  OBJ_FUNC_CYCLE_TIME                  = 10

#  DEV_FUNC_DELAY                       = 1000
#  DEV_FUNC_DYN_POWER                   = 1000
#  DEV_FUNC_LEAK_POWER                  = 1000
#  DEV_FUNC_AREA                        = 1000
#  DEV_FUNC_CYCLE_TIME                  = 1000

  ED_ED2_NONE                          = 1

  TEMPERATURE                          = 350
  WT                                   = 0

  DATA_ARRAY_RAM_CELL_TECH             = 2
  DATA_ARRAY_PERI_TECH                 = 2
  TAG_ARRAY_RAM_CELL_TECH              = 2
  TAG_ARRAY_PERI_TECH                  = 2

  INTERCONNECT_PROJECTION_TYPE         = 1
  WIRE_TYPE_INSIDE_MAT                 = 1
  WIRE_TYPE_OUTSIDE_MAT                = 1

  IS_NUCA                              = 0
  CORE_COUNT                           = 8
  CACHE_LEVEL                          = 1
  NUCA_BANK_COUNT                      = 0
  NUCA_OBJ_FUNC_DELAY                  = 0
  NUCA_OBJ_FUNC_DYN_POWER              = 0
  NUCA_OBJ_FUNC_LEAK_POWER             = 0
  NUCA_OBJ_FUNC_AREA                   = 100
  NUCA_OBJ_FUNC_CYCLE_TIME             = 0

  NUCA_DEV_FUNC_DELAY                  = 0
  NUCA_DEV_FUNC_DYN_POWER              = 0
  NUCA_DEV_FUNC_LEAK_POWER             = 0
  NUCA_DEV_FUNC_AREA                   = 100
  NUCA_DEV_FUNC_CYCLE_TIME             = 0

  REPEATERS_IN_HTREE                   = 1

  path = os.path.dirname(__file__)
  tlist = locals().copy()
  t = Template(file=path+'/tmpl/tmpl.cacti.cfg', searchList=tlist)

  tempDir    = tempfile.mkdtemp()
#  tempDir    = '/tmp/cacti'
  currentDir = os.getcwd()
  os.chdir(tempDir)

  f = open('sram.cfg', 'w')
  f.write(str(t))
  f.close()

  #os.system(cactiDir + '/cacti %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d 0' % (C,B,A,RWP,ERP,EWP,NSER,NBANKS,TECH,PAGE_SIZE,BURST_LENGTH,PRE_WIDTH,OUTPUT_WIDTH,SPECIFIC_TAG,TAG_WIDTH,ACCESS_MODE,CACHE,MAIN_MEM,OBJ_FUNC_DELAY,OBJ_FUNC_DYN_POWER,OBJ_FUNC_LEAK_POWER,OBJ_FUNC_AREA,OBJ_FUNC_CYCLE_TIME,DEV_FUNC_DELAY,DEV_FUNC_DYN_POWER,DEV_FUNC_LEAK_POWER,DEV_FUNC_AREA,DEV_FUNC_CYCLE_TIME,ED_ED2_NONE,TEMPERATURE,WT,DATA_ARRAY_RAM_CELL_TECH,DATA_ARRAY_PERI_TECH,TAG_ARRAY_RAM_CELL_TECH,TAG_ARRAY_PERI_TECH,INTERCONNECT_PROJECTION_TYPE,WIRE_TYPE_INSIDE_MAT,WIRE_TYPE_OUTSIDE_MAT,IS_NUCA,CORE_COUNT,CACHE_LEVEL,NUCA_BANK_COUNT,NUCA_OBJ_FUNC_DELAY,NUCA_OBJ_FUNC_DYN_POWER,NUCA_OBJ_FUNC_LEAK_POWER,NUCA_OBJ_FUNC_AREA,NUCA_OBJ_FUNC_CYCLE_TIME,NUCA_DEV_FUNC_DELAY,NUCA_DEV_FUNC_DYN_POWER,NUCA_DEV_FUNC_LEAK_POWER,NUCA_DEV_FUNC_AREA,NUCA_DEV_FUNC_CYCLE_TIME, REPEATERS_IN_HTREE))
  os.system(cactiDir + '/cacti -infile sram.cfg')

  output = []
  for line in open('out.csv'):
    parsed = re.split(', ' , line)
    for word in parsed:
      output.append(word)

  middle = len(output)/2
  listOfValues = map(lambda (x,y): (x, float(y)), zip(output[:middle], output[middle:]))

  if debug:
    for pair in range(len(listOfValues)):
      print '%-3d%s' % (pair, listOfValues[pair])

  os.chdir(currentDir)
  shutil.rmtree(tempDir)

  # Read Energy (nJ -> pJ), Write Energy (nJ -> pJ), Leakage Power (mW -> pW), Height (mm -> um), Width (mm -> um), Access Time (ns)
  return (1e3*listOfValues[4][1], 1e3*listOfValues[5][1], 1e9*listOfValues[6][1], 1e3*listOfValues[1][1], 1e3*listOfValues[0][1], listOfValues[2][1])
