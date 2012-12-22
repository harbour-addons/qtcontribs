/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"

#include "hbtrace.ch"


#define __ev_keypress__                           1                /* Keypress Event */
#define __ev_mousepress_on_frozen__               31               /* Mousepress on Frozen */
#define __ev_mousepress__                         2                /* Mousepress */
#define __ev_xbpBrw_itemSelected__                3                /* xbeBRW_ItemSelected */
#define __ev_wheel__                              4                /* wheelEvent */
#define __ev_horzscroll_via_qt__                  11               /* Horizontal Scroll Position : sent by Qt */
#define __ev_vertscroll_via_user__                101              /* Vertical Scrollbar Movements by the User */
#define __ev_vertscroll_sliderreleased__          102              /* Vertical Scrollbar: Slider Released */
#define __ev_horzscroll_slidermoved__             103              /* Horizontal Scrollbar: Slider moved */
#define __ev_horzscroll_sliderreleased__          104              /* Horizontal Scrollbar: Slider Released */
#define __ev_columnheader_pressed__               111              /* Column Header Pressed */
#define __ev_headersec_resized__                  121              /* Header Section Resized */
#define __ev_footersec_resized__                  122              /* Footer Section Resized */
#define __editor_closeEditor__                    1400
#define __editor_commitData__                     1401

#define __ev_tableViewBlock_main__                1501
#define __ev_tableViewBlock_left__                1502
#define __ev_tableViewBlock_right__               1503

#define __ev_frame_resized__                      2001
#define __ev_contextMenuRequested__               2002


#define HBQTBRW_CURSOR_NONE                       1
#define HBQTBRW_CURSOR_CELL                       2
#define HBQTBRW_CURSOR_ROW                        3

#define HBQTCOL_TYPE_ICON                         1
#define HBQTCOL_TYPE_BITMAP                       2
#define HBQTCOL_TYPE_SYSICON                      3
#define HBQTCOL_TYPE_TEXT                         4
#define HBQTCOL_TYPE_FILEICON                     5
#define HBQTCOL_TYPE_FILEMINIICON                 6
#define HBQTCOL_TYPE_MULTILINETEXT                7

#define ISFROZEN( n )                             ( ascan( ::aLeftFrozen, n ) > 0 .OR. ascan( ::aRightFrozen, n ) > 0 )


FUNCTION HbQtBrowseNew( nTop, nLeft, nBottom, nRight, oParent, oFont )
   RETURN HbQtBrowse():new( nTop, nLeft, nBottom, nRight, oParent, oFont )


STATIC FUNCTION hbxbp_ConvertAFactFromXBP( ... )
   RETURN NIL


CLASS HbQtBrowse INHERIT TBrowse

   DATA   oWidget

   /* Overloaded Methods */
   METHOD new( nTop, nLeft, nBottom, nRight, oParent, oFont )
   METHOD doConfigure()
   METHOD rowCount()
   METHOD up()
   METHOD down()
   METHOD pageUp()
   METHOD pageDown()
   METHOD goTop()
   METHOD goBottom()
   METHOD left()
   METHOD right()
   METHOD firstCol()
   METHOD lastCol()
   METHOD home()
   METHOD end()
   METHOD panHome()
   METHOD panEnd()
   METHOD panLeft()
   METHOD panRight()
   ASSIGN freeze                                  METHOD freeze               // set number of columns to freeze

   /* HbQt Methods */
   METHOD create()
   METHOD execSlot( nEvent, p1, p2, p3 )
   METHOD execEvent( nEvent, oEvent )
   METHOD supplyInfo( nMode, nCall, nRole, nX, nY )
   METHOD compatColor( nColor )
   METHOD compatIcon( cIcon )
   METHOD cellValue( nRow, nCol )
   METHOD cellValueA( nRow, nCol )

   METHOD navigationBlock( bBlock )               SETGET

   DATA   oParent
   DATA   oFont

   DATA   oDbfModel
   DATA   oModelIndex                             INIT      QModelIndex()
   DATA   oVHeaderView
   DATA   oHeaderView
   DATA   oVScrollBar                             INIT      QScrollBar()
   DATA   oHScrollBar                             INIT      QScrollBar()
   DATA   oViewport                               INIT      QWidget()
   DATA   pCurIndex

   DATA   lFirst                                  INIT      .t.
   DATA   nRowsInView                             INIT      1

   METHOD connect()

   METHOD setHorzOffset()
   METHOD setVertScrollBarRange( lPageStep )
   METHOD setHorzScrollBarRange( lPageStep )
   METHOD updateVertScrollBar()
   METHOD updatePosition()

   DATA   sl_navigate

   DATA   lHScroll                                INIT      .F.
   METHOD hScroll                                 SETGET
   DATA   lVScroll                                INIT      .F.
   METHOD vScroll                                 SETGET
   DATA   nCursorMode                             INIT      0
   METHOD cursorMode                              SETGET

   DATA   lSizeCols                               INIT      .T.
   METHOD sizeCols                                SETGET

   DATA   softTrack                               INIT      .T.
   DATA   nHorzOffset                             INIT      -1
   DATA   lReset                                  INIT      .F.
   DATA   lHorzMove                               INIT      .f.

   DATA   oTableView
   DATA   oGridLayout
   DATA   oFooterView
   DATA   oFooterModel

   DATA   oLeftView
   DATA   oLeftVHeaderView
   DATA   oLeftHeaderView
   DATA   oLeftFooterView
   DATA   oLeftFooterModel
   DATA   oLeftDbfModel

   DATA   oRightView
   DATA   oRightVHeaderView
   DATA   oRightHeaderView
   DATA   oRightFooterView
   DATA   oRightFooterModel
   DATA   oRightDbfModel

   METHOD buildLeftFreeze()
   METHOD buildRightFreeze()
   METHOD fetchColumnInfo( nCall, nRole, nArea, nRow, nCol )

   METHOD setLeftFrozen( aColFrozens )
   METHOD setRightFrozen( aColFrozens )
   DATA   aLeftFrozen                             INIT   {}
   DATA   aRightFrozen                            INIT   {}
   DATA   nLeftFrozen                             INIT   0
   DATA   nRightFrozen                            INIT   0

   DATA   gridStyle                               INIT   Qt_SolidLine

   DATA   nCellHeight                             INIT   20
   DATA   oDefaultCellSize
   METHOD setCellHeight( nCellHeight )
   METHOD setCurrentIndex( lReset )
   METHOD setIndex( qModelIndex )                 INLINE ::oTableView:setCurrentIndex( qModelIndex )
   METHOD getCurrentIndex()                       INLINE ::oDbfModel:index( ::rowPos - 1, ::colPos - 1 )
   ACCESS getDbfModel()                           INLINE ::oDbfModel
   METHOD openPersistentEditor()


   METHOD setFocus()                              INLINE ::oTableView:setFocus()

   DATA   qDelegate
   METHOD edit()                                  INLINE ::oTableView:edit( ::getCurrentIndex() )

   METHOD manageFrameResized()
   METHOD manageCommitData( qWidget )
   METHOD manageEditorClosed( pWidget, nHint )
   METHOD manageScrollContents( nX, nY )
   METHOD manageMouseDblClick( oMouseEvent )
   METHOD manageMousePress( oMouseEvent )
   METHOD manageMouseWheel( oWheelEvent )

   DATA   hColors                                 INIT {=>}
   DATA   hIcons                                  INIT {=>}


   VAR aCellValuesA  AS ARRAY                     INIT {}   // cell values buffers for each record - actual

   /* Xbase++ : Mainly Manage Scrollbars : Will be useful for HbQt */
   METHOD firstPosBlock( bBlock )                 SETGET
   METHOD lastPosBlock( bBlock )                  SETGET
   METHOD phyPosBlock( bBlock )                   SETGET
   METHOD posBlock( bBlock )                      SETGET
   METHOD goPosBlock( bBlock )                    SETGET
   METHOD hitBottomBlock( bBlock )                SETGET
   METHOD hitTopBlock( bBlock )                   SETGET
   METHOD stableBlock( bBlock )                   SETGET

   VAR bFirstPosBlock                             INIT NIL
   VAR bLastPosBlock                              INIT NIL
   VAR bPhyPosBlock                               INIT NIL
   VAR bPosBlock                                  INIT NIL
   VAR bGoPosBlock                                INIT NIL
   VAR bHitBottomBlock                            INIT NIL
   VAR bHitTopBlock                               INIT NIL
   VAR bStableBlock                               INIT NIL

   METHOD skipRows( nRows )                                 // INTERNAL - skips <nRows> back or forward : Resizing
   METHOD skipCols( nCols )                                 // INTERNAL - skips <nCols> right or left   : Resizing

   ENDCLASS


