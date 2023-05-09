      /*
 * $Id$
 */

/*
 * Copyright 2010-2023 Pritpal Bedi <bedipritpal@hotmail.com>
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
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                            Harbour-Qt IDE
 *
 *                  Pritpal Bedi <bedipritpal@hotmail.com>
 *                               28Dec2009
 */
/*----------------------------------------------------------------------*/

#include "hbide.ch"
#include "common.ch"
#include "hbclass.ch"
#include "xbp.ch"
#include "appevent.ch"
#include "hbqtgui.ch"


#define __QEvent_WindowStateChange__              2001
#define __QEvent_Hide__                           2002
#define __qSystemTrayIcon_activated__             2003
#define __qSystemTrayIcon_show__                  2004
#define __qSystemTrayIcon_close__                 2005
#define __qTimer_timeOut__                        2006
#define __buttonViewTabbed_clicked__              2007
#define __x_mdiArea_subWindowActivated__          2008
#define __buttonViewOrganized_clicked__           2009
#define __buttonSaveLayout_clicked__              2010
#define __buttonViewCascaded_clicked__            2011
#define __buttonViewTiled_clicked__               2012
#define __buttonViewMaximized_clicked__           2013
#define __buttonViewStackedVert_clicked__         2014
#define __buttonViewStackedHorz_clicked__         2015
#define __buttonViewZoomedIn_clicked__            2016
#define __buttonViewZoomedOut_clicked__           2017
#define __mdiArea_subWindowActivated__            2018
#define __editWidget_dragEnterEvent__             2019
#define __editWidget_dragMoveEvent__              2020
#define __editWidget_dropEvent__                  2021
#define __mdiSubWindow_windowStateChanged__       2022
#define __projectTree_dragEnterEvent__            2023
#define __projectTree_dropEvent__                 2024
#define __dockSkltnsTree_visibilityChanged__      2025
#define __oFuncDock_visibilityChanged__           2026
#define __qHelpBrw_contextMenuRequested__         2027
#define __dockHelpDock_visibilityChanged__        2028
#define __outputConsole_contextMenuRequested__    2029
#define __dockThemes_visibilityChanged__          2030
#define __dockProperties_visibilityChanged__      2031
#define __dockFindInFiles_visibilityChanged__     2032
#define __dockDocViewer_visibilityChanged__       2033
#define __dockDocWriter_visibilityChanged__       2034
#define __docFunctions_visibilityChanged__        2035
#define __docEnvironments_visibilityChanged__     2036
#define __docSkeletons_visibilityChanged__        2037
#define __dockSourceThumbnail_visibilityChanged__ 2038
#define __dockFormat_visibilityChanged__          2041
#define __dockCuiEd_visibilityChanged__           2042
#define __dockUISrc_visibilityChanged__           2043
#define __dockFunctionsMap_visibilityChanged__    2044
#define __dockDebugger_visibilityChanged__        2045


CLASS IdeDocks INHERIT IdeObject

   DATA   nPass                                   INIT   0
   DATA   aPanels                                 INIT   {}
   DATA   aMdiBtns                                INIT   {}
   DATA   aBtnLines                               INIT   {}
   DATA   aBtnDocks                               INIT   {}
   DATA   oBtnTabClose
   DATA   aViewsInfo                              INIT   {}
   DATA   qTBtnClose
   DATA   lChanging                               INIT   .f.
   DATA   qTimer
   DATA   nPrevWindowState                        INIT   Qt_WindowNoState
   DATA   lSystemTrayAvailable                    INIT   .f.
   DATA   lMinimizeInSystemTray                   INIT   .f.  /* TODO: make it user definable */
   DATA   qAct1
   DATA   qAct2
   DATA   cOldView                                INIT   ""

   METHOD init( oIde )
   METHOD create( oIde )
   METHOD destroy()
   METHOD execEvent( nEvent, p, p1 )
   METHOD setView( cView )
   METHOD buildHelpWidget()
   METHOD buildSkeletonWidget()
   METHOD buildDialog()
   METHOD buildViewWidget( cView )
   METHOD buildStackedWidget()
   METHOD buildSearchReplaceWidget()
   METHOD buildDockWidgets()
   METHOD buildProjectTree()
   METHOD buildEditorTree()
   METHOD buildFuncList()
   METHOD buildFunctionsDock()
   METHOD buildSkeletonsTree()
   METHOD buildCompileResults()
   METHOD buildLinkResults()
   METHOD buildOutputResults()
   METHOD buildFindInFiles()
   METHOD buildThemesDock()
   METHOD buildPropertiesDock()
   METHOD buildEnvironDock()
   METHOD buildDocViewer()
   METHOD buildDocWriter()
   METHOD outputDoubleClicked( lSelected )
   METHOD buildStatusBar()
   METHOD setStatusText( nPart, xValue )
   METHOD getMarkWidget( nIndex )
   METHOD dispEnvironment( cEnvironment )
   METHOD disblePanelButton( qTBtn )
   METHOD getADockWidget( nAreas, cObjectName, cWindowTitle, nFlags )
   METHOD getPanelIcon( cView )
   METHOD animateComponents( nMode )
   METHOD buildSourceThumbnail()
   METHOD buildUpDownWidget()
   METHOD buildSystemTray()
   METHOD showDlgBySystemTrayIconCommand()
   METHOD setViewInitials()
   METHOD getEditorPanelsInfo()
   METHOD restPanelsGeometry()
   METHOD savePanelsGeometry()
   METHOD stackVertically()
   METHOD stackHorizontally()
   METHOD stackMaximized()
   METHOD stackZoom( nMode )
   METHOD restState( nMode )
   METHOD setButtonState( cButton, lChecked )
   METHOD buildFormatWidget()
   METHOD hideAllDocks()
   METHOD buildCuiEdWidget()
   METHOD buildUISrcDock()
   METHOD buildFunctionsMapDock()
   METHOD buildDebuggerDock()
   METHOD showSelectedTextToolbar( oEdit )

   ENDCLASS


METHOD IdeDocks:init( oIde )
   ::oIde := oIde
   RETURN Self


METHOD IdeDocks:create( oIde )
   DEFAULT oIde TO ::oIde
   ::oIde := oIde
   RETURN Self


METHOD IdeDocks:hideAllDocks()
   IF .T.
      // Left
      ::oDockPT                  : hide()
      ::oDockED                  : hide()
      ::oSkltnsTreeDock          : hide()
      // Right
      ::oEnvironDock             : hide()
      ::oPropertiesDock          : hide()
      ::oThemesDock              : hide()
      ::oDocViewDock             : hide()
      ::oDocWriteDock            : hide()
      ::oFindDock                : hide()
      ::oFunctionsDock           : hide()
      ::oSkeltnDock              : hide()
      ::oHelpDock                : hide()
      ::oFuncDock                : hide()
      ::oSourceThumbnailDock     : hide()
      ::oFormatDock              : hide()
      ::oCuiEdDock               : hide()
      ::oUiSrcDock               : hide()
      // Bottom
      ::oDockB2                  : hide()
      ::oDockB1                  : hide()
      ::oDockB                   : hide()
   ENDIF
   RETURN Self


METHOD IdeDocks:destroy()
   LOCAL qTmp
   FOR EACH qTmp IN ::oIde:aViews
      qTmp:oTabWidget:oWidget:disconnect( QEvent_DragEnter )
      qTmp:oTabWidget:oWidget:disconnect( QEvent_DragMove )
      qTmp:oTabWidget:oWidget:disconnect( QEvent_Drop      )
   NEXT
   ::oDlg:oWidget                : disconnect( QEvent_WindowStateChange  )
   ::oDlg:oWidget                : disconnect( QEvent_Hide               )
   ::oIde:oProjRoot              := NIL
   ::oIde:oOpenedSources         := NIL
   ::oOutputResult:oWidget       : disconnect( "copyAvailable(bool)"     )
   ::oEnvironDock:oWidget        : disconnect( "visibilityChanged(bool)" )
   ::oPropertiesDock:oWidget     : disconnect( "visibilityChanged(bool)" )
   ::oThemesDock:oWidget         : disconnect( "visibilityChanged(bool)" )
   ::oDocViewDock:oWidget        : disconnect( "visibilityChanged(bool)" )
   ::oDocWriteDock:oWidget       : disconnect( "visibilityChanged(bool)" )
   ::oFindDock:oWidget           : disconnect( "visibilityChanged(bool)" )
   ::oFunctionsDock:oWidget      : disconnect( "visibilityChanged(bool)" )
   ::oSkeltnDock:oWidget         : disconnect( "visibilityChanged(bool)" )
   ::oHelpDock:oWidget           : disconnect( "visibilityChanged(bool)" )
   ::oFuncDock:oWidget           : disconnect( "visibilityChanged(bool)" )
   ::oSourceThumbnailDock:oWidget: disconnect( "visibilityChanged(bool)" )
   ::oFormatDock:oWidget         : disconnect( "visibilityChanged(bool)" )
   ::oCuiEdDock:oWidget          : disconnect( "visibilityChanged(bool)" )
   ::oUiSrcDock:oWidget          : disconnect( "visibilityChanged(bool)" )
