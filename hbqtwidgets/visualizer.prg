/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010-2014 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                               05Oct2014
 */
/*----------------------------------------------------------------------*/


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"
#include "hbtrace.ch"
#include "common.ch"
#include "hbserial.ch"

#define UNIT  0.1

#define INI_KEY( cKey, n )                        cKey + "_" + hb_ntos( n ) + "="
#define U_UNIT( n )                               ( n / 0.1 )

#define STACK_MAIN_PAGE_JUST                      0
#define STACK_MAIN_PAGE_MAIN                      1
#define STACK_MAIN_PAGE_PREVIEW                   2
#define STACK_MAIN_PAGE_CHATTING                  3

#define PAGE_MAPS                                 0
#define PAGE_ITEMS                                1
#define PAGE_STATES                               2
#define PAGE_NAVIGATOR                            3
#define PAGE_FILTER                               4

#define PAGE_LAYERS                               0
#define PAGE_DATA                                 1
#define PAGE_PROPERTIES                           2
#define PAGE_RESIZER                              3
#define PAGE_MOVER                                4
#define PAGE_CHANGELAYER                          5

#define hbqt_screen_heightMM                      ( QDesktopWidget():height() / QDesktopWidget():physicalDpiY() * 25.4 )
#define hbqt_screen_widthMM                       ( QDesktopWidget():width()  / QDesktopWidget():physicalDpiX() * 25.4 )

#define HBQT_GRAPHICSVIEW_ZOOM_IN                 1
#define HBQT_GRAPHICSVIEW_ZOOM_OUT                2
#define HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG            3
#define HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL           4
#define HBQT_GRAPHICSVIEW_ZOOM_LOCATE             5

#define HBQT_GRAPHICSITEM_SELECTED                1
#define HBQT_GRAPHICSITEM_DELETED                 2
#define HBQT_GRAPHICSITEM_GEOMETRYCHANGED         3
#define HBQT_GRAPHICSITEM_REQUESTDATA             4


#define HQR_BARCODE_3OF9                          1

#define TO_MMS( n )                               ( ( n ) * 10 / 25.4 )
#define BY_MMS( n )                               ( ( n ) * 25.4 / 10 )

#define SHP_ACT_RECTANGLE                         1
#define SHP_ACT_ROUNDRECT                         2
#define SHP_ACT_ELLIPSE                           3
#define SHP_ACT_LINEVERT                          4
#define SHP_ACT_LINEHORZ                          5
#define SHP_ACT_LINEDIAGRIGHT                     6
#define SHP_ACT_LINEDIAGLEFT                      7
#define SHP_ACT_ARC                               8
#define SHP_ACT_CHORD                             9
#define SHP_ACT_DIAMOND                           10
#define SHP_ACT_TRIANGLE                          11

#define NUM_SHAPES                                11

#define __graphicsScene_block__                   2001
#define __treeObjects_clicked__                   2002
#define __tabBar_currentChanged__                 2003
#define __buttonOpen_clicked__                    2004
#define __buttonSave_clicked__                    2005
#define __buttonClose_clicked__                   2006
#define __buttonPrint_clicked__                   2007
#define __buttonRotateL_clicked__                 2008
#define __buttonRotateR_clicked__                 2009
#define __treeMarkers_clicked__                   2010
#define __treeMarkers_currentItemChanged__        2011
#define __treeVisuals_currentItemChanged__        2012
#define __treeVisuals_dblClicked__                2013


#define __HBQT_VISUALIZER_OPTION_RESIZEINPLACE__  1

#define STATUS_PANEL_READY                        1
#define STATUS_PANEL_LAYER                        2
#define STATUS_PANEL_MARKERS                      3
#define STATUS_PANEL_VISUALS                      4
#define STATUS_PANEL_MISC                         5


CLASS HbQtVisualizer

   DATA   oCurHbQtVisual

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD destroy()                               VIRTUAL
   ACCESS ui()                                    INLINE ::oUI

   METHOD setSplitterSizes( nFrameLeftWidth, nFrameRightWidth )
   METHOD setOption( nOption, xValue )

   ACCESS toolbarTop()                            INLINE ::oToolbar
   ACCESS toolbarItemEdit()                       INLINE ::oToolbarItemEdit
   ACCESS toolbarObjects()                        INLINE ::oObjectsToolbar
   ACCESS currentVisualIcon()                     INLINE iif( Empty( ::oCurHbQtVisual ), NIL, ::oCurHbQtVisual:icon() )
   ACCESS currentVisualName()                     INLINE iif( Empty( ::oCurHbQtVisual ), NIL, ::oCurHbQtVisual:refID() )

   METHOD visualsListBlock( bBlock )              SETGET
   METHOD visualsLoadBlock( bBlock )              SETGET
   METHOD visualsSaveBlock( bBlock )              SETGET
   METHOD visualInfoBlock( bBlock )               SETGET
   METHOD execInfoBlock( cWhat, xData )
   METHOD itemDataChangedBlock( bBlock )          SETGET    // fired for hItem[ "DataChange"  ] == TRUE defined items
   METHOD itemDataRequestBlock( bBlock )          SETGET    // fired for hItem[ "DataRequestDuration" ] == nDurationInSeconds defined indivisual items
   METHOD refreshItem( hItem )                              // general purpose method to receive structured data from application
                                                            // either in reponse to itemDataRequestBlock() or by its own.
   METHOD manageStateClicks( cButton )
   METHOD manageMarkerVClicks( cMarker )
   METHOD manageEventClose( oEvent )

   DATA   hState
   METHOD setState( hState )                      INLINE iif( HB_ISHASH( hState ), ::hState := hState, NIL )
   METHOD saveState()
   METHOD restoreState( hState )

   DATA   hTreeBGBrush                            INIT __hbqtStandardHash()
   METHOD setTreeNodesBGColor( cKey, oColor )

   FRIEND CLASS HbQtVisual

   PROTECTED:

   DATA   oUI

   DATA   oWidget
   DATA   oParent
   DATA   oOpenGLViewport
   DATA   oSplitter
   DATA   oStatusBar
   DATA   oSlidingsManager
   DATA   oSlidingListRight
   DATA   oSlidingListLeft
   DATA   oSlidingBrowser

   DATA   oToolbar
   DATA   oToolbarItemEdit
   DATA   oObjectsToolbar
   DATA   oStatesToolbar

   DATA   oHbQtPreview

   DATA   oDataWidget
   DATA   oDataManager
   DATA   oDataSheet

   DATA   oPropWidget
   DATA   oPropManager
   DATA   oPropertySheet

   DATA   oVisualsTree
   DATA   oNavgtTree
   DATA   oDataTree
   DATA   oMarkersTree
   DATA   oFiltersTree
   DATA   oLayersTree
   DATA   oChangeLayerTree
   DATA   nCurLayer                               INIT 0

   DATA   oGraphicsView
   DATA   oCurScene

   DATA   oCurrentMarkersItem
   DATA   oCurGraphicsItem

   DATA   cSaved                                  INIT ""
   DATA   cCurrentState
   DATA   cCurrentMarkerV
   DATA   cNavigtTreePage                         INIT "Objects"
   DATA   cSplitterSizes

   DATA   nScreenDpiX                             INIT 96
   DATA   nScreenDpiY                             INIT 96
   DATA   nResizerSteps                           INIT 10
   DATA   nMoverSteps                             INIT 10
   DATA   nFrameLeftWidth                         INIT 100
   DATA   nFrameRightWidth                        INIT 100

   DATA   lNew                                    INIT .T.
   DATA   lShowGrid                               INIT .F.
   DATA   lDoubleClickZoom                        INIT .F.
   DATA   lEditingOn                              INIT .F.
   DATA   lResizeInPlace                          INIT .T.
   DATA   lShowInitialized                        INIT .F.
   DATA   lToolboxLeftVisible                     INIT .T.
   DATA   lToolboxRightVisible                    INIT .T.

   DATA   bVisualsListBlock
   DATA   bVisualsLoadBlock
   DATA   bVisualsSaveBlock
   DATA   bItemDataChangedBlock
   DATA   bItemDataRequestBlock
   DATA   bVisualInfoBlock

   DATA   hVisualsTree                            INIT __hbqtStandardHash()
   DATA   hNavgtTreeItems                         INIT __hbqtStandardHash()
   DATA   hVisualsList                            INIT __hbqtStandardHash()
   DATA   hDataStruct                             INIT __hbqtStandardHash()
   DATA   hVisualsStates                          INIT __hbqtStandardHash()
   DATA   hMarkers                                INIT __hbqtStandardHash()
   DATA   hHbQtVisuals                            INIT __hbqtStandardHash()

   DATA   aStatusPnls                             INIT {}
   DATA   aPages                                  INIT {}
   DATA   aSources                                INIT {}
   DATA   aObjects                                INIT {}
   DATA   aRptPages                               INIT {}
   DATA   aRptObjects                             INIT {}
   DATA   oTimerZoom
   DATA   nHSBValue                               INIT 0
   DATA   nVSBValue                               INIT 0
   DATA   lZoomLocate                             INIT .F.
   DATA   oZoomTrans
   DATA   oChatter

   METHOD execEvent( nEvent, p, p1, p2 )

   METHOD buildToolbar( oLayout )
   METHOD buildToolbarItemEdit( oLayout )
   METHOD buildSlidings()
   METHOD buildMarkersTree()
   METHOD buildFiltersTree()
   METHOD buildLayersTree()
   METHOD buildChangeLayerTree()
   METHOD buildStatusBar()
   METHOD buildComponents()
   METHOD buildPropertySheets()
   METHOD buildDataSheets()
   METHOD buildVisualStream( oHbQtVisual )

   METHOD activateScene()
   METHOD showStatus( nPanel, cMsg )
   METHOD addObject( cType, oPos, oGeo, cName )
   METHOD placeObject( nSceneX, nSceneY )
   METHOD populateVisual()
   METHOD getImageOfType( cType )
   METHOD updateObjectsTree( cType, cParent, cName, cSubType, oPixmap )
   METHOD contextMenuScene( nX, nY )
   METHOD clear()
   METHOD toString( oHbQtVisual )
   METHOD parseBuffer( cBuffer )
   METHOD presentBlankVisual()
   METHOD printVisual( oPrinter )
   METHOD zoom( nMode )
   METHOD resizeMarker( nDirection )
   METHOD moveMarker( nDirection )
   METHOD manageEditing( lOn )
   METHOD manageEditClicked( lChecked )

   METHOD itemActionsBlock( oHbQtVisualItem, nAction, xData )
   METHOD objectGeometryChanged( oHbQtVisualItem )
   METHOD objectDeleted( oHbQtVisualItem )
   METHOD objectSelected( oHbQtVisualItem )
   METHOD deleteState( oHbQtVisualItem )
   METHOD rotateMarker( oCurGraphicsItem, nDirection )
   METHOD toggleLockOnObject()
   METHOD toggleGrid()
   METHOD setMarker( oGraphicsItem )
   METHOD clearMarker()
   METHOD setItemLayer( cLayer, oHbQtVisualItem )

   ACCESS splitter()                              INLINE ::oSplitter

   METHOD dataStructureProperties()
   METHOD populateDataSheet( oHbQtVisualItem )
   METHOD dataPropertyChanged( cSheet, cProperty, xValue )

   ACCESS propertiesManager()                     INLINE ::oPropManager
   METHOD populatePropertySheet( oHbQtVisualItem )
   METHOD visualPropertyChanged( cSheet, cProperty, xValue )
   METHOD saveVisual( oHbQtVisual )
   METHOD show()
   METHOD hide()
   METHOD buildVisualsTree( hVisualsList )
   METHOD loadVisual( cRefID, nVer )
   METHOD buildStates( hStates )
   METHOD buildStyleSheet()
   METHOD switchItemOptions( lOnOff )
   METHOD updateItemStatus( oHbQtVisualItem )
   METHOD activatePanning( lActivate )
   METHOD animateVisualsTree()
   METHOD setupCurrentChangeLayer()

   DATA   oBrowse, xData
   METHOD tabulize()
   METHOD selectMarkerOffBrowser( cMarker )
   METHOD browseNavigate( nKey )

   DATA   oHiddenItemsGroup
   METHOD filter( oItem, nColumn )
   METHOD setupCurrentLayer( oItem, nCol )

   DATA   aCompLeft                               INIT {}
   DATA   aCompRight                              INIT {}
   METHOD onPanelAction( cArea, nPage )
   METHOD gridOffOn( lOff )

   ENDCLASS


METHOD HbQtVisualizer:init( oParent )
   ::oParent := oParent
   RETURN Self


METHOD HbQtVisualizer:create( oParent )
   LOCAL oLayout, i, nCount, aComp

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::oUI := hbqtui_visualizer( oParent )

   ::oUI:toolBoxLeft:setMinimumWidth( 40 )
   ::oUI:toolBoxRight:setMinimumWidth( 40 )

   ::oUI:splitterViews:setCollapsible( 0, .F. )
   ::oUI:splitterViews:setCollapsible( 1, .F. )
   ::oUI:splitterViews:setCollapsible( 2, .F. )

   FOR i := 1 TO ::oUI:toolBoxLeft:count()
      AAdd( ::aCompLeft, { ::oUI:toolBoxLeft:widget( i-1 ), ::oUI:toolBoxLeft:itemIcon( i-1 ), ::oUI:toolBoxLeft:itemText( i-1 ) } )
   NEXT
   FOR i := 1 TO ::oUI:toolBoxRight:count()
      AAdd( ::aCompRight, { ::oUI:toolBoxRight:widget( i-1 ), ::oUI:toolBoxRight:itemIcon( i-1 ), ::oUI:toolBoxRight:itemText( i-1 ) } )
   NEXT
   nCount := ::oUI:toolBoxLeft:count()
   FOR i := nCount TO 1 STEP -1
      ::oUI:toolBoxLeft:removeItem( i-1 )
   NEXT
   nCount := ::oUI:toolBoxRight:count()
   FOR i := nCount TO 1 STEP -1
      ::oUI:toolBoxRight:removeItem( i-1 )
   NEXT
   FOR EACH aComp IN ::aCompRight
      aComp[ 1 ]:hide()
   NEXT
   FOR EACH aComp IN ::aCompLeft
      aComp[ 1 ]:hide()
   NEXT

   WITH OBJECT ::oWidget := ::oUI:oWidget
      :setStyleSheet( ::buildStyleSheet() )
      :setContentsMargins( 1,0,1,0 )
   ENDWITH

   IF HB_ISOBJECT( oParent )
      IF Empty( oLayout := oParent:layout() )
         oLayout := QHBoxLayout()
         ::oParent:setLayout( oLayout )
         oLayout:addWidget( ::oWidget )
      ELSE
         SWITCH __objGetClsName( oLayout )
         CASE "QVBOXLAYOUT"
         CASE "QHBOXLAYOUT"
            oLayout:addWidget( ::oWidget )
            EXIT
         CASE "QGRIDLAYOUT"
            oLayout:addWidget( ::oWidget, 0, 0, 1, 1 )
            EXIT
         ENDSWITCH
      ENDIF
   ENDIF

   ::buildSlidings()
   ::buildToolbar( ::oUI:hLayToolbarVisualizer )
   ::buildToolbarItemEdit( ::oUI:hLayoutItemEdit )
   ::buildComponents()
   ::buildPropertySheets()

   ::setTreeNodesBGColor()                        // default background colors of MarkersTree

   WITH OBJECT ::oUI:labelTopLeft
      :connect( QEvent_MouseButtonPress, {|| iif( ::oUI:toolBoxLeft:isVisible(), ::oUI:toolBoxLeft:hide(), ::oUI:toolBoxLeft:show() ), ;
           ::oUI:labelTopLeft:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxLeft:isVisible(), "left-close", "left-open" ) ) ) ), ;
           ::lToolboxLeftVisible := ::oUI:toolBoxLeft:isVisible() } )
   ENDWITH
   WITH OBJECT ::oUI:labelTopRight
      :connect( QEvent_MouseButtonPress, {|| iif( ::oUI:toolBoxRight:isVisible(), ::oUI:toolBoxRight:hide(), ::oUI:toolBoxRight:show() ), ;
           ::oUI:labelTopRight:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxRight:isVisible(), "right-close", "right-open" ) ) ) ), ;
           ::lToolboxRightVisible := ::oUI:toolBoxRight:isVisible() } )
   ENDWITH

   WITH OBJECT ::oUI:splitterViews
      :setStretchFactor( 0, 0 )
      :setStretchFactor( 1, 1 )
      :setStretchFactor( 2, 0 )
   ENDWITH

   ::onPanelAction( "L", PAGE_MAPS )
   ::onPanelAction( "R", PAGE_LAYERS )

   ::oUI:stackBase:setCurrentIndex( 1 )
   ::oUI:stackMarkers:setCurrentIndex( 1 )
   ::oUI:stackData:setCurrentIndex( 1 )
#ifndef __ios__
   WITH OBJECT ::oHbQtPreview := HbQtPrintPreview():new():create( ::oUI:vLayPreviewer )
      :previewBlock := {|oPrinter| ::printVisual( oPrinter ) }
      :exitBlock    := {|| ::oUI:stackBase:setCurrentIndex( 1 ) }
   ENDWITH
#endif
   FOR i := 1 TO 10
      ::oUI:comboResizerSteps:addItem( hb_ntos( i ) )
   NEXT
   ::oUI:comboResizerSteps:setCurrentIndex( 9 )
   ::oUI:comboResizerSteps:connect( "currentIndexChanged(int)", {|nIndex| ::nResizerSteps := nIndex+1 } )

   FOR i := 1 TO 10
      ::oUI:comboMoverSteps:addItem( hb_ntos( i ) )
   NEXT
   ::oUI:comboMoverSteps:setCurrentIndex( 9 )
   ::oUI:comboMoverSteps:connect( "currentIndexChanged(int)", {|nIndex| ::nMoverSteps := nIndex+1 } )

   ::oWidget:connect( QEvent_Show, {|| ::show() } )
   ::oWidget:connect( QEvent_Hide, {|| ::hide() } )

   WITH OBJECT ::oTimerZoom := QTimer()
      :setSingleShot( .T. )
      :setInterval( 100 )
      :connect( "timeout()", {|| ::activatePanning( .T. ) } )
   ENDWITH

   ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_MAIN )

   WITH OBJECT ::oChatter := HbQtChat():new():create( ::oUI:pageBaseMain )
      :infoBlock := {| cWhat,xData | ::execInfoBlock( cWhat,xData ) }
   ENDWITH

   __hbqtRegisterForEventClose( {|oEvent| ::manageEventClose( oEvent ) } )
   RETURN Self


