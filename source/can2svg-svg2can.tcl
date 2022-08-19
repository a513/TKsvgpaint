#  tinyfileutils.tcl ---
#  
#      A collection of some small file utility procedures.
#      
#  Copyright (c) 2002-2003  Mats Bengtsson
#  
#  This file is distributed under BSD style license.
#  
# $Id: tinyfileutils.tcl,v 1.11 2008-02-28 07:51:25 matben Exp $

package provide tinyfileutils 1.0


namespace eval ::tfileutils:: {}

# tfileutils::relative --
#
#       Constructs the relative file path from one absolute path to
#       another absolute path.
#
# Arguments:
#       srcpath        An absolute file path.
#	dstpath        An absolute file path.
#       
# Results:
#       The relative (unix-style) path from 'srcpath' to 'dstpath'.

proc ::tfileutils::relative {srcpath dstpath} {
    global  tcl_platform

    if {![string equal [file pathtype $srcpath] "absolute"]} {
	return -code error "::tfileutils::relative: the path \"$srcpath\" is not of type absolute"
    }
    if {![string equal [file pathtype $dstpath] "absolute"]} {
	return -code error "::tfileutils::relative: the path \"$dstpath\" is not of type absolute"
    }

    # Need real path without any file for the source path.
    set srcpath [getdirname $srcpath]
    set up {../}
    set srclist [file split $srcpath]
    set dstlist [file split $dstpath]
    
    # Must get rid of the extra ":" volume specifier on mac.
    if {[string equal $tcl_platform(platform) "macintosh"]} {
	set srclist [lreplace $srclist 0 0  \
	  [string trimright [lindex $srclist 0] :]]
	set dstlist [lreplace $dstlist 0 0  \
	  [string trimright [lindex $dstlist 0] :]]
    }
    set lensrc [llength $srclist]
    set lendst [llength $dstlist]
    set minlen [expr {($lensrc < $lendst) ? $lensrc : $lendst}]

    # Find first nonidentical dir; n = the number of common dirs
    # If there are no common dirs we are left with n = 0???    
    set n 0
    while {[string equal [lindex $srclist $n] [lindex $dstlist $n]] && \
      ($n < $minlen)} {
	incr n
    }
    set numUp [expr {$lensrc - $n}]
    set tmp {}
    for {set i 1} {$i <=$numUp} {incr i} {
	append tmp $up
    }
    return "${tmp}[join [lrange $dstlist $n end] /]"
}

# tfileutils::unixpath --
#
#       Translatates a native path type to a unix style.
#
# Arguments:
#       path        
#       
# Results:
#       The unix-style path of path.

proc ::tfileutils::unixpath {path} {
    global  tcl_platform
    
    set isabs [string equal [file pathtype $path] "absolute"]
    set plist [file split $path]
	
    # The volume specifier always leaves a ":"; {Macintosh HD:}
    if {$isabs && [string equal $tcl_platform(platform) "macintosh"]} {
	set volume [string trimright [lindex $plist 0] ":"]
	set plist [lreplace $plist 0 0 $volume]
    }
    set upath [join $plist /]
    if {$isabs} {
	set upath "/$upath"
    }
    return $upath
}

# Perhaps this could be replaced by [file normalize [file join ...]] ???

# addabsolutepathwithrelative ---
#
#       Adds the second, relative path, to the first, absolute path.
#       Always returns unix style absolute path.
#           
# Arguments:
#       absPath        an absolute path which is the "original" path.
#       toPath         a relative path which should be added.
#       
# Results:
#       The absolute unix style path by adding 'absPath' with 'relPath'.

proc addabsolutepathwithrelative {absPath relPath} {
    global  tcl_platform
    
    set state(debug) 0
    if {$state(debug) >= 3} {
	puts "addabsolutepathwithrelative:: absPath=$absPath, relPath=$relPath"
    }

    # Be sure to strip off any filename of the absPath.
    set absPath [getdirname $absPath]
    if {[file pathtype $absPath] != "absolute"} {
	error "first path must be an absolute path"
    } elseif {[file pathtype $relPath] != "relative"} {
	error "second path must be a relative path"
    }

    # This is the method to reach platform independence.
    # We must be sure that there are no path separators left.    
    set absP {}
    foreach elem [file split $absPath] {
	lappend absP [string trim $elem "/:\\"]
    }
    
    # If any up dir (../ ::  ), find how many. Only unix style.
    set nup [regsub -all {\.\./} $relPath {} newRelPath]
    # Mac???
    #set nup [expr {[regsub -all : $part "" x] - 1}]
   
    # Delete the same number of elements from the end of the absolute path
    # as there are up dirs in the relative path.    
    if {$nup > 0} {
	set iend [expr {[llength $absP] - 1}]
	set upAbsP [lreplace $absP [expr {$iend - $nup + 1}] $iend]
    } else {
	set upAbsP $absP
    }
    set relP {}
    foreach elem [file split $newRelPath] {
	lappend relP [string trim $elem "/:\\"]
    }
    set completePath "$upAbsP $relP"

    # On Windows we need special treatment of the "C:/" type drivers.
    if {[string equal $tcl_platform(platform) "windows"]} {
    	set finalAbsPath   \
	    "[lindex $completePath 0]:/[join [lrange $completePath 1 end] "/"]"
    } else {
        set finalAbsPath "/[join $completePath "/"]"
    }
    return $finalAbsPath
}

# tfileutils::appendfile --
#
#       Adds the second, relative path, to the first, absolute path.
#           
# Arguments:
#       dstFile     the destination file name
#       args        the files to append
#       
# Results:
#       none

proc ::tfileutils::appendfile {dstFile args} {
    
    set dst [open $dstFile {WRONLY APPEND}]
    fconfigure $dst -translation binary
    foreach f $args {
	set src [open $f RDONLY]
	fconfigure $src -translation binary
	fcopy $src $dst
	close $src
    }
    close $dst
}

# tfileutils::tempfile --
#
#   generate a temporary file name suitable for writing to
#   the file name will be unique, writable and will be in the 
#   appropriate system specific temp directory
#   Code taken from http://mini.net/tcl/772 attributed to
#    Igor Volobouev and anon.
#
# Arguments:
#   prefix     - a prefix for the filename, p
# Results:
#   returns a file name
#

proc ::tfileutils::tempfile {tmpdir {prefix {}}} {
    return [file normalize [TempFile $tmpdir $prefix]]
}

proc ::tfileutils::TempFile {tmpdir prefix} {

    set chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    set nrand_chars 10
    set maxtries 10
    set access [list RDWR CREAT EXCL TRUNC]
    set permission 0600
    set channel ""
    set checked_dir_writable 0

    for {set i 0} {$i < $maxtries} {incr i} {
	set newname $prefix
	for {set j 0} {$j < $nrand_chars} {incr j} {
	    append newname [string index $chars \
		    [expr {int(rand()*62)}]]
	}
	set newname [file join $tmpdir $newname]
	if {[file exists $newname]} {
	    after 1
	} else {
	    if {[catch {open $newname $access $permission} channel]} {
		if {!$checked_dir_writable} {
		    set dirname [file dirname $newname]
		    if {![file writable $dirname]} {
			return -code error "Directory $dirname is not writable"
		    }
		    set checked_dir_writable 1
		}
	    } else {
		# Success
		close $channel
		return $newname
	    }
	}
    }
    if {[string compare $channel ""]} {
	return -code error "Failed to open a temporary file: $channel"
    } else {
	return -code error "Failed to find an unused temporary file name"
    }
}

# tfileutils::deleteallfiles --
# 
#       Deletes all files in a directory but keeps the directory.

proc ::tfileutils::deleteallfiles {dir {pattern *}} {
    set files [eval {glob -nocomplain -directory $dir} -- $pattern]
    if {[llength $files]} {
	eval {file delete -force} $files
    }
}

#------------------------------------------------------------------------------


# uriencode.tcl --
#
#	Encoding of uri's and file names. Some code from tcllib.
#     Parts: Copyright (C) 2001 Pat Thoyts <Pat.Thoyts@bigfoot.com>
# 	extend the uri package to deal with URN (RFC 2141)
# 	see http://www.normos.org/ietf/rfc/rfc2141.txt
# 	
# $Id: uriencode.tcl,v 1.5 2008-02-10 09:43:21 matben Exp $

package require uri::urn

package provide uriencode 1.0

namespace eval uriencode {}

# uriencode::quotepath --
# 
#	Need to carefully avoid encoding any / in volume specifiers.
#	/root/...  or C:/disk/...
#       Always return path using unix separators "/"

proc uriencode::quotepath {path} {
    
    set isrel [string equal [file pathtype $path] "relative"]

    if {!$isrel} {
	
	# An absolute path. 
	# Be sure to get rid of unix style "/" and windows "C:/"
  	set plist [file split [string trimleft $path /]]
	set qpath [::uri::urn::quote [string trimright [lindex $plist 0] /]]
	foreach str [lrange $plist 1 end] {
	    lappend qpath [::uri::urn::quote $str]
	}	
    } else {
	
	# A relative path.
	set qpath [list]
	foreach str [file split $path] {
	    lappend qpath [::uri::urn::quote $str]
	}
    }
    
    # Build unix style path
    set qpath [join $qpath /]
    if {!$isrel} {
	set qpath "/$qpath"
    }
    return $qpath
}

