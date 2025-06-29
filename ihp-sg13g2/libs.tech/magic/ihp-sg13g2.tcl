#------------------------------------------------------
# Magic/TCL design kit for IHP ihp-sg13g2
#------------------------------------------------------
# Lukas Baumann
# Based on device generator by Tim Edwards for sky130
#------------------------------------------------------

if {[catch {set TECHPATH $env(PDK_ROOT)}]} {
    set TECHPATH /usr/share/pdk
}
if [catch {set PDKPATH}] {set PDKPATH ${TECHPATH}/ihp-sg13g2}
set PDKNAME ihp-sg13g2
# "sg13g2" is the namespace used for all devices
set PDKNAMESPACE sg13g2
puts stdout "Loading ihp-sg13g2 Device Generator Menu ..."

# Initialize toolkit menus to the wrapper window

global Opts
namespace eval sg13g2_devstdin {}

# Set the window callback
if [catch {set Opts(callback)}] {set Opts(callback) ""}
set Opts(callback) [subst {sg13g2_devstdin::addtechmenu \$framename; $Opts(callback)}]

# if {![info exists Opts(cmdentry)]} {set Opts(cmdentry) 1}

# Set options specific to this PDK
set Opts(hidelocked) 1
set Opts(hidespecial) 0

# Wrap the closewrapper procedure so that closing the last
# window is equivalent to quitting.
if {[info commands closewrapper] == "closewrapper"} {
   rename closewrapper closewrapperonly
   proc closewrapper { framename } {
      if {[llength [windownames all]] <= 1} {
         magic::quit
      } else {
         closewrapperonly $framename
      }
   }
}

# Remove maze router layers from the toolbar by locking them
catch {tech lock fence,magnet,rotate}

namespace eval sg13g2_devstdin {
    namespace path {::tcl::mathop ::tcl::mathfunc}

    set ruleset [dict create]
    # Process DRC rules
    dict set ruleset rhi_d            0.20      ;# Min. and max. SalBlock space to Cont
    dict set ruleset nw_e             0.24      ;# Min. NWell enclosure of NWell tie surrounded entirely by NWell in N+Activ not inside ThickGateOx
    dict set ruleset nw_e1            0.62      ;# Min. NWell enclosure of NWell tie surrounded entirely by NWell in N+Activ inside ThickGateOx
    dict set ruleset nw_c             0.31      ;# Min. NWell enclosure of P+Activ not inside ThickGateOx
    dict set ruleset nw_d             0.31      ;# Min. NWell space to external N+Activ not inside ThickGateOx
    dict set ruleset nw_f             0.24      ;# Min. NWell space to substrate tie in P+Activ not inside ThickGateOx
    dict set ruleset nw_c1            0.62      ;# Min. NWell enclosure of P+Activ inside ThickGateOx
    dict set ruleset gat_d            0.07      ;# Min. GatPoly space to Activ
    dict set ruleset gat_c            0.18      ;# Min. GatPoly space to Activ
    dict set ruleset sal_d            0.20      ;# Min. SalBlock space to unrelated Activ or GatPoly
    dict set ruleset sal_c            0.20      ;# Min. SalBlock extension over Activ or GatPoly
    dict set ruleset m1_c1            0.05      ;# Min. Metal1 endcap enclosure of Cont
    dict set ruleset m1_e             0.22      ;# Min. space of Metal1 lines if, at least one line is wider than 0.3 µm and the parallel run is more than 1.0 µm
    dict set ruleset act_c            0.23      ;# Min. Activ drain/source extension
    dict set ruleset act_b            0.21      ;# Min. Activ space or notch
    dict set ruleset cnt_d            0.07      ;# Min. GatPoly enclosure of Cont
    dict set ruleset cnt_c            0.07      ;# Min. Activ enclosure of Cont
    dict set ruleset cnt_a            0.16      ;# Min. and max. Cont width
    dict set ruleset cnt_f            0.11      ;# Min. Cont on Activ space to GatPoly
    dict set ruleset cnt_e            0.14      ;# Min. Cont on GatPoly space to Activ
    dict set ruleset psd_d            0.18      ;# Min. pSD space to unrelated N+Activ in PWell
    dict set ruleset mim_c            0.60      ;# Min. Metal5 enclosure of MIM
    dict set ruleset mim_d            0.36      ;# Min. MIM enclosure of TopVia1
    dict set ruleset vn_c1            0.05      ;# Min. Metal(n) endcap enclosure of Via(n)
    dict set ruleset tv1_a            0.42      ;# Min. and max. TopVia1 width
    dict set ruleset tv1_c            0.10      ;# Min. Metal5 enclosure of TopVia1
    dict set ruleset vn_a             0.19      ;# Min. and max. Via(n) width
    dict set ruleset tm1_a            1.64      ;# Min. TopMetal1 width
    dict set ruleset tgo_a            0.27      ;# Min. ThickGateOx extension over Activ
    dict set ruleset tgo_b            0.27      ;# Min. space between ThickGateOx and Activ outside thick gate oxide region
}

