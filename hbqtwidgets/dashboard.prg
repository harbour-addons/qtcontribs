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
 *                          HbQtDashBoard Class
 *
 *                             Pritpal Bedi
 *                               04May2013
 */
/*----------------------------------------------------------------------*/


#include "hbqtgui.ch"
#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbgtinfo.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbtrace.ch"


#define HBQTTOOLBAR_BUTTON_DEFAULT                0
#define HBQTTOOLBAR_BUTTON_SEPARATOR              1

#define __toolbarButton_clicked__                 1001
#define __qPanelsButton_clicked__                 2041
#define __mdiArea_subWindowActivated__            2044
#define __dbu_treeDoubleClicked__                 2045

#define __obj_QLCD__                              1
#define __obj_QChart__                            2
#define __obj_Browser__                           3

#define SUB_TYPE                                  1
#define SUB_ID                                    2
#define SUB_WINDOW                                3
#define SUB_DATA                                  4
#define SUB_GEOMETRY                              5
#define SUB_NIL                                   6
#define SUB_NIL2                                  7

#define OBJ_TYPE                                  1
#define OBJ_TITLE                                 2
#define OBJ_DURATION                              3
#define OBJ_BLOCK                                 4
#define OBJ_ATTRBS                                5
#define OBJ_CATTRBS                               6
#define OBJ_POSANDSIZE                            7

#define STATUS_PANEL                              1
#define STATUS_NOOFPANELS                         2
#define STATUS_NOOFWINDOWS                        3
#define STATUS_ACTIVEWINDOW                       5

STATIC hMutex
STATIC hData   := {=>}


INIT PROCEDURE __dashboardCreatMutex()
   hMutex := hb_mutexCreate()
   RETURN


CLASS HbQtDashboard

   DATA   oParent

   DATA   oWidget
   ACCESS widget                                  INLINE ::oWidget

   DATA   oSplitter
   DATA   oTree
   DATA   oTabBar

   DATA   oToolbar
   DATA   oToolbarT
   DATA   oStatusBar
   DATA   oStackedWidget
   DATA   oGLayout
   DATA   oTimer

   DATA   oActivePanel

   DATA   hSubWnds                                INIT {=>}
   DATA   hMDIs                                   INIT {=>}

   DATA   oPanelsMenu, oPanelsButton

   DATA   oActiveMDI
   DATA   sp0,sp1,sp2,sp3
   DATA   aStatusPnls                             INIT {}

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD execEvent( nEvent, p, p1 )
   METHOD buildToolbars()
   METHOD buildToolbarLeft()
   METHOD buildStatusPanels()
   METHOD dispStatus()
   METHOD dispStatusMessage( nPanel, cMsg )
   METHOD enableStatusBar( lEnable )              INLINE iif( HB_ISLOGICAL( lEnable ), iif( lEnable, ::oStatusBar:show(), ::oStatusBar:hide() ), NIL )

   METHOD addPanel( cName )
   METHOD removePanel( cPanel )
   METHOD buildPanelsButton()
   METHOD managePanels()
   METHOD addPanels( aPanels )
   METHOD isPanelLocked( cPanel )
   METHOD setPanelLocked( cPanel, lLocked )
   METHOD clearPanel( cPanel )

   METHOD addObject( cType )
   METHOD createObject( cName, cAttrbs )
   METHOD manageTreeObject( oItem )
   METHOD setActiveTab( cName )
   METHOD manageTabContext( oPos )

   METHOD saveState()
   METHOD restState( hState )
   METHOD savePanelsInfo()
   METHOD restPanelsInfo( hInfo )

   /* Tables Tree Management */

   ACCESS populateTreeBlock                       METHOD getPopulateTreeBlock
   ASSIGN populateTreeBlock                       METHOD setPopulateTreeBlock

   METHOD clearTree()
   METHOD populateTree( xSection, cParent, cNode, cID, cDesc, cIcon )

   DATA   sl_background
   METHOD background                              SETGET

   DATA   bObjectsBlock
   ACCESS objectsBlock                            INLINE ::bObjectsBlock
   ASSIGN objectsBlock( bBlock )                  INLINE ::bObjectsBlock := bBlock
   ACCESS objectsTree                             INLINE ::oTree

   FRIEND CLASS HbQtPanel

   ENDCLASS


METHOD HbQtDashboard:init( oParent )

   ::oParent := oParent

   hb_HCaseMatch( ::hMDIs, .F. )
   hb_HKeepOrder( ::hMDIs, .T. )

   RETURN Self


METHOD HbQtDashboard:create( oParent )

   hb_default( @oParent, ::oParent )
   ::oParent := oParent

   ::oWidget := QWidget( ::oParent )

   WITH OBJECT ::oStackedWidget := QStackedWidget()
      :connect( "currentChanged(int)", {|i|
                                             IF i >= 0 .AND. ! Empty( ::hMDIs ) .AND. Len( ::hMDIs ) <= i + 1
                                                ::oActivePanel := hb_HValueAt( ::hMDIs, i + 1 )
                                                ::dispStatus()
                                             ENDIF
                                             RETURN NIL
                                       } )
   ENDWITH

   WITH OBJECT ::oTabBar := QTabBar()
      :setShape( QTabBar_TriangularNorth )
//    :setMovable( .T. )
      :setTabsClosable( .T. )
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :connect( "currentChanged(int)"               , {|i| ::oStackedWidget:setCurrentIndex( i ) } )
      :connect( "tabCloseRequested(int)"            , {|i| ::removePanel( ::oTabbar:tabText( i ) ) } )
      :connect( "customContextMenuRequested(QPoint)", {|pos| ::manageTabContext( pos ) } )
   ENDWITH

   WITH OBJECT ::oStatusBar := QStatusBar()
      :setSizeGripEnabled( .F. )
      :setStyleSheet( "QStatusBar::item { border: 1px solid darkgray; border-radius: 3px; }" )
      :setMaximumHeight( 20 )
      :setMinimumHeight( 20 )
   ENDWITH
   ::buildStatusPanels()

   /* Populating the side tree will be done in appln code */
   WITH OBJECT ::oTree := QTreeWidget()
      :setHeaderHidden( .T. )
      :setRootIsDecorated( .T. )
      :setItemsExpandable( .T. )
      :setUniformRowHeights( .T. )
      :setIndentation( 10 )
      :setIconSize( QSize( 10,10 ) )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oItem| ::manageTreeObject( oItem ) } )
   ENDWITH

   WITH OBJECT ::oSplitter := QSplitter()
      :setOrientation( Qt_Horizontal )
      :addWidget( ::oStackedWidget )
      :addWidget( ::oTree )
   ENDWITH

   WITH OBJECT ::oGLayout := QGridLayout()
      :setContentsMargins( 0,0,0,0 )
      :setHorizontalSpacing( 0 )
      :setVerticalSpacing( 0 )
   ENDWITH

   ::oWidget:setLayout( ::oGLayout )

   ::buildToolbars()

   ::oGLayout:addWidget( ::oTabBar          , 0, 0, 1, 2 )
   ::oGLayout:addWidget( ::oToolbarT:oWidget, 1, 0, 1, 2 )
   ::oGLayout:addWidget( ::oToolbar:oWidget , 2, 0, 1, 1 )
   ::oGLayout:addWidget( ::oSplitter        , 2, 1, 1, 1 )
   ::oGLayout:addWidget( ::oStatusBar       , 3, 0, 1, 2 )

   ::addPanel( "Main" )

   ::oTree:hide()
   ::oTabBar:hide()
   ::dispStatus()

   RETURN Self


METHOD HbQtDashboard:saveState()
   LOCAL hState := {=>}

   hState[ "dashSplitter" ] := QVariant( ::oSplitter:saveState() )

   RETURN hState


