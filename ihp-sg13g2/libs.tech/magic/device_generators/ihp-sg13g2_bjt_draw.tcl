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
#----------------------------------------------------------------

proc sg13g2_devstdin::bjt_device {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set box_initial [getbox]

    # Draw bjt and center contact
    box size 0 0
    set box_origin [getbox]

    set hw [/ $w 2.0]
    set hl [/ $l 2.0]
    box grow n ${hl}um
    box grow s ${hl}um
    box grow e ${hw}um
    box grow w ${hw}um
    paint ${emitter_type}
    set box_emitter [getbox]

    # draw core contact
    box shrink c ${emitter_enclose_cont}um
    paint ${emitter_contact_type}
    set box_emitter_cont [getbox]

    # draw metal over contact
    box grow c ${metal_enclose_cont}um
    paint ${contact_metal_type}

    # draw base contact (is a guard ring)
    setbox ${box_emitter}
    set base_enclose [+ [+ [+ ${emitter_base_subdiff_dist} ${base_contact_size}] [* ${base_subdiff_enclose_cont} 2]] ${base_enclose_subdiff}]
    set basedict [dict create \
        well_type               ${base_type} \
        subdiff_type            ${base_subdiff_type} \
        subdiff_distance        [list ${emitter_base_subdiff_dist} \
                                      ${emitter_base_subdiff_dist} \
                                      ${emitter_base_subdiff_dist} \
                                      ${emitter_base_subdiff_dist}] \
        subdiff_enclose_contact ${base_subdiff_enclose_cont} \
        well_enclose_subdiff    ${base_enclose_subdiff} \
        contact_type            ${base_contact_type} \
        contact_size            ${base_contact_size} \
        contact_location        [list 1 1 1 1] \
        metal_type              ${contact_metal_type} \
        metal_enclose_contact   ${metal_enclose_cont} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]
    sg13g2_devstdin::guard_draw $basedict
    box grow c ${base_enclose}um
    set box_base [getbox]

    # draw nbu layer
    setbox ${box_emitter}
    set nbu_enclose_emitter [+ [- ${base_enclose} ${base_enclose_subdiff}] ${nbu_enclose_base_subdiff}]
    box grow c ${nbu_enclose_emitter}um
    paint ${nbu_type}

    # draw collector contact (is a guard ring)
    setbox ${box_base}
    set collector_enclose [+ [+ [+ ${base_collector_subdiff_dist} ${collector_contact_size}] [* ${collector_subdiff_enclose_cont} 2]] ${collector_enclose_subdiff}]
    set collectordict [dict create \
        well_type               ${collector_type} \
        subdiff_type            ${collector_subdiff_type} \
        subdiff_distance        [list ${base_collector_subdiff_dist} \
                                      ${base_collector_subdiff_dist} \
                                      ${base_collector_subdiff_dist} \
                                      ${base_collector_subdiff_dist}] \
        subdiff_enclose_contact ${collector_subdiff_enclose_cont} \
        well_enclose_subdiff    ${collector_enclose_subdiff} \
        contact_type            ${collector_contact_type} \
        contact_size            ${collector_contact_size} \
        contact_location        [list 1 1 1 1] \
        metal_type              ${contact_metal_type} \
        metal_enclose_contact   ${metal_enclose_cont} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]
    sg13g2_devstdin::guard_draw $collectordict
    box grow c ${collector_enclose}um
    set box_collector [getbox]

    return $box_collector
}

#----------------------------------------------------------------

proc sg13g2_devstdin::pnpmpa_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # emitter_base_sufdiff_dist is unclear
    set bjtdict [dict create \
        w                               ${w} \
        l                               ${l} \
        nx                              ${nx} \
        dx                              ${dx} \
        ny                              ${ny} \
        dy                              ${dy} \
        emitter_type                    pdiff \
        emitter_contact_type            pdiffc \
        emitter_contact_size            ${cnt_a} \
        emitter_enclose_cont            ${cnt_c} \
        base_type                       nbase \
        base_enclose_subdiff            ${nw_e} \
        base_contact_type               nsubdiffc \
        base_contact_size               ${cnt_a} \
        base_subdiff_type               nsubdiff \
        base_subdiff_enclose_cont       ${cnt_c} \
        emitter_base_subdiff_dist       0.39 \
        nbu_type                        dnwell \
        nbu_enclose_base_subdiff        0.05 \
        base_collector_subdiff_dist     ${nw_d} \
        collector_type                  pwell \
        collector_enclose_subdiff       0 \
        collector_contact_type          psubdiffc \
        collector_contact_size          ${cnt_a} \
        collector_subdiff_type          psubdiff \
        collector_subdiff_enclose_cont  ${cnt_c} \
        contact_metal_type              m1 \
        metal_enclose_cont              ${m1_c1} \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::bjt_device" $bjtdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::bjt_device" $bjtdict]
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
