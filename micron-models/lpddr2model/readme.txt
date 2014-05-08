Disclaimer of Warranty:
-----------------------
This software code and all associated documentation, comments or other 
information (collectively "Software") is provided "AS IS" without 
warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGES. Because some jurisdictions prohibit the exclusion or 
limitation of liability for consequential or incidental damages, the 
above limitation may not apply to you.

Copyright 2003 Micron Technology, Inc. All rights reserved.

Getting Started:
----------------
Unzip the included files to a folder.
Compile mobile_ddr2.v and tb.v using a verilog simulator.
Simulate the top level test bench tb.
Or, if you are using the ModelSim simulator, type "do tb.do" at the prompt.

File Descriptions:
------------------
mobile_ddr2.v              -mobile_ddr2 component model 
mobile_ddr2_parameters.vh  -file that contains all parameters used by the model
readme.txt                 -this file
tb.v                       -component test bench
subtest.vh                 -example test included by the test bench.
tb.do                      -compiles and runs the component model and test bench

Choosing the mobile_ddr2_parameters.vh file:
--------------------------------------------
The mobile_ddr2_parameters.vh files are separated by density and manufacturing
process node.  Use the file that fits your needs accordingly.  Currently supported
are the following:
lpddr2_1Gb/mobile_ddr2_parameters.vh 
lpddr2_2Gb/mobile_ddr2_parameters.vh 
lpddr2_4Gb/mobile_ddr2_parameters.vh 
lpddr2_512Mb/mobile_ddr2_parameters.vh

Defining the Speed Grade:
-------------------------
The verilog compiler directive "`define" may be used to choose between 
multiple speed grades supported by the mobile_ddr2 model.  Allowable speed 
grades are listed in the mobile_ddr2_parameters.vh file and begin with the 
letters "sg".  The speed grade is used to select a set of timing 
parameters for the mobile_ddr2 model.  The following are examples of defining 
the speed grade.

    simulator   command line
    ---------   ------------
    ModelSim    vlog +define+sg5 mobile_ddr2.v
    VCS         vcs +define+sg5 mobile_ddr2.v
    NC-Verilog  ncverilog +define+sg5 mobile_ddr2.v

Defining the Organization:
--------------------------
The verilog compiler directive "`define" may be used to choose between 
multiple organizations supported by the mobile_ddr2 model.  Valid 
organizations include "x16", and x32, and are listed in the 
mobile_ddr2_parameters.vh file.  The organization is used to select the amount 
of memory and the port sizes of the mobile_ddr2 model.  The following are
examples of defining the organization.

    simulator   command line
    ---------   ------------
    ModelSim    vlog +define+x16 mobile_ddr2.v
    VCS         vcs +define+x16 mobile_ddr2.v
    NC-Verilog  ncverilog +define+x16 mobile_ddr2.v

All combinations of speed grade and organization are considered valid 
by the mobile_ddr2 model even though a Micron part may not exist for every 
combination.

Allocating Memory:
------------------
An associative array has been implemented to reduce the amount of 
static memory allocated by the mobile_ddr2 model.  Each entry in the 
associative array is a burst length of two in size.  The number of 
entries in the associative array is controlled by the MEM_BITS 
parameter, and is equal to 2^MEM_BITS.  For example, if the MEM_BITS 
parameter is equal to 10, the associative array will be large enough 
to store 1024 writes of burst length 2 to unique addresses.  The 
following are examples of setting the MEM_BITS parameter to 8.

    simulator   command line
    ---------   ------------
    ModelSim    vsim -GMEM_BITS=8 mobile_ddr2
    VCS         vcs -pvalue+MEM_BITS=8 mobile_ddr2.v
    NC-Verilog  ncverilog +defparam+mobile_ddr2.MEM_BITS=8 mobile_ddr2.v

It is possible to allocate memory for every address supported by the 
mobile_ddr2 model by using the verilog compiler directive "`define MAX_MEM".
This procedure will improve simulation performance at the expense of 
system memory.  The following are examples of allocating memory for
every address.

    Simulator   command line
    ---------   ------------
    ModelSim    vlog +define+MAX_MEM mobile_ddr2.v
    VCS         vcs +define+MAX_MEM mobile_ddr2.v
    NC-Verilog  ncverilog +define+MAX_MEM mobile_ddr2.v

Selecting the prefetch architecture:
------------------------------------
The mobile_ddr2 model supports 2n and 4n prefetch architectures.  The SX 
parameter is used to select between 2n and 4n prefetch.  Valid settings 
for the SX parameter are "2" or "4". The following are examples of setting 
the SX parameter to 2.

    simulator   command line
    ---------   ------------
    ModelSim    vsim -GSX=2 mobile_ddr2
    VCS         vcs -pvalue+SX=2 mobile_ddr2.v
    NC-Verilog  ncverilog +defparam+mobile_ddr2.SX=2 mobile_ddr2.v

