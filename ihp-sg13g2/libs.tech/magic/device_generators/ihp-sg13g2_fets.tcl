#----------------------------------------------------------------
# Include draw code
#----------------------------------------------------------------

source [file dirname [file normalize [info script]]]/ihp-sg13g2_fets_draw.tcl

#----------------------------------------------------------------
# Default values
#----------------------------------------------------------------

proc sg13g2_devstdin::lvnmos_defaults {} {
    return {w 0.5 l 0.5 nf 1 nx 1 dx 0.21 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class mosfet \
		    gcontcov_t 100 gcontcov_b 100 dcontcov_l 100 dcontcov_r 100 \
            guard_distf 1 glc 0 grc 0 gtc 0 gbc 0}
}

proc sg13g2_devstdin::lvpmos_defaults {} {
     return {w 0.5 l 0.5 nf 1 nx 1 dx 0.21 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class mosfet \
            gcontcov_t 100 gcontcov_b 100 dcontcov_l 100 dcontcov_r 100 \
            guard_distf 1 glc 0 grc 0 gtc 0 gbc 0}
}

proc sg13g2_devstdin::hvnmos_defaults {} {
    return {w 0.5 l 0.5 nf 1 nx 1 dx 0.21 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class mosfet \
            gcontcov_t 100 gcontcov_b 100 dcontcov_l 100 dcontcov_r 100 \
            guard_distf 1 glc 0 grc 0 gtc 0 gbc 0}
}

proc sg13g2_devstdin::hvpmos_defaults {} {
     return {w 0.5 l 0.5 nf 1 nx 1 dx 0.21 ny 1 dy 0.18 wmin 0.50 lmin 0.50 class mosfet \
            gcontcov_t 100 gcontcov_b 100 dcontcov_l 100 dcontcov_r 100 \
            guard_distf 1 glc 0 grc 0 gtc 0 gbc 0}
}

#----------------------------------------------------------------
# Parameter window
#----------------------------------------------------------------

proc sg13g2_devstdin::fet_dialog {device parameters} {
    magic::add_entry l "Length (um)" $parameters
    magic::add_entry w "Width (um)" $parameters
    magic::add_entry nf "Number of Fingers" $parameters
    magic::add_entry nx "X Repeat" $parameters
    magic::add_entry dx "X Repeat Distance (um)" $parameters
    magic::add_entry ny "Y Repeat" $parameters
    magic::add_entry dy "Y Repeat Distance (um)" $parameters
	magic::add_entry gcontcov_t "Top gate contact coverage (%)" $parameters
    magic::add_entry gcontcov_b "Bottom gate contact coverage (%)" $parameters
    magic::add_entry dcontcov_l "Left diffusion contact coverage (%)" $parameters
    magic::add_entry dcontcov_r "Right diffusion contact coverage (%)" $parameters
    magic::add_entry guard_distf "Guard Ring Distance Factor" $parameters
    magic::add_checkbox glc "Add left guard ring contact" $parameters
    magic::add_checkbox grc "Add right guard ring contact" $parameters
    magic::add_checkbox gtc "Add top guard ring contact" $parameters
    magic::add_checkbox gbc "Add bottom guard ring contact" $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::lvnmos_dialog {parameters} {
    sg13g2_devstdin::fet_dialog lvnmos $parameters
}

proc sg13g2_devstdin::lvpmos_dialog {parameters} {
    sg13g2_devstdin::fet_dialog lvpmos $parameters
}

proc sg13g2_devstdin::hvnmos_dialog {parameters} {
    sg13g2_devstdin::fet_dialog hvnmos $parameters
}

proc sg13g2_devstdin::hvpmos_dialog {parameters} {
    sg13g2_devstdin::fet_dialog hvpmos $parameters
}

#----------------------------------------------------------------
# Conversion from SPICE netlist parameters to toolkit
#----------------------------------------------------------------

proc sg13g2_devstdin::fet_convert {parameters} {
    puts "fet_convert: ToDo"
    set pdkparams [dict create]
    return $pdkparams
}

#----------------------------------------------------------------

proc sg13g2_devstdin::lvnmos_convert {parameters} {
    return [sg13g2_devstdin::fet_convert $parameters]
}

proc sg13g2_devstdin::lvpmos_convert {parameters} {
    return [sg13g2_devstdin::fet_convert $parameters]
}

proc sg13g2_devstdin::hvnmos_convert {parameters} {
    return [sg13g2_devstdin::fet_convert $parameters]
}

proc sg13g2_devstdin::hvpmos_convert {parameters} {
    return [sg13g2_devstdin::fet_convert $parameters]
}

#----------------------------------------------------------------
# Check device parameters for out-of-bounds values
#----------------------------------------------------------------

proc sg13g2_devstdin::fet_check {device parameters} {

    return $parameters
}

#----------------------------------------------------------------

proc sg13g2_devstdin::lvnmos_check {parameters} {
    return [sg13g2_devstdin::fet_check lvnmos $parameters]
}

proc sg13g2_devstdin::lvpmos_check {parameters} {
    return [sg13g2_devstdin::fet_check lvpmos $parameters]
}

proc sg13g2_devstdin::hvnmos_check {parameters} {
    return [sg13g2_devstdin::fet_check hvnmos $parameters]
}

proc sg13g2_devstdin::hvpmos_check {parameters} {
    return [sg13g2_devstdin::fet_check hvpmos $parameters]
}
