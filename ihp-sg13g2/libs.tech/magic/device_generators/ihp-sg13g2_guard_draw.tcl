#----------------------------------------------------------------
# Draws a guard ring. Contacts start at box edge
#----------------------------------------------------------------
# Parameters:
#  - well_type:
#      Tile type to use inside guard ring and for enclosure
#      of contacts.
#  - subdiff_type:
#      Tile type to use under contacts
#  - subdiff_distance:
#      Distance of beginning of contacts from box 
#      ([t, b, l, r], um) 
#  - subdiff_enclose_contact:
#      Subdiff enclosure of contacts
#  - contact_type:
#      Tile type to use for contacts
#  - contact_size:
#      Size of contacts used in contact ring (um)
#  - contact_location:
#      Selects sides with guard ring contacts
#      ([t, b, l, r], 1/0)
#  - metal_type:
#      Tile type to use for metal guard ring
#  - metal_enclose_contact:
#      Metal enclose of contacts
#  - minimal_well_enclosure:
#      minimal extension of well type on box sides where contacts 
#      are disabled ([t, b, l, r], um).
#
#----------------------------------------------------------------

proc sg13g2_devstdin::guard_draw {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    set box_initial [getbox]

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # dont paint well type if it is pwell
    if {${well_type} == "pwell"} {
        set paint_well 0
    } else {
        set paint_well 1
    }

    set d {top bottom left right}

    # Expand box at each side depending on selection of contact location
    for {set i 0} {$i < 4} {incr i} {    
        if {[lindex ${contact_location} ${i}] == 1} {
            box grow [lindex ${d} ${i}] [lindex ${subdiff_distance} ${i}]um
        } else {
            box grow [lindex ${d} ${i}] [lindex ${minimal_well_enclosure} ${i}]um
        }
    }
    if {${paint_well} == 1} { paint ${well_type} }

    set box_start_contact [getbox]

    set diffwidth [+ ${contact_size} [* ${subdiff_enclose_contact} 2]]

    # Paint diffusion areas if contacts should be implemented
    # top
    setbox $box_start_contact
    if {[lindex ${contact_location} 0] == 1} {
        flipbox top ${diffwidth}
        if {[lindex ${contact_location} 2] == 1} { box grow left ${diffwidth}um } else { box shrink left ${well_enclose_subdiff}um }
        if {[lindex ${contact_location} 3] == 1} { box grow right ${diffwidth}um } else { box shrink right ${well_enclose_subdiff}um }
        paint ${subdiff_type}
        set box_top_diffusion [getbox]
        if {[lindex ${contact_location} 2] == 1} { box shrink left ${diffwidth}um }
        if {[lindex ${contact_location} 3] == 1} { box shrink right ${diffwidth}um }
        box shrink c ${subdiff_enclose_contact}um
        paint ${contact_type}
        setbox ${box_top_diffusion}
        box shrink c [- ${subdiff_enclose_contact} ${metal_enclose_contact}]um
        paint ${metal_type}
    }
    # bottom
    setbox $box_start_contact
    if {[lindex ${contact_location} 1] == 1} {
        flipbox bottom ${diffwidth}
        if {[lindex ${contact_location} 2] == 1} { box grow left ${diffwidth}um } else { box shrink left ${well_enclose_subdiff}um }
        if {[lindex ${contact_location} 3] == 1} { box grow right ${diffwidth}um } else { box shrink right ${well_enclose_subdiff}um }
        paint ${subdiff_type}
        set box_bottom_diffusion [getbox]
        if {[lindex ${contact_location} 2] == 1} { box shrink left ${diffwidth}um }
        if {[lindex ${contact_location} 3] == 1} { box shrink right ${diffwidth}um }
        box shrink c ${subdiff_enclose_contact}um
        paint ${contact_type}
        setbox ${box_bottom_diffusion}
        box shrink c [- ${subdiff_enclose_contact} ${metal_enclose_contact}]um
        paint ${metal_type}
    }
    # left
    setbox $box_start_contact
    if {[lindex ${contact_location} 2] == 1} {
        flipbox left ${diffwidth}
        if {[lindex ${contact_location} 0] == 1} { box grow top ${diffwidth}um } else { box shrink top ${well_enclose_subdiff}um }
        if {[lindex ${contact_location} 1] == 1} { box grow bottom ${diffwidth}um } else { box shrink bottom ${well_enclose_subdiff}um }
        paint ${subdiff_type}
        set box_left_diffusion [getbox]
        if {[lindex ${contact_location} 0] == 1} { box shrink top ${diffwidth}um }
        if {[lindex ${contact_location} 1] == 1} { box shrink bottom ${diffwidth}um }
        box shrink c ${subdiff_enclose_contact}um
        paint ${contact_type}
        setbox ${box_left_diffusion}
        box shrink c [- ${subdiff_enclose_contact} ${metal_enclose_contact}]um
        paint ${metal_type}
    }
    # right
    setbox $box_start_contact
    if {[lindex ${contact_location} 3] == 1} {
        flipbox right ${diffwidth}
        if {[lindex ${contact_location} 0] == 1} { box grow top ${diffwidth}um } else { box shrink top ${well_enclose_subdiff}um }
        if {[lindex ${contact_location} 1] == 1} { box grow bottom ${diffwidth}um } else { box shrink bottom ${well_enclose_subdiff}um }
        paint ${subdiff_type}
        set box_right_diffusion [getbox]
        if {[lindex ${contact_location} 0] == 1} { box shrink top ${diffwidth}um }
        if {[lindex ${contact_location} 1] == 1} { box shrink bottom ${diffwidth}um }
        box shrink c ${subdiff_enclose_contact}um
        paint ${contact_type}
        setbox ${box_right_diffusion}
        box shrink c [- ${subdiff_enclose_contact} ${metal_enclose_contact}]um
        paint ${metal_type}
    }

    # Get contacts outside edge and well overlap
    setbox $box_start_contact
    for {set i 0} {$i < 4} {incr i} {    
        if {[lindex ${contact_location} ${i}] == 1} {
            box grow [lindex ${d} ${i}] ${diffwidth}um
            box grow [lindex ${d} ${i}] ${well_enclose_subdiff}um
        }
    }
    if {${paint_well} == 1} { paint ${well_type} }
    
    set box_bounding [getbox]

    setbox $box_initial

    return ${box_bounding}
}

