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


#define UNIT  0.1

#define INI_KEY( cKey, n )                        cKey + "_" + hb_ntos( n ) + "="
#define U_UNIT( n )                               ( n / 0.1 )

#define hbqt_screen_heightMM                      ( QDesktopWidget():height() / QDesktopWidget():physicalDpiY() * 25.4 )
#define hbqt_screen_widthMM                       ( QDesktopWidget():width()  / QDesktopWidget():physicalDpiX() * 25.4 )

#define HBQT_GRAPHICSVIEW_ZOOM_IN                 1
#define HBQT_GRAPHICSVIEW_ZOOM_OUT                2
#define HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG            3
#define HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL           4

#define HBQT_GRAPHICSITEM_SELECTED                1
#define HBQT_GRAPHICSITEM_DELETED                 2
#define HBQT_GRAPHICSITEM_GEOMETRYCHANGED         3


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


#define __HBQT_PRP_JUST__                         1000
#define __HBQT_PRP_EDIT__                         1001
#define __HBQT_PRP_COMBO__                        1002
#define __HBQT_PRP_COLOR__                        1003
#define __HBQT_PRP_FONT__                         1004
#define __HBQT_PRP_TEXTURE__                      1005

#define __HBQT_VISUALIZER_OPTION_RESIZEINPLACE__  1

#define STATUS_PANEL_READY                        1
#define STATUS_PANEL_STATES                       2
#define STATUS_PANEL_MARKERS                      3
#define STATUS_PANEL_VISUALS                      4
#define STATUS_PANEL_MISC                         5

STATIC hIDs := {=>}


CLASS HbQtVisualizer

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD destroy()                               VIRTUAL

   METHOD setSplitterSizes( nFrameLeftWidth, nFrameRightWidth )
   METHOD setOption( nOption, xValue )

   ACCESS toolbarTop()                            INLINE ::oToolbar
   ACCESS toolbarObjects()                        INLINE ::oToolbarObjects

   METHOD visualsListBlock( bBlock )              SETGET
   METHOD visualsLoadBlock( bBlock )              SETGET
   METHOD visualsSaveBlock( bBlock )              SETGET
   METHOD visualsVerListBlock( bBlock )           SETGET

   METHOD manageStateClicks( cButton )
   METHOD manageMarkerVClicks( cMarker )

   PROTECTED:

   DATA   oUI

   DATA   oWidget
   DATA   oParent
   DATA   oToolbar
   DATA   oToolbarObjects
   DATA   oToolbarStates
   DATA   oHbQtPreview
   DATA   oDataWidget
   DATA   oDataManager
   DATA   oDataSheet
   DATA   oSplitter
   DATA   oPropWidget
   DATA   oPropManager
   DATA   oSheetGraphicObjects
   DATA   oTreeVisuals
   DATA   oTreeNavigator
   DATA   oTreeData
   DATA   oMarkersTree
   DATA   oCurrentMarkersItem
   DATA   oGraphicsView
   DATA   oScene
   DATA   oStatusBar
   DATA   oCurGraphicsItem
   DATA   oHbQtVisualBackground
   DATA   oPixmapBackground

   DATA   cSaved                                  INIT ""
   DATA   cCurrentVisual                          INIT ""
   DATA   cCurrentState
   DATA   cCurrentMarkerV

   DATA   nScreenDpiX                             INIT 96
   DATA   nScreenDpiY                             INIT 96
   DATA   nResizerSteps                           INIT 10
   DATA   nMoverSteps                             INIT 10

   DATA   lNew                                    INIT .T.
   DATA   lShowGrid                               INIT .F.
   DATA   lDoubleClickZoom                        INIT .F.
   DATA   lResizerOn                              INIT .F.
   DATA   lMovingOn                               INIT .F.
   DATA   lEditingOn                              INIT .F.
   DATA   lResizeInPlace                          INIT .T.
   DATA   lShowInitialized                        INIT .F.

   DATA   bVisualsListBlock
   DATA   bVisualsLoadBlock
   DATA   bVisualsSaveBlock
   DATA   bVisualsVerListBlock

   DATA   hVisualsTree                            INIT __hbqtStandardHash()
   DATA   hItems                                  INIT __hbqtStandardHash()
   DATA   hNavigatorTree                          INIT __hbqtStandardHash()
   DATA   hVisualsList                            INIT __hbqtStandardHash()
   DATA   hDataStruct                             INIT __hbqtStandardHash()
   DATA   hVisualsStates                          INIT __hbqtStandardHash()
   DATA   hMarkers                                INIT __hbqtStandardHash()


   DATA   aStatusPnls                             INIT {}
   DATA   aPages                                  INIT {}
   DATA   aSources                                INIT {}
   DATA   aObjects                                INIT {}
   DATA   aRptPages                               INIT {}
   DATA   aRptSources                             INIT {}
   DATA   aRptObjects                             INIT {}

   DATA   cCurrentVisualTitle                     INIT "Untitled"
   DATA   cNavigtTreePage                         INIT "Objects"

   METHOD execEvent( nEvent, p, p1, p2 )

   METHOD buildToolbar( oLayout )
   METHOD buildToolbarObjects( oLayout )
   METHOD buildMarkersTree()
   METHOD buildStatusBar()
   METHOD buildComponents()
   METHOD buildScene()
   METHOD buildPropertySheets()
   METHOD buildDataSheets()
   METHOD showStatus( nPanel, cMsg )
   METHOD addObject( cType, oPos, oGeo )
   METHOD placeObject( nSceneX, nSceneY )
   METHOD populateVisual( xData )
   METHOD getNextID( cType )
   METHOD getImageOfType( cType )
   METHOD updateObjectsTree( cType, cParent, cName, cSubType, oPixmap )
   METHOD contextMenuScene( nX, nY )
   METHOD addSource( cAlias, aStruct )
   METHOD clear()
   METHOD buildVisualStream()
   METHOD toString()
   METHOD parseBuffer( cBuffer )
   METHOD presentBlankVisual()
   METHOD printVisual( oPrinter )
   METHOD printPreview( oPrinter )
   METHOD zoom( nMode )
   METHOD resizeMarker( nDirection )
   METHOD moveMarker( nDirection )
   METHOD manageEditing( lOn )

   METHOD itemActionsBlock( oHbQtVisualItem, nAction )
   METHOD objectGeometryChanged( oHbQtVisualItem )
   METHOD objectDeleted( oHbQtVisualItem )
   METHOD objectSelected( oHbQtVisualItem )
   METHOD deleteState( oHbQtVisualItem )
   METHOD rotateMarker( oCurGraphicsItem, nDirection )
   METHOD toggleLockOnObject()
   METHOD toggleGrid()
   METHOD setMarker( oGraphicsItem )
   METHOD clearMarker()

   METHOD setBackgroundImage( oPixmap )           INLINE ::oPixmapBackground := oPixmap
   ACCESS splitter()                              INLINE ::oSplitter

   METHOD dataStructureProperties()
   METHOD populateDataSheet( oHbQtVisualItem )
   METHOD dataPropertyChanged( cSheet, cProperty, xValue )

   ACCESS propertiesManager()                     INLINE ::oPropManager
   METHOD populatePropertySheet( oHbQtVisualItem )
   METHOD visualPropertyChanged( cSheet, cProperty, xValue )
   METHOD saveVisual( cVisualID )
   METHOD show()
   METHOD populateVisualsList( hVisualsList )
   METHOD loadVisual( cRefID )
   METHOD buildStates( hStates )
   METHOD buildStyleSheet()
   METHOD switchItemOptions( lOnOff )
   METHOD updateItemStatus( oHbQtVisualItem )

   ENDCLASS


