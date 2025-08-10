#----------------------------------------------------------------
# Draw a single diode device
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
#  - diode_type:
#  - diode_contact_type:
#  - diode_contact_size:
#  - diode_contact_coverage
#  - diode_contact_enclosure:
#  - well_type:
#  - subdiff_type:
#  - subdiff_distance:
#  - subdiff_enclose_contact:
#  - well_enclose_subdiff:
#  - contact_type:
#  - contact_size:
#  - contact_location:
#  - metal_type:
#  - metal_enclose_contact:
#  - minimal_well_enclosure:
#----------------------------------------------------------------

proc sg13g2_devstdin::diode_device {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set box_initial [getbox]

    # Draw diode and center contact
    box size 0 0
    set box_origin [getbox]

    set hw [/ $w 2.0]
    set hl [/ $l 2.0]
    box grow n ${hl}um
    box grow s ${hl}um
    box grow e ${hw}um
    box grow w ${hw}um
    paint ${diode_type}
    set box_d_core [getbox]

    # scale/draw contact
    box shrink c ${diode_contact_enclosure}um
    set top_cont_w [getboxwidth]
    set top_cont_h [getboxheight]
    if {${diode_contact_cover} > 0} {
        set top_cont_w [* ${top_cont_w} [/ ${diode_contact_cover} 100.0]]
        set top_cont_h [* ${top_cont_h} [/ ${diode_contact_cover} 100.0]]
        if {${top_cont_w} < ${diode_contact_size}} { set top_cont_w ${diode_contact_size} }
        if {${top_cont_h} < ${diode_contact_size}} { set top_cont_h ${diode_contact_size} }
        setcboxwidth ${top_cont_w}
        setcboxheight ${top_cont_h}
        paint ${diode_contact_type}
        set box_d_core_cont [getbox]
    }

    # draw ring contact
    setbox ${box_d_core}
    set box_d_ring [sg13g2_devstdin::guard_draw ${parameters}]

    return $box_d_ring
}

#----------------------------------------------------------------

proc sg13g2_devstdin::dantenna_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set coredict [dict create \
        w                       ${w} \
        l                       ${l} \
        nx                      ${nx} \
        dx                      ${dx} \
        ny                      ${ny} \
        dy                      ${dy} \
        diode_type              ndiode \
        diode_contact_type      ndiodec \
        diode_contact_size      ${cnt_a} \
        diode_contact_cover     ${contcov} \
        diode_contact_enclosure ${cnt_c} \
    ]

    set ringdict [dict create \
        well_type               pwell \
        subdiff_type            psubdiff \
        subdiff_distance        [list ${act_b} \
                                      ${act_b} \
                                      ${act_b} \
                                      ${act_b}] \
        subdiff_enclose_contact ${cnt_c} \
        well_enclose_subdiff    0 \
        contact_type            psubdiffcont \
        contact_size            ${cnt_a} \
        contact_location        [list 1 1 1 1] \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]

    set diodedict [dict merge $coredict $ringdict]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::diode_device" $diodedict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::diode_device" $diodedict]
        setbox ${e}
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list ${act_b} \
                                          ${act_b} \
                                          ${act_b} \
                                          ${act_b}] \
            subdiff_enclose_contact ${cnt_c} \
            well_enclose_subdiff    0 \
            contact_type            psubdiffcont \
            contact_size            ${cnt_a} \
            contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
            metal_type              m1 \
            metal_enclose_contact   ${m1_c1} \
            minimal_well_enclosure  [list 0 0 0 0] \
        ]
        return [sg13g2_devstdin::guard_draw $guarddict]
    }
}

#----------------------------------------------------------------

proc sg13g2_devstdin::dpantenna_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set coredict [dict create \
        w                       ${w} \
        l                       ${l} \
        nx                      ${nx} \
        dx                      ${dx} \
        ny                      ${ny} \
        dy                      ${dy} \
        diode_type              pdiode \
        diode_contact_type      pdiodec \
        diode_contact_size      ${cnt_a} \
        diode_contact_cover     ${contcov} \
        diode_contact_enclosure ${cnt_c} \
    ]

    set ringdict [dict create \
        well_type               nwell \
        subdiff_type            nsubdiff \
        subdiff_distance        [list ${act_b} \
                                      ${act_b} \
                                      ${act_b} \
                                      ${act_b}] \
        subdiff_enclose_contact ${cnt_c} \
        well_enclose_subdiff    ${nw_e} \
        contact_type            nsubdiffcont \
        contact_size            ${cnt_a} \
        contact_location        [list 1 1 1 1] \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]

    set diodedict [dict merge $coredict $ringdict]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::diode_device" $diodedict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::diode_device" $diodedict]
        setbox ${e}
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list ${nw_f} \
                                          ${nw_f} \
                                          ${nw_f} \
                                          ${nw_f}] \
            subdiff_enclose_contact ${cnt_c} \
            well_enclose_subdiff    0 \
            contact_type            psubdiffcont \
            contact_size            ${cnt_a} \
            contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
            metal_type              m1 \
            metal_enclose_contact   ${m1_c1} \
            minimal_well_enclosure  [list 0 0 0 0] \
        ]
        return [sg13g2_devstdin::guard_draw $guarddict]
    }
}

#----------------------------------------------------------------

