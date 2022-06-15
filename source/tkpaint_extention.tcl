#SVG - элементы - http://shpargalkablog.ru/2015/11/svg.html
# https://msiter.ru/tutorials/svg/svg_path
# https://webbeaver.ru/svg-path-syntax/
#Сдвиг на градусы по оси X или Y
#set degX -45.0
#set degY -45.0
#set anX [expr {$degX / 180 * 3.1415926)}]
#set anY [expr {$degY / 180 * 3.1415926)}]
#Матрица для оси X
#set m_X [::tkp::matrix skewx $anX]
#Матрица для оси Y
#set m_Y [::tkp::matrix skewy $anY]
#Матирица по осям XY
#set m_XY $m_X
#lset m_XY 0 [lindex $m_Y 0]
#set id  [.c find withtag Selected]
#.c itemconfigure $id -matrix $m_XY
#Вернуть в исходное
#set m_0 [::tkp::matrix skewx 0.0]
#.c itemconfigure $id -matrix $m_0
#Получить из значения tan угол:
#set atan_1 [expr {atan(1.0)}]
#set angle [expr {$atan_1 * 180 / 3.1415}]
#Ещё учесть, как при повороте, что хранится в matrix
#Читаем matrix
#set m_XYorig [.c itemcget $id -matrix]
#set m_Xorig [lindex $m_XYorig 1]
#set m_Yorig [lindex $m_XYorig 0]