#-----------------------------------------------------
# magic::addtechmenu
#-----------------------------------------------------

proc sg13g2_devstdin::addtechmenu {framename} {
   global Winopts Opts
   
   # Check for difference between magic 8.1.125 and earlier, and 8.1.126 and later
   if {[catch {${framename}.titlebar cget -height}]} {
      set layoutframe ${framename}.pane.top
   } else {
      set layoutframe ${framename}
   }

   magic::add_toolkit_menu $layoutframe "Devices" pdk1

   magic::add_toolkit_command $layoutframe "LV nmos (MOSFET)" \
	    "magic::gencell sg13g2_devstdin::lvnmos" pdk1
   magic::add_toolkit_command $layoutframe "LV pmos (MOSFET)" \
	    "magic::gencell sg13g2_devstdin::lvpmos" pdk1
   magic::add_toolkit_command $layoutframe "HV nmos (MOSFET)" \
        "magic::gencell sg13g2_devstdin::hvnmos" pdk1
   magic::add_toolkit_command $layoutframe "HV pmos (MOSFET)" \
        "magic::gencell sg13g2_devstdin::hvpmos" pdk1
   magic::add_toolkit_separator    $layoutframe pdk1

   magic::add_toolkit_command $layoutframe "n-diode" \
	    "magic::gencell sg13g2_devstdin::dantenna" pdk1
   magic::add_toolkit_command $layoutframe "p-diode" \
	    "magic::gencell sg13g2_devstdin::dpantenna" pdk1
#   magic::add_toolkit_command $layoutframe "schottky" \
	    "magic::gencell sg13g2_devstdin::schottky" pdk1
   magic::add_toolkit_separator	$layoutframe pdk1

   magic::add_toolkit_command $layoutframe "pnpMPA" \
        "magic::gencell sg13g2_devstdin::pnpmpa" pdk1
#   magic::add_toolkit_command $layoutframe "NPN" \
	    "magic::gencell sg13g2_devstdin::npn13g2" pdk1
#   magic::add_toolkit_command $layoutframe "PNP" \
	    "magic::gencell sg13g2_devstdin::pnpMPA" pdk1
   magic::add_toolkit_separator	$layoutframe pdk1

   magic::add_toolkit_command $layoutframe "poly resistor - 7 Ohm/sq" \
	    "magic::gencell sg13g2_devstdin::rsil" pdk1
   magic::add_toolkit_command $layoutframe "poly resistor - 260 Ohm/sq" \
	    "magic::gencell sg13g2_devstdin::rppd" pdk1
   magic::add_toolkit_command $layoutframe "poly resistor - 1360 Ohm/sq" \
	    "magic::gencell sg13g2_devstdin::rhigh" pdk1
   magic::add_toolkit_separator	$layoutframe pdk1

   magic::add_toolkit_command $layoutframe "MiM cap" \
	    "magic::gencell sg13g2_devstdin::cmim" pdk1
   magic::add_toolkit_separator	$layoutframe pdk1

   magic::add_toolkit_command $layoutframe "substrate/p-well tie contact" \
	    "sg13g2_devstdin::pwelltie_draw" pdk1
   magic::add_toolkit_command $layoutframe "n-well tie contact" \
	    "sg13g2_devstdin::nwelltie_draw" pdk1
   magic::add_toolkit_command $layoutframe "n-well region with guard ring" \
	    "sg13g2_devstdin::nwell_draw" pdk1
   magic::add_toolkit_command $layoutframe "p-well region with guard ring" \
	    "sg13g2_devstdin::pwell_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via1" \
	    "sg13g2_devstdin::via1_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via2" \
	    "sg13g2_devstdin::via2_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via3" \
	    "sg13g2_devstdin::via3_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via4" \
	    "sg13g2_devstdin::via4_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via5" \
	    "sg13g2_devstdin::via5_draw" pdk1
#   magic::add_toolkit_command $layoutframe "via6" \
	    "sg13g2_devstdin::via6_draw" pdk1
    magic::add_toolkit_separator $layoutframe pdk1

    magic::add_toolkit_command $layoutframe "Metal Stripes" \
        "sg13g2_devstdin::stripes_draw" pdk1
    magic::add_toolkit_separator $layoutframe pdk1

    magic::add_toolkit_command $layoutframe "Seal Ring" \
        "sg13g2_devstdin::seal_draw" pdk1

   # Additional DRC style for routing only---add this to the DRC menu
   ${layoutframe}.titlebar.mbuttons.drc.toolmenu add command -label "DRC Routing" -command {drc style drc(routing)}

   # Add SPICE import function to File menu
   ${layoutframe}.titlebar.mbuttons.file.toolmenu insert 4 command -label "Import SPICE" -command {sg13g2_devstdin::importspice}
   ${layoutframe}.titlebar.mbuttons.file.toolmenu insert 4 separator

   # Add command entry window by default if enabled
   if {[info exists Opts(cmdentry)]} {
      set Winopts(${framename},cmdentry) $Opts(cmdentry)
   } else {
      set Winopts(${framename},cmdentry) 0
   }
   if {$Winopts(${framename},cmdentry) == 1} {
      addcommandentry $framename
   }
}