METHOD HbQtVisualizer:init( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   hIDs := __hbqtStandardHash()

   RETURN Self


METHOD HbQtVisualizer:create( oParent )
   LOCAL oLayout, i

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::oUI := hbqtui_visualizer( oParent )
   ::oWidget := ::oUI:oWidget

   ::oWidget:setStyleSheet( ::buildStyleSheet() )

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

   ::buildToolbar( ::oUI:hLayToolbarVisualizer )
   ::buildToolbarObjects( ::oUI:vLayToolbarVisualizer )
   ::buildComponents()
   ::buildMarkersTree()
   ::buildPropertySheets()

   WITH OBJECT ::oUI:labelTopLeft
      :connect( QEvent_MouseButtonPress, {|| iif( ::oUI:toolBoxLeft:isVisible(), ::oUI:toolBoxLeft:hide(), ::oUI:toolBoxLeft:show() ) } )
      :connect( QEvent_MouseButtonPress, {|| iif( ::oUI:toolBoxLeft:isVisible(), ::oUI:toolBoxLeft:hide(), ::oUI:toolBoxLeft:show() ), ;
           ::oUI:labelTopLeft:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxLeft:isVisible(), "arrow-left-1", "arrow-right-1" ) ) ) ) } )
   ENDWITH
   WITH OBJECT ::oUI:labelTopRight
      :connect( QEvent_MouseButtonPress, {|| iif( ::oUI:toolBoxRight:isVisible(), ::oUI:toolBoxRight:hide(), ::oUI:toolBoxRight:show() ), ;
           ::oUI:labelTopRight:setPixmap( QPixmap( __hbqtImage( iif( ::oUI:toolBoxRight:isVisible(), "arrow-right-1", "arrow-left-1" ) ) ) ) } )
   ENDWITH

   ::oUI:splitterViews:setStretchFactor( 0, 0 )
   ::oUI:splitterViews:setStretchFactor( 1, 1 )
   ::oUI:splitterViews:setStretchFactor( 2, 0 )

   ::oUI:toolBoxLeft:setCurrentIndex( 0 )
   ::oUI:toolBoxRight:setCurrentIndex( 1 )

   ::switchItemOptions( .F. )

   ::oUI:stackBase:setCurrentIndex( 1 )
   ::oUI:stackMarkers:setCurrentIndex( 1 )
   ::oUI:stackData:setCurrentIndex( 1 )

   WITH OBJECT ::oHbQtPreview := HbQtPrintPreview():new():create( ::oUI:vLayPreviewer )
      :previewBlock := {|oPrinter| ::printVisual( oPrinter ) }
      :exitBlock    := {|| ::oUI:stackBase:setCurrentIndex( 1 ) }
      :refreshPreview()
   ENDWITH

   ::oWidget:connect( QEvent_Show, {|| ::show() } )

   __hbqGraphics_AllowMovement( ::lEditingOn )

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

   ::manageEditing( .F. )
   RETURN Self


METHOD HbQtVisualizer:buildComponents()

   ::oToolbar:setEnabled( "Separator_1", .F. )

   ::oSplitter := ::oUI:splitterViews
   WITH OBJECT ::oGraphicsView := ::oUI:graphicsView
      //
   ENDWITH

   ::buildScene()

   WITH OBJECT ::oPropWidget := ::oUI:pageProperties
      //
   ENDWITH

   WITH OBJECT ::oTreeNavigator := ::oUI:treeNavigator
      __hbqtApplyStandardScroller( ::oTreeNavigator )
      :connect( "itemClicked(QTreeWidgetItem*,int)", {|p,p1| ::execEvent( __treeObjects_clicked__, p, p1 ) } )
   ENDWITH
   WITH OBJECT ::oTreeData := ::oUI:treeWidgetData
      __hbqtApplyStandardScroller( ::oTreeData )
   ENDWITH
   WITH OBJECT ::oTreeVisuals := ::oUI:treeVisuals
      __hbqtApplyStandardScroller( ::oTreeVisuals )
   ENDWITH
   WITH OBJECT ::oMarkersTree := ::oUI:treeMarkers
      __hbqtApplyStandardScroller( ::oMarkersTree )
      :connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|p,p1| ::execEvent( __treeMarkers_currentItemChanged__, p, p1 ) } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)"              , {|p,p1| ::execEvent( __treeMarkers_clicked__, p, p1 ) } )
   ENDWITH

   ::buildStatusBar()
   ::oUI:vLayoutBaseNew:addWidget( ::oStatusBar )

   ::oUI:pageVisuals:setStyleSheet( __hbqtTreeViewStyleSheet() )
   ::oUI:pageObjects:setStyleSheet( __hbqtTreeViewStyleSheet() )
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

   ::oUI:pageGraphicsView:setStyleSheet( "QWidget#pageGraphicsView{ background: rgb(170,170,170);}" )

   ::oUI:frameResizeOut:setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameResizeIn :setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameMover    :setMaximumWidth( __hbqtPixelsByDPI( 200 ) )
   ::oUI:frameMover    :setMaximumHeight( __hbqtPixelsByDPI( 200 ) )

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


METHOD HbQtVisualizer:buildScene()
   IF Empty( ::oScene )
      ::oScene := HBQGraphicsScene()
   ENDIF
   WITH OBJECT ::oScene
      :hbSetBlock( {|p, p1, p2| ::execEvent( __graphicsScene_block__, p, p1, p2 ) } )
      :setLeftMagnet( .T. )
      :setTopMagnet( .T. )
      :setRightMagnet( .T. )
      :setBottomMagnet( .T. )
      :setPageSize( QPrinter_Letter )
   ENDWITH
   ::oGraphicsView:setScene( ::oScene )
   RETURN Self


METHOD HbQtVisualizer:setSplitterSizes( nFrameLeftWidth, nFrameRightWidth )
   ::splitter():hbSetSizes( { __hbqtPixelsByDPI( nFrameLeftWidth ), ;
                              ::splitter():width()-nFrameLeftWidth-nFrameRightWidth, ;
                              __hbqtPixelsByDPI( nFrameRightWidth ) } )
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
   LOCAL i, oPainter, oRectF, nScaleFactor

   SWITCH nEvent
   CASE __graphicsScene_block__
      DO CASE
      CASE p == 21201                             // paint background
         oPainter := p1
         oRectF := ::oScene:sceneRect()
         oPainter:fillRect( oRectF, QColor( Qt_white ) )
         IF HB_ISOBJECT( ::oHbQtVisualBackground )
            WITH OBJECT ::oHbQtVisualBackground
               :setPixmap( ::oPixmapBackground:scaled( oRectF:width(), oRectF:height(), Qt_KeepAspectRatio ) )
               :setGeometry( oRectF:x(), oRectF:y(), oRectF:width(), oRectF:height() )
               :draw( oPainter, oRectF )
            ENDWITH
         ENDIF
      CASE p == 21107                             // Left button pressed nowhere on an item
         ::objectSelected()
         ::placeObject( p1, p2 )                  // scene coordinates
         ::objectSelected()
      CASE p == 21131                             // double-click
         nScaleFactor := 1.10
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
      CASE p == 21001                             // at initialization
         ::nScreenDpiX := p1
         ::nScreenDpiY := p2
      CASE p == QEvent_GraphicsSceneContextMenu
         ::contextMenuScene( p1:screenPos():x(), p1:screenPos():y() )
      ENDCASE
      EXIT
   CASE __treeObjects_clicked__
      IF hb_hHasKey( ::hItems, p:text( 0 ) )
         ::objectSelected( ::hItems[ p:text( 0 ) ] )
      ELSE
         ::objectSelected()
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
      ::oCurrentMarkersItem:setBackground( 0, QBrush( Qt_white ) )
   ENDIF
   ::cCurrentMarkerV := NIL
   ::oCurrentMarkersItem := NIL
   ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   RETURN Self


