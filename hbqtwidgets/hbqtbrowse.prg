   /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"
#include "common.ch"

#include "hbtrace.ch"


#define __ev_mousepress_on_frozen__               31               /* Mousepress on Frozen */
#define __ev_mousepress_on_frozen_left__          32
#define __ev_mousepress_on_frozen_right__         33
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

#define __ev_tableViewBlock_main__                1501
#define __ev_tableViewBlock_left__                1502
#define __ev_tableViewBlock_right__               1503

#define __LETTER__                                "A"

#define HBQTCOL_TYPE_ICON                         1
#define HBQTCOL_TYPE_BITMAP                       2
#define HBQTCOL_TYPE_SYSICON                      3
#define HBQTCOL_TYPE_TEXT                         4
#define HBQTCOL_TYPE_FILEICON                     5
#define HBQTCOL_TYPE_FILEMINIICON                 6
#define HBQTCOL_TYPE_MULTILINETEXT                7

#define ISFROZEN( n )                             ( ascan( ::aLeftFrozen, n ) > 0 .OR. ascan( ::aRightFrozen, n ) > 0 )

STATIC s_itemFlags


INIT PROCEDURE initItemFlags
   s_itemFlags := Qt_ItemIsEnabled + Qt_ItemIsSelectable + Qt_ItemIsEditable
   RETURN


#if 0
STATIC PROCEDURE _GENLIMITRTE( cDesc )
   LOCAL oError := ErrorNew()

   hb_default( @cDesc, hb_LangErrMsg( EG_LIMIT ) )

   oError:severity    := ES_ERROR
   oError:genCode     := EG_LIMIT
   oError:subSystem   := "TBROWSE"
   oError:subCode     := 0
   oError:description := cDesc
   oError:canRetry    := .F.
   oError:canDefault  := .F.
   oError:fileName    := ""
   oError:osCode      := 0

   Eval( ErrorBlock(), oError )
   __errInHandler()

   RETURN
#endif

STATIC FUNCTION _SKIP_RESULT( xResult )
   RETURN iif( HB_ISNUMERIC( xResult ), Int( xResult ), 0 )


FUNCTION __hbqtBrowseActionsSlidingList( oHbQtBrowse, nLeftOrRight, nDuration, nWidth )
   LOCAL oSlidingList

   DEFAULT nLeftOrRight TO __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
   DEFAULT nDuration    TO nDuration

   WITH OBJECT oSlidingList := HbQtSlidingList():new( __hbqtAppWidget() )
      :setSlidingDirection( nLeftOrRight )
      :setDuration( nDuration )
      IF HB_ISNUMERIC( nWidth ) .AND. nWidth > 50
         :setWidth( nWidth )
      ENDIF
      :create()
      //
      //:addItem( "Print" , { "Print" , QPixmap( __hbqtImage( "print" ) ) }, {|| oHbQtBrowse:print()  } )
      //:addItem( "Search", { "Search", QPixmap( __hbqtImage( "find"  ) ) }, {|| oHbQtBrowse:search()  } )
      :addItem( "Up"      , { "Up"      , QPixmap( __hbqtImage( "go-up"     ) ) }, {|| oHbQtBrowse:up()        } )
      :addItem( "Down"    , { "Down"    , QPixmap( __hbqtImage( "go-down"   ) ) }, {|| oHbQtBrowse:down()      } )
      :addItem( "Top"     , { "Top"     , QPixmap( __hbqtImage( "go-top"    ) ) }, {|| oHbQtBrowse:goTop()     } )
      :addItem( "Bottom"  , { "Bottom"  , QPixmap( __hbqtImage( "go-bottom" ) ) }, {|| oHbQtBrowse:goBottom()  } )
      :addItem( "Left"    , { "Left"    , QPixmap( __hbqtImage( "go-prev"   ) ) }, {|| oHbQtBrowse:left()      } )
      :addItem( "Right"   , { "Right"   , QPixmap( __hbqtImage( "go-next"   ) ) }, {|| oHbQtBrowse:right()     } )
      :addItem( "Home"    , { "Home"    , QPixmap( __hbqtImage( "go-first"  ) ) }, {|| oHbQtBrowse:panHome()   } )
      :addItem( "End"     , { "End"     , QPixmap( __hbqtImage( "go-last"   ) ) }, {|| oHbQtBrowse:panEnd()    } )
   ENDWITH

   RETURN oSlidingList


FUNCTION __hbqtBrowseActionsScrollingToolbar( oLayout, oHbQtBrowse, nButtonHeight, nButtonWidth, aRGBIndicator, hOptions )
   LOCAL oToolbar

   DEFAULT nButtonHeight TO 50
   DEFAULT nButtonWidth  TO 50
   DEFAULT aRGBIndicator TO { 255,0,0 }

   WITH OBJECT oToolbar := HbQtScrollableToolbar():new()
      :setIndicatorsRGB( aRGBIndicator )
      :setButtonHeight( nButtonHeight )
      :setButtonWidth( nButtonWidth )
      :create( oLayout )
   ENDWITH
   WITH OBJECT oToolbar
      IF HB_ISHASH( hOptions ) .AND. hb_HHasKey( hOptions, "exit" ) .AND. HB_ISBLOCK( hOptions[ "exit" ] )
         :addToolbarButton( "EXIT"   , "Exit"            , "prv_undo"       , hOptions[ "exit" ] )
      ENDIF
      IF HB_ISHASH( hOptions ) .AND. hb_HHasKey( hOptions, "menuleft" ) .AND. HB_ISBLOCK( hOptions[ "menuleft" ] )
         :addToolbarButton( "OPTIONSLEFT", "Naviagte Columns", "vz-menu"    , hOptions[ "menuleft" ] )
      ENDIF
      :addToolbarButton( "UP"        , "Up One Row"      , "brw-up"         , {|| __pullBrowser( oHbQtBrowse ):up()       }, .F., .F., .T. )
      :addToolbarButton( "PAGEUP"    , "Up One Page"     , "brw-page-up"    , {|| HbQtActivateSilverLight( .T., "Loading" ),__pullBrowser( oHbQtBrowse ):pageUp()  , HbQtActivateSilverLight( .F. ) } )
      :addToolbarButton( "TOP"       , "First Row"       , "brw-top"        , {|| HbQtActivateSilverLight( .T., "Loading" ),__pullBrowser( oHbQtBrowse ):goTop()   , HbQtActivateSilverLight( .F. ) } )
      :addToolbarButton( "DOWN"      , "Down One Row"    , "brw-down"       , {|| __pullBrowser( oHbQtBrowse ):down()     }, .F., .F., .T. )
      :addToolbarButton( "PAGEDOWN"  , "Down One Page"   , "brw-page-down"  , {|| HbQtActivateSilverLight( .T., "Loading" ),__pullBrowser( oHbQtBrowse ):pageDown(), HbQtActivateSilverLight( .F. ) } )
      :addToolbarButton( "BOTTOM"    , "Last Row"        , "brw-bottom"     , {|| HbQtActivateSilverLight( .T., "Loading" ),__pullBrowser( oHbQtBrowse ):goBottom(), HbQtActivateSilverLight( .F. ) } )
      :addToolbarButton( "PANHOME"   , "First Column"    , "brw-far-left"   , {|| __pullBrowser( oHbQtBrowse ):panHome()  } )
      :addToolbarButton( "LEFT"      , "Left One Column" , "brw-left"       , {|| __pullBrowser( oHbQtBrowse ):left()     } )
      :addToolbarButton( "RIGHT"     , "Right One Column", "brw-right"      , {|| __pullBrowser( oHbQtBrowse ):right()    } )
      :addToolbarButton( "PANEND"    , "Last Column"     , "brw-far-right"  , {|| __pullBrowser( oHbQtBrowse ):panEnd()   } )
      IF HB_ISHASH( hOptions ) .AND. hb_HHasKey( hOptions, "menuright" ) .AND. HB_ISBLOCK( hOptions[ "menuright" ] )
         :addToolbarButton( "OPTIONSRIGHT", "More Options", "vz-menu"       , hOptions[ "menuright" ] )
      ENDIF
   ENDWITH
   RETURN oToolbar


STATIC FUNCTION __pullBrowser( oHbQtBrowse )
   RETURN iif( HB_ISBLOCK( oHbQtBrowse ), Eval( oHbQtBrowse ), oHbQtBrowse )


FUNCTION HbQtBrowseDB( nTop, nLeft, nBottom, nRight, hConfig )
   LOCAL oWnd, oLayout, oBrw, cAlias, n, cUnique, i, cKey, a_

   HB_SYMBOL_UNUSED( nTop + nLeft + nBottom + nRight )
   IF ! Used()
      RETURN .F.
   ENDIF
   cAlias := Alias()
   cUnique := __hbqtUniqueString( cAlias )

   DEFAULT hConfig TO {=>}
   hb_HCaseMatch( hConfig, .F. )

   WITH OBJECT oLayout := QHBoxLayout( oWnd )
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT oWnd := QWidget()
      :setLayout( oLayout )
      :resize( 600, 300 )
      :connect( QEvent_Close, {|| HbQtExit( cUnique, .T. ) } )
   ENDWITH
   WITH OBJECT oBrw := HbQtBrowseNew( 0, 0, 10, 10, oWnd, QFont( "Courier new", 10 ), .F. )
      :skipBlock             := {|n| ( cAlias )->( __skipped( n, .F. ) ) }
      :goTopBlock            := {| | ( cAlias )->( dbGoTop()      ) }
      :goBottomBlock         := {| | ( cAlias )->( dbGoBottom()   ) }
      :gotoBlock             := {|n| ( cAlias )->( dbGoto( n )    ) }

      :firstPosBlock         := {| | 1 }
      :lastPosBlock          := {| | iif( ( cAlias )->( IndexOrd() ) == 0, ( cAlias )->( lastRec()   ), ( cAlias )->( ordKeyCount()   ) ) }
      :posBlock              := {| | iif( ( cAlias )->( IndexOrd() ) == 0, ( cAlias )->( recNo()     ), ( cAlias )->( ordKeyNo()      ) ) }
      :goPosBlock            := {|n| iif( ( cAlias )->( IndexOrd() ) == 0, ( cAlias )->( dbGoto( n ) ), ( cAlias )->( ordKeyGoto( n ) ) ) }
      :phyPosBlock           := {| | iif( ( cAlias )->( IndexOrd() ) == 0, ( cAlias )->( recNo()     ), ( cAlias )->( ordKeyNo()      ) ) }
   ENDWITH
   oLayout:addWidget( oBrw:oWidget )

   IF hb_HHasKey( hConfig, "title" )
      oWnd:setWindowTitle( hConfig[ "title" ] )
   ENDIF
   IF hb_HHasKey( hConfig, "cursormoderow" )
      oBrw:cursorMode := HBQTBRW_CURSOR_ROW
   ENDIF
   IF hb_HHasKey( hConfig, "hscrollbar" )
      oBrw:horizontalScrollbar := .T.
   ENDIF
   IF hb_HHasKey( hConfig, "vscrollbar" )
      oBrw:verticalScrollbar := .T.
   ENDIF
   IF hb_HHasKey( hConfig, "toptoolbar" )
      oBrw:toolbar := .T.
   ENDIF
   IF hb_HHasKey( hConfig, "lefttoolbar" )
      oBrw:toolbarLeft := .T.
   ENDIF
   IF hb_HHasKey( hConfig, "statusbar" )
      oBrw:statusbar := .T.
   ENDIF
   IF hb_HHasKey( hConfig, "statusmessage" )
      oBrw:statusMessage := hConfig[ "statusmessage" ]
   ENDIF

   a_:={}
   FOR i := 1 to 50
      IF ( cKey := ( cAlias )->( IndexKey( i ) ) ) == ""
         EXIT
      ENDIF
      aadd( a_, { ( cAlias )->( OrdName( i ) ) + " : " + cKey, __indexOrdBlock( cAlias, i ) } )
   NEXT
   IF ! Empty( a_ )
      oBrw:indexes := a_
   ENDIF

   FOR n := 1 TO ( cAlias )->( FCount() )
      oBrw:AddColumn( HbQtColumnNew( FieldName( n ), __fieldBlock( cAlias, n ) ) )
   NEXT

   IF ( cAlias )->( Eof() )
      ( cAlias )->( dbGoTop() )
   ENDIF
   oBrw:ForceStable()

   oWnd:show()
   HbQtExec( cUnique )
   oWnd:setParent( QWidget() )
   oWnd := NIL

   RETURN NIL


STATIC FUNCTION __indexOrdBlock( cAlias, nOrder )
   RETURN {|oBrw| ( cAlias )->( dbSetOrder( nOrder ) ), oBrw:refreshAll(), oBrw:forceStable() }


STATIC FUNCTION __fieldBlock( cAlias, nField )
   RETURN {|x| iif( x == NIL, ( cAlias )->( fieldget( nField ) ), ( cAlias )->( FieldPut( nField, x ) ) ) }


STATIC FUNCTION __skipped( nRecs, lAppend )
   LOCAL nSkipped := 0

   IF LastRec() != 0
      IF nRecs == 0
         dbSkip( 0 )
      ELSEIF nRecs > 0 .AND. RecNo() != LastRec() + 1
         DO WHILE nSkipped < nRecs
            dbSkip()
            IF Eof()
               IF lAppend
                  ++nSkipped
               ELSE
                  dbSkip( -1 )
               ENDIF
               EXIT
            ENDIF
            ++nSkipped
         ENDDO
      ELSEIF nRecs < 0
         DO WHILE nSkipped > nRecs
            dbSkip( -1 )
            IF Bof()
               EXIT
            ENDIF
            --nSkipped
         ENDDO
      ENDIF
   ENDIF
   RETURN nSkipped


FUNCTION HbQtBrowseNew( nTop, nLeft, nBottom, nRight, oParent, oFont, lOnTop )
   LOCAL oDlg, oLay, oBrw

   __defaultNIL( @oFont , HbQtSet( _QSET_GETSFONT ) )
   __defaultNIL( @lOnTop, .F. )

   IF lOnTop
      oDlg := __hbqtGetADialogOnTopOf( oParent, nTop, nLeft, nBottom, nRight, NIL, oFont, .F. )

      oLay := QVBoxLayout( oDlg )
      oLay:setContentsMargins( 0,0,0,0 )
      oBrw := HbQtBrowse():new( nTop, nLeft, nBottom, nRight, oDlg, oFont )
      oLay:addWidget( oBrw:oWidget )
   ELSE
      oBrw := HbQtBrowse():new( nTop, nLeft, nBottom, nRight, oParent, oFont )
   ENDIF

   RETURN oBrw


CLASS HbQtBrowse INHERIT TBrowse

   DATA   oWidget

   METHOD destroy()

   /* Overloaded Methods */
   METHOD new( nTop, nLeft, nBottom, nRight, oParent, oFont )
   METHOD doConfigure()
   METHOD refreshWindow()
   METHOD rowCount()
   METHOD up()
   METHOD down()
   METHOD pageUp()
   METHOD pageDown()
   METHOD goTop()
   METHOD goBottom()
   METHOD goTo()
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
   METHOD refreshAll()
   METHOD refreshCurrent()
   METHOD stabilize()
   METHOD forceStable()
   METHOD setVisible()
   ACCESS rightVisible()                          INLINE ::oHeaderView:visualIndexAt( ::oViewport:width()-2 ) + 1
   ACCESS leftVisible()                           INLINE ::oHeaderView:visualIndexAt( 1 ) + 1

   ACCESS freeze                                  METHOD getFrozen            // get number of frozen columns
   ASSIGN freeze                                  METHOD freeze               // set number of columns to freeze

   /* HbQt Extentions */
   METHOD initializationBlock( bBlock )           SETGET
   METHOD navigationBlock( bBlock )               SETGET

   METHOD gotoBlock( bBlock )                     SETGET
   /* Xbase++ */
   METHOD firstPosBlock( bBlock )                 SETGET
   METHOD lastPosBlock( bBlock )                  SETGET
   METHOD phyPosBlock( bBlock )                   SETGET
   METHOD posBlock( bBlock )                      SETGET
   METHOD goPosBlock( bBlock )                    SETGET
   METHOD hitBottomBlock( bBlock )                SETGET
   METHOD hitTopBlock( bBlock )                   SETGET
   METHOD stableBlock( bBlock )                   SETGET
   METHOD verticalMovementBlock( bBlock )         SETGET
   METHOD horizontalMovementBlock( bBlock )       SETGET

   METHOD helpBlock( bBlock )                     SETGET
   METHOD addColumnsBlock( bBlock )               SETGET
   METHOD pressHeaderBlock( bBlock )              SETGET
   METHOD pressFrozenBlock( bBlock )              SETGET

   ACCESS rFreeze                                 METHOD getRFrozen           // get number of frozen columns
   ASSIGN rFreeze                                 METHOD rFreeze              // set number of columns to freeze at right side

   METHOD moveLeft()
   METHOD moveRight()
   METHOD moveHome()
   METHOD moveEnd()

   METHOD horizontalScrollbar                     SETGET
   METHOD verticalScrollbar                       SETGET
   METHOD cursorMode                              SETGET

   METHOD editCellEx( cPicture, cColor, bWhen, bValid, nKey, xValue )
   METHOD cellEditingTerminate()
   METHOD cellEditingFinishedBlock( bBlock )      SETGET

   METHOD editCell( cPicture, cColor, bWhen, bValid, nKey )
   METHOD edit( cTitle, lSaveOnLastGet, lDownAfterSave )
   METHOD editBlock( bBlock )                     SETGET
   METHOD search( xValue, cPicture, nMode )
   METHOD print( cPrinter, lOpenPrintDialog )
   METHOD help( xInfo, nTimeout )
   METHOD searchBlock( bBlock )                   SETGET
   METHOD searchExBlock( bBlock )                 SETGET
   METHOD searchEx( xValue )
   METHOD contextMenuBlock( bBlock )              SETGET
   ACCESS toolbar                                 INLINE ::oToolBar:isVisible()
   ASSIGN toolbar                                 METHOD manageToolbar
   ACCESS toolbarLeft                             INLINE ::oToolBarLeft:isVisible()
   ASSIGN toolbarLeft                             METHOD manageToolbarLeft
   ACCESS statusbar                               INLINE ::oStatusBar:isVisible()
   ASSIGN statusbar                               METHOD manageStatusbar
   ASSIGN statusMessage( cMessage )               INLINE ::oStatusLabel:setText( iif( HB_ISSTRING( cMessage ), cMessage, "" ) )
   ACCESS title                                   METHOD getTitle
   ASSIGN title                                   METHOD setTitle
   METHOD toColumn( cnColumn )
   ACCESS indexes                                 METHOD getIndexes
   ASSIGN indexes                                 METHOD setIndexes
   METHOD execIndex( cIndex )

   ACCESS editEnabled                             METHOD getEditable
   ASSIGN editEnabled                             METHOD setEditable
   ACCESS columnsComboEnabled                     METHOD getToColumnCombo
   ASSIGN columnsComboEnabled                     METHOD setToColumnCombo
   ACCESS printingEnabled                         METHOD getPrinting
   ASSIGN printingEnabled                         METHOD setPrinting
   ACCESS moveColumnsEnabled                      METHOD getMoveColumns
   ASSIGN moveColumnsEnabled                      METHOD setMoveColumns

   METHOD setFocus()                              INLINE ::oTableView:setFocus()
   METHOD scroll( nMode, nMSInterval )

   ACCESS widget                                  INLINE ::oTableView
   ACCESS searchText                              INLINE ::oSearchLabel:text()
   ASSIGN searchText( cText )                     INLINE ::oSearchLabel:setText( cText )

   METHOD showIndicator( rgbColorString )
   METHOD activateIndexMenu()
   METHOD activateColumnsMenu()

   METHOD skipRows( nRows )                       // INTERNAL - skips <nRows> back or forward : Resizing
   METHOD skipCols( nCols )                       // INTERNAL - skips <nCols> right or left   : Resizing

   METHOD dispFrames()                            // display TBrowse border, columns' headings, footings and separators
   METHOD dispRow( nRow )                         // display TBrowse data

   METHOD execute()                               INLINE iif( __objGetClsName( ::oParent ) == "QDIALOG", ::oParent:exec(), NIL )
   METHOD terminate()                             //INLINE iif( HB_ISOBJECT( ::oParent ), ::oParent:close(), NIL )
   METHOD exit()                                  INLINE __hbqtKeyboard( K_CTRL_ENTER, ::oTableView )
   METHOD getParent()                             INLINE ::oParent
   METHOD showCellContents()

   METHOD keyBoard( cnKey )                       INLINE __hbqtKeyboard( cnKey, ::oTableView )

   DATA   oGetList
   DATA   oGetObject
   METHOD setGetObject( oGetObject )              SETGET