#----------------------------------------------------------------
# Menu callback function to read a SPICE netlist and generate an
# initial layout using the IHP sg13g2A gencells.
#----------------------------------------------------------------

proc sg13g2_devstdin::importspice {} {
   global CAD_ROOT

   set Layoutfilename [ tk_getOpenFile -filetypes \
	    {{SPICE {.spice .spc .spi .ckt .cir .sp \
	    {.spice .spc .spi .ckt .cir .sp}}} {"All files" {*}}}]
   if {$Layoutfilename != ""} {
      magic::netlist_to_layout $Layoutfilename sg13g2
   }
}

#----------------------------------------------------------------
# Device Scripts
#----------------------------------------------------------------
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_resistors.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_guard.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_fets.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_diodes.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_caps.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_bjt.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_welltie.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_stripes.tcl
source [file dirname [file normalize [info script]]]/device_generators/ihp-sg13g2_seal.tcl

#-------------------------------------------------------------------
# General-purpose routines for the PDK script in all technologies
#-------------------------------------------------------------------

#----------------------------------------------------------------
# Draw array of devices
#----------------------------------------------------------------

proc sg13g2_devstdin::tiled_draw {dev_draw parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    tech unlock *
    set savesnap [snap]
    snap internal

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # Normalize distance units to microns
    set w [magic::spice2float $w]
    set l [magic::spice2float $l]

    set box_initial [getbox]
    box values 0 0 0 0
    set box_origin [getbox]

    # Determine the base device dimensions by drawing one device
    # while all layers are locked (nothing drawn).  This allows the
    # base drawing routine to do complicated geometry without having
    # to duplicate it here with calculations.

    tech lock *
    set box_dev [${dev_draw} $parameters]
    setbox $box_dev
    #puts stdout "Diagnostic: Device bounding box $box_dev (um)"
    tech unlock *

    # Determine tile width and height
    set dev_w [getboxwidth]
    set dev_h [getboxheight]
    #puts "Device width: ${dev_w}, height: ${dev_h}"
    set xstep [+ ${dev_w} $dx]
    set ystep [+ ${dev_h} $dy]

    # draw array
    # first instance
    box values 0 0 0 0
    set coord_x 0
    set coord_y 0
    set box_core [getbox]
    for {set xp 0} {$xp < $nx} {incr xp} {
        for {set yp 0} {$yp < $ny} {incr yp} {    
            set b [${dev_draw} $parameters]
            set box_core [unionbox $box_core $b]
            # next resistor position
            set coord_y [+ ${coord_y} ${ystep}]
            box values 0 0 0 0
            box move right ${coord_x}um
            box move up ${coord_y}um
        }
        # next resistor position
        set coord_x [+ ${coord_x} ${xstep}]
        set coord_y 0
        box values 0 0 0 0
        box move right ${coord_x}um
        box move up ${coord_y}um
    }
    snap $savesnap
    tech revert
    return ${box_core}
}