METHOD HbQtVisualizer:itemActionsBlock( oHbQtVisualItem, nAction )
   SWITCH nAction
   CASE HBQT_GRAPHICSITEM_SELECTED
      ::objectSelected( oHbQtVisualItem )
      EXIT
   CASE HBQT_GRAPHICSITEM_DELETED
      ::objectDeleted( oHbQtVisualItem )
      EXIT
   CASE HBQT_GRAPHICSITEM_GEOMETRYCHANGED
      ::objectGeometryChanged( oHbQtVisualItem )
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
      IF hb_hHasKey( ::hNavigatorTree, cName )
         IF ! oHbQtVisualItem:isLocked()
            oParent := ::hNavigatorTree[ cName ]:parent()
            oParent:removeChild( ::hNavigatorTree[ cName ] )
            ::hNavigatorTree[ cName ] := NIL
            hb_HDel( ::hNavigatorTree, cName )
            ::oScene:removeItem( oHbQtVisualItem:oWidget )
            hb_HDel( ::hItems, cName )
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

   ::oTreeNavigator:clearSelection()

   IF ! Empty( ::oCurGraphicsItem )
      ::oCurGraphicsItem:unselect()
   ENDIF
   IF hb_hHasKey( ::hNavigatorTree, cName )
      ::oCurGraphicsItem := ::hItems[ cName ]
      ::oTreeNavigator:setCurrentItem( ::hNavigatorTree[ cName ] )
      ::oCurGraphicsItem:select()
   ELSE
      ::oCurGraphicsItem := NIL
   ENDIF
   ::populatePropertySheet( ::oCurGraphicsItem )
   ::populateDataSheet( ::oCurGraphicsItem )
   IF ! Empty( ::cCurrentState ) .AND. ! Empty( ::oCurGraphicsItem )
      ::oCurGraphicsItem:setState( ::hVisualsStates[ ::cCurrentState ][ "HbQtVisualItemState" ] )
      ::oToolbarStates:click( ::cCurrentState )
   ENDIF
   ::switchItemOptions( ! Empty( ::oCurGraphicsItem ) )
   ::updateItemStatus( ::oCurGraphicsItem )
   RETURN Self


METHOD HbQtVisualizer:updateItemStatus( oHbQtVisualItem )
   LOCAL oRect, cMsg

   IF ! Empty( oHbQtVisualItem )
      oRect:= oHbQtVisualItem:geometry()
      cMsg := oHbQtVisualItem:name() + "[(" + LTrim( Str( oRect:x(), 7, 0 ) ) + "," + LTrim( Str( oRect:y(), 7, 0 ) ) + ")" +;
                                LTrim( Str( oRect:width(), 7, 0 ) ) + "," + LTrim( Str( oRect:height(), 7, 0 ) ) + "]"
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
   LOCAL oVisualObject

   FOR EACH oVisualObject IN ::hItems
      ::oScene:removeItem( oVisualObject:oWidget )
      oVisualObject:destroy()
      oVisualObject := NIL
   NEXT
   IF HB_ISOBJECT( ::oHbQtVisualBackground )
      ::oScene:removeItem( ::oHbQtVisualBackground:oWidget )
      ::oHbQtVisualBackground:destroy()
      ::oHbQtVisualBackground := NIL
   ENDIF

   ::oTreeNavigator:clear()
   ::oTreeData:clear()

   hIDs             := __hbqtStandardHash()
   ::hItems         := __hbqtStandardHash()
   ::hNavigatorTree := __hbqtStandardHash()

   ::aObjects    := {}
   ::aPages      := {}
   ::aSources    := {}
   ::aRptObjects := {}
   ::aRptPages   := {}
   ::aRptSources := {}

   ::oScene:invalidate()
   RETURN Self


METHOD HbQtVisualizer:presentBlankVisual()
   aadd( ::aPages, { ::cNavigtTreePage } )

   ::updateObjectsTree( "Visual", NIL, ::cCurrentVisualTitle )
   ::updateObjectsTree( "Page", "Visual", ::cNavigtTreePage )

   ::addSource( "Customer", { { "Title" ,"C",35,0 }, { "Street","C",20,0 }, { "Revenue","N",12,2 } } )
   ::addSource( "Invoice" , { { "Number","C",10,0 }, { "Date"  ,"D",08,0 }, { "Amount" ,"N",12,2 } } )

   ::oScene:setPageSize( QPrinter_Letter )
   ::oScene:setOrientation( QPrinter_Landscape )
   ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )

   RETURN Self


METHOD HbQtVisualizer:populateVisual( xData )
   LOCAL cBuffer, a_, d_, oWidget, oRectF
   LOCAL aGeo, aPt, aTran, oGeo, oTran, oPos

   ::clear()

   IF HB_ISOBJECT( ::oPixmapBackground )
      oRectF := ::oScene:sceneRect()
      WITH OBJECT ::oHbQtVisualBackground := HbQtVisualItem():new():create( "Image", "BackGround", {0,0}, { 0, 0, oRectF:width(), oRectF:height() } )
         WITH OBJECT :oWidget
            :setZValue( -5000 )
            :setPixmap( ::oPixmapBackground:scaled( oRectF:width(), oRectF:height(), Qt_KeepAspectRatio ) )
         ENDWITH
      ENDWITH
   ENDIF

   IF Empty( xData )
      ::lNew := .T.
      ::presentBlankVisual()
   ELSE
      ::lNew := .F.

      IF Len( xData ) <= 300 .AND. hb_fileExists( xData )
         ::cSaved := xData
         cBuffer  := hb_UTF8ToStr( hb_MemoRead( xData ) )
         IF ! empty( ::oParent )
            ::oParent:setWindowTitle( "HbQt Visualizer [" + ::cSaved + "]" )
         ENDIF
      ELSE
         ::cSaved := ""
         cBuffer  := xData
      ENDIF

      ::oScene:setPageSize( QPrinter_Letter )
      ::oScene:setOrientation( QPrinter_Landscape )
      ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )

      ::parseBuffer( cBuffer )

      ::updateObjectsTree( "Visual", NIL     , ::cCurrentVisualTitle )
      ::updateObjectsTree( "Page"  , "Visual", ::cNavigtTreePage )

      FOR EACH a_ IN ::aRptSources
         ::addSource( a_[ 1 ], a_[ 2 ] )
      NEXT

      FOR EACH a_ IN ::aRptObjects
         d_:= a_[ 5 ] ; aGeo := d_[ 1 ] ; aPt := d_[ 2 ] ; aTran := d_[ 3 ]

         oGeo := QRectF( aGeo[ 1 ], aGeo[ 2 ], aGeo[ 3 ], aGeo[ 4 ] )
         oPos := QPointF( aPt[ 1 ], aPt[ 2 ] )

         SWITCH a_[ 1 ]
         CASE "Object"
            oWidget := ::addObject( a_[ 4 ], oPos, oGeo ):oWidget
            EXIT
         ENDSWITCH

         oTran   := QTransform()
         oTran   :  setMatrix( aTran[ 1 ], aTran[ 2 ], aTran[ 3 ], aTran[ 4 ], aTran[ 5 ], aTran[ 6 ], aTran[ 7 ], aTran[ 8 ], aTran[ 9 ] )
         oWidget :  setTransform( oTran )
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:addSource( cAlias, aStruct )
   LOCAL oItem, qItmC, b_

   oItem := QTreeWidgetItem()
   oItem:setText( 0, cAlias )
   ::oTreeData:addTopLevelItem( oItem )

   FOR EACH b_ IN aStruct
      qItmC := QTreeWidgetItem()
      qItmC:setText( 0, b_[ 1 ] )
      oItem:addChild( qItmC )
      oItem:setExpanded( .t. )
   NEXT
   aadd( ::aSources, { cAlias, aStruct } )
   RETURN Self


