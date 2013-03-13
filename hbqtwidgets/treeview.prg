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
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                          HbQtTreeView Class
 *
 *                             Pritpal Bedi
 *                               04Mar2013
 */
/*----------------------------------------------------------------------*/

#include "hbqtgui.ch"
#include "hbclass.ch"
#include "common.ch"

/*----------------------------------------------------------------------*/

CLASS HbQtTreeView

   DATA     oParent
   DATA     oWidget
   DATA     alwaysShowSelection                   INIT .F.
   DATA     hasButtons                            INIT .F.
   DATA     hasLines                              INIT .F.
   DATA     aItems                                INIT {}

   DATA     oRootItem
   ACCESS   rootItem()                            INLINE ::oRootItem

   METHOD   init( oParent )
   METHOD   create( oParent )
   METHOD   execSlot( cSlot, p )

   METHOD   itemFromPos( aPos )
   METHOD   connect()

   DATA     oItemSelected

   METHOD   itemCollapsed( ... )                  SETGET
   METHOD   itemExpanded( ... )                   SETGET
   METHOD   itemMarked( ... )                     SETGET
   METHOD   itemSelected( ... )                   SETGET
   METHOD   contextMenu( ... )                    SETGET

   DATA     hParentSelected
   DATA     hItemSelected
   DATA     textParentSelected                    INIT   ""
   DATA     textItemSelected                      INIT   ""

PROTECTED:

   DATA     sl_itemCollapsed
   DATA     sl_itemExpanded
   DATA     sl_itemMarked
   DATA     sl_itemSelected
   DATA     sl_contextMenu


   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:init( oParent )

   ::oParent := oParent

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   WITH OBJECT ::oWidget := QTreeWidget( ::oParent )
      :setMouseTracking( .t. )
      :setColumnCount( 1 )
      :setHeaderHidden( .t. )
      :setContextMenuPolicy( Qt_CustomContextMenu )
   ENDWITH

   ::oRootItem          := HbQtTreeViewItem():New()
   ::oRootItem:hTree    := ::oWidget
   ::oRootItem:oXbpTree := self

   ::oRootItem:oWidget  := ::oWidget:invisibleRootItem()

   ::connect()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:execSlot( cSlot, p )
   LOCAL n, qPt, qItem, oItem

   IF ( n := ascan( ::aItems, {|o| iif( empty( o ), .f., hbqt_IsEqual( o:oWidget, p ) ) } ) ) > 0
      oItem := ::aItems[ n ]
   ENDIF

   DO CASE
   CASE cSlot == "itemCollapsed(QTreeWidgetItem*)"
      ::itemCollapsed( oItem, {0,0,0,0} )
   CASE cSlot == "itemExpanded(QTreeWidgetItem*)"
      ::itemExpanded( oItem, {0,0,0,0} )
   CASE cSlot == "itemClicked(QTreeWidgetItem*,int)"
      ::itemMarked( oItem, {0,0,0,0} )
   CASE cSlot == "itemDoubleClicked(QTreeWidgetItem*,int)"
      ::itemSelected( oItem, {0,0,0,0} )
   CASE cSlot == "itemEntered(QTreeWidgetItem*,int)"
      ::oWidget:setToolTip( iif( empty( oItem:tooltipText ), oItem:caption, oItem:tooltipText ) )
   CASE cSlot == "customContextMenuRequested(QPoint)"
      IF HB_ISBLOCK( ::sl_contextMenu )
         IF ! empty( qItem := ::oWidget:itemAt( p ) )
            IF ( n := ascan( ::aItems, {|o| hbqt_IsEqual( o:oWidget, qItem ) } ) ) > 0
               qPt := ::oWidget:mapToGlobal( p )
               Eval( ::sl_contextMenu, { qPt:x(), qPt:y() }, NIL, ::aItems[ n ] )
            ENDIF
         ENDIF
      ENDIF
   #if 0
   CASE cSlot == "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)"
   CASE cSlot == "itemPressed(QTreeWidgetItem*,int)"
   CASE cSlot == "itemActivated(QTreeWidgetItem*,int)"
   CASE cSlot == "itemChanged(QTreeWidgetItem*,int)"
   CASE cSlot == "itemSelectionChanged()"
   #endif
   ENDCASE

   RETURN .f.

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:connect()

   ::oWidget:connect( "itemCollapsed(QTreeWidgetItem*)"                , {|p1  | ::execSlot( "itemCollapsed(QTreeWidgetItem*)"         , p1    ) } )
   ::oWidget:connect( "itemExpanded(QTreeWidgetItem*)"                 , {|p1  | ::execSlot( "itemExpanded(QTreeWidgetItem*)"          , p1    ) } )
*  ::oWidget:connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|p,p1| ::execSlot( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", p, p1 ) } )
*  ::oWidget:connect( "itemActivated(QTreeWidgetItem*,int)"            , {|p,p1| ::execSlot( "itemActivated(QTreeWidgetItem*,int)"     , p, p1 ) } )
*  ::oWidget:connect( "itemChanged(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemChanged(QTreeWidgetItem*,int)"       , p, p1 ) } )
   ::oWidget:connect( "itemClicked(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemClicked(QTreeWidgetItem*,int)"       , p, p1 ) } )
   ::oWidget:connect( "itemDoubleClicked(QTreeWidgetItem*,int)"        , {|p,p1| ::execSlot( "itemDoubleClicked(QTreeWidgetItem*,int)" , p, p1 ) } )
   ::oWidget:connect( "itemEntered(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemEntered(QTreeWidgetItem*,int)"       , p, p1 ) } )