METHOD HbQtBrowse:new( nTop, nLeft, nBottom, nRight, oParent, oFont )

   ::TBrowse:new( nTop, nLeft, nBottom, nRight )

   hb_default( @oFont, QFont( "Courier new", 10 ) )

   ::oParent := oParent
   ::oFont   := oFont

   ::create()

   RETURN Self


METHOD HbQtBrowse:create()
   LOCAL qRect

   ::oWidget := QFrame( ::oParent )
   ::oWidget:setFrameStyle( QFrame_Panel + QFrame_Plain )

   /* Important here as other parts will be based on it*/
   ::oWidget:resize( ::oParent:width(), ::oParent:height() )

   /* Subclass of QTableView */
   ::oTableView := HBQTableView()
   ::oTableView:setFont( ::oFont )
   /* Set block to receive protected information */
   ::oTableView:hbSetBlock( {|p,p1,p2| ::execSlot( __ev_tableViewBlock_main__, p, p1, p2 ) } )
   /* Some parameters */
   ::oTableView:setTabKeyNavigation( .t. )
   ::oTableView:setShowGrid( .t. )
   ::oTableView:setGridStyle( ::gridStyle )   /* to be based on column definition */
   ::oTableView:setSelectionMode( QAbstractItemView_SingleSelection )
   ::oTableView:setSelectionBehavior( iif( ::cursorMode == 1, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
   ::oTableView:setAlternatingRowColors( .t. )
   ::oTableView:setContextMenuPolicy( Qt_CustomContextMenu )

   /* Finetune Horizontal Scrollbar */
   ::oTableView:setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   //
   ::oHScrollBar := QScrollBar()
   ::oHScrollBar:setOrientation( Qt_Horizontal )

   /*  Replace Vertical Scrollbar with our own */
   ::oTableView:setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   //
   ::oVScrollBar := QScrollBar()
   ::oVScrollBar:setOrientation( Qt_Vertical )

   /*  Veritical Header because of Performance boost */
   ::oVHeaderView := ::oTableView:verticalHeader()
   ::oVHeaderView:hide()

   /*  Horizontal Header Fine Tuning */
   ::oHeaderView := ::oTableView:horizontalHeader()
   ::oHeaderView:setHighlightSections( .F. )

   /* .DBF Manipulation Model */
   ::oDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 141, t, role, x, y ) } )

   /*  Attach Model with the View */
   ::oTableView:setModel( ::oDbfModel )

   /*  Horizontal Footer */
   ::oFooterView := QHeaderView( Qt_Horizontal )
   //
   ::oFooterView:setHighlightSections( .F. )
   ::oFooterView:setMinimumHeight( 20 )
   ::oFooterView:setMaximumHeight( 20 )
   ::oFooterView:setResizeMode( QHeaderView_Fixed )
   ::oFooterView:setFocusPolicy( Qt_NoFocus )
   //
   ::oFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 142, t, role, x, y ) } )
   //
   ::oFooterView:setModel( ::oFooterModel )

   /*  Widget for ::setLeftFrozen( aColumns )  */
   ::buildLeftFreeze()
   /*  Widget for ::setRightFrozen( aColumns )  */
   ::buildRightFreeze()

   /* Place all widgets in a Grid Layout */
   ::oGridLayout := QGridLayout( ::oWidget )
   ::oGridLayout:setContentsMargins( 0,0,0,0 )
   ::oGridLayout:setHorizontalSpacing( 0 )
   ::oGridLayout:setVerticalSpacing( 0 )
   /*  Rows */
   ::oGridLayout:addWidget( ::oLeftView       , 0, 0, 1, 1 )
   ::oGridLayout:addWidget( ::oLeftFooterView , 1, 0, 1, 1 )
   //
   ::oGridLayout:addWidget( ::oTableView      , 0, 1, 1, 1 )
   ::oGridLayout:addWidget( ::oFooterView     , 1, 1, 1, 1 )
   //
   ::oGridLayout:addWidget( ::oRightView      , 0, 2, 1, 1 )
   ::oGridLayout:addWidget( ::oRightFooterView, 1, 2, 1, 1 )
   //
   ::oGridLayout:addWidget( ::oHScrollBar     , 2, 0, 1, 3 )
   /*  Columns */
   ::oGridLayout:addWidget( ::oVScrollBar     , 0, 3, 2, 1 )

   ::oWidget:show()

   ::oFooterView:hide()

   /* Viewport */
   ::oViewport := ::oTableView:viewport()

   qRect := ::oWidget:geometry()
   ::oWidget:setGeometry( qRect )

   /* Handle the delegate */
   ::qDelegate := QItemDelegate()
   ::oTableView:setItemDelegate( ::qDelegate )

   ::oTableView:setEditTriggers( QAbstractItemView_AnyKeyPressed )

   ::connect()

   // QApplication():sendEvent( ::oTableView, QMouseEvent( QEvent_MouseButtonPress, QPoint( 1,1 ), Qt_LeftButton, Qt_LeftButton, Qt_NoModifier ) )

   RETURN Self


