#----------------------------------------------------------------
# Draws a well-tie contact
#----------------------------------------------------------------
# Parameters:
#  - subdiff_type:
#      Tile type to use under contacts
#  - subdiff_enclose_contact:
#      Subdiff enclose of contact (um)
#  - contact_type:
#      Tile type to use for contacts
#  - contact_size:
#      Size of contacts used in contact ring (um)
#  - metal_type:
#      Tile type to use for metal guard ring
#  - metal_enclose_contact:
#      Metal enclose of contacs (um)
#----------------------------------------------------------------

proc sg13g2_devstdin::welltie_draw {parameters} {
    # Epsilon for avoiding round-off errors
    set eps  0.0005

    set box_initial [getbox]

    # Set a local variable for each parameter (e.g., $l, $w, etc.)
    foreach key [dict keys $parameters] {
        set $key [dict get $parameters $key]
    }

    # check for minimal size
    set box_w [getboxwidth]
    set box_h [getboxheight]
    set min_size [+ [* ${subdiff_enclose_contact} 2] ${contact_size}]
    if {${box_w} < ${min_size}} { setcboxwidth ${min_size} }
    if {${box_h} < ${min_size}} { setcboxheight ${min_size} }

    set box_bounding [getbox]

    # Paint diffusion areas and contacts
    paint ${subdiff_type}
    box shrink c ${subdiff_enclose_contact}um
    paint ${contact_type}
    box grow c ${metal_enclose_contact}um
    paint ${metal_type}

    setbox ${box_bounding}
    
    return ${box_bounding}
}

#----------------------------------------------------------------

proc sg13g2_devstdin::nwelltie_draw {} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }

    set tiedict [dict create \
        subdiff_type            nsubdiff \
        subdiff_enclose_contact ${cnt_c} \
        contact_type            nsubdiffcont \
        contact_size            ${cnt_a} \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
    ]
    return [sg13g2_devstdin::welltie_draw $tiedict]
}

proc sg13g2_devstdin::pwelltie_draw {} {
    # Set a local variable for each rule in ruleset
    foreach key [dict keys $sg13g2_devstdin::ruleset] {
        set $key [dict get $sg13g2_devstdin::ruleset $key]
    }

    set tiedict [dict create \
        subdiff_type            psubdiff \
        subdiff_enclose_contact ${cnt_c} \
        contact_type            psubdiffcont \
        contact_size            ${cnt_a} \
        metal_type              m1 \
        metal_enclose_contact   ${m1_c1} \
    ]
    return [sg13g2_devstdin::welltie_draw $tiedict]
}