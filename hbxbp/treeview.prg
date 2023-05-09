/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file for the Xbp*Classes
 *
 * Copyright 2009-2023 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                  Xbase++ xbpTreeView compatible Class
 *
 *                             Pritpal Bedi
 *                               20Jun2009
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"

#include "xbp.ch"
#include "appevent.ch"


CLASS XbpTreeView  INHERIT  XbpWindow, DataRef

   DATA     alwaysShowSelection                   INIT .F.
   DATA     hasButtons                            INIT .F.
   DATA     hasLines                              INIT .F.
   DATA     aItems                                INIT {}

   DATA     oRootItem
   ACCESS   rootItem()                            INLINE ::oRootItem

   METHOD   init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   destroy()
   METHOD   handleEvent( nEvent, mp1, mp2 )
   METHOD   execSlot( cSlot, p )
   METHOD   setStyle()

   METHOD   itemFromPos( aPos )
   METHOD   connect()
   METHOD   disconnect()

   DATA     sl_itemCollapsed
   DATA     sl_itemExpanded
   DATA     sl_itemMarked
   DATA     sl_itemSelected

   DATA     oItemSelected

   METHOD   itemCollapsed( ... )                  SETGET
   METHOD   itemExpanded( ... )                   SETGET
   METHOD   itemMarked( ... )                     SETGET
   METHOD   itemSelected( ... )                   SETGET

   DATA     hParentSelected
   DATA     hItemSelected
   DATA     textParentSelected                    INIT   ""
   DATA     textItemSelected                      INIT   ""

#if 0
   METHOD   setColorFG( nRGB )                    INLINE WVG_TreeView_SetTextColor( ::hWnd, nRGB )
   METHOD   setColorBG( nRGB )                    INLINE WVG_TreeView_SetBkColor( ::hWnd, nRGB )
   METHOD   setColorLines( nRGB )                 INLINE WVG_TreeView_SetLineColor( ::hWnd, nRGB )
   METHOD   showExpanded( lExpanded, nLevels )    INLINE Wvg_TreeView_ShowExpanded( ::hWnd, ;
                                                         iif( HB_ISNIL( lExpanded ), .f., lExpanded ), nLevels )
#endif
   ENDCLASS


METHOD XbpTreeView:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   ::xbpWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   RETURN Self


METHOD XbpTreeView:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::xbpWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   WITH OBJECT ::oWidget := QTreeWidget( ::pParent )
      :setMouseTracking( .t. )
      :setColumnCount( 1 )
      :setHeaderHidden( .t. )
      :setContextMenuPolicy( Qt_CustomContextMenu )
   ENDWITH 
#if 0
   IF ::alwaysShowSelection
      ::style += TVS_SHOWSELALWAYS
   ENDIF
   IF ::hasButtons
      ::style += TVS_HASBUTTONS
   ENDIF
   IF ::hasLines
      ::style += TVS_HASLINES + TVS_LINESATROOT
   ENDIF
#endif

   ::oRootItem          := XbpTreeViewItem():New()
   ::oRootItem:hTree    := ::oWidget
   ::oRootItem:oXbpTree := self

   ::oRootItem:oWidget  := ::oWidget:invisibleRootItem()

   ::connect()
   ::setPosAndSize()
   IF ::visible
      ::show()
   ENDIF
   ::oParent:AddChild( Self )
   ::postCreate()

   RETURN Self


METHOD XbpTreeView:execSlot( cSlot, p )
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
      IF HB_ISBLOCK( ::hb_contextMenu )
         IF ! empty( qItem := ::oWidget:itemAt( p ) )
            IF ( n := ascan( ::aItems, {|o| hbqt_IsEqual( o:oWidget, qItem ) } ) ) > 0
               qPt := ::oWidget:mapToGlobal( p )
               eval( ::hb_contextMenu, { qPt:x(), qPt:y() }, NIL, ::aItems[ n ] )
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


METHOD XbpTreeView:handleEvent( nEvent, mp1, mp2 )
   HB_SYMBOL_UNUSED( nEvent )
   HB_SYMBOL_UNUSED( mp1    )
   HB_SYMBOL_UNUSED( mp2    )
   RETURN HBXBP_EVENT_UNHANDLED


METHOD XbpTreeView:destroy()
   LOCAL i

   ::disconnect()

   FOR i := len( ::aItems ) TO 1 step -1
      ::aItems[ i ]:destroy()
   NEXT
   ::aItems := NIL

   ::sl_itemCollapsed        := NIL
   ::sl_itemExpanded         := NIL
   ::sl_itemMarked           := NIL
   ::oItemSelected           := NIL
   ::sl_itemSelected         := NIL
   ::hParentSelected         := NIL
   ::hItemSelected           := NIL
   ::textParentSelected      := NIL
   ::textItemSelected        := NIL

   ::xbpWindow:destroy()
   RETURN NIL


METHOD XbpTreeView:connect()
   WITH OBJECT ::oWidget