METHOD HbQtDashboard:restState( hState )

   IF HB_ISHASH( hState )
      IF "dashSplitter" $ hState
         ::oSplitter:restoreState( hState[ "dashSplitter" ]:toByteArray() )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtDashboard:savePanelsInfo()
   LOCAL oPanel, hInfo := {=>}

   hb_HKeepOrder( hInfo, .T. )
   hb_HCaseMatch( hInfo, .F. )

   hInfo[ "dashTabsVisible" ] := ::oTabbar:isVisible()
   hInfo[ "dashTreeVisible" ] := ::oTree:isVisible()

   hInfo[ "dashPanels"      ] := {=>}
   hb_HKeepOrder( hInfo[ "dashPanels" ], .T. )
   hInfo[ "dashState"       ] := {=>}
   hb_HKeepOrder( hInfo[ "dashState" ], .T. )

   FOR EACH oPanel IN ::hMDIs
      hInfo[ "dashPanels" ][ oPanel:name() ] := oPanel:saveWindowsInfo()
   NEXT
   FOR EACH oPanel IN ::hMDIs
      hInfo[ "dashState"  ][ oPanel:name() ] := { oPanel:isLocked() }
   NEXT

   hInfo[ "dashActivePanel" ] := ::oActivePanel:name()

   RETURN hInfo


METHOD HbQtDashboard:restPanelsInfo( hInfo )
   LOCAL xPanel, aSub, oDashObj, hDash

   IF ! HB_ISHASH( hInfo )
      RETURN Self
   ENDIF

   FOR EACH xPanel IN hInfo
      SWITCH xPanel:__enumKey()
      CASE "dashTabsVisible"
         ::oTabbar:setVisible( xPanel )
         EXIT
      CASE "dashTreeVisible"
         ::oTree:setVisible( xPanel )
         EXIT
      CASE "dashActivePanel"
         ::setActiveTab( xPanel )
         EXIT
      CASE "dashPanels"
         FOR EACH hDash IN xPanel
            ::addPanel( hDash:__enumKey() )
            FOR EACH aSub IN hDash
               IF ! Empty( oDashObj := ::createObject( aSub:__enumKey(), aSub[ 1 ] ) )
                  oDashObj:subWindow():move( aSub[ 2 ], aSub[ 3 ] )
                  oDashObj:subWindow():resize( aSub[ 4 ], aSub[ 5 ] )
               ENDIF
            NEXT
         NEXT
         EXIT
      CASE "dashState"
         FOR EACH hDash IN xPanel
            ::setPanelLocked( hDash:__enumKey(), hDash[ 1 ] )
         NEXT
         EXIT
      ENDSWITCH
   NEXT
   RETURN Self


METHOD HbQtDashboard:manageTabContext( oPos )
   LOCAL oMenu, oAct, n, cName

   IF ( n := ::oTabbar:tabAt( oPos ) ) < 0
      RETURN NIL
   ENDIF
   cName := ::oTabbar:tabText( n )
   WITH OBJECT oMenu := QMenu()
      IF ::isPanelLocked( cName )
         :addAction( "Unlock Panel <" + cName + ">" )
      ELSE
         :addAction( "Lock Panel <" + cName + ">" )
         :addAction( "Clear Objects" )
      ENDIF
   ENDWITH
   IF ! Empty( oAct := oMenu:exec( ::oTabbar:mapToGlobal( oPos ) ) )
      IF oAct:text() == "Clear Objects"
         ::clearPanel( cName )
      ELSEIF oAct:text() == "Lock Panel <" + cName + ">"
         ::setPanelLocked( cName, .T. )
      ELSE
         ::setPanelLocked( cName, .F. )
      ENDIF
   ENDIF

   RETURN NIL


METHOD HbQtDashboard:isPanelLocked( cPanel )
   IF cPanel $ ::hMDIs
      RETURN ::hMDIs[ cPanel ]:isLocked()
   ENDIF
   RETURN .F.


METHOD HbQtDashboard:setPanelLocked( cPanel, lLocked )
   LOCAL i
   IF cPanel $ ::hMDIs
      ::hMDIs[ cPanel ]:setLocked( lLocked )
      FOR i := 1 TO ::oTabbar:count()
         IF ::oTabbar:tabText( i-1 ) == cPanel
            ::oTabbar:setTabTextColor( i-1, QColor( iif( lLocked, Qt_red, Qt_black ) ) )
            EXIT
         ENDIF
      NEXT
   ENDIF
   RETURN NIL


METHOD HbQtDashboard:clearPanel( cPanel )

   IF cPanel $ ::hMDIs
      IF Alert( "Do you really want to clear objects from <" + cPanel + "> panel ?", { "No", "Yes" } ) != 2
         RETURN Self
      ENDIF
      ::hMDIs[ cPanel ]:clear()
   ENDIF

   RETURN Self


METHOD HbQtDashboard:removePanel( cPanel )
   LOCAL oPanel, nPanel

   IF cPanel == "Main"
      RETURN Self
   ENDIF
   IF Alert( "Do you really want to remove <" + cPanel + "> panel ?", { "No", "Yes" } ) != 2
      RETURN Self
   ENDIF
   IF hb_HHasKey( ::hMDIs, cPanel )
      FOR nPanel := 0 TO ::oTabbar:count()
         IF ::oTabbar:tabText( nPanel ) == cPanel
            ::oTabbar:removeTab( nPanel )
            EXIT
         ENDIF
      NEXT
      oPanel := ::hMDIs[ cPanel ]
      hb_HDel( ::hMDIs, cPanel )
      oPanel:destroy()
      ::oStackedWidget:removeWidget( oPanel:oWidget )
      oPanel:oWidget:setParent( QWidget() )
   ENDIF

   RETURN Self

METHOD HbQtDashboard:addPanel( cName )
   LOCAL oMDI, oAct

   IF hb_HHasKey( ::hMDIs, cName )  /* Already Added */
      ::setActiveTab( cName )
      RETURN Self
   ENDIF

   oMDI := HbQtPanel():new( cName )
   ::hMDIs[ cName ] := oMDI

   ::background()

   ::oStackedWidget:addWidget( oMDI:oWidget )

   ::oTabbar:addTab( cName )
   ::oTabbar:setCurrentIndex( ::oTabbar:count() - 1 )

   ::oActivePanel := oMDI

   WITH OBJECT oAct := ::oPanelsMenu:addAction( cName )
      :connect( "triggered(bool)", {|| ::setActiveTab( cName ) } )
   ENDWITH
   HB_SYMBOL_UNUSED( oAct )

   RETURN Self


METHOD HbQtDashboard:addPanels( aPanels )
   LOCAL cName

   IF HB_ISARRAY( aPanels )
      FOR EACH cName IN aPanels
         ::addPanel( cName )
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtDashboard:managePanels()
   LOCAL GetList := {}, SayList := {}
   LOCAL cName := Space( 15 )

   @ 1,2 QSAY "New Panel Name:" QGET cName
   QREAD LASTGETBLOCK {|| GetActive():parent():close() }
   cName := Trim( cName )

   IF ! Empty( cName ) .AND. ! hb_HHasKey( ::hMDIs, cName )
      ::addPanel( cName )
   ENDIF

   RETURN Self


