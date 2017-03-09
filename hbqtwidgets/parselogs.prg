/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2016-2017 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                             Pritpal Bedi
 *                              17Dec2016
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "inkey.ch"
#include "set.ch"
#include "fileio.ch"
#include "hbgtinfo.ch"
#include "hbhrb.ch"
#include "hbqtgui.ch"

#define __ERR_SR__                                1
#define __ERR_DATETIME__                          2
#define __ERR_DESC__                              3
#define __ERR_ALIAS__                             4
#define __ERR_ORDER__                             5
#define __ERR_OPER__                              6
#define __ERR_ARGS__                              7
#define __ERR_TRACE1__                            8
#define __ERR_TRACE2__                            9
#define __ERR_TRACE3__                            10
#define __ERR_RECORD__                            11
#define __ERR_EXE__                               12
#define __ERR_EMP__                               13
#define __ERR_STATION__                           14
#define __ERR_SITE__                              15
#define __ERR_LOC__                               16
//
#define __ERR_COLUMNS__                           16
//
#define __ERR_UNIQUE__                            17

#define __BSE_EMP__                               1
#define __BSE_STA__                               2
#define __BSE_EXE__                               3
#define __BSE_DTE__                               4
#define __BSE_TME__                               5
#define __BSE_STE__                               6
#define __BSE_LOC__                               7
#define __BSE_MIS__                               8
//
#define __BSE_ALL__                               8

#define __DFN_FIELDNAME__                         1
#define __DFN_LOGTOKEN__                          2
#define __DFN_EXPRESSION__                        3
#define __DFN_HDRINDEX__                          4
#define __DFN_OFFSET__                            5
#define __DFN_ANALYZE__                           6


STATIC s_LastActivity := 0


CLASS HbQtLogAnalyzer

   DATA   oWidget
   ACCESS widget()                                INLINE ::oWidget

   DATA   oUI
   DATA   oParent
   DATA   oChart
   DATA   oTimer
   DATA   oTimerRefresh
   DATA   oGraphics
   DATA   lGraphicsOn                             INIT .F.

   DATA   aDir

   DATA   nKeyOffset                              INIT 15
   DATA   cNewEntryToken                          INIT ""
   DATA   aMaxWidth                               INIT {}

   DATA   aEntries                                INIT {}
   DATA   axMaxWidth                              INIT {}
   DATA   axTable                                 INIT {}
   DATA   axColumns                               INIT {}
   DATA   axErrors                                INIT {}
   DATA   axFields                                INIT {}
   DATA   axDefintn                               INIT {}
   DATA   axAnalyze                               INIT {}
   DATA   cEntryToken                             INIT ""
   DATA   cHdrDlm                                 INIT ""
   DATA   cDateFormat                             INIT ""
   DATA   nHdrOffset                              INIT 0
   DATA   cDefintnFile                            INIT ""
   DATA   nTraceBacks                             INIT 0
   DATA   nSignificantRows                        INIT 10

   DATA   lRefreshStopped                         INIT .F.
   DATA   nStoppedSeconds                         INIT 0

   METHOD init( oParent )
   METHOD create( oParent )

   METHOD show()                                  INLINE ::oWidget:show()

   METHOD loadConfiguration( cHlgFile )
   METHOD loadLog( cLogFile )
   METHOD setSignificantRows( nRows )             INLINE iif( HB_ISNUMERIC( nRows ) .AND. nRows > 0, ::nSignificantRows := nRows, NIL )
   ACCESS significantRows()                       INLINE ::nSignificantRows

   PROTECTED:
   ACCESS lenNewEntryToken()                      INLINE Len( ::cNewEntryToken )

   METHOD saveConfiguration( lSaveAs )
   METHOD parseLog( cErrorLog )
   METHOD copySelections( lSave )
   METHOD manageChart( oItem )
   METHOD manageSummaryContextMenu( oPoint )
   METHOD manageTableCellClicked( nRow, nCol )
   METHOD clearConfiguration()
   METHOD parseConfiguration()
   METHOD loadFrom()
   METHOD buildTreeErrorlog()
   METHOD buildTableErrorlog()
   METHOD adjustTableColumns( aColumns )
   METHOD buildErrorsSummary()
   METHOD clear()
   METHOD dialogExpandExpression( oEditControl )
   METHOD switchOnOff( nIndex )
   METHOD reloadLogIfChanged()
   METHOD manageRefresh()
   METHOD switchRefresh()

   ENDCLASS


METHOD HbQtLogAnalyzer:init( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent
   RETURN Self


METHOD HbQtLogAnalyzer:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   IF ! Empty( ::oUI := hbqtui_parselogs() )
      ::oWidget := ::oUI:widget()

      ::oUI:connect( QEvent_Show, {|| iif( HB_ISOBJECT( ::oChart ), ::oChart:widget():setMaximumHeight( 15000 ), NIL ) } )

      ::oUI:btnOpenErrorLog:connect( "clicked()", {||
                                       LOCAL cFile := HbQtOpenFileDialog( NIL, "Select ErrorLog", "ErrorLog (*.*)", .F., .F., NIL )
                                       IF ! Empty( cFile )
                                          ::oUI:editErrorLog:setText( "" )
                                          ::oUI:editErrorLog:setText( cFile )
                                       ENDIF
                                       RETURN NIL
                                                  } )
      ::oUI:editErrorLog:connect( "textChanged(QString)", {|cText| ::parseLog( cText ) } )

      ::oUI:btnCopySelect:connect( "clicked()", {|| ::copySelections( .F. ) } )
      ::oUI:btnSaveCsv:connect( "clicked()", {|| ::copySelections( .T. ) } )

      ::oUI:btnExpandTree:connect( "clicked()", {|| __hbqtTreeExpandAll( ::oUI:treeNumbers:invisibleRootItem(), .T. ) } )
      ::oUI:btnCollapseTree:connect( "clicked()", {|| __hbqtTreeCollapseAll( ::oUI:treeNumbers:invisibleRootItem(), .T. ) } )
      ::oUI:btnAutoOnOff:connect( "clicked()", {|| ::manageRefresh() } )

      ::oUI:treeNumbers:connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oItem| ::manageChart( oItem ) } )

      ::oUI:treeNumbers:setContextMenuPolicy( Qt_CustomContextMenu )
      ::oUI:treeNumbers:connect( "customContextMenuRequested(QPoint)", {|oPoint| ::manageSummaryContextMenu( oPoint ) } )

      ::oUI:tableErrorLog:connect( "cellClicked(int,int)", {|nRow,nCol| ::manageTableCellClicked( nRow, nCol ) } )

      ::oUI:tabAnalysis:connect( QEvent_Hide, {||
                                          LOCAL i
                                          FOR i := 0 TO ::oUI:tableErrorLog:rowCount() - 1
                                             ::oUI:tableErrorLog:setRowHidden( i, .F. )
                                          NEXT
                                          RETURN NIL
                                      } )

      WITH OBJECT ::oChart := HbQtCharts():new( ::oUI:frameCharts ):create()
         :enableShadows( .F. )
         :enableLegend( .F. )
         :enableTitle( .T. )
         :widget():setMaximumHeight( 145 )
      ENDWITH
      ::oUI:hLaySummary:addWidget( ::oChart:widget() )

      ::oUI:btnLoadCfg:connect( "clicked()", {|| ::loadFrom() } )
      ::oUI:btnSaveCfgAs:connect( "clicked()", {|| ::saveConfiguration( .T. ) } )
      ::oUI:btnSaveCfg:connect( "clicked()", {|| ::saveConfiguration() } )
      ::oUI:btnClearCfg:connect( "clicked()", {|| ::clearConfiguration() } )

      WITH OBJECT ::oUI
         :btnEntryExp:connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editEntryToken ) } )
         :btnDateExp :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editDateExp ) } )
         :btnTimeExp :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editTimeExp ) } )
         :btnF3Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF3Exp ) } )
         :btnF4Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF4Exp ) } )
         :btnF5Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF5Exp ) } )
         :btnF6Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF6Exp ) } )
         :btnF7Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF7Exp ) } )
         :btnF8Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF8Exp ) } )
         :btnF9Exp   :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF9Exp ) } )
         :btnF10Exp  :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF10Exp ) } )
         :btnF11Exp  :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF11Exp ) } )
         :btnF12Exp  :connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editF12Exp ) } )
         :btnTraceExp:connect( "clicked()", {|| ::dialogExpandExpression( ::oUI:editTraceExp ) } )
      ENDWITH

      ::oUI:tabWidgetErrorLog:connect( "currentChanged(int)", {|nIndex| ::switchOnOff( nIndex ) } )
      ::switchOnOff( 1 )

      ::oUI:tabWidgetErrorLog:setCurrentIndex( 1 )
      ::oUI:treeErrorLog:hide()
      ::loadConfiguration()

      WITH OBJECT ::oTimer := QTimer()
         :setInterval( 60000 )
         :connect( "timeout()", {|| ::reloadLogIfChanged() } )
         :start()
      ENDWITH
      WITH OBJECT ::oTimerRefresh := QTimer()
         :setInterval( 500 )
         :connect( "timeout()", {|| ::switchRefresh() } )
         :start()
      ENDWITH
      WITH OBJECT ::oWidget
         :connect( QEvent_KeyPress          , {|| s_LastActivity := Seconds() } )
         :connect( QEvent_MouseButtonRelease, {|| s_LastActivity := Seconds() } )
      ENDWITH
      ::oGraphics := HbQtLogGraphics():new():create( ::oWidget )

      ::oUI:btnGraphics:connect( "clicked()", {|| ::lGraphicsOn := .T., ::oGraphics:show() } )
   ENDIF
   RETURN Self