#if 0
      :connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|p,p1| ::execSlot( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", p, p1 ) } )
      :connect( "itemActivated(QTreeWidgetItem*,int)"            , {|p,p1| ::execSlot( "itemActivated(QTreeWidgetItem*,int)"     , p, p1 ) } )
      :connect( "itemChanged(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemChanged(QTreeWidgetItem*,int)"       , p, p1 ) } )
      :connect( "itemPressed(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemPressed(QTreeWidgetItem*,int)"       , p, p1 ) } )
      :connect( "itemSelectionChanged()"                         , {|p1  | ::execSlot( "itemSelectionChanged()"                  , p1    ) } )
#endif      
      :connect( "itemCollapsed(QTreeWidgetItem*)"                , {|p1  | ::execSlot( "itemCollapsed(QTreeWidgetItem*)"         , p1    ) } )
      :connect( "itemExpanded(QTreeWidgetItem*)"                 , {|p1  | ::execSlot( "itemExpanded(QTreeWidgetItem*)"          , p1    ) } )
      :connect( "itemClicked(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemClicked(QTreeWidgetItem*,int)"       , p, p1 ) } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)"        , {|p,p1| ::execSlot( "itemDoubleClicked(QTreeWidgetItem*,int)" , p, p1 ) } )
      :connect( "itemEntered(QTreeWidgetItem*,int)"              , {|p,p1| ::execSlot( "itemEntered(QTreeWidgetItem*,int)"       , p, p1 ) } )
      :connect( "customContextMenuRequested(QPoint)"             , {|p1  | ::execSlot( "customContextMenuRequested(QPoint)"      , p1    ) } )
   ENDWITH
   RETURN Self


METHOD XbpTreeView:disconnect()
   WITH OBJECT ::oWidget
#if 0
      :disconnect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)"   )
      :disconnect( "itemActivated(QTreeWidgetItem*,int)"            )
      :disconnect( "itemChanged(QTreeWidgetItem*,int)"              )
      :disconnect( "itemPressed(QTreeWidgetItem*,int)"              )
      :disconnect( "itemSelectionChanged()"                         )
#endif 
      :disconnect( "itemCollapsed(QTreeWidgetItem*)"                )
      :disconnect( "itemExpanded(QTreeWidgetItem*)"                 )
      :disconnect( "itemClicked(QTreeWidgetItem*,int)"              )
      :disconnect( "itemDoubleClicked(QTreeWidgetItem*,int)"        )
      :disconnect( "itemEntered(QTreeWidgetItem*,int)"              )
      :disconnect( "customContextMenuRequested(QPoint)"             )
   ENDWITH 
   RETURN Self


METHOD XbpTreeView:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   ::Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   RETURN Self


METHOD XbpTreeView:itemFromPos( aPos )
   HB_SYMBOL_UNUSED( aPos )
   RETURN Self