METHOD HbQtBrowse:doConfigure()     /* Overloaded */

   LOCAL aCol, aVal, aValA, nColCount, nRowCount, nHeight
   LOCAL nViewH, i, xVal, oFontMetrics, n, nLeftWidth, nwVal, nwHead
   LOCAL nMaxCellH

   ::TBrowse:doConfigure()

   IF ! ::lHScroll
      ::oHScrollBar:hide()
   ENDIF
   IF ! ::lVScroll
      ::oVScrollBar:hide()
   ENDIF

   ::oTableView:setSelectionBehavior( iif( ::cursorMode == 1, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )

   /* Calculate how many rows fit in the view */
   IF len( ::columns ) > 0
      oFontMetrics := QFontMetrics( ::oTableView:font() )
      nHeight := oFontMetrics:height() + 3

      nMaxCellH := nHeight + 5
      //aeval( ::columns, {|o| nMaxCellH := max( nMaxCellH, o:hHeight ) } )
      //
      ::oHeaderView:setMaximumHeight( nMaxCellH )
      ::oHeaderView:setMinimumHeight( nMaxCellH )
      //
      ::oLeftHeaderView:setMaximumHeight( nMaxCellH )
      ::oLeftHeaderView:setMinimumHeight( nMaxCellH )
      //
      ::oRightHeaderView:setMaximumHeight( nMaxCellH )
      ::oRightHeaderView:setMinimumHeight( nMaxCellH )

      nMaxCellH := nHeight + 5
      //aeval( ::columns, {|o| nMaxCellH := max( nMaxCellH, o:fHeight ) } )
      //
      ::oFooterView     :setMaximumHeight( nMaxCellH )
      ::oLeftFooterView :setMaximumHeight( nMaxCellH )
      ::oRightFooterView:setMaximumHeight( nMaxCellH )

      nMaxCellH := nHeight
      //aeval( ::columns, {|o| nMaxCellH := max( nMaxCellH, o:dHeight ) } )
      //
      nViewH := ::oViewport:height() //- ::oHeaderView:height()
      ::nRowsInView := Int( nViewH / nMaxCellH )
      IF ( nViewH % nMaxCellH ) > ( nMaxCellH / 2 )
         ::nRowsInView++
      ENDIF

      /* Probably this is the appropriate time to update row heights */
      ::nCellHeight := nMaxCellH
      ::setCellHeight( nMaxCellH )

      /* Implement Column Resizing Mode */
      ::oHeaderView:setResizeMode( iif( ::lSizeCols, QHeaderView_Interactive, QHeaderView_Fixed ) )
      ::oFooterView:setResizeMode( QHeaderView_Fixed )
      //
      ::oLeftHeaderView:setResizeMode( QHeaderView_Fixed )
      ::oLeftFooterView:setResizeMode( QHeaderView_Fixed )
      //
      ::oRightHeaderView:setResizeMode( QHeaderView_Fixed )
      ::oRightFooterView:setResizeMode( QHeaderView_Fixed )

      /* Set column widths */
      FOR i := 1 TO len( ::columns )
         IF ::columns[ i ]:nColWidth != NIL
            ::oHeaderView:resizeSection( i-1, ::columns[ i ]:nColWidth )
            ::oFooterView:resizeSection( i-1, ::columns[ i ]:nColWidth )
         ELSE
            xVal := transform( eval( ::columns[ i ]:block ), ::columns[ i ]:picture )

            nwVal := oFontMetrics:width( xVal, -1 )
            nwHead := oFontMetrics:width( ::columns[ i ]:heading(), -1 )

            ::columns[ i ]:nColWidth := max( nwVal, nwHead ) + 8

            ::oHeaderView:resizeSection( i-1, max( nwVal, nwHead ) + 8 )
            ::oFooterView:resizeSection( i-1, max( nwVal, nwHead ) + 8 )
         *  ::oHeaderView:resizeSection( i-1, oFontMetrics:width( xVal, -1 ) + 8 )
         *  ::oFooterView:resizeSection( i-1, oFontMetrics:width( xVal, -1 ) + 8 )
         ENDIF
      NEXT

      nLeftWidth := 0
      FOR n := 1 TO ::nLeftFrozen
         i := ::aLeftFrozen[ n ]
         IF ::columns[ i ]:nColWidth != NIL
            ::oLeftHeaderView:resizeSection( n-1, ::columns[ i ]:nColWidth )
            ::oLeftFooterView:resizeSection( n-1, ::columns[ i ]:nColWidth )
         ELSE
            xVal := transform( eval( ::columns[ i ]:block ), ::columns[ i ]:picture )
            nwVal := oFontMetrics:width( xVal, -1 )
            nwHead := oFontMetrics:width( ::columns[ i ]:heading(), -1 )
            ::oLeftHeaderView:resizeSection( n-1, max( nwVal, nwHead ) + 8 )
            ::oLeftFooterView:resizeSection( n-1, max( nwVal, nwHead ) + 8 )
         *  ::oLeftHeaderView:resizeSection( n-1, oFontMetrics:width( xVal, -1 ) + 8 )
         *  ::oLeftFooterView:resizeSection( n-1, oFontMetrics:width( xVal, -1 ) + 8 )
         ENDIF
         nLeftWidth += ::oLeftHeaderView:sectionSize( n-1 )
      NEXT
      ::oLeftView:setFixedWidth( 4 + nLeftWidth )
      //::oLeftHeaderView:setFixedWidth( nLeftWidth )
      ::oLeftFooterView:setFixedWidth( 4 + nLeftWidth )

      nLeftWidth := 0
      FOR n := 1 TO ::nRightFrozen
         i := ::aRightFrozen[ n ]
         IF ::columns[ i ]:nColWidth != NIL
            ::oRightHeaderView:resizeSection( n-1, ::columns[ i ]:nColWidth )
            ::oRightFooterView:resizeSection( n-1, ::columns[ i ]:nColWidth )
         ELSE
            xVal := transform( eval( ::columns[ i ]:block ), ::columns[ i ]:picture )
            nwVal := oFontMetrics:width( xVal, -1 )
            nwHead := oFontMetrics:width( ::columns[ i ]:heading(), -1 )
            ::oRightHeaderView:resizeSection( n-1, max( nwVal, nwHead ) + 8 )
            ::oRightFooterView:resizeSection( n-1, max( nwVal, nwHead ) + 8 )
         *  ::oRightHeaderView:resizeSection( n-1, oFontMetrics:width( xVal, -1 ) + 8 )
         *  ::oRightFooterView:resizeSection( n-1, oFontMetrics:width( xVal, -1 ) + 8 )
         ENDIF
         nLeftWidth += ::oRightHeaderView:sectionSize( n-1 )
      NEXT
      ::oRightView:setFixedWidth( 4 + nLeftWidth )
      //::oRightHeaderView:setFixedWidth( nLeftWidth )
      ::oRightFooterView:setFixedWidth( 4 + nLeftWidth )

   ENDIF

   IF ::nLeftFrozen == 0 .AND. HB_ISOBJECT( ::oLeftView )
      ::oLeftView:hide()
      ::oLeftFooterView:hide()
   ELSEIF ::nLeftFrozen > 0 .AND. HB_ISOBJECT( ::oLeftView )
      ::oLeftView:show()
      ::oLeftFooterView:show()
   ENDIF
   IF ::nRightFrozen == 0 .AND. HB_ISOBJECT( ::oRightView )
      ::oRightView:hide()
      ::oRightFooterView:hide()
   ELSEIF ::nRightFrozen > 0 .AND. HB_ISOBJECT( ::oRightView )
      ::oRightView:show()
      ::oRightFooterView:show()
   ENDIF

   FOR i := 1 TO ::colCount
      IF ISFROZEN( i )
         ::oTableView:hideColumn( i - 1 )
         ::oFooterView:setSectionHidden( i - 1, .t. )
      ELSE
         ::oTableView:showColumn( i - 1 )
         ::oFooterView:setSectionHidden( i - 1, .f. )
      ENDIF
   NEXT


   nColCount := ::colCount
   nRowCount := ::rowCount
   IF nRowCount == 0
      _GENLIMITRTE()
   ENDIF

   /* create new record buffer */
   ASize( ::aCellStatus , nRowCount )
   ASize( ::aDispStatus , nRowCount )
   ASize( ::aCellValues , nRowCount )
   ASize( ::aCellValuesA, nRowCount )
   ASize( ::aCellColors , nRowCount )
   AFill( ::aCellStatus , .F. )
   AFill( ::aDispStatus , .T. )
   FOR EACH aVal, aValA, aCol IN ::aCellValues, ::aCellValuesA, ::aCellColors
      IF aVal == NIL
         aVal := Array( nColCount )
      ELSE
         ASize( aVal, nColCount )
      ENDIF
      IF aValA == NIL
         aValA := Array( nColCount )
      ELSE
         ASize( aValA, nColCount )
      ENDIF
      IF aCol == NIL
         aCol := Array( nColCount )
      ELSE
         ASize( aCol, nColCount )
      ENDIF
   NEXT

   ::lStable := .F.
   ::lFrames := .T.
   ::nLastRow := nRowCount
   ::nLastScroll := 0
   ::nLastPos := 0
   IF ::nRowPos > nRowCount
      ::nRowPos := nRowCount
   ELSEIF ::nRowPos < 1
      ::nRowPos := 1
   ENDIF

   ::setHorzScrollBarRange()

   ::setCellHeight( ::nCellHeight )

   /* Inform Qt about number of rows and columns browser implements */
   //::oDbfModel:hbSetRowColumns( ::rowCount - 1, ::colCount - 1 )
   /* Tell Qt to Reload Everything */
   ::oDbfModel:reset()
   //
   IF HB_ISOBJECT( ::oLeftDbfModel )
      //::oLeftDbfModel:hbSetRowColumns( ::rowCount - 1, ::nLeftFrozen - 1 ) // Dangling code
      ::oLeftDbfModel:reset()
   ENDIF
   IF HB_ISOBJECT( ::oRightDbfModel )
      //::oRightDbfModel:hbSetRowColumns( ::rowCount - 1, ::nRightFrozen - 1 )
      ::oRightDbfModel:reset()
   ENDIF

   RETURN Self


METHOD HbQtBrowse:connect()

   ::oTableView       : connect( QEvent_KeyPress                     , {|p      | ::execEvent( __ev_keypress__                , p    ) } )
   ::oWidget          : connect( QEvent_Resize                       , {|p      | ::execEvent( __ev_frame_resized__           , p    ) } )


   ::oLeftHeaderView  : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )
   ::oLeftFooterView  : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )

   ::oRightHeaderView : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )
   ::oRightFooterView : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )

   ::oTableView       : connect( "customContextMenuRequested(QPoint)", {|p      | ::execSlot( __ev_contextMenuRequested__     , p    ) } )

   ::oHScrollBar      : connect( "actionTriggered(int)"              , {|i      | ::execSlot( __ev_horzscroll_slidermoved__   , i    ) } )
   ::oHScrollBar      : connect( "sliderReleased()"                  , {|i      | ::execSlot( __ev_horzscroll_sliderreleased__, i    ) } )

   ::oVScrollBar      : connect( "actionTriggered(int)"              , {|i      | ::execSlot( __ev_vertscroll_via_user__      , i    ) } )
   ::oVScrollBar      : connect( "sliderReleased()"                  , {|i      | ::execSlot( __ev_vertscroll_sliderreleased__, i    ) } )

   ::oHeaderView      : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_columnheader_pressed__     , i    ) } )
   ::oHeaderView      : connect( "sectionResized(int,int,int)"       , {|i,i1,i2| ::execSlot( __ev_headersec_resized__   , i, i1, i2 ) } )

   ::qDelegate        : connect( "commitData(QWidget*)"              , {|p      | ::execSlot( __editor_commitData__           , p    ) } )
   ::qDelegate        : connect( "closeEditor(QWidget*,QAbstractItemDelegate::EndEditHint)", {|p,p1 | ::execSlot( __editor_closeEditor__, p, p1 ) } )

   RETURN Self