METHOD HbQtLogAnalyzer:switchRefresh()            // called inside timer
   IF ::lRefreshStopped .AND. ::nStoppedSeconds > 0 .AND. Abs( Seconds() - ::nStoppedSeconds ) > 180    // arbitrary 3 minutes - must be user definable
      ::oUI:btnAutoOnOff:setIcon( QIcon( __hbqtImage( "auto_on" ) ) )
      ::oUI:btnAutoOnOff:setTooltip( "Disable auto refresh" )
      ::nStoppedSeconds := 0
      ::lRefreshStopped := .F.
      ::reloadLogIfChanged()
      IF ::lGraphicsOn
         ::oGraphics:show()
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:manageRefresh()            // user interacted explicitly
   IF ::lRefreshStopped
      ::oUI:btnAutoOnOff:setIcon( QIcon( __hbqtImage( "auto_on" ) ) )
      ::oUI:btnAutoOnOff:setTooltip( "Disable auto refresh" )
   ELSE
      ::oUI:btnAutoOnOff:setIcon( QIcon( __hbqtImage( "auto_off" ) ) )
      ::oUI:btnAutoOnOff:setTooltip( "Enable auto refresh" )
   ENDIF
   ::lRefreshStopped := ! ::lRefreshStopped
   IF ! ::lRefreshStopped
      ::nStoppedSeconds := 0
   ELSE
      ::nStoppedSeconds := Seconds()
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:dialogExpandExpression( oEditControl )
   LOCAL oDialog
   LOCAL cText := oEditControl:text()

   IF Empty( cText )
      cText := ""
   ENDIF

   WITH OBJECT oDialog := hbqtui_expandtext()
      :btnOK:connect( "clicked()", {|| oEditControl:setText( oDialog:plainTextEdit:toPlainText() ), oDialog:done( 0 ) } )
      :btnCancel:connect( "clicked()", {|| oDialog:done( 0 ) } )
      //
      :plainTextEdit:clear()
      :plainTextEdit:setPlainText( cText )
      //
      :setWindowTitle( oEditControl:whatsThis() + " - " + "Expression to Pull Desired Value!" )
      :move( ::oUI:frameConfigure:mapToGlobal( QPoint( 0, oEditControl:y() + oEditControl:height() + 3 ) ) )
      //
      :exec()
   ENDWITH
   RETURN NIL


METHOD HbQtLogAnalyzer:loadLog( cLogFile )
   IF ! Empty( cLogFile ) .AND. hb_FileExists( cLogFile )
      ::oUI:editErrorLog:setText( cLogFile )
   ENDIF
   RETURN NIL

METHOD HbQtLogAnalyzer:switchOnOff( nIndex )

   SWITCH nIndex
   CASE 0
      ::oUI:btnCopySelect:setEnabled( .T. )
      ::oUI:btnSaveCsv:setEnabled( .T. )
      ::oUI:btnExpandTree:setEnabled( .F. )
      ::oUI:btnCollapseTree:setEnabled( .F. )
      EXIT
   CASE 1
      ::oUI:btnCopySelect:setEnabled( .F. )
      ::oUI:btnSaveCsv:setEnabled( .F. )
      ::oUI:btnExpandTree:setEnabled( .T. )
      ::oUI:btnCollapseTree:setEnabled( .T. )
      EXIT
   CASE 2
      ::oUI:btnCopySelect:setEnabled( .F. )
      ::oUI:btnSaveCsv:setEnabled( .F. )
      ::oUI:btnExpandTree:setEnabled( .F. )
      ::oUI:btnCollapseTree:setEnabled( .F. )
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD HbQtLogAnalyzer:clear()

   ::aEntries     := {}
   ::axMaxWidth   := {}
   ::axTable      := {}
   ::axColumns    := {}
   ::axErrors     := {}
   ::axFields     := {}
   ::axAnalyze    := {}

   ::oChart:clear()

   ::oUI:treeErrorLog:clear()
   ::oUI:tableErrorLog:clear()
   ::oUI:treeNumbers:clear()
   RETURN NIL


METHOD HbQtLogAnalyzer:copySelections( lSave )
   LOCAL aData, oMList, oMIndex, nRows, nCols, i, s, n, x, a_, b_, nRowOff, nColOff, cCSV
   LOCAL oTable := ::oUI:tableErrorLog
   LOCAL oSelModel := oTable:selectionModel()
   LOCAL cDlm := ","

   IF ! oSelModel:hasSelection()
      RETURN NIL
   ENDIF

   a_:= {}
   aData := {}
   oMList := oSelModel:selectedIndexes()
   FOR i := 0 TO oMList:count() - 1
      oMIndex := oMList:At( i )
      AAdd( a_, { oMIndex:Row(), oMIndex:column(), oMIndex:data():toString() } )
   NEXT
   ASort( a_, , , {|e_,f_| e_[ 1 ] < f_[ 1 ] } )
   nRows := a_[ Len( a_ ), 1 ] - a_[ 1,1 ] + 1
   nRowOff := a_[ 1,1 ]
   ASort( a_, , , {|e_,f_| e_[ 2 ] < f_[ 2 ] } )
   nCols := a_[ Len( a_ ), 2 ] - a_[ 1,2 ] + 1
   nColOff := a_[ 1,2 ]

   FOR i := 1 TO nRows
      AAdd( aData, Array( nCols ) )
   NEXT
   FOR i := 1 TO Len( a_ )
      aData[ a_[ i, 1 ] - nRowOff + 1, a_[ i, 2 ] - nColOff + 1 ] := a_[ i, 3 ]
   NEXT
   a_:= AFill( Array( nCols ), 0 )
   FOR EACH b_ IN aData
      FOR EACH n IN a_
         n := Max( n, Len( b_[ n:__enumIndex() ] ) )
      NEXT
   NEXT
   s := ""
   FOR EACH b_ IN aData
      FOR EACH x IN b_
         s += '"' + Pad( x, a_[ x:__enumIndex() ] ) + '"' + iif( x:__enumIndex() == nCols, "", cDlm )
      NEXT
      s += Chr( 13 ) + Chr( 10 )
   NEXT
   IF lSave
      IF ! Empty( cCSV := HbQtOpenFileDialog( NIL, "Select .csv file", "Excel Compliant CSV File (*.csv)", .F., .T., NIL ) )
         hb_MemoWrit( cCSV, s )
      ENDIF
   ELSE
      QApplication():clipBoard():setText( s )
   ENDIF
   RETURN aData


METHOD HbQtLogAnalyzer:manageTableCellClicked( nRow, nCol )
   LOCAL cIndex, oParent, i
   IF nCol == 0
      cIndex := ::oUI:tableErrorLog:item( nRow, nCol ):text()
      IF .T.
         oParent := ::oUI:treeErrorLog:invisibleRootItem()
         __hbqtTreeCollapseAll( oParent, .T. )
         FOR i := 0 TO oParent:childCount() - 1
            IF Left( oParent:child( i ):text( 0 ), Len( cIndex ) ) == cIndex
               oParent:child( i ):setExpanded( .T. )
               ::oUI:treeErrorLog:scrollToItem( oParent:child( i ), QAbstractItemView_PositionAtTop )
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:manageSummaryContextMenu( oPoint )
   LOCAL oItem, cText, nRow, nColumn, cParentField
   LOCAL oTable := ::oUI:tableErrorLog

   IF ! empty( oItem := ::oUI:treeNumbers:itemAt( oPoint ) )
      IF Left( oItem:whatsThis( 0 ), 1 ) == "C"
         cParentField := SubStr( oItem:parent():text( 0 ), 4 )
         cText := Trim( oItem:text( 0 ) )
         nColumn := Val( SubStr( oItem:whatsThis( 0 ), 3 ) ) - 1
         oTable:sortItems( nColumn )

         IF cParentField == "DateTime"
            FOR nRow := 0 TO oTable:rowCount() - 1
               oItem := NIL
               IF ! Empty( oItem := oTable:item( nRow, nColumn ) )
                  IF Left( oItem:text(), 10 ) == __ansiDate( cText )
                     oTable:setRowHidden( nRow, .F. )
                  ELSE
                     oTable:setRowHidden( nRow, .T. )
                  ENDIF
               ELSE
                  oTable:setRowHidden( nRow, .T. )
               ENDIF
            NEXT
         ELSE
            FOR nRow := 0 TO oTable:rowCount() - 1
               oItem := NIL
               IF ! Empty( oItem := oTable:item( nRow, nColumn ) )
                  IF oItem:text() == cText
                     oTable:setRowHidden( nRow, .F. )
                  ELSE
                     oTable:setRowHidden( nRow, .T. )
                  ENDIF
               ELSE
                  oTable:setRowHidden( nRow, .T. )
               ENDIF
            NEXT
         ENDIF
         ::oUI:tabWidgetErrorLog:setCurrentIndex( 0 )
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:manageChart( oItem )
   LOCAL cTitle, xTmp, nColumn, cField, cValue, dat_, i, n, byDate, dDateFr, dDateTo, nUnqColumn
   LOCAL cGroup  := ""
   LOCAL cText   := oItem:text( 0 )

   byDate  := ::axColumns[ 2, 5 ]
   dDateFr := byDate[ 1, 2 ]
   dDateTo := byDate[ Len( byDate ), 2 ]
   nUnqColumn := Len( ::axColumns )

   IF ! Left( cText, 3 ) == "By "
      cGroup := SubStr( oItem:parent():text( 0 ), 4 )
   ENDIF
   cField := SubStr( cText, 4 )

   ::oChart:clear()
   IF Empty( cGroup )
      SWITCH cField
      CASE "DateTime"
         cTitle := "Number of Errors by Date . " + DToC( dDateFr ) + "-" + DToC( dDateTo )
         FOR EACH xTmp IN byDate
            ::oChart:addItem( StrZero( Day( xTmp[ 2 ] ), 2 ), xTmp[ nUnqColumn ] )
         NEXT
         EXIT
      OTHERWISE
         IF ( nColumn := AScan( ::axColumns, {|e_| e_[ 1 ] == cField } ) ) > 0
            cTitle := "Number of Errors by " + cField
            __addChartItem( ::oChart, ::axColumns[ nColumn, 5 ], nColumn, nUnqColumn )
         ENDIF
         EXIT
      ENDSWITCH
   ELSE
      IF ! cGroup == "DateTime"
         IF ( nColumn := AScan( ::axColumns, {|e_| e_[ 1 ] == cGroup } ) ) > 0
            cValue := Pad( cText, ::axMaxWidth[ nColumn ] )
            dat_:= __hbqtAProcessUniqueEx( ::axTable, { 2, nColumn }, { nUnqColumn }, { "SUM" }, {|e_|  e_[ nColumn ] == cValue } )
            IF ! Empty( dat_ )
               cTitle := "Number of Errors " + cGroup + " [ " + Trim( cText ) + " ] " + CMonth( dDateFr ) + " " + Str( Year( dDateFr ), 4 )
               FOR i := 1 TO ( dDateTo - dDateFr + 1 )
                  n := AScan( dat_, {|e_| e_[ 2 ] == dDateFr + i - 1 } )
                  xTmp := iif( n > 0, dat_[ n, nUnqColumn ], 0 )
                  ::oChart:addItem( StrZero( Day( dDateFr + i - 1 ), 2 ), xTmp )
               NEXT
            ELSE
               cTitle := "Number of Errors " + cGroup + " [ " + cText  + " ] " + CMonth( dDateFr ) + " " + Str( Year( dDateFr ), 4 ) + " No Data"
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF HB_ISSTRING( cTitle )
      ::oChart:setTitle( cTitle )
   ENDIF
   RETURN NIL


