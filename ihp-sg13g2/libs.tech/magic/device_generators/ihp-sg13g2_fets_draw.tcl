#----------------------------------------------------------------
# Draw a single transistor device
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
#  - transistor_type:
#  - well_type:
#  - diff_type:
#  - gate_type:
#  - well_enclose_diff:
#  - diff_contact_type:
#  - gate_contact_type:
#  - diff_contact_size:
#  - gate_contact_size:
#  - diff_contact_coverage:
#  - gate_contact_coverage:
#  - diff_contact_enclosure:
#  - gate_contact_enclosure:
#  - gate_endcap:
#  - gate_diff_space:
#----------------------------------------------------------------

proc sg13g2_devstdin::fet_device {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # decide if dogbone shape is required for gate
    if {${l} < [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]} {
        set gate_dogbone 1
    } else {
        set gate_dogbone 0
    }
    # decide if dogbone shape is required for diffusion
    if {${w} < [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]} {
        set diff_dogbone 1
    } else {
        set diff_dogbone 0
    }

    set box_initial [getbox]

    # Draw transistor
    box size 0 0
    set box_origin [getbox]

    set hw [/ $w 2.0]
    set hl [/ $l 2.0]
    box grow n ${hw}um
    box grow s ${hw}um
    box grow e ${hl}um
    box grow w ${hl}um
    paint ${transistor_type}
    set box_t_core [getbox]

    # Draw gate endcaps for dogbone
    if {${gate_dogbone} == 1} {
        # top contact
        setbox ${box_t_core}
        flipbox top ${gate_endcap}
        paint ${gate_type}
        # top contact coverage >0
        if {[lindex ${gate_contact_coverage} 0] > 0} {
            flipbox top [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            setcboxwidth [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            paint ${gate_type}
            set box_top_contactpoly [getbox]
            box shrink c [lindex ${gate_contact_enclosure} 1]um
            paint ${gate_contact_type}
            set box_top_gatecontact [getbox]
        }
        # bottom contact
        setbox ${box_t_core}
        flipbox bottom ${gate_endcap}
        paint ${gate_type}
        # bottom contact coverage >0
        if {[lindex ${gate_contact_coverage} 1] > 0} {
            flipbox bottom [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            setcboxwidth [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            paint ${gate_type}
            set box_bottom_contactpoly [getbox]
            box shrink c [lindex ${gate_contact_enclosure} 1]um
            paint ${gate_contact_type}
            set box_bottom_gatecontact [getbox]
        }
    } else {
        # no dogbone
        # top contact coverage >0
        if {[lindex ${gate_contact_coverage} 0] > 0} {
            setbox ${box_t_core}
            flipbox top [- [lindex ${gate_contact_enclosure} 0] [lindex ${gate_contact_enclosure} 1]]
            paint ${gate_type}
            flipbox top [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            paint ${gate_type}
            set box_top_contactpoly [getbox]
            box shrink c [lindex ${gate_contact_enclosure} 1]um
            setcboxwidth [* [getboxwidth] [/ [lindex ${gate_contact_coverage} 0] 100.0]]
            if {[getboxwidth] < ${gate_contact_size}} { setcboxwidth ${gate_contact_size} }
            paint ${gate_contact_type}
            set box_top_gatecontact [getbox]
        } else {
            setbox ${box_t_core}
            flipbox top ${gate_endcap}
            paint ${gate_type}
            set box_top_contactpoly [getbox]
        }
        # bottom contact coverage >0
        if {[lindex ${gate_contact_coverage} 1] > 0} {
            setbox ${box_t_core}
            flipbox bottom [- [lindex ${gate_contact_enclosure} 0] [lindex ${gate_contact_enclosure} 1]]
            paint ${gate_type}
            flipbox bottom [+ ${gate_contact_size} [* [lindex ${gate_contact_enclosure} 1] 2]]
            paint ${gate_type}
            set box_bottom_contactpoly [getbox]
            box shrink c [lindex ${gate_contact_enclosure} 1]um
            setcboxwidth [* [getboxwidth] [/ [lindex ${gate_contact_coverage} 1] 100.0]]
            if {[getboxwidth] < ${gate_contact_size}} { setcboxwidth ${gate_contact_size} }
            paint ${gate_contact_type}
            set box_bottom_gatecontact [getbox]
        } else {
            setbox ${box_t_core}
            flipbox bottom ${gate_endcap}
            paint ${gate_type}
            set box_bottom_contactpoly [getbox]
        }
    }

    # Draw diffusion endcaps
    # dogbone
    if {${diff_dogbone} == 1} {
        # left contact
        setbox ${box_t_core}
        flipbox left ${gate_diff_space}
        paint ${diff_type}
        flipbox left [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        setcboxheight [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        paint ${diff_type}
        set box_left_contactdiff [getbox]
        box shrink c [lindex ${gate_contact_enclosure} 1]um
        paint ${diff_contact_type}
        set box_left_diffcontact [getbox]
        # right contact
        setbox ${box_t_core}
        flipbox right ${gate_diff_space}
        paint ${diff_type}
        flipbox right [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        setcboxheight [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        paint ${diff_type}
        set box_right_contactdiff [getbox]
        box shrink c [lindex ${diff_contact_enclosure} 1]um
        paint ${diff_contact_type}
        set box_right_diffcontact [getbox]
    } else {
        # no dogbone
        # left contact 
        setbox ${box_t_core}
        flipbox left [- [lindex ${diff_contact_enclosure} 0] [lindex ${diff_contact_enclosure} 1]]
        paint ${diff_type}
        flipbox left [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        paint ${diff_type}
        set box_left_contactdiff [getbox]
        box shrink c [lindex ${diff_contact_enclosure} 1]um
        setcboxheight [* [getboxheight] [/ [lindex ${diff_contact_coverage} 0] 100.0]]
        if {[getboxheight] < ${diff_contact_size}} { setcboxheight ${diff_contact_size} }
        paint ${diff_contact_type}
        set box_left_diffcontact [getbox]
        # right contact
        setbox ${box_t_core}
        flipbox right [- [lindex ${diff_contact_enclosure} 0] [lindex ${diff_contact_enclosure} 1]]
        paint ${diff_type}
        flipbox right [+ ${diff_contact_size} [* [lindex ${diff_contact_enclosure} 1] 2]]
        paint ${diff_type}
        set box_right_contactdiff [getbox]
        box shrink c [lindex ${diff_contact_enclosure} 1]um
        setcboxheight [* [getboxheight] [/ [lindex ${diff_contact_coverage} 1] 100.0]]
        if {[getboxheight] < ${diff_contact_size}} { setcboxheight ${diff_contact_size} }
        paint ${diff_contact_type}
        set box_right_diffcontact [getbox]
    }

    # Draw well
    setbox ${box_t_core}
    set box_well [getbox]
    set box_well [unionbox ${box_well} ${box_left_contactdiff}]
    set box_well [unionbox ${box_well} ${box_right_contactdiff}]
    setbox ${box_well}
    box grow c ${well_enclose_diff}um
    paint ${well_type}

    # get bounding box
    setbox ${box_t_core}
    set box_bounds [getbox]
    set box_bounds [unionbox ${box_bounds} ${box_top_contactpoly}]
    set box_bounds [unionbox ${box_bounds} ${box_bottom_contactpoly}]
    set box_bounds [unionbox ${box_bounds} ${box_left_contactdiff}]
    set box_bounds [unionbox ${box_bounds} ${box_right_contactdiff}]
    set box_bounds [unionbox ${box_bounds} ${box_well}]
    
    return ${box_bounds}
}

#----------------------------------------------------------------

proc sg13g2_devstdin::lvnmos_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set fetdict [dict create \
        w                      ${w} \
        l                      ${l} \
        nf                     ${nf} \
        nx                     ${nx} \
        dx                     ${dx} \
        ny                     ${ny} \
        dy                     ${dy} \
        transistor_type        nmos \
        well_type              pwell \
        diff_type              ndiff \
        gate_type              polysilicon \
        well_enclose_diff      0 \
        diff_contact_type      ndiffc \
        gate_contact_type      pcontact \
        diff_contact_size      ${cnt_a} \
        gate_contact_size      ${cnt_a} \
        diff_contact_coverage  [list ${dcontcov_l} ${dcontcov_r}] \
        gate_contact_coverage  [list ${gcontcov_t} ${gcontcov_b}] \
        diff_contact_enclosure [list ${cnt_f} ${cnt_c}] \
        gate_contact_enclosure [list ${cnt_e} ${cnt_d}] \
        gate_endcap            ${gat_c} \
        gate_diff_space        ${gat_d} \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
        setbox ${e}
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list [* ${gat_d} 2] \
                                          [* ${gat_d} 2] \
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

proc sg13g2_devstdin::hvnmos_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set fetdict [dict create \
        w                      ${w} \
        l                      ${l} \
        nf                     ${nf} \
        nx                     ${nx} \
        dx                     ${dx} \
        ny                     ${ny} \
        dy                     ${dy} \
        transistor_type        hvnmos \
        well_type              pwell \
        diff_type              hvndiff \
        gate_type              polysilicon \
        well_enclose_diff      0 \
        diff_contact_type      hvndiffc \
        gate_contact_type      pcontact \
        diff_contact_size      ${cnt_a} \
        gate_contact_size      ${cnt_a} \
        diff_contact_coverage  [list ${dcontcov_l} ${dcontcov_r}] \
        gate_contact_coverage  [list ${gcontcov_t} ${gcontcov_b}] \
        diff_contact_enclosure [list ${cnt_f} ${cnt_c}] \
        gate_contact_enclosure [list ${cnt_e} ${cnt_d}] \
        gate_endcap            ${gat_c} \
        gate_diff_space        ${gat_d} \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
        setbox ${e}
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list [* ${gat_d} 2] \
                                          [* ${gat_d} 2] \
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

proc sg13g2_devstdin::lvpmos_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set fetdict [dict create \
        w                      ${w} \
        l                      ${l} \
        nf                     ${nf} \
        nx                     ${nx} \
        dx                     ${dx} \
        ny                     ${ny} \
        dy                     ${dy} \
        transistor_type        pmos \
        well_type              nwell \
        diff_type              pdiff \
        gate_type              polysilicon \
        well_enclose_diff      ${nw_c} \
        diff_contact_type      pdiffc \
        gate_contact_type      pcontact \
        diff_contact_size      ${cnt_a} \
        gate_contact_size      ${cnt_a} \
        diff_contact_coverage  [list ${dcontcov_l} ${dcontcov_r}] \
        gate_contact_coverage  [list ${gcontcov_t} ${gcontcov_b}] \
        diff_contact_enclosure [list ${cnt_f} ${cnt_c}] \
        gate_contact_enclosure [list ${cnt_e} ${cnt_d}] \
        gate_endcap            ${gat_c} \
        gate_diff_space        ${gat_d} \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
        setbox ${e}
        set guarddict [dict create \
            well_type               nwell \
            subdiff_type            nsubdiff \
            subdiff_distance        [list [* ${gat_d} 2] \
                                          [* ${gat_d} 2] \
                                          ${act_b} \
                                          ${act_b}] \
            subdiff_enclose_contact ${cnt_c} \
            well_enclose_subdiff    ${nw_e} \
            contact_type            nsubdiffcont \
            contact_size            ${cnt_a} \
            contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
            metal_type              m1 \
            metal_enclose_contact   ${m1_c1} \
            minimal_well_enclosure  [list 0 \
                                          0 \
                                          0 \
                                          0] \
        ]
        return [sg13g2_devstdin::guard_draw $guarddict]
    }
}

#----------------------------------------------------------------

proc sg13g2_devstdin::hvpmos_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set fetdict [dict create \
        w                      ${w} \
        l                      ${l} \
        nf                     ${nf} \
        nx                     ${nx} \
        dx                     ${dx} \
        ny                     ${ny} \
        dy                     ${dy} \
        transistor_type        hvpmos \
        well_type              nwell \
        diff_type              hvpdiff \
        gate_type              polysilicon \
        well_enclose_diff      ${nw_c1} \
        diff_contact_type      hvpdiffc \
        gate_contact_type      pcontact \
        diff_contact_size      ${cnt_a} \
        gate_contact_size      ${cnt_a} \
        diff_contact_coverage  [list ${dcontcov_l} ${dcontcov_r}] \
        gate_contact_coverage  [list ${gcontcov_t} ${gcontcov_b}] \
        diff_contact_enclosure [list ${cnt_f} ${cnt_c}] \
        gate_contact_enclosure [list ${cnt_e} ${cnt_d}] \
        gate_endcap            ${gat_c} \
        gate_diff_space        ${gat_d} \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::fet_device" $fetdict]
        setbox ${e}
        set guarddict [dict create \
            well_type               nwell \
            subdiff_type            nsubdiff \
            subdiff_distance        [list [* ${gat_d} 2] \
                                          [* ${gat_d} 2] \
                                          ${act_b} \
                                          ${act_b}] \
            subdiff_enclose_contact ${cnt_c} \
            well_enclose_subdiff    ${nw_e1} \
            contact_type            nsubdiffcont \
            contact_size            ${cnt_a} \
            contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
            metal_type              m1 \
            metal_enclose_contact   ${m1_c1} \
            minimal_well_enclosure  [list 0 \
                                          0 \
                                          0 \
                                          0] \
        ]
        return [sg13g2_devstdin::guard_draw $guarddict]
    }
}

#----------------------------------------------------------------
