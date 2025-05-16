#----------------------------------------------------------------
# Include draw code
#----------------------------------------------------------------

source [file dirname [file normalize [info script]]]/ihp-sg13g2_diodes_draw.tcl

#----------------------------------------------------------------
# Default values
#----------------------------------------------------------------

proc sg13g2_devstdin::dantenna_defaults {} {
    return {w 0.78 l 0.78 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class diode \
		    contcov 0 glc 1 grc 1 gtc 1 gbc 1}
}

proc sg13g2_devstdin::dpantenna_defaults {} {
    return {w 0.78 l 0.78 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class diode \
            contcov 0 glc 1 grc 1 gtc 1 gbc 1}
}

#----------------------------------------------------------------
# Parameter window
#----------------------------------------------------------------

proc sg13g2_devstdin::diode_dialog {device parameters} {
    magic::add_entry l "Length (um)" $parameters
    magic::add_entry w "Width (um)" $parameters
    magic::add_entry nx "X Repeat" $parameters
    magic::add_entry dx "X Repeat Distance (um)" $parameters
    magic::add_entry ny "Y Repeat" $parameters
    magic::add_entry dy "Y Repeat Distance (um)" $parameters
	#magic::add_entry contcov "Ring contact coverage (%)" $parameters
    magic::add_checkbox glc "Add left guard ring contact" $parameters
    magic::add_checkbox grc "Add right guard ring contact" $parameters
    magic::add_checkbox gtc "Add top guard ring contact" $parameters
    magic::add_checkbox gbc "Add bottom guard ring contact" $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::dantenna_dialog {parameters} {
    sg13g2_devstdin::diode_dialog dantenna $parameters
}

proc sg13g2_devstdin::dpantenna_dialog {parameters} {
    sg13g2_devstdin::diode_dialog dpantenna $parameters
}

#----------------------------------------------------------------
# Conversion from SPICE netlist parameters to toolkit
#----------------------------------------------------------------

proc sg13g2_devstdin::diode_convert {parameters} {
    puts "diode_convert: ToDo"
    set pdkparams [dict create]
    return $pdkparams
}

#----------------------------------------------------------------

proc sg13g2_devstdin::dantenna_convert {parameters} {
    return [sg13g2_devstdin::diode_convert $parameters]
}

proc sg13g2_devstdin::dpantenna_convert {parameters} {
    return [sg13g2_devstdin::diode_convert $parameters]
}

#----------------------------------------------------------------
# Check device parameters for out-of-bounds values
#----------------------------------------------------------------

proc sg13g2_devstdin::diode_check {device parameters} {

    return $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::dantenna_check {parameters} {
    return [sg13g2_devstdin::diode_check dantenna $parameters]
}

proc sg13g2_devstdin::dpantenna_check {parameters} {
    return [sg13g2_devstdin::diode_check dantenna $parameters]
}