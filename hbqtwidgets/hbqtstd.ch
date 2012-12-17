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


   /* Constants for _QGET_DATA array elements */
   #define _QDATA_LISTBOX_ITEMS                   1
   #define _QDATA_LISTBOX_FOCUSBLOCK              2
   #define _QDATA_LISTBOX_STATUSBLOCK             3
   #define _QDATA_LISTBOX_SCROLLBAR               4


   #define _QSET_GETSFONT                         1
   #define _QSET_LINESPACING                      2
   #define _QSET_NOMOUSABLE                       3


   #command QSET GETSFONT [TO] <oFont>            =>   HbQtSet( _QSET_GETSFONT   , <oFont>   )
   #command QSET LINESPACING [TO] <nPixels>       =>   HbQtSet( _QSET_LINESPACING, <nPixels> )
   #command QSET NOMOUSABLE [TO] <lMouse>         =>   HbQtSet( _QSET_NOMOUSABLE , <lMouse>  )


   #command @ <row>, <col> QSAY <exp> [PICTURE <pic>] [COLOR <clr>] => ;
         AAdd( SayList, { <row>, <col>, <exp>, <pic>, <clr> } )


   #command @ <row>, <col> QGET <v> ;
                              [PICTURE <pic>] ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [COLOR <color>] ;
                              [CAPTION <cap>] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl> ] ;
                       => ;
         AAdd( GetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, NIL, NIL, NIL, NIL, NIL, <oControl>, "QLineEdit", NIL } )


   #command @ <row>, <col> QSAY <sayExp> ;
                              [PICTURE <sayPic>] ;
                              [COLOR <sayColor>] ;
                           QGET <v> ;
                              [PICTURE <pic>] ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [COLOR <color>] ;
                              [CAPTION <cap>] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl> ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, NIL, NIL, ;
                                <sayExp>, <sayPic>, <sayColor>, <oControl>, "QLineEdit", NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> MEMOEDIT ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [COLOR <color>] ;
                              [CAPTION <cap>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl> ] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QPlainTextEdit", NIL } )


   #command @ <top>, <left>, <bottom>, <right> QGET <v> LISTBOX <items> ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [COLOR <color>] ;
                              [CAPTION <cap>] ;
                              [<noMouse: NOMOUSABLE>] ;
                              [CONTROL <oControl> ] ;
                              [FOCUS <fb>] ;
                              [STATE <sb>] ;
                              [<sbar:SCROLLBAR>] ;
                        => ;
         AAdd( GetList, { _GET_( <v>, <"v">, NIL, <{valid}>, <{when}> ),;
                                <cap>, <color>, NIL, <.noMouse.>, <top>, <left>, <bottom>, <right>, NIL, NIL, NIL, <oControl>, "QListWidget", ;
                                { <items>, <{fb}>, <{sb}>, <.sbar.> } } )


   #command QREAD [ PARENT <GetParent> ] [ FONT <oFont> ] [ LINESPACING <nSpc> ] => HbQtReadGets( GetList, SayList, <GetParent>, <oFont>, <nSpc> )
   #command QREAD => HbQtReadGets( GetList, SayList, GetParent, NIL, 6 )

#endif