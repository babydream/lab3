##
## UC Berkeley Memory Compiler v081610a
## Rimas Avizienis, Yunsup Lee, and Kyle Wecker
##
## Cheetah template for the milkyway run
##
geOpenLib
formButton "Open Library" "browse..."
setFormField "Open Library" "Library Name" "cells.mw"
setFormField "Open Library" "Library Path" "$cadpath/stdcells/${UCB_STDCELLS}/mw"
setFormField "Open Library" "read only" "1"
setFormField "Open Library" "open ref library for write" "0"
formOK "Open Library"
cmDumpTech
setFormField "Dump Technology File" "Technology File Name" "${fileName}.tempTech"
formOK "Dump Technology File"
geCloseLib
cmCreateLib
setFormField "Create Library" "Library Name" "$fileName"
setFormField "Create Library" "Technology File Name" "${fileName}.tempTech"
formOK "Create Library"
read_lef
formButton "Read LEF" "browse..."
setFormField "Read LEF" "Library Name" "$fileName"
setFormField "Read LEF" "Cell LEF Files" "./${fileName}.lef"
formOK "Read LEF"
exit