#if 0  /* Not Implemented */
   ::oDockPT:oWidget             : disconnect( "visibilityChanged(bool)" )
   ::oDockED:oWidget             : disconnect( "visibilityChanged(bool)" )
   ::oDockB2:oWidget             : disconnect( "visibilityChanged(bool)" )
#endif
   IF !empty( ::oSys )
      ::oIde:oSys                : disconnect( "activated(QSystemTrayIcon::ActivationReason)" )
      IF HB_ISOBJECT( ::qAct1 )
         ::qAct1                 : disconnect( "triggered(bool)"         )
         ::qAct2                 : disconnect( "triggered(bool)"         )
      ENDIF
      ::oIde:oSys := NIL
      ::qAct1     := NIL
      ::qAct2     := NIL
   ENDIF
   IF !empty( ::qTimer )
      ::qTimer:disconnect( "timeout()" )
      ::qTimer:stop()
      ::qTimer := NIL
   ENDIF
   FOR EACH qTmp IN ::aPanels
      qTmp:disconnect( "clicked()" )
      qTmp := NIL
   NEXT
   FOR EACH qTmp IN ::aMdiBtns
      qTmp:disconnect( "clicked()" )
      qTmp := NIL
   NEXT
   FOR EACH qTmp IN ::oIde:aMarkTBtns
      qTmp:disconnect( "clicked()" )
      qTmp := NIL
   NEXT
   FOR EACH qTmp IN ::oIde:aMdies
      qTmp:disconnect( "windowStateChanged(Qt::WindowStates,Qt::WindowStates)" )
      qTmp := NIL
   NEXT
   IF HB_ISOBJECT( ::qMdiToolBar )
      ::qMdiToolBar:destroy()
      ::qMdiToolBar := NIL
   ENDIF
   IF HB_ISOBJECT( ::qMdiToolBarL )
      ::qMdiToolBarL:destroy()
      ::qMdiToolBarL := NIL
   ENDIF
   RETURN Self


METHOD IdeDocks:getEditorPanelsInfo()
   LOCAL k, j, b_, a_:= {}
   LOCAL qLst := ::oStackedWidget:oWidget:subWindowList( QMdiArea_StackingOrder )  /* The order tabs are visible */
   FOR k := 1 TO qLst:count()
#if 0
      cView := qLst:at( k - 1 ):objectName()
      ascan( ::aViewsInfo, {|e_| e_[ 1 ] == cView } )
#else
      j := k
#endif
      b_:= ::aViewsInfo[ j ]
      aadd( a_, b_[ 1 ] + "," + ;
                iif( empty( b_[ 2 ] ), "",  hbide_nArray2String( { b_[ 2 ]:x(), b_[ 2 ]:y(), b_[ 2 ]:width(), b_[ 2 ]:height() } ) ) + "," + ;
                hb_ntos( b_[ 3 ] ) + "," + hb_ntos( b_[ 4 ] ) + "," + ;
                hb_ntos( ::oStackedWidget:oWidget:viewMode() ) + "," + hb_ntos( ::oINI:nEditsViewStyle ) + ","   ;
          )
   NEXT
   RETURN a_


METHOD IdeDocks:buildDialog()
   LOCAL s, aSize, a_, x_, lNew := .f.

   WITH OBJECT ::oIde:oDlg := XbpDialog():new()
      :icon     := hbide_image( "hbide" )
      :title    := "Harbour IDE"
      :create( , , , , , .f. )
      :oWidget:setStyleSheet( GetStyleSheet( "QMainWindow", ::nAnimantionMode ) )
      :close := {|| hbide_setClose( hbide_getYesNo( "HbIDE is about to be closed!", "Are you sure?" ) ), ;
                                                                   PostAppEvent( xbeP_Close, , , ::oDlg ) }
      :setDockOptions( QMainWindow_AllowTabbedDocks + QMainWindow_AllowNestedDocks + QMainWindow_AnimatedDocks )
      :setTabShape( ::oINI:nDocksTabShape )
      :setTabPosition( Qt_RightDockWidgetArea , ::oINI:nDocksRightTabPos  )
      :setTabPosition( Qt_BottomDockWidgetArea, ::oINI:nDocksBottomTabPos )
      :setTabPosition( Qt_LeftDockWidgetArea  , ::oINI:nDocksLeftTabPos   )
      :setTabPosition( Qt_TopDockWidgetArea   , ::oINI:nDocksTopTabPos    )
      :setCorner( Qt_BottomLeftCorner , Qt_LeftDockWidgetArea  )
      :setCorner( Qt_BottomRightCorner, Qt_RightDockWidgetArea )
      :oWidget:resize( 1000,570 )
   ENDWITH 
   ::oIde:oDa := ::oDlg:drawingArea
   ::oParts:buildParts()
   SetAppWindow( ::oDlg )
   // Center on Desktop and decorate
   aSize := AppDesktop():currentSize()
   ::oDlg:setPos( { ( aSize[ 1 ] - ::oDlg:currentSize()[ 1 ] ) / 2, ;
                    ( aSize[ 2 ] - ::oDlg:currentSize()[ 2 ] ) / 2 } )
   ::oIde:setPosAndSizeByIniEx( ::oDlg:oWidget, ::oINI:cMainWindowGeometry )
   /* StatusBar */
   ::buildStatusBar()
   /* Menubar */
   ::oAC:buildMdiToolbar()
   ::oParts:addWidget( IDE_PART_EDITOR, ::oAC:qMdiToolbar:oWidget   , 0, 0, 1, 2 )
   ::oAC:buildMdiToolbarLeft()
   ::oParts:addWidget( IDE_PART_EDITOR, ::oAC:qMdiToolbarL:oWidget  , 1, 0, 1, 1 )
   ::buildStackedWidget()
   ::oParts:addWidget( IDE_PART_EDITOR, ::oStackedWidget:oWidget    , 1, 1, 1, 1 )
   ::buildSearchReplaceWidget()
   ::oParts:addWidget( IDE_PART_EDITOR, ::oSearchReplace:oUI:oWidget, 2, 0, 1, 2 )
   /* Normalize Views */
   FOR EACH s IN ::oINI:aViews
      a_:= hb_aTokens( s, "," )
      asize( a_, 6 )
      IF ! empty( a_[ 2 ] )
         a_[ 2 ] := hbide_array2Rect( hbide_string2nArray( a_[ 2 ] ) )
      ENDIF
      DEFAULT a_[ 3 ] TO "0"
      DEFAULT a_[ 4 ] TO "0"
      DEFAULT a_[ 5 ] TO hb_ntos( QMdiArea_TabbedView )
      DEFAULT a_[ 6 ] TO "0"
      a_[ 3 ] := val( a_[ 3 ] )
      a_[ 4 ] := val( a_[ 4 ] )
      a_[ 5 ] := val( a_[ 5 ] )
      a_[ 6 ] := val( a_[ 6 ] )
      aadd( ::aViewsInfo, a_ )
   NEXT
   IF ascan( ::aViewsInfo, {|e_| e_[ 1 ] == "Main" } ) == 0
      lNew := .t.
      hb_ains( ::aViewsInfo, 1, { "Main", NIL, 0, 0, QMdiArea_TabbedView, 0 }, .t. )
   ENDIF
   /* View Panels */
   x_:= aclone( ::aViewsInfo )
   FOR EACH a_ IN ::aViewsInfo
      ::buildViewWidget( a_[ 1 ] )
   NEXT
   ::setView( "Main" )
   IF lNew
      ::oStackedWidget:setViewMode( QMdiArea_TabbedView )
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_MAXIMIZED
      ::stackMaximized()
   ELSE
      IF x_[ 1,5 ] == QMdiArea_TabbedView
         ::oStackedWidget:setViewMode( QMdiArea_TabbedView )
      ENDIF
      IF x_[ 1,6 ] == HBPMDI_STYLE_TILED
         ::oStackedWidget:tileSubWindows()
      ELSEIF x_[ 1,6 ] == HBPMDI_STYLE_CASCADED
         ::oStackedWidget:cascadeSubWindows()
      ELSEIF x_[ 1,6 ] == HBPMDI_STYLE_MAXIMIZED
         ::oINI:nEditsViewStyle  := HBPMDI_STYLE_MAXIMIZED
         ::stackMaximized()
      ELSEIF x_[ 1,6 ] == HBPMDI_STYLE_TILEDVERT
         ::oINI:nEditsViewStyle  := HBPMDI_STYLE_TILEDVERT
         ::stackVertically()
      ELSEIF x_[ 1,6 ] == HBPMDI_STYLE_TILEDHORZ
         ::oINI:nEditsViewStyle  := HBPMDI_STYLE_TILEDHORZ
         ::stackHorizontally()
      ELSE
         FOR EACH a_ IN x_
            IF !empty( a_[ 2 ] )
               ::oIde:aMdies[ a_:__enumIndex() ]:setGeometry( a_[ 2 ] )
            ENDIF
            ::oIde:aMdies[ a_:__enumIndex() ]:setWindowState( a_[ 4 ] )
         NEXT
      ENDIF
   ENDIF
   WITH OBJECT ::oDlg
      :oWidget:connect( QEvent_WindowStateChange, {|e| ::execEvent( __QEvent_WindowStateChange__, e ) } )
      :oWidget:connect( QEvent_Hide             , {|e| ::execEvent( __QEvent_Hide__             , e ) } )
   ENDWITH
   ::buildSystemTray()
   RETURN Self


