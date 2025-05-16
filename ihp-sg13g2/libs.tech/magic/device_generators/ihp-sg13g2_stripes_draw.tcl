#----------------------------------------------------------------
# Draw a selectable number of stripes in horizontal/vertical
# direction inside the box
#----------------------------------------------------------------

proc sg13g2_devstdin::stripes_draw {} {

    toplevel .win

    set paramlist [dict create]
    dict set paramlist nhs [dict create text "Horizontal Stripes (#)" default 3 variable v_nhs type ent]
    dict set paramlist hsw [dict create text "Horizontal Stripe Width (um)" default 1 variable v_hsw type ent]
    dict set paramlist hm1 [dict create text "Horizontal Stripes on Metal 1" default 1 variable v_hm1 type chk]
    dict set paramlist hm2 [dict create text "Horizontal Stripes on Metal 2" default 0 variable v_hm2 type chk]
    dict set paramlist nvs [dict create text "Vertical Stripes (#)" default 3 variable v_nvs type ent]
    dict set paramlist vsw [dict create text "Vertical Stripe Width (um)" default 1 variable v_vsw type ent]
    dict set paramlist vm1 [dict create text "Vertical Stripes on Metal 1" default 1 variable v_vm1 type chk]
    dict set paramlist vm2 [dict create text "Vertical Stripes on Metal 2" default 0 variable v_vm2 type chk]

    set row 0
    foreach id [dict keys $paramlist] {
        label .win.${id}_lab -text [dict get $paramlist $id text]
        set [dict get $paramlist $id variable] [dict get $paramlist $id default]
        if {[dict get $paramlist $id type] == "ent"} {
            entry .win.${id}_userin -background white -textvariable [dict get $paramlist $id variable]
            .win.${id}_userin delete 0 end
            .win.${id}_userin insert 0 [dict get $paramlist $id default]
        }
        if {[dict get $paramlist $id type] == "chk"} {
            checkbutton .win.${id}_userin  -variable [dict get $paramlist $id variable]
            if {[dict get $paramlist $id default] == 1} {
                .win.${id}_userin select
            } else {
                .win.${id}_userin deselect
            }
        }
        grid .win.${id}_lab -row ${row} -column 0 -sticky ens -pady 2 -padx 5
        grid .win.${id}_userin -row ${row} -column 1 -sticky wns -pady 2 -padx 5
        set row [expr ${row} + 1]
    }

    button .win.draw -text "Draw" -command {sg13g2_devstdin::do_stripes_drawing $v_nhs $v_hsw $v_hm1 $v_hm2 $v_nvs $v_vsw $v_vm1 $v_vm2}
    button .win.close -text "Close" -command {destroy .win}
    grid .win.draw  -row ${row} -column 0 -sticky wns -pady 5 -padx 5
    grid .win.close -row ${row} -column 1 -sticky ens -pady 5 -padx 5

}

proc sg13g2_devstdin::do_stripes_drawing {v_nhs v_hsw v_hm1 v_hm2 v_nvs v_vsw v_vm1 v_vm2} {
    set box_w [getboxwidth]
    set box_h [getboxheight]
    set box_initial [getbox]

    if {${v_nhs} > 0} {
        set isol_v [/ [- ${box_h} [* ${v_nhs} ${v_hsw}]] [+ ${v_nhs} 1.0]]
        box height ${isol_v}um
        for {set i 0} {$i < ${v_nhs}} {incr i} {
            flipbox top ${v_hsw}
            if {${v_hm1} == 1} { paint m1 }
            if {${v_hm2} == 1} { paint m2 }
            flipbox top ${isol_v}
        }
    }
    setbox ${box_initial}
    if {${v_nvs} > 0} {
        set isol_h [/ [- ${box_w} [* ${v_nvs} ${v_vsw}]] [+ ${v_nvs} 1.0]]
        box width ${isol_h}um
        for {set i 0} {$i < ${v_nvs}} {incr i} {
            flipbox right ${v_vsw}
            if {${v_vm1} == 1} { paint m1 }
            if {${v_vm2} == 1} { paint m2 }
            flipbox right ${isol_h}
        }
    }
    setbox ${box_initial}
}