global {TPcolorList}
set {TPcolorList} {{snow 255 250 250} {GhostWhite 248 248 255} {WhiteSmoke 245 245 245} {gainsboro 220 220 220} {FloralWhite 255 250 240} {OldLace 253 245 230} {linen 250 240 230} {AntiqueWhite 250 235 215} {PapayaWhip 255 239 213} {BlanchedAlmond 255 235 205} {bisque 255 228 196} {PeachPuff 255 218 185} {NavajoWhite 255 222 173} {moccasin 255 228 181} {cornsilk 255 248 220} {ivory 255 255 240} {LemonChiffon 255 250 205} {seashell 255 245 238} {honeydew 240 255 240} {MintCream 245 255 250} {azure 240 255 255} {AliceBlue 240 248 255} {lavender 230 230 250} {LavenderBlush 255 240 245} {MistyRose 255 228 225} {white 255 255 255} {black 0 0 0} {DarkSlateGray 47 79 79} {DarkSlateGrey 47 79 79} {DimGray 105 105 105} {DimGrey 105 105 105} {SlateGray 112 128 144} {SlateGrey 112 128 144} {LightSlateGray 119 136 153} {LightSlateGrey 119 136 153} {gray 190 190 190} {LightGrey 211 211 211} {MidnightBlue 25 25 112} {navy 0 0 128} {NavyBlue 0 0 128} {CornflowerBlue 100 149 237} {DarkSlateBlue 72 61 139} {SlateBlue 106 90 205} {MediumSlateBlue 123 104 238} {LightSlateBlue 132 112 255} {MediumBlue 0 0 205} {RoyalBlue 65 105 225} {blue 0 0 255} {DodgerBlue 30 144 255} {DeepSkyBlue 0 191 255} {SkyBlue 135 206 235} {LightSkyBlue 135 206 250} {SteelBlue 70 130 180} {LightSteelBlue 176 196 222} {LightBlue 173 216 230} {PowderBlue 176 224 230} {PaleTurquoise 175 238 238} {DarkTurquoise 0 206 209} {MediumTurquoise 72 209 204} {turquoise 64 224 208} {cyan 0 255 255} {LightCyan 224 255 255} {CadetBlue 95 158 160} {MediumAquamarine 102 205 170} {aquamarine 127 255 212} {DarkGreen 0 100 0} {DarkOliveGreen 85 107 47} {DarkSeaGreen 143 188 143} {SeaGreen 46 139 87} {MediumSeaGreen 60 179 113} {LightSeaGreen 32 178 170} {PaleGreen 152 251 152} {SpringGreen 0 255 127} {LawnGreen 124 252 0} {green 0 255 0} {chartreuse 127 255 0} {MediumSpringGreen 0 250 154} {GreenYellow 173 255 47} {LimeGreen 50 205 50} {YellowGreen 154 205 50} {ForestGreen 34 139 34} {OliveDrab 107 142 35} {DarkKhaki 189 183 107} {khaki 240 230 140} {PaleGoldenrod 238 232 170} {LightGoldenrodYellow 250 250 210} {LightYellow 255 255 224} {yellow 255 255 0} {gold 255 215 0} {LightGoldenrod 238 221 130} {goldenrod 218 165 32} {DarkGoldenrod 184 134 11} {RosyBrown 188 143 143} {IndianRed 205 92 92} {SaddleBrown 139 69 19} {sienna 160 82 45} {peru 205 133 63} {burlywood 222 184 135} {beige 245 245 220} {wheat 245 222 179} {SandyBrown 244 164 96} {tan 210 180 140} {chocolate 210 105 30} {firebrick 178 34 34} {brown 165 42 42} {DarkSalmon 233 150 122} {salmon 250 128 114} {LightSalmon 255 160 122} {orange 255 165 0} {DarkOrange 255 140 0} {coral 255 127 80} {LightCoral 240 128 128} {tomato 255 99 71} {OrangeRed 255 69 0} {red 255 0 0} {HotPink 255 105 180} {DeepPink 255 20 147} {pink 255 192 203} {LightPink 255 182 193} {PaleVioletRed 219 112 147} {maroon 176 48 96} {MediumVioletRed 199 21 133} {VioletRed 208 32 144} {magenta 255 0 255} {violet 238 130 238} {plum 221 160 221} {orchid 218 112 214} {MediumOrchid 186 85 211} {DarkOrchid 153 50 204} {DarkViolet 148 0 211} {BlueViolet 138 43 226} {purple 160 32 240} {MediumPurple 147 112 219} {thistle 216 191 216} {snow1 255 250 250} {snow2 238 233 233} {snow3 205 201 201} {snow4 139 137 137} {seashell1 255 245 238} {seashell2 238 229 222} {seashell3 205 197 191} {seashell4 139 134 130} {AntiqueWhite1 255 239 219} {AntiqueWhite2 238 223 204} {AntiqueWhite3 205 192 176} {AntiqueWhite4 139 131 120} {bisque1 255 228 196} {bisque2 238 213 183} {bisque3 205 183 158} {bisque4 139 125 107} {PeachPuff1 255 218 185} {PeachPuff2 238 203 173} {PeachPuff3 205 175 149} {PeachPuff4 139 119 101} {NavajoWhite1 255 222 173} {NavajoWhite2 238 207 161} {NavajoWhite3 205 179 139} {NavajoWhite4 139 121 94} {LemonChiffon1 255 250 205} {LemonChiffon2 238 233 191} {LemonChiffon3 205 201 165} {LemonChiffon4 139 137 112} {cornsilk1 255 248 220} {cornsilk2 238 232 205} {cornsilk3 205 200 177} {cornsilk4 139 136 120} {ivory1 255 255 240} {ivory2 238 238 224} {ivory3 205 205 193} {ivory4 139 139 131} {honeydew1 240 255 240} {honeydew2 224 238 224} {honeydew3 193 205 193} {honeydew4 131 139 131} {LavenderBlush1 255 240 245} {LavenderBlush2 238 224 229} {LavenderBlush3 205 193 197} {LavenderBlush4 139 131 134} {MistyRose1 255 228 225} {MistyRose2 238 213 210} {MistyRose3 205 183 181} {MistyRose4 139 125 123} {azure1 240 255 255} {azure2 224 238 238} {azure3 193 205 205} {azure4 131 139 139} {SlateBlue1 131 111 255} {SlateBlue2 122 103 238} {SlateBlue3 105 89 205} {SlateBlue4 71 60 139} {RoyalBlue1 72 118 255} {RoyalBlue2 67 110 238} {RoyalBlue3 58 95 205} {RoyalBlue4 39 64 139} {blue1 0 0 255} {blue2 0 0 238} {blue3 0 0 205} {blue4 0 0 139} {DodgerBlue1 30 144 255} {DodgerBlue2 28 134 238} {DodgerBlue3 24 116 205} {DodgerBlue4 16 78 139} {SteelBlue1 99 184 255} {SteelBlue2 92 172 238} {SteelBlue3 79 148 205} {SteelBlue4 54 100 139} {DeepSkyBlue1 0 191 255} {DeepSkyBlue2 0 178 238} {DeepSkyBlue3 0 154 205} {DeepSkyBlue4 0 104 139} {SkyBlue1 135 206 255} {SkyBlue2 126 192 238} {SkyBlue3 108 166 205} {SkyBlue4 74 112 139} {LightSkyBlue1 176 226 255} {LightSkyBlue2 164 211 238} {LightSkyBlue3 141 182 205} {LightSkyBlue4 96 123 139} {SlateGray1 198 226 255} {SlateGray2 185 211 238} {SlateGray3 159 182 205} {SlateGray4 108 123 139} {LightSteelBlue1 202 225 255} {LightSteelBlue2 188 210 238} {LightSteelBlue3 162 181 205} {LightSteelBlue4 110 123 139} {LightBlue1 191 239 255} {LightBlue2 178 223 238} {LightBlue3 154 192 205} {LightBlue4 104 131 139} {LightCyan1 224 255 255} {LightCyan2 209 238 238} {LightCyan3 180 205 205} {LightCyan4 122 139 139} {PaleTurquoise1 187 255 255} {PaleTurquoise2 174 238 238} {PaleTurquoise3 150 205 205} {PaleTurquoise4 102 139 139} {CadetBlue1 152 245 255} {CadetBlue2 142 229 238} {CadetBlue3 122 197 205} {CadetBlue4 83 134 139} {turquoise1 0 245 255} {turquoise2 0 229 238} {turquoise3 0 197 205} {turquoise4 0 134 139} {cyan1 0 255 255} {cyan2 0 238 238} {cyan3 0 205 205} {cyan4 0 139 139} {DarkSlateGray1 151 255 255} {DarkSlateGray2 141 238 238} {DarkSlateGray3 121 205 205} {DarkSlateGray4 82 139 139} {aquamarine1 127 255 212} {aquamarine2 118 238 198} {aquamarine3 102 205 170} {aquamarine4 69 139 116} {DarkSeaGreen1 193 255 193} {DarkSeaGreen2 180 238 180} {DarkSeaGreen3 155 205 155} {DarkSeaGreen4 105 139 105} {SeaGreen1 84 255 159} {SeaGreen2 78 238 148} {SeaGreen3 67 205 128} {SeaGreen4 46 139 87} {PaleGreen1 154 255 154} {PaleGreen2 144 238 144} {PaleGreen3 124 205 124} {PaleGreen4 84 139 84} {SpringGreen1 0 255 127} {SpringGreen2 0 238 118} {SpringGreen3 0 205 102} {SpringGreen4 0 139 69} {green1 0 255 0} {green2 0 238 0} {green3 0 205 0} {green4 0 139 0} {chartreuse1 127 255 0} {chartreuse2 118 238 0} {chartreuse3 102 205 0} {chartreuse4 69 139 0} {OliveDrab1 192 255 62} {OliveDrab2 179 238 58} {OliveDrab3 154 205 50} {OliveDrab4 105 139 34} {DarkOliveGreen1 202 255 112} {DarkOliveGreen2 188 238 104} {DarkOliveGreen3 162 205 90} {DarkOliveGreen4 110 139 61} {khaki1 255 246 143} {khaki2 238 230 133} {khaki3 205 198 115} {khaki4 139 134 78} {LightGoldenrod1 255 236 139} {LightGoldenrod2 238 220 130} {LightGoldenrod3 205 190 112} {LightGoldenrod4 139 129 76} {LightYellow1 255 255 224} {LightYellow2 238 238 209} {LightYellow3 205 205 180} {LightYellow4 139 139 122} {yellow1 255 255 0} {yellow2 238 238 0} {yellow3 205 205 0} {yellow4 139 139 0} {gold1 255 215 0} {gold2 238 201 0} {gold3 205 173 0} {gold4 139 117 0} {goldenrod1 255 193 37} {goldenrod2 238 180 34} {goldenrod3 205 155 29} {goldenrod4 139 105 20} {DarkGoldenrod1 255 185 15} {DarkGoldenrod2 238 173 14} {DarkGoldenrod3 205 149 12} {DarkGoldenrod4 139 101 8} {RosyBrown1 255 193 193} {RosyBrown2 238 180 180} {RosyBrown3 205 155 155} {RosyBrown4 139 105 105} {IndianRed1 255 106 106} {IndianRed2 238 99 99} {IndianRed3 205 85 85} {IndianRed4 139 58 58} {sienna1 255 130 71} {sienna2 238 121 66} {sienna3 205 104 57} {sienna4 139 71 38} {burlywood1 255 211 155} {burlywood2 238 197 145} {burlywood3 205 170 125} {burlywood4 139 115 85} {wheat1 255 231 186} {wheat2 238 216 174} {wheat3 205 186 150} {wheat4 139 126 102} {tan1 255 165 79} {tan2 238 154 73} {tan3 205 133 63} {tan4 139 90 43} {chocolate1 255 127 36} {chocolate2 238 118 33} {chocolate3 205 102 29} {chocolate4 139 69 19} {firebrick1 255 48 48} {firebrick2 238 44 44} {firebrick3 205 38 38} {firebrick4 139 26 26} {brown1 255 64 64} {brown2 238 59 59} {brown3 205 51 51} {brown4 139 35 35} {salmon1 255 140 105} {salmon2 238 130 98} {salmon3 205 112 84} {salmon4 139 76 57} {LightSalmon1 255 160 122} {LightSalmon2 238 149 114} {LightSalmon3 205 129 98} {LightSalmon4 139 87 66} {orange1 255 165 0} {orange2 238 154 0} {orange3 205 133 0} {orange4 139 90 0} {DarkOrange1 255 127 0} {DarkOrange2 238 118 0} {DarkOrange3 205 102 0} {DarkOrange4 139 69 0} {coral1 255 114 86} {coral2 238 106 80} {coral3 205 91 69} {coral4 139 62 47} {tomato1 255 99 71} {tomato2 238 92 66} {tomato3 205 79 57} {tomato4 139 54 38} {OrangeRed1 255 69 0} {OrangeRed2 238 64 0} {OrangeRed3 205 55 0} {OrangeRed4 139 37 0} {red1 255 0 0} {red2 238 0 0} {red3 205 0 0} {red4 139 0 0} {DeepPink1 255 20 147} {DeepPink2 238 18 137} {DeepPink3 205 16 118} {DeepPink4 139 10 80} {HotPink1 255 110 180} {HotPink2 238 106 167} {HotPink3 205 96 144} {HotPink4 139 58 98} {pink1 255 181 197} {pink2 238 169 184} {pink3 205 145 158} {pink4 139 99 108} {LightPink1 255 174 185} {LightPink2 238 162 173} {LightPink3 205 140 149} {LightPink4 139 95 101} {PaleVioletRed1 255 130 171} {PaleVioletRed2 238 121 159} {PaleVioletRed3 205 104 137} {PaleVioletRed4 139 71 93} {maroon1 255 52 179} {maroon2 238 48 167} {maroon3 205 41 144} {maroon4 139 28 98} {VioletRed1 255 62 150} {VioletRed2 238 58 140} {VioletRed3 205 50 120} {VioletRed4 139 34 82} {magenta1 255 0 255} {magenta2 238 0 238} {magenta3 205 0 205} {magenta4 139 0 139} {orchid1 255 131 250} {orchid2 238 122 233} {orchid3 205 105 201} {orchid4 139 71 137} {plum1 255 187 255} {plum2 238 174 238} {plum3 205 150 205} {plum4 139 102 139} {MediumOrchid1 224 102 255} {MediumOrchid2 209 95 238} {MediumOrchid3 180 82 205} {MediumOrchid4 122 55 139} {DarkOrchid1 191 62 255} {DarkOrchid2 178 58 238} {DarkOrchid3 154 50 205} {DarkOrchid4 104 34 139} {purple1 155 48 255} {purple2 145 44 238} {purple3 125 38 205} {purple4 85 26 139} {MediumPurple1 171 130 255} {MediumPurple2 159 121 238} {MediumPurple3 137 104 205} {MediumPurple4 93 71 139} {thistle1 255 225 255} {thistle2 238 210 238} {thistle3 205 181 205} {thistle4 139 123 139} {gray0 0 0 0} {gray1 3 3 3} {gray2 5 5 5} {gray3 8 8 8} {gray4 10 10 10} {gray5 13 13 13} {gray6 15 15 15} {gray7 18 18 18} {gray8 20 20 20} {gray9 23 23 23} {gray10 26 26 26} {gray11 28 28 28} {gray12 31 31 31} {gray13 33 33 33} {grey14 36 36 36} {gray15 38 38 38} {grey16 41 41 41} {gray17 43 43 43} {grey18 46 46 46} {gray19 48 48 48} {grey20 51 51 51} {gray21 54 54 54} {grey22 56 56 56} {gray23 59 59 59} {grey24 61 61 61} {gray25 64 64 64} {grey26 66 66 66} {gray27 69 69 69} {grey28 71 71 71} {gray29 74 74 74} {grey30 77 77 77} {gray31 79 79 79} {grey32 82 82 82} {gray33 84 84 84} {grey34 87 87 87} {gray35 89 89 89} {grey36 92 92 92} {gray37 94 94 94} {grey38 97 97 97} {gray39 99 99 99} {grey40 102 102 102} {gray41 105 105 105} {grey42 107 107 107} {gray43 110 110 110} {grey44 112 112 112} {gray45 115 115 115} {grey46 117 117 117} {gray47 120 120 120} {grey48 122 122 122} {gray49 125 125 125} {grey50 127 127 127} {gray51 130 130 130} {grey52 133 133 133} {gray53 135 135 135} {grey54 138 138 138} {gray55 140 140 140} {grey56 143 143 143} {gray57 145 145 145} {grey58 148 148 148} {gray59 150 150 150} {grey60 153 153 153} {gray61 156 156 156} {grey62 158 158 158} {gray63 161 161 161} {grey64 163 163 163} {gray65 166 166 166} {grey66 168 168 168} {gray67 171 171 171} {grey68 173 173 173} {gray69 176 176 176} {grey70 179 179 179} {gray71 181 181 181} {grey72 184 184 184} {gray73 186 186 186} {grey74 189 189 189} {gray75 191 191 191} {grey76 194 194 194} {gray77 196 196 196} {grey78 199 199 199} {gray79 201 201 201} {grey80 204 204 204} {gray81 207 207 207} {grey82 209 209 209} {gray83 212 212 212} {grey84 214 214 214} {gray85 217 217 217} {grey86 219 219 219} {gray87 222 222 222} {grey88 224 224 224} {gray89 227 227 227} {grey90 229 229 229} {gray91 232 232 232} {grey92 235 235 235} {gray93 237 237 237} {grey94 240 240 240} {gray95 242 242 242} {grey96 245 245 245} {gray97 247 247 247} {grey98 250 250 250} {gray99 252 252 252} {grey100 255 255 255}}
image create photo author -data {
R0lGODlhdQBiAOf/ABQVExkWFBQYGh8WFhoYHCQWFxkaIRwgIR8fJyEfIiUe
IyQhIDEfIygiKywjKCEmLSYlKCUlLCMmMi4jLi4oMiksLC0qOiwrMy4rLigs
OSgtNDQqOjwpLkMpMkIrK0ErOjkvMTcwOi4zOjMyNDIyOi0zRC40P0EwLDwz
Lj41SjI5SzI6Rkg1OkI5OTk7Qzw7Ozo7SEQ6NFI1PU42R0s5M1A4Nkc6RlM5
KlM5L047L1A7KjhAUjhBTDxHWVVCPFdCNkFGWU9EP0FHU0xEWUZIT1dESFBF
Vk5HRmNBQV9BUlxEQV9FNWFDSkhMX19IPUZOWlZLRUROZ1xKQ0RPYGdKNW5M
PmRQQ2RQSU9UaEpWZ2pPRW9MX3FNTWVQV2pQTE5XY3RPSFxWV2xTQmBWUWNW
THRQWXNTPllYcGNWbGpXSVFcbmpXUHNbT3FcVW1fVX9aUn5bTXxaY3tdR1tk
dIBbW3xbcnRfY3tfTm5iXWdkY3JiU2pkWntjV3lkXXRmXIteeXZpgYRqWIlq
VIBsZXpuZI5oaXBxfoZtYYNtco9rYpFrXYxrdIhrg3dyc4BxYYhybIF1bJR1
Xpt0epR3e5h3cJB6cIt8cYZ+b4l9iZN7kouAfJd8h5J/fpOBbJiCeJKEeZ2A
gpGMiaSGi5qLgJ2LdpmLiJaNgaGKf6GNcqGNjaGLpaaLlp+PmJSUmaGSh6uO
k52Vh5+UkK+WoKmaj6yahLKXnKmblqWasaSdkq6alq6bnq2cpKifn6uhj7Oc
tqCjqaqhqrGimrmfpqulm/+OxLSrn72opbiqo7KspbKrt7upr7aqwLitm8Ko
srmtsK2wur+rx7SyscCxq7u0qf+i0MW4t8m10sS7rru9usK8tb+7zNC3xcK9
u8e+q8G+w8/CwcrEvcrEw87Et8THw8vNytHMy9jLytPNxdbNwNjK4//G4drU
zeDT1NrV09TX09bW2dzZ3t/a2eLa09rc2djd3+Te3d7g3efi4ePl4+vk3Ovm
5fLt7O/x7/fw6P/t9f///yH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAP8A
LAAAAAB1AGIAAAj+AP8JHEiwoMGDCAtyWsiwIaeEECNKnPjPnzpqxDJq5MdP
n8ePID3uC0mypEl9HPepPPnx3sl7MEHi+4ivps2Z+O7hRKnvZkefHGtyDIpv
nlF3R90hjWd0XrynSttJlfq0qtWrTq3W21rv6tV25bxujXcO3Dl5MHXaW7u2
3tp79cqCe0oPHr277/K+Uxou2zmlgAGTI4etqVF7htnau0vP8GHFi+nZ4woZ
X9u0mD3ejCfVpUfP+fKJuyYuX79+Q1OnVInuGrh6cCkbdtcuW7Fr69q5WzeY
3LjfyBIjFh55uGO28xTDowzZXk6YW9P2rGmvXLh2sD+7DD269Ol9qlf+7+vX
+jVXpsan2sat213v3+CCN117nLFkx4kf21u+tblztf959lk73HADVjwupcXd
NeiY1g944fEzHnmucdVVU/BwJtU1t+Wm1HvA4VeffY2JON9b/bU12VqWrSjd
Z/GE40w14RjoGUwLevdghBydVp6FhmU41TQdtjfYb8AhZWJyJN63ZHL9WSgl
V3C9eE+M0cwYznUC4tidgxCGpxKF4lj4lVTlEHmNVO4dieQwSh4lXJMlHjfc
ZG7hOWV0mHkGTznR8DJjNO3Ek50+XnajI48pkWlmVVOBNc0wa37o5m9wNqVU
YnTeJSJ982xllJSGUtknTO1Uc0wwx6x6HYL+sEH35Xc8jtlamWNVBc+u8Eja
y5rrtOnbm7Ph1yk9TNlplFZ4NhvrqfGUIw2rwwTjjDTnbCXPs7OqVOt4o5nX
FaTvwPOOr9Oss84557jZ1zBPztNpvE09lSdkz6a1VTnZHOMML7YcU4005miL
WbdhpqbSPqJVOK6G7egFVjHDpLtuu8O+q2mc8jYp75NVLWvvnqfWw2+r0tjC
6jHYopWPgrM+mPBQKjVs3lPzTCVxOBTjdrG72cCbVJx04pesyIXKo/RV4/Kp
b4ytRr2qLciA4/LL9+RzDWmmLewtP5ZVJc8108w1bqR6WVfMbe3whjGSQW+8
acceD4dzcohx9pT+POt4VWq+cKUatS3TzhLwWfXIk089oW1dmtcr1dNOjdFU
oyoy3JRTTqQRp81zMdmoC+JvQTM2D2BGHfupPU8VyllurY/sdODh8NIqq4UH
Uw072kan9TSPey15jf/yYrzxwEQTjTfebD6V5tYxA/q6l46TTTa42Ic63arj
Xa/rGsYeZZ+TVxMwysHMYrjVY/lOdvAjxehNoMbrYj8w+Bv/y/LOQ18OONIL
3duQhI1pZI8xe1HSsexjGL9RRWnbcsuzMiSjVgVsWrawxSxcEbrEKQ02WlNU
PlbSjvlF4xfA4IUuZCEMXewCf/j7xS+c0Tz//S+A1BvWbwp4QHrkZW7+ndqV
pxrot70tTYIWKkc1nMGqlc0ifa6wRTawA8HQjI0Zj7tHCZUXDfzZTxjNCGMz
lPFCGT5jeeHwHzjW5pcB7hAZPcTLOxZYlzrNY1cie5jY7NWWrRAIYCoLhiCD
YQtXuCIY5zCUPIx4xdLooxzcyJIzYLgLMIoxjMrAXzKeccYaWsc2oGNX9bAB
R/vkhY54rFc84LGU8xiKaVAa3jFsEYtYDFKQrhjFLL4RwUUqcmzAywc7qiEo
Su6iFpbchjK3oYxMAiMZm+Tf/7IRwHJUz3qlROCx7MJAo2SIlU4xkx61gqUM
xqIUx1CfBnMZDHNAcJHaAqY45CGN49WSFaz+YKEYl6nMZj5zk8/wxvXIVs1r
ktIUQ1QKneZol49hCCruiAdbHkaVq0CSF7FYp/oMydFZVOOdXFEa2VxDy1SY
NBWieAUyw8jPbWASms/QBvOiQaS1TSNzo+QGMkLhqcCUy5R1tKNVaHMYPUpl
kUcl0CzVt9ENumKDszgG+6QkUiIV0qScAAUoUrrSZrT0pZvUhlijsbZhVCyN
o8RGNIQWGHec0j684mbOmAKpIlqlHXyLTwaf6lSOPjUYDIqghUSazk+cIhVa
3apKhWHJS4qxmdAUqzZ+AQtTjMIU00CrDseBjc5iozFRaQ/36hJX0B7tTK+8
yrpSVopYbHQUpCD+BUeD0bLFJS6kY0tnJRCr1ZSqtBbAbewlhaEMmIr1F7iI
BS5wkQ3NbdaznaVHWzcVxJ7SxoGFMipYsoHRUqQiGBz9xGzL9s7y8u0ax3BF
Vnvr21e497eMDSNjd7ELaCZDG5yMBjfCAQ7oIWmH0D1dW9sxWrykMrThax34
IDW5Y9QyFqfIxQZHcYpR/FUc6zCvutaBDnSII72eSKwoRkxi3yKTsSiuhSxe
+M9kzAh6aYXudIm60F1BlHOFmsqZZHROv3LUE4bMxTE6TOQOi+PISP6wKzxB
CUpstcQkXiyKGati+lJSFrqAMZK2hA1uyLg9gZFXueyyqzFzJrQ4rij+pMIR
qFJYOJdvPoUnnBqMJNv5yFu7BniZ3OQnj1ixKm4slWvhwl3gcxWTeEUaz2Gd
LW2pQJ4l1HTbM2Ze5aVXaZZKbtS1SAiaIxvBOKd4R/GJN7/ZkIAVRzfynOdp
1DR9seBEk50M5ffKQp/NGHSh8bmJRFdDc45+NKQ7G400orkdrHSrpfeC6TSv
S13ogOC6vsFaN5P61HB+6jFWvbWaFoOQy8UFq2wh6z772c9RVjFwgetCfE5i
ErWgUaOF7eVIF9t5kXKrO8pMG91oesMAPweHO3yODoNDGg4uRSlc8Qkgv/kT
lbAwLsoa7uUOAxnTuJ5ZzlGNVMw6saCYhCT+FkHyRdjBDoiYRG/ZbehULEIS
8Q42vaEbjVgcY79ToY3Oc6bzfquLXT8vcpK3Nq1zWvsTpR6F0j9hCaSPItwX
x3g2zILXbb3MHLkAhZPfXYiuF4IOdOACE5hQhC7YIQ6TEAUydWFSXaQ95vwF
R40KVG9iayIWF0/j5vod0bb9fMNEtjOruz2NWZZCE5pYeqmdPgqFK7cYGTdL
35wGknZII+STQEQf2sAFLnQ9DmMPfRwWAYpXtJDtqRCGSpVBI3C4HhzXywY3
rhfJaCC+tZiTfMDZxa47D/73hU+vKw7vCaSXuukWjrzAP5ivktTjG6egBB28
UAQlKMHzIY9DGcr+QIfRq33tbEcmoZXxjbjH/vyyVx4kIGGJu1OtjQU/x9B/
P3hXr41iTwzGwolv/OKXehgZNjsvAhKYsQ6ncAhggARFUARI4HmvIAqTUAiL
QAeFkGgnVgvuJX6styWuh36x52rIQAiEsH6awAmxgAwDRX+KwmrZUFO4AAuV
ZVmuZTgWVgqcUAmeYAme4AmV8AmlgAyhcSqZgSjQER3ycIBgIHadRwcW6F6i
0FuvcGvABV/EpQwcCHseOA3IMAy44Ad+MIKQ0AiJdwwYtzXc1mpayIUvGIOX
ZQqwoEGGY20l2IOWYAmkVgrBkA1BKIR9Ug/s8A2AaA7nkAuU8AZhxwX+FAgK
F7gKKqVStxaFK0RogVZ+r/eByABHsRAKmuCFfgAJmrB+llAKE9dqFFdZoWAK
qOiGuHBxGdeCG2V8n/gITBeKUQUO7bA4fNgnw9RMynAthJgIYEeBkqB28rUK
KXVryIhlyLgKm7AK2+ANs9eCW1hLqPgJlwAJnMh+n8h+nzALa/OCqYiKsKBc
wwB5U7dx6wAO0zBhn6AJlgAJgyCLjSdFiGMhRXgq8vANxqAM9pMLHncIiVAI
kiAJApmBwiALqzCQq7AKyYhlK7SQspAO25BCvJBcpnAJ14iRSOcHeqAHhPCO
dRiPQIYLptBatoALl6h8QJdhEAQOwwBno/D+joMQj90oDeAweXtCJTmxFecg
DbnAj2wHCodQCIlACQPZdSE3YpOwCQMpCc2IjC7kQggJDRLJCpiACY3QCJCg
kakICxypB45ACIMwgjP5CJrQWjc3dYyWG+YFQecAagyHdJYwCHgACbEQSn+T
k5QxFtPyk/aDUhEYkEcZjN2HCM0ICk7ZjAuZCviUT75AlelwC4BwBnOQB2IY
CqGQiZ+AjWygB17YB33whWJploRTDhnmQOugOVKRDcgwCw0HcY7QB3jwCaHD
fBYyUXsSD99wDLnwk0D5CqDwdV53iEjgBSjHkAu5CcqpnKvQmLLgC9aQDung
C5OJBZRpCIaQlY3+kAdhsHlt4AZe2AZ94AhhOYKucAy1eSaQVCB+gQy51HCW
8AiEgAeEAAssOSq32UekYg6r0pv2Yz8POAl0YIjByAVeYJyc0Jz4hAnLuZzN
+ZjWEJ2qAAhYUKEVmgVfgAVfQARCoAdtsAZk0JFt0AYdKYJ9EHF5uGBSwWa2
c4mtSWrFVwkz2QeagAwQNCqChZtSkiqE5J9RCZiHiIhhd6Aop5yIcKSYwArM
6KDQaQ3QAA2TGQVSKqVAsAM70ANC0KFuQAZp0JEeugaeSQihCQmjYAu2GCks
+mCulUs6GJ/zCQlmeqPxYJv4ch67aU6xcFJZtZRxgAQNCAZe0HlcUAb+o1dy
i2CYDcqQTQoNE4oFUxoFWaAGPTAFX1CphOAHbpAGXKqpa9CloQmWoWiTArea
uGALCqdwpGYJlaCqj+AHY1AKtWleVaGjXCEtGpSnWIUIJ4dyZVADNdB5SuCn
DVgGEpiYJPdu77YKy/CkTxqlUjqpWWAIGDoHhjAH2OgHZEAGV5CtncoGI+oH
jjAInDALKHgO7bBGrnBOt6cJj/AIMvoIg+AHeACrfNOWshNSXdGXroBVnGAH
RcACLFB2/yoDTCCsfjqoo6eYm0ByKbcJrLAMTuoLkumoUdADPXClWTAFU/AE
laqJhJCtIMsGaZAGV3AF4gma4jUM2cAzsND+eIgXkn0wCJUQs14IpzfJku+k
FeehNLaaC961EIjQBQALsP/KAhxQfQfbeXHglAvJjIsQB16ACJhwC9AQsZlw
BhVrsSpQAiWgAjBgAiawAjCADcOgCSCbrSNrBSXrqWNaClQzCp3QjkwHCXgw
Bm4Qj3zAByNaCtjCabKqSNriDtYxDYSEVZnnryzgA2tQAyxQAx7AAWswCH2A
BGDwBgIpCU3LjKDHBHaACczKqGjQBEBwsSqwtRkgARmQuqnrDrZ3tlJwBWlg
BbI7st7qrYSAeIdwCO36CZ1At0FABuQ5oiNqCdhyVG2Zs4DyC4Dkj5zwCCcn
BSxAA1dACFdQAz7+cAU+0I2nMKCWe7nKOQlxUAQyUAR2oApV6wu+kAkpoAJW
ugMrsLUlIARPIAQ7UAISgA2hgAcgWrJXIAVSYAViIAZpuwbeerJ5ywd9UIft
JwVrELxr0AePYAlStWk4C0FzCkHIcJVuawup0Lxt0AVF4L9tMAiq2gZ+MAqE
0FqaMAiCOqjbVwZjR7SYAKG+oApoYAElYKU9kLEWqwZzkLFbGwqNgAddMAba
qrb/KwZ6ELtqywZO/MR5m8COYIdXsAZ84AhucAV9gE7XMKobVl4XLA/nEArY
aYJ5ygl94AVKML12mH9KNwuaMMRjUL01IKwycMcyMLRFQLVPSp1DYAH+KXCl
PTAHhJwFUVClVqoC25kHeJCta6sFsisGWuAEUuAFaaAFmMwGWhAIneAJo+AI
geAJajuemkoIsbCS/8aSP8d74tAIYZCdCscJiLAGawwJ4sYy0kC4wxcGR3AE
L0ADHhDMwQywHNABHHC0hsDHEosGIWABKjC6OxCphtwDW8u+KpAHe5DNRrwG
H7oGVuAE4Oy/kHygWnAHWnAIpzALlnAHclAJVqAEXtAHadCJuGAOAHcxvNd7
W0MxeUAERPDKmKCr/zoGn0B0qxILcRwGI7DQL2C0HMAAxxzREb3Hj8momWAE
FuDMFrsD1ly6OTwFGYvNe8DIeOAGH3oFsgv+BT/gBFaAyUqAyQHMBhHnBmJw
B3wgBWvcBlZACK4wDfnMex3YbczQC5UFCWHgz/IbBtx5BC0QBpeQPnJWCXjg
yyMAARiAASAAAsfMAAxwAsLcAR3AAl2wDOhbw3VgAxLAtezbvhYrBDzwBNRa
mdk80iW9Big9sj+w0pjsBC8dwCzdBoTgA1ZwB2ngAz7gBCRLCLiwcUFNNkTC
hZWFkXtwBP7sAjDgAv5MBC4QAmEACZ7wCIfwBl7QAi0wAleNARDgAA+91cLs
AWAtA12QCaow26qQBBuQ1jncA0AABFPgw3NQqV9AyCIdBmEwBkacBmyA0j/w
zeCc104gBlbwA4b+LQU04ANSYNiHnQbgCQt41m0UQ9TWyJWQMAYv4AKWfdkw
cNkmEAJSkAjunQhgUAMgsNAoMAILkAAJ4AAOANES7QF4zARJgAZ1wAiMMAMW
kAFdmwWErAYMrgZZ4NY8YLHcycu9DAUhSgZSAAUs7QR5jQM/sARiwOE+QAMk
XuLVLQVksJW/UlNEjZEufgluaAvDAAlHMAIkcN7pDQMkQAJFQAeJoAiKUAhK
AAKnXQEVAAH4nQALwACqXcwd4N94bMw2kARJ8AEHnuBzoAYaq9s7ALZdqwJ7
QNzEvQdeeKkYbgVSkNc/QAM5AOIcbuImbt1rUJ+90AuucJEY6QhbqYr+a3OJ
ebDQIiACOw62O04CXlAITUYHQ+4AENDoCYDkSp4ABJAACqDaMzADBEvlMwDW
ET0BCM7RV9rlpbu1YSvIoSCCnhgLqNhahCC7hg3ONFADPyAGS7DmcE7iDLx5
lkAKlkCel9B0fH5/xbBTCn0BGqABF5C6F7DsGeAFYEd9RI7ajT7t9y3pk17p
M7AF2q7tVf4BH9ABH9AAGdDRo77WKuACT+DDaqCGrOhqGXcJVqCpUvDmh03r
P5ADty69X0gGnWgJcWths1COwp5cmhAGL7DsyH4BErDwGbDsRXCgPgACDrAA
p13xkE4AGE8ADsACSVAHHl8HWzADmh4CEZD+1uXOvtCKBRxLyHPgWUhCDuVQ
FqagB5fwCX1A3TSw0rSOAzhQA3D+A2wwCJDwkZ+giuXYKhRTWWE51S9AAqet
8AsvAREw9S0ABUHQAg6A341e8dKO5BmvABzA8R7P7dx+22m9A00QBVOABQ2e
5Vk6qVPw8r1BDmVBkpdoCdjr3NH9AzxPAydwAmzuBHcwxa6AC3U+8Aw3l3yQ
3EFA5BeAARXwAFAvAQ/wABEAAUcABS2A2vh9AI/e6Ee+9UmO3yFgA0yw7UxQ
BlvABCzQAAuvApF6BliAoRvr1l7OtXI/GOwCexmHDJCg3ZSs3Ho94oC/3HfA
yb0wDHX+gqQ2s07+zAfu3QZBsOzGXvlTf/2VfwC9LPFJ7vmXP+1aP/oIEAJG
QPZbUAcwzAGuP+5ZgAVN4L5fC7aBDral+1/jQA4deD1EgguQAJZWsAYAscbK
jxxa7rDxQYMGFCts+ETqFWzWKEt62rRh8waOokSJKK0ZcUHkA5IPIpg8+SDB
ixYYIiQ4EBPCTAgRIiBIkFNnggs2tvysw6jOlhkOImTIYEKFihImTCR9KkKE
iRU9hIwDBy7b1q3TphUbhssUITd63PBhY0WhkzuB2FwhM8YNpEORaJF61MZL
xjeJFFGilKhQmyIXIswsiVKCBAQ4R4yAsBMBCcqVL+DUuaDmhiRBM23++kO0
gQSkGSxYKI3ahAgePKZkmTOHq1dkxYrhgmXqkqM9bsi4GcRHzI8TJ9i2dTNG
rqVKkVCROgSmb0fqfPQqAYGBZmKbjBvPvNlY/IXKlA1HMKwTQYMZjDJlYhT6
A4LFpC04NcFjBw8hT/xnwUKNOaZBBplhwjLlk0sI6e03PwhhLhC1aDjhhzva
SkOKK9o4pBJSUKHlFMAOSYQOOthwwgcppGABMpogQKk773ISr0YE0ENPJMMo
eymBxjaoA74//kiCgsZIo6q1/rDAwj8ieIABBv3CiiWUBf3obY89CIHEkk8+
IQW6NqTwwQcrxDCDjTXW6KNDT8I8Jc5K+PD+wgslpHBiRSlaehECG20Kz0cb
G7PJpJpuIo8EmtabAZD46rDhpgeSFKLSSvdbQSoRMihhBRU+gURLN7R88JJL
TEHVlTBJ8eSRPi5qQww5+BjkkUoq8eTLTzw5xRNHDrlOzxX5pCkmGm8MD6cD
GjPAAPFOOuAkm268QIMKMKgAggYmQOPREG7UYIVM8XOqKRM0QJfTpUTdww9I
LvkkFFNgoRcWVVn1pJJH9h3kDjluzZUTgTlhzhNPDjmkjyuElQIKEDSDICaJ
lz3gARspbjbjpEio1gQYMgBXgwsgwACDBIyoo44ujFysNJdNK40qGIDIIgsu
L9EE1XrpjcUUS8L+7KQTgwWu5BB/3RyYk3xxnfMthqFweCaYJha0RmeXFS/j
C6KkbGYVMqhWhJsiMDkDI7awoQH6GCOtKRhWMKHTpabwT8A5dN45t080IQSP
NQLp5BBHbuXkkUP48DcQSpLm5NZ9DxlOxadBiGyBiQ+o2sZms948Rwi2VsGE
C0QgwgQJbPJxAxsmOLJtFXgAIvYddpgCiB2yeGIK3afApXfcYlGQkDGgCMIH
CwMR/FZ9jUZTkEqS1neQPvpggwocJF8RrjEoX8ByY48dNGNnmxVg2QdGPqqE
DCIQ4QkgYDCssQaMROCBDFSAoYkAmWwCiNbE3YEKxOUUKpkCEngYng/+arBA
JFRBDoEYxCFqhTCE3YEKcjjE4gp3OD68Sgs6+IETFkYGErrBDSDQCdWqZgBB
iU98BChfoehjAcY8wAU74Fp6EGCADIjABUBoQhCn0L8drAAGTvFUCdSXAQmE
gm94kAKFGFgFMIABDlVwiEP4wAfkHSIQYhADGGhFPTaw4VVX+MEPxJAGK8DF
hKN6AY1yEhPObW6HLmwWDCt2LpEtBWQP0IDHOPaSxiTJdktRYiLNtZSnUGUH
eIBCmWqABEpyoYqXVIITtLBJLYjhQp8UAxW1UKcrlFJPaQAjG9pgQi3tIY4+
Ah8exyfLzWkAh1LpnwokAEinrK8xD2hbCZb+spTZqWB2++EB3JyiginMQQnP
RAIXpGlJMFRBCQk5QQ1C6IQqVAFNZjDDHULpTTZ4QQp3ugKbyMgGE/rBnXsY
gRxpREt6ZuwBRxydEGIHAw1gQARHXB+gSJMUYQJRdzVr0hOg5IL89EANb4Ao
RMHABSQoQSEnQAEIQHCCHISwClQwAxVESoVQikELDmnDhtpQqz5oyA148ANM
exNPHxmAAAmwaT1pWT4fioAELugfPyHggidgoQnwmwl5ogREJmXhC194ghCk
xIPXSWkFPFAEHN4wUSQsEAVfBUELYhADheDACUsAqUi7uYQlbNKT1nlErR6x
Bh9AAQ93jSkC45n+MQL0lQA6xWNfBdDTCwC1CTsQQWGJwCQgKOoAFfipC2Bg
KSEQwQWX5c8TatY/uMGBqzWgAQtY0ALSinWsNPABDnDA1pBSoQpOgG0nwXkH
PuwrrnS9Al6xtIcwmMyvAvBrTgFrU8EigDwiEUIQecAxEsBgiDCQrE9J4FMT
kKC65enPF9SghiwQ0QsJEW1pSzvWGKCABk5QrQ5uINIlECSNmgTnAzu4xbSs
4a54aOURfAtD4ArAv8ANbh7/6lf+/lcDlMEAEb4wBR6I4Fov0O5To+qCn0aJ
wtPlmD9d0Boe9GB3QYiBeEU8VvOqkSDqvcESboCDHLRYtUtwoL8+eYf+Nroh
r1rSbwIE+1//EtjHP+4vAARwrZG5oD9CcMFjRgBUuk2YMpeFMpRgMAJNXXUK
WNDdWEU8XvLSwMQ3AHOYb6ADMq8YB1UwgxzU3JY7aEEKZMgrfntLYB4DV8A/
9nH3RvACPpMAAyMgwhOasFxsVYBmT8UddF9ABEYHWqpSqUAFfLgDIOhuvFsO
8WnVeFa0jtTTr12CGOCw5kCUOkO5vS9vMfDbOg8Yz32VSQVecIQw5CEPR3jB
Y4jaBKkWWgja3a5RXbBo/0S1UsmUSrpulwXThnjEMQhCEBjiVnBW29qflMOM
P5mW3I5qD3mYMwAK/F88A7ivC9jzEZTz7Vv+lwwDJEhu/5KsYSHoTt6YlVJ/
7P2+cfEgC2poNqajHQRUetJfcIjvqNX8wIVr2wxgvAIrtdTbAAi5zjwWLIH1
jIIgqFs5YQjDEZTcXCxkoQfwOwnpgo2FL7iACMlNrr2JGLqr9oe05BXvEaQN
tTSIc+FyqDYcBDH0n8sBDnC40MLFIAWJK+cFC7A4AKQudf9SHbgBwHr3FvDn
EXz1MSi4VqFfoNkpSNXPS9Yslp9w2ZnNrlJRaMLuJKzQTGt54NGGGhQKLiug
B33oRFczOI/uL0HIIUUvvatyjlCBqTfe8VLHeuQlH4DuUR7rByBZBQD9BZYj
+QLYEkG96YZkIwL+wSq5+/d2v5CFsvPg7jq/e96hIIVOoqnoRv874I2O9LaI
oUwIDINyxqDfx0N+8lgfQPKVf3ysE0DzmncBk6AKAxI8oAJE3a4asFDZeDd5
d1PoQQ+KuAIf3D3aOj+C7I0HRjAWXeiRgH8kAG/SUVLIBx//+NOZH3nl99//
/4+8BcgWzROCkusu6vszI4u7sosSKemBYruykouC8NuBIiCegTuCDNS5vCOr
jmIrMPKXhRu6SCg1caqCHwCtGiiOIFCONVA8EPg//yuAGaRBGhwAG+y/yAOA
SNO8/KmZKdgB0RFAGAiQ2Ni+FXiCCHsqowK/AFKBvIs2H8jAFtjA2Qu6AhQo
jhxgMbNiqy5co01yAoIojhPwgBOAtrhQDuJBgQK4QTaswTeEwxq8weXDOgAQ
QGyBt9VjvQa7FqL6tzloEiMjuyYDgtxpQl5AxERUREQsEESMhUd8RF6whUmc
xN6hRF7ABUeEREYsEGRwxFAAxVAUxVEMhVIohVA8RVIkxVZgxV/4hWeARVdk
xVZ0RVlshVrERVjUxX/gxV70xV8ExmAUxmEkxmI0xmNExmRUxmVkxmZ0xmfs
xYAAADs=
} -gamma 1.0 -height 0 -width 0

