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
#define __buttonNew_clicked__                     2004
#define __buttonOpen_clicked__                    2005
#define __buttonSave_clicked__                    2006
#define __buttonClose_clicked__                   2007
#define __buttonPrint_clicked__                   2008
#define __buttonToBack_clicked__                  2009
#define __buttonToFront_clicked__                 2010
#define __buttonRotateL_clicked__                 2011
#define __buttonRotateR_clicked__                 2012
#define __buttonPortrait_clicked__                2013
#define __buttonLandscape_clicked__               2014
#define __buttonFontG_clicked__                   2015
#define __buttonFontB_clicked__                   2016
#define __buttonFontI_clicked__                   2017
#define __buttonFontU_clicked__                   2018
#define __buttonFontS_clicked__                   2019
#define __buttonJustL_clicked__                   2020
#define __buttonJustC_clicked__                   2021
#define __buttonJustR_clicked__                   2022
#define __buttonJustJ_clicked__                   2023
#define __buttonJustT_clicked__                   2024
#define __buttonJustM_clicked__                   2025
#define __buttonJustB_clicked__                   2026
#define __buttonBoxT_clicked__                    2027
#define __buttonBoxL_clicked__                    2028
#define __buttonBoxB_clicked__                    2029
#define __buttonBoxR_clicked__                    2030
#define __buttonBoxA_clicked__                    2031
#define __buttonBoxP_clicked__                    2032
#define __buttonBoxS_clicked__                    2033
#define __buttonZoom_clicked__                    2034
#define __buttonGrid_clicked__                    2035
#define __buttonNew0_clicked__                    2036
#define __buttonShapes_clicked__                  2037
#define __QEvent_MousePressMenu__                 2038
#define __QEvent_MouseMoveMenu__                  2039
#define __QEvent_MouseReleaseMenu__               2040


#define TAB_MAIN_VISUALS                          0
#define TAB_MAIN_WORKSPACE                        1
#define TAB_MAIN_PRINTPREVIEW                     2
#define TAB_MAIN_COLLABORATION                    3

STATIC hIDs := {=>}


CLASS HbQtVisualizer

   DATA   oUI
   DATA   oTBVisualTop
   DATA   oTBVisualLft

   DATA   oWidget
   DATA   oParent
   DATA   qLayout
   DATA   oHLayToolbar
   DATA   oVLayToolbar
   DATA   oToolbar
   DATA   oToolbarObjects
   DATA   oToolbarAlign
   DATA   oStackWSpace
   DATA   qStatus
   DATA   qTabBar
   DATA   oWSpaceVisualizer
   DATA   oWSpacePreview
   DATA   qWidget3
   DATA   oHbQtPreview

   DATA   qPaper

   DATA   oSplitter
   DATA   oLayoutD
   DATA   oFrameL
   DATA   qScroll
   DATA   oFrameR

   DATA   qLayL
   DATA   qLayR
   DATA   qSplL
   DATA   qSplR

   DATA   oTabMain
   DATA   oStackMain
   DATA   oPageOptions
   DATA   oPageWorks
   DATA   oPageCollaborate

   DATA   qTabL0
   DATA   qPageL01
   DATA   qPageL02
   DATA   qPageL01Lay
   DATA   oTreeObjects

   DATA   qTabL1
   DATA   qPageL11
   DATA   qPageL12
   DATA   qPageL11Lay
   DATA   oPropWidget
   DATA   oPropManager

   DATA   qEditDesc

   DATA   qTabR1
   DATA   qPageR11
   DATA   qPageR11Lay
   DATA   oTreeData
   DATA   qPageR12
   DATA   qPageR13

   DATA   qDesign
   DATA   qHRuler
   DATA   qVRuler
   DATA   qPort
   DATA   oGraphicsView
   DATA   oScene

   DATA   aStatusPnls                             INIT {}
   DATA   aItems                                  INIT {}
   DATA   hItems                                  INIT {=>}
   DATA   hObjTree                                INIT {=>}
   DATA   oCurGraphicsItem

   DATA   aPages                                  INIT {}
   DATA   aSources                                INIT {}
   DATA   aObjects                                INIT {}
   DATA   aRptPages                               INIT {}
   DATA   aRptSources                             INIT {}
   DATA   aRptObjects                             INIT {}

   DATA   lNew                                    INIT .t.
   DATA   cSaved                                  INIT ""

   DATA   nScreenDpiX                             INIT 96
   DATA   nScreenDpiY                             INIT 96

   /* Report's Properties */
   DATA   symposis                                INIT "HBReports Designer"
   DATA   version                                 INIT 0.1
   DATA   title                                   INIT "Report"
   DATA   author                                  INIT "HbIDE"
   DATA   created                                 INIT date()
   DATA   modified                                INIT date()

   DATA   xData
   DATA   qPos                                    INIT QPoint( -1,-1 )
   DATA   qAct
   DATA   qShapesMenu
   DATA   aShapesAct                              INIT array( NUM_SHAPES )
   DATA   lShowGrid                               INIT .F.

   DATA   oHbQtVisualBackground
   DATA   oPixmapBackground
   DATA   lDoubleClickZoom                        INIT .F.

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD destroy()
   METHOD manageResize()

   METHOD execEvent( nEvent, p, p1, p2 )

   METHOD buildToolbar( oLayout )
   METHOD buildToolbarLeft( oLayout )
   METHOD buildStatusBar()
   METHOD buildDesignReport()
   METHOD buildPropertySheets()
   METHOD addField( cAlias, cField, qPos, qGeo )
   METHOD addObject( cType, qPos, qGeo )
   METHOD loadReport( xData )
   METHOD saveReport( lSaveAs )
   METHOD prepareReport()
   METHOD getNextID( cType )
   METHOD getImageOfType( cType )
   METHOD updateObjectsTree( cType, cParent, cName, cSubType )
   METHOD contextMenuItem( p1, p2 )
   METHOD contextMenuScene( oPoint )
   METHOD addSource( cAlias, aStruct )
   METHOD clear()
   METHOD buildReportStream()
   METHOD toString()
   METHOD openReport()
   METHOD parseBuffer( cBuffer )
   METHOD presentBlankPage()
   METHOD printReport( oPrinter )
   METHOD printPreview( oPrinter )
   METHOD zoom( nMode )

   METHOD itemActionsBlock( oHbQtVisualItem, nAction )
   METHOD objectDeleted( oHbQtVisualItem )
   METHOD objectSelected( oHbQtVisualItem )
   METHOD execMenuShapes()

   METHOD setBackgroundImage( oPixmap )           INLINE ::oPixmapBackground := oPixmap

   METHOD splitter()                              INLINE ::oSplitter
   METHOD toolbarTop()                            INLINE ::oToolbar
   METHOD toolbarObjects()                        INLINE ::oToolbarObjects

   ENDCLASS