METHOD HbQtBrowse:buildLeftFreeze()

   /*  Left Freeze */
   ::oLeftView := HBQTableView()
   ::oLeftView:setFont( ::oFont )
   //
   ::oLeftView:setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   ::oLeftView:setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   ::oLeftView:setTabKeyNavigation( .t. )
   ::oLeftView:setShowGrid( .t. )
   ::oLeftView:setGridStyle( ::gridStyle )   /* to be based on column definition */
   ::oLeftView:setSelectionMode( QAbstractItemView_SingleSelection )
   ::oLeftView:setSelectionBehavior( iif( ::cursorMode == 1, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
   ::oLeftView:setFocusPolicy( Qt_NoFocus )
   //
   /*  Veritical Header because of Performance boost */
   ::oLeftVHeaderView := ::oLeftView:verticalHeader()
   ::oLeftVHeaderView:hide()
   /*  Horizontal Header Fine Tuning */
   ::oLeftHeaderView := ::oLeftView:horizontalHeader()
   ::oLeftHeaderView:setHighlightSections( .F. )

   ::oLeftDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 151, t, role, x, y ) } )

   ::oLeftView:setModel( ::oLeftDbfModel )
   //
   //::oLeftView:hide()

   /*  Horizontal Footer */
   ::oLeftFooterView := QHeaderView( Qt_Horizontal )
   //
   ::oLeftFooterView:setHighlightSections( .F. )
   ::oLeftFooterView:setMinimumHeight( 20 )
   ::oLeftFooterView:setMaximumHeight( 20 )
   ::oLeftFooterView:setResizeMode( QHeaderView_Fixed )
   ::oLeftFooterView:setFocusPolicy( Qt_NoFocus )
   //
   ::oLeftFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 152, t, role, x, y ) } )

   ::oLeftFooterView:setModel( ::oLeftFooterModel )
   //
   //::oLeftFooterView:hide()

   RETURN Self


METHOD HbQtBrowse:buildRightFreeze()
   LOCAL oVHdr

   /*  Left Freeze */
   ::oRightView := HBQTableView()
   ::oRightView:setFont( ::oFont )
   //
   ::oRightView:setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   ::oRightView:setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
   ::oRightView:setTabKeyNavigation( .t. )
   ::oRightView:setShowGrid( .t. )
   ::oRightView:setGridStyle( ::gridStyle )   /* to be based on column definition */
   ::oRightView:setSelectionMode( QAbstractItemView_SingleSelection )
   ::oRightView:setSelectionBehavior( iif( ::cursorMode == 1, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
   //
   /*  Veritical Header because of Performance boost */
   oVHdr := ::oRightView:verticalHeader()
   oVHdr:hide()
   /*  Horizontal Header Fine Tuning */
   ::oRightHeaderView := ::oRightView:horizontalHeader()
   ::oRightHeaderView:setHighlightSections( .F. )

   ::oRightDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 161, t, role, x, y ) } )

   ::oRightView:setModel( ::oRightDbfModel )

   /*  Horizontal Footer */
   ::oRightFooterView := QHeaderView( Qt_Horizontal )
   //
   ::oRightFooterView:setHighlightSections( .F. )
   ::oRightFooterView:setMinimumHeight( 20 )
   ::oRightFooterView:setMaximumHeight( 20 )
   ::oRightFooterView:setResizeMode( QHeaderView_Fixed )
   ::oRightFooterView:setFocusPolicy( Qt_NoFocus )
   //
   ::oRightFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 162, t, role, x, y ) } )

   ::oRightFooterView:setModel( ::oRightFooterModel )

   RETURN Self