image create photo tkpaint_icon -data {
iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAFNQDtUAAAD90lEQVRYhc2Xa2gcVRTHfzM7
ee6WbSKGfvBzjMmmD1BBq9kFbUFFKhjT0iAGm0JRSYOIRHzVWptgpY2mYkGlVRCiQhViQw1K
mpak9dHYNoltMelunm2aNppkU8maneuHONvJvHY2qZA/XNi5c87//O+55547K4lYDCMUAFWO
Cm3i3XNxZO3h2/rKhKUkYjGTpaL90FAT8EuSMZBc1z0hVDkqNPdEgOixIhIT+/c04Av13IxW
1z2RiGaaMKIm4JcQsRi1nWMiPjueGLuqykW8pUVo7xS916EDn1JasJdX9s7FRTWEqwn4JWMo
TYZpoUYoemtL1HaOCRGLoResjdrOMSEbHSRJorrqADMzM4AulRqmWgtZWzhJRkaG2WC6rYgj
XWU8te3l+SIBwn0Rsu9sZWMwz3oVNYHAXC5U/esJ4bg3popwzIcNAVhUgNXWWEHvMy8bNQG/
pJWlcQjPtGj5oF788PFHQpWj8+rAlHMjJAmONDzLVGshV6PtdE9GTTaKhV8Ch/dtZf2aDoLF
0Nyzmc2vvWppZ6tkdnaWYPk7NJ97El+oh7LnrQkcSRRF4ba8PMqqdjqJBXRnIdXt1WDZORaC
eYlNRY1+i5O2GzdkinHCrbNlxWoEdhVrHClVrIYLPecZbmxm9Mqo6Z0rkt6Lf/DhJ79wfmiE
Mwe/Tp0k3NvH7UOPs+OROhp/v06wektqJOHeS+REHsPj8TAbl2nYX0VmVpZ7kkhfmOWRR1EU
Dzf+lvCV/ERWtpnAlkQIQf+JetL+I8h+4CRer9dWsSXJV583Eqx4n67h9WTe345v2TJbArDp
J4cO/kb+Xfncu+k9PB6PI4EtydG2PQjh/iQklqOVsaz6JCnulWTV5zj0Zb/gU6zHgu8dUytY
CjBtzmL6U6qwzYiViFR6XTI48dteOvpeeauEwFwlW8WyPMGLzYIkSVy7eo2RwWEm/ppwxe+6
0bsVEOmLUL3tDc589g15F4bIPNXDF7v2oaqqo6/j500qAgbCEbqa3uS+gp9ZtWItTaP5NB29
SIl/Eu+KXEjSmRYtZDDSz9mmnYSKT1FSDCBRGuwg9OdJjg1UsOG57ShpaUl5FixksH+A04ff
5qHVHYSKb85PTauc6H+GJypfpCI93TVfykIuD4/Q8eUO1q1u5+E1egFxjofL2bDlJcosbthk
SKlYI72XGL18hdDTu+keWUdc/YfojTjfnS3FHzzNxhdet7zmb6mQ8evjtH7fRkFRIbLHw/KV
lfw4uhvfg7+yaftbZPvsb3k3cL01siyz6u5i0jPSyczKJCc3h8KVgUUFTypE/39YVn0SQK7f
R+49d8wZOLeEpLBq9UvvrnEy/r+wJL9H/gU3rSnly96NAwAAAABJRU5ErkJggg==
} -format {png -alpha 1.0} -gamma 1.0 -height 0 -width 0
set ::update 1
global macos
set macos 0
switch [tk windowingsystem] {
    classic - aqua {
	    set macos 1
    }
}
#Тип -fill: name - это цвет или градиентсная заливка?
proc filltype {name}  {
    if {[catch {winfo rgb . $name} result ] == 0} {
        return "color"
    }
    if {[catch {.c gradient type $name} result ] == 0} {
        return "gradient"
    }
    return "bad"
}

#Радианы в градусы и наоборот
proc radian2degre {radian} {
    set pi [expr {2 * asin(1)}]
    return [expr {$radian * 180.0 / $pi}]
}
proc degre2radian {degre} {
    set pi [expr {2 * asin(1)}]
    return [expr {$degre * $pi / 180}]
}
proc id2coordscenter {id} {
#Координаты прямоугольника вокруг объекта
    foreach {x0 y0 x1 y1} [.c bbox $id] {break}
#точка вращения - центр
    set xc [expr {($x1 - $x0) / 2.0 + $x0 }]
    set yc [expr {($y1 - $y0) / 2.0 + $y0 }]
    return [list $xc $yc]
}
proc id2anglerotate {id} {
#Получить Угол на который повёрнут объект SVG
    set m [.c itemcget $id -m]
    if {$m == ""} {return }
#Угол поворота вокруг оси
	set rad [lindex [lindex $m 1] 1]
	if {[expr {abs($rad)}] <= 1} {
#	    set angrad [radian2degre [expr {acos($rad)}]]
	    set angrad [radian2degre [expr {asin([lindex [lindex $m 1] 0])}]]
	} else {
#Разобраться с mult!!!!!
puts "id2anglerotate: Разобраться с mult!!!!!"
	    set angrad 0
	}
    set ind0 [expr {abs([lindex [lindex $m 0] 1])}]
    set ind1 [expr {abs([lindex [lindex $m 1] 0])}]
    if { $ind0 != $ind1} {
#Угол смещения по оси X
	set angX [radian2degre [expr {atan([lindex [lindex $m 1] 0])}]]
#Угол смещения по оси Y
	set angY [radian2degre [expr {atan([lindex [lindex $m 0] 1])}]]
    } else {
#Разобраться с mult!!!!!
	set angX  0
	set angY  0
    }
    return [list $angrad $angX $angY]
}
#Получить значение utagxxx
proc id2utag {id} {
    set ut [.c itemcget $id -tags]
    set utagnum [lsearch $ut utag*]
    if {$utagnum == -1} {
	return ""
    } 
    return [lindex $ut $utagnum]
}
#Получить из матрицы данные
proc deltaTransformPoint {m point}  {
    set a [lindex [lindex $m 0] 0]
    set b [lindex [lindex $m 0] 1]
    set c [lindex [lindex $m 1] 0]
    set d [lindex [lindex $m 1] 1]
    set e [lindex [lindex $m 2] 0]
    set f [lindex [lindex $m 2] 1]

    set x [lindex $point 0]
    set y [lindex $point 1]
#return matrix.deltaTransformPoint(point);
    set dx [expr {$x * $a + $y * $c + 0}]
    set dy [expr {$x * $b + $y * $d + 0}]
    return [list $dx $dy]
}
proc decomposeMatrix {m} {
    set a [lindex [lindex $m 0] 0]
    set b [lindex [lindex $m 0] 1]
    set c [lindex [lindex $m 1] 0]
    set d [lindex [lindex $m 1] 1]
    set e [lindex [lindex $m 2] 0]
    set f [lindex [lindex $m 2] 1]
    set E [expr {$a + $d} / 2.0]
    set F [expr {$a - $d} / 2.0]
    set G [expr {$c + $b} / 2.0]
    set H [expr {$c - $b} / 2.0]

    set Q [expr {sqrt($E * $E + $H * $H)}]
    set R [expr {sqrt($F * $F + $G * $G)}]
    set a1 [expr {atan2($G, $F)}]
    set a2 [expr {atan2($H, $E)}]
    set theta [expr {($a2 - $a1) / 2.0}]
    set phi [expr {($a2 + $a1) / 2.0}]

# The requested parameters are then theta, 
# sx, sy, phi,
    set PI [expr {2 * asin(1)}]
# calculate delta transform point
    set px [deltaTransformPoint $m [list 0 1]]
    set py [deltaTransformPoint $m [list 1 0]]

    set skewX  [expr {(180 / $PI) * atan2([lindex $px 1], [lindex $px 0]) - 90}]
    set skewY  [expr {(180 / $PI) * atan2([lindex $py 1], [lindex $py 0])}]
    set transform(translate) "$e $f"
    set transform(rotate) [expr {-1.0 * $phi * 180 / $PI}]
    set transform(scaleX) [expr {$Q + $R}]
    set transform(scaleY) [expr {$Q - $R}]
    set transform(skewX) $skewX
    set transform(skewY) $skewY
    set transform(skew) [expr {-1.0 * $theta * 180.0 / $PI}]
    return [array get transform]
    
#    set ret "'transform='translate($e $f) rotate([expr {-1.0 * $phi * 180 / $PI}]) scaleX([expr {$Q + $R}]) scaleY([expr {$Q - $R}]) skewX($skewX) skewY($skewY) skew([expr {-1.0 * $theta * 180.0 / $PI}])'"
#    return $ret
}

#Получить значение матрицы
proc id2matrix {id} {
    set m [.c itemcget $id -m]
    return $m
}
# 0 - это объект TK, 1 - это объект svg
proc idissvg {id} {
    set ut [.c itemcget $id -tags]
    set svg [lsearch $ut "svg"]
    if {$svg == -1} {
	set  ret 0
    } else {
	set ret 1
    }
    return $ret
}
#Вернуть объект в исходное (угол поворота 0)
proc id2angle0 {id } {
    if {[idissvg $id] == 0} {return}
    set m [list {1.0 0.0} {-0.0 1.0} {0.0 0.0}]
    .c itemconfigure $id -m $m
    if {$id == "Selected"} {
	drawBoundingBox
    }
}
#Повернуть id на угол
proc rotateid2angle {id deg {retm 0}} {
    set pi [expr 2*asin(1)]
    set phi [expr {$deg * $pi / 180.0}]
#puts "rotateid2angle id=$id deg=$deg phi=$phi"
    set coors [id2coordscenter $id]
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$coors "
    foreach {xr yr} [id2coordscenter $id] {break}
#    set m1 [::tkp::matrix rotate $phi [lindex $coors 0] [lindex $coors 1]]

#С КООРДИНАТАМИ ЛЕВОООГО ВЕРХНЕГО УГЛА
#foreach {xr  yr x1 y1} [.c bbox $id] {break}


    set m1 [::tkp::matrix rotate $phi $xr $yr]
	if {$retm != 0} {
	    return $m1
	}
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
#Читаем что было
set mOrig [.c itemcget $id -m]
#puts "rotateid2angle: m1=$m1\n\tmOrig=$mOrig"
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $mOrig $m1]
#puts "rotateid2angle Full: m1=$m1\n\tmOrig=$mOrig"
    }

    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
    return
}
#scale id -  масштабировать объект по x и y
proc scaleid2xy {id x y {retm 0}} {
    if {[.c type $id] == ""} {
	return
    } 
#Матрица для scale
    set m1 [::tkp::matrix scale $x $y]
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
    if {$retm != 0} {
	return $m1
    }
    set mOrig [.c itemcget $id -m]
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $mOrig $m1]
    }
#сохраняем координаты центра масштабируемого объекта
    foreach {xc yc} [id2coordscenter $id] {break}
    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
#сохраняем координаты центра объекта после масштабирования
    foreach {xe ye} [id2coordscenter $id] {break}
#Возвращаем объект в исходную точку 
    moveid2dxdy $id [expr {$xc - $xe}] [expr {$yc - $ye}]
    return
}
#skewy id - сдвиг по оси y
proc skewyid2angle {id deg {retm 0}} {
    set pi [expr 2*asin(1)]
    set phi [expr {$deg * $pi / 180.0}]
#Матрица для оси Y
    set m1 [::tkp::matrix skewy $phi]
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
	if {$retm != 0} {
	    return $m1
	}
set mOrig [.c itemcget $id -m]
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $mOrig $m1]
    }
    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
    return
}
#skewy id - сдвиг по оси y
proc skewxid2angle {id deg {retm 0}} {
    set pi [expr 2*asin(1)]
    set phi [expr {$deg * $pi / 180.0}]
#Матрица для оси X
    set m1 [::tkp::matrix skewx $phi]
	if {$retm != 0} {
	    return $m1
	}
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
#Читаем что было
set mOrig [.c itemcget $id -m]
#puts "rotateid2angle: m1=$m1\n\tmOrig=$mOrig"
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $mOrig $m1]
#puts "rotateid2angle Full: m1=$m1\n\tmOrig=$mOrig"
    }
    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
    return
}
#translate id -переместить в точку x и y - к сожалению нет функции translate
proc translateid2point {id dx dy {retm 0}} {
#Матрица для оси X
    set m1 [::tkp::matrix translate $dx $dy]
	if {$retm != 0} {
	    return $m1
	}
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
#Читаем что было
set mOrig [.c itemcget $id -m]
#puts "rotateid2angle: m1=$m1\n\tmOrig=$mOrig"
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $mOrig $m1]
#puts "rotateid2angle Full: m1=$m1\n\tmOrig=$mOrig"
    }
    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
    return
}
#move id - переместить по оси x и y на dx и dy
#Tckb retm != 0, то возвращается созданная матрица
proc moveid2dxdy {id dx dy {retm 0}} {
#    moveGroupSVG $dx $dy
#return

#Матрица для оси X
    set m1 [::tkp::matrix move $dx $dy]
	if {$retm != 0} {
	    return $m1
	}
#puts "rotateid2angle id=$id deg=$deg phi=$phi coors=$xr $yr m=$m1"
#Читаем что было
set mOrig [.c itemcget $id -m]
#puts "rotateid2angle: m1=$m1\n\tmOrig=$mOrig"
    if {$mOrig != ""} {
	    set m1 [::tkp::matrix mult $m1 $mOrig]
#puts "rotateid2angle Full: m1=$m1\n\tmOrig=$mOrig"
    }
    .c itemconfigure $id -m $m1
    if {$id == "Selected"} {
	drawBoundingBox
    }
    return
}
#LISSI копирование группы с учетом поворота
proc moveGroupSVG {x y} {
    global lastX lastY BBox
#puts "moveGroupSVG: START x=$x y=$y"
    if {[info exists lastX]} {
#Перейти в точкус координатами  x,y
	set dx [expr {$x - $lastX}]
	set dy [expr {$y - $lastY}]
    } else {
#Сдвиг на дельту x и y
	set dx $x 
	set dy $y 
    }
#catch {unset idrotate}

    foreach id [.c find withtag Selected] {
#Сохраняем угол поворота
	set tid [idissvg $id]
	if {$tid == 1} {
#SVG-объект
	    set mv [::tkp::matrix move $dx $dy]
	    set mOrig [.c itemcget $id -m]
	    if {$mOrig != ""} {
#puts "moveGroupSVG: mv=$mv"
#puts "moveGroupSVG: mOrig=$mOrig"
		set m_Mult [::tkp::matrix mult $mv $mOrig]
		.c itemconfigure $id -m $m_Mult
	    } else {
		.c itemconfigure $id -m $mv
	    }

	} else {
	    .c move $id $dx $dy
	}
    }

    drawBoundingBox
    if {[info exists lastX]} {
	set lastX $x
	set lastY $y
    }
}
#Экспорт group в SVG-формат
proc TP_Group2SVGfile {} {
#Если нет выделенной группы, то сохраняется весь проект
    if {[llength [.c find withtag Selected]] == 0} {
	selectAll
    }

    set File(img,types) {
	{{img svg} {.svg} }
	{{All files} * }
    }
    set type        "svg"
        set title       "Select file for SVG"
        set command tk_getSaveFile
        set filename [$command \
                -title "$title" \
                -filetypes $File(img,types) \
                -defaultextension ".$type" ]
        if {$filename==""} {return 0}

    set ret [can2svg::group2file .c $filename]
    if {$ret != ""} {
        tk_messageBox -title "Export group to SVG" -message "SVG-file: $ret"  -icon info
    }
}


