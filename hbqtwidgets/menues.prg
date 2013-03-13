/*
 * $Id$
 */

/*
 * Harbour Project source code:
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
 *                          HbQtMenuBar Class
 *
 *                            Pritpal Bedi
 *                              04Mar2013
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"

/*----------------------------------------------------------------------*/

#define QTC_MENITEM_CAPTION                       1
#define QTC_MENITEM_BLOCK                         2
#define QTC_MENITEM_STYLE                         3
#define QTC_MENITEM_ATTRIB                        4

#define QTC_MENUITEM_ADD                          1
#define QTC_MENUITEM_INSERT                       2
#define QTC_MENUITEM_REPLACE                      3

#define QMF_POPUP                                 1
#define QMF_BYPOSITION                            2
#define QMF_SEPARATOR                             3
#define QMF_STRING                                4
#define QMF_CHECKED                               5
#define QMF_UNCHECKED                             6
#define QMF_ENABLED                               7
#define QMF_GRAYED                                8

#define HBQTMENUBAR_MIS_BUTTONSEPARATOR           512
#define HBQTMENUBAR_MIS_STATIC                    256
#define HBQTMENUBAR_MIS_SEPARATOR                 4

#define HBQTMENUBAR_MIA_NODISMISS                 32
#define HBQTMENUBAR_MIA_FRAMED                    4096
#define HBQTMENUBAR_MIA_CHECKED                   8192
#define HBQTMENUBAR_MIA_DISABLED                  16384
#define HBQTMENUBAR_MIA_HILITED                   32768
#define HBQTMENUBAR_MIA_DEFAULT                   65536
#define HBQTMENUBAR_MIA_OWNERDRAW                 131072

/*----------------------------------------------------------------------*/

CLASS HbQtMenuBar

   DATA     oParent
   DATA     oWidget

   CLASSVAR nMenuItemID                            INIT 0
   DATA     hMenu

   DATA     aMenuItems                             INIT {}
   DATA     aOrgItems                              INIT {}
   DATA     nPass                                  INIT 0
   DATA     caption                                INIT ""
   DATA     nItemID                                INIT 0
   DATA     aIds                                   INIT {}

   METHOD   init( oParent )
   METHOD   create( oParent )
   METHOD   execSlot( cSlot, p )

   METHOD   delAllItems()
   METHOD   delItem( aItem )
   METHOD   addItem( aItem )
   METHOD   insItem( nItemIndex, aItem )
   METHOD   setItem( nItemIndex, aItem )
   METHOD   checkItem( nItemIndex, lCheck )
   METHOD   enableItem( nItemIndex )
   METHOD   disableItem( nItemIndex )
   METHOD   getItem( nItemIndex )
   METHOD   isItemChecked( nItemIndex )
   METHOD   isItemEnabled( nItemIndex )
   METHOD   selectItem( nItemIndex )

   METHOD   beginMenu( ... )                      SETGET
   METHOD   endMenu( ... )                        SETGET
   METHOD   itemMarked( ... )                     SETGET
   METHOD   itemSelected( ... )                   SETGET
   METHOD   drawItem( ... )                       SETGET
   METHOD   measureItem( ... )                    SETGET
   METHOD   onMenuKey( ... )                      SETGET

   METHOD   numItems()                            INLINE len( ::aMenuItems )

PROTECTED:
   DATA     sl_beginMenu
   DATA     sl_endMenu
   DATA     sl_itemMarked
   DATA     sl_itemSelected
   DATA     sl_drawItem
   DATA     sl_measureItem
   DATA     sl_onMenuKey

   METHOD   placeItem( xCaption, bAction, nStyle, nAttrb, nMode, nPos )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:init( oParent )

   ::oParent := oParent

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:create( oParent )

   DEFAULT oParent TO ::oParent

   ::oParent := oParent

   IF HB_ISOBJECT( ::oParent )
      ::oWidget := QMenuBar( ::oParent )
      ::oParent:setMenuBar( ::oWidget )
   ELSE
      ::oWidget := QMenuBar()
   ENDIF

   ::oWidget:setVisible( .T. )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:delAllItems()
   LOCAL aItem

   FOR EACH aItem IN ::aMenuItems
      ::delItem( @aItem )
   NEXT
   ::aMenuItems := {}

   RETURN .t.

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:delItem( aItem )
   LOCAL n, oAction

   IF HB_ISNUMERIC( aItem )
      n := aItem
      aItem := ::aMenuItems[ n ]  /* Will polish later */
      hb_adel( ::aMenuItems, n, .t. )
   ENDIF

   oAction := aItem[ 5 ]
   aItem := NIL

   IF HB_ISOBJECT( oAction ) .AND. __ObjGetClsName( oAction ) == "QACTION"
      IF !( oAction:isSeparator() )
         oAction:disConnect( "triggered(bool)" )
         oAction:disConnect( "hovered()"       )
      ENDIF
      oAction:setVisible( .f. )
      ::oWidget:removeAction( oAction )
   ENDIF

   RETURN .t.

