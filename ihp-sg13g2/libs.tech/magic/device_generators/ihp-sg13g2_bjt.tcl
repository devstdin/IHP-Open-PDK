#----------------------------------------------------------------
# Include draw code
#----------------------------------------------------------------

source [file dirname [file normalize [info script]]]/ihp-sg13g2_bjt_draw.tcl

#----------------------------------------------------------------
# Default values
#----------------------------------------------------------------

proc sg13g2_devstdin::pnpmpa_defaults {} {
    return {w 0.78 l 0.78 nx 1 dx 0.18 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class bjt \
		    glc 1 grc 1 gtc 1 gbc 1}
}

#----------------------------------------------------------------
# Parameter window
#----------------------------------------------------------------

proc sg13g2_devstdin::bjt_dialog {device parameters} {
    magic::add_entry l "Length (um)" $parameters
    magic::add_entry w "Width (um)" $parameters
    magic::add_entry nx "X Repeat" $parameters
    magic::add_entry dx "X Repeat Distance (um)" $parameters
    magic::add_entry ny "Y Repeat" $parameters
    magic::add_entry dy "Y Repeat Distance (um)" $parameters
    magic::add_checkbox glc "Add left guard ring contact" $parameters
    magic::add_checkbox grc "Add right guard ring contact" $parameters
    magic::add_checkbox gtc "Add top guard ring contact" $parameters
    magic::add_checkbox gbc "Add bottom guard ring contact" $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::pnpmpa_dialog {parameters} {
    sg13g2_devstdin::bjt_dialog dantenna $parameters
}

#----------------------------------------------------------------
# Conversion from SPICE netlist parameters to toolkit
#----------------------------------------------------------------

proc sg13g2_devstdin::bjt_convert {parameters} {
    puts "bjt_convert: ToDo"
    set pdkparams [dict create]
    return $pdkparams
}

#----------------------------------------------------------------

proc sg13g2_devstdin::pnpmpa_convert {parameters} {
    return [sg13g2_devstdin::bjt_convert $parameters]
}

#----------------------------------------------------------------
# Check device parameters for out-of-bounds values
#----------------------------------------------------------------

proc sg13g2_devstdin::bjt_check {device parameters} {

    return $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::pnpmpa_check {parameters} {
    return [sg13g2_devstdin::bjt_check dantenna $parameters]
}