PROTECTED:

   METHOD cellValue( nRow, nCol )                 /* Overloaded */
   METHOD cellColor( nRow, nCol )                 /* Overloaded */
   METHOD cellInBounds( nRow, nCol )              /* Not a TBrowse Method */

   /* HbQt Internal Methods */
   METHOD create()
   METHOD execSlot( nEvent, p1, p2, p3 )
   METHOD supplyInfo( nMode, nCall, nRole, nX, nY )
   METHOD compatColor( nColor )
   METHOD compatIcon( cIcon )
   METHOD compatBrush( nColor )

   METHOD addAColumn( cColumn )

   DATA   oParent
   DATA   oFont

   DATA   oToolbar, oToolbarLeft

   DATA   oDbfModel
   DATA   oModelIndex
   DATA   oVHeaderView
   DATA   oHeaderView
   DATA   oVScrollBar
   DATA   oHScrollBar
   DATA   oViewport
   DATA   pCurIndex

   DATA   lFirst                                  INIT   .T.
   DATA   nRowsInView                             INIT   1

   METHOD connect()

   METHOD setHorzOffset()
   METHOD setVertScrollBarRange( lPageStep )
   METHOD setHorzScrollBarRange( lPageStep )
   METHOD updateVertScrollBar()
   METHOD updatePosition()

   DATA   lHScroll                                INIT   .F.
   DATA   lVScroll                                INIT   .F.
   DATA   nCursorMode                             INIT   HBQTBRW_CURSOR_CELL

   DATA   lSizeCols                               INIT   .T.
   METHOD sizeCols                                SETGET

   DATA   softTrack                               INIT   .T.
   DATA   nHorzOffset                             INIT   -1
   DATA   lReset                                  INIT   .F.
   DATA   lHorzMove                               INIT   .F.

   DATA   oIndicator
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

   DATA   gridStyle                               INIT   Qt_DotLine //Qt_SolidLine

   DATA   nCellHeight                             INIT   20
   DATA   oDefaultCellSize
   METHOD setCellHeight( nCellHeight )
   METHOD setCurrentIndex( lReset )
   METHOD setIndex( qModelIndex )                 INLINE ::oTableView:setCurrentIndex( qModelIndex )
   METHOD getCurrentIndex()                       INLINE ::oDbfModel:index( ::rowPos - 1, ::colPos - 1 )
   ACCESS getDbfModel()                           INLINE ::oDbfModel

   METHOD manageKeyPress( oEvent )
   METHOD manageFrameResized()
   METHOD manageMouseDblClick( oMouseEvent )
   METHOD manageMousePress( oMouseEvent )
   METHOD manageMouseRelease( oMouseEvent )
   METHOD manageMouseWheel( oWheelEvent )
   METHOD manageCommitData( qWidget )
   METHOD manageScrollContents( nX, nY )
   METHOD manageColumnMoved( nLogicalIndex, nOldVisualIndex, nNewVisualIndex )
   METHOD manageVerticalMovement( nMode )

   DATA   hColors                                 INIT {=>}
   DATA   hIcons                                  INIT {=>}
   DATA   hBrushes                                INIT {=>}

   DATA   bGotoBlock                              INIT NIL
   DATA   bInitializationBlock                    INIT NIL
   DATA   bNavigationBlock                        INIT NIL
   DATA   bSearchBlock                            INIT NIL
   DATA   bSearchExBlock                          INIT NIL
   DATA   bEditBlock                              INIT NIL
   DATA   bFirstPosBlock                          INIT NIL
   DATA   bLastPosBlock                           INIT NIL
   DATA   bPhyPosBlock                            INIT NIL
   DATA   bPosBlock                               INIT NIL
   DATA   bGoPosBlock                             INIT NIL
   DATA   bHitBottomBlock                         INIT NIL
   DATA   bHitTopBlock                            INIT NIL
   DATA   bStableBlock                            INIT NIL
   DATA   bVerticalMovementBlock                  INIT NIL
   DATA   bHorizontalMovementBlock                INIT NIL
   DATA   bHelpBlock                              INIT NIL
   DATA   bAddColumnsBlock                        INIT NIL
   DATA   bPressHeaderBlock                       INIT NIL
   DATA   bPressFrozenBlock                       INIT NIL

   DATA   lVerticalMovementBlock                  INIT .F.
   DATA   lHorizontalMovementBlock                INIT .F.

   DATA   bCellEditingFinishedBlock               INIT NIL

   /* Editor specific calls */
   METHOD loadRow()
   METHOD saveRow()
   METHOD populateGets()
   METHOD mangageEditorKeyPress( oKeyEvent )
   //
   DATA   aOriginal
   DATA   aModified
   DATA   aCaptions
   DATA   lSaveOnLastGet
   DATA   lDownAfterSave
   DATA   aGetList
   DATA   aPosSize

   /* Toolbar Option Switches */
   DATA   lEditable                               INIT .T.
   DATA   lToColumnCombo                          INIT .T.
   DATA   lPrinting                               INIT .T.
   DATA   lMoveColumns                            INIT .T.

   METHOD execSearch( cSearch )
   METHOD setGETIncremental( oGet,oEdit,oBrw )
   METHOD execSearchByField()
   //
   DATA   oStatusBar
   DATA   oStatusLabel
   DATA   oSearchGet
   DATA   oSearchLabel
   DATA   isSearchActive                          INIT .F.
   DATA   xSearchValue
   DATA   aSearchList
   DATA   oSearchTimer
   DATA   nSearchMode

   METHOD execScroll( nMode )
   DATA   oScrollTimer
   DATA   nScrollMode

   METHOD manageContextMenu( oPos )
   //
   DATA   bContextMenuBlock
   DATA   oContextMenu

   METHOD buildActions()
   //
   DATA   oActHelp
   //
   DATA   oActSave
   DATA   oActEdit
   DATA   oActPrint
   DATA   oActSearch
   //
   DATA   oActGoUp
   DATA   oActGoTop
   DATA   oActGoDown
   DATA   oActGoBottom
   DATA   oActGoTo
   //
   DATA   oActPanHome
   DATA   oActLeft
   DATA   oActRight
   DATA   oActPanEnd
   //
   DATA   oActMoveToLeft
   DATA   oActMoveToRight
   DATA   oActMoveToFirst
   DATA   oActMoveToLast
   //
   DATA   oActToColumn
   DATA   oActToColumnM
   DATA   oColumnsButton
   DATA   oColumnsMenu
   DATA   oComboColumn
   DATA   oComboColumnM
   //
   DATA   oActFreezeLPlus
   DATA   oActFreezeLMinus
   DATA   oActFreezeRPlus
   DATA   oActFreezeRMinus
   //
   DATA   oActScroll
   DATA   oActStop
   //
   DATA   oActCopySel
   DATA   oActCellMemo
   //
   DATA   oActAddColumn
   DATA   oActDelColumn
   DATA   oAddColumnsButton
   DATA   oAddColumnsMenu
   //
   DATA   oActIndexes
   DATA   oComboIndexes
   DATA   oIndexButton
   DATA   oIndexMenu
   DATA   aIndexes                                INIT {}

   METHOD buildToolbar()
   METHOD stopAllTimers()

   METHOD printPreview( oPrinter )
   METHOD paintRequested( oPrinter )
   METHOD printReport( oPrinter )

   METHOD getTitle()
   METHOD setTitle( xTitle )
   METHOD drawTitle( oPainter, aTitle, nT, nRH, nCols, nPage, nML, aX, nF, aLen, nPxlX, nPxlW, nM, nAW, nLeading )
   DATA   xTitle
   DATA   oPenBlack
   DATA   oPrinter

   FRIEND FUNCTION __addColumnBlock()

   METHOD copySelectionToClipboard()

   DATA   oCellEditor
   DATA   oSilverLight
   DATA   bEscape
   METHOD cellEditingFinished( xValue, nColumn )

   DATA   lInitialized                            INIT .F.

   DATA   oContentsDlg, oContentsEditor, oContentsRect

   METHOD disConnect()

   DATA   aActColumns
   DATA   aActIndexes
   DATA   aActAddColumns

   ENDCLASS


METHOD HbQtBrowse:destroy()

   ::oParent                   := NIL

   ::oDbfModel                 := NIL
   ::oFooterModel              := NIL
   ::oLeftDbfModel             := NIL
   ::oLeftFooterModel          := NIL
   ::oRightDbfModel            := NIL
   ::oRightFooterModel         := NIL

   ::aIndexes                  := NIL
   ::lInitialized              := NIL
   ::xTitle                    := NIL
   ::pCurIndex                 := NIL
   ::lFirst                    := NIL
   ::nRowsInView               := NIL
   ::lHScroll                  := NIL
   ::lVScroll                  := NIL
   ::nCursorMode               := NIL
   ::lSizeCols                 := NIL
   ::softTrack                 := NIL
   ::nHorzOffset               := NIL
   ::lReset                    := NIL
   ::lHorzMove                 := NIL
   ::aLeftFrozen               := NIL
   ::aRightFrozen              := NIL
   ::nLeftFrozen               := NIL
   ::nRightFrozen              := NIL
   ::gridStyle                 := NIL
   ::nCellHeight               := NIL
   ::oDefaultCellSize          := NIL
   ::hColors                   := NIL
   ::hIcons                    := NIL
   ::hBrushes                  := NIL
   ::bGotoBlock                := NIL
   ::bInitializationBlock      := NIL
   ::bNavigationBlock          := NIL
   ::bSearchBlock              := NIL
   ::bSearchExBlock            := NIL
   ::bEditBlock                := NIL
   ::bFirstPosBlock            := NIL
   ::bLastPosBlock             := NIL
   ::bPhyPosBlock              := NIL
   ::bPosBlock                 := NIL
   ::bGoPosBlock               := NIL
   ::bHitBottomBlock           := NIL
   ::bHitTopBlock              := NIL
   ::bStableBlock              := NIL
   ::bVerticalMovementBlock    := NIL
   ::bHorizontalMovementBlock  := NIL
   ::bHelpBlock                := NIL
   ::bAddColumnsBlock          := NIL
   ::bPressHeaderBlock         := NIL
   ::bPressFrozenBlock         := NIL
   ::lVerticalMovementBlock    := NIL
   ::lHorizontalMovementBlock  := NIL
   ::bCellEditingFinishedBlock := NIL
   ::aOriginal                 := NIL
   ::aModified                 := NIL
   ::aCaptions                 := NIL
   ::lSaveOnLastGet            := NIL
   ::lDownAfterSave            := NIL
   ::aGetList                  := NIL
   ::aPosSize                  := NIL
   ::lEditable                 := NIL
   ::lToColumnCombo            := NIL
   ::lPrinting                 := NIL
   ::lMoveColumns              := NIL
   ::nScrollMode               := NIL
   ::isSearchActive            := NIL
   ::xSearchValue              := NIL
   ::aSearchList               := NIL
   ::nSearchMode               := NIL
   ::bContextMenuBlock         := NIL

   ::aActColumns               := NIL
   ::aActIndexes               := NIL
   ::aActAddColumns            := NIL

   ::oLeftVHeaderView          := NIL
   ::oLeftHeaderView           := NIL
   ::oRightVHeaderView         := NIL
   ::oRightHeaderView          := NIL

   ::oSearchGet                := NIL
   ::oSearchLabel              := NIL
   ::oSearchTimer              := NIL
   ::oScrollTimer              := NIL
   ::oContextMenu              := NIL
   ::oActHelp                  := NIL
   ::oActSave                  := NIL
   ::oActEdit                  := NIL
   ::oActPrint                 := NIL
   ::oActSearch                := NIL
   ::oActGoUp                  := NIL
   ::oActGoTop                 := NIL
   ::oActGoDown                := NIL
   ::oActGoBottom              := NIL
   ::oActGoTo                  := NIL
   ::oActPanHome               := NIL
   ::oActLeft                  := NIL
   ::oActRight                 := NIL
   ::oActPanEnd                := NIL
   ::oActMoveToLeft            := NIL
   ::oActMoveToRight           := NIL
   ::oActMoveToFirst           := NIL
   ::oActMoveToLast            := NIL
   ::oActToColumn              := NIL
   ::oActToColumnM             := NIL
   ::oColumnsButton            := NIL
   ::oColumnsMenu              := NIL
   ::oComboColumn              := NIL
   ::oComboColumnM             := NIL
   ::oActFreezeLPlus           := NIL
   ::oActFreezeLMinus          := NIL
   ::oActFreezeRPlus           := NIL
   ::oActFreezeRMinus          := NIL
   ::oActScroll                := NIL
   ::oActStop                  := NIL
   ::oActCopySel               := NIL
   ::oActCellMemo              := NIL
   ::oActAddColumn             := NIL
   ::oActDelColumn             := NIL
   ::oAddColumnsButton         := NIL
   ::oAddColumnsMenu           := NIL
   ::oActIndexes               := NIL
   ::oComboIndexes             := NIL
   ::oIndexButton              := NIL
   ::oIndexMenu                := NIL
   ::oPenBlack                 := NIL
   ::oPrinter                  := NIL
   ::oCellEditor               := NIL
   ::oSilverLight              := NIL
   ::oGetList                  := NIL
   ::oGetObject                := NIL
   ::oFont                     := NIL
   ::oModelIndex               := NIL
   ::oVHeaderView              := NIL
   ::oHeaderView               := NIL
   ::oVScrollBar               := NIL
   ::oHScrollBar               := NIL
   ::oViewport                 := NIL
   ::oContentsDlg              := NIL
   ::oContentsEditor           := NIL
   ::oContentsRect             := NIL

   ::oGridLayout               := NIL

   ::oIndicator                := NIL
   ::oToolbar                  := NIL
   ::oToolbarLeft              := NIL
   ::oTableView                := NIL
   ::oFooterView               := NIL
   ::oLeftView                 := NIL
   ::oLeftFooterView           := NIL
   ::oRightView                := NIL
   ::oRightFooterView          := NIL
   ::oSearchLabel              := NIL
   ::oVScrollBar               := NIL
   ::oHScrollBar               := NIL
   ::oStatusBar                := NIL
   IF HB_ISOBJECT( ::oWidget )
      ::oWidget:setParent( QWidget() )
   ENDIF
   ::oWidget                   := NIL

   Self                        := NIL

   RETURN NIL


METHOD HbQtBrowse:terminate()
   LOCAL oParent := ::oParent

   ::destroy()
   IF HB_ISOBJECT( oParent )
      oParent:close()
   ENDIF
   RETURN NIL


METHOD HbQtBrowse:new( nTop, nLeft, nBottom, nRight, oParent, oFont )

   ::TBrowse:new( nTop, nLeft, nBottom, nRight )

   hb_default( @oFont, HbQtSet( _QSET_GETSFONT ) )

   ::oParent := oParent
   ::oFont   := oFont

   ::colorSpec := "N/W*, N/W"                     /* DEFAULT TO GUI Colors */

   ::create()

   RETURN Self


METHOD HbQtBrowse:create()
   LOCAL oPal

   ::oWidget := QFrame( ::oParent )
   ::oWidget:setObjectName( __hbqtGetNextIdAsString( "TBROWSE" ) )

   /* Important here as other parts will be based on it */
   IF HB_ISOBJECT( ::oParent )
      ::oWidget:resize( ::oParent:width(), ::oParent:height() )
   ENDIF

   /* Toolbar actions */
   ::buildActions()

   /* .DBF Manipulation Model */
   ::oDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 141, t, role, x, y ) } )

   /* Subclass of QTableView */
   WITH OBJECT ::oTableView := HBQTableView()
      :hbSetBlock( {|p,p1,p2| ::execSlot( __ev_tableViewBlock_main__, p, p1, p2 ) } )
      :setFont( ::oFont )
      :setTabKeyNavigation( .T. )
      :setShowGrid( .T. )
      :setGridStyle( ::gridStyle )                /* to be based on column definition */
#ifdef __HBQTMOBILE__
      :setSelectionMode( QAbstractItemView_SingleSelection )
      :setSelectionBehavior( QAbstractItemView_SelectItems )