METHOD HbQtVisualizer:destroy()
   LOCAL oHbQtVisualItem

   FOR EACH oHbQtVisualItem IN ::hItems
      oHbQtVisualItem:hbClearBlock()
   NEXT
   ::hItems := {=>}

   ::oScene:hbClearBlock()
   ::oScene := NIL

   ::oWidget := NIL
   ::oUI:destroy()
   RETURN NIL


METHOD HbQtVisualizer:init( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent
   RETURN Self


METHOD HbQtVisualizer:create( oParent )
   LOCAL oLayout, oVertLayout

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

#if 0
   oPixmap:= QPixmap()
   cBuffer := hb_MemoRead( "C:\downloads\LA.png" )
   oPixmap:loadFromData( cBuffer, Len( cBuffer ), "PNG" )
   ::setBackgroundImage( oPixmap )
#else          // will be provided by the application via SetBackgroundImage( oPixmap )
   ::setBackgroundImage( QPixmap( ":/icons/la.png" ) )
#endif

   ::oUI := hbqtui_visualizer( oParent )
   ::oWidget := ::oUI:oWidget

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

   WITH OBJECT oVertLayout := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   ::oUI:pageVisualizations:setLayout( oVertLayout )

   ::buildToolbar( ::oUI:hLayToolbarVisualizer )
   ::buildToolbarLeft( ::oUI:vLayToolbarVisualizer )
   WITH OBJECT ::oHbQtPreview := HbQtPrintPreview():new():create( ::oUI:vLayPreviewer )
      :previewBlock := {|oPrinter| ::printReport( oPrinter ) }
      :exitBlock    := {|| ::oUI:tabBaseMain:setCurrentIndex( TAB_MAIN_WORKSPACE ) }
   ENDWITH

   ::buildDesignReport()
   ::buildPropertySheets()

   ::loadReport()
   ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )
   ::oScene:setOrientation( QPrinter_Landscape )

   ::oUI:tabBaseMain:tabBar():setExpanding( .T. )
   ::oUI:tabBaseMain:connect( "currentChanged(int)", {|nIndex| iif( nIndex == 2, ::oHbQtPreview:refreshPreview(), NIL ) } )
#if 0
   ::buildStatusBar()
   ::qLayout:addWidget( ::qStatus     , 4, 0, 1, 2 )
#endif

   ::oWidget:connect( QEvent_Resize, {|| ::manageResize() } )
   RETURN Self


METHOD HbQtVisualizer:manageResize()
   RETURN Self


METHOD HbQtVisualizer:buildDesignReport()

   WITH OBJECT ::oLayoutD := ::oUI:hLayCentralVisualizer
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 1 )
   ENDWITH

   WITH OBJECT ::oSplitter := QSplitter()
      :setOrientation( Qt_Horizontal )
      //:setHandleWidth( 15 )
      :setOpaqueResize( .F. )
   ENDWITH
   ::oLayoutD:addWidget( ::oSplitter )

   WITH OBJECT ::oFrameL := QFrame()
      //:setMaximumWidth( 250 )
   ENDWITH
   ::oSplitter:addWidget( ::oFrameL )

   WITH OBJECT ::oScene := HBQGraphicsScene()
      :hbSetBlock( {|p,p1,p2| ::execEvent( __graphicsScene_block__, p, p1, p2 ) } )
      :setLeftMagnet( .t. )
      :setTopMagnet( .t. )
      :setRightMagnet( .t. )
      :setBottomMagnet( .t. )
      :setPageSize( QPrinter_Letter )
   ENDWITH
   WITH OBJECT ::oGraphicsView := QGraphicsView( ::qDesign )
      :setMouseTracking( .t. )
      :setScene( ::oScene )
      :setContentsMargins( 20,20,20,20 )
   ENDWITH
   ::oSplitter:addWidget( ::oGraphicsView )

   WITH OBJECT ::oFrameR := QFrame()
      //:setMaximumWidth( 250 )
   ENDWITH
   ::oSplitter:addWidget( ::oFrameR )

   ::qLayL := QVBoxLayout()
   ::qLayL:setContentsMargins( 0,0,0,0 )
   ::qLayL:setSpacing( 1 )
   ::oFrameL:setLayout( ::qLayL )
   ::qSplL := QSplitter()
   ::qSplL:setOrientation( Qt_Vertical )
   ::qLayL:addWidget( ::qSplL )

   ::qLayR := QVBoxLayout()
   ::qLayR:setContentsMargins( 0,0,0,0 )
   ::qLayR:setSpacing( 1 )
   ::oFrameR:setLayout( ::qLayR )
   ::qSplR := QSplitter()
   ::qSplR:setOrientation( Qt_Vertical )
   ::qLayR:addWidget( ::qSplR )

   WITH OBJECT ::qTabL0 := QTabWidget()
      :setDocumentMode( .T. )
      :setTabShape( QTabWidget_Triangular )
      :tabBar():setExpanding( .T. )
   ENDWITH
   ::qSplL:addWidget( ::qTabL0 )
   /* Left Pane Objects Page */
   ::qPageL01 := QWidget()
   ::qTabL0:addTab( ::qPageL01, "Objects" )
   ::qPageL01Lay := QVBoxLayout()
   ::qPageL01:setLayout( ::qPageL01Lay )
   ::qPageL01Lay:setContentsMargins( 0,0,0,0 )

   /* Left pane Properties Treeview */
   WITH OBJECT ::oTreeObjects := QTreeWidget()
      :setAlternatingRowColors( .T. )
      :setIndentation( 15 )
      :setFocusPolicy( Qt_NoFocus )
      :setHeaderHidden( .t. )
      :setObjectName( "ObjectsTree" )
      :setIconSize( QSize( 12,12 ) )
      :setIndentation( 12 )
      :setSelectionMode( QAbstractItemView_SingleSelection )
      :setSelectionBehavior( QAbstractItemView_SelectRows )
      :connect( "itemClicked(QTreeWidgetItem*,int)", {|p,p1| ::execEvent( __treeObjects_clicked__, p, p1 ) } )
   ENDWITH
   ::qPageL01Lay:addWidget( ::oTreeObjects )

   WITH OBJECT ::qTabL1 := QTabWidget()
      :setDocumentMode( .T. )
      :setTabShape( QTabWidget_Triangular )
      :tabBar():setExpanding( .T. )
   ENDWITH
   ::qSplL:addWidget( ::qTabL1 )
   /* Left Pane Properties Page */
   ::qPageL11 := QWidget()
   ::qTabL1:addTab( ::qPageL11, "Properties" )
   ::qPageL11Lay := QVBoxLayout()
   ::qPageL11:setLayout( ::qPageL11Lay )
   ::qPageL11Lay:setContentsMargins( 0,0,0,0 )

   /* Left pane Properties Treeview */
   WITH OBJECT ::oPropWidget := QWidget()
      :setObjectName( "Properties" )
   ENDWITH
   ::qPageL11Lay:addWidget( ::oPropWidget )