/*----------------------------------------------------------------------*/
/*
 * xCaption : NIL | cPrompt | ncResource | oMenu
 */
METHOD HbQtMenuBar:placeItem( xCaption, bAction, nStyle, nAttrb, nMode, nPos )
   LOCAL nItemIndex, cCaption, cIcon, oAction, aItem, cType, pOldAct, nMenuItemId, n, cKey, oKey
   LOCAL lInsert := ( nMode == QTC_MENUITEM_INSERT )

   IF lInsert
      pOldAct := ::aMenuItems[ nPos, 5 ]
   ENDIF

   nItemIndex  := ::numItems() + 1
   nMenuItemId := ++::nMenuItemID

   cType := valtype( xCaption )
   DO CASE
   CASE cType == "U" .OR. empty( xCaption ) .OR. nStyle == HBQTMENUBAR_MIS_SEPARATOR
      IF lInsert
         oAction := ::oWidget:insertSeparator( pOldAct )
      ELSE
         oAction := ::oWidget:addSeparator()
      ENDIF
      aItem := { QMF_SEPARATOR, 0, 0, NIL, oAction }

   CASE cType == "C"
      oAction := QAction( ::oWidget )
      cCaption := strtran( xCaption, '~', '&' )
      IF ( n := at( '|', cCaption ) ) > 0
         cIcon := substr( cCaption, 1, n-1 )
         cCaption := substr( cCaption, n+1 )
      ENDIF
      IF ( n := at( chr( K_TAB ), cCaption ) ) > 0
         cKey := substr( cCaption, n+1 )
         cCaption := substr( cCaption, 1, n-1 )
      ENDIF
      oAction:setText( cCaption )
      IF hb_FileExists( cIcon )
         oAction:setIcon( QIcon( cIcon ) )
      ENDIF
      IF !empty( cKey )
         oKey := QKeySequence( cKey )
         oAction:setShortcut( oKey )
      ENDIF

      oAction:connect( "triggered(bool)", {|| ::execSlot( "triggered(bool)", nMenuItemID ) } )
      oAction:connect( "hovered()"      , {|| ::execSlot( "hovered()"      , nMenuItemID ) } )

      DO CASE
      CASE nAttrb == HBQTMENUBAR_MIA_CHECKED
         oAction:setCheckable( .t. )
         oAction:setChecked( .t. )
      CASE nAttrb == HBQTMENUBAR_MIA_DISABLED
         oAction:setDisabled( .t. )
      CASE nAttrb == HBQTMENUBAR_MIA_HILITED
         ::oWidget:setActiveAction( oAction )
      CASE nAttrb == HBQTMENUBAR_MIA_DEFAULT
         ::oWidget:setDefaultAction( oAction )
      CASE nAttrb == HBQTMENUBAR_MIA_FRAMED
      CASE nAttrb == HBQTMENUBAR_MIA_OWNERDRAW
      CASE nAttrb == HBQTMENUBAR_MIA_NODISMISS
      ENDCASE

      IF nStyle == HBQTMENUBAR_MIS_STATIC
         oAction:setDisabled( .t. )
      ENDIF

      IF nMode == QTC_MENUITEM_ADD
         ::oWidget:addAction( oAction )
      ELSE
         ::oWidget:insertAction( pOldAct, oAction )
      ENDIF

      aItem := { QMF_STRING, nMenuItemID, xCaption, bAction, oAction }

   CASE cType == "O" .AND. __ObjGetClsName( xCaption ) $ "QACTION,QWIDGETACTION"

      oAction := xCaption

      oAction:connect( "triggered(bool)", {|| ::execSlot( "triggered(bool)", nMenuItemID ) } )
      oAction:connect( "hovered()"      , {|| ::execSlot( "hovered()"      , nMenuItemID ) } )

      DO CASE
      CASE nAttrb == HBQTMENUBAR_MIA_CHECKED
         oAction:setCheckable( .t. )
         oAction:setChecked( .t. )
      CASE nAttrb == HBQTMENUBAR_MIA_DISABLED
         oAction:setDisabled( .t. )
      CASE nAttrb == HBQTMENUBAR_MIA_HILITED
         ::oWidget:setActiveAction( oAction )
      CASE nAttrb == HBQTMENUBAR_MIA_DEFAULT
         ::oWidget:setDefaultAction( oAction )
      CASE nAttrb == HBQTMENUBAR_MIA_FRAMED
      CASE nAttrb == HBQTMENUBAR_MIA_OWNERDRAW
      CASE nAttrb == HBQTMENUBAR_MIA_NODISMISS
      ENDCASE

      IF nStyle == HBQTMENUBAR_MIS_STATIC
         oAction:setDisabled( .t. )
      ENDIF

      IF nMode == QTC_MENUITEM_ADD
         ::oWidget:addAction( oAction )
      ELSE
         ::oWidget:insertAction( pOldAct, oAction )
      ENDIF

      aItem := { QMF_STRING, nMenuItemID, oAction:text(), bAction, oAction }

   CASE cType == "O"
      cCaption := iif( bAction == NIL, xCaption:title, bAction )
      aItem    := { QMF_POPUP, xCaption:oWidget, cCaption, xCaption, NIL }
      IF HB_ISSTRING( cCaption )
         xCaption:oWidget:setTitle( strtran( cCaption, '~','&' ) )
      ENDIF

   CASE cType == "N"
      /* Resource ID */

   ENDCASE

   IF     nMode == QTC_MENUITEM_ADD
      aadd( ::aMenuItems, aItem )
      aadd( ::aOrgItems , { xCaption, bAction, nStyle, nAttrb, NIL } )

   ELSEIF nMode == QTC_MENUITEM_INSERT
      asize( ::aMenuItems, ::numItems + 1 )
      asize( ::aOrgItems, ::numItems + 1 )
      ains( ::aMenuItems, nPos )
      ains( ::aOrgItems, nPos )
      ::aMenuItems[ nPos ] := aItem
      ::aOrgItems[ nPos ] := { xCaption, bAction, nStyle, nAttrb, NIL }

   ELSEIF nMode == QTC_MENUITEM_REPLACE

   ENDIF

   RETURN nItemIndex

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:addItem( aItem )
   LOCAL xCaption, bAction, nStyle, nAttrib

   IF PCount() == 1 .AND. HB_ISARRAY( aItem )
      ASize( aItem, 4 )

      xCaption := aItem[ 1 ]
      bAction  := aItem[ 2 ]
      nStyle   := aItem[ 3 ]
      nAttrib  := aItem[ 4 ]

      DEFAULT nStyle  TO 0
      DEFAULT nAttrib TO 0
   ELSE
      RETURN 0
   ENDIF

   RETURN ::placeItem( xCaption, bAction, nStyle, nAttrib, QTC_MENUITEM_ADD )

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:insItem( nItemIndex, aItem )
   LOCAL xCaption, bAction, nStyle, nAttrib

   IF nItemIndex > 0 .and. nItemIndex <= ::numItems .and. HB_ISARRAY( aItem )
      ASize( aItem, 4 )

      xCaption := aItem[ 1 ]
      bAction  := aItem[ 2 ]
      nStyle   := aItem[ 3 ]
      nAttrib  := aItem[ 4 ]

      DEFAULT nStyle  TO 0
      DEFAULT nAttrib TO 0
   ELSE
      RETURN 0
   ENDIF

   RETURN ::placeItem( xCaption, bAction, nStyle, nAttrib, QTC_MENUITEM_INSERT, nItemIndex )

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:setItem( nItemIndex, aItem )

   HB_SYMBOL_UNUSED( nItemIndex )
   HB_SYMBOL_UNUSED( aItem )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:checkItem( nItemIndex, lCheck )
   LOCAL lChecked

   DEFAULT lCheck TO .T.

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      ::aMenuItems[ nItemIndex, 5 ]:setChecked( lCheck )
      lChecked := ::aMenuItems[ nItemIndex, 5 ]:isChecked()
   ENDIF

   RETURN iif( lCheck, lChecked, !lChecked )

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:enableItem( nItemIndex )
   LOCAL lSuccess := .f.

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      ::aMenuItems[ nItemIndex, 5 ]:setEnabled( .t. )
      lSuccess := ::aMenuItems[ nItemIndex, 5 ]:isEnabled()
   ENDIF

   RETURN lSuccess

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:disableItem( nItemIndex )
   LOCAL lSuccess := .f.

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      ::aMenuItems[ nItemIndex, 5 ]:setDisabled( .t. )
      lSuccess := !( ::aMenuItems[ nItemIndex, 5 ]:isEnabled() )
   ENDIF

   RETURN lSuccess

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:getItem( nItemIndex )
   LOCAL aItem

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      aItem := ::aOrgItems[ nItemIndex ]
   ENDIF

   RETURN aItem

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:isItemChecked( nItemIndex )
   LOCAL lChecked := .f.

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      lChecked := ::aMenuItems[ nItemIndex, 5 ]:isChecked()
   ENDIF

   RETURN lChecked

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:isItemEnabled( nItemIndex )
   LOCAL lEnabled := .t.

   IF !empty( ::aMenuItems ) .AND. !empty( nItemIndex ) .AND. nItemIndex <= ::numItems
      lEnabled := ::aMenuItems[ nItemIndex, 5 ]:isEnabled()
   ENDIF

   RETURN lEnabled

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:selectItem( nItemIndex )

   HB_SYMBOL_UNUSED( nItemIndex )

   RETURN Self