#else
      :setSelectionMode( QAbstractItemView_ContiguousSelection )
      :setSelectionBehavior( iif( ::cursorMode == HBQTBRW_CURSOR_ROW, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
#endif
      :setAlternatingRowColors( .T. )
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :setEditTriggers( QAbstractItemView_AnyKeyPressed )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :verticalHeader():hide()
      :setModel( ::oDbfModel )
      :horizontalScrollBar():hide()
      :setHorizontalScrollMode( QAbstractItemView_ScrollPerPixel )
      :setVerticalScrollMode( QAbstractItemView_ScrollPerPixel )
      :setCornerButtonEnabled( .F. )
   ENDWITH

   oPal := ::oTableView:palette()
   oPal:SetColor( QPalette_Inactive, QPalette_Highlight, QColor( 255,255,175 ) )
   ::oTableView:setPalette( oPal )

   WITH OBJECT ::oHScrollBar := QScrollBar()
      :setOrientation( Qt_Horizontal )
      :hide()
   ENDWITH

   WITH OBJECT ::oVScrollBar := QScrollBar()
      :setOrientation( Qt_Vertical )
      :hide()
   ENDWITH

   ::oViewport := ::oTableView:viewport()
#ifdef __HBQTMOBILE__
   WITH OBJECT ::oCellEditor := QLineEdit( iif( HB_ISOBJECT( __hbqtAppWidget() ), __hbqtAppWidget(), ::oViewport ) )
#else
   WITH OBJECT ::oCellEditor := QLineEdit( ::oViewport )
#endif
      ::oCellEditor:hide()
   ENDWITH

   /*  Horizontal Header Fine Tuning */
   WITH OBJECT ::oHeaderView := ::oTableView:horizontalHeader()
      :setHighlightSections( .F. )
      // :setMovable( .T. )                /* Needs more time TO investigae Qt behvior - first efforts have been futile */
   ENDWITH

   /*  Horizontal Footer */
   ::oFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 142, t, role, x, y ) } )
   //
   WITH OBJECT ::oFooterView := QHeaderView( Qt_Horizontal )
      :setHighlightSections( .F. )
      :setMinimumHeight( 20 )
      :setMaximumHeight( 20 )
      :setSectionResizeMode( QHeaderView_Fixed )
      :setFocusPolicy( Qt_NoFocus )
      :setModel( ::oFooterModel )
      :setFont( ::oFont )
      :hide()
   ENDWITH

   /*  Widget for ::setLeftFrozen( aColumns )  */
   ::buildLeftFreeze()
   /*  Widget for ::setRightFrozen( aColumns )  */
   ::buildRightFreeze()

   /* Toolbar hosting navigational actions */
   ::buildToolbar()

   WITH OBJECT ::oSearchLabel := QLabel()
      :setText( "" )
      :setAlignment( Qt_AlignHCenter )
      :setFont( ::oFont )
      :setStyleSheet( "background-color: blue; color: white;" )
      :hide()
   ENDWITH
   WITH OBJECT ::oStatusBar := QStatusBar( ::oWidget )
      WITH OBJECT ::oStatusLabel := QLabel( ::oStatusBar )
         :setFont( ::oFont )
         :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      ENDWITH
      :addPermanentWidget( ::oStatusLabel, 1 )
      :setSizeGripEnabled( .F. )
      :hide()
   ENDWITH
   WITH OBJECT ::oIndicator := QLabel( ::oWidget )
      :setMaximumHeight( 2 )
      :hide()
   ENDWITH

   /* Place all widgets in a Grid Layout */
   WITH OBJECT ::oGridLayout := QGridLayout()
      ::oWidget:setLayout( ::oGridLayout )

      :setContentsMargins( 0,0,0,0 )
      :setHorizontalSpacing( 0 )
      :setVerticalSpacing( 0 )

      :addWidget( ::oIndicator      , 0, 0, 1, 5 )
      :addWidget( ::oToolbar        , 1, 0, 1, 5 )
      :addWidget( ::oToolbarLeft    , 2, 0, 2, 1 )

      :addWidget( ::oLeftView       , 2, 1, 1, 1 )
      :addWidget( ::oLeftFooterView , 3, 1, 1, 1 )

      :addWidget( ::oTableView      , 2, 2, 1, 1 )
      :addWidget( ::oFooterView     , 3, 2, 1, 1 )

      :addWidget( ::oRightView      , 2, 3, 1, 1 )
      :addWidget( ::oRightFooterView, 3, 3, 1, 1 )

      :addWidget( ::oHScrollBar     , 4, 0, 1, 4 )

      :addWidget( ::oVScrollBar     , 2, 3, 2, 1 )
      :addWidget( ::oStatusBar      , 5, 0, 1, 5 )
      :addWidget( ::oSearchLabel    , 6, 0, 1, 5 )
   ENDWITH

   ::connect()
   RETURN Self


METHOD HbQtBrowse:refreshWindow()
   LOCAL nViewH, aVal, aCol, oSz

   IF Len( ::columns ) > 0
      oSz := QFontMetrics( ::oTableView:font() ):size( Qt_TextSingleLine, __LETTER__ )

      ::nCellHeight := oSZ:height() + 3

      nViewH := ::oWidget:height() - ;
                iif( ::oIndicator:isVisible() , ::oIndicator:height(), 0 ) - ;
                iif( ::oToolbar:isVisible()   , ::oToolbar:height(), 0 ) - ;
                iif( ::oHScrollBar:isVisible(), ::oHScrollBar:height(), 0 ) - ;
                iif( ::oStatusBar:isVisible() , ::oStatusBar:height(), 0 ) - ;
                ::oTableView:horizontalHeader():height()

      IF nViewH <= 0
         nViewH := 1
      ENDIF
      ::nRowsInView := Max( 1, Int( nViewH / ::nCellHeight ) )
      IF ( nViewH % ::nCellHeight ) > ( ::nCellHeight / 2 )
         ::nRowsInView++
      ENDIF

      /* create new record buffer */
      ASize( ::aCellStatus , ::nRowsInView )
      ASize( ::aDispStatus , ::nRowsInView )
      ASize( ::aCellValues , ::nRowsInView )
      ASize( ::aCellColors , ::nRowsInView )
      AFill( ::aCellStatus , .F. )
      AFill( ::aDispStatus , .T. )

      FOR EACH aVal, aCol IN ::aCellValues, ::aCellColors
         IF aVal == NIL
            aVal := Array( ::colCount )
         ELSE
            ASize( aVal, ::colCount )
         ENDIF
         IF aCol == NIL
            aCol := Array( ::colCount )
         ELSE
            ASize( aCol, ::colCount )
         ENDIF
      NEXT
      IF ::nRowPos > ::nRowsInView
         ::nRowPos := ::nRowsInView
      ELSEIF ::nRowPos < 1
         ::nRowPos := 1
      ENDIF
      ::refreshAll()
      ::setCellHeight( ::nCellHeight )
   ENDIF
   RETURN Self


METHOD HbQtBrowse:doConfigure()     /* Overloaded */
   LOCAL oCol, oSz
   LOCAL i, xVal, oFontMetrics, n, nLeftWidth, nwVal, nwHead
   LOCAL nMaxCellH, lShowFooter, oAct, cMenu
   LOCAL nPadding, nColumnWidth

   ::TBrowse:doConfigure()

   IF Len( ::columns ) <= 0  /* GUI Components are not in place yet */
      RETURN Self
   ENDIF

   IF ! ::lHScroll
      ::oHScrollBar:hide()
   ELSE
      ::oHScrollBar:show()
   ENDIF
   IF ! ::lVScroll
      ::oVScrollBar:hide()
   ELSE
      ::oVScrollBar:show()
   ENDIF

   lShowFooter := .F.
   FOR i := 1 TO ::colCount
      IF ! Empty( ::columns[ i ]:footing )
         lShowFooter := .T.
      ENDIF
   NEXT
   IF lShowFooter
      ::oLeftFooterView:show()
      ::oRightFooterView:show()
      ::oFooterView:show()
   ELSE
      ::oLeftFooterView:hide()
      ::oRightFooterView:hide()
      ::oFooterView:hide()
   ENDIF
#ifdef __HBQTMOBILE__
   ::oTableView:setSelectionBehavior( QAbstractItemView_SelectItems )
#else
   ::oTableView:setSelectionBehavior( iif( ::cursorMode == HBQTBRW_CURSOR_ROW, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
#endif
   ::oHeaderView:setSectionResizeMode( iif( ::lSizeCols, QHeaderView_Interactive, QHeaderView_Fixed ) )
   ::oFooterView:setSectionResizeMode( QHeaderView_Fixed )

   ::oLeftHeaderView:setSectionResizeMode( QHeaderView_Fixed )
   ::oLeftFooterView:setSectionResizeMode( QHeaderView_Fixed )

   ::oRightHeaderView:setSectionResizeMode( QHeaderView_Fixed )
   ::oRightFooterView:setSectionResizeMode( QHeaderView_Fixed )

   oFontMetrics := QFontMetrics( ::oTableView:font() )
   oSz := oFontMetrics:size( Qt_TextSingleLine, __LETTER__ )
   nPadding := 8

   IF .T.
      ::nCellHeight := oSZ:height() + 3

      nMaxCellH := ::nCellHeight + 5
      ::oHeaderView:setMaximumHeight( nMaxCellH )
      ::oHeaderView:setMinimumHeight( nMaxCellH )

      ::oLeftHeaderView:setMaximumHeight( nMaxCellH )
      ::oLeftHeaderView:setMinimumHeight( nMaxCellH )

      ::oRightHeaderView:setMaximumHeight( nMaxCellH )
      ::oRightHeaderView:setMinimumHeight( nMaxCellH )

      ::oFooterView     :setMaximumHeight( nMaxCellH )
      ::oLeftFooterView :setMaximumHeight( nMaxCellH )
      ::oRightFooterView:setMaximumHeight( nMaxCellH )
   ENDIF

   FOR i := 1 TO Len( ::columns )
      xVal := Transform( Eval( ::columns[ i ]:block ), ::columns[ i ]:picture )
      nwVal := oSZ:width() * Len( xVal )
      nwHead := oSZ:width() * Len( ::columns[ i ]:heading() )

      //::columns[ i ]:nColWidth := Max( nwVal + nPadding, nwHead )
      ::columns[ i ]:nColWidth := Max( nwVal, nwHead ) + nPadding

      ::oHeaderView:resizeSection( i-1, ::columns[ i ]:nColWidth )
      ::oFooterView:resizeSection( i-1, ::columns[ i ]:nColWidth )
   NEXT

   nLeftWidth := 0
   FOR n := 1 TO ::nLeftFrozen
      i := ::aLeftFrozen[ n ]
      IF ::columns[ i ]:nColWidth != NIL
         ::oLeftHeaderView:resizeSection( n-1, ::columns[ i ]:nColWidth )
         ::oLeftFooterView:resizeSection( n-1, ::columns[ i ]:nColWidth )
      ELSE
         xVal := transform( eval( ::columns[ i ]:block ), ::columns[ i ]:picture )
         nwVal := oSZ:width() * Len( xVal )
         nwHead := oSZ:width() * Len( ::columns[ i ]:heading() )
         //nColumnWidth := Max( nwVal + nPadding, nwHead )
         nColumnWidth := Max( nwVal, nwHead ) + nPadding

         ::oLeftHeaderView:resizeSection( n - 1, nColumnWidth )
         ::oLeftFooterView:resizeSection( n - 1, nColumnWidth )
      ENDIF
      nLeftWidth += ::oLeftHeaderView:sectionSize( n - 1 )
   NEXT
   ::oLeftView:setFixedWidth( nLeftWidth )
   ::oLeftFooterView:setFixedWidth( nLeftWidth )

   nLeftWidth := 0
   FOR n := 1 TO ::nRightFrozen
      i := ::aRightFrozen[ n ]
      IF ::columns[ i ]:nColWidth != NIL
         ::oRightHeaderView:resizeSection( n-1, ::columns[ i ]:nColWidth )
         ::oRightFooterView:resizeSection( n-1, ::columns[ i ]:nColWidth )
      ELSE
         xVal := transform( eval( ::columns[ i ]:block ), ::columns[ i ]:picture )
         nwVal := oSZ:width() * Len( xVal )
         nwHead := oSZ:width() * Len( ::columns[ i ]:heading() )
         //nColumnWidth := Max( nwVal + nPadding, nwHead )
         nColumnWidth := Max( nwVal, nwHead ) + nPadding

         ::oRightHeaderView:resizeSection( n-1, nColumnWidth )
         ::oRightFooterView:resizeSection( n-1, nColumnWidth )
      ENDIF
      nLeftWidth += ::oRightHeaderView:sectionSize( n - 1 )
   NEXT
   ::oRightView:setFixedWidth( 4 + nLeftWidth )
   ::oRightFooterView:setFixedWidth( 4 + nLeftWidth )

   IF ::nLeftFrozen == 0
      ::oLeftView:hide()
   ELSEIF ::nLeftFrozen > 0
      ::oLeftView:show()
   ENDIF

   IF ::nRightFrozen == 0
      ::oRightView:hide()
   ELSEIF ::nRightFrozen > 0
      ::oRightView:show()
   ENDIF

   FOR i := 1 TO ::colCount
      IF ISFROZEN( i )
         ::oTableView:hideColumn( i - 1 )
         ::oFooterView:setSectionHidden( i - 1, .T. )
      ELSE
         ::oTableView:showColumn( i - 1 )
         ::oFooterView:setSectionHidden( i - 1, .F. )
      ENDIF
   NEXT
#ifndef __HBQTMOBILE__
   ::refreshWindow()                              // on mobile it causes a lot of issues
#endif
   ::lStable     := .F.
   ::lFrames     := .T.
   ::nLastRow    := ::rowCount()
   ::nLastScroll := 0
   ::nLastPos    := 0

   /* Tell Qt to Reload Everything */
   ::oDbfModel:reset()
   ::oLeftDbfModel:reset()
   ::oRightDbfModel:reset()

   ::oComboColumnM:clear()
   FOR EACH oCol IN ::columns
      ::oComboColumnM:addItem( oCol:heading() )
   NEXT

   ::aActColumns := {}
   ::oColumnsMenu:clear()
   FOR EACH oCol IN ::columns
      cMenu := oCol:heading
      oAct := ::oColumnsMenu:addAction( cMenu )
      oAct:connect( "triggered(bool)", __toColumnBlock( Self, cMenu ) )
      AAdd( ::aActColumns, oAct )
   NEXT

   IF HB_ISBLOCK( ::horizontalMovementBlock )
      Eval( ::horizontalMovementBlock, 0, NIL, Self )
   ENDIF
   IF HB_ISBLOCK( ::verticalMovementBlock )
      Eval( ::verticalMovementBlock, 0, NIL, Self )
   ENDIF

   IF ! ::lInitialized
      ::lInitialized := .T.
      IF HB_ISBLOCK( ::bInitializationBlock )
         Eval( ::bInitializationBlock, NIL, NIL, Self )
      ENDIF
      ::horizontalScrollbar( ::lHScroll )
      ::verticalScrollbar( ::lVScroll )
   ENDIF
   RETURN Self


METHOD HbQtBrowse:stabilize()
   LOCAL nRowCount, nToMove, nMoved, lRead, lStat

   IF ::nConfigure != 0
      ::doConfigure()
   ENDIF

   IF ! ::lStable .OR. ::lInvalid .OR. ::lFrames .OR. ::lRefresh .OR. ;
      ::nMoveOffset != 0 .OR. ::nBufferPos != ::nRowPos

      nRowCount := ::rowCount

      IF ::lRefresh
         AFill( ::aCellStatus, .F. )
         ::nLastRow := nRowCount
         ::nLastScroll := 0
         ::lRefresh := .F.
      ENDIF

      ::setVisible()

      lRead := .F.
      IF ::nMoveOffset != 0
         ::setPosition()
         lRead := .T.
      ENDIF

      IF ::nLastScroll > 0
         FOR EACH lStat IN ::aCellStatus DESCEND
            IF ! lStat
               IF lRead
                  RETURN .F.
               ENDIF
               lRead := ::readRecord( lStat:__enumIndex() )
            ENDIF
         NEXT
      ELSE
         FOR EACH lStat IN ::aCellStatus
            IF ! lStat
               IF lRead
                  RETURN .F.
               ENDIF
               lRead := ::readRecord( lStat:__enumIndex() )
            ENDIF
         NEXT
      ENDIF

      IF ::nRowPos > ::nLastRow
         ::nRowPos := ::nLastRow
      ENDIF
      IF ::nBufferPos != ::nRowPos
         nToMove := ::nRowPos - ::nBufferPos
         nMoved := _SKIP_RESULT( Eval( ::bSkipBlock, nToMove ) )
         IF nToMove > 0
            IF nMoved < 0
               nMoved := 0
            ENDIF
         ELSEIF nToMove < 0
            nMoved := nToMove
         ELSE
            nMoved := 0
         ENDIF
         ::nBufferPos += nMoved
         ::nRowPos := ::nBufferPos
      ENDIF
      ::lStable := .T.
      ::lInvalid := .F.
   ENDIF

   RETURN .T.


METHOD HbQtBrowse:forceStable()
   DO WHILE ! ::stabilize()
      // QApplication():processEvents()
   ENDDO
   RETURN Self


METHOD HbQtBrowse:setVisible()
   RETURN Self


STATIC FUNCTION __toColumnBlock( obj, cMenu )
   RETURN {|| obj:toColumn( cMenu ) }


METHOD HbQtBrowse:connect()
   ::oWidget          : connect( QEvent_Resize                       , {|       | ::manageFrameResized(), .T.                          } )

   ::oTableView       : connect( QEvent_KeyPress                     , {|oKeyEvent| ::manageKeyPress( oKeyEvent )                      } )

   ::oLeftHeaderView  : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_columnheader_pressed__     , i    ) } )
   ::oLeftFooterView  : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )

   ::oRightHeaderView : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_columnheader_pressed__     , i    ) } )
   ::oRightFooterView : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_mousepress_on_frozen__     , i    ) } )

   ::oLeftView        : connect( "clicked(const QModelIndex&)"       , {|p      | ::execSlot( __ev_mousepress_on_frozen_left__, p    ) } )
   ::oRightView       : connect( "clicked(const QModelIndex&)"       , {|p      | ::execSlot( __ev_mousepress_on_frozen_right__, p   ) } )

   ::oTableView       : connect( "customContextMenuRequested(QPoint)", {|p      | ::manageContextMenu( p )                             } )

   ::oHScrollBar      : connect( "actionTriggered(int)"              , {|i      | ::execSlot( __ev_horzscroll_slidermoved__   , i    ) } )
   ::oHScrollBar      : connect( "sliderReleased()"                  , {|i      | ::execSlot( __ev_horzscroll_sliderreleased__, i    ) } )

   ::oVScrollBar      : connect( "actionTriggered(int)"              , {|i      | ::execSlot( __ev_vertscroll_via_user__      , i    ) } )
   ::oVScrollBar      : connect( "sliderReleased()"                  , {|i      | ::execSlot( __ev_vertscroll_sliderreleased__, i    ) } )

   ::oHeaderView      : connect( "sectionPressed(int)"               , {|i      | ::execSlot( __ev_columnheader_pressed__     , i    ) } )
#if 0
   ::oHeaderView      : connect( "sectionResized(int,int,int)"       , {|i,i1,i2| ::execSlot( __ev_headersec_resized__        , i, i1, i2 ) } )
   ::oHeaderView      : connect( "sectionMoved(int,int,int)"         , {|i,i1,i2| ::manageColumnMoved( i, i1, i2 )                     } )  /* Revisit Later */
#endif

   ::oTableView:verticalScrollbar():connect( "valueChanged(int)"     , {|y| iif( HB_ISOBJECT( ::oLeftView ), ::oLeftView:verticalScrollbar():setValue( y ), NIL ), ;
                                                                            iif( HB_ISOBJECT( ::oRightView ), ::oRightView:verticalScrollbar():setValue( y ), NIL ) } )
   RETURN Self