METHOD HbQtVisualizer:manageEventClose( oEvent )
   LOCAL lHandeled := .T.

   IF ! ::oWidget:isVisible()
      RETURN .F.
   ENDIF

   SWITCH ::oUI:stackBase:currentIndex()
   CASE STACK_MAIN_PAGE_JUST
   CASE STACK_MAIN_PAGE_MAIN
      lHandeled := .F.
      EXIT
   CASE STACK_MAIN_PAGE_PREVIEW
      ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_MAIN )
      EXIT
   CASE STACK_MAIN_PAGE_CHATTING
      ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_MAIN )
      EXIT
   OTHERWISE
      lHandeled := .F.
   ENDSWITCH

   IF lHandeled
      oEvent:ignore()
   ENDIF
   RETURN lHandeled


METHOD HbQtVisualizer:buildComponents()

   WITH OBJECT ::oSplitter := ::oUI:splitterViews
      :connect( "splitterMoved(int,int)", {|| ::cSplitterSizes := ::oSplitter:saveState():toBase64():data() } )
   ENDWITH

   WITH OBJECT ::oGraphicsView := ::oUI:graphicsView
#if 0                                             // Still not working as expected, many flaws.
      :grabGesture( Qt_PinchGesture )
      :connect( QEvent_Gesture, ;
         {|oEvent|
            LOCAL nChangeFlags, nScale, nZoom
            LOCAL oGesture := oEvent:gesture( Qt_PinchGesture )
            IF ! Empty( oGesture )
               oGesture := oGesture:__toPinchGesture()
               IF oGesture:state() == Qt_GestureStarted
                  ::activatePanning( .F. )
               ENDIF
               nChangeFlags := oGesture:changeFlags()
               IF hb_bitAnd( nChangeFlags, QPinchGesture_ScaleFactorChanged ) != 0
                  nScale := oGesture:scaleFactor()
                  IF nScale < 2 .AND. nScale > 0.5
                     nZoom := nScale
                     ::oGraphicsView:setTransformationAnchor( QGraphicsView_AnchorUnderMouse )
                     ::nHSBValue := ::oGraphicsView:horizontalScrollbar():value()
                     ::nVSBValue := ::oGraphicsView:verticalScrollbar():value()
                     ::oGraphicsView:scale( nZoom, nZoom )
                     ::showStatus( 4, Str( nZoom ) )
                  ENDIF
               ENDIF
               IF oGesture:state() == Qt_GestureFinished
                  ::oTimerZoom:start()
               ENDIF
            ENDIF
            RETURN .T.
         } )
#else
#if 0          // not useful until we find its proper use . actually it hits the performance in many ways -
      :grabGesture( Qt_TapAndHoldGesture )
      :connect( QEvent_Gesture, ;
         {|oEvent|
            LOCAL oPointF
            LOCAL oGesture := oEvent:gesture( Qt_TapAndHoldGesture )
            IF ! Empty( oGesture )
               oPointF := oGesture:hotSpot()
               oGesture := oGesture:__toTapAndHoldGesture()
               IF oGesture:state() == Qt_GestureStarted
                  ::contextMenuScene( oPointF:x(), oPointF:y() )
               ENDIF
            ENDIF
            RETURN .T.
         } )
#endif
#endif
   ENDWITH
   WITH OBJECT ::oPropWidget := ::oUI:pageProperties
      //
   ENDWITH

   WITH OBJECT ::oNavgtTree := ::oUI:treeNavigator
      __hbqtApplyStandardScroller( ::oNavgtTree )
      :connect( "itemClicked(QTreeWidgetItem*,int)", {|p,p1| ::execEvent( __treeObjects_clicked__, p, p1 ) } )
   ENDWITH
   WITH OBJECT ::oDataTree := ::oUI:treeWidgetData
      __hbqtApplyStandardScroller( ::oDataTree )
   ENDWITH
   WITH OBJECT ::oVisualsTree := ::oUI:treeVisuals
      __hbqtApplyStandardScroller( ::oVisualsTree )
      :connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|p,p1| ::execEvent( __treeVisuals_currentItemChanged__, p, p1 ) } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)"              , {|p,p1| ::execEvent( __treeVisuals_dblClicked__, p, p1 ) } )
      :connect( "itemClicked(QTreeWidgetItem*,int)"                    , {|p,p1| ::execEvent( __treeVisuals_dblClicked__, p, p1 ) } )
   ENDWITH
   WITH OBJECT ::oMarkersTree := ::oUI:treeMarkers
      __hbqtApplyStandardScroller( ::oMarkersTree )
      :connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|p,p1| ::execEvent( __treeMarkers_currentItemChanged__, p, p1 ) } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)"              , {|p,p1| ::execEvent( __treeMarkers_clicked__, p, p1 ) } )
      :connect( "itemClicked(QTreeWidgetItem*,int)"                    , {|p,p1| ::execEvent( __treeMarkers_clicked__, p, p1 ) } )
   ENDWITH
   WITH OBJECT ::oFiltersTree := ::oUI:treeFilter
      __hbqtApplyStandardScroller( ::oFiltersTree )
      :setStyleSheet( ;
          "QTreeView::item:text {margin-left: 2px;}" + ;
          "QTreeView::indicator {width: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator {height: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator:unchecked {image: url(" + __hbqtImage( "checkbox-unchecked-g" ) + ");}" + ;
          "QTreeView::indicator:checked {image: url(" + __hbqtImage( "checkbox-checked-g" ) + ");}" )
   ENDWITH
   WITH OBJECT ::oChangeLayerTree := ::oUI:treeChangeLayer
      __hbqtApplyStandardScroller( ::oChangeLayerTree )
      :setStyleSheet( ;
          "QTreeView::item:text {margin-left: 2px;}" )
   ENDWITH
   WITH OBJECT ::oLayersTree := ::oUI:treeLayers
      __hbqtApplyStandardScroller( ::oLayersTree )
#if 1
      :setStyleSheet( ;
          "QTreeView::item:text {margin-left: 2px;}" + ;
          "QTreeView::indicator {width: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator {height: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator:unchecked {image: url(" + __hbqtImage( "eye-close-48" ) + ");}" + ;
          "QTreeView::indicator:checked {image: url(" + __hbqtImage( "eye-open-48" ) + ");}" )
#else
      :setStyleSheet( ;
          "QTreeView::item:text {margin-left: 2px;}" + ;
          "QTreeView::indicator {width: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator {height: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator:unchecked {image: url(" + __hbqtImage( "checkbox-unchecked" ) + ");}" + ;
          "QTreeView::indicator:checked {image: url(" + __hbqtImage( "checkbox-checked" ) + ");}" )
#endif
   ENDWITH

   ::buildStatusBar()
   ::oUI:vLayoutBaseNew:addWidget( ::oStatusBar )

   //::oUI:pageVisuals:setStyleSheet( __hbqtTreeViewStyleSheet() )
   ::oUI:pageObjects:setStyleSheet( __hbqtTreeViewStyleSheet() )
#if 0
   ::oUI:pageResizer:setStyleSheet( "QWidget#pageResizer{ background: rgb(255,255,255);}" ;
                                      + "QToolButton, QPushButton, QComboBox{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}" ;
                                        + "QToolButton::icon{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}";
                                          + "QComboBox{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}";
                                            + "QComboBox{ max-width: " + __hbqtCssPX( 50 ) + "max-height: " + __hbqtCssPX( 50 ) + "}";
                                              + "QFrame#frameResizeIn, QFrame#frameResizeOut{ background: rgb(255,255,220); border: 1px solid lightgray; }" )

   ::oUI:pageMover:setStyleSheet( "QWidget#pageMover{ background: rgb(255,255,255);}" ;
                                    + "QToolButton, QPushButton{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}" ;
                                      + "QToolButton::icon{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}";
                                        + "QComboBox{ min-width: " + __hbqtCssPX( 50 ) + "min-height: " + __hbqtCssPX( 50 ) + "}";
                                          + "QFrame#frameMover{ background: rgb(255,255,220); border: 1px solid lightgray; }" )
#endif
   ::oUI:pageGraphicsView   :setStyleSheet( "QWidget#pageGraphicsView{ background: rgb(170,170,170);}" )

   ::oUI:frameResizeOut     :setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameResizeIn      :setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameMover         :setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameMover         :setMaximumHeight( __hbqtPixelsByDPI( 200 ) )

   ::oUI:toolOutTopLeft     :connect( "clicked()", {|| ::resizeMarker( 1 ) } )
   ::oUI:toolOutUp          :connect( "clicked()", {|| ::resizeMarker( 2 ) } )
   ::oUI:toolOutTopRight    :connect( "clicked()", {|| ::resizeMarker( 3 ) } )
   ::oUI:toolOutRight       :connect( "clicked()", {|| ::resizeMarker( 4 ) } )
   ::oUI:toolOutBottomRight :connect( "clicked()", {|| ::resizeMarker( 5 ) } )
   ::oUI:toolOutDown        :connect( "clicked()", {|| ::resizeMarker( 6 ) } )
   ::oUI:toolOutBottomLeft  :connect( "clicked()", {|| ::resizeMarker( 7 ) } )
   ::oUI:toolOutLeft        :connect( "clicked()", {|| ::resizeMarker( 8 ) } )
   ::oUI:toolOutAll         :connect( "clicked()", {|| ::resizeMarker( 9 ) } )

   ::oUI:toolInTopLeft      :connect( "clicked()", {|| ::resizeMarker( 10 ) } )
   ::oUI:toolInUp           :connect( "clicked()", {|| ::resizeMarker( 11 ) } )
   ::oUI:toolInTopRight     :connect( "clicked()", {|| ::resizeMarker( 12 ) } )
   ::oUI:toolInRight        :connect( "clicked()", {|| ::resizeMarker( 13 ) } )
   ::oUI:toolInBottomRight  :connect( "clicked()", {|| ::resizeMarker( 14 ) } )
   ::oUI:toolInDown         :connect( "clicked()", {|| ::resizeMarker( 15 ) } )
   ::oUI:toolInBottomLeft   :connect( "clicked()", {|| ::resizeMarker( 16 ) } )
   ::oUI:toolInLeft         :connect( "clicked()", {|| ::resizeMarker( 17 ) } )
   ::oUI:toolInAll          :connect( "clicked()", {|| ::resizeMarker( 18 ) } )

   ::oUI:btnResizeToDefault :connect( "clicked()", {|| ::resizeMarker( 21 ) } )

   ::oUI:toolMoveTopLeft    :connect( "clicked()", {|| ::moveMarker( 1 ) } )
   ::oUI:toolMoveUp         :connect( "clicked()", {|| ::moveMarker( 2 ) } )
   ::oUI:toolMoveTopRight   :connect( "clicked()", {|| ::moveMarker( 3 ) } )
   ::oUI:toolMoveRight      :connect( "clicked()", {|| ::moveMarker( 4 ) } )
   ::oUI:toolMoveBottomRight:connect( "clicked()", {|| ::moveMarker( 5 ) } )
   ::oUI:toolMoveDown       :connect( "clicked()", {|| ::moveMarker( 6 ) } )
   ::oUI:toolMoveBottomLeft :connect( "clicked()", {|| ::moveMarker( 7 ) } )
   ::oUI:toolMoveLeft       :connect( "clicked()", {|| ::moveMarker( 8 ) } )

   RETURN Self


METHOD HbQtVisualizer:activateScene()

   ::oCurScene := ::oCurHbQtVisual:scene()
   ::oGraphicsView:setScene( ::oCurScene )
#ifndef __ios__
   ::oHbQtPreview:refreshPreview()
#endif
   __hbqGraphics_AllowMovement( ::lEditingOn )
   ::switchItemOptions( .F. )
   ::manageEditing( .F. )

   RETURN Self


METHOD HbQtVisualizer:setSplitterSizes( nFrameLeftWidth, nFrameRightWidth )

   DEFAULT nFrameLeftWidth  TO ::nFrameLeftWidth
   DEFAULT nFrameRightWidth TO ::nFrameRightWidth

   ::nFrameLeftWidth  := nFrameLeftWidth
   ::nFrameRightWidth := nFrameRightWidth

   ::splitter():hbSetSizes( { __hbqtPixelsByDPI( ::nFrameLeftWidth ), ;
                              ::splitter():width() - ::nFrameLeftWidth - ::nFrameRightWidth, ;
                              __hbqtPixelsByDPI( ::nFrameRightWidth ) } )
   RETURN Self


METHOD HbQtVisualizer:setOption( nOption, xValue )
   LOCAL xOldValue

   SWITCH nOption
   CASE __HBQT_VISUALIZER_OPTION_RESIZEINPLACE__
      xOldValue := ::lResizeInPlace
      IF HB_ISLOGICAL( xValue )
         ::lResizeInPlace := xValue
         __hbqGraphics_allowResizeInPlace( xValue )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN iif( xOldValue == NIL, xValue, xOldValue )


METHOD HbQtVisualizer:execEvent( nEvent, p, p1, p2 )
   LOCAL i, nScaleFactor, xTmp

   SWITCH nEvent
   CASE __graphicsScene_block__
      DO CASE
      CASE p == 21107                             // Left button pressed nowhere on an item
         ::objectSelected()
         ::placeObject( p1, p2 )                  // scene coordinates
         ::objectSelected()
      CASE p == 21131                             // double-click
         IF ::lZoomLocate
            ::lZoomLocate := .F.
            ::oGraphicsView:resetMatrix()
            ::oGraphicsView:setTransform( ::oZoomTrans )
            ::oGraphicsView:centerOn( p1, p2 )
         ELSE
            nScaleFactor := 1.15
            IF ::lDoubleClickZoom
               FOR i := 1 TO 10
                  ::oGraphicsView:scale( 1 / nScaleFactor, 1 / nScaleFactor )
               NEXT
            ELSE
               FOR i := 1 TO 10
                  ::oGraphicsView:scale( nScaleFactor, nScaleFactor )
               NEXT
            ENDIF
            ::lDoubleClickZoom := ! ::lDoubleClickZoom
            ::oGraphicsView:centerOn( p1, p2 )
         ENDIF
      CASE p == 21001                             // at initialization
         ::nScreenDpiX := p1
         ::nScreenDpiY := p2
      CASE p == QEvent_GraphicsSceneContextMenu
         ::contextMenuScene( p1:screenPos():x(), p1:screenPos():y() )
      ENDCASE
      EXIT
   CASE __treeObjects_clicked__
      IF ! Empty( xTmp := ::oCurHbQtVisual:item( p:text( 0 ) ) )
         ::objectSelected( xTmp )
         ::oGraphicsView:centerOn( xTmp:widget() )   // should it be like this ?
      ENDIF
      EXIT
   CASE __treeMarkers_currentItemChanged__
      IF ::cCurrentMarkerV != p:whatsThis( 0 )
         ::clearMarker()
      ENDIF
      EXIT
   CASE __treeMarkers_clicked__
      IF ::cCurrentMarkerV == p:whatsThis( 0 )
         ::clearMarker()
      ELSE
         ::setMarker( p )
      ENDIF
      EXIT
   CASE __treeVisuals_currentItemChanged__
      EXIT
   CASE __treeVisuals_dblClicked__
      IF p:childCount() == 0
         IF ::oCurHbQtVisual:refID() != p:whatsThis( 0 )
            p:setSelected( .T. )
            ::loadVisual( p:whatsThis( 0 ) )
         ENDIF
      ENDIF
      EXIT
   CASE __buttonOpen_clicked__
      ::openReport()
      EXIT
   ENDSWITCH

   ::switchItemOptions( ! Empty( ::oCurGraphicsItem ) )
   RETURN Self


METHOD HbQtVisualizer:setMarker( oGraphicsItem )
   IF oGraphicsItem:childCount() == 0
      WITH OBJECT oGraphicsItem
         ::cCurrentMarkerV := :whatsThis( 0 )
         :setSelected( .T. )
         :setBackground( 0, __hbqtGradientBrush( QColor( Qt_yellow ), QColor( Qt_red ), 0 ) )
      ENDWITH
      ::oCurrentMarkersItem := oGraphicsItem
      ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:clearMarker()
   ::oMarkersTree:clearSelection()
   IF ! Empty( ::oCurrentMarkersItem )
      //::oCurrentMarkersItem:setBackground( 0, QBrush( Qt_white ) )
      ::oCurrentMarkersItem:setBackground( 0, QBrush() )
   ENDIF
   ::cCurrentMarkerV := NIL
   ::oCurrentMarkersItem := NIL
   ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   RETURN Self


METHOD HbQtVisualizer:itemActionsBlock( oHbQtVisualItem, nAction, xData )

   SWITCH nAction
   CASE HBQT_GRAPHICSITEM_SELECTED
      ::objectSelected( oHbQtVisualItem )
      EXIT
   CASE HBQT_GRAPHICSITEM_DELETED
      ::objectDeleted( oHbQtVisualItem )
      oHbQtVisualItem:visual():edited( .T. )
      EXIT
   CASE HBQT_GRAPHICSITEM_GEOMETRYCHANGED
      ::objectGeometryChanged( oHbQtVisualItem )
      oHbQtVisualItem:visual():edited( .T. )
      EXIT
   CASE HBQT_GRAPHICSITEM_REQUESTDATA
      IF HB_ISBLOCK( ::itemDataRequestBlock() )
         Eval( ::itemDataRequestBlock(), xData )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtVisualizer:toggleLockOnObject()
   IF HB_ISOBJECT( ::oCurGraphicsItem )
      ::oCurGraphicsItem:toggleLock()
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:objectGeometryChanged( oHbQtVisualItem )
   LOCAL hProp := {=>}
   LOCAL oRect := oHbQtVisualItem:geometry()

   hProp[ "x"      ] := oRect:x()
   hProp[ "y"      ] := oRect:y()
   hProp[ "width"  ] := oRect:width()
   hProp[ "height" ] := oRect:height()

   ::oPropManager:setPropertySheetProperties( "GraphicObjects", hProp )
   ::updateItemStatus( oHbQtVisualItem )
   RETURN Self