#----------------------------------------------------------------
# flipbox:
#   - direction:
#        left, right, up, down
#   - [new_size]:
#        new box size in 'direction' (um)
#----------------------------------------------------------------

proc sg13g2_devstdin::flipbox {direction {size -1}} {
    set b [sg13g2_devstdin::getbox]
    set llx [lindex ${b} 0]
    set lly [lindex ${b} 1]
    set urx [lindex ${b} 2]
    set ury [lindex ${b} 3]
    set bh [- ${ury} ${lly}]
    set bw [- ${urx} ${llx}]

    if {$direction == "left" || $direction == "right"} {
        if {$size >= 0} {
            set new_size $size
        } else {
            set new_size $bw
        }
    }
    if {$direction == "top" || $direction == "bottom"} {
        if {$size >= 0} {
            set new_size $size
        } else {
            set new_size $bh
        }
    }

    if {$direction == "left"} {
        box values [- ${llx} ${new_size}]um \
                   ${lly}um \
                   ${llx}um \
                   ${ury}um
    }
    if {$direction == "right"} {
        box values ${urx}um \
                   ${lly}um \
                   [+ ${urx} ${new_size}]um \
                   ${ury}um
    }
    if {$direction == "top"} {
        box values ${llx}um \
                   ${ury}um \
                   ${urx}um \
                   [+ ${ury} ${new_size}]um
    }
    if {$direction == "bottom"} {
        box values ${llx}um \
                   [- ${lly} ${new_size}]um \
                   ${urx}um \
                   ${lly}um
    }
}

#----------------------------------------------------------------
# getbox:  Get the current cursor box, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::getbox {} {
    set curbox [box values]
    set newbox []
    set oscale [cif scale out]
    for {set i 0} {$i < 4} {incr i} {
        set v [* [lindex $curbox $i] $oscale]
        lappend newbox $v
    }
    return $newbox
}

#----------------------------------------------------------------
# setcboxheight:  Set a new box height, centered, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::setcboxheight {h} {
    if {${h} < [getboxheight]} {
        box move top [/ [- [getboxheight] ${h}] 2]um
    } else {
        box move bottom [/ [- ${h} [getboxheight]] 2]um
    }
    box height ${h}um
}

#----------------------------------------------------------------
# setcboxwidth:  Set a new box width, centered, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::setcboxwidth {w} {
    if {${w} < [getboxwidth]} {
        box move right [/ [- [getboxwidth] ${w}] 2]um
    } else {
        box move left [/ [- ${w} [getboxwidth]] 2]um
    }
    box width ${w}um
}

#----------------------------------------------------------------
# getboxheight:  Get the current cursor box height, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::getboxheight {} {
    set b [getbox]
    return [- [lindex ${b} 3] [lindex ${b} 1]]
}

#----------------------------------------------------------------
# getboxwidth:  Get the current cursor box width, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::getboxwidth {} {
    set b [getbox]
    return [- [lindex ${b} 2] [lindex ${b} 0]]
}

#----------------------------------------------------------------
# setbox:  Set the current cursor box, in microns
#----------------------------------------------------------------

proc sg13g2_devstdin::setbox {v} {
    box values [lindex ${v} 0]um [lindex ${v} 1]um \
               [lindex ${v} 2]um [lindex ${v} 3]um 
}

#----------------------------------------------------------------
# unionbox:  Get the union bounding box of box1 and box2
#----------------------------------------------------------------

proc sg13g2_devstdin::unionbox {box1 box2} {
    set newbox []
    for {set i 0} {$i < 2} {incr i} {
        set v [lindex $box1 $i]
        set o [lindex $box2 $i]
        if {$v < $o} {
            lappend newbox $v
        } else {
            lappend newbox $o
        }
    }
    for {set i 2} {$i < 4} {incr i} {
        set v [lindex $box1 $i]
        set o [lindex $box2 $i]
        if {$v > $o} {
            lappend newbox $v
        } else {
            lappend newbox $o
        }
    }
    return $newbox
}

#----------------------------------------
# Number Conversion Functions
#----------------------------------------