#if 0
   WITH OBJECT ::qEditDesc := QTextEdit()
      :setPlainText( "Interface implemented is just a proof of concept, no promises yet, please." )
      :setMaximumHeight( 120 )
   ENDWITH
   ::qSplL:addWidget( ::qEditDesc )
#endif
   WITH OBJECT ::qTabR1 := QTabWidget()
      :setDocumentMode( .T. )
      :setTabShape( QTabWidget_Triangular )
      :tabBar():setExpanding( .T. )
   ENDWITH
   ::qSplR:addWidget( ::qTabR1 )
   ::qPageR11 := QWidget()
   ::qTabR1:addTab( ::qPageR11, "Data" )

   WITH OBJECT ::qPageR11Lay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
   ENDWITH
   ::qPageR11:setLayout( ::qPageR11Lay )

   WITH OBJECT ::oTreeData := QTreeWidget()
      :setAlternatingRowColors( .T. )
      :setIndentation( 15 )
      :setFocusPolicy( Qt_NoFocus )
      :setHeaderHidden( .t. )
      :setObjectName( "DataTree" )
      :setDragEnabled( .t. )
   ENDWITH
   ::qPageR11Lay:addWidget( ::oTreeData )
   ::oLayoutD:setStretch( 1,1 )
   RETURN Self


METHOD HbQtVisualizer:buildStatusBar()
   LOCAL qLabel

   ::qStatus := QStatusBar()
   ::qStatus:setSizeGripEnabled( .f. )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )
   qLabel:setText( "Ready" )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 1 )
   aadd( ::aStatusPnls, qLabel )
   RETURN Self


#define __HBQT_PRP_JUST__                         1000
#define __HBQT_PRP_EDIT__                         1001
#define __HBQT_PRP_COMBO__                        1002
#define __HBQT_PRP_COLOR__                        1003
#define __HBQT_PRP_FONT__                         1004