METHOD HbQtBrowse:disConnect()
   ::oWidget          : disconnect( QEvent_Resize                        )

   ::oTableView       : disconnect( QEvent_KeyPress                      )

   ::oLeftHeaderView  : disconnect( "sectionPressed(int)"                )
   ::oLeftFooterView  : disconnect( "sectionPressed(int)"                )

   ::oRightHeaderView : disconnect( "sectionPressed(int)"                )
   ::oRightFooterView : disconnect( "sectionPressed(int)"                )

   ::oLeftView        : disconnect( "clicked(const QModelIndex&)"        )
   ::oRightView       : disconnect( "clicked(const QModelIndex&)"        )

   ::oTableView       : disconnect( "customContextMenuRequested(QPoint)" )

   ::oHScrollBar      : disconnect( "actionTriggered(int)"               )
   ::oHScrollBar      : disconnect( "sliderReleased()"                   )

   ::oVScrollBar      : disconnect( "actionTriggered(int)"               )
   ::oVScrollBar      : disconnect( "sliderReleased()"                   )

   ::oHeaderView      : disconnect( "sectionPressed(int)"                )
#if 0
   ::oHeaderView      : disconnect( "sectionResized(int,int,int)"        )
   ::oHeaderView      : disconnect( "sectionMoved(int,int,int)"          )
#endif

   ::oTableView:verticalScrollbar():disconnect( "valueChanged(int)"      )

   RETURN Self


METHOD HbQtBrowse:buildLeftFreeze()

   ::oLeftDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 151, t, role, x, y ) } )
   WITH OBJECT ::oLeftView := HBQTableView()
      :setFont( ::oFont )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setTabKeyNavigation( .T. )
      :setShowGrid( .T. )
      :setGridStyle( ::gridStyle )   /* to be based on column definition */
      :setSelectionMode( QAbstractItemView_SingleSelection )
      :setSelectionBehavior( iif( ::cursorMode == HBQTBRW_CURSOR_ROW, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
      :setFocusPolicy( Qt_NoFocus )
      :setModel( ::oLeftDbfModel )
      :verticalHeader():hide()
   ENDWITH

   /*  Horizontal Header Fine Tuning */
   ::oLeftHeaderView := ::oLeftView:horizontalHeader()
   ::oLeftHeaderView:setHighlightSections( .F. )

   ::oLeftFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 152, t, role, x, y ) } )
   WITH OBJECT ::oLeftFooterView := QHeaderView( Qt_Horizontal )
      :setHighlightSections( .F. )
      :setMinimumHeight( 20 )
      :setMaximumHeight( 20 )
      :setSectionResizeMode( QHeaderView_Fixed )
      :setFocusPolicy( Qt_NoFocus )
      :setModel( ::oLeftFooterModel )
   ENDWITH

   RETURN Self


METHOD HbQtBrowse:buildRightFreeze()

   ::oRightDbfModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 161, t, role, x, y ) } )
   WITH OBJECT ::oRightView := HBQTableView()
      :setFont( ::oFont )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setTabKeyNavigation( .T. )
      :setShowGrid( .T. )
      :setGridStyle( ::gridStyle )   /* to be based on column definition */
      :setSelectionMode( QAbstractItemView_SingleSelection )
      :setSelectionBehavior( iif( ::cursorMode == HBQTBRW_CURSOR_ROW, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
      :setModel( ::oRightDbfModel )
      :verticalHeader():hide()
   ENDWITH

   /*  Horizontal Header Fine Tuning */
   ::oRightHeaderView := ::oRightView:horizontalHeader()
   ::oRightHeaderView:setHighlightSections( .F. )

   /*  Horizontal Footer */
   ::oRightFooterModel := HBQAbstractItemModel( {|t,role,x,y| ::supplyInfo( 162, t, role, x, y ) } )
   WITH OBJECT ::oRightFooterView := QHeaderView( Qt_Horizontal )
      :setHighlightSections( .F. )
      :setMinimumHeight( 20 )
      :setMaximumHeight( 20 )
      :setSectionResizeMode( QHeaderView_Fixed )
      :setFocusPolicy( Qt_NoFocus )
      :setModel( ::oRightFooterModel )
   ENDWITH

   RETURN Self


METHOD HbQtBrowse:copySelectionToClipboard()
   LOCAL oSelModel := ::oTableView:selectionModel()
   LOCAL aRows := {}, aCols := {}, aData := {}, a_
   LOCAL i, j, s, nRow
// LOCAL oSelection := oSelModel:selection()

   nRow := ::rowPos

   FOR i := 0 TO ::rowCount - 1
      IF oSelModel:rowIntersectsSelection( i, QModelIndex() )
         AAdd( aRows, i + 1 )
      ENDIF
   NEXT
   IF Empty( aRows )
      RETURN Self
   ENDIF

   FOR i := 0 TO ::colCount - 1
      IF oSelModel:columnIntersectsSelection( i, QModelIndex() )
         AAdd( aCols, i + 1 )
      ENDIF
   NEXT
   IF Empty( aCols )
      RETURN Self
   ENDIF

   FOR i := 1 TO Len( aRows )
      IF i == 1
         a_:= {}
         FOR j := 1 TO Len( aCols )
            AAdd( a_, ::getColumn( aCols[ j ] ):heading )
         NEXT
         AAdd( aData, a_ )
      ENDIF

      ::rowPos := aRows[ i ]
      ::forceStable()

      a_:= {}
      FOR j := 1 TO Len( aCols )
         AAdd( a_, Eval( ::getColumn( aCols[ j ] ):block ) )
      NEXT
      AAdd( aData, a_ )
   NEXT

   // oSelModel:Select( oSelection, 0x0002 /*QItemSelectionModel_Select*/ )

   ::rowPos := nRow
   ::forceStable()

   IF ! Empty( aData )
      s := Array2CSV( aData )
      QClipboard():setText( s )
   ENDIF

   RETURN Self


STATIC FUNCTION Array2CSV( aArray )
   LOCAL i, s
   LOCAL nRows := len( aArray )
   LOCAL nCols := len( aArray[ 1 ] )
   LOCAL aTyp  := array( nCols )
   LOCAL aCsv  := {}

   s := ''
   aeval( aArray[ 1 ], {|e, j| s += X2Csv( e, "C" ) + if( j == nCols, '', Chr( K_TAB )/*','*/ ) } )
   aadd( aCsv, s )

   aeval( aArray[ 2 ], {|e,i| aTyp[ i ] := valtype( e ) } )

   FOR i := 2 TO nRows
      s := ''
      aeval( aArray[ i ], {|e, j| s += X2Csv( e, aTyp[ j ] ) + if( j == nCols, '', Chr( K_TAB )/*','*/ ) } )
      aadd( aCsv, s )
   NEXT

   s := ''
   AEval( aCsv, {|e| s += e + hb_eol() } )

   RETURN s


STATIC FUNCTION X2Csv( x, cTyp )

   DO CASE
   CASE cTyp == 'C'
      RETURN x
   CASE cTyp == 'N'
      RETURN LTrim( Str( x ) )
   CASE cTyp == 'D'
      RETURN DToC( x )
   CASE cTyp == 'L'
      RETURN iif( x, 'Yes','No' )
   ENDCASE

   RETURN ""


METHOD HbQtBrowse:manageMouseDblClick( oMouseEvent )

   ::stopAllTimers()

   IF HB_ISBLOCK( ::bNavigationBlock )
      SWITCH oMouseEvent:button()
      CASE Qt_LeftButton
         Eval( ::bNavigationBlock, K_LDBLCLK, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_RightButton
         Eval( ::bNavigationBlock, K_RDBLCLK, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_MidButton
         Eval( ::bNavigationBlock, K_MDBLCLK, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      ENDSWITCH
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMouseWheel( oWheelEvent )

   ::stopAllTimers()

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

   IF oWheelEvent:orientation() == Qt_Vertical .AND. HB_ISBLOCK( ::bNavigationBlock )
      IF oWheelEvent:delta() > 0
         Eval( ::bNavigationBlock, K_MWBACKWARD, { oWheelEvent:x(), oWheelEvent:y() }, Self )
      ELSE
         Eval( ::bNavigationBlock, K_MWFORWARD , { oWheelEvent:x(), oWheelEvent:y() }, Self )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMousePress( oMouseEvent )

   ::stopAllTimers()

   ::oModelIndex := ::oTableView:indexAt( oMouseEvent:pos() )
   IF ::oModelIndex:isValid()
      ::skipRows( ( ::oModelIndex:row() + 1 ) - ::rowPos )
      ::skipCols( ( ::oModelIndex:column() + 1 ) - ::colPos )
   ENDIF

   IF HB_ISBLOCK( ::bNavigationBlock )
      SWITCH oMouseEvent:button()
      CASE Qt_LeftButton
         Eval( ::bNavigationBlock, K_LBUTTONDOWN, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_RightButton
         Eval( ::bNavigationBlock, K_RBUTTONDOWN, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_MidButton
         Eval( ::bNavigationBlock, K_MBUTTONDOWN, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      ENDSWITCH
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageMouseRelease( oMouseEvent )

   ::stopAllTimers()

   IF HB_ISBLOCK( ::bNavigationBlock )
      SWITCH oMouseEvent:button()
      CASE Qt_LeftButton
         Eval( ::bNavigationBlock, K_LBUTTONUP, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_RightButton
         Eval( ::bNavigationBlock, K_RBUTTONUP, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      CASE Qt_MidButton
         Eval( ::bNavigationBlock, K_MBUTTONUP, { oMouseEvent:x(), oMouseEvent:y() }, Self )
         EXIT
      ENDSWITCH
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageKeyPress( oEvent )

   LOCAL lHandelled := .F.
   LOCAL nKey, cText

   ::stopAllTimers()

   nKey := hbqt_qtEventToHbEvent( oEvent )
   IF nKey == K_ALT_F12
      ::showCellContents()
   ENDIF

   IF ::oSearchLabel:isVisible() .AND. ( ( nKey >= 32 .AND. nKey <= 127 ) .OR. nKey == K_BS .OR. nKey == K_ENTER )
      IF nKey == K_ENTER
         ::oSearchLabel:hide()
      ELSE
         IF nKey == K_BS
            cText := SubStr( ::oSearchLabel:text(), 1, Len( ::oSearchLabel:text() ) - 1 )
         ELSE
            cText := ::oSearchLabel:text() + Chr( nKey )
         ENDIF
         ::oSearchLabel:setText( cText )
         IF HB_ISBLOCK( ::searchExBlock )
            Eval( ::searchExBlock, cText, NIL, Self )
         ENDIF
         RETURN .T.
      ENDIF
   ENDIF

   IF nKey == K_CTRL_C                            /* Copy Selection */
      ::copySelectionToClipboard()
   ENDIF

   IF HB_ISBLOCK( SetKey( nKey ) )
      Eval( SetKey( nKey ) )
      RETURN .T.                                  /* Stop Propegation to parent */
   ENDIF

   IF HB_ISOBJECT( ::oGetObject )                 /* Browse is a part of GETLIST */
      IF nKey == K_CTRL_ENTER
         __hbqtKeyBoard( K_CTRL_ENTER, ::oGetObject:edit() )
         RETURN .T.
      ENDIF
   ENDIF

   IF HB_ISBLOCK( ::bNavigationBlock )
      lHandelled := Eval( ::bNavigationBlock, nKey, NIL, Self )
      IF ! HB_ISLOGICAL( lHandelled )
         lHandelled := .F.
      ENDIF
   ENDIF

   IF ! lHandelled
      ::applyKey( nKey )
   ENDIF

   RETURN .T.                                     /* Stop Propegation to parent */


METHOD HbQtBrowse:execSlot( nEvent, p1, p2, p3 )

   SWITCH nEvent
   CASE __ev_tableViewBlock_main__
      SWITCH p1
      CASE QEvent_MouseButtonPress
         ::manageMousePress( p2 )
         EXIT
      CASE QEvent_MouseButtonRelease
         ::manageMouseRelease( p2 )
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
   CASE __ev_mousepress_on_frozen_left__
      ::skipRows( ( p1:Row() + 1 ) - ::rowPos )
      IF HB_ISBLOCK( ::bPressFrozenBlock )
         Eval( ::bPressFrozenBlock, { p1:Row() + 1, p1:column() + 1 }, "left", Self )
      ENDIF
      EXIT
   CASE __ev_mousepress_on_frozen_right__
      ::skipRows( ( p1:Row() + 1 ) - ::rowPos )
      IF HB_ISBLOCK( ::bPressFrozenBlock )
         Eval( ::bPressFrozenBlock, { p1:Row() + 1, p1:column() + 1 }, "right", Self )
      ENDIF
      EXIT
   CASE __ev_mousepress_on_frozen__
      ::oTableView:setFocus( 0 )
      EXIT
   CASE __ev_horzscroll_via_qt__
      ::manageScrollContents( p1, p2 )
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
      IF HB_ISBLOCK( ::bNavigationBlock )
         Eval( ::bNavigationBlock, 0, NIL, Self )
      ENDIF
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
   CASE __ev_columnheader_pressed__
      IF p1 >= 0 .AND. p1 < ::colCount
         ::colPos := p1 + 1
         ::refreshCurrent()
         IF HB_ISBLOCK( ::pressHeaderBlock )
            Eval( ::pressHeaderBlock, p1 + 1, ::getColumn( p1 + 1 ):heading, Self )
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH

   RETURN .F.


METHOD HbQtBrowse:manageFrameResized()
   LOCAL nOff := 0
   LOCAL nRowPos := ::rowPos()
   LOCAL nColPos := ::colPos()

   ::refreshWindow()

   ::colPos := nColPos
   IF nRowPos > ::rowCount()
      nOff := nRowPos - ::rowCount()
      ::rowPos := ::rowCount()
   ENDIF
   IF nOff > 0
      ::skipRows( nOff )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageCommitData( qWidget )
   LOCAL cTxt  := qWidget:property( "text" ):toString()
   LOCAL oCol  := ::columns[ ::colPos ]
   LOCAL cTyp  := valtype( eval( oCol:block ) )

   HB_TRACE( HB_TR_DEBUG, cTxt, cTyp )
   DO CASE
   CASE cTyp == "C"
      Eval( oCol:block, cTxt )
   CASE cTyp == "N"
      Eval( oCol:block, val( cTxt ) )
   CASE cTyp == "D"
      Eval( oCol:block, ctod( cTxt ) )
   CASE cTyp == "L"
      Eval( oCol:block, cTxt $ "Yy" )
   ENDCASE

   ::refreshCurrent()
   ::oTableView:setFocus()

   RETURN Self


METHOD HbQtBrowse:manageScrollContents( nX, nY )
   HB_SYMBOL_UNUSED( nY )
   IF nX != 0
      ::setHorzOffset()
   ENDIF
   RETURN Self


METHOD HbQtBrowse:supplyInfo( nMode, nCall, nRole, nX, nY )

   IF nCall == HBQT_QAIM_headerData .AND. nX == Qt_Vertical
      RETURN NIL
   ENDIF

   IF nCall == HBQT_QAIM_flags
      RETURN s_itemFlags                          /* Qt_ItemIsEnabled + Qt_ItemIsSelectable + Qt_ItemIsEditable */
   ENDIF

   SWITCH nMode
   CASE 141                                       /* Main View Header|Data */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::colCount > 0
            ::forceStable()
            ::setHorzScrollBarRange( .T. )
         ENDIF
         RETURN ::colCount
      CASE HBQT_QAIM_rowCount
         IF ::colCount > 0
            ::forceStable()
            ::setVertScrollBarRange( .F. )
         ENDIF
         RETURN ::rowCount
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 0, nY+1, nX+1 )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 0, 0, nY+1 )
      ENDSWITCH
      EXIT

   CASE 142                                       /* Main View Footer */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::colCount > 0
            ::forceStable()
         ENDIF
         RETURN ::colCount
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 1, nY+1, nX+1 )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 1, 0, nY+1 )
      ENDSWITCH
      EXIT

   CASE 151                                       /* Left Frozen Header|Data */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nLeftFrozen
      CASE HBQT_QAIM_rowCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::rowCount
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 0, nY + 1, ::aLeftFrozen[ nX + 1 ] )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 0, 0, ::aLeftFrozen[ nY + 1 ] )
      ENDSWITCH
      EXIT

   CASE 152                                       /* Left Frozen Footer */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::nLeftFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nLeftFrozen
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 1, nY+1, ::aLeftFrozen[ nX+1 ] )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 1, 0, ::aLeftFrozen[ nY+1 ] )
      ENDSWITCH
      EXIT

   CASE 161                                       /* Right Frozen Header|Data */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nRightFrozen
      CASE HBQT_QAIM_rowCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::rowCount
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall, nRole, 0, nY + 1, ::aRightFrozen[ nX + 1 ] )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall, nRole, 0, 0, ::aRightFrozen[ nY + 1 ] )
      ENDSWITCH
      EXIT

   CASE 162                                       /* Right Frozen Footer */
      SWITCH nCall
      CASE HBQT_QAIM_columnCount
         IF ::nRightFrozen > 0
            ::forceStable()
         ENDIF
         RETURN ::nRightFrozen
      CASE HBQT_QAIM_data
         RETURN ::fetchColumnInfo( nCall,nRole, 1, nY+1, ::aRightFrozen[ nX+1 ] )
      CASE HBQT_QAIM_headerData
         RETURN ::fetchColumnInfo( nCall,nRole, 1, 0, ::aRightFrozen[ nY+1 ] )
      ENDSWITCH
      EXIT

   ENDSWITCH
   RETURN NIL


METHOD HbQtBrowse:fetchColumnInfo( nCall, nRole, nArea, nRow, nCol )

   SWITCH nCall
   CASE HBQT_QAIM_data
      SWITCH nRole
      CASE Qt_ForegroundRole
         IF ::cellInBounds( nRow, nCol )
            RETURN ::compatColor( __hbqtHbColorToQtValue( ::colorValue( ::cellColor( nRow, nCol )[ 1 ] ), Qt_ForegroundRole ) )
         ENDIF

      CASE Qt_BackgroundRole
         IF ::cellInBounds( nRow, nCol )
            RETURN ::compatColor( __hbqtHbColorToQtValue( ::colorValue( ::cellColor( nRow, nCol )[ 1 ] ), Qt_BackgroundRole ) )
         ENDIF

      CASE Qt_TextAlignmentRole
         RETURN ::columns[ nCol ]:dAlignment

      CASE Qt_SizeHintRole
         RETURN ::oDefaultCellSize

      CASE Qt_DecorationRole
         IF ::columns[ nCol ]:type == HBQTCOL_TYPE_FILEICON .AND. ::cellInBounds( nRow, nCol )
            RETURN ::compatIcon( ::cellValue( nRow, nCol ) )
         ENDIF
         RETURN NIL

      CASE Qt_EditRole
      CASE Qt_DisplayRole
         IF ::columns[ nCol ]:type == HBQTCOL_TYPE_FILEICON
            RETURN NIL
         ELSE
            IF nCall == Qt_EditRole               /* Never Reached */
               SWITCH ::columns[ nCol ]:valtype
               CASE "C" ; RETURN Trim( Eval( ::columns[ nCol ]:block ) )
               CASE "N" ; RETURN Val( Eval( ::columns[ nCol ]:block ) )
               CASE "D" ; RETURN DToC( Eval( ::columns[ nCol ]:block ) )
               CASE "L" ; RETURN iif( Eval( ::columns[ nCol ]:block ), "T", "F" )
               ENDSWITCH
               RETURN ""
            ELSE
               RETURN ::cellValue( nRow, nCol )
            ENDIF
         ENDIF
      ENDSWITCH
      RETURN NIL

   CASE HBQT_QAIM_headerData
      IF nArea == 0                               /* Header Area */
         SWITCH nRole
         CASE Qt_SizeHintRole      ; RETURN ::oDefaultCellSize
         CASE Qt_DisplayRole       ; RETURN ::columns[ nCol ]:heading
         CASE Qt_TextAlignmentRole ; RETURN ::columns[ nCol ]:hAlignment
         CASE Qt_ForegroundRole    ; RETURN ::compatColor( ::columns[ nCol ]:hFgColor )
         CASE Qt_BackgroundRole    ; RETURN ::compatColor( ::columns[ nCol ]:hBgColor )
         ENDSWITCH
      ELSE                                        /* Footer Area */
         SWITCH nRole
         CASE Qt_SizeHintRole      ; RETURN ::oDefaultCellSize
         CASE Qt_DisplayRole       ; RETURN ::columns[ nCol ]:footing
         CASE Qt_TextAlignmentRole ; RETURN ::columns[ nCol ]:fAlignment
         CASE Qt_ForegroundRole    ; RETURN ::compatColor( ::columns[ nCol ]:fFgColor )
         CASE Qt_BackgroundRole    ; RETURN ::compatColor( ::columns[ nCol ]:fBgColor )
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