METHOD HbQtBrowse:execEvent( nEvent, oEvent )
   LOCAL lHandelled := .F.
   LOCAL nKey

   SWITCH nEvent

   CASE __ev_keypress__
      nKey := hbqt_qtEventToHbEvent( oEvent )

      IF HB_ISBLOCK( SetKey( nKey ) )
         Eval( SetKey( nKey ) )
         RETURN .F.
      ENDIF

      IF HB_ISBLOCK( ::sl_navigate )
         lHandelled := Eval( ::sl_navigate, nKey, NIL, Self )
         IF ! HB_ISLOGICAL( lHandelled )
            lHandelled := .F.
         ENDIF
      ENDIF

      IF ! lHandelled
         ::applyKey( nKey )
      ENDIF
      /* SetAppEvent( xbeP_Keyboard, hbqt_qtEventToHbEvent( p1 ), NIL, Self ) */
      RETURN .T.   /* Stop Propegation to parent */

   CASE __ev_frame_resized__
      ::manageFrameResized()
      RETURN .T.

   ENDSWITCH

   RETURN .F.


METHOD HbQtBrowse:execSlot( nEvent, p1, p2, p3 )
   LOCAL oPoint

   SWITCH nEvent
   CASE __ev_tableViewBlock_main__
      SWITCH p1
      CASE QEvent_MouseButtonPress
         ::manageMousePress( p2 )
         EXIT
      CASE QEvent_MouseButtonDblClick
         ::manageMouseDblClick( p2 )
         EXIT
      CASE QEvent_Wheel
         ::manageMouseWheel( p2 )
         EXIT
      CASE HBQT_HBQTABLEVIEW_scrollContentsBy
         ::manageScrollContents( p2, p3 )
         EXIT
      ENDSWITCH
      EXIT
   CASE __ev_mousepress_on_frozen__
      ::oTableView:setFocus( 0 )
      EXIT
   CASE __ev_horzscroll_via_qt__
      ::manageScrollContents( p1, p2 )
      EXIT
   CASE __ev_contextMenuRequested__
      oPoint := ::oTableView:mapToGlobal( QPoint( p1 ) )
      ::hbContextMenu( { oPoint:x(), oPoint:y() } )
      EXIT
   CASE __editor_commitData__
      ::manageCommitData( p1 )
      EXIT
   CASE __editor_closeEditor__
      ::manageEditorClosed( p1, p2 )
      EXIT
   CASE __ev_vertscroll_via_user__
      SWITCH p1
      CASE QAbstractSlider_SliderNoAction
         RETURN NIL
      CASE QAbstractSlider_SliderSingleStepAdd
         ::down()
         EXIT
      CASE QAbstractSlider_SliderSingleStepSub
         ::up()
         EXIT
      CASE QAbstractSlider_SliderPageStepAdd
         ::pageDown()
         EXIT
      CASE QAbstractSlider_SliderPageStepSub
         ::pageUp()
         EXIT
      CASE QAbstractSlider_SliderToMinimum
         ::goTop()
         EXIT
      CASE QAbstractSlider_SliderToMaximum
         ::goBottom()
         EXIT
      CASE QAbstractSlider_SliderMove
         ::updatePosition()
         EXIT
      ENDSWITCH
      ::oTableView:setFocus( 0 )
      EXIT
   CASE __ev_vertscroll_sliderreleased__
      ::updatePosition()
      ::oTableView:setFocus()
      EXIT
   CASE __ev_horzscroll_slidermoved__
      ::skipCols( ( ::oHScrollBar:value() + 1 ) - ::colPos )
      ::oTableView:setFocus()
      EXIT
   CASE __ev_horzscroll_sliderreleased__
      ::skipCols( ( ::oHScrollBar:value() + 1 ) - ::colPos )
      ::oTableView:setFocus()
      EXIT
   CASE __ev_headersec_resized__
      ::oFooterView:resizeSection( p1, p3 )
      EXIT
   CASE __ev_footersec_resized__
      ::oHeaderView:resizeSection( p1, p3 )
      EXIT

   ENDSWITCH

   RETURN .F.


METHOD HbQtBrowse:manageFrameResized()
   LOCAL nRowPos, nColPos, nOff

   ::oHeaderView:resizeSection( 0, ::oHeaderView:sectionSize( 0 )+1 )
   ::oHeaderView:resizeSection( 0, ::oHeaderView:sectionSize( 0 )-1 )

   nRowPos := ::rowPos()
   nColPos := ::colPos()
   //
   ::nConfigure := 9
   ::doConfigure()
   //
   ::colPos := nColPos
   IF nRowPos > ::rowCount()
      nOff := nRowPos - ::rowCount()
      ::rowPos := ::rowCount()
   ELSE
      nOff := 0
   ENDIF
   ::refreshAll()
   ::forceStable()
   ::setCurrentIndex( nRowPos > ::rowCount() )
   IF nOff > 0
      ::skipRows( nOff )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageCommitData( qWidget )
   LOCAL cTxt    := qWidget:property( "text" ):toString()
   LOCAL oCol    := ::columns[ ::colPos ]
   LOCAL cTyp    := valtype( eval( oCol:block ) )

   HB_TRACE( HB_TR_DEBUG, cTxt )
   DO CASE
   CASE cTyp == "C"
      oCol:setData( cTxt )
   CASE cTyp == "N"
      oCol:setData( val( cTxt ) )
   CASE cTyp == "D"
      oCol:setData( ctod( cTxt ) )
   CASE cTyp == "L"
      oCol:setData( cTxt $ "Yy" )
   ENDCASE

   RETURN Self


METHOD HbQtBrowse:manageEditorClosed( pWidget, nHint )

   pWidget:close()

   SWITCH nHint
   CASE QAbstractItemDelegate_NoHint                 /* 0  RETURN is presses    */

   CASE QAbstractItemDelegate_EditNextItem           /* 1  TAB is pressed       */
      ::skipCols( 1 )

   CASE QAbstractItemDelegate_EditPreviousItem       /* 2  SHIFT_TAB is pressed */
      ::skipCols( -1 )

   CASE QAbstractItemDelegate_SubmitModelCache       /* 3  ENTER is pressed     */
      #if 0
      IF ::colPos < ::colCount
         ::skipCols( 1 )
         ::edit()
      ENDIF
      #endif
   CASE QAbstractItemDelegate_RevertModelCache       /* 4  ESC is pressed       */

   ENDSWITCH

   RETURN Self


METHOD HbQtBrowse:manageScrollContents( nX, nY )

   HB_SYMBOL_UNUSED( nY )

   IF nX != 0
      ::setHorzOffset()
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMouseDblClick( oMouseEvent )

   IF oMouseEvent:button() == Qt_LeftButton
      // ??
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMouseWheel( oWheelEvent )

   IF oWheelEvent:orientation() == Qt_Vertical
      IF oWheelEvent:delta() > 0
         ::skipRows( -1 )
      ELSE
         ::skipRows( 1 )
      ENDIF
   ELSE
      IF oWheelEvent:delta() > 0
         ::skipCols( 1 )
      ELSE
         ::skipCols( -1 )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMousePress( oMouseEvent )

   ::oModelIndex := ::oTableView:indexAt( oMouseEvent:pos() )
   IF ::oModelIndex:isValid()
      ::skipRows( ( ::oModelIndex:row() + 1 ) - ::rowPos )
      ::skipCols( ( ::oModelIndex:column() + 1 ) - ::colPos )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:openPersistentEditor()

   ::oTableView:openPersistentEditor( ::oDbfModel:index( ::rowPos - 1, ::colPos - 1 ) )

   RETURN Self