METHOD HbQtVisualizer:buildPropertySheets()

   WITH OBJECT ::oPropManager := HbQtPropertiesManager():new():create( ::oPropWidget )
      WITH OBJECT :addPropertySheet( "GraphicObjects" )
         :addProperty( "objectName" , ""        , __HBQT_PRP_EDIT__ , "Rectangle_1", NIL, NIL )
         :addProperty( "Geometry"   , ""        , __HBQT_PRP_JUST__ , ""           , NIL, NIL )
         :addProperty( "x"          , "Geometry", __HBQT_PRP_EDIT__ , 10.0         , NIL, NIL )
         :addProperty( "y"          , "Geometry", __HBQT_PRP_EDIT__ , 10.0         , NIL, NIL )
         :addProperty( "width"      , "Geometry", __HBQT_PRP_EDIT__ , 300.0        , NIL, NIL )
         :addProperty( "height"     , "Geometry", __HBQT_PRP_EDIT__ , 300.0        , NIL, NIL )
         :addProperty( "Pen"        , ""        , __HBQT_PRP_JUST__ , ""           , NIL, NIL )
         :addProperty( "capStyle"   , "Pen"     , __HBQT_PRP_COMBO__, "FlatCap"    , {"FlatCap","RoundCap","SquareCap"}, NIL )
         :addProperty( "joinStyle"  , "Pen"     , __HBQT_PRP_COMBO__, "BevelJoin"  , {"BevelJoin","MitterJoin","RoundJoin"}, NIL )
         :addProperty( "mitterLimit", "Pen"     , __HBQT_PRP_EDIT__ , 2.00         , NIL, NIL )
         :addProperty( "style"      , "Pen"     , __HBQT_PRP_COMBO__, "SolidLine"  , {"NoPen","SolidLine","BevelJoin","DottedLine"}, NIL )
         :addProperty( "penWidth"   , "Pen"     , __HBQT_PRP_EDIT__ , 0            , NIL, NIL )
         :addProperty( "needHelp"   , ""        , __HBQT_PRP_EDIT__ , .T.          , NIL, NIL )
         :addProperty( "needDate"   , ""        , __HBQT_PRP_EDIT__ , Date()-3     , NIL, NIL )
      ENDWITH
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:execEvent( nEvent, p, p1, p2 )
   LOCAL qMime, qDrag, qByte, qPix, qRC, qIcon, cType, i
   LOCAL oPainter, oRectF

   SWITCH nEvent
   CASE __graphicsScene_block__
      DO CASE
      CASE p == 21201
         oPainter := p1
         oRectF := ::oScene:sceneRect()
         IF HB_ISOBJECT( ::oHbQtVisualBackground )
            WITH OBJECT ::oHbQtVisualBackground
               :setPixmap( ::oPixmapBackground:scaled( oRectF:width(), oRectF:height(), Qt_KeepAspectRatio ) )
               :setGeometry( oRectF:x(), oRectF:y(), oRectF:width(), oRectF:height() )
               :draw( oPainter, oRectF )
            ENDWITH
         ENDIF

      CASE p == 21001
         ::nScreenDpiX := p1
         ::nScreenDpiY := p2

      CASE p == 21107    // Left button pressed nowhere on an item
         IF ! empty( ::oCurGraphicsItem )
            ::oCurGraphicsItem := NIL
            ::oTreeObjects:setCurrentItem( QTreeWidgetItem() )
         ENDIF

      CASE p == 21131    // double-click
         IF ::lDoubleClickZoom
            FOR i := 1 TO 9
               ::oGraphicsView:scale( 0.9, 0.9 )
            NEXT
         ELSE
            FOR i := 1 TO 10
               ::oGraphicsView:scale( 1.1, 1.1 )
            NEXT
         ENDIF
         ::lDoubleClickZoom := ! ::lDoubleClickZoom
         ::oGraphicsView:centerOn( p1, p2 )

      CASE p == 21141    // right-click simulated
         ::contextMenuScene( QPoint( p1, p2 ) )

      CASE p == QEvent_GraphicsSceneContextMenu
         ::contextMenuScene( p1:screenPos() )

      CASE p == QEvent_GraphicsSceneDragEnter
         p1:acceptProposedAction()

      CASE p == QEvent_GraphicsSceneDragMove
         p1:acceptProposedAction()

      CASE p == QEvent_GraphicsSceneDragLeave
         p1:acceptProposedAction()

      CASE p == QEvent_GraphicsSceneDrop
         qMime := p1:mimeData()
         IF qMime:hasFormat( "application/x-qabstractitemmodeldatalist" )
            IF p2[ 1 ] == "DataTree"
               IF p2[ 2 ] != p2[ 3 ]
                  ::addField( p2[ 2 ], p2[ 3 ], p1:scenePos(), NIL )
               ENDIF
            ENDIF
         ELSEIF qMime:hasFormat( "application/x-toolbaricon"  )
            ::addObject( qMime:html(), p1:scenePos(), NIL )
         ELSEIF qMime:hasFormat( "application/x-menuitem" )
            cType := qMime:html()
            SWITCH cType
            CASE "Rectangle"          ;                        EXIT
            CASE "Ellipse"            ;                        EXIT
            CASE "Arc"                ;                        EXIT
            CASE "Chord"              ;                        EXIT
            CASE "Triangle"           ;                        EXIT
            CASE "Diamond"            ;                        EXIT
            CASE "Rounded Rectangle"  ; cType := "RoundRect" ; EXIT
            CASE "Horizontal Line"    ; cType := "LineH"     ; EXIT
            CASE "Vertical Line"      ; cType := "LineV"     ; EXIT
            CASE "Diagonal Line Right"; cType := "LineDR"    ; EXIT
            CASE "Diagonal Line Left" ; cType := "LineDL"    ; EXIT
            ENDSWITCH
            ::addObject( cType, p1:scenePos(), NIL )
         ENDIF
         p1:acceptProposedAction()
      ENDCASE
      EXIT

   CASE __treeObjects_clicked__
      IF hb_hHasKey( ::hItems, p:text( 0 ) )
         ::oScene:clearSelection()
         //::hItems[ qItem:text( 0 ) ]:setSelected( .t. )
         ::hItems[ p:text( 0 ) ]:oWidget:setSelected( .t. )
      ENDIF
      EXIT

   CASE __tabBar_currentChanged__
      IF !empty( ::oStackWSpace ) .AND. p < ::oStackWSpace:count()
         ::oStackWSpace:setCurrentIndex( p )
      ENDIF
      EXIT

   CASE "dataTree_dropEvent"
   CASE "dataTree_mouseReleseEvent"
   CASE "dataTree_dragMoveEvent"
   CASE "dataTree_dragEnterEvent"
      EXIT

   CASE __QEvent_MouseMoveMenu__
      IF empty( ::qPos ) .OR. empty( ::qAct )
         EXIT
      ENDIF
      qRC := QRect( ::qPos:x() - 5, ::qPos:y() - 5, 10, 10 ):normalized()
      IF qRC:contains( p:pos() )
         qIcon := QIcon( ::qAct:icon() )
         qPix  := qIcon:pixmap( 16,16 )
         qByte := QByteArray( ::qAct:text() )
         WITH OBJECT qMime := QMimeData()
            :setData( "application/x-menuitem", qByte )
            :setHtml( ::qAct:text() )
         ENDWITH
         WITH OBJECT qDrag := QDrag( ::oWidget )
            :setMimeData( qMime )
            :setPixmap( qPix )
            :setHotSpot( QPoint( 15,15 ) )
            :setDragCursor( qPix, Qt_MoveAction )
            :exec( Qt_MoveAction )
         ENDWITH
         qDrag:setParent( QWidget() )
         qDrag := NIL
         ::qPos  := NIL
         ::qAct  := NIL
      ENDIF
      EXIT
   CASE __QEvent_MouseReleaseMenu__
      EXIT
   CASE __QEvent_MousePressMenu__
      ::qPos := p:pos()
      ::qAct := ::qShapesMenu:actionAt( ::qPos )
      EXIT

   CASE __buttonShapes_clicked__
      ::execMenuShapes()
      EXIT
   CASE __buttonRotateL_clicked__
      IF !empty( ::oCurGraphicsItem )
         ::oCurGraphicsItem:rotate( -10 )
      ENDIF
      EXIT
   CASE __buttonRotateR_clicked__
      IF !empty( ::oCurGraphicsItem )
         ::oCurGraphicsItem:rotate( 10 )
      ENDIF
      EXIT
   CASE __buttonToBack_clicked__
      EXIT
   CASE __buttonToFront_clicked__
      EXIT
   CASE __buttonNew_clicked__
      EXIT
   CASE __buttonOpen_clicked__
      ::openReport()
      EXIT
   CASE __buttonClose_clicked__
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtVisualizer:itemActionsBlock( oHbQtVisualItem, nAction )
   SWITCH nAction
   CASE HBQT_GRAPHICSITEM_SELECTED
      ::objectSelected( oHbQtVisualItem )
      EXIT
   CASE HBQT_GRAPHICSITEM_DELETED
      ::objectDeleted( oHbQtVisualItem )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtVisualizer:objectDeleted( oHbQtVisualItem )
   LOCAL oParent
   LOCAL cName := oHbQtVisualItem:cName
   IF hb_hHasKey( ::hObjTree, cName )
      oParent := ::hObjTree[ cName ]:parent()
      oParent:removeChild( ::hObjTree[ cName ] )
      ::hObjTree[ cName ] := NIL
      hb_HDel( ::hObjTree, cName )
      ::oScene:removeItem( oHbQtVisualItem:oWidget )
      hb_HDel( ::hItems, cName )
      QApplication():processEvents()
   ENDIF
   ::oCurGraphicsItem := NIL
   RETURN Self


