/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbclass.ch"
#include "hbqtgui.ch"


#define HBQTCOL_TYPE_ICON                         1
#define HBQTCOL_TYPE_BITMAP                       2
#define HBQTCOL_TYPE_SYSICON                      3
#define HBQTCOL_TYPE_TEXT                         4
#define HBQTCOL_TYPE_FILEICON                     5
#define HBQTCOL_TYPE_FILEMINIICON                 6
#define HBQTCOL_TYPE_MULTILINETEXT                7


FUNCTION HbQtColumnNew( cHeading, bBlock )
   RETURN HbQtColumn():new( cHeading, bBlock )


CREATE CLASS HbQtColumn INHERIT TBColumn

   METHOD new( cHeading, bBlock )
   METHOD configure()

   DATA   hAlignment                              INIT      Qt_AlignHCenter + Qt_AlignVCenter
   DATA   hHeight                                 INIT      20
   DATA   hFgColor                                INIT      Qt_black
   DATA   hBgColor                                INIT      Qt_darkGray

   DATA   fAlignment                              INIT      Qt_AlignHCenter + Qt_AlignVCenter
   DATA   fHeight                                 INIT      16
   DATA   fFgColor                                INIT      Qt_black
   DATA   fBgColor                                INIT      Qt_darkGray

   DATA   dAlignment                              INIT      Qt_AlignLeft
   DATA   dHeight                                 INIT      16
   DATA   dFgColor                                INIT      Qt_black
   DATA   dBgColor                                INIT      Qt_white
   DATA   nColWidth

   DATA   valtype
   DATA   type                                    INIT      HBQTCOL_TYPE_TEXT
   DATA   blankVariable

   ENDCLASS


METHOD HbQtColumn:new( cHeading, bBlock )

   ::TBColumn:new( cHeading, bBlock )

   ::valtype       := valtype( Eval( ::bBlock ) )
   ::blankVariable := iif( ::valtype == "N", 0, iif( ::valtype == "D", ctod( "" ), iif( ::valtype == "L", .f., "" ) ) )

   ::configure()

   RETURN Self


METHOD HbQtColumn:configure()

   //::hAlignment += Qt_AlignVCenter

   /*  Data Area  */
   ::dAlignment := iif( ::valtype == "N", Qt_AlignRight, iif( ::valtype $ "DL", Qt_AlignHCenter, Qt_AlignLeft ) )
   ::dAlignment += Qt_AlignVCenter

   //::dFgColor := hbxbp_ConvertAFactFromXBP( "Color", ::aPresParams[ n,2 ] )

   //::dBgColor := hbxbp_ConvertAFactFromXBP( "Color", ::aPresParams[ n,2 ] )

   //::fFgColor := hbxbp_ConvertAFactFromXBP( "Color", ::aPresParams[ n,2 ] )
   //::fBgColor := hbxbp_ConvertAFactFromXBP( "Color", ::aPresParams[ n,2 ] )
   //::fAlignment += Qt_AlignVCenter

   RETURN Self


