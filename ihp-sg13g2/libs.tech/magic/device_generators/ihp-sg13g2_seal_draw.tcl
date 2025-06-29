#----------------------------------------------------------------
# Draw a seal ring which starts at box and grows outwards
#----------------------------------------------------------------

proc sg13g2_devstdin::seal_draw {} {
    set box_w [getboxwidth]
    set box_h [getboxheight]
    set box_initial [getbox]
    
    set seal_width 4.2
    set num_edge_segments 9
    set corner_offset [* ${seal_width} 4]
    set side_height [- ${box_h} [* ${corner_offset} 2]]
    set side_width [- ${box_w} [* ${corner_offset} 2]]
    set inner_to_outer 3

    tech unlock seal,sealc,sealv1,sealv2,sealv3,sealv4,sealv5,sealv6

    # draw left side
    # --------------
    do_side_drawing ${box_initial} "left" ${side_height} ${seal_width} 0

    # draw upper left corner
    # ----------------------
    setbox ${box_initial}
    flipbox left ${seal_width}
    setcboxheight ${side_height}
    do_corner_drawing "top" "right" ${seal_width} ${num_edge_segments}

    # draw top side
    # -------------
    do_side_drawing ${box_initial} "top" ${side_width} ${seal_width} 0

    # draw upper right corner
    # -----------------------
    setbox ${box_initial}
    flipbox top ${seal_width}
    setcboxwidth ${side_width}
    do_corner_drawing "right" "bottom" ${seal_width} ${num_edge_segments}

    # draw right side
    # ---------------
    do_side_drawing ${box_initial} "right" ${side_height} ${seal_width} 0

    # draw lower right corner
    # -----------------------
    setbox ${box_initial}
    flipbox right ${seal_width}
    setcboxheight ${side_height}
    do_corner_drawing "bottom" "left" ${seal_width} ${num_edge_segments}

    # draw bottom side
    # ----------------
    do_side_drawing ${box_initial} "bottom" ${side_width} ${seal_width} 0

    # draw lower left corner
    # ----------------------
    setbox ${box_initial}
    flipbox bottom ${seal_width}
    setcboxwidth ${side_width}
    do_corner_drawing "left" "top" ${seal_width} ${num_edge_segments}

    # draw outer seal ring (passivation opening)
    # ------------------------------------------
    # ------------------------------------------
    setbox ${box_initial}
    box grow c [+ ${inner_to_outer} ${seal_width}]um
    set box_w [getboxwidth]
    set box_h [getboxheight]
    set box_initial_outer [getbox]

    set side_height_outer [- ${box_h} [* ${corner_offset} 2]]
    set side_width_outer [- ${box_w} [* ${corner_offset} 2]]

    # draw left side
    # --------------
    do_side_drawing ${box_initial_outer} "left" ${side_height_outer} ${seal_width} 1

    # draw upper left corner
    # ----------------------
    setbox ${box_initial_outer}
    flipbox left ${seal_width}
    setcboxheight ${side_height_outer}
    do_corner_drawing "top" "right" ${seal_width} ${num_edge_segments}

    # draw top side
    # -------------
    do_side_drawing ${box_initial_outer} "top" ${side_width_outer} ${seal_width} 1

    # draw upper right corner
    # -----------------------
    setbox ${box_initial_outer}
    flipbox top ${seal_width}
    setcboxwidth ${side_width_outer}
    do_corner_drawing "right" "bottom" ${seal_width} ${num_edge_segments}

    # draw right side
    # ---------------
    do_side_drawing ${box_initial_outer} "right" ${side_height_outer} ${seal_width} 1

    # draw lower right corner
    # -----------------------
    setbox ${box_initial_outer}
    flipbox right ${seal_width}
    setcboxheight ${side_height_outer}
    do_corner_drawing "bottom" "left" ${seal_width} ${num_edge_segments}

    # draw bottom side
    # ----------------
    do_side_drawing ${box_initial_outer} "bottom" ${side_width_outer} ${seal_width} 1

    # draw lower left corner
    # ----------------------
    setbox ${box_initial_outer}
    flipbox bottom ${seal_width}
    setcboxwidth ${side_width_outer}
    do_corner_drawing "left" "top" ${seal_width} ${num_edge_segments}

    tech lock seal,sealc,sealv1,sealv2,sealv3,sealv4,sealv5,sealv6

    setbox ${box_initial}
}

proc sg13g2_devstdin::do_corner_drawing {f_dir s_dir seal_w num_segs} {
    set current_dir 0
    for {set i 0} {$i < ${num_segs}} {incr i} {
        if {${current_dir} == 0} {
            set grow_dir ${f_dir}
            set corner_dir ${s_dir}
            set current_dir 1
        } else {
            set grow_dir ${s_dir}
            set corner_dir ${f_dir}
            set current_dir 0
        }
        flipbox ${grow_dir} ${seal_w}
        corner ${grow_dir} ${corner_dir}
    }
}

proc sg13g2_devstdin::do_side_drawing {init_box flipdir side_length seal_w outer} {
    # draw side
    setbox ${init_box}
    flipbox ${flipdir} ${seal_w}
    if {${flipdir} == "top"} { setcboxwidth ${side_length} }
    if {${flipdir} == "bottom"} { setcboxwidth ${side_length} }
    if {${flipdir} == "left"} { setcboxheight ${side_length} }
    if {${flipdir} == "right"} { setcboxheight ${side_length} }
    if {${outer} == 0} {
        paint m1,m2,m3,m4,m5,m6,m7
    } else {
        paint seal
    }

    if {${outer} == 0} {
        # draw contact
        setbox ${init_box}
        box grow c [- 2.2 0.16]um
        flipbox ${flipdir} 0.16
        if {${flipdir} == "top"} { setcboxwidth ${side_length} }
        if {${flipdir} == "bottom"} { setcboxwidth ${side_length} }
        if {${flipdir} == "left"} { setcboxheight ${side_length} }
        if {${flipdir} == "right"} { setcboxheight ${side_length} }
        paint sealc

        # draw vias 1,2,3,4
        setbox ${init_box}
        box grow c [- 2.2 0.19]um
        flipbox ${flipdir} 0.19
        if {${flipdir} == "top"} { setcboxwidth ${side_length} }
        if {${flipdir} == "bottom"} { setcboxwidth ${side_length} }
        if {${flipdir} == "left"} { setcboxheight ${side_length} }
        if {${flipdir} == "right"} { setcboxheight ${side_length} }
        paint sealv1,sealv2,sealv3,sealv4

        # draw via5
        setbox ${init_box}
        box grow c [- 2.2 0.42]um
        flipbox ${flipdir} 0.42
        if {${flipdir} == "top"} { setcboxwidth ${side_length} }
        if {${flipdir} == "bottom"} { setcboxwidth ${side_length} }
        if {${flipdir} == "left"} { setcboxheight ${side_length} }
        if {${flipdir} == "right"} { setcboxheight ${side_length} }
        paint sealv5

        # draw via6
        setbox ${init_box}
        box grow c [- 2.2 0.9]um
        flipbox ${flipdir} 0.9
        if {${flipdir} == "top"} { setcboxwidth ${side_length} }
        if {${flipdir} == "bottom"} { setcboxwidth ${side_length} }
        if {${flipdir} == "left"} { setcboxheight ${side_length} }
        if {${flipdir} == "right"} { setcboxheight ${side_length} }
        paint sealv6
    }
}