*  ::oWidget:connect( "itemPressed(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemPressed(QTreeWidgetItem*,int)"       , p, p1 ) } )
*  ::oWidget:connect( "itemSelectionChanged()"                         , {|p1  | ::execSlot( "itemSelectionChanged()"                  , p1    ) } )
   ::oWidget:connect( "customContextMenuRequested(QPoint)"             , {|p1  | ::execSlot( "customContextMenuRequested(QPoint)"      , p1    ) } )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:itemFromPos( aPos )

   HB_SYMBOL_UNUSED( aPos )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:itemCollapsed( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemCollapsed := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemCollapsed )
      eval( ::sl_itemCollapsed, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:itemExpanded( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemExpanded := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemExpanded )
      eval( ::sl_itemExpanded, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:itemMarked( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemMarked := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemMarked )
      eval( ::sl_itemMarked, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:itemSelected( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemSelected := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemSelected )
      eval( ::sl_itemSelected, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeView:contextMenu( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_contextMenu := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_contextMenu )
      eval( ::sl_contextMenu, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
/*                      Class HbQtTreeViewItem                           */
/*----------------------------------------------------------------------*/

CLASS HbQtTreeViewItem

   DATA     oWidget

   DATA     caption                               INIT ""
   DATA     dllName                               INIT NIL
   DATA     expandedImage                         INIT -1
   DATA     image                                 INIT -1
   DATA     markedImage                           INIT -1

   DATA     xValue                                             // To be returned by get/set methods

   DATA     hTree
   DATA     hItem
   DATA     oParent
   DATA     oXbpTree

   DATA     aChilds                               INIT {}
   DATA     tooltipText                           INIT ""

   METHOD   init()
   METHOD   create()

   METHOD   expand( lExpand )                     INLINE   ::oWidget:setExpanded( lExpand )
   METHOD   isExpanded()                          INLINE   ::oWidget:isExpanded()

   METHOD   setCaption( cCaption )                INLINE   ::caption := cCaption, ::oWidget:setText( 0, cCaption )
   METHOD   setImage( xIcon )
   METHOD   setExpandedImage( nResIdoBitmap )
   METHOD   setMarkedImage( nResIdoBitmap )

   METHOD   addItem( xItem, xNormalImage, xMarkedImage, xExpandedImage, cDllName, xValue )
   METHOD   delItem( oItem )
   METHOD   getChildItems()
   METHOD   getParentItem()
   METHOD   insItem()

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:addItem( xItem, xNormalImage, xMarkedImage, xExpandedImage, cDllName, xValue )
   Local oItem

   HB_SYMBOL_UNUSED( cDllName )

   IF valtype( xItem ) == 'C'
      oItem := HbQtTreeViewItem():New()
      oItem:caption := xItem
      oItem:oWidget := QTreeWidgetItem()
      oItem:oWidget:setText( 0, oItem:caption )
   ELSE
      oItem := xItem   // aNode
   ENDIF

   oItem:oParent := self
   oItem:oXbpTree := oItem:oParent:oXbpTree

   IF xNormalImage != NIL
      oItem:image := xNormalImage
   ENDIF
   IF xMarkedImage != NIL
      oItem:markedImage := xMarkedImage
   ENDIF
   IF xExpandedImage != NIL
      oItem:expandedImage := xExpandedImage
   ENDIF
   IF xValue != NIL
      oItem:xValue := xValue
   ENDIF

   ::oWidget:addChild( oItem:oWidget )

   aadd( ::aChilds, oItem )
   aadd( oItem:aChilds, oItem )
   aadd( oItem:oXbpTree:aItems, oItem )

   RETURN oItem

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:init()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:create()

   ::oWidget := QTreeWidgetItem()
   ::oWidget:setText( 0,::caption )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:setExpandedImage( nResIdoBitmap )

   HB_SYMBOL_UNUSED( nResIdoBitmap )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:setImage( xIcon )

   ::oWidget:setIcon( 0, iif( HB_ISSTRING( xIcon ), QIcon( xIcon ), xIcon ) )

   RETURN self

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:setMarkedImage( nResIdoBitmap )

   HB_SYMBOL_UNUSED( nResIdoBitmap )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:delItem( oItem )
   LOCAL n

   IF ( n := ascan( ::aChilds, {|o| o == oItem } ) ) > 0
      ::oWidget:removeChild( ::aChilds[ n ]:oWidget )
      ::aChilds[ n ]:oWidget := NIL
      adel( ::aChilds, n )
      asize( ::aChilds, len( ::aChilds )-1 )
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:getChildItems()

   RETURN ::aChilds

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:getParentItem()

   RETURN ::oParent

/*----------------------------------------------------------------------*/

METHOD HbQtTreeViewItem:insItem()

   RETURN NIL

/*----------------------------------------------------------------------*/