proc uriencode::quoteurl {url} {

    # Only the file path part shall be encoded.
    if {![regexp {([^:]+://[^:/]+(:[0-9]+)?)(/.*)} $url  \
	match prepath x path]} {
	return -code error "Is not a valid url: $url"
    }
    set path [string trimleft $path /]
    return "${prepath}/[uriencode::quotepath $path]"
}

proc uriencode::decodefile {file} {
    return [::uri::urn::unquote $file]
}

proc uriencode::decodeurl {url} {
    return [::uri::urn::unquote $url]
}

#-----------------------------------------------------------------------


#  can2svg.tcl ---
#  
#      This file provides translation from canvas commands to XML/SVG format.
#      
#  Copyright (c) 2002-2007  Mats Bengtsson
#  
#  This file is distributed under BSD style license.
#
# $Id: can2svg.tcl,v 1.26 2008-01-27 08:19:36 matben Exp $
# 
# ########################### USAGE ############################################
#
#   NAME
#      can2svg - translate canvas command to SVG.
#      
#   SYNOPSIS
#      can2svg canvasCmd ?options?
#           canvasCmd is everything except the widget path name.
#           
#      can2svg::canvas2file widgetPath fileName ?options?
#           options:   -height
#                      -width
#      
#      can2svg::can2svg canvasCmd ?options?
#           options:    -httpbasedir        path
#                       -imagehandler       tclProc
#                       -ovalasellipse      0|1
#                       -reusedefs          0|1
#                       -uritype            file|http
#                       -usestyleattribute  0|1
#                       -usetags            0|all|first|last
#                       -windowitemhandler  tclProc
#                       
#      can2svg::config ?options?
#           options:        -allownewlines      0
#                        -filtertags         ""
#                        -httpaddr           localhost
#                        -ovalasellipse      0
#                        -reusedefs          1
#                        -uritype            file
#                        -usetags            all
#                        -usestyleattribute  1
#                       -windowitemhandler  tclProc
#
# ########################### CHANGES ##########################################
#
#   0.1      first release
#   0.2      URI encoded image file path
#   0.3      uses xmllists more, added svgasxmllist
#
# ########################### TODO #############################################
# 
#   handle units (m->mm etc.) 
#   better support for stipple patterns
#   how to handle tk editing? DOM?
#   
#   ...

# We need URN encoding for the file path in images. From my whiteboard code.

package require uriencode
package require tinyfileutils

package provide can2svg 0.3


namespace eval can2svg {

    namespace export can2svg canvas2file
    
    variable confopts
    array set confopts {
        -allownewlines        0
        -filtertags           ""
        -httpaddr             localhost
        -ovalasellipse        0
        -reusedefs            0
        -uritype              file
        -usetags              all
        -usestyleattribute    1
        -windowitemhandler    ""
    }
#LISSI ниже оригинал
#        -reusedefs            1


    set confopts(-httpbasedir) [info script]
    
    variable formatArrowMarker
    variable formatArrowMarkerLast
    
    # The key into this array is 'arrowMarkerDef_$col_$a_$b_$c', where
    # col is color, and a, b, c are the arrow's shape.
    variable defsArrowMarkerArr

    # Similarly for stipple patterns.
    variable defsStipplePatternArr

    # This shouldn't be hardcoded!
    variable defaultFont {Helvetica 12}

    variable pi 3.14159265359
    variable anglesToRadians [expr $pi/180.0]
    variable grayStipples {gray75 gray50 gray25 gray12}
        
    # Make 4x4 squares. Perhaps could be improved.
    variable stippleDataArr
    
    set stippleDataArr(gray75)  \
      {M 0 0 h3  M 0 1 h1 M 2 1 h2
       M 0 2 h3  M 0 3 h1 M 2 3 h1}
    set stippleDataArr(gray50)  \
      {M 0 0 h1 M 2 0 h1  M 1 1 h1 M 3 1 h1
       M 0 2 h1 M 2 2 h1  M 1 3 h1 M 3 3 h1}
    set stippleDataArr(gray25)  \
      {M 3 0 h1 M 1 1 h1 M 3 2 h1 M 1 3 h1}
    set stippleDataArr(gray12)  \
      {M 1 1 h1 M 3 3 h1}
    
}

proc can2svg::config {args} {
    variable confopts
    
    set options [lsort [array names confopts -*]]
    set usage [join $options ", "]
    if {[llength $args] == 0} {
        set result {}
        foreach name $options {
            lappend result $name $confopts($name)
        }
        return $result
    }
    regsub -all -- - $options {} options
    set pat ^-([join $options |])$
    if {[llength $args] == 1} {
        set flag [lindex $args 0]
        if {[regexp -- $pat $flag]} {
            return $confopts($flag)
        } else {
            return -code error "Unknown option $flag, must be: $usage"
        }
    } else {
        foreach {flag value} $args {
            if {[regexp -- $pat $flag]} {
                set confopts($flag) $value
            } else {
                return -code error "Unknown option $flag, must be: $usage"
            }
        }
    }
}

# can2svg::can2svg --
#
#       Make xml out of a canvas command, widgetPath removed.
#       
# Arguments:
#       cmd         canvas create commands without prepending widget path.
#       args    -httpbasedir        path
#               -imagehandler       tclProc
#               -ovalasellipse      0|1
#               -reusedefs          0|1
#               -uritype            file|http
#               -usestyleattribute  0|1
#               -usetags            0|all|first|last
#       
# Results:
#   xml data

proc can2svg::can2svg {cmd args} {

    set xml ""
#LISSI
    foreach xmllist [eval {svgasxmllist $cmd} $args] {
        append xml [MakeXML $xmllist]
    }
    return $xml
}

# can2svg::svgasxmllist --
#
#       Make a list of xmllists out of a canvas command, widgetPath removed.
#       
# Arguments:
#       cmd         canvas create command without prepending widget path.
#       args    -httpbasedir        path
#               -imagehandler       tclProc
#               -ovalasellipse      0|1
#               -reusedefs          0|1
#               -uritype            file|http
#               -usestyleattribute  0|1
#               -usetags            0|all|first|last
#       
# Results:
#       a list of xmllist = {tag attrlist isempty cdata {child1 child2 ...}}

proc can2svg::svgasxmllist {cmd args} {
    
    variable confopts
    variable defsArrowMarkerArr
    variable defsStipplePatternArr
    variable defaultFont
    variable grayStipples
        
    set nonum_ {[^0-9]}
    set wsp_ {[ ]+}
    set xmlLL [list]
    
    array set argsA [array get confopts]
    array set argsA $args
    set args [array get argsA]
    
    if {![string equal [lindex $cmd 0] "create"]} {
        return
    }
    
    set type [lindex $cmd 1]
    set rest [lrange $cmd 2 end]
#LISSI
#puts "can2svg::svgasxmllist: START type=$type"
    
    # Separate coords from options.
    set indopt [lsearch -regexp $rest "-${nonum_}"]
    if {$indopt < 0} {
        set ind end
        set opts [list]
    } else {
        set ind [expr $indopt - 1]
        set opts [lrange $rest $indopt end]
    }
    
    # Flatten coordinate list!
    set coo [lrange $rest 0 $ind]
    if {[llength $coo] == 1} {
        set coo [lindex $coo 0]
    }
    array set optA $opts
#LISSI
#puts "can2svg::svgasxmllist: optA"
#parray optA
    
    # Is the item in normal state? If not, return.
    if {[info exists optA(-state)] && $optA(-state) != "normal"} {
#LISSI
puts "can2svg::svgasxmllist: optA(-state) ERROR"
        return
    }
    
    # Figure out if we've got a spline.
    set haveSpline 0
    if {[info exists optA(-smooth)] && ($optA(-smooth) != "0") &&  \
      [info exists optA(-splinesteps)] && ($optA(-splinesteps) > 2)} {
        set haveSpline 1
    }
    if {[info exists optA(-fill)]} {
        set fillValue $optA(-fill)
#LISSI
	if {[filltype $fillValue] == "gradient"} {
#puts "can2svg::svgasxmllist: type==gradient ДЕЛАТЬ ЗДЕСЬ как у Стрелки"
	    set gradientValue $fillValue
	} else {

        if {![regexp {#[0-9]+} $fillValue]} {
            set fillValue [FormatColorName $fillValue]
        }
        }
    } else {
        set fillValue black
    }
    if {[string length $argsA(-filtertags)] && [info exists optA(-tags)]} {
        set tag [uplevel #0 $argsA(-filtertags) [list $optA(-tags)]]
        set idAttr [list id $tag]
    } elseif {($argsA(-usetags) != "0") && [info exists optA(-tags)]} {
        
        # Remove any 'current' tag.
        set optA(-tags) \
          [lsearch -all -not -inline $optA(-tags) current]
        
        switch -- $argsA(-usetags) {
            all {                        
                set idAttr [list id $optA(-tags)]
            }
            first {
                set idAttr [list id [lindex $optA(-tags) 0]]
            }
            last {
                set idAttr [list id [lindex $optA(-tags) end]]
            }
        }
    } else {
        set idAttr ""
    }
    
#LISSI fill - Gradient
    if {[info exists gradientValue]} {
	    set ret [can2svg::MakeGradientDef $gradientValue]
            set xmlLL [concat $xmlLL $ret]
    }    
#LISSI
#puts "can2svg::svgasxmllist: MakeArrowMarker ????? argsA(-reusedefs)=$argsA(-reusedefs)"

    # If we need a marker (arrow head) need to make that first.
    if {[info exists optA(-arrow)] && ![string equal $optA(-arrow) "none"]} {
        if {[info exists optA(-arrowshape)]} {
            
            # Make a key of the arrowshape list into the array.
            regsub -all -- $wsp_ $optA(-arrowshape) _ shapeKey
            set arrowKey ${fillValue}_${shapeKey}
            set arrowShape $optA(-arrowshape)
#LISSI
            set arrowShapeEnd $optA(-arrowshape)
        } else {
            set arrowKey ${fillValue}
            set arrowShape {8 10 3}
            set arrowShapeEnd {8 10 3}
        }
        if {!$argsA(-reusedefs) || \
          ![info exists defsArrowMarkerArr($arrowKey)]} {
#LISSI
#puts "can2svg::svgasxmllist: MakeArrowMarker 1"

            set defsArrowMarkerArr($arrowKey)  \
              [eval {MakeArrowMarker} $arrowShape $arrowShapeEnd {$fillValue}  $optA(-width)]
#              [eval {MakeArrowMarker} $arrowShape {$fillValue}]
            set xmlLL \
              [concat $xmlLL $defsArrowMarkerArr($arrowKey)]
        }
    } elseif {[info exists optA(-startarrow)] && ( $optA(-startarrow) > 0 || $optA(-endarrow) > 0)} {
#LISSI
#parray optA
            set arrowKey [lrange $optA(-stroke) 1 end]
#            set arrowShape {8 10 3}
	    set pq "[expr {int ($optA(-startarrowlength) / $optA(-startarrowfill))}].0"
            set arrowShape {$optA(-startarrowlength) $pq  $optA(-startarrowwidth)}
#puts "arrowShape=$arrowShape pq=$pq"
	    set pq1 "[expr {int ($optA(-endarrowlength) / $optA(-endarrowfill))}].0"
            set arrowShapeEnd {$optA(-endarrowlength) $pq1  $optA(-endarrowwidth)}
#puts "arrowShape=$arrowShape arrowShapeEnd=$arrowShapeEnd"
            set fillValue $optA(-stroke)
        if {!$argsA(-reusedefs) || 1 || \
          ![info exists defsArrowMarkerArr($arrowKey)]} {
#LISSI
#puts "can2svg::svgasxmllist: MakeArrowMarker 2"

            set defsArrowMarkerArr($arrowKey)  \
              [eval {MakeArrowMarker} $arrowShape $arrowShapeEnd {$fillValue} $optA(-strokewidth)]
            set xmlLL \
              [concat $xmlLL $defsArrowMarkerArr($arrowKey)]
        }

    }

    # If we need a stipple bitmap, need to make that first. Limited!!!
    # Only: gray12, gray25, gray50, gray75
    foreach key {-stipple -outlinestipple} {
        if {[info exists optA($key)] &&  \
          ([lsearch $grayStipples $optA($key)] >= 0)} {
            set stipple $optA($key)
            if {![info exists defsStipplePatternArr($stipple)]} {
                set defsStipplePatternArr($stipple)  \
                  [MakeGrayStippleDef $stipple]
            }
            lappend xmlLL $defsStipplePatternArr($stipple)
        }
    }
#    puts "can2svg::svgasxmllist cmd=$cmd, args=$args"
    
    switch -- $type {
        
        arc {
            
            # Had to do it the hard way! (?)
            # "Wrong" coordinate system :-(
            set attr [CoordsToAttr $type $coo $opts elem]            
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
        }
	pimage -
        bitmap - image {
            if {[info exists optA(-image)]} {
                set elem "image"
                set attr [eval {MakeImageAttr $coo $opts} $args]
                if {[string length $idAttr] > 0} {
                    set attr [concat $attr $idAttr]
                }
                set subEs [list]
                if {[info exists argsA(-imagehandler)]} {
                    set subE [uplevel #0 $argsA(-imagehandler) [list $cmd] $args]
                    if {[llength $subE]} {
                        set subEs [list $subE]
                    }
                }
#LISSI
#Масштабирование асинхронное срабатывает только в Konqueror
#На google-chrome не срабатывает
#            set argsA(-usestyleattribute) 1
if {$type == "pimage"} {
#            set attr [concat $attr [MakeAttrList $type $opts $argsA(-usestyleattribute)]]
            set gtrans ""
            if {[info exists groupX]} {
#        	set gtrans " translate([expr {-1.0 * $groupX}], [expr {-1.0 * $groupY}]) "
	    }

            if {[info exists optA(-matrix)]} {
        	set a [lindex [lindex $optA(-matrix) 0] 0]
        	set b [lindex [lindex $optA(-matrix) 0] 1]
        	set c [lindex [lindex $optA(-matrix) 1] 0]
        	set d [lindex [lindex $optA(-matrix) 1] 1]
        	set e [lindex [lindex $optA(-matrix) 2] 0]
        	set f [lindex [lindex $optA(-matrix) 2] 1]
		set val " matrix($a $b $c $d $e $f)"
		append gtrans $val
            }
                lappend attr "transform" $gtrans

            if {[info exists optA(-fillopacity)]} {
		set val " opacity : $optA(-fillopacity)"
                lappend attr "style" $val
            }
}
                lappend xmlLL [MakeXMLList $elem -attrlist $attr -subtags $subEs]
            }
        }
        line {
            set attr [CoordsToAttr $type $coo $opts elem]            
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }                    
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
#LISSI
#puts "can2svg::svgasxmllist type=$type:\nargsA(-usestyleattribute)=$argsA(-usestyleattribute)\nxmlLL=$xmlLL\n"
        }
        oval {
            set attr [CoordsToAttr $type $coo $opts elem]            
            foreach {x y w h} [NormalizeRectCoords $coo] break
            if {[expr $w == $h] && !$argsA(-ovalasellipse)} {
                # set elem "circle";# circle needs an r: not an rx & ry
                set elem "ellipse"
            } else {
                set elem "ellipse"
            }
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
        }
        polygon {
            set attr [CoordsToAttr $type $coo $opts elem]            
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
        }
        rectangle {
	    set elem "rect"
#puts "can2svg::svgasxmllist: RECTANGLE: type=$type \ncoo=$coo \nopts=$opts \nelem=$elem"
            set attr [CoordsToAttr $type $coo $opts elem]            
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
#puts "can2svg::svgasxmllist: RECTANGLE: attr=$attr"
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
        }
	ptext -
        text {
            set elem "text"
            set chdata ""
            set nlines 1
#LISSI 
	    if {$type == "ptext"} {
		set optA(-font) "\"$optA(-fontfamily)\" [expr {int ($optA(-fontsize))}] $optA(-fontweight)"
		set optA(-anchor) $optA(-textanchor)
		if {$optA(-anchor) == "c"} {
		    set optA(-anchor) "center"
		}
		set optA(-width) 0
                if {[info exists optA(-matrix)]} {
#Число pi
		    set pi [expr 2*asin(1)]
		    set pangle [lindex [lindex $optA(-matrix) 0] 1]
		    set optA(-angle) [expr {360 - asin($pangle) * 180 / $pi}]
		}
	    }

            if {[info exists optA(-font)]} {
                set theFont $optA(-font)
            } else {
                set theFont $defaultFont
            }
            set ascent [font metrics $theFont -ascent]
            set lineSpace [font metrics $theFont -linespace]
            if {[info exists optA(-text)]} {
                set chdata $optA(-text)
                
                if {[info exists optA(-width)]} {
                    
                    # MICK O'DONNELL: if the text is wrapped in the wgt, we need
                    # to simulate linebreaks
                    # 
                    # If the item has got -width != 0 then we must wrap it ourselves
                    # using newlines since the -text does not have extra newlines
                    # at these linebreaks.
                    set lines [split $chdata \n]
                    set newlines {}
                    foreach line $lines {
                        set lines2 [SplitWrappedLines $line $theFont $optA(-width)]
                        set newlines [concat $newlines $lines2]
                    }
                    set chdata [join $newlines \n]
                    if {!$argsA(-allownewlines) || \
                      ([llength $newlines] > [llength $lines])} {
                        set nlines [expr [regexp -all "\n" $chdata] + 1]
                    }
                } else {
                    if {!$argsA(-allownewlines)} {
                        set nlines [expr [regexp -all "\n" $chdata] + 1]
                    }
                }
            }
            
            # Figure out the coords of the first baseline.
            set anchor center
            if {[info exists optA(-anchor)]} {
                set anchor $optA(-anchor)
            }                                        
            
            foreach {xbase ybase}  \
              [GetTextSVGCoords $coo $anchor $chdata $theFont $nlines] {}
#LISSI это не соисем правильно
if {$xbase < 0} {set xbase 0}

            set attr [list "x" $xbase "y" $ybase]
            # angle is negated in order to fit 
            # canvas coordinate system
if {$type == "text"} {
            if {[info exists optA(-angle)]} {
                set ang [expr {-1.0*$optA(-angle)}]
#Точку поворота берём из coo
#                set val "rotate($ang $xbase,$ybase)"
                set val "rotate($ang [lindex $coo 0], [lindex $coo 1])"

                lappend attr "transform" $val
            }
} else {
            set gtrans ""
            if {[info exists groupX]} {
#        	set gtrans " translate([expr {-1.0 * $groupX}], [expr {-1.0 * $groupY}]) "
	    }

            if {[info exists optA(-matrix)]} {
        	set a [lindex [lindex $optA(-matrix) 0] 0]
        	set b [lindex [lindex $optA(-matrix) 0] 1]
        	set c [lindex [lindex $optA(-matrix) 1] 0]
        	set d [lindex [lindex $optA(-matrix) 1] 1]
        	set e [lindex [lindex $optA(-matrix) 2] 0]
        	set f [lindex [lindex $optA(-matrix) 2] 1]
		set val " matrix($a $b $c $d $e $f)"
		append gtrans $val
            }
                lappend attr "transform" $gtrans
}

            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
            set attr [concat $attr [MakeAttrList \
              $type $opts $argsA(-usestyleattribute)]]
            set dy 0
            if {$nlines > 1} {
                
                # Use the 'tspan' trick here.
                set subList {}
                foreach line [split $chdata "\n"] {
                    lappend subList [MakeXMLList "tspan"  \
                      -attrlist [list "x" $xbase "dy" $dy] -chdata $line]
                    set dy $lineSpace
                }
                lappend xmlLL [MakeXMLList $elem -attrlist $attr \
                  -subtags $subList]
            } else {
                lappend xmlLL [MakeXMLList $elem -attrlist $attr \
                  -chdata $chdata]
            }
        }
        window {
            
            # There is no svg for this; must be handled by application layer.            
            #puts "window: $cmd"
            if {[string length $argsA(-windowitemhandler)]} {
                set xmllist \
                  [uplevel #0 $argsA(-windowitemhandler) [list $cmd] $args]
                if {[llength $xmllist]} {
                    lappend xmlLL $xmllist
                }
            }
        }
        ptextXA -
	circle -
        ellipse -
	ppolygon -
	prect -
	polyline -
        path {
    	    variable groupX
    	    variable groupY
#	    puts "can2svg::svgasxmllist typePATH=$type:\ncoo=$coo \nopts=$opts  "
            if {[info exists optA(-matrix)]} {
#Число pi
		    set pi [expr 2*asin(1)]
		    set pangle [lindex [lindex $optA(-matrix) 0] 1]
		    set optA(-angle) [expr {360 - asin($pangle) * 180 / $pi}]
#puts "P=$type  MATRIX yes угол=$optA(-angle)"
	    }

            set attr [CoordsToAttr $type $coo $opts elem]            
            if {[string length $idAttr] > 0} {
                set attr [concat $attr $idAttr]
            }
            set gtrans ""
            if {[info exists groupX]} {
#        	set gtrans " translate([expr {-1.0 * $groupX}], [expr {-1.0 * $groupY}]) "
	    }

            if {[info exists optA(-matrix)]} {
        	set a [lindex [lindex $optA(-matrix) 0] 0]
        	set b [lindex [lindex $optA(-matrix) 0] 1]
        	set c [lindex [lindex $optA(-matrix) 1] 0]
        	set d [lindex [lindex $optA(-matrix) 1] 1]
        	set e [lindex [lindex $optA(-matrix) 2] 0]
        	set f [lindex [lindex $optA(-matrix) 2] 1]
		set val " matrix($a $b $c $d $e $f)"
		append gtrans $val
            }
                lappend attr "transform" $gtrans


            set argsA(-usestyleattribute) 1
            set attr [concat $attr [MakeAttrList $type $opts $argsA(-usestyleattribute)]]
#puts "can2svg::svgasxmllist typePATH=$type:\nattr=$attr\n"
            
            lappend xmlLL [MakeXMLList $elem -attrlist $attr]
#LISSI
#puts "can2svg::svgasxmllist type=$type:\nargsA(-usestyleattribute)=$argsA(-usestyleattribute)\nxmlLL=$xmlLL\n"
        }
        default {
	    puts "can2svg::svgasxmllist: unknown type=$type"
        }
    }
    return $xmlLL
}

# can2svg::CoordsToAttr --
#
#       Makes a list of attributes corresponding to type and coords.
#       
# Arguments:
#
#       
# Results:
#       a list of attributes.

proc can2svg::CoordsToAttr {type coo opts svgElementVar} {
    upvar $svgElementVar elem 

    array set optA $opts
    
    # Figure out if we've got a spline.
    set haveSpline 0
    if {[info exists optA(-smooth)] && ($optA(-smooth) != "0") &&  \
      [info exists optA(-splinesteps)] && ($optA(-splinesteps) > 2)} {
        set haveSpline 1
    }
    set attr {}

    switch -- $type {
        arc {
            set elem "path"
            set data [MakeArcPath $coo $opts]
            set attr [list "d" $data]
        }
        bitmap - image {
            array set __optA $opts
            if {[info exists __optA(-image)]} {
                set elem "image"
                set attr [ImageCoordsToAttr $coo $opts]
            }
        }
        line {
            if {$haveSpline} {
                set elem "path"
                set data [ParseSplineToPath $type $coo]
                set attr [list "d" $data]
            } else {
                set elem "polyline"
                set attr [list "points" $coo]
            }   
        }
        oval {
            
            # Assume SVG ellipse.
            set elem "ellipse"
            foreach {x y w h} [NormalizeRectCoords $coo] break
            set attr [list  \
              "cx" [expr $x + $w/2.0] "cy" [expr $y + $h/2.0]  \
              "rx" [expr $w/2.0]      "ry" [expr $h/2.0]]
        }
        polygon {
            if {$haveSpline} {
                set elem "path"
                set data [ParseSplineToPath $type $coo]
                set attr [list "d" $data]
            } else {
                set elem "polygon"
                set attr [list "points" $coo]
            }
        }
        rectangle {
            set elem "rect"
            foreach {x y w h} [NormalizeRectCoords $coo] break
            set attr [list "x" $x "y" $y "width" $w "height" $h]
        }
        text {
            set elem "text"
            # ?
        }
        ptext {
            set elem "text"
#puts "PTEXT coo=$coo"
            foreach {x y} $coo break
            set attr [list x $x y $y]
            # ?
        }
	prect {
            set elem "rect"
#puts "PRECT coo=$coo"
	    set indu [lsearch $optA(-tags) utag*]
	    set tektag [lindex $optA(-tags) $indu]
	    foreach {xx1 yy1 xx2 yy2} [.c bbox $tektag] {break}
            foreach {x y w h} [NormalizeRectCoords [.c coords $tektag]] break
#Выбрать rx и ry и убрать их из coo
            set attr [list "x" $x "y" $y "width" $w "height" $h "rx" $optA(-rx) "ry" $optA(-rx)]
        }
	polyline {
            set elem "polyline"
	    if {$optA(-strokewidth) > $optA(-startarrowwidth)} {
		foreach {x0 y0 x1 y1} $coo {break} 
		set sdvig [expr {$optA(-startarrowlength) / 2.0}]
		set x0 [expr {$x0 + $sdvig}]
		set x1 [expr {$x1 - $sdvig}]
        	set attr [list "points" "$x0 $y0 $x1 $y1"]
	    } else {
        	set attr [list "points" $coo]
	    }
#puts "can2svg::CoordsToAttr: POLYLINE coo=$coo  attr=$attr $optA(-strokewidth) > $optA(-startarrowwidth)"
        }
	ellipse {
            set elem "ellipse"
#######################
		set indu [lsearch $optA(-tags) utag*]
		set tektag [lindex $optA(-tags) $indu]
		foreach {xx1 yy1 xx2 yy2} [.c bbox $tektag] {break}
        	set attr [list "cx" [lindex $coo 0] "cy" [lindex $coo 1] "rx" $optA(-rx) "ry" $optA(-ry)]
	}
	circle {
            set elem "ellipse"
            set attr [list "cx" [lindex $coo 0] "cy" [lindex $coo 1] "rx" $optA(-rx) "ry" $optA(-rx)]
	}
	ppolygon {
            set elem "polygon"
            set attr [list "points" $coo]
#puts "can2svg::CoordsToAttr:  attr=$attr $optA(-strokewidth) > $optA(-startarrowwidth)"
        }
        path {
            set elem "path"
            set attr [list "d" $coo]
        }
        default {
	    puts "can2svg::CoordsToAttr: unknown type=$type"
        }
    }
    return $attr
}

# can2svg::MakeArcPath --
# 
#       Makes a path using A commands from an arc.
#       Conversion from center to endpoint parameterization.
#       From: http://www.w3.org/TR/2003/REC-SVG11-20030114

proc can2svg::MakeArcPath {coo opts} {
    
    variable anglesToRadians
    variable pi

    # Canvas defaults.
    array set optA {
        -extent 90
        -start  0
        -style  pieslice
    }
    array set optA $opts

    # Extract center and radius from bounding box.
    foreach {x1 y1 x2 y2} $coo break
    set cx [expr ($x1 + $x2)/2.0]
    set cy [expr ($y1 + $y2)/2.0]
    set rx [expr abs($x1 - $x2)/2.0]
    set ry [expr abs($y1 - $y2)/2.0]

    set start  [expr $anglesToRadians * $optA(-start)]
    set extent [expr $anglesToRadians * $optA(-extent)]

    # NOTE: direction of angles are opposite for Tk and SVG!    
    set theta1 [expr -1*$start]
    set delta  [expr -1*$extent]
    set theta2 [expr $theta1 + $delta]
    set phi 0.0

    # F.6.4 Conversion from center to endpoint parameterization.
    set x1 [expr $cx + $rx * cos($theta1) * cos($phi) -  \
      $ry * sin($theta1) * sin($phi)]
    set y1 [expr $cy + $rx * cos($theta1) * sin($phi) +  \
      $ry * sin($theta1) * cos($phi)]
    set x2 [expr $cx + $rx * cos($theta2) * cos($phi) -  \
      $ry * sin($theta2) * sin($phi)]
    set y2 [expr $cy + $rx * cos($theta2) * sin($phi) +  \
      $ry * sin($theta2) * cos($phi)]
    
    set fa [expr {abs($delta) > $pi} ? 1 : 0]
    set fs [expr {$delta > 0.0} ? 1 : 0]
    
    set data [format "M %.1f %.1f A" $x1 $y1]
    append data [format " %.1f %.1f %.1f %1d %1d %.1f %.1f"  \
      $rx $ry $phi $fa $fs $x2 $y2]
    
    switch -- $optA(-style) {
        arc {
            # empty.
        }
        chord {
            append data " Z"
        }
        pieslice {
            append data [format " L %.1f %.1f Z" $cx $cy]
        }
    }
    return $data
}

# can2svg::MakeArcPathNonA --
# 
#       Makes a path without any A commands from an arc.

proc can2svg::MakeArcPathNonA {coo opts} {

    variable anglesToRadians

    array set optA $opts
    
    foreach {x1 y1 x2 y2} $coo break
    set cx [expr ($x1 + $x2)/2.0]
    set cy [expr ($y1 + $y2)/2.0]
    set rx [expr abs($x1 - $x2)/2.0]
    set ry [expr abs($y1 - $y2)/2.0]
    set rmin [expr $rx > $ry ? $ry : $rx]
    
    # This approximation gives a maximum half pixel error.
    set deltaPhi [expr 2.0/sqrt($rmin)]
    set extent   [expr $anglesToRadians * $optA(-extent)]
    set start    [expr $anglesToRadians * $optA(-start)]
    set nsteps   [expr int(abs($extent)/$deltaPhi) + 2]
    set delta    [expr $extent/$nsteps]
    set data [format "M %.1f %.1f L"  \
      [expr $cx + $rx*cos($start)] [expr $cy - $ry*sin($start)]]
    for {set i 0} {$i <= $nsteps} {incr i} {
        set phi [expr $start + $i * $delta]
        append data [format " %.1f %.1f"  \
          [expr $cx + $rx*cos($phi)] [expr $cy - $ry*sin($phi)]]
    }
    if {[info exists optA(-style)]} {
        
        switch -- $optA(-style) {
            chord {
                append data " Z"
            }
            pieslice {
                append data [format " %.1f %.1f Z" $cx $cy]
            }
        }
    } else {
        
        # Pieslice is the default.
        append data [format " %.1f %.1f Z" $cx $cy]
    }
    return $data
}
#LISSI Make Defs Gradient
proc can2svg::MakeGradientDef {gradient} {
    array set Gradient [parsegradient .c  $gradient]
#    parray Gradient
    if {$Gradient(units) == "bbox"} {
	set units "bbox"
    } else {
	set units "userSpaceOnUse"
    }
    if {$Gradient(type) == "linear"} {
	set type "linearGradient"
	set gradientAttr [list "id" $gradient "x1" $Gradient(x0) "x2" $Gradient(x1) "y1" $Gradient(y0) "y2" $Gradient(y1) gradientsUnits $units]
    } else {
	set type "radialGradient"
	set gradientAttr [list "id" $gradient  "cx" $Gradient(cx) "cy" $Gradient(cy) "r" $Gradient(r) "fx" $Gradient(fx) "fy" $Gradient(fy) gradientsUnits $units]
    }
    set stopList [list]
    for {set i 0} {$i < $Gradient(i)} {incr i} {
	set stopAttr [list "id" "stop$gradient$i" "offset" $Gradient(offset$i) "stop-color" $Gradient(color$i) "stop-opacity" $Gradient(opacity$i)]
	append stopList " [MakeXMLList stop -attrlist $stopAttr]"
    }
#puts "MakeGradientDef: stopList=$stopList"
    set defElemList [MakeXMLList "defs" -subtags  \
          [list [MakeXMLList $type -attrlist $gradientAttr \
          -subtags [list $stopList] ] ] ]
#puts "MakeGradientDef: defElemList=$defElemList"

    return [list $defElemList]
}

# can2svg::MakeAttrList --
# 
#       Handles the use of style attributes or presenetation attributes.

proc can2svg::MakeAttrList {type opts usestyleattribute} {
    
    if {$usestyleattribute} {
        set attrList [list style [MakeStyleAttr $type $opts]]
    } else {
        set attrList [MakeStyleList $type $opts]
    }
    return $attrList
}

# can2svg::MakeStyleAttr --
#
#       Produce the SVG style attribute from the canvas item options.
#
# Arguments:
#       type        tk canvas widget item type
#       opts
#       
# Results:
#       The SVG style attribute as a a string.

proc can2svg::MakeStyleAttr {type opts} {
#puts "can2svg::MakeStyleAttr type=$type \nopts=$opts"    

    set style ""
    set ind [lsearch $opts "-tags"]
    set svg 0
    if {$ind > -1} {
	incr ind
	set svg [lsearch [lindex $opts $ind] "svg"]
	if {$svg > -1} {
	    set svg 1
	}
    }
    if {$svg && ($type == "ellipse" || $type == "pimage" || $type == "path" || $type == "polyline" || $type == "prect" || $type == "ppolygon" || $type == "ptext")} {
	foreach {key value} [lrange $opts 0 end] {
	    if {$type == "prect"} {
		if {$key == "-rx" || $key == "-ry"} {
		    continue
		}
	    }
	    if {$key == "-tags" || $key == "-parent" || $key == "-state"} {continue}
#puts "can2svg::MakeStyleAttr key=$key value=$value"    
	    if {[string length $key] > 7 && [string range $key 0 6]  == "-stroke"} {
		set key [string replace $key 0 6 "-stroke-"]
	    }
	    if {[string length $key] > 5 && [string range $key 0 4]  == "-font"} {
		set key [string replace $key 0 4 "-font-"]
		if {$key == "-font-size"} {
    		    if {$value > 0} {
        		# pixels (actually user units)
        		set funit pt
    		    } else {
        		# points
        		set funit px
    		    }        
    		    set  value "[expr abs($value)]$funit"
		}
	    }
	    if {$key  == "-fillopacity"} {
		set key "-fill-opacity"
	    }

	    if {$value == ""} {
    		append style "[string range ${key} 1 end] : none; "
	    } else {
    		append style "[string range ${key} 1 end] : ${value}; "
    	    }
	}
#	return [string trim $style]
    }
    
#puts "can2svg::MakeStyleAttr: type=$type opts=$opts"
#puts "can2svg::MakeStyleAttr: style=$style"
    foreach {key value} [MakeStyleList $type $opts] {
#puts "can2svg::MakeStyleAttr: key=$key value=$value"
        append style "${key}: ${value}; "
    }
#puts "can2svg::MakeStyleAttr: style=$style"
    return [string trim $style]
}

proc can2svg::MakeStyleList {type opts args} {
    
    array set argsA {
        -setdefaults 1 
    }
    array set argsA $args
    
#LISSI
    if {$type == "polyline"} {
#Выбираем стрелки из tkpath - scg
	set arrowValue ""
	set fontsvg ""
	set strwidth 0
	foreach {key value} $opts {
    	    switch -- $key {
        	-fontsize -
        	-fontwidth -
        	-fontfamily {
            	    append $fontsvg " $value"
        	}
        	-startarrowlength {
            	    set a $value
        	}
        	-startarrowwidth {
            	    set b $value
        	}
        	-startarrowfill {
            	    set c $value
        	}
        	-endarrowlength {
            	    set a1 $value
        	}
        	-endarrowwidth {
            	    set b1 $value
        	}
        	-endarrowfill {
            	    set c1 $value
        	}
        	-startarrow {
        	    if {$value == 1} {
        		if {$arrowValue == ""} {
            		    set arrowValue "first"
            		} else {
            		    set arrowValue "both"
            		}
            	    }
        	}
        	-endarrow {
        	    if {$value == 1} {
        		if {$arrowValue == ""} {
            		    set arrowValue "last"
            		} else {
            		    set arrowValue "both"
            		}
		    }
        	}
        	-stroke {
            	    set fillCol $value
#            	    set fillCol [string range $value 1 end]
        	}
        	-strokewidth {
            	    set strwidth $value
        	}

    	    }
	}
	if {$fontsvg != ""} {
#puts "can2svg::MakeStyleList: fontsvg=$fontsvg"
                array set styleArr [MakeFontStyleList $fontsvg]
	}
	
	set pq [expr {int($a / $c) * 1.0}]
        set arrowShape [list $a $pq  $b]
	set pq1 [expr {int($a1 / $c1) * 1.0}]
        set arrowShapeEnd [list $a1 $pq1  $b1]
set optA(-arrowshapeEnd) $arrowShapeEnd
#	set arrowShape [list $a $b $c]
#puts "can2svg::MakeStyleAttr ARROW: opts=$opts"    
    } else {

    # Defaults for everything except text.
    if {$type != "polyline" && $type != "prect" && $type != "ptext" && $type != "path" && $type != "ppolygon" && $argsA(-setdefaults) && ![string equal $type "text"]} {
        array set styleArr {fill none stroke black}
    }
    set fillCol black
    foreach {key value} $opts {
        
        switch -- $key {
            -arrow {
                set arrowValue $value
            }
            -arrowshape {
                set arrowShape $value
                set arrowShapeEnd $value
            }
            -capstyle {
                if {[string equal $value "projecting"]} {
                    set value "square"
                }
                if {![string equal $value "butt"]} {
                    set styleArr(stroke-linecap) $value
                }
            }
            -dash {
                set dashValue $value
            }
            -dashoffset {
                if {$value != 0} {
                    set styleArr(stroke-dashoffset) $value
                }
            }
            -extent {
                # empty
            }
            -fill {
		#LISSI gradient
		if {[filltype $value] == "gradient"} {
                    set styleArr(fill) "url(#$value)"
#puts "can2svg::MakeStyleList: styleArr(fill)=$styleArr(fill)"
		} else {
                # Need to translate names to hex spec.
                if {![regexp {#[0-9]+} $value]} {
                    set value [FormatColorName $value]
                }
                set fillCol $value                
                if {[string equal $type "line"]} {
                    set styleArr(stroke) [MapEmptyToNone $value]
                } else {
                    set styleArr(fill) [MapEmptyToNone $value]
                }
                }
            }
            -font {
                array set styleArr [MakeFontStyleList $value]
                
            }
            -joinstyle {
                set styleArr(stroke-linejoin) $value                
            }
            -outline {
                set styleArr(stroke) [MapEmptyToNone $value]
            }
            -outlinestipple {
                set outlineStippleValue $value
            }
            -start {
                # empty
            }
            -stipple {
                set stippleValue $value
            }
            -width {
                set styleArr(stroke-width) $value
            }
        }
    }
    }
    # If any arrow specify its marker def url key.
    if {[info exists arrowValue]} {
#puts "arrowShape=$arrowShape arrowShapeEnd=$arrowShapeEnd"
        if {[info exists arrowShape]} {        
            foreach {a b c} $arrowShape break
#LISSI
	    set colM [string range $fillCol  1 end]
	    set arrowIdKey "arrowMarkerDef_${colM}_${a}_${b}_${c}"
#puts "can2svg::MakeStyleList colM=\"$colM\""
            foreach {a1 b1 c1} $arrowShapeEnd break
	    set arrowIdKeyLast "arrowMarkerLastDef_${colM}_${a1}_${b1}_${c1}"

        } else {
            set arrowIdKey "arrowMarkerDef_${fillCol}"
            set arrowIdKeyLast $arrowIdKey
        }
#puts "arrowIdKey=$arrowIdKey arrowIdKeyLast=$arrowIdKeyLast"
        switch -- $arrowValue {
            first {
                set styleArr(marker-start) "url(#$arrowIdKey)"
            }
            last {
                set styleArr(marker-end) "url(#$arrowIdKeyLast)"
            }
            both {
                set styleArr(marker-start) "url(#$arrowIdKey)"
                set styleArr(marker-end) "url(#$arrowIdKeyLast)"
            }
        }
    }
    
    if {[info exists stippleValue]} {
        
        # Overwrite any existing.
        set styleArr(fill) "url(#tile[string trimleft $stippleValue @])"
    }
    if {[info exists outlineStippleValue]} {
        
        # Overwrite any existing.
        set styleArr(stroke) "url(#tile[string trimleft $stippleValue @])"
    }
    
    # Transform dash value.
    if {[info exists dashValue]} {
                
        # Two different syntax here.                
        if {[regexp {[\.,\-_]} $dashValue]} {
            
            # .=2 ,=4 -=6 space=4    times stroke width.
            # A space enlarges the... space.
            # Not foolproof!
            regsub -all -- {[^ ]} $dashValue "& " dash
            regsub -all -- "   "  $dash  "12 " dash
            regsub -all -- "  "   $dash  "8 " dash
            regsub -all -- " "    $dash  "4 " dash
            regsub -all -- {\.}   $dash  "2 " dash
            regsub -all -- {,}    $dash  "4 " dash
            regsub -all -- {-}    $dash  "6 " dash                    
        
            # Multiply with stroke width if > 1.
            if {[info exists styleArr(stroke-width)] &&  \
              ($styleArr(stroke-width) > 1)} {
                set width $styleArr(stroke-width)
                set dashOrig $dash
                set dash {}
                foreach num $dashOrig {
                    lappend dash [expr int($width * $num)]
                }
            }
            set styleArr(stroke-dasharray) [string trim $dash]
        } else {
            set dashValue [string trim $dashValue]
            if {$dashValue ne ""} {
                set styleArr(stroke-dasharray) $dashValue
            }
        }
    }
    if {[string equal $type "polygon"]} {
        set styleArr(fill-rule) "evenodd"
    }        
    return [array get styleArr]
}

proc can2svg::FormatColorName {value} {

    if {[string length $value] == 0} {
        return $value
    }

    switch -- $value {
        black - white - red - green - blue {
            set col $value
        }
        default {
        
            # winfo rgb . white -> 65535 65535 65535
            foreach rgb [winfo rgb . $value] {
                lappend rgbx [expr $rgb >> 8]
            }
            set col [eval {format "#%02x%02x%02x"} $rgbx]
        }
    }
    return $col
}

# can2svg::MakeFontStyleList --
# 
#       Takes a tk font description and returns a flat style array.
#       
# Arguments:
#       fontDesc    a tk font description 
#       
# Results:
#       flat style array

proc can2svg::MakeFontStyleList {fontDesc} {    
#LISSI
#puts "can2svg::MakeFontStyleList: fontDesc=$fontDesc"

    # MICK Modify - break a named font into its component fields
    set font [lindex $fontDesc 0]
    if {[lsearch -exact [font names] $font] > -1} {
        
        # This is a font name
        set styleArr(font-family) [font config $font -family]
        set fsize [font config $font -size]
        if {$fsize > 0} {
            # points
            set funit pt
        } else {
            # pixels (actually user units)
            set funit px
        }        
        set styleArr(font-size) "[expr abs($fsize)]$funit"
        if {[font config $font -slant] == "italic"} {
            set styleArr(font-style) italic
        }
        if {[font config $font -weight] == "bold"} {
            set styleArr(font-weight) bold
        }
        if {[font config $font -underline]} {
            set styleArr(text-decoration) underline
        }
        if {[font config $font -overstrike]} {
            set styleArr(text-decoration) overline
        }
    } else {
        set styleArr(font-family) [lindex $fontDesc 0]
        if {[llength $fontDesc] > 1} {
            # Mick: added pt at end
            set fsize [lindex $fontDesc 1]
            if {$fsize > 0} {
                # points
                set funit pt
            } else {
                # pixels (actually user units)
                set funit px
            }
            set styleArr(font-size) "[expr abs($fsize)]$funit"
        }
        if {[llength $fontDesc] > 2} {
            set tkstyle [lindex $fontDesc 2]
            switch -- $tkstyle {
                bold {
                    set styleArr(font-weight) $tkstyle
                }
                italic {
                    set styleArr(font-style) $tkstyle
                }
                underline {
                    set styleArr(text-decoration) underline
                }
                overstrike {
                    set styleArr(text-decoration) overline
                }
            }
        }                
    }
    return [array get styleArr]
}

# can2svg::SplitWrappedLines --
# 
# MICK O'DONNELL: added code to split wrapped lines
# This is actally only needed for text items with -width != 0.
# If -width = 0 then just return it.

proc can2svg::SplitWrappedLines {line font wgtWidth} {

     # If the text is shorter than the widget width, no need to wrap
     # If the wgtWidth comes out as 0, don't wrap
     if {$wgtWidth == 0 || [font measure $font $line] <= $wgtWidth} {
        return [list $line]
     }

     # Wrap the line
     set width 0
     set endchar 0
     while {$width < $wgtWidth} {
        set substr [string range $line 0 [incr endchar]]
        set width [font measure $font $substr]
     }

     # Go back till we find a nonwhite char
     set char [string index $line $endchar]
     set default [expr $endchar -1]
     while {[BreakChar $char] == 0} {
        if {$endchar == 0} {
            # we got to the front without breaking, so break midword
            set endchar $default
            break
        }
        set char [string index $line [incr endchar -1]]
     }
     set first [string range $line 0 $endchar]
     set rest [string range $line [expr $endchar+1] end]
     return [concat [list $first] [SplitWrappedLines $rest $font $wgtWidth]]
}

proc can2svg::BreakChar {char} {
     if [string is space $char] {return 1}
     if {$char == "-"} {return 1}
     if {$char == ","} {return 1}
     return 0
}

# can2svg::MakeImageAttr --
#
#       Special code is needed to make the attributes for an image item.
#       
# Arguments:
#       elem 
#       
# Results:
#   

proc can2svg::MakeImageAttr {coo opts args} {
    variable confopts
    
    array set optA {-anchor nw}
    array set optA $opts
    array set argsA $args
    
    set attrList [ImageCoordsToAttr $coo $opts]

    # We should make this an URI.
    set image $optA(-image)
    set fileName [$image cget -file]
    if {$fileName ne ""} {
        if {[string equal $argsA(-uritype) "file"]} {
            set uri [FileUriFromLocalFile $fileName]
        } elseif {[string equal $argsA(-uritype) "http"]} {
            set uri [HttpFromLocalFile $fileName]
        }
        lappend attrList "xlink:href" $uri
    } else {
        # Unclear if we can use base64 data in svg.
	set uri [$optA(-image) cget -data]
        lappend attrList "xlink:href" "data:image/png;base64,$uri"
    }    
    return $attrList
}

# Function � �: can2svg::ImageCoordsToAttr 
# ------------------------------ ------------------------------ --------- 
# Returns � � : list of x y width and height including description 
# Parameters �: coo �- coordinates of the image 
# � � � � � � � opts - argument list -anchor nw ... 
#
# Description : 
# fixme (Roger) 01/25/2008 :Why not using the bounding box? 
#
# Written � � : 2002-2007, Mats 
# Rewritten � : 01/25/2008, Roger 
# ------------------------------ ------------------------------ --------- 

proc can2svg::ImageCoordsToAttr {coo opts} { 
    
    array set optArr {-anchor nw}
    array set optArr $opts
    
    if {![info exists optArr(-image)]} { 
        return -code error "Missing -image option; can't parse that" 
    } 
    set theImage $optArr(-image) 

    lassign $coo x0 y0
#LISSI
    set svg [lsearch $optArr(-tags) "svg"]
    if {$svg > -1} {
	set svg 1
    } else {
	set svg 0
    }
    if {$svg} {
	set w $optArr(-width)
	set h $optArr(-height) 
    } else { 

	set w [image width $theImage]
	set h [image height $theImage]
    }
    
    set x [expr {$x0 - $w/2.0}] 
    set y [expr {$y0 - $h/2.0}] 

    if { "center" ne $optArr(-anchor) } { 
        foreach orientation [split $optArr(-anchor) {}] { 
            switch $orientation { 
                n { set y $y0 } 
                s { set y [expr {$y0 - $w}] } 
                e { set x [expr {$x0 - $h}] } 
                w { set x $x0 } 
                default {} 
            } 
        } 
    } 
    return [list "x" $x "y" $y "width" $w "height" $h] 
}

proc can2svg::ImageCoordsToAttrBU {coo opts} {
    array set optA {-anchor nw}
    array set optA $opts
    if {[info exists optA(-image)]} {
        set theImage $optA(-image)
        set w [image width $theImage]
        set h [image height $theImage]
    } else {
        return -code error "Missing -image option; can't parse that"
    }
    foreach {x0 y0} $coo break
    
    switch -- $optA(-anchor) {
        nw {
            set x $x0
            set y $y0
        }
        n {
            set x [expr $x0 - $w/2.0]
            set y $y0
        }
        ne {
            set x [expr $x0 - $w]
            set y $y0
        }
        e {
            set x $x0
            set y [expr $y0 - $h/2.0]
        }
        se {
            set x [expr $x0 - $w]
            set y [expr $y0 - $h]
        }
        s {
            set x [expr $x0 - $w/2.0]
            set y [expr $y0 - $h]
        }
        sw {
            set x $x0
            set y [expr $y0 - $h]
        } 
        w {
            set x $x0
            set y [expr $y0 - $h/2.0]
        }
        center {
            set x [expr $x0 - $w/2.0]
            set y [expr $y0 - $h/2.0]
        }
    }
    set attrList [list "x" $x "y" $y "width" $w "height" $h]
    return $attrList
}

# can2svg::GetTextSVGCoords --
# 
#       Figure out the baseline coords of the svg text element from
#       the canvas text item.
#
# Arguments:
#       coo         {x y}
#       anchor
#       chdata      character data, newlines included.
#       
# Results:
#       raw xml data of the marker def element.

proc can2svg::GetTextSVGCoords {coo anchor chdata theFont nlines} {
    
    foreach {x y} $coo break
    set ascent [font metrics $theFont -ascent]
    set lineSpace [font metrics $theFont -linespace]

    # If not anchored to the west it gets more complicated.
    if {![string match $anchor "*w*"]} {
        
        # Need to figure out the extent of the text.
        if {$nlines <= 1} {
            set textWidth [font measure $theFont $chdata]
        } else {
            set textWidth 0
            foreach line [split $chdata "\n"] {
                set lineWidth [font measure $theFont $line]
                if {$lineWidth > $textWidth} {
                    set textWidth $lineWidth
                }
            }
        }
    }
    
    switch -- $anchor {
        nw {
            set xbase $x
            set ybase [expr $y + $ascent]
        }
        w {
            set xbase $x
            set ybase [expr $y - $nlines*$lineSpace/2.0 + $ascent]
        }
        sw {
            set xbase $x
            set ybase [expr $y - $nlines*$lineSpace + $ascent]
        }
        s {
            set xbase [expr $x - $textWidth/2.0]
            set ybase [expr $y - $nlines*$lineSpace + $ascent]
        }
        se {
            set xbase [expr $x - $textWidth]
            set ybase [expr $y - $nlines*$lineSpace + $ascent]
        }
        e {
            set xbase [expr $x - $textWidth]
            set ybase [expr $y - $nlines*$lineSpace/2.0 + $ascent]
        }
        ne {
            set xbase [expr $x - $textWidth]
            set ybase [expr $y + $ascent]
        } 
        n {
            set xbase [expr $x - $textWidth/2.0]
            set ybase [expr $y + $ascent]
        }
        center {
            set xbase [expr $x - $textWidth/2.0]
            set ybase [expr $y - $nlines*$lineSpace/2.0 + $ascent]
        }
    }
    
    return [list $xbase $ybase]
}

# can2svg::ParseSplineToPath --
# 
#       Make the path data string for a bezier.
#
# Arguments:
#       type        canvas type: line or polygon
#       coo         its coordinate list
#       
# Results:
#       path data string

proc can2svg::ParseSplineToPath {type coo} {
    
    set npts [expr [llength $coo]/2]
    
    # line is open ended while the polygon must be closed.
    # Need to construct a closed smooth polygon with path instructions.

    switch -- $npts {
        1 {
            set data "M [lrange $coo 0 1]"
        }
        2 {
            set data "M [lrange $coo 0 1] L [lrange $coo 2 3]"                                
        }
        3 {
            set data "M [lrange $coo 0 1] Q [lrange $coo 2 5]"
        }
        default {
            if {[string equal $type "polygon"]} {
                set x0s [expr ([lindex $coo 0] + [lindex $coo end-1])/2.]
                set y0s [expr ([lindex $coo 1] + [lindex $coo end])/2.]
                set data "M $x0s $y0s"
                    
                # Add Q1 and Q2 points.
                append data " Q [lrange $coo 0 1]"
                set x0 [expr ([lindex $coo 0] + [lindex $coo 2])/2.]
                set y0 [expr ([lindex $coo 1] + [lindex $coo 3])/2.]
                append data " $x0 $y0"
                set xctrlp [lindex $coo 2]
                set yctrlp [lindex $coo 3]
                set tind 4
            } else {
                set data "M [lrange $coo 0 1]"
                    
                # Add Q1 and Q2 points.
                append data " Q [lrange $coo 2 3]"
                set x0 [expr ([lindex $coo 2] + [lindex $coo 4])/2.]
                set y0 [expr ([lindex $coo 3] + [lindex $coo 5])/2.]
                append data " $x0 $y0"
                set xctrlp [lindex $coo 4]
                set yctrlp [lindex $coo 5]
                set tind 6
            }
            append data " T"                                
            foreach {x y} [lrange $coo $tind end-2] {
                #puts "x=$x, y=$y, xctrlp=$xctrlp, yctrlp=$yctrlp"
                
                # The T point is the midpoint between the
                # two control points.
                set x0 [expr ($x + $xctrlp)/2.0]
                set y0 [expr ($y + $yctrlp)/2.0]
                set xctrlp $x
                set yctrlp $y
                append data " $x0 $y0"
                #puts "data=$data"
            }
            if {[string equal $type "polygon"]} {
                set x0 [expr ([lindex $coo end-1] + $xctrlp)/2.0]
                set y0 [expr ([lindex $coo end] + $yctrlp)/2.0]
                append data " $x0 $y0"
                append data " $x0s $y0s"
            } else {
                append data " [lrange $coo end-1 end]"
            }
            #puts "data=$data"
        }
    }
    return $data
}

# can2svg::MakeArrowMarker --
# 
#       Make the xml for an arrow marker def element.
#
# Arguments:
#       a           arrows length along its symmetry line
#       b           arrows total length
#       c           arrows half width
#       col         its color
#       
# Results:
#       a list of xmllists of the marker def elements, both start and last.

proc can2svg::MakeArrowMarker {a b c a1 b1 c1 col strokewidth} {
    variable formatArrowMarker
    variable formatArrowMarkerLast
    unset -nocomplain formatArrowMarker
#puts "a=$a b=$b c=$c" 
#puts "a1=$a1 b1=$b1 c1=$c1 strokewidth=$strokewidth" 

    if {![info exists formatArrowMarker]} {
        
        # "M 0 c, b 0, a c, b 2*c Z" for the start marker.
        # "M 0 0, b c, 0 2*c, b-a c Z" for the last marker.
        set data "M 0 %s, %s 0, %s %s, %s %s Z"
        set style "fill: %s; stroke: %s;"
        set attr [list "d" $data "style" $style]
        set arrowList [MakeXMLList "path" -attrlist $attr]
        set markerAttr [list "id" %s "markerWidth" %s "markerHeight" %s  \
          "refX" %s "refY" %s "orient" "auto" "markerUnits" "userSpaceOnUse"]
        set defElemList [MakeXMLList "defs" -subtags  \
          [list [MakeXMLList "marker" -attrlist $markerAttr \
          -subtags [list $arrowList] ] ] ]
        set formatArrowMarker $defElemList
        
        # ...and the last arrow marker.
        set dataLast "M 0 0, %s %s, 0 %s, %s %s Z"
        set attrLast [list "d" $dataLast "style" $style]
        set arrowLastList [MakeXMLList "path" -attrlist $attrLast]
        set defElemLastList [MakeXMLList "defs" -subtags  \
          [list [MakeXMLList "marker" -attrlist $markerAttr \
          -subtags [list $arrowLastList] ] ] ]
        set formatArrowMarkerLast $defElemLastList
    }
#LISSI
#puts "can2svg::MakeArrowMarker formatArrowMarker=$formatArrowMarker"
#puts "can2svg::MakeArrowMarker formatArrowMarkerLast=$formatArrowMarkerLast"
    set colM [string range $col  1 end]
    set idKey "arrowMarkerDef_${colM}_${a}_${b}_${c}"
#puts "can2svg::MakeArrowMarker col=$col colM=\"$colM\""
    set idKeyLast "arrowMarkerLastDef_${colM}_${a1}_${b1}_${c1}"
    
    # Figure out the order of all %s substitutions.
    if {$strokewidth > $c} {
	set c $strokewidth
    }
    if {$strokewidth > $c1} {
	set c1 $strokewidth
    }
    
    set markerXML [format $formatArrowMarker $idKey  \
      $b [expr 2*$c] 0 $c  \
      $c $b $a $c $b [expr 2*$c] $col $col]
#puts "idKey=$idKey"
#puts "markerXML=$markerXML"
    set markerLastXML [format $formatArrowMarkerLast $idKeyLast  \
      $b1 [expr 2*$c1] $b1 $c1 \
      $b1 $c1 [expr 2*$c1] [expr $b1-$a1] $c1 $col $col]
#puts "idKeyLast=$idKeyLast"
#puts "markerLastXML=$markerLastXML"

    return [list $markerXML $markerLastXML]
}

# can2svg::MakeGrayStippleDef --
#
#

proc can2svg::MakeGrayStippleDef {stipple} {
    
    variable stippleDataArr
    
    set pathList [MakeXMLList "path" -attrlist  \
      [list "d" $stippleDataArr($stipple) "style" "stroke: black; fill: none;"]]
    set patterAttr [list "id" "tile$stipple" "x" 0 "y" 0 "width" 4 "height" 4 \
      "patternUnits" "userSpaceOnUse"]
    set defElemList [MakeXMLList "defs" -subtags  \
      [list [MakeXMLList "pattern" -attrlist $patterAttr \
      -subtags [list $pathList] ] ] ]
    
    return $defElemList
}

# can2svg::MapEmptyToNone --
#
#
# Arguments:
#       elem 
#       
# Results:
#   

proc can2svg::MapEmptyToNone {val} {

    if {[string length $val] == 0} {
        return "none"
    } else {
        return $val
    }
}

# can2svg::NormalizeRectCoords --
#
#
# Arguments:
#       elem 
#       
# Results:
#   

proc can2svg::NormalizeRectCoords {coo} {
    
    foreach {x1 y1 x2 y2} $coo {}
    return [list [expr $x2 > $x1 ? $x1 : $x2]  \
      [expr $y2 > $y1 ? $y1 : $y2]  \
      [expr abs($x1-$x2)]  \
      [expr abs($y1-$y2)]]
}

# can2svg::makedocument --
#
#       Adds the prefix and suffix elements to make a complete XML/SVG
#       document.
#
# Arguments:
#       elem 
#       
# Results:
#   

proc can2svg::makedocument {width height xml} {
    global groupX
#LISSI
#<svg width='300' height='180'  viewBox="203 85 300 180" version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>
    set viewbox ""
#puts "can2svg::makedocument: bbox=[.c bbox mainBBox]"
    if {[.c bbox mainBBox] != ""} {
	foreach {x1 y1 x2 y2} [.c bbox mainBBox] {break}
	set width [expr {$x2 - $x1 + 1}]
	set height [expr {$y2 - $y1 + 1}]
	set viewbox " viewBox='$x1 $y1 $width $height'"
    }
#puts "can2svg::makedocument: viewvox=$viewbox"
    switch -- $::tcl_platform(platform) {
	"windows"        {
	    set enc " encoding='cp1251'"
	}
	"unix" - default {
	    set enc "encoding='utf-8'"
	}
    }

    set pre "<?xml version='1.0' $enc?>\n\
      <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"\
      \"Graphics/SVG/1.1/DTD/svg11.dtd\">"
    set svgStart "<svg width='$width' height='$height' $viewbox version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>"
    set svgEnd "</svg>"
    return "${pre}\n${svgStart}\n${xml}${svgEnd}"
}

# can2svg::canvas2file --
#
#       Takes everything on a canvas widget, translates it to XML/SVG,
#       and puts it on a file.
#       
# Arguments:
#       wcan        the canvas widget path
#       path        the file path
#       args:   -height
#               -width 
#       
# Results:
#   

proc can2svg::canvas2file {wcan path args} {
    variable confopts
    variable defsArrowMarkerArr
    variable defsStipplePatternArr
    
    array set argsA [array get confopts]
    foreach {x y width height} [$wcan cget -scrollregion] break
#LISSI
    set cmain [$wcan coords mainBBox]
    if {$cmain != ""} {
    foreach {x1 y1 x2 y2} [$wcan coords mainBBox] {break}
#    set width [expr {$x2 - $x1 + 1}]
#    set height [expr {$y2 - $y1 + 1}]
#Обрезаем canvas справа и снизу
#Можно использовать функцию  setBoundingBox!!!!
	set width $x2
	set height $y2
	unselectGroup
    } 

    array set argsA [list -width $width -height $height]
    array set argsA $args
    set args [array get argsA]
    
    # Need to make a fresh start for marker def's.
    unset -nocomplain defsArrowMarkerArr defsStipplePatternArr
  
    set fd [open $path w]

    # This could have been done line by line.
    set xml ""
#LISSI
#    foreach id [$wcan find all] {}
    foreach id [lrange [$wcan find all] 1 end] {
        set type [$wcan type $id]
        set opts [$wcan itemconfigure $id]
        set opcmd {}
        foreach opt $opts {
            set op [lindex $opt 0]
            set val [lindex $opt 4]
            
            # Empty val's except -fill can be stripped off.
            if {![string equal $op "-fill"] && ([string length $val] == 0)} {
                continue
            }
            lappend opcmd $op $val
        }
        set co [$wcan coords $id]
        set cmd [concat "create" $type $co $opcmd]
        append xml "\t[eval {can2svg $cmd} $args]\n"        
    }

    puts $fd [makedocument $argsA(-width) $argsA(-height) $xml]
    close $fd
}

proc can2svg::group2file {wcan path args} {
    variable confopts
    variable defsArrowMarkerArr
    variable defsStipplePatternArr
#LISSI 
    variable groupX
    variable groupY
    if {[llength [$wcan find withtag Selected]] == 0} {
        tk_messageBox -title "Export group to SVG" -message "Not group for export" -icon warning
	return ""
    }

    array set argsA [array get confopts]
    foreach {x y width height} [$wcan cget -scrollregion] break
#LISSI
    
    foreach {x1 y1 x2 y2} [$wcan coords mainBBox] break
    set width [expr {$x2 - $x1 + 1}]
    set height [expr {$y2 - $y1 + 1}]

    array set argsA [list -width $width -height $height]
    array set argsA $args
    set args [array get argsA]
    
    # Need to make a fresh start for marker def's.
    unset -nocomplain defsArrowMarkerArr defsStipplePatternArr
    if {$path != "-image"} {
	if {[catch {set fd [open $path w]} ret]} {
    	    tk_messageBox -title "Export group to SVG" -message "Cannot open file for write:\n$path" -detail $ret -icon error
	    return ""
	}
    }
    # This could have been done line by line.
    set xml ""
#LISSI
#    foreach id [$wcan find all] {}
#Перемещвем в начало координат
    foreach {x1 y1 x2 y2} [.c coords mainBBox] {break}
    set groupX $x1
    set groupY $y1
set groupX 0
set groupY 0

#    moveGroupSVG [expr {-1.0 * $x1}]  [expr {-1.0 * $y1}]
#    .c cmove Selected "-$x1" "-$y1"
    foreach id [$wcan find withtag Selected] {
#Сохраняем угол поворота
	set tid [idissvg $id]

        set type [$wcan type $id]
        set opts [$wcan itemconfigure $id]
        set opcmd {}
        foreach opt $opts {
            set op [lindex $opt 0]
            set val [lindex $opt 4]
            
            # Empty val's except -fill can be stripped off.
            if {![string equal $op "-fill"] && ([string length $val] == 0)} {
                continue
            }
            lappend opcmd $op $val
        }
        set co [$wcan coords $id]
        set cmd [concat "create" $type $co $opcmd]
        append xml "\t[eval {can2svg $cmd} $args]\n"        

    }
#Перемещвем в начальные координаты
#    moveGroupSVG $x1  $y1
#puts "can2svg::group2file: groupX=$groupX groupY=$groupY"
    unset groupX
    unset groupY

    set datasvg [makedocument $argsA(-width) $argsA(-height) $xml]

    if {$path != "-image"} {
	puts $fd $datasvg
	close $fd
	return $path
    } else {
	return $datasvg
    }
}


# can2svg::MakeXML --
#
#       Creates raw xml data from a hierarchical list of xml code.
#       This proc gets called recursively for each child.
#       It makes also internal entity replacements on character data.
#       Mixed elements aren't treated correctly generally.
#       
# Arguments:
#       xmlList     a list of xml code in the format described in the header.
#       
# Results:
#       raw xml data.

proc can2svg::MakeXML {xmlList} {
        
    # Extract the XML data items.
    foreach {tag attrlist isempty chdata childlist} $xmlList {}
#LISSI
    if {$tag == "stop"} {
#puts "MakeXML: tag=$tag"
	set rawxml ""
	foreach {tag attrlist isempty chdata childlist} $xmlList {
	    append rawxml "<$tag"
	    foreach {attr value} $attrlist {
    		append rawxml " ${attr}='${value}'"
	    }
    	    append rawxml "/>"
	}
        return $rawxml

    }

    set rawxml "<$tag"
    foreach {attr value} $attrlist {
        append rawxml " ${attr}='${value}'"
    }
    if {$isempty} {
        append rawxml "/>"
        return $rawxml
    } else {
        append rawxml ">"
    }
    
    # Call ourselves recursively for each child element. 
    # There is an arbitrary choice here where childs are put before PCDATA.
    foreach child $childlist {
        append rawxml [MakeXML $child]
    }
    
    # Make standard entity replacements.
    if {[string length $chdata]} {
        append rawxml [XMLCrypt $chdata]
    }
    append rawxml "</$tag>"
    return $rawxml
}

# can2svg::MakeXMLList --
#
#       Build an element list given the tag and the args.
#
# Arguments:
#       tagname:    the name of this element.
#       args:       
#           -empty   0|1      Is this an empty tag? If $chdata 
#                             and $subtags are empty, then whether 
#                             to make the tag empty or not is decided 
#                             here. (default: 1)
#            -attrlist {attr1 value1 attr2 value2 ..}   Vars is a list 
#                             consisting of attr/value pairs, as shown.
#            -chdata $chdata   ChData of tag (default: "").
#            -subtags {$subchilds $subchilds ...} is a list containing xmldata
#                             of $tagname's subtags. (default: no sub-tags)
#       
# Results:
#       a list suitable for can2svg::MakeXML.

proc can2svg::MakeXMLList {tagname args} {
        
    # Fill in the defaults.
    array set xmlarr {-isempty 1 -attrlist {} -chdata {} -subtags {}}
    
    # Override the defults with actual values.
    if {[llength $args] > 0} {
        array set xmlarr $args
    }
    if {!(($xmlarr(-chdata) eq "") && ($xmlarr(-subtags) eq ""))} {
        set xmlarr(-isempty) 0
    }
    
    # Build sub elements list.
    set sublist [list]
    foreach child $xmlarr(-subtags) {
        lappend sublist $child
    }
    set xmlList [list $tagname $xmlarr(-attrlist) $xmlarr(-isempty)  \
      $xmlarr(-chdata) $sublist]
    return $xmlList
}

# can2svg::XMLCrypt --
#
#       Makes standard XML entity replacements.
#
# Arguments:
#       chdata:     character data.
#       
# Results:
#       chdata with XML standard entities replaced.

proc can2svg::XMLCrypt {chdata} {

    foreach from {\& < > {"} {'}}   \
      to {{\&amp;} {\&lt;} {\&gt;} {\&quot;} {\&apos;}} {
        regsub -all $from $chdata $to chdata
    }        
    return $chdata
}

# can2svg::FileUriFromLocalFile --
#
#       Not foolproof!

proc can2svg::FileUriFromLocalFile {path} {
        
    # Quote the disallowed characters according to the RFC for URN scheme.
    # ref: RFC2141 sec2.2
    return file://[uriencode::quotepath $path]
}

# can2svg::HttpFromLocalFile --
#
#       Translates an absolute file path to an uri encoded http address.

proc can2svg::HttpFromLocalFile {path} {
    variable confopts
    
    set relPath [::tfileutils::relative $confopts(-httpbasedir) $path]
    set relPath [uriencode::quotepath $relPath]
    return "http://$confopts(-httpaddr)/$relPath"
}

#-------------------------------------------------------------------------------

#  svg2can.tcl ---
#  
#      This file provides translation from canvas commands to XML/SVG format.
#      
#  Copyright (c) 2004-2007  Mats Bengtsson
#  
#  This file is distributed under BSD style license.
#
# $Id: svg2can.tcl,v 1.42 2008-02-06 13:57:24 matben Exp $
# 
# ########################### USAGE ############################################
#
#   NAME
#      svg2can - translate XML/SVG to canvas command.
#      
#   SYNOPSIS
#      svg2can::parsesvgdocument xmllist
#      svg2can::parseelement xmllist
#      
#
# ########################### CHANGES ##########################################
#
#   0.1      first release
#   0.2      starting support for tkpath package
#
# ########################### TODO #############################################
#
#       A lot...
#
# ########################### INTERNALS ########################################
# 
# The whole parse tree is stored as a hierarchy of lists as:
# 
#       xmllist = {tag attrlist isempty cdata {child1 child2 ...}}

# We need URN decoding for the file path in images. From my whiteboard code.

package require uriencode

package provide svg2can 1.0

namespace eval svg2can {

    variable confopts
    array set confopts {
        -foreignobjecthandler ""
        -httphandler          ""
        -imagehandler         ""
        -imagehandlerex       ""
    }

    variable textAnchorMap
    array set textAnchorMap {
        start   w
        middle  c
        end     e
    }
    
    variable fontWeightMap 
    array set fontWeightMap {
        normal    normal
        bold      bold
        bolder    bold
        lighter   normal
        100       normal
        200       normal
        300       normal
        400       normal
        500       normal
        600       bold
        700       bold
        800       bold
        900       bold
    }
    
    # We need to have a temporary tag for doing transformations.
    variable tmptag _tmp_transform
    variable pi 3.14159265359
    variable degrees2Radians [expr {2*$pi/360.0}]
    variable systemFont

    switch -- $::tcl_platform(platform) {
        unix {
            set systemFont {Helvetica 10}
            if {[package vcompare [info tclversion] 8.3] == 1} {        
                if {[string equal [tk windowingsystem] "aqua"]} {
                    set systemFont system
                }
            }
        }
        windows {
            set systemFont system
        }
    }
    
    variable priv
    set priv(havetkpath) 0
    if {![catch {package require tkpath 0.2.8}]} {
        set priv(havetkpath) 1
    }

    # We don't want it now.
    set priv(havetkpath) 0

    variable chache
    variable cache_key ""
}

# svg2can::config --
# 
#       Processes the configuration options.

proc svg2can::config {args} {
    variable confopts
    
    set options [lsort [array names confopts -*]]
    set usage [join $options ", "]
    if {[llength $args] == 0} {
        set result {}
        foreach name $options {
            lappend result $name $confopts($name)
        }
        return $result
    }
    regsub -all -- - $options {} options
    set pat ^-([join $options |])$
    if {[llength $args] == 1} {
        set flag [lindex $args 0]
        if {[regexp -- $pat $flag]} {
            return $confopts($flag)
        } else {
            return -code error "Unknown option $flag, must be: $usage"
        }
    } else {
        foreach {flag value} $args {
            if {[regexp -- $pat $flag]} {
                set confopts($flag) $value
            } else {
                return -code error "Unknown option $flag, must be: $usage"
            }
        }
    }
}

# svg2can::cache_* --
# 
#       A few routines to handle the caching of images and gradients.
#       Useful for garbage collection. Cache stuff per key which is typically
#       a widget path, and then do:
#       svg2can::cache_set_key $w
#       bind $w <Destroy> +[list svg2can::cache_free $w]
#       This works only if parsing svg docs in one shot.

proc svg2can::cache_set_key {key} {
    variable cache_key
    set cache_key $key
}

proc svg2can::cache_get_key {} {
    variable cache_key
    return $cache_key
}

proc svg2can::cache_get {$key} {
    variable cache
    if {[info exists cache($key)]} {
        return $cache($key)
    } else {
        return [list]
    }
}

proc svg2can::cache_add {type token} {
    variable cache
    variable cache_key
    lappend cache($cache_key) [list $type $token]
}

proc svg2can::cache_free {key} {
    variable cache
    
    if {![info exists cache($key)]} {
        return
    }
    foreach spec $cache($key) {
        set type [lindex $spec 0]
        set token [lindex $spec 1]
        switch -- $type {
            image {
                image delete $token
            }
            gradient {
                ::tkpath::gradient delete $token
            }
        }
    }
    set cache($key) [list]
}

proc svg2can::cache_reset {key} {
    variable cache
    set cache($key) [list]
}

# svg2can::parsesvgdocument --
# 
# 
# Arguments:
#       xmllist     the parsed document as a xml list
#       args        configuration options
#          -httphandler
#               -imagehandler            
#       
# Results:
#       a list of canvas commands without the widgetPath

proc svg2can::parsesvgdocument {xmllist args} {
    variable confopts
    variable priv

    array set argsA [array get confopts]
    array set argsA $args
    set paropts [array get argsA]
        
    set ans {}
    foreach c [getchildren $xmllist] {
        if {$priv(havetkpath)} {
            set ans [concat $ans [ParseElemRecursiveEx $c $paropts {}]]
        } else {
            set ans [concat $ans [ParseElemRecursive $c $paropts {}]]
        }
    }
    return $ans
}

# svg2can::parseelement --
# 
#       External interface for parsing a single element.
# 
# Arguments:
#       xmllist     the elements xml list
#       args        configuration options
#          -httphandler
#               -imagehandler            
#               -imagehandlerex            
#       
# Results:
#       a list of canvas commands without the widgetPath

proc svg2can::parseelement {xmllist args} {
    variable confopts
    variable priv

    array set argsA [array get confopts]
    array set argsA $args
    set paropts [array get argsA]
    if {$priv(havetkpath)} {    
        return [ParseElemRecursiveEx $xmllist $paropts {}]
    } else {
        return [ParseElemRecursive $xmllist $paropts {}]
    }
}

# svg2can::ParseElemRecursive --
# 
#       Parses element for internal usage.
#       
# Arguments:
#       xmllist     the elements xml list
#       paropts     parse options
#       transformL
#       args        list of attributes from any enclosing element (g).
#       
# Results:
#       a list of canvas commands without the widgetPath

proc svg2can::ParseElemRecursive {xmllist paropts transformL args} {

    set cmdList [list]
    set tag [gettag $xmllist]
    
    # Handle any transform attribute; may be recursive, so keep a list.
    set transformL [concat $transformL [ParseTransformAttr [getattr $xmllist]]]

    switch -- $tag {
        circle - ellipse - image - line - polyline - polygon - rect - path - text {
            set func [string totitle $tag]
            set cmdL [eval {Parse${func} $xmllist $paropts $transformL} $args]
            set cmdList [concat $cmdList $cmdL]
        }
        a - g {
            
            # Need to collect the attributes for the g element since
            # the child elements inherit them. g elements may be nested!
            # Must parse any style to the actual attribute names.
            array set attrA $args
            array set attrA [getattr $xmllist]
            unset -nocomplain attrA(id)
            if {[info exists attrA(style)]} {
                array set attrA [StyleAttrToList $attrA(style)]
            }
            foreach c [getchildren $xmllist] {
                set cmdList [concat $cmdList [eval {
                    ParseElemRecursive $c $paropts $transformL
                } [array get attrA]]]
            }            
        }
        foreignObject {
            array set parseArr $paropts
            if {[string length $parseArr(-foreignobjecthandler)]} {
                set elem [uplevel #0 $parseArr(-foreignobjecthandler) \
                  [list $xmllist $paropts $transformL] $args]
                if {$elem != ""} {
                    set cmdList [concat $cmdList $elem]
                }
            }
        }
        use - defs - marker - symbol {
            # todo
        }
    }
    return $cmdList
}

# svg2can::ParseElemRecursiveEx --
# 
#       Same for tkpath...
#       
# Arguments:
#       transAttr   this is a list of transform attributes

proc svg2can::ParseElemRecursiveEx {xmllist paropts transAttr args} {

    set cmdList [list]
    set tag [gettag $xmllist]
    
    switch -- $tag {
        circle - ellipse - image - line - polyline - polygon - rect - path - text {
            set func [string totitle $tag]
            set cmd [eval {Parse${func}Ex $xmllist $paropts $transAttr} $args]
            if {[llength $cmd]} {
                lappend cmdList $cmd
            }
        }
        a - g {
            
            # Need to collect the attributes for the g element since
            # the child elements inherit them. g elements may be nested!
            # Must parse any style to the actual attribute names.
            array set attrA $args
            array set attrA [getattr $xmllist]
            unset -nocomplain attrA(id)
            if {[info exists attrA(style)]} {
                array set attrA [StyleAttrToList $attrA(style)]
            }
            if {[info exists attrA(transform)]} {
                eval {lappend transAttr} [TransformAttrToList $attrA(transform)]
                unset attrA(transform)
            }
            foreach c [getchildren $xmllist] {
                set cmdList [concat $cmdList [eval {
                    ParseElemRecursiveEx $c $paropts $transAttr
                } [array get attrA]]]
            }            
        }
        linearGradient {
            CreateLinearGradient $xmllist
        }
        radialGradient {
            CreateRadialGradient $xmllist
        }
        foreignObject {
            array set parseArr $paropts
            if {[string length $parseArr(-foreignobjecthandler)]} {
                set elem [uplevel #0 $parseArr(-foreignobjecthandler) \
                  [list $xmllist $paropts $transformL] $args]
                if {$elem != ""} {
                    set cmdList [concat $cmdList $elem]
                }
            }
        }
        defs {
            eval {ParseDefs $xmllist $paropts $transAttr} $args
        }
        use - marker - symbol {
            # todo
        }
    }
    return $cmdList
}

proc svg2can::ParseDefs {xmllist paropts transAttr args} {
    
    # @@@ Only gradients so far.
    
    foreach c [getchildren $xmllist] {
        set tag [gettag $c]
    
        switch -- $tag {
            linearGradient {
                CreateLinearGradient $c
            }
            radialGradient {
                CreateRadialGradient $c
            }
        }
    }    
}

# svg2can::ParseCircle, ParseEllipse, ParseLine, ParseRect, ParsePath, 
#   ParsePolyline, ParsePolygon, ParseImage --
# 
#       Makes the necessary canvas commands needed to reproduce the
#       svg element.
#       
# Arguments:
#       xmllist
#       paropts     parse options
#       transformL
#       args        list of attributes from any enclosing element (g).
#       
# Results:
#       list of canvas create command without the widgetPath.

proc svg2can::ParseCircle {xmllist paropts transformL args} {
    variable tmptag
    
    set opts {}
    set presAttr {}
    set cx 0
    set cy 0
    set r 0
    array set attrA $args
    array set attrA [getattr $xmllist]
    
    # We need to have a temporary tag for doing transformations.
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }
    
    foreach {key value} [array get attrA] {        
        switch -- $key {
            cx - cy - r {
                set $key [parseLength $value]
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts oval [StyleAttrToList $value]]
            }
            default {
                # Valid itemoptions will be sorted out below.
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags
    set coords [list [expr {$cx - $r}] [expr {$cy - $r}] \
      [expr {$cx + $r}] [expr {$cy + $r}]]        
    set opts [MergePresentationAttr oval $opts $presAttr]
    set cmdList [list [concat create oval $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParseCircleEx {xmllist paropts transAttr args} {

    set opts {}
    set cx 0
    set cy 0
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]

    foreach {key value} [array get attrA] {        
        switch -- $key {
            cx - cy {
                set $key [parseLength $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create circle $cx $cy $opts]
}

proc svg2can::ParseEllipse {xmllist paropts transformL args} {
    variable tmptag
    
    set opts {}
    set presAttr {}
    set cx 0
    set cy 0
    set rx 0
    set ry 0
##########
puts "svg2can::ParseEllipse 1 args=$args"
#    array set attrA $args
    array set attrA [lindex $args 0]
#########

    array set attrA [getattr $xmllist]
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }
    
    foreach {key value} [array get attrA] {
        
        switch -- $key {
            cx - cy - rx - ry {
                set $key [parseLength $value]
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts oval [StyleAttrToList $value]]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags
    set coords [list [expr $cx - $rx] [expr $cy - $ry] \
      [expr $cx + $rx] [expr $cy + $ry]]
    set opts [MergePresentationAttr oval $opts $presAttr]
    set cmdList [list [concat create oval $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParseEllipseEx {xmllist paropts transAttr args} {

    set opts {}
    set cx 0
    set cy 0
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]

    foreach {key value} [array get attrA] {        
        switch -- $key {
            cx - cy {
                set $key [parseLength $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create ellipse $cx $cy $opts]    
}

proc svg2can::ParseImage {xmllist paropts transformL args} {
    variable tmptag
    
    set x 0
    set y 0    
    set presAttr {}
    set photo {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    array set paroptsA $paropts
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }

    foreach {key value} [array get attrA] {        
        switch -- $key {
            x - y - height - width {
                # The canvas image item does not have width and height.
                # These are REQUIRED in SVG.
                set $key [parseLength $value]
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts image [StyleAttrToList $value]]
            }
            xlink:href {
                set xlinkhref $value
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags -anchor nw
    set opts [MergePresentationAttr image $opts $presAttr]

    if {[string length $paroptsA(-imagehandlerex)]} {                    
        uplevel #0 $paroptsA(-imagehandlerex) [list $xmllist $opts]
        return
    }
    
    # Handle the xlink:href attribute.
    if {[info exists xlinkhref]} {
        
        switch -glob -- $xlinkhref {
            file:/* {                        
                set path [::uri::urn::unquote $xlinkhref]
                set path [string map {file:/// /} $path]
                if {[string length $paroptsA(-imagehandler)]} {                    
                    set cmd [concat create image $x $y $opts]
                    lappend cmd -file $path -height $height -width $width
                    set photo [uplevel #0 $paroptsA(-imagehandler) [list $cmd]]
                    lappend opts -image $photo
                } else {                        
                    if {[string tolower [file extension $path]] eq ".gif"} {
                        set photo [image create photo -file $path -format gif]
                        cache_add image $photo
                    } else {
                        set photo [image create photo -file $path]
                        cache_add image $photo
                    }
                    lappend opts -image $photo
                }
            }
            http:/* {
                if {[string length $paroptsA(-httphandler)]} {
                    set cmd [concat create image $x $y $opts]
                    lappend cmd -url $xlinkhref  -height $height -width $width
                    uplevel #0 $paroptsA(-httphandler) [list $cmd]
                }
                return
            }
            default {
                return
            }
        }        
    }
    set cmd [concat create image $x $y $opts]
    set cmdList [list $cmd]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParseImageEx {xmllist paropts transAttr args} {

    set x 0
    set y 0    
    set width  0
    set height 0
    set opts {}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    array set paroptsA $paropts

    foreach {key value} [array get attrA] {        
        switch -- $key {
            x - y {
                set $key [parseLength $value]
            }
            height - width {
                # A value of 0 disables rendering in SVG.
                # tkpath uses 0 for using natural sizes.
                if {$value == 0.0} {
                    return
                }
                set $key [parseLength $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            xlink:href {
                set xlinkhref $value
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -width $width -height $height
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    if {[string length $paroptsA(-imagehandlerex)]} {                    
        uplevel #0 $paroptsA(-imagehandlerex) [list $xmllist $opts]
        return
    }

    # Handle the xlink:href attribute.
    if {[info exists xlinkhref]} {

        switch -glob -- $xlinkhref {
            file:/* {                        
                set path [::uri::urn::unquote $xlinkhref]
                set path [string map {file:/// /} $path]
                if {[string length $paroptsA(-imagehandler)]} {                    
                    set cmd [concat create image $x $y $opts]
                    lappend cmd -file $path -height $height -width $width
                    set photo [uplevel #0 $paroptsA(-imagehandler) [list $cmd]]
                    lappend opts -image $photo
                } else {                        
                    if {[string tolower [file extension $path]] eq ".gif"} {
                        set photo [image create photo -file $path -format gif]
                        cache_add image $photo
                    } else {
                        set photo [image create photo -file $path]
                        cache_add image $photo
                    }
                    lappend opts -image $photo
                }
            }
            http:/* {
                if {[string length $paroptsA(-httphandler)]} {
                    set cmd [concat create image $x $y $opts]
                    lappend cmd -url $xlinkhref -height $height -width $width
                    uplevel #0 $paroptsA(-httphandler) [list $cmd]
                }
                return
            }
            default {
                return
            }
        }        
    }
    
    set opts [MergePresentationAttrEx $opts $presAttr]
    return [concat create pimage $x $y $opts]    
}

proc svg2can::ParseLine {xmllist paropts transformL args} {
    variable tmptag
    
    set opts {}
    set coords {0 0 0 0}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }
    
    foreach {key value} [array get attrA] {
        
        switch -- $key {
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts line [StyleAttrToList $value]]
            }
            x1 {
                lset coords 0 [parseLength $value]
            }
            y1 {
                lset coords 1 [parseLength $value]
            }
            x2 {
                lset coords 2 [parseLength $value]
            }
            y2 {
                lset coords 3 [parseLength $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags
    set opts [MergePresentationAttr line $opts $presAttr]  
    set cmdList [list [concat create line $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParseLineEx {xmllist paropts transAttr args} {

    set x1 0
    set y1 0
    set x2 0
    set y2 0
    set opts {}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]

    foreach {key value} [array get attrA] {        
        switch -- $key {
            x1 - y1 - x2 - y2 {
                set $key [parseLength $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr] 1]
    return [concat create pline $x1 $y1 $x2 $y2 $opts]    
}

proc svg2can::ParsePath {xmllist paropts transformL args} {
    variable tmptag
#puts "svg2can::ParsePath $xmllist $paropts $transformL $args"
    set cmdList {}
    set opts {}
    set presAttr {}
    set path {}
    set styleList {}
    set lineopts {}
    set polygonopts {}
#puts "svg2can::ParsePath 1 args=$args"
#    array set attrA $args
    array set attrA [lindex $args 0]

#puts "svg2can::ParsePath 2"
#parray attrA
    array set attrA [getattr $xmllist]
#puts "svg2can::ParsePath 3"
#parray attrA
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }
#parray attrA
    foreach {key value} [array get attrA] {
        
        switch -- $key {
            d {
                set path $value
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                # Need to parse separately for each canvas item since different
                # default values.
                set lineopts    [StyleToOpts line    [StyleAttrToList $value]]
                set polygonopts [StyleToOpts polygon [StyleAttrToList $value]]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }

    # The resulting canvas items are typically lines and polygons.
    # Since the style parsing is different keep separate copies.
    lappend lineopts    -tags $tags
    lappend polygonopts -tags $tags
    set lineopts    [MergePresentationAttr line    $lineopts    $presAttr]
    set polygonopts [MergePresentationAttr polygon $polygonopts $presAttr]
    
    # Parse the actual path data. 
    set co {}
    set cantype line
    set itemopts {}
    
    regsub -all -- {([a-zA-Z])([0-9])} $path {\1 \2} path
    regsub -all -- {([0-9])([a-zA-Z])} $path {\1 \2} path
    set path [string map {- " -"} $path]
    set path [string map {, " "} $path]
    
    set i 0
    set len  [llength $path]
    set len1 [expr $len - 1]
    set len2 [expr $len - 2]
    set len4 [expr $len - 4]
    set len6 [expr $len - 6]
    
    # 'i' is the index into the path list; points to the command (character).
    
    while {$i < $len} {
        set elem [lindex $path $i]
        set isabsolute 1
        if {[string is lower $elem]} {
            set isabsolute 0
        }
        
        switch -glob -- $elem {
            A - a {
                # Not part of Tiny SVG.
                incr i
                foreach {rx ry phi fa fs x y} [lrange $path $i [expr $i + 6]] break
                if {!$isabsolute} {
                    set x [expr $cpx + $x] 
                    set y [expr $cpy + $y]
                    
                }
                set arcpars \
                  [EllipticArcParameters $cpx $cpy $rx $ry $phi $fa $fs $x $y]
                
                # Handle special cases.
                switch -- $arcpars {
                    skip {
                        # Empty
                    }
                    lineto {
                        lappend co [lindex $path [expr $i + 5]] \
                          [lindex $path [expr $i + 6]]
                    }
                    default {
                        
                        # Need to end any previous path.
                        if {[llength $co] > 2} {
                            set opts [concat [set ${cantype}opts] $itemopts]
                            lappend cmdList [concat create $cantype $co $opts]
                        }

                        # Cannot handle rotations.
                        foreach {cx cy rx ry theta delta phi} $arcpars break
                        set box [list [expr $cx-$rx] [expr $cy-$ry] \
                          [expr $cx+$rx] [expr $cy+$ry]]
                        set itemopts [list -start $theta -extent $delta]
                        
                        # Try to interpret any subsequent data as a
                        # -style chord | pieslice.
                        # Z: chord; float float Z: pieslice.
                        set ia [expr $i + 7]
                        set ib [expr $i + 10]
                        
                        if {[regexp -nocase {z} [lrange $path $ia $ia]]} {
                            lappend itemopts -style chord
                            incr i 1
                        } elseif {[regexp -nocase {l +([-0-9\.]+) +([-0-9\.]+) +z} \
                          [lrange $path $ia $ib] m mx my] &&  \
                          [expr hypot($mx-$cx, $my-$cy)] < 4.0} {
                            lappend itemopts -style pieslice
                            incr i 4
                        } else {
                            lappend itemopts -style arc
                        }
                        set opts [concat $polygonopts $itemopts]
                        lappend cmdList [concat create arc $box $opts]
                        set co {}
                        set itemopts {}
                    }
                }
                incr i 6
            }
            C - c {
                # We could have a sequence of pairs of points here...
                # Approximate by quadratic bezier.
                # There are three options here: 
                # C (p1 p2 p3) (p4 p5 p6)...           finalize item
                # C (p1 p2 p3) S (p4 p5)...            let S trigger below
                # C p1 p2 p3 anything else             finalize here
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len6)} {
                    set co [list $cpx $cpy] 
                    if {$isabsolute} {
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        set cpx [lindex $co end-1]
                        set cpy [lindex $co end]
                    } else {
                        PathAddRelative $path co i cpx cpy
                        PathAddRelative $path co i cpx cpy
                        PathAddRelative $path co i cpx cpy
                    }
                    
                    # Do not finalize item if S instruction.
                    if {![string equal -nocase [lindex $path [expr $i+1]] "S"]} {
                        lappend itemopts -smooth 1
                        set opts [concat $lineopts $itemopts]
                        lappend cmdList [concat create line $co $opts]
                        set co {}
                        set itemopts {}
                    }
                }
                incr i
            }
            H {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len1)} {
                    lappend co [lindex $path [incr i]] $cpy
                }
                incr i
            }
            h {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len1)} {
                    lappend co [expr $cpx + [lindex $path [incr i]]] $cpy
                }
                incr i
            }
            L - {[0-9]+} - {-[0-9]+} {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len2)} {
                    lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                }
                incr i
            }
            l {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len2)} {
                    lappend co [expr $cpx + [lindex $path [incr i]]] \
                      [expr $cpy + [lindex $path [incr i]]]
                }
                incr i
            }
            M - m {
                # Make a fresh canvas item and finalize any previous command.
                if {[llength $co]} {
                    set opts [concat [set ${cantype}opts] $itemopts]
                    lappend cmdList [concat create $cantype $co $opts]
                }
                if {!$isabsolute && [info exists cpx]} {
                    set co [list  \
                      [expr $cpx + [lindex $path [incr i]]]
                      [expr $cpy + [lindex $path [incr i]]]]
                } else {
                    set co [list [lindex $path [incr i]] [lindex $path [incr i]]]
                }
                set itemopts {}
                incr i
            }
            Q - q {
                # There are three options here: 
                # Q p1 p2 p3 p4...           finalize item
                # Q p1 p2 T p3...            let T trigger below
                # Q p1 p2 anything else      finalize here
                
                # We may have a sequence of pairs of points following the Q.
                # Make a fresh item for each.
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len4)} {
                    set co [list $cpx $cpy] 
                    if {$isabsolute} {
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        set cpx [lindex $co end-1]
                        set cpy [lindex $co end]
                    } else {
                        PathAddRelative $path co i cpx cpy
                        PathAddRelative $path co i cpx cpy
                    }
                    
                    # Do not finalize item if T instruction.
                    if {![string equal -nocase [lindex $path [expr $i+1]] "T"]} {
                        lappend itemopts -smooth 1
                        set opts [concat $lineopts $itemopts]
                        lappend cmdList [concat create line $co $opts]
                        set co {}
                        set itemopts {}
                    }
                }
                incr i
            }
            S - s {
                # Must annihilate last point added and use its mirror instead.
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len4)} {
                    
                    # Control point from mirroring.
                    set ctrlpx [expr 2 * $cpx - [lindex $co end-3]]
                    set ctrlpy [expr 2 * $cpy - [lindex $co end-2]]
                    lset co end-1 $ctrlpx
                    lset co end $ctrlpy
                    if {$isabsolute} {
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        set cpx [lindex $co end-1]
                        set cpy [lindex $co end]
                    } else {
                        PathAddRelative $path co i cpx cpy
                        PathAddRelative $path co i cpx cpy
                    }
                }
                
                # Finalize item.
                lappend itemopts -smooth 1
                set dx [expr [lindex $co 0] - [lindex $co end-1]]
                set dy [expr [lindex $co 1] - [lindex $co end]]
                
                # Check endpoints to see if closed polygon.
                # Remove first AND end points if closed!
                if {[expr hypot($dx, $dy)] < 0.5} {
                    set opts [concat $polygonopts $itemopts]
                    set co [lrange $co 2 end-2]
                    lappend cmdList [concat create polygon $co $opts]
                } else {
                    set opts [concat $lineopts $itemopts]
                    lappend cmdList [concat create line $co $opts]
                }
                set co {}
                set itemopts {}
                incr i
            }
            T - t {
                # Must annihilate last point added and use its mirror instead.
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len2)} {
                    
                    # Control point from mirroring.
                    set ctrlpx [expr 2 * $cpx - [lindex $co end-3]]
                    set ctrlpy [expr 2 * $cpy - [lindex $co end-2]]
                    lset co end-1 $ctrlpx
                    lset co end $ctrlpy
                    if {$isabsolute} {
                        lappend co [lindex $path [incr i]] [lindex $path [incr i]]
                        set cpx [lindex $co end-1]
                        set cpy [lindex $co end]
                    } else {
                        PathAddRelative $path co i cpx cpy
                    }
                }                
                
                # Finalize item.
                lappend itemopts -smooth 1
                set dx [expr [lindex $co 0] - [lindex $co end-1]]
                set dy [expr [lindex $co 1] - [lindex $co end]]
                
                # Check endpoints to see if closed polygon.
                # Remove first AND end points if closed!
                if {[expr hypot($dx, $dy)] < 0.5} {
                    set opts [concat $polygonopts $itemopts]
                    set co [lrange $co 2 end-2]
                    lappend cmdList [concat create polygon $co $opts]
                } else {
                    set opts [concat $lineopts $itemopts]
                    lappend cmdList [concat create line $co $opts]                    
                }
                set co {}
                set itemopts {}
                incr i
            }
            V {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len1)} {
                    lappend co $cpx [lindex $path [incr i]]
                }
                incr i
            }
            v {
                while {![regexp {[a-zA-Z]} [lindex $path [expr $i+1]]] && \
                  ($i < $len1)} {
                    lappend co $cpx [expr $cpy + [lindex $path [incr i]]]
                }
                incr i
            }
            Z - z {
                if {[llength $co]} {
                    set opts [concat $polygonopts $itemopts]
                    lappend cmdList [concat create polygon $co $opts]
                }
                set cantype line
                set itemopts {}
                incr i
                set co {}
            }
            default {
                # ?
                incr i
            }
        }   ;# End switch.
        
        # Keep track of the pens current point.
        if {[llength $co]} {
            set cpx [lindex $co end-1]
            set cpy [lindex $co end]
        }
    }   ;# End while loop.
    
    # Finalize the last element if any.
    if {[llength $co]} {
        set opts [concat [set ${cantype}opts] $itemopts]
        lappend cmdList [concat create $cantype $co $opts]
    }
    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParsePathEx {xmllist paropts transAttr args} {
    
    set opts {}
    set presAttr {}
    set path {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    
    foreach {key value} [array get attrA] {
        switch -- $key {
            d { 
                set path [parsePathAttr $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value 
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create path [list $path] $opts]
}

# Handle different defaults for fill and stroke.

proc svg2can::StrokeFillDefaults {opts {noFill 0}} {

    array set optsA $opts
    if {!$noFill && ![info exists optsA(-fill)]} {
        set optsA(-fill) black
    }
    if {[info exists optsA(-fillgradient)]} {
        unset -nocomplain optsA(-fill)
    }
    if {![info exists optsA(-stroke)]} {
        set optsA(-stroke) {}
    }
    return [array get optsA]
}

proc svg2can::ParsePolyline {xmllist paropts transformL args} {
    variable tmptag
    
    set coords {}
    set opts {}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }

    foreach {key value} [array get attrA] {
        
        switch -- $key {
            points {
                set coords [PointsToList $value]
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts line [StyleAttrToList $value]]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags
    set opts [MergePresentationAttr line $opts $presAttr]
    set cmdList [list [concat create line $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParsePolylineEx {xmllist paropts transAttr args} {

    set opts {}
    set points {0 0}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]

    foreach {key value} [array get attrA] {        
        switch -- $key {
            points {
                set points [PointsToList $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create polyline $points $opts]    
}

proc svg2can::ParsePolygon {xmllist paropts transformL args} {
    variable tmptag
    
    set coords {}
    set opts {}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }

    foreach {key value} [array get attrA] {
        
        switch -- $key {
            points {
                set coords [PointsToList $value]
            }
            id {
                set tags [concat $tags $value]
            }
            style {
                set opts [StyleToOpts polygon [StyleAttrToList $value]]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    lappend opts -tags $tags
    set opts [MergePresentationAttr polygon $opts $presAttr]
    set cmdList [list [concat create polygon $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParsePolygonEx {xmllist paropts transAttr args} {

    set opts {}
    set points {0 0}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]

    foreach {key value} [array get attrA] {        
        switch -- $key {
            points {
                set points [PointsToList $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create ppolygon $points $opts]    
}

proc svg2can::ParseRect {xmllist paropts transformL args} {
    variable tmptag
    
    set opts {}
    set coords {0 0 0 0}
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    set tags {}
    if {[llength $transformL]} {
        lappend tags $tmptag
    }
    
    foreach {key value} [array get attrA] {
        
        switch -- $key {
            id {
                set tags [concat $tags $value]
            }
            rx - ry {
                # unsupported :-(
            }
            style {
                set opts [StyleToOpts rectangle [StyleAttrToList $value]]
            }
            x - y - width - height {
                set $key [parseLength $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[info exists x]} {
        lset coords 0 $x
    }
    if {[info exists y]} {
        lset coords 1 $y
    }
    if {[info exists width]} {
        lset coords 2 [expr [lindex $coords 0] + $width]
    }
    if {[info exists height]} {
        lset coords 3 [expr [lindex $coords 1] + $height]
    }
    lappend opts -tags $tags
    set opts [MergePresentationAttr rectangle $opts $presAttr]
    set cmdList [list [concat create rectangle $coords $opts]]

    return [AddAnyTransformCmds $cmdList $transformL]
}

proc svg2can::ParseRectEx {xmllist paropts transAttr args} {

    set opts {}
    set x 0
    set y 0
    set width  0
    set height 0
    set presAttr {}
    array set attrA $args
    array set attrA [getattr $xmllist]
    
    foreach {key value} [array get attrA] {        
        switch -- $key {
            x - y - width - height {
                set $key [parseLength $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                eval {lappend opts} [StyleToOptsEx [StyleAttrToList $value]]
            }
            transform {
                eval {lappend transAttr} [TransformAttrToList $value]
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    if {[llength $transAttr]} {
        lappend opts -matrix [TransformAttrListToMatrix $transAttr]
    }
    set x2 [expr {$x + $width}]
    set y2 [expr {$y + $height}]
    set opts [StrokeFillDefaults [MergePresentationAttrEx $opts $presAttr]]
    return [concat create prect $x $y $x2 $y2 $opts]    
}

# svg2can::ParseText --
# 
#       Takes a text element and returns a list of canvas create text commands.
#       Assuming that chdata is not mixed with elements, we should now have
#       either chdata OR more elements (tspan).

proc svg2can::ParseText {xmllist paropts transformL args} {
    set x 0
    set y 0
    set xAttr 0
    set yAttr 0
    set cmdList [ParseTspan $xmllist $transformL x y xAttr yAttr {}]
    return $cmdList
}

proc svg2can::ParseTextEx {xmllist paropts transAttr args} {
    return [eval {ParseText $xmllist $paropts {}} $args]
}

# svg2can::ParseTspan --
# 
#       Takes a tspan or text element and returns a list of canvas
#       create text commands.

proc svg2can::ParseTspan {xmllist transformL xVar yVar xAttrVar yAttrVar opts} { 
    variable tmptag
    variable systemFont
    upvar $xVar x
    upvar $yVar y
    upvar $xAttrVar xAttr
    upvar $yAttrVar yAttr

    # Nested tspan elements do not inherit x, y, dx, or dy attributes set.
    # Sibling tspan elements do inherit x, y attributes.
    # Keep two separate sets of x and y; (x,y) and (xAttr,yAttr):
    # (x,y) 
    
    # Inherit opts.
    array set optsA $opts
    array set optsA [ParseTextAttr $xmllist xAttr yAttr baselineShift]

    set tag [gettag $xmllist]
    set childList [getchildren $xmllist]
    set cmdList {}
    if {[string equal $tag "text"]} {
        set x $xAttr
        set y $yAttr
    }
    
    if {[llength $childList]} {
        
        # Nested tspan elements do not inherit x, y set via attributes.
        if {[string equal $tag "tspan"]} {
            set xAttr $x
            set yAttr $y
        }
        set opts [array get optsA]
        foreach c $childList {
            
            switch -- [gettag $c] {
                tspan {
                    set cmdList [concat $cmdList \
                      [ParseTspan $c $transformL x y xAttr yAttr $opts]]
                }
                default {
                    # empty
                }
            }
        }
    } else {
        set str [getcdata $xmllist]
        set optsA(-text) $str
        if {[llength $transformL]} {
            lappend optsA(-tags) $tmptag
        }
        set opts [array get optsA]
        set theFont $systemFont
        if {[info exists optsA(-font)]} {
            set theFont $optsA(-font)
        }
        
        # Need to adjust the text position so that the baseline matches y.
        # nw to baseline
        set ascent [font metrics $theFont -ascent]
        set cmdList [list [concat create text  \
          $xAttr [expr $yAttr - $ascent + $baselineShift] $opts]]        
        set cmdList [AddAnyTransformCmds $cmdList $transformL]
        
        # Each text insert moves both the running coordinate sets.
        # newlines???
        set deltax [font measure $theFont $str]
        set x     [expr $x + $deltax]
        set xAttr [expr $xAttr + $deltax]
    }
    return $cmdList
}

# svg2can::ParseTextAttr --
# 
#       Parses the attributes in xmllist and returns the translated canvas
#       option list.

proc svg2can::ParseTextAttr {xmllist xVar yVar baselineShiftVar} {    
    variable systemFont
    upvar $xVar x
    upvar $yVar y
    upvar $baselineShiftVar baselineShift

    # svg defaults to start with y being the baseline while tk default is c.
    #set opts {-anchor sw}
    # Anchor nw is simplest when newlines.
    set opts {-anchor nw}
    set presAttr {}
    set baselineShift 0
    
    foreach {key value} [getattr $xmllist] {
        
        switch -- $key {
            baseline-shift {
                set baselineShiftSet $value
            }
            dx {
                set x [expr $x + $value]
            }
            dy {
                set y [expr $y + $value]
            }
            id {
                lappend opts -tags $value
            }
            style {
                set opts [concat $opts \
                  [StyleToOpts text [StyleAttrToList $value]]]
            }
            x - y {
                set $key $value
            }
            default {
                lappend presAttr $key $value
            }
        }
    }
    array set optsA $opts
    set theFont $systemFont
    if {[info exists optsA(-font)]} {
        set theFont $optsA(-font)
    }
    if {[info exists baselineShiftSet]} {
        set baselineShift [BaselineShiftToDy $baselineShiftSet $theFont]
    }
    return [MergePresentationAttr text $opts $presAttr]
}

# svg2can::AttrToCoords --
# 
#       Returns coords from SVG attributes.
#       
# Arguments:
#       type        SVG type
#       attr        list of geometry attributes
#       
# Results:
#       list of coordinates

proc svg2can::AttrToCoords {type attrlist} {
    
    # Defaults.
    array set attr {
        cx      0
        cy      0
        height  0
        r       0
        rx      0
        ry      0
        width   0
        x       0
        x1      0
        x2      0
        y       0
        y1      0
        y2      0
    }
    array set attr $attrlist
    
    switch -- $type {
        circle {
            set coords [list  \
              [expr $attr(cx) - $attr(r)] [expr $attr(cy) - $attr(r)] \
              [expr $attr(cx) + $attr(r)] [expr $attr(cy) + $attr(r)]]        
        }
        ellipse {
            set coords [list  \
              [expr $attr(cx) - $attr(rx)] [expr $attr(cy) - $attr(ry)] \
              [expr $attr(cx) + $attr(rx)] [expr $attr(cy) + $attr(ry)]]
        }
        image {
            set coords [list $attr(x) $attr(y)]
        }
        line {
            set coords [list $attr(x1) $attr(y1) $attr(x2) $attr(y2)]
        }
        path {
            # empty
        }
        polygon {
            set coords [PointsToList $attr(points)] 
        }
        polyline {
            set coords [PointsToList $attr(points)] 
        }
        rect {
            set coords [list $attr(x) $attr(y) \
              [expr $attr(x) + $attr(width)] [expr $attr(y) + $attr(height)]]
        }
        text {
            set coords [list $attr(x) $attr(y)]
        }
    }
    return $coords
}

# @@@ There is a lot TODO here!

proc svg2can::CreateLinearGradient {xmllist} {
    variable gradientIDToToken
    
    set x1 0
    set y1 0
    set x2 1
    set y2 0
    set method pad
    set units bbox
    set stops {}

    # We first need to find out if any xlink:href attribute since:
    # Any 'linearGradient' attributes which are defined on the
    # referenced element which are not defined on this element are 
    # inherited by this element.
    set attr [getattr $xmllist]
    set idx [lsearch -exact $attr xlink:href]
    if {$idx >= 0 && [expr {$idx % 2 == 0}]} {
        set value [lindex $attr [incr idx]]
        if {![string match {\#*} $value]} {
            return -code error "unrecognized gradient uri \"$value\""
        }
        set uri [string range $value 1 end]
        if {![info exists gradientIDToToken($uri)]} {
            return -code error "unrecognized gradient uri \"$value\""
        }
        set hreftoken $gradientIDToToken($uri)
        set units  [::tkpath::gradient cget $hreftoken -units]
        set method [::tkpath::gradient cget $hreftoken -method]
        set hrefstops [::tkpath::gradient cget $hreftoken -stops]
        foreach {x1 y1 x2 y2} \
          [::tkpath::gradient cget $hreftoken -lineartransition] { break }        
    }    
    
    foreach {key value} $attr {        
        switch -- $key {
            x1 - y1 - x2 - y2 {
                set $key [parseUnaryOrPercentage $value]
            }
            id {
                set id $value
            }
            gradientUnits {
                set units [string map \
                  {objectBoundingBox bbox userSpaceOnUse userspace} $value]
            }
            spreadMethod {
                set method $value
            }
        }
    }
    if {![info exists id]} {
        return
    }
    
    # If this element has no defined gradient stops, and the referenced element 
    # does, then this element inherits the gradient stop from the referenced 
    # element.
    set stops [ParseGradientStops $xmllist]    
    if {$stops eq {}} {
        if {[info exists hrefstops]} {
            set stops $hrefstops
        }
    }
    set token [::tkpath::gradient create linear -method $method -units $units \
      -lineartransition [list $x1 $y1 $x2 $y2] -stops $stops]
    set gradientIDToToken($id) $token
    cache_add gradient $token
}

proc svg2can::CreateRadialGradient {xmllist} {
    variable gradientIDToToken

    set cx 0.5
    set cy 0.5
    set r  0.5
    set fx 0.5
    set fy 0.5
    set method pad
    set units bbox
    set stops {}
    
    # We first need to find out if any xlink:href attribute since:
    # Any 'linearGradient' attributes which are defined on the
    # referenced element which are not defined on this element are 
    # inherited by this element.
    set attr [getattr $xmllist]
    set idx [lsearch -exact $attr xlink:href]
    if {$idx >= 0 && [expr {$idx % 2 == 0}]} {
        set value [lindex $attr [incr idx]]
        if {![string match {\#*} $value]} {
            return -code error "unrecognized gradient uri \"$value\""
        }
        set uri [string range $value 1 end]
        if {![info exists gradientIDToToken($uri)]} {
            return -code error "unrecognized gradient uri \"$value\""
        }
        set hreftoken $gradientIDToToken($uri)
        set units  [::tkpath::gradient cget $hreftoken -units]
        set method [::tkpath::gradient cget $hreftoken -method]
        set hrefstops [::tkpath::gradient cget $hreftoken -stops]
        set transL [::tkpath::gradient cget $hreftoken -radialtransition]
        set cx [lindex $transL 0]
        set cy [lindex $transL 1]
        if {[llength $transL] > 2} {
            set r [lindex $transL 2]
            if {[llength $transL] == 5} {
                set fx [lindex $transL 3]
                set fy [lindex $transL 4]
            }
        }
    }    

    foreach {key value} [getattr $xmllist] {        
        switch -- $key {
            cx - cy - r - fx - fy {
                set $key [parseUnaryOrPercentage $value]
            }
            id {
                set id $value
            }
            gradientUnits {
                set units [string map \
                  {objectBoundingBox bbox userSpaceOnUse userspace} $value]
            }
            spreadMethod {
                set method $value
            }
        }
    }
    if {![info exists id]} {
        return
    }
    # If this element has no defined gradient stops, and the referenced element 
    # does, then this element inherits the gradient stop from the referenced 
    # element.
    set stops [ParseGradientStops $xmllist]    
    if {$stops eq {}} {
        if {[info exists hrefstops]} {
            set stops $hrefstops
        }
    }
    set token [::tkpath::gradient create radial -method $method -units $units \
      -radialtransition [list $cx $cy $r $fx $fy] -stops $stops]
    set gradientIDToToken($id) $token
    cache_add gradient $token
}

proc svg2can::ParseGradientStops {xmllist} {
    
    set stops {}
    
    foreach stopE [getchildren $xmllist] {
        if {[gettag $stopE] eq "stop"} {
            set opts {}
            set offset 0
            set color black
            set opacity 1
            
            foreach {key value} [getattr $stopE] {
                switch -- $key {
                    offset {
                        set offset [parseUnaryOrPercentage $value]
                    }
                    stop-color {
                        set color [parseColor $value]
                    }
                    stop-opacity {
                        set opacity $value
                    }
                    style {
                        set opts [StopsStyleToStopSpec [StyleAttrToList $value]]
                    }
                }
            }

            # Style takes precedence.
            array set stopA [list color $color opacity $opacity]
            array set stopA $opts
            lappend stops [list $offset $stopA(color) $stopA(opacity)]
        }
    }
    return $stops
}

proc svg2can::parseUnaryOrPercentage {offset} {
    if {[string is double -strict $offset]} {
        return $offset
    } elseif {[regexp {(.+)%} $offset - percent]} {
        return [expr {$percent/100.0}]
    }
}

# svg2can::parseColor --
# 
#       Takes a SVG color definition and turns it into a Tk color.
#       
# Arguments:
#       color       SVG color
#       
# Results:
#       tk color

proc svg2can::parseColor {color} {
    
    if {[regexp {rgb\(([0-9]{1,3})%, *([0-9]{1,3})%, *([0-9]{1,3})%\)}  \
      $color - r g b]} {
        set col "#"
        foreach c [list $r $g $b] {
            append col [format %02x [expr round(2.55 * $c)]]
        }
    } elseif {[regexp {rgb\(([0-9]{1,3}), *([0-9]{1,3}), *([0-9]{1,3})\)}  \
      $color - r g b]} {
        set col "#"
        foreach c [list $r $g $b] {
            append col [format %02x $c]
        }
    } else {
        set col [MapNoneToEmpty $color]
    }
    return $col
}

proc svg2can::parseFillToList {value} {
    variable gradientIDToToken

    if {[regexp {url\(#(.+)\)} $value - id]} {
        #puts "\t id=$id"
        if {[info exists gradientIDToToken($id)]} {
            #puts "\t gradientIDToToken=$gradientIDToToken($id)"
            return [list -fill $gradientIDToToken($id)]
        } else {
            puts "--------> missing gradientIDToToken id=$id"
            return [list -fill black]
        }
    } else {
        return [list -fill [parseColor $value]]
    }
}

proc svg2can::parseLength {length} {    
    if {[string is double -strict $length]} {
        return $length
    }    
    # SVG is using: px, pt, mm, cm, em, ex, in, %.
    # @@@ Incomplete!
    set length [string map {px ""  pt p  mm m  cm c  in i} $length]
    return [winfo fpixels . $length]
}

proc svg2can::parsePathAttr {path} {
    regsub -all -- {([a-zA-Z])([0-9])} $path {\1 \2} path
    regsub -all -- {([0-9])([a-zA-Z])} $path {\1 \2} path
    regsub -all -- {([a-zA-Z])([a-zA-Z])} $path {\1 \2} path
    return [string map {- " -"  , " "} $path]
}

# svg2can::StyleToOpts --
# 
#       Takes the style attribute as a list and parses it into
#       resonable canvas drawing options.
#       Discards all attributes that don't map to an item option.
#       
# Arguments:
#       type        tk canvas item type
#       styleList
#       
# Results:
#       list of canvas options

proc svg2can::StyleToOpts {type styleList args} {
    
    variable textAnchorMap
    
    array set argsA {
        -setdefaults 1 
        -origfont    {Helvetica 12}
    }
    array set argsA $args

    # SVG and canvas have different defaults.
    if {$argsA(-setdefaults)} {
        switch -- $type {
            oval - polygon - rectangle {
                array set optsA {-fill black -outline ""}
            }
            line {
                array set optsA {-fill black}
            }
        }
    }
    
    set fontSpec $argsA(-origfont)
    set haveFont 0
    
    foreach {key value} $styleList {
        
        switch -- $key {
            fill {
                switch -- $type {
                    arc - oval - polygon - rectangle - text {
                        set optsA(-fill) [parseColor $value]
                    }
                }
            }
            font-family {
                lset fontSpec 0 $value
                set haveFont 1
            }
            font-size {
                
                # Use pixels instead of points.
                if {[regexp {([0-9\.]+)pt} $value match pts]} {
                    set pix [expr int($pts * [tk scaling] + 0.01)]
                    lset fontSpec 1 "-$pix"
                } elseif {[regexp {([0-9\.]+)px} $value match pix]} {
                    lset fontSpec 1 [expr int(-$pix)]
                } else {
                    lset fontSpec 1 [expr int(-$value)]
                }
                set haveFont 1
            }
            font-style {
                switch -- $value {
                    italic {
                        lappend fontSpec italic
                    }
                }
                set haveFont 1
            }
            font-weight {
                switch -- $value {
                    bold {
                        lappend fontSpec bold
                    }
                }
                set haveFont 1
            }
            marker-end {
                set optsA(-arrow) last
            }
            marker-start {
                set optsA(-arrow) first                
            }
            stroke {
                switch -- $type {
                    arc - oval - polygon - rectangle {
                        set optsA(-outline) [parseColor $value]
                    }
                    line {
                        set optsA(-fill) [parseColor $value]
                    }
                }
            }
            stroke-dasharray {
                set dash [split $value ,]
                if {[expr [llength $dash]%2 == 1]} {
                    set dash [concat $dash $dash]
                }
            }
            stroke-linecap {        
                # canvas: butt (D), projecting , round 
                # svg:    butt (D), square, round
                if {[string equal $value "square"]} {
                    set optsA(-capstyle) "projecting"
                }
                if {![string equal $value "butt"]} {
                    set optsA(-capstyle) $value
                }
            }
            stroke-linejoin {
                set optsA(-joinstyle) $value
            }
            stroke-miterlimit {
                # empty
            }
            stroke-opacity {
                if {[expr {$value == 0}]} {
                    
                }
            }
            stroke-width {
                if {![string equal $type "text"]} {
                    set optsA(-width) $value
                }
            }
            text-anchor {
                set optsA(-anchor) $textAnchorMap($value)
            }
            text-decoration {
                switch -- $value {
                    line-through {
                        lappend fontSpec overstrike
                    }
                    underline {
                        lappend fontSpec underline
                    }
                }
                set haveFont 1
            }
        }
    }
    if {$haveFont} {
        set optsA(-font) $fontSpec
    }
    return [array get optsA]
}

proc svg2can::StyleToOptsEx {styleList args} {
    
    foreach {key value} $styleList {    
        switch -- $key {
            fill {
                foreach {name val} [parseFillToList $value] { break }
                set optsA($name) $val
            } 
            opacity {
                # @@@ This is much more complicated than this for groups!
                set optsA(-fillopacity) $value
                set optsA(-strokeopacity) $value
            }
            stroke {
                set optsA(-$key) [parseColor $value]                
            }
            stroke-dasharray {
                if {$value eq "none"} {
                    set optsA(-strokedasharray) {}
                } else {
                    set dash [split $value ,]
                    set optsA(-strokedasharray) $dash
                }
            }
            fill-opacity - stroke-linejoin - stroke-miterlimit - stroke-opacity {                
                set name [string map {"-" ""} $key]
                set optsA(-$name) $value
            }
            stroke-linecap {
                # svg:    butt (D), square, round
                # canvas: butt (D), projecting , round 
                if {$value eq "square"} {
                    set value "projecting"
                }
                set name [string map {"-" ""} $key]
                set optsA(-$name) $value
            }
            stroke-width {                
                set name [string map {"-" ""} $key]
                set optsA(-$name) [parseLength $value]
            }
            r - rx - ry - width - height {
                set optsA(-$key) [parseLength $value]
            }
        }
    }
    return [array get optsA]
}

# svg2can::StopsStyleToStopSpec --
# 
#       Takes the stop style attribute as a list and parses it into
#       a flat array for the gradient stopSpec: {offset color ?opacity?}

proc svg2can::StopsStyleToStopSpec {styleList} {
    
    foreach {key value} $styleList {    
        switch -- $key {
            stop-color {
                set optsA(color) [parseColor $value]                
            }
            stop-opacity {
                set optsA(opacity) $value
            }
        }
    }
    return [array get optsA]
}

# svg2can::EllipticArcParameters --
# 
#       Conversion from endpoint to center parameterization.
#       From: http://www.w3.org/TR/2003/REC-SVG11-20030114

proc svg2can::EllipticArcParameters {x1 y1 rx ry phi fa fs x2 y2} {
    variable pi

    # NOTE: direction of angles are opposite for Tk and SVG!
    
    # F.6.2 Out-of-range parameters 
    if {($x1 == $x2) && ($y1 == $y2)} {
        return skip
    }
    if {[expr $rx == 0] || [expr $ry == 0]} {
        return lineto
    }
    set rx [expr abs($rx)]
    set ry [expr abs($ry)]
    set phi [expr fmod($phi, 360) * $pi/180.0]
    if {$fa != 0} {
        set fa 1
    }
    if {$fs != 0} {
        set fs 1
    }
    
    # F.6.5 Conversion from endpoint to center parameterization 
    set dx [expr ($x1-$x2)/2.0]
    set dy [expr ($y1-$y2)/2.0]
    set x1prime [expr cos($phi) * $dx + sin($phi) * $dy]
    set y1prime [expr -sin($phi) * $dx + cos($phi) * $dy]
    
    # F.6.6 Correction of out-of-range radii
    set rx [expr abs($rx)]
    set ry [expr abs($ry)]
    set x1prime2 [expr $x1prime * $x1prime]
    set y1prime2 [expr $y1prime * $y1prime]
    set rx2 [expr $rx * $rx]
    set ry2 [expr $ry * $ry]
    set lambda [expr $x1prime2/$rx2 + $y1prime2/$ry2]
    if {$lambda > 1.0} {
        set rx [expr sqrt($lambda) * $rx]
        set ry [expr sqrt($lambda) * $ry]
        set rx2 [expr $rx * $rx]
        set ry2 [expr $ry * $ry]
    }    
    
    # Compute cx' and cy'
    set sign [expr {$fa == $fs} ? -1 : 1]
    set square [expr ($rx2 * $ry2 - $rx2 * $y1prime2 - $ry2 * $x1prime2) /  \
      ($rx2 * $y1prime2 + $ry2 * $x1prime2)]
    set root [expr sqrt(abs($square))]
    set cxprime [expr  $sign * $root * $rx * $y1prime/$ry]
    set cyprime [expr -$sign * $root * $ry * $x1prime/$rx]
    
    # Compute cx and cy from cx' and cy'
    set cx [expr $cxprime * cos($phi) - $cyprime * sin($phi) + ($x1 + $x2)/2.0]
    set cy [expr $cxprime * sin($phi) + $cyprime * cos($phi) + ($y1 + $y2)/2.0]

    # Compute start angle and extent
    set ux [expr ($x1prime - $cxprime)/double($rx)]
    set uy [expr ($y1prime - $cyprime)/double($ry)]
    set vx [expr (-$x1prime - $cxprime)/double($rx)]
    set vy [expr (-$y1prime - $cyprime)/double($ry)]

    set sign [expr {$uy > 0} ? 1 : -1]
    set theta [expr $sign * acos( $ux/hypot($ux, $uy) )]

    set sign [expr {$ux * $vy - $uy * $vx > 0} ? 1 : -1]
    set delta [expr $sign * acos( ($ux * $vx + $uy * $vy) /  \
      (hypot($ux, $uy) * hypot($vx, $vy)) )]
    
    # To degrees
    set theta [expr $theta * 180.0/$pi]
    set delta [expr $delta * 180.0/$pi]
    #set delta [expr fmod($delta, 360)]
    set phi   [expr fmod($phi, 360)]
    
    if {($fs == 0) && ($delta > 0)} {
        set delta [expr $delta - 360]
    } elseif {($fs ==1) && ($delta < 0)} {
        set delta [expr $delta + 360]
    }

    # NOTE: direction of angles are opposite for Tk and SVG!
    set theta [expr -1*$theta]
    set delta [expr -1*$delta]
    
    return [list $cx $cy $rx $ry $theta $delta $phi]
}

# svg2can::MergePresentationAttr --
# 
#       Let the style attribute override the presentation attributes.

proc svg2can::MergePresentationAttr {type opts presAttr} {
    
    if {[llength $presAttr]} {
        array set optsA [StyleToOpts $type $presAttr]
        array set optsA $opts
        set opts [array get optsA]
    }
    return $opts
}

proc svg2can::MergePresentationAttrEx {opts presAttr} {
    
    if {[llength $presAttr]} {
        array set optsA [StyleToOptsEx $presAttr]
        array set optsA $opts
        set opts [array get optsA]
    }
    return $opts
}

proc svg2can::StyleAttrToList {style} {    
    return [split [string trim [string map {" " ""} $style] \;] :\;]
}

proc svg2can::BaselineShiftToDy {baselineshift fontSpec} {
    
    set linespace [font metrics $fontSpec -linespace]
    
    switch -regexp -- $baselineshift {
        sub {
            set dy [expr 0.8 * $linespace]
        }
        super {
            set dy [expr -0.8 * $linespace]
        }
        {-?[0-9]+%} {
            set dy [expr 0.01 * $linespace * [string trimright $baselineshift %]]
        }
        default {
            # 0.5em ?
            set dy $baselineshift
        }
    }
    return $dy
}

# svg2can::PathAddRelative --
# 
#       Utility function to add a relative point from the path to the 
#       coordinate list. Updates iVar, and the current point.

proc svg2can::PathAddRelative {path coVar iVar cpxVar cpyVar} {
    upvar $coVar  co
    upvar $iVar   i
    upvar $cpxVar cpx
    upvar $cpyVar cpy

    set newx [expr $cpx + [lindex $path [incr i]]]
    set newy [expr $cpy + [lindex $path [incr i]]]
    lappend co $newx $newy
    set cpx $newx
    set cpy $newy
}

proc svg2can::PointsToList {points} {
    return [string map {, " "} $points]
}

# svg2can::ParseTransformAttr --
# 
#       Parse the svg syntax for the transform attribute to a simple tcl
#       list.

proc svg2can::ParseTransformAttr {attrlist} {  
    set cmd ""
    set idx [lsearch -exact $attrlist "transform"]
    if {$idx >= 0} {
        set cmd [TransformAttrToList [lindex $attrlist [incr idx]]]
    }
    return $cmd
}

proc svg2can::TransformAttrToList {cmd} {    
    regsub -all -- {\( *([-0-9.]+) *\)} $cmd { \1} cmd
    regsub -all -- {\( *([-0-9.]+)[ ,]+([-0-9.]+) *\)} $cmd { {\1 \2}} cmd
    regsub -all -- {\( *([-0-9.]+)[ ,]+([-0-9.]+)[ ,]+([-0-9.]+) *\)} \
      $cmd { {\1 \2 \3}} cmd
    regsub -all -- {,} $cmd {} cmd
    return $cmd
}

# svg2can::TransformAttrListToMatrix --
# 
#       Processes a SVG transform attribute to a transformation matrix.
#       Used by tkpath only.
#       
#       | a c tx |
#       | b d ty |
#       | 0 0 1  |
#       
#       linear form : {a b c d tx ty}

proc svg2can::TransformAttrListToMatrix {transform} {
    variable degrees2Radians
    
    # @@@ I don't have 100% control of multiplication order!
    set i 0

    foreach {op value} $transform {
        
        switch -- $op {
            matrix {
                set m([incr i]) $value
            }
            rotate {
                set phi [lindex $value 0]
                set cosPhi  [expr cos($degrees2Radians*$phi)]
                set sinPhi  [expr sin($degrees2Radians*$phi)]
                set msinPhi [expr {-1.0*$sinPhi}]
                if {[llength $value] == 1} {
                    set m([incr i])  \
                      [list $cosPhi $sinPhi $msinPhi $cosPhi 0 0]
                } else {
                    set cx [lindex $value 1]
                    set cy [lindex $value 2]
                    set m([incr i]) [list $cosPhi $sinPhi $msinPhi $cosPhi \
                      [expr {-$cx*$cosPhi + $cy*$sinPhi + $cx}] \
                      [expr {-$cx*$sinPhi - $cy*$cosPhi + $cy}]]
                }
            }
            scale {
                set sx [lindex $value 0]
                if {[llength $value] > 1} {
                    set sy [lindex $value 1]
                } else {
                    set sy $sx
                }
                set m([incr i]) [list $sx 0 0 $sy 0 0]
            }
            skewx {
                set tana [expr {tan($degrees2Radians*[lindex $value 0])}]
                set m([incr i]) [list 1 0 $tana 1 0 0]
            }
            skewy {
                set tana [expr {tan($degrees2Radians*[lindex $value 0])}]
                set m([incr i]) [list 1 $tana 0 1 0 0]
            }
            translate {
                set tx [lindex $value 0]
                if {[llength $value] > 1} {
                    set ty [lindex $value 1]
                } else {
                    set ty 0
                }
                set m([incr i]) [list 1 0 0 1 $tx $ty]
            }
        }
    }
    if {$i == 1} {
        # This is the most common case.
        set mat $m($i)
    } else {
        set mat {1 0 0 1 0 0}
        foreach i [lsort -integer [array names m]] {
#LISSI
            set mat [MMult $mat $m($i)]
#	    set mat [::tkp::matrix mult $mat $m($i)]

        }
    }
    foreach {a b c d tx ty} $mat { break }
    return [list [list $a $c] [list $b $d] [list $tx $ty]]
}

proc svg2can::MMult {m1 m2} {
    foreach {a1 b1 c1 d1 tx1 ty1} $m1 { break }
    foreach {a2 b2 c2 d2 tx2 ty2} $m2 { break }
    return [list \
      [expr {$a1*$a2  + $c1*$b2}]        \
      [expr {$b1*$a2  + $d1*$b2}]        \
      [expr {$a1*$c2  + $c1*$d2}]        \
      [expr {$b1*$c2  + $d1*$d2}]        \
      [expr {$a1*$tx2 + $c1*$ty2 + $tx1}] \
      [expr {$b1*$tx2 + $d1*$ty2 + $ty1}]]
}

# svg2can::CreateTransformCanvasCmdList --
# 
#       Takes a parsed list of transform attributes and turns them
#       into a sequence of canvas commands.
#       Standard items only which miss a matrix option.

proc svg2can::CreateTransformCanvasCmdList {tag transformL} {
    
    set cmdList {}
    foreach {key argument} $transformL {
        
        switch -- $key {
            translate {
                lappend cmdList [concat [list move $tag] $argument]
            }
            scale {
                
                switch -- [llength $argument] {
                    1 {
                        set xScale $argument
                        set yScale $argument
                    }
                    2 {
                        foreach {xScale yScale} $argument break
                    }
                    default {
                        set xScale 1.0
                        set yScale 1.0
                    }
                }
                lappend cmdList [list scale $tag 0 0 $xScale $yScale]
            }
        }
    }
    return $cmdList
}

proc svg2can::AddAnyTransformCmds {cmdList transformL} {
    variable tmptag
    
    if {[llength $transformL]} {
        set cmdList [concat $cmdList \
          [CreateTransformCanvasCmdList $tmptag $transformL]]
        lappend cmdList [list dtag $tmptag]
    }
    return $cmdList
}

proc svg2can::MapNoneToEmpty {val} {

    if {[string equal $val "none"]} {
        return
    } else {
        return $val
    }
}

proc svg2can::FlattenList {hilist} {
    
    set flatlist {}
    FlatListRecursive $hilist flatlist
    return $flatlist
}

proc svg2can::FlatListRecursive {hilist flatlistVar} {
    upvar $flatlistVar flatlist
    
    if {[string equal [lindex $hilist 0] "create"]} {
        set flatlist [list $hilist]
    } else {
        foreach c $hilist {
            if {[string equal [lindex $c 0] "create"]} {
                lappend flatlist $c
            } else {
                FlatListRecursive $c flatlist
            }
        }
    }
}

# svg2can::gettag, getattr, getcdata, getchildren --
# 
#       Accesor functions to the specific things in a xmllist.

proc svg2can::gettag {xmllist} { 
    return [lindex $xmllist 0]
}

proc svg2can::getattr {xmllist} { 
    return [lindex $xmllist 1]
}

proc svg2can::getcdata {xmllist} { 
    return [lindex $xmllist 3]
}

proc svg2can::getchildren {xmllist} { 
    return [lindex $xmllist 4]
}

proc svg2can::_DrawSVG {fileName w} {
    set fd [open $fileName r]
    set xml [read $fd]
    close $fd
    set xmllist [tinydom::documentElement [tinydom::parse $xml]]
    set cmdList [svg2can::parsesvgdocument $xmllist]
    foreach c $cmdList {
        puts $c
        eval $w $c
    }
}

# Tests...
if {0} {
    # load /Users/matben/C/cvs/tkpath/macosx/build/tkpath0.2.1.dylib
    package require svg2can
    toplevel .t
    pack [canvas .t.c -width 600 -height 500]    
    set i 0
        
    set xml([incr i]) {<polyline points='400 10 10 10 10 400' \
      style='stroke: #000000; stroke-width: 1.0; fill: none;'/>}
                    
    # Text
    set xml([incr i]) {<text x='10.0' y='20.0' \
      style='stroke-width: 0; font-family: Helvetica; font-size: 12; \
      fill: #000000;' id='std text t001'>\
      <tspan>Start</tspan><tspan>Mid</tspan><tspan>End</tspan></text>}
    set xml([incr i]) {<text x='10.0' y='40.0' \
      style='stroke-width: 0; font-family: Helvetica; font-size: 12; \
      fill: #000000;' id='std text t002'>One\
      straight text data</text>}
    set xml([incr i]) {<text x='10.0' y='60.0' \
      style='stroke-width: 0; font-family: Helvetica; font-size: 12; \
      fill: #000000;' id='std text t003'>\
      <tspan>Online</tspan><tspan dy='6'>dy=6</tspan><tspan dy='-6'>End</tspan></text>}
    set xml([incr i]) {<text x='10.0' y='90.0' \
      style='stroke-width: 0; font-family: Helvetica; font-size: 16; \
      fill: #000000;' id='std text t004'>\
      <tspan>First</tspan>\
      <tspan dy='10'>Online (dy=10)</tspan>\
      <tspan><tspan>Nested</tspan></tspan><tspan>End</tspan></text>}
    
    # Paths
    set xml([incr i]) {<path d='M 200 100 L 300 100 300 200 200 200 Z' \
      style='fill-rule: evenodd; fill: none; stroke: black; stroke-width: 1.0;\
      stroke-linejoin: round;' id='std poly t005'/>}
    set xml([incr i]) {<path d='M 30 100 Q 80 30 100 100 130 65 200 80' \
      style='fill-rule: evenodd; fill: none; stroke: #af5da8; stroke-width: 4.0;\
      stroke-linejoin: round;' id='std poly t006'/>}
    set xml([incr i]) {<polyline points='30 100,80 30,100 100,130 65,200 80' \
      style='fill: none; stroke: red;'/>}
    set xml([incr i])  {<path d='M 10 200 H 100 200 v20h 10'\
    style='fill-rule: evenodd; fill: none; stroke: black; stroke-width: 2.0;\
      stroke-linejoin: round;' id='std t008'/>}
    set xml([incr i])  {<path d='M 20 200 V 300 310 h 10 v 10'\
      style='fill-rule: evenodd; fill: none; stroke: blue; stroke-width: 2.0;\
      stroke-linejoin: round;' id='std t008'/>}
    set xml([incr i]) {<path d='M 30 100 Q 80 30 100 100 T 200 80' \
      style='fill: none; stroke: green; stroke-width: 2.0;' id='t006'/>}
    set xml([incr i]) {<path d='M 30 200 Q 80 130 100 200 T 150 180 200 180 250 180 300 180' \
      style='fill: none; stroke: gray50; stroke-width: 2.0;' id='t006'/>}
    set xml([incr i]) {<path d='M 30 300 Q 80 230 100 300 t 50 0 50 0 50 0 50 0' \
      style='fill: none; stroke: gray50; stroke-width: 1.0;' id='std poly t006'/>}
    set xml([incr i]) {<path d="M100,200 C100,100 250,100 250,200 \
      S400,300 400,200" style='fill: none; stroke: black'/>}

    set xml([incr i]) {<path d="M 125 75 A 100 50 0 0 0 225 125" \
      style='fill: none; stroke: blue; stroke-width: 2.0;'/>}
    set xml([incr i]) {<path d="M 125 75 A 100 50 0 0 1 225 125" \
      style='fill: none; stroke: red; stroke-width: 2.0;'/>}
    set xml([incr i]) {<path d="M 125 75 A 100 50 0 1 0 225 125" \
      style='fill: none; stroke: green; stroke-width: 2.0;'/>}
    set xml([incr i]) {<path d="M 125 75 A 100 50 0 1 1 225 125" \
      style='fill: none; stroke: gray50; stroke-width: 2.0;'/>}

    # g
    set xml([incr i]) {<g fill="none" stroke="red" stroke-width="3" > \
      <line x1="300" y1="10" x2="350" y2="10" /> \
      <line x1="300" y1="10" x2="300" y2="50" /> \
      </g>}
    
    # translate
    set xml([incr i]) {<rect id="t0012" x="10" y="10" width="20" height="20" \
      style="stroke: yellow; fill: none; stroke-width: 2.0;" \
      transform="translate(200,200)"/>}
    set xml([incr i]) {<rect id="t0013" x="10" y="10" width="20" height="20" \
      style="stroke: yellow; fill: none; stroke-width: 2.0;" transform="scale(4)"/>}
    set xml([incr i]) {<circle id="t0013" cx="10" cy="10" r="20" \
      style="stroke: yellow; fill: none; stroke-width: 2.0;"\
      transform="translate(200,300)"/>}
    set xml([incr i]) {<text x='10.0' y='40.0' transform="translate(200,300)" \
      style='font-family: Helvetica; font-size: 24; \
      fill: #000000;'>Translated Text</text>}
    
    # tkpath tests...
    set xml([incr i]) {<rect x='10' y='10' height='15' width='20' \
      transform='translate(30, 20) scale(2)' style='fill: gray;'/>}
    set xml([incr i]) {<rect x='10' y='10' height='15' width='20' \
      transform='scale(2) translate(30, 20)' style='fill: black;'/>}
    
    set xml([incr i]) {<g transform='translate(30, 20)'> \
      <g transform='scale(2)'> \
      <rect x='10' y='10' height='15' width='20' style='stroke: blue; fill: none;'/> \
      </g> \
      </g>}
    
    .t.c create path "M 30 20 h 100 M 30 20 v 100"
    .t.c create prect 10 10 30 25 -stroke {} -fill gray
    
    foreach i [lsort -integer [array names xml]] {
        set xmllist [tinydom::documentElement [tinydom::parse $xml($i)]]
        set cmdList [svg2can::parseelement $xmllist]
        foreach c $cmdList {
            puts $c
            eval .t.c $c
        }
    }

}
    
#-------------------------------------------------------------------------------