METHOD HbQtVisualizer:objectDeleted( oHbQtVisualItem )
   LOCAL oParent, cName

   IF HB_ISOBJECT( oHbQtVisualItem )
      cName := oHbQtVisualItem:name()
      IF hb_hHasKey( ::hNavgtTreeItems, cName )
         IF ! oHbQtVisualItem:isLocked()
            oParent := ::hNavgtTreeItems[ cName ]:parent()
            oParent:removeChild( ::hNavgtTreeItems[ cName ] )
            ::hNavgtTreeItems[ cName ] := NIL
            hb_HDel( ::hNavgtTreeItems, cName )
            ::oCurScene:removeItem( oHbQtVisualItem:oWidget )
            ::oCurHbQtVisual:delItem( cName )
            QApplication():processEvents()
         ENDIF
      ENDIF
   ENDIF
   ::oCurGraphicsItem := NIL
   ::switchItemOptions( ! Empty( ::oCurGraphicsItem ) )
   RETURN Self


METHOD HbQtVisualizer:rotateMarker( oCurGraphicsItem, nDirection )
   IF !empty( oCurGraphicsItem )
      oCurGraphicsItem:rotate( iif( nDirection == 1, 5, -5 ) )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:deleteState( oHbQtVisualItem )
   IF HB_ISOBJECT( oHbQtVisualItem )
      oHbQtVisualItem:setState( NIL )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:objectSelected( oHbQtVisualItem )
   LOCAL cName := iif( HB_ISOBJECT( oHbQtVisualItem ), oHbQtVisualItem:name(), "x.x" )

   ::oNavgtTree:clearSelection()

   IF ! Empty( ::oCurGraphicsItem )
      ::oCurGraphicsItem:unselect()
   ENDIF
   IF hb_hHasKey( ::hNavgtTreeItems, cName )
      ::oCurGraphicsItem := ::oCurHbQtVisual:item( cName )
      ::oNavgtTree:setCurrentItem( ::hNavgtTreeItems[ cName ] )
      ::oCurGraphicsItem:select()
   ELSE
      ::oCurGraphicsItem := NIL
   ENDIF
   ::populatePropertySheet( ::oCurGraphicsItem )
   ::populateDataSheet( ::oCurGraphicsItem )
   IF ! Empty( ::cCurrentState ) .AND. ! Empty( ::oCurGraphicsItem ) .AND. ::oCurHbQtVisual:editingMode()
      ::oCurGraphicsItem:setState( ::hVisualsStates[ ::cCurrentState ][ "HbQtVisualItemState" ] )
      ::oStatesToolbar:click( ::cCurrentState )
   ELSEIF ! Empty( ::cCurrentState )
      ::oStatesToolbar:click( ::cCurrentState )
   ENDIF
   ::switchItemOptions( ! Empty( ::oCurGraphicsItem ) )
   ::updateItemStatus( ::oCurGraphicsItem )
#if 0
   IF ! Empty( ::oCurGraphicsItem )
      ::oUI:comboChangeLayer:setCurrentText( iif( Empty( ::oCurGraphicsItem:layer() ), "...ROOT...", ::oCurGraphicsItem:layer() ) )
   ENDIF
#endif
   ::setupCurrentChangeLayer()
   RETURN Self


METHOD HbQtVisualizer:updateItemStatus( oHbQtVisualItem )
   LOCAL oRect, cMsg

   IF ! Empty( oHbQtVisualItem )
      oRect:= oHbQtVisualItem:geometry()
      cMsg := oHbQtVisualItem:name() + "[" + ft_Proper( Trim( oHbQtVisualItem:layer() ) ) + "(" + ;
                                       LTrim( Str( oRect:x(), 7, 0 ) ) + "," + LTrim( Str( oRect:y(), 7, 0 ) ) + ")]"
   ELSE
      cMsg := ""
   ENDIF
   ::showStatus( STATUS_PANEL_READY, cMsg )
   RETURN Self


METHOD HbQtVisualizer:populateDataSheet( oHbQtVisualItem )

   IF HB_ISOBJECT( ::oDataManager )
      IF Empty( oHbQtVisualItem )
         ::oDataManager:setPropertySheetProperties( "MarkersData", ::dataStructureProperties() )
      ELSE
         ::oDataManager:setPropertySheetProperties( "MarkersData", oHbQtVisualItem:getDataEx(), .T. )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:dataStructureProperties()
   LOCAL hTmp
   LOCAL hProp := __hbqtStandardHash()

   FOR EACH hTmp IN ::hDataStruct
      hProp[ hTmp[ "Field" ] ] := hTmp[ "Value" ]
   NEXT
   RETURN hb_HClone( hProp )


METHOD HbQtVisualizer:dataPropertyChanged( cSheet, cProperty, xValue )
   IF HB_ISOBJECT( ::oCurGraphicsItem )
      ::oCurGraphicsItem:setDataValue( cProperty, xValue )
   ENDIF
   HB_SYMBOL_UNUSED( cSheet )
   RETURN Self


METHOD HbQtVisualizer:populatePropertySheet( oHbQtVisualItem )
   IF HB_ISOBJECT( ::oPropManager )
      IF Empty( oHbQtVisualItem )
         ::oPropManager:setPropertySheetProperties( "GraphicObjects", __hbqtDefaultVisualProperties() )
      ELSE
         ::oPropManager:setPropertySheetProperties( "GraphicObjects", oHbQtVisualItem:getProperties() )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:clear()

   ::oNavgtTree:clear()
   ::oDataTree:clear()

   ::hNavgtTreeItems := __hbqtStandardHash()

   ::aPages      := {}
   ::aSources    := {}
   ::aRptObjects := {}
   ::aRptPages   := {}

   RETURN Self


METHOD HbQtVisualizer:saveVisual( oHbQtVisual )
   LOCAL hVisual, hRspns

   DEFAULT oHbQtVisual TO ::oCurHbQtVisual

   IF ! Empty( oHbQtVisual ) .AND. oHbQtVisual:editingMode() .AND. oHbQtVisual:edited() .AND. HB_ISBLOCK( ::visualsSaveBlock() )
      IF Alert( "Save [" + oHbQtVisual:title() + "] ?", { "Yes", "No" } ) == 1
         HbQtActivateSilverLight( .T., "Saving Visual..." + oHbQtVisual:refID() )
         IF ! Empty( hVisual := ::buildVisualStream( oHbQtVisual ) )
            oHbQtVisual:edited( .F. )
            hRspns := Eval( ::visualsSaveBlock(), oHbQtVisual:refID(), oHbQtVisual:version(), hVisual )
            IF HB_ISHASH( hRspns ) .AND. hb_HHasKey( hRspns, "version" )
               oHbQtVisual:version( hRspns[ "version" ] )
            ENDIF
         ENDIF
         HbQtActivateSilverLight( .F., "Saving Visual..." + oHbQtVisual:refID() )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:buildVisualStream( oHbQtVisual )
   LOCAL a_, dat_, oHbQtVisualItem, hProp
   LOCAL hVisual := __hbqtStandardHash()
   LOCAL f_:= { "Normal", "Italic", "Bold", "Bold Italic" }

   DEFAULT oHbQtVisual TO ::oCurHbQtVisual

   dat_:= {}
   FOR EACH oHbQtVisualItem IN ::oCurHbQtVisual:items()
      a_:= Array( __VZOBJ_VARIABLES__ )

      WITH OBJECT oHbQtVisualItem
         hProp := :getProperties()

         a_[ __VZOBJ_CLASS__          ] := :type()
         a_[ __VZOBJ_TYPE__           ] := iif( Empty( :marker() ), :type(), :marker() )
         a_[ __VZOBJ_NAME__           ] := :name()
         a_[ __VZOBJ_LOCKED__         ] := :isLocked()
         a_[ __VZOBJ_STATE__          ] := iif( Empty( :state() ), "", :state():name() )

         a_[ __VZOBJ_X__              ] := hProp[ "x"      ]
         a_[ __VZOBJ_Y__              ] := hProp[ "y"      ]
         a_[ __VZOBJ_WIDTH__          ] := hProp[ "width"  ]
         a_[ __VZOBJ_HEIGHT__         ] := hProp[ "height" ]
         a_[ __VZOBJ_ROTATION__       ] := :rotation()

         a_[ __VZOBJ_PENSTYLE__       ] := __hbqtStyleConvert( "penStyle"  , hProp[ "penStyle"    ] )
         a_[ __VZOBJ_PENWIDTH__       ] := hProp[ "penWidth"    ]
         a_[ __VZOBJ_PENCOLOR__       ] := hProp[ "penColor"    ]
         a_[ __VZOBJ_CAPSTYLE__       ] := __hbqtStyleConvert( "capStyle"  , hProp[ "capStyle"    ] )
         a_[ __VZOBJ_JOINSTYLE__      ] := __hbqtStyleConvert( "joinStyle" , hProp[ "joinStyle"   ] )
         a_[ __VZOBJ_MITTERLIMIT__    ] := hProp[ "miterLimit"  ]
         a_[ __VZOBJ_BRUSHSTYLE__     ] := __hbqtStyleConvert( "brushStyle", hProp[ "brushStyle"  ] )
         a_[ __VZOBJ_BRUSHCOLOR__     ] := hProp[ "brushColor"  ]
         a_[ __VZOBJ_BBRUSHSTYLE__    ] := __hbqtStyleConvert( "brushStyle", hProp[ "bBrushStyle" ] )
         a_[ __VZOBJ_BBRUSHCOLOR__    ] := hProp[ "bBrushColor" ]
         a_[ __VZOBJ_BACKGROUNDMODE__ ] := iif( hProp[ "backgroundMode" ] == "TransparentMode", Qt_TransparentMode, Qt_OpaqueMode )
         a_[ __VZOBJ_OPACITY__        ] := hProp[ "opacity"     ]
         a_[ __VZOBJ_FONTFAMILY__     ] := iif( Empty( hProp[ "text" ] ), "",hProp[ "fontFamily"  ] )
         a_[ __VZOBJ_FONTSTYLE__      ] := AScan( f_, hProp[ "fontStyle" ] )
         a_[ __VZOBJ_FONTSIZE__       ] := hProp[ "fontSize"    ]
         a_[ __VZOBJ_TEXT__           ] := hProp[ "text"        ]
         a_[ __VZOBJ_DATA__           ] := :getDataEx()
         a_[ __VZOBJ_LAYER__          ] := :layer()

         AAdd( dat_, a_ )
      ENDWITH
   NEXT
   hVisual[ "objects" ] := dat_
   // other information
   RETURN hVisual


METHOD HbQtVisualizer:toString( oHbQtVisual )
   DEFAULT oHbQtVisual TO ::oCurHbQtVisual
   RETURN ::buildVisualStream( oHbQtVisual )


METHOD HbQtVisualizer:presentBlankVisual()

   AAdd( ::aPages, { ::cNavigtTreePage } )

   ::updateObjectsTree( "Visual", NIL, ::oCurHbQtVisual:title() )
   ::updateObjectsTree( "Page", "Visual", ::cNavigtTreePage )

   IF ! Empty( ::oCurHbQtVisual:transform() )
      ::oGraphicsView:setTransform( ::oCurHbQtVisual:transform() )
      ::oGraphicsView:verticalScrollBar():setValue( ::oCurHbQtVisual:vertPos() )
      ::oGraphicsView:horizontalScrollBar():setValue( ::oCurHbQtVisual:horzPos() )
   ELSE
      ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:populateVisual()
   LOCAL hItems, oHbQtVisualItem, aItems, aItem, oGeo, oPos

   ::clear()
   ::presentBlankVisual()

   IF ! Empty( hItems := ::oCurHbQtVisual:items() )
      FOR EACH oHbQtVisualItem IN hItems
         ::updateObjectsTree( "Object", ::cNavigtTreePage, oHbQtVisualItem:name(), oHbQtVisualItem:type(), oHbQtVisualItem:pixmap() )
      NEXT

   ELSEIF ! Empty( aItems := ::oCurHbQtVisual:objects() )
      FOR EACH aItem IN aItems
         oPos := QPointF( aItem[ __VZOBJ_X__ ], aItem[ __VZOBJ_Y__ ] )
         oGeo := QRectF( 0.0, 0.0, aItem[ __VZOBJ_WIDTH__ ], aItem[ __VZOBJ_HEIGHT__ ] )

         IF Upper( aItem[ __VZOBJ_CLASS__ ] ) == "MARKER"
            oHbQtVisualItem := ::addObject( "Marker_" + aItem[ __VZOBJ_TYPE__ ], oPos, oGeo, aItem[ __VZOBJ_NAME__ ] )
         ELSE
            oHbQtVisualItem := ::addObject( aItem[ __VZOBJ_TYPE__ ], oPos, oGeo, aItem[ __VZOBJ_NAME__ ] )
         ENDIF
         WITH OBJECT oHbQtVisualItem
            :setVisual( ::oCurHbQtVisual )

            :setRotation( aItem[ __VZOBJ_ROTATION__ ] )
            :setLocked( aItem[ __VZOBJ_LOCKED__ ] )
            IF ! Empty( aItem[ __VZOBJ_STATE__ ] )
               :setState( ::hVisualsStates[ aItem[ __VZOBJ_STATE__ ] ][ "HbQtVisualItemState" ] )
            ENDIF
            //
            :setPenProperties( "penStyle"      , __hbqtStyleConvert( "penStyle", aItem[ __VZOBJ_PENSTYLE__    ] ) )
            :setPenProperties( "penWidth"      , aItem[ __VZOBJ_PENWIDTH__    ] )
            :setPenProperties( "penColor"      , aItem[ __VZOBJ_PENCOLOR__    ] )
            :setPenProperties( "capStyle"      , __hbqtStyleConvert( "capStyle", aItem[ __VZOBJ_CAPSTYLE__    ] ) )
            :setPenProperties( "joinStyle"     , __hbqtStyleConvert( "joinStyle", aItem[ __VZOBJ_JOINSTYLE__   ] ) )
            :setPenProperties( "miterLimit"    , aItem[ __VZOBJ_MITTERLIMIT__  ] )
            :setBrushProperties( "brushStyle"  , __hbqtStyleConvert( "brushStyle", aItem[ __VZOBJ_BRUSHSTYLE__  ] ) )
            :setBrushProperties( "brushColor"  , aItem[ __VZOBJ_BRUSHCOLOR__  ] )
            :setBBrushProperties( "bBrushStyle", __hbqtStyleConvert( "brushStyle", aItem[ __VZOBJ_BBRUSHSTYLE__ ] ) )
            :setBBrushProperties( "bBrushColor" , aItem[ __VZOBJ_BBRUSHCOLOR__ ] )
            :setFontProperties( "fontFamily"   , aItem[ __VZOBJ_FONTFAMILY__  ] )
            :setFontProperties( "fontStyle"    , { "Normal","Italic","Bold", "Bold Italic" }[ aItem[ __VZOBJ_FONTSTYLE__ ] ] )
            :setFontProperties( "fontSize"     , hb_ntos( aItem[ __VZOBJ_FONTSIZE__ ] ) )
            :setText( aItem[ __VZOBJ_TEXT__ ] )
            :nOpacity        := aItem[ __VZOBJ_OPACITY__ ]
            :cBackgroundMode := iif( aItem[ __VZOBJ_BACKGROUNDMODE__ ] == Qt_OpaqueMode, "OpaqueMode", "TransparentMode" )
            //
            :setData( aItem[ __VZOBJ_DATA__ ] )
            :setLayer( aItem[ __VZOBJ_LAYER__ ] )
            //
            :update()
            ::oCurHbQtVisual:edited( .F. )
         ENDWITH

         ::oCurHbQtVisual:objects( {} )
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:addObject( cType, oPos, oGeo, cName )
   LOCAL oGrad, oHbQtVisualItem, aGeo, aPos, cMarker, oPixmap, nWidth, nHeight, hCargo

   aPos := iif( empty( oPos ), NIL, { oPos:x(), oPos:y() } )
   aGeo := iif( empty( oGeo ), NIL, { oGeo:x(), oGeo:y(), oGeo:width(), oGeo:height() } )

   IF Left( cType, 6 ) == "Marker"
      cMarker := SubStr( cType, 8 )
      cType   := "Marker"
      cName   := ::oCurHbQtVisual:getName( cMarker, cName )
      nWidth  := ::oCurHbQtVisual:getMarkerProperty( cMarker, "Width" , nWidth  )
      nHeight := ::oCurHbQtVisual:getMarkerProperty( cMarker, "Height", nHeight )

      hCargo := __hbqtStandardHash()
      hCargo[ "Marker" ] := cMarker
   ELSE
      cName := ::oCurHbQtVisual:getName( cType, cName )
   ENDIF

   WITH OBJECT oHbQtVisualItem := HbQtVisualItem():new():create( cType, cName, aPos, aGeo, nWidth, nHeight, hCargo )

      :actionsBlock := {|oHbQtVisualItem,nAction,xData| ::itemActionsBlock( oHbQtVisualItem, nAction, xData ) }

      SWITCH Upper( cType )
      CASE "MARKER"
         oPixmap := ::oCurHbQtVisual:getMarkerProperty( cMarker, "Pixmap", oPixmap )
         :setPixmap( oPixmap )
         :setBorderWidth( 2 )
         :setData( __hbqtMergeMarkerData( ::hDataStruct, ::oCurHbQtVisual:marker( cMarker ) ) )
         EXIT
      CASE "IMAGE"
         :setPixmap( QPixmap( __hbqtImage( "harbour" ) ) )
         :setBorderWidth( 2 )
         EXIT
      CASE "CHART"
         EXIT
      CASE "GRADIENT"
         WITH OBJECT oGrad := QLinearGradient()
            :setColorAt( 0, QColor( 195,225,255 ) )
            :setColorAt( 1, QColor( Qt_darkBlue ):darker( 150 ) )
            :setCoordinateMode( QGradient_StretchToDeviceMode )
         ENDWITH
         :setBrush( QBrush( oGrad ) )
         :setPen( QPen( Qt_NoPen ) )
         EXIT
      CASE "BARCODE"
         :setText( "Harbour" )
         :setBarcodeType( HQR_BARCODE_3OF9 )
         EXIT
      CASE "TEXT"
         :setText( "Text" )
         EXIT
      ENDSWITCH

      ::oCurScene:addItem( :oWidget )

      :setVisual( ::oCurHbQtVisual )
      ::oCurHbQtVisual:edited( .T. )

      oHbQtVisualItem:setLayer( ::oCurHbQtVisual:layer() )
   ENDWITH

   ::oCurHbQtVisual:addItem( cName, oHbQtVisualItem )
   ::updateObjectsTree( "Object", ::cNavigtTreePage, cName, cType, oPixmap )

   RETURN oHbQtVisualItem