METHOD HbQtVisualizer:addObject( cType, oPos, oGeo )
   LOCAL cName, oGrad, oHbQtVisualItem, aGeo, aPos, cMarker, oPixmap, nWidth, nHeight

   aPos := iif( empty( oPos ), NIL, { oPos:x(), oPos:y() } )
   aGeo := iif( empty( oGeo ), NIL, { oGeo:x(), oGeo:y(), oGeo:width(), oGeo:height() } )

   IF Left( cType, 6 ) == "Marker"
      cMarker := SubStr( cType, 8 )
      cType   := "Marker"
      cName   := cMarker + "_" + hb_ntos( ::getNextID( cMarker ) )
      IF hb_HHasKey( ::hMarkers[ ::cCurrentVisual ][ cMarker ], "Width" )
         nWidth  := ::hMarkers[ ::cCurrentVisual ][ cMarker ][ "Width" ]
      ENDIF
      IF hb_HHasKey( ::hMarkers[ ::cCurrentVisual ][ cMarker ], "Height" )
         nHeight := ::hMarkers[ ::cCurrentVisual ][ cMarker ][ "Height" ]
      ENDIF
   ELSE
      cName := cType + "_" + hb_ntos( ::getNextID( cType ) )
   ENDIF

   WITH OBJECT oHbQtVisualItem := HbQtVisualItem():new():create( cType, cName, aPos, aGeo, nWidth, nHeight )

      :actionsBlock := {|oHbQtVisualItem,nAction| ::itemActionsBlock( oHbQtVisualItem, nAction ) }

      SWITCH cType
      CASE "Marker"
         oPixmap := __hbqtLoadPixmapFromBuffer( hb_base64Decode( ::hMarkers[ ::cCurrentVisual ][ cMarker ][ "Icon" ] ) )
         :setPixmap( oPixmap )
         :setBorderWidth( 2 )
         :setData( __hbqtMergeMarkerData( ::hDataStruct, ::hMarkers[ ::cCurrentVisual ][ cMarker ] ) )
         EXIT
      CASE "Image"
         :setPixmap( QPixmap( __hbqtImage( "harbour" ) ) )
         :setBorderWidth( 2 )
         EXIT
      CASE "Chart"
         EXIT
      CASE "Gradient"
         WITH OBJECT oGrad := QLinearGradient()
            :setColorAt( 0, QColor( 195,225,255 ) )
            :setColorAt( 1, QColor( Qt_darkBlue ):darker( 150 ) )
            :setCoordinateMode( QGradient_StretchToDeviceMode )
         ENDWITH
         :setBrush( QBrush( oGrad ) )
         :setPen( QPen( Qt_NoPen ) )
         EXIT
      CASE "Barcode"
         :setText( "Harbour" )
         :setBarcodeType( HQR_BARCODE_3OF9 )
         EXIT
      CASE "Text"
         :setText( "Text" )
         EXIT
      ENDSWITCH
      ::oScene:addItem( :oWidget )
   ENDWITH

   ::hItems[ cName ] := oHbQtVisualItem
   ::updateObjectsTree( "Object", ::cNavigtTreePage, cName, cType, oPixmap )
   aadd( ::aObjects, { "Object", ::cNavigtTreePage, cName, cType, {} } )

   RETURN oHbQtVisualItem


METHOD HbQtVisualizer:manageEditing( lOn )
   LOCAL lSwitchOn

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
      __hbqtUndoStandardScroller( ::oGraphicsView )
      QScroller():scroller( ::oGraphicsView ):ungrabGesture( ::oGraphicsView )
      ::oGraphicsView:setDragMode( QGraphicsView_ScrollHandDrag )
   ELSE
      __hbqtApplyStandardScroller( ::oGraphicsView )
      ::oGraphicsView:setDragMode( QGraphicsView_NoDrag )
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
   RETURN Self


METHOD HbQtVisualizer:updateObjectsTree( cType, cParent, cName, cSubType, oPixmap )
   LOCAL oParent, oItem

   DO CASE
   CASE cType == "Visual"
      WITH OBJECT oItem := QTreeWidgetItem()
         :setText( 0, cName )
         :setIcon( 0, QIcon( __hbqtImage( "r-report" ) ) )
      ENDWITH
      ::oTreeNavigator:addTopLevelItem( oItem )
      ::hNavigatorTree[ cType ] := oItem
      oItem:setExpanded( .t. )

   CASE cType == "Page" .OR. cType == "Object" .OR. cType == "Field"
      IF hb_hHasKey( ::hNavigatorTree, cParent )
         oParent := ::hNavigatorTree[ cParent ]
      ENDIF
      IF !empty( oParent )
         IF hb_hHasKey( ::hNavigatorTree, cName )
            //
         ENDIF
         oItem := QTreeWidgetItem()
         oItem:setText( 0, cName )
         oParent:addChild( oItem )
         ::hNavigatorTree[ cName ] := oItem

         IF cType == "Page"
            oItem:setIcon( 0, QIcon( __hbqtImage( "r-page" ) ) )
         ELSEIF cType == "Object"
            IF ! Empty( oPixmap )
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
      ::oToolbarObjects:setState( ::cCurrentMarkerV, 2 )
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
         ::oToolbarObjects:click( ::cCurrentMarkerV )
         ::clearMarker()
      ENDIF
      ::showStatus( STATUS_PANEL_MARKERS, iif( Empty( ::cCurrentMarkerV ), "", ::cCurrentMarkerV ) )
   ENDIF
   RETURN Self


STATIC FUNCTION  __hbqtTreeWidgetItem( cText, cWhatsThis, cIcon, oFont )
   LOCAL oItem

   WITH OBJECT oItem := QTreeWidgetItem()
      :setText( 0, cText )
      :setWhatsThis( 0, cWhatsThis )
      :setIcon( 0, QIcon( cIcon ) )
      :setFont( 0, oFont )
      :setFlags( Qt_ItemIsEnabled )
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