/*----------------------------------------------------------------------*/
/*                         Callback Methods                             */
/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:execSlot( cSlot, p )
   LOCAL nIndex

   IF ! empty( p ) .AND. ( nIndex := ascan( ::aMenuItems, {|e_| iif( HB_ISNUMERIC( e_[ 2 ] ), e_[ 2 ] == p, .f. ) } ) ) > 0
      IF cSlot == "triggered(bool)"
         IF HB_ISBLOCK( ::aMenuItems[ nIndex,4 ] )
            eval( ::aMenuItems[ nIndex,4 ], nIndex, NIL, Self )
         ELSE
            ::itemSelected( nIndex )
         ENDIF

      ELSEIF cSlot == "hovered()"
         IF !empty( p )
            ::itemMarked( nIndex )
         ENDIF
      ENDIF
   ENDIF

   RETURN nil

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:beginMenu( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_beginMenu := a_[ 1 ]
   ELSEIF len( a_ ) >= 0 .AND. HB_ISBLOCK( ::sl_beginMenu )
      eval( ::sl_beginMenu, NIL, NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:endMenu( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_endMenu := a_[ 1 ]
   ELSEIF len( a_ ) >= 0 .AND. HB_ISBLOCK( ::sl_endMenu )
      eval( ::sl_endMenu, NIL, NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:itemMarked( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemMarked := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_itemMarked )
      eval( ::sl_itemMarked, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:itemSelected( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemSelected := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_itemSelected )
      eval( ::sl_itemSelected, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:drawItem( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_drawItem := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_drawItem )
      eval( ::sl_drawItem, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:measureItem( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_measureItem := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_measureItem )
      eval( ::sl_measureItem, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenuBar:onMenuKey( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_onMenuKey := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_onMenuKey )
      eval( ::sl_onMenuKey, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
/*
 *                            HbQtMenu Class
 */
/*----------------------------------------------------------------------*/

CLASS HbQtMenu INHERIT HbQtMenuBar

   DATA     oParent
   DATA     oWidget

   DATA     title                                 INIT  ""
   DATA     className                             INIT  "HBQTMENU"
   DATA     oAction

   METHOD   init( oParent )
   METHOD   create( oParent )
   METHOD   getTitle()
   METHOD   setTitle( cTitle )
   METHOD   popUp( xPos )
   METHOD   show()                                 INLINE iif( HB_ISOBJECT( ::oAction ), ::oAction:setVisible( .t. ), NIL )
   METHOD   hide()                                 INLINE iif( HB_ISOBJECT( ::oAction ), ::oAction:setVisible( .f. ), NIL )

PROTECTED:
   METHOD   normalize( cCaption )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:init( oParent )

   ::oParent := oParent

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:create( oParent )

   DEFAULT oParent TO ::oParent

   ::oParent := oParent

   ::oWidget := QMenu( ::oParent )
   ::oWidget:setTitle( ::normalize( ::title ) )

   IF HB_ISOBJECT( ::oParent )
      ::oAction := ::oParent:addMenu( ::oWidget )
      ::oAction:setVisible( .T. )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:getTitle()

   RETURN ::title

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:setTitle( cTitle )
   LOCAL oldTitle := ::title

   ::title := cTitle
   ::oWidget:setTitle( ::normalize( ::title ) )

   RETURN oldTitle

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:popUp( xPos )

   IF HB_ISARRAY( xPos )
      ::oWidget:exec( QPoint( xPos[ 1 ], xPos[ 2 ] ) )
   ELSEIF HB_ISOBJECT( xPos )
      ::oWidget:exec( xPos )
   ENDIF

   RETURN .f.

/*----------------------------------------------------------------------*/

METHOD HbQtMenu:normalize( cCaption )

   RETURN strtran( cCaption, '~', '&' )

/*----------------------------------------------------------------------*/

