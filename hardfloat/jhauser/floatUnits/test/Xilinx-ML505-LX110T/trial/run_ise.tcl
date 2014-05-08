#########################
###  DEFINE VARIABLES ###
#########################
set DesignName	"FPGA_TOP_ML505_UARTLoopback"
set FamilyName	"VIRTEX5"
set DeviceName	"xc5vlx110t"
set PackageName	"FF1136"
set SpeedGrade	"-3"
set TopModule	"FPGA_TOP_ML505_UARTLoopback"
set EdifFile	"FPGA_TOP_ML505_UARTLoopback.edn"
if {![file exists $DesignName.ise]} {

project new $DesignName.ise

project set family $FamilyName
project set device $DeviceName
project set package $PackageName
project set speed $SpeedGrade

xfile add $EdifFile
if {[file exists synplicity.ucf]} {
    xfile add synplicity.ucf
}

#project set {Placer Effort Level (Overrides Overall Level)} "High"
#project set {Router Effort Level (Overrides Overall Level)} "High"
project set {Place & Route Effort Level (Overall)} "High"

project close
}

project open $DesignName.ise

process run "Implement Design" -force rerun_all

project close

