package require tkpath 0.3.3


proc ShowWindow.tpgradient { id grad} {
  global TPcolor
  global Gradient
  catch "destroy .tpgradient"
    catch {unset Gradient}
  if {$grad == ""} {
    set Gradient(type) linear
    set Gradient(color0) red
    set Gradient(color1) black
    set Gradient(offset0) 0.0
    set Gradient(offset1) 1.0
    set Gradient(opacity0) 0.5
    set Gradient(opacity1) 0.8
    set Gradient(x0) 0
    set Gradient(x1) 1
    set Gradient(y0) 0
    set Gradient(y1) 0
    set Gradient(cx) 0.5
    set Gradient(cy) 0.5
    set Gradient(r) 0.5
    set Gradient(fx) 0.25
    set Gradient(fy) 0.25
    set Gradient(units) "bbox"
    set Gradient(unitssel) 0
    set Gradient(i) 2
  } else {
    array set Gradient [parsegradient .c  $grad]
    if {$Gradient(type) == "linear"} {
	set Gradient(cx) 0.5
	set Gradient(cy) 0.5
	set Gradient(r) 0.5
	set Gradient(fx) 0.25
	set Gradient(fy) 0.25
    } else {
	set Gradient(x0) 0
	set Gradient(x1) 1
	set Gradient(y0) 0
	set Gradient(y1) 0
    }

#    puts "ShowWindow.tpgradient: Gradient(i)=$Gradient(i)"
  }

  toplevel .tpgradient   -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tpgradient ""
  wm sizefrom .tpgradient ""
  wm maxsize .tpgradient 480 640
  wm minsize .tpgradient 480 240
  wm geometry .tpgradient 480x300+200+100
  wm title .tpgradient {TKpaint create gradient}


frame .tpgradient.frameFirst -borderwidth {1} -relief {raised} -background {#d6d2d0} -height {30} -width {30}

tkp::canvas .tpgradient.frameFirst.canvas18 -background {#FFE4C4} -height {87} -highlightthickness {0} -selectborderwidth {0} -width {100}

pack .tpgradient.frameFirst.canvas18 -anchor n -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side right

frame .tpgradient.frameFirst.frame0 -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {30} -width {30}

frame .tpgradient.frameFirst.frame0.frame2 -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {30} -width {30}

ttk::radiobutton .tpgradient.frameFirst.frame0.frame2.radiobutton3 -variable {Gradient(type)} -value linear -text {Linear} -width {0} -padding {0} -command {settransition;updategradient}

ttk::radiobutton .tpgradient.frameFirst.frame0.frame2.radiobutton4 -variable {Gradient(type)} -value radial -text {Radial} -command {settransition;updategradient}
ttk::checkbutton .tpgradient.frameFirst.frame0.frame2.checkunits -variable {Gradient(unitssel)}  -text {userspace:} -command {setuserspace}
pack .tpgradient.frameFirst.frame0.frame2.radiobutton3 -anchor center -expand 1 -fill none -ipadx 0 -ipady 0 -padx 10 -pady 0 -side left
pack .tpgradient.frameFirst.frame0.frame2.radiobutton4 -anchor center -expand 1 -fill none -ipadx 0 -ipady 0 -padx 10 -pady 0 -side left
pack .tpgradient.frameFirst.frame0.frame2.checkunits -anchor center -expand 1 -fill none -ipadx 0 -ipady 0 -padx 10 -pady 0 -side left
pack .tpgradient.frameFirst.frame0.frame2.radiobutton3 .tpgradient.frameFirst.frame0.frame2.radiobutton4 .tpgradient.frameFirst.frame0.frame2.checkunits -in .tpgradient.frameFirst.frame0.frame2
pack .tpgradient.frameFirst.frame0.frame2 -anchor n -expand 0 -fill x -ipadx 0 -ipady 0 -padx 40 -pady 0 -side top
#For userspace
#Linear transition
    set wtrl ".tpgradient.frameFirst.frame0.frame3"
    frame $wtrl -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {10} 
    label $wtrl.l1 -text {Transition:} 
    pack $wtrl.l1 -side left
    label $wtrl.l2 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {x0:}
    pack $wtrl.l2 -anchor center -expand 0 -side left
    entry $wtrl.e2 -background {white} -textvariable Gradient(x0) -borderwidth {0} -foreground {#221f1e}  -width {3} -highlightthickness {0} 
    pack $wtrl.e2 -anchor center -expand 0 -padx 1 -side left -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 
    label $wtrl.l3 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {x1:}
    pack $wtrl.l3 -anchor center -expand 0 -side left
    entry $wtrl.e3 -background {white} -textvariable Gradient(x1) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrl.e3 -anchor center -expand 0 -padx 1 -side left
    label $wtrl.l4 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {y0:}
    pack $wtrl.l4 -anchor center -expand 0 -side left
    entry $wtrl.e4 -background {white} -textvariable Gradient(y0) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrl.e4 -anchor center -expand 0 -padx 1 -side left
    label $wtrl.l5 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {y1:}
    pack $wtrl.l5 -anchor center -expand 0 -side left
    entry $wtrl.e5 -background {white} -textvariable Gradient(y1) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrl.e5 -anchor center -expand 0 -padx 1 -side left
#Radial transition
    set wtrr ".tpgradient.frameFirst.frame0.frame4"
    frame $wtrr -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {10} 
    label $wtrr.l1 -text {Transition:} 
    pack $wtrr.l1 -side left
    label $wtrr.l2 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {cx:}
    pack $wtrr.l2 -anchor center -expand 0 -side left
    entry $wtrr.e2 -background {white} -textvariable Gradient(cx) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0} -highlightthickness {0}
    pack $wtrr.e2 -anchor center -expand 0 -padx 1 -side left
    label $wtrr.l3 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {cy:}
    pack $wtrr.l3 -anchor center -expand 0 -side left
    entry $wtrr.e3 -background {white} -textvariable Gradient(cy) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrr.e3 -anchor center -expand 0 -padx 1 -side left
    label $wtrr.l4 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {r:}
    pack $wtrr.l4 -anchor center -expand 0 -side left
    entry $wtrr.e4 -background {white} -textvariable Gradient(r) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrr.e4 -anchor center -expand 0 -padx 1 -side left
    label $wtrr.l5 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {fx:}
    pack $wtrr.l5 -anchor center -expand 0 -side left
    entry $wtrr.e5 -background {white} -textvariable Gradient(fx) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrr.e5 -anchor center -expand 0 -padx 1 -side left
    label $wtrr.l6 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {fy:}
    pack $wtrr.l6 -anchor center -expand 0 -side left
    entry $wtrr.e6 -background {white} -textvariable Gradient(fy) -borderwidth {0} -relief {flat} -foreground {#221f1e}  -width {4} -highlightthickness {0}
    pack $wtrr.e6 -anchor center -expand 0 -padx 1 -side left
    pack $wtrr -anchor n -expand 1 -fill x -ipadx 0 -ipady 0 -pady 0 -side top
#For bbox
#Linear transition
    set wtrlb ".tpgradient.frameFirst.frame0.fbboxl"
    frame $wtrlb -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {10} 
    label $wtrlb.l1 -text {Transition:} 
    pack $wtrlb.l1 -side left
    label $wtrlb.l2 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {x0:}
    pack $wtrlb.l2 -anchor center -expand 0 -side left
    spinbox $wtrlb.e2 -background {white} -textvariable Gradient(x0) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrlb.e2 -anchor center -expand 0 -padx 1 -side left -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 
    label $wtrlb.l3 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {x1:}
    pack $wtrlb.l3 -anchor center -expand 0 -side left
    spinbox $wtrlb.e3 -background {white} -textvariable Gradient(x1) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrlb.e3 -anchor center -expand 0 -padx 1 -side left
    label $wtrlb.l4 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {y0:}
    pack $wtrlb.l4 -anchor center -expand 0 -side left
    spinbox $wtrlb.e4 -background {white} -textvariable Gradient(y0) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrlb.e4 -anchor center -expand 0 -padx 1 -side left
    label $wtrlb.l5 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {y1:}
    pack $wtrlb.l5 -anchor center -expand 0 -side left
    spinbox $wtrlb.e5 -background {white} -textvariable Gradient(y1) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrlb.e5 -anchor center -expand 0 -padx 1 -side left
#Radial transition
    set wtrrb ".tpgradient.frameFirst.frame0.fbboxr"
    frame $wtrrb -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {10} 
    label $wtrrb.l1 -text {Transition:} 
    pack $wtrrb.l1 -side left
    label $wtrrb.l2 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {cx:}
    pack $wtrrb.l2 -anchor center -expand 0 -side left
    spinbox $wtrrb.e2 -background {white} -textvariable Gradient(cx) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrrb.e2 -anchor center -expand 0 -padx 1 -side left
    label $wtrrb.l3 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {cy:}
    pack $wtrrb.l3 -anchor center -expand 0 -side left
    spinbox $wtrrb.e3 -background {white} -textvariable Gradient(cy) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrrb.e3 -anchor center -expand 0 -padx 1 -side left
    label $wtrrb.l4 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {r:}
    pack $wtrrb.l4 -anchor center -expand 0 -side left
    spinbox $wtrrb.e4 -background {white} -textvariable Gradient(r) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrrb.e4 -anchor center -expand 0 -padx 1 -side left
    label $wtrrb.l5 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {fx:}
    pack $wtrrb.l5 -anchor center -expand 0 -side left
    spinbox $wtrrb.e5 -background {white} -textvariable Gradient(fx) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrrb.e5 -anchor center -expand 0 -padx 1 -side left
    label $wtrrb.l6 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {fy:}
    pack $wtrrb.l6 -anchor center -expand 0 -side left
    spinbox $wtrrb.e6 -background {white} -textvariable Gradient(fy) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -increment {0.1} -to {1.0} -width {3} -command {changetransition .tpgradient.frameFirst.canvas18}
    pack $wtrrb.e6 -anchor center -expand 0 -padx 1 -side left

label .tpgradient.frameFirst.frame0.label1 -background {#d6d2d0} -foreground {#221f1e} -relief {flat} -text {Type Gradient}

pack .tpgradient.frameFirst.frame0.label1 -anchor n -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top

label .tpgradient.frameFirst.frame0.label5 -background {#d6d2d0} -foreground {#221f1e} -relief {flat} -text {Components of the gradient}

pack .tpgradient.frameFirst.frame0.label5 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top

pack .tpgradient.frameFirst.frame0 -anchor nw -expand  1 -fill x -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left
#pack .tpgradient.frameFirst.frame0.label1 .tpgradient.frameFirst.frame0.frame2 .tpgradient.frameFirst.frame0.frame3 .tpgradient.frameFirst.frame0.frame4 .tpgradient.frameFirst.frame0.label5 -in .tpgradient.frameFirst.frame0

pack .tpgradient.frameFirst -anchor ne -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side right
pack .tpgradient.frameFirst.frame0 .tpgradient.frameFirst.canvas18 -in .tpgradient.frameFirst


frame .tpgradient.frameStops -borderwidth {1} -relief {raised}  -borderwidth 2 -background {#d6d2d0} -height {30} -highlightbackground {#d6d2d0} -highlightcolor {#221f1e} -width {30}
    frame .tpgradient.frame6 -borderwidth {0} -relief {flat} -background {#d6d2d0} -height {30} -highlightbackground {#d6d2d0} -highlightcolor {#221f1e} -width {30}

#frame .tpgradient.frame6.frame7 -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {30} -highlightbackground {#d6d2d0} -highlightcolor {#221f1e} -width {30}
    set i 0
    createstop ".tpgradient.frame6" $i
#pack .tpgradient.frame6.frame7 -anchor center -expand 0 -fill x -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top
    incr i
    createstop ".tpgradient.frame6" $i

    set Gradient(newgr) [creategradient .tpgradient.frameFirst.canvas18]
    set Gradient(viewgr) [.tpgradient.frameFirst.canvas18 create prect 0 0 100 87 -fill $Gradient(newgr) -tags {viewgr}]

    incr i
frame .tpgradient.frameStops.buts -borderwidth {2} -relief {flat} -background {#d6d2d0} -height {30} -highlightbackground {#d6d2d0} -highlightcolor {#221f1e} -width {30}
    button .tpgradient.frameStops.buts.butadd -activebackground {skyblue} -background {#d6d2d0} -command {global Gradient; createstop ".tpgradient.frame6" $Gradient(i);viewgradient ".tpgradient.frameFirst.canvas18"} -padx {2} -pady {0} -text "Add stop" -width 10
    button .tpgradient.frameStops.buts.butview -activebackground {skyblue} -background {#d6d2d0} -command {viewgradient ".tpgradient.frameFirst.canvas18"} -padx {2} -pady {0} -text "View" -width 10
    button .tpgradient.frameStops.buts.butok -activebackground {skyblue} -background {#d6d2d0} -command {okgradient} -padx {2} -pady {0} -text "Ok" -width 10
    button .tpgradient.frameStops.buts.butcan -activebackground {skyblue} -background {#d6d2d0} -command {cancelgradient} -padx {2} -pady {0} -text "Cancel" -width 10
    button .tpgradient.frameStops.buts.butdel -activebackground {skyblue} -background {#d6d2d0} -command {deletestop ".tpgradient.frame6"} -padx {2} -pady {0} -text "Delete last" -width 10

    pack .tpgradient.frameStops.buts.butadd -anchor ne -expand 0 -fill none -ipadx 0 -ipady 0 -padx {4 0} -pady {1 1} -side top
    pack .tpgradient.frameStops.buts.butview -anchor ne -expand 0 -fill none -ipadx 0 -ipady 0 -padx {4 0} -pady 1 -side top
    pack .tpgradient.frameStops.buts.butok -anchor ne -expand 0 -fill none -ipadx 0 -ipady 0 -padx {4 0} -pady 1 -side top
    pack .tpgradient.frameStops.buts.butcan -anchor ne -expand 0 -fill none -ipadx 0 -ipady 0 -padx {4 0} -pady 1 -side top
    pack .tpgradient.frameStops.buts.butdel -anchor ne -expand 0 -fill none -ipadx 0 -ipady 0 -padx {4 0} -pady 1 -side top

    pack .tpgradient.frameStops.buts -anchor center -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side right -in .tpgradient.frameStops
    pack .tpgradient.frameStops -anchor center -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side bottom

    pack .tpgradient.frame6 -anchor center -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left -in .tpgradient.frameStops
#    pack .tpgradient.frame6 .tpgradient.frameFirst -in .tpgradient
    pack .tpgradient.frameStops .tpgradient.frameFirst -in .tpgradient

    if {$grad != ""} {
	if {$Gradient(i) > 2} {
	    set i [expr {$Gradient(i) - 2}]
	    set j 2
	    while {$i > 0 } {
		createstop ".tpgradient.frame6" $j
		incr i -1
		incr j
	    }
	}
    }
    settransition
    set newgr [creategradient .tpgradient.frameFirst.canvas18]
#    puts "newgr=$newgr"
    gradientcan
}
proc TP_selcolorgr {but ind} {
    global Gradient
    set tekbg [$but cget -background]
    set color [tk_chooseColor -title "Color" -initialcolor $tekbg -parent .tpgradient]
    if {$color == ""} {
	set color $tekbg
    }
    $but configure -background $color
    set Gradient(color$ind) $color
    changestops .tpgradient.frameFirst.canvas18
    gradientcan
}
proc updategradient {} {
    global Gradient
    catch {    .tpgradient.frameFirst.canvas18 gradient delete $Gradient(newgr)}
    set newgr [creategradient .tpgradient.frameFirst.canvas18]
    set Gradient(newgr) $newgr
    .tpgradient.frameFirst.canvas18 itemconfigure $Gradient(viewgr) -fill $Gradient(newgr)
    gradientcan
}
proc viewgradient {can } {
    changetransition $can
    changestops $can
}

proc okgradient {} {
    global Gradient
    global TPcolor
#    set newgr [creategradient .c]
#    .c itemconfigure $TPcolor(id) -fill $newgr
    destroy .tpgradient;
    unset Gradient
    unset TPcolor
}

proc gradientcan {} {
    global Gradient
    global TPcolor
#    catch {    .tpgradient.frameFirst.canvas18 gradient delete $Gradient(newgr)}
    if {$TPcolor(gradlast) != ""} {
	.c gradient delete $TPcolor(gradlast)
    }
    set newgr [creategradient .c]
    set TPcolor(gradlast) $newgr
#    set Gradient(newgr) $newgr
    foreach id $TPcolor(svggroup) {
	.c itemconfigure $id -fill $newgr
    }
#    destroy .tpgradient;
#    unset Gradient
#    unset TPcolor
}

proc cancelgradient {} {
    global Gradient
    global TPcolor
#puts "cancelgradient: Cancel"
    foreach id $TPcolor(svggroup) {
	eval $TPcolor($id,cancel)
    }
#    eval $TPcolor(cancel)
    destroy .tpgradient;
    unset Gradient
    unset TPcolor
}

proc deletestop {w} {
    global Gradient
    global TPcolor
#    puts "Delete last stop";
    if {$Gradient(i) < 3} {
	return
    }
    set i $Gradient(i)
    incr i -1
    unset Gradient(offset$i)
    destroy $w.frame$i
    unset Gradient(color$i)
    unset Gradient(opacity$i)
    set Gradient(i) $i
    incr i -1
    $w.frame$i.spinbox1 configure -to 1.0
    updategradient
    gradientcan
}


proc settransition {} {
    global Gradient
    if {$Gradient(type) == "linear"} {
	pack forget .tpgradient.frameFirst.frame0.frame4
	pack forget .tpgradient.frameFirst.frame0.fbboxr
	if {$Gradient(unitssel) == 1} {
	    pack forget .tpgradient.frameFirst.frame0.fbboxl
	    pack .tpgradient.frameFirst.frame0.frame3 -anchor n -expand 1 -fill x -ipadx 0 -ipady 0 -pady 0 -side top
	    pack .tpgradient.frameFirst.frame0.label1 .tpgradient.frameFirst.frame0.frame2 .tpgradient.frameFirst.frame0.frame3 .tpgradient.frameFirst.frame0.label5 -in .tpgradient.frameFirst.frame0
	} else {
	    pack forget .tpgradient.frameFirst.frame0.frame3
	    pack .tpgradient.frameFirst.frame0.fbboxl -anchor n -expand 1 -fill x -ipadx 0 -ipady 0 -pady 0 -side top
	    pack .tpgradient.frameFirst.frame0.label1 .tpgradient.frameFirst.frame0.frame2 .tpgradient.frameFirst.frame0.fbboxl .tpgradient.frameFirst.frame0.label5 -in .tpgradient.frameFirst.frame0
	}
    } else {
	pack forget .tpgradient.frameFirst.frame0.fbboxl
	pack forget .tpgradient.frameFirst.frame0.frame3
	if {$Gradient(unitssel) == 1} {
	    pack forget .tpgradient.frameFirst.frame0.fbboxr
	    pack .tpgradient.frameFirst.frame0.frame4 -anchor n -expand 1 -fill x -ipadx 0 -ipady 0 -pady 0 -side top
	    pack .tpgradient.frameFirst.frame0.label1 .tpgradient.frameFirst.frame0.frame2 .tpgradient.frameFirst.frame0.frame4 .tpgradient.frameFirst.frame0.label5 -in .tpgradient.frameFirst.frame0
	} else {
	    pack forget .tpgradient.frameFirst.frame0.frame4
	    pack .tpgradient.frameFirst.frame0.fbboxr -anchor n -expand 1 -fill x -ipadx 0 -ipady 0 -pady 0 -side top
	    pack .tpgradient.frameFirst.frame0.label1 .tpgradient.frameFirst.frame0.frame2 .tpgradient.frameFirst.frame0.fbboxr .tpgradient.frameFirst.frame0.label5 -in .tpgradient.frameFirst.frame0
	}
    }
}
proc setuserspace {} {
    global Gradient
    if {$Gradient(unitssel) == 1} {
	set Gradient(units) "userspace"
    } else {
	set Gradient(units) "bbox"
    }
    settransition
}

proc createstop {wfr i} {
    global Gradient
#puts "createstop: wfr=$wfr i=$i"
    frame $wfr.frame$i -borderwidth {2} -relief {flat} -height {30} -width {30} -background {#d6d2d0}
    if {![info exists  Gradient(color$i)]} {
	set Gradient(color$i) skyblue
	set Gradient(offset$i) 1.0
	set Gradient(opacity$i) 1.0
    }

    set w $wfr.frame$i
    eval [subst "button $w.button1 -activebackground {#d6d2d0} -background {#d6d2d0} -command {TP_selcolorgr $w.button1 $i} -padx {2} -pady {0} -width {4} -bg  $Gradient(color$i)"]

    pack $w.button1 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 4 -pady 0 -side left

    label $w.label1 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -padx {0} -pady {0} -text {Offset:}

    pack $w.label1 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left

    label $w.label2 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -padx {0} -pady {0} -relief {flat} -text {Color:}

    pack $w.label2 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left

    label $w.label3 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -relief {flat} -text {Opacity:}

    pack $w.label3 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left

    eval [subst "label $w.label4 -background {#d6d2d0} -borderwidth {0} -foreground {#221f1e} -padx {0} -pady {0} -text {Stop $i:}"]

    pack $w.label4 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 5 -pady 0 -side left
    if {$i == 0} {
	set j 0
	set min 0
    } else {
	set j [expr {$i - 1}]
	set min $Gradient(offset$j)
    }
    if {$i < [expr {$Gradient(i) - 1}]} {
	set l [expr {$i + 1}]
	set max $Gradient(offset$l)
    } else {
	set max 1.0
    }
#puts "lll Gradient(offset$l)=$Gradient(offset$l) j=$j j_gr=$Gradient(offset$j)"
    eval [subst "spinbox $w.spinbox1 -background {white} -textvariable Gradient(offset$i) -from $min  -increment {0.1} -to $max  -width {3} -command {changestops .tpgradient.frameFirst.canvas18 $i $wfr.frame}"]

    pack $w.spinbox1 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 4 -pady 0 -side left
    eval [subst "spinbox $w.spinbox2 -background {white} -textvariable Gradient(opacity$i) -borderwidth {0} -buttonbackground {#d6d2d0} -foreground {#221f1e} -highlightthickness {0} -increment {0.1} -to {1.0} -width {3} -command {changestops .tpgradient.frameFirst.canvas18}"]

    pack $w.spinbox2 -anchor center -expand 0 -fill none -ipadx 0 -ipady 0 -padx 0 -pady 0 -side left

    pack $w.label4 $w.label1 $w.spinbox1 $w.label2 $w.button1 $w.label3 $w.spinbox2 -in $w

    pack $w -anchor center -expand 0 -fill x -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top
#puts "createstop: i=$i Gradient(i)=$Gradient(i)"
    if {$i >= $Gradient(i)} {
	incr Gradient(i)
    }
    gradientcan
}
proc creategradient {can} {
    global Gradient
    if {$Gradient(type) == "linear"} {
	set tran " -lineartransition \{$Gradient(x0) $Gradient(y0) $Gradient(x1) $Gradient(y1)\} "
    } else {
	set tran " -radialtransition \{$Gradient(cx) $Gradient(cy) $Gradient(r) $Gradient(fx) $Gradient(fy)\} "
    }
    set cmd "$can gradient create $Gradient(type) $tran -units $Gradient(units) -stops \{"
# -units userspace
    set i 0
    for {set i 0} {$i < $Gradient(i)} {incr i} {
	append cmd " \{ $Gradient(offset$i) $Gradient(color$i) $Gradient(opacity$i)\}"
    }
    append cmd "\}"
#puts "creategradient can=$can: cmd=$cmd"
    return [eval $cmd]
}
proc changetransition {can} {
    global Gradient
    if {$Gradient(type) == "linear"} {
	set tran " -lineartransition \{$Gradient(x0) $Gradient(y0) $Gradient(x1) $Gradient(y1)\} "
    } else {
	set tran " -radialtransition \{$Gradient(cx) $Gradient(cy) $Gradient(r) $Gradient(fx) $Gradient(fy)\} "
    }
    set cmd "$can gradient configure $Gradient(newgr) $tran"
    eval $cmd
    gradientcan
}
proc changestops {can {ind -1} {w ""} } {
    global Gradient
    set cmd "$can gradient configure $Gradient(newgr)  -stops \{"
    set i 0
    for {set i 0} {$i < $Gradient(i)} {incr i} {
	append cmd " \{ $Gradient(offset$i) $Gradient(color$i) $Gradient(opacity$i)\}"
    }
    append cmd "\}"
    eval $cmd
    if {$ind > -1} {
	set i [expr {$ind - 1}]
	if {$i >= 0} {
	    $w$i.spinbox1 configure -to $Gradient(offset$ind)
	}
	set i [expr {$ind + 1}]
	if {$i < $Gradient(i)} {
	    $w$i.spinbox1 configure -from $Gradient(offset$ind)
	}
    }
    gradientcan
}

proc parsegradient {can grad} {
    array set Gradient []
    set Gradient(type) [$can gradient type $grad]
    set Gradient(units) [$can gradient cget $grad -units]
    if {$Gradient(type) == "linear"} {
	foreach {Gradient(x0) Gradient(y0) Gradient(x1) Gradient(y1)} [$can gradient cget $grad -lineartransition] {break}
    } else {
	foreach {Gradient(cx) Gradient(cy) Gradient(r) Gradient(fx) Gradient(fy)} [$can gradient cget $grad -radialtransition] {break}
    }
    set i 0
    foreach stop [$can gradient cget $grad -stops] {
	foreach {offset color opacity} $stop {
	    set Gradient(offset$i) $offset
	    set Gradient(color$i) $color
	    set Gradient(opacity$i) $opacity
	}
	incr i
    }
    if {$Gradient(units) == "bbox"} {
	set Gradient(unitssel) 0
    } else {
	set Gradient(unitssel) 1
    }
    set Gradient(i) $i

    return [array get Gradient]
}

#ShowWindow.tpgradient