METHOD IdeDocks:buildDockWidgets()
   IF .T.
      ::buildProjectTree()
      ::buildEditorTree()
      ::buildFuncList()
      ::buildSkeletonsTree()
      ::buildHelpWidget()
      ::buildSkeletonWidget()
      ::buildFindInFiles()
      ::buildThemesDock()
      ::buildPropertiesDock()
      ::buildEnvironDock()
      ::buildCompileResults()
      ::buildLinkResults()
      ::buildOutputResults()
      ::buildDocViewer()
      ::buildDocWriter()
      ::buildFunctionsDock()
      ::buildSourceThumbnail()
      ::buildUpDownWidget()
      ::buildFormatWidget()
      ::buildCuiEdWidget()
      ::buildUiSrcDock()
      ::buildFunctionsMapDock()
      ::buildDebuggerDock()
      /* Bottom Docks */
      ::oDlg:oWidget:tabifyDockWidget( ::oDockB:oWidget              , ::oDockB1:oWidget              )
      ::oDlg:oWidget:tabifyDockWidget( ::oDockB1:oWidget             , ::oDockB2:oWidget              )
   ENDIF
   RETURN Self


METHOD IdeDocks:buildSystemTray()
   IF empty( ::oSys )
      WITH OBJECT ::oIde:oSys := QSystemTrayIcon( ::oDlg:oWidget )
         IF ( ::lSystemTrayAvailable := :isSystemTrayAvailable() ) .AND. ::lMinimizeInSystemTray
            :setIcon( QIcon( hbide_image( "hbide" ) ) )
            :connect( "activated(QSystemTrayIcon::ActivationReason)", {|p| ::execEvent( __qSystemTrayIcon_activated__, p ) } )
            //
            ::oIde:oSysMenu := QMenu()
            ::qAct1 := ::oSysMenu:addAction( QIcon( hbide_image( "fullscreen" ) ), "&Show" )
            ::oSysMenu:addSeparator()
            ::qAct2 := ::oSysMenu:addAction( QIcon( hbide_image( "exit" ) ), "&Exit" )
            //
            ::qAct1:connect( "triggered(bool)", {|| ::execEvent( __qSystemTrayIcon_show__  ) } )
            ::qAct2:connect( "triggered(bool)", {|| ::execEvent( __qSystemTrayIcon_close__ ) } )
            //
            :setContextMenu( ::oSysMenu )
            :hide()
            :setToolTip( "Harbour's Integrated Development Environment (v1.0)" )
         ENDIF
      ENDWITH 
   ENDIF
   RETURN NIL