#---------------------
# Microns to Lambda
#---------------------
proc magic::u2l {micron} {
    set techlambda [magic::tech lambda]
    set tech1 [lindex $techlambda 1]
    set tech0 [lindex $techlambda 0]
    set tscale [expr {$tech1 / $tech0}]
    set lambdaout [expr {((round([magic::cif scale output] * 10000)) / 10000.0)}]
    return [expr $micron / ($lambdaout*$tscale) ]
}

#---------------------
# Lambda to Microns
#---------------------
proc magic::l2u {lambda} {
    set techlambda [magic::tech lambda]
    set tech1 [lindex $techlambda 1] ; set tech0 [lindex $techlambda 0]
    set tscale [expr {$tech1 / $tech0}]
    set lambdaout [expr {((round([magic::cif scale output] * 10000)) / 10000.0)}]
    return [expr $lambda * $lambdaout * $tscale ]
}

#---------------------
# Internal to Microns
#---------------------
proc magic::i2u { value } {
    return [expr {((round([magic::cif scale output] * 10000)) / 10000.0) * $value}]
}

#---------------------
# Microns to Internal
#---------------------
proc magic::u2i {value} {
    return [expr {$value / ((round([magic::cif scale output] * 10000)) / 10000.0)}]
}

#---------------------
# Float to Spice 
#---------------------
proc magic::float2spice {value} { 
    if {$value >= 1.0e+6} { 
	set exponent 1e+6
	set unit "meg"
    } elseif {$value >= 1.0e+3} { 
	set exponent 1e+3
	set unit "k"
    } elseif { $value >= 1} { 
	set exponent 1
	set unit ""
    } elseif {$value >= 1.0e-3} { 
	set exponent 1e-3
	set unit "m"
    } elseif {$value >= 1.0e-6} { 
	set exponent 1e-6
	set unit "u"
    } elseif {$value >= 1.0e-9} { 
	set exponent 1e-9
	set unit "n"
    } elseif {$value >= 1.0e-12} { 
	set exponent 1e-12
	set unit "p"
    } elseif {$value >= 1.0e-15} { 
	set exponent 1e-15
	set unit "f"
    } else {
	set exponent 1e-18
	set unit "a"
    }
    set val [expr $value / $exponent]
    set val [expr int($val * 1000) / 1000.0]
    if {$val == 0} {set unit ""}
    return $val$unit
}

#---------------------
# Spice to Float
#---------------------
proc magic::spice2float {value {faultval 0.0}} { 
    # Remove trailing units, at least for some common combinations
    set value [string tolower $value]
    set value [string map {um u nm n uF n nF n pF p aF a} $value]
    set value [string map {meg "* 1.0e6" k "* 1.0e3" m "* 1.0e-3" u "* 1.0e-6" \
		 n "* 1.0 e-9" p "* 1.0e-12" f "* 1.0e-15" a "* 1.0e-15"} $value]
    if {[catch {set rval [expr $value]}]} {
	puts stderr "Value is not numeric!"
	set rval $faultval
    }
    return $rval
}

#---------------------
# Numeric Precision
#---------------------
proc magic::3digitpastdecimal {value} {
    set new [expr int([expr $value * 1000 + 0.5 ]) / 1000.0]
    return $new
}

#-------------------------------------------------------------------
# File Access Functions
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Ensures that a cell name does not already exist, either in
# memory or on disk. Modifies the name until it does.
#-------------------------------------------------------------------
proc magic:cellnameunique {cellname} {
    set i 0
    set newname $cellname
    while {[cellname list exists $newname] != 0 || [magic::searchcellondisk $newname] != 0} {
	incr i
	set newname ${cellname}_$i
    }
    return $newname
}

#-------------------------------------------------------------------
# Looks to see if a cell exists on disk
#-------------------------------------------------------------------
proc magic::searchcellondisk {name} {
    set rlist {}
    foreach dir [path search] {
	set ftry [file join $dir ${name}.mag]
	if [file exists $ftry] {
	    return 1
	}
    }
    return 0
} 

#-------------------------------------------------------------------
# Checks to see if a cell already exists on disk or in memory
#-------------------------------------------------------------------
proc magic::iscellnameunique {cellname} {
    if {[cellname list exists $cellname] == 0 && [magic::searchcellondisk $cellname] == 0} { 
	return 1
    } else {
	return 0
    }
}

#----------------------------------------------------------------