METHOD HbQtVisualizer:manageEditClicked( lChecked )
   LOCAL lOn := lChecked
   LOCAL hRspns

   IF Empty( ::oCurHbQtVisual )
      IF lChecked
         ::oToolbar:setState( "Edit", 2 )
         RETURN Self
      ENDIF
   ENDIF

   IF lChecked                                    // pressed first time
      ::oCurHbQtVisual:edited( .F. )              // start with a clean state
      IF HB_ISBLOCK( ::visualInfoBlock() )
         HbQtActivateSilverLight( .T., "Requesting Editing Info..." )
         hRspns := ::execInfoBlock( "canEdit" )
         HbQtActivateSilverLight( .F. )
      ENDIF
      IF HB_ISHASH( hRspns )
         IF hRspns[ "response" ] == "NO"
            ::oToolbar:setState( "Edit", 2 )
            HbQtActivateSilverLight( .T., "..." )
            Alert( hRspns[ "alert" ] )
            HbQtActivateSilverLight( .F. )
            RETURN Self
         ENDIF
      ELSE
         ::oToolbar:setState( "Edit", 2 )
         Alert( "Seems some problem with the server!" )
         RETURN Self
      ENDIF
      ::oCurHbQtVisual:editingMode( .T. )
      ::animateVisualsTree()
   ELSE
      IF ::oCurHbQtVisual:editingMode()           // it must be true
         IF ::oCurHbQtVisual:edited()
            ::saveVisual()
         ENDIF
         Eval( ::visualInfoBlock(), "doneEdit", ::oCurHbQtVisual:refID(), ::oCurHbQtVisual:version(), NIL )
         ::oCurHbQtVisual:editingMode( .F. )
         ::animateVisualsTree()
      ENDIF
   ENDIF

   ::manageEditing( lOn )
   RETURN Self


METHOD HbQtVisualizer:manageEditing( lOn )
   LOCAL lSwitchOn

   IF ! Empty( ::oCurHbQtVisual ) .AND. ::oCurHbQtVisual:editingMode()
      lOn := .T.
   ENDIF
   IF lOn
      ::oToolbar:setState( "Edit", 3 )
   ELSE
      ::oToolbar:setState( "Edit", 2 )
   ENDIF
   ::lEditingOn := lOn
   __hbqGraphics_AllowMovement( lOn )

   IF ! ::lEditingOn .OR. Empty( ::oCurGraphicsItem )
      lSwitchOn := .F.
   ELSE
      lSwitchOn := ::lEditingOn
   ENDIF
   WITH OBJECT ::oToolbar
      :setEnabled( "RotateM"    , lSwitchOn )
      :setEnabled( "RotateML"   , lSwitchOn )
      :setEnabled( "DelState"   , lSwitchOn )
      :setEnabled( "Delete"     , lSwitchOn )
      :setEnabled( "Lock"       , lSwitchOn )
   ENDWITH
   IF ! ::lEditingOn
      IF HB_ISOBJECT( ::oPropManager )
         ::oPropManager:setEnabled( "GraphicObjects", .F. )
      ENDIF
      IF HB_ISOBJECT( ::oDataManager )
         ::oDataManager:setEnabled( "MarkersData", .F. )
      ENDIF
   ENDIF
   IF ::lEditingOn
      __hbqtUndoScroller( ::oGraphicsView )
      QScroller():scroller( ::oGraphicsView ):ungrabGesture( ::oGraphicsView )
      ::oGraphicsView:setDragMode( QGraphicsView_ScrollHandDrag )
   ELSE
      __hbqtApplyStandardScroller( ::oGraphicsView )
      ::oGraphicsView:setDragMode( QGraphicsView_NoDrag )
   ENDIF
   IF lSwitchOn
      ::oToolbarItemEdit:show()
   ELSE
      ::oToolbarItemEdit:hide()
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:switchItemOptions( lOnOff )
   LOCAL lSwitchOn

   IF ! ::lEditingOn
      lSwitchOn := .F.
   ELSE
      lSwitchOn := lOnOff
   ENDIF
   WITH OBJECT ::oToolbar
      :setEnabled( "RotateM"    , lSwitchOn )
      :setEnabled( "RotateML"   , lSwitchOn )
      :setEnabled( "DelState"   , lSwitchOn )
      :setEnabled( "Delete"     , lSwitchOn )
      :setEnabled( "Lock"       , lSwitchOn )
   ENDWITH
   WITH OBJECT ::oToolbarItemEdit
      :setEnabled( "RotateM"    , lSwitchOn )
      :setEnabled( "RotateML"   , lSwitchOn )
      :setEnabled( "DelState"   , lSwitchOn )
      :setEnabled( "Delete"     , lSwitchOn )
      :setEnabled( "Lock"       , lSwitchOn )
   ENDWITH

   IF HB_ISOBJECT( ::oPropManager )
      IF ! lOnOff
         ::populatePropertySheet()
      ENDIF
      ::oPropManager:setEnabled( "GraphicObjects", iif( ::lEditingOn, lOnOff, .F. ) )
   ENDIF
   IF HB_ISOBJECT( ::oDataManager )
      IF ! lOnOff
         ::populateDataSheet()
      ENDIF
      ::oDataManager:setEnabled( "MarkersData", iif( ::lEditingOn, lOnOff, .F. ) )
   ENDIF
   IF lSwitchOn
      ::oToolbarItemEdit:show()
      ::oChangeLayerTree:setEnabled( .T. )
      //::oUI:comboChangeLayer:setEnabled( .T. )
   ELSE
      ::oToolbarItemEdit:hide()
      //::oUI:comboChangeLayer:setEnabled( .F. )
      ::oChangeLayerTree:setEnabled( .F. )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:activatePanning( lActivate )
   IF lActivate
      ::oGraphicsView:horizontalScrollbar():setValue( ::nHSBValue )
      ::oGraphicsView:verticalScrollbar():setValue( ::nVSBValue )
      IF ::lEditingOn
         ::oGraphicsView:setDragMode( QGraphicsView_ScrollHandDrag )
      ELSE
         __hbqtApplyStandardScroller( ::oGraphicsView )
         ::oGraphicsView:setDragMode( QGraphicsView_NoDrag )
      ENDIF
   ELSE
      IF ::lEditingOn
         ::oGraphicsView:setDragMode( QGraphicsView_NoDrag )
      ELSE
         QScroller():scroller( ::oGraphicsView ):ungrabGesture( ::oGraphicsView )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:updateObjectsTree( cType, cParent, cName, cSubType, oPixmap )
   LOCAL oParent, oItem

   DO CASE
   CASE cType == "Visual"
      WITH OBJECT oItem := QTreeWidgetItem()
         :setText( 0, cName )
         :setIcon( 0, QIcon( __hbqtImage( "r-report" ) ) )
      ENDWITH
      ::oNavgtTree:addTopLevelItem( oItem )
      ::hNavgtTreeItems[ cType ] := oItem
      oItem:setExpanded( .t. )

   CASE cType == "Page" .OR. cType == "Object" .OR. cType == "Field"
      IF hb_hHasKey( ::hNavgtTreeItems, cParent )
         oParent := ::hNavgtTreeItems[ cParent ]
      ENDIF
      IF ! empty( oParent )
         IF hb_hHasKey( ::hNavgtTreeItems, cName )
            //
         ENDIF
         oItem := QTreeWidgetItem()
         oItem:setText( 0, cName )
         oParent:addChild( oItem )
         ::hNavgtTreeItems[ cName ] := oItem

         IF cType == "Page"
            oItem:setIcon( 0, QIcon( __hbqtImage( "r-page" ) ) )
         ELSEIF cType == "Object"
            IF ! Empty( oPixmap ) .AND. ! oPixmap:isNull()
               oItem:setIcon( 0, QIcon( oPixmap ) )
            ELSE
               oItem:setIcon( 0, QIcon( ::getImageOfType( cSubType ) ) )
            ENDIF
         ELSEIF cType == "Field"
            oItem:setIcon( 0, QIcon( ::getImageOfType( "Field" ) ) )
         ENDIF

         oParent:setExpanded( .t. )
      ENDIF
   ENDCASE
   RETURN Self


METHOD HbQtVisualizer:manageMarkerVClicks( cMarker )
   IF ::cCurrentMarkerV != cMarker
      ::oObjectsToolbar:setState( ::cCurrentMarkerV, 2 )
      ::cCurrentMarkerV := cMarker
   ELSE
      ::cCurrentMarkerV := NIL
   ENDIF
   ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   RETURN Self


METHOD HbQtVisualizer:placeObject( nSceneX, nSceneY )
   IF ::lEditingOn
      IF ! Empty( ::cCurrentMarkerV )
         ::addObject( ::cCurrentMarkerV, QPoint( nSceneX, nSceneY ), NIL )
         ::clearMarker()
      ENDIF
      ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   ENDIF
   RETURN Self


STATIC FUNCTION  __hbqtTreeWidgetItem( cText, cWhatsThis, cIcon, oFont, nFlags )
   LOCAL oItem

   DEFAULT nFlags TO 0

   WITH OBJECT oItem := QTreeWidgetItem()
      :setText( 0, cText )
      :setWhatsThis( 0, cWhatsThis )
      :setIcon( 0, QIcon( cIcon ) )
      :setFont( 0, oFont )
      :setFlags( Qt_ItemIsEnabled + nFlags )
      :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
   ENDWITH
   RETURN oItem


STATIC FUNCTION __hbqtMergeMarkerData( hDataStruct, hMarkers )
   LOCAL hData, hTmp, cField

   hData := __hbqtStandardHash()

   IF HB_ISHASH( hDataStruct ) .AND. ! Empty( hDataStruct )
      IF HB_ISHASH( hMarkers ) .AND. hb_HHasKey( hMarkers, "Data" )
         FOR EACH hTmp IN hMarkers[ "Data" ]
            cField := hTmp:__enumKey()
            IF hb_HHasKey( hDataStruct, cField )
               hData[ cField ] := hb_HClone( hDataStruct[ cField ] )
               IF hb_HHasKey( hTmp, "Label" )
                  hData[ cField ][ "Label" ] := hTmp[ "Label" ]
               ENDIF
               IF hb_HHasKey( hTmp, "Value" )
                  hData[ cField ][ "Value" ] := hTmp[ "Value" ]
               ENDIF
               IF hb_HHasKey( hTmp, "Options" ) .AND. ! Empty( hTmp[ "Options" ] )
                  hData[ cField ][ "Options" ] := hTmp[ "Options" ]
               ENDIF
            ENDIF
         NEXT
      ELSE
         hData := hb_HClone( hDataStruct )
      ENDIF
   ENDIF
   RETURN hData


