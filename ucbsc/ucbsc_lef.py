# -*- coding: utf-8 -*-
#
# UC Berkeley Memory Compiler v081610a
# Rimas Avizienis, Yunsup Lee, and Kyle Wecker
#
# Python driver for the lef file
#

import os
import sys
import math
import re
from Cheetah.Template import Template

lg = lambda x: int(math.ceil(math.log(x)/math.log(2)))
ceil4 = lambda x: (int((x-1)/4)*4) + 4
round5thousandth = lambda x: round(x*1e3/5)*5e-3

cell_width  = 0
cell_height = 0
pinPitch = 0
pinWidth = 0
pinHeight = 0
gapPitch = 0
lastEnd = 0

obstructions = []
pins = []

def convertToMW(fileName, technology):
  cadpath = os.environ.get('UCB_VLSI_HOME')
  UCB_STDCELLS = os.environ.get('UCB_STDCELLS')

  #if technology == 65:
  #  UCB_STDCELLS = 'tsmc-65nm/default'
  #elif technology == 90:
  #  UCB_STDCELLS = 'synopsys-90nm/default'
  #else:
  #  raise Exception, "Techonolgy must be specified"

  path = os.path.dirname(__file__)
  tlist = locals().copy()
  t = Template(file=path+'/tmpl/tmpl.mw.scm', searchList=tlist)

  f = open('%s.scm' % fileName, 'w')
  f.write(str(t))
  f.close()

  os.system('Milkyway -nullDisplay -nogui -load %s.scm' % fileName)
  for file in os.listdir(os.getcwd()):
    if re.match('^Milkyway\.cmd', file) or \
       re.match('^Milkyway\.log', file) or \
       re.match('^lefPinOrder2def$', file) or \
       re.match('%s\.lef\.defineVarRoute\.tcl$' % fileName, file) or \
       re.match('^%s.tempTech$' % fileName, file) or \
       re.match('^%s.scm$' % fileName, file):
      os.remove(file)
  os.rename('%s' % fileName, '%s.mw' % fileName)

def addObs(lowerLeft, upperRight, layers = ['M2', 'M3', 'M4', 'M5'] ):
  global obstructions

  (x0,y0) = lowerLeft
  (x1,y1) = upperRight
  obs = [ '%.3f'%x0, '%.3f'%y0, '%.3f'%x1, '%.3f'%y1, layers ]
  obstructions.append(obs)

def addPin(lowerLeft, name, direction = None, use = 'SIGNAL', upperRight = None, layers = ['M2', 'M3', 'M4', 'M5']):
  global pins

  if direction == None:
    print 'Error: direction == None'

  if upperRight == None:
    print 'Error: upperRight == None'

  (x0,y0) = lowerLeft
  (x1,y1) = upperRight

  pin = [ name, direction, use, layers, '%.3f'%x0, '%.3f'%y0, '%.3f'%x1, '%.3f'%y1 ]
  pins.append(pin)

def addAddrWEPins(addrBits, wordLength, portNum, noBM, portType, WEB=True):
  global cell_width, cell_height, pinWidth, pinHeight, pinPitch

  if portNum == 1:
    x = cell_width - pinWidth
  else:
    x = 0

  y = cell_height * 0.875
  lasty = cell_height - 2 - pinWidth

  for i in range(addrBits):
    if portNum == 1:
      addObs( (cell_width-2*pinWidth, y+2*pinHeight), (cell_width, lasty) )
    else:
      addObs( (0, y+2*pinHeight), (2*pinWidth, lasty) )
    addPin((x,y), 'A%d[%d]' % (portNum, i), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
    lasty = y - pinHeight
    y -= pinPitch * 12

  if y < (cell_height * 0.25):
    print 'ERROR: Address pins overlap with WE pins!'

  y = cell_height * 0.25
  if portNum == 1:
    addObs( (cell_width-2*pinWidth, y+2*pinHeight), (cell_width, lasty) )
  else:
    addObs( (0, y+2*pinHeight), (2*pinWidth, lasty) )

  if WEB:
    addPin((x,y), 'WEB%d' % portNum, 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))

  if noBM == False:
    for i in range (wordLength/8):
      lasty = y - pinHeight
      y -= pinPitch * 4
      if portNum == 1:
        addObs( (cell_width-2*pinWidth, y+2*pinHeight), (cell_width, lasty) )
      else:
        addObs( (0, y+2*pinHeight), (2*pinWidth, lasty) )

      if portType == 'RW' or portType == 'W':
        addPin((x,y), 'WBM%d[%d]' % (portNum, i), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))

  if y < pinPitch:
    print 'ERROR: WEB pins extend beyond bottom of cell!'

  if portNum == 1:
    addObs( (cell_width-2*pinWidth, 2*pinHeight), (cell_width, y-pinHeight) )
  else:
    addObs( (0, 2*pinHeight), (2*pinWidth, y - pinHeight) )