METHOD HbQtBrowse:compatBrush( nColor )
   IF ! hb_hHasKey( ::hBrushes, nColor )
      ::hBrushes[ nColor ] := QBrush( nColor )
   ENDIF
   RETURN ::hBrushes[ nColor ]

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

   IF HB_ISOBJECT( ::oHScrollBar )
      WITH OBJECT ::oHScrollBar
         :setMinimum( 0 )
         :setMaximum( ::colCount - 1 )
         :setSingleStep( 1 )
         :setPageStep( 1 )
      ENDWITH
   ENDIF

   RETURN Self


METHOD HbQtBrowse:updatePosition()

   IF HB_ISBLOCK( ::goPosBlock )
      eval( ::goPosBlock, ::oVScrollBar:value() + 1 )
      ::refreshAll()
      ::forceStable()
      ::setCurrentIndex()
      ::manageVerticalMovement( -999 )
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


METHOD HbQtBrowse:horizontalScrollbar( lYes )

   IF HB_ISLOGICAL( lYes )
      ::lHScroll := lYes
      ::setUnstable()
      ::configure( 128 )
   ENDIF

   RETURN ::lHScroll


METHOD HbQtBrowse:verticalScrollbar( lYes )

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
      ::oTableView:setSelectionBehavior( iif( ::cursorMode == HBQTBRW_CURSOR_ROW, QAbstractItemView_SelectRows, QAbstractItemView_SelectItems ) )
      IF ::rowPos == 1
         ::down()
         IF ! ::hitBottom
            ::up()
         ENDIF
      ELSE
         ::up()
         IF ! ::hitTop
            ::down()
         ENDIF
      ENDIF
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

   FOR i := 0 TO ::nRowsInView - 1
      ::oTableView : setRowHeight( i, nCellHeight )
      IF ! Empty( ::oLeftView )
         ::oLeftView  : setRowHeight( i, nCellHeight )
      ENDIF
      IF ! Empty( ::oRightView )
         ::oRightView : setRowHeight( i, nCellHeight )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtBrowse:cellInBounds( nRow, nCol )

   IF nRow >= 1 .AND. nRow <= ::rowCount .AND. ;
      nCol >= 1 .AND. nCol <= ::colCount .AND. ;
      nRow <= Len( ::aCellValues ) .AND. nCol <= Len( ::aCellValues[ nRow ] )

      RETURN .T.
   ENDIF
   RETURN .F.


METHOD HbQtBrowse:cellColor( nRow, nCol )

   IF ::cellInBounds( nRow, nCol )
      RETURN ::aCellColors[ nRow, nCol ]
   ENDIF

   RETURN NIL


METHOD HbQtBrowse:cellValue( nRow, nCol )

   IF ::cellInBounds( nRow, nCol )
      RETURN ::aCellValues[ nRow, nCol ]
   ENDIF

   RETURN NIL