METHOD HbQtVisualizer:objectSelected( oHbQtVisualItem )
   LOCAL cName := oHbQtVisualItem:cName

   IF hb_hHasKey( ::hObjTree, cName )
      ::oCurGraphicsItem := ::hItems[ cName ]
      ::oTreeObjects:setCurrentItem( ::hObjTree[ cName ] )
   ELSE
      ::oCurGraphicsItem := NIL
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:presentBlankPage()
   aadd( ::aPages, { "Page_1" } )

   ::oScene:setPageSize( QPrinter_Letter )
   ::oScene:setOrientation( QPrinter_Portrait )

   ::updateObjectsTree( "ReportName", NIL, "Report" )
   ::updateObjectsTree( "Page", "Report", "Page_1" )

   ::addSource( "Customer", { { "Title" ,"C",35,0 }, { "Street","C",20,0 }, { "Revenue","N",12,2 } } )
   ::addSource( "Invoice" , { { "Number","C",10,0 }, { "Date"  ,"D",08,0 }, { "Amount" ,"N",12,2 } } )
   RETURN Self


METHOD HbQtVisualizer:openReport()
   LOCAL qFileDlg, qList, cFile

   qFileDlg := QFileDialog( ::oWidget )

   qFileDlg:setAcceptMode( QFileDialog_AcceptOpen )
   qFileDlg:setFileMode( QFileDialog_AnyFile )
   qFileDlg:setViewMode( QFileDialog_List )
   qFileDlg:setNameFilter( "HB Reports (*.hqr)" )

   IF qFileDlg:exec() == 1
      qList := qFileDlg:selectedFiles()
      cFile := qList:at( 0 )
      IF !empty( cFile ) .AND. lower( right( cFile, 4 ) ) == ".hqr"
         ::loadReport( cFile )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:saveReport( lSaveAs )
   LOCAL cFile, cBuffer, qFileDlg, qList, cExt
   LOCAL lSave := .t.

   DEFAULT lSaveAs TO .f.

   IF lSaveAs .OR. ::lNew .OR. empty( ::cSaved )
      qFileDlg := QFileDialog( ::oWidget )

      qFileDlg:setAcceptMode( QFileDialog_AcceptSave )
      qFileDlg:setFileMode( QFileDialog_AnyFile )
      qFileDlg:setViewMode( QFileDialog_List )
      qFileDlg:setNameFilter( "HB Reports (*.hqr)" )

      IF qFileDlg:exec() == 1
         qList := qFileDlg:selectedFiles()
         cFile := qList:at( 0 )
         hb_fNameSplit( cFile, , , @cExt )
         IF empty( cExt )
            cFile += ".hqr"
         ENDIF
         ::cSaved := cFile
      ELSE
         lSave := .f.
      ENDIF
   ENDIF

   IF lSave .AND. !empty( ::cSaved )
      cBuffer  := ::buildReportStream()
      hb_memowrit( ::cSaved, hb_strtoutf8( cBuffer ) )

      RETURN hb_fileExists( ::cSaved )
   ENDIF
   RETURN .f.


METHOD HbQtVisualizer:prepareReport()
   RETURN Self


METHOD HbQtVisualizer:toString()
   RETURN ::buildReportStream()