METHOD HbQtBrowse:supplyInfo( nMode, nCall, nRole, nX, nY )

   IF nCall == HBQT_QAIM_headerData .AND. nX == Qt_Vertical
      RETURN NIL
   ENDIF

   IF nCall == HBQT_QAIM_flags
      RETURN Qt_ItemIsEnabled + Qt_ItemIsSelectable + Qt_ItemIsEditable
   ENDIF

   DO CASE
   CASE nMode == 141       /* Main View Header|Data */
      IF nCall == HBQT_QAIM_columnCount
         IF ::colCount > 0
            ::forceStable()
            ::setHorzScrollBarRange( .t. )
         ENDIF
         RETURN ::colCount
      ELSEIF nCall == HBQT_QAIM_rowCount
         IF ::colCount > 0
            ::forceStable()
            ::setVertScrollBarRange( .f. )
         ENDIF
         RETURN ::rowCount
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 0, nY+1, nX+1 )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 0, 0, nY+1 )
      ENDIF
      RETURN nil

   CASE nMode == 142       /* Main View Footer */
      IF nCall == HBQT_QAIM_columnCount
         IF ::colCount > 0
            ::forceStable()
         ENDIF
         RETURN ::colCount
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 1, nY+1, nX+1 )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 1, 0, nY+1 )
      ENDIF
      RETURN nil

   CASE nMode == 151       /* Left Frozen Header|Data */
      IF nCall == HBQT_QAIM_columnCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nLeftFrozen
      ELSEIF nCall == HBQT_QAIM_rowCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::rowCount
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 0, nY+1, ::aLeftFrozen[ nX+1 ] )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 0, 0, ::aLeftFrozen[ nY+1 ] )
      ENDIF
      RETURN NIL

   CASE nMode == 152       /* Left Frozen Footer */
      IF nCall == HBQT_QAIM_columnCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nLeftFrozen
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 1, nY+1, ::aLeftFrozen[ nX+1 ] )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 1, 0, ::aLeftFrozen[ nY+1 ] )
      ENDIF

   CASE nMode == 161       /* Right Frozen Header|Data */
      IF nCall == HBQT_QAIM_columnCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nRightFrozen
      ELSEIF nCall == HBQT_QAIM_rowCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::rowCount
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 0, nY+1, ::aRightFrozen[ nX+1 ] )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 0, 0, ::aRightFrozen[ nY+1 ] )
      ENDIF

   CASE nMode == 162       /* Right Frozen Footer */
      IF nCall == HBQT_QAIM_columnCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nRightFrozen
      ELSEIF nCall == HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 1, nY+1, ::aRightFrozen[ nX+1 ] )
      ELSEIF nCall == HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 1, 0, ::aRightFrozen[ nY+1 ] )
      ENDIF

   ENDCASE

   RETURN NIL


METHOD HbQtBrowse:fetchColumnInfo( nCall, nRole, nArea, nRow, nCol )
   LOCAL oCol := ::columns[ nCol ]

   SWITCH nCall
   CASE HBQT_QAIM_data

      SWITCH ( nRole )
      CASE Qt_ForegroundRole
          RETURN ::compatColor( __hbqtHbColorToQtValue( ::colorValue( ::cellColor( nRow, nCol )[ 1 ] ), Qt_ForegroundRole ) )

      CASE Qt_BackgroundRole
         RETURN ::compatColor( __hbqtHbColorToQtValue( ::colorValue( ::cellColor( nRow, nCol )[ 1 ] ), Qt_BackgroundRole ) )

      CASE Qt_TextAlignmentRole
         RETURN oCol:dAlignment

      CASE Qt_SizeHintRole
         RETURN ::oDefaultCellSize

      CASE Qt_DecorationRole
         IF oCol:type == HBQTCOL_TYPE_FILEICON
            RETURN ::compatIcon( ::cellValue( nRow, nCol ) )
         ELSE
            RETURN NIL
         ENDIF
      CASE Qt_EditRole
      CASE Qt_DisplayRole
         IF oCol:type == HBQTCOL_TYPE_FILEICON
            RETURN nil
         ELSE
            RETURN ::cellValue( nRow, nCol )
         ENDIF
      ENDSWITCH
      RETURN NIL

   CASE HBQT_QAIM_headerData
      IF nArea == 0                    /* Header Area */
         SWITCH nRole
         CASE Qt_SizeHintRole
            RETURN ::oDefaultCellSize //oCol:hHeight
         CASE Qt_DisplayRole
            RETURN oCol:heading
         CASE Qt_TextAlignmentRole
            RETURN oCol:hAlignment
         CASE Qt_ForegroundRole
            RETURN ::compatColor( oCol:hFgColor )
         CASE Qt_BackgroundRole
            RETURN ::compatColor( oCol:hBgColor )
         ENDSWITCH
      ELSE                             /* Footer Area */
         SWITCH nRole
         CASE Qt_SizeHintRole
            RETURN ::oDefaultCellSize //oCol:fHeight
         CASE Qt_DisplayRole
            RETURN oCol:footing
         CASE Qt_TextAlignmentRole
            RETURN oCol:fAlignment
         CASE Qt_ForegroundRole
            RETURN ::compatColor( oCol:fFgColor )
         CASE Qt_BackgroundRole
            RETURN ::compatColor( oCol:fBgColor )
         ENDSWITCH
      ENDIF
      RETURN NIL
   ENDSWITCH

   RETURN NIL


METHOD HbQtBrowse:compatColor( nColor )

   IF ! hb_hHasKey( ::hColors, nColor )
      ::hColors[ nColor ] := QColor( nColor )
   ENDIF

   RETURN ::hColors[ nColor ]


METHOD HbQtBrowse:compatIcon( cIcon )

   IF ! hb_hHasKey( ::hIcons, cIcon )
      ::hIcons[ cIcon ] := QIcon( QPixmap( Trim( cIcon ) ) )
   ENDIF

   RETURN ::hIcons[ cIcon ]


METHOD HbQtBrowse:setVertScrollBarRange( lPageStep )
   LOCAL nMin, nMax

   IF HB_ISBLOCK( ::bFirstPosBlock ) .AND. HB_ISBLOCK( ::bLastPosBlock )
      hb_default( @lPageStep, .F. )

      IF HB_ISNUMERIC( nMin := eval( ::bFirstPosBlock  ) ) .AND. HB_ISNUMERIC( nMax := eval( ::bLastPosBlock ) )
         ::oVScrollBar:setMinimum( nMin - 1 )
         ::oVScrollBar:setMaximum( nMax - 1 )
         ::oVScrollBar:setSingleStep( 1 )
         //
         IF lPageStep
            ::oVScrollBar:setPageStep( ::rowCount() )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:setHorzScrollBarRange( lPageStep )

   hb_default( @lPageStep, .F. )

   ::oHScrollBar:setMinimum( 0 )
   ::oHScrollBar:setMaximum( ::colCount - 1 )
   ::oHScrollBar:setSingleStep( 1 )
   ::oHScrollBar:setPageStep( 1 )

   RETURN Self


METHOD HbQtBrowse:updatePosition()

   IF HB_ISBLOCK( ::goPosBlock )
      eval( ::goPosBlock, ::oVScrollBar:value() + 1 )
      ::refreshAll()
      ::forceStable()
      ::setCurrentIndex()
   ENDIF

   RETURN Self


