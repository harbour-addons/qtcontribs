/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file for the Xbp*Classes
 *
 * Copyright 2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
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
/*----------------------------------------------------------------------*/
/*
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                         HbQtSttausbar Class
 *
 *                             Pritpal Bedi
 *                              01Mar2013
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "hbqtgui.ch"

/*----------------------------------------------------------------------*/

CLASS HbQtStatusBar

   DATA     oWidget
   DATA     oParent

   DATA     caption                               INIT ""
   DATA     sizeGrip                              INIT .T.

   DATA     aItems                                INIT {}

   METHOD   init( oParent )
   METHOD   create( oParent )

   METHOD   addItem( cCaption, nStyle, cKey, nMode )
   METHOD   delItem( nItemORcKey )
   METHOD   getItem( nItemORcKey )
   METHOD   clear()

   METHOD   panelClick( ... )                     SETGET
   METHOD   panelDblClick( ... )                  SETGET

   METHOD   numItems()                            INLINE Len( ::aItems )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:init( oParent )

   ::oParent := oParent

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:create( oParent )

   hb_default( @oParent, ::oParent )

   ::oParent := oParent

   ::oWidget := QStatusBar()

   ::oWidget:setSizeGripEnabled( ::sizeGrip )

   ::addItem( , , , -1 )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:addItem( cCaption, nStyle, cKey, nMode )
   LOCAL oPanel, lSuccess := .t.

   DEFAULT nMode TO 0

   oPanel := HbQtStatusBarPanel():new( cCaption, nStyle, cKey ):create()
   IF nMode == -1
      ::oWidget:addPermanentWidget( oPanel:oWidget, 1 )
   ELSE
      ::oWidget:addWidget( oPanel:oWidget )
   ENDIF

   oPanel:oParent := self
   oPanel:index := ::numItems + 1
   IF lSuccess
      AAdd( ::aItems, oPanel )
   ELSE
      RETURN nil
   ENDIF

   RETURN oPanel

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:delItem( nItemORcKey )
   LOCAL nIndex := 0

   IF HB_ISNUMERIC( nItemORcKey )
      nIndex := ascan( ::aItems, {|o| o:key == nItemORcKey } )
   ELSEIF HB_ISNUMERIC( nItemORcKey )
      nIndex := nItemORcKey
   ENDIF

   IF nIndex > 0
      /* Delete panel by window */
      adel( ::aItems, nIndex )
      asize( ::aItems, len( ::aItems ) - 1 )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:getItem( nItemORcKey )
   LOCAL nIndex := 0, oPanel

   IF HB_ISSTRING( nItemORcKey  )
      nIndex := ascan( ::aItems, {|o| o:key == nItemORcKey } )

   ELSEIF HB_ISNUMERIC(  nItemORcKey  )
      nIndex := nItemORcKey

   ENDIF

   IF nIndex > 0
      oPanel := ::aItems[ nIndex ]
   ENDIF

   RETURN oPanel

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:clear()

   ::aItems := {}

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:panelClick( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_lbClick := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_lbClick )
      eval( ::sl_lbClick, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBar:panelDblClick( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_lbDblClick := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_lbDblClick )
      eval( ::sl_lbDblClick, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
/*
 *                      XbpToolbarButton() Class
 */
/*----------------------------------------------------------------------*/

CLASS HbQtStatusBarPanel

   DATA     oParent
   DATA     oWidget

   DATA     alignment                             INIT Qt_AlignLeft
   DATA     enabled                               INIT .T.
   DATA     index                                 INIT 0
   DATA     key                                   INIT ""
   DATA     style                                 INIT 0
   DATA     sl_caption                            INIT ""
   DATA     image                                 INIT NIL
   DATA     tooltipText                           INIT ""
   DATA     visible                               INIT .T.
   DATA     left                                  INIT 0
   DATA     width                                 INIT 0
   DATA     minWidth                              INIT 0

   METHOD   init( cCaption, nStyle, cKey )
   METHOD   create( cCaption, nStyle, cKey )
   METHOD   caption( cCaption )                   SETGET

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBarPanel:init( cCaption, nStyle, cKey )

   DEFAULT cCaption       TO ::sl_caption
   DEFAULT nStyle         TO ::style
   DEFAULT cKey           TO ::key

   ::sl_caption     := cCaption
   ::style          := nStyle
   ::key            := cKey

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBarPanel:create( cCaption, nStyle, cKey )

   DEFAULT cCaption       TO ::sl_caption
   DEFAULT nStyle         TO ::style
   DEFAULT cKey           TO ::key

   ::sl_caption     := cCaption
   ::style          := nStyle
   ::key            := cKey

   ::oWidget := QLabel()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtStatusBarPanel:caption( cCaption )

   IF cCaption == NIL
      RETURN ::sl_caption

   ELSE
      DEFAULT cCaption TO ::sl_caption

      ::sl_caption := cCaption

      IF ::oWidget != NIL
         ::oWidget:setText( cCaption )
      ELSE
         ::oParent:oWidget:showMessage( cCaption )
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