STATIC FUNCTION __addChartItem( oChart, aData, nGroup, nNumber )
   LOCAL xTmp
   FOR EACH xTmp IN aData
      IF xTmp:__enumIndex() <= 100
         oChart:addItem( xTmp[ nGroup ], xTmp[ nNumber ] )
      ENDIF
   NEXT
   RETURN NIL


STATIC FUNCTION __addTreeChild( oParent, cText, nColumn, cWhatsThis, cTooltip )
   LOCAL oItem

   DEFAULT nColumn TO 0
   DEFAULT cWhatsThis TO ""
   DEFAULT cTooltip TO ""

   WITH OBJECT oItem := QTreeWidgetItem()
      :setText( nColumn, cText )
      :setWhatsThis( nColumn, cWhatsThis )
      :setTooltip( nColumn, cTooltip )
   ENDWITH
   oParent:addChild( oItem )
   RETURN oItem


STATIC FUNCTION __ansiDate( xDate )
   LOCAL sDate := iif( HB_ISDATE( xDate ), DToS( xDate ), DToS( CToD( xDate ) ) )
   RETURN SubStr( sDate, 1, 4 ) + "-" + SubStr( sDate, 5, 2 ) + "-" + SubStr( sDate, 7, 2 )


STATIC FUNCTION __ansiDateTime( cDate, cTime )
   RETURN __ansiDate( cDate ) + "  " + iif( Empty( cTime ), "00:00:00", cTime )


STATIC FUNCTION __tableWidgetItem( lHeaderItem )
   LOCAL oItem := QTableWidgetItem()

   DEFAULT lHeaderItem TO .F.
   IF lHeaderItem
      oItem:setFlags( Qt_ItemNeverHasChildren + Qt_ItemIsUserCheckable + Qt_ItemIsEnabled )
      oItem:setTextAlignment( hb_bitOr( Qt_AlignHCenter, Qt_AlignVCenter ) )
   ELSE
      oItem:setFlags( Qt_ItemIsEnabled + Qt_ItemIsSelectable )
   ENDIF
   RETURN oItem


METHOD HbQtLogAnalyzer:parseConfiguration()
   LOCAL xTmp, xT, i

   ::clear()

   IF Empty( ::oUI:editLoadHlg:text() )
      Alert( "Please load LogAnalyzer Definition first!" )
      RETURN .F.
   ENDIF
   WITH OBJECT ::oUI
      IF Empty( ::cEntryToken )
         AAdd( ::axErrors, "EntryToken must have to be defined!" )
      ENDIF
      IF Empty( ::cDateFormat )
         AAdd( ::axErrors, "DateFormat must have to be defined!" )
      ENDIF
      xTmp := AScan( ::axDefintn, {|e_| e_[ __DFN_HDRINDEX__ ] > 0 }, 1, Len( ::axDefintn ) - 1 )
      IF xTmp > 0
         IF Empty( ::cHdrDlm )
            AAdd( ::axErrors, "HdrDelimiter must have to be defined if some field has HdrIndex!" )
         ENDIF
      ENDIF
      FOR EACH xTmp IN ::axDefintn
         IF ! Empty( xTmp[ __DFN_FIELDNAME__ ] )
            IF xTmp[ __DFN_HDRINDEX__ ] == 0 .AND. Empty( xTmp[ __DFN_LOGTOKEN__ ] )
               AAdd( ::axErrors, "Field#" + hb_ntos( xTmp:__enumIndex() ) + "[" + xTmp[ __DFN_FIELDNAME__ ] + "]" + " must have either HdrIndex or LogToken!" )
            ENDIF
         ENDIF
      NEXT
   ENDWITH
   IF ! Empty( ::axErrors )
      Alert( ::axErrors )
      RETURN .F.
   ENDIF

   ::nTraceBacks := ::axDefintn[ Len( ::axDefintn ), __DFN_HDRINDEX__ ]
   ::axFields := {}
   ::axAnalyze := {}
   FOR EACH xTmp IN ::axDefintn
      IF ! Empty( xTmp[ __DFN_FIELDNAME__ ] ) .AND. xTmp[ __DFN_ANALYZE__ ]
         AAdd( ::axFields, xTmp )
         AAdd( ::axAnalyze, xTmp )
         IF xTmp:__enumIndex() == Len( ::axDefintn ) .AND. ::nTraceBacks > 1
            xT := AClone( xTmp )
            FOR i := 2 TO ::nTraceBacks
               xT[ __DFN_FIELDNAME__ ] := xTmp[ __DFN_FIELDNAME__ ] + "-" + hb_ntos( i )
               AAdd( ::axAnalyze, AClone( xT ) )
            NEXT
         ENDIF
      ENDIF
   NEXT
   RETURN .T.


METHOD HbQtLogAnalyzer:reloadLogIfChanged()
   LOCAL cErrorLog, aDir

   IF ! ::lRefreshStopped
      cErrorLog := ::oUI:editErrorLog:text()
      IF ! Empty( cErrorLog )
         aDir := Directory( cErrorLog )
         IF ! Empty( aDir )
            IF Empty( ::aDir )
               ::aDir := aDir
            ELSE
               IF ! aDir[ 1,4 ] == ::aDir[ 1,4 ]
                  ::oUI:editErrorLog:setText( "" )
                  ::oUI:editErrorLog:setText( cErrorLog )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:parseLog( cErrorLog )
   LOCAL cLog, aLog, cValue, n, n1, xTmp, cKey, hFields, hTokens, cField, cToken, cFormat
   LOCAL nRow, hRows, lRestCallStack, cKeyCallStack, lIsRest
   LOCAL aEntries := {}
   LOCAL hEntry := {=>}
   LOCAL nEntry := 0
   LOCAL nHdrLen := Len( ::cHdrDlm )
   LOCAL cBuffer := hb_MemoRead( cErrorLog )

   IF Empty( cBuffer )
      RETURN NIL
   ENDIF
   IF ! ::parseConfiguration()
      RETURN NIL
   ENDIF
   ::aDir := Directory( cErrorLog )

   lRestCallStack := .F.
   xTmp := ::axDefintn[ Len( ::axDefintn ) ]
   IF ! Empty( xTmp[ __DFN_LOGTOKEN__ ] ) .AND. ! Empty( xTmp[ __DFN_FIELDNAME__ ] )
      cKey := xTmp[ __DFN_LOGTOKEN__ ]
      IF Right( cKey, 2 ) == "_$"
         cKeyCallStack := Left( cKey, Len( cKey ) - 2 )
      ENDIF
   ENDIF

   hb_HCaseMatch( hEntry, .F. )
   hb_HKeepOrder( hEntry, .T. )

   aLog := hb_ATokens( StrTran( cBuffer, Chr( 13 ) ), Chr( 10 ) )
   FOR EACH cLog IN aLog
      cLog := AllTrim( cLog )
      IF Empty( cLog )
         LOOP
      ENDIF
      IF Left( cLog, Len( ::cEntryToken ) ) == ::cEntryToken .OR. __evalAsLogical( ::cEntryToken, cLog )
         lRestCallStack := .F.
         nRow := 1
         IF ! Empty( hEntry )
            AAdd( aEntries, hEntry )
            hEntry := {=>}
            hb_HCaseMatch( hEntry, .F. )
            hb_HKeepOrder( hEntry, .T. )
         ENDIF
         cValue := AllTrim( SubStr( cLog, iif( ::nHdrOffset > 0, ::nHdrOffset, Len( ::cEntryToken ) + 1 ) ) )
         IF ! Empty( ::cHdrDlm )
            IF ( n := At( ::cHdrDlm, cValue ) ) > 0
               IF ( n1 := RAt( ::cHdrDlm, cValue ) ) > 0
                  IF ! n == n1
                     cValue := SubStr( cValue, n + nHdrLen, n1 - n - nHdrLen )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         hEntry[ "__index"   ] := ++nEntry
         hEntry[ "__header"  ] := cValue
         hEntry[ "__hdrflds" ] := hb_ATokens( cValue, ::cHdrDlm )

         hFields := {=>}
         hb_HCaseMatch( hFields, .F. )
         hb_HKeepOrder( hFields, .T. )
         hEntry[ "fields" ] := hFields

         hTokens := {=>}
         hb_HCaseMatch( hTokens, .F. )
         hb_HKeepOrder( hTokens, .T. )
         hEntry[ "tokens" ] := hTokens

         hRows := {=>}
         hb_HCaseMatch( hRows, .F. )
         hEntry[ "rows" ] := hRows
         hRows[ "__Row" + hb_ntos( nRow ) + "__" ] := cLog

      ELSEIF hb_HHasKey( hEntry, "tokens" )
         nRow++
         IF nRow <= ::significantRows()
            hEntry[ "rows" ][ "__Row" + hb_ntos( nRow ) + "__" ] := cLog
         ENDIF

         hTokens := hEntry[ "tokens" ]

         IF lRestCallStack
            AAdd( hTokens[ cKeyCallStack ], cLog )
         ELSE
            FOR EACH xTmp IN ::axDefintn
               IF ! Empty( xTmp[ __DFN_LOGTOKEN__ ] ) .AND. ! Empty( xTmp[ __DFN_FIELDNAME__ ] )
                  IF ! Left( xTmp[ __DFN_LOGTOKEN__ ], 2 ) == "__"
                     lIsRest := .F.
                     cKey := xTmp[ __DFN_LOGTOKEN__ ]
                     IF Right( cKey, 2 ) == "_$"
                        IF xTmp:__enumIndex() == Len( ::axDefintn )
                           lIsRest := .T.
                           cKey := Left( cKey, Len( cKey ) - 2 )
                        ENDIF
                     ENDIF
                     IF Left( cLog, Len( cKey ) ) == cKey
                        cValue := iif( xTmp[ __DFN_OFFSET__ ] > 0, SubStr( cLog, xTmp[ __DFN_OFFSET__ ] ), AllTrim( SubStr( cLog, Len( cKey ) + 1 ) ) )
                        IF ! hb_HHasKey( hTokens, cKey )
                           IF xTmp:__enumIndex() == Len( ::axDefintn )
                              hTokens[ cKey ] := {}
                              IF lIsRest
                                 lRestCallStack := .T.
                              ELSE
                                 AAdd( hTokens[ cKey ], cValue )
                              ENDIF
                           ELSE
                              hTokens[ cKey ] := cValue
                           ENDIF
                        ELSEIF xTmp:__enumIndex() == Len( ::axDefintn )
                           AAdd( hTokens[ cKey ], cValue )
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            NEXT
         ENDIF
      ENDIF
   NEXT
   IF ! Empty( hEntry )
      AAdd( aEntries, hEntry )
   ENDIF

   FOR EACH hEntry IN aEntries
      hTokens := hEntry[ "tokens" ]
      hFields := hEntry[ "fields" ]
      hRows   := hEntry[ "rows"   ]

      FOR EACH xTmp IN ::axDefintn
         IF ! Empty( cField := xTmp[ __DFN_FIELDNAME__ ] )
            cToken := xTmp[ __DFN_LOGTOKEN__ ]

            IF xTmp:__enumIndex() == Len( ::axDefintn ) .AND. ! Empty( cToken )
               IF Right( cToken, 2 ) == "_$"
                  cToken := Left( cToken, Len( cToken ) - 2 )
               ENDIF
               IF hb_HHasKey( hTokens, cToken )
                  IF  ! Empty( xTmp[ __DFN_EXPRESSION__ ] )
                     FOR EACH cValue IN hTokens[ cToken ]
                        cValue :=__evalAsStr( xTmp[ __DFN_EXPRESSION__ ], cValue )
                     NEXT
                  ENDIF
                  hFields[ cField ] := hTokens[ cToken ]
               ENDIF
            ELSE
               cValue := ""
               IF xTmp[ __DFN_HDRINDEX__ ] > 0
                  cValue := iif( Len( hEntry[ "__hdrflds" ] ) >= xTmp[ __DFN_HDRINDEX__ ], hEntry[ "__hdrflds" ][ xTmp[ __DFN_HDRINDEX__ ] ], "" )
               ELSEIF ! Empty( cToken ) .AND. hb_HHasKey( hTokens, cToken )
                  cValue := hTokens[ cToken ]
               ELSEIF ! Empty( cToken ) .AND. hb_HHasKey( hRows, cToken )
                  cValue := hRows[ cToken ]
               ENDIF
               IF ! Empty( xTmp[ __DFN_EXPRESSION__ ] )
                  cValue :=__evalAsStr( xTmp[ __DFN_EXPRESSION__ ], cValue )
               ENDIF
               hFields[ cField ] := cValue
            ENDIF
         ENDIF
      NEXT
   NEXT

   cFormat := Set( _SET_DATEFORMAT, ::cDateFormat )
   FOR EACH hEntry IN aEntries
      hFields := hEntry[ "fields" ]
      hFields[ "date" ] := CToD( hFields[ "date" ] )
   NEXT
   Set( _SET_DATEFORMAT, cFormat )

   ::aEntries := aEntries

   ::buildTreeErrorlog()
   ::buildTableErrorlog()
   ::buildErrorsSummary()

   ::oGraphics:setData( ::aEntries )

   ::oUI:tabWidgetErrorLog:setCurrentIndex( 1 )
   RETURN NIL


