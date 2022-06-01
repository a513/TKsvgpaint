# -----------------------------------------------------------------------------
# screenshot.tcl ---
# -----------------------------------------------------------------------------
# (c) 2018, Johann Oberdorfer - Engineering Support | CAD | Software
#     johann.oberdorfer [at] gmail.com
#     www.johann-oberdorfer.eu
# -----------------------------------------------------------------------------
# This source file is distributed under the BSD license.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#   See the BSD License for more details.
# -----------------------------------------------------------------------------
# Purpose:
#   A TclOO class which implements a convinient way to create a screen shot.
#   The screenshot not only works "internally" for tk widgets such as for
#   example the [image create photo -format window -data $mywidget] command,
#   but for any  portion of the display.
# Implementation:
#   The screen picture is captured with the "loupe" utility function
#   included in the treectrl (binary) package. To save the image to various
#   image file formats, the Img package is also required.
#
#   Code can be used nearly "stand alone" but might be usefull for
#   some other application, e.g. like a note taken application, etc...
# -----------------------------------------------------------------------------
# TclOO naming conventions:
#   public methods  - starts with lower case declaration names, whereas
#   private methods - starts with uppercase naming, so we use CamelCase ...
# -----------------------------------------------------------------------------
#
# Credits:
#   This code is based on and influenced by the
#   "ruler widget and screenruler dialog" originally written by Jeffrey Hobbs.
#   The aformentioned code is avaliable in tklib.
# -----------------------------------------------------------------------------
# Revision history:
#   18-01-04: J.Oberdorfer, Initial release
#   18-04-15: Johann, V0.2, ResizeHandler added
#   18-09-24: Johann, -screenshotcancelcommand added
#   20-11-03: Johann, fixed a small linux bug
#                    - thanks t the feedback of "apIsimple"
#	on: https://wiki.tcl-lang.org/page/A+Screenshot+Widget+implemented+with+TclOO?V=8
#                    KeyPress-Return binding added, thank's to Weiwu Zhang for
#                    his suggestion
#
#   XX-XX-XX: Comments and improvements whatsover are very welcome.
# -----------------------------------------------------------------------------

package require Tk
package require TclOO
package require treectrl
package require Img

package provide screenshot 0.2

namespace eval ::screenshot {
	
	namespace export screenshot

	# -- resizeHandle
	# --------------------------------------------------------------------
	# http://wiki.tcl.tk/3350, Thanks to:
	# George Peter Staplin: A resize handle is that funky thing usually
	# on the bottom right of a window that you can use to resize a window.
	# --------------------------------------------------------------------

	image create bitmap resizeHandle:image -data {
		#define resizeHandle_width 25
		#define resizeHandle_height 25
		static unsigned char resizeHandle_bits[] = {
			0x40, 0x10, 0x04, 0x01, 0x20, 0x08, 0x82, 0x00, 0x10, 0x04, 0x41, 0x00,
			0x08, 0x82, 0x20, 0x00, 0x04, 0x41, 0x10, 0x00, 0x82, 0x20, 0x08, 0x00,
			0x41, 0x10, 0x04, 0x01, 0x20, 0x08, 0x82, 0x00, 0x10, 0x04, 0x41, 0x00,
			0x08, 0x82, 0x20, 0x00, 0x04, 0x41, 0x10, 0x00, 0x82, 0x20, 0x08, 0x00,
			0x41, 0x10, 0x04, 0x01, 0x20, 0x08, 0x82, 0x00, 0x10, 0x04, 0x41, 0x00,
			0x08, 0x82, 0x20, 0x00, 0x04, 0x41, 0x10, 0x00, 0x82, 0x20, 0x08, 0x00,
			0x41, 0x10, 0x04, 0x01, 0x20, 0x08, 0x82, 0x00, 0x10, 0x04, 0x41, 0x00,
			0x08, 0x82, 0x20, 0x00, 0x04, 0x41, 0x10, 0x00, 0x82, 0x20, 0x08, 0x00,
			0x41, 0x10, 0x04, 0x00};
	}
	