METHOD IdeDocks:execEvent( nEvent, p, p1 )
   LOCAL qEvent, qMime, qList, qUrl, i, n, aMenu, oEditor
   IF ::lQuitting
      RETURN Self
   ENDIF
   SWITCH nEvent
   CASE __dockDebugger_visibilityChanged__
      IF p; ::oIde:oDebugger:show(); ENDIF
      IF ! p .AND. ! p1:isVisible()
         p1:raise()
      ENDIF
      EXIT
   CASE __dockFunctionsMap_visibilityChanged__
      IF p; ::oFM:show(); ENDIF
      IF ! p .AND. ! p1:isVisible()
         p1:raise()
      ENDIF
      EXIT
   CASE __dockUISrc_visibilityChanged__
      IF p; ::oUiS:show(); ENDIF
      IF ! p .AND. ! p1:isVisible()
         p1:raise()
      ENDIF
      EXIT
   CASE __dockCuiEd_visibilityChanged__
      IF p; ::oCUI:show(); ENDIF
      IF ! p .AND. ! p1:isVisible()
         p1:raise()
      ENDIF
      EXIT
   CASE __dockFormat_visibilityChanged__
      IF p; ::oFmt:show(); ENDIF
      IF ! p .AND. ! p1:isVisible()
         p1:raise()
      ENDIF
      EXIT
   CASE __dockSourceThumbnail_visibilityChanged__
      IF p; ::oEM:showThumbnail(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockSkltnsTree_visibilityChanged__
      IF p; ::oSK:showTree(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockHelpDock_visibilityChanged__
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockDocViewer_visibilityChanged__
      IF p; ::oHL:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockDocWriter_visibilityChanged__
      IF p; ::oDW:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __oFuncDock_visibilityChanged__
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __docFunctions_visibilityChanged__
      IF p; ::oFN:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockProperties_visibilityChanged__
      IF p; ::oPM:fetchProperties(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __docEnvironments_visibilityChanged__
      IF p; ::oEV:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __docSkeletons_visibilityChanged__
      IF p; ::oSK:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockThemes_visibilityChanged__
      IF p; ::oTH:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   CASE __dockFindInFiles_visibilityChanged__
      IF p; ::oFF:show(); ENDIF
      IF !empty( p1 )
         IF ! p .AND. ! p1:isVisible()
            p1:raise()
         ENDIF
      ENDIF
      EXIT
   /* Miscellaneous */
   CASE __qHelpBrw_contextMenuRequested__
      hbide_popupBrwContextMenu( ::qHelpBrw, p )
      EXIT
   CASE __outputConsole_contextMenuRequested__
      aMenu := {}
      aadd( aMenu, { "Clear"     , {|| ::oOutputResult:oWidget:clear()     } } )
      aadd( aMenu, { "" } )
      aadd( aMenu, { "Select All", {|| ::oOutputResult:oWidget:selectAll() } } )
      aadd( aMenu, { "Copy"      , {|| ::oOutputResult:oWidget:copy()      } } )
      hbide_execPopup( aMenu, p, ::oOutputResult:oWidget )
      EXIT
   CASE QEvent_WindowStateChange
      ::nPrevWindowState := p:oldState()
      EXIT
   CASE QEvent_Hide
      IF ::lSystemTrayAvailable .AND. ::lMinimizeInSystemTray
         qEvent := p
         IF ! ::lChanging
            ::lChanging := .t.
            IF qEvent:spontaneous()
               IF empty( ::qTimer )
                  ::qTimer := QTimer()
                  ::qTimer:setSingleShot( .t. )
                  ::qTimer:setInterval( 250 )
                  ::qTimer:connect( "timeout()", {|| ::execEvent( __qTimer_timeOut__ ) } )
               ENDIF
               ::qTimer:start()
               qEvent:ignore()
            ENDIF
            ::lChanging := .f.
         ENDIF
      ENDIF
      EXIT
   CASE __qTimer_timeOut__
      ::oDlg:hide()
      ::oSys:setToolTip( ::oDlg:oWidget:windowTitle() )
      ::oSys:show()
      EXIT
   CASE __qSystemTrayIcon_close__
      PostAppEvent( xbeP_Close, NIL, NIL, ::oDlg )
      EXIT
   CASE __qSystemTrayIcon_show__
      ::showDlgBySystemTrayIconCommand()
      EXIT
   CASE __qSystemTrayIcon_activated__
      IF p == QSystemTrayIcon_Trigger
         ::showDlgBySystemTrayIconCommand()
      ELSEIF p == QSystemTrayIcon_DoubleClick
      ELSEIF p == QSystemTrayIcon_Context
      ELSEIF p == QSystemTrayIcon_MiddleClick
      ENDIF
      EXIT
   CASE __editWidget_dragMoveEvent__
   CASE __editWidget_dragEnterEvent__
      IF p:mimeData():hasUrls()
         p:acceptProposedAction()
      ENDIF
      EXIT
   CASE __editWidget_dropEvent__
      qMime := p:mimeData()
      IF qMime:hasUrls()
         qList := qMime:urls()
         FOR i := 0 TO qList:size() - 1
            qUrl := qList:at( i )
            IF hbide_isValidText( qUrl:toLocalFile() )
               ::oSM:editSource( hbide_pathToOSPath( qUrl:toLocalFile() ) )
            ENDIF
         NEXT
         p:setDropAction( Qt_IgnoreAction ) //Qt_CopyAction )
         p:accept()
         qList := NIL
      ENDIF
      qMime := NIL
      EXIT
   CASE __projectTree_dragEnterEvent__
      p:acceptProposedAction()
      EXIT
   CASE __projectTree_dropEvent__
      qMime := p:mimeData()
      IF qMime:hasUrls()
         qList := qMime:urls()
         FOR i := 0 TO qList:size() - 1
            qUrl := qList:at( i )
            IF hbide_sourceType( qUrl:toLocalFile() ) == ".hbp"
               ::oPM:loadProperties( qUrl:toLocalFile(), .f., .f., .t. )
            ENDIF
         NEXT
      ENDIF
      EXIT
   /* Left-toolbar actions */
   CASE __buttonViewTabbed_clicked__
      ::oStackedWidget:setViewMode( iif( ::oStackedWidget:viewMode() == QMdiArea_TabbedView, QMdiArea_SubWindowView, QMdiArea_TabbedView ) )
      EXIT
   CASE __buttonViewOrganized_clicked__
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_ORGANIZED
      ::restState()
      EXIT
   CASE __buttonSaveLayout_clicked__
      IF ::oINI:nEditsViewStyle == HBPMDI_STYLE_ORGANIZED
         ::savePanelsGeometry()
      ENDIF
      EXIT
   CASE __buttonViewTiled_clicked__
      ::oStackedWidget:tileSubWindows()
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_TILED
      EXIT
   CASE __buttonViewCascaded_clicked__
      ::oStackedWidget:cascadeSubWindows()
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_CASCADED
      EXIT
   CASE __buttonViewMaximized_clicked__
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_MAXIMIZED
      ::stackMaximized()
      EXIT
   CASE __buttonViewStackedVert_clicked__
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_TILEDVERT
      ::stackVertically()
      EXIT
   CASE __buttonViewStackedHorz_clicked__
      ::oINI:nEditsViewStyle  := HBPMDI_STYLE_TILEDHORZ
      ::stackHorizontally()
      EXIT
   CASE __buttonViewZoomedIn_clicked__
      ::stackZoom( +1 )
      EXIT
   CASE __buttonViewZoomedOut_clicked__
      ::stackZoom( -1 )
      EXIT
   /* Ends: MDI actions */
   CASE __mdiSubWindow_windowStateChanged__
      IF ! empty( ::oIde:aMdies )
         IF ( n := ascan( ::oIde:aMdies, {|o| o == p } ) )  > 0
            ::aViewsInfo[ n, 3 ] := p1[ 1 ]
            ::aViewsInfo[ n, 4 ] := p1[ 2 ]
         ENDIF
         IF p1[ 2 ] >= 8 .AND. !( ::cWrkView == p:objectName() )
            ::setView( p:objectName() )
            IF ! Empty( oEditor := ::oEM:getEditorCurrent() )
               WITH OBJECT oEditor
                  :refresh()
               ENDWITH
               ::oUpDn:show()
               ::showSelectedTextToolbar()
            ENDIF
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Self


METHOD IdeDocks:restState( nMode )
   LOCAL qMdi
   HB_SYMBOL_UNUSED( nMode )
   FOR EACH qMdi IN ::oIde:aMdies
      qMdi:setWindowState( Qt_WindowNoState )
   NEXT
   ::restPanelsGeometry()
   RETURN Self


METHOD IdeDocks:stackMaximized()
   LOCAL qMdi
   LOCAL qObj := ::oStackedWidget:oWidget:activeSubWindow()
   FOR EACH qMdi IN ::oIde:aMdies
      qMdi:setWindowState( Qt_WindowMaximized )
   NEXT
   ::oStackedWidget:oWidget:setActiveSubWindow( qObj )
   RETURN Self


METHOD IdeDocks:stackZoom( nMode )
   LOCAL qMdi, nT, nL, nH, nW, qRect
   HB_SYMBOL_UNUSED( nMode )
   IF ::oINI:nEditsViewStyle == 4 .OR. ::oINI:nEditsViewStyle == 5
      IF ::oINI:nEditsViewStyle == 4
         nT := 0
         FOR EACH qMdi IN ::oIde:aMdies
            qRect := qMdi:geometry()
            nH := qRect:height() + ( nMode * ( qRect:height() / 4 ) )
            qMdi:setGeometry( QRect( 0, nT, qRect:width(), nH ) )
            nT += nH
         NEXT
      ELSE
         nL := 0
         FOR EACH qMdi IN ::oIde:aMdies
            qRect := qMdi:geometry()
            nW := qRect:width() + ( nMode * ( qRect:width() / 4 ) )
            qMdi:setGeometry( QRect( nL, 0, nW, qRect:height() ) )
            nL += nW
         NEXT
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeDocks:stackHorizontally()
   LOCAL qArea, qVPort, nH, nT, nW, qMdi, nL, qObj
   IF .T.
      ::restState( 0 )
      //
      qArea  := ::oStackedWidget
      qObj   := qArea:oWidget:activeSubWindow()
      qVPort := qArea:viewport()
      nH     := qVPort:height()
      nW     := qVPort:width() / Len( ::oIde:aMdies )
      nT     := 0
      nL     := 0
   ENDIF
   FOR EACH qMdi IN ::oIde:aMdies
      qMdi:setGeometry( QRect( nL, nT, nW, nH ) )
      nL += nW
   NEXT
   ::oStackedWidget:oWidget:setActiveSubWindow( qObj )
   RETURN Self


METHOD IdeDocks:stackVertically()
   LOCAL qArea, qVPort, nH, nT, nW, qMdi,  qObj
   IF .T.
      ::restState( 0 )
      //   
      qArea  := ::oStackedWidget
      qObj   := qArea:oWidget:activeSubWindow()
      qVPort := qArea:viewport()
      nH     := qVPort:height() / Len( ::oIde:aMdies )
      nW     := qVPort:width()
      nT     := 0
   ENDIF
   FOR EACH qMdi IN ::oIde:aMdies
      qMdi:setGeometry( QRect( 0, nT, nW, nH ) )
      nT += nH
   NEXT
   ::oStackedWidget:oWidget:setActiveSubWindow( qObj )
   RETURN Self


METHOD IdeDocks:restPanelsGeometry()
   LOCAL a_, n
   FOR EACH a_ IN ::aViewsInfo
      IF ( n := ascan( ::oIde:aMdies, {|o| o:objectName() == a_[ 1 ] } ) ) > 0
         IF HB_ISOBJECT( a_[ 2 ] )
            ::oIde:aMdies[ n ]:setGeometry( a_[ 2 ] )
         ENDIF
      ENDIF
   NEXT
   RETURN Self


METHOD IdeDocks:savePanelsGeometry()
   LOCAL a_, n
   FOR EACH a_ IN ::aViewsInfo
      IF ( n := ascan( ::oIde:aMdies, {|o| o:objectName() == a_[ 1 ] } ) ) > 0
         a_[ 2 ] := ::oIde:aMdies[ n ]:geometry()
      ENDIF
   NEXT
   RETURN Self


METHOD IdeDocks:showDlgBySystemTrayIconCommand()()
   ::oSys:hide()
   IF hb_bitAnd( ::nPrevWindowState, Qt_WindowMaximized ) == Qt_WindowMaximized
      ::oDlg:oWidget:showMaximized()
   ELSEIF hb_bitAnd( ::nPrevWindowState, Qt_WindowFullScreen ) == Qt_WindowFullScreen
      ::oDlg:oWidget:showFullScreen()
   ELSE
      ::oDlg:oWidget:showNormal()
   ENDIF
   ::oDlg:oWidget:raise()
   ::oDlg:oWidget:activateWindow()
   RETURN Self


METHOD IdeDocks:getADockWidget( nAreas, cObjectName, cWindowTitle, nFlags )
   LOCAL oDock, nBasic
   DEFAULT nFlags TO 0
   nBasic := hb_bitOR( QDockWidget_DockWidgetClosable, nFlags )
   WITH OBJECT oDock := XbpWindow():new()
      ::oDlg:addChild( oDock )
      WITH OBJECT :oWidget := QDockWidget( ::oDlg:oWidget )
         :setObjectName( cObjectName )
         :setFeatures( nBasic )
         :setAllowedAreas( nAreas )
         :setWindowTitle( cWindowTitle )
         :setFocusPolicy( Qt_NoFocus )
         :setStyleSheet( getStyleSheet( "QDockWidget", ::nAnimantionMode ) )
      ENDWITH
      :hide()
   ENDWITH 
   RETURN oDock


METHOD IdeDocks:setViewInitials()
   LOCAL a_
   FOR EACH a_ IN ::aViewsInfo
      ::setView( a_[ 1 ] )
      IF ::qTabWidget:count() == 1
         ::oEM:setSourceVisibleByIndex( 0 )
      ELSE
#if 0
         ::qTabWidget:setCurrentIndex( 0 )
         ::qTabWidget:setCurrentIndex( ::qTabWidget:count() - 1 )
         ::qTabWidget:setCurrentIndex( 0 )
#endif
      ENDIF
   NEXT
   RETURN Self


METHOD IdeDocks:setView( cView )
   LOCAL n, nIndex
   ::cOldView := ::oIde:cWrkView
   SWITCH cView
   CASE "New..."
      cView := hbide_fetchAString( ::qViewsCombo, cView, "Name the View", "New View" )
      IF !( cView == "New..." ) .AND. !( cView == "Main" )
         IF ascan( ::aViewsInfo, {|e_| e_[ 1 ] == cView } ) > 0
            MsgBox( "View: " + cView + ", already exists" )
         ELSE
            aadd( ::aViewsInfo, { cView, NIL, 0, 0, 0, 0 } )
            ::oTM:addPanelsMenu( cView )
            ::buildViewWidget( cView )
            ::setView( cView )
         ENDIF
      ENDIF
      EXIT
   OTHERWISE
      IF ( n := ascan( ::aViews, {|o| iif( HB_ISSTRING( o:oWidget:objectName() ), o:oWidget:objectName() == cView, .f. ) } ) ) > 0
         ::oIde:cWrkView := cView
         ::oIde:qTabWidget := ::aViews[ n ]:oTabWidget:oWidget
         ::oIde:oTabParent := ::aViews[ n ]
         nIndex := ::oIde:qTabWidget:currentIndex()
         IF nIndex + 1 == ::oIde:qTabWidget:count()
            IF !( ::oIde:lClosing )
               ::oIde:qTabWidget:setCurrentIndex( 0 )
               ::oIde:qTabWidget:setCurrentIndex( nIndex )  /* TODO: Must be last saved */
            ENDIF
         ENDIF
         ::oStackedWidget:oWidget:setActiveSubWindow( ::oIde:aMdies[ n ] )
         ::setStatusText( SB_PNL_VIEW, ::cWrkView )
      ELSE
         aadd( ::aViewsInfo, { cView, NIL, 0, 0, 0, 0 } )
         ::oTM:addPanelsMenu( cView )
         ::buildViewWidget( cView )
         ::setView( cView )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD IdeDocks:setButtonState( cButton, lChecked )
   IF ::oAC:qMdiToolbar:contains( cButton )
      RETURN ::oAC:qMdiToolbar:setItemChecked( cButton, lChecked )
   ELSEIF ::oAC:qMdiToolbarL:contains( cButton )
      RETURN ::oAC:qMdiToolbarL:setItemChecked( cButton, lChecked )
   ENDIF
   RETURN .f.


METHOD IdeDocks:buildStackedWidget()
   ::oIde:oStackedWidget := XbpWindow():new( ::oDa )
   WITH OBJECT ::oStackedWidget:oWidget := QMdiArea( ::oDa:oWidget )
      :setObjectName( "editMdiArea" )
      :setDocumentMode( .t. )
      :setOption( QMdiArea_DontMaximizeSubWindowOnActivation, .t. )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setActivationOrder( QMdiArea_CreationOrder )
      :setTabsMovable( .t. )
   ENDWITH
   WITH OBJECT ::oStackedWidget
      :setTabShape( ::oINI:nPanelsTabShape )
      :setTabPosition( ::oINI:nPanelsTabPosition )
   ENDWITH
   ::oDa:addChild( ::oStackedWidget )
   ::oStackedWidget:oWidget:connect( "subWindowActivated(QMdiSubWindow*)", {|p| ::execEvent( __mdiArea_subWindowActivated__, p ) } )
   RETURN Self


METHOD IdeDocks:buildViewWidget( cView )
   LOCAL oFrame, qTBtnClose, qMdi, n
   //
   WITH OBJECT qMdi := QMdiSubWindow( ::oDlg:oWidget )
      :setWindowTitle( cView )
      :setObjectName( cView )
      :setWindowIcon( QIcon( ::getPanelIcon( cView ) ) )
   ENDWITH 
   WITH OBJECT oFrame := XbpWindow():new( ::oStackedWidget )
      :oWidget := QWidget( ::oStackedWidget:oWidget )
      :oWidget:setObjectName( cView )
      :hbLayout := HBPLAYOUT_TYPE_VERTBOX
      :qLayout:setContentsMargins( 0,0,0,0 )
      :oTabWidget := XbpTabWidget():new():create( oFrame, , {0,0}, {200,200}, , .t. )
   ENDWITH 
   ::oStackedWidget:addChild( oFrame )
   WITH OBJECT qTBtnClose := QToolButton( oFrame:oTabWidget:oWidget )
      :setTooltip( "Close Tab" )
      :setAutoRaise( .t. )
      :setIcon( QIcon( hbide_image( "closetab" ) ) )
      :connect( "clicked()", {|| ::oSM:closeSource() } )
   ENDWITH 
   oFrame:oTabWidget:qCornerWidget := qTBtnClose
   oFrame:oTabWidget:oWidget:setCornerWidget( qTBtnClose, Qt_TopRightCorner )
   WITH OBJECT oFrame:oTabWidget:oWidget
      :setAcceptDrops( .t. )
      :connect( QEvent_DragEnter, {|p| ::execEvent( __editWidget_dragEnterEvent__, p ) } )
      :connect( QEvent_DragMove , {|p| ::execEvent( __editWidget_dragMoveEvent__ , p ) } )
      :connect( QEvent_Drop     , {|p| ::execEvent( __editWidget_dropEvent__     , p ) } )
   ENDWITH 
   WITH OBJECT oFrame:oTabWidget:oWidget
      :setUsesScrollButtons( .t. )
      :setMovable( .t. )
   ENDWITH 
   WITH OBJECT oFrame
      :oWidget:show()
      :oTabWidget:oWidget:show()
   ENDWITH
   aadd( ::oIde:aViews, oFrame )
   aadd( ::oIde:aMdies, qMdi   )
   WITH OBJECT qMdi
      IF ( n := ascan( ::aViewsInfo, {|e_| e_[ 1 ] == cView } ) ) > 0
         IF !empty( ::aViewsInfo[ n, 2 ] )
            :setGeometry( ::aViewsInfo[ n, 2 ] )
         ELSE
            :resize( 300, 200 )
         ENDIF
      ENDIF
      :setWidget( oFrame:oWidget )
   ENDWITH
   ::oStackedWidget:oWidget:addSubWindow( qMdi )
   qMdi:connect( "windowStateChanged(Qt::WindowStates,Qt::WindowStates)", ;
                 {|p,p1| ::execEvent( __mdiSubWindow_windowStateChanged__, qMdi, { p, p1 } ) } )
   ::setView( cView )
   RETURN oFrame


METHOD IdeDocks:buildSearchReplaceWidget()
   ::oIde:oSearchReplace := IdeSearchReplace():new( ::oIde ):create()
   ::oSearchReplace:oUI:hide()
   RETURN Self


METHOD IdeDocks:buildUpDownWidget()
   WITH OBJECT ::oIde:oUpDn := IdeUpDown():new( ::oIde ):create()
      :oUI:show()
      ::oAC:qMdiToolbarL:addWidget( "UpDown", :oUI:oWidget )
      :oUI:hide()
   ENDWITH 
   RETURN Self


METHOD IdeDocks:disblePanelButton( qTBtn )
   LOCAL q
   FOR EACH q IN ::aPanels
      q:setEnabled( !( q == qTBtn ) )
   NEXT
   RETURN Self


METHOD IdeDocks:getPanelIcon( cView )
   LOCAL n
   IF ( n := ascan( ::aViewsInfo, {|e_| e_[ 1 ] == cView } ) ) > 0
      IF n > 20
         n -= 20
      ENDIF
      RETURN hbide_image( "b_" + hb_ntos( n ) )
   ENDIF
   RETURN ""


METHOD IdeDocks:buildProjectTree()
   LOCAL i, oItem
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea

   ::oIde:oDockPT := ::getADockWidget( nAreas, "dockProjectTree", "Projects", QDockWidget_DockWidgetFloatable )
   ::oDlg:oWidget:addDockWidget( Qt_LeftDockWidgetArea, ::oDockPT:oWidget, Qt_Vertical )
   WITH OBJECT ::oIde:oProjTree := XbpTreeView():new()
      :hasLines := .T.
      :hasButtons := .T.
      :create( ::oDockPT, NIL, { 0,0 }, { 100,10 }, NIL, .t. )
      WITH OBJECT :oWidget
         :setStyleSheet( GetStyleSheet( "QTreeWidgetHB", ::nAnimantionMode ) )
         :setMinimumWidth( 100 )
         :setSizePolicy( QSizePolicy_MinimumExpanding, QSizePolicy_Preferred )
         :setIconSize( QSize( 12,12 ) )
         :setIndentation( 12 )
      ENDWITH
      :itemMarked    := {|oItem| ::oIde:oCurProjItem := oItem }
      :itemSelected  := {|oItem| ::oIde:manageItemSelected( oItem ) }
      :hbContextMenu := {|mp1, mp2, oXbp| ::oIde:manageProjectContext( mp1, mp2, oXbp ) }
   ENDWITH 
   WITH OBJECT ::oIde:oProjRoot := ::oProjTree:rootItem:addItem( "Projects" )
      oItem := :addItem( "Executables" )
      oItem:oWidget:setIcon( 0, QIcon( hbide_image( "fl_exe" ) ) )
      aadd( ::aProjData, { oItem, "Executables", ::oProjRoot, NIL, NIL } )
      oItem := :addItem( "Libs" )
      oItem:oWidget:setIcon( 0, QIcon( hbide_image( "fl_lib" ) ) )
      aadd( ::aProjData, { oItem, "Libs"       , ::oProjRoot, NIL, NIL } )
      oItem := :addItem( "Dlls" )
      oItem:oWidget:setIcon( 0, QIcon( hbide_image( "fl_dll" ) ) )
      aadd( ::aProjData, { oItem, "Dlls"       , ::oProjRoot, NIL, NIL } )
      // 
      :expand( .t. )
   ENDWITH 
   FOR i := 1 TO Len( ::aProjects )
      ::oIde:updateProjectTree( ::aProjects[ i, 3 ] )
   NEXT
   /* Insert Project Tree Into Dock Widget */
   WITH OBJECT ::oDockPT
      :oWidget:setWidget( ::oProjTree:oWidget )
      :hide()
   ENDWITH 
   WITH OBJECT ::oDockPT:oWidget 
      :setAcceptDrops( .t. )
      :connect( QEvent_DragEnter, {|p| ::execEvent( __projectTree_dragEnterEvent__, p ) } )
      :connect( QEvent_Drop     , {|p| ::execEvent( __projectTree_dropEvent__     , p ) } )   
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildEditorTree()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oDockED := ::getADockWidget( nAreas, "dockEditorTabs", "Editors", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_LeftDockWidgetArea, :oWidget, Qt_Vertical )
      WITH OBJECT ::oIde:oEditTree := XbpTreeView():new()
         :hasLines   := .T.
         :hasButtons := .T.
         :create( ::oDockED, , { 0,0 }, { 100,10 }, , .t. )
         WITH OBJECT :oWidget
            :setSizePolicy( QSizePolicy_MinimumExpanding, QSizePolicy_Preferred )
            :setMinimumWidth( 100 )
            :setIconSize( QSize( 12,12 ) )
            :setIndentation( 12 )
         ENDWITH 
         :itemMarked    := {|oItem| ::oIde:oCurProjItem := oItem }
         :itemSelected  := {|oItem| ::oIde:manageItemSelected( oItem ) }
         :hbContextMenu := {|mp1, mp2, oXbp| ::oIde:manageProjectContext( mp1, mp2, oXbp ) }
      ENDWITH    
      WITH OBJECT ::oIde:oOpenedSources := ::oEditTree:rootItem:addItem( "Editors" )
         :expand( .t. )
      ENDWITH 
      :oWidget:setWidget( ::oEditTree:oWidget )
      :hide()
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildSkeletonsTree()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oSkltnsTreeDock := ::getADockWidget( nAreas, "dockSkltnsTree", "Skeletons", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_LeftDockWidgetArea, :oWidget, Qt_Vertical )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockSkltnsTree_visibilityChanged__, p, ::oSkltnsTreeDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildFuncList()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oFuncDock := ::getADockWidget( nAreas, "dockFuncList", "Functions List", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Vertical )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __oFuncDock_visibilityChanged__, p, ::oFuncDock:oWidget ) } )
   ENDWITH 
   WITH OBJECT ::oIde:oFuncList := XbpListBox():new( ::oFuncDock ):create( , , { 0,0 }, { 100,400 }, , .t. )
      :oWidget:setEditTriggers( QAbstractItemView_NoEditTriggers )
      :ItemSelected  := {|mp1, mp2, oXbp| ::oIde:gotoFunction( mp1, mp2, oXbp ) }
      /* Harbour Extension : prefixed with "hb" */
      :hbContextMenu := {|mp1, mp2, oXbp| ::oIde:manageFuncContext( mp1, mp2, oXbp ) }
      ::oFuncDock:oWidget:setWidget( :oWidget )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildHelpWidget()
   WITH OBJECT ::oIde:oHelpDock := ::getADockWidget( Qt_RightDockWidgetArea, "dockHelp", "hbIDE Help", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
   ENDWITH 
   WITH OBJECT ::oIde:qHelpBrw := QTextBrowser( ::oHelpDock:oWidget )
      :show()
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :setOpenExternalLinks( .t. )
      :setSource( QUrl( "qrc:///docs/faq.htm" ) )
      :connect( "customContextMenuRequested(QPoint)", {|p| ::execEvent( __qHelpBrw_contextMenuRequested__, p ) } )
      ::oHelpDock:oWidget:setWidget( ::qHelpBrw )
   ENDWITH 
   WITH OBJECT ::oHelpDock:oWidget
      :connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockHelpDock_visibilityChanged__, p, ::oHelpDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildCompileResults()
   WITH OBJECT ::oIde:oDockB := ::getADockWidget( Qt_BottomDockWidgetArea, "dockCompileResults", "Compile Results" )
      ::oDlg:oWidget:addDockWidget( Qt_BottomDockWidgetArea, :oWidget, Qt_Horizontal )
      ::oIde:oCompileResult := XbpMLE():new( ::oDockB ):create( , , { 0,0 }, { 100,400 }, , .t. )
      :oWidget:setWidget( ::oCompileResult:oWidget )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildLinkResults()
   WITH OBJECT ::oIde:oDockB1 := ::getADockWidget( Qt_BottomDockWidgetArea, "dockLinkResults", "Link Results" )
      ::oDlg:oWidget:addDockWidget( Qt_BottomDockWidgetArea, ::oDockB1:oWidget, Qt_Horizontal )
      ::oIde:oLinkResult := XbpMLE():new( ::oDockB1 ):create( NIL, NIL, { 0,0 }, { 100, 400 }, NIL, .T. )
      :oWidget:setWidget( ::oLinkResult:oWidget )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildOutputResults()
   LOCAL nAreas := Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oDockB2 := ::getADockWidget( nAreas, "dockOutputResults", "Output Console" )//, QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_BottomDockWidgetArea, :oWidget, Qt_Horizontal )
      WITH OBJECT ::oIde:oOutputResult := XbpRtf():new( ::oDockB2 ):create( NIL, NIL, { 0,0 }, { 100, 400 }, NIL, .T. )
         :setContextMenuPolicy( Qt_CustomContextMenu )
         WITH OBJECT :oWidget
            :setAcceptRichText( .T. )
            :setReadOnly( .T. )
            :connect( "customContextMenuRequested(QPoint)", {|p| ::execEvent( __outputConsole_contextMenuRequested__, p ) } )
            :connect( "copyAvailable(bool)", {|l| ::outputDoubleClicked( l ) } )
         ENDWITH 
      ENDWITH 
      :oWidget:setWidget( ::oOutputResult:oWidget )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:outputDoubleClicked( lSelected )
   LOCAL qCursor, cText, cSource, nLine
   IF lSelected
      qCursor := ::oOutputResult:oWidget:textCursor()
      cText := qCursor:block():text()
      IF hbide_parseFNfromStatusMsg( cText, @cSource, @nLine, .T. )
         IF ::oSM:editSource( cSource, 0, 0, 0, NIL, NIL, .f., .t. )
            nLine := iif( nLine < 1, 0, nLine - 1 )
            WITH OBJECT qCursor := ::oIde:qCurEdit:textCursor()
               :setPosition( 0 )
               :movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine )
            ENDWITH 
            WITH OBJECT ::oIde:qCurEdit
               :setTextCursor( qCursor )
               :centerCursor()
            ENDWITH 
            ::oIde:manageFocusInEditor()
         ENDIF
      ENDIF
   ENDIF
   RETURN nLine