METHOD HbQtVisualizer:buildMarkersTree()
   LOCAL oItem, oIcon, hVisual, oChild, hMarker, oGroup, oFont
   LOCAL oSize := QSize( __hbqtPixelsByDPI( 40 ), __hbqtPixelsByDPI( 40 ) )
   LOCAL hGrp := __hbqtStandardHash()

   oFont := ::oMarkersTree:font()
   oFont:setPixelSize( __hbqtPixelsByDPI( 16 ) )

   ::oMarkersTree:clear()
   ::oMarkersTree:setIconSize( oSize )

   IF ! Empty( ::cCurrentVisual )
      IF hb_HHasKey( ::hMarkers, ::cCurrentVisual ) .AND. ! Empty( ::hMarkers[ ::cCurrentVisual ] )
         hVisual := ::hVisualsList[ ::cCurrentVisual ]
         oIcon := __hbqtIconFromBuffer( hb_base64Decode( hVisual[ "Icon" ] ) )
         WITH OBJECT oItem := QTreeWidgetItem()
            :setText( 0, hVisual[ "Label" ] )
            :setIcon( 0, oIcon )
            :setData( 0, Qt_UserRole, QVariant( "VisualMarkers" ) )
            :setFlags( Qt_ItemIsEnabled )
            :setBackground( 0, QBrush( QColor( 220,255,220 ) ) )
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
            :setFont( 0, oFont )
         ENDWITH
         ::oMarkersTree:addTopLevelItem( oItem )

         FOR EACH hMarker IN ::hMarkers[ ::cCurrentVisual ]
            IF hb_HHasKey( hMarker, "Group" ) .AND. ! Empty( hMarker[ "Group" ] )
               WITH OBJECT oGroup := QTreeWidgetItem()
                  :setText( 0, hMarker[ "Group" ] )
                  :setFlags( Qt_ItemIsEnabled )
                  :setBackground( 0, QBrush( QColor( 255,255,220 ) ) )
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
                  :setFont( 0, oFont )
               ENDWITH
               oItem:addChild( oGroup )
               hGrp[ hMarker[ "Group" ] ] := oGroup
               IF hMarker:__enumIndex() == 1
                  oGroup:setExpanded( .T. )
               ENDIF
            ENDIF
         NEXT
         FOR EACH hMarker IN ::hMarkers[ ::cCurrentVisual ]
            IF hb_HHasKey( hMarker, "Icon" ) .AND. hb_HHasKey( hMarker, "Label" )
               WITH OBJECT oChild := QTreeWidgetItem()
                  :setText( 0, hMarker[ "Label" ] )
                  :setIcon( 0, QIcon( hMarker[ "Pixmap" ] ) )
                  :setFlags( Qt_ItemIsEnabled  )
                  :setWhatsThis( 0, "Marker" + "_" + hMarker:__enumKey() )
                  :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( 40 ) ) )
                  :setFont( 0, oFont )
                  IF hb_HHasKey( hMarker, "Group" ) .AND. ! Empty( hMarker[ "Group" ] )
                     hGrp[ hMarker[ "Group" ] ]:addChild( oChild )
                  ELSE
                     oItem:addChild( oChild )
                  ENDIF
               ENDWITH
            ENDIF
         NEXT
         oItem:setExpanded( .T. )
      ENDIF
   ENDIF

   WITH OBJECT oItem := __hbqtTreeWidgetItem( "Defaults", "", __hbqtImage( "prv_objects-1" ), oFont )
      :setBackground( 0, QBrush( QColor( 220,255,220 ) ) )
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
   IF ::oMarkersTree:topLevelItemCount() == 1
      oItem:setExpanded( .T. )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:toggleGrid()
   ::lShowGrid := ! ::lShowGrid
   ::oScene:setShowGrid( ::lShowGrid )
   RETURN Self


METHOD HbQtVisualizer:buildToolbarObjects( oLayout )

   WITH OBJECT ::oToolbarObjects := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( { 255,0,0 } )
      :setButtonHeight( 50 )
      :setButtonWidth( 50 )
      :create( oLayout )
   ENDWITH

   WITH OBJECT ::oToolbarObjects
      :addToolbarButton( "Text"       , "Text"               , "text-object"  , {|| ::manageMarkerVClicks( "Text"        ) }, .T., .F. )
      :addToolbarButton( "Barcode"    , "Barcode"            , "z-barcode"    , {|| ::manageMarkerVClicks( "Barcode"     ) }, .T., .F. )
      :addToolbarButton( "Rectangle"  , "Rectangle"          , "z-rectangle"  , {|| ::manageMarkerVClicks( "Rectangle"   ) }, .T., .F. )
      :addToolbarButton( "RoundedRect", "Rounded Rectangle"  , "z-roundedrect", {|| ::manageMarkerVClicks( "RoundedRect" ) }, .T., .F. )
      :addToolbarButton( "Ellipse"    , "Ellipse"            , "z-ellipse"    , {|| ::manageMarkerVClicks( "Ellipse"     ) }, .T., .F. )
      :addToolbarButton( "Diamond"    , "Diamond"            , "z-diamond"    , {|| ::manageMarkerVClicks( "Diamond"     ) }, .T., .F. )
      :addToolbarButton( "Triangle"   , "Triangle"           , "z-triangle"   , {|| ::manageMarkerVClicks( "Triangle"    ) }, .T., .F. )
      :addToolbarButton( "LineH"      , "Horizontal Line"    , "z-lineh"      , {|| ::manageMarkerVClicks( "LineH"       ) }, .T., .F. )
      :addToolbarButton( "LineV"      , "Vertical Line"      , "z-linev"      , {|| ::manageMarkerVClicks( "LineV"       ) }, .T., .F. )
      :addToolbarButton( "LineDR"     , "Diagonal Line Right", "z-linedr"     , {|| ::manageMarkerVClicks( "LineDR"      ) }, .T., .F. )
      :addToolbarButton( "LineDL"     , "Diagonal Line Left" , "z-linedl"     , {|| ::manageMarkerVClicks( "LineDL"      ) }, .T., .F. )
#if 0
      :addToolbarButton( "Arc"        , "Arc"                , "rp_arc"       , {|| ::manageMarkerVClicks( "Arc"         ) }, .T., .F. )
      :addToolbarButton( "Chord"      , "Chord"              , "rp_chord"     , {|| ::manageMarkerVClicks( "Chord"       ) }, .T., .F. )
      :addToolbarButton( "Gradient"   , "Gradient"           , "prv_gradient" , {|| ::execEvent( __buttonNew_clicked__   ) }, .t., .T. )
      :addToolbarButton( "Image"      , "Image"              , "prv_image"    , {|| ::execEvent( __buttonNew_clicked__   ) }, .t., .T. )
#endif
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
      :addToolbarButton( "Save"       , "Save"           , "save-5"           , {|| ::saveVisual()                                } )
      :addToolbarButton( "Print"      , "Print"          , "preview-1"        , {|| ::oHbQtPreview:refreshPreview(), ::oUI:stackBase:setCurrentIndex( 2 ) } )
      :addToolbarButton( "Rotate"     , "Rotate"         , "rotate-1"         , {|| ::oGraphicsView:rotate( 90 ) }, .F., .F.      )
      :addToolbarButton( "ZoomIn"     , "Zoom In"        , "prv_zoom-in-1"    , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_IN        )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomOut"    , "Zoom Out"       , "prv_zoom-out-1"   , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_OUT       )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomWYS"    , "Zoom WYSIWYG"   , "prv_zoom-1"       , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG   )    } )
      :addToolbarButton( "ZoomOrg"    , "Zoom Original"  , "prv_zoom-original", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL  )    } )
      :addToolbarButton( "Grid"       , "Show Grid"      , "grid-4"           , {|| ::toggleGrid() } )
      :addSeparator( "Separator_1" )
      :addToolbarButton( "Edit"       , "Edit"           , "edit-object"      , {|lChecked| ::manageEditing( lChecked ) }, .T. )
      :addToolbarButton( "RotateM"    , "Rotate Marker R", "rotate-3"         , {|| ::rotateMarker( ::oCurGraphicsItem, 1 ) }, .F., .F., .T. )
      :addToolbarButton( "RotateML"   , "Rotate Marker L", "rotatel-3"        , {|| ::rotateMarker( ::oCurGraphicsItem, 2 ) }, .F., .F., .T. )
      :addToolbarButton( "Lock"       , "Lock Object"    , "lock"             , {|| ::toggleLockOnObject() } )
      :addToolbarButton( "Delete"     , "Delete Object"  , "delete"           , {|| ::objectDeleted( ::oCurGraphicsItem ) } )
      :addToolbarButton( "DelState"   , "Delete State"   , "del-state-1"      , {|| ::deleteState( ::oCurGraphicsItem ) } )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:printPreview( oPrinter )
   LOCAL oDlg

   WITH OBJECT oPrinter := QPrinter()
      :setOutputFormat( QPrinter_PdfFormat )
      :setOrientation( ::oScene:orientation() )
      :setPaperSize( ::oScene:pageSize() )
   ENDWITH

   WITH OBJECT oDlg := QPrintPreviewDialog( oPrinter, ::oGraphicsView )
      :setWindowTitle( "HBReportGenerator : " + iif( !empty( ::cSaved ), ::cSaved, "Untitled" ) )
      :move( 20, 20 )
      :resize( 400, 600 )
      :connect( "paintRequested(QPrinter*)", {|p| ::printVisual( p ) } )
      :exec()
   ENDWITH
   oDlg:disconnect( "paintRequested(QPrinter*)" )

   RETURN NIL