METHOD XbpTreeView:itemCollapsed( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemCollapsed := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemCollapsed )
      eval( ::sl_itemCollapsed, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self


METHOD XbpTreeView:itemExpanded( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemExpanded := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemExpanded )
      eval( ::sl_itemExpanded, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self


METHOD XbpTreeView:itemMarked( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemMarked := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemMarked )
      eval( ::sl_itemMarked, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self


METHOD XbpTreeView:itemSelected( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_itemSelected := a_[ 1 ]
   ELSEIF len( a_ ) >= 2 .AND. HB_ISBLOCK( ::sl_itemSelected )
      eval( ::sl_itemSelected, a_[ 1 ], a_[ 2 ], Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
//                      Class XbpTreeViewItem                           
/*----------------------------------------------------------------------*/

CLASS XbpTreeViewItem  INHERIT  DataRef

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
   METHOD   configure()
   METHOD   destroy()

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


METHOD XbpTreeViewItem:addItem( xItem, xNormalImage, xMarkedImage, xExpandedImage, cDllName, xValue )
   LOCAL oItem

   HB_SYMBOL_UNUSED( cDllName )

   IF valtype( xItem ) == 'C'
      oItem := XbpTreeViewItem():New()
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
   //
   RETURN oItem


METHOD XbpTreeViewItem:init()
   RETURN Self


METHOD XbpTreeViewItem:create()
   WITH OBJECT ::oWidget := QTreeWidgetItem()
      :setText( 0,::caption )
   ENDWITH 
   RETURN Self


METHOD XbpTreeViewItem:configure()
   RETURN Self


METHOD XbpTreeViewItem:destroy()
   LOCAL i
   FOR i := 1 TO len( ::aChilds )
      ::aChilds[ i ]:oWidget := NIL
   NEXT
   ::oWidget := NIL
   RETURN NIL


METHOD XbpTreeViewItem:setExpandedImage( nResIdoBitmap )
   HB_SYMBOL_UNUSED( nResIdoBitmap )
   RETURN NIL


METHOD XbpTreeViewItem:setImage( xIcon )
   ::oWidget:setIcon( 0, iif( HB_ISSTRING( xIcon ), QIcon( xIcon ), xIcon ) )
   RETURN self


METHOD XbpTreeViewItem:setMarkedImage( nResIdoBitmap )
   HB_SYMBOL_UNUSED( nResIdoBitmap )
   RETURN NIL


METHOD XbpTreeViewItem:delItem( oItem )
   LOCAL n
   IF ( n := ascan( ::aChilds, {|o| o == oItem } ) ) > 0
      ::oWidget:removeChild( ::aChilds[ n ]:oWidget )
      ::aChilds[ n ]:oWidget := NIL
      adel( ::aChilds, n )
      asize( ::aChilds, len( ::aChilds )-1 )
   ENDIF
   RETURN NIL


METHOD XbpTreeViewItem:getChildItems()
   RETURN ::aChilds


METHOD XbpTreeViewItem:getParentItem()
   RETURN ::oParent


METHOD XbpTreeViewItem:insItem()
   RETURN NIL

/* Another approach - in the making
 */
METHOD XbpTreeView:setStyle()
#if 0
   LOCAL oS

   oS := XbpStyle():new()
   oS:xbpPart  := "XbpTreeView"
   oS:qtWidget := "QTreeWidget"
   oS:colorFG  := "white"
   oS:colorBG  := "blue"
   oS:create()
   ::oWidget:setStyleSheet( oS:style )
#else
   LOCAL s := "", txt_:={}

   AAdd( txt_, 'QTreeView {                                                                                      ' )
   AAdd( txt_, '     alternate-background-color: yellow;                                                         ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView {                                                                                     ' )
   AAdd( txt_, '     show-decoration-selected: 1;                                                                ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::item {                                                                               ' )
   AAdd( txt_, '      border: 1px solid #d9d9d9;                                                                 ' )
   AAdd( txt_, '     border-top-color: transparent;                                                              ' )
   AAdd( txt_, '     border-bottom-color: transparent;                                                           ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::item:hover {                                                                         ' )
   AAdd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #e7effd, stop: 1 #cbdaf1);  ' )
   AAdd( txt_, '     border: 1px solid #bfcde4;                                                                  ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::item:selected {                                                                      ' )
   AAdd( txt_, '     border: 1px solid #567dbc;                                                                  ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::item:selected:active{                                                                ' )
   AAdd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #6ea1f1, stop: 1 #567dbc);  ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::item:selected:!active {                                                              ' )
   AAdd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #6b9be8, stop: 1 #577fbf);  ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch {                                                                             ' )
   AAdd( txt_, '         background: palette(base);                                                              ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:has-siblings:!adjoins-item {                                                  ' )
   AAdd( txt_, '         background: cyan;                                                                       ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:has-siblings:adjoins-item {                                                   ' )
   AAdd( txt_, '         background: red;                                                                        ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:!has-children:!has-siblings:adjoins-item {                                    ' )
   AAdd( txt_, '         background: blue;                                                                       ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:closed:has-children:has-siblings {                                            ' )
   AAdd( txt_, '         background: pink;                                                                       ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:has-children:!has-siblings:closed {                                           ' )
   AAdd( txt_, '         background: gray;                                                                       ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:open:has-children:has-siblings {                                              ' )
   AAdd( txt_, '         background: magenta;                                                                    ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:open:has-children:!has-siblings {                                             ' )
   AAdd( txt_, '         background: green;                                                                      ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, 'vline.png   branch-more.png   branch-end.png   branch-closed.png   branch-open.png               ' )
   AAdd( txt_, ' QTreeView::branch:has-siblings:!adjoins-item {                                                  ' )
   AAdd( txt_, '     border-image: url(vline.png) 0;                                                             ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:has-siblings:adjoins-item {                                                   ' )
   AAdd( txt_, '     border-image: url(branch-more.png) 0;                                                       ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:!has-children:!has-siblings:adjoins-item {                                    ' )
   AAdd( txt_, '     border-image: url(branch-end.png) 0;                                                        ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:has-children:!has-siblings:closed,                                            ' )
   AAdd( txt_, ' QTreeView::branch:closed:has-children:has-siblings {                                            ' )
   AAdd( txt_, '         border-image: none;                                                                     ' )
   AAdd( txt_, '         image: url(branch-closed.png);                                                          ' )
   AAdd( txt_, ' }                                                                                               ' )
   AAdd( txt_, ' QTreeView::branch:open:has-children:!has-siblings,                                              ' )
   AAdd( txt_, ' QTreeView::branch:open:has-children:has-siblings  {                                             ' )
   AAdd( txt_, '         border-image: none;                                                                     ' )
   AAdd( txt_, '         image: url(branch-open.png);                                                            ' )
   AAdd( txt_, ' } '                                                                                               )

   aeval( txt_, {|e| s += e + chr( 13 )+chr( 10 ) } )

   ::oWidget:setStyleSheet( s )
#endif
   RETURN nil