METHOD HbQtBrowse:gotoBlock( bBlock )
   IF bBlock != NIL
      ::bGotoBlock := __eInstVar53( Self, "GOTONBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bGotoBlock

METHOD HbQtBrowse:initializationBlock( bBlock )
   IF bBlock != NIL
      ::bInitializationBlock := __eInstVar53( Self, "INITIALIZATIONBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bInitializationBlock

METHOD HbQtBrowse:navigationBlock( bBlock )
   IF bBlock != NIL
      ::bNavigationBlock := __eInstVar53( Self, "NAVIGATIONBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bNavigationBlock

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

METHOD HbQtBrowse:horizontalMovementBlock( bBlock )
   IF bBlock != NIL
      ::bHorizontalMovementBlock := __eInstVar53( Self, "HORIZONTALMOVEMENTBLOCK", bBlock, "B", 1001 )
      ::lHorizontalMovementBlock := .T.
   ENDIF
   RETURN ::bHorizontalMovementBlock

METHOD HbQtBrowse:verticalMovementBlock( bBlock )
   IF bBlock != NIL
      ::bVerticalMovementBlock := __eInstVar53( Self, "VERTICALMOVEMENTBLOCK", bBlock, "B", 1001 )
      ::lVerticalMovementBlock := .T.
   ENDIF
   RETURN ::bVerticalMovementBlock

METHOD HbQtBrowse:editBlock( bBlock )
   IF bBlock != NIL
      ::bEditBlock := __eInstVar53( Self, "EDITBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bEditBlock

METHOD HbQtBrowse:cellEditingFinishedBlock( bBlock )
   IF bBlock != NIL
      ::bCellEditingFinishedBlock := __eInstVar53( Self, "CELLEDITINGFINISHEDBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bCellEditingFinishedBlock

METHOD HbQtBrowse:searchBlock( bBlock )
   IF bBlock != NIL
      ::bSearchBlock := __eInstVar53( Self, "SEARCHBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bSearchBlock

METHOD HbQtBrowse:searchExBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bSearchExBlock := __eInstVar53( Self, "SEARCHEXBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bSearchExBlock

METHOD HbQtBrowse:helpBlock( bBlock )
   IF bBlock != NIL
      ::bHelpBlock := __eInstVar53( Self, "HELPBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bHelpBlock

METHOD HbQtBrowse:addColumnsBlock( bBlock )
   IF bBlock != NIL
      ::bAddColumnsBlock := __eInstVar53( Self, "ADDCOLUMNSBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bAddColumnsBlock

METHOD HbQtBrowse:pressHeaderBlock( bBlock )
   IF bBlock != NIL
      ::bPressHeaderBlock := __eInstVar53( Self, "PRESSHEADERBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bPressHeaderBlock


METHOD HbQtBrowse:pressFrozenBlock( bBlock )
   IF bBlock != NIL
      ::bPressFrozenBlock := __eInstVar53( Self, "PRESSFROZENBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bPressFrozenBlock


METHOD HbQtBrowse:contextMenuBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
     ::bContextMenuBlock := __eInstVar53( Self, "CONTEXTMENUBLOCK", bBlock, "B", 1001 )
   ENDIF
   RETURN ::bContextMenuBlock


STATIC FUNCTION __execIndexBlock( obj, cIndex )
   RETURN {|| obj:execIndex( cIndex ) }

METHOD HbQtBrowse:getIndexes()
   RETURN ::aIndexes

METHOD HbQtBrowse:setIndexes( aIndexes )
   LOCAL aIndex, oAct
   IF HB_ISARRAY( aIndexes )
      ::aIndexes := aIndexes
      ::aActIndexes := {}
      ::oActIndexes:setVisible( .T. )
      ::oIndexMenu:clear()
      FOR EACH aIndex IN ::aIndexes
         oAct := ::oIndexMenu:addAction( aIndex[ 1 ] )
         oAct:connect( "triggered()", __execIndexBlock( Self, aIndex[ 1 ] ) )
         AAdd( ::aActIndexes, oAct )
      NEXT
   ENDIF
   RETURN ::aIndexes

METHOD HbQtBrowse:execIndex( cIndex )
   LOCAL n
   IF ( n := AScan( ::aIndexes, {|e_| e_[ 1 ] == cIndex } ) ) > 0
      IF HB_ISBLOCK( ::aIndexes[ n,2 ] )
         Eval( ::aIndexes[ n,2 ], Self )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtBrowse:setGetObject( oGetObject )
   IF HB_ISOBJECT( oGetObject )
      ::oGetObject := oGetObject
   ENDIF
   RETURN ::oGetObject


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
   ::forceStable()

   RETURN Self


METHOD HbQtBrowse:skipRows( nRows )
   LOCAL i

   IF nRows < 0
      FOR i := 1 TO abs( nRows )
         ::up()
         IF ::hitTop
            ::keyboard( K_CTRL_PGUP )
            EXIT
         ENDIF
      NEXT
   ELSEIF nRows > 0
      FOR i := 1 TO nRows
         ::down()
         IF ::hitBottom
            ::keyboard( K_CTRL_PGDN )
            EXIT
         ENDIF
      NEXT
   ENDIF

   RETURN Self


/* get number of frozen columns */
METHOD HbQtBrowse:getFrozen()

   IF ::nConfigure != 0
      ::doConfigure()
   ENDIF

   RETURN ::nLeftFrozen


METHOD HbQtBrowse:freeze( nColumns )              /* Overloaded */
   LOCAL i, n := ::nLeftFrozen

   nColumns := Max( 0, Int( nColumns ) )

   IF ! Empty( nColumns )
      IF nColumns + ::nRightFrozen < ::colCount
         ::aLeftFrozen := {}
         FOR i := 1 TO nColumns
            AAdd( ::aLeftFrozen, i )
         NEXT
      ENDIF
   ELSE
      ::aLeftFrozen := {}
   ENDIF
   ::nLeftFrozen := Len( ::aLeftFrozen )
   ::nFrozen := Len( ::aLeftFrozen )
   ::setUnstable()
   ::configure( 128 )
   ::forceStable()

   IF n < ::nFrozen
      ::Right()
      IF ::colPos < ::nFrozen
         ::Right()
      ENDIF
   ENDIF

   RETURN ::nLeftFrozen


METHOD HbQtBrowse:getRFrozen()                    /* Not a TBrowse METHOD  */

   IF ::nConfigure != 0
      ::doConfigure()
   ENDIF

   RETURN ::nRightFrozen


METHOD HbQtBrowse:rFreeze( nColumns )             /* Not a TBrowse METHOD  */
   LOCAL i, n := ::nRightFrozen

   ::nRightFrozen := Max( 0, Int( nColumns ) )
   IF ! Empty( ::nRightFrozen )
      IF ::nFrozen + ::nRightFrozen < ::colCount  /* At least 1 column must remain IN table view */
         ::aRightFrozen := {}
         FOR i := ::nRightFrozen TO 1 STEP -1
            AAdd( ::aRightFrozen, ::colCount - i + 1 )
         NEXT
      ENDIF
   ELSE
      ::aRightFrozen := {}
   ENDIF
   ::nRightFrozen := Len( ::aRightFrozen )
   ::setUnstable()
   ::configure( 128 )
   ::forceStable()
   IF n < ::nRightFrozen
      IF ::colPos > ::colCount - ::nRightFrozen
         ::Left()
      ENDIF
   ENDIF

   RETURN ::nRightFrozen


METHOD HbQtBrowse:rowCount()                      /* Overloaded */
   IF ::nConfigure != 0
      ::doConfigure()
   ENDIF
   RETURN ::nRowsInView


METHOD HbQtBrowse:refreshAll()

   ::TBrowse:refreshAll()
   ::setCurrentIndex( .T. )

   RETURN Self


METHOD HbQtBrowse:refreshCurrent()

   ::TBrowse:refreshCurrent()
   ::setCurrentIndex( .T. )

   RETURN Self


METHOD HbQtBrowse:up()
   LOCAL lReset := ::rowPos == 1

   ::TBrowse:up()

   ::forceStable()
   ::setCurrentIndex( lReset )
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_UP )

   RETURN Self

METHOD HbQtBrowse:down()
   LOCAL lReset := ::rowPos >= ::rowCount

   ::TBrowse:down()

   ::forceStable()
   ::setCurrentIndex( lReset )
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_DOWN )

   RETURN Self

METHOD HbQtBrowse:pageUp()

   ::TBrowse:pageUp()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_PGUP )

   RETURN Self

METHOD HbQtBrowse:pageDown()

   ::TBrowse:pageDown()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_PGDN )

   RETURN Self

METHOD HbQtBrowse:goTop()

   ::TBrowse:goTop()

   ::forceStable()
   ::setCurrentIndex( .T. )
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_CTRL_PGUP )

   RETURN Self

METHOD HbQtBrowse:goBottom()

   ::TBrowse:goBottom()

   ::refreshAll()
   ::forceStable()
   ::updateVertScrollBar()
   ::manageVerticalMovement( K_CTRL_PGDN )

   RETURN Self

METHOD HbQtBrowse:goTo()

   IF HB_ISBLOCK( ::gotoBlock() )
      IF Eval( ::gotoBlock(), NIL, NIL, Self )
         ::refreshAll()
         ::updateVertScrollBar()
         ::manageVerticalMovement( -1 )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageVerticalMovement( nMode )
   LOCAL xTmp

   IF HB_ISOBJECT( ::oLeftView )
      xTmp := ::oTableView:currentIndex():Row()
      ::oLeftView:setCurrentIndex( ::oLeftView:model():index( xTmp, 0 ) )
   ENDIF
   IF HB_ISOBJECT( ::oRightView )
      IF Empty( xTmp )
         xTmp := ::oTableView:currentIndex():Row()
      ENDIF
      ::oRightView:setCurrentIndex( ::oRightView:model():index( xTmp, 0 ) )
   ENDIF
   IF ::lVerticalMovementBlock
      Eval( ::bVerticalMovementBlock, nMode, NIL, Self )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:left()
   LOCAL n, nCol
   LOCAL lUpdate := .F.

   nCol := ::colPos

   IF nCol > 1
      DO WHILE --nCol >= 1
         IF ! ISFROZEN( nCol )
            lUpdate := .T.
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

      IF ::lHorizontalMovementBlock
         Eval( ::bHorizontalMovementBlock, 1, NIL, Self )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:right()
   LOCAL n, n1, n2, nLnWidth, nCol
   LOCAL lUpdate := .F.

   IF ::oCellEditor:isVisible()                   // Only one column can be edited at any given time.
      RETURN Self
   ENDIF

   IF ::colPos < ::colCount
      nCol := ::colPos

      DO WHILE ++nCol <= ::colCount
         IF !( ISFROZEN( nCol ) )
            lUpdate := .T.
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
            ::setCurrentIndex( .T. )
         ELSE
            ::setCurrentIndex( .F. )
         ENDIF

         ::oHScrollBar:setValue( ::colPos - 1 )

         IF ::lHorizontalMovementBlock
            Eval( ::bHorizontalMovementBlock, 2, NIL, Self )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:firstCol()
   LOCAL n, nCol
   LOCAL lUpdate := .F.

   nCol := 0

   DO WHILE ++nCol <= ::colCount
      IF !ISFROZEN( nCol )
         lUpdate := .T.
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
         ::setCurrentIndex( .T. )
      ELSE
         ::setCurrentIndex( .F. )
      ENDIF
      ::oHScrollBar:setValue( 0 )
      IF ::lHorizontalMovementBlock
         Eval( ::bHorizontalMovementBlock, 3, NIL, Self )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtBrowse:lastCol()
   LOCAL n, n1, n2, nCol
   LOCAL lUpdate := .F.

   nCol := ::colCount + 1

   DO WHILE --nCol >= 1
      IF !ISFROZEN( nCol )
         lUpdate := .T.
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
         ::setCurrentIndex( .T. )
      ELSE
         ::setCurrentIndex( .F. )
      ENDIF
      ::oHScrollBar:setValue( ::colCount - 1 )

      IF ::lHorizontalMovementBlock
         Eval( ::bHorizontalMovementBlock, 4, NIL, Self )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:home()

   ::colPos := max( 1, ::oHeaderView:visualIndexAt( 1 ) + 1 )
   ::setCurrentIndex( .T. )
   ::oHScrollBar:setValue( ::colPos - 1 )
   IF ::lHorizontalMovementBlock
      Eval( ::bHorizontalMovementBlock, 5, NIL, Self )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:end()

   ::nRightVisible := ::oHeaderView:visualIndexAt( ::oViewport:width()-2 ) + 1
   IF ::nRightVisible == 0
      ::nRightVisible := ::colCount
   ENDIF
   ::colPos := ::nRightVisible
   ::setCurrentIndex( .T. )
   ::oHScrollBar:setValue( ::colPos - 1 )
   IF ::lHorizontalMovementBlock
      Eval( ::bHorizontalMovementBlock, 6, NIL, Self )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:panHome()
   RETURN ::firstCol()


METHOD HbQtBrowse:panEnd()
   RETURN ::lastCol()


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


METHOD HbQtBrowse:manageColumnMoved( nLogicalIndex, nOldVisualIndex, nNewVisualIndex )
   LOCAL nMoved := nOldVisualIndex + 1
   LOCAL nAt    := nNewVisualIndex + 1
   LOCAL oCol   := ::getColumn( nMoved )

   HB_SYMBOL_UNUSED( nLogicalIndex )

HB_TRACE( HB_TR_ALWAYS, nMoved, ::getColumn( nMoved ):heading, nAt, ::getColumn( nAt ):heading )
   IF nMoved > nAt        /* Moved left */
      ::insColumn( nAt, oCol )
      ::configure()
      ::refreshAll()
      ::forceStable()
      ::delColumn( nMoved + 1 )
      ::configure()
      ::refreshAll()
      ::forceStable()
   ELSE                   /* Moved Right */
      ::insColumn( nAt, oCol )
      ::configure()
      ::refreshAll()
      ::forceStable()
      ::delColumn( nMoved )
      ::configure()
      ::refreshAll()
      ::forceStable()
   ENDIF

   RETURN Self

METHOD HbQtBrowse:moveLeft()
   LOCAL save_col, col_to_move := ::colPos

   IF col_to_move > 1
      save_col := ::getColumn( col_to_move )
      ::setColumn( col_to_move, ::getcolumn( col_to_move - 1 ) )
      ::setColumn( col_to_move - 1, save_col )
      QApplication():sendEvent( ::oTableView, QKeyEvent( QEvent_KeyPress, Qt_Key_Left, Qt_NoModifier ) )
   ENDIF

   RETURN col_to_move > 1


METHOD HbQtBrowse:moveRight()
   LOCAL save_col, col_to_move := ::colPos

   IF col_to_move < ::colCount
      save_col := ::getColumn( col_to_move )
      ::setColumn( col_to_move, ::getColumn( col_to_move + 1 ) )
      ::setColumn( col_to_move + 1, save_col )
      QApplication():sendEvent( ::oTableView, QKeyEvent( QEvent_KeyPress, Qt_Key_Right, Qt_NoModifier ) )
   ENDIF

   RETURN col_to_move < ::colCount


METHOD HbQtBrowse:moveHome()
   LOCAL save_col, col_to_move := ::colPos

   IF col_to_move > 1
      save_col := ::getColumn( col_to_move )
      ::delColumn( col_to_move )
      ::insColumn( 1, save_col )
      QApplication():sendEvent( ::oTableView, QKeyEvent( QEvent_KeyPress, Qt_Key_Home, Qt_ControlModifier ) )
   ENDIF

   RETURN col_to_move > 1


METHOD HbQtBrowse:showCellContents()
   LOCAL oLay
   LOCAL xValue := Eval( ::getColumn( ::colPos ):block )

   IF ! Empty( xValue ) .AND. HB_ISSTRING( xValue )
      IF Empty( ::oContentsDlg )
         ::oContentsDlg := QWidget( ::oWidget )
         ::oContentsDlg:setWindowFlags( Qt_Sheet )
         ::oContentsDlg:connect( QEvent_Close, {|| ::oContentsRect := QRect( ::oContentsDlg:x(), ::oContentsDlg:y(), ::oContentsDlg:width(), ::oContentsDlg:height() ) } )
         WITH OBJECT oLay := QHBoxLayout()
            :setContentsMargins( 0, 0, 0, 0 )
            ::oContentsEditor := QPlainTextEdit()
            oLay:addWidget( ::oContentsEditor )
            ::oContentsDlg:setLayout( oLay )
         ENDWITH
      ENDIF

      IF ! Empty( ::oContentsRect )
         ::oContentsDlg:setGeometry( 0, 0, ::oContentsRect:width(), ::oContentsRect:height() )
         ::oContentsDlg:move( ::oContentsRect:x(), ::oContentsRect:y() )
      ENDIF

      ::oContentsDlg:setWindowTitle( "Field Contents" )
      ::oContentsDlg:show()
      ::oContentsEditor:clear()
      ::oContentsEditor:setPlainText( xValue )
   ENDIF

   RETURN Self


METHOD HbQtBrowse:moveEnd()
   LOCAL save_col, col_to_move := ::colPos

   IF col_to_move < ::colCount
      save_col := ::getColumn( col_to_move )
      ::addColumn( save_col )
      ::delColumn( col_to_move )
      QApplication():sendEvent( ::oTableView, QKeyEvent( QEvent_KeyPress, Qt_Key_End, Qt_ControlModifier ) )
   ENDIF

   RETURN col_to_move < ::colCount


METHOD HbQtBrowse:editCell( cPicture, cColor, bWhen, bValid, nKey )
   LOCAL nRes, oSz
   LOCAL oRect   := ::oTableView:visualRect( ::getCurrentIndex() )
   LOCAL oPos    := ::oTableView:viewport():mapToGlobal( oRect:topLeft() )
   LOCAL oCol    := ::getColumn( ::colPos )
   LOCAL xValue  := Eval( oCol:block )
   LOCAL GetList := {}, SayList := {}
   LOCAL oDlg

   cPicture := iif( Empty( cPicture ), oCol:Picture, cPicture )
   IF Empty( cPicture )
      cPicture := ""
   ENDIF

   oDlg := QDialog( ::oTableView )
   oDlg:setWindowTitle( oCol:heading )

   @ 0,0 QGET xValue PICTURE cPicture ;
                     COLOR   iif( Empty( cColor ), "N/BG*", cColor ) ;
                     WHEN    {|oGet| iif( HB_ISBLOCK( bWhen ) , Eval( bWhen, oGet ) , iif( HB_ISBLOCK( oCol:preBlock ) , Eval( oCol:preBlock , oGet ), .T. ) ) } ;
                     VALID   {|oGet| iif( HB_ISBLOCK( bValid ), Eval( bValid, oGet ), iif( HB_ISBLOCK( oCol:postBlock ), Eval( oCol:postBlock, oGet ), .T. ) ) } ;
                     PROPERTIES {|oGET,oEdit| HB_SYMBOL_UNUSED( oGET ), oSz := oEdit:size(), oEdit:resize( oRect:width(), oRect:height() ) }

   QREAD PARENT oDlg LASTGETBLOCK {|| oDlg:done( 1 ) } NOFOCUSFRAME

   WITH OBJECT oDlg
      :setWindowFlags( Qt_Dialog + Qt_FramelessWindowHint )
      :setAttribute( Qt_WA_TranslucentBackground, .T. )
      :move( oPos:x - 6, oPos:y() )
      :connect( QEvent_Show, {||
                                 LOCAL oEdit := GetList[ 1 ]:edit()
                                 IF HB_ISNUMERIC( nKey )
                                    IF "K" $ Upper( cPicture )
                                       oEdit:clear()
                                       SWITCH ValType( xValue )
                                       CASE "C"
                                          oEdit:insert( Chr( nKey ) )
                                          oEdit:end( .F. )
                                          EXIT
                                       CASE "L"
                                          oEdit:insert( Chr( nKey ) )
                                          oEdit:end( .F. )
                                          EXIT
                                       CASE "D"
                                          oEdit:insert( Chr( nKey ) )
                                          EXIT
                                       CASE "N"
                                          IF nKey >= 48 .AND. nKey <= 57
                                             GetList[ 1 ]:varPut( Val( Chr( nKey ) ) )
                                             GetList[ 1 ]:display()
                                             oEdit:home( .F. )
                                             oEdit:setCursorPosition( 1 )
                                          ELSEIF nKey == 45
                                             oEdit:insert( "-" )
                                          ELSEIF nKey == 46
                                             oEdit:insert( "." )
                                          ENDIF
                                          EXIT
                                       ENDSWITCH
                                    ELSE
                                       SWITCH ValType( xValue )
                                       CASE "L"
                                          oEdit:home( .F. )
                                          oEdit:end( .T. )
                                          oEdit:insert( Chr( nKey ) )
                                          EXIT
                                       CASE "D"
                                          oEdit:home( .F. )
                                          oEdit:del()
                                          oEdit:home( .F. )
                                          oEdit:insert( Chr( nKey ) )
                                          EXIT
                                       CASE "C"
                                       CASE "N"
                                          oEdit:insert( Chr( nKey ) )
                                          EXIT
                                       ENDSWITCH
                                    ENDIF
                                 ENDIF
                                 oDlg:resize( oDlg:width() + oRect:width() - oSz:width(), oDlg:height() )
                                 oRect := NIL
                                 oSz := NIL
                                 RETURN .F.
                             } )
   ENDWITH

   nRes := oDlg:exec()
   HbQtClearGets( oDlg )
   oDlg:setParent( QWidget() )

   ::refreshCurrent()

   RETURN iif( nRes == 0, NIL, xValue )


STATIC FUNCTION __applyKey( oEdit, nKey, cPicture, xValue )

   MEMVAR GetList

   IF HB_ISNUMERIC( nKey )
      WITH OBJECT oEdit
         IF "K" $ Upper( cPicture )
            :clear()
            SWITCH ValType( xValue )
            CASE "C"
               :insert( Chr( nKey ) )
               :end( .F. )
               EXIT
            CASE "L"
               :insert( Chr( nKey ) )
               :end( .F. )
               EXIT
            CASE "D"
               :insert( Chr( nKey ) )
               EXIT
            CASE "N"
               IF nKey >= 48 .AND. nKey <= 57
                  :insert( Chr( nKey ) )
                  :home( .F. )
                  :setCursorPosition( 1 )
               ELSEIF nKey == 45
                  :insert( "-" )
               ELSEIF nKey == 46
                  :insert( "." )
               ENDIF
               EXIT
            ENDSWITCH
         ELSE
            SWITCH ValType( xValue )
            CASE "L"
               :home( .F. )
               :end( .T. )
               :insert( Chr( nKey ) )
               EXIT
            CASE "D"
               :home( .F. )
               :del()
               :home( .F. )
               :insert( Chr( nKey ) )
               EXIT
            CASE "C"
            CASE "N"
               :insert( Chr( nKey ) )
               EXIT
            ENDSWITCH
         ENDIF
      ENDWITH
   ENDIF
   RETURN NIL


METHOD HbQtBrowse:editCellEx( cPicture, cColor, bWhen, bValid, nKey, xValue )
   LOCAL GetList   := {}, SayList := {}
   LOCAL nColumn   := ::colPos
   LOCAL oCol      := ::getColumn( nColumn )
   LOCAL oRect     := ::oTableView:visualRect( ::getCurrentIndex() )
#ifdef __HBQTMOBILE__
   LOCAL nWidth    := oRect:width()
   LOCAL nHeight   := oRect:height()

   oRect:setX( ( ::widget():parent():width() - nWidth ) / 2 )
   oRect:setY( __hbqtPixelsByDPI( 40 ) )
   oRect:setWidth( nWidth )
   oRect:setHeight( nHeight )
#endif

   DEFAULT xValue TO Eval( oCol:block )

   ::bEscape := SetKey( K_ESC, {|| ::cellEditingTerminate() } )

   cPicture := iif( Empty( cPicture ), oCol:Picture, cPicture )
   IF Empty( cPicture )
      cPicture := ""
   ENDIF

   IF Empty( ::oSilverLight )
#ifdef __HBQTMOBILE__
      ::oSilverLight := HbQtSilverLight():new():create( "", QColor( 255,255,255 ), .F., { 0,0 }, __hbqtAppWidget() )
#else
      ::oSilverLight := HbQtSilverLight():new():create( "", QColor( 255,255,255 ), .F., { 0,0 }, ::widget():parent() )
#endif
   ENDIF
#ifdef __HBQTMOBILE__
   ::oSilverLight:activate( .T. )
#else
   ::oSilverLight:activate( , , , , ::widget() )
#endif

   WITH OBJECT ::oCellEditor
      :setGeometry( oRect )
      :setInputMask( "" )
      :show()
      :raise()
   ENDWITH

   @ 0,0 QGET xValue CONTROL ::oCellEditor ;
                     PICTURE cPicture ;
                     COLOR   iif( Empty( cColor ), "N/BG*", cColor ) ;
                     WHEN    {|oGet| iif( HB_ISBLOCK( bWhen  ), Eval( bWhen , oGet ), iif( HB_ISBLOCK( oCol:preBlock  ), Eval( oCol:preBlock , oGet ), .T. ) ) } ;
                     VALID   {|oGet| iif( HB_ISBLOCK( bValid ), Eval( bValid, oGet ), iif( HB_ISBLOCK( oCol:postBlock ), Eval( oCol:postBlock, oGet ), .T. ) ) }
   QREAD PARENT ::widget() NOFOCUSFRAME LASTGETBLOCK  {|xValue| ::cellEditingFinished( xValue, nColumn ) }

   ::oCellEditor:setFocus()
   __applyKey( ::oCellEditor, nKey, cPicture, xValue )
   RETURN NIL


METHOD HbQtBrowse:cellEditingFinished( xValue, nColumn )

   DEFAULT xValue TO iif( HB_ISOBJECT( GetActive() ), GetActive():varGet(), NIL )

   ::oCellEditor:hide()
   ::oSilverLight:deActivate()
   SetKey( K_ESC, ::bEscape )
   ::widget():setFocus()
   ::refreshCurrent()
   ::forceStable()

   IF HB_ISBLOCK( ::cellEditingFinishedBlock() )
      Eval( ::cellEditingFinishedBlock(), xValue, ::getColumn( nColumn ), Self )
   ELSE
      Eval( ::getColumn( ::colPos ), xValue )
   ENDIF
   RETURN Self


METHOD HbQtBrowse:cellEditingTerminate()
   ::oCellEditor:hide()
   ::widget():setFocus()
   ::refreshCurrent()
   ::forceStable()
   ::oSilverLight:deActivate()
   SetKey( K_ESC, ::bEscape )
   RETURN Self

#if 0
STATIC FUNCTION GetNoOfDecimals( xValue )
   LOCAL s, n

   s := Str( xValue )
   IF ( n := At( ".", s ) ) == 0
      RETURN 0
   ENDIF
   n := Len( SubStr( s, n + 1 ) )

   RETURN n
#endif

METHOD HbQtBrowse:getToColumnCombo()
   RETURN ::lToColumnCombo
METHOD HbQtBrowse:setToColumnCombo( lToColumnCombo )
   IF HB_ISLOGICAL( lToColumnCombo )
      ::lToColumnCombo := lToColumnCombo
      ::oActToColumn:setVisible( ::lToColumnCombo )
   ENDIF
   RETURN ::lToColumnCombo


METHOD HbQtBrowse:getEditable()
   RETURN ::lEditable
METHOD HbQtBrowse:setEditable( lEdit )
   IF HB_ISLOGICAL( lEdit )
      ::lEditable := lEdit
      ::oActEdit:setVisible( ::lEditable )
   ENDIF
   RETURN ::lEditable


METHOD HbQtBrowse:getPrinting()
   RETURN ::lPrinting
METHOD HbQtBrowse:setPrinting( lPrinting )
   IF HB_ISLOGICAL( lPrinting )
      ::lPrinting := lPrinting
      ::oActPrint:setVisible( ::lPrinting )
   ENDIF
   RETURN ::lPrinting


METHOD HbQtBrowse:getMoveColumns()
   RETURN ::lMoveColumns
METHOD HbQtBrowse:setMoveColumns( lMoveColumns )
   IF HB_ISLOGICAL( lMoveColumns )
      ::lMoveColumns := lMoveColumns
      ::oActMoveToFirst:setVisible( ::lMoveColumns )
      ::oActMoveToLeft :setVisible( ::lMoveColumns )
      ::oActMoveToRight:setVisible( ::lMoveColumns )
      ::oActMoveToLast :setVisible( ::lMoveColumns )
   ENDIF
   RETURN ::lMoveColumns

/*----------------------------------------------------------------------*/

METHOD HbQtBrowse:edit( cTitle, lSaveOnLastGet, lDownAfterSave )
   LOCAL oDlg, oVLayout, oScrollArea, oPos, oCol
   LOCAL oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oToolbar
   LOCAL oEditor, oFLayout, aFrame
   LOCAL k1, k2, k3, k4, k5
   LOCAL GetList := {}, SayList := {}

   hb_default( @cTitle, "Modify Row Data" )
   hb_default( @lSaveOnLastGet, .T. )
   hb_default( @lDownAfterSave, .T. )

   ::lSaveOnLastGet := lSaveOnLastGet
   ::lDownAfterSave := lDownAfterSave

   oDlg := QDialog( ::oWidget )
   oDlg:setWindowTitle( cTitle )

   oEditor := QWidget()
   oFLayout := QFormLayout()
   oEditor:setLayout( oFLayout )

   WITH OBJECT oScrollArea := QScrollArea( oDlg )
      :setWidget( oEditor )
      :horizontalScrollBar():setFocusPolicy( Qt_NoFocus )
      :verticalScrollBar():setFocusPolicy( Qt_NoFocus )
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH

   WITH OBJECT oVLayout := QVBoxLayout( oDlg )
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
      :addWidget( oScrollArea )
   ENDWITH

   WITH OBJECT oBtn1 := QToolButton( oDlg )
      :setText( "Save" )
      :setIcon( QIcon( __hbqtImage( "save3" ) ) )
      :setAutoRaise( .T. )
      :setTooltip( "Save editied record" )
      :connect( "clicked()", {||  ::saveRow() } )
   ENDWITH
   WITH OBJECT oBtn2 := QToolButton( oDlg )
      :setText( "Down" )
      :setIcon( QIcon( __hbqtImage( "go-down" ) ) )
      :setAutoRaise( .T. )
      :setTooltip( "Go down one record" )
      :connect( "clicked()", {||  ::down()    , ::loadRow(), ::populateGets() } )
   ENDWITH
   WITH OBJECT oBtn3 := QToolButton( oDlg )
      :setText( "Up" )
      :setIcon( QIcon( __hbqtImage( "go-up" ) ) )
      :setAutoRaise( .T. )
      :setTooltip( "Go up one record" )
      :connect( "clicked()", {||  ::up()      , ::loadRow(), ::populateGets() } )
   ENDWITH
   WITH OBJECT oBtn4 := QToolButton( oDlg )
      :setText( "Bttm" )
      :setIcon( QIcon( __hbqtImage( "go-bottom" ) ) )
      :setAutoRaise( .T. )
      :setTooltip( "Go bottom of browser" )
      :connect( "clicked()", {||  ::goBottom(), ::loadRow(), ::populateGets() } )
   ENDWITH
   WITH OBJECT oBtn5 := QToolButton( oDlg )
      :setText( "Top" )
      :setIcon( QIcon( __hbqtImage( "go-top" ) ) )
      :setAutoRaise( .T. )
      :setTooltip( "Go top of browser" )
      :connect( "clicked()", {||  ::goTop()   , ::loadRow(), ::populateGets() } )
   ENDWITH
   WITH OBJECT oToolbar := QToolBar()
      :setOrientation( Qt_Horizontal )
      :setIconSize( QSize( 12,12 ) )
      :setMovable( .F. )
      :setFloatable( .F. )
      :setFocusPolicy( Qt_NoFocus )
      //
      :addWidget( oBtn1 )
      :addWidget( oBtn2 )
      :addWidget( oBtn3 )
      :addWidget( oBtn4 )
      :addWidget( oBtn5 )
   ENDWITH

   oVLayout:addWidget( oToolbar )

   k1 := SetKey( K_ALT_S   , {|| oBtn1:click() } )
   k2 := SetKey( K_ALT_DOWN, {|| oBtn2:click() } )
   k3 := SetKey( K_ALT_UP  , {|| oBtn3:click() } )
   k4 := SetKey( K_ALT_PGDN, {|| oBtn4:click() } )
   k5 := SetKey( K_ALT_PGUP, {|| oBtn5:click() } )

   ::loadRow()

   FOR EACH oCol IN ::columns
      @ 1,1 QGET ::aModified[ oCol:__enumIndex() ] PICTURE oCol:Picture CAPTION oCol:heading ;
                           WHEN  {|| iif( HB_ISBLOCK( oCol:preBlock ) , Eval( oCol:preBlock ) , .T. ) } ;
                           VALID {|| iif( HB_ISBLOCK( oCol:postBlock ), Eval( oCol:postBlock ), .T. ) }
   NEXT

   QREAD oFLayout LASTGETBLOCK {|| ::saveRow() }

   ::aGetList := GetList

   oDlg:show()
   IF Empty( ::aPosSize )
      aFrame := __hbqtGetWindowFrameWidthHeight( oDlg )
      oPos := ::oWidget:mapToGlobal( QPoint( ::oWidget:width(), 0 ) )
      oDlg:move( oPos:x() + aFrame[ 1 ] / 2, oPos:y() - aFrame[ 2 ] + aFrame[ 1 ] / 2 )
      oDlg:resize( oDlg:width(), ::oWidget:height() )
   ELSE
      oDlg:setGeometry( ::aPosSize[ 3 ] )
      oDlg:move( ::aPosSize[ 1 ], ::aPosSize[ 2 ] )
   ENDIF
   oDlg:setWindowFlags( Qt_Dialog )
   oDlg:exec()

   ::aPosSize := {}
   ASize( ::aPosSize, 5 )
   ::aPosSize[ 1 ] := oDlg:pos():x()
   ::aPosSize[ 2 ] := oDlg:pos():y()
   ::aPosSize[ 3 ] := oDlg:geometry()
   ::aPosSize[ 4 ] := oDlg:width()
   ::aPosSize[ 5 ] := oDlg:height()

   SetKey( K_ALT_S   , k1 )
   SetKey( K_ALT_DOWN, k2 )
   SetKey( K_ALT_UP  , k3 )
   SetKey( K_ALT_PGDN, k4 )
   SetKey( K_ALT_PGUP, k5 )

   oDlg:setParent( QWidget() )

   RETURN NIL


METHOD HbQtBrowse:loadRow()
   LOCAL oCol

   ::aOriginal := {}
   ::aCaptions := {}
   FOR EACH oCol IN ::columns
      AAdd( ::aOriginal, Eval( oCol:block ) )
      AAdd( ::aCaptions, oCol:heading )
   NEXT
   ::aModified := AClone( ::aOriginal )

   RETURN NIL

METHOD HbQtBrowse:saveRow()
   LOCAL lHandelled, oCol

   IF HB_ISBLOCK( ::editBlock() )
      lHandelled := Eval( ::editBlock(), ::aModified, { ::aOriginal, ::aCaptions }, Self )  /* User can RETURN any type */
   ENDIF
   lHandelled := iif( HB_ISLOGICAL( lHandelled ), lHandelled, .F. )
   IF ! lHandelled
      FOR EACH oCol IN ::columns
         Eval( oCol:block, ::aModified[ oCol:__enumIndex() ] )
      NEXT
   ENDIF
   ::refreshCurrent()

   IF ::lDownAfterSave
      ::down()
      ::loadRow()
      ::populateGets()
   ENDIF

   RETURN NIL

METHOD HbQtBrowse:populateGets()
   LOCAL oGet

   FOR EACH oGet IN ::aGetList
      oGet:varPut( ::aModified[ oGet:__enumIndex() ] )
      oGet:display()
   NEXT

   RETURN NIL

METHOD HbQtBrowse:mangageEditorKeyPress( oKeyEvent )

   SWITCH oKeyEvent:key()
   CASE K_ALT_S
      ::save()
      EXIT
   CASE K_ALT_UP
      ::up()
      ::loadRow()
      ::populateGets()
      EXIT
   CASE K_ALT_DOWN
      ::down()
      ::loadRow()
      ::populateGets()
      EXIT
   CASE K_ALT_PGUP
      ::goTop()
      ::loadRow()
      ::populateGets()
      EXIT
   CASE K_ALT_PGDN
      ::goBottom()
      ::loadRow()
      ::populateGets()
      EXIT
   ENDSWITCH

   RETURN .F.


METHOD HbQtBrowse:searchEx( xValue )

   IF xValue == NIL                        /* Deactivate */
      ::oSearchLabel:setText( "" )
      ::oSearchLabel:hide()
   ELSEIF HB_ISCHAR( xValue ) .AND. HB_ISBLOCK( ::bSearchExBlock )
      ::oSearchLabel:setText( iif( HB_ISCHAR( xValue ), xValue, iif( HB_ISNUMERIC( xValue ), Chr( xValue ), "" ) ) )
      ::oSearchLabel:show()
      Eval( ::bSearchExBlock, ::oSearchLabel:text(), NIL, Self )
   ENDIF

   RETURN Self

METHOD HbQtBrowse:search( xValue, cPicture, nMode )
   LOCAL oCol := ::getColumn( ::colPos )
   LOCAL GetList := {} , SayList := {}, oDlg
   LOCAL aInfo, nCursor
   LOCAL k1,k2,k3,k4,k5,k6
   LOCAL oParent := ::oTableView:viewport()
   LOCAL oBtmCtr := oParent:mapToGlobal( QPoint( oParent:width() / 2, oParent:height() ) )

   ::stopAllTimers()
   IF ! HB_ISOBJECT( ::oSearchTimer )
      ::oSearchTimer := QTimer( ::oWidget )
      ::oSearchTimer:setInterval( 10 )
      ::oSearchTimer:connect( "timeout()", {|| ::execSearchByField() } )
   ENDIF

   IF xValue == NIL                               /* User has clicked on <search> button */
      IF HB_ISBLOCK( ::searchBlock )
         aInfo := Eval( ::searchBlock, NIL, NIL, Self )
      ENDIF
      IF ! HB_ISARRAY( aInfo )
         ::xSearchValue := Eval( oCol:block )
         cPicture       := oCol:picture
         nMode          := HBQTBRW_SEARCH_ONCE
      ELSE
         ASize( aInfo, 4 )
         ::xSearchValue := iif( aInfo[ 1 ] == NIL, Eval( oCol:block ), aInfo[ 1 ] )
         cPicture       := iif( aInfo[ 2 ] == NIL, oCol:picture, aInfo[ 2 ] )
         nMode          := iif( Empty( aInfo[ 3 ] ), HBQTBRW_SEARCH_ONCE, aInfo[ 3 ] )
      ENDIF
   ELSE
      ::xSearchValue := xValue
   ENDIF

   hb_default( @nMode, HBQTBRW_SEARCH_ONCE )
   ::nSearchMode := nMode

   oDlg := QDialog( oParent )

   IF nMode == HBQTBRW_SEARCH_INCREMENTAL
      nCursor := ::cursorMode
      ::cursorMode := HBQTBRW_CURSOR_ROW
      @ 1,2 QGET ::xSearchValue PICTURE cPicture PROPERTIES {|oGet,oEdit,oBrw| ::setGETIncremental( oGet,oEdit,oBrw ) }
      QREAD PARENT oDlg LASTGETBLOCK {|| oDlg:done( 1 ) }
   ELSEIF nMode == HBQTBRW_SEARCH_BYFIELD
      @ 1,2 QGET ::xSearchValue PICTURE cPicture
      QREAD PARENT oDlg LASTGETBLOCK {|| oDlg:done( 1 ) }
   ELSEIF nMode == HBQTBRW_SEARCH_ONCE
      @ 1,2 QGET ::xSearchValue PICTURE cPicture
      QREAD PARENT oDlg LASTGETBLOCK {|| oDlg:done( 1 ), ::execSearch() }
   ENDIF
   ::oSearchGet := GetList[ 1 ]

   k1 := SetKey( K_UP       , {|| ::up()       } )
   k2 := SetKey( K_DOWN     , {|| ::down()     } )
   k3 := SetKey( K_PGUP     , {|| ::pageUp()   } )
   k4 := SetKey( K_PGDN     , {|| ::pageDown() } )
   k5 := SetKey( K_CTRL_PGUP, {|| ::goTop()    } )
   k6 := SetKey( K_CTRL_PGDN, {|| ::goBottom() } )
   WITH OBJECT oDlg
      :setWindowFlags( Qt_Dialog + Qt_FramelessWindowHint )
      :setAttribute( Qt_WA_TranslucentBackground, .T. )
      :setStyleSheet( "background-color: lightblue;" )
      :connect( QEvent_Show, {|| oDlg:move( oBtmCtr:x() - ( oDlg:width() / 2 ), oBtmCtr:y() - ( oDlg:height() / 2 ) ) } )
      :exec()
      :disconnect( QEvent_Show )
      :setParent( QWidget() )
   ENDWITH
   oDlg := NIL
   oBtmCtr := NIL
   ::oTableView:setFocus()

   SetKey( K_UP       , k1 )
   SetKey( K_DOWN     , k2 )
   SetKey( K_PGUP     , k3 )
   SetKey( K_PGDN     , k4 )
   SetKey( K_CTRL_PGUP, k5 )
   SetKey( K_CTRL_PGDN, k6 )

   ::xSearchValue := iif( ValType( ::xSearchValue ) == "C", Trim( ::xSearchValue ), ::xSearchValue )

   ::cursorMode := nCursor

   IF nMode == HBQTBRW_SEARCH_INCREMENTAL         /* Inform appln that interface is done with */
      IF HB_ISBLOCK( ::searchBlock )
         Eval( ::searchBlock )
      ENDIF
   ELSEIF nMode == HBQTBRW_SEARCH_BYFIELD
      IF HB_ISBLOCK( ::searchBlock )
         ::oSearchTimer:start()
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtBrowse:setGETIncremental( oGet,oEdit,oBrw )
   HB_SYMBOL_UNUSED( oGet )
   HB_SYMBOL_UNUSED( oBrw )
   oEdit:connect( "textEdited(QString)", {|cText| ::execSearch( cText, ::colPos, Self ) } )
   RETURN Self

METHOD HbQtBrowse:execSearchByField()
   IF Eval( ::searchBlock, ::xSearchValue, ::nSearchMode, Self )
      ::oSearchTimer:stop()
   ELSE
      ::down()
      IF ::hitBottom
         ::oSearchTimer:stop()
      ENDIF
   ENDIF
   RETURN Self

METHOD HbQtBrowse:execSearch( cSearch )
   IF HB_ISBLOCK( ::searchBlock )
      hb_default( @cSearch, ::xSearchValue )
      Eval( ::searchBlock, cSearch, ::nSearchMode, Self )
   ENDIF
   RETURN .T.


METHOD HbQtBrowse:activateColumnsMenu()
   ::oAddColumnsButton:showMenu()
   RETURN Self


METHOD HbQtBrowse:activateIndexMenu()
   ::oIndexButton:showMenu()
   RETURN Self


METHOD HbQtBrowse:manageContextMenu( oPos )
   LOCAL oPoint := ::oTableView:mapToGlobal( QPoint( oPos ) )
   LOCAL oMenu

   IF HB_ISBLOCK( ::contextMenuBlock() )
      Eval( ::contextMenuBlock(), oPoint, NIL, Self )
   ELSE
      WITH OBJECT oMenu := QMenu( ::oWidget )
         :addAction( ::oActSearch )
         :addSeparator()
         :addAction( ::oActGoTop )
         :addAction( ::oActGoBottom )
         :addAction( ::oActPanHome )
         :addAction( ::oActPanEnd )
         :addSeparator()
         :addAction( ::oActCopySel )

         oMenu:exec( oPoint )

         :setParent( QWidget() )
      ENDWITH
   ENDIF

   RETURN NIL


METHOD HbQtBrowse:scroll( nMode, nMSInterval )
   LOCAL oDlg, nRes

   ::stopAllTimers()

   IF nMode == NIL
      oDlg := hbqtui_scroll( ::oWidget )
      oDlg:btnOK:connect( "clicked()", {|| oDlg:done( 1 ) } )
      oDlg:btnCancel:connect( "clicked()", {|| oDlg:done( 0 ) } )
      oDlg:rdwDnBtmTopDn:setChecked( .T. )
      nRes := oDlg:exec()
      IF nRes == 1
         nMode       := iif( oDlg:rdwDnBtmTopDn:isChecked(), 1, iif( oDlg:rdwDnBtm:isChecked(), 2, 3 ) )
         nMSInterval := oDlg:spinInterval:value()
      ENDIF
      oDlg:setParent( QWidget() )
      IF nRes == 0
         RETURN Self
      ENDIF
   ENDIF

   hb_default( @nMSInterval, 10 )

   ::nScrollMode := nMode

   IF ! HB_ISOBJECT( ::oScrollTimer )
      ::oScrollTimer := QTimer( ::oWidget )
      ::oScrollTimer:connect( "timeout()", {|| ::execScroll( ::nScrollMode ) } )
   ENDIF
   ::oScrollTimer:setInterval( nMSInterval )
   ::oScrollTimer:start()
   ::oActStop:setEnabled( .T. )

   RETURN Self


METHOD HbQtBrowse:help( xInfo, nTimeout )
   LOCAL aInfo

   IF xInfo == NIL .AND. HB_ISBLOCK( ::helpBlock )
      aInfo := Eval( ::helpBlock, NIL, NIL, Self )
      IF HB_ISARRAY( aInfo )
         IF Len( aInfo ) == 2 .AND. HB_ISNUMERIC( aInfo[ 2 ] )
            xInfo := aInfo[ 1 ]
            nTimeout := aInfo[ 2 ]
         ELSEIF Len( aInfo ) == 1
            xInfo := aInfo[ 1 ]
         ENDIF
      ENDIF
   ENDIF

   IF ! Empty( xInfo )
      hb_default( @nTimeout, 0 )

      IF HB_ISARRAY( xInfo )
         Alert( xInfo, , , , "Help - HbQtBrowse" )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:execScroll( nMode )

   SWITCH nMode
   CASE 1
      ::down()
      IF ::hitBottom
         ::goTop()
      ENDIF
      EXIT
   CASE 2
      ::down()
      EXIT
   CASE 3
      ::goBottom()
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtBrowse:stopAllTimers()

   ::oActStop:setEnabled( .F. )

   IF HB_ISOBJECT( ::oSearchTimer )
      IF ::oSearchTimer:isActive()
         ::oSearchTimer:stop()
      ENDIF
   ENDIF
   IF HB_ISOBJECT( ::oScrollTimer )
      IF ::oScrollTimer:isActive()
         ::oScrollTimer:stop()
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtBrowse:buildToolbar()

   WITH OBJECT ::oToolbar := QToolBar( ::oWidget )
      :setOrientation( Qt_Horizontal )
      :setIconSize( QSize( 12,12 ) )
      :setMovable( .F. )
      :setFloatable( .F. )
      :setFocusPolicy( Qt_NoFocus )
      //
      :addAction( ::oActHelp )
      :addAction( ::oActIndexes )
      :addAction( ::oActEdit )
      :addAction( ::oActPrint )
      :addAction( ::oActSearch )
      :addSeparator()
      :addAction( ::oActToColumn )
      //
      :addSeparator()
      :addAction( ::oActFreezeLPlus )
      :addAction( ::oActFreezeLMinus )
      :addAction( ::oActFreezeRPlus )
      :addAction( ::oActFreezeRMinus )
      :addSeparator()
      :addAction( ::oActScroll )
      :addAction( ::oActStop )
      :addSeparator()
      :addAction( ::oActAddColumn )
      :addAction( ::oActDelColumn )
      :addSeparator()
      :addAction( ::oActCopySel )
      :addAction( ::oActCellMemo )
      :addSeparator()

      :hide()
   ENDWITH

   WITH OBJECT ::oToolbarLeft := QToolBar( ::oWidget )
      :setOrientation( Qt_Vertical )
      :setIconSize( QSize( 12,12 ) )
      :setMovable( .F. )
      :setFloatable( .F. )
      :setFocusPolicy( Qt_NoFocus )
      //
      :addAction( ::oActPanHome )
      :addAction( ::oActLeft )
      :addAction( ::oActRight )
      :addAction( ::oActPanEnd )
      :addSeparator()
      :addAction( ::oActGoTop )
      :addAction( ::oActGoUp )
      :addAction( ::oActGoDown )
      :addAction( ::oActGoBottom )
      :addAction( ::oActGoTo )
      :addSeparator()
      :addAction( ::oActMoveToFirst )
      :addAction( ::oActMoveToLeft )
      :addAction( ::oActMoveToRight )
      :addAction( ::oActMoveToLast )
      :addSeparator()

      :hide()
   ENDWITH

   RETURN Self


METHOD HbQtBrowse:buildActions()

   ::oColumnsMenu := QMenu()
   WITH OBJECT ::oColumnsButton := QToolButton()
      :setTooltip( "Scroll to column..." )
      :setIcon( QIcon( __hbqtImage( "select-column" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::oColumnsMenu )
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH
   WITH OBJECT ::oActToColumn := QWidgetAction( ::oWidget )
      :setDefaultWidget( ::oColumnsButton )
      :setTooltip( "Scroll to column..." )
   ENDWITH

   WITH OBJECT ::oComboColumnM := QComboBox()
      :setFocusPolicy( Qt_NoFocus )
      :setTooltip( "Scroll to column..." )
      :connect( "activated(QString)", {|cColumn| ::toColumn( cColumn ) } )
   ENDWITH
   WITH OBJECT ::oActToColumnM := QWidgetAction( ::oWidget )
      :setDefaultWidget( ::oComboColumnM )
      :setTooltip( "Scroll to column..." )
   ENDWITH

   ::oIndexMenu := QMenu()
   WITH OBJECT ::oIndexButton := QToolButton()
      :setTooltip( "Indexes..." )
      :setIcon( QIcon( __hbqtImage( "sort" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::oIndexMenu )
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH
   WITH OBJECT ::oActIndexes := QWidgetAction( ::oWidget )
      :setDefaultWidget( ::oIndexButton )
      :setVisible( .F. )
   ENDWITH

   WITH OBJECT ::oActHelp := QAction( ::oWidget )
      :setText( "Help" )
      :setIcon( QIcon( __hbqtImage( "help" ) ) )
      :setTooltip( "Show Help" )
      :connect( "triggered()", {|| ::help() } )
   ENDWITH

   WITH OBJECT ::oActEdit := QAction( ::oWidget )
      :setText( "Edit" )
      :setIcon( QIcon( __hbqtImage( "data-edit" ) ) )
      :setTooltip( "Edit current record" )
      :connect( "triggered()", {|| ::edit() } )
   ENDWITH
   WITH OBJECT ::oActSave := QAction( ::oWidget )
      :setText( "Save" )
      :setIcon( QIcon( __hbqtImage( "save3" ) ) )
      :setTooltip( "Save current record" )
      :connect( "triggered()", {|| ::saveRow() } )
   ENDWITH
   WITH OBJECT ::oActPrint := QAction( ::oWidget )
      :setText( "Print" )
      :setIcon( QIcon( __hbqtImage( "print" ) ) )
      :setTooltip( "Print browser" )
      :connect( "triggered()", {|| ::print() } )
   ENDWITH
   WITH OBJECT ::oActSearch := QAction( ::oWidget )
      :setText( "Search" )
      :setIcon( QIcon( __hbqtImage( "find" ) ) )
      :setTooltip( "Search a value" )
      :connect( "triggered()", {|| ::search() } )
   ENDWITH

   WITH OBJECT ::oActGoUp := QAction( ::oWidget )
      :setText( "Up" )
      :setIcon( QIcon( __hbqtImage( "go-up" ) ) )
      :setTooltip( "Go to previou record" )
      :connect( "triggered()", {|| ::up() } )
   ENDWITH
   WITH OBJECT ::oActGoDown := QAction( ::oWidget )
      :setText( "Down" )
      :setIcon( QIcon( __hbqtImage( "go-down" ) ) )
      :setTooltip( "Go to the next record" )
      :connect( "triggered()", {|| ::down() } )
   ENDWITH
   WITH OBJECT ::oActGoTop := QAction( ::oWidget )
      :setText( "Top" )
      :setIcon( QIcon( __hbqtImage( "go-top" ) ) )
      :setTooltip( "Go to the top record" )
      :connect( "triggered()", {|| ::goTop() } )
   ENDWITH
   WITH OBJECT ::oActGoBottom := QAction( ::oWidget )
      :setText( "Bottom" )
      :setIcon( QIcon( __hbqtImage( "go-bottom" ) ) )
      :setTooltip( "Go to bottom record" )
      :connect( "triggered()", {|| ::goBottom() } )
   ENDWITH
   WITH OBJECT ::oActGoTo := QAction( ::oWidget )
      :setText( "GoTo" )
      :setIcon( QIcon( __hbqtImage( "go-jump" ) ) )
      :setTooltip( "Go to requested record" )
      :connect( "triggered()", {|| ::goto() } )
   ENDWITH

   WITH OBJECT ::oActLeft := QAction( ::oWidget )
      :setText( "Left" )
      :setIcon( QIcon( __hbqtImage( "go-prev" ) ) )
      :setTooltip( "To left column" )
      :connect( "triggered()", {|| ::left() } )
   ENDWITH
   WITH OBJECT ::oActRight := QAction( ::oWidget )
      :setText( "Right" )
      :setIcon( QIcon( __hbqtImage( "go-next" ) ) )
      :setTooltip( "To right column" )
      :connect( "triggered()", {|| ::right() } )
   ENDWITH
   WITH OBJECT ::oActPanHome := QAction( ::oWidget )
      :setText( "Home" )
      :setIcon( QIcon( __hbqtImage( "go-first" ) ) )
      :setTooltip( "Jump to left-most column" )
      :connect( "triggered()", {|| ::panHome() } )
   ENDWITH
   WITH OBJECT ::oActPanEnd := QAction( ::oWidget )
      :setText( "End" )
      :setIcon( QIcon( __hbqtImage( "go-last" ) ) )
      :setTooltip( "Jump to right-most column" )
      :connect( "triggered()", {|| ::panEnd() } )
   ENDWITH

   WITH OBJECT ::oActMoveToLeft := QAction( ::oWidget )
      :setText( "Move Left" )
      :setIcon( QIcon( __hbqtImage( "navigate-left" ) ) )
      :setTooltip( "Move current column left one column" )
      :connect( "triggered()", {|| ::moveLeft() } )
   ENDWITH
   WITH OBJECT ::oActMoveToRight := QAction( ::oWidget )
      :setText( "Move Right" )
      :setIcon( QIcon( __hbqtImage( "navigate-right" ) ) )
      :setTooltip( "Move current column right one column" )
      :connect( "triggered()", {|| ::moveRight() } )
   ENDWITH
   WITH OBJECT ::oActMoveToFirst := QAction( ::oWidget )
      :setText( "Move First" )
      :setIcon( QIcon( __hbqtImage( "navigate-left-most" ) ) )
      :setTooltip( "Move current column at first position" )
      :connect( "triggered()", {|| ::moveHome() } )
   ENDWITH
   WITH OBJECT ::oActMoveToLast := QAction( ::oWidget )
      :setText( "Move Last" )
      :setIcon( QIcon( __hbqtImage( "navigate-right-most" ) ) )
      :setTooltip( "Move current column at last position" )
      :connect( "triggered()", {|| ::moveEnd() } )
   ENDWITH

   WITH OBJECT ::oActFreezeLPlus := QAction( ::oWidget )
      :setText( "FreezePlus" )
      :setIcon( QIcon( __hbqtImage( "plus-1" ) ) )
      :setTooltip( "Freeze another column at left" )
      :connect( "triggered()", {|| ::freeze++ } )
   ENDWITH
   WITH OBJECT ::oActFreezeLMinus := QAction( ::oWidget )
      :setText( "FreezeMinus" )
      :setIcon( QIcon( __hbqtImage( "minus-1" ) ) )
      :setTooltip( "UnFreeze another column at left" )
      :connect( "triggered()", {|| ::freeze-- } )
   ENDWITH
   WITH OBJECT ::oActFreezeRPlus := QAction( ::oWidget )
      :setText( "FreezeRPlus" )
      :setIcon( QIcon( __hbqtImage( "plus-2" ) ) )
      :setTooltip( "Freeze another column at right" )
      :connect( "triggered()", {|| ::rfreeze++ } )
   ENDWITH
   WITH OBJECT ::oActFreezeRMinus := QAction( ::oWidget )
      :setText( "FreezeRMinus" )
      :setIcon( QIcon( __hbqtImage( "minus-2" ) ) )
      :setTooltip( "UnFreeze another column at right" )
      :connect( "triggered()", {|| ::rfreeze-- } )
   ENDWITH

   WITH OBJECT ::oActScroll := QAction( ::oWidget )
      :setText( "Scroll" )
      :setIcon( QIcon( __hbqtImage( "scroll" ) ) )
      :setTooltip( "Auto scroll" )
      :connect( "triggered()", {|| ::Scroll() } )
   ENDWITH
   WITH OBJECT ::oActStop := QAction( ::oWidget )
      :setText( "StopScroll" )
      :setIcon( QIcon( __hbqtImage( "stop" ) ) )
      :setTooltip( "Stop Auto Scrolling" )
      :connect( "triggered()", {|| ::stopAllTimers() } )
      :setEnabled( .F. )
   ENDWITH

   ::oAddColumnsMenu := QMenu()
   ::oAddColumnsMenu:connect( "aboutToShow()", {|| ::addAColumn() } )
   WITH OBJECT ::oAddColumnsButton := QToolButton()
      :setTooltip( "Add a Column..." )
      :setIcon( QIcon( __hbqtImage( "add-column" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::oAddColumnsMenu )
      :connect( "clicked()", {|| ::addAColumn() } )
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH
   WITH OBJECT ::oActAddColumn := QWidgetAction( ::oWidget )
      :setDefaultWidget( ::oAddColumnsButton )
      :setTooltip( "Add a Column..." )
   ENDWITH
   WITH OBJECT ::oActDelColumn := QAction( ::oWidget )
      :setText( "Delete Current Column" )
      :setIcon( QIcon( __hbqtImage( "delete-column" ) ) )
      :setTooltip( "Delete Current Column" )
      :connect( "triggered()", {|| iif( ::colCount > 1, ::delColumn( ::colPos ), NIL ), ::configure(), ::refreshAll(), ::forceStable() } )
   ENDWITH

   WITH OBJECT ::oActCopySel := QAction( ::oWidget )
      :setText( "Copy Selection" )
      :setIcon( QIcon( __hbqtImage( "copy" ) ) )
      :setTooltip( "Copy Selected Data to Clipboard" )
      :connect( "triggered()", {|| ::copySelectionToClipboard() } )
   ENDWITH

   WITH OBJECT ::oActCellMemo := QAction( ::oWidget )
      :setText( "Cell Contents Memo" )
      :setIcon( QIcon( __hbqtImage( "memo" ) ) )
      :setTooltip( "Show Cell Contents as Memo" )
      :connect( "triggered()", {|| ::showCellContents() } )
   ENDWITH
   RETURN Self


STATIC FUNCTION __addColumnBlock( obj, cColumn )
   RETURN {||  obj:addAColumn( cColumn ) }


METHOD HbQtBrowse:addAColumn( cColumn )
   LOCAL aNames, oAct

   IF HB_ISSTRING( cColumn )
      Eval( ::addColumnsBlock, 1, cColumn, Self )
   ELSE
      IF HB_ISBLOCK( ::addColumnsBlock )
         IF ::oAddColumnsMenu:isEmpty()
            aNames := Eval( ::addColumnsBlock, 0, NIL, Self )
            IF HB_ISARRAY( aNames )
               ::aActAddColumns := {}
               FOR EACH cColumn IN aNames
                  oAct := ::oAddColumnsMenu:addAction( cColumn )
                  oAct:connect( "triggered(bool)", __addColumnBlock( Self, cColumn ) )
                  AAdd( ::aActAddColumns, oAct )
               NEXT
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN Self

METHOD HbQtBrowse:toColumn( cnColumn )
   LOCAL i, oCol

   IF HB_ISCHAR( cnColumn )
      FOR EACH oCol IN ::columns
         IF oCol:heading == cnColumn
            cnColumn := oCol:__enumIndex()
            EXIT
         ENDIF
      NEXT
   ENDIF
   IF HB_ISNUMERIC( cnColumn )
      IF cnColumn > 0 .AND. cnColumn <= ::colCount .AND. cnColumn != ::colPos
         ::panHome()
         FOR i := 2 TO cnColumn
            ::Right()
         NEXT
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtBrowse:showIndicator( rgbColorString )

   IF HB_ISCHAR( rgbColorString )
      ::oIndicator:setStyleSheet( "" )
      ::oIndicator:setStyleSheet( "background-color: " + rgbColorString + ";" )
      ::oIndicator:show()
   ELSE
      ::oIndicator:hide()
   ENDIF

   RETURN Self


METHOD HbQtBrowse:manageStatusbar( lShow )
   IF HB_ISLOGICAL( lShow )
      IF lShow
         ::oStatusbar:show()
      ELSE
         ::oStatusbar:hide()
      ENDIF
   ENDIF
   RETURN ::oStatusbar:isVisible()


METHOD HbQtBrowse:manageToolbar( lShow )
   IF HB_ISLOGICAL( lShow )
      IF lShow
         ::oToolbar:show()
      ELSE
         ::oToolbar:hide()
      ENDIF
   ENDIF
   RETURN ::oToolbar:isVisible()


METHOD HbQtBrowse:manageToolbarLeft( lShow )
   IF HB_ISLOGICAL( lShow )
      IF lShow
         ::oToolbarLeft:show()
      ELSE
         ::oToolbarLeft:hide()
      ENDIF
   ENDIF
   RETURN ::oToolbarLeft:isVisible()


METHOD HbQtBrowse:getTitle()
   RETURN ::xTitle


METHOD HbQtBrowse:setTitle( xTitle )
   IF HB_ISCHAR( xTitle ) .OR. HB_ISARRAY( xTitle ) .OR. HB_ISBLOCK( xTitle )
      ::xTitle := xTitle
   ENDIF
   RETURN ::xTitle


METHOD HbQtBrowse:print( cPrinter, lOpenPrintDialog )
   LOCAL i, oPrinterInfo, oList, oPrinter

   hb_default( @lOpenPrintDialog, .T. )

   IF HB_ISCHAR( cPrinter ) .AND. ! Empty( cPrinter )
      oPrinterInfo := QPrinterInfo()
      oList := oPrinterInfo:availablePrinters()
      FOR i := 0 TO oList:size() - 1
         IF cPrinter == oList:at( i ):printerName()
            oPrinter := QPrinter( oList:at( i ) )
         ENDIF
      NEXT
   ENDIF

#if 0    /* Not known yet, application crashed IF QPrintDialog is opened and returned printer is used */
   IF Empty( oPrinter )
      //oDlg := QPrintDialog( ::oWidget )
      oDlg := QPrintDialog()
   ELSEIF lOpenPrintDialog
      //oDlg := QPrintDialog( oPrinter, ::oWidget )
      oDlg := QPrintDialog( oPrinter )
   ENDIF
   IF HB_ISOBJECT( oDlg )
      oDlg:connect( "accepted(QPrinter*)", {|oPrn| oPrinter := oPrn } )
      oDlg:exec()
   ENDIF

   HB_TRACE( HB_TR_ALWAYS, __objGetClsName( oPrinter ) )
#endif

   IF Empty( oPrinter )
      oPrinter := QPrinter()
      oPrinter:setOutputFormat( QPrinter_PdfFormat )     /* Until issue WITH QPrintDialog() is resolved, Printing will CREATE a .PDF file on disk */
      oPrinter:setPageOrientation( QPrinter_Portrait )
#ifndef __HB_QT_MAJOR_VER_4__
      oPrinter:setPageSize( QPageSize( QPrinter_A4 ) )
#endif
   ENDIF

   ::printPreview( oPrinter )
   oPrinter := NIL
#if 0
   IF HB_ISOBJECT( oDlg )
      oDlg:setParent( QWidget() )
   ENDIF
#endif

   RETURN Self


METHOD HbQtBrowse:printPreview( oPrinter )
   LOCAL oDlg

   ::oPenBlack := QPen( Qt_black, 1, Qt_SolidLine, Qt_SquareCap, Qt_BevelJoin )

   oDlg := QPrintPreviewDialog( oPrinter )
   oDlg:connect( "paintRequested(QPrinter*)", {|p| ::paintRequested( p ) } )

   oDlg:setWindowTitle( "TBrowse Printed" )
   oDlg:move( 20, 20 )
   oDlg:resize( 400, 600 )
   oDlg:exec()
// oDlg:setParent( QWidget() )

   RETURN NIL


METHOD HbQtBrowse:paintRequested( oPrinter )
   ::printReport( oPrinter )
   RETURN Self


METHOD HbQtBrowse:printReport( oPrinter )
   LOCAL oPainter, i, oFM, nH, nW, nRH, nAW, nRows, nCols, nT, n, aX, nX, cVal, nM, nF, xTmp
   LOCAL oPage, oPaper, nMX, nMY, nML, nMT, nPxlX, nPxlW, nTtlMax, nPage, aLen, nLeading
   LOCAL aTitle := {}
   LOCAL nCGap := 2

   IF HB_ISCHAR( ::title )
      aTitle := hb_ATokens( ::title, ";" )
   ELSEIF HB_ISARRAY( ::title )
      aTitle := ::title
   ELSEIF HB_ISBLOCK( ::title )
      xTmp := Eval( ::title, NIL,  NIL, Self )
      IF HB_ISCHAR( xTmp )
         aTitle := hb_ATokens( xTmp, ";" )
      ELSEIF HB_ISARRAY( xTmp )
         aTitle := xTmp
      ENDIF
   ENDIF
   IF Empty( aTitle ) .OR. ! HB_ISARRAY( aTitle )
      aTitle := {}
      AAdd( aTitle, "Browsed Data" )
   ENDIF
   IF Len( aTitle ) > 5
      ASize( aTitle, 5 )
   ENDIF
   nTtlMax := 0
   AEval( aTitle, {|e| nTtlMax := Max( nTtlMax, Len( e ) ) } )

   oPainter := QPainter()
   IF ! oPainter:begin( oPrinter )
      Alert( "Printing could not been started!" )
      RETURN NIL
   ENDIF

   oPainter:setFont( ::oFont )

   oPaper   := oPrinter:paperRect( QPrinter_DevicePixel )
   oPage    := oPrinter:pageRect( QPrinter_DevicePixel )

   nMX      := ( oPaper:width()  - oPage:width() )
   nMY      := ( oPaper:height() - oPage:height() )

   nW       := oPrinter:width()  - nMX
   nH       := oPrinter:height() - nMY

   oFM      := QFontMetrics( oPainter:font() )
   nAW      := oFM:averageCharWidth()
   nRH      := oFM:lineSpacing()
   nLeading := oFM:descent() + oFM:leading() + 1

   nRows    := Int( nH / nRH )
   nCols    := Int( nW / nAW )

   nF       := 0
   nX       := 0
   aX       := {}
   aLen     := {}
   AAdd( aX, 0 )
   FOR i := 1 TO ::colCount
      cVal := ::cellValue( 1, i )
      IF nX + Len( cVal ) > nCols
         EXIT
      ENDIF
      nX := nX + Len( cVal ) + nCGap
      AAdd( aLen, Len( cVal ) )
      AAdd( aX, nX )
      nF++
   NEXT
   nX  -= nCGap
   nM  := Int( ( nCols - nX ) / 2 )
   nML := nMX / 2
   nMT := nMY / 2

   nPxlX := nML + ( nM * nAW )
   nPxlW := nX * nAW

   nPage := 1
   nT  := nMT
   nT := ::drawTitle( oPainter, aTitle, nT, nRH, nCols, nPage, nML, aX, nF, aLen, nPxlX, nPxlW, nM, nAW, nLeading )

   /* 1 Top Line, 1 bottom line, title lines - minimum 1 - paging info - headings - line */
   nRows -= 1 + 1 + 1 + Len( aTitle ) + 1 + 1
   n := 0
   ::goTop()
   DO WHILE .T.
      IF n > nRows
         oPainter:setPen( ::oPenBlack )
         oPainter:drawLine( nPxlX, nT-nRH/2, nPxlX + nPxlW, nT-nRH/2 )
         //
         IF ! oPrinter:newPage()
            Alert( "Printer misbehaving, exiting printing!" )
            EXIT
         ENDIF
         //
         nPage++
         nT := nMT
         nT := ::drawTitle( oPainter, aTitle, nT, nRH, nCols, nPage, nML, aX, nF, aLen, nPxlX, nPxlW, nM, nAW, nLeading )
         n := 0
      ENDIF
      FOR i := 1 TO nF
         oPainter:fillRect( nML + ( ( nM + aX[ i ] ) * nAW ), nT-nRH+nLeading, aLen[ i ] * nAW, nRH, ;
                              __hbqtHbColorToQtValue( ::colorValue( ::cellColor( ::rowPos, i )[ 1 ] ), Qt_BackgroundRole ) )
         oPainter:setPen( ::compatColor( __hbqtHbColorToQtValue( ::colorValue( ::cellColor( ::rowPos, i )[ 1 ] ), Qt_ForegroundRole ) ) )
         oPainter:drawText( nML + ( ( nM + aX[ i ] ) * nAW ), nT, ::cellValue( ::rowPos, i ) )
      NEXT
      n++
      nT += nRH
      ::down()
      IF ::hitBottom
         EXIT
      ENDIF
   ENDDO
   IF nT < nH
      oPainter:setPen( ::oPenBlack )
      oPainter:drawLine( nPxlX, nT-nRH/2, nPxlX + nPxlW, nT-nRH/2 )
   ENDIF

   oPainter:end()

   RETURN Self


METHOD HbQtBrowse:drawTitle( oPainter, aTitle, nT, nRH, nCols, nPage, nML, aX, nF, aLen, nPxlX, nPxlW, nM, nAW, nLeading )
   LOCAL cPage := DToC( Date() ) + " " + Time() + " Page:" + hb_ntos( nPage )
   LOCAL cText, i, nn

   oPainter:setPen( ::oPenBlack )

   FOR EACH cText IN aTitle
      oPainter:drawText( nML, nT, PadC( cText, nCols ) )
      nT += nRH
   NEXT
   oPainter:drawText( nML, nT, PadC( cPage, nCols ) )
   nT += nRH
   oPainter:drawLine( nPxlX, nT-nRH/2, nPxlX + nPxlW, nT-nRH/2 )
   nT += nRH

   FOR i := 1 TO nF
      nN := nML + ( ( nM + aX[ i ] ) * nAW )
      oPainter:fillRect( nN, nT-nRH+nLeading-nRH/4, aLen[ i ] * nAW, nRH, QColor( 220,220,220 ) )
      oPainter:drawText( nN, nT-nRH/4, PadC( ::columns[ i ]:heading, aLen[ i ] ) )
   NEXT
   nT += nRH

   oPainter:drawLine( nPxlX, nT-nRH/2, nPxlX + nPxlW, nT-nRH/2 )
   nT += nRH

   RETURN nT


METHOD HbQtBrowse:dispFrames()

   ::lFrames := .F.

   RETURN Self


METHOD HbQtBrowse:dispRow( nRow )

   HB_SYMBOL_UNUSED( nRow )

   RETURN Self