#Анимация SVG
proc TP_anim {w} {
  namespace eval ::textanchor {
    set x0 25
    set y0 25

    set anchors [list c]

    set fs 25

    for {set i 0} {$i < [llength $anchors] } {incr i} {
        set a [lindex $anchors $i]
        set x $x0
        set y $x0
        set t "SVG"
	set w ".anim"
        $w create ptext $x $y -text $t -fontfamily Times -fontsize $fs -fill chocolate1 -textanchor $a -tags $a
    }
    set phi [expr 15.0/180 * 3.14]

    proc ticker {deg step tim x y} {
	set w ".anim"
        variable anchors
        if {[winfo exists $w]} {
            after $tim [list textanchor::ticker [expr [incr deg $step] % 360] $step $tim $x $y]
            set phi [expr 2*$deg*3.14159/360.0]
            for {set i 0} {$i < [llength $anchors] } {incr i} {
                set a [lindex $anchors $i]
                set m [::tkp::matrix rotate $phi $x $y]
                $w itemconfig $a -m $m
            }
        }
    }

    ticker 0 2 40 $x $y

  }
}
#Вычисляем радиус и координаты центра по трём точкам
proc TP_radiuscoords {} {
    global Arc
    set p1_x [lindex $Arc(p1) 0]
    set p1_y [lindex $Arc(p1) 1]
    set p2_x [lindex $Arc(p2) 0]
    set p2_y [lindex $Arc(p2) 1]
    set p3_x [lindex $Arc(p3) 0]
    set p3_y [lindex $Arc(p3) 1]
#Вычисляем сторону b,a, c
    set b [expr {sqrt (pow($p2_x - $p1_x, 2) + pow($p2_y - $p1_y, 2))}]
    set a [expr {sqrt (pow($p3_x - $p2_x, 2) + pow($p3_y - $p2_y, 2))}]
    set c [expr {sqrt (pow($p3_x - $p1_x, 2) + pow($p3_y - $p1_y, 2))}]
    puts "$a $b $c"
#Вычисляем углы alpha, beta, gamma
    set alpha [expr {acos((pow($b, 2) + pow($c, 2) - pow($a, 2)) / (2.0 * $b * $c)) }]
    set alphad [TP_radiantodegre [expr {acos((pow($b, 2) + pow($c, 2) - pow($a, 2)) / (2.0 * $b * $c)) }]]
    puts "alpha=$alpha alphad=$alphad"
    set beta [expr {acos((pow($c, 2) + pow($a, 2) - pow($b, 2)) / (2.0 * $c * $a)) }]
    set betad [TP_radiantodegre [expr {acos((pow($c, 2) + pow($a, 2) - pow($b, 2)) / (2.0 * $c * $a)) }]]
    puts "beta=$beta betad=$betad"
    set gamma [expr {acos((pow($a, 2) + pow($b, 2) - pow($c, 2)) / (2.0 * $a * $b)) }]
    set gammad [TP_radiantodegre [expr {acos((pow($a, 2) + pow($b, 2) - pow($c, 2)) / (2.0 * $a * $b)) }]]
    puts "gamma=$gamma gammad=$gammad"
    set radius [expr {$a / (2 * sin($alpha))}]
    puts "radius=$radius"
#Вычисляем координаты центра
set A [expr {$p2_x - $p1_x}]
set B [expr {$p2_y - $p1_y}]
set C [expr {$p3_x - $p1_x}]
set D [expr {$p3_y - $p1_y}]
set E [expr {$A * ($p1_x + $p2_x) + $B * ($p1_y + $p2_y)}]
set F [expr {$C * ($p1_x + $p3_x) + $D * ($p1_y + $p3_y)}]
set G [expr { 2 * ($A * ($p3_y - $p2_y) - $B * ($p3_x - $p2_x))}]
if {$G == 0} {puts "Ошибка"; return}
set Cx [expr {($D * $E - $B * $F) / $G}]
set Cy [expr {($A * $F - $C * $E) / $G}]
puts "Cx=$Cx Cy=$Cy"

    return [list $radius $Cx $Cy]
}
proc TP_radiantodegre {rad} {
    return [expr {$rad * 180.0 / 3.1415926}]
}

#Список команд создания картинок
proc TP_Clone_images { } {
# Generate and return image loading code
    set rtnval {}
    foreach picture [lsort [image names]] {
	if {[image inuse $picture] == 0}  {
	    continue
	}
	if {[image type $picture] != "photo"}  {
	    continue
	}
	set indim [string first "image" $picture]
	if {$indim == -1} {
	    set indim1 [string first "Tkpaint_image" $picture]
	}
	if {$indim == -1} {
	    continue
	}
	    set type [image type $picture]
	    set cmd "image create $type $picture"
	    foreach option [$picture configure] {
		  set optval [lindex $option 4]
		  if {$optval != {}} {
		      lappend cmd [lindex $option 0] $optval
		    } elseif {[lindex $option 0] == "-data"} {
		      set optval [$picture data -format "png"]
		      lappend cmd [lindex $option 0] $optval
		    }
	    }
	    append rtnval $cmd\n
    }
    append rtnval "\n"
    return $rtnval
}
proc TP_CloneGradients { } {
# Generate and return image loading code
    set rtnval {}
    foreach grad [.c gradient names] {
	if {[.c gradient inuse $grad] == 0}  {
	    continue
	}
	    set type [.c gradient type $grad]
	    set cmd ".c gradient create $type "
	    foreach option [.c gradient configure $grad] {
		  set optval [lindex $option 4]
		  if {$optval != {}} {
		      lappend cmd [lindex $option 0] $optval
		    } 
	    }
	set cm1 "set $grad \["
	append cm1 "$cmd \]"
	    append rtnval $cm1\n
    }

    append rtnval "\n"
    return $rtnval
}

proc CloneGradForCanvad {grd canvas }  {
# Generate and return image loading code
    set rtnval {}
puts "CloneGradForCanvad: grd=\"$grd\""
    if {$grd == "" } {
	set grlist [.c gradient names]
    } else {
	set grlist $grd
    }
#puts "CloneGradForCanvad: grlist=\"$grlist\""

    foreach grad $grlist {
	if {[.c gradient inuse $grad] == 0}  {
	    continue
	}
	    set type [.c gradient type $grad]
	    set cmd "$canvas gradient create $type "
	    foreach option [.c gradient configure $grad] {
		  set optval [lindex $option 4]
		  if {$optval != {}} {
		      lappend cmd [lindex $option 0] $optval
		    } 
	    }
#puts "CloneGradForCanvad: cmd=\"$cmd\""
	set cm1 "set $grad \["
	append cm1 "$cmd \]"
	    append rtnval $cm1\n
    }
puts "CloneGradForCanvad:END rtnval=\"$rtnval\""
#eval $rtnval
    append rtnval "\n"
    return $rtnval
}


# Procedure: TP_ImageEncode
proc TP_ImageEncode { args} {
# Code taken from base64.tcl in tcllib 1.3
#
# Encode/Decode base64 for a string
# Stephen Uhler / Brent Welch (c) 1997 Sun Microsystems
# The decoder was done for exmh by Chris Garrigues
#
# Copyright (c) 1998-2000 by Ajuba Solutions.
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#

set base64_en {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 + /}

# Set the default wrapchar and maximum line length to match the output
# of GNU uuencode 4.2.  Various RFC's allow for different wrapping
# characters and wraplengths, so these may be overridden by command line
# options.
set wrapchar "\n"
set maxlen 60

if { [llength $args] == 0 } {
    error "wrong # args: should be \"[lindex [info level 0] 0] ?-maxlen maxlen? ?-wrapchar wrapchar? string\""
}

set optionStrings [list "-maxlen" "-wrapchar"]
for {set i 0} {$i < [llength $args] - 1} {incr i} {
    set arg [lindex $args $i]
    set index [lsearch -glob $optionStrings "${arg}*"]
    if { $index == -1 } {
	error "unknown option \"$arg\": must be -maxlen or -wrapchar"
    }
    incr i
    if { $i >= [llength $args] - 1 } {
	error "value for \"$arg\" missing"
    }
    set val [lindex $args $i]

    # The name of the variable to assign the value to is extracted
    # from the list of known options, all of which have an
    # associated variable of the same name as the option without
    # a leading "-". The [string range] command is used to strip
    # of the leading "-" from the name of the option.
    #
    # FRINK: nocheck
    set [string range [lindex $optionStrings $index] 1 end] $val
}

# [string is] requires Tcl8.2; this works with 8.0 too
if {[catch {expr {$maxlen % 2}}]} {
    error "expected integer but got \"$maxlen\""
}

set string [lindex $args end]

set result {}
set state 0
set length 0

# Process the input bytes 3-by-3
binary scan $string c* X
foreach {x y z} $X {
    # Do the line length check before appending so that we don't get an
    # extra newline if the output is a multiple of $maxlen chars long.
    if {$maxlen && $length >= $maxlen} {
	append result $wrapchar
	set length 0
    }

    append result [lindex $base64_en [expr {($x >>2) & 0x3F}]]
    if {$y != {}} {
	append result [lindex $base64_en [expr {(($x << 4) & 0x30) | (($y >> 4) & 0xF)}]]
	if {$z != {}} {
	    append result  [lindex $base64_en [expr {(($y << 2) & 0x3C) | (($z >> 6) & 0x3)}]]
	    append result [lindex $base64_en [expr {($z & 0x3F)}]]
	} else {
	    set state 2
	    break
	}
    } else {
	set state 1
	break
    }
    incr length 4
}
if {$state == 1} {
    append result [lindex $base64_en [expr {(($x << 4) & 0x30)}]]== 
} elseif {$state == 2} {
    append result [lindex $base64_en [expr {(($y << 2) & 0x3C)}]]=
}
return $result
}