STATIC FUNCTION __evalAsStr( cExp, cString )
   LOCAL bBlock, cValue
   LOCAL bError := ErrorBlock( {|| Break() } )

   BEGIN SEQUENCE
      bBlock := &( "{| cText,v1,v2,v3,v4,v5 | " + cExp + " }" )
      cValue := Eval( bBlock, cString )
   RECOVER
      cValue := ""
   END SEQUENCE
   ErrorBlock( bError )
   RETURN cValue


STATIC FUNCTION __evalAsLogical( cExp, cString )
   LOCAL bBlock, lValue
   LOCAL bError := ErrorBlock( {|| Break() } )

   BEGIN SEQUENCE
      bBlock := &( "{| cText,v1,v2,v3,v4,v5 | " + cExp + " }" )
      lValue := Eval( bBlock, cString )
   RECOVER
      lValue := .F.
   END SEQUENCE
   ErrorBlock( bError )
   RETURN iif( HB_ISLOGICAL( lValue ), lValue, .F. )


METHOD HbQtLogAnalyzer:buildTreeErrorlog()
   LOCAL nStrZ, hEntry, hFields, hField, nIndex, xTmp, cValue, oItem, oChild, cDetails
   LOCAL oTree := ::oUI:treeErrorLog
   LOCAL oParent := oTree:invisibleRootItem()

   WITH OBJECT oTree
      :clear()
      :setHeaderLabel( " Total Entries: " + hb_ntos( Len( ::aEntries ) ) )
   ENDWITH

   nStrZ := iif( Len( ::aEntries ) > 9999, 5, iif( Len( ::aEntries ) > 999, 4, iif( Len( ::aEntries ) > 99, 3, 2 ) ) )
   FOR EACH hEntry IN ::aEntries
      nIndex := hEntry:__enumIndex()
      hFields := hEntry[ "fields" ]
      WITH OBJECT oItem := QTreeWidgetItem()
         IF hb_HHasKey( hFields, "Description" )
            :setText( 0, StrZero( nIndex, nStrZ ) + " - " + hFields[ "Description" ] )
            :setTooltip( 0, hEntry[ "__header" ] )
         ENDIF
         oParent:addChild( oItem )
         cDetails := ""
         FOR EACH hField IN hFields
            cDetails += hField:__enumKey() + " : " + Chr( 10 )
            xTmp := hField:__enumValue()
            IF HB_ISARRAY( xTmp )
               FOR EACH cValue IN xTmp
                  cDetails += "   " + cValue + Chr( 10 )
               NEXT
            ELSE
               cDetails += "   " + __hbqtXtoS( xTmp ) + Chr( 10 )
            ENDIF
         NEXT
         WITH OBJECT oChild := QTreeWidgetItem()
            :setFont( 0, QFont( "Courier New", 8 ) )
            :setText( 0, cDetails )
         ENDWITH
         oItem:addChild( oChild )
      ENDWITH
   NEXT
   ::oUI:splitter:hbSetSizes( { 350, 1200 } )
   ::oUI:treeErrorLog:show()
   RETURN NIL


METHOD HbQtLogAnalyzer:buildTableErrorlog()
   LOCAL aField, nField, hField, nColumns, hEntry, i, j, aTbl, s, xTmp, oItem, nTblRow, nTblCol, aMaxWidth
   LOCAL aColumns := {}
   LOCAL aTable := {}
   LOCAL oTable := ::oUI:tableErrorLog
   LOCAL nStrZ := iif( Len( ::aEntries ) > 9999, 5, iif( Len( ::aEntries ) > 999, 4, iif( Len( ::aEntries ) > 99, 3, 2 ) ) )

   AAdd( aColumns, { hb_ntos( Len( ::aEntries ) ), nStrZ, nStrZ, NIL, NIL  } )
   AAdd( aColumns, { "DateTime"     , 17, 10, NIL, NIL } )
   AAdd( aColumns, { "Description"  , 35,  0, NIL, NIL } )
   FOR EACH aField IN ::axAnalyze
      IF aField:__enumIndex() > 3
         AAdd( aColumns, { aField[ __DFN_FIELDNAME__ ], 15, 0, NIL, NIL } )
      ENDIF
   NEXT
   AAdd( aColumns, { "Unq", 4, 4, NIL, NIL } )
   nColumns := Len( aColumns )

   FOR i := 1 TO ::nTraceBacks
      aColumns[ nColumns - i, 2 ] := 35
   NEXT

   WITH OBJECT oTable
      :setSortingEnabled( .F. )
      :clear()
      :setColumnCount( nColumns - 1 )
      :setRowCount( Len( ::aEntries ) )

      FOR i := 1 TO nColumns - 1
         WITH OBJECT oItem := __tableWidgetItem( .T. )
            :setText( aColumns[ i,1 ] )
         ENDWITH
         :setHorizontalHeaderItem( i-1, oItem )
      NEXT
      WITH OBJECT :horizontalHeader()
         :setStretchLastSection( .T. )
         :setMinimumHeight( __hbqtPixelsByDPI( 32 ) )
         :setSectionsMovable( .T. )
      ENDWITH

      FOR EACH hEntry IN ::aEntries
         nTblRow := hEntry:__enumIndex() - 1
         hField := hEntry[ "fields" ]
         aTbl := AFill( Array( nColumns ), "" )

         WITH OBJECT oItem := __tableWidgetItem()
            :setText( StrZero( nTblRow + 1, nStrZ ) )
         ENDWITH
         oTable:setItem( nTblRow, 0, oItem )
         aTbl[ 1 ] := nTblRow + 1

         s := __ansiDateTime( DToC( hField[ "Date" ] ), hField[ "Time" ] )
         WITH OBJECT oItem :=__tableWidgetItem()
            :setText( s )
         ENDWITH
         oTable:setItem( nTblRow, 1, oItem )
         aTbl[ 2 ] := hField[ "Date" ]

         FOR EACH aField IN ::axAnalyze
            nField := aField:__enumIndex()
            IF nField > 2 .AND. nField <= Len( ::axAnalyze ) - ::nTraceBacks + 1
               nTblCol := nField - 1

               xTmp := ""
               IF hb_HHasKey( hField, aField[ __DFN_FIELDNAME__ ] )
                  xTmp := hField[ aField[ __DFN_FIELDNAME__ ] ]
               ENDIF
               IF HB_ISARRAY( xTmp )
                  FOR j := 1 TO ::nTraceBacks
                     s := ""
                     IF Len( xTmp ) >= j
                        s := xTmp[ j ]
                     ENDIF
                     WITH OBJECT oItem :=__tableWidgetItem()
                        :setText( s )
                     ENDWITH
                     oTable:setItem( nTblRow, nField + j - 2, oItem )
                     aTbl[ nField + j - 1 ] := s
                  NEXT
               ELSE
                  WITH OBJECT oItem :=__tableWidgetItem()
                     :setText( xTmp )
                  ENDWITH
                  oTable:setItem( nTblRow, nTblCol, oItem )
                  aTbl[ nField ] := xTmp
               ENDIF
            ENDIF
         NEXT

         aTbl[ nColumns ] := 1
         AAdd( aTable, aTbl )
         oTable:setRowHeight( nTblRow, __hbqtPixelsByDPI( 45 ) )
      NEXT
      :setSortingEnabled( .T. )
   ENDWITH

   aMaxWidth := {}
   IF ! Empty( aTable )
      FOR i := 1 TO Len( aTable[ 1 ] )
         IF ValType( aTable[ 1, i ] ) == "C"
            xTmp := 0
            FOR EACH aTbl IN aTable
               xTmp := Max( xTmp, Len( aTbl[ i ] ) )
            NEXT
            AAdd( aMaxWidth, xTmp )
         ELSE
            AAdd( aMaxWidth, 0 )
         ENDIF
      NEXT
      FOR i := 1 TO Len( aTable[ 1 ] )
         IF ValType( aTable[ 1, i ] ) == "C"
            FOR EACH aTbl IN aTable
               aTbl[ i ] := Pad( aTbl[ i ], aMaxWidth[ i ] )
            NEXT
         ENDIF
      NEXT
   ENDIF
   ::axTable := aTable
   ::axColumns := aColumns
   ::axMaxWidth := aMaxWidth
   ::adjustTableColumns( aColumns )
   RETURN NIL


