#----------------------------------------------------------------
# Include draw code
#----------------------------------------------------------------

source [file dirname [file normalize [info script]]]/ihp-sg13g2_resistors_draw.tcl

#----------------------------------------------------------------
# Default values
#----------------------------------------------------------------

proc sg13g2_devstdin::rsil_defaults {} {
    return {w 0.5 l 0.5 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class resistor \
		    endcov 0 glc 1 grc 1 gtc 1 gbc 1}
}

proc sg13g2_devstdin::rppd_defaults {} {
     return {w 0.5 l 0.5 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class resistor \
		    endcov 0 glc 1 grc 1 gtc 1 gbc 1}
}

proc sg13g2_devstdin::rhigh_defaults {} {
    return {w 0.5 l 0.5 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class resistor \
		    endcov 0 glc 1 grc 1 gtc 1 gbc 1}
}

#----------------------------------------------------------------
# Parameter window
#----------------------------------------------------------------

proc sg13g2_devstdin::res_dialog {device parameters} {
    magic::add_entry l "Length (um)" $parameters
    magic::add_entry w "Width (um)" $parameters
    magic::add_entry nx "X Repeat" $parameters
    magic::add_entry dx "X Repeat Distance (um)" $parameters
    magic::add_entry ny "Y Repeat" $parameters
    magic::add_entry dy "Y Repeat Distance (um)" $parameters
	magic::add_entry endcov "End contact coverage (%)" $parameters
    magic::add_checkbox glc "Add left guard ring contact" $parameters
    magic::add_checkbox grc "Add right guard ring contact" $parameters
    magic::add_checkbox gtc "Add top guard ring contact" $parameters
    magic::add_checkbox gbc "Add bottom guard ring contact" $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::rsil_dialog {parameters} {
    sg13g2_devstdin::res_dialog rsil $parameters
}

proc sg13g2_devstdin::rppd_dialog {parameters} {
    sg13g2_devstdin::res_dialog rppd $parameters
}

proc sg13g2_devstdin::rhigh_dialog {parameters} {
    sg13g2_devstdin::res_dialog rhigh $parameters
}

#----------------------------------------------------------------
# Conversion from SPICE netlist parameters to toolkit
#----------------------------------------------------------------

proc sg13g2_devstdin::res_convert {parameters} {
    puts "res_convert: ToDo"
    set pdkparams [dict create]
    return $pdkparams
}

#----------------------------------------------------------------

proc sg13g2_devstdin::rsil_convert {parameters} {
    return [sg13g2_devstdin::res_convert $parameters]
}

proc sg13g2_devstdin::rppd_convert {parameters} {
    return [sg13g2_devstdin::res_convert $parameters]
}

proc sg13g2_devstdin::rhigh_convert {parameters} {
    return [sg13g2_devstdin::res_convert $parameters]
}

#----------------------------------------------------------------
# Check device parameters for out-of-bounds values
#----------------------------------------------------------------

proc sg13g2_devstdin::res_check {device parameters} {

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    set snake 0
    set guard 0
    set sterm 0.0
    set caplen 0
    set wmax 0
    set dw 0.0

    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # Normalize distance units to microns
    set w [magic::spice2float $w]
    set w [magic::3digitpastdecimal $w]
    set l [magic::spice2float $l]
    set l [magic::3digitpastdecimal $l]

    # nf, m must be integer
    if {![string is int $nx]} {
    puts stderr "X repeat must be an integer!"
        dict set parameters nx 1
    }
    if {![string is int $ny]} {
    puts stderr "Y repeat must be an integer!"
        dict set parameters ny 1
    }

    # Width always needs to be specified
    if {$w < $wmin} {
    puts stderr "Resistor width must be >= $wmin um"
    dict set parameters w $wmin
    } 
    if {$wmax > 0 && $w > $wmax} {
    puts stderr "Resistor width must be <= $wmax um"
    dict set parameters w $wmax
    }
    if {$l < $lmin} {
    puts stderr "Resistor length must be >= $lmin um"
    dict set parameters l $lmin
    } 
    if {$nx < 1} {
    puts stderr "X repeat must be >= 1"
    dict set parameters nx 1
    } 
    if {$ny < 1} {
    puts stderr "Y repeat must be >= 1"
    dict set parameters ny 1
    }

    return $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::rsil_check {parameters} {
    return [sg13g2_devstdin::res_check rsil $parameters]
}

proc sg13g2_devstdin::rppd_check {parameters} {
    return [sg13g2_devstdin::res_check rppd $parameters]
}

proc sg13g2_devstdin::rhigh_check {parameters} {
    return [sg13g2_devstdin::res_check rhigh $parameters]
}