METHOD IdeDocks:buildStatusBar()
   LOCAL i
   STATIC qTBtn
   WITH OBJECT ::oIde:oSBar := XbpStatusBar():new()
      :create( ::oDlg, , { 0,0 }, { ::oDlg:currentSize()[ 1 ], 30 } )
      WITH OBJECT :oWidget
         :showMessage( "" )
         :setStyleSheet( GetStyleSheet( "QStatusBar", ::nAnimantionMode ) )
      ENDWITH 
      :getItem( SB_PNL_MAIN ):autosize := XBPSTATUSBAR_AUTOSIZE_SPRING
      IF .T.
         :addItem( "", , , , "Ready"    ):oWidget:setMinimumWidth(  40 )
         :addItem( "", , , , "Line"     ):oWidget:setMinimumWidth( 110 )
         :addItem( "", , , , "Column"   ):oWidget:setMinimumWidth(  40 )
         :addItem( "", , , , "Ins"      ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "SelChar"  ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Modified" ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Stream"   ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Edit"     ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Search"   ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Encoding" ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Environ"  ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "View"     ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Project"  ):oWidget:setMinimumWidth(  20 )
         :addItem( "", , , , "Theme"    ):oWidget:setMinimumWidth(  20 )
      ENDIF  
      WITH OBJECT qTBtn := QToolButton( ::oSBar:oWidget )
         :setTooltip( "Toggle Mark" )
         :setIcon(  QIcon( hbide_image( "bookmark" ) ) )
         :setMaximumHeight( 16 )
         :setMaximumWidth( 16 )
         :setAutoRaise( .t. )
         :connect( "clicked()", {|| ::oEM:setMark() } )
      ENDWITH 
      :oWidget:addWidget( qTBtn )
      FOR i := 1 TO 6
         :oWidget:addWidget( ::getMarkWidget( i ) )
      NEXT
      WITH OBJECT ::oIde:oProgBar := QProgressBar( ::oSBar:oWidget )
         :setMaximumWidth( 50 )
         :setMaximum( 20 )
         :setTextVisible( .F. )
         :hide()
      ENDWITH
      :oWidget:addWidget( ::oProgBar )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:setStatusText( nPart, xValue )
   LOCAL oPanel
   IF ! HB_ISOBJECT( ::oSBar )
      RETURN Self
   ENDIF
   oPanel := ::oSBar:getItem( nPart )
   SWITCH nPart
   CASE SB_PNL_MAIN
      oPanel:caption := '<font color="2343212"><b>' + xValue + "</b></font>"
      EXIT
   CASE SB_PNL_READY
      EXIT
   CASE SB_PNL_LINE
      EXIT
   CASE SB_PNL_COLUMN
      EXIT
   CASE SB_PNL_INS
      EXIT
   CASE SB_PNL_SELECTEDCHARS
      oPanel:caption := iif( xValue == 0, "", "Sel: " + hb_ntos( xValue ) )
      EXIT
   CASE SB_PNL_MODIFIED
      oPanel:caption := xValue
      EXIT
   CASE SB_PNL_STREAM
      oPanel:caption := iif( empty( xValue ), "St", xValue )
      EXIT
   CASE SB_PNL_EDIT
      EXIT
   CASE SB_PNL_SEARCH
      oPanel:caption := "Find: " + xValue
      EXIT
   CASE SB_PNL_CODEC
      xValue := iif( empty( xValue ), "default", xValue )
      oPanel:caption := "<font color = brown >Enc: "  + xValue + "</font>"
      EXIT
   CASE SB_PNL_ENVIRON
      xValue := iif( empty( xValue ), "default", xValue )
      oPanel:caption := "<font color = blue  >Env: "    + xValue + "</font>"
      EXIT
   CASE SB_PNL_VIEW
      oPanel:caption := "<font color = green >Panel: "   + xValue + "</font>"
      EXIT
   CASE SB_PNL_PROJECT
      xValue := iif( empty( xValue ), "none", xValue )
      oPanel:caption := "<font color = darkred >Prj: " + xValue + "</font>"
      EXIT
   CASE SB_PNL_THEME
      xValue := iif( empty( xValue ), "Bare Minimum", xValue )
      oPanel:caption := "<font color = blue >Theme: " + xValue + "</font>"
      EXIT
   ENDSWITCH
   RETURN Self


METHOD IdeDocks:dispEnvironment( cEnvironment )
   ::setStatusText( SB_PNL_ENVIRON, cEnvironment )
   RETURN Self


METHOD IdeDocks:getMarkWidget( nIndex )
   LOCAL aColors  := { "rgb( 255,255,127 )", "rgb( 175,175,255 )", "rgb( 255,175,175 )", ;
                       "rgb( 175,255,175 )", "rgb( 255,190,125 )", "rgb( 175,255,255 )"  }
   ::oIde:aMarkTBtns[ nIndex ] := QToolButton( ::oSBar:oWidget )
   //
   ::oIde:aMarkTBtns[ nIndex ]:setMaximumHeight( 12 )
   ::oIde:aMarkTBtns[ nIndex ]:setMaximumWidth( 12 )
   ::oIde:aMarkTBtns[ nIndex ]:setStyleSheet( "background-color: " + aColors[ nIndex ] + ";" )
   ::oIde:aMarkTBtns[ nIndex ]:hide()
   ::oIde:aMarkTBtns[ nIndex ]:connect( "clicked()" , {|| ::oEM:gotoMark( nIndex )        } )
   ::oIde:aMarkTBtns[ nIndex ]:connect( QEvent_Enter, {|| ::oEM:setTooltipMark( nIndex )  } )
   //
   RETURN ::oIde:aMarkTBtns[ nIndex ]


METHOD IdeDocks:animateComponents( nMode )
   LOCAL cStyle, oView, oMenu

   IF nMode == NIL
      ::oIde:nAnimantionMode := iif( ::nAnimantionMode == HBIDE_ANIMATION_NONE, HBIDE_ANIMATION_GRADIENT, HBIDE_ANIMATION_NONE )
      nMode := ::nAnimantionMode
   ENDIF
   ::oIde:nAnimantionMode := nMode
   ::oIde:oINI:cIdeAnimated := hb_ntos( ::nAnimantionMode )

   ::qAnimateAction:setChecked( ::nAnimantionMode != HBIDE_ANIMATION_NONE )
   /* Main Menu Bar with all its submenus */
   ::oDlg:menubar():oWidget:setStyleSheet( GetStyleSheet( "QMenuBar", nMode ) )
   FOR EACH oMenu IN ::oDlg:menubar():childList()
      oMenu:oWidget:setStyleSheet( GetStyleSheet( "QMenuPop", nMode ) )
   NEXT
   /* Toolbars */
   ::oMainToolbar:oWidget:setStyleSheet( GetStyleSheet( iif( ::oMainToolbar       : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qFilesToolbar   :setStyleSheet( GetStyleSheet( iif( ::oAC:qFilesToolbar  : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qTBarDocks      :setStyleSheet( GetStyleSheet( iif( ::oAC:qTBarDocks     : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qPartsToolbar   :setStyleSheet( GetStyleSheet( iif( ::oAC:qPartsToolbar  : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qProjectToolbar :setStyleSheet( GetStyleSheet( iif( ::oAC:qProjectToolbar: oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qMdiToolbar     :setStyleSheet( GetStyleSheet( iif( ::oAC:qMdiToolbar    : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   ::oAC:qMdiToolbarL    :setStyleSheet( GetStyleSheet( iif( ::oAC:qMdiToolbarL   : oWidget:orientation() == Qt_Horizontal, "QToolBar", "QToolBarLR5" ), nMode ) )
   /* User defined toolbars */
   ::oTM:setStyleSheet( GetStyleSheet( "QToolBarLR5", nMode ) )
   ::oEM:setStyleSheet( nMode )
   /* Statusbar */
   ::oSBar:oWidget:setStyleSheet( GetStyleSheet( "QStatusBar", nMode ) )
   /* Docking Widgets */
   cStyle := GetStyleSheet( "QDockWidget", nMode )
   //
   ::oDockPT:oWidget              : setStyleSheet( cStyle )
   ::oDockED:oWidget              : setStyleSheet( cStyle )
   ::oSkltnsTreeDock:oWidget      : setStyleSheet( cStyle )
   ::oHelpDock:oWidget            : setStyleSheet( cStyle )
   ::oDocViewDock:oWidget         : setStyleSheet( cStyle )
   ::oDocWriteDock:oWidget        : setStyleSheet( cStyle )
   ::oFuncDock:oWidget            : setStyleSheet( cStyle )
   ::oFunctionsDock:oWidget       : setStyleSheet( cStyle )
   ::oPropertiesDock:oWidget      : setStyleSheet( cStyle )
   ::oEnvironDock:oWidget         : setStyleSheet( cStyle )
   ::oSkeltnDock:oWidget          : setStyleSheet( cStyle )
   ::oThemesDock:oWidget          : setStyleSheet( cStyle )
   ::oFindDock:oWidget            : setStyleSheet( cStyle )
   ::oDockB2:oWidget              : setStyleSheet( cStyle )
   ::oSourceThumbnailDock:oWidget : setStyleSheet( cStyle )
   //
   ::oProjTree:oWidget:setStyleSheet( GetStyleSheet( "QTreeWidgetHB", ::nAnimantionMode ) )
   /* Edior Tab Widget */
   FOR EACH oView IN ::aViews
      oView:oTabWidget:oWidget:setStyleSheet( GetStyleSheet( "QTabWidget", nMode ) )
   NEXT
   RETURN Self


METHOD IdeDocks:buildThemesDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oThemesDock := ::getADockWidget( nAreas, "dockThemes", "Theme Manager", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockThemes_visibilityChanged__, p, ::oThemesDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildPropertiesDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oPropertiesDock := ::getADockWidget( nAreas, "dockProperties", "Project Properties", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockProperties_visibilityChanged__, p, ::oPropertiesDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildFindInFiles()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oFindDock := ::getADockWidget( nAreas, "dockFindInFiles", "Find in Files", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockFindInFiles_visibilityChanged__, p, ::oFindDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildDocViewer()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oDocViewDock := ::getADockWidget( nAreas, "dockDocViewer", "Harbour Documentation", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockDocViewer_visibilityChanged__, p, ::oDocViewDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildDocWriter()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oDocWriteDock := ::getADockWidget( nAreas, "dockDocWriter", "Documentation Writer", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockDocWriter_visibilityChanged__, p, ::oDocWriteDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildFunctionsDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oFunctionsDock := ::getADockWidget( nAreas, "dockFunctions", "Projects Functions Lookup", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __docFunctions_visibilityChanged__, p, ::oFunctionsDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildEnvironDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oEnvironDock := ::getADockWidget( nAreas, "dockEnvironments", "Compiler Environments", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __docEnvironments_visibilityChanged__, p, ::oEnvironDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildSkeletonWidget()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oSkeltnDock := ::getADockWidget( nAreas, "dockSkeleton", "Code Skeletons", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __docSkeletons_visibilityChanged__, p, ::oSkeltnDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildSourceThumbnail()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oSourceThumbnailDock := ::getADockWidget( nAreas, "dockSourceThumbnail", "Source Thumbnail", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockSourceThumbnail_visibilityChanged__, p, ::oSourceThumbnailDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildFormatWidget()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oFormatDock := ::getADockWidget( nAreas, "dockFormat", "Format Source", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockFormat_visibilityChanged__, p, ::oFormatDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildCuiEdWidget()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oCuiEdDock := ::getADockWidget( nAreas, "dockCuiEd", "CUI Screen Designer", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockCuiEd_visibilityChanged__, p, ::oCuiEdDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildUISrcDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oUISrcDock := ::getADockWidget( nAreas, "dockUISrc", "UI Source Manager", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockUISrc_visibilityChanged__, p, ::oUISrcDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildFunctionsMapDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oFunctionsMapDock := ::getADockWidget( nAreas, "dockFunctionsMap", "Functions Map", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockFunctionsMap_visibilityChanged__, p, ::oFunctionsMapDock:oWidget ) } )
   ENDWITH 
   RETURN Self


METHOD IdeDocks:buildDebuggerDock()
   LOCAL nAreas := Qt_LeftDockWidgetArea + Qt_RightDockWidgetArea + Qt_TopDockWidgetArea + Qt_BottomDockWidgetArea
   WITH OBJECT ::oIde:oDebuggerDock := ::getADockWidget( nAreas, "dockDebugger", "HbIDE Debugger", QDockWidget_DockWidgetFloatable )
      ::oDlg:oWidget:addDockWidget( Qt_RightDockWidgetArea, :oWidget, Qt_Horizontal )
      :oWidget:connect( "visibilityChanged(bool)", {|p| ::execEvent( __dockDebugger_visibilityChanged__, p, ::oDebuggerDock:oWidget ) } )
   ENDWITH 
   RETURN Self


#define __selectionMode_stream__                  1
#define __selectionMode_column__                  2
#define __selectionMode_line__                    3

METHOD IdeDocks:showSelectedTextToolbar( oEdit )
   LOCAL qRect, nVPH, nVPW, nTBH, nTBW, nY, nX
   LOCAL qToolbar := ::oAC:qSelToolbar
   //
   DEFAULT oEdit TO ::oEM:getEditObjectCurrent()
   IF ! empty( oEdit )
      IF ! ::oINI:lSelToolbar
         qToolbar:hide()
         RETURN Self
      ENDIF
      IF oEdit:aSelectionInfo[ 1 ] > -1
         nVPH := oEdit:qEdit:viewport():height()
         nVPW := oEdit:qEdit:viewport():width()
         WITH OBJECT qToolbar
            :setParent( oEdit:qEdit:viewport() )
            :setOrientation( iif( oEdit:aSelectionInfo[ 5 ] == __selectionMode_column__, Qt_Vertical, Qt_Horizontal ) )
            :adjustSize()
         ENDWITH
         nTBW := qToolbar:width()
         nTBH := qToolbar:height()
         IF HB_ISNUMERIC( nTBW ) .AND. nTBW > 0 .AND. HB_ISNUMERIC( nTBH ) .AND. nTBH > 0
            qRect := oEdit:qEdit:cursorRect()
            IF oEdit:aSelectionInfo[ 5 ] == __selectionMode_column__
               nY := qRect:y() - ( nTBH / 2 )
               IF nY < 0
                  nY := 0
               ELSEIF nY + nTBH > nVPH
                  nY := nVPH - nTBH
               ENDIF
               nX := ( Max( oEdit:aSelectionInfo[ 2 ], oEdit:aSelectionInfo[ 4 ] ) + 5 ) * oEdit:qEdit:fontMetrics():averageCharWidth()
               IF nX + qToolbar:width() > nVPW
                  nX := ( Max( oEdit:aSelectionInfo[ 2 ], oEdit:aSelectionInfo[ 4 ] ) - 5 ) * oEdit:qEdit:fontMetrics():averageCharWidth() - nTBW
               ENDIF
               qToolbar:move( nX, nY )
            ELSE
               nX := qRect:x() - ( nTBW / 2 ) + 10  // arbitrary value
               IF nX < 0
                  nX := 0
               ELSEIF nX + nTBW > nVPW
                  nX := nVPW - nTBW
               ENDIF
               nY := qRect:y() + ( qRect:height() * 3 )
               IF nY + nTBH >= nVPH
                  nY := qRect:y() - ( qRect:height() * 4 )
               ENDIF
               qToolbar:move( nX, nY )
            ENDIF
            qToolbar:show()
            qToolbar:raise()
         ENDIF
      ELSE
         qToolbar:hide()
      ENDIF
   ENDIF
   RETURN Self