#----------------------------------------------------------------

proc sg13g2_devstdin::nwell_draw {} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    #foreach key [dict keys $parameters] {
    #    set $key [dict get $parameters $key]
    #}

    set gtc 1
    set gbc 1
    set glc 1
    set grc 1

    set guarddict [dict create \
        well_type               nwell \
        subdiff_type            nsubdiff \
        subdiff_distance        [list 0.0 \
                                      0.0 \
                                      0.0 \
                                      0.0] \
        subdiff_enclose_contact ${cnt_c} \
        well_enclose_subdiff    ${nw_e} \
        contact_type            nsubdiffcont \
        contact_size            ${cnt_a} \
        contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]
    return [sg13g2_devstdin::guard_draw $guarddict]
}

proc sg13g2_devstdin::pwell_draw {} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }
    # Set a local variable for each parameter
    #foreach key [dict keys $parameters] {
    #    set $key [dict get $parameters $key]
    #}

    set gtc 1
    set gbc 1
    set glc 1
    set grc 1

    set guarddict [dict create \
        well_type               pwell \
        subdiff_type            psubdiff \
        subdiff_distance        [list 0.0 \
                                      0.0 \
                                      0.0 \
                                      0.0] \
        subdiff_enclose_contact ${cnt_c} \
        well_enclose_subdiff    0.0 \
        contact_type            psubdiffcont \
        contact_size            ${cnt_a} \
        contact_location        [list ${gtc} ${gbc} ${glc} ${grc}] \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
        minimal_well_enclosure  [list 0 0 0 0] \
    ]
    return [sg13g2_devstdin::guard_draw $guarddict]
}