METHOD HbQtBrowse:updateVertScrollBar()

   IF HB_ISBLOCK( ::posBlock )
      ::oVScrollBar:setValue( eval( ::posBlock ) - 1 )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:setHorzOffset()

   IF ::colPos == ::colCount
      ::oHeaderView:setOffsetToLastSection()
      ::oFooterView:setOffsetToLastSection()
   ELSE
      ::oHeaderView:setOffsetToSectionPosition( ::colPos - 1 )
      ::oFooterView:setOffsetToSectionPosition( ::colPos - 1 )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:setCurrentIndex( lReset )

   hb_default( @lReset, .T. )

   IF lReset
      ::oDbfModel:reset()                         /* Important */
      //
      IF HB_ISOBJECT( ::oLeftDbfModel )
         ::oLeftDbfModel:reset()
      ENDIF
      IF HB_ISOBJECT( ::oRightDbfModel )
         ::oRightDbfModel:reset()
      ENDIF
   ENDIF
   ::oTableView:setCurrentIndex( ::oDbfModel:index( ::rowPos - 1, ::colPos - 1 ) )

   RETURN Self


METHOD HbQtBrowse:hScroll( lYes )

   IF HB_ISLOGICAL( lYes )
      ::lHScroll := lYes
      ::setUnstable()
      ::configure( 128 )
   ENDIF

   RETURN ::lHScroll


METHOD HbQtBrowse:vScroll( lYes )

   IF HB_ISLOGICAL( lYes )
      ::lVScroll := lYes
      ::setUnstable()
      ::configure( 128 )
   ENDIF

   RETURN ::lHScroll


METHOD HbQtBrowse:sizeCols( lYes )

   IF HB_ISLOGICAL( lYes )
      ::lSizeCols := lYes
      ::setUnstable()
      ::configure( 128 )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:cursorMode( nMode )

   IF HB_ISNUMERIC( nMode )
      ::nCursorMode := nMode
      ::setUnstable()
      ::configure( 128 )
   ENDIF

   RETURN ::nCursorMode


METHOD HbQtBrowse:setRightFrozen( aColFrozens )
   LOCAL aFrozen := aclone( ::aRightFrozen )

   IF HB_ISARRAY( aColFrozens )
      ::aRightFrozen := aColFrozens
      ::nRightFrozen := len( ::aRightFrozen )
      ::setUnstable()
      ::configure( 128 )
      ::forceStable()
   ENDIF

   RETURN aFrozen


METHOD HbQtBrowse:setLeftFrozen( aColFrozens )
   LOCAL aFrozen := aclone( ::aLeftFrozen )

   IF HB_ISARRAY( aColFrozens )
      ::aLeftFrozen := aColFrozens
      ::nLeftFrozen := len( ::aLeftFrozen )
      ::setUnstable()
      ::configure( 128 )
      ::forceStable()
   ENDIF

   RETURN aFrozen


METHOD HbQtBrowse:setCellHeight( nCellHeight )
   LOCAL i

   FOR i := 1 TO ::nRowsInView
      ::oTableView : setRowHeight( i-1, nCellHeight )
      IF !empty( ::oLeftView )
         ::oLeftView  : setRowHeight( i-1, nCellHeight )
      ENDIF
      IF !empty( ::oRightView )
         ::oRightView : setRowHeight( i-1, nCellHeight )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtBrowse:cellValue( nRow, nCol )

   IF nRow >= 1 .AND. nRow <= ::rowCount .AND. ;
      nCol >= 1 .AND. nCol <= ::colCount .AND. ;
      ::aCellStatus[ nRow ]

      RETURN ::aCellValues[ nRow, nCol ]
   ENDIF

   RETURN NIL


METHOD HbQtBrowse:cellValueA( nRow, nCol )

   IF nRow >= 1 .AND. nRow <= ::rowCount .AND. ;
      nCol >= 1 .AND. nCol <= ::colCount .AND. ;
      ::aCellStatus[ nRow ]

      RETURN ::aCellValuesA[ nRow, nCol ]
   ENDIF

   RETURN NIL


