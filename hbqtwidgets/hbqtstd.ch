   /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#ifndef HB_QSTD_CH_
   #define HB_QSTD_CH_

   #define HBQT_CHART_BARS                        0
   #define HBQT_CHART_BARS_M                      1
   #define HBQT_CHART_PIE                         2
   #define HBQT_CHART_PIE_3D                      3
   #define HBQT_CHART_LINES                       4

   #define HBQT_LEGEND_VERICAL                    0
   #define HBQT_LEGEND_CIRCULAR                   1

   #define HBQTMDI_MODE_SUBWINDOWS                0
   #define HBQTMDI_MODE_TABBED                    1

   #define HBQTMDI_STYLE_ORGANIZED                0
   #define HBQTMDI_STYLE_CASCADED                 1
   #define HBQTMDI_STYLE_TILED                    2
   #define HBQTMDI_STYLE_MAXIMIZED                3
   #define HBQTMDI_STYLE_TILEDVERT                4
   #define HBQTMDI_STYLE_TILEDHORZ                5

   #define HBQTBRW_CURSOR_NONE                    1
   #define HBQTBRW_CURSOR_CELL                    2
   #define HBQTBRW_CURSOR_ROW                     3

   #define HBQTBRW_SEARCH_ONCE                    0
   #define HBQTBRW_SEARCH_INCREMENTAL             1
   #define HBQTBRW_SEARCH_BYFIELD                 2

   #define _QGET_GET                              1
   #define _QGET_CAPTION                          2
   #define _QGET_COLOR                            3
   #define _QGET_VALIDATOR                        4
   #define _QGET_NOMOUSE                          5
   #define _QGET_ROW                              6
   #define _QGET_COL                              7
   #define _QGET_TOROW                            8
   #define _QGET_TOCOL                            9
   #define _QGET_SAY                              10
   #define _QGET_SAYPICTURE                       11
   #define _QGET_SAYCOLOR                         12
   #define _QGET_CONTROL                          13
   #define _QGET_TYPE                             14
   #define _QGET_DATA                             15
   #define _QGET_PROPERTIES                       16
   #define _QGET_SAYPROPERTIES                    17

   #define _QSAY_ROW                              1
   #define _QSAY_COL                              2
   #define _QSAY_EXP                              3
   #define _QSAY_PICTURE                          4
   #define _QSAY_COLOR                            5
   #define _QSAY_PROPERTIESBLOCK                  6
   #define _QSAY_OBJECT                           7


   /* Additiona parameters for GETs window - QREAD ... ATTRIBUTES <aAttribs> */
   #define _QGET_ATTRB_SETMODE                    1        /* SetMode() Equivalent Array - { nRows, nColumns } */
   #define _QGET_ATTRB_RESIZABLE                  2        /* Logical to flag if window is resizable . Default is TRUE */
   #define _QGET_ATTRB_ATROWCOLUMNONTOPOF         3        /* Array representing { oWnd, nRow, nCol, lMovable } */

   /* Constants for _QGET_DATA array elements */
   #define _QDATA_LISTBOX_ITEMS                   1


   #define _QDATA_COMBOBOX_ITEMS                  1


   #define _QDATA_PUSHBUTTON_TEXT                 1
   #define _QDATA_PUSHBUTTON_ACTION               2


   #define _QSET_GETSFONT                         1
   #define _QSET_LINESPACING                      2
   #define _QSET_NOMOUSABLE                       3
   #define _QSET_EDITSPADDING                     4


   #command QSET GETSFONT [TO] <oFont>            =>   HbQtSet( _QSET_GETSFONT    , <oFont>   )
   #command QSET LINESPACING [TO] <nPixels>       =>   HbQtSet( _QSET_LINESPACING , <nPixels> )
   #command QSET NOMOUSABLE [TO] <lMouse>         =>   HbQtSet( _QSET_NOMOUSABLE  , <lMouse>  )
   #command QSET EDITSPADDING [TO] <nPadds>       =>   HbQtSet( _QSET_EDITSPADDING, <nPadds>  )


   #command @ <row>, <col> QSAY <exp> [PICTURE <pic>] [COLOR <clr>] [ PROPERTIES <props> ] => ;
         AAdd( SayList, { <row>, <col>, <exp>, <pic>, <clr>, <{props}>, NIL } )


   #command @ <row>, <col> QGET <v> ;
                              [PICTURE <pic>        ] ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                       => ;
         AAdd( GetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, NIL, NIL, NIL, NIL, NIL, <oControl>, "QLineEdit", NIL, <{prop}>, NIL } )


   #command @ <row>, <col> QSAY <sayExp> ;
                              [PICTURE <sayPic>     ] ;
                              [COLOR <sayColor>     ] ;
                              [PROPERTIES <sayProps>] ;
                           QGET <v> ;
                              [PICTURE <pic>        ] ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, NIL, NIL, ;
                                <sayExp>, <sayPic>, <sayColor>, <oControl>, "QLineEdit", NIL, <{prop}>, <{sayProps}> } )


   #command @ <row>, <col> QGET <v> CHECKBOX  ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                       => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <row>, <col>, NIL, NIL, NIL, NIL, NIL, <oControl>, "QCheckBox", NIL, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> MEMOEDIT ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QPlainTextEdit", NIL, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> LISTBOX <items> ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QListWidget", ;
                                { <items> }, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> COMBOBOX <items> ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QComboBox", ;
                                { <items> }, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> PUSHBUTTON <label> [ACTION <act>] ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QPushButton", ;
                                { <label>, <{act}> }, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> HBQTBROWSE <oHbQtBrowse> ;
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "HbQtBrowse", ;
                                { <oHbQtBrowse> }, <{prop}>, NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> IMAGE [<lDoNotScale: DONOTSCALE>];
                              [VALID <valid>        ] ;
                              [WHEN <when>          ] ;
                              [COLOR <color>        ] ;
                              [CAPTION <cap>        ] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl>   ] ;
                              [PROPERTIES <prop>    ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QImage", ;
                                <.lDoNotScale.>, <{prop}>, NIL } )


   #command QREAD [ [ PARENT ] <GetParent> ] ;
                  [ FONT <oFont>           ] ;
                  [ LINESPACING <nSpc>     ] ;
                  [ TITLE <title>          ] ;
                  [ ICON <icon>            ] ;
                  [ <nomodal:NOMODAL>      ] ;
                  [ PROPERTIES <prop>      ] ;
                  [ LASTGETBLOCK <bLast>   ] ;
                  [ <nofous:NOFOCUSFRAME>  ] ;
                  [ ATTRIBUTES <aAttrbs>   ] ;
                  [ <noresize:NORESIZE>    ] ;
                        => ;
         HbQtReadGets( @GetList, SayList, <GetParent>, <oFont>, <nSpc>, <title>, <icon>, <.nomodal.>, <{prop}>, <{bLast}>, <.nofous.>, <aAttrbs>, <.noresize.> )


   /* Dashboard Objects - Attributes Array Elements per Object Type */
   #define DBRD_ATTRB_TEXT_FONTNAME                  1
   #define DBRD_ATTRB_TEXT_FONTSIZE                  2
   #define DBRD_ATTRB_TEXT_COLORS                    3
   #define DBRD_ATTRB_TEXT_NOWRAP                    4
   #define DBRD_ATTRB_TEXT_KEEPAPPENDING             5
   #define DBRD_ATTRB_TEXT_CLEARAFTERMS              6

   #define DBRD_ATTRB_TEXT_NOVRBLS                   6

   #define HBQT_P_XX( n )                            ( Int( QApplication():primaryScreen():logicalDotsPerInchY() * n / 96 ) )

   #define __STATE_AREA_NONE__                       0
   #define __STATE_AREA_TOPLEFT__                    1
   #define __STATE_AREA_TOPRIGHT__                   2
   #define __STATE_AREA_BOTTOMRIGHT__                3
   #define __STATE_AREA_BOTTOMLEFT__                 4
   #define __STATE_AREA_CENTER__                     5
   #define __STATE_AREA_OVERALL__                    6
   //
   #define __STATE_AREA_TOP_1_8__                    7
   #define __STATE_AREA_TOP_1_4__                    8
   #define __STATE_AREA_TOP_1_2__                    9
   #define __STATE_AREA_BTM_1_8__                    10
   #define __STATE_AREA_BTM_1_4__                    11
   #define __STATE_AREA_BTM_1_2__                    12
   #define __STATE_AREA_LFT_1_8__                    13
   #define __STATE_AREA_LFT_1_4__                    14
   #define __STATE_AREA_LFT_1_2__                    15
   #define __STATE_AREA_RGT_1_8__                    16
   #define __STATE_AREA_RGT_1_4__                    17
   #define __STATE_AREA_RGT_1_2__                    18
   //
   #define __STATE_AREA_MAXIMUM__                    18

   #define __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__ 1
   #define __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__ 2

   #define __VISUALIZER_ACTION_X__                   1
   #define __VISUALIZER_ACTION_Y__                   2
   #define __VISUALIZER_ACTION_POS__                 4
   #define __VISUALIZER_ACTION_WIDTH__               8
   #define __VISUALIZER_ACTION_HEIGHT__              16
   #define __VISUALIZER_ACTION_GEOMETRY__            32
   #define __VISUALIZER_ACTION_STATE__               64
   #define __VISUALIZER_ACTION_DEL__                 128
   #define __VISUALIZER_ACTION_LOCK__                256
   #define __VISUALIZER_ACTION_ROTATE__              512

   #define __VZOBJ_CLASS__                           1
   #define __VZOBJ_TYPE__                            2
   #define __VZOBJ_NAME__                            3
   #define __VZOBJ_LOCKED__                          4
   #define __VZOBJ_STATE__                           5
   #define __VZOBJ_X__                               6
   #define __VZOBJ_Y__                               7
   #define __VZOBJ_WIDTH__                           8
   #define __VZOBJ_HEIGHT__                          9
   #define __VZOBJ_ROTATION__                        10
   #define __VZOBJ_PENSTYLE__                        11
   #define __VZOBJ_PENWIDTH__                        12
   #define __VZOBJ_PENCOLOR__                        13
   #define __VZOBJ_CAPSTYLE__                        14
   #define __VZOBJ_JOINSTYLE__                       15
   #define __VZOBJ_MITTERLIMIT__                     16
   #define __VZOBJ_BRUSHSTYLE__                      17
   #define __VZOBJ_BRUSHCOLOR__                      18
   #define __VZOBJ_BBRUSHSTYLE__                     19
   #define __VZOBJ_BBRUSHCOLOR__                     20
   #define __VZOBJ_BACKGROUNDMODE__                  21
   #define __VZOBJ_OPACITY__                         22
   #define __VZOBJ_FONTFAMILY__                      23
   #define __VZOBJ_FONTSTYLE__                       24
   #define __VZOBJ_FONTSIZE__                        25
   #define __VZOBJ_TEXT__                            26
   #define __VZOBJ_DATA__                            27
   //
   #define __VZOBJ_VARIABLES__                       27

   #define __HBQT_PRP_JUST__                         1000
   #define __HBQT_PRP_EDIT__                         1001
   #define __HBQT_PRP_COMBO__                        1002
   #define __HBQT_PRP_COLOR__                        1003
   #define __HBQT_PRP_FONT__                         1004
   #define __HBQT_PRP_FONTSIZE__                     1005
   #define __HBQT_PRP_BRUSHSTYLE__                   1006
   #define __HBQT_PRP_TEXTURE__                      1007

   #define __HBQTEDITOR_FOCUSIN__                    101
   #define __HBQTEDITOR_RESIZE__                     102
   #define __HBQTEDITOR_SELECTIONINFO__              103
   #define __HBQTEDITOR_UPDATEFIELDSLIST__           104
   #define __HBQTEDITOR_MARKCURRENTFUNCTION__        105
   #define __HBQTEDITOR_GOTOPREVIOUSFUNCTION__       106
   #define __HBQTEDITOR_GOTONEXTFUNCTION__           107
   #define __HBQTEDITOR_SHOWHEADERFILE__             108
   #define __HBQTEDITOR_JUMPTOFUNCTIONHELP__         109
   #define __HBQTEDITOR_JUMPTOFUNCTION__             110
   #define __HBQTEDITOR_LOADFUNCTIONHELP__           111
   #define __HBQTEDITOR_UPDATEWORDSINCOMPLETER__     112


#endif