METHOD HbQtVisualizer:setTreeNodesBGColor( cKey, oColor )
   LOCAL cClass

   IF HB_ISSTRING( cKey ) .AND. HB_ISOBJECT( oColor )
      cClass :=__objGetClsName( oColor )
      ::hTreeBGBrush[ cKey ] := NIL
      ::hTreeBGBrush[ cKey ] := iif( cClass $ "QCOLOR,QLINEARGRADIENT", QBrush( oColor ), oColor )
   ELSE
      ::hTreeBGBrush[ "Level_1"       ] := QBrush( QColor( 180,180,180 ) )
      ::hTreeBGBrush[ "Level_2"       ] := QBrush( QColor( 220,220,220 ) )
      ::hTreeBGBrush[ "VisualCurrent" ] := __hbqtGradientBrush( QColor( Qt_yellow ), QColor( Qt_red ), 0 )
      ::hTreeBGBrush[ "VisualLoaded"  ] := QBrush( QColor( "#CCFFFF" ) )
      ::hTreeBGBrush[ "VisualEditing" ] := QBrush( QColor( "#CCFFCC" ) )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:buildVisualsTree( hVisualsList )
   LOCAL cRefID, oItem, oIcon, hVisual, cGroup, oGroup, oFont
   LOCAL nIconSize := 32
   LOCAL nItemSize := 40
   LOCAL hGrp := __hbqtStandardHash()

   ::oVisualsTree:setIconSize( QSize( __hbqtPixelsByDPI( nIconSize ), __hbqtPixelsByDPI( nIconSize ) ) )

   oFont := ::oVisualsTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   IF ! Empty( hVisualsList )
      FOR EACH hVisual IN hVisualsList
         IF __hbqtHHasKey( hVisual, "Group", @cGroup ) .AND. ! Empty( cGroup ) .AND. ! hb_HHasKey( hGrp, cGroup )
            WITH OBJECT oGroup := QTreeWidgetItem()
               :setText( 0, cGroup )
               :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
               :setFont( 0, oFont )
               IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
                  :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
               ENDIF
               :setFlags( Qt_ItemIsEnabled )
            ENDWITH
            ::oVisualsTree:addTopLevelItem( oGroup )
            oGroup:setExpanded( .T. )
            hGrp[ cGroup ] := oGroup
         ENDIF
      NEXT

      FOR EACH hVisual IN hVisualsList
         IF __hbqtHHasKey( hVisual, "RefID", @cRefID )
            oIcon := __hbqtIconFromBuffer( hb_base64Decode( hVisual[ "Icon" ] ) )
            WITH OBJECT oItem := QTreeWidgetItem()
               :setText( 0, hVisual[ "Label" ] )
               :setIcon( 0, oIcon )
               :setTooltip( 0, hVisual[ "Purpose" ] )
               :setWhatsThis( 0, cRefID )
               :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
               :setFont( 0, oFont )
               :setFlags( Qt_ItemIsEnabled  )
            ENDWITH
            IF __hbqtHHasKey( hVisual, "Group", @cGroup ) .AND. ! Empty( cGroup )
               hGrp[ cGroup ]:addChild( oItem )
            ELSE
               ::oVisualsTree:addTopLevelItem( oItem )
            ENDIF
            ::hVisualsTree[ cRefID ] := oItem
            oItem:setExpanded( .T.  )
         ENDIF
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:buildMarkersTree()
   LOCAL oItem, oChild, hMarker, oGroup, cGroup, oFont
   LOCAL nIconSize := 32
   LOCAL nItemSize := 40
   LOCAL hGrp := __hbqtStandardHash()

   oFont := ::oMarkersTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   ::oMarkersTree:clear()
   ::oMarkersTree:setIconSize( QSize( __hbqtPixelsByDPI( nIconSize ), __hbqtPixelsByDPI( nIconSize ) ) )

   IF ! Empty( ::oCurHbQtVisual )
      IF ! Empty( ::oCurHbQtVisual:markers() )
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, ::oCurHbQtVisual:title() )
            :setIcon( 0, ::oCurHbQtVisual:icon() )
            :setData( 0, Qt_UserRole, QVariant( "VisualMarkers" ) )
            IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
               :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
            ENDIF
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setFont( 0, oFont )
            :setFlags( Qt_ItemIsEnabled )
         ENDWITH
         ::oMarkersTree:addTopLevelItem( oItem )

         FOR EACH hMarker IN ::oCurHbQtVisual:markers()
            IF __hbqtHHasKey( hMarker, "Group", @cGroup ) .AND. ! Empty( cGroup ) .AND. ! hb_HHasKey( hGrp, cGroup )
               WITH OBJECT oGroup := QTreeWidgetItem()
                  :setText( 0, cGroup )
                  IF hb_HHasKey( ::hTreeBGBrush, "Level_2" )
                     :setBackground( 0, ::hTreeBGBrush[ "Level_2" ] )
                  ENDIF
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
                  :setFont( 0, oFont )
                  :setFlags( Qt_ItemIsEnabled )
               ENDWITH
               oItem:addChild( oGroup )
               hGrp[ cGroup ] := oGroup
               oGroup:setExpanded( .T. )
            ENDIF
         NEXT
         FOR EACH hMarker IN ::oCurHbQtVisual:markers()
            IF hb_HHasKey( hMarker, "Icon" ) .AND. hb_HHasKey( hMarker, "Label" )
               WITH OBJECT oChild := QTreeWidgetItem()
                  :setText( 0, ft_Proper( hMarker[ "Label" ] ) )
                  :setIcon( 0, QIcon( hMarker[ "Pixmap" ] ) )
                  :setWhatsThis( 0, "Marker" + "_" + hMarker:__enumKey() )
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
                  :setFont( 0, oFont )
                  IF __hbqtHHasKey( hMarker, "Group", @cGroup ) .AND. ! Empty( cGroup )
                     hGrp[ cGroup ]:addChild( oChild )
                  ELSE
                     oItem:addChild( oChild )
                  ENDIF
                  :setFlags( Qt_ItemIsEnabled  )
               ENDWITH
            ENDIF
         NEXT
         oItem:setExpanded( .T. )
      ENDIF
   ENDIF

   WITH OBJECT oItem := __hbqtTreeWidgetItem( "Defaults", "", __hbqtImage( "prv_objects-1" ), oFont, NIL )
      IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
         :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
       ENDIF
   ENDWITH
   ::oMarkersTree:addTopLevelItem( oItem )
   WITH OBJECT oItem
      :addChild( __hbqtTreeWidgetItem( "Text"       , "Text"       , __hbqtImage( "text-object"   ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "Barcode"    , "Barcode"    , __hbqtImage( "z-barcode"     ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "Rectangle"  , "Rectangle"  , __hbqtImage( "z-rectangle"   ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "RoundedRect", "RoundedRect", __hbqtImage( "z-roundedrect" ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "Ellipse"    , "Ellipse"    , __hbqtImage( "z-ellipse"     ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "Diamond"    , "Diamond"    , __hbqtImage( "z-diamond"     ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "Triangle"   , "Triangle"   , __hbqtImage( "z-triangle"    ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "LineH"      , "LineH"      , __hbqtImage( "z-lineh"       ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "LineV"      , "LineV"      , __hbqtImage( "z-linev"       ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "LineDR"     , "LineDR"     , __hbqtImage( "z-linedr"      ), oFont ) )
      :addChild( __hbqtTreeWidgetItem( "LineDL"     , "LineDL"     , __hbqtImage( "z-linedl"      ), oFont ) )
   ENDWITH
   oItem:setExpanded( .T. )
   RETURN Self


METHOD HbQtVisualizer:buildFiltersTree()
   LOCAL oItem, oChild, hMarker, oGroup, cGroup, oFont, i
   LOCAL nIconSize := 32
   LOCAL nItemSize := 40
   LOCAL hGrp := __hbqtStandardHash()

   oFont := ::oFiltersTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   ::oFiltersTree:disconnect( "itemChanged(QTreeWidgetItem*,int)" )
   ::oFiltersTree:clear()
   ::oFiltersTree:setIconSize( QSize( __hbqtPixelsByDPI( nIconSize ), __hbqtPixelsByDPI( nIconSize ) ) )

   IF ! Empty( ::oCurHbQtVisual )
#if 0
      IF ! Empty( ::oCurHbQtVisual:layers() )
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, "LAYERS" )
            IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
               :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
            ENDIF
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setFont( 0, oFont )
            :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
            :setCheckState( 0, Qt_Checked )
         ENDWITH
         ::oFiltersTree:addTopLevelItem( oItem )

         FOR EACH cLayer IN ::oCurHbQtVisual:layers()
            WITH OBJECT oChild := QTreeWidgetItem()
               :setText( 0, ft_Proper( cLayer ) )
               :setWhatsThis( 0, "Layer_" + cLayer )
               :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
               :setFont( 0, oFont )
               :setCheckState( 0, Qt_Checked )
               :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
            ENDWITH
            oItem:addChild( oChild )
         NEXT
         oItem:setExpanded( .T. )
      ENDIF
#endif

      IF ! Empty( ::oCurHbQtVisual:markers() )
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, ::oCurHbQtVisual:title() )
            :setIcon( 0, ::oCurHbQtVisual:icon() )
            :setData( 0, Qt_UserRole, QVariant( "VisualMarkers" ) )
            IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
               :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
            ENDIF
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setFont( 0, oFont )
            :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
            :setCheckState( 0, Qt_Checked )
         ENDWITH
         ::oFiltersTree:addTopLevelItem( oItem )

         FOR EACH hMarker IN ::oCurHbQtVisual:markers()
            IF __hbqtHHasKey( hMarker, "Group", @cGroup ) .AND. ! Empty( cGroup ) .AND. ! hb_HHasKey( hGrp, cGroup )
               WITH OBJECT oGroup := QTreeWidgetItem()
                  :setText( 0, cGroup )
                  IF hb_HHasKey( ::hTreeBGBrush, "Level_2" )
                     :setBackground( 0, ::hTreeBGBrush[ "Level_2" ] )
                  ENDIF
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
                  :setFont( 0, oFont )
                  :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
                  :setCheckState( 0, Qt_Checked )
               ENDWITH
               oItem:addChild( oGroup )
               hGrp[ cGroup ] := oGroup
               oGroup:setExpanded( .T. )
            ENDIF
         NEXT
         FOR EACH hMarker IN ::oCurHbQtVisual:markers()
            IF hb_HHasKey( hMarker, "Icon" ) .AND. hb_HHasKey( hMarker, "Label" )
               WITH OBJECT oChild := QTreeWidgetItem()
                  :setText( 0, ft_Proper( hMarker[ "Label" ] ) )
                  :setIcon( 0, QIcon( hMarker[ "Pixmap" ] ) )
                  :setWhatsThis( 0, "Marker" + "_" + hMarker:__enumKey() )
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
                  :setFont( 0, oFont )
                  :setCheckState( 0, Qt_Checked )
                  IF __hbqtHHasKey( hMarker, "Group", @cGroup ) .AND. ! Empty( cGroup )
                     hGrp[ cGroup ]:addChild( oChild )
                  ELSE
                     oItem:addChild( oChild )
                  ENDIF
                  :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
               ENDWITH
            ENDIF
         NEXT
         oItem:setExpanded( .T. )
      ENDIF
   ENDIF

   WITH OBJECT oItem := __hbqtTreeWidgetItem( "Defaults", "", __hbqtImage( "prv_objects-1" ), oFont )
      IF hb_HHasKey( ::hTreeBGBrush, "Level_1" )
         :setBackground( 0, ::hTreeBGBrush[ "Level_1" ] )
      ENDIF
      :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
      :setCheckState( 0, Qt_Checked )
   ENDWITH
   ::oFiltersTree:addTopLevelItem( oItem )
   WITH OBJECT oItem
      :addChild( __hbqtTreeWidgetItem( "Text"       , "Text"       , __hbqtImage( "text-object"   ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "Barcode"    , "Barcode"    , __hbqtImage( "z-barcode"     ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "Rectangle"  , "Rectangle"  , __hbqtImage( "z-rectangle"   ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "RoundedRect", "RoundedRect", __hbqtImage( "z-roundedrect" ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "Ellipse"    , "Ellipse"    , __hbqtImage( "z-ellipse"     ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "Diamond"    , "Diamond"    , __hbqtImage( "z-diamond"     ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "Triangle"   , "Triangle"   , __hbqtImage( "z-triangle"    ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "LineH"      , "LineH"      , __hbqtImage( "z-lineh"       ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "LineV"      , "LineV"      , __hbqtImage( "z-linev"       ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "LineDR"     , "LineDR"     , __hbqtImage( "z-linedr"      ), oFont, Qt_ItemIsUserCheckable ) )
      :addChild( __hbqtTreeWidgetItem( "LineDL"     , "LineDL"     , __hbqtImage( "z-linedl"      ), oFont, Qt_ItemIsUserCheckable ) )
   ENDWITH
   FOR i := 0 TO oItem:childCount() - 1
      oItem:child( i ):setCheckState( 0, Qt_Checked )
   NEXT
   oItem:setExpanded( .T. )

   ::oFiltersTree:connect( "itemChanged(QTreeWidgetItem*,int)", {|p,p1| ::filter( p, p1 ) } )
   RETURN Self


METHOD HbQtVisualizer:filter( oItem, nColumn )
   LOCAL cMarker, oHbQtVisualItem, i
   LOCAL nCheckState := oItem:checkState( 0 )

   IF oItem:childCount() > 0                      // Group or Sub-group
      FOR i := 1 TO oItem:childCount()
         oItem:child( i - 1 ):setCheckState( 0, nCheckState )
      NEXT
   ELSE
      IF ! Empty( cMarker := oItem:whatsThis( 0 ) )
         IF "Layer_" $ cMarker
            cMarker := StrTran( cMarker, "Layer_" )
            ::oCurHbQtVisual:setFilter( cMarker, nCheckState == Qt_Unchecked )
            FOR EACH oHbQtVisualItem IN ::oCurHbQtVisual:items()
               IF oHbQtVisualItem:layer() == cMarker .OR. ( Empty( oHbQtVisualItem:layer() ) .AND. cMarker == "...ROOT..." )
                  IF nCheckState == Qt_Checked
                     oHbQtVisualItem:show()
                  ELSE
                     oHbQtVisualItem:hide()
                  ENDIF
               ENDIF
            NEXT
         ELSEIF "Marker_" $ cMarker
            cMarker := StrTran( cMarker, "Marker_" )
            FOR EACH oHbQtVisualItem IN ::oCurHbQtVisual:items()
               IF ! ::oCurHbQtVisual:isFiltered( oHbQtVisualItem:layer() )
                  IF oHbQtVisualItem:marker() == cMarker
                     IF nCheckState == Qt_Checked
                        oHbQtVisualItem:show()
                     ELSE
                        oHbQtVisualItem:hide()
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ELSE
            cMarker := Upper( cMarker )
            FOR EACH oHbQtVisualItem IN ::oCurHbQtVisual:items()
               IF ! ::oCurHbQtVisual:isFiltered( oHbQtVisualItem:layer() )
                  IF Upper( oHbQtVisualItem:type() ) == cMarker
                     IF nCheckState == Qt_Checked
                        oHbQtVisualItem:show()
                     ELSE
                        oHbQtVisualItem:hide()
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ENDIF
      ENDIF
   ENDIF
   HB_SYMBOL_UNUSED( nColumn )
   RETURN Self


METHOD HbQtVisualizer:buildChangeLayerTree()
   LOCAL oItem, oFont, cLayer
   LOCAL nIconSize := 32
   LOCAL nItemSize := 40
   LOCAL oTree := ::oChangeLayerTree

   oFont := oTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   WITH OBJECT oTree
      :disconnect( "itemDoubleClicked(QTreeWidgetItem*,int)" )
      :clear()
      :setIconSize( QSize( __hbqtPixelsByDPI( nIconSize ), __hbqtPixelsByDPI( nIconSize ) ) )
   ENDWITH

   IF ! Empty( ::oCurHbQtVisual )
      FOR EACH cLayer IN ::oCurHbQtVisual:layers()
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, cLayer )
            :setWhatsThis( 0, "Layer_" + cLayer )
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setFont( 0, oFont )
            :setFlags( Qt_ItemIsEnabled )
         ENDWITH
         oTree:addTopLevelItem( oItem )
      NEXT
      WITH OBJECT oItem := QTreeWidgetItem()
         :setText( 0, "...ROOT..." )
         :setWhatsThis( 0, "Layer_...ROOT..." )
         :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
         :setFont( 0, oFont )
         :setFlags( Qt_ItemIsEnabled )
      ENDWITH
      oTree:addTopLevelItem( oItem )
   ENDIF
   oTree:connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {| oItem, nCol | ::setItemLayer( Upper( oItem:text( nCol ) ) ) } )

   RETURN Self


METHOD HbQtVisualizer:buildLayersTree()
   LOCAL oItem, oFont, cLayer
   LOCAL nIconSize := 32
   LOCAL nItemSize := 40

   oFont := ::oLayersTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   WITH OBJECT ::oLayersTree
      :disconnect( "itemChanged(QTreeWidgetItem*,int)" )
      :disconnect( "itemClicked(QTreeWidgetItem*,int)" )
      :clear()
      :setIconSize( QSize( __hbqtPixelsByDPI( nIconSize ), __hbqtPixelsByDPI( nIconSize ) ) )
   ENDWITH

   IF ! Empty( ::oCurHbQtVisual )
      FOR EACH cLayer IN ::oCurHbQtVisual:layers()
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, cLayer )
            :setWhatsThis( 0, "Layer_" + cLayer )
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setFont( 0, oFont )
            :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
            :setCheckState( 0, Qt_Checked )
         ENDWITH
         ::oLayersTree:addTopLevelItem( oItem )
      NEXT
      WITH OBJECT oItem := QTreeWidgetItem()
         :setText( 0, "...ROOT..." )
         :setWhatsThis( 0, "Layer_...ROOT..." )
         :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
         :setFont( 0, oFont )
         :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
         :setCheckState( 0, Qt_Checked )
      ENDWITH
      ::oLayersTree:addTopLevelItem( oItem )
   ENDIF
   ::oLayersTree:connect( "itemChanged(QTreeWidgetItem*,int)", {| oItem, nCol | ::filter( oItem, nCol ) } )
   ::oLayersTree:connect( "itemClicked(QTreeWidgetItem*,int)", {| oItem, nCol | ::setupCurrentLayer( oItem, nCol ) } )
#if 0
   ::oUI:comboChangeLayer:disconnect( "activated(QString)" )
   ::oUI:comboChangeLayer:clear()
   IF ! Empty( ::oCurHbQtVisual )
      FOR EACH cLayer IN ::oCurHbQtVisual:layers()
         ::oUI:comboChangeLayer:addItem( cLayer )
      NEXT
      ::oUI:comboChangeLayer:addItem( "...ROOT..." )
   ENDIF
   ::oUI:comboChangeLayer:connect( "activated(QString)", {|cLayer| ::setItemLayer( Upper( cLayer ) ) } )
#endif
   RETURN Self


METHOD HbQtVisualizer:setupCurrentLayer( oItem, nCol )
   LOCAL nLayer, cLayer, i
   LOCAL nCurLayer := ::oCurHbQtVisual:currentLayer()

   cLayer := Upper( oItem:text( nCol ) )
   nLayer := AScan( ::oCurHbQtVisual:layers(), {|e| e == cLayer } )

   ::oLayersTree:clearSelection()
   IF nCurLayer == 0
      ::oLayersTree:topLevelItem( Len( ::oCurHbQtVisual:layers() ) ):setBackground( 0, QBrush() )
   ELSE
      FOR i := 0 TO ::oLayersTree:topLevelItemCount() - 1
         IF Upper( ::oLayersTree:topLevelItem( i ):text( 0 ) ) == ::oCurHbQtVisual:layer()
            ::oLayersTree:topLevelItem( i ):setBackground( 0, QBrush() )
            EXIT
         ENDIF
      NEXT
   ENDIF

   WITH OBJECT oItem
      :setSelected( .T. )
      :setBackground( 0, __hbqtGradientBrush( QColor( Qt_yellow ), QColor( Qt_red ), 0 ) )
   ENDWITH
   ::oCurHbQtVisual:setCurrentLayer( nLayer )
   ::showStatus( STATUS_PANEL_LAYER, ::oCurHbQtVisual:layer() )
   RETURN Self


METHOD HbQtVisualizer:setupCurrentChangeLayer()
   LOCAL oTree := ::oChangeLayerTree
   LOCAL cLayer, i

   IF ! Empty( ::oCurGraphicsItem )
      cLayer := ::oCurGraphicsItem:layer()
   ENDIF
   IF Empty( cLayer )
      cLayer := "...ROOT..."
   ENDIF
   FOR i := 0 TO oTree:topLevelItemCount() - 1
      IF oTree:topLevelItem( i ):text( 0 ) == cLayer
         oTree:topLevelItem( i ):setBackground( 0, __hbqtGradientBrush( QColor( Qt_yellow ), QColor( Qt_red ), 0 ) )
      ELSE
         oTree:topLevelItem( i ):setBackground( 0, QBrush() )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtVisualizer:setItemLayer( cLayer, oHbQtVisualItem )
   IF Empty( oHbQtVisualItem )
      oHbQtVisualItem := ::oCurGraphicsItem
   ENDIF
   IF ! Empty( oHbQtVisualItem ) .AND. oHbQtVisualItem:isSelected()
      IF Upper( cLayer ) == "...ROOT..."
         oHbQtVisualItem:setLayer( "" )
      ELSE
         oHbQtVisualItem:setLayer( cLayer )
      ENDIF
      ::updateItemStatus( oHbQtVisualItem )
      ::setupCurrentChangeLayer()
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:gridOffOn( lOff )
   LOCAL lOldState := ::lShowGrid
   IF ::lShowGrid
      ::oCurScene:setShowGrid( lOff )
   ENDIF
   RETURN lOldState


METHOD HbQtVisualizer:toggleGrid()
   ::lShowGrid := ! ::lShowGrid
   ::oCurScene:setShowGrid( ::lShowGrid )
   RETURN Self


METHOD HbQtVisualizer:tabulize()
   LOCAL oHbQtVisualItem, aAttrbs, oBrowse, aAttrb, cType, oCol, n, oFont
   LOCAL a_, aData := {}, dat_

   IF ::oUI:pageBrowser:isVisible()
      ::oUI:stackedWidget:setCurrentIndex( 0 )
      ::oSlidingsManager:activateSlidings( "PrintListL", "PrintList" )
      ::oGraphicsView:setFocus()
      RETURN Self
   ENDIF

   FOR EACH oHbQtVisualItem IN ::oCurHbQtVisual:items()
      WITH OBJECT oHbQtVisualItem
         dat_:= __firstFields( :getDataEx(), 5 )
         cType := Lower( :type() )
         AAdd( aData, { iif( cType == "marker", "Marker", "Object" ), ;
                        iif( cType == "marker", ft_proper( Pad( :marker(), 8 ) ), Pad( ft_Proper( cType ), 8 ) ), ;
                        0, ;
                        Pad( :name(), 12 ), ;
                        Pad( iif( Empty( :state() ), "", :state():name() ), 8 ), ;
                        iif( :isLocked(), "YES", "   " ), ;
                        dat_[ 1 ], dat_[ 2 ], dat_[ 3 ], dat_[ 4 ], dat_[ 5 ] ;
                      } )
      ENDWITH
   NEXT

   IF .T.
      IF ! Empty( aData )
         ASort( aData, , , {|e_,f_| Lower( e_[ 1 ] + e_[ 2 ] + e_[ 4 ] + e_[ 5 ] ) < Lower( f_[ 1 ] + f_[ 2 ] + f_[ 4 ] + f_[ 5 ] ) } )

         n := 0
         cType := aData[ 1, 2 ]
         FOR EACH a_ IN aData
            IF ! ( a_[ 2 ] == cType )
               aData[ a_:__enumIndex() - 1, 3 ] := n
               n := 0
               cType := a_[ 2 ]
            ENDIF
            n++
         NEXT
         aData[ Len( aData ), 3 ] := n
      ENDIF

      IF Empty( ::xData )
         ::xData := {}
         AAdd( ::xData, { Space( 6 ), Space( 8 ), 0, Space( 12 ), Space( 8 ), "   ", Space( 8 ), Space( 8 ), Space( 8 ), Space( 8 ), Space( 20 ) } )          // navigation should not complain
      ENDIF
      IF Empty( ::oBrowse )

         aAttrbs := {}
         //
         AAdd( aAttrbs, {  1, "Class", "C",  6, 0 } )
         AAdd( aAttrbs, {  2, "Type" , "C",  8, 0 } )
         AAdd( aAttrbs, {  3, "Nos"  , "N",  4, 0, "@Z 9999" } )
         AAdd( aAttrbs, {  4, "Name" , "C", 12, 0 } )
         AAdd( aAttrbs, {  5, "State", "C",  8, 0 } )
         AAdd( aAttrbs, {  6, "Lck"  , "C",  3, 0 } )
         AAdd( aAttrbs, {  7, "Fld_1", "C",  8, 0 } )
         AAdd( aAttrbs, {  8, "Fld_2", "C",  8, 0 } )
         AAdd( aAttrbs, {  9, "Fld_3", "C",  8, 0 } )
         AAdd( aAttrbs, { 10, "Fld_4", "C",  8, 0 } )
         AAdd( aAttrbs, { 11, "Fld_5", "C", 20, 0 } )

         oFont := QFont( "Courier New", __hbqtPixelsByDPI( 14 ) )
#ifdef __HBQTMOBILE__
         oFont:setFixedPitch( .T. )
#endif
         WITH OBJECT ::oBrowse := HbQtBrowseNew( 5, 5, 10, 10, NIL, oFont )
            oBrowse := ::oBrowse
            :cargo := { AClone( ::xData ), 1 }

            :goTopBlock    := {|| oBrowse:cargo[ 2 ] := 1 }
            :goBottomBlock := {|| oBrowse:cargo[ 2 ] := Len( oBrowse:cargo[ 1 ] ) }
            :skipBlock     := {| nSkip, nPos | nPos := oBrowse:cargo[ 2 ], ;
                                       oBrowse:cargo[ 2 ] := iif( nSkip > 0, Min( Len( oBrowse:cargo[ 1 ] ), oBrowse:cargo[ 2 ] + nSkip ), ;
                                          Max( 1, oBrowse:cargo[ 2 ] + nSkip ) ), oBrowse:cargo[ 2 ] - nPos }

            :posBlock      := {| | oBrowse:cargo[ 2 ] * 100 / Len( oBrowse:cargo[ 1 ] ) }
            :goPosBlock    := {|i| oBrowse:cargo[ 2 ] := Int( i * Len( oBrowse:cargo[ 1 ] ) / 100 ) }
            :phyPosBlock   := {| | oBrowse:cargo[ 2 ] * 100 / Len( oBrowse:cargo[ 1 ] ) }

            :AddColumn( oCol := HbQtColumnNew( "SR", {|| oBrowse:cargo[ 2 ] } ) )
            oCol:picture := "9999"
            FOR EACH aAttrb IN aAttrbs
               :AddColumn( oCol := HbQtColumnNew( aAttrb[ 2 ], {|| oBrowse:cargo[ 1 ][ oBrowse:cargo[ 2 ], __getColumnNumber( aAttrb[ 1 ] ) ] } ) )
               IF Len( aAttrb ) >= 6 .AND. HB_ISSTRING( aAttrb[ 6 ] )
                  oCol:picture := aAttrb[ 6 ]
               ENDIF
            NEXT
            :configure()

            :toolbar           := .F.
            :toolbarLeft       := .F.
            :statusbar         := .F.
            :editEnabled       := .F.
            :verticalScrollbar := .F.
            :statusMessage     := "Ready !"
            :navigationBlock   := {|nKey| ::browseNavigate( nKey ) }

            __hbqtApplyStandardScroller( ::oBrowse:widget() )
         ENDWITH
         ::oUI:layoutBrowser:addWidget( ::oBrowse:oWidget )

         WITH OBJECT ::oSlidingBrowser := __hbqtBrowseActionsSlidingList( ::oBrowse, __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__, 100, 150 )
            :addItem( "SortA" , { "Sort A", QPixmap( __hbqtImage( "sort-ascending"  ) ) }, {|| __sortBrowser( ::oBrowse, 1 ) } )
            :addItem( "SortD" , { "Sort D", QPixmap( __hbqtImage( "sort-descending" ) ) }, {|| __sortBrowser( ::oBrowse, 2 ) } )
            :addItem( "Select", { "Select", QPixmap( __hbqtImage( "select"          ) ) }, {|| ::selectMarkerOffBrowser( ::oBrowse:cargo[ 1 ][ ::oBrowse:cargo[ 2 ] ][ 4 ]  ) } )
            :setHideOnClick( .F. )
         ENDWITH
         WITH OBJECT ::oSlidingsManager
            :addSliding( "Browser", {|| ::oSlidingBrowser:activate() } )
         ENDWITH
      ENDIF

      WITH OBJECT ::oBrowse
         ASize( :cargo[ 1 ], 0 )
         IF ! Empty( aData )
            AEval( aData, {|e_| AAdd( :cargo[ 1 ], e_ ) } )
         ELSE
            AAdd( :cargo[ 1 ], { Space( 6 ), Space( 8 ), 0, Space( 12 ), Space( 8 ), "   ", Space( 8 ), Space( 8 ), Space( 8 ), Space( 8 ), Space( 20 ) } )
         ENDIF
         :gotop()
         :forceStable()
         :refreshAll()
      ENDWITH

      ::oUI:stackedWidget:setCurrentIndex( 1 )
      ::oSlidingsManager:activateSlidings( "PrintListL", "Browser" )
   ENDIF
   RETURN Self


STATIC FUNCTION __sortBrowser( oBrowse, nAscend )
   LOCAL nColumn := oBrowse:colPos() - 1          // first column is row serial

   IF nColumn > 0
      WITH OBJECT oBrowse
         IF nAscend == 1
            ASort( :cargo[ 1 ], , , {| e_, f_ | e_[ nColumn ] < f_[ nColumn ] } )
         ELSE
            ASort( :cargo[ 1 ], , , {| e_, f_ | e_[ nColumn ] > f_[ nColumn ] } )
         ENDIF
         :gotop()
         :forceStable()
         :refreshAll()
      ENDWITH
   ENDIF
   RETURN NIL


STATIC FUNCTION __getColumnNumber( nNumber )
   RETURN nNumber


METHOD HbQtVisualizer:browseNavigate( nKey )
   IF nKey == K_LDBLCLK
      ::selectMarkerOffBrowser( ::oBrowse:cargo[ 1 ][ ::oBrowse:cargo[ 2 ] ][ 4 ] )
      RETURN .T.
   ENDIF
   RETURN .F.


METHOD HbQtVisualizer:selectMarkerOffBrowser( cMarker )
   LOCAL oHbQtVisualItem := ::oCurHbQtVisual:item( Trim( cMarker ) )

   ::oToolbar:click( "Table" )
   IF ! Empty( oHbQtVisualItem )
      ::objectSelected( oHbQtVisualItem )
      ::oGraphicsView:centerOn( oHbQtVisualItem:widget() )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:printVisual( oPrinter )
   LOCAL oPainter
   LOCAL oPageLayout

   WITH OBJECT oPageLayout := QPageLayout( QPageSize( QPageSize_Letter ), ::oCurScene:orientation(), QMarginsF( 10,10,10,10 ), QPageLayout_Millimeter )
      :SetMode( QPageLayout_StandardMode )
   ENDWITH

   WITH OBJECT oPrinter
      :setOutputFormat( QPrinter_PdfFormat )
      :setPageLayout( oPageLayout )
   ENDWITH
   oPainter := QPainter()
   IF oPainter:begin( oPrinter )
      oPainter:setRenderHint( QPainter_Antialiasing )
      ::oCurScene:render( oPainter )
      oPainter:end()
   ENDIF
   RETURN Self


FUNCTION __hbqtDefaultVisualProperties()
   LOCAL hProp := __hbqtStandardHash()

   hProp[ "objectName"     ] := ""

   hProp[ "x"              ] := 0.0
   hProp[ "y"              ] := 0.0
   hProp[ "width"          ] := 0.0
   hProp[ "height"         ] := 0.0

   hProp[ "capStyle"       ] := "FlatCap"
   hProp[ "joinStyle"      ] := "BevelJoin"
   hProp[ "miterLimit"     ] := 2.0
   hProp[ "penStyle"       ] := "SolidLine"
   hProp[ "penWidth"       ] := 1
   hProp[ "penColor"       ] := "#000000"

   hProp[ "brushStyle"     ] := "NoBrush"
   hProp[ "brushColor"     ] := "#ffffff"
   hProp[ "brushTexture"   ] := ""

   hProp[ "bBrushStyle"    ] := "NoBrush"
   hProp[ "bBrushColor"    ] := "#ffffff"
   hProp[ "bBrushTexture"  ] := ""

   hProp[ "backgroundMode" ] := "TransparentMode"
   hProp[ "opacity"        ] := 100
   hProp[ "text"           ] := ""
   hProp[ "fontFamily"     ] := "Arial"
   hProp[ "fontStyle"      ] := "Normal"
   hProp[ "fontSize"       ] := "3.5"

   RETURN hProp


METHOD HbQtVisualizer:visualPropertyChanged( cSheet, cProperty, xValue )
   LOCAL oRect, nW, nH

   SWITCH cSheet
   CASE "GraphicObjects"
      IF HB_ISOBJECT( ::oCurGraphicsItem )
         WITH OBJECT ::oCurGraphicsItem

            SWITCH cProperty
            CASE "x"
               oRect := :geometry()
               nW := oRect:width()
               oRect:setX( xValue )
               oRect:setWidth( nW )
               :setGeometry( oRect )
               EXIT
            CASE "y"
               oRect := :geometry()
               nH := oRect:height()
               oRect:setY( xValue )
               oRect:setHeight( nH )
               :setGeometry( oRect )
               EXIT
            CASE "width"
               oRect := :geometry()
               oRect:setWidth( xValue )
               :setGeometry( oRect )
               EXIT
            CASE "height"
               oRect := :geometry()
               oRect:setHeight( xValue )
               :setGeometry( oRect )
               EXIT
            CASE "objectName"
               EXIT
            CASE "penStyle"
            CASE "penWidth"
            CASE "penColor"
            CASE "capStyle"
            CASE "joinStyle"
            CASE "miterLimit"
               :setPenProperties( cProperty, xValue )
               EXIT
            CASE "brushStyle"
            CASE "brushColor"
            CASE "brushTexture"
               :setBrushProperties( cProperty, xValue )
               EXIT
            CASE "bBrushStyle"
            CASE "bBrushColor"
            CASE "bBrushTexture"
               :setBBrushProperties( cProperty, xValue )
               EXIT
            CASE "opacity"
               :setOpacity( xValue )
               EXIT
            CASE "backgroundMode"
               :setBackgroundMode( xValue )
               EXIT
            CASE "fontFamily"
            CASE "fontStyle"
            CASE "fontSize"
               :setFontProperties( cProperty, xValue )
               EXIT
            CASE "text"
               :setText( xValue )
               EXIT
            ENDSWITCH
         ENDWITH
      ENDIF
      EXIT
   CASE "X"
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD HbQtVisualizer:buildPropertySheets()
   LOCAL aCapStyle  := { "FlatCap", "RoundCap", "SquareCap" }
   LOCAL aJoinStyle := { "BevelJoin", "MiterJoin", "RoundJoin", "SvgMiterJoin" }
   LOCAL aPenStyle  := { "NoPen", "SolidLine", "DashLine", "DotLine", "DashDotLine", "DashDotDotLine" }
   LOCAL aBrushStyle := {}

   AAdd( aBrushStyle, "NoBrush"                )
   AAdd( aBrushStyle, "SolidPattern"           )
   AAdd( aBrushStyle, "Dense1Pattern"          )
   AAdd( aBrushStyle, "Dense2Pattern"          )
   AAdd( aBrushStyle, "Dense3Pattern"          )
   AAdd( aBrushStyle, "Dense4Pattern"          )
   AAdd( aBrushStyle, "Dense5Pattern"          )
   AAdd( aBrushStyle, "Dense6Pattern"          )
   AAdd( aBrushStyle, "Dense7Pattern"          )
   AAdd( aBrushStyle, "HorPattern"             )
   AAdd( aBrushStyle, "VerPattern"             )
   AAdd( aBrushStyle, "CrossPattern"           )
   AAdd( aBrushStyle, "BDiagPattern"           )
   AAdd( aBrushStyle, "FDiagPattern"           )
   AAdd( aBrushStyle, "DiagCrossPattern"       )
#if 0
   AAdd( aBrushStyle, "LinearGradientPattern"  )
   AAdd( aBrushStyle, "ConicalGradientPattern" )
   AAdd( aBrushStyle, "RadialGradientPattern"  )
   AAdd( aBrushStyle, "TexturePattern"         )
#endif
   WITH OBJECT ::oPropManager := HbQtPropertiesManager():new():create( ::oPropWidget )
      WITH OBJECT ::oPropertySheet := :addPropertySheet( "GraphicObjects" )
         :addProperty( "objectName"     , "objectName"     , ""               , __HBQT_PRP_EDIT__    , ""               , NIL )

         :addProperty( "geometry"       , "Geometry"       , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "x"              , "x"              , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "y"              , "y"              , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "width"          , "width"          , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "height"         , "height"         , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )

         :addProperty( "pen"            , "Pen"            , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "penStyle"       , "style"          , "Pen"            , __HBQT_PRP_COMBO__   , "SolidLine"      , aPenStyle )
         :addProperty( "penWidth"       , "width"          , "Pen"            , __HBQT_PRP_EDIT__    , 1                , NIL )
         :addProperty( "penColor"       , "color"          , "Pen"            , __HBQT_PRP_COLOR__   , "#000000"        , NIL )
         :addProperty( "capStyle"       , "capStyle"       , "Pen"            , __HBQT_PRP_COMBO__   , "FlatCap"        , aCapStyle  )
         :addProperty( "joinStyle"      , "joinStyle"      , "Pen"            , __HBQT_PRP_COMBO__   , "BevelJoin"      , aJoinStyle )
         :addProperty( "miterLimit"     , "miterLimit"     , "Pen"            , __HBQT_PRP_EDIT__    , 2.00             , NIL )

         :addProperty( "brush"          , "Brush"          , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "brushStyle"     , "style"          , "Brush"          , __HBQT_PRP_BRUSHSTYLE__, "NoBrush"      , NIL )
         :addProperty( "brushColor"     , "color"          , "Brush"          , __HBQT_PRP_COLOR__   , "#ffffff"        , NIL )
//       :addProperty( "brushTexture"   , "texture"        , "Brush"          , __HBQT_PRP_TEXTURE__ , ""               , NIL )

         :addProperty( "text"           , "text"           , ""               , __HBQT_PRP_EDIT__    , ""               , NIL )
         :addProperty( "font"           , "Font"           , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "fontFamily"     , "family"         , "Font"           , __HBQT_PRP_FONT__    , "Arial"          , NIL )
         :addProperty( "fontStyle"      , "style"          , "Font"           , __HBQT_PRP_COMBO__   , "Normal"         , { "Normal", "Italic", "Bold", "Bold Italic" } )
         :addProperty( "fontSize"       , "size"           , "Font"           , __HBQT_PRP_FONTSIZE__, "3.5"            , NIL )

         :addProperty( "backgroundMode" , "bgMode"         , ""               , __HBQT_PRP_COMBO__   , "TransparentMode", { "TransparentMode", "OpaqueMode" } )
         :addProperty( "opacity"        , "opacity"        , ""               , __HBQT_PRP_EDIT__    , 100              , NIL )

         :addProperty( "backgroundBrush", "BGBrush"        , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "bBrushStyle"    , "style"          , "BackgroundBrush", __HBQT_PRP_BRUSHSTYLE__, "NoBrush"      , NIL )
         :addProperty( "bBrushColor"    , "color"          , "BackgroundBrush", __HBQT_PRP_COLOR__   , "#ffffff"        , NIL )
//       :addProperty( "bBushTexture"   , "texture"        , "BackgroundBrush", __HBQT_PRP_TEXTURE__ , ""               , NIL )

         :propertyChangedBlock := {|cSheet, cProperty, xValue| ::visualPropertyChanged( cSheet, cProperty, xValue ) }
      ENDWITH
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:buildDataSheets()
   LOCAL hField, cGroup, nType, xValue, aOptions, cType
   LOCAL hGrp := __hbqtStandardHash()

   IF Empty( ::hDataStruct )
      RETURN Self
   ENDIF

   ::oDataWidget := ::oUI:pageMarkersData

   WITH OBJECT ::oDataManager := HbQtPropertiesManager():new():create( ::oDataWidget )
      WITH OBJECT ::oDataSheet := :addPropertySheet( "MarkersData" )
         FOR EACH hField IN ::hDataStruct

            IF hb_HHasKey( hField, "Group" ) .AND. ! Empty( hField[ "Group" ] )
               cGroup := hField[ "Group" ]
               IF ! hb_HHasKey( hGrp, cGroup )
                  hGrp[ cGroup ] := NIL
                  :addProperty( cGroup, cGroup, "", __HBQT_PRP_JUST__, "", NIL )
               ENDIF
            ELSE
               cGroup := ""
            ENDIF

            IF hb_HHasKey( hField, "SelectOnly" ) .AND. hField[ "SelectOnly" ]
               nType := __HBQT_PRP_COMBO__
               IF hb_HHasKey( hField, "Options" )
                  aOptions := hField[ "Options" ]
               ENDIF
            ELSE
               nType := __HBQT_PRP_EDIT__
            ENDIF

            IF hb_HHasKey( hField, "Value" )
               xValue := hField[ "Value" ]
            ELSE
               cType := hField[ "Type" ]
               xValue := iif( cType == "L", .F., iif( cType == "N", 0, iif( cType == "D", SToD( "" ), "" ) ) )
            ENDIF

            :addProperty( hField:__enumKey(), hField[ "Label" ], cGroup, nType, xValue, aOptions )
         NEXT

         :propertyChangedBlock := {|cSheet, cProperty, xValue| ::dataPropertyChanged( cSheet, cProperty, xValue ) }
      ENDWITH
   ENDWITH

   RETURN Self


STATIC FUNCTION rmgr_a2arrayStr( aArray )
   LOCAL s, x

   s := "{"
   FOR EACH x IN aArray
      SWITCH valtype( x )
      CASE "C"  ; s += '"' + x + '"'             ; EXIT
      CASE "N"  ; s += hb_ntos( x )              ; EXIT
      CASE "D"  ; s += "stod(" + dtos( x ) + ")" ; EXIT
      CASE "L"  ; s += iif( x, ".t.", ".f." )    ; EXIT
      CASE "A"  ; s += rmgr_a2arrayStr( x )      ; EXIT
      OTHERWISE ; s += "NIL"                     ; EXIT
      ENDSWITCH
      s += ","
   NEXT
   s := iif( Len( s ) == 1, s, substr( s, 1, len( s ) - 1 ) ) + "}"
   RETURN s


STATIC FUNCTION rmgr_keyValuePair( s, cKey, cVal, cDlm )
   LOCAL n

   DEFAULT cDlm TO "="

   IF ( n := at( cDlm, s ) ) > 0
      cKey := alltrim( substr( s, 1, n - 1 ) )
      cVal := alltrim( substr( s, n + 1 ) )
      RETURN .t.
   ENDIF
   RETURN .f.


STATIC FUNCTION rmgr_evalAsArray( cStr )
   LOCAL a_, bErr := ErrorBlock( {|| break() } )

   BEGIN SEQUENCE
      a_:= Eval( hb_macroBlock( cStr ) )
   RECOVER
      a_:= {}
   ENDSEQUENCE
   ErrorBlock( bErr )
   RETURN a_


METHOD HbQtVisualizer:moveMarker( nDirection )
   LOCAL oRect, oOldRect
   LOCAL nUnit := ::nMoverSteps

   IF Empty( ::oCurGraphicsItem )
      RETURN Self
   ENDIF
   IF ! ::lEditingOn
      RETURN Self
   ENDIF
   oRect := ::oCurGraphicsItem:geometry()
   oOldRect := QRectF( oRect )

   SWITCH nDirection
   CASE 1
      oRect:setX( oRect:x() - nUnit )
      oRect:setY( oRect:y() - nUnit )
      oRect:setWidth( oRect:width() - nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 2
      oRect:setY( oRect:y() - nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 3
      oRect:setX( oRect:x() + nUnit )
      oRect:setY( oRect:y() - nUnit )
      oRect:setWidth( oRect:width() + nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 4
      oRect:setX( oRect:x() + nUnit )
      oRect:setWidth( oRect:width() + nUnit )
      EXIT
   CASE 5
      oRect:setX( oRect:x() + nUnit )
      oRect:setY( oRect:y() + nUnit )
      oRect:setWidth( oRect:width() + nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 6
      oRect:setY( oRect:y() + nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 7
      oRect:setX( oRect:x() - nUnit )
      oRect:setY( oRect:y() + nUnit )
      oRect:setWidth( oRect:width() - nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 8
      oRect:setX( oRect:x() - nUnit )
      oRect:setWidth( oRect:width() - nUnit )
      EXIT
   ENDSWITCH
   ::oCurGraphicsItem:setGeometry( oRect )
   ::objectGeometryChanged( ::oCurGraphicsItem )
   ::oCurGraphicsItem:update()
   ::oCurScene:invalidate( oOldRect )
   RETURN Self


METHOD HbQtVisualizer:resizeMarker( nDirection )
   LOCAL oRect, oOldRect
   LOCAL nUnit := ::nResizerSteps

   IF Empty( ::oCurGraphicsItem )
      RETURN Self
   ENDIF
   IF ! ::lEditingOn
      RETURN Self
   ENDIF
   oRect := ::oCurGraphicsItem:geometry()
   oOldRect := QRectF( oRect )

   SWITCH nDirection
   CASE 1                                         // Outward - top-left
      oRect:setX( oRect:x() - nUnit )
      oRect:setY( oRect:y() - nUnit )
      EXIT
   CASE 2                                         // Outward - up
      oRect:setY( oRect:y() - nUnit )
      EXIT
   CASE 3                                         // Outward - top-right
      oRect:setWidth( oRect:width() + nUnit )
      oRect:setY( oRect:y() - nUnit )
      EXIT
   CASE 4
      oRect:setWidth( oRect:width() + nUnit )
      EXIT
   CASE 5
      oRect:setWidth( oRect:width() + nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 6
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 7
      oRect:setX( oRect:x() - nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 8
      oRect:setX( oRect:x() - nUnit )
      EXIT
   CASE 9
      oRect:setX( oRect:x() - nUnit )
      oRect:setY( oRect:y() - nUnit )
      oRect:setWidth( oRect:width() + nUnit )
      oRect:setHeight( oRect:height() + nUnit )
      EXIT
   CASE 10
      oRect:setX( oRect:x() + nUnit )
      oRect:setY( oRect:y() + nUnit )
      EXIT
   CASE 11
      oRect:setY( oRect:y() + nUnit )
      EXIT
   CASE 12
      oRect:setWidth( oRect:width() - nUnit )
      oRect:setY( oRect:y() + nUnit )
      EXIT
   CASE 13
      oRect:setWidth( oRect:width() - nUnit )
      EXIT
   CASE 14
      oRect:setWidth( oRect:width() - nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 15
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 16
      oRect:setX( oRect:x() + nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 17
      oRect:setX( oRect:x() + nUnit )
      EXIT
   CASE 18
      oRect:setX( oRect:x() + nUnit )
      oRect:setY( oRect:y() + nUnit )
      oRect:setWidth( oRect:width() - nUnit )
      oRect:setHeight( oRect:height() - nUnit )
      EXIT
   CASE 21                                        // to default
      //  implement application defined widths/heights
      oRect:setWidth( ::oCurGraphicsItem:defWidth() )
      oRect:setHeight( ::oCurGraphicsItem:defHeight() )
      EXIT
   ENDSWITCH
   ::oCurGraphicsItem:setGeometry( oRect )
   ::objectGeometryChanged( ::oCurGraphicsItem )
   ::oCurGraphicsItem:update()
   ::oCurScene:invalidate( oOldRect )
   RETURN Self


METHOD HbQtVisualizer:zoom( nMode )
   LOCAL nScaleFactor := 1.10

   ::gridOffOn( .F. )

   SWITCH nMode
   CASE HBQT_GRAPHICSVIEW_ZOOM_IN
      ::oGraphicsView:scale( nScaleFactor, nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_OUT
      ::oGraphicsView:scale( 1 / nScaleFactor, 1 / nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG
      ::oGraphicsView:fitInView( ::oCurScene:sceneRect(), Qt_KeepAspectRatio )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_LOCATE
      ::oZoomTrans := NIL
      ::oZoomTrans := ::oGraphicsView:Transform()
      ::oGraphicsView:fitInView( ::oCurScene:sceneRect(), Qt_KeepAspectRatio )
      ::lZoomLocate := .T.
      EXIT
   ENDSWITCH

   ::gridOffOn( .T. )
   RETURN sELF


METHOD HbQtVisualizer:contextMenuScene( nX, nY )
   LOCAL oMenu, oAct, aAct := {}

   IF Empty( ::oCurGraphicsItem )
      RETURN Self
   ENDIF

   oMenu := QMenu( ::oGraphicsView )
   aadd( aAct, oMenu:addAction( "Data"  ) )
   aadd( aAct, oMenu:addAction( "What" ) )

   IF ! empty( oAct := oMenu:exec( QPoint( nX, nY ) ) )
      SWITCH oAct:text()
      CASE "Data"
         EXIT
      CASE "What"
         EXIT
      ENDSWITCH
   ENDIF

   oMenu:setParent( QWidget() )
   oMenu := NIL
   RETURN Self


METHOD HbQtVisualizer:showStatus( nPanel, cMsg )
   LOCAL cDisp

   DEFAULT cMsg TO ""

   SWITCH nPanel
   CASE STATUS_PANEL_READY   ; cDisp := "<font color = black >" + iif( Empty( cMsg ), "Item:", cMsg ) + "</font>" ; EXIT
   CASE STATUS_PANEL_LAYER   ; cDisp := "<font color = red   >" + iif( Empty( cMsg ), "...ROOT...", cMsg ) + "</font>" ; EXIT
   CASE STATUS_PANEL_MARKERS ; cDisp := "<font color = green >M: " + cMsg + "</font>" ; EXIT
   CASE STATUS_PANEL_VISUALS ; cDisp := "<font color = blue  >" + iif( Empty( cMsg ), "Visual:", cMsg ) + "</font>" ; EXIT
   ENDSWITCH
   ::aStatusPnls[ nPanel ]:setText( cDisp )
   RETURN Self


METHOD HbQtVisualizer:buildStatusBar()
   LOCAL qLabel

   ::oStatusBar := QStatusBar()
   ::oStatusBar:setSizeGripEnabled( .f. )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::oStatusBar:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::oStatusBar:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::oStatusBar:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::oStatusBar:addPermanentWidget( qLabel, 1 )
   aadd( ::aStatusPnls, qLabel )

   ::showStatus( STATUS_PANEL_READY   )
   ::showStatus( STATUS_PANEL_LAYER   )
   ::showStatus( STATUS_PANEL_MARKERS )
   ::showStatus( STATUS_PANEL_VISUALS )
   RETURN Self


METHOD HbQtVisualizer:parseBuffer( cBuffer )
   LOCAL aTxt, s, nPart, cKey, cVal

   aTxt := hb_ATokens( StrTran( cBuffer, Chr( 13 ) ), Chr( 10 ) )

   FOR EACH s IN aTxt
      s := alltrim( s )
      IF empty( s )
         LOOP
      ENDIF

      SWITCH Upper( s )
      CASE "[GENERAL]" ; nPart := "HQR_GENERAL" ; EXIT
      CASE "[PAGES]"   ; nPart := "HQR_PAGES"   ; EXIT
      CASE "[OBJECTS]" ; nPart := "HQR_OBJECTS" ; EXIT
      OTHERWISE
         DO CASE
         CASE nPart == "HQR_GENERAL"
         CASE nPart == "HQR_PAGES"
            IF rmgr_keyValuePair( s, @cKey, @cVal, "=" )
               aadd( ::aRptPages, { "Page", rmgr_evalAsArray( cVal ) } )
            ENDIF
         CASE nPart == "HQR_OBJECTS"
            IF rmgr_keyValuePair( s, @cKey, @cVal, "=" )
               aadd( ::aRptObjects, rmgr_evalAsArray( cVal ) )
            ENDIF
         ENDCASE
      ENDSWITCH
   NEXT
   RETURN Self


METHOD HbQtVisualizer:getImageOfType( cType )

   SWITCH Trim( Upper( cType ) )
   CASE "IMAGE"       ; RETURN __hbqtImage( "f-image"        )
   CASE "CHART"       ; RETURN __hbqtImage( "f_chart"        )
   CASE "GRADIENT"    ; RETURN __hbqtImage( "f_gradient"     )
   CASE "FIELD"       ; RETURN __hbqtImage( "text"           )
   CASE "TEXT"        ; RETURN __hbqtImage( "text-object"    )
   CASE "BARCODE"     ; RETURN __hbqtImage( "z-barcode"      )
   CASE "RECT"
   CASE "RECTANGLE"   ; RETURN __hbqtImage( "z-rectangle"    )
   CASE "RND-RECT"
   CASE "ROUNDEDRECT" ; RETURN __hbqtImage( "z-roundedrect"  )
   CASE "ELLIPSE"     ; RETURN __hbqtImage( "z-ellipse"      )
   CASE "DIAMOND"     ; RETURN __hbqtImage( "z-diamond"      )
   CASE "TRIANGLE"    ; RETURN __hbqtImage( "z-triangle"     )
   CASE "LINE-H"
   CASE "LINEH"       ; RETURN __hbqtImage( "z-lineh"        )
   CASE "LINE-V"
   CASE "LINEV"       ; RETURN __hbqtImage( "z-linev"        )
   CASE "LINE-D-R"
   CASE "LINEDR"      ; RETURN __hbqtImage( "z-linedr"       )
   CASE "LINE-D-L"
   CASE "LINEDL"      ; RETURN __hbqtImage( "z-linedl"       )
   CASE "ARC"         ; RETURN __hbqtImage( "rp_arc"         )
   CASE "CHORD"       ; RETURN __hbqtImage( "rp_chord"       )
   ENDSWITCH
   RETURN ""


STATIC FUNCTION __firstFields( hData, nFlds )
   LOCAL hField, nFld
   LOCAL aData := AFill( Array( nFlds ), "" )

   FOR EACH hField IN hData
      nFld := Val( StrTran( hField[ "Field" ], "FLD_", "" ) )
      IF nFld > 0 .AND. nFld <= nFlds
         aData[ nFld ] := hField[ "Value" ]
      ENDIF
   NEXT
   RETURN aData


METHOD HbQtVisualizer:buildToolbarItemEdit( oLayout )
   WITH OBJECT ::oToolbarItemEdit := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( { 255,0,0 } )
      :setButtonHeight( 40 )
      :setButtonWidth( 50 )
      :create( oLayout )
   ENDWITH
   WITH OBJECT ::oToolbarItemEdit
      :hide()
      :addToolbarButton( "RotateM"    , "Rotate Marker R", "rotate-3"         , {|| ::rotateMarker( ::oCurGraphicsItem, 1 ) }, .F., .F., .T. )
      :addToolbarButton( "RotateML"   , "Rotate Marker L", "rotatel-3"        , {|| ::rotateMarker( ::oCurGraphicsItem, 2 ) }, .F., .F., .T. )
      :addToolbarButton( "Lock"       , "Lock Object"    , "lock"             , {|| ::toggleLockOnObject() } )
      :addToolbarButton( "Delete"     , "Delete Object"  , "delete"           , {|| ::objectDeleted( ::oCurGraphicsItem   ) } )
      :addToolbarButton( "DelState"   , "Delete State"   , "del-state-1"      , {|| ::deleteState( ::oCurGraphicsItem     ) } )
   // :addSeparator( "Separator_1" )
      :addToolbarButton( "Resizer"    , "Resizer"        , "vz-resizer"       , {|| ::onPanelAction( "R", PAGE_RESIZER    ) } )
      :addToolbarButton( "Mover"      , "Mover"          , "vz-mover"         , {|| ::onPanelAction( "R", PAGE_MOVER      ) } )
      :addToolbarButton( "ChangeLayer", "ChangeLayer"    , "vz-layerchange"   , {|| ::onPanelAction( "R", PAGE_CHANGELAYER ) } )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:buildToolbar( oLayout )

   WITH OBJECT ::oToolbar := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( { 255,0,0 } )
      :setButtonHeight( 50 )
      :setButtonWidth( 50 )
      :create( oLayout )
   ENDWITH
   WITH OBJECT ::oToolbar
      :addToolbarButton( "MenuL"      , "MenuLeft"       , "vz-menu"          , {|| ::oSlidingListLeft:show()                    } )
      :addToolbarButton( "Save"       , "Save"           , "save-5"           , {|| ::saveVisual()                               } )
      :addToolbarButton( "Print"      , "Print"          , "preview-1"        , {|| ::oHbQtPreview:refreshPreview(), ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_PREVIEW ) } )
      :addToolbarButton( "Rotate"     , "Rotate"         , "rotate-1"         , {|| ::oGraphicsView:rotate( 90 ) }, .F., .F.      )
      :addToolbarButton( "ZoomIn"     , "Zoom In"        , "prv_zoom-in-1"    , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_IN        )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomOut"    , "Zoom Out"       , "prv_zoom-out-1"   , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_OUT       )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomWYS"    , "Zoom WYSIWYG"   , "prv_zoom-1"       , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG   )    } )
      :addToolbarButton( "ZoomOrg"    , "Zoom Original"  , "prv_zoom-original", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL  )    } )
      :addToolbarButton( "ZoomLocate" , "Zoom Locate"    , "prv_zoom_locate"  , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_LOCATE    )    } )
      :addToolbarButton( "Grid"       , "Show Grid"      , "grid-4"           , {|| ::toggleGrid() } )
      :addToolbarButton( "Table"      , "Tabulize Visual", "table-3"          , {|| ::tabulize() }, .T. )
      :addToolbarButton( "Edit"       , "Edit"           , "edit-object"      , {|lChecked| ::manageEditClicked( lChecked ) }, .T. )
      :addToolbarButton( "Chat"       , "Chatting"       , "vz-chat-2"        , {|| ::oChatter:show() } )
      :addToolbarButton( "MenuR"      , "MenuRight"      , "vz-menu"          , {|| ::oSlidingListRight:show()                    } )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:buildSlidings()

   WITH OBJECT ::oSlidingListRight := HbQtSlidingList():new( __hbqtAppWidget() )
      :setSlidingDirection( __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__ )
      :setDuration( 100 )
      :setWidth( 160 )
      :create()
      //:addItem( "Layers"     , { "Layers"         , QPixmap( __hbqtImage( "vz-layers"     ) ) }, {|| ::onPanelAction( "R", PAGE_LAYERS     ) } )
      :addSeparator( 2 )
      //:addItem( "Data"       , { "Data"           , QPixmap( __hbqtImage( "vz-data"       ) ) }, {|| ::onPanelAction( "R", PAGE_DATA       ) } )
      //:addItem( "Properties" , { "Properties"     , QPixmap( __hbqtImage( "vz-properties" ) ) }, {|| ::onPanelAction( "R", PAGE_PROPERTIES ) } )
   ENDWITH

   WITH OBJECT ::oSlidingListLeft := HbQtSlidingList():new( __hbqtAppWidget() )
      :setSlidingDirection( __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__ )
      :setDuration( 100 )
      :setWidth( 160 )
      :create()
      :addItem( "Visuals"    , { "Visuals"        , QPixmap( __hbqtImage( "vz-maps"       ) ) }, {|| ::onPanelAction( "L", PAGE_MAPS       ) } )
      :addSeparator( 2 )
      :addItem( "Layers"     , { "Layers"         , QPixmap( __hbqtImage( "vz-layers"     ) ) }, {|| ::onPanelAction( "R", PAGE_LAYERS     ) } )
      :addSeparator( 2, "red" )
      :addItem( "Items"      , { "Items"          , QPixmap( __hbqtImage( "vz-items"      ) ) }, {|| ::onPanelAction( "L", PAGE_ITEMS      ) } )
      :addItem( "States"     , { "States"         , QPixmap( __hbqtImage( "vz-states"     ) ) }, {|| ::onPanelAction( "L", PAGE_STATES     ) } )
      :addItem( "Data"       , { "Data"           , QPixmap( __hbqtImage( "vz-data"       ) ) }, {|| ::onPanelAction( "R", PAGE_DATA       ) } )
      :addItem( "Properties" , { "Properties"     , QPixmap( __hbqtImage( "vz-properties" ) ) }, {|| ::onPanelAction( "R", PAGE_PROPERTIES ) } )
      :addSeparator( 2, "lightblue" )
      :addItem( "Filter"     , { "Filter"         , QPixmap( __hbqtImage( "vz-filter"     ) ) }, {|| ::onPanelAction( "L", PAGE_FILTER     ) } )
      :addItem( "Navigator"  , { "Navigator"      , QPixmap( __hbqtImage( "vz-navigate"   ) ) }, {|| ::onPanelAction( "L", PAGE_NAVIGATOR  ) } )
   ENDWITH

   WITH OBJECT ::oSlidingsManager := HbQtSlidingsManager():new( ::oWidget ):create()
      :addSliding( "PrintList" , {|| ::oSlidingListRight:activate() } )
      :addSliding( "PrintListL", {|| ::oSlidingListLeft:activate() } )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:onPanelAction( cArea, nPage )
   LOCAL i
   LOCAL lLeft := cArea == "L"
   LOCAL oToolBox := iif( lLeft, ::oUI:toolBoxLeft, ::oUI:toolBoxRight )
   LOCAL aComp := iif( lLeft, ::aCompLeft, ::aCompRight )

   FOR i := oToolBox:count() TO 1 STEP -1
      oToolBox:widget( i - 1 ):hide()
      oToolBox:removeItem( i - 1 )
   NEXT
   oToolBox:addItem( aComp[ nPage + 1, 1 ], aComp[ nPage + 1, 2 ], aComp[ nPage + 1, 3 ] )
   aComp[ nPage + 1, 1 ]:show()
   IF ! oToolBox:isVisible()
      oToolBox:show()
      IF lLeft
         ::oUI:labelTopLeft:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxLeft:isVisible(), "left-close", "left-open" ) ) ) )
         ::lToolboxLeftVisible := oToolBox:isVisible()
      ELSE
         ::oUI:labelTopRight:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxLeft:isVisible(), "right-close", "right-open" ) ) ) )
         ::lToolboxRightVisible := oToolBox:isVisible()
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:buildStyleSheet()
   LOCAL aCSS := {}
   LOCAL cCSS := ""

   AAdd( aCSS, '#labelTopLeft, #labelTopRight{' )
   AAdd( aCSS, '    min-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-height: '                + __hbqtCssPX( 50 ) )
   AAdd( aCSS, '    background-color: rgba(255,255,255,0);' )
   AAdd( aCSS, '}' )

   AAdd( aCSS, '#frameTop {' )
   AAdd( aCSS, '   min-width: 0px;' )
   AAdd( aCSS, '   max-height: '                 + __hbqtCssPX( 60 ) )
   AAdd( aCSS, '}' )

   AAdd( aCSS, 'QToolButton::checked {' )
   AAdd( aCSS, '   background-color: red;' )
   AAdd( aCSS, '}' )

   AAdd( aCSS, 'QGraphicsView {' )
   AAdd( aCSS, '   background: rgb( 170,170,170 );' )
   AAdd( aCSS, '}' )

   AAdd( aCSS, 'QStatusBar {' )
   AAdd( aCSS, '   min-height: '                 + __hbqtCssPX( 24 ) )
   AAdd( aCSS, '   max-height: '                 + __hbqtCssPX( 24 ) )
   AAdd( aCSS, '   font-size: '                  + __hbqtCssPX( 20 ) )
   AAdd( aCSS, '}' )

   AAdd( aCSS, '#toolBoxLeft::tab:selected, #toolBoxRight::tab:selected { ' )
   AAdd( aCSS, '   font: bold; color: black;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, '#toolBoxLeft::tab:!selected, #toolBoxRight::tab:!selected {' )
   AAdd( aCSS, '   color: black;' )
   AAdd( aCSS, '}' )

   AEval( aCSS, {|e| cCSS += e + Chr( 13 )+Chr( 10 ) } )
   RETURN cCSS


METHOD HbQtVisualizer:restoreState( hState )
   LOCAL tmp

   IF HB_ISHASH( hState )
      IF hb_HHasKey( hState, "SplitterSizes" )
         tmp := hb_base64Decode( hState[ "SplitterSizes" ] )
         ::oSplitter:restoreState( QByteArray( tmp, Len( tmp ) ) )
      ENDIF
      IF hb_HHasKey( hState, "LeftPanelVisible" )
         ::oUI:toolBoxLeft:setVisible( hState[ "LeftPanelVisible" ] )
      ENDIF
      IF hb_HHasKey( hState, "RightPanelVisible" )
         ::oUI:toolBoxRight:setVisible( hState[ "RightPanelVisible" ] )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:saveState()
   LOCAL hState

   IF ! Empty( ::oCurHbQtVisual )
      hState := __hbqtStandardHash()
      //
      hState[ "SplitterSizes"     ] := ::cSplitterSizes
      hState[ "LeftPanelVisible"  ] := ::lToolboxLeftVisible
      hState[ "RightPanelVisible" ] := ::lToolboxRightVisible
      hState[ "CurrentVisual"     ] := ::oCurHbQtVisual:refID()
   ENDIF
   RETURN hState


//--------------------------------------------------------------------//
//                       Manage Opening Objects
//--------------------------------------------------------------------//

METHOD HbQtVisualizer:refreshItem( hItem )
   LOCAL oHbQtVisual, oHbQtVisualItem, oRect

   IF HB_ISHASH( hItem ) .AND. hb_HHasKey( hItem, "Action" )
      oHbQtVisual := ::hHbQtVisuals[ hItem[ "RefID" ] ]
      oHbQtVisualItem := oHbQtVisual:item( hItem[ "Name" ] )

      SWITCH hItem[ "Action" ]
      CASE __VISUALIZER_ACTION_X__
         oRect := oHbQtVisualItem:oWidget:geometry()
         oHbQtVisualItem:oWidget:setPos( QPointF( hItem[ "X" ], oRect:y() ) )
         oHbQtVisualItem:update()
         EXIT
      CASE __VISUALIZER_ACTION_Y__
         EXIT
      CASE __VISUALIZER_ACTION_POS__
         EXIT
      CASE __VISUALIZER_ACTION_WIDTH__
         EXIT
      CASE __VISUALIZER_ACTION_HEIGHT__
         EXIT
      CASE __VISUALIZER_ACTION_GEOMETRY__
         EXIT
      CASE __VISUALIZER_ACTION_STATE__
         EXIT
      CASE __VISUALIZER_ACTION_DEL__
         EXIT
      CASE __VISUALIZER_ACTION_LOCK__
         EXIT
      CASE __VISUALIZER_ACTION_ROTATE__
         EXIT
      ENDSWITCH
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:itemDataChangedBlock( bBlock )
   LOCAL bOldBlock := ::bItemDataChangedBlock
   IF HB_ISBLOCK( bBlock )
      ::bItemDataChangedBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualizer:itemDataRequestBlock( bBlock )
   LOCAL bOldBlock := ::bItemDataRequestBlock
   IF HB_ISBLOCK( bBlock )
      ::bItemDataRequestBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualizer:visualsListBlock( bBlock )
   LOCAL bOldBlock := ::bVisualsListBlock
   IF HB_ISBLOCK( bBlock )
      ::bVisualsListBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualizer:visualsLoadBlock( bBlock )
   LOCAL bOldBlock := ::bVisualsLoadBlock
   IF HB_ISBLOCK( bBlock )
      ::bVisualsLoadBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualizer:execInfoBlock( cWhat, xData )
   LOCAL hRspns

   IF HB_ISBLOCK( ::visualInfoBlock() )
      // following three actions are Vizualizer based which already have been requested from application
      IF Lower( cWhat ) == "hidemessagesrequested"
         ::oUI:stackBase:setCurrentWidget( ::oUI:pageBaseNew )
      ELSEIF Lower( cWhat ) == "showmessagesrequested"
         ::oUI:stackBase:setCurrentWidget( ::oUI:pageBaseMain )
      ELSEIF Lower( cWhat ) == "iconforbackbutton"
         hRspns := ::currentVisualIcon()
      ELSE
         hRspns := Eval( ::visualInfoBlock(), cWhat, ::oCurHbQtVisual:refID(), ::oCurHbQtVisual:version(), xData )
      ENDIF
   ENDIF
   RETURN hRspns


METHOD HbQtVisualizer:visualInfoBlock( bBlock )
   LOCAL bOldBlock := ::bVisualInfoBlock
   IF HB_ISBLOCK( bBlock )
      ::bVisualInfoBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualizer:visualsSaveBlock( bBlock )
   LOCAL bOldBlock := ::bVisualsSaveBlock
   IF HB_ISBLOCK( bBlock )
      ::bVisualsSaveBlock := bBlock
   ENDIF
   RETURN bOldBlock


STATIC FUNCTION  __hbqtIconFromBuffer( cBuffer )
   LOCAL oPixmap := QPixmap()
   oPixmap:loadFromData( cBuffer, Len( cBuffer ), "PNG" )
   RETURN QIcon( oPixmap )


METHOD HbQtVisualizer:hide()
   ::oSlidingsManager:activateSlidings( "none", "none" )
   RETURN Self


METHOD HbQtVisualizer:show()
   LOCAL hList, hMarker, oFirst, hVisual, oVisualInTree, cVisual

   HbQtActivateSilverLight( .T., "Loading Visuals List..." )

   ::setSplitterSizes()
   ::restoreState( ::hState )

   ::lToolboxRightVisible := ::oUI:toolBoxRight:isVisible()
   ::lToolboxLeftVisible  := ::oUI:toolBoxLeft:isVisible()
   ::cSplitterSizes       := ::oSplitter:saveState():toBase64():data()
   ::oSlidingsManager:activateSlidings( "PrintListL", "PrintList" )

   IF ! ::lShowInitialized
      IF HB_ISBLOCK( ::visualsListBlock() )
         hList := Eval( ::visualsListBlock(), Self )
      ENDIF
      IF Empty( hList )
         hList := __hbqtVisualsList()
      ENDIF
      IF .T.
         IF HB_ISHASH( hList ) .AND. ! Empty( hList )
            ::lShowInitialized := .T.
            ::hVisualsList := hb_HClone( hList[ "List" ] )

            ::buildVisualsTree( ::hVisualsList )

            IF hb_HHasKey( hList, "States" )
               ::hVisualsStates := hb_HClone( hList[ "States" ] )
               ::buildStates( ::hVisualsStates )
            ENDIF

            ::hMarkers[ "m_markers" ] := __hbqtStandardHash()
            IF hb_HHasKey( hList, "Markers" )
               ::hMarkers[ "m_markers" ] := hb_HClone( hList[ "Markers" ] )
            ENDIF
            FOR EACH hMarker IN ::hMarkers[ "m_markers" ]
               hMarker[ "Pixmap" ] := __hbqtLoadPixmapFromBuffer( hb_base64Decode( hMarker[ "Icon" ] ) )
            NEXT

            IF hb_HHasKey( hList, "Structure" ) .AND. HB_ISHASH( hList[ "Structure" ] )
               ::hDataStruct := hb_HClone( hList[ "Structure" ] )
               ::buildDataSheets()
            ENDIF

            FOR EACH hVisual IN ::hVisualsList
               ::hHbQtVisuals[ hVisual:__enumKey() ] := HbQtVisual():new( Self ):create()
               ::hHbQtVisuals[ hVisual:__enumKey() ]:list( hVisual )
            NEXT

            // Fire first visual in the list - replace it by looking at what it was at last session
            //
            IF __hbqtHHasKey( ::hState, "CurrentVisual", @cVisual )
               FOR EACH oVisualInTree IN ::hVisualsTree
                  IF oVisualInTree:whatsThis( 0 ) == cVisual
                     oFirst := oVisualInTree
                     EXIT
                  ENDIF
               NEXT
            ENDIF
            IF Empty( oFirst )
               oFirst := hb_HValueAt( ::hVisualsTree, 1 )
            ENDIF
            ::oVisualsTree:setCurrentItem( oFirst )
            ::loadVisual( oFirst:whatsThis( 0 ) )
            IF oFirst:whatsThis( 0 ) == "UNTITLED"
               ::toggleGrid()
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   HbQtActivateSilverLight( .F., "Loading Visuals List..." )
   RETURN Self


METHOD HbQtVisualizer:animateVisualsTree()
   LOCAL oVisualTreeItem, oHbQtVisual, cRefID

   FOR EACH oVisualTreeItem IN ::hVisualsTree
      cRefID := oVisualTreeItem:whatsThis( 0 )

      IF hb_HHasKey( ::hHbQtVisuals, cRefID )
         oHbQtVisual := ::hHbQtVisuals[ cRefID ]

         IF oHbQtVisual == ::oCurHbQtVisual
            oVisualTreeItem:setBackground( 0, ::hTreeBGBrush[ "VisualCurrent" ] )
         ELSE
            IF oHbQtVisual:loaded()
               IF oHbQtVisual:editingMode()
                  oVisualTreeItem:setBackground( 0, ::hTreeBGBrush[ "VisualEditing" ] )
               ELSE
                  oVisualTreeItem:setBackground( 0, ::hTreeBGBrush[ "VisualLoaded" ] )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtVisualizer:loadVisual( cRefID, nVer )
   LOCAL hVisual

   IF Empty( cRefID )
      RETURN Self
   ENDIF
   DEFAULT nVer TO ::hVisualsList[ cRefID ][ "Version" ]

   WITH OBJECT ::oUI:labelTopLeft
      :setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxLeft:isVisible(), "left-close", "left-open" ) ) ) )
   ENDWITH
   WITH OBJECT ::oUI:labelTopRight
      :setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxRight:isVisible(), "right-close", "right-open" ) ) ) )
   ENDWITH

   IF ! Empty( ::oCurHbQtVisual )
      ::oCurHbQtVisual:transform( ::oGraphicsView:Transform() )
      ::oCurHbQtVisual:vertPos( ::oGraphicsView:verticalScrollBar():value() )
      ::oCurHbQtVisual:horzPos( ::oGraphicsView:horizontalScrollbar():value() )
   ENDIF

   ::oCurHbQtVisual := NIL
   ::oCurGraphicsItem := NIL

   ::showStatus( STATUS_PANEL_VISUALS )
   IF ! Empty( cRefID )
      ::oCurHbQtVisual := ::hHbQtVisuals[ cRefID ]

      IF HB_ISBLOCK( ::visualsLoadBlock() )
         IF hb_HHasKey( ::hVisualsList, cRefID ) .AND. hb_HHasKey( ::hVisualsList[ cRefID ], "Visual" )
            // nothing to do
         ELSE
            HbQtActivateSilverLight( .T., "Loading Visual..." + cRefID )

            hVisual := Eval( ::visualsLoadBlock(), cRefID, nVer )

            IF HB_ISHASH( hVisual ) .AND. ! Empty( hVisual )
               ::hVisualsList[ cRefID ][ "Visual" ] := hVisual
               ::oCurHbQtVisual:visual( hVisual )
               ::oCurHbQtVisual:setupMarkers( hVisual[ "Markers" ], ::hMarkers[ "m_markers" ] )
            ENDIF

            HbQtActivateSilverLight( .F., "Loading Visual..." + cRefID )
         ENDIF
      ENDIF

      ::activateScene()
      ::buildMarkersTree()
      ::buildFiltersTree()
      ::buildLayersTree()
      ::buildChangeLayerTree()
      ::populateVisual()
      ::animateVisualsTree()
      ::showStatus( STATUS_PANEL_VISUALS, ::oCurHbQtVisual:title() )
   ENDIF

   ::onPanelAction( "L", PAGE_ITEMS )
   RETURN Self


METHOD HbQtVisualizer:buildStates( hStates )
   LOCAL hState, oPixmap, oState

   IF ! Empty( hStates )
      WITH OBJECT ::oStatesToolbar := HbQtScrollableToolbar():new()
         :setIndicatorsRGB( { 255,0,0 } )
         :setButtonHeight( 50 )
         :setButtonWidth( 50 + 70 )
         :create( ::oUI:vLayToolbarStates )
      ENDWITH
      WITH OBJECT ::oStatesToolbar
         FOR EACH hState IN hStates
            oState := HbQtVisualItemState():new( hState )
            hState[ "HbQtVisualItemState" ] := oState
            oPixmap := oState:pixmap( __hbqtPixelsByDPI( 50 ), __hbqtPixelsByDPI( 50 ) )
            :addToolbarButton( hState:__enumKey(), hState:__enumKey(), QIcon( oPixmap ), ;
                                      __stateNameBlock( Self, hState:__enumKey() ), .T., .F., NIL, NIL, Qt_ToolButtonTextBesideIcon )
         NEXT
      ENDWITH
   ENDIF
   RETURN Self


STATIC FUNCTION __stateNameBlock( oObj, cState )
   RETURN {|| oObj:manageStateClicks( cState ) }


METHOD HbQtVisualizer:manageStateClicks( cButton )
   LOCAL oldState
   IF ::cCurrentState != cButton
      oldState := ::oStatesToolbar:setState( ::cCurrentState, 2 )
      ::cCurrentState := cButton
   ELSE
      ::cCurrentState := NIL
   ENDIF
   HB_SYMBOL_UNUSED( oldState )
   RETURN Self


STATIC FUNCTION __hbqtVisualsList()
   LOCAL cBuffer, aVisual, hVisual, hVisuals, hList, aList, hState, hStates

   cBuffer  := __hbqtLoadResourceAsBase64String( "harbour.png" )

   aList := {}
   AAdd( aList, { "UNTITLED", "1", "Untitled", "Whatever...", cBuffer , "", .T., {} } )

   hList := __hbqtStandardHash()
   FOR EACH aVisual IN aList
      hVisual := __hbqtStandardHash()

      hVisual[ "RefID"   ] := aVisual[ 1 ]        // base of all in/out requests - unique across each session
      hVisual[ "Version" ] := aVisual[ 2 ]        // version string which will be used to send requests for load/save.
      hVisual[ "Label"   ] := aVisual[ 3 ]        // displayable label in the tree - must be short name
      hVisual[ "Purpose" ] := aVisual[ 4 ]        // displayed as a tooltip what this visual belongs to
      hVisual[ "Icon"    ] := aVisual[ 5 ]        // base64 encoded image buffer - easily storable in tables or resources
      hVisual[ "Parent"  ] := aVisual[ 6 ]        // parent RefID - only to display Visuals list in descent manner
      hVisual[ "Editable"] := aVisual[ 7 ]        // should editing and saving of this visual is allowed

      hList[ aVisual[ 1 ] ] := hVisual
   NEXT

   IF .T.
      hStates := __hbqtStandardHash()

      hState  := __hbqtStandardHash()
      //
      hState[ "Shape"       ] := "Rectangle"
      hState[ "Area"        ] := __STATE_AREA_BOTTOMRIGHT__
      hState[ "Style"       ] := Qt_SolidPattern
      hState[ "Color"       ] := "#FF0000"
      hState[ "BorderStyle" ] := Qt_SolidLine
      hState[ "BorderWidth" ] := 1
      hState[ "BorderColor" ] := "#000000"
      //
      hStates[ "Installing" ] := hState

      hState  := __hbqtStandardHash()
      //
      hState[ "Shape"       ] := "Ellipse"
      hState[ "Area"        ] := __STATE_AREA_CENTER__
      hState[ "Style"       ] := Qt_LinearGradientPattern
      hState[ "Color"       ] := "#ADFF2F"
      hState[ "BorderStyle" ] := Qt_DotLine
      hState[ "BorderWidth" ] := 2
      hState[ "BorderColor" ] := "#FF0000"
      //
      hStates[ "Activated" ] := hState
   ENDIF

   hVisuals := __hbqtStandardHash()

   hVisuals[ "Label"   ] := "Just"
   hVisuals[ "List"    ] := hList
   hVisuals[ "States"  ] := hStates

   RETURN hVisuals


