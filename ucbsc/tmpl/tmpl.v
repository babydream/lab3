##
## UC Berkeley Memory Compiler v081610a
## Rimas Avizienis, Yunsup Lee, and Kyle Wecker
##
## Cheetah template for the verilog file
##
`timescale 1ns/10ps

module $fileName ( #slurp
#set $portNum = 1
#for $i in range(0, $numRWPorts)
  #for $p in $rw_ports
$p$portNum#slurp
    #if $portNum != $numPorts or $p != $rw_lastport
, #slurp
    #end if
  #end for
  #set $portNum = $portNum + 1
#end for
#for $i in range(0, $numRPorts)
  #for $p in $r_ports
$p$portNum#slurp
    #if $portNum != $numPorts or $p != $r_lastport
, #slurp
    #end if
  #end for
  #set $portNum = $portNum + 1
#end for
#for $i in range(0, $numWPorts)
  #for $p in $w_ports
$p$portNum#slurp
    #if $portNum != $numPorts or $p != $w_lastport
, #slurp
    #end if
  #end for
  #set $portNum = $portNum + 1
#end for
 );
#set $portNum = 1
#for $i in range(0, $numRWPorts)
  #for $p in $rw_singleports
input $p$portNum;
  #end for
input [${numAddr-1}:0] A${portNum};
input [${wordLength-1}:0] I${portNum};
output reg [${wordLength-1}:0] O${portNum};
  #if not $noBM
input [${bmWidth-1}:0] WBM${portNum};
  #end if
  #set $portNum = $portNum + 1
#end for
#for $i in range(0, $numRPorts)
  #for $p in $r_singleports
input $p$portNum;
  #end for
input [${numAddr-1}:0] A${portNum};
output reg [${wordLength-1}:0] O${portNum};
  #set $portNum = $portNum + 1
#end for
#for $i in range(0, $numWPorts)
  #for $p in $w_singleports
input $p$portNum;
  #end for
input [${numAddr-1}:0] A${portNum};
input [${wordLength-1}:0] I${portNum};
  #if not $noBM
input [${bmWidth-1}:0] WBM${portNum};
  #end if
  #set $portNum = $portNum + 1
#end for

reg notifier;

specify
#set $portNum = 1
##
## Read/Write Ports
##
#for $i in range(0,$numRWPorts)
\$setuphold(posedge CE$portNum, WEB$portNum, 0, 0, notifier);
\$setuphold(posedge CE$portNum, OEB$portNum, 0, 0, notifier);
\$setuphold(posedge CE$portNum, CSB$portNum, 0, 0, notifier);
  #for $j in range(0, $numAddr)
\$setuphold(posedge CE$portNum, A${portNum}[$j], 0, 0, notifier);
  #end for
  #for $j in range(0, $wordLength)
\$setuphold(posedge CE$portNum, I${portNum}[$j], 0, 0, notifier);
  #end for
  #if not $noBM
    #for $j in range(0, $bmWidth)
\$setuphold(posedge CE$portNum, WBM${portNum}[$j], 0, 0, notifier);
    #end for
  #end if
  #for $j in range(0, $wordLength)
(posedge CE$portNum => O${portNum}[$j]) = (0.3:0.3:0.3);
  #end for
  #set $portNum = $portNum + 1
#end for
##
## Read Ports
##
#for $i in range(0,$numRPorts)
\$setuphold(posedge CE$portNum, OEB$portNum, 0, 0, notifier);
\$setuphold(posedge CE$portNum, CSB$portNum, 0, 0, notifier);
  #for $j in range(0, $numAddr)
\$setuphold(posedge CE$portNum, A${portNum}[$j], 0, 0, notifier);
  #end for
  #for $j in range(0, $wordLength)
(posedge CE$portNum => O${portNum}[$j]) = (0.3:0.3:0.3);
  #end for
  #set $portNum = $portNum + 1
#end for
##
## Write Ports
##
#for $i in range(0,$numWPorts)
\$setuphold(posedge CE$portNum, WEB$portNum, 0, 0, notifier);
\$setuphold(posedge CE$portNum, CSB$portNum, 0, 0, notifier);
  #for $j in range(0, $numAddr)
\$setuphold(posedge CE$portNum, A${portNum}[$j], 0, 0, notifier);
  #end for
  #for $j in range(0, $wordLength)
\$setuphold(posedge CE$portNum, I${portNum}[$j], 0, 0, notifier);
  #end for
  #if not $noBM
    #for $j in range(0, $bmWidth)
\$setuphold(posedge CE$portNum, WBM${portNum}[$j], 0, 0, notifier);
    #end for
  #end if
  #set $portNum = $portNum + 1
#end for
endspecify

reg [${wordLength-1}:0] memory[${numWords-1}:0];
#set $portNum = 1
#for $i in range(0,$numRWPorts)
always @ (posedge CE$portNum)
begin
  if (~CSB$portNum & WEB$portNum)
    O$portNum <= memory[A$portNum];
  else if (~CSB$portNum & ~WEB$portNum)
  begin
  #if $noBM
    memory[A$portNum] <= I$portNum;
  #else
    #for $j in range($bmWidth)
    if (WBM${portNum}[${j}])
      memory[A${portNum}][${(j+1)*8-1}:${j*8}] <= I${portNum}[${(j+1)*8-1}:${j*8}];
    #end for
  #end if
  end
end

  #set $portNum = $portNum + 1
#end for
#for $i in range(0,$numRPorts)
always @ (posedge CE$portNum)
  if (~CSB$portNum)
    O$portNum <= memory[A$portNum];

  #set $portNum = $portNum + 1
#end for
#for $i in range(0,$numWPorts)
always @ (posedge CE$portNum)
begin
  if (~CSB$portNum & ~WEB$portNum)
  begin
  #if $noBM
    memory[A$portNum] <= I$portNum;
  #else
    #for $j in range($bmWidth)
    if (WBM${portNum}[${j}])
      memory[A${portNum}][${(j+1)*8-1}:${j*8}] <= I${portNum}[${(j+1)*8-1}:${j*8}];
    #end for
  #end if
  end
end
  #set $portNum = $portNum + 1
#end for

endmodule
