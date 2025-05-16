#----------------------------------------------------------------
# Draw a single MIM capacitor device
#----------------------------------------------------------------
# Parameters:
#  - w:
#      width (um)
#  - l:
#      length (um)
#  - nx:
#      number of devices in x direction
#  - dx:
#      distance between devices in x direction (um)
#  - ny:
#      number of devices in y direction
#  - dy:
#      distance between devices in y direction (um)
#  - top_plate_type:
#      tile type for top capacitor plate
#  - bot_plate_type:
#      tile type for bottom capacitor plate
#  - bot_plate_enclose_top_plate:
#      bottom plate enclosure of top plate (um)
#  - top_cont_type:
#      tile type of top contact
#  - top_cont_size:
#      size of contacts from top plate upwards (um)
#  - top_cont_cover:
#      coverage of top contacts (%)
#  - top_cont_enclose_top_plate:
#      top contact enclose of top plate (um)
#  - bot_cont_type:
#      tile type of bottom contact
#  - bot_cont_size:
#      size of contacts from bottom plate downwards
#  - bot_cont_cover:
#      coverage of bottom contacts (%)
#  - bot_cont_enclose_bot_plate:
#      bottom contact enclosure of bottom plate
#----------------------------------------------------------------

proc sg13g2_devstdin::cap_device {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set box_initial [getbox]

    # Draw the resistor and endcaps
    box size 0 0
    set box_origin [getbox]

    set hw [/ $w 2.0]
    set hl [/ $l 2.0]
    box grow n ${hl}um
    box grow s ${hl}um
    box grow e ${hw}um
    box grow w ${hw}um
    paint ${top_plate_type}
    set box_cap_core [getbox]

    # scale/draw top contact
    box shrink c ${top_cont_enclose_top_plate}um
    set top_cont_w [getboxwidth]
    set top_cont_h [getboxheight]
    if {${top_cont_cover} > 0} {
        set top_cont_w [* ${top_cont_w} [/ ${top_cont_cover} 100.0]]
        set top_cont_h [* ${top_cont_h} [/ ${top_cont_cover} 100.0]]
        if {${top_cont_w} < ${top_cont_size}} { set top_cont_w ${top_cont_size} }
        if {${top_cont_h} < ${top_cont_size}} { set top_cont_h ${top_cont_size} }
        setcboxwidth ${top_cont_w}
        setcboxheight ${top_cont_h}
        paint ${top_cont_type}
    }

    # draw bottom plate
    setbox ${box_cap_core}
    box grow c ${bot_plate_enclose_top_plate}um
    paint ${bot_plate_type}
    set box_cap_bottom [getbox]

    # scale/draw bottom contact
    box shrink c ${bot_cont_enclose_bot_plate}um
    set bot_cont_w [getboxwidth]
    set bot_cont_h [getboxheight]
    if {${bot_cont_cover} > 0} {
        set bot_cont_w [* ${bot_cont_w} [/ ${bot_cont_cover} 100.0]]
        set bot_cont_h [* ${bot_cont_h} [/ ${bot_cont_cover} 100.0]]
        if {${bot_cont_w} < ${bot_cont_size}} { set bot_cont_w ${bot_cont_size} }
        if {${bot_cont_h} < ${bot_cont_size}} { set bot_cont_h ${bot_cont_size} }
        setcboxwidth ${bot_cont_w}
        setcboxheight ${bot_cont_h}
        paint ${bot_cont_type}
    }

    return ${box_cap_bottom}
}

#----------------------------------------------------------------

proc sg13g2_devstdin::cmim_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set capdict [dict create \
        w                           ${w} \
        l                           ${l} \
        nx                          ${nx} \
        dx                          ${dx} \
        ny                          ${ny} \
        dy                          ${dy} \
        top_plate_type              mimcap \
        bot_plate_type              m5 \
        bot_plate_enclose_top_plate ${mim_c} \
        top_cont_type               mimcapc \
        top_cont_size               ${tm1_a} \
        top_cont_cover              ${topcc} \
        top_cont_enclose_top_plate  ${mim_d} \
        bot_cont_type               via4 \
        bot_cont_size               [+ ${vn_a} [* ${vn_c1} 2]] \
        bot_cont_cover              ${botcc} \
        bot_cont_enclose_bot_plate  ${vn_c1} \
    ]

    return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::cap_device" $capdict]
}
