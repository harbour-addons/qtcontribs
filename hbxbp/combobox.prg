/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file FOR the Xbp*Classes
 *
 * Copyright 2009-2023 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR (at your option)
 * any later version.
 *
 * This program is distributed IN the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General PUBLIC License FOR more details.
 *
 * You should have received a copy of the GNU General PUBLIC License
 * along WITH this software; see the file COPYING.  IF NOT, write TO
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (OR visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission FOR
 * additional uses of the text contained IN its release of Harbour.
 *
 * The exception is that, IF you link the Harbour libraries WITH other
 * files TO produce an executable, this does NOT by itself cause the
 * resulting executable TO be covered by the GNU General PUBLIC License.
 * Your use of that executable is IN no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does NOT however invalidate any other reasons why
 * the executable file might be covered by the GNU General PUBLIC License.
 *
 * This exception applies only TO the code released by the Harbour
 * Project under the name Harbour.  IF you copy code FROM other
 * Harbour Project OR Free Software Foundation releases into a copy of
 * Harbour, as the General PUBLIC License permits, the exception does
 * NOT apply TO the code that you add IN this way.  TO avoid misleading
 * anyone as TO the status of such modified files, you must delete
 * this exception notice FROM them.
 *
 * IF you write modifications of your own FOR Harbour, it is your choice
 * whether TO permit this exception TO apply TO your modifications.
 * IF you DO NOT wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                  Xbase++ xbpComboBox compatible CLASS
 *
 *                             Pritpal Bedi
 *                               20Jun2009
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"

#include "xbp.ch"
#include "appevent.ch"


CLASS XbpComboBox  INHERIT  XbpWindow

   DATA     type                                  INIT    XBPCOMBO_DROPDOWN
   DATA     drawMode                              INIT    XBP_DRAW_NORMAL

   METHOD   init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) VIRTUAL
   METHOD   destroy()
   METHOD   handleEvent( nEvent, mp1, mp2 )       VIRTUAL
   METHOD   execSlot( cSlot, p )
   METHOD   connect()
   METHOD   disconnect()

   METHOD   listBoxFocus( lFocus )                VIRTUAL      // -> lOldFocus
   METHOD   sleSize()                             VIRTUAL      // -> aOldSize

   METHOD   addItem( cItem )                      INLINE  ::oWidget:addItem( cItem )
   METHOD   setIcon( nItem,cIcon )                INLINE  ::oWidget:setItemIcon( nItem-1, QIcon( cIcon ) )

#IF 0
   METHOD   clear()                               INLINE  ::oStrList:clear(),;
                                                          ::oStrModel:setStringList( ::oStrList )
   METHOD   delItem( nIndex )                     INLINE  ::oStrList:removeAt( nIndex-1 ),;
                                                          ::oStrModel:setStringList( ::oStrList )
   METHOD   getItem( nIndex )                     INLINE  ::oStrList:at( nIndex-1 )
   METHOD   insItem( nIndex, cItem )              INLINE  ::oStrList:insert( nIndex-1, cItem ),;
                                                          ::oStrModel:setStringList( ::oStrList )
   METHOD   setItem( nIndex, cItem )              INLINE  ::oStrModel:REPLACE( nIndex-1, cItem ),;
                                                          ::oStrModel:setStringList( ::oStrList )
#ENDIF

   DATA     oSLE
   DATA     oLB
   ACCESS   XbpSLE                                INLINE  ::oSLE
   ACCESS   XbpListBox                            INLINE  ::oLB

   DATA     sl_itemMarked
   DATA     sl_itemSelected
   DATA     sl_drawItem

   METHOD   itemMarked( ... )                     SETGET
   METHOD   itemSelected( ... )                   SETGET
   METHOD   drawItem( ... )                       SETGET

   ENDCLASS


METHOD XbpComboBox:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   ::xbpWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   RETURN SELF


METHOD XbpComboBox:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::xbpWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::oSLE := XbpSLE():new():create( ::oParent, ::oOwner, ::aPos, ::aSize, ::aPresParams, ::visible )
   ::oLB  := XbpListBox():new():create( ::oParent, ::oOwner, ::aPos, ::aSize, ::aPresParams, ::visible )

   ::oWidget := QComboBox( ::pParent )

   ::oWidget:setModel( ::xbpListBox:model() )
   ::oWidget:setView( ::xbpListBox:oWidget )
   ::oWidget:setLineEdit( ::xbpSLE:oWidget )
   ::oWidget:setEditable( ::xbpSLE:editable )
   ::oWidget:setFrame( ::xbpSLE:border )

   ::connect()
   ::setPosAndSize()
   IF ::visible
      ::show()
   ENDIF
   ::oParent:AddChild( SELF )
   ::postCreate()
   RETURN SELF


METHOD XbpComboBox:connect()
   ::oWidget:connect( "highlighted(int)"        , {|i| ::execSlot( "highlighted(int)"        , i ) } )
   ::oWidget:connect( "activated(int)"          , {|i| ::execSlot( "activated(int)"          , i ) } )
   // ::oWidget:connect( "currentIndexChanged(int)", {|i| ::execSlot( "currentIndexChanged(int)", i ) } )
   RETURN SELF


METHOD XbpComboBox:disconnect()
   ::oWidget:disconnect( "highlighted(int)"         )
   ::oWidget:disconnect( "activated(int)"           )
   // ::oWidget:disconnect( "currentIndexChanged(int)" )
   RETURN SELF


METHOD XbpComboBox:destroy()
   ::disconnect()
   ::xbpWindow:destroy()
   RETURN NIL


METHOD XbpComboBox:execSlot( cSlot, p )
   HB_SYMBOL_UNUSED( p )

   DO CASE
   CASE cSlot == "highlighted(int)"
      ::itemMarked()
   CASE cSlot == "activated(int)"
      ::itemSelected()
   CASE cSlot == "currentIndexChanged(int)"
   ENDCASE
   RETURN .T. 


METHOD XbpComboBox:itemMarked( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemMarked := a_[ 1 ]
   ELSEIF len( a_ ) >= 0 .AND. HB_ISBLOCK( ::sl_itemMarked )
      eval( ::sl_itemMarked, NIL, NIL, SELF )
   ENDIF
   RETURN SELF


METHOD XbpComboBox:itemSelected( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemSelected := a_[ 1 ]
   ELSEIF len( a_ ) >= 0 .AND. HB_ISBLOCK( ::sl_itemSelected )
      eval( ::sl_itemSelected, NIL, NIL, SELF )
   ENDIF
   RETURN SELF


METHOD XbpComboBox:drawItem( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_xbePDrawItem := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_xbePDrawItem )
      eval( ::sl_xbePDrawItem, a_[ 1 ], a_[ 2 ], SELF )
   ENDIF
   RETURN SELF