METHOD HbQtLogAnalyzer:adjustTableColumns( aColumns )
   LOCAL i, nWidth
   LOCAL nPadding    := 10
   LOCAL oTable      := ::oUI:tableErrorLog
   LOCAL nCharWidth  := oTable:fontMetrics():width( "B" )
   LOCAL nCharWidthN := oTable:fontMetrics():width( "5" )
   LOCAL nRows       := Len( ::aEntries )
   LOCAL nRecWidth   := iif( nRows >= 10000, 5, iif( nRows >= 1000, 4, iif( nRows >= 100, 3, 2 ) ) )

   oTable:horizontalHeader():resizeSection( 0, nRecWidth * nCharWidthN + nPadding )

   FOR i := 2 TO Len( aColumns ) - 1
      nWidth := Max( aColumns[ i,2 ], Len( aColumns[ i,1 ] ) )
      oTable:horizontalHeader():resizeSection( i - 1, nWidth * nCharWidth + nPadding )
   NEXT
   RETURN NIL


METHOD HbQtLogAnalyzer:buildErrorsSummary()
   LOCAL oStrList, xTmp, i, byDate
   LOCAL oTree := ::oUI:treeNumbers()
   LOCAL oRoot := oTree:invisibleRootItem()
   LOCAL nColumns := Len( ::axColumns )

   WITH OBJECT oStrList := QStringList()
      :append( " Summary" )
      :append( "     Entries" )
      :append( "     Times" )
      :append( "     Notes" )
   ENDWITH
   oTree:setHeaderLabels( oStrList )
   oTree:Header():resizeSection( 1, 70 )
   oTree:Header():resizeSection( 2, 70 )

   FOR i := 2 TO nColumns - 1
      ::axColumns[ i, 5 ] := __populateSummary( oRoot, "By " + ::axColumns[ i, 1 ], ::axTable, i, nColumns )
   NEXT

   IF ! Empty( byDate := ::axColumns[ 2, 5 ] )
      WITH OBJECT ::oChart
         :setTitle( "Number of Errors by Date . " + DToC( byDate[ 1, 2 ] ) + "-" + DToC( byDate[ Len( byDate ), 2 ] ) + Chr( 10 ) )
         FOR EACH xTmp IN byDate
            :addItem( StrZero( Day( xTmp[ 2 ] ), 2 ), xTmp[ nColumns ] )
         NEXT
      ENDWITH
   ENDIF
   RETURN NIL


STATIC FUNCTION __populateSummary( oRoot, cLabel, aTable, nColumn, nColUnique )
   LOCAL dat_, oItem, oChild, aRec

   IF .T.
      dat_:=__hbqtAProcessUnique( aTable, { nColumn }, { nColUnique }, { "SUM" } )
      WITH OBJECT oItem :=__addTreeChild( oRoot, cLabel )
         :setText( 1, hb_ntos( Len( dat_ ) ) )
         :setWhatsThis( 0, "P:" + hb_ntos( nColumn ) )
      ENDWITH
      FOR EACH aRec IN dat_
         WITH OBJECT oChild :=__addTreeChild( oItem, __hbqtXToS( aRec[ nColumn ] ) )
            :setWhatsThis( 0, "C:" + hb_ntos( nColumn ) )
            :setText( 2, hb_ntos( aRec[ nColUnique ] ) )
            :setTextAlignment( 2, Qt_AlignRight )
         ENDWITH
      NEXT
   ENDIF
   HB_SYMBOL_UNUSED( oChild )
   RETURN dat_


