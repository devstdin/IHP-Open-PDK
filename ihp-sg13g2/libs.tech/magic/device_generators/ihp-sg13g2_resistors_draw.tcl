#----------------------------------------------------------------
# Draw a single resistor device
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
#  - resistor_type:
#      Tile type of resistor body
#  - endcap_type:
#      Tile type of resistor endcaps
#  - contact_type:
#      Tile type of end contacts
#  - contacts:
#      Selects whether contacts should be drawn in endcaps (0/1)
#  - contact_size:
#      Size of contacts in endcaps (um)
#  - contact_coverage:
#      Coverage factor of contacts in endcap (0 ... 100%)
#  - contact_enclosure:
#      Enclosure of endcap contacts by endcap_type
#      ([towards resistor body, other sides], um)
#
#----------------------------------------------------------------

proc sg13g2_devstdin::res_device {parameters} {
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
    paint ${resistor_type}
    set box_res_core [getbox]

    set endcap_height [+ [+ [lindex $contact_enclosure 0] $contact_size] [lindex $contact_enclosure 1]]
    flipbox top ${endcap_height}
	paint ${endcap_type}
    set box_endcap_top [getbox]
    
    setbox ${box_res_core}
    flipbox bottom ${endcap_height}
    paint ${endcap_type}
    set box_endcap_bottom [getbox]
    
    setbox ${box_res_core}
    box grow n ${endcap_height}um
    box grow s ${endcap_height}um
    set box_res [sg13g2_devstdin::getbox]

    # Contac size
    # Reduce contact sizes by endcap enclosure
    set epl [- ${w} [* [lindex $contact_enclosure 1] 2]]
    # Reduce by coverage percentage
    if {${contact_coverage} > 0} {
	   set cpl [* ${epl} [/ ${contact_coverage} 100.0]]
    } else {
	   set cpl $epl
    }
    # Check for minimum dimension
    if {${cpl} < ${contact_size}} {
        set cpl ${contact_size}
    }
    set cont_hw [/ ${cpl} 2.0]
    set cont_hh [/ ${contact_size} 2.0]

    # Top contact
    setbox ${box_origin}
    box move n ${hl}um
    box move n [+ [lindex $contact_enclosure 0] $cont_hh]um

    box grow n ${cont_hh}um
    box grow s ${cont_hh}um
    box grow e ${cont_hw}um
    box grow w ${cont_hw}um
    paint ${contact_type}
    set box_top_contact [sg13g2_devstdin::getbox]

    # Bottom contact
    setbox ${box_origin}
    box move s ${hl}um
    box move s [+ [lindex $contact_enclosure 0] $cont_hh]um

    box grow n ${cont_hh}um
    box grow s ${cont_hh}um
    box grow e ${cont_hw}um
    box grow w ${cont_hw}um
    paint ${contact_type}
    set box_bottom_contact [sg13g2_devstdin::getbox]

    return $box_res
}

#----------------------------------------------------------------

proc sg13g2_devstdin::rsil_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set resdict [dict create \
        w                 ${w} \
        l                 ${l} \
        nx                ${nx} \
        dx                ${dx} \
        ny                ${ny} \
        dy                ${dy} \
        resistor_type     npolyres \
        endcap_type       polysilicon \
        contact_type      pcontact \
        contacts          1 \
        contact_size      ${cnt_a} \
        contact_coverage  ${endcov} \
        contact_enclosure [list ${rhi_d} ${cnt_d}] \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
        setbox ${e}
        # subdiff_distance: 2*${gat_d} to give room for metal on endap and guardring
        #subdiff_distance        [list [* [* ${gat_d} 2] 10] \
        #                                  [* [* ${gat_d} 2] 10] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5]]
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list 0.6 \
                                          0.6 \
                                          0.6 \
                                          0.6] \
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

proc sg13g2_devstdin::rppd_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set resdict [dict create \
        w                 ${w} \
        l                 ${l} \
        nx                ${nx} \
        dx                ${dx} \
        ny                ${ny} \
        dy                ${dy} \
        resistor_type     ppolyres \
        endcap_type       polysilicon \
        contact_type      pcontact \
        contacts          1 \
        contact_size      ${cnt_a} \
        contact_coverage  ${endcov} \
        contact_enclosure [list ${rhi_d} ${cnt_d}] \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
        setbox ${e}
        # subdiff_distance: 2*${gat_d} to give room for metal on endap and guardring
        #subdiff_distance        [list [* [* ${gat_d} 2] 10] \
        #                                  [* [* ${gat_d} 2] 10] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5]]
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list 0.6 \
                                          0.6 \
                                          0.6 \
                                          0.6] \
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

proc sg13g2_devstdin::rhigh_draw {parameters} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    set resdict [dict create \
        w                 ${w} \
        l                 ${l} \
        nx                ${nx} \
        dx                ${dx} \
        ny                ${ny} \
        dy                ${dy} \
        resistor_type     xpolyres \
        endcap_type       polysilicon \
        contact_type      pcontact \
        contacts          1 \
        contact_size      ${cnt_a} \
        contact_coverage  ${endcov} \
        contact_enclosure [list ${rhi_d} ${cnt_d}] \
    ]

    set guard [expr {${gtc} || ${gbc} || ${glc} || ${grc}}]

    if {$guard == 0} {
        return [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
    } else {
        set e [sg13g2_devstdin::tiled_draw "sg13g2_devstdin::res_device" $resdict]
        setbox ${e}
        # subdiff_distance: 2*${gat_d} to give room for metal on endap and guardring
        #subdiff_distance        [list [* [* ${gat_d} 2] 10] \
        #                                  [* [* ${gat_d} 2] 10] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5] \
        #                                  [* [+ ${sal_d} ${sal_c}] 5]]
        set guarddict [dict create \
            well_type               pwell \
            subdiff_type            psubdiff \
            subdiff_distance        [list 0.6 \
                                          0.6 \
                                          0.6 \
                                          0.6] \
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