METHOD HbQtDashboard:buildPanelsButton()

   ::oPanelsMenu := QMenu()

   WITH OBJECT ::oPanelsButton := QToolButton()
      :setTooltip( "Dashboard Panels - Click: Create; Menu: Select" )
      :setIcon( QIcon( __hbqtImage( "panel_8" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::oPanelsMenu )
      :connect( "clicked()", {|| ::managePanels() } )
   ENDWITH

   ::oToolbarT:addItem( ::oPanelsButton )

   RETURN Self


METHOD HbQtDashboard:setActiveTab( cName )
   LOCAL i

   FOR i := 0 TO ::oTabbar:count() - 1
      IF ::oTabbar:tabText( i ) == cName
         ::oTabbar:setCurrentIndex( i )
         EXIT
      ENDIF
   NEXT

   RETURN Self


METHOD HbQtDashboard:buildToolbars()

   ::sp0 := QLabel(); ::sp0:setMinimumWidth( 25 )
   ::sp1 := QLabel(); ::sp1:setMinimumWidth( 100 )

   WITH OBJECT ::oToolbarT := HbQtToolbar():new()
      :imageWidth  := 12
      :imageHeight := 12
      :create()
      :buttonClick := {|oButton| ::execEvent( __toolbarButton_clicked__, oButton ) }
   ENDWITH

   ::buildPanelsButton()

   ::oToolbarT:addItem( ::sp0 )
   ::oToolbarT:addItem( "Browser"            , QIcon( __hbqtImage( "table"    ) ) , , , , , "Browser"   )
   ::oToolbarT:addItem( "Figures"            , QIcon( __hbqtImage( "numbers"  ) ) , , , , , "Figure"    )
   ::oToolbarT:addItem( "Graph"              , QIcon( __hbqtImage( "f_chart"  ) ) , , , , , "Graph"     )
   ::oToolbarT:addItem( "Banner"             , QIcon( __hbqtImage( "banner"   ) ) , , , , , "Banner"    )
   ::oToolbarT:addItem( "Pictures"           , QIcon( __hbqtImage( "images"   ) ) , , , , , "Picture"   )
   ::oToolbarT:addItem( "Text"               , QIcon( __hbqtImage( "text-file") ) , , , , , "Text"      )
   ::oToolbarT:addItem( ::sp1 )
   ::oToolbarT:addItem( "Toggle Objects Tree", QIcon( __hbqtImage( "treeview" ) ) , , , , , "TreeView"  )
   ::oToolbarT:addItem( "Toggle Panels Tabs" , QIcon( __hbqtImage( "treeview" ) ) , , , , , "PanelTabs" )

   ::buildToolbarLeft()

   RETURN Self


METHOD HbQtDashboard:buildToolbarLeft()

   WITH OBJECT ::oToolbar := HbQtToolbar():new()
      :orientation := Qt_Vertical
      :imageWidth  := 12
      :imageHeight := 12
      :create()

      :buttonClick := {|oButton| iif( HB_ISBLOCK( oButton:key ), Eval( oButton:key ), NIL ) }

      :addItem( { "view_tabbed"      , "Toggle Tabbed View"      , QIcon( __hbqtImage( "view_tabbed"       ) ), {|| ::oActivePanel:oWidget:setViewMode( iif( ::oActivePanel:oWidget:viewMode() == QMdiArea_TabbedView, QMdiArea_SubWindowView, QMdiArea_TabbedView ) ) }, .f. } )
      :addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
      :addItem( { "view_organized"   , "View as Arranged"        , QIcon( __hbqtImage( "view_organized"    ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_ORGANIZED ) }, .f. } )
      :addItem( { "save3"            , "Save Layout"             , QIcon( __hbqtImage( "save3"             ) ), {|| ::oActivePanel:saveGeometry() }, .f. } )
      :addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
      :addItem( { "view_cascaded"    , "View as Cascaded"        , QIcon( __hbqtImage( "view_cascaded"     ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_CASCADED ) }, .f. } )
      :addItem( { "view_tiled"       , "View as Tiled"           , QIcon( __hbqtImage( "view_tiled"        ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_TILED ) }, .f. } )
      :addItem( { "fullscreen"       , "View Maximized"          , QIcon( __hbqtImage( "fullscreen"        ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_MAXIMIZED ) }, .f. } )
      :addItem( { "view_vertstacked" , "View Vertically Tiled"   , QIcon( __hbqtImage( "view_vertstacked"  ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_TILEDVERT ) }, .f. } )
      :addItem( { "view_horzstacked" , "View Horizontally Tiled" , QIcon( __hbqtImage( "view_horzstacked"  ) ), {|| ::oActivePanel:setViewStyle( HBQTMDI_STYLE_TILEDHORZ ) }, .f. } )
      :addItem( { "view_zoomin"      , "View Zoom In"            , QIcon( __hbqtImage( "view_zoomin"       ) ), {|| ::oActivePanel:tilesZoom( +1 ) }, .f. } )
      :addItem( { "view_zoomout"     , "View Zoom Out"           , QIcon( __hbqtImage( "view_zoomout"      ) ), {|| ::oActivePanel:tilesZoom( -1 ) }, .f. } )
   ENDWITH

   RETURN NIL


METHOD HbQtDashboard:dispStatus()

   ::dispStatusMessage( STATUS_PANEL      , ::oActivePanel:name() )
   ::dispStatusMessage( STATUS_NOOFPANELS , hb_ntos( ::oTabbar:currentIndex() + 1 ) + "/" + hb_ntos( ::oTabbar:count() ) )
   ::dispStatusMessage( STATUS_NOOFWINDOWS, hb_ntos( ::oActivePanel:widget():subWindowList():count() ) )
//   ::dispStatusMessage( STATUS_ACTIVEWINDOWS, ::oActivePanel:widget():activeSubWindow():objectName() )

   RETURN Self


METHOD HbQtDashboard:dispStatusMessage( nPanel, cMsg )

   IF nPanel > 0 .AND. nPanel <= Len( ::aStatusPnls ) .AND. HB_ISCHAR( cMsg )
      ::aStatusPnls[ nPanel ]:setText( cMsg )
   ENDIF

   RETURN Self


METHOD HbQtDashboard:buildStatusPanels()
   LOCAL oLabel

   oLabel := QLabel(); oLabel:setMinimumWidth( 40 )
   oLabel:setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
   ::oStatusBar:addPermanentWidget( oLabel, 0 )
   aadd( ::aStatusPnls, oLabel )

   oLabel := QLabel(); oLabel:setMinimumWidth( 40 )
   oLabel:setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
   ::oStatusBar:addPermanentWidget( oLabel, 0 )
   aadd( ::aStatusPnls, oLabel )

   oLabel := QLabel(); oLabel:setMinimumWidth( 40 )
   oLabel:setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
   ::oStatusBar:addPermanentWidget( oLabel, 0 )
   aadd( ::aStatusPnls, oLabel )

   oLabel := QLabel(); oLabel:setMinimumWidth( 40 )
   oLabel:setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
   ::oStatusBar:addPermanentWidget( oLabel, 1 )
   aadd( ::aStatusPnls, oLabel )

   RETURN Self


METHOD HbQtDashboard:background( oBrush )
   LOCAL oOBackground, oMDI

   oOBackground := ::sl_background
   IF HB_ISOBJECT( oBrush )
      ::sl_background := oBrush
   ENDIF
   IF HB_ISOBJECT( ::sl_background )
      FOR EACH oMDI IN ::hMDIs
         oMDI:setBackground( ::sl_background )
      NEXT
   ENDIF

   RETURN oOBackground


METHOD HbQtDashboard:execEvent( nEvent, p, p1 )

   HB_SYMBOL_UNUSED( p1 )

   SWITCH nEvent
   CASE __toolbarButton_clicked__
      SWITCH p:key
      CASE "Banner"
      CASE "Graph"
      CASE "Browser"
      CASE "Figure"
      CASE "Picture"
      CASE "Text"
         ::addObject( p:key ) ;  EXIT
      CASE "TreeView"
         IF ::oTree:isVisible()
            ::oTree:hide()
         ELSE
            ::oTree:show()
         ENDIF
         EXIT
      CASE "PanelTabs"
         IF ::oTabBar:isVisible()
            ::oTabBar:hide()
         ELSE
            ::oTabBar:show()
         ENDIF
         EXIT
      ENDSWITCH
      EXIT
   ENDSWITCH

   RETURN Self


METHOD HbQtDashboard:createObject( cName, cAttrbs )
   LOCAL aObject, oDashObj

   IF ! HB_ISBLOCK( ::objectsBlock )
      RETURN NIL
   ENDIF
   IF ! ::oActivePanel:isObjectAvailable( cName )
      aObject := Eval( ::objectsBlock, "Create", cName, cAttrbs, "" )
      IF HB_ISARRAY( aObject ) .AND. Len( aObject ) >= 5
         IF ! Empty( oDashObj := ::oActivePanel:addObject( aObject ) )
            Eval( ::objectsBlock, "Configure", iif( Empty( oDashObj:oHbQtWidget ), oDashObj:oWidget, oDashObj:oHbQtWidget ), aObject )
         ENDIF
         Alert( "Created", , , 0.05 )         // a hack - need to be investigated deeper
      ENDIF
   ENDIF

   RETURN oDashObj


METHOD HbQtDashboard:addObject( cType )         /* Click on Toolbar Icon */
   LOCAL aObject

   IF HB_ISBLOCK( ::objectsBlock )
      IF ! ::oActivePanel:isLocked()
         aObject := Eval( ::objectsBlock, "New", cType )
         IF HB_ISARRAY( aObject ) .AND. Len( aObject ) >= 5
            ::oActivePanel:addObject( aObject )    /* No Configuration Required */
            Alert( "Created", , , 0.05 )         // a hack - need to be investigated deeper
         ENDIF
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtDashboard:manageTreeObject( oItem )  /* Click on Tree Node */
   LOCAL cAttrbs, oDashObj

   IF HB_ISBLOCK( ::objectsBlock )
      IF ! ::oActivePanel:isLocked()
         IF ! Empty( cAttrbs := oItem:whatsThis( 0 ) )
            oDashObj := ::createObject( oItem:text( 0 ), cAttrbs )
         ENDIF
      ENDIF
   ENDIF

   RETURN oDashObj


METHOD HbQtDashboard:setPopulateTreeBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bPopulateTree := bBlock
   ENDIF
   RETURN ::bPopulateTree


METHOD HbQtDashboard:getPopulateTreeBlock()
   RETURN ::bPopulateTree


METHOD HbQtDashboard:clearTree()
   ::oTree:clear()
   RETURN Self


METHOD HbQtDashboard:populateTree( xSection, cParent, cNode, cID, cDesc, cIcon )
   LOCAL oTreeItem, oParent, cSection, oSection, oNode

   IF HB_ISARRAY( xSection )
      ASize( xSection, 6 )
      cSection := xSection[ 1 ]
      cParent  := xSection[ 2 ]
      cNode    := xSection[ 3 ]
      cID      := xSection[ 4 ]
      cDesc    := xSection[ 5 ]
      cIcon    := xSection[ 6 ]
   ELSE
      cSection := xSection
   ENDIF

   hb_default( @cDesc, "" )
   hb_default( @cID, "" )

   IF HB_ISCHAR( cSection ) .AND. ! Empty( cSection )
      oSection := findItem( ::oTree:invisibleRootItem(), cSection )
      IF oSection == NIL
         WITH OBJECT oSection := QTreeWidgetItem()
            :setText( 0, cSection )
            :setTooltip( 0, cSection )
            :setForeground( 0, QBrush( QColor( 120,75,75 ) ) )
         ENDWITH
         ::oTree:invisibleRootItem():addChild( oSection )
      ENDIF
      oParent := findItem( oSection, cParent )
      IF oParent == NIL
         WITH OBJECT oParent := QTreeWidgetItem()
            :setText( 0, cParent )
            :setTooltip( 0, cParent )
            :setForeground( 0, QBrush( QColor( 75,120,75 ) ) )
         ENDWITH
         oSection:addChild( oParent )
         oSection:setExpanded( .T. )
      ENDIF

      oNode := findItem( oParent, cNode )
      IF oNode == NIL
         WITH OBJECT oTreeItem := QTreeWidgetItem()
            :setText( 0, cNode )
            :setWhatsThis( 0, cID )
            :setTooltip( 0, cDesc )
            :setIcon( 0, QIcon( iif( Empty( cIcon ), __hbqtImage( "objects" ), cIcon ) ) )
         ENDWITH
         oParent:addChild( oTreeItem )
         oParent:sortChildren( 0, Qt_AscendingOrder )
      ENDIF
      oSection:setExpanded( .T. )
   ENDIF

   RETURN Self


STATIC FUNCTION findItem( oParent, cItem )
   LOCAL i, oItem
   IF oParent:text( 0 ) == cItem
      RETURN oParent
   ENDIF
   FOR i := 0 TO oParent:childCount() - 1
      oItem := findItem( oParent:child( i ), cItem )
      IF oItem != NIL
         RETURN oItem
      ENDIF
   NEXT
   RETURN NIL

/*----------------------------------------------------------------------*/
//                          Class HbQtPanel
/*----------------------------------------------------------------------*/

CLASS HbQtPanel

   DATA   oWidget
   ACCESS widget                                  INLINE ::oWidget

   DATA   oActiveWindow
   DATA   oManager

   DATA   cPanel                                  INIT   ""
   DATA   nViewStyle                              INIT   QMdiArea_SubWindowView
   DATA   lLayoutLocked                           INIT   .F.
   DATA   lLocked                                 INIT   .F.

   DATA   hSubWindows                             INIT   {=>}
   ACCESS subWindows()                            INLINE ::hSubWindows
   ACCESS name                                    INLINE ::oWidget:objectName()

   METHOD init( cPanel )
   METHOD clear()
   METHOD destroy()
   METHOD execEvent( nEvent, p )
   METHOD setActiveWindow( oSubWindow )

   METHOD addObject( aObject )
   METHOD isObjectAvailable( cObject )
   METHOD setActiveObject( cObject )

   METHOD saveGeometry()
   METHOD restGeometry()
   METHOD activateWindows()

   METHOD setViewStyle( nStyle )
   METHOD tileVertically()
   METHOD tileHorizontally()
   METHOD tilesZoom( nMode )

   METHOD setBackground( oBrush )                 INLINE ::oWidget:setBackground( oBrush )
   METHOD saveWindowsInfo()

   ACCESS isLocked                                INLINE ::lLocked
   METHOD setLocked( lLocked )                    INLINE iif( HB_ISLOGICAL( lLocked ), ::lLocked := lLocked, NIL ), ::oWidget:setEnabled( ! ::lLocked )

   ENDCLASS


METHOD HbQtPanel:init( cPanel )

   ::cPanel := cPanel

   WITH OBJECT ::oWidget := QMdiArea()
      :setObjectName( ::cPanel )
      :setDocumentMode( .F. )
      :setOption( QMdiArea_DontMaximizeSubWindowOnActivation, .T. )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setDocumentMode( .T. )
      :setTabShape( QTabWidget_Triangular )
      :setViewMode( ::nViewStyle )
      :connect( "subWindowActivated(QMdiSubWindow*)", {|p| ::execEvent( __mdiArea_subWindowActivated__, p ) } )
   ENDWITH

   RETURN Self


METHOD HbQtPanel:clear()
   RETURN ::destroy()


METHOD HbQtPanel:destroy()
   LOCAL oList

   DO WHILE .T.
      oList := ::oWidget:subWindowList()
      IF oList:count() == 0
         EXIT
      ENDIF
      oList:at( 0 ):close()
   ENDDO

   RETURN NIL


METHOD HbQtPanel:saveWindowsInfo()
   LOCAL oSub, oDashObj
   LOCAL hInfo := {=>}

   hb_HKeepOrder( hInfo, .T. )

   FOR EACH oDashObj IN ::hSubWindows
      oDashObj:collectAttributes()
      oSub := oDashObj:subWindow()
      hInfo[ oDashObj:title() ] := { oDashObj:cAttrbs, oSub:x(), oSub:y(), oSub:width(), oSub:height() }
   NEXT

   RETURN hInfo


METHOD HbQtPanel:addObject( aObject )
   LOCAL oDashObj := HbQtDashboardObject():new( Self, aObject ):create()

   IF ! Empty( oDashObj )
      ::oActiveWindow := oDashObj:subWindow()
      ::oWidget:addSubWindow( ::oActiveWindow )

      ::hSubWindows[ oDashObj:title() ] := oDashObj

      oDashObj:subWindow():connect( QEvent_Close , {||
                                                        hb_HDel( ::hSubWindows, oDashObj:title() )
                                                        ::oWidget:removeSubWindow( oDashObj:subWindow() )
                                                        oDashObj:destroy()
                                                        oDashObj := NIL
                                                        RETURN .F.
                                                   } )
   ENDIF
   RETURN oDashObj


METHOD HbQtPanel:setViewStyle( nStyle )
   LOCAL qObj, oDashObj
   LOCAL nOldStyle := ::nViewStyle

   IF HB_ISNUMERIC( nStyle )
      IF nStyle != ::nViewStyle
         IF ::nViewStyle == HBQTMDI_STYLE_ORGANIZED
            ::saveGeometry()
         ENDIF
         IF ::nViewStyle == HBQTMDI_STYLE_MAXIMIZED
            qObj := ::oWidget:activeSubWindow()
            FOR EACH oDashObj IN ::hSubWindows
               oDashObj:subWindow():setWindowState( Qt_WindowNoState )
            NEXT
            IF ! Empty( qObj )
               ::oWidget:setActiveSubWindow( qObj )
            ENDIF
         ENDIF

         SWITCH nStyle
         CASE HBQTMDI_STYLE_ORGANIZED
            ::restGeometry()
            EXIT
         CASE HBQTMDI_STYLE_CASCADED
            ::oWidget:cascadeSubWindows()
            EXIT
         CASE HBQTMDI_STYLE_TILED
            ::oWidget:tileSubWindows()
            EXIT
         CASE HBQTMDI_STYLE_MAXIMIZED
            qObj := ::oWidget:activeSubWindow()
            FOR EACH oDashObj IN ::hSubWindows
               oDashObj:subWindow():setWindowState( Qt_WindowMaximized )
            NEXT
            IF ! Empty( qObj )
               ::oWidget:setActiveSubWindow( qObj )
            ENDIF
            EXIT
         CASE HBQTMDI_STYLE_TILEDVERT
            ::tileVertically()
            EXIT
         CASE HBQTMDI_STYLE_TILEDHORZ
            ::tileHorizontally()
            EXIT
         ENDSWITCH

         ::nViewStyle := nStyle
      ENDIF
   ENDIF
   RETURN nOldStyle


METHOD HbQtPanel:tileVertically()
   LOCAL oObj, oVPort, nH, nT, nW, oDashObj

   IF Len( ::hSubWindows ) > 0
      oObj   := ::oWidget:activeSubWindow()
      oVPort := ::oWidget:viewport()
      nH     := oVPort:height() / Len( ::hSubWindows )
      nW     := oVPort:width()
      nT     := 0
      FOR EACH oDashObj IN ::hSubWindows
         oDashObj:subWindow():setGeometry( QRect( 0, nT, nW, nH ) )
         nT += nH
      NEXT
      IF ! Empty( oObj )
         ::oWidget:setActiveSubWindow( oObj )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtPanel:tileHorizontally()
   LOCAL oObj, oVPort, nH, nT, nW, nL, oDashObj

   IF Len( ::hSubWindows ) > 0
      oObj   := ::oWidget:activeSubWindow()
      oVPort := ::oWidget:viewport()
      nH     := oVPort:height()
      nW     := oVPort:width() / Len( ::hSubWindows )
      nT     := 0
      nL     := 0
      FOR EACH oDashObj IN ::hSubWindows
         oDashObj:subWindow():setGeometry( QRect( nL, nT, nW, nH ) )
         nL += nW
      NEXT
      IF ! Empty( oObj )
         ::oWidget:setActiveSubWindow( oObj )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtPanel:tilesZoom( nMode )
   LOCAL oMdi, nT, nL, nH, nW, oRect, oDashObj

   IF Len( ::hSubWindows ) > 0
      IF ::nViewStyle == HBQTMDI_STYLE_TILEDVERT .OR. ::nViewStyle == HBQTMDI_STYLE_TILEDHORZ
         IF ::nViewStyle == HBQTMDI_STYLE_TILEDVERT
            nT := 0
            FOR EACH oDashObj IN ::hSubWindows
               oMdi  := oDashObj:subWindow()
               oRect := oMdi:geometry()
               nH    := oRect:height() + ( nMode * ( oRect:height() / 4 ) )
               oMdi  : setGeometry( QRect( 0, nT, oRect:width(), nH ) )
               nT    += nH
            NEXT
         ELSE
            nL := 0
            FOR EACH oDashObj IN ::hSubWindows
               oMdi  := oDashObj:subWindow()
               oRect := oMdi:geometry()
               nW    := oRect:width() + ( nMode * ( oRect:width() / 4 ) )
               oMdi  :  setGeometry( QRect( nL, 0, nW, oRect:height() ) )
               nL    += nW
            NEXT
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtPanel:saveGeometry()
   LOCAL oDashObj
   IF ::nViewStyle == HBQTMDI_STYLE_ORGANIZED
      FOR EACH oDashObj IN ::hSubWindows
         oDashObj:geometry := oDashObj:subWindow():geometry()
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtPanel:restGeometry()
   LOCAL oDashObj
   FOR EACH oDashObj IN ::hSubWindows
      IF HB_ISOBJECT( oDashObj:geometry() )
         oDashObj:subWindow():setGeometry( oDashObj:geometry() )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtPanel:execEvent( nEvent, p )
   LOCAL oDashObj

   SWITCH nEvent

   CASE __mdiArea_subWindowActivated__
      FOR EACH oDashObj IN ::hSubWindows
         IF hbqt_IsEqual( oDashObj:subWindow(), p )
            ::oActiveWindow := oDashObj
            EXIT
         ENDIF
      NEXT
      EXIT

   ENDSWITCH

   RETURN Self


METHOD HbQtPanel:isObjectAvailable( cObject )

   RETURN hb_HHasKey( ::hSubWindows, cObject )


METHOD HbQtPanel:setActiveObject( cObject )

   IF hb_HHasKey( ::hSubWindows, cObject )
      ::oWidget:activateSubWindow( ::hSubWindows[ cObject ]:subWindow() )
      ::oActiveWindow := ::hSubWindows[ cObject ]:subWindow()
   ENDIF

   RETURN .F.


METHOD HbQtPanel:setActiveWindow( oSubWindow )
   LOCAL oDashObj

   FOR EACH oDashObj IN ::hSubWindows
      IF oDashObj:subWindow() == oSubWindow
         ::oActiveWindow := oSubWindow
         EXIT
      ENDIF
   NEXT

   RETURN Self


METHOD HbQtPanel:activateWindows()
   LOCAL oDashObj

   IF Len( ::hSubWindows ) > 0
      FOR EACH oDashObj IN ::hSubWindows
         ::oWidget:setActiveSubWindow( oDashObj:subWindow() )
      NEXT
      FOR EACH oDashObj IN ::hSubWindows
         ::oWidget:setActiveSubWindow( oDashObj:subWindow() )
         IF oDashObj:__enumIndex() == 1
            EXIT
         ENDIF
      NEXT
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/
//                        Class HbQtDashboardObject
/*----------------------------------------------------------------------*/

CLASS HbQtDashboardObject

   DATA   oWidget
   DATA   oParent
   DATA   oHbQtWidget
   DATA   oSubWindow
   ACCESS subWindow                               INLINE ::oSubWindow

   ACCESS widget                                  INLINE iif( HB_ISOBJECT( ::oHbQtWidget ), ::oHbQtWidget, ::oWidget )

   DATA   cType                                   INIT   ""
   ACCESS type                                    INLINE ::cType
   ASSIGN type( cType )                           INLINE ::cType := cType

   DATA   cTitle                                  INIT   ""
   ACCESS title                                   INLINE ::cTitle
   ASSIGN title( cTitle )                         INLINE ::cTitle := cTitle

   DATA   nDuration                               INIT   10
   ACCESS duration                                INLINE ::nDuration
   ASSIGN duration( nDuration )                   INLINE ::nDuration := nDuration

   DATA   xData
   ACCESS data                                    INLINE ::xData
   ASSIGN data( xData )                           INLINE ::xData := xData

   DATA   cAttrbs                                 INIT   ""
   METHOD collectAttributes()

   DATA   aAttrbs                                 INIT   {}
   ACCESS attributes                              INLINE ::aAttrbs
   ASSIGN attributes( aAttrbs )                   INLINE ::aAttrbs := aAttrbs

   DATA   bDataBlock
   ACCESS dataBlock                               INLINE ::bdataBlock
   ASSIGN dataBlock( bBlock )                     INLINE ::bDataBlock := bBlock

   DATA   bAttributesBlock
   ACCESS attributesBlock                         INLINE ::bAttributesBlock
   ASSIGN attributesBlock( bBlock )               INLINE ::bAttributesBlock := bBlock

   DATA   oGeometry
   ACCESS geometry                                INLINE ::oGeometry
   ASSIGN geometry( oGeometry )                   INLINE ::oGeometry := oGeometry

   METHOD new( oParent, aObject )
   METHOD create()
   METHOD destroy()
   METHOD update( xData )
   METHOD refresh( xData )                        INLINE ::update( xData )

   METHOD buildSubWindow()
   METHOD buildBrowser()
   METHOD buildBanner()
   METHOD buildGraph()
   METHOD buildFigure()
   METHOD buildPicture()
   METHOD buildText()

   DATA   aPosAndSize                             INIT   {}
   DATA   nHotPos                                 INIT   0
   DATA   cDisp                                   INIT   ""
   DATA   nLastWidth                              INIT   0
   DATA   nCharWidth
   DATA   oTimerFetch, oTimerPull, oTimerSpeed, oTimerClear

   DATA   nID
   ACCESS id                                      INLINE ::nID
   ASSIGN id( nID )                               INLINE ::nID := nID

   METHOD fetchData()
   METHOD pullData()

   DATA   oGetEdit
   DATA   oTextEdit
   DATA   oGetEditTimer
   DATA   oGetEditText                            INIT ""
   DATA   nSeconds                                INIT Seconds()
   METHOD manageUDF( cText )

   ENDCLASS


METHOD HbQtDashboardObject:new( oParent, aObject )

   ::id          := __getAnObjectID()

   ::oParent     := oParent

   ::cType       := aObject[ OBJ_TYPE     ]
   ::cTitle      := aObject[ OBJ_TITLE    ]
   ::nDuration   := aObject[ OBJ_DURATION ]
   ::bDataBlock  := aObject[ OBJ_BLOCK    ]
   ::aAttrbs     := aObject[ OBJ_ATTRBS   ]
   ::cAttrbs     := aObject[ OBJ_CATTRBS  ]
   ::aPosAndSize := iif( Len( aObject ) >= OBJ_POSANDSIZE, aObject[ OBJ_POSANDSIZE ], {} )

   IF ::Type() != "Text"
      ::fetchData()
   ENDIF

   RETURN Self


METHOD HbQtDashboardObject:create()

   ::buildSubWindow()

   SWITCH ::type()
   CASE "Banner"  ;  ::buildBanner()  ;  EXIT
   CASE "Figure"  ;  ::buildFigure()  ;  EXIT
   CASE "Graph"   ;  ::buildGraph()   ;  EXIT
   //CASE "Browser" ;  ::buildBrowser() ;  EXIT
   CASE "Picture" ;  ::buildPicture() ;  EXIT
   CASE "Text"    ;  ::buildText()    ;  EXIT
   ENDSWITCH

   IF HB_ISOBJECT( ::oWidget )
      ::oSubWindow:setWidget( ::oWidget )
   ENDIF

   RETURN Self


METHOD HbQtDashboardObject:fetchData()

   IF HB_ISBLOCK( ::dataBlock() )
      IF hb_mtvm()
         hb_threadStart( {|| __fetchObjectData( ::dataBlock(), ::nID ) } )
      ELSE
         __fetchObjectData( ::dataBlock(), ::nID )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtDashboardObject:pullData()
   LOCAL xData

   IF ::nID $ hData
      hb_mutexLock( hMutex )
         xData := hData[ ::nID ]
      hb_mutexUnLock( hMutex )
   ENDIF

   IF xData != NIL
      IF HB_ISARRAY( xData )
         ::xData := AClone( xData )
      ELSE
         ::xData := xData
      ENDIF

      IF ! HB_ISOBJECT( ::oWidget )
         SWITCH ::type()
         CASE "Banner"  ;  ::buildBanner()  ;  EXIT
         CASE "Figure"  ;  ::buildFigure()  ;  EXIT
         CASE "Graph"   ;  ::buildGraph()   ;  EXIT
         CASE "Browser" ;  ::buildBrowser() ;  EXIT
         CASE "Picture" ;  ::buildPicture() ;  EXIT
         CASE "Text"    ;  ::buildText()    ;  EXIT
         ENDSWITCH

         ::oSubWindow:setWidget( ::oWidget )
      ENDIF

      ::update( ::xData )
   ENDIF

   RETURN Self


METHOD HbQtDashboardObject:update( xData )
   LOCAL aData, xTmp, oRect, cData

   SWITCH ::type()

   CASE "Figure"
      ::oWidget:display( xData )
      EXIT

   CASE "Banner"
      IF xData != NIL
         ::cDisp := ::xData + Space( ::oWidget:width() / ::nCharWidth - 1 )
         RETURN NIL
      ENDIF
      IF HB_ISSTRING( ::xData )
         IF ::nLastWidth != ::oWidget:width()
            ::cDisp := ::xData + Space( ::oWidget:width() / ::nCharWidth - 1 )
            ::nLastWidth := ::oWidget:width()
         ENDIF
         ::nHotPos++
         IF ::nHotPos > Len( ::cDisp )
            ::nHotPos := 1
         ENDIF
         ::oWidget:setText( Left( ::cDisp, ::nHotPos ) )
      ENDIF
      EXIT

   CASE "Picture"
      IF xData != NIL
         RETURN NIL
      ENDIF
      IF HB_ISARRAY( ::xData )
         ::nHotPos++
         IF ::nHotPos > Len( ::xData )
            ::nHotPos := 1
         ENDIF
         IF ::nHotPos <= Len( ::xData )
            xTmp := ::xData[ ::nHotPos ]
         ENDIF
      ELSE
         xTmp := ::xData
      ENDIF
      IF __objGetClsName( xTmp ) != "QPIXMAP"
         xTmp := QPixmap( xTmp )
      ENDIF
         oRect := ::oSubWindow:geometry()
         IF xTmp:width() > oRect:width() .OR. xTmp:height() > oRect:height()
            ::oWidget:setPixmap( xTmp:scaled( oRect:width(), oRect:height(), Qt_KeepAspectRatio ) )
         ELSE
            ::oWidget:setPixmap( xTmp )
         ENDIF
      EXIT

   CASE "Text"
      cData := iif( HB_ISCHAR( xData ), xData, iif( HB_ISCHAR( ::xData ), ::xData, NIL ) )
      IF cData != NIL
         IF ::attributes()[ DBRD_ATTRB_TEXT_KEEPAPPENDING ]
            ::oTextEdit:append( cData )
         ELSE
            ::oTextEdit:clear()
            ::oTextEdit:setText( cData )
         ENDIF
      ENDIF
      EXIT

   CASE "Graph"
      ::oHbQtWidget:clear()
      FOR EACH aData IN xData
         ::oHbQtWidget:addItem( aData[ 1 ], aData[ 2 ], iif( Len( aData ) == 3, aData[ 3 ], NIL ) )
      NEXT
      EXIT

   CASE "Browser"
      ASize( ::oHbQtWidget:cargo[ 1 ], 0 )
      AEval( xData, {|e_| AAdd( ::oHbQtWidget:cargo[ 1 ], e_ ) } )
      WITH OBJECT ::oHbQtWidget
         :gotop()
         :forceStable()
         :refreshAll()
      ENDWITH
      EXIT

   ENDSWITCH
   RETURN NIL


METHOD HbQtDashboardObject:destroy()
   LOCAL lDestroyed := .F.

   IF HB_ISOBJECT( ::oHbQtWidget )
      IF __objHasMethod( ::oHbQtWidget, "DESTROY" )
         lDestroyed := .T.
      ENDIF
   ENDIF
   IF lDestroyed
      ::oHbQtWidget:destroy()
   ENDIF
   ::oSubWindow:setParent( QWidget() )
   IF HB_ISOBJECT( ::oHbQtWidget )
      IF ! lDestroyed
         ::oHbQtWidget:oWidget:setParent( QWidget() )
      ENDIF
      ::oHbQtWidget := NIL
   ENDIF
   ::oSubWindow := NIL
   QApplication():processEvents()
   RETURN NIL


METHOD HbQtDashboardObject:buildSubWindow()

   WITH OBJECT ::oSubWindow := QMdiSubWindow( ::oParent:widget() )
      :setObjectName( ::title() )
      :setWindowTitle( ::title() )
      :setAttribute( Qt_WA_DeleteOnClose, .F. )

      SWITCH ::type()
      CASE "Banner" ; :setWindowIcon( QIcon( __hbqtImage( "banner"    ) ) ); EXIT
      CASE "Figure" ; :setWindowIcon( QIcon( __hbqtImage( "numbers"   ) ) ); EXIT
      CASE "Graph"  ; :setWindowIcon( QIcon( __hbqtImage( "f_chart"   ) ) ); EXIT
      CASE "Browser"; :setWindowIcon( QIcon( __hbqtImage( "table"     ) ) ); EXIT
      CASE "Picture"; :setWindowIcon( QIcon( __hbqtImage( "images"    ) ) ); EXIT
      CASE "Text"   ; :setWindowIcon( QIcon( __hbqtImage( "text-file" ) ) ); EXIT
      ENDSWITCH

      IF Empty( ::aPosAndSize )
         SWITCH ::type()
         CASE "Banner" ; :setMaximumWidth( ::oParent:widget():viewport():width() ) ; :resize( ::oParent:widget():viewport():width(), 80 ); EXIT
         CASE "Figure" ; :resize( 400, 100 ); EXIT
         CASE "Graph"  ; :resize( 400, 200 ); EXIT
         CASE "Browser"; :resize( 400, 300 ); EXIT
         CASE "Picture"; :resize( 400, 300 ); EXIT
         CASE "Text"   ; :resize( 400, 300 ); EXIT
         ENDSWITCH
      ELSE
         :move( ::aPosAndSize[ 1 ], ::aPosAndSize[ 2 ] )
         :resize( ::aPosAndSize[ 3 ], ::aPosAndSize[ 4 ] )
      ENDIF
   ENDWITH

   IF ::nDuration > 0 .AND. ::Type() != "Text"
      WITH OBJECT ::oTimerFetch := QTimer( ::oSubWindow )
         :setInterval( ::nDuration * 1000 )
         :connect( "timeout()", {|| ::fetchData(), .F. } )
      ENDWITH
      ::oTimerFetch:start()
   ENDIF

   WITH OBJECT ::oTimerPull := QTimer( ::oSubWindow )
      :setInterval( 1000 )
      :connect( "timeout()", {|| ::pullData(), .F. } )
   ENDWITH
   ::oTimerPull:start()

   ::oSubWindow:show()

   RETURN Self


METHOD HbQtDashboardObject:buildText()
   LOCAL oFont, oLay
   LOCAL aAttrbs := ::attributes()

   ASize( aAttrbs, DBRD_ATTRB_TEXT_NOVRBLS )
   IF ! HB_ISCHAR( aAttrbs[ DBRD_ATTRB_TEXT_FONTNAME ] ) .OR. Empty( aAttrbs[ DBRD_ATTRB_TEXT_FONTNAME ] )
      aAttrbs[ DBRD_ATTRB_TEXT_FONTNAME ] := "Courier New"
   ENDIF
   IF ! HB_ISNUMERIC( aAttrbs[ DBRD_ATTRB_TEXT_FONTSIZE ] )
      aAttrbs[ DBRD_ATTRB_TEXT_FONTSIZE ] := 18
   ENDIF
   ::oWidget := QWidget()
   WITH OBJECT oLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
   ENDWITH
   WITH OBJECT ::oTextEdit := QTextEdit()
      :setAlignment( Qt_AlignVCenter + Qt_AlignHCenter )
      oFont := QFont( aAttrbs[ DBRD_ATTRB_TEXT_FONTNAME ], aAttrbs[ DBRD_ATTRB_TEXT_FONTSIZE ] )
      oFont:setBold( .T. )
      :setFont( oFont )
      :setReadOnly( .T. )
   ENDWITH
   WITH OBJECT ::oGetEdit := QLineEdit()
      :connect( "returnPressed()", {|| ::manageUDF() } )
      :connect( "textChanged(QString)", {|cText| ::manageUDF( cText ) } )
   ENDWITH
   WITH OBJECT ::oWidget
      :setLayout( oLay )
   ENDWITH
   oLay:addWidget( ::oTextEdit )
   oLay:addWidget( ::oGetEdit )

   IF aAttrbs[ DBRD_ATTRB_TEXT_COLORS ] != NIL
      ::oTextEdit:setStyleSheet( __hbqtRgbStringFromColors( aAttrbs[ DBRD_ATTRB_TEXT_COLORS ] ) )
   ENDIF
   IF HB_ISLOGICAL( aAttrbs[ DBRD_ATTRB_TEXT_NOWRAP ] ) .AND. aAttrbs[ DBRD_ATTRB_TEXT_NOWRAP ]
      ::oTextEdit:setWrapMode( QTextEdit_NoWrap )
   ENDIF
   IF ! HB_ISLOGICAL( aAttrbs[ DBRD_ATTRB_TEXT_KEEPAPPENDING ] )
      aAttrbs[ DBRD_ATTRB_TEXT_KEEPAPPENDING ] := .F.
   ENDIF
   IF HB_ISNUMERIC( aAttrbs[ DBRD_ATTRB_TEXT_CLEARAFTERMS ] )
      WITH OBJECT ::oTimerClear := QTimer( ::oWidget )
         :setInterval( aAttrbs[ DBRD_ATTRB_TEXT_CLEARAFTERMS ] )
         :connect( "timeout()", {|| ::oTextEdit:clear(), __hbqtPushObjectData( ::nID, NIL ) } )
         :start()
      ENDWITH
   ENDIF
   WITH OBJECT ::oGetEditTimer := QTimer( ::oGetEdit )
      :setInterval( 500 )
      :connect( "timeout()", {|| ::manageUDF() } )
      :start()
   ENDWITH

   RETURN Self


METHOD HbQtDashboardObject:manageUDF( cText )
   HB_SYMBOL_UNUSED( cText )

   IF ::oGetEdit:text() == ::oGetEditText
      IF Seconds() - ::nSeconds > 5
         ::oGetEdit:selectAll()
         ::nSeconds := Seconds()
      ENDIF
   ELSE
      ::oGetEditText := ::oGetEdit:text()
      ::xData := Eval( ::dataBlock(), ::oGetEditText )
      IF HB_ISSTRING( ::xData )
         ::update( ::xData )
         IF ! Empty( ::xData )           // Start Afresh
            ::oGetEdit:selectAll()
         ENDIF
      ENDIF
      ::nSeconds := Seconds()
   ENDIF

   RETURN .T.


METHOD HbQtDashboardObject:buildPicture()

   WITH OBJECT ::oWidget := QLabel()
      :setAlignment( Qt_AlignVCenter + Qt_AlignHCenter )
      :connect( QEvent_Resize, {|| ::oWidget:setPixmap( QPixmap() ) } )
   ENDWITH
   WITH OBJECT ::oTimerSpeed := QTimer( ::oWidget )
      IF HB_ISARRAY( ::attributes() ) .AND. Len( ::attributes() ) >= 1 .AND. HB_ISNUMERIC( ::attributes()[ 1 ] )
         :setInterval( ::attributes()[ 1 ] )
      ELSE
         :setInterval( 5000 )
      ENDIF
      :connect( "timeout()", {|| ::update() } )
   ENDWITH
   ::oTimerSpeed:start()

   RETURN Self


METHOD HbQtDashboardObject:buildGraph()
   LOCAL aTkns

   ASize( ::attributes(), 2 )

   WITH OBJECT ::oHbQtWidget := HbQtCharts():new()
      :enableLegend( .F. )

      IF HB_ISARRAY( ::attributes() )
         IF ! Empty( ::aAttrbs[ 1 ] )
            :setTitle( ::attributes()[ 1 ] )
         ENDIF
         IF ! Empty( ::aAttrbs[ 2 ] )
            aTkns := Lower( ::aAttrbs[ 2 ] )

            IF "notitle" $ aTkns
               :enableTitle( .F. )
            ENDIF
            IF "notoolbar" $ aTkns
               :enableToolbar( .F. )
            ENDIF
            IF "typepie" $ aTkns
               :setType( HBQT_CHART_PIE )
            ENDIF
            IF "showlegend" $ aTkns
               :enableLegend( .T. )
            ENDIF
            IF "noshadows" $ aTkns
               :enableShadows( .F. )
            ENDIF
            IF "nolabels" $ aTkns
               :enableLabels( .F. )
            ENDIF
            IF "novalues" $ aTkns
               :enableValues( .F. )
            ENDIF
            IF "showyvalues" $ aTkns
               :enableYValues( .T. )
            ENDIF
         ENDIF
      ENDIF
      :create()
   ENDWITH

   ::oWidget := ::oHbQtWidget:oWidget

   RETURN Self


METHOD HbQtDashboardObject:buildFigure()

   ::oWidget := QLCDNumber( 15 )
   IF HB_ISARRAY( ::attributes() ) .AND. Len( ::attributes() ) >= 1
      ::oWidget:setStyleSheet( __hbqtRgbStringFromColors( ::attributes()[ 1 ] ) )
   ENDIF

   RETURN Self


METHOD HbQtDashboardObject:buildBanner()
   LOCAL oFont
   LOCAL aAttrbs := ::attributes()

   ASize( aAttrbs, 3 )
   IF ! HB_ISNUMERIC( aAttrbs[ 2 ] )
      aAttrbs[ 2 ] := 250
   ENDIF
   IF ! HB_ISNUMERIC( aAttrbs[ 3 ] )
      aAttrbs[ 3 ] := 36
   ENDIF
   WITH OBJECT ::oWidget := QLabel()
      :setAlignment( Qt_AlignVCenter + Qt_AlignRight )
      oFont := QFont( "Courier New", aAttrbs[ 3 ] )
      oFont:setBold( .T. )
      :setFont( oFont )
   ENDWITH
   IF HB_ISARRAY( aAttrbs ) .AND. Len( aAttrbs ) >= 1
      ::oWidget:setStyleSheet( __hbqtRgbStringFromColors( aAttrbs[ 1 ] ) )
   ENDIF

   ::nCharWidth := ::oWidget:fontMetrics():averageCharWidth()
   ::nHotPos := 1
   WITH OBJECT ::oTimerSpeed := QTimer( ::oWidget )
      :setInterval( aAttrbs[ 2 ] )
      :connect( "timeout()", {|| ::update() } )
   ENDWITH
   ::oTimerSpeed:start()

   ::oWidget:connect( QEvent_Resize, {|| ::oTimerSpeed:stop(), ::oWidget:setText( "" ), ::oTimerSpeed:start(), .T. } )
   ::oWidget:connect( QEvent_Move  , {|| ::oTimerSpeed:stop(), ::oWidget:setText( "" ), ::oTimerSpeed:start(), .T. } )

   RETURN Self


METHOD HbQtDashboardObject:buildBrowser()
   LOCAL oBrowse, aAttrb, xVrb, cType, nIndex, oCol

   IF ! HB_ISARRAY( ::aAttrbs ) .OR. Empty( ::aAttrbs )
      ::aAttrbs := {}
      FOR EACH xVrb IN ::xData[ 1 ]
         nIndex :=  xVrb:__enumIndex()
         cType  := ValType( xVrb )
         AAdd( ::aAttrbs, { nIndex, "Fld_" + hb_ntos( xVrb:__enumIndex() ), cType, iif( cType == "N", Len( Str( xVrb ) ), iif( cType == "D", 8, iif( cType == "L", 1, Len( xVrb ) ) ) ) } )
      NEXT
   ENDIF

   WITH OBJECT oBrowse := HbQtBrowseNew( 5, 5, 10, 10 )
      :cargo := { AClone( ::xData ), 1 }

      :GoTopBlock    := {|| oBrowse:cargo[ 2 ] := 1 }
      :GoBottomBlock := {|| oBrowse:cargo[ 2 ] := Len( oBrowse:cargo[ 1 ] ) }
      :SkipBlock     := {| nSkip, nPos | nPos := oBrowse:cargo[ 2 ], ;
                                 oBrowse:cargo[ 2 ] := iif( nSkip > 0, Min( Len( oBrowse:cargo[ 1 ] ), oBrowse:cargo[ 2 ] + nSkip ), ;
                                    Max( 1, oBrowse:cargo[ 2 ] + nSkip ) ), oBrowse:cargo[ 2 ] - nPos }

      :posBlock      := {| | oBrowse:cargo[ 2 ] * 100 / Len( oBrowse:cargo[ 1 ] ) }
      :goPosBlock    := {|i| oBrowse:cargo[ 2 ] := Int( i * Len( oBrowse:cargo[ 1 ] ) / 100 ) }
      :phyPosBlock   := {| | oBrowse:cargo[ 2 ] * 100 / Len( oBrowse:cargo[ 1 ] ) }

      FOR EACH aAttrb IN ::attributes()
         :AddColumn( oCol := HbQtColumnNew( aAttrb[ 2 ], {|| oBrowse:cargo[ 1 ][ oBrowse:cargo[ 2 ], __getColumnNumber( aAttrb[ 1 ] ) ] } ) )
         IF Len( aAttrb ) >= 6 .AND. HB_ISSTRING( aAttrb[ 6 ] )
            oCol:picture := aAttrb[ 6 ]
         ENDIF
      NEXT
      :Configure()

      :editEnabled         := .F.
      :verticalScrollbar   := .T.
      :horizontalScrollbar := .F.
   ENDWITH

   ::oHbQtWidget := oBrowse
   ::oWidget := oBrowse:oWidget

   RETURN Self


METHOD HbQtDashboardObject:collectAttributes()
   LOCAL s
   LOCAL cAttrbs := "{'"
   LOCAL oWgt := ::oHbQtWidget

   SWITCH ::type()
   CASE "Graph"
      cAttrbs += oWgt:title() + "','"
      cAttrbs += iif( oWgt:Type() == HBQT_CHART_PIE, "typePie"    , "typeBar"   ) + ","
      cAttrbs += iif( oWgt:isTitleEnabled()        , "showTitle"  , "noTitle"   ) + ","
      cAttrbs += iif( oWgt:isToolbarEnabled()      , "showToolbar", "noToolbar" ) + ","
      cAttrbs += iif( oWgt:isLegendEnabled()       , "showLegend" , "noLegend"  ) + ","
      cAttrbs += iif( oWgt:isShadowsEnabled()      , "showShadows", "noShadows" ) + ","
      cAttrbs += iif( oWgt:isLabelsEnabled()       , "showLabels" , "noLabels"  ) + ","
      cAttrbs += iif( oWgt:isValuesEnabled()       , "showValues" , "noValues"  ) + ","
      cAttrbs += iif( oWgt:isValuesOnYEnabled()    , "showYValues", "noYValues" ) + ","
      cAttrbs += "'}"

      s := SubStr( ::cAttrbs, 1, RAt( "~", ::cAttrbs ) - 1 )
      s := SubStr( s, 1, RAt( "~", s ) )
      cAttrbs := s + cAttrbs + "~"
      ::cAttrbs := cAttrbs
      EXIT
   ENDSWITCH

   RETURN Self


STATIC FUNCTION __getColumnNumber( nNumber )
   RETURN nNumber


STATIC FUNCTION __getAnObjectID()
   STATIC nId := 100000
   hb_mutexLock( hMutex )
   nID++
   hb_mutexUnlock( hMutex )
   RETURN nID


STATIC FUNCTION __fetchObjectData( bBlock, nID )
   LOCAL xData := Eval( bBlock )
   hb_mutexLock( hMutex )
      hData[ nID ] := iif( HB_ISARRAY( xData ), AClone( xData ), xData )
   hb_mutexUnLock( hMutex )
   RETURN xData


FUNCTION __hbqtPushObjectData( nID, xData )

   hb_mutexLock( hMutex )
      hData[ nID ] := xData
   hb_mutexUnLock( hMutex )

   RETURN NIL

/*----------------------------------------------------------------------*/