METHOD HbQtVisualizer:buildReportStream()
   LOCAL txt_:= {}, n, a_, s, oWidget, qPos, qTran

   aadd( txt_, "[GENERAL]" )
   aadd( txt_, "" )
   aadd( txt_, "Symposis"     + "=" + "HBReportsManager"   )
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
         qPos    := oWidget:scenePos()
         qTran   := oWidget:transform()

         a_[ 5 ] := { { 0, 0, oWidget:width(), oWidget:height() }, ;
                      { qPos:x(), qPos:y() }, ;
                      { qTran:m11(), qTran:m12(), qTran:m13(), qTran:m21(), qTran:m22(), qTran:m23(), qTran:m31(), qTran:m32(), qTran:m33() }, ;
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


METHOD HbQtVisualizer:loadReport( xData )
   LOCAL cBuffer, a_, d_, n, cName, cAlias, cField, oWidget , oRectF
   LOCAL aGeo, aPt, aTran
   LOCAL qGeo, qPt, qTran

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

   IF empty( xData )
      ::presentBlankPage()
      ::lNew := .t.
   ELSE
      ::lNew := .f.

      IF Len( xData ) <= 300 .AND. hb_fileExists( xData )
         ::cSaved := xData
         cBuffer  := hb_utf8tostr( hb_memoread( xData ) )

         IF !empty( ::oParent )
            ::oParent:setWindowTitle( "HbReportsManager : " + ::cSaved )
         ENDIF
      ELSE
         ::cSaved := ""
         cBuffer  := xData
      ENDIF

      ::parseBuffer( cBuffer )

      ::oScene:setPageSize( QPrinter_Letter )
      ::oScene:setOrientation( QPrinter_Portrait )

      ::updateObjectsTree( "ReportName", NIL, "Report" )
      ::updateObjectsTree( "Page", "Report", "Page_1" )

      FOR EACH a_ IN ::aRptSources
         ::addSource( a_[ 1 ], a_[ 2 ] )
      NEXT

      FOR EACH a_ IN ::aRptObjects
         d_:= a_[ 5 ] ; aGeo := d_[ 1 ] ; aPt := d_[ 2 ] ; aTran := d_[ 3 ]

         qGeo := QRectF( aGeo[ 1 ], aGeo[ 2 ], aGeo[ 3 ], aGeo[ 4 ] )
         qPt  := QPointF( aPt[ 1 ], aPt[ 2 ] )

         SWITCH a_[ 1 ]
         CASE "Object"
            oWidget := ::addObject( a_[ 4 ], qPt, qGeo )
            EXIT
         CASE "Field"
            cName   := a_[ 3 ] ; n := at( "...", cName ) ; cAlias := substr( cName, 1, n-1 )
            cField  := substr( cName, n + 3 ) ; n := at( "_", cField ) ; cField := substr( cField, 1, n-1 )
            oWidget := ::addField( cAlias, cField, qPt, qGeo )
            EXIT
         ENDSWITCH

         qTran   := QTransform()
         qTran   :  setMatrix( aTran[ 1 ], aTran[ 2 ], aTran[ 3 ], aTran[ 4 ], aTran[ 5 ], aTran[ 6 ], aTran[ 7 ], aTran[ 8 ], aTran[ 9 ] )
         oWidget :  setTransform( qTran )
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtVisualizer:addObject( cType, qPos, qGeo )
   LOCAL cName, qGrad, oHbQtVisualItem, aGeo, aPos

   aPos := iif( empty( qPos ), NIL, { qPos:x(), qPos:y() } )
   aGeo := iif( empty( qGeo ), NIL, { qGeo:x(), qGeo:y(), qGeo:width(), qGeo:height() } )

   cName := cType + "_" + hb_ntos( ::getNextID( cType ) )
   WITH OBJECT oHbQtVisualItem := HbQtVisualItem():new():create( cType, cName, aPos, aGeo )
      :actionsBlock := {|oHbQtVisualItem,nAction| ::itemActionsBlock( oHbQtVisualItem, nAction ) }
      SWITCH cType
      CASE "Image"
         :setPixmap( QPixmap( __hbqtImage( "harbour" ) ) )
         :setBorderWidth( 2 )
         EXIT
      CASE "Chart"
         EXIT
      CASE "Gradient"
         qGrad := QLinearGradient()
         qGrad:setColorAt( 0, QColor( 195,225,255 ) )
         qGrad:setColorAt( 1, QColor( Qt_darkBlue ):darker( 150 ) )
         qGrad:setCoordinateMode( QGradient_StretchToDeviceMode )
         :setBrush( QBrush( qGrad ) )
         :setPen( QPen( Qt_NoPen ) )
         EXIT
      CASE "Barcode"
         :setText( "Harbour" )
         :setBarcodeType( HQR_BARCODE_3OF9 )
         EXIT
      CASE "Text"
         :setText( "Harbour" )
         EXIT
      ENDSWITCH
      ::oScene:addItem( :oWidget )
   ENDWITH

   ::hItems[ cName ] := oHbQtVisualItem
   ::updateObjectsTree( "Object", "Page_1", cName, cType )
   aadd( ::aObjects, { "Object", "Page_1", cName, cType, {} } )
   //
   RETURN oHbQtVisualItem:oWidget


METHOD HbQtVisualizer:addField( cAlias, cField, qPos, qGeo )
   LOCAL cName, oHbQtVisualItem, aGeo, aPos

   aPos := iif( empty( qPos ), NIL, { qPos:x(), qPos:y() } )
   aGeo := iif( empty( qGeo ), NIL, { qGeo:x(), qGeo:y(), qGeo:width(), qGeo:height() } )

   cName := cAlias + "..." + cField
   cName := cName + "_" + hb_ntos( ::getNextID( cName ) )

   WITH OBJECT oHbQtVisualItem := HbQtVisualItem():new():create( "Field", cName, aPos, aGeo )
      :setText( cName )
      :actionsBlock := {|oHbQtVisualItem, nAction| ::itemActionsBlock( oHbQtVisualItem, nAction ) }
      :oScene:addItem( :oWidget )
   ENDWITH
   ::hItems[ cName ] := oHbQtVisualItem
   ::updateObjectsTree( "Field", "Page_1", cName, "Field" )
   aadd( ::aObjects, { "Field", "Page_1", cName, "Field", {} } )
   //
   RETURN oHbQtVisualItem:oWidget


METHOD HbQtVisualizer:addSource( cAlias, aStruct )
   LOCAL qItem, qItmC, b_

   qItem := QTreeWidgetItem()
   qItem:setText( 0, cAlias )
   ::oTreeData:addTopLevelItem( qItem )

   FOR EACH b_ IN aStruct
      qItmC := QTreeWidgetItem()
      qItmC:setText( 0, b_[ 1 ] )
      qItem:addChild( qItmC )
      qItem:setExpanded( .t. )
   NEXT

   aadd( ::aSources, { cAlias, aStruct } )
   RETURN Self


METHOD HbQtVisualizer:clear()
   LOCAL oHrqObject, qObj

   FOR EACH oHrqObject IN ::hItems
      qObj := oHrqObject:oWidget
      ::oScene:removeItem( qObj )
      qObj := NIL
   NEXT
   ::hItems      := {=>}

   ::oTreeObjects:clear()
   ::oTreeData:clear()

   ::aObjects    := {}
   ::aPages      := {}
   ::aSources    := {}

   ::aRptObjects := {}
   ::aRptPages   := {}
   ::aRptSources := {}

   hIDs          := {=>}

   ::oScene:invalidate()
   RETURN Self


METHOD HbQtVisualizer:updateObjectsTree( cType, cParent, cName, cSubType )
   LOCAL qParent, qItem

   DO CASE
   CASE cType == "ReportName"
      qItem := QTreeWidgetItem() ; qItem:setText( 0, cName )
      qItem:setIcon( 0, QIcon( __hbqtImage( "r-report" ) ) )
      ::oTreeObjects:addTopLevelItem( qItem )
      ::hObjTree[ cName ] := qItem
      qItem:setExpanded( .t. )

   CASE cType == "Page" .OR. cType == "Object" .OR. cType == "Field"
      IF hb_hHasKey( ::hObjTree, cParent )
         qParent := ::hObjTree[ cParent ]
      ENDIF
      IF !empty( qParent )
         IF hb_hHasKey( ::hObjTree, cName )
            //
         ENDIF
         qItem := QTreeWidgetItem() ; qItem:setText( 0, cName )
         qParent:addChild( qItem )
         ::hObjTree[ cName ] := qItem

         IF cType == "Page"
            qItem:setIcon( 0, QIcon( __hbqtImage( "r-page" ) ) )
         ELSEIF cType == "Object"
            qItem:setIcon( 0, QIcon( ::getImageOfType( cSubType ) ) )
         ELSEIF cType == "Field"
            qItem:setIcon( 0, QIcon( ::getImageOfType( "Field" ) ) )
         ENDIF

         qParent:setExpanded( .t. )
      ENDIF
   ENDCASE
   RETURN Self


METHOD HbQtVisualizer:zoom( nMode )
   SWITCH nMode
   CASE HBQT_GRAPHICSVIEW_ZOOM_IN
      ::oGraphicsView:scale( 1.1, 1.1 )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_OUT
      ::oGraphicsView:scale( 0.9, 0.9 )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:scale( ::nScreenDpiX / 25.4 / 10.0, ::nScreenDpiY / 25.4 / 10.0 )
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      EXIT
   ENDSWITCH
   RETURN sELF


METHOD HbQtVisualizer:contextMenuScene( oPoint )
   LOCAL qMenu, qAct, aAct := {}

   qMenu := QMenu( ::oGraphicsView )
   aadd( aAct, qMenu:addAction( "Refresh"  ) )
   aadd( aAct, qMenu:addAction( "Zoom+" ) )

   IF ! empty( qAct := qMenu:exec( oPoint ) )
      SWITCH qAct:text()
      CASE "Refresh"
         EXIT
      CASE "Zoom+"
         EXIT
      ENDSWITCH
   ENDIF
   RETURN Self


METHOD HbQtVisualizer:contextMenuItem( p1, p2 )
   LOCAL qMenu, qAct, aAct := {}

   HB_SYMBOL_UNUSED( p2 )

   qMenu := QMenu()
   aadd( aAct, qMenu:addAction( "Cut"  ) )
   aadd( aAct, qMenu:addAction( "Copy" ) )

   IF ! empty( qAct := qMenu:exec( p1:screenPos() ) )
      SWITCH qAct:text()
      CASE "Cut"
         EXIT
      CASE "Copy"
         EXIT
      ENDSWITCH
   ENDIF
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
   CASE cType == "RoundRect" ;   cImage := "rp_roundrectangle"
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


METHOD HbQtVisualizer:buildToolbarLeft( oLayout )

   WITH OBJECT ::oToolbarObjects := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( { 255,0,0 } )
      :setButtonHeight( 50 )
      :setButtonWidth( 50 )
      :create( oLayout )
   ENDWITH

   WITH OBJECT ::oToolbarObjects
      :addToolbarButton( "Shapes"  , "Shapes"  , "prv_objects" , {|| ::execEvent( __buttonShapes_clicked__ ) }, .F., .F. )
      :addToolbarButton( "Text"    , "Text"    , "prv_text"    , {|| ::execEvent( __buttonNew_clicked__    ) }, .t., .T. )
      // these should be user defined ? how ??
      :addToolbarButton( "Image"   , "Image"   , "prv_image"   , {|| ::execEvent( __buttonNew_clicked__    ) }, .t., .T. )
      :addToolbarButton( "Chart"   , "Chart"   , "prv_charts"  , {|| ::execEvent( __buttonNew_clicked__    ) }, .t., .T. )
      :addToolbarButton( "Gradient", "Gradient", "prv_gradient", {|| ::execEvent( __buttonNew_clicked__    ) }, .t., .T. )
      :addToolbarButton( "Barcode" , "Barcode" , "prv_barcode" , {|| ::execEvent( __buttonNew_clicked__    ) }, .t., .T. )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:buildToolbar( oLayout )

   WITH OBJECT ::oToolbar := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( { 255,0,0 } )
      :setButtonHeight( 50 )
      :setButtonWidth( 50 )
      :setAlignment( Qt_AlignHCenter )
      :create( oLayout )
   ENDWITH
   WITH OBJECT ::oToolbar
      :addToolbarButton( "ShowObjects", "Show Objects Toolbar", "menu"             , {|| iif( ::oToolbarObjects:oWidget:isVisible(), ::oToolbarObjects:oWidget:hide(), ::oToolbarObjects:oWidget:show() ) } )
      :addToolbarButton( "Save"     , "Save"                  , "prv_save-doc"     , {|| ::saveReport()                                } )
      :addToolbarButton( "Print"    , "Print"                 , "prv_printpreview" , {|| ::oUI:tabBaseMain:setCurrentIndex( TAB_MAIN_PRINTPREVIEW ) } )
      :addToolbarButton( "Portrait" , "Portrait Orientation"  , "r-portrait"       , {|| ::oScene:setOrientation( QPrinter_Portrait  ) }, .F., .F.      )
      :addToolbarButton( "Landscape", "Landscape Orientation" , "r-landscape"      , {|| ::oScene:setOrientation( QPrinter_Landscape ) }, .F., .F.      )
      :addToolbarButton( "ZoomIn"   , "Zoom In"               , "prv_zoom-in-1"    , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_IN        )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomOut"  , "Zoom Out"              , "prv_zoom-out-1"   , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_OUT       )    }, .F., .F., .T. )
      :addToolbarButton( "ZoomWYS"  , "Zoom WYSIWYG"          , "prv_zoom-1"       , {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG   )    } )
      :addToolbarButton( "ZoomOrg"  , "Zoom Original"         , "prv_zoom-original", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL  )    } )
      :addToolbarButton( "Grid"     , "Show Grid"             , "prv_grid"         , {|| ::lShowGrid := ! ::lShowGrid, ::oScene:setShowGrid( ::lShowGrid ) } )
   ENDWITH
   RETURN Self