#Font select
proc ShowWindow.tpfontselect { args} {
global TPfontFamily
global TPfontSize
global TPfontStyle

    global fontCmdCancel
    global fontCmdItem
    global TPcurCanvas
    set TPcurCanvas ".c"

  catch "destroy .tpfontselect"
  set id $args
  set ffamOrig [.c itemcget $id -fontfamily]
  set TPfontFamily $ffamOrig
  set fsizeOrig [.c itemcget $id -fontsize]
  set TPfontSize [expr {int($fsizeOrig)}]
  set fslantOrig [.c itemcget $id -fontslant]
  set fweightOrig [.c itemcget $id -fontweight]
  set TPfontStyle [list $fweightOrig $fslantOrig]
  set fontCmdCancel [subst ".c itemconfigure $id  -fontfamily $ffamOrig -fontsize $fsizeOrig -fontweight $fweightOrig -fontslant $fslantOrig"]
  set fontCmdItem "if {\[llength \$TPfontStyle] < 2} {lappend TPfontStyle normal};"
#  set fontCmdItem [subst ".c itemconfigure $id"]
  append fontCmdItem [subst ".c itemconfigure $id"]
  append fontCmdItem  " -fontfamily \$TPfontFamily -fontsize \$TPfontSize -fontweight \[string tolower \[lindex \$TPfontStyle 0]] -fontslant \[string tolower \[lindex \$TPfontStyle 1 ] ]"

  toplevel .tpfontselect   -relief {raised}  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tpfontselect program
  wm sizefrom .tpfontselect program
  wm maxsize .tpfontselect 2560 1024
  wm minsize .tpfontselect 600 285
  wm protocol .tpfontselect WM_DELETE_WINDOW {global TPfontCmd
global TPshowFonts

set TPfontCmd {}
.tpfontselect.frame1.frame.listbox1 delete 0 end
#catch {$TPcurWidget configure -$TPpropsInfo(propname) $TPpropsInfo(propval)}
set TPshowFonts 0
DestroyWindow.tpfontselect}
  wm title .tpfontselect {TKsvgpaint font selection}

  # bindings
  bind .tpfontselect <ButtonRelease-1> {TP_ProcessClick %W %X %Y %x %y}
  bind .tpfontselect <Shift-Button-3> {TP_PropsSelWidget %W}

  frame .tpfontselect.frame1  -borderwidth {2}  -background {#dcdcdc}  -height {224}  -highlightbackground {#dcdcdc}  -width {166}

  label .tpfontselect.frame1.label3  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {0}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {Font:}

  entry .tpfontselect.frame1.entry4  -background {#eeeeee}  -disabledbackground {white}  -disabledforeground {black}  -font {Helvetica 10}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -state {disabled}  -textvariable {TPfontFamily}

  frame .tpfontselect.frame1.frame  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

#LISSI
#  scrollbar .tpfontselect.frame1.frame.scrollbar2  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -command {.tpfontselect.frame1.frame.listbox1 yview}  -cursor {left_ptr}  -highlightbackground {#dcdcdc}  -relief {raised}  -troughcolor {#dcdcdc}  -width {12}
  ttk::scrollbar .tpfontselect.frame1.frame.scrollbar2 -command {.tpfontselect.frame1.frame.listbox1 yview} 

  listbox .tpfontselect.frame1.frame.listbox1  -background {#eeeeee}  -font {Helvetica 10}  -height {6}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -width {34}  -yscrollcommand {.tpfontselect.frame1.frame.scrollbar2 set}
  # bindings
  bind .tpfontselect.frame1.frame.listbox1 <<ListboxSelect>> {set TPtemp [%W curselection]
  if {$TPtemp ne {}} {set TPfontFamily [%W get $TPtemp]}
#.tpfontselect.frame1.frame5.canvas0 itemconfigure sample -font  [TP_FontGetSelected]
#LISSI
.tpfontselect.frameSample.canvas0 itemconfigure sample -font  [TP_FontGetSelected]

catch $TPfontCmd
    eval $fontCmdItem
    drawBoundingBox

}

  frame .tpfontselect.frame1.frame5  -borderwidth {2}  -relief {groove}  -background {#dcdcdc}  -height {26}  -highlightbackground {#dcdcdc}  -width {302}

  label .tpfontselect.frame1.frame5.label6  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {Sample}

  canvas .tpfontselect.frame1.frame5.canvas0  -background {#dcdcdc}  -height {53}  -highlightbackground {#ffffff}  -relief {raised}  -width {271}

  frame .tpfontselect.frame2  -borderwidth {2}  -background {#dcdcdc}  -height {224}  -highlightbackground {#dcdcdc}  -width {130}

  frame .tpfontselect.frame2.frame9  -background {#dcdcdc}  -height {126}  -highlightbackground {#dcdcdc}  -width {76}

  entry .tpfontselect.frame2.frame9.entry11  -background {#eeeeee}  -disabledbackground {white}  -disabledforeground {black}  -font {Helvetica 10}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -state {disabled}  -textvariable {TPfontStyle}  -width {10}

  listbox .tpfontselect.frame2.frame9.listbox12  -background {#eeeeee}  -font {Helvetica 10}  -height {6}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -width {10}
  # bindings
  bind .tpfontselect.frame2.frame9.listbox12 <<ListboxSelect>> {set TPtemp [%W curselection]
  if {$TPtemp ne {}} {set TPfontStyle [%W get $TPtemp]}
#.tpfontselect.frame1.frame5.canvas0 itemconfigure sample -font [TP_FontGetSelected]
#LISSI
.tpfontselect.frameSample.canvas0 itemconfigure sample -font [TP_FontGetSelected]

if {[string length $TPfontCmd] > 0} {
     catch $TPfontCmd
    eval $fontCmdItem
    drawBoundingBox
   }}

  frame .tpfontselect.frame2.frame  -background {#dcdcdc}  -height {126}  -highlightbackground {#dcdcdc}  -width {50}

#LISSI
#  scrollbar .tpfontselect.frame2.frame.scrollbar2  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -command {.tpfontselect.frame2.frame.listbox1 yview}  -cursor {left_ptr}  -highlightbackground {#dcdcdc}  -relief {raised}  -troughcolor {#dcdcdc}  -width {12}
  ttk::scrollbar .tpfontselect.frame2.frame.scrollbar2 -command {.tpfontselect.frame2.frame.listbox1 yview}

  listbox .tpfontselect.frame2.frame.listbox1  -background {#eeeeee}  -font {Helvetica 10}  -height {6}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -width {4}  -yscrollcommand {.tpfontselect.frame2.frame.scrollbar2 set}
  # bindings
  bind .tpfontselect.frame2.frame.listbox1 <<ListboxSelect>> {set TPtemp [%W curselection]
  if {$TPtemp ne {}} {set TPfontSize [%W get $TPtemp]}
#.tpfontselect.frame1.frame5.canvas0 itemconfigure sample -font  [TP_FontGetSelected]
#LISSI
.tpfontselect.frameSample.canvas0 itemconfigure sample -font  [TP_FontGetSelected]

catch $TPfontCmd
    eval $fontCmdItem
    drawBoundingBox
}

  entry .tpfontselect.frame2.frame.entry11  -background {#eeeeee}  -disabledbackground {white}  -disabledforeground {black}  -font {Helvetica 10}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -state {disabled}  -textvariable {TPfontSize}  -width {6}

  frame .tpfontselect.frame2.frame13  -borderwidth {2}  -relief {groove}  -background {#dcdcdc}  -height {86}  -highlightbackground {#dcdcdc}  -width {140}

  label .tpfontselect.frame2.frame13.label14  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {Effects}

#LISSI
#  checkbutton .tpfontselect.frame2.frame13.checkbutton15  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {.tpfontselect.frame1.frame5.canvas0 itemconfigure sample -font  [TP_FontGetSelected]}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Strikeout}  -variable {TPfontStrikeout}
  checkbutton .tpfontselect.frame2.frame13.checkbutton15  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {.tpfontselect.frameSample.canvas0 itemconfigure sample -font  [TP_FontGetSelected]}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Strikeout}  -variable {TPfontStrikeout}
  checkbutton .tpfontselect.frame2.frame13.checkbutton16  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {.tpfontselect.frameSample.canvas0 itemconfigure sample -font  [TP_FontGetSelected]}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Underline}  -variable {TPfontUnderline}
#  checkbutton .tpfontselect.frame2.frame13.checkbutton16  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {.tpfontselect.frame1.frame5.canvas0 itemconfigure sample -font  [TP_FontGetSelected]}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Underline}  -variable {TPfontUnderline}

  label .tpfontselect.frame2.label3  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {0}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {FontStyle:   Size:}

  frame .tpfontselect.frame  -borderwidth {2}  -background {#dcdcdc}  -height {247}  -highlightbackground {#e6e7e6}  -width {158}

  label .tpfontselect.frame.label0  -activebackground {#e6e7e6}  -anchor {w}  -background {#dcdcdc}  -borderwidth {0}  -font {Helvetica 10 bold}  -highlightbackground {#e6e7e6}  -text {Named fonts:}

  frame .tpfontselect.frame.frame3  -borderwidth {2}  -relief {groove}  -background {#eeeeee}  -height {58}  -highlightbackground {#eeeeee}  -width {150}

  button .tpfontselect.frame.frame3.button1  -activebackground {gray75}  -background {#dcdcdc}  -command {TP_FontCreate $TPnamedFont
TP_FontNameFill .tpfontselect.frame.frame4.listbox1}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -padx {2}  -pady {0}  -text {Name font as:}

  entry .tpfontselect.frame.frame3.entry3  -background {lightblue}  -font {Helvetica 10}  -highlightbackground {#ffffff}  -selectbackground {#21449c}  -selectforeground {#ffffff}  -textvariable {TPnamedFont}  -width {16}

  button .tpfontselect.frame.frame3.button4  -activebackground {gray75}  -background {#dcdcdc}  -command {set TPtemp [.tpfontselect.frame.frame4.listbox1 curselection]
if {[llength $TPtemp] == 1} {
     catch {font delete [.tpfontselect.frame.frame4.listbox1 get $TPtemp]}
     TP_FontNameFill .tpfontselect.frame.frame4.listbox1
   }}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -padx {2}  -pady {0}  -text {Delete named}

  frame .tpfontselect.frame.frame4  -borderwidth {2}  -relief {groove}  -background {#eeeeee}  -height {138}  -highlightbackground {#eeeeee}  -width {154}

  listbox .tpfontselect.frame.frame4.listbox1  -background {white}  -font {Helvetica 10}  -height {5}  -highlightbackground {#ffffff}  -selectbackground {#21449c}  -selectforeground {#ffffff}  -width {16}  -xscrollcommand {.tpfontselect.frame.frame4.scrollbar3 set}  -yscrollcommand {.tpfontselect.frame.frame4.scrollbar2 set}
  # bindings
  bind .tpfontselect.frame.frame4.listbox1 <<ListboxSelect>> {set TPtemp [%W curselection]
if {[llength $TPtemp] == 1} {
     TP_FontSelect [%W get $TPtemp]
   }}

#LISSI
#  scrollbar .tpfontselect.frame.frame4.scrollbar3  -activebackground {#e6e7e6}  -background {#e6e7e6}  -borderwidth {2}  -command {.tpfontselect.frame.frame4.listbox1 xview}  -cursor {left_ptr}  -highlightbackground {#e6e7e6}  -orient {horizontal}  -relief {raised}  -troughcolor {#e6e7e6}  -width {12}
#  scrollbar .tpfontselect.frame.frame4.scrollbar2  -activebackground {#e6e7e6}  -background {#e6e7e6}  -borderwidth {2}  -command {.tpfontselect.frame.frame4.listbox1 yview}  -cursor {left_ptr}  -highlightbackground {#e6e7e6}  -relief {raised}  -troughcolor {#e6e7e6}  -width {12}
  ttk::scrollbar .tpfontselect.frame.frame4.scrollbar3  -command {.tpfontselect.frame.frame4.listbox1 xview} -orient {horizontal}
  ttk::scrollbar .tpfontselect.frame.frame4.scrollbar2  -command {.tpfontselect.frame.frame4.listbox1 yview}

  frame .tpfontselect.frame0  -borderwidth {2}  -relief {ridge}  -background {#eeeeee}  -height {36}  -highlightbackground {#eeeeee}  -width {734}

  button .tpfontselect.frame0.button5  -activebackground {gray75}  -background {#dcdcdc}  -command { 
    set TPfontCmd {}
    drawBoundingBox
    .tpfontselect.frame1.frame.listbox1 delete 0 end
    set TPshowFonts 0
    DestroyWindow.tpfontselect}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {OK}  -width {5}

  button .tpfontselect.frame0.button6  -activebackground {gray75}  -background {#dcdcdc}  -command { 
  global fontCmdCancel
  eval $fontCmdCancel
set TPshowFonts 0
DestroyWindow.tpfontselect}  -font {Helvetica 10 bold}  -highlightbackground {#dcdcdc}  -text {Cancel}  -width {5}

  # pack master .tpfontselect.frame1
  pack configure .tpfontselect.frame1.label3  -anchor w
  pack configure .tpfontselect.frame1.entry4  -fill x
  pack configure .tpfontselect.frame1.frame  -expand 1  -fill both
#LISSI
#  pack configure .tpfontselect.frame1.frame5  -anchor w  -fill x

  # pack master .tpfontselect.frame1.frame
  pack configure .tpfontselect.frame1.frame.scrollbar2  -fill y  -side right
  pack configure .tpfontselect.frame1.frame.listbox1  -expand 1  -fill both

  # pack master .tpfontselect.frame1.frame5
#LISSI
#  pack configure .tpfontselect.frame1.frame5.label6  -anchor w
#  pack configure .tpfontselect.frame1.frame5.canvas0

  # pack master .tpfontselect.frame2
  pack configure .tpfontselect.frame2.label3  -anchor w
  pack configure .tpfontselect.frame2.frame13  -fill x  -ipady 3  -side bottom
  pack configure .tpfontselect.frame2.frame9  -anchor n  -expand 1  -fill y  -side left
  pack configure .tpfontselect.frame2.frame  -anchor n  -expand 1  -fill y

  # pack master .tpfontselect.frame2.frame9
  pack configure .tpfontselect.frame2.frame9.entry11
  pack configure .tpfontselect.frame2.frame9.listbox12  -expand 1  -fill y

  # pack master .tpfontselect.frame2.frame
  pack configure .tpfontselect.frame2.frame.entry11  -fill x
  pack configure .tpfontselect.frame2.frame.scrollbar2  -fill y  -side right
  pack configure .tpfontselect.frame2.frame.listbox1  -expand 1  -fill y

  # pack master .tpfontselect.frame2.frame13
  pack configure .tpfontselect.frame2.frame13.label14  -anchor w
  pack configure .tpfontselect.frame2.frame13.checkbutton15  -anchor w
  pack configure .tpfontselect.frame2.frame13.checkbutton16  -anchor w

  # pack master .tpfontselect.frame
  pack configure .tpfontselect.frame.label0  -fill x
  pack configure .tpfontselect.frame.frame4  -expand 1  -fill both  -ipady 8
  pack configure .tpfontselect.frame.frame3  -fill x  -ipady 5

  # pack master .tpfontselect.frame.frame3
  pack configure .tpfontselect.frame.frame3.button4  -expand 1
  pack configure .tpfontselect.frame.frame3.button1
  pack configure .tpfontselect.frame.frame3.entry3

  # pack master .tpfontselect.frame.frame4
  pack configure .tpfontselect.frame.frame4.scrollbar2  -fill y  -side right
  pack configure .tpfontselect.frame.frame4.listbox1  -expand 1  -fill both  -ipady 3
  pack configure .tpfontselect.frame.frame4.scrollbar3  -fill x

  # pack master .tpfontselect.frame0
  pack configure .tpfontselect.frame0.button5  -anchor e  -expand 1  -padx 2  -side left
  pack configure .tpfontselect.frame0.button6  -anchor w  -expand 1  -padx 2  -side left

  pack configure .tpfontselect.frame0  -fill x  -side bottom
#LISSI
  labelframe .tpfontselect.frameSample  -borderwidth {2} -text {Sample} -font {Helvetica 10 bold}  -relief {ridge}  -background {#eeeeee}  -height {36}  -highlightbackground {#eeeeee}
#    -width {734}
  pack configure .tpfontselect.frameSample  -fill x  -side bottom
  canvas .tpfontselect.frameSample.canvas0  -background {#dcdcdc}  -height {53}  -highlightbackground {#ffffff}  -relief {raised} 
  # -width {770}
  pack configure .tpfontselect.frameSample.canvas0  -fill x -expand 1
  set xfTmpTag1 [.tpfontselect.frameSample.canvas0 create text 40.0 28.0]
#  .tpfontselect.frameSample.canvas0 itemconfigure $xfTmpTag1 -anchor w  -font {{arial} 16 bold  underline}  -tags {sample}  -text {ABCabcXYZxyz0123456789АБВабвЭЮЯэюя}
  .tpfontselect.frameSample.canvas0 itemconfigure $xfTmpTag1 -anchor w  -font [TP_FontGetSelected]  -tags {sample}  -text {ABCabcXYZxyz0123456789АБВабвЭЮЯэюя}
#puts "-font {$TPfontFamily $TPfontSize $TPfontStyle}"

  # pack master .tpfontselect
  pack configure .tpfontselect.frame1  -anchor n  -fill y  -ipady 3  -side left
  pack configure .tpfontselect.frame2  -anchor n  -fill y  -ipady 3  -side left
  pack configure .tpfontselect.frame  -anchor n  -expand 1  -fill both  -side left

  # build canvas items .tpfontselect.frame1.frame5.canvas0
  set xfTmpTag [.tpfontselect.frame1.frame5.canvas0 create text 132.0 28.0]
  .tpfontselect.frame1.frame5.canvas0 itemconfigure $xfTmpTag  -font {{arial} 16 bold  underline}  -tags {sample}  -text {0123456789abcdefghij}
  .tpfontselect.frame2.frame9.listbox12 insert end {Normal}
  .tpfontselect.frame2.frame9.listbox12 insert end {Regular}
  .tpfontselect.frame2.frame9.listbox12 insert end {Bold}
  .tpfontselect.frame2.frame9.listbox12 insert end {Italic}
  .tpfontselect.frame2.frame9.listbox12 insert end {Bold Italic}
  .tpfontselect.frame2.frame.listbox1 insert end {6}
  .tpfontselect.frame2.frame.listbox1 insert end {8}
  .tpfontselect.frame2.frame.listbox1 insert end {10}
  .tpfontselect.frame2.frame.listbox1 insert end {12}
  .tpfontselect.frame2.frame.listbox1 insert end {14}
  .tpfontselect.frame2.frame.listbox1 insert end {16}
  .tpfontselect.frame2.frame.listbox1 insert end {18}
  .tpfontselect.frame2.frame.listbox1 insert end {20}
  .tpfontselect.frame2.frame.listbox1 insert end {22}
  .tpfontselect.frame2.frame.listbox1 insert end {24}
  .tpfontselect.frame2.frame.listbox1 insert end {26}
  .tpfontselect.frame2.frame.listbox1 insert end {28}
  .tpfontselect.frame2.frame.listbox1 insert end {30}
  .tpfontselect.frame2.frame.listbox1 insert end {32}
  .tpfontselect.frame2.frame.listbox1 insert end {34}
  .tpfontselect.frame2.frame.listbox1 insert end {36}
  .tpfontselect.frame2.frame.listbox1 insert end {38}
  .tpfontselect.frame2.frame.listbox1 insert end {40}
  .tpfontselect.frame2.frame.listbox1 insert end {42}
  .tpfontselect.frame2.frame.listbox1 insert end {44}
  .tpfontselect.frame2.frame.listbox1 insert end {46}
  .tpfontselect.frame2.frame.listbox1 insert end {48}
  .tpfontselect.frame2.frame.listbox1 insert end {50}
  .tpfontselect.frame2.frame.listbox1 insert end {52}
  .tpfontselect.frame2.frame.listbox1 insert end {54}
  .tpfontselect.frame2.frame.listbox1 insert end {56}
  .tpfontselect.frame2.frame.listbox1 insert end {58}
  .tpfontselect.frame2.frame.listbox1 insert end {60}
  .tpfontselect.frame2.frame.listbox1 insert end {62}
  .tpfontselect.frame2.frame.listbox1 insert end {64}
  .tpfontselect.frame2.frame.listbox1 insert end {68}
  .tpfontselect.frame2.frame.listbox1 insert end {70}
  .tpfontselect.frame2.frame.listbox1 insert end {72}

EndSrc.tpfontselect
}

proc DestroyWindow.tpfontselect {} {
     catch "destroy .tpfontselect"
     update
}

proc EndSrc.tpfontselect {} {
global TPshowFonts

wm iconphoto .tpfontselect  tkpaint_icon
#set ::TPselWidget(.tpfontselect) $::TPcurWidget
.tpfontselect.frame1.frame.listbox1 delete 0 end
set ff [lsort [font families]]
set df ""
set lff [list]
foreach f1 $ff {
    if {$df == $f1} {continue}
    set df $f1
    lappend lff $f1
} 
#
#eval ".tpfontselect.frame1.frame.listbox1 insert end [lsort [font families]]"
eval ".tpfontselect.frame1.frame.listbox1 insert end $lff"
#TP_FontNameFill .tpfontselect.frame.frame4.listbox1
set TPshowFonts 1
}
# Procedure: TP_FontGetSelected
proc TP_FontGetSelected {} {
# Return the -font configuration string for the currently selected font.
global TPfontFamily
global TPfontSize
global TPfontStyle
global TPfontStrikeout
global TPfontUnderline
global TPcurWidget
global TPfontCmd

if {$TPfontStyle == {Regular}} {
   set fontStyle {}
  } { set fontStyle [string tolower $TPfontStyle]}

if {$TPfontStrikeout} {
   set fontOverstrike overstrike
  } { set fontOverstrike {} }

if {$TPfontUnderline} {
    set fontUnderline underline
  } { set fontUnderline {} }

set rtnval "\{$TPfontFamily\} $TPfontSize $fontStyle $fontOverstrike $fontUnderline"

return $rtnval
}



#Edit ptext
proc ShowWindow.tpcmdedit { id} {
global TPtxtCmd
global TPcurCanvas
set TPcurCanvas ".c"
  catch "destroy .tpcmdedit"

  toplevel .tpcmdedit   -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tpcmdedit program
  wm sizefrom .tpcmdedit program
  wm maxsize .tpcmdedit 2560 1024
  wm minsize .tpcmdedit 424 210
  wm protocol .tpcmdedit WM_DELETE_WINDOW {DestroyWindow.tpcmdedit}

  # bindings
  bind .tpcmdedit <ButtonRelease-1> {TP_ProcessClick %W %X %Y %x %y}
  bind .tpcmdedit <Shift-Button-3> {TP_PropsSelWidget %W}

  frame .tpcmdedit.frame3  -borderwidth {2}  -relief {ridge}  -background {#dcdcdc}  -height {24}  -highlightbackground {#dcdcdc}  -width {364}

  if { $id > -1} {
    wm title .tpcmdedit {TKsvgpaint: Edit ptext}
    set TPtxtCmd [subst "$TPcurCanvas itemconfigure $id -text "]
    button .tpcmdedit.frame3.button4  -activebackground {gray75}  -background {#dcdcdc}  -command {
    global TPtxtCmd
    set TPtemp [.tpcmdedit.frame.text2 get 1.0 end-1chars]
    catch "$TPtxtCmd \{$TPtemp\}"
    DestroyWindow.tpcmdedit }  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -padx {4}  -pady {2}  -text {Done}  -width {6}
  } else {
    wm title .tpcmdedit {TKsvgpaint: Create path}
    button .tpcmdedit.frame3.button4  -activebackground {gray75}  -background {#dcdcdc}  -command {
        global TPtxtCmd
	set TPtxtCmd ".c create path "
	set TPtemp [.tpcmdedit.frame.text2 get 1.0 end-1chars]
	set id [.c create path  "$TPtemp" -tags "path obj svg"]
	set utag [Utag assign $id]
	History add [getObjectCommand $utag 1]
	Undo add ".c delete $utag"
	DestroyWindow.tpcmdedit } \
    -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -padx {4}  -pady {2}  -text {Done}  -width {6}
  }

  button .tpcmdedit.frame3.button8  -activebackground {gray75}  -background {#dcdcdc}  -command {DestroyWindow.tpcmdedit}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -padx {4}  -pady {2}  -text {Cancel}  -width {6}

  frame .tpcmdedit.frame  -relief {raised}  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  ttk::scrollbar .tpcmdedit.frame.scrollbar1 -command {.tpcmdedit.frame.text2 yview}

  text .tpcmdedit.frame.text2  -font {Helvetica 10}  -height {8}  -highlightbackground {#ffffff}  -selectbackground {#7783bd}  -selectforeground {#ffffff}  -width {50}  -wrap {none}  -xscrollcommand {.tpcmdedit.frame.scrollbar3 set}  -yscrollcommand {.tpcmdedit.frame.scrollbar1 set}

  ttk::scrollbar .tpcmdedit.frame.scrollbar3 -command {.tpcmdedit.frame.text2 xview} -orient {horizontal}

  # pack master .tpcmdedit.frame3
  pack configure .tpcmdedit.frame3.button4  -side left
  pack configure .tpcmdedit.frame3.button8  -side right

  # pack master .tpcmdedit.frame
  pack configure .tpcmdedit.frame.scrollbar1  -fill y  -side left
  pack configure .tpcmdedit.frame.text2  -expand 1  -fill both
  pack configure .tpcmdedit.frame.scrollbar3  -fill x

  # pack master .tpcmdedit
  pack configure .tpcmdedit.frame3  -fill x
  pack configure .tpcmdedit.frame  -expand 1  -fill both

  wm iconphoto .tpcmdedit tkpaint_icon
  .tpcmdedit.frame.text2 insert end [.c itemcget $id -text]
update
  grab set .tpcmdedit

}

proc DestroyWindow.tpcmdedit {} {
     catch "destroy .tpcmdedit"
     update
}
#Редактирование gradient у group
proc editGroupFillGradient {} {
   set have_fill 0
   set filledTypes [list svg Rectangle Ellipse RoundRect Circle Polygon \
             pieslice chord freeHandImage image text]

   set group [.c find withtag Selected]
   foreach id $group {
      foreach t [.c gettags $id] {
         if {[lsearch $filledTypes $t]>=0} {
              set have_fill 1
         }
      }
      if {$have_fill==1} {break}
   }

   if {$have_fill==0} {
     Message "There are no selected objects with fill color!"
     return
   }

   set undo [getGroupCommand 1]
   set cmd ""

#LISSI
    TP_tpGradientGroup $group
    return
}
proc TP_tpGradientGroup {group} {
    global TPcolor
    catch {unset TPcolor}
    global TPcolorCmd
    global TPcurCanvas
    set TPcurCanvas ".c"
    set TPcolor(svggroup) [list]
    set TPcolorCmd ""
    set TPcolor(gradlast) ""
    
    foreach id $group {
	if {[.c type $id] == "pimage"} {
	    continue
	}
	if {![idissvg $id]} {
	    continue
	}
	lappend TPcolor(svggroup) $id
	.c addtag svggroup withtag $id
	set idfill  [.c itemcget $id -fill]
	set TPcolor(rgb)  $idfill
	if {$idfill == ""} {
	    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill {}"]
	} else {
	    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill $idfill"]
	}
##################
	set TPcolor(rgb)  [.c itemcget $id -fill]
    }
    if {[llength $TPcolor(svggroup)] < 1} {
	return
    }
    set id svggroup
    set tfill [filltype $TPcolor(rgb)]
    set svggroup $TPcolor(svggroup)
    if {$tfill != "gradient"} {
	set color [ShowWindow.tpgradient $id ""]
    } else {
	set color [ShowWindow.tpgradient $id $TPcolor(rgb)]
    }
    tkwait window .tpgradient
    catch {unset TPcolor}
    foreach id $svggroup {
	.c dtag $id svggroup
    }
}

#Редактирование fill у группы
proc TP_tpcolorlineGroup {group} {
    global Canv Graphics
    global TPcolor
    global TPcolorCmd
    global TPcurCanvas
    set TPcurCanvas ".c"
    set TPcolor(group) [list]
    set TPcolor(svggroup) [list]
    set TPcolorCmd ""
    foreach id $group {
	set t [.c type $id]
	if {$t == "image" || $t == "pimage" || $t == "text"} {
	    continue
	}
	set TPcolor($id,nocolor) [subst ".c itemconfigure $id -fill  {}"]

	if {![idissvg $id]} {
	    lappend TPcolor(group) $id
	    lappend TPcolor(svggroup) $id
	    .c addtag svggroup withtag $id
#puts "TP_tpcolorlineGroup: type=[.c type $id] id=$id"
	    set TPcolor($id,opacity)  [.c itemcget $id -stipple]
#	    set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -outlinestipple \\\$rgb"]
	    if {[.c type $id] != "line"} {
		set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -outlinestipple \\\$stipple"]
		set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -outline \\\$rgb"]
		set TPcolor($id,nocolor) [subst ".c itemconfigure $id -outline  {}"]
		set idout [.c itemcget $id -outline]
		set idfill [.c itemcget $id -fill]
		if {$idfill == ""} {
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -outline {} -fill \"$idfill\""]
		} else {
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -outline $idout -fill \"$idfill\""]
		}
		set TPcolor(rgb) [.c itemcget $id -outline]
	    } else {
		set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -stipple \\\$stipple"]
		set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -fill \\\$rgb"]
		set TPcolor($id,nocolor) [subst ".c itemconfigure $id -fill  {}"]
		set idfill [.c itemcget $id -fill]
		set idopa [.c itemcget $id -stipple]
		if {$idfill == ""} {
		    set TPcolor(rgb) black
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill {}"]
		} else {
		    set TPcolor(rgb) $idfill
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill $idfill -stipple $idopa "]
		}
	    }
	} else {
	    lappend TPcolor(svggroup) $id
	    .c addtag svggroup withtag $id
	    set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -stroke \\\$rgb -strokeopacity \\\$TPcolor(opacity)"]
	    set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -strokeopacity \\\$TPcolor(opacity)"]
#	    set TPcolor($id,opacity)  [.c itemcget $id -fillopacity]
	    set TPcolor($id,opacity)  [.c itemcget $id -strokeopacity]
	    set TPcolor($id,nocolor) [subst ".c itemconfigure $id -stroke  {}"]
	    set idfill [.c itemcget $id -stroke]
	    set strop [.c itemcget $id -strokeopacity]
	    if {$idfill == ""} {
		set TPcolor($id,cancel) [subst ".c itemconfigure $id -stroke {}"]
		set TPcolor(rgb) black
	    } else {
		set TPcolor($id,cancel) [subst ".c itemconfigure $id -stroke $idfill -strokeopacity $strop"]
		set TPcolor(rgb) $idfill
	    }
	}
	continue
    }
    if {[llength $TPcolor(svggroup)] == 0} {
	return
    }
    set id svggroup
    set TPcolor(opacity) 1.0
    set svggroup $TPcolor(svggroup)
	set color [ShowWindow.tpcolorsel "line"]
#puts "editGroupLineColor: group=$group"
    	tkwait window .tpcolorsel
	catch {unset TPcolor}

##############
    foreach id $svggroup {
	.c dtag $id svggroup
    }


}
#Редактирование fill у группы
proc TP_tpfillGroup {group} {
    global Canv Graphics
    global TPcolor
    global TPcolorCmd
    global TPcurCanvas
    set TPcolor(varname) "Canv(fill)"

    set TPcolor(label) ".c"
    set TPcurWidget ".c"
    set TPcurCanvas ".c"
    set propname "fill"
    set TPcolor(group) [list]
    set TPcolor(svggroup) [list]
    foreach id $group {
	if {[.c type $id] == "image"} {
	    continue
	}
	if {[.c type $id] == "pimage"} {
	    set idfill [.c itemcget $id -tintcolor]
	} else {
	    set idfill [.c itemcget $id -fill]
	}
	if {[filltype $idfill] != "gradient"} {
	    set TPcolor(rgb) $idfill
	}
	if {$idfill == ""} {
	    if {[.c type $id] == "pimage"} {
		set TPcolor($id,cancel) [subst ".c itemconfigure $id -tintcolor {}"]
	    } else {
		set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill {}"]
	    }
	} else {
	    if {[.c type $id] == "pimage"} {
		set TPcolor($id,cancel) [subst ".c itemconfigure $id -tintcolor $idfill"]
	    } else {
		if {[idissvg $id]} {
		    set idopa [.c itemcget $id -fillopacity]
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill $idfill -fillopacity $idopa"]
		} else {
		    set idopa [.c itemcget $id -stipple]
		    set TPcolor($id,cancel) [subst ".c itemconfigure $id -fill $idfill -stipple \"$idopa\""]
		}
	    }
	}
	if {[.c type $id] == "pimage"} {
	    set TPcolor($id,nocolor) [subst ".c itemconfigure $id -tintcolor  {}"]
	} else {
	    set TPcolor($id,nocolor) [subst ".c itemconfigure $id -fill  {}"]
	}

	if {![idissvg $id]} {
	    lappend TPcolor(group) $id
	    lappend TPcolor(svggroup) $id
	    .c addtag svggroup withtag $id
	    set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -fill \\\$rgb"]
#	    set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -fill \\\$rgb"]
	    set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -stipple \\\$stipple"]
	    set stopa  [.c itemcget $id -stipple]
	    if {$stopa == ""} {
		set TPcolor($id,opacity)  1.0
	    } elseif  {$stopa == "gray12"} {
		set TPcolor($id,opacity)  0.12
	    } elseif  {$stopa == "gray25"} {
		set TPcolor($id,opacity)  0.25
	    } elseif  {$stopa == "gray50"} {
		set TPcolor($id,opacity)  0.50
	    } elseif  {$stopa == "gray75"} {
		set TPcolor($id,opacity)  0.75
	    } else {
		set TPcolor($id,opacity)  1.0
	    }
	    set TPcolor(opacity) $TPcolor($id,opacity)
	} else {
	    lappend TPcolor(svggroup) $id
	    .c addtag svggroup withtag $id
	    set TPcolor($id,opacity)  [.c itemcget $id -fillopacity]
	    set TPcolor(opacity)  [.c itemcget $id -fillopacity]
	    if {[.c type $id] == "pimage"} {
		set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -tintcolor \\\$rgb -tintamount \\\$TPcolor(tintamount) -fillopacity \\\$TPcolor(opacity)"]
		set TPcolor($id,tintamount)  [.c itemcget $id -fillopacity]
		set TPcolor(tintamount)  [.c itemcget $id -fillopacity]
	    } else {
		set TPcolor($id,colorCmd) [subst ".c itemconfigure $id -fill \\\$rgb -fillopacity \\\$TPcolor(opacity)"]
		set TPcolor($id,cmdopacity) [subst ".c itemconfigure $id -fillopacity \\\$TPcolor(opacity)"]
	    }
	}
    }
    if {[llength $TPcolor(svggroup)] == 0} {
	return
    }
    set id svggroup
    set svggroup $TPcolor(svggroup)
############
	set Canv(fill)  [.c itemcget $id -fill]
	set TPcolor(varname) "Canv(fill)"
	    set TPcolorCmd ".c itemconfigure $id -fill \$rgb -fillopacity \$TPcolor(opacity)"
	    set TPcolor(cmdopacity) ".c itemconfigure $id -fillopacity \$TPcolor(opacity)"
#puts "editGroupFillColor: $TPcolorCmd; group=$group"
	    if {$Canv(fill) == ""} {
		set TPcolor(cancel) "$TPcurCanvas itemconfigure $id -fill {}"
	    } else {
		set TPcolor(cancel) "$TPcurCanvas itemconfigure $id -fill $Canv(fill)"
	    }
	    set TPcolor(nocolor) "$TPcurCanvas itemconfigure $id -fill  {}"
#puts "editGroupFillColor: group=$group type=[.c type $id]"
    if {[llength $svggroup] == 1} {
	if {[.c type [lindex $svggroup 0]] == "pimage"} {
#puts "TP_tpfillGroup: TPcolor(rgb)=$TPcolor(rgb)"
	    set color [ShowWindow.tpcolorsel "image"]
	} else {
	    set color [ShowWindow.tpcolorsel "fill"]
	}
    } else {
	set color [ShowWindow.tpcolorsel "fill"]
    }
    tkwait window .tpcolorsel

    foreach id $svggroup {
	.c dtag $id svggroup
    }

}

proc TP_tpskewGroup {} {
    global Rotate
    catch {unset Rotate}
    set Rotate(svggroup) [list]
    set Rotate(group) [list]
    foreach id [.c find withtag Selected] {
	if {![idissvg $id]} {
#	    deformGroupMode
	    lappend Rotate(group) $id
	    continue
	} else {
	    lappend Rotate(svggroup) $id
	    .c addtag svggroup withtag $id
	}
	continue
	
	set Rotate(id) $id
	set Rotate(matrix) [.c itemcget $id -m]
	set Rotate(matrixLast) [.c itemcget $id -m]
	set bb [.c bbox $id]
	set Rotate(xi) [expr {([lindex $bb 0] + [lindex $bb 2]) / 2}]
	set Rotate(yi) [expr {([lindex $bb 1] + [lindex $bb 3]) / 2}]

	if {$Rotate(matrix) != ""} {
	    set dmat [decomposeMatrix $Rotate(matrix)]
	    array set amM $dmat
	    set Rotate(skewXorig) $amM(skewX)
	    set Rotate(skewYorig) $amM(skewY)
	    set Rotate(angleOrig) $amM(rotate)
	    unset dmat
	    unset amM
	} else {
	    set Rotate(skewXorig) ""
	    set Rotate(skewYorig) ""
	    set Rotate(angleOrig) ""
	}
	
	set Rotate(skewX) 0
	set Rotate(skewY) 0
	set Rotate(angle) 0
	set Rotate(skewXlast) 0
	set Rotate(skewYlast) 0
	set Rotate(anglelast) 0

	foreach {Rotate(xi) Rotate(yi)} [id2coordscenter $id] {break}
	ShowWindow.tpskew
	tkwait window .tpskew
	drawBoundingBox
    }
    if {[llength $Rotate(svggroup)] == 0} {
	return
    }
    set id svggroup
    set Rotate(id) $id
    set Rotate(matrix) [.c itemcget $id -m]
    set Rotate(matrixLast) [.c itemcget $id -m]
    set bb [.c bbox $id]
    set Rotate(xi) [expr {([lindex $bb 0] + [lindex $bb 2]) / 2}]
    set Rotate(yi) [expr {([lindex $bb 1] + [lindex $bb 3]) / 2}]


    set Rotate(skewX) 0
    set Rotate(skewY) 0
    set Rotate(angle) 0
    set Rotate(skewXlast) 0
    set Rotate(skewYlast) 0
    set Rotate(anglelast) 0

    foreach {Rotate(xi) Rotate(yi)} [id2coordscenter svggroup] {break}
    set svggroup $Rotate(svggroup)

    ShowWindow.tpskew
    tkwait window .tpskew
    drawBoundingBox
    foreach id $svggroup {
	.c dtag $id svggroup
    }
#    drawBoundingBox
}

proc ShowWindow.tpskew { args} {
#LISSI
  global Rotate
  catch "destroy .tpskew"
  set id $Rotate(id)
  toplevel .tpskew   -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tpskew ""
  wm sizefrom .tpskew ""
  wm maxsize .tpskew 600 220
  wm minsize .tpskew 600 220
  wm geometry .tpskew 600x220+200+100
  wm title .tpskew {TKpaint skew angle}

  frame .tpskew.top  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  frame .tpskew.top.left  -background {#dcdcdc}  -highlightbackground {#dcdcdc}
  set type [.c type $id]

  scale .tpskew.top.left.x -command {TP_skewX} -background {#dcdcdc} -font {Helvetica 10} -length {590}   -label {Skew angle X:} -orient {horizontal} -digits 2 -from {-360.0}  -to {360.0}  -troughcolor {red} -variable {Rotate(skewX)}
  scale .tpskew.top.left.y -command {TP_skewY} -background {#dcdcdc} -font {Helvetica 10} -length {590}  -label {Skew angle Y:}  -orient {horizontal} -digits 2 -from {-360.00}  -to {360.00}  -troughcolor {blue} -variable {Rotate(skewY)}
  scale .tpskew.top.left.rotate -command {TP_rotateC} -background {#dcdcdc} -font {Helvetica 10} -length {590}  -label {Rotate angle:}  -orient {horizontal} -digits 2 -from {-180.0}  -to {180.0}  -troughcolor {green} -variable {Rotate(angle)}

  frame .tpskew.frame0  -borderwidth {2}  -relief {ridge}  -background {#dcdcdc}  -height {34}  -highlightbackground {#dcdcdc}  -width {280}

  button .tpskew.frame0.button1  -activebackground {gray75}  -background {#dcdcdc}  -command {global Rotate; \
    if {0} {TP_saveImage $Rotate(id) "skew"}; \
    destroy .tpskew; 
#    unselectGroup; 
    unset Rotate; 
  } \
    -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {OK}  -width {5}

  button .tpskew.frame0.button2  -activebackground {gray75} -command {global Rotate; \
    .c itemconfigure $Rotate(id) -m $Rotate(matrix); \
    destroy .tpskew; 
#    unselectGroup; 
    unset Rotate; 
  } \
     -background {#dcdcdc} -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Cancel}

  # pack master .tpskew.top
  pack configure .tpskew.top.left  -fill both  -side left -padx 0

  # pack master .tpskew.top.left
  pack configure .tpskew.top.left.x -expand 1 -fill x -padx 0 -pady 0
  pack configure .tpskew.top.left.y -expand 1 -fill both
  pack configure .tpskew.top.left.rotate -expand 1 -fill both


  # pack master .tpskew.frame0
  pack configure .tpskew.frame0.button1  -expand 1  -side left

  pack configure .tpskew.frame0.button2  -expand 1  -side left

  # pack master .tpskew
  pack configure .tpskew.top  -fill x
  pack configure .tpskew.frame0  -fill x  -side bottom

  wm protocol .tpskew WM_DELETE_WINDOW {.tpskew.frame0.button2 invoke}
  grab set .tpskew

#EndSrc.tpskew
}

proc rotateGroupSVG {} {
  global Rotate
    foreach id [.c find withtag Selected] {
	catch {unset Rotate}
	if {![idissvg $id]} {
    	    rotateGroupMode
	    continue
	}
	set Rotate(id) $id
	set Rotate(matrix) [.c itemcget $id -m]
	foreach {Rotate(xi) Rotate(yi)} [id2coordscenter $id] {break}
	if {$Rotate(matrix) != ""} {
	    set dmat [decomposeMatrix $Rotate(matrix)]
	    array set amM $dmat
	    set Rotate(angleOrig) $amM(rotate)
	    unset dmat
	    unset amM
	} else {
	    set Rotate(angleOrig) ""
	}
	set Rotate(angle) 0
	ShowWindow.tprotate
	tkwait window .tprotate
    }
}

proc ShowWindow.tprotate { args} {
#LISSI
  global Rotate
  catch "destroy .tprotate"
  set id $Rotate(id)
  set Rotate(angle) 0

  toplevel .tprotate   -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tprotate ""
  wm sizefrom .tprotate ""
  wm maxsize .tprotate 280 140
  wm minsize .tprotate 280 140
  wm geometry .tprotate 280x140+200+100
  wm title .tprotate {TKsvgpaint angle rotate}

  frame .tprotate.top  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  frame .tprotate.top.left  -background {#dcdcdc}  -highlightbackground {#dcdcdc}
  set type [.c type $id]    
  if {$type == "pimage"} {
    scale .tprotate.top.left.red  -activebackground {#dcdcdc} -command {TP_imagerotate}  -background {#dcdcdc}   -font {Helvetica 10}  -highlightbackground {#dcdcdc} -length {280}  -label {Angle:}  -orient {horizontal} -from {-180.0}  -to {180.0}  -troughcolor {red} -variable {Rotate(angle)}
  } else {
    scale .tprotate.top.left.red  -activebackground {#dcdcdc} -command {TP_imagerotate}  -background {#dcdcdc}   -font {Helvetica 10}  -highlightbackground {#dcdcdc} -length {280}  -label {Angle:}  -orient {horizontal} -from {-180.0}  -to {180.0}  -troughcolor {red} -variable {Rotate(angle)}
  }

  frame .tprotate.frame0  -borderwidth {2}  -relief {ridge}  -background {#dcdcdc}  -height {34}  -highlightbackground {#dcdcdc}  -width {280}

  button .tprotate.frame0.button1  -activebackground {gray75}  -background {#dcdcdc}  -command {global Rotate; \
    if {0} {TP_saveImage $Rotate(id) "rotate"}; \
    set Rotate(angle) 0; \
    destroy .tprotate; 
#    unselectGroup;
    drawBoundingBox
    unset Rotate; \
  } \
    -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {OK}  -width {5}

  button .tprotate.frame0.button2  -activebackground {gray75} -command {global Rotate; \
    .c itemconfigure $Rotate(id) -m $Rotate(matrix); \
    destroy .tprotate;
#     unselectGroup; 
    drawBoundingBox
    unset Rotate; \
  } \
     -background {#dcdcdc} -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Cancel}

  # pack master .tprotate.top
  pack configure .tprotate.top.left  -fill both  -side left

  # pack master .tprotate.top.left
  pack configure .tprotate.top.left.red  -expand 1  -fill both


  # pack master .tprotate.frame0
  pack configure .tprotate.frame0.button1  -expand 1  -side left

  pack configure .tprotate.frame0.button2  -expand 1  -side left

  # pack master .tprotate
  pack configure .tprotate.top  -fill x
  pack configure .tprotate.frame0  -fill x  -side bottom

  wm protocol .tprotate WM_DELETE_WINDOW {.tprotate.frame0.button2 invoke}
  grab set .tprotate

#EndSrc.tprotate
}

proc ShowWindow.tpcolorsel { type } {
#LISSI
  global TPcolorCmd
  global TPcolor
  set TPcolor(type) $type

  catch "destroy .tpcolorsel"

  if {![info exists TPcolor(rgb)] } {
    set TPcolor(rgb) #00FFFF
  }

  toplevel .tpcolorsel   -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  # Window manager configurations
  wm positionfrom .tpcolorsel ""
  wm sizefrom .tpcolorsel ""
  wm maxsize .tpcolorsel 280 994
  wm protocol .tpcolorsel WM_DELETE_WINDOW {.tpcolorsel.frame0.button2 invoke}
  
  if {$type == "image"} {
    wm title .tpcolorsel "Image tintcolor selection"
    wm iconphoto .tpcolorsel tkpaint_icon
  } else {
    wm title .tpcolorsel "$type color selection"
  }
  set tfill [filltype $TPcolor(rgb)]
  if {$tfill != "gradient"} {
    wm minsize .tpcolorsel 280 340
    wm geometry .tpcolorsel 280x570+200+50
  } else {
    wm minsize .tpcolorsel 280 110
    wm geometry .tpcolorsel 280x70+200+50
  }

  # bindings
  bind .tpcolorsel <ButtonRelease-1> {TP_ProcessClick %W %X %Y %x %y}
  bind .tpcolorsel <Shift-Button-3> {TP_PropsSelWidget %W}
  
  frame .tpcolorsel.top  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  frame .tpcolorsel.top.left  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

  scale .tpcolorsel.top.left.red  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {TP_ColorSetSample {}}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -label {RED:}  -length {120}  -orient {horizontal}  -to {255.0}  -troughcolor {red}  -variable {TPcolor(red)}

  scale .tpcolorsel.top.left.green  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {TP_ColorSetSample {}}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -label {GREEN:}  -length {120}  -orient {horizontal}  -to {255.0}  -troughcolor {green}  -variable {TPcolor(green)}

  scale .tpcolorsel.top.left.blue  -activebackground {#dcdcdc}  -background {#dcdcdc}  -command {TP_ColorSetSample {}}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -label {BLUE:}  -length {120}  -orient {horizontal}  -to {255.0}  -troughcolor {blue}  -variable {TPcolor(blue)}

  frame .tpcolorsel.top.right  -background {#dcdcdc}  -highlightbackground {#dcdcdc}

#Метку меняем на canvas prect
  tkp::canvas .tpcolorsel.top.right.color -relief flat -height 1c -width 1.5c  -background blue

  label .tpcolorsel.top.right.label0  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -font {Helvetica 12 bold}  -foreground {red}  -highlightbackground {#dcdcdc}  -text {#000000}  -textvariable {TPcolor(rgb)}  -width {17}

  frame .tpcolorsel.c  -borderwidth {2}  -relief {ridge}  -background {#dcdcdc}  -highlightbackground {#dcdcdc}
#Прозрачность
#LISSI
if {$type != "bgcanvas" } {
  scale .tpcolorsel.opacity -width 8 -command {TP_ColorSetSample {}} -font {Helvetica 10} -label {OPACITY:} -length {240} -orient {horizontal} -digits 2 -resolution {0.1}  -from {0.0} -to {1.0}  -troughcolor {skyblue}  -variable {TPcolor(opacity)}
}
if {$type == "image"} {
  scale .tpcolorsel.tintamount -width 8 -command {TP_ColorSetSample {}} -font {Helvetica 10} -label {TINTAMOUNT:} -length {240} -orient {horizontal} -digits 2 -resolution {0.1}  -from {0.0} -to {1.0}  -troughcolor {skyblue}  -variable {TPcolor(tintamount)}
}

  canvas .tpcolorsel.c.canvas  -background {#ffffff}  -borderwidth {2}  -height {250}  -highlightbackground {#ffffff}  -relief {raised}  -scrollregion {0 0 200 19500}  -width {200}  -yscrollcommand {.tpcolorsel.c.sy set}

#  scrollbar .tpcolorsel.c.sy  -activebackground {#dcdcdc}  -background {#dcdcdc}  -borderwidth {2}  -command {.tpcolorsel.c.canvas yview}  -cursor {left_ptr}  -highlightbackground {#dcdcdc}  -troughcolor {#dcdcdc}  -width {15}
  ttk::scrollbar .tpcolorsel.c.sy -command {.tpcolorsel.c.canvas yview} 

  frame .tpcolorsel.frame0  -borderwidth {2}  -relief {ridge}  -background {#dcdcdc}  -height {34}  -highlightbackground {#dcdcdc}  -width {280}

  button .tpcolorsel.frame0.button1  -activebackground {gray75}  -background {#dcdcdc}  -command {global TPcolor 
    .tpcolorsel.c.canvas delete all
    DestroyWindow.tpcolorsel;unset TPcolor}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {OK}  -width {5}

  button .tpcolorsel.frame0.button2  -activebackground {gray75}  -background {#dcdcdc}  -command {
    .tpcolorsel.c.canvas delete all
    DestroyWindow.tpcolorsel;
    foreach id $TPcolor(svggroup) {
	eval $TPcolor($id,cancel)
    }
    unset TPcolor}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {Cancel}

  # pack master .tpcolorsel.top
  pack configure .tpcolorsel.top.left  -fill both  -side left
  pack configure .tpcolorsel.top.right  -expand 1  -fill both  -side left

  # pack master .tpcolorsel.top.left
  pack configure .tpcolorsel.top.left.red  -expand 1  -fill y
  pack configure .tpcolorsel.top.left.green  -expand 1  -fill y
  pack configure .tpcolorsel.top.left.blue  -expand 1  -fill y

  # pack master .tpcolorsel.top.right
  pack configure .tpcolorsel.top.right.color  -expand 1  -fill both
  pack configure .tpcolorsel.top.right.label0

  # pack master .tpcolorsel.c
  if {$tfill != "gradient"} {
    pack configure .tpcolorsel.c.sy  -fill y  -side right
    pack configure .tpcolorsel.c.canvas  -expand 1  -fill both
  }
  # pack master .tpcolorsel.frame0
  pack configure .tpcolorsel.frame0.button1  -expand 1  -side left
#LISSI
  if {$type != "bgcanvas"} {
    button .tpcolorsel.frame0.button3  -activebackground {gray75}  -background {#dcdcdc}  -command {
	.tpcolorsel.c.canvas delete all
	DestroyWindow.tpcolorsel;
	foreach id $TPcolor(svggroup) {
	    eval $TPcolor($id,nocolor)
	}
    unset TPcolor}  -font {Helvetica 10}  -highlightbackground {#dcdcdc}  -text {No color}
    pack configure .tpcolorsel.frame0.button3  -expand 1  -side left
  }

  pack configure .tpcolorsel.frame0.button2  -expand 1  -side left

  # pack master .tpcolorsel
  if {$tfill != "gradient"} {
    pack configure .tpcolorsel.top  -fill x
  }
#LISSI
  if {$type != "bgcanvas"} {
    pack .tpcolorsel.opacity  -expand 1  -fill x -anchor n
  } else {
    set TPcolor(opacity) 1.0
  }
  if {$type == "image"} {
    pack .tpcolorsel.tintamount  -expand 1  -fill x -anchor n
  }
  if {$tfill != "gradient"} {
    pack configure .tpcolorsel.c  -expand 1  -fill both  -anchor n
  }
  pack configure .tpcolorsel.frame0  -fill x  -side bottom
#Метку меняем на canvas prect
  update idle
  regexp {(\d*)x(\d*)\+(\d*)\+(\d*)} [winfo geometry .tpcolorsel.top.right.color] -> w h x y
#puts "ShowWindow.tpcolorsel: w=$w h=$h x=$x y=$y"
  .tpcolorsel.top.right.color create pimage 0 0 \
          -width $w \
          -height $h \
          -image author
    if {$tfill != "gradient"} {
	.tpcolorsel.top.right.color create prect 0 0 $w $h \
          -tags labelColor \
          -fill $TPcolor(rgb) \
          -fillopacity $TPcolor(opacity) \
          -strokewidth 0
    }
    EndSrc.tpcolorsel
}

proc DestroyWindow.tpcolorsel {} {
     catch "destroy .tpcolorsel"
     update
}

proc EndSrc.tpcolorsel {} {
    global TPcolor

    wm iconphoto .tpcolorsel tkpaint_icon
    TP_ColorCanvasFill .tpcolorsel.c.canvas
    TP_ColorSetSample $TPcolor(rgb)
}

# Procedure: TP_CVpropsValueSel
proc TP_ColorSel { wname xpos ypos propname} {
global TPcvPropsInfo
global TPcolor
global TPcvPropsStandard
global TPcvPropsSpecific
global TPfontCmd
global TPcurCanvas
global TPcanvasID
global TPcolorCmd
global TPimgCmd
global TPcurMenu
global TPcurWidget
global TPcfgCmd
global TPtxtCmd
global TPvarCmd

if {[winfo exists $wname]} { focus $wname }
ShowWindow.tpcolorsel
}

# Procedure: TP_ColorCanvasFill
proc TP_ColorCanvasFill { cvname} {
# Fill the specified canvas with color samples
global TPcolorList
global Graphics

if {[winfo exists $cvname]} {
    $cvname delete all
    set ypos1 0
    foreach colorinfo $TPcolorList {
	 foreach {name red green blue} $colorinfo {}
	 set ypos2 $ypos1
	 incr ypos2 30
	 set textpos $ypos1
	 incr textpos 15
	 set fillcolor [format "#%02X%02X%02X" $red $green $blue]
	 set xred [expr {$red^255}]
	 set xgreen [expr {$green^255}]
	 set xblue [expr {$blue^255}]
	 set textcolor [format "#%02X%02X%02X" $xred $xgreen $xblue]
	 set tmptag [$cvname create rectangle 0.0 $ypos1 400 $ypos2]
 	 $cvname itemconfigure $tmptag  -fill $fillcolor  -outline {}
 	 $cvname bind $tmptag <Button-1> "TP_ColorSetSample $fillcolor"
	 set tmptag [$cvname create text 100 $textpos]
	 $cvname itemconfigure $tmptag  -text $name -fill $textcolor
	 $cvname bind $tmptag <Button-1> "TP_ColorSetSample $fillcolor" 

	 incr ypos1 30
               }
        $cvname conf -scrollregion [$cvname bbox all]
  }
}

# Procedure: TP_ColorSetSample
proc TP_ColorSetSample { {rgb ""} args} {
global TPcolor
global TPcurWidget
global TPmessage
global TPcolorCmd
global TPcanvasID
global TPcurCanvas
#puts "TP_ColorSetSample: rgb=$rgb args=$args"
#puts "TP_ColorSetSample len rgb=[string length $rgb] args=$args"
#    set tfill [filltype $rgb]
    if {$rgb != ""} {
	set TPcolor(rgb) $rgb
    }

    set tfill [filltype $TPcolor(rgb)]
    if {$tfill == "bad"} {
	puts "TP_ColorSetSample: bad fill=$rgb"
	if {$rgb == ""} {
	    set tfill "color"
	} else {
	    return
	}
    }
    set rgbor $rgb
if {[string length $rgb] > 0 && $tfill == "color"} {
    if {[string index $rgb 0] != {#}} {
         # Need to convert from color name to RGB format
         if {[catch {winfo rgb . $rgb} color16]} {
              set TPmessage $color16
              ShowWindow.tpmsgbox
              after 100 bell
	update
              return {}
            }
         set TPcolor(red) [expr int([lindex $color16 0] / 256)]
         set TPcolor(green) [expr int([lindex $color16 1] / 256)]
         set TPcolor(blue) [expr int([lindex $color16 2] / 256)]
      } {
           scan $rgb "\#%2x%2x%2x" red green blue
           foreach c {red green blue} { set TPcolor($c) [format %d [set $c]] }
         }
  } {
      set rgb \#[format "%.2X%.2X%.2X" $TPcolor(red) $TPcolor(green) $TPcolor(blue)]
    }
if {![catch {winfo rgb . $rgb}]} {
#LISSI
    if {$TPcolorCmd == ".c configure -background"} {
	$TPcolor(label) config -bg $rgb
    }

#    if {[string length $TPcolorCmd] > 0} {}
    if {1} {
	foreach id $TPcolor(svggroup) {
	    catch "$TPcolor($id,colorCmd)" 
	  if {![idissvg $id]} {	        
	    if {$TPcolor(opacity) == 0.0} {
		set stipple ""
#		catch "TPcolor($id,nocolor)"
		if {$TPcolor(type) == "fill"} {
		    .c itemconfigure $id -fill {} -stipple {}
		} elseif {$TPcolor(type) == "line"} {
		    if {[.c type $id] == "line"} { 
			.c itemconfigure $id -fill {} -stipple {}
		    } else {
			.c itemconfigure $id -outline {} -outlinestipple {}
		    }
		} 
	    } elseif {$TPcolor(opacity) < 0.13} {
		set stipple "gray12"
		catch "$TPcolor($id,cmdopacity)" 
	    } elseif {$TPcolor(opacity) < 0.26} {
		set stipple "gray25"
		catch "$TPcolor($id,cmdopacity)" 
	    } elseif {$TPcolor(opacity) < 0.51} {
		set stipple "gray50"
		catch "$TPcolor($id,cmdopacity)" 
	    } elseif {$TPcolor(opacity) < 0.76} {
		set stipple "gray75"
		catch "$TPcolor($id,cmdopacity)" 
	    } else {
		set stipple ""
		catch "$TPcolor($id,cmdopacity)" 
	    }
	  } else {
	    if {[.c type $id] != "pimage"} {
		catch "$TPcolor($id,cmdopacity)" 
	    }
	  }
	}
#LISSI	
	set id [.tpcolorsel.top.right.color find withtag labelColor]
	if {$tfill == "gradient"} {
	    set cmd [CloneGradForCanvad $TPcolor(rgb) ".tpcolorsel.top.right.color"]
#puts "TP_ColorSetSample: rgbor=$TPcolor(rgb) id=$id cmd=$cmd"
	    eval [subst "$cmd"]
	    .tpcolorsel.top.right.color itemconfigure $id -fill [subst $$TPcolor(rgb)]
	} else {
#puts "TP_ColorSetSample not grad: FILL=$TPcolor(rgb) id=$id "
	    .tpcolorsel.top.right.color itemconfigure $id -fill $TPcolor(rgb)
	}

	if {$TPcolorCmd != ".c configure -background"} {
	    .tpcolorsel.top.right.color itemconfigure $id -fillopacity $TPcolor(opacity)
	}
    }
    if {$tfill == "color"} {
	set TPcolor(rgb) [string toupper $rgb]
    }
#LISSI
if {$TPcolorCmd == ".c configure -background"} {
    set Canv(bg)  [string toupper $rgb]
}

   }
update
}

# Procedure: TP_ProcessClick
proc TP_ProcessClick { wname Xpos Ypos xpos ypos} {
global TPcurCanvas
global TPcurCanvasPoint
global TPcurCanvasObjXpos
global TPcurCanvasObjYpos
if {$wname == $TPcurCanvas && $TPcurCanvasPoint} {
    set TPcurCanvasObjXpos $xpos
    set TPcurCanvasObjYpos $yposGGGGGGG
    .tpcanvas.frame2.frame21.frame.text2 insert insert " $xpos $ypos "
    TP_CVcoordAdjust accept .tpcanvas.frame2.frame21.frame.text2
  }
}

proc TP_saveImage {id type} {
    if {[.c type $id] != "pimage"} {return}
#type - rotate или skew 
    puts "TP_saveImage type=$type:id=$id bbox=[.c bbox $id]"
    if {$type == "skew"} {
	set bskew [.c bbox $id]
    }
    set Graphics(mode) "SaveGroupToImage"
#Вызов сохранеия группы в картинке
#.mbar.image.menu invoke SaveGroupToImage
#вызов события: event generate <Button-1> -x ...  -y ...
    set newim [TP_saveGroupToFileOrImage 2 $id]
#puts "NewImage=$newim"
    set m [list {1.0 0.0} {-0.0 1.0} {0.0 0.0}]
    .c itemconfigure $id -image $newim -m $m
    if {$type == "skew"} {
	set bnskew [.c bbox $id]
#puts "TP_saveImage type=$type:id=$id bbox NEW=$bnskew"
	set x [expr {[lindex $bskew 0] - [lindex $bnskew 0]}]
	set y [expr {[lindex $bskew 1] - [lindex $bnskew 1]}]
#puts "TP_saveImage type=$type: x=$x y=$y"
	.c move $id $x $y
    }
}

proc TP_saveGroupToPicture {type } {
#type == 0 - save to file
#type == 1 - save to image
    set svgdata [can2svg::group2file ".c" "-image"]
    if {$svgdata == ""} {
	return ""
    }
    set newimg [image create photo -data $svgdata]

    if {$type == 0} {
	set File(img,types) {
		    {{img png} {.png} }
		    {{img gif} {.gif} }
		    {{img jpg} {.jpg} }
		    {{All files} * }
	}
        set type        "png"
        set title       "Select file for image group"
        set defaultName "tk_$newimg"
        set command tk_getSaveFile
        set filename [$command \
                -title "$title" \
                -filetypes $File(img,types) \
                -initialfile $defaultName \
                -defaultextension ".$type" ]
        if {$filename==""} {return 0}

    	$newimg write $filename -format "png"
	image delete $newimg
#puts "TP_saveGroupToFicture: save to file - $filename"
    }
}

proc TP_saveGroupFromRGB {type {cur ""}} {
#Информация о задержки
    catch {destroy .waitimage}
    label .waitimage -text "Wait. Image formation is underway." -anchor w -justify left -bg yellow  -font {Times 16 bold italic}  -foreground blue
    place .waitimage -in .tools.width -relx 0.0 -rely 0.25
    tk busy hold ".tools"
    tk busy hold ".svg"
    set ret [TP_saveGroupToFileOrImage $type $cur]
    tk busy forget ".tools"
    tk busy forget ".svg"
    destroy .waitimage
}
#SaveGroupToFile or SaveGroupToImage
proc TP_saveGroupToFileOrImage {type {cur ""}} {
  global Graphics
    global cmddel
    global macos
    global Image
#puts "Необходимо подождать! type=$type"
  set idgroup [.c find withtag Selected]
  if {[llength $idgroup] == 0} {return}

    set yesps 0
    if {$macos && [info exists ::freewrap::patchLevel]} {
	if {$::freewrap::patchLevel == "1.2.0"} {
	    set yesps 1
	} 
    }

    set TPtoolpath ".c"
#type 0 - сохранить в файле. 1 - создать image png, усли $cur!= "", то снимок одиночного объекта
#type 2 - пересоздать изображение, при прищании и других деформациях. При этом в cur лежит id изображения
#LISSI
set typeP $type
    if {$cur == ""} {
	set cmddel ""
    } else {
	set idsel $cur
	set cmddel [subst ".c delete $idsel"]
    }
    if {$type == 2} {
	set tobj [$TPtoolpath type $idsel]
	if {$tobj == "ppolygon"} {
	    $TPtoolpath itemconfigure $idsel -fillopacity 0.0 -fill #000000
	}
	set TPbboxL [$TPtoolpath bbox $idsel]
	set xP [lindex $TPbboxL 0]
	set yP [lindex $TPbboxL 2]
	set type 1
    } else {
	set TPbboxL [$TPtoolpath bbox Selected]
    }
#puts "bboxl=$TPbboxL"
    unselectGroup

    if {$TPbboxL == ""} {
	set TPbboxL [$TPtoolpath bbox groupbox]
	puts "bboxl (groupbox)=$TPbboxL";
    }
    if {$TPbboxL == ""} { return}

    set canbg [$TPtoolpath cget -background]
#    puts "Выделенный блок! \"$TPbboxL\", bg=$canbg cur=$cur"

    if { [catch {winfo rgb . $canbg} rgb] } {
    	tk_messageBox -message "Invalid background color \"$canbg\""
    	return;
    }
    if {$macos && $yesps } {
	if { [catch {winfo rgb . "#ffffff"} rgb] } {
    	    tk_messageBox -message "Invalid white color \"#ffffff\" for PS"
    	    return;
	}
    }
    raise [winfo toplevel $TPtoolpath]
    update
	set bbox $TPbboxL
	if {$bbox == ""} {
	    puts "Нет выделенного блока!$TPbboxL"
	    return
	}
    foreach {x1 y1 x2 y2} $bbox {break}
set x1 [expr {$x1 + 3}]
set y1 [expr {$y1 + 3}]

set x2 [expr {$x2 - 2}]
set y2 [expr {$y2 - 2}]
#puts "Необходимо подождать!"
#Копировать можно только видимую область!!!!
#Ещё скролинг!!!!
foreach xy {x1 y1 x2 y2} {
    if {[subst $[subst $xy]] < 0} {
	set $xy 1
    }
}

	set x2_new [expr $x2 - $x1 + 1]
	set y2_new [expr $y2 - $y1 + 1]
    if {$macos && $yesps} {
	set ps1 [$TPtoolpath postscript -x $x1 -y $y1 -width $x2_new -height $y2_new]
# -pageanchor nw  -pagex 0  -pagey $y2_new  -pagewidth $x2 -pageheight $y2
	set newimg [image create photo -format ps -data $ps1]
    } else {
#Снимаем картинку только с видимой части холста
	update
	set canfull 0
	set canimg [image create photo -format window -data $TPtoolpath]
#Снимаем картинку из полного холста
#	set canfull 1
#	set canimg [fullcanvas $TPtoolpath]

	if {$canfull == 0} {
	    set hcanimg [image height $canimg]
	    set wcanimg [image width $canimg]
	    foreach {v1 v2} [.main.vscroll get] {break}
	    foreach {h1 h2} [.main.hscroll get] {break}
	    foreach {rx0 ry0 rwidth rheight} [.c cget -scrollregion] {break}
	    set sy0 [expr {$rheight * $v1}]
	    set sy1 [expr {$rheight * $v2}]
	    set sx0 [expr {$rwidth * $h1}]
	    set sx1 [expr {$rwidth * $h2}]
	    set vcan [.c cget -height]
#Проверка видимости выделенной области
	    if {$y1 < $sy0 || $y2 > $sy1  } {
#		tk_messageBox -title "Error create Image" -parent "." -icon error -message "Выделенная область в невидимой части по вертикали.\n"
		tk_messageBox -title "Error create Image" -parent "." -icon error -message "The selected area in the invisible part vertically\n"
    		image delete $canimg
		return ""
	    }
	    if {$x1 < $sx0 || $x2 > $sx1  } {
#		tk_messageBox -title "Error create Image" -parent "." -icon error -message "Выделенная область в невидимой части по горизонтали.\n"
		tk_messageBox -title "Error create Image" -parent "." -icon error -message "The selected area in the invisible part horizontally.\n"
    		image delete $canimg
		return ""
	    }
#Учёт скроллинга
	    set y1 [expr {$y1 - int($sy0) + 1}]
	    set y2 [expr {$y2 - int($sy0) + 1}]
	    set x1 [expr {$x1 - int($sx0) + 1}]
	    set x2 [expr {$x2 - int($sx0) + 1}]
	}
# create image - пустая
	set newimg [image create photo]
#puts "TP_saveGroupToFileOrImage: sy0=$sy0 sy1=$sy1  $newimg copy $canimg -from  $x1 $y1 $x2 $y2 -to 0 0 $x2_new $y2_new "
	$newimg copy $canimg -from  $x1 $y1 $x2 $y2 -to 0 0 $x2_new $y2_new
    }
    set rgb2 [list [expr [lindex $rgb 0]/256] [expr [lindex $rgb 1]/256] [expr [lindex $rgb 2]/256]]

	set h [image height $newimg]
	set w [image width $newimg]
set x1n -1
set y1n -1
set x2n -1
set y2n -1
	for { set x 0 } {$x < $w} {incr x} {
	    for {set y 0} {$y < $h} {incr y} {
		if {$cur == "" || $type == 2} {
    		    if { [$newimg get $x $y] != $rgb2 } {
			if {$y1n == -1} {
			    set y1n $y
			} elseif {$y1n > -1 && $y < $y1n} {
			    set y1n $y
			}
			if {$y2n == -1} {
			    set y2n $y
			} elseif {$y > $y2n} {
			    set y2n $y
			}
			if {$x1n == -1} {
			    set x1n $x
			} elseif {$x1n > -1 && $x < $x1n} {
			    set x1n $x
			}
			if {$x2n == -1} {
			    set x2n $y
			} elseif {$x > $x2n} {
			    set x2n $x
			}
        	    }
        	} else {
		    set over [$TPtoolpath find overlapping [expr {$x1 + $x}] [expr {$y1 + $y}] [expr {$x1 + $x}] [expr {$y1 + $y}]]
		    if {[lsearch $over $cur] >= 0} {
			if {$y1n == -1} {
			    set y1n $y
			} elseif {$y1n > -1 && $y < $y1n} {
			    set y1n $y
			}
			if {$y2n == -1} {
			    set y2n $y
			} elseif {$y > $y2n} {
			    set y2n $y
			}
			if {$x1n == -1} {
			    set x1n $x
			} elseif {$x1n > -1 && $x < $x1n} {
			    set x1n $x
			}
			if {$x2n == -1} {
			    set x2n $y
			} elseif {$x > $x2n} {
			    set x2n $x
			}
		    } 
        	}
    	    }
	}
#puts "TP_saveGroupToFileOrImage NewCoord: x1n=$x1n y1n=$y1n x2n=$x2n y2n=$y2n x1=$x1 y1=$y1"
set x1n [expr {$x1n + $x1}]
set y1n [expr {$y1n + $y1}]
set x2n [expr {$x2n + $x1 + 1}]
set y2n [expr {$y2n + $y1 + 1}]

#puts "TP_saveGroupToFileOrImage NewCopy: x1n=$x1n y1n=$y1n x2n=$x2n y2n=$y2n x1=$x1 y1=$y1"
    	image delete $newimg
	set newimg [image create photo]
	$newimg copy $canimg -from  $x1n $y1n $x2n $y2n -to 0 0
#$newimg write "/tmp/newimg1.png" -format "png"
    	image delete $canimg
#############Заменяем цвет канваса на прозрачность
if {1} {
	set h [image height $newimg]
	set w [image width $newimg]
#puts "Необходимо подождать! rgb2=$rgb2"
	for { set x 0 } {$x < $w} {incr x} {
	    for {set y 0} {$y < $h} {incr y} {
		if {$cur == "" || $typeP == 2} {
    		    if { [$newimg get $x $y] == $rgb2 } {
        		$newimg transparency set $x $y 1
        	    }
        	} else {
		    set over [.c find overlapping [expr {$x1 + $x}] [expr {$y1 + $y}] [expr {$x1 + $x}] [expr {$y1 + $y}]]
		    if {[lsearch $over $cur] < 0} {
        		$newimg transparency set $x $y 1
		    }
        	}
    	    }
	}
}
#$newimg write "/tmp/newimg2.png" -format "png"

if {$typeP == 2} {
#Выставляет поле data
    $newimg configure -data [$newimg data -format "png"]
    return $newimg
}

    if {$type == 0} {
	set File(img,types) {
		    {{img png} {.png} }
		    {{img gif} {.gif} }
		    {{img jpg} {.jpg} }
		    {{All files} * }
	}
        set type        "png"
        set title       "Select file for image group"
        set defaultName "tk_$newimg"
        set command tk_getSaveFile
        set filename [$command \
                -title "$title" \
                -filetypes $File(img,types) \
                -initialfile $defaultName \
                -defaultextension ".$type" ]
        if {$filename==""} {return 0}

    	$newimg write $filename -format "png"
	image delete $newimg
    } else {
	global TPimage
#Данные сразу в проект
        set defaultName "tk_$newimg"
#	set data [$newimg data -format "png"]
set Image(name) $newimg
$Image(name) configure -data [$Image(name) data -format "png"]
################################ START
    if {$type == 2} {
	global cmddel
        set x $x1
        set y $y1
        incr Image(ctr)
#        set v [catch { set id [.c create pimage $x $y -image $Image(name) -anchor nw -tags {image photo obj}] } err]
set v 0
	set m [list {1.0 0.0} {-0.0 1.0} {0.0 0.0}]
	.c itemconfigure $idsel -image $Image(name) -m $m
#	.c itemconfigure $idsel -m $m
return
        if {$v != 0} {
            incr Image(ctr) -1
            tk_messageBox -type ok \
                -message "Problem with image file or the Img package \
                          not installed:\n $err\n \
                          look at the readme file for details" \
                -icon warning \
                -title "TkPaint: $err" \
                -default ok
            return
        }
#Уничтожаем выделенную область для копирования
#        eval $cmddel
        set cmddel ""

        set Image(utag) [Utag assign $id]
        .c addtag spline withtag $Image(utag)
        History add [getObjectCommand $Image(utag) 1]
        Undo add ".c delete $Image(utag)"
    } else {
	bind .c <Button-1> {
	global cmddel
        set x [.c canvasx %x $Graphics(grid,snap)]
        set y [.c canvasy %y $Graphics(grid,snap)]
        incr Image(ctr)
        set v [catch { set id [.c create pimage $x $y -image $Image(name) -anchor c -tags {image photo obj}] } err]
        if {$v!=0} {
            incr Image(ctr) -1
            tk_messageBox -type ok \
                -message "Problem with image file or the Img package \
                          not installed:\n $err\n \
                          look at the readme file for details" \
                -icon warning \
                -title "TkPaint: $err" \
                -default ok
            return
        }
#Уничтожаем выделенную область для копирования
        eval $cmddel
        set cmddel ""

        set Image(utag) [Utag assign $id]
        .c addtag spline withtag $Image(utag)
        History add [getObjectCommand $Image(utag) 1]
        Undo add ".c delete $Image(utag)"
        bind .c <Button-1> {}
#parray Graphics
#puts "TP_saveGroupToFileOrImage: cur=$cur "
	    if {$Graphics(mode) == "SaveAreaToImage" && $Graphics(shape) == "Free Hand Select"} {
		.c delete freeHandImage
		set Graphics(shape) {}
		set Graphics(mode) {}
	    }
	}
    }
###################################### END
  }
}

proc TP_saveOneImage {type} {
    set TPtoolpath ".c"
    set cur [.c find withtag Selected]
    if {[llength $cur] != 1} {
        tk_messageBox -title "Save Area" -message "Missing highlighted area"  -icon info
	return
    }
    set tobj [.c type $cur]
#    puts "TP_saveOneImage: Current=$cur type=$tobj utags=[.c itemconfigure $cur -tags]"
    if {$tobj == "image" || $tobj == "pimage"} { 
	unselectGroup
        tk_messageBox -title "Save Area" -message "Incorrect area (image) selection"  -icon info
	return
    }
    if {![idissvg $cur]} {
        .c  itemconfigure $cur -outline {}
    } else {
	unselectGroup
        tk_messageBox -title "Save Area" -message "Incorrect area selection"  -icon info
	return
    }
#    puts "TP_saveOneImage: Current=$cur type=$type utags=[.c itemconfigure $cur -tags]"
#Информация о задержки
    catch {destroy .waitimage}
    label .waitimage -text "Wait. Image formation is underway." -anchor w -justify left -bg yellow -font {Times 16 bold italic}  -foreground blue
    place .waitimage -in .tools.width -relx 0.0 -rely 0.25
    tk busy hold ".tools"
    tk busy hold ".svg"

    set ret [TP_saveGroupToFileOrImage $type $cur]
    tk busy forget ".tools"
    tk busy forget ".svg"
    destroy .waitimage
}
###### FREE HAND SECTION
proc TP_freehandSelect {} {
  global freeHand Graphics
  set Graphics(shape) "Free Hand Select"
  bind .c <Button-1> {
      lappend freeHand(coords) [.c canvasx %x] [.c canvasy %y]
      set freeHand(tmp_options)  [list \
             -width 1 \
             -fill  black \
             -stipple $Graphics(line,style) \
             -joinstyle $Graphics(line,joinstyle) \
             -capstyle $Graphics(line,capstyle) \
             -tags {freeHandTemp}\
      ]
      set freeHand(options)  [list \
             -width 1 \
             -fill  {} \
             -outline  {yellow} \
             -stipple $Graphics(line,style) \
             -joinstyle $Graphics(line,joinstyle) \
             -tags {freeHandImage obj}\
      ]
#             -fill  $Graphics(line,color) 
#             -capstyle $Graphics(line,capstyle) 
  }

  bind .c <B1-Motion> {
        set x [.c canvasx %x]
        set y [.c canvasy %y]
        set n [llength $freeHand(coords)]
        set lastPoint [lrange $freeHand(coords) [expr $n-2] end]
        eval .c create line $lastPoint $x $y $freeHand(tmp_options)
        lappend freeHand(coords) $x $y
  }

  bind .c <B1-ButtonRelease> {
     .c delete freeHandTemp
#      set id [eval .c create line $freeHand(coords) $freeHand(options)]
#puts "TP_freehandSelect: $freeHand(options)"
      set id [eval .c create polygon $freeHand(coords) $freeHand(options)]
      set utag [Utag assign $id]
      History add [getObjectCommand $utag 1]
      Undo add ".c delete $utag"
      catch {unset freeHand}
#ВЫДЕЛЕНИЕ
     unselectGroup
     set x [.c canvasx %x]
     set y [.c canvasy %y]
     set utag [getNearestUtag $x $y 2 obj]
     if {$utag==""} {
       Message "No object under cursor. Try again."
       return
     }
     .c addtag Selected withtag $utag
     set bbox [.c bbox Selected]
     drawBoundingBox
     setEditGroupMode
#puts "TP_saveOneImage:Graphics(shape)=$Graphics(shape) Graphics(mode)=$Graphics(mode) utag=$utag  + Selected"
  }
  Message "Never scare your users!"
}
proc TP_unfreehandSelect {} {
  global selectBox
  catch {unset selectBox}
  .c delete graybox
  .c dtag obj Selected
  .c configure -cursor ""
    .c delete freeHandImage
}

proc TPselectAction {butt1} {
    global TPtekbut
    global Graphics
    $TPtekbut configure -bg {#eff0f1}
    $butt1 configure -bg red
    set TPtekbut $butt1 
    set Graphics(mode) ""
#parray Graphics
#puts $TPtekbut 
#puts $butt1
}

#Всплывающая подсказка
proc TP_popupHint {wname msg {anchor nw}} {
# Create the necessary bindings for pop-up help on the specified widget.
    if {[winfo exists $wname]} {
	bind $wname <Enter> [list TP_hintShow %W $msg $anchor]
	bind $wname <Leave> [list TP_hintHide %W]
   }
    return {}
}
proc TP_hintHide {wname} {
    set wtop $wname
    while {1} {
	if {[TP_ClassGet $wtop] == "Toplevel"} {break}   
	set wtop [winfo parent $wtop]
    }
    if {$wtop == "."} {
	set wtop ""
    }
# Hide the help windows.
    if {[winfo exists $wtop.tppopuphelp]} {
	destroy $wtop.tppopuphelp
    }
    return
}
proc TP_hintShow {wname msg anchor} {
# Hide the help windows.
    global TPhelpmsg
    global tcl_platform
    set fmsg {Helvertica 8}
    set Xpos [winfo pointerx $wname]
    set Ypos [winfo pointery $wname]
    set curwin [winfo containing $Xpos $Ypos]
    if {$curwin eq $wname} {
	set TPhelpmsg $msg
	set wtop $wname
	while {1} {
	    if {[TP_ClassGet $wtop] == "Toplevel"} {break}   
	    set wtop [winfo parent $wtop]
	}
	if {$wtop == "."} {
	    set wtop ""
	}
        if {![winfo exists $wtop.tppopuphelp]} {
#Ширина оконтовки
    	    set bdl 1
#	    regexp {(\d*)x(\d*)\+(\d*)\+(\d*)} [winfo geometry $wtop] -> w h x y
	    if {$wtop != ""} {
	    regexp {(\d*)x(\d*)\+(\d*)\+(\d*)} [wm geometry $wtop] -> w h x y
	    } else {
		regexp {(\d*)x(\d*)\+(\d*)\+(\d*)} [wm geometry .] -> w h x y
	    }
	    set lenmsg [font measure $fmsg $msg]
	    set Xpos [winfo rootx $wname]
	    if {[expr {$Xpos + $lenmsg + 4 * $bdl}] > [expr {$x + $w}]} {
		set Xpos [expr {($x + $w) - ($Xpos + $lenmsg + 4 * $bdl)}]
	    } else {
		set Xpos 0
	    }
    	    set Ypos [winfo rooty $wname]

#    	    label $wtop.tppopuphelp -font $fmsg -bg cornsilk -fg black -borderwidth 1 -relief solid -textvariable TPhelpmsg
    	    label $wtop.tppopuphelp -font $fmsg -bg cyan1 -fg black -borderwidth $bdl -relief solid -textvariable TPhelpmsg
	    set Ypos [expr {[font metrics $fmsg -ascent] + [font metrics $fmsg -descent]}]
	    place $wtop.tppopuphelp -in $wname -x $Xpos -y -$Ypos
        }
   }
    return {}
}

# Procedure: TP_ClassGet
proc TP_ClassGet { wname} {
global TPrealClass

set rtnval {}
if {$wname eq {.}} {
    set rtnval Toplevel
   } {
      if {[winfo exists $wname]} {
          set rtnval [winfo class $wname]
          if {[info exists TPrealClass($rtnval)]} { set rtnval $TPrealClass($rtnval) }
         }
     }
return $rtnval
}

#Повернуть объект на угол
proc TP_idrotate {id deg} {
    set pi [expr 2*asin(1)]
    set bb [.c bbox $id]
#    set x0 [expr {([lindex $bb 0] + [lindex $bb 2]) / 2}]
#    set y0 [expr {([lindex $bb 1] + [lindex $bb 3]) / 2}]
    set x0 [expr {([lindex $bb 0] + [lindex $bb 2]) / 2}]
    set y0 [expr {([lindex $bb 1] + [lindex $bb 3]) / 2}]

    set phi [expr $deg * $pi / 180.0]
    set m [::tkp::matrix rotate $phi $x0 $y0]
#    set m [::tkp::matrix rotate $phi $x0 $x0]
    .c itemconfig $id -m $m
}
#Image rotate
proc TP_imagerotate { {deg 0} } {
    global Rotate
    set id $Rotate(id)
    if {[idissvg $id]} {
	.c itemconfigure $id -m $Rotate(matrix)
	rotateid2angle $id $deg
    }
    drawBoundingBox
    return
}
#Transform skewx skewy rotate
proc TP_skewX { {deg 0} } {
    global Rotate
    set id $Rotate(id)
    set degX $Rotate(skewX)
#    if {$degX > 360.00 || $degX < -360.00} {return}
    set bno [.c bbox $id]
    if {[.c bbox mainBBox] == ""} {
	set x0 [lindex [.c bbox $id] 0]
	set y0 [lindex [.c bbox $id] 1]
    } else {
	set x0 [lindex [.c bbox mainBBox] 0]
	set y0 [lindex [.c bbox mainBBox] 1]
    }
.c itemconfigure $id -m $Rotate(matrixLast)
    foreach {cx0 cy0} [id2coordscenter $id] {break}
#moveid2dxdy $id [expr {-1.0 * ($x0 - $cx0)}] [expr {-1.0 * ($y0 - $cy0)}] 
#    skewxid2angle $id  [expr {$Rotate(skewXlast) - $degX}]
    skewxid2angle $id  [expr {$degX - $Rotate(skewXlast)}]
    set Rotate(skewXlast) $Rotate(skewX)
    foreach {cx1 cy1} [id2coordscenter $id] {break}
#moveid2dxdy $id [expr {$x0 - $cx0}] [expr {$y0 - $cy0}] 
    moveid2dxdy $id [expr {-1.0 * ($cx1 - $cx0)}] [expr {-1.0 * ($cy1 - $cy0)}] 
    set Rotate(matrixLast) [.c itemcget $id -m]
    drawBoundingBox
}
proc TP_skewY { {deg 0} } {
    global Rotate
    set id $Rotate(id)
    set degY $Rotate(skewY)
#    if {$degY > 89.99 || $degY < -89.99} {return}
	set bno [.c bbox $id]
	if {[.c bbox mainBBox] == ""} {
	set x0 [lindex [.c bbox $id] 0]
	set y0 [lindex [.c bbox $id] 1]
    } else {
	set x0 [lindex [.c bbox mainBBox] 0]
	set y0 [lindex [.c bbox mainBBox] 1]
    }
.c itemconfigure $id -m $Rotate(matrixLast)
    foreach {cx0 cy0} [id2coordscenter $id] {break}
#    skewyid2angle $id [expr {$Rotate(skewYlast) - $degY}]
    skewyid2angle $id [expr {$degY - $Rotate(skewYlast)}]
    set Rotate(skewYlast) $Rotate(skewY)
    foreach {cx1 cy1} [id2coordscenter $id] {break}
    moveid2dxdy $id [expr {-1.0 * ($cx1 - $cx0)}] [expr {-1.0 * ($cy1 - $cy0)}] 
    set Rotate(matrixLast) [.c itemcget $id -m]
    drawBoundingBox
}
proc TP_rotateC { {deg 0} } {
    global Rotate
    set id $Rotate(id)

	set degR $Rotate(angle)
	set bno [.c bbox $id]
	if {[.c bbox mainBBox] == ""} {
	set x0 [lindex [.c bbox $id] 0]
	set y0 [lindex [.c bbox $id] 1]
    } else {
	set x0 [lindex [.c bbox mainBBox] 0]
	set y0 [lindex [.c bbox mainBBox] 1]
    }
.c itemconfigure $id -m $Rotate(matrixLast)
    foreach {cx0 cy0} [id2coordscenter $id] {break}
#    rotateid2angle $id [expr {$Rotate(anglelast) - $degR}]
    rotateid2angle $id [expr {$degR - $Rotate(anglelast)}]
    set Rotate(anglelast) $Rotate(angle)
    foreach {cx1 cy1} [id2coordscenter $id] {break}
    moveid2dxdy $id [expr {-1.0 * ($cx1 - $cx0)}] [expr {-1.0 * ($cy1 - $cy0)}] 
    set Rotate(matrixLast) [.c itemcget $id -m]
    drawBoundingBox
}
#Image полного  canvas
#proc ::canvas::snap {canvas} {}
proc fullcanvas {canvas} {
    # Ensure that the window is on top of everything else, so as not
    # to get white ranges in the image, due to overlapped portions of
    # the window with other windows...

    raise [winfo toplevel $canvas] 
    update
    # XXX: Undo the raise at the end ?!

    set border [expr {[$canvas cget -borderwidth] +
                      [$canvas cget -highlightthickness]}]

    set view_height [expr {[winfo height $canvas]-2*$border}]
    set view_width  [expr {[winfo width  $canvas]-2*$border}]

    lassign [$canvas bbox all] x1 y1 x2 y2
    #foreach {x1 y1 x2 y2} [$canvas bbox all] break

    set x1 [expr {int($x1-10)}]
    set y1 [expr {int($y1-10)}]
#Для полного совпадения и оригиналом холста
set x1 0
set y1 0
    set x2 [expr {int($x2+10)}]
    set y2 [expr {int($y2+10)}]

    set width  [expr {$x2-$x1}]
    set height [expr {$y2-$y1}]

    set image [image create photo -height $height -width $width]

    # Arrange the scrollregion of the canvas to get the whole window
    # visible, so as to grab it into an image...

    # Save the scrolling state, as this will be overidden in short order.
    set scrollregion   [$canvas cget -scrollregion]
    set xscrollcommand [$canvas cget -xscrollcommand]
    set yscrollcommand [$canvas cget -yscrollcommand]
#LISSI
    set vscr [lindex $yscrollcommand 0]
    set hscr [lindex $xscrollcommand 0]
    set canvget [lindex [$vscr get] 0]
    set canhget [lindex [$hscr get] 0]
#puts "Сдаиг по y=$canvget по x=$canhget"

    $canvas configure -xscrollcommand {}
    $canvas configure -yscrollcommand {}

    set grabbed_x $x1
    set grabbed_y $y1
    set image_x   0
    set image_y   0

    while {$grabbed_y < $y2} {
	while {$grabbed_x < $x2} {
	    set newregion [list \
			       $grabbed_x \
			       $grabbed_y \
			       [expr {$grabbed_x + $view_width}] \
			       [expr {$grabbed_y + $view_height}]]

	    $canvas configure -scrollregion $newregion
	    update

	    # Take a screenshot of the visible canvas part...
	    set tmp [image create photo -format window -data $canvas]

	    # Copy the screenshot to the target image...
	    $image copy $tmp -to $image_x $image_y -from $border $border

	    # And delete the temporary image (leak in original code)
	    image delete $tmp

	    incr grabbed_x $view_width
	    incr image_x   $view_width
	}

	set grabbed_x $x1
	set image_x 0

	incr grabbed_y $view_height
	incr image_y   $view_height
    }

    # Restore the previous scrolling state of the canvas.

    $canvas configure -scrollregion   $scrollregion
    $canvas configure -xscrollcommand $xscrollcommand
    $canvas configure -yscrollcommand $yscrollcommand
    $canvas yview moveto $canvget 
    $canvas xview moveto $canhget 

    # At last, return the fully assembled snapshot
    return $image
}


# Edit Radius Round Rectangle:
proc editRadiusRoundRect {} {
   global glwidth glw_undo Font
   global glradius
   set have_line 0

   set glw_undo [getGroupCommand 1]

   foreach id [.c find withtag Selected] {
      set type [.c type $id]
      switch -exact -- $type {
	 ppolygon -
	 pimage   -
         text     -
         image    -
         bitmap   {continue}
         default  {set glwidth [.c itemcget $id -strokewidth]
		   set glradius [.c itemcget $id -rx]
                   set have_line 1
                   break
                  }
      }
   }

   if {$have_line==0} {
     Message "There are no lines in selection box"
     return
   }

   catch {destroy .grouplw}
   toplevel .grouplw
#   wm transient .grouplw .
   wm resizable .grouplw 0 0
#   wm geometry .grouplw +250+150
   focus -force .grouplw
   wm title .grouplw "Select radius round rectangle"
   frame .grouplw.width ;# -relief raised -bd 1
   scale .grouplw.widthscale -orient horiz \
          -resolution 1 -from 0 -to 60 \
          -length 4c \
          -variable glradius \
          -command updateRadiusRoundRect \
          -bd 2 \
          -relief flat \
          -highlightthickness 0 \
          -width 10 \
          -showvalue true \
          -font $Font(groupLineWidthDemo)
   pack .grouplw.widthscale -in .grouplw.width -side top  -fill both -expand true
   pack .grouplw.width
   frame .grouplw.butts
   pack .grouplw.butts -side top -fill both -expand true -pady 2m

   button .grouplw.butts.ok -text OK -command {
        set cmd ""
        foreach id [.c find withtag Selected] {
            set type [.c type $id]
            if {$type=="text" || $type=="image" || $type=="bitmap"} {
              continue
            }
            set utag [Utag find $id]
            set lw [.c itemcget $id -strokewidth]
            append cmd [list .c itemconfigure $utag -strokewidth $lw]
        }
        History add $cmd
        Undo add $glw_undo
        unset glwidth glw_undo cmd
        destroy .grouplw
   }

   button .grouplw.butts.cancel -text Cancel -command {
      eval $glw_undo
      unset glw_undo
      destroy .grouplw
   }

   pack .grouplw.butts.ok .grouplw.butts.cancel -side left -fill x -expand 1

   wm protocol .grouplw WM_DELETE_WINDOW {.grouplw.butts.ok invoke}
   #tkwait window .grouplw
   grab set .grouplw
}

proc updateRadiusRoundRect {glw} {
   global Graphics
   global TPcolor
   global glradius
   foreach id [.c find withtag Selected] {
       set type [.c type $id]
#puts "updateRadiusRoundRect: type=$type"
       switch -exact -- $type {
          text   -
          image  -
          bitmap {continue}
          line   {
             .c itemconfigure $id -strokewidth $glw
          }
          default   {
    		.c itemconfigure $id -rx $glradius
#    		 -strokelinejoin miter
          }
       }
   }
}


#######################SCREENSHOT###########################################

proc ScaleImage {img1 targetwidth} {

	set w [image width $img1]
	set ratio [expr {$targetwidth / ($w * 1.0)}]
	set img2 [image create photo]

	if {$ratio >= 1} {
		set f [expr int($ratio)]
		$img2 copy $img1 -zoom $f $f

	} else {
		set f [expr round(1.0 / $ratio)]
		
		# a.) Img package (bad quality):
		$img2 copy $img1 -subsample $f $f

		# test as well the following: 
		# $img2 copy $img1 -shrink
		
		# b.) with procedure (slightly better quality, but slow):
		#     http://wiki.tcl.tk/10504
		# set img2 [Shrink3 $img1 $ratio]
	}

	image delete $img1
	return $img2
}


proc SaveScreenShot {wparent capture_img} {

	# finally, write image to file and we are done...
	set filetypes {
		{"All Image Files" {.gif .png .jpg}}
		{"PNG Images" .png}
	}

	set re {\.(gif|png)$}
	set LASTDIR [pwd]
			
	set file [tk_getSaveFile \
		-parent $wparent -title "Save Image to File" \
		-initialdir $LASTDIR -filetypes $filetypes]
			
	if {$file ne ""} {
			
		if {![regexp -nocase $re $file -> ext]} {
			set ext "png"
			append file ".${ext}"
		}
		
		# -test-
#LISSI
#Это для масштабирования
#		set scaled_img [ScaleImage $capture_img 1200]
#а сейчас
set scaled_img $capture_img

		if {[catch {$scaled_img write $file -format [string tolower $ext]} err]} {
						
			tk_messageBox -title "Error Writing File" \
				-parent $wparent -icon error -type ok \
				-message "Error writing to file \"$file\":\n$err"
		}
		
		# clear some memory:
		image delete $scaled_img
	}
}

proc createpath {} {

    ShowWindow.tpcmdedit -1

}

set dev_mode 1

if { $dev_mode } {
	catch {
		console show
		console eval {wm protocol . WM_DELETE_WINDOW {exit 0}}
	}
}

set t [toplevel .t]

wm geometry $t "+50+50"
set aa [screenshot::screenshot $t.scrnshot \
		-background LightYellow -foreground DarkGreen \
		-alpha 0.5 \
		-width 800 -height 600 \
		-screenshotcommand "SaveScreenShot $t"]

pack $t.scrnshot -expand true -fill both