METHOD HbQtLogAnalyzer:saveConfiguration( lSaveAs )
   LOCAL hHlg, hFld, cHlgFile

   DEFAULT lSaveAs TO .F.
   IF Empty( cHlgFile := ::oUI:editLoadHlg:text() )
      cHlgFile := hb_DirBase() + "default.hlg"
      ::oUI:editLoadHlg:setText( cHlgFile )
      lSaveAs := .T.
   ENDIF

   IF lSaveAs
      cHlgFile := HbQtOpenFileDialog( iif( Empty( ::oUI:editLoadHlg:text() ), hb_DirBase(), ::oUI:editLoadHlg:text() ), ;
                                          "Select a LogAnalyzer Definition File", "LogAnalyzer (*.hlg*)", .F., .T., NIL )
      IF Empty( cHlgFile )
         Alert( "Please provide a qualified LogAnalyzer definition file!" )
         RETURN NIL
      ENDIF
      IF ! Lower( Right( cHlgFile, 4 ) ) == ".hlg"
         cHlgFile := cHlgFile + ".hlg"
      ENDIF
   ENDIF

   hHlg := {=>}
   //
   WITH OBJECT ::oUI
      hHlg[ "entrytoken"  ] := :editEntryToken:text()
      hHlg[ "headerdlm"   ] := :editHdrDlm:text()
      hHlg[ "dateformat"  ] := :editDateFormat:text()
      hHlg[ "valueoffset" ] := :spinOffset:value()

      hFld := {=>}
      hFld[ "name"        ] := :editDateName:text()
      hFld[ "token"       ] := :editDateToken:text()
      hFld[ "expression"  ] := :editDateExp:text()
      hFld[ "index"       ] := :spinDateHdr:value()
      hFld[ "offset"      ] := :spinDateOff:value()
      hFld[ "active"      ] := :chkDateAtv:isChecked()
      //
      hHlg[ "fielddate"   ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editTimeName:text()
      hFld[ "token"       ] := :editTimeToken:text()
      hFld[ "expression"  ] := :editTimeExp:text()
      hFld[ "index"       ] := :spinTimeHdr:value()
      hFld[ "offset"      ] := :spinTimeOff:value()
      hFld[ "active"      ] := :chkTimeAtv:isChecked()
      //
      hHlg[ "fieldtime"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF3Name:text()
      hFld[ "token"       ] := :editF3Token:text()
      hFld[ "expression"  ] := :editF3Exp:text()
      hFld[ "index"       ] := :spinF3Hdr:value()
      hFld[ "offset"      ] := :spinF3Off:value()
      hFld[ "active"      ] := :chkF3Atv:isChecked()
      //
      hHlg[ "field03"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF4Name:text()
      hFld[ "token"       ] := :editF4Token:text()
      hFld[ "expression"  ] := :editF4Exp:text()
      hFld[ "index"       ] := :spinF4Hdr:value()
      hFld[ "offset"      ] := :spinF4Off:value()
      hFld[ "active"      ] := :chkF4Atv:isChecked()
      //
      hHlg[ "field04"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF5Name:text()
      hFld[ "token"       ] := :editF5Token:text()
      hFld[ "expression"  ] := :editF5Exp:text()
      hFld[ "index"       ] := :spinF5Hdr:value()
      hFld[ "offset"      ] := :spinF5Off:value()
      hFld[ "active"      ] := :chkF5Atv:isChecked()
      //
      hHlg[ "field05"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF6Name:text()
      hFld[ "token"       ] := :editF6Token:text()
      hFld[ "expression"  ] := :editF6Exp:text()
      hFld[ "index"       ] := :spinF6Hdr:value()
      hFld[ "offset"      ] := :spinF6Off:value()
      hFld[ "active"      ] := :chkF6Atv:isChecked()
      //
      hHlg[ "field06"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF7Name:text()
      hFld[ "token"       ] := :editF7Token:text()
      hFld[ "expression"  ] := :editF7Exp:text()
      hFld[ "index"       ] := :spinF7Hdr:value()
      hFld[ "offset"      ] := :spinF7Off:value()
      hFld[ "active"      ] := :chkF7Atv:isChecked()
      //
      hHlg[ "field07"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF8Name:text()
      hFld[ "token"       ] := :editF8Token:text()
      hFld[ "expression"  ] := :editF8Exp:text()
      hFld[ "index"       ] := :spinF8Hdr:value()
      hFld[ "offset"      ] := :spinF8Off:value()
      hFld[ "active"      ] := :chkF8Atv:isChecked()
      //
      hHlg[ "field08"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF9Name:text()
      hFld[ "token"       ] := :editF9Token:text()
      hFld[ "expression"  ] := :editF9Exp:text()
      hFld[ "index"       ] := :spinF9Hdr:value()
      hFld[ "offset"      ] := :spinF9Off:value()
      hFld[ "active"      ] := :chkF9Atv:isChecked()
      //
      hHlg[ "field09"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF10Name:text()
      hFld[ "token"       ] := :editF10Token:text()
      hFld[ "expression"  ] := :editF10Exp:text()
      hFld[ "index"       ] := :spinF10Hdr:value()
      hFld[ "offset"      ] := :spinF10Off:value()
      hFld[ "active"      ] := :chkF10Atv:isChecked()
      //
      hHlg[ "field10"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF11Name:text()
      hFld[ "token"       ] := :editF11Token:text()
      hFld[ "expression"  ] := :editF11Exp:text()
      hFld[ "index"       ] := :spinF11Hdr:value()
      hFld[ "offset"      ] := :spinF11Off:value()
      hFld[ "active"      ] := :chkF11Atv:isChecked()
      //
      hHlg[ "field11"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editF12Name:text()
      hFld[ "token"       ] := :editF12Token:text()
      hFld[ "expression"  ] := :editF12Exp:text()
      hFld[ "index"       ] := :spinF12Hdr:value()
      hFld[ "offset"      ] := :spinF12Off:value()
      hFld[ "active"      ] := :chkF12Atv:isChecked()
      //
      hHlg[ "field12"     ] := hFld

      hFld := {=>}
      hFld[ "name"        ] := :editTraceName:text()
      hFld[ "token"       ] := :editTraceToken:text()
      hFld[ "expression"  ] := :editTraceExp:text()
      hFld[ "index"       ] := :spinTraceHdr:value()
      hFld[ "offset"      ] := :spinTraceOff:value()
      hFld[ "active"      ] := :chkTraceAtv:isChecked()
      //
      hHlg[ "fieldtrace"  ] := hFld
   ENDWITH
   hHlg[ "ok" ] := .T.

   hb_MemoWrit( cHlgFile, hb_jsonEncode( hHlg, .T. ) )
   //
   ::oUI:editLoadHlg:setText( cHlgFile )
   ::loadConfiguration( cHlgFile )
   RETURN NIL


METHOD HbQtLogAnalyzer:loadFrom()
   LOCAL cHlgFile

   IF ! Empty( cHlgFile := HbQtOpenFileDialog( iif( Empty( ::oUI:editLoadHlg:text() ), hb_DirBase(), ::oUI:editLoadHlg:text() ), ;
                                                  "Select a LogAnalyzer Definition File", "LogAnalyzer (*.hlg*)", .F., .F., NIL ) )
      ::loadConfiguration( cHlgFile )
   ENDIF
   RETURN NIL


METHOD HbQtLogAnalyzer:clearConfiguration()
   WITH OBJECT ::oUI
      :editEntryToken:setText( "" )
      :editHdrDlm:setText( "" )
      :editDateFormat:setText( "" )
      :spinOffset:setValue( 0 )

      :editDateToken:setText( "" )
      :editDateExp:setText( "" )
      :spinDateHdr:setValue( 0 )
      :spinDateOff:setValue( 0 )
      :chkDateAtv:setChecked( .T. )

      :editTimeToken:setText( "" )
      :editTimeExp:setText( "" )
      :spinTimeHdr:setValue( 0 )
      :spinTimeOff:setValue( 0 )
      :chkTimeAtv:setChecked( .T. )

      :editF3Token:setText( "" )
      :editF3Exp:setText( "" )
      :spinF3Hdr:setValue( 0 )
      :spinF3Off:setValue( 0 )
      :chkF3Atv:setChecked( .T. )

      :editF4Name:setText( "" )
      :editF4Token:setText( "" )
      :editF4Exp:setText( "" )
      :spinF4Hdr:setValue( 0 )
      :spinF4Off:setValue( 0 )
      :chkF4Atv:setChecked( .F. )

      :editF5Name:setText( "" )
      :editF5Token:setText( "" )
      :editF5Exp:setText( "" )
      :spinF5Hdr:setValue( 0 )
      :spinF5Off:setValue( 0 )
      :chkF5Atv:setChecked( .F. )

      :editF6Name:setText( "" )
      :editF6Token:setText( "" )
      :editF6Exp:setText( "" )
      :spinF6Hdr:setValue( 0 )
      :spinF6Off:setValue( 0 )
      :chkF6Atv:setChecked( .F. )

      :editF7Name:setText( "" )
      :editF7Token:setText( "" )
      :editF7Exp:setText( "" )
      :spinF7Hdr:setValue( 0 )
      :spinF7Off:setValue( 0 )
      :chkF7Atv:setChecked( .F. )

      :editF8Name:setText( "" )
      :editF8Token:setText( "" )
      :editF8Exp:setText( "" )
      :spinF8Hdr:setValue( 0 )
      :spinF8Off:setValue( 0 )
      :chkF8Atv:setChecked( .F. )

      :editF9Name:setText( "" )
      :editF9Token:setText( "" )
      :editF9Exp:setText( "" )
      :spinF9Hdr:setValue( 0 )
      :spinF9Off:setValue( 0 )
      :chkF9Atv:setChecked( .F. )

      :editF10Name:setText( "" )
      :editF10Token:setText( "" )
      :editF10Exp:setText( "" )
      :spinF10Hdr:setValue( 0 )
      :spinF10Off:setValue( 0 )
      :chkF10Atv:setChecked( .F. )

      :editF11Name:setText( "" )
      :editF11Token:setText( "" )
      :editF11Exp:setText( "" )
      :spinF11Hdr:setValue( 0 )
      :spinF11Off:setValue( 0 )
      :chkF11Atv:setChecked( .F. )

      :editF12Name:setText( "" )
      :editF12Token:setText( "" )
      :editF12Exp:setText( "" )
      :spinF12Hdr:setValue( 0 )
      :spinF12Off:setValue( 0 )
      :chkF12Atv:setChecked( .F. )

      :editTraceName:setText( "" )
      :editTraceToken:setText( "" )
      :editTraceExp:setText( "" )
      :spinTraceHdr:setValue( 0 )
      :spinTraceOff:setValue( 0 )
      :chkTraceAtv:setChecked( .F. )

      :editLoadHlg:setText( "" )
   ENDWITH
   RETURN NIL


METHOD HbQtLogAnalyzer:loadConfiguration( cHlgFile )
   LOCAL cJson, hHlg, hFld, aHlg

   DEFAULT cHlgFile TO hb_DirBase() + "default.hlg"

   ::axDefintn := {}

   IF ! Empty( cHlgFile ) .AND. hb_FileExists( cHlgFile )
      IF ! Empty( cJson := hb_MemoRead( cHlgFile ) )
         hb_jsonDecode( cJson, @hHlg )
      ENDIF
      IF HB_ISHASH( hHlg ) .AND. ! Empty( hHlg ) .AND. hb_HHasKey( hHlg, "ok" ) .AND. hHlg[ "ok" ]
         ::oUI:editLoadHlg:setText( cHlgFile )
         ::cDefintnFile := cHlgFile

         WITH OBJECT ::oUI
            :editEntryToken:setText(  hHlg[ "entrytoken"  ] ) ; ::cEntryToken := hHlg[ "entrytoken"  ]
            :editHdrDlm:setText(      hHlg[ "headerdlm"   ] ) ; ::cHdrDlm     := hHlg[ "headerdlm"   ]
            :editDateFormat:setText(  hHlg[ "dateformat"  ] ) ; ::cDateFormat := hHlg[ "dateformat"  ]
            :spinOffset:setValue(     hHlg[ "valueoffset" ] ) ; ::nHdrOffset  := hHlg[ "valueoffset" ]

            hFld := hHlg[ "fielddate"   ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editDateName:setText(    hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editDateToken:setText(   hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editDateExp:setText(     hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinDateHdr:setValue(    hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinDateOff:setValue(    hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkDateAtv:setChecked(   hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "fieldtime"   ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editTimeName:setText(    hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editTimeToken:setText(   hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editTimeExp:setText(     hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinTimeHdr:setValue(    hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinTimeOff:setValue(    hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkTimeAtv:setChecked(   hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field03"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF3Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF3Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF3Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF3Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF3Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF3Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field04"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF4Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF4Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF4Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF4Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF4Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF4Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field05"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF5Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF5Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF5Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF5Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF5Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF5Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field06"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF6Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF6Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF6Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF6Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF6Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF6Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field07"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF7Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF7Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF7Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF7Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF7Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF7Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field08"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF8Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF8Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF8Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF8Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF8Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF8Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field09"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF9Name:setText(      hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF9Token:setText(     hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF9Exp:setText(       hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF9Hdr:setValue(      hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF9Off:setValue(      hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF9Atv:setChecked(     hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field10"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF10Name:setText(     hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF10Token:setText(    hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF10Exp:setText(      hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF10Hdr:setValue(     hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF10Off:setValue(     hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF10Atv:setChecked(    hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field11"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF11Name:setText(     hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF11Token:setText(    hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF11Exp:setText(      hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF11Hdr:setValue(     hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF11Off:setValue(     hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF11Atv:setChecked(    hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "field12"     ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editF12Name:setText(     hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editF12Token:setText(    hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editF12Exp:setText(      hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinF12Hdr:setValue(     hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinF12Off:setValue(     hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkF12Atv:setChecked(    hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]

            hFld := hHlg[ "fieldtrace"  ] ; aHlg := Array( 6 ) ; AAdd( ::axDefintn, aHlg )
            :editTraceName:setText(   hFld[ "name"        ] ) ; aHlg[ 1 ] := hFld[ "name"        ]
            :editTraceToken:setText(  hFld[ "token"       ] ) ; aHlg[ 2 ] := hFld[ "token"       ]
            :editTraceExp:setText(    hFld[ "expression"  ] ) ; aHlg[ 3 ] := hFld[ "expression"  ]
            :spinTraceHdr:setValue(   hFld[ "index"       ] ) ; aHlg[ 4 ] := hFld[ "index"       ]
            :spinTraceOff:setValue(   hFld[ "offset"      ] ) ; aHlg[ 5 ] := hFld[ "offset"      ]
            :chkTraceAtv:setChecked(  hFld[ "active"      ] ) ; aHlg[ 6 ] := hFld[ "active"      ]
         ENDWITH
      ENDIF
   ENDIF
   RETURN hHlg

//--------------------------------------------------------------------//
//                        CLASS HbQtLogGraphics
//--------------------------------------------------------------------//

#if defined( HBQT_WITH_CHARTS_SUPPORT )

CLASS HbQtLogGraphics

   DATA   oWidget
   DATA   oUI
   DATA   oParent
   DATA   aData
   DATA   dRefresh
   DATA   hDesc                                   INIT {=>}
   DATA   hSlots                                  INIT {=>}
   DATA   nErrors                                 INIT 0
   DATA   aPallete                                INIT {}
   DATA   dToday
   DATA   nMaxDesc
   DATA   cMaxDesc
   DATA   nMaxSlot
   DATA   nMaxBySlot

   DATA   oChartViewHrs
   DATA   oChartViewDesc
   DATA   oChartViewMonthlyDesc
   DATA   aBarSets
   DATA   aBarAnimations

   DATA   cTotalErr                               INIT ""
   DATA   cPeakErr                                INIT ""
   DATA   cTopErr                                 INIT ""
   DATA   nTotalErr                               INIT 0
   DATA   nPeakErr                                INIT 0
   DATA   nTopErr                                 INIT 0
   DATA   nStrIndex                               INIT 0
   DATA   nSpeed                                  INIT 200
   DATA   oTimer
   DATA   oTimerMonthlyDesc
   DATA   cLastDesc                               INIT ""

   DATA   oChartMonthlyNumbers

   ACCESS widget()                                INLINE ::oWidget

   METHOD init( oParent )
   METHOD create( oParent )

   METHOD show()
   METHOD hide()                                  INLINE ::oWidget:hide()
   METHOD setData( aData )                        INLINE iif( HB_ISARRAY( aData ), ::aData := aData, NIL ), ::refresh()
   METHOD refresh( dToday )
   METHOD loadPallete()
   METHOD displayBanner()
   METHOD buildChartDesc()
   METHOD buildChartHrs()
   METHOD buildChartMonthlyNumbers()
   METHOD buildChartMonthlyDesc( cDesc )
   METHOD refreshChartMonthlyDesc()

   ENDCLASS


METHOD HbQtLogGraphics:init( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent
   RETURN Self


METHOD HbQtLogGraphics:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::loadPallete()

   ::oUI := hbqtui_loggraphics( ::oParent )
   WITH OBJECT ::oWidget := ::oUI:widget()
      :setWindowFlags( Qt_Sheet )
      :connect( QEvent_Close, {|oEvent| oEvent:ignore(), ::hide() } )
   ENDWITH

   WITH OBJECT ::oChartViewDesc := QChartView( ::oWidget )
      :setRenderHint( QPainter_Antialiasing )
   ENDWITH
   ::oUI:hLayDesc:addWidget( ::oChartViewDesc )

   WITH OBJECT ::oChartViewHrs := QChartView( ::oWidget )
      :setRenderHint( QPainter_Antialiasing )
   ENDWITH
   ::oUI:hLayHourly:addWidget( ::oChartViewHrs )

   WITH OBJECT ::oChartViewMonthlyDesc := QChartView( ::oWidget )
      :setRenderHint( QPainter_Antialiasing )
   ENDWITH
   ::oUI:vLayMonthlyDesc:addWidget( ::oChartViewMonthlyDesc )

   WITH OBJECT ::oTimer := QTimer()
      :setInterval( ::nSpeed )
      :connect( "timeout()", {|| ::displayBanner() } )
      :start()
   ENDWITH

   ::refresh()

   WITH OBJECT ::oTimerMonthlyDesc := QTimer()
      :setInterval( 60000 )
      :connect( "timeout()", {|| ::refreshChartMonthlyDesc() } )
      :start()
   ENDWITH
   RETURN Self


METHOD HbQtLogGraphics:show()
   IF HB_ISOBJECT( __hbqtAppWidget() )
      ::oWidget:setGeometry( __hbqtAppWidget():geometry() )
      ::oWidget:move( __hbqtAppWidget():pos() )
   ENDIF
   ::oWidget:show()
   RETURN NIL


METHOD HbQtLogGraphics:buildChartDesc()
   LOCAL xTmp, nMax, nX, oAxisY, oBarSeries, oSet, oFont, nColor, oChartDesc, oGradient, oAnimtn

   nMax := 0
   ::cMaxDesc := ""
   FOR EACH nX IN ::hDesc
      IF nX > nMax
         nMax := nX
         ::cMaxDesc := nX:__enumKey()
      ENDIF
   NEXT
   ::nMaxDesc := nMax

   WITH OBJECT oAxisY := QBarCategoryAxis()
      :append( "Errors by Description" )
   ENDWITH

   IF ! HB_ISOBJECT( oBarSeries )
      WITH OBJECT oBarSeries := QBarSeries()
         :setBarWidth( 0.98 )
         :setLabelsVisible( .T. )
         :setLabelsPosition( QAbstractBarSeries_LabelsInsideEnd )
      ENDWITH
   ENDIF

   FOR EACH nX IN ::hDesc
      nColor := Max( 1, nX:__enumIndex() % Len( ::aPallete ) )
      oSet := NIL
      WITH OBJECT oSet := QBarSet( nX:__enumKey() )
         AAdd( ::aBarSets, oSet )
         //
         :append( nX )
         :setLabel( Left( nX:__enumKey(), 50 ) )
         :setLabelFont( QFont( "Arial Black", 12 ) )
         :setColor( ::aPallete[ nColor ] )
         :setLabelColor( ::aPallete[ nColor ]:darker() )
         :connect( "clicked(int)", __blockLabelClicked( ::oWidget, oSet ) )
         :connect( "hovered(bool,int)", __blockLabelHovered( oSet, Self ) )
#if 0
         //
         WITH OBJECT oAnimtn := QPropertyAnimation( oSet, "color" )
            :setStartValue( QVariant( ::aPallete[ nColor ] ) )
            :setEndValue( QVariant( ::aPallete[ nColor ]:darker() ) )
            :setDuration( 10000 )
         ENDWITH
         AAdd( ::aBarAnimations, oAnimtn )
#endif
      ENDWITH
      oBarSeries:append( oSet )
      oAnimtn:start()
   NEXT

   WITH OBJECT oFont := QFont()
      :setPixelSize( 18 )
   ENDWITH
   WITH OBJECT oChartDesc := QChart()
      :setMargins( QMargins( 10,10,10,10 ) )
      :setTitleFont( oFont )
      WITH OBJECT oGradient := QLinearGradient()
         :setStart( QPointF( 0, 0 ) )
         :setFinalStop( QPointF( 0, 1 ) )
         :setColorAt( 0.0, QColor( 255,255,255 ) )
         :setColorAt( 1.0, QColor( 210,210,210 ) )
         :setCoordinateMode( QGradient_ObjectBoundingMode )
      ENDWITH
      :setBackgroundBrush( QBrush( oGradient ) )
   ENDWITH

   WITH OBJECT oChartDesc
      :addSeries( oBarSeries )
      :createDefaultAxes()
      :setAxisX( oAxisY, oBarSeries )
      :setTitle( "Today by Description" )
      :setAnimationOptions( QChart_SeriesAnimations )
      //
      :legend():setAlignment( Qt_AlignBottom )
      :legend():setShowTooltips( .T. )
      //
      :axisY():setGridLineVisible( .F. )
   ENDWITH

   xTmp := ::oChartViewDesc:chart()
   ::oChartViewDesc:setChart( oChartDesc )
   HB_SYMBOL_UNUSED( xTmp )

   RETURN NIL


METHOD HbQtLogGraphics:refreshChartMonthlyDesc()
   LOCAL oSet, oS

   IF Empty( ::aBarSets )
      RETURN NIL
   ENDIF
   IF Empty( ::cLastDesc )
      ::cLastDesc := ::aBarSets[ 1 ]:label()
   ENDIF

   FOR EACH oS IN ::aBarSets
      IF oS:label() == ::cLastDesc
         oSet := iif( oS:__enumIndex() < Len( ::aBarSets ), ::aBarSets[ oS:__enumIndex() + 1 ], ::aBarSets[ 1 ] )
         EXIT
      ENDIF
   NEXT

   IF ! Empty( oSet )
      ::cLastDesc := oSet:label()
      ::buildChartMonthlyDesc( ::cLastDesc )
   ENDIF
   RETURN NIL


METHOD HbQtLogGraphics:buildChartMonthlyDesc( cDesc )
   LOCAL hEntry, hFields, hInfo, nDateLast, oAxisX, oLineSeries, nY, oChart, xTmp, nDay, oSet, oS, oFont, oGradient

   IF Empty( ::aBarSets )
      RETURN NIL
   ENDIF

   DEFAULT cDesc TO ::aBarSets[ 1 ]:label()

   nDateLast := Day( ::aData[ Len( ::aData ) ][ "fields" ][ "date" ] )

   FOR EACH oS IN ::aBarSets
      IF oS:label() == cDesc
         oSet := oS
         EXIT
      ENDIF
   NEXT

   hInfo := {=>}
   hb_HKeepOrder( hInfo )

   FOR EACH hEntry IN ::aData
      hFields := hEntry[ "fields" ]
      IF hFields[ "Description" ] == cDesc
         nDay := Day( hFields[ "date" ] )
         IF ! hb_HHasKey( hInfo, nDay )
            hInfo[ nDay ] := 0
         ENDIF
         hInfo[ nDay ]++
      ENDIF
   NEXT
   IF Empty( hInfo )
      RETURN NIL
   ENDIF

   WITH OBJECT oAxisX := QValueAxis()
      :setMin( 0.0 )
      :setMax( nDateLast )
      :setTickCount( nDateLast + 1 )
      :setLabelFormat( "%.0f" )
   ENDWITH

   WITH OBJECT oLineSeries := QLineSeries()
      FOR nY := 0 TO nDateLast
         IF hb_HHasKey( hInfo, nY )
            :append( nY, hInfo[ nY ] )
         ELSE
            :append( nY, 0 )
         ENDIF
      NEXT
      IF HB_ISOBJECT( oSet )
         :setPointLabelsColor( oSet:brush():color():darker() )
         :setColor( oSet:brush():color():darker() )
      ENDIF
   ENDWITH

   WITH OBJECT oFont := QFont()
      :setPixelSize( 18 )
   ENDWITH

   WITH OBJECT oChart := QChart()
      :setMargins( QMargins( 10,10,10,10 ) )
      :setTitleFont( oFont )
      :addSeries( oLineSeries )
      :createDefaultAxes()
      :setAxisX( oAxisX, oLineSeries )
      :setTitle( cMonth( ::aData[ 1 ][ "fields" ][ "date" ] ) + " by " + cDesc )
      :setAnimationOptions( QChart_SeriesAnimations )
      IF HB_ISOBJECT( oSet )
         :setTitleBrush( QBrush( oSet:brush():color():darker() ) )
      ENDIF
      WITH OBJECT oGradient := QLinearGradient()
         :setStart( QPointF( 0, 0 ) )
         :setFinalStop( QPointF( 0, 1 ) )
         :setColorAt( 0.0, QColor( 255,255,255 ) )
         :setColorAt( 0.3, QColor( 255,255,255 ) )
         :setColorAt( 1.0, oSet:brush():color() )
         :setCoordinateMode( QGradient_ObjectBoundingMode )
      ENDWITH
      :setBackgroundBrush( QBrush( oGradient ) )
   ENDWITH

   xTmp := ::oChartViewMonthlyDesc:chart()
   WITH OBJECT ::oChartViewMonthlyDesc
      :setChart( oChart )
   ENDWITH
   IF ! Empty( xTmp )
      xTmp:setParent( QWidget() )
   ENDIF
   RETURN NIL


METHOD HbQtLogGraphics:buildChartMonthlyNumbers()
   LOCAL hEntry, hFields, hInfo, xTmp

   IF ! HB_ISOBJECT( ::oChartMonthlyNumbers )
      WITH OBJECT ::oChartMonthlyNumbers := HbQtCharts():new( ::oUI:frameMonthlyNumbers ):create()
         :enableShadows( .F. )
         :enableLegend( .F. )
         :enableTitle( .T. )
         :enableToolbar( .F. )
         :widget():setMaximumHeight( 145 )
      ENDWITH
      ::oUI:hLayMonthlyNumbers:addWidget( ::oChartMonthlyNumbers:widget() )
      ::oChartMonthlyNumbers:widget():show()
   ENDIF
   ::oChartMonthlyNumbers:clear()
   IF .T.
      hInfo := {=>}
      hb_HKeepOrder( hInfo )
      FOR EACH hEntry IN ::aData
         hFields := hEntry[ "fields" ]
         IF ! hb_HHasKey( hInfo, hFields[ "date" ] )
            hInfo[ hFields[ "date" ] ] := 0
         ENDIF
         hInfo[ hFields[ "date" ] ]++
      NEXT
      IF ! Empty( hInfo )
         FOR EACH xTmp IN hInfo
            ::oChartMonthlyNumbers:addItem( StrZero( Day( xTmp:__enumKey() ), 2 ), xTmp )
         NEXT
      ENDIF
   ENDIF
   ::oChartMonthlyNumbers:setTitle( CMonth( ::aData[ 1 ][ "fields" ][ "date" ] ) + " " + Str( Year( ::aData[ 1 ][ "fields" ][ "date" ] ), 4, 0 ) + " Daily by Numbers")
   RETURN NIL


METHOD HbQtLogGraphics:buildChartHrs()
   LOCAL xTmp, oFont, nY, oAxisX, oAxisY, oLineSeries, oChartHrs, oGradient

   WITH OBJECT oFont := QFont()
      :setPixelSize( 18 )
   ENDWITH

   ::nMaxBySlot := 0
   ::nMaxSlot := ::hSlots[ 1 ]
   FOR EACH nY IN ::hSlots
      IF nY > ::nMaxBySlot
         ::nMaxSlot := nY:__enumIndex()
         ::nMaxBySlot := nY
      ENDIF
   NEXT
   ::nMaxSlot--

   WITH OBJECT oAxisY := QValueAxis()
      :setMin( 0.0 )
      :setMax( ::nMaxBySlot )
      :setTickCount( ::nMaxBySlot + 1 )
      :setLabelFormat( "%.0f" )
   ENDWITH
   WITH OBJECT oAxisX := QValueAxis()
      :setMin( 0.0 )
      :setMax( 24.0 )
      :setTickCount( 25 )
      :setLabelFormat( "%.0f" )
   ENDWITH

   oLineSeries := QLineSeries()
   FOR EACH nY IN ::hSlots
      oLineSeries:append( nY:__enumKey(), nY )
   NEXT

   WITH OBJECT oChartHrs := QChart()
      :setMargins( QMargins( 10,10,10,10 ) )
      :setTitleFont( oFont )
      WITH OBJECT oGradient := QLinearGradient()
         :setStart( QPointF( 0, 0 ) )
         :setFinalStop( QPointF( 0, 1 ) )
         :setColorAt( 0.0, QColor( 210,210,210 ) )
         :setColorAt( 1.0, QColor( 255,255,255 ) )
         :setCoordinateMode( QGradient_ObjectBoundingMode )
      ENDWITH
      :setBackgroundBrush( QBrush( oGradient ) )
   ENDWITH
   WITH OBJECT oChartHrs
      :addSeries( oLineSeries )
      :setAxisX( oAxisX, oLineSeries )
      :setAxisY( oAxisY )
      :setTitle( "Today by Hours" )
      :setAnimationOptions( QChart_SeriesAnimations )
      //:setTheme( QChart_ChartThemeBlueIcy )
   ENDWITH
   xTmp := ::oChartViewHrs:chart()
   WITH OBJECT ::oChartViewHrs
      :setChart( oChartHrs )
   ENDWITH
   HB_SYMBOL_UNUSED( xTmp )
   RETURN NIL


METHOD HbQtLogGraphics:refresh( dToday )
   LOCAL hEntry, hFields, nSecs, nSlot, nErrors, oSet
   LOCAL hSlots := {=>}
   LOCAL hDesc := {=>}

   IF Empty( ::aData )
      RETURN self
   ENDIF
   hb_HKeepOrder( hDesc, .F. )

   DEFAULT dToday TO ::aData[ Len( ::aData ) ][ "fields" ][ "date" ]
   ::dToday := dToday

   IF ! Empty( ::aBarSets )
      FOR EACH oSet IN ::aBarSets
         oSet:setParent( QWidget() )
      NEXT
   ENDIF
   ::aBarSets := {}
   ::aBarAnimations := {}

   hSlots[ 0.00 ] := 0
   FOR nSlot := 1 TO 24
      hSlots[ nSlot ] := 0
   NEXT

   nErrors := 0
   FOR EACH hEntry IN ::aData
      hFields := hEntry[ "fields" ]
      IF hFields[ "date" ] == dToday
         nErrors++
         nSecs := TimeToSec( hFields[ "time" ] )
         nSlot := __seconds2slot( nSecs )
         IF ! hb_HHasKey( hSlots, nSlot )
            hSlots[ nSlot ] := 0
         ENDIF
         hSlots[ nSlot ]++
         IF ! hb_HHasKey( hDesc, hFields[ "Description" ] )
            hDesc[ hFields[ "Description" ] ] := 0
         ENDIF
         hDesc[ hFields[ "Description" ] ]++
      ENDIF
   NEXT
   ::hDesc := hDesc
   ::hSlots := hSlots
   ::nErrors := nErrors

   ::buildChartMonthlyNumbers()
   //
   ::buildChartDesc()
   ::buildChartHrs()
   //
   ::buildChartMonthlyDesc()

   ::cTotalErr := "Total [ " + hb_ntos( ::nErrors ) + " ] " + __ansiDate( ::dToday )
   ::nTotalErr := Len( ::cTotalErr )
   ::cPeakErr  := "  Peak " + "[ " + hb_ntos( ::nMaxBySlot ) + " ] " + hb_ntos( ::nMaxSlot - 1 ) + ":00-" + hb_ntos( ::nMaxSlot ) + ":00"
   ::nPeakErr  := Len( ::cPeakErr )
   ::cTopErr   := "  Top "  + " [ " + hb_ntos( ::nMaxDesc ) + " ] " + Trim( Left( ::cMaxDesc, 30 ) )
   ::nTopErr   := Len( ::cTopErr )

   ::nStrIndex := 0
   WITH OBJECT ::oTimer
      :stop()
      :setInterval( 200 )
      :start()
   ENDWITH
   ::oUI:labelErrors:setText( "" )

   ::oUI:labelErrors:setAlignment( Qt_AlignHCenter )
   ::oUI:labelErrors:setText( "" )

   ::oUI:labelDesc:setText( __ansiDate( ::dToday ) + "  Errors  " + hb_ntos( ::nErrors ) )

   RETURN Self


METHOD HbQtLogGraphics:displayBanner()
   LOCAL cBanner

   IF ::oTimer:interval() == 30000
      WITH OBJECT ::oTimer
         :stop()
         :setInterval( 200 )
         :start()
      ENDWITH
   ENDIF
   ::oUI:labelErrors:setAlignment( Qt_AlignRight )

   ::nStrIndex++
   IF ::nStrIndex <= ::nTotalErr
      cBanner := "<font color=yellow>" + SubStr( ::cTotalErr, 1, ::nStrIndex ) + "</font>"
   ELSEIF ::nStrIndex <= ::nTotalErr + ::nPeakErr
      cBanner := "<font color=yellow>" + ::cTotalErr + "</font>" + ;
                 "<font color=cyan>"   + SubStr( ::cPeakErr, 1, ::nStrIndex - ::nTotalErr ) + "</font>"
   ELSEIF ::nStrIndex <= ::nTotalErr + ::nPeakErr + ::nTopErr
      cBanner := "<font color=yellow>" + ::cTotalErr + "</font>" + ;
                 "<font color=cyan>"   + ::cPeakErr + "</font>" + ;
                 "<font color=white>"  + SubStr( ::cTopErr, 1, ::nStrIndex - ::nTotalErr - ::nPeakErr ) + "</font>"
   ELSE
      cBanner := ""
      ::nStrIndex := 0
   ENDIF

   ::oUI:labelErrors:setText( cBanner )
   IF ::nStrIndex == ::nTotalErr + ::nPeakErr + ::nTopErr
      ::oUI:labelErrors:setAlignment( Qt_AlignHCenter )
      WITH OBJECT ::oTimer
         :stop()
         :setInterval( 30000 )
         :start()
      ENDWITH
   ENDIF
   RETURN NIL


METHOD HbQtLogGraphics:loadPallete()

   AAdd( ::aPallete, QColor( Qt_yellow    ) )
   AAdd( ::aPallete, QColor( Qt_green     ) )
   AAdd( ::aPallete, QColor( Qt_blue      ) )
   AAdd( ::aPallete, QColor( Qt_cyan      ) )
   AAdd( ::aPallete, QColor( Qt_magenta   ) )
   AAdd( ::aPallete, QColor( Qt_red       ) )
   AAdd( ::aPallete, QColor( Qt_lightGray ) )

   AAdd( ::aPallete, QColor( 255,250,205  ) )    // LemonChiffon
   AAdd( ::aPallete, QColor( 124,255,0    ) )    // ChartReuse
   AAdd( ::aPallete, QColor( 0  ,191,255  ) )    // DeepSkyblue
   AAdd( ::aPallete, QColor( 127,255,212  ) )    // Aquamarine
   AAdd( ::aPallete, QColor( 238,130,238  ) )    // Violet
   AAdd( ::aPallete, QColor( 220,20,60    ) )    // Crimson
   AAdd( ::aPallete, QColor( 119,136,53   ) )    // LightSlateGray

   AAdd( ::aPallete, QColor( 240,230,140  ) )    // Khaki
   AAdd( ::aPallete, QColor( 60 ,179,113  ) )    // MediumGreen
   AAdd( ::aPallete, QColor( 30 ,144,255  ) )    // DoggerBlue
   AAdd( ::aPallete, QColor( 64 ,224,208  ) )    // Turquoise
   AAdd( ::aPallete, QColor( 123,104,238  ) )    // MediumSlateBlue
   AAdd( ::aPallete, QColor( 240,128,128  ) )    // LightCoral
   AAdd( ::aPallete, QColor( 255,240,245  ) )    // LavendarBlush

   RETURN NIL


STATIC FUNCTION __seconds2slot( nSeconds )
   LOCAL n := nSeconds / 3600
   RETURN Int( n ) + 1


STATIC FUNCTION __blockLabelClicked( oWidget, oSet )
   RETURN {|| oWidget:setWindowTitle( oSet:label() ) }


STATIC FUNCTION __blockLabelHovered( oSet, oSelf )
   RETURN {||
               oSelf:buildChartMonthlyDesc( oSet:label() )
               RETURN NIL
          }

#else

CLASS HbQtLogGraphics

   METHOD init()
   METHOD create()
   METHOD setData()                               VIRTUAL
   METHOD show()                                  VIRTUAL

   ENDCLASS


METHOD HbQtLogGraphics:init()
   RETURN Self


METHOD HbQtLogGraphics:create()
   RETURN Self

#endif