METHOD HbQtVisualizer:execMenuShapes()

   IF empty( ::qShapesMenu )
      ::qShapesMenu := QMenu()

      ::aShapesAct[ SHP_ACT_RECTANGLE     ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_rectangle"     ) ), "Rectangle"           )
      ::aShapesAct[ SHP_ACT_ROUNDRECT     ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_roundrectangle") ), "Rounded Rectangle"   )
      ::aShapesAct[ SHP_ACT_ELLIPSE       ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_ellipse"       ) ), "Ellipse"             )
      ::aShapesAct[ SHP_ACT_LINEHORZ      ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_linehorz"      ) ), "Horizontal Line"     )
      ::aShapesAct[ SHP_ACT_LINEVERT      ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_linevert"      ) ), "Vertical Line"       )
      ::aShapesAct[ SHP_ACT_LINEDIAGRIGHT ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_linediagright" ) ), "Diagonal Line Right" )
      ::aShapesAct[ SHP_ACT_LINEDIAGLEFT  ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_linediagleft"  ) ), "Diagonal Line Left"  )
      ::aShapesAct[ SHP_ACT_ARC           ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_arc"           ) ), "Arc"                 )
      ::aShapesAct[ SHP_ACT_CHORD         ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_chord"         ) ), "Chord"               )
      ::aShapesAct[ SHP_ACT_DIAMOND       ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_diamond"       ) ), "Diamond"             )
      ::aShapesAct[ SHP_ACT_TRIANGLE      ] := ::qShapesMenu:addAction( QIcon( __hbqtImage( "rp_triangle"      ) ), "Triangle"            )

      ::qShapesMenu:connect( QEvent_MouseButtonPress  , {|p| ::execEvent( __QEvent_MousePressMenu__  , p ) } )
      ::qShapesMenu:connect( QEvent_MouseMove         , {|p| ::execEvent( __QEvent_MouseMoveMenu__   , p ) } )
      ::qShapesMenu:connect( QEvent_MouseButtonRelease, {|p| ::execEvent( __QEvent_MouseReleaseMenu__, p ) } )
   ENDIF
   ::qShapesMenu:exec( QCursor():pos() )
   RETURN Self


METHOD HbQtVisualizer:printPreview( oPrinter )
   LOCAL oDlg //, qInfo //, qList, i, qStr

   WITH OBJECT oPrinter := QPrinter()
      :setOutputFormat( QPrinter_PdfFormat )
      :setOrientation( ::oScene:orientation() )
      :setPaperSize( ::oScene:pageSize() )
      // :setFullPage( .t. )
   ENDWITH
#if 0
   qInfo := QPrinterInfo( qPrinter )
   qList := qInfo:availablePrinters()
   FOR i := 0 TO qList:size() - 1
      qStr := qList:at( i )
   NEXT
#endif

   WITH OBJECT oDlg := QPrintPreviewDialog( oPrinter, ::oGraphicsView )
      :setWindowTitle( "HBReportGenerator : " + iif( !empty( ::cSaved ), ::cSaved, "Untitled" ) )
      :move( 20, 20 )
      :resize( 400, 600 )
      :connect( "paintRequested(QPrinter*)", {|p| ::printReport( p ) } )
      :exec()
   ENDWITH
   oDlg:disconnect( "paintRequested(QPrinter*)" )

   RETURN NIL


METHOD HbQtVisualizer:printReport( oPrinter )
   LOCAL oPageLayout, oPainter, oRectF, oRPage, oRectS, nMarginW, nMarginH, a_ //, oBack

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
//Alert( {  nMarginW, oRectS:width(), U_UNIT( oRectF:width() ), U_UNIT( oRPage:width() ) } )
      //oPainter:setWindow( 0, 0, U_UNIT( oRectF:width() ), U_UNIT( oRectF:height() ) )
      //oPainter:setViewPort( nMarginW/2, nMarginH/2, U_UNIT( oRectF:width() ) - nMarginW, U_UNIT( oRectF:height() ) - nMarginH )
      //oPainter:setViewPort( 0, 0, oRectS:width(), oRectS:height() )
      IF HB_ISOBJECT( ::oHbQtVisualBackground )
         WITH OBJECT ::oHbQtVisualBackground
            //:setPixmap( ::oPixmapBackground:scaled( U_UNIT( oRectF:width() ) - nMarginW, U_UNIT( oRectF:height() ) - nMarginH, Qt_KeepAspectRatio ) )
            //:setGeometry( 0, 0, U_UNIT( oRectF:width() ) - nMarginW, U_UNIT( oRectF:height() ) - nMarginH )
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


STATIC FUNCTION rmgr_a2arrayStr( aArray )
   LOCAL s, x

   s := "{"
   FOR EACH x IN aArray
      SWITCH valtype( x )
      CASE "C"
         s += '"' + x + '"'               ; EXIT
      CASE "N"
         s += hb_ntos( x )                ; EXIT
      CASE "D"
         s += "stod(" + dtos( x ) + ")"   ; EXIT
      CASE "L"
         s += iif( x, ".t.", ".f." )      ; EXIT
      CASE "A"
         s += rmgr_a2arrayStr( x )        ; EXIT
      OTHERWISE
         s += "NIL"                       ; EXIT
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