	proc Event_ButtonPress1 {win resizeWin X Y} {
		upvar #0 _resizeHandle$win ar
		set ar(startX) $X
		set ar(startY) $Y
		set ar(minWidth) [image width resizeHandle:image]
		set ar(minHeight) [image height resizeHandle:image]
		set ar(resizeWinX) [winfo x $resizeWin]
		set ar(resizeWinY) [winfo y $resizeWin]
	}
	
	proc Event_B1Motion {win resizeWin internal X Y} {
		upvar #0 _resizeHandle$win ar
		
		set xDiff [expr {$X - $ar(startX)}]
		set yDiff [expr {$Y - $ar(startY)}]
		
		set oldWidth [winfo width $resizeWin]
		set oldHeight [winfo height $resizeWin]
		
		set newWidth [expr {$oldWidth + $xDiff}]
		set newHeight [expr {$oldHeight + $yDiff}]
		
		if {$newWidth < $ar(minWidth) || $newHeight < $ar(minHeight)} {
			return
		}
		
		if {$internal == 0} {
			set newX "+$ar(resizeWinX)"
			set newY "+$ar(resizeWinY)"
			
			wm geometry $resizeWin ${newWidth}x${newHeight}${newX}${newY}
		} else {
			place $resizeWin -width $newWidth -height $newHeight -x $ar(resizeWinX) -y $ar(resizeWinY)
		}
		
		set ar(startX) $X
		set ar(startY) $Y
	}
	
	proc Event_Destroy {win} {
		upvar #0 _resizeHandle$win ar
		# catch because this may not be set
		catch {array unset ar}
	}
	
	proc resizeHandle {win resizeWin args} {
		eval label [concat $win $args -image resizeHandle:image]
		
		bind $win <ButtonPress-1> "[namespace current]::Event_ButtonPress1 $win $resizeWin %X %Y"
		bind $win <B1-Motion> "[namespace current]::Event_B1Motion $win $resizeWin 0 %X %Y"
		bind $win <Destroy> "[namespace current]::Event_Destroy $win"
		return $win
	}

	# --------------------------------------------------------------------
	# --------------------------------------------------------------------
	
	# this is a tk-like wrapper around the class,
	# so that object creation works like other Tk widgets
	
	proc screenshot {path args} {
		set obj [ScreenShot create tmp $path {*}$args]
		rename $obj ::$path
		return $path
	}
	
	# a canvas based object
	oo::class create ScreenShot {
		
		constructor {path args} {
			my variable wcanvas
			my variable woptions
			my variable width
			my variable height
			my variable measure
			my variable shade

			my variable edge
			my variable drag
			my variable curdim
			
			my variable timeout
			my variable timeout_max
			my variable timeout_incr
			
			set timeout 0
			set timeout_max 16
			set timeout_incr 2
			
			array set woptions {
				-foreground	black
				-background LightYellow
				-font {Helvetica 14}
				-interval {10 50 100}
				-sizes {4 8 12}
				-showvalues	1
				-outline 1
				-grid 1
				-measure pixels
				-zoom 1
				-showgeometry 1
				-alpha 0.7
				-topmost 1
				-screenshotcommand ""
				-screenshotcancelcommand ""
			}
			
			array set shade {
				small gray medium gray large gray
			}
			
			array set measure {
				what ""
				valid {pixels points inches mm cm}
				cm c mm m inches i points p pixels ""
			}
			
			set width 0
			set height 0

			array set edge {
				at 0
				left   1
				right  2
				top    3
				bottom 4
			}

			array set drag {}
			array set curdim {x 0 y 0 w 0 h 0}
			
			# --------------------------------
			ttk::frame $path -class ScreenShot
			# --------------------------------

			# for the screenshot window, depending on the os-spcific window manager,
			# we'd like to have a semi-transparent window, which is on the very top of
			# all the windows stack and which is borderless (wm overrideredirect ...)
			#
			set t [winfo toplevel $path]
			
			# bug fix for linux:
			if { $::tcl_platform(os) == "Linux" } {
				wm withdraw $t
			}

			catch {
				wm attributes $t -topmost 1
				wm overrideredirect $t 1
			}

			pack [frame $path.f] -side bottom -anchor e
			pack [::screenshot::resizeHandle $path.f.label $t] -side left
			
			canvas $path.c \
				-width 800 -height 600 -relief flat -bd 0 \
				-background white -highlightthickness 0

			set wcanvas $path.c
			pack $wcanvas -fill both -expand true
			
			bind $wcanvas <Configure>     "[namespace code {my Resize}] %W %w %h"
			bind $wcanvas <ButtonPress-1> "[namespace code {my DragStart}] %W %X %Y"
			bind $wcanvas <B1-Motion>     "[namespace code {my PerformDrag}] %W %X %Y"
			bind $wcanvas <Motion>        "[namespace code {my EdgeCheck}] %W %x %y"

			bind $wcanvas <Double-ButtonPress-1> "[namespace code {my ScreenShotCmd}]"
			bind $wcanvas <KeyPress-Return> "[namespace code {my ScreenShotCmd}]"

			focus -force $wcanvas
		
			my AddMenu $wcanvas
			
			# $wcanvas xview moveto 0 ;	$wcanvas yview moveto 0
			
			# we must rename the widget command
			# since it clashes with the object being created
			
			set widget ${path}_
			rename $path $widget
	
			# start with default configuration
			foreach opt_name [array names woptions] {
				my configure $opt_name $woptions($opt_name)
			}

			
			# and configure custom arguments
			my configure {*}$args
			# bug fix for linux:
			if { $::tcl_platform(os) == "Linux" } {
				after 10 "wm deiconify $t; wm attributes $t -alpha $woptions(-alpha)"
#				after 10 "wm deiconify $t; wm attributes $t -alpha \"1.0\""
			}
#LISSI
			wm withdraw $t

		}
		
		destructor {
			set w [namespace tail [self]]
			catch {bind $w <Destroy> {}}
			catch {destroy $w}
		}
		
		method cget { {opt "" }  } {
			my variable wcanvas
			my variable woptions
			
			if { [string length $opt] == 0 } {
				return [array get woptions]
			}
			if { [info exists woptions($opt) ] } {
				return $woptions($opt)
			}
			return [$wcanvas cget $opt]
		}
		
		method configure { args } {
			my variable wcanvas
			my variable woptions
			my variable measure
			my variable curdim

			if {[llength $args] == 0}  {
				
				# return all canvas options
				set opt_list [$wcanvas configure]
				
				# as well as all custom options
				foreach xopt [array get woptions] {
					lappend opt_list $xopt
				}
				return $opt_list
				
			} elseif {[llength $args] == 1}  {
				
				# return configuration value for this option
				set opt $args
				if { [info exists woptions($opt) ] } {
					return $woptions($opt)
				}
				return [$wcanvas cget $opt]
			}
			
			# error checking
			if {[expr {[llength $args]%2}] == 1}  {
				return -code error "value for \"[lindex $args end]\" missing"
			}
			
			# overwrite with new value and
			# process all configuration options...
			#
			array set opts $args
			
			foreach opt_name [array names opts] {
				set opt_value $opts($opt_name)

				# overwrite with new value
				if { [info exists woptions($opt_name)] } {
					set woptions($opt_name) $opt_value
				}
				
				# some options need action from the widgets side
				switch -- $opt_name {
					-font {}
					-sizes - -showvalues - -outline - -grid - -zoom {
						my Redraw
					}
					-foreground {
						my ReShade
						my Redraw
					}
					-measure {
						if {[set idx [lsearch -glob $measure(valid) $opt_value*]] == -1} {
							return -code error "invalid $option value \"$value\":\
									must be one of [join $measure(valid) {, }]"
						}
						set value [lindex $measure(valid) $idx]
						set measure(what) $measure($value)
						set woptions(-measure) $value
						my Redraw
					}
					-interval {
						set dir 1
						set newint {}
						foreach i $woptions(-interval) {
							if {$dir < 0} {
								lappend newint [expr {$i/2.0}]
							} else {
								lappend newint [expr {$i*2.0}]
							}
						}
						set woptions(-interval) $newint
						my Redraw
					}
					-showgeometry {
						if {![string is boolean -strict $opt_value]} {
							return -code error "invalid $option value \"$opt_value\":\
								must be a valid boolean"
						}

						$wcanvas delete geoinfo

						if {$opt_value} {
							set x 20
							set y 20
							foreach d {x y w h} {

								set w $wcanvas._$d
								catch { destroy $w }

								entry $w -borderwidth 1 -highlightthickness 1 -width 4 \
									-textvar [namespace current]::curdim($d) \
									-bg White

								$wcanvas create window $x $y -window $w -tags geoinfo
								
								bind $w <Return> "[namespace code {my PlaceCmd}]"

								# avoid toplevel bindings
								bindtags $w [list $w Entry all]
								incr x [winfo reqwidth $w]
							}
						}
					}
					-alpha {
						wm attributes [winfo toplevel $wcanvas] -alpha $opt_value
					}
					-topmost {
						wm attributes [winfo toplevel $wcanvas] -topmost $opt_value
					}
					-geometry {
						wm geometry [winfo toplevel $wcanvas] $opt_value
					}
					-screenshotcommand {
						set woptions(-screenshotcommand) $opt_value
					}
					-screenshotcancelcommand {
						set woptions(-screenshotcancelcommand) $opt_value
					}
					default {
						# if the configure option wasn't one of our special one's,
						# pass control over to the original canvas widget
						#
						if {[catch {$wcanvas configure $opt_name $opt_value} result]} {
							return -code error $result
						}
					}
				}
			}
		}

		method display {} {
			my variable wcanvas
			set win [winfo toplevel $wcanvas]
			wm deiconify $win
			raise $win
			focus $win
		}

		method hide {} {
			my variable wcanvas
			set win [winfo toplevel $wcanvas]
			wm withdraw $win
			
			# wait a bit so that the pop-up menu
			# has time to disappear...
			# ----------------------------------
			after 400 {set ::_wait_flag 1}
			vwait ::_wait_flag
			# ----------------------------------
		}

		method unknown {method args} {
			my variable wcanvas
			
			# if the command wasn't one of our special one's,
			# pass control over to the original canvas widget
			#
			if {[catch {$wcanvas $method {*}$args} result]} {
				return -code error $result
			}
			return $result
		}
	
		method getgeometry {} {
			my variable curdim
			return [list $curdim(x) $curdim(y) $curdim(w) $curdim(h)]
		}
	
		method PlaceCmd {} {
			my variable wcanvas
			my variable curdim

			set win [winfo toplevel $wcanvas]
			wm geometry $win $curdim(w)x$curdim(h)+$curdim(x)+$curdim(y)
		}
		

		method ReShade {} {
			my variable wcanvas
			my variable woptions
			my variable shade
			
			set bg [$wcanvas cget -bg]
			set fg $woptions(-foreground)
			set shade(small)  [my Shade $bg $fg 0.15]
			set shade(medium) [my Shade $bg $fg 0.4]
			set shade(large)  [my Shade $bg $fg 0.8]
		}
		
		method Redraw {} {
			my variable wcanvas
			my variable woptions
			my variable width
			my variable height
			my variable measure
			
			$wcanvas delete ruler
			
			set width  [winfo width $wcanvas]
			set height [winfo height $wcanvas]
			
			my Redraw_x
			my Redraw_y
			
			if {$woptions(-outline) || $woptions(-grid)} {
				
				if {[tk windowingsystem] eq "aqua"} {
					# Aqua has an odd off-by-one drawing
					set coords [list 0 0 $width $height]
				} else {
					set coords [list 0 0 [expr {$width-1}] [expr {$height-1}]]
				}
				$wcanvas create rect $coords \
						-width 1 \
						-outline $woptions(-foreground) \
						-tags [list ruler outline]
			}
			
			if {$woptions(-showvalues) && $height > 20} {
				
				if {$measure(what) ne ""} {
					set m   [winfo fpixels $wcanvas 1$measure(what)]
					set txt "[format %.2f [expr {$width / $m}]] x\
							[format %.2f [expr {$height / $m}]] $woptions(-measure)"
				} else {
					set txt "$width x $height"
				}
				if {$woptions(-zoom) > 1} {
					append txt " (x$woptions(-zoom))"
				}
				$wcanvas create text 15 [expr {$height/2.}] \
						-text $txt \
						-anchor w -tags [list ruler value label] \
						-fill $woptions(-foreground)
			}
			$wcanvas raise large
			$wcanvas raise value
		}
		
		method Redraw_x {} {
			my variable wcanvas
			my variable woptions
			my variable width
			my variable height
			my variable measure
			my variable shade
			
			foreach {sms meds lgs} $woptions(-sizes) { break }
			foreach {smi medi lgi} $woptions(-interval) { break }
			for {set x 0} {$x < $width} {set x [expr {$x + $smi}]} {
				set dx [winfo fpixels $wcanvas \
						[expr {$x * $woptions(-zoom)}]$measure(what)]
				if {fmod($x, $lgi) == 0.0} {
					# draw large tick
					set h $lgs
					set tags [list ruler tick large]
					if {$x && $woptions(-showvalues) && $height > $lgs} {
						$wcanvas create text [expr {$dx+1}] $h -anchor nw \
								-text [format %g $x]$measure(what) \
								-tags [list ruler value]
					}
					set fill $shade(large)
				} elseif {fmod($x, $medi) == 0.0} {
					set h $meds
					set tags [list ruler tick medium]
					set fill $shade(medium)
				} else {
					set h $sms
					set tags [list ruler tick small]
					set fill $shade(small)
				}
				if {$woptions(-grid)} {
					$wcanvas create line $dx 0 $dx $height -width 1 -tags $tags \
							-fill $fill
				} else {
					$wcanvas create line $dx 0 $dx $h -width 1 -tags $tags \
							-fill $woptions(-foreground)
					$wcanvas create line $dx $height $dx [expr {$height - $h}] \
							-width 1 -tags $tags -fill $woptions(-foreground)
				}
			}
		}
		
		method Redraw_y {} {
			my variable wcanvas
			my variable woptions
			my variable width
			my variable height
			my variable measure
			my variable shade
			
			foreach {sms meds lgs} $woptions(-sizes) { break }
			foreach {smi medi lgi} $woptions(-interval) { break }
			for {set y 0} {$y < $height} {set y [expr {$y + $smi}]} {
				set dy [winfo fpixels $wcanvas \
						[expr {$y * $woptions(-zoom)}]$measure(what)]
				if {fmod($y, $lgi) == 0.0} {
					# draw large tick
					set w $lgs
					set tags [list ruler tick large]
					if {$y && $woptions(-showvalues) && $width > $lgs} {
						$wcanvas create text $w [expr {$dy+1}] -anchor nw \
								-text [format %g $y]$measure(what) \
								-tags [list ruler value]
					}
					set fill $shade(large)
				} elseif {fmod($y, $medi) == 0.0} {
					set w $meds
					set tags [list ruler tick medium]
					set fill $shade(medium)
				} else {
					set w $sms
					set tags [list ruler tick small]
					set fill $shade(small)
				}
				if {$woptions(-grid)} {
					$wcanvas create line 0 $dy $width $dy -width 1 -tags $tags \
							-fill $fill
				} else {
					$wcanvas create line 0 $dy $w $dy -width 1 -tags $tags \
							-fill $woptions(-foreground)
					$wcanvas create line $width $dy [expr {$width - $w}] $dy \
							-width 1 -tags $tags -fill $woptions(-foreground)
				}
			}
		}
		
		method Resize {W w h} {
			my variable wcanvas
			my variable curdim
			
			set curdim(w) $w
			set curdim(h) $h
			
			my Redraw
		}
		
		method Shade {orig dest frac} {
			my variable wcanvas
			
			if {$frac >= 1.0} {return $dest} elseif {$frac <= 0.0} {return $orig}
			foreach {oR oG oB} [winfo rgb $wcanvas $orig] \
					{dR dG dB} [winfo rgb $wcanvas $dest] {
						set color [format "\#%02x%02x%02x" \
						[expr {int($oR+double($dR-$oR)*$frac)}] \
						[expr {int($oG+double($dG-$oG)*$frac)}] \
						[expr {int($oB+double($dB-$oB)*$frac)}]]
						return $color
					}
		}
		
		method EdgeCheck {w x y} {
			my variable edge
			
			set CHKWIDTH 8
			set edge(at) 0

			set cursor ""
			if {$x < $CHKWIDTH || $x > ([winfo width $w] - $CHKWIDTH)} {
				set cursor sb_h_double_arrow
				set edge(at) [expr {$x < $CHKWIDTH ? $edge(left) : $edge(right)}]
			} elseif {$y < $CHKWIDTH || $y > ([winfo height $w] - $CHKWIDTH)} {
				set cursor sb_v_double_arrow
				set edge(at) [expr {$y < $CHKWIDTH ? $edge(top) : $edge(bottom)}]
			}
			$w configure -cursor $cursor
		}
		
		method DragStart {w X Y} {
			my variable drag
		
			set drag(X) [expr {$X - [winfo rootx $w]}]
			set drag(Y) [expr {$Y - [winfo rooty $w]}]
			set drag(w) [winfo width $w]
			set drag(h) [winfo height $w]
			my EdgeCheck $w $drag(X) $drag(Y)
			
			raise $w
			focus $w
		}
		
		method PerformDrag {w X Y} {
			my variable edge
			my variable drag
			my variable curdim
			
			set curdim(x) [winfo rootx $w]
			set curdim(y) [winfo rooty $w]
			
			set win [winfo toplevel $w]
			
			if {$edge(at) == 0} {
				set dx [expr {$X - $drag(X)}]
				set dy [expr {$Y - $drag(Y)}]
				wm geometry $win +$dx+$dy
			} elseif {$edge(at) == $edge(left)} {
				# need to handle moving root - currently just moves
				set dx [expr {$X - $drag(X)}]
				set dy [expr {$Y - $drag(Y)}]
				wm geometry $win +$dx+$dy
			} elseif {$edge(at) == $edge(right)} {
				set relx   [expr {$X - [winfo rootx $win]}]
				set width  [expr {$relx - $drag(X) + $drag(w)}]
				set height $drag(h)
				if {$width > 5} {
					wm geometry $win ${width}x${height}
				}
			} elseif {$edge(at) == $edge(top)} {
				# need to handle moving root - currently just moves
				set dx [expr {$X - $drag(X)}]
				set dy [expr {$Y - $drag(Y)}]
				wm geometry $win +$dx+$dy
			} elseif {$edge(at) == $edge(bottom)} {
				set rely   [expr {$Y - [winfo rooty $win]}]
				set width  $drag(w)
				set height [expr {$rely - $drag(Y) + $drag(h)}]
				if {$height > 5} {
					wm geometry $win ${width}x${height}
				}
			}
		}

		# allows to add additional menu entries once the screenshot widget
		# has been initialized 
		method getmenuwidget {} {
			my variable wmenu
			return $wmenu
		}
		
		method AddMenu {wcanvas} {
			my variable woptions
			my variable timeout
			my variable timeout_max
			my variable wmenu
		
			if {[tk windowingsystem] eq "aqua"} {
				set CTRL    "Command-"
				set CONTROL Command
			} else {
				set CTRL    CTRL+
				set CONTROL Control
			}
		
			set m $wcanvas.menu
			
			menu $m -tearoff 1

			set m0 [menu $m.extras -tearoff 0]
			set wmenu $m0

			if {[tk windowingsystem] ne "x11"} {
				$m add checkbutton -label "Keep on Top" \
					-underline 8 -accelerator "t" \
					-variable [namespace current]::woptions(-topmost) \
					-command "[namespace code {my configure}] -topmost $[namespace current]::woptions(-topmost)"
			
				bind $wcanvas <Key-t> [list $m invoke "Keep on Top"]
			}

			$m add checkbutton -label "Show Grid" \
				-accelerator "g" -underline 5 \
				-variable [namespace current]::woptions(-grid) \
				-command "[namespace code {my configure}] -grid $[namespace current]::woptions(-grid)"

			bind $wcanvas <Key-g> [list $m invoke "Show Grid"]
		
			set m1 [menu $m.opacity -tearoff 0]
			$m add cascade -label "Opacity" -menu $m1 -underline 0
			for {set i 10} {$i <= 100} {incr i 10} {
				set aval [expr {$i/100.}]
				$m1 add radiobutton -label "${i}%" \
					-variable [namespace current]::woptions(-alpha) \
					-value $aval \
					-command "[namespace code {my configure}] -alpha $[namespace current]::woptions(-alpha)"
			}

			$m add separator

			$m add command \
				-label "Screenshot now" \
				-accelerator ${CTRL}s \
				-underline 7 \
				-command "[namespace code {my ScreenShotCmd}]" \
				-background $woptions(-background)

			set m2 [menu $m.timeout -tearoff 0]
			$m add cascade -label "Screenshot with Timeout..." -menu $m2 -underline 0
			for {set i 0} {$i <= $timeout_max} {incr i 4} {
				$m2 add radiobutton -label "${i} sec" \
					-variable [namespace current]::timeout \
					-value $i \
					-command "[namespace code {my ScreenShotCmd}]"
			}
				
			$m add separator
			$m add command \
				-label "Close Window" \
				-accelerator "ESC" \
				-command "[namespace code {my hide}]"
#LISSI
#				-command "[namespace code {my ExitCmd}]"

			bind $wcanvas <Escape> "[namespace code {my ExitCmd}]"
			bind $wcanvas <Double-ButtonPress-1> "[namespace code {my ScreenShotCmd}]"

			# menu invoke can also be used,
			# make sure that the invoke command gets exactly the label string
			#
			bind $wcanvas <$CONTROL-s> [list $m invoke "Screenshot now..."]			

			if {[tk windowingsystem] eq "aqua"} {
				# aqua switches 2 and 3 ...
				bind $wcanvas <Control-ButtonPress-1> [list tk_popup $m %X %Y]
				bind $wcanvas <ButtonPress-2> [list tk_popup $m %X %Y]
			} else {
				bind $wcanvas <ButtonPress-3> [list tk_popup $m %X %Y]
			}
		
		}
		
		# wait a few msec's ...
		method Wait {msec} {
			set ::wait 0; after $msec {set ::wait 1}; vwait ::wait					
		}

		method ScreenShotCmd {} {
			my variable woptions
			my variable wcanvas
			my variable curdim
			my variable timeout
			my variable timeout_max
			my variable timeout_incr
			
			# perform screenshot after timeout ? ...
			if {$timeout != 0} {
			
				# add text to the canvas
				set textfont {Helvetica 24}
				set txtitem [$wcanvas create text 50 50 \
								-text "Timeout: ${timeout} sec..." \
								-width 440 -anchor nw -font $textfont -justify left\
								-fill "DarkBlue"]
				$wcanvas addtag text withtag $txtitem
				
				# text animation loop...
				for {set i $timeout} {$i != 0} {incr i [expr {$timeout_incr * -1}]} {
					$wcanvas itemconfigure $txtitem -fill "Orange"
					$wcanvas itemconfigure $txtitem -text "Timeout: ${i} sec..."
					
					my Wait [expr {$timeout_incr * 1000}]
				}
			}

			if { [catch {package require treectrl}] != 0 ||
								[llength [info commands loupe]] == 0 } {
				return -code error "tktreectrl loupe command is not available."
			}

			my hide

			set capture_img [image create photo \
									-width $curdim(w) -height $curdim(h)]
			set zoom 1
			set loupe_ctr_x [expr {$curdim(x) + $curdim(w) / 2}]
			set loupe_ctr_y [expr {$curdim(y) + $curdim(h) / 2}]

			# ----------------------------------------------------------------------------
			# a delay is required, otherwise the image won't get copied
			# ----------------------------------------------------------------------------
			after idle \
				"loupe $capture_img $loupe_ctr_x $loupe_ctr_y $curdim(w) $curdim(h) $zoom"
			set ::_vwait 0; after idle {set ::_vwait 1}; vwait ::_vwait
			# ----------------------------------------------------------------------------

			# -only for development-
			# $wcanvas create image 0 0 -anchor nw -image $capture_img
			# my display
			# puts [$capture_img data -format "png"]
			# $capture_img write "capture_img.png" -format "png"

			# evaluate the given command in parent namespace with
			# the capture image as argument to the function:
			#
			if {$woptions(-screenshotcommand) != ""} {
				uplevel $woptions(-screenshotcommand) $capture_img 
#							[wm geometry [winfo toplevel $wcanvas]] 
#							$woptions(-grid) $woptions(-alpha)
			}
		}
		
		method ExitCmd {} {
			my variable woptions
			my variable wcanvas
			
			set win [winfo toplevel $wcanvas]
			set geometry [wm geometry $win]
			destroy $win

			# evaluate the given command in parent namespace
			#
			if {$woptions(-screenshotcancelcommand) != ""} {
				uplevel $woptions(-screenshotcancelcommand) \
							$geometry $woptions(-grid) $woptions(-alpha)
			}
		}
	}
	
}

