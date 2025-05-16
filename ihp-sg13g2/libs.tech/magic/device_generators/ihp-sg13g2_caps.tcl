#----------------------------------------------------------------
# Include draw code
#----------------------------------------------------------------

source [file dirname [file normalize [info script]]]/ihp-sg13g2_caps_draw.tcl

#----------------------------------------------------------------
# Default values
#----------------------------------------------------------------

proc sg13g2_devstdin::cmim_defaults {} {
    return {w 2.0 l 2.0 nx 1 dx -0.6 ny 1 dy -0.6 wmin 1.14 lmin 1.14 class capacitor \
            topcc 100 botcc 100}
}

#----------------------------------------------------------------
# Parameter window
#----------------------------------------------------------------

proc sg13g2_devstdin::cmim_dialog {parameters} {
    magic::add_entry l "Length (um)" $parameters
    magic::add_entry w "Width (um)" $parameters
    magic::add_entry nx "X Repeat" $parameters
    magic::add_entry dx "X Repeat Distance (um)" $parameters
    magic::add_entry ny "Y Repeat" $parameters
    magic::add_entry dy "Y Repeat Distance (um)" $parameters
    magic::add_entry topcc "Top Contact Coverage (\%)" $parameters
    magic::add_entry botcc "Bottom Contact Coverage (\%)" $parameters
}

#----------------------------------------------------------------
# Conversion from SPICE netlist parameters to toolkit
#----------------------------------------------------------------

proc sg13g2_devstdin::cmim_convert {parameters} {
    puts "cmim_convert: ToDo"
    set pdkparams [dict create]
    return $pdkparams
}

#----------------------------------------------------------------
# Check device parameters for out-of-bounds values
#----------------------------------------------------------------

proc sg13g2_devstdin::cmim_check {parameters} {

    return $parameters
}