METHOD HbQtVisualizer:printVisual( oPrinter )
   LOCAL oPageLayout, oPainter, oRectF, oRPage, oRectS, nMarginW, nMarginH, a_

   WITH OBJECT oPageLayout := QPageLayout( QPageSize( QPageSize_Letter ), ::oScene:orientation(), QMarginsF( 10,10,10,10 ), QPageLayout_Millimeter )
      :SetMode( QPageLayout_StandardMode )
   ENDWITH
   WITH OBJECT oPrinter
      :setOutputFormat( QPrinter_PdfFormat )
      :setPageLayout( oPageLayout )
   ENDWITH
   oPainter := QPainter()
   IF oPainter:begin( oPrinter )
      oRectS := ::oScene:sceneRect()
      oRectF := oPrinter:paperRect( QPrinter_Millimeter )
      oRPage := oPrinter:pageRect( QPrinter_Millimeter )

      nMarginW := ( ( oRectF:width()  - oRPage:width()  ) / UNIT )
      nMarginH := ( ( oRectF:height() - oRPage:height() ) / UNIT )
      IF HB_ISOBJECT( ::oHbQtVisualBackground )
         WITH OBJECT ::oHbQtVisualBackground
            :setPixmap( ::oPixmapBackground:scaled( oRectS:width(), oRectS:height(), Qt_KeepAspectRatio ) )
            :setGeometry( 0, 0, oRectS:width(), oRectS:height() )
            :drawOnPrinter( oPainter )
         ENDWITH
      ENDIF
      FOR EACH a_ IN ::aObjects
         IF hb_hHasKey( ::hItems, a_[ 3 ] )
            ::hItems[ a_[ 3 ] ]:drawOnPrinter( oPainter )
         ENDIF
      NEXT
      oPainter:end()
   ENDIF
   HB_SYMBOL_UNUSED( nMarginW + nMarginH )
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
         SWITCH cProperty
         CASE "x"
            oRect := ::oCurGraphicsItem:geometry()
            nW := oRect:width()
            oRect:setX( xValue )
            oRect:setWidth( nW )
            ::oCurGraphicsItem:setGeometry( oRect )
            EXIT
         CASE "y"
            oRect := ::oCurGraphicsItem:geometry()
            nH := oRect:height()
            oRect:setY( xValue )
            oRect:setHeight( nH )
            ::oCurGraphicsItem:setGeometry( oRect )
            EXIT
         CASE "width"
            oRect := ::oCurGraphicsItem:geometry()
            oRect:setWidth( xValue )
            ::oCurGraphicsItem:setGeometry( oRect )
            EXIT
         CASE "height"
            oRect := ::oCurGraphicsItem:geometry()
            oRect:setHeight( xValue )
            ::oCurGraphicsItem:setGeometry( oRect )
            EXIT
         CASE "objectName"
            EXIT
         CASE "penStyle"
         CASE "penWidth"
         CASE "penColor"
         CASE "capStyle"
         CASE "joinStyle"
         CASE "miterLimit"
            ::oCurGraphicsItem:setPenProperties( cProperty, xValue )
            EXIT
         CASE "brushStyle"
         CASE "brushColor"
         CASE "brushTexture"
            ::oCurGraphicsItem:setBrushProperties( cProperty, xValue )
            EXIT
         CASE "bBrushStyle"
         CASE "bBrushColor"
         CASE "bBrushTexture"
            ::oCurGraphicsItem:setBBrushProperties( cProperty, xValue )
            EXIT
         CASE "opacity"
            ::oCurGraphicsItem:nOpacity := xValue
            ::oCurGraphicsItem:update()
            EXIT
         CASE "backgroundMode"
            ::oCurGraphicsItem:cBackgroundMode := xValue
            ::oCurGraphicsItem:update()
            EXIT
         CASE "fontFamily"
         CASE "fontStyle"
         CASE "fontSize"
            ::oCurGraphicsItem:setFontProperties( cProperty, xValue )
            EXIT
         CASE "text"
            ::oCurGraphicsItem:setText( xValue )
            EXIT
         ENDSWITCH
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
      WITH OBJECT ::oSheetGraphicObjects := :addPropertySheet( "GraphicObjects" )
         :addProperty( "objectName"     , "objectName"     , ""               , __HBQT_PRP_EDIT__    , ""               , NIL )

         :addProperty( "geometry"       , "Geometry"       , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "x"              , "x"              , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "y"              , "y"              , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "width"          , "width"          , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )
         :addProperty( "height"         , "height"         , "Geometry"       , __HBQT_PRP_EDIT__    , 0.0              , NIL )

         :addProperty( "pen"            , "Pen"            , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "penStyle"       , "style"          , "Pen"            , __HBQT_PRP_COMBO__   , "SolidLine"          , aPenStyle )
         :addProperty( "penWidth"       , "width"          , "Pen"            , __HBQT_PRP_EDIT__    , 1                , NIL )
         :addProperty( "penColor"       , "color"          , "Pen"            , __HBQT_PRP_COLOR__   , "#000000"        , NIL )
         :addProperty( "capStyle"       , "capStyle"       , "Pen"            , __HBQT_PRP_COMBO__   , "FlatCap"        , aCapStyle  )
         :addProperty( "joinStyle"      , "joinStyle"      , "Pen"            , __HBQT_PRP_COMBO__   , "BevelJoin"      , aJoinStyle )
         :addProperty( "miterLimit"     , "miterLimit"     , "Pen"            , __HBQT_PRP_EDIT__    , 2.00             , NIL )

         :addProperty( "brush"          , "Brush"          , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "brushStyle"     , "style"          , "Brush"          , __HBQT_PRP_COMBO__   , "NoBrush"        , aBrushStyle )
         :addProperty( "brushColor"     , "color"          , "Brush"          , __HBQT_PRP_COLOR__   , "#ffffff"        , NIL )
//       :addProperty( "brushTexture"   , "texture"        , "Brush"          , __HBQT_PRP_TEXTURE__ , ""               , NIL )

         :addProperty( "text"           , "text"           , ""               , __HBQT_PRP_EDIT__    , ""               , NIL )
         :addProperty( "font"           , "Font"           , ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "fontFamily"     , "fontFamily"     , "Font"           , __HBQT_PRP_FONT__    , "Arial"          , NIL )
         :addProperty( "fontStyle"      , "fontStyle"      , "Font"           , __HBQT_PRP_COMBO__   , "Normal"         , { "Normal", "Italic", "Bold", "Bold Italic" } )
         :addProperty( "fontSize"       , "fontSize[MM]"   , "Font"           , __HBQT_PRP_COMBO__   , "3.5"            , { "2.5", "3.0", "3.5", "4.0", "4.5", "5.0", "5.5", "6.0", "6.5", "7.0", "7.5", "8.0", "8.5", "9.0", "9.5", "10.0" } )

         :addProperty( "backgroundMode" , "backgroundMode" , ""               , __HBQT_PRP_COMBO__   , "TransparentMode", { "TransparentMode", "OpaqueMode" } )
         :addProperty( "opacity"        , "opacity"        , ""               , __HBQT_PRP_EDIT__    , 100              , NIL )

         :addProperty( "backgroundBrush", "BackgroundBrush", ""               , __HBQT_PRP_JUST__    , ""               , NIL )
         :addProperty( "bBrushStyle"    , "style"          , "BackgroundBrush", __HBQT_PRP_COMBO__   , "NoBrush"        , aBrushStyle )
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
   ::oScene:invalidate( oOldRect )
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
   ::oScene:invalidate( oOldRect )
   RETURN Self