METHOD HbQtBrowse:navigationBlock( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_navigate := bBlock
   ENDIF

   RETURN ::sl_navigate


METHOD HbQtBrowse:firstPosBlock( bBlock )
   IF bBlock != NIL
      ::bFirstPosBlock := __eInstVar53( Self, "FIRSTPOSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bFirstPosBlock

METHOD HbQtBrowse:lastPosBlock( bBlock )
   IF bBlock != NIL
      ::bLastPosBlock := __eInstVar53( Self, "LASTPOSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bLastPosBlock

METHOD HbQtBrowse:phyPosBlock( bBlock )
   IF bBlock != NIL
      ::bPhyPosBlock := __eInstVar53( Self, "PHYPOSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bPhyPosBlock

METHOD HbQtBrowse:posBlock( bBlock )
   IF bBlock != NIL
      ::bPosBlock := __eInstVar53( Self, "POSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bPosBlock

METHOD HbQtBrowse:goPosBlock( bBlock )
   IF bBlock != NIL
      ::bGoPosBlock := __eInstVar53( Self, "GOPOSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bGoPosBlock

METHOD HbQtBrowse:hitBottomBlock( bBlock )
   IF bBlock != NIL
      ::bHitBottomBlock := __eInstVar53( Self, "HITBOTTOMBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bHitBottomBlock

METHOD HbQtBrowse:hitTopBlock( bBlock )
   IF bBlock != NIL
      ::bHitTopBlock := __eInstVar53( Self, "HITTOPBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bHitTopBlock

METHOD HbQtBrowse:stableBlock( bBlock )
   IF bBlock != NIL
      ::bStableBlock := __eInstVar53( Self, "STABLEBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bStableBlock


METHOD HbQtBrowse:skipCols( nCols )
   LOCAL i

   IF nCols < 0
      FOR i := 1 TO abs( nCols )
         ::left()
      NEXT
   ELSEIF nCols > 0
      FOR i := 1 TO nCols
         ::right()
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtBrowse:skipRows( nRows )
   LOCAL i

   IF nRows < 0
      FOR i := 1 TO abs( nRows )
         ::up()
      NEXT
   ELSEIF nRows > 0
      FOR i := 1 TO nRows
         ::down()
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtBrowse:freeze( nColumns )  /* Overloaded */
   LOCAL i, n := ::nFrozen

   ::TBrowse:freeze( nColumns )

   ::nFrozen := Max( 0, Int( nColumns ) )
   ::aLeftFrozen := {}
   IF ! Empty( ::nFrozen )
      FOR i := 1 TO ::nFrozen
         AAdd( ::aLeftFrozen, i )
      NEXT
   ENDIF
   ::nLeftFrozen := Len( ::aLeftFrozen )
   ::setUnstable()
   ::configure( 128 )
   ::forceStable()
   IF n < nColumns
      ::Right()
      IF ::colPos > nColumns
         ::Left()
      ENDIF
   ELSEIF n > nColumns
      ::Left()
      ::Right()
   ENDIF

   RETURN ::nFrozen


METHOD HbQtBrowse:rowCount()  /* Overloaded */
   IF ::nConfigure != 0
      ::doConfigure()
   ENDIF
   RETURN ::nRowsInView


METHOD HbQtBrowse:up()
   LOCAL lReset := ::rowPos == 1

   ::TBrowse:up()

   ::forceStable()
   ::setCurrentIndex( lReset )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:down()
   LOCAL lReset := ::rowPos >= ::rowCount

   ::TBrowse:down()

   ::forceStable()
   ::setCurrentIndex( lReset )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:pageUp()

   ::TBrowse:pageUp()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:pageDown()

   ::TBrowse:pageDown()

   ::forceStable()
   ::setCurrentIndex( .t. )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:goTop()

   ::TBrowse:goTop()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:goBottom()

   ::TBrowse:goBottom()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()

   RETURN Self


METHOD HbQtBrowse:left()
   LOCAL n, nCol
   LOCAL lUpdate := .f.

   nCol := ::colPos

   IF nCol > 1
      DO WHILE --nCol >= 1
         IF ! ISFROZEN( nCol )
            lUpdate := .t.
            EXIT
         ENDIF
      ENDDO
   ENDIF
   IF lUpdate
      ::colPos := nCol

      n  := ::oHeaderView:sectionViewportPosition( ::colPos-1 )
      IF n < 0
         ::oHeaderView:setOffset( ::oHeaderView:offSet() + n )
         ::oFooterView:setOffset( ::oFooterView:offSet() + n )
         ::setCurrentIndex( .T. )
      ELSE
         ::setCurrentIndex( .F. )
      ENDIF

      ::oHScrollBar:setValue( ::colPos - 1 )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:right()
   LOCAL n, n1, n2, nLnWidth, nCol
   LOCAL lUpdate := .f.

   IF ::colPos < ::colCount
      nCol := ::colPos

      DO WHILE ++nCol <= ::colCount
         IF !( ISFROZEN( nCol ) )
            lUpdate := .t.
            EXIT
         ENDIF
      ENDDO

      IF lUpdate
         ::colPos := nCol

         n  := ::oHeaderView:sectionViewportPosition( ::colPos - 1 )
         n1 := ::oHeaderView:sectionSize( ::colPos-1 )
         n2 := ::oViewport:width()
         IF n + n1 > n2
            nLnWidth := ::oTableView:lineWidth()
            IF n1 > n2
               ::oHeaderView:setOffset( ::oHeaderView:sectionPosition( ::colPos - 1 ) )
               ::oFooterView:setOffset( ::oHeaderView:sectionPosition( ::colPos - 1 ) )

            ELSE
               ::oHeaderView:setOffset( ::oHeaderView:offSet()+(n1-(n2-n)+1) - nLnWidth )
               ::oFooterView:setOffset( ::oFooterView:offSet()+(n1-(n2-n)+1) - nLnWidth )

            ENDIF
            ::setCurrentIndex( .t. )
         ELSE
            ::setCurrentIndex( .f. )
         ENDIF

         ::oHScrollBar:setValue( ::colPos - 1 )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:firstCol()
   LOCAL n, nCol
   LOCAL lUpdate := .f.

   nCol := 0

   DO WHILE ++nCol <= ::colCount
      IF !ISFROZEN( nCol )
         lUpdate := .t.
         EXIT
      ENDIF
   ENDDO

   IF lUpdate
      ::setUnstable()
      ::colPos := nCol

      n  := ::oHeaderView:sectionViewportPosition( ::colPos-1 )
      IF n < 0
         ::oHeaderView:setOffset( ::oHeaderView:offSet() + n )
         ::oFooterView:setOffset( ::oFooterView:offSet() + n )
         ::setCurrentIndex( .t. )
      ELSE
         ::setCurrentIndex( .f. )
      ENDIF
      ::oHScrollBar:setValue( ::colPos - 1 )
   ENDIF
   RETURN Self


METHOD HbQtBrowse:lastCol()
   LOCAL n, n1, n2, nCol
   LOCAL lUpdate := .f.

   nCol := ::colCount + 1

   DO WHILE --nCol >= 1
      IF !ISFROZEN( nCol )
         lUpdate := .t.
         EXIT
      ENDIF
   ENDDO

   IF lUpdate
      ::setUnstable()
      ::colPos := nCol

      n  := ::oHeaderView:sectionViewportPosition( ::colPos-1 )
      n1 := ::oHeaderView:sectionSize( ::colPos-1 )
      n2 := ::oViewport:width()
      IF n + n1 > n2
         IF n1 > n2
            ::oHeaderView:setOffset( ::oHeaderView:sectionPosition( ::colPos - 1 ) )
            ::oFooterView:setOffset( ::oHeaderView:sectionPosition( ::colPos - 1 ) )
         ELSE
            ::oHeaderView:setOffset( ::oHeaderView:offSet()+(n1-(n2-n)+1) - ::oTableView:lineWidth() )
            ::oFooterView:setOffset( ::oFooterView:offSet()+(n1-(n2-n)+1) - ::oTableView:lineWidth() )
         ENDIF
         ::setCurrentIndex( .t. )
      ELSE
         ::setCurrentIndex( .f. )
      ENDIF
      ::oHScrollBar:setValue( ::colPos - 1 )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:home()

   ::colPos := max( 1, ::oHeaderView:visualIndexAt( 1 ) + 1 )
   ::setCurrentIndex( .t. )

   RETURN Self


METHOD HbQtBrowse:end()

   ::nRightVisible := ::oHeaderView:visualIndexAt( ::oViewport:width()-2 ) + 1
   IF ::nRightVisible == 0
      ::nRightVisible := ::colCount
   ENDIF
   ::colPos := ::nRightVisible
   ::setCurrentIndex( .t. )

   RETURN Self


METHOD HbQtBrowse:panHome()

   ::oHeaderView:setOffset( 0 )
   ::oFooterView:setOffset( 0 )
   ::oDbfModel:reset()

   RETURN Self


METHOD HbQtBrowse:panEnd()
   LOCAL nOffset

   IF ::oHeaderView:sectionSize( ::colCount - 1 ) > ::oViewport:width()
      nOffSet := ::oHeaderView:sectionPosition( ::colCount - 1 )
   ELSE
      nOffSet := ::oHeaderView:sectionPosition( ::colCount - 1 ) + ;
                 ::oHeaderView:sectionSize( ::colCount - 1 ) - ::oViewport:width()
   ENDIF
   ::oHeaderView:setOffset( nOffSet )
   ::oFooterView:setOffset( nOffSet )
   ::oDbfModel:reset()

   RETURN Self


METHOD HbQtBrowse:panLeft()
   LOCAL nLeftVisible := ::oHeaderView:visualIndexAt( 1 )+1

   IF nLeftVisible > 1
      ::oHeaderView:setOffSet( ::oHeaderView:sectionPosition( nLeftVisible - 2 ) )
      ::oFooterView:setOffSet( ::oFooterView:sectionPosition( nLeftVisible - 2 ) )
   ENDIF
   ::oDbfModel:reset()

   RETURN Self


METHOD HbQtBrowse:panRight()

   ::TBRowse:panRight()

   RETURN Self


STATIC PROCEDURE _GENLIMITRTE()
   LOCAL oError := ErrorNew()

   oError:severity    := ES_ERROR
   oError:genCode     := EG_LIMIT
   oError:subSystem   := "TBROWSE"
   oError:subCode     := 0
   oError:description := hb_LangErrMsg( EG_LIMIT )
   oError:canRetry    := .F.
   oError:canDefault  := .F.
   oError:fileName    := ""
   oError:osCode      := 0

   Eval( ErrorBlock(), oError )
   __errInHandler()

   RETURN