def addPowerPins():
  global cell_height, pinWidth

  x = 5.195
  y = cell_height - 2
  addObs( (0, y-pinWidth), (x-pinWidth, cell_height) )
  addPin((x,y), 'VDD', 'INOUT', 'POWER', (x+2, y+2), ['M2', 'M3', 'M5'])

  x = 7.915
  addObs( (7.355, y-pinWidth), (x-pinWidth, cell_height) )
  addPin((x,y), 'VSS', 'INOUT', 'GROUND', (x+2, y+2), ['M2', 'M3', 'M5'])
  addObs( (x+2+pinWidth, y-pinWidth), (cell_width, cell_height) )

def addDataPins(offset = 0, wordLength = 32, portNum = 1, numPorts = 1, portType = 'RW', noBM = False):
  global cell_width, cell_height, pinPitch, pinHeight, gapPitch, lastEnd

  if portNum == 1:
    x = cell_width - gapPitch - offset
    dir = 1
    xoffset = -1
    addObs( (x+pinWidth*2, 0), (cell_width, pinHeight*2) )
  else:
    lastx = 0
    x = gapPitch + offset
    dir = -1
    xoffset = 2
    addObs( (0, 0), (x - pinWidth, pinHeight*2) )

  y = 0

  addPin((x,y), 'CE%d' % portNum, 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
  lastx = x + (xoffset * pinWidth)
  x -= gapPitch * dir

  if dir == 1:
    addObs( (x+pinWidth*2, 0), (lastx, pinHeight*2) )
  else:
    addObs( (lastx, 0), (x-pinWidth, pinHeight*2) )
  addPin((x,y), 'CSB%d' % portNum, 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
  lastx = x + (xoffset * pinWidth)
  x -= gapPitch * dir

  if portType == 'RW' or portType == 'R':
    if dir == 1:
      addObs( (x+pinWidth*2, 0), (lastx, pinHeight*2) )
    else:
      addObs( (lastx, 0), (x-pinWidth, pinHeight*2) )
    addPin((x,y), 'OEB%d' % portNum, 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
    lastx = x + (xoffset * pinWidth)
    x -= gapPitch * dir

  for i in range(wordLength/4):
    if portType == 'RW' or portType == 'R':
      if dir == 1:
        addObs( (x+pinWidth*2, 0), (lastx, pinHeight*2) )
      else:
        addObs( (lastx, 0), (x-pinWidth, pinHeight*2) )
      addPin((x,y), 'O%d[%d]' % (portNum, i*4+3), 'OUTPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'O%d[%d]' % (portNum, i*4+2), 'OUTPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'O%d[%d]' % (portNum, i*4+1), 'OUTPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'O%d[%d]' % (portNum, i*4), 'OUTPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      lastx = x + (xoffset * pinWidth)
      x -= gapPitch * dir

    if portType == 'RW' or portType == 'W':
      if dir == 1:
        addObs( (x+pinWidth*2, 0), (lastx, pinHeight*2) )
      else:
        addObs( (lastx, 0), (x-pinWidth, pinHeight*2) )
      addPin((x,y), 'I%d[%d]' % (portNum, i*4), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'I%d[%d]' % (portNum, i*4+1), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'I%d[%d]' % (portNum, i*4+2), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      x -= pinPitch * dir
      addPin((x,y), 'I%d[%d]' % (portNum, i*4+3), 'INPUT', 'SIGNAL', (x+pinWidth, y+pinHeight))
      lastx = x + (xoffset * pinWidth)
      x -= gapPitch * dir

  if numPorts == 1:
    addObs( (0,0), (lastx, pinHeight*2) )

  if portNum == 1:
    lastEnd = lastx

  if portNum == 2:
    addObs( (lastx, 0), (lastEnd, pinHeight*2) )

def make_lef(fileName, wordLength = 32, depth = 512, numRWPorts = 1, numRPorts = 1, numWPorts = 1, cactiHeight = 1000.0, cactiWidth = 1000.0, debug = False, noBM = False, technology = None):
  global cell_width, cell_height
  global pinHeight, pinWidth, pinPitch, gapPitch, lastEnd
  global obstructions, pins

  if technology == 65:
    pinPitch = 0.2
    pinWidth = 0.1
    pinHeight = 0.1
  elif technology == 90:
    pinPitch = 0.32
    pinWidth = 0.16
    pinHeight = 0.16
  # FIXME: rimas
  elif technology == 45 or technology == 32:
    pinPitch = 0.304
    pinWidth = 0.152
    pinHeight = 0.152
#  elif technology == 32:
#    pinPitch = 0.272
#    pinWidth = 0.136
#    pinHeight = 0.136
  else:
    raise Exception, "Error, you need to specify a technology"

  cell_width = round5thousandth(cactiWidth)
  cell_height = round5thousandth(cactiHeight)

  addrBits = lg(depth)

  cell_width  = (4*pinPitch * math.floor(cell_width /  (4*pinPitch)))
  cell_height = (4*pinPitch * math.floor(cell_height / (4*pinPitch)))
  cell_area   = cell_width * cell_height

  print 'Cell Width:  %f' % cell_width
  print 'Cell Height: %f' % cell_height
  print 'Cell Area:   %f' % cell_area

  # Make data I/O pins along bottom of cell
  # Total number of data pins per port = (N = 2 for RW ports, 1 otherwise)
  # (N * wordLength) + CE + CSB + OEB

  numDataPins  = ((2 * wordLength) + 3) * numRWPorts
  numDataPins += (wordLength + 2) * (numRPorts + numWPorts)
  dataPinWidth = (numDataPins+1) * pinPitch

  # 1 gap between edge of cell and CE pin
  # 1 gap between CE and CSB pin
  # 1 gap between CSB pin and OEB pin
  # 1 gap between OEB pin and and first 4 O pins
  # plus a gap between each remaining set of 4 O & I pins

  numPorts = numRWPorts + numRPorts + numWPorts  
  numGaps  = (4 + (((wordLength/4)-1) * 2)) * numRWPorts
  numGaps += (3 + (((wordLength/4)-1))) * (numRPorts + numWPorts)
  numGaps += numPorts

  gapPitch = 0
  lastEnd = 0
  obstructions = []
  pins = []

  while gapPitch == 0:
    gapPitch = (cell_width - dataPinWidth) / float(numGaps)
    if gapPitch < pinPitch:
      gapPitch = 0
      cell_width += 10
      print 'adding 10um to cell width'
    else:
      gapPitch = (pinPitch * math.floor(gapPitch / pinPitch))

  if dataPinWidth > cell_width:
    print 'Not enough space for pins along the bottom of the SRAM!\n'

  totalWidth = dataPinWidth + (gapPitch * numGaps)
  startOffset = cell_width - totalWidth

  portNum = 1
  if numRWPorts > 0:
    for i in range(numRWPorts):
      addDataPins(startOffset, wordLength, portNum, numPorts, 'RW', noBM)
      addAddrWEPins(addrBits, wordLength, portNum, noBM, 'RW')
      portNum += 1
  
  if numRPorts > 0:
    for i in range(numRPorts):
      addDataPins(startOffset, wordLength, portNum, numPorts, 'R', noBM)
      addAddrWEPins(addrBits, wordLength, portNum, noBM, 'R', False)
      portNum += 1
    
  if numWPorts > 0:
    for i in range(numWPorts):
      addDataPins(startOffset, wordLength, portNum, numPorts, 'W', noBM)
      addAddrWEPins(addrBits, wordLength, portNum, noBM, 'W')
      portNum += 1    

  addPowerPins()

  if numPorts == 1:
    addObs( (0, 2*pinHeight), (cell_width - 2*pinWidth, cell_height - 2 - pinWidth) )
  else:
    addObs( (2*pinWidth, 2*pinHeight), (cell_width - 2*pinWidth, cell_height - 2 - pinWidth) )

  obslayers = ['M2', 'M3', 'M4', 'M5']

  path = os.path.dirname(__file__)
  tlist = globals().copy()
  tlist['fileName'] = fileName
  tlist['obslayers'] = obslayers
  tlist['cell_width'] = '%.3f'%cell_width
  tlist['cell_height'] = '%.3f'%cell_height
  t = Template(file=path+'/tmpl/tmpl.lef', searchList=tlist)

  f = open('%s.lef' % fileName, 'w')
  f.write(str(t))
  f.close()

  convertToMW(fileName, technology)

  return cell_width*cell_height