METHOD HbQtVisualizer:zoom( nMode )
   LOCAL nScaleFactor := 1.10

   SWITCH nMode
   CASE HBQT_GRAPHICSVIEW_ZOOM_IN
      ::oGraphicsView:scale( nScaleFactor, nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_OUT
      ::oGraphicsView:scale( 1 / nScaleFactor, 1 / nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG
      ::oGraphicsView:fitInView( ::oScene:sceneRect(), Qt_KeepAspectRatio )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      EXIT
   ENDSWITCH
   RETURN sELF


METHOD HbQtVisualizer:contextMenuScene( nX, nY )
   LOCAL oMenu, oAct, aAct := {}

   oMenu := QMenu( ::oGraphicsView )
   aadd( aAct, oMenu:addAction( "Refresh"  ) )
   aadd( aAct, oMenu:addAction( "Zoom+" ) )

   IF ! empty( oAct := oMenu:exec( QPoint( nX, nY ) ) )
      SWITCH oAct:text()
      CASE "Refresh"
         EXIT
      CASE "Zoom+"
         EXIT
      ENDSWITCH
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:showStatus( nPanel, cMsg )
   LOCAL cDisp

   DEFAULT cMsg TO ""

   SWITCH nPanel
   CASE STATUS_PANEL_READY   ; cDisp := "<font color = black >Item: "   + cMsg + "</font>" ; EXIT
   CASE STATUS_PANEL_STATES  ; cDisp := "<font color = red   >State: "  + cMsg + "</font>" ; EXIT
   CASE STATUS_PANEL_MARKERS ; cDisp := "<font color = green >Marker: " + cMsg + "</font>" ; EXIT
   CASE STATUS_PANEL_VISUALS ; cDisp := "<font color = blue  >Visual: " + cMsg + "</font>" ; EXIT
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
   ::showStatus( STATUS_PANEL_STATES  )
   ::showStatus( STATUS_PANEL_MARKERS )
   ::showStatus( STATUS_PANEL_VISUALS )
   RETURN Self


METHOD HbQtVisualizer:toString()
   RETURN ::buildVisualStream()


METHOD HbQtVisualizer:buildVisualStream()
   LOCAL txt_:= {}, n, a_, s, oWidget, oPos, oTran

   aadd( txt_, "[GENERAL]" )
   aadd( txt_, "" )
   aadd( txt_, "Symposis"     + "=" + "HbQtVisualizer"     )
   aadd( txt_, "Version"      + "=" + hb_ntos( ::version ) )
   aadd( txt_, "Title"        + "=" + ::title              )
   aadd( txt_, "Author"       + "=" + ::author             )
   aadd( txt_, "DateCreated"  + "=" + dtos( ::created )    )
   aadd( txt_, "DateModified" + "=" + dtos( ::modified )   )
   aadd( txt_, "Properties"   + "=" + ""                   )
   aadd( txt_, "" )
   aadd( txt_, "[SOURCES]" )
   aadd( txt_, "" )
   FOR EACH a_ IN ::aSources
      n := a_:__enumIndex()
      aadd( txt_, INI_KEY( "source", n ) + a_[ 1 ] + "," + rmgr_a2arrayStr( a_[ 2 ] ) )
   NEXT
   aadd( txt_, "" )
   aadd( txt_, "[PAGES]" )
   aadd( txt_, "" )
   FOR EACH a_ IN ::aPages
      n := a_:__enumIndex()
      aadd( txt_, INI_KEY( "page", n ) + rmgr_a2arrayStr( a_ ) )
   NEXT
   aadd( txt_, "" )
   aadd( txt_, "[OBJECTS]" )
   aadd( txt_, "" )
   FOR EACH a_ IN ::aObjects
      n := a_:__enumIndex()
      IF hb_hHasKey( ::hItems, a_[ 3 ] )
         oWidget := ::hItems[ a_[ 3 ] ]:oWidget
         oPos    := oWidget:scenePos()
         oTran   := oWidget:transform()

         a_[ 5 ] := { { 0, 0, oWidget:width(), oWidget:height() }, ;
                      { oPos:x(), oPos:y() }, ;
                      { oTran:m11(), oTran:m12(), oTran:m13(), oTran:m21(), oTran:m22(), oTran:m23(), oTran:m31(), oTran:m32(), oTran:m33() }, ;
                    }

         aadd( txt_, INI_KEY( "object", n ) + rmgr_a2arrayStr( a_ ) )
      ENDIF
   NEXT
   aadd( txt_, "" )

   s := ""
   aeval( txt_, {|e| s += e + chr( 13 ) + chr( 10 ) } )
   RETURN s


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
      CASE "[SOURCES]" ; nPart := "HQR_SOURCES" ; EXIT
      CASE "[PAGES]"   ; nPart := "HQR_PAGES"   ; EXIT
      CASE "[OBJECTS]" ; nPart := "HQR_OBJECTS" ; EXIT
      OTHERWISE
         DO CASE
         CASE nPart == "HQR_GENERAL"
         CASE nPart == "HQR_SOURCES"
            IF rmgr_keyValuePair( s, @cKey, @cVal, "=" )
               IF rmgr_keyValuePair( cVal, @cKey, @cVal, "," )
                  aadd( ::aRptSources, { "Source", rmgr_evalAsArray( cVal ) } )
               ENDIF
            ENDIF
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
   LOCAL cImage

   DO CASE
   CASE cType == "Image"     ;   cImage := "f-image"
   CASE cType == "Barcode"   ;   cImage := "f_barcode"
   CASE cType == "Chart"     ;   cImage := "f_chart"
   CASE cType == "Gradient"  ;   cImage := "f_gradient"
   CASE cType == "Text"      ;   cImage := "text"
   CASE cType == "Field"     ;   cImage := "text"
   CASE cType == "Rectangle" ;   cImage := "rp_rectangle"
   CASE cType == "RoundedRect";  cImage := "rp_roundrectangle"
   CASE cType == "Ellipse"   ;   cImage := "rp_ellipse"
   CASE cType == "LineH"     ;   cImage := "rp_linehorz"
   CASE cType == "LineV"     ;   cImage := "rp_linevert"
   CASE cType == "LineDR"    ;   cImage := "rp_linediagright"
   CASE cType == "LineDL"    ;   cImage := "rp_linediagleft"
   CASE cType == "Arc"       ;   cImage := "rp_arc"
   CASE cType == "Chord"     ;   cImage := "rp_chord"
   CASE cType == "Diamond"   ;   cImage := "rp_diamond"
   CASE cType == "Triangle"  ;   cImage := "rp_triangle"
   ENDCASE
   RETURN __hbqtImage( cImage )


METHOD HbQtVisualizer:getNextID( cType )
   IF ! hb_hHasKey( hIDs, cType )
      hIDs[ cType ] := 0
   ENDIF
   RETURN ++hIDs[ cType ]


METHOD HbQtVisualizer:buildStyleSheet()
   LOCAL aCSS := {}
   LOCAL cCSS := ""
   //LOCAL cColorTreeBranch := "rgba(  255, 255, 220, 255 );"

   AAdd( aCSS, 'QLabel#labelTopLeft{' )
   AAdd( aCSS, '    min-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-height: '                + __hbqtCssPX( 50 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QLabel#labelTopRight{' )
   AAdd( aCSS, '    min-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-width: '                 + __hbqtCssPX( 28 ) )
   AAdd( aCSS, '    max-height: '                + __hbqtCssPX( 50 ) )
   AAdd( aCSS, '}' )

   AAdd( aCSS, 'QFrame#frameTop {' )
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
   AAdd( aCSS, '    min-height: '                + __hbqtCssPX( 24 ) )
   AAdd( aCSS, '    max-height: '                + __hbqtCssPX( 24 ) )
   AAdd( aCSS, '    font-size: '                 + __hbqtCssPX( 20 ) )
   AAdd( aCSS, '}' )

   AEval( aCSS, {|e| cCSS += e + Chr( 13 )+Chr( 10 ) } )

   RETURN cCSS


//--------------------------------------------------------------------//
//                       Manage Opening Objects
//--------------------------------------------------------------------//

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


METHOD HbQtVisualizer:visualsVerListBlock( bBlock )
   LOCAL bOldBlock := ::bVisualsVerListBlock
   IF HB_ISBLOCK( bBlock )
      ::bVisualsVerListBlock := bBlock
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


METHOD HbQtVisualizer:show()
   LOCAL hList, hMarker, oFirst

   ::setSplitterSizes( 100, 100 )

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
            ::oUI:toolBoxLeft:setItemText( 0, hList[ "Label" ] )
            ::hVisualsList := hb_HClone( hList[ "List" ] )

            ::populateVisualsList( ::hVisualsList )

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

            // Fire first visual in the list - replace it by looking at what it was at last session
            //
            oFirst := hb_HValueAt( ::hVisualsTree, 1 )
            oFirst:setSelected( .T. )
            ::loadVisual( oFirst:whatsThis( 0 ) )
            IF oFirst:whatsThis( 0 ) == "UNTITLED"
               ::toggleGrid()
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:populateVisualsList( hVisualsList )
   LOCAL cID, oItem, oIcon, hVisual

   IF ! Empty( hVisualsList )
      FOR EACH hVisual IN hVisualsList
         IF hb_HHasKey( hVisual, "RefID" )
            cID   := hVisual[ "RefID" ]
            oIcon := __hbqtIconFromBuffer( hb_base64Decode( hVisual[ "Icon" ] ) )
            WITH OBJECT oItem := QTreeWidgetItem()
               :setText( 0, hVisual[ "Label" ] )
               :setIcon( 0, oIcon )
               :setTooltip( 0, hVisual[ "Purpose" ] )
               :setWhatsThis( 0, cID )
            ENDWITH
            ::oTreeVisuals:addTopLevelItem( oItem )
            ::hVisualsTree[ cID ] := oItem
            oItem:setExpanded( .T.  )
         ENDIF
      NEXT
      ::oTreeVisuals:connect( "itemClicked(QTreeWidgetItem*,int)", {|oItem| ::loadVisual( oItem:whatsThis( 0 ) ) } )
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:loadVisual( cRefID )
   LOCAL hVisual, hMarker, cMarkerID

   IF ! Empty( ::cCurrentVisual )
      ::saveVisual( ::cCurrentVisual )
   ENDIF

   ::oCurGraphicsItem := NIL

   ::showStatus( STATUS_PANEL_VISUALS )
   IF ! Empty( cRefID )
      ::cCurrentVisual := cRefID
      IF HB_ISBLOCK( ::visualsLoadBlock() )
         hVisual := Eval( ::visualsLoadBlock(), cRefID, ::hVisualsList[ cRefID ][ "Version" ] )
         IF HB_ISHASH( hVisual ) .AND. ! Empty( hVisual )
            ::hVisualsList[ ::cCurrentVisual ][ "Visual" ] := hVisual

            ::oPixmapBackground := NIL
            ::setBackgroundImage( __hbqtLoadPixmapFromBuffer( hb_base64Decode( hVisual[ "Image" ] ) ) )

            ::hMarkers[ ::cCurrentVisual ] := __hbqtStandardHash()
            IF hb_HHasKey( ::hVisualsList[ ::cCurrentVisual ], "Markers" )
               FOR EACH hMarker IN ::hVisualsList[ ::cCurrentVisual ][ "Markers" ]
                  cMarkerID := hMarker:__enumKey()
                  IF hb_HHasKey( ::hMarkers, "m_markers" ) .AND. hb_HHasKey( ::hMarkers[ "m_markers" ], cMarkerID )
                     ::hMarkers[ ::cCurrentVisual ][ cMarkerID ] := ::hMarkers[ "m_markers" ][ cMarkerID ]
                     IF hb_HHasKey( hMarker, "Data" )
                        ::hMarkers[ ::cCurrentVisual ][ cMarkerID ][ "Data" ] := hMarker[ "Data" ]
                     ENDIF
                  ELSE
                     ::hMarkers[ ::cCurrentVisual ][ cMarkerID ] := hMarker
                     IF hb_HHasKey( hMarker, "Icon" )
                        hMarker[ "Pixmap" ] := QPixmap( hb_base64Decode( hMarker[ "Icon" ] ) )
                     ENDIF
                  ENDIF
               NEXT
            ENDIF
         ENDIF
      ENDIF
      ::cCurrentVisualTitle := ::hVisualsList[ ::cCurrentVisual ][ "Label" ]
      ::buildMarkersTree()
      ::populateVisual()
      ::showStatus( STATUS_PANEL_VISUALS, ::cCurrentVisualTitle )
   ENDIF
   ::oUI:toolBoxLeft:setCurrentIndex( 1 )
   RETURN Self


METHOD HbQtVisualizer:saveVisual( cVisualID )
   LOCAL hVisual

   IF ! Empty( cVisualID ) .AND. HB_ISBLOCK( ::visualsSaveBlock() )
      IF hb_HHasKey( ::hVisualsList, cVisualID )
         IF Alert( "Save [" + ::hVisualsList[ cVisualID ][ "Label" ], { "Yes", "No" } ) == 1
            IF ! Empty( hVisual := ::buildVisualStream() )
               Eval( ::visualsSaveBlock(), cVisualID, ::hVisualsList[ cVisualID ][ "Version1" ], hVisual )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:buildStates( hStates )
   LOCAL hState, oPixmap, oState

   IF ! Empty( hStates )
      WITH OBJECT ::oToolbarStates := HbQtScrollableToolbar():new()
         :setIndicatorsRGB( { 255,0,0 } )
         :setButtonHeight( 50 )
         :setButtonWidth( 50 )
         :create( ::oUI:vLayToolbarStates )
      ENDWITH
      WITH OBJECT ::oToolbarStates
         FOR EACH hState IN hStates
            oState := HbQtVisualItemState():new( hState )
            hState[ "HbQtVisualItemState" ] := oState
            oPixmap := oState:pixmap( __hbqtPixelsByDPI( 50 ), __hbqtPixelsByDPI( 50 ) )
            :addToolbarButton( hState:__enumKey(), hState:__enumKey(), QIcon( oPixmap ), ;
                                                      __stateNameBlock( Self, hState:__enumKey() ), .T., .F. )
         NEXT
      ENDWITH
   ENDIF
   RETURN Self


STATIC FUNCTION __stateNameBlock( oObj, cState )
   RETURN {|| oObj:manageStateClicks( cState ) }


METHOD HbQtVisualizer:manageStateClicks( cButton )
   LOCAL oldState
   IF ::cCurrentState != cButton
      oldState := ::oToolbarStates:setState( ::cCurrentState, 2 )
      ::cCurrentState := cButton
   ELSE
      ::cCurrentState := NIL
   ENDIF
   ::showStatus( STATUS_PANEL_STATES, iif( Empty( ::cCurrentState ), "", ::cCurrentState ) )
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


