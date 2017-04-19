/*
 * $Id$
 */

/* this file adapted for hbide from hwgdebug.prg by alex;(Alexey Zapolski(pepan@mail.ru))
 * (HWGUI - Harbour Win32 GUI library source code)
 * The GUI Debugger
 *
 * Copyright 2013 Alexander Kresin <alex@kresin.ru>
 * www - http://www.kresin.ru
 *
 * 2014 - Adopted for HbIDE by Alex <alexeyzapolskiy@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version, with one exception:
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


#include "fileio.ch"
#include "hbide.ch"
#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "inkey.ch"


#define MODE_INPUT                                1
#define MODE_INIT                                 2
#define MODE_WAIT_ANS                             3
#define MODE_WAIT_BR                              4

#define ANS_CMD                                   0
#define ANS_BRP                                   1
#define ANS_EXP                                  2
#define ANS_STACK                                 3
#define ANS_LOCAL                                 4
#define ANS_WATCH                                 5
#define ANS_AREAS                                 6
#define ANS_REC                                   7
#define ANS_OBJECT                                8
#define ANS_SETS                                  9
#define ANS_ARRAY                                 10
#define ANS_SETVAR                                11
#define ANS_QUIT                                  21

#define CMD_QUIT                                  1
#define CMD_GO                                    2
#define CMD_STEP                                  3
#define CMD_TRACE                                 4
#define CMD_NEXTR                                 5
#define CMD_TOCURS                                6
#define CMD_EXIT                                  7
#define CMD_STACK                                 8
#define CMD_EXP                                   9
#define CMD_LOCAL                                 10
#define CMD_STATIC                                11
#define CMD_PRIV                                  12
#define CMD_PUBL                                  13
#define CMD_WATCH                                 14
#define CMD_AREA                                  15
#define CMD_REC                                   16
#define CMD_OBJECT                                17
#define CMD_TERMINATE                             18
#define CMD_SETS                                  19
#define CMD_ARRAY                                 20
#define CMD_BRP                                   21
#define CMD_SETVAR                                22

#define WAIT_CMD_INIT                             60
#define WAIT_CMD_QUIT                             1
#define WAIT_CMD_GO                               3
#define WAIT_CMD_STEP                             3
#define WAIT_CMD_TRACE                            3
#define WAIT_CMD_NEXTR                            3
#define WAIT_CMD_TOCURS                           3
#define WAIT_CMD_EXIT                             3
#define WAIT_CMD_STACK                            30
#define WAIT_CMD_EXP                              30
#define WAIT_CMD_LOCAL                            30
#define WAIT_CMD_STATIC                           30
#define WAIT_CMD_PRIV                             30
#define WAIT_CMD_PUBL                             30
#define WAIT_CMD_WATCH                            30
#define WAIT_CMD_AREA                             60
#define WAIT_CMD_REC                              30
#define WAIT_CMD_OBJECT                           30
#define WAIT_CMD_SETS                             30
#define WAIT_CMD_ARRAY                            30
#define WAIT_CMD_BRP                              30
#define WAIT_CMD_SETVAR                           30

#define BUFFER_LEN                                1024

#define cMsgNotSupp                               "Command isn't supported"
#define C_C                                       " , "


#define MAIN_TAB_VARIABLES                        0
#define MAIN_TAB_WORKAREAS                        1
#define MAIN_TAB_WATCHES                          2
#define MAIN_TAB_STACK                            3
#define MAIN_TAB_SETS                             4

#define __DBG_BROWSER__
#define __UI_TABLES__


CLASS IdeDebugger INHERIT IdeObject

   DATA   oIde

   DATA   nRequestedVarsIndex                     INIT 0
   DATA   lLoaded                                 INIT .F.
   DATA   nRowWatch                               INIT -1
   DATA   nRowAreas                               INIT -1
   DATA   lDebugging                              INIT .F.
   DATA   hRequest                                INIT -1
   DATA   hResponse                               INIT -1
   DATA   nId1                                    INIT 0
   DATA   nId2                                    INIT -1

   DATA   cAppName                                INIT ""
   DATA   cPrgName                                INIT ""

   DATA   cInspectVar                             INIT ""
   DATA   cInspectTypes                           INIT ""
   DATA   cInspectType                            INIT ""

   DATA   aBP                                     INIT {}
   DATA   aWatches                                INIT {}
   DATA   aNWatches                               INIT {}
   DATA   nCurrLine                               INIT 0
   DATA   nMode                                   INIT MODE_INPUT
   DATA   nAnsType                                INIT 0
   DATA   cPrgBP                                  INIT ""
   DATA   nLineBP                                 INIT -1
   DATA   aBPLoad                                 INIT {}
   DATA   nBPLoad

   DATA   nExitMode                               INIT 2
   DATA   nVerProto                               INIT 0
   DATA   cLastMessage                            INIT ""

   DATA   oUI
   DATA   cCurrentProject                         INIT ""
   DATA   aTabs
   DATA   cBuffer
   DATA   lTerminated                             INIT .F.
   DATA   lStarted                                INIT .F.
   DATA   cExe                                    INIT ""
   DATA   oFileWatcher
   DATA   lExpanding                              INIT .F.
   DATA   cLastRequest                            INIT ""
   DATA   cLastResponse                           INIT ""
   DATA   hRequests                               INIT {=>}
   DATA   hResponses                              INIT {=>}
   DATA   lInRequest                              INIT .F.
   DATA   nOutput                                 INIT 0
   DATA   oAreaMenu
   DATA   btnLoadAll
   DATA   lVariableInEdit                         INIT .F.

   //  Browser Implementation
   //
   DATA   hBrowsers                               INIT {=>}
   DATA   cActiveBrowser                          INIT ""
   DATA   cAliasArea                              INIT ""

   METHOD init( oIde )
   METHOD create( oIde )
   METHOD start( cExe, cCmd, qStr, cWrkDir )
   METHOD quit()
   METHOD show()
   METHOD hide()
   METHOD clear()

   METHOD stopDebug()
   METHOD exitDbg()

   METHOD loadBreakPoints()
   METHOD clearBreakPoints( cPrg )
   METHOD deleteBreakPoint( cPrg, nLine )
   METHOD toggleBreakPoint( cAns, cLine )
   METHOD addBreakPoint( cPrg, nLine )

   METHOD watch_ins( lPaste, cWatch )
   METHOD watch_del( lAll )
   METHOD watch_save()
   METHOD watch_rest()
   METHOD changeWatch( item )

   METHOD populateResponse( arr )

   METHOD readResponse( cSource )
   METHOD doCommand( nCmd, cDop, cDop2, cDop3, cDop4, cDop5 )
   METHOD sendRequest( ... )

   METHOD setCurrLine( nLine, cName )
   METHOD getCurrLine()
   METHOD getCurrPrgName()
   METHOD getBP( nLine, cPrg )
   METHOD setWindow( cPrgName )

   METHOD editVariable( oItem )
   METHOD editVariableEx( oItem )
   METHOD inspectObject( lClicked )
   METHOD inspectObjectEx()
   METHOD manageObjectLevelUp()
   METHOD expandObject( nIndent, txt_ )
   METHOD expandObjectDetail( nIndent, txt_, cOriginVar )

   METHOD requestRecord( row, col )
   METHOD requestVars( index )
   METHOD requestObject()

   METHOD showStack( arr, n )
   METHOD showVars( arr, n, nVarType )
   METHOD showWatch( arr, n )
   METHOD showAreas( arr, n )
   METHOD showRec( arr, n )
   METHOD showObject( arr, n )
   METHOD showSets( arr, n )

   METHOD ui_init( oUI )
   METHOD ui_load()
   METHOD ui_loadAll()

   METHOD fineTune( oTable )
   METHOD waitState( nSeconds )
   METHOD copyOnClipboard()
   METHOD isActive()                              INLINE ! ::lTerminated
   METHOD raise()                                 INLINE ::oIde:oDebuggerDock:oWidget:raise()
   METHOD manageKey( nQtKey )
   METHOD matureShakehand()
   METHOD getRequestType( cId )
   METHOD processEvents()                         INLINE QApplication():processEvents()
   METHOD manageAreasContextManu( oPoint )
   METHOD openTableInIdeDBU( cTable, lByHbDBU )
   METHOD manageTabMain( index )
   METHOD copyStructToClipboard()
   METHOD isStopped()                             INLINE ::oUi:labelStatus:text() == "Stopped"
   METHOD manageTableVariablesClicked( oItem, cVariables )
   METHOD buildBrowsers()
   METHOD buildMdiBrowse( cTitle, aFields, aData )
   METHOD updateData( hBrowse, aData )
   METHOD emptyBrowsers()
   METHOD emptyBrowser( hBrowser )
   METHOD execMdiEvent( cEvent, p1 )
   METHOD manageNavigation( cBrowse, nKey, aXY, oBrw )
   METHOD isUIBrowsers()                          INLINE ( ::oUI:stackedWidget:currentIndex() == 0 )
   METHOD getUIState()
   METHOD restUIState( cState )
   METHOD setTitle( hBrowser )
   METHOD resizeSubWindows()

   ENDCLASS


METHOD IdeDebugger:init( oIde )
   DEFAULT oIde TO ::oIde
   ::oIde := oIde
   RETURN Self


METHOD IdeDebugger:create( oIde )

   DEFAULT oIde TO ::oIde
   ::oIde := oIde

   hb_HCaseMatch( ::hBrowsers, .F. )
   hb_HKeepOrder( ::hBrowsers, .T. )

   ::clear()

   ::cBuffer  := Space( BUFFER_LEN )
   ::aTabs    := ::oIde:aTabs
   ::oUI      := hbqtui_debugger2()
   ::ui_init( ::oUI )

   ::oDebuggerDock:oWidget:setWidget( ::oUI:oWidget )

   ::oFileWatcher := QFileSystemWatcher()
   ::oFileWatcher:connect( "fileChanged(QString)", {|cSource| ::readResponse( cSource ) } )
   //
   RETURN Self


METHOD IdeDebugger:clear()

   ::nRequestedVarsIndex    := 0
   ::lLoaded                := .F.
   ::lStarted               := .F.
   ::lTerminated            := .F.
   ::nRowWatch              := -1
   ::nRowAreas              := -1
   ::lDebugging             := .F.
   ::hRequest               := -1
   ::hResponse              := 0
   ::nId1                   := 0
   ::nId2                   := -1
   ::cAppName               := ""
   ::cPrgName               := ""
   ::cInspectVar            := ""
   ::cInspectType           := ""
   ::aBP                    := {}
   ::aWatches               := {}
   ::nCurrLine              := 0
   ::nMode                  := MODE_INPUT
   ::nAnsType               := NIL
   ::cPrgBP                 := ""
   ::nLineBP                := -1
   ::aBPLoad                := {}
   ::nBPLoad                := 0
   ::nExitMode              := 2
   ::nVerProto              := 0
   ::cLastRequest           := ""
   ::cLastResponse          := ""
   ::lInRequest             := .F.
   ::nOutput                := 0
   ::lVariableInEdit        := .F.

   ::hRequests              := {=>}
   ::hResponses             := {=>}
   //
   hb_HKeepOrder( ::hRequests , .T. )
   hb_HKeepOrder( ::hResponses, .T. )
   RETURN .T.


METHOD IdeDebugger:quit()
   IF ::isActive()
      ::doCommand( CMD_QUIT )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:hide()
   ::oIde:oDebuggerDock:oWidget:hide()
   RETURN Self


METHOD IdeDebugger:show()
   ::oIde:oDebuggerDock:oWidget:show()
   ::raise()
   RETURN Self


METHOD IdeDebugger:waitState( nSeconds )
   LOCAL nSecs := Seconds()
   DO WHILE Abs( Seconds() - nSecs ) < nSeconds
      ::processEvents()
      IF ! ::lInRequest
         EXIT
      ENDIF
   ENDDO
   RETURN NIL


METHOD IdeDebugger:start( cExe, cCmd, qStr, cWrkDir )
   LOCAL cPath, cFile, cExt

   ::oFileWatcher:removePath( ::cExe + ".d2" )

   hb_fNameSplit( cExe, @cPath, @cFile, @cExt )
   cWrkDir := hbide_pathToOSPath( iif( Empty( cWrkDir ), cPath, cWrkDir ) )

   ::cAppName := Lower( cFile + cExt )
   ::cExe := cExe

   FErase( cExe + ".d1" )
   FErase( cExe + ".d2" )
   IF ( ::hRequest := FCreate( cExe + ".d1" ) ) == -1
      Alert( "Previous instance still active, cannot continue." )
   ENDIF
   FWrite( ::hRequest, "init,!" )
   ::hResponse := FCreate( cExe + ".d2" )
   FClose( ::hResponse )
   FClose( ::hRequest )

   ::hRequest := FOpen( cExe + ".d1", FO_READWRITE + FO_SHARED )
   ::hResponse := FOpen( cExe + ".d2", FO_READ + FO_SHARED )
   IF ::hRequest == -1 .OR. ::hResponse == -1
      FClose( ::hResponse )
      FClose( ::hRequest )
      FErase( cExe + ".d1" )
      FErase( cExe + ".d2" )
      ::hRequest := ::hResponse := -1
      hbide_showWarning( "No Feasible Connection !!" )
      RETURN .F.
   ENDIF

   ::oFileWatcher:addPath( ::cExe + ".d2" )
   ::show()

   QProcess():startDetached( cCmd, qStr, cWrkDir )
   ::lInRequest := .T.
   ::waitState( WAIT_CMD_INIT )                               // duration can be controlled by user

   RETURN .T.


METHOD IdeDebugger:matureShakehand()
   ::lStarted := .T.
   ::lDebugging := .T.
   ::oPM:outputText( "Connected Successfully." )
   ::oPM:outputText( "Debug Started." )
   ::loadBreakPoints()
   ::doCommand( CMD_GO )
   RETURN NIL


METHOD IdeDebugger:readResponse( cSource )
   LOCAL cText, arr, i

   IF cSource == ::cExe + ".d2"
      ::processEvents()
      cText := hb_MemoRead( cSource )
      cText := substr( cText, 1, At( ",!", cText ) + 1 )
      arr   := hb_ATokens( cText, "," )
      ::oPM:outputText( "...........RESPONSE[ " + hb_ntos( ::nId1 ) + "." + ::cLastRequest + "] ... " + ;
                                                            arr[ 1 ] + "," + arr[ 2 ] + "," + ATail( arr ) )
      IF Left( arr[ 1 ], 1 ) == "m"
         FOR i := 3 TO Len( arr ) - 2
            ::oPM:outputText( Hex2Str( arr[ i ] ) )
         NEXT
         RETURN NIL
      ENDIF
      ::hResponses[ arr[ 1 ] ] := arr
      ::lInRequest := .F.
      ::populateResponse( arr )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:sendRequest( ... )
   LOCAL i, s, arr

   IF ::lStarted
      arr := hb_aParams()

      FSeek( ::hRequest, 0, 0 )
      s := ""
      FOR i := 1 TO Len( arr )
         s += arr[ i ] + ","
      NEXT
      ::cLastRequest := arr[ 1 ]

      ::lInRequest := .T.
      ::nId1++
      FWrite( ::hRequest, LTrim( Str( ::nId1 ) ) + "," + s + LTrim( Str( ::nId1 ) ) + ",!" )

      ::hRequests[ hb_ntos( ::nId1 ) ] := { arr, ::nAnsType, .F. }
      ::oPM:outputText( "REQUEST[" + hb_ntos( ::nId1 ) + "]..." + arr[ 1 ] + "," + arr[ 2 ] )
      ::processEvents()
   ENDIF
   //
   RETURN NIL


METHOD IdeDebugger:doCommand( nCmd, cDop, cDop2, cDop3, cDop4, cDop5 )
   LOCAL oCursor

   IF ! ::lStarted
      RETURN NIL
   ENDIF
   IF ::oUi:labelStatus:text() != "Stopped"
      RETURN NIL
   ENDIF
   IF ! ::isActive()
      RETURN NIL
   ENDIF

   DEFAULT cDop TO ""

   SWITCH nCmd
   CASE CMD_GO
      ::nAnsType := ANS_CMD
      ::oIde:qCurEdit:hbSetDebuggedLine( -1 )
      oCursor := ::oIde:qCurEdit:textCursor()
      oCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, 1 )
      ::oIde:qCurEdit:setTextCursor( oCursor )
      QApplication():processEvents()
      oCursor := ::oIde:qCurEdit:textCursor()
      oCursor:movePosition( QTextCursor_Up, QTextCursor_MoveAnchor, 1 )
      ::oIde:qCurEdit:setTextCursor( oCursor )
      QApplication():processEvents()

      ::oPM:outputText( "Command GO Issued."   )
      ::oPM:outputText( "Program Executing..." )
      ::oUi:labelStatus:setText( "Program Executing..." )
      ::sendRequest( "cmd", "go" )
      ::waitState( WAIT_CMD_GO )
      EXIT
   CASE CMD_STEP
      ::nAnsType := ANS_CMD
      ::oPM:outputText( "Command STEP Issued." )
      ::oPM:outputText( "Program Executing..." )
      ::oUi:labelStatus:setText( "Program Executing..." )
      ::sendRequest( "cmd", "step" )
      ::waitState( WAIT_CMD_STEP )
      EXIT
   CASE CMD_TOCURS
      ::nAnsType := ANS_CMD
      ::oPM:outputText( "Command TOCURS Issued." )
      ::oPM:outputText( "Program Executing..." )
      ::oUi:labelStatus:setText( "Program Executing..." )
      ::sendRequest( "cmd", "to", ::getCurrPrgName(), Ltrim( Str( ::getCurrLine() ) ) )
      ::waitState( WAIT_CMD_TOCURS )
      EXIT
   CASE CMD_TRACE
      ::nAnsType := ANS_CMD
      ::oPM:outputText( "Command TRACE Issued."   )
      ::oPM:outputText( "Program Executing..." )
      ::oUi:labelStatus:setText( "Program Executing..." )
      ::sendRequest( "cmd", "trace" )
      ::waitState( WAIT_CMD_TRACE )
      EXIT
   CASE CMD_NEXTR
      ::nAnsType := ANS_CMD
      ::oPM:outputText( "Command NEXTR Issued."   )
      ::oPM:outputText( "Program Executing..." )
      ::oUi:labelStatus:setText( "Program Executing..." )
      ::sendRequest( "cmd", "nextr" )
      ::waitState( WAIT_CMD_NEXTR )
      EXIT
   CASE CMD_SETVAR
      ::nAnsType := ANS_SETVAR
      ::sendRequest( "set", cDop, cDop2, cDop3, cDop4, cDop5 )
      ::waitState( WAIT_CMD_SETVAR )
      EXIT
   CASE CMD_EXP
      ::nAnsType := ANS_EXP
      ::sendRequest( "exp", cDop )
      ::waitState( WAIT_CMD_EXP )
      EXIT
   CASE CMD_STACK
      ::nAnsType := ANS_STACK
      ::sendRequest( "view", "stack", cDop )
      ::waitState( WAIT_CMD_STACK )
      EXIT
   CASE CMD_LOCAL
      ::nAnsType := ANS_LOCAL
      ::sendRequest( "view", "local", cDop )
      ::waitState( WAIT_CMD_LOCAL )
      EXIT
   CASE CMD_PRIV
      ::nAnsType := ANS_LOCAL
      ::sendRequest( "view", "priv", cDop )
      ::waitState( WAIT_CMD_PRIV )
      EXIT
   CASE CMD_PUBL
      ::nAnsType := ANS_LOCAL
      ::sendRequest( "view", "publ", cDop )
      ::waitState( WAIT_CMD_PUBL )
      EXIT
   CASE CMD_STATIC
      ::nAnsType := ANS_LOCAL
      ::sendRequest( "view", "static", cDop )
      ::waitState( WAIT_CMD_STATIC )
      EXIT
   CASE CMD_WATCH
      ::nAnsType := ANS_WATCH
      IF Empty( cDop2 )
         ::sendRequest( "view", "watch", cDop )
      ELSE
         ::sendRequest( "watch", cDop, cDop2 )
      ENDIF
      ::waitState( WAIT_CMD_WATCH )
      EXIT
   CASE CMD_AREA
      ::nAnsType := ANS_AREAS
      ::sendRequest( "view", "areas" )
      ::waitState( WAIT_CMD_AREA )
      EXIT
   CASE CMD_SETS
      ::nAnsType := ANS_SETS
      ::sendRequest( "view", "sets" )
      ::waitState( WAIT_CMD_SETS )
      EXIT
   CASE CMD_REC
      ::nAnsType := ANS_REC
      ::sendRequest( "insp", "rec", cDop )
      ::waitState( WAIT_CMD_REC )
      EXIT
   CASE CMD_OBJECT
      ::nAnsType := ANS_OBJECT
      ::sendRequest( "insp", "obj", cDop )
      ::waitState( WAIT_CMD_OBJECT )
      EXIT
   CASE CMD_ARRAY
      ::nAnsType := ANS_ARRAY
      ::sendRequest( "insp", "arr", cDop, "", "" )
      ::waitState( WAIT_CMD_ARRAY )
      EXIT
   CASE CMD_BRP
      ::nAnsType := ANS_BRP
      ::sendRequest( "brp", cDop, cDop2, cDop3 )
      ::waitState( WAIT_CMD_BRP )
      EXIT
   CASE CMD_QUIT
      ::nAnsType := ANS_QUIT
      ::sendRequest( "cmd", "quit" )
      ::waitState( WAIT_CMD_QUIT )
      ::stopDebug()
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD IdeDebugger:getRequestType( cId )
   LOCAL cReq

   IF Left( cID, 1 ) == "b"
      cReq := SubStr( cId, 2 )
      IF hb_HHasKey( ::hRequests, cReq )
         IF ! ::hRequests[ cReq ][ 3 ]
            ::hRequests[ cReq ][ 3 ] := .T.
            RETURN ::hRequests[ cReq ][ 2 ]
         ENDIF
      ENDIF
   ENDIF
   RETURN -1


METHOD IdeDebugger:populateResponse( arr )
   LOCAL n

   IF Empty( arr )
      RETURN NIL
   ENDIF
   IF arr[ 1 ] == "quit"
      RETURN ::stopDebug()
   ENDIF

   IF Left( arr[ 1 ], 1 ) == "b"
      SWITCH ::getRequestType( arr[ 1 ] )
      //
      CASE ANS_EXP                               // using as setting a variable
         IF arr[ 2 ] == "value"
            IF ! Empty( ::cInspectVar )
               IF Substr( Hex2Str( arr[ 3 ] ), 2, 1 ) == "O"
                  ::inspectObject( .F. )
                  RETURN NIL
               ELSE
                  ::oUI:tableObjectInspector:setRowCount( 0 )
                  hbide_showWarning( ::cInspectVar + " isn't an object" )
                  ::oUI:activateWindow()
               ENDIF
            ENDIF
            // value should be the same as sent
            ::oPM:outputText( Hex2Str( arr[ 3 ] ) )
         ELSE
            ::oPM:outputText( "-- BAD ANSWER --" )
         ENDIF
         EXIT
      CASE ANS_SETVAR
         IF arr[ 2 ] == "result"
            ::oPM:outputText( arr[ 3 ] )
         ELSE
            ::oPM:outputText( "-- BAD ANSWER --" )
         ENDIF
         EXIT
      CASE ANS_BRP
         IF arr[ 2 ] == "err"
            ::oPM:outputText( "-- BAD LINE --" )
            ::toggleBreakPoint( "line", Str( ::nLineBP ) )
         ELSE
            ::oPM:outputText( "Ok" )
            ::toggleBreakPoint( arr[ 2 ], arr[ 3 ] )
         ENDIF

         IF ! Empty( ::aBPLoad )
            IF ++::nBPLoad <= Len( ::aBPLoad )
               ::addBreakPoint( ::aBPLoad[ ::nBPLoad,2 ], ::aBPLoad[ ::nBPLoad,1 ] )
               RETURN NIL
            ELSE
               ::aBPLoad := {}
               ::oPM:outputText( "Breakpoints loaded." )
            ENDIF
         ENDIF
         EXIT
      CASE ANS_STACK
         IF arr[ 2 ] == "stack"
            ::showStack( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_LOCAL
         IF arr[ 2 ] == "valuelocal"
            ::showVars( arr, 3, 1 )
         ELSEIF arr[ 2 ] == "valuepriv"
            ::showVars( arr, 3, 2 )
         ELSEIF arr[ 2 ] == "valuepubl"
            ::showVars( arr, 3, 3 )
         ELSEIF arr[ 2 ] == "valuestatic"
            ::showVars( arr, 3, 4 )
         ENDIF
         EXIT
      CASE ANS_WATCH
         IF arr[ 2 ] == "valuewatch"
            ::showWatch( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_AREAS
         IF arr[ 2 ] == "valueareas"
            ::showAreas( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_SETS
         IF arr[ 2 ] == "valuesets"
            ::showSets( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_REC
         IF arr[ 2 ] == "valuerec"
            ::showRec( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_OBJECT
         IF arr[ 2 ] == "valueobj"
            ::showObject( arr, 3 )
         ENDIF
         EXIT
      CASE ANS_ARRAY
         IF arr[ 2 ] == "valuearr"
            ::showObject( arr, 3 )
         ENDIF
         EXIT
      ENDSWITCH

   ELSEIF Left( arr[ 1 ], 1 ) == "a"
      n := Val( SubStr( arr[ 1 ], 2 ) )

      ::nId2 := n
      IF arr[2] == "."
         ::oPM:outputText( "-- BAD LINE --" )
      ELSE
         ::oPM:outputText( "Program Stopped..." )
         ::oUi:labelStatus:setText( "Stopped" )

         ::ui_load()

         ::cPrgName := arr[ 2 ]
         ::setCurrLine( ::nCurrLine := Val( arr[ 3 ] ), ::cPrgName )
         ::cLastMessage := "Debugger (" + arr[ 2 ] + ", line " + arr[ 3 ] + ")"
         ::oPM:outputText( ::cLastMessage )

         ::oUI:show()
         ::oUI:activateWindow()
         IF arr[ 4 ] == "ver"
            ::matureShakehand()
         ENDIF
      ENDIF

   ELSEIF Left( arr[ 1 ], 1 ) == "e"
      ::oPM:outputText( "Unrecognized Command!" )

   ENDIF
   ::processEvents()

   RETURN NIL


METHOD IdeDebugger:loadBreakPoints()
   LOCAL i, oEditor, nBP, aBP, cSource

   ::aBPLoad := {}
   ::oPM:outputText( "Loading breakpoints..." )
   FOR i := 1 TO Len( ::aTabs )
      oEditor := ::aTabs[ i, TAB_OEDITOR ]
      cSource := Lower( hb_FNameName( oEditor:source() ) + hb_FNameExt( oEditor:source() ) )
      aBP := hb_ATokens( oEditor:oEdit:qEdit:hbGetBreakPoints(), "," )
      AEval( aBP, {|e,i| aBP[ i ] := Val( e ) } )
      FOR EACH nBP IN aBP
         IF nBP > 0
            AAdd( ::aBPLoad, { nBP, cSource } )
         ENDIF
      NEXT
   NEXT i
   IF ! Empty( ::aBPLoad )
      ::nBPLoad := 1
      ::addBreakPoint( ::aBPLoad[ 1,2 ], ::aBPLoad[ 1,1 ] )
   ENDIF
   RETURN .T.


// Also called from the editor when a line number area is clicked.
//
METHOD IdeDebugger:addBreakPoint( cPrg, nLine )
   LOCAL n

   IF nLine <= 0
      RETURN NIL
   ENDIF
   IF ( n := ::getBP( nLine, cPrg ) ) == 0
      ::oPM:outputText( "Setting break point: " + cPrg + ": " + Str( nLine ) )
      ::doCommand( CMD_BRP, "add", cPrg, LTrim( Str( nLine ) ) )
      AAdd( ::aBP, { nLine, cPrg } )
   ELSE
      ::oPM:outputText( "Deleting break point: " + cPrg + ": " + Str( nLine ) )
      ::doCommand( CMD_BRP, "del", cPrg, LTrim( Str( nLine ) ) )
      hb_ADel( ::aBP, n, .T. )
   ENDIF
   ::cPrgBP   := cPrg
   ::nLineBP  := nLine
   RETURN NIL


METHOD IdeDebugger:clearBreakPoints( cPrg )
   LOCAL n

   IF PCount() == 0
      cPrg := ""
   ENDIF
   FOR n := 1 TO Len( ::aBP )
      IF ( Empty( cPrg ) .OR. cPrg == ::aBP[ n,2 ] ) .AND. ::aBP[ n,1 ] <> 0
         ::deleteBreakPoint( ::aBP[ n,2 ], ::aBP[ n,1 ] )
      ENDIF
   NEXT
   RETURN .T.


METHOD IdeDebugger:toggleBreakPoint( cAns, cLine )
   LOCAL nLine := Val( cLine ), i

   IF cAns == "line"
      FOR i := 1 TO Len( ::aBP )
         IF ::aBP[ i,1 ] == 0
            ::aBP[ i,1 ] := nLine
            ::aBP[ i,2 ] := ::cPrgBP
            EXIT
         ENDIF
      NEXT
      IF i > Len( ::aBP )
         AAdd( ::aBP, { nLine, ::cPrgBP } )
      ENDIF
   ELSE
      IF ( i := ::getBP( nLine, ::cPrgBP ) ) == 0
         hbide_showWarning( "Error deleting BP line " + cLine )
         ::oUI:activateWindow()
      ELSE
         ::aBP[ i,1 ] := 0
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:deleteBreakPoint( cPrg, nLine )
   ::doCommand( CMD_BRP, "del", cPrg, LTrim( Str( nLine ) ) )
   ::cPrgBP   := cPrg
   ::nLineBP  := nLine
   RETURN .T.


METHOD IdeDebugger:getBP( nLine, cPrg )
   cPrg := Lower( iif( cPrg == NIL, ::cPrgName, cPrg ) )
   RETURN Ascan( ::aBP, {|a_| a_[ 1 ] == nLine .and. Lower( a_[ 2 ] ) == cPrg } )


METHOD IdeDebugger:setCurrLine( nLine, cName )
   LOCAL qCursor

   IF ! ::lDebugging
      ::lDebugging := .T.
   ENDIF
   IF ! Empty( ::oIde:qCurEdit )
      ::oIde:qCurEdit:hbSetDebuggedLine( -1 )
   ENDIF

   ::setWindow( cName )

   IF ! Empty( ::oIde:qCurEdit )
      ::oIde:qCurEdit:hbSetDebuggedLine( nLine )
      qCursor := ::oIde:qCurEdit:textCursor()

      qCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine - 1 )
      ::oIde:qCurEdit:setTextCursor( qCursor )
      ::oIde:qCurEdit:centerCursor()
   ENDIF
   ::oIde:manageFocusInEditor()
   ::oUI:activateWindow()
   RETURN NIL


METHOD IdeDebugger:getCurrLine()
   RETURN ::oIde:qCurEdit:textCursor():blockNumber() + 1


METHOD IdeDebugger:getCurrPrgName()
   LOCAL oEditor := ::oIde:oCurEditor
   RETURN oEditor:cFile + oEditor:cExt


METHOD IdeDebugger:setWindow( cPrgName )
   LOCAL qCursor, oSource, cSource, cPath, cName, cExt, cNme, cEtn
   LOCAL oProject := ::oPM:getProjectByTitle( ::cCurrentProject )

   cNme := Lower( hb_FNameName( cPrgName ) )
   cEtn := Lower( hb_FNameExt( cPrgName ) )
   FOR EACH oSource IN oProject:hSources
      hb_FNameSplit( oSource:original, @cPath, @cName, @cExt )
      IF Lower( cName ) + Lower( cExt ) == cNme + cEtn
         cSource := cPath + cName + cExt
         EXIT
      ENDIF
   NEXT
   IF Empty( cSource )
      FOR EACH cPath IN ::oINI:aSourcePaths
         IF hb_FileExists( hbide_pathToOSPath( cPath + cPrgName ) )
            cSource := hbide_pathToOSPath( cPath + cPrgName )
            EXIT
         ENDIF
      NEXT
   ENDIF
   IF ! Empty( cSource )
      ::oIde:oSM:editSource( cSource, 0, 0, 0, NIL, NIL, .F., .T., NIL, NIL, NIL )
      qCursor := ::oIde:qCurEdit:textCursor()
      qCursor:setPosition( 0 )
      ::oIde:qCurEdit:setTextCursor( qCursor )
   ELSE
      Alert( "Exact location of source " + cPrgName + " could not been detected." )
   ENDIF
   RETURN .T.


METHOD IdeDebugger:stopDebug()
   ::oFileWatcher:removePath( ::cExe + ".d2" )

   IF ! ::isActive()
      ::hide()
      RETURN Self
   ENDIF
   ::lDebugging := .F.
   ::oIde:qCurEdit:hbSetDebuggedLine( -1 )
   FClose( ::hRequest )
   FClose( ::hResponse )
   ::hRequest := ::hResponse := -1
   FErase( ::cExe + ".d1" )
   FErase( ::cExe + ".d2" )

   ::oUI:tableWatchExpressions:setRowCount( 0 )
   ::oUI:tableStack           :setRowCount( 0 )
   ::oUI:tableVarLocal        :setRowCount( 0 )
   ::oUI:tableVarPrivate      :setRowCount( 0 )
   ::oUI:tableVarPublic       :setRowCount( 0 )
   ::oUI:tableVarStatic       :setRowCount( 0 )
   ::oUI:tableOpenTables      :setRowCount( 0 )
   ::oUI:tableCurrentRecord   :setRowCount( 0 )
   ::oUI:tableObjectInspector :setRowCount( 0 )
   ::oUI:tableSets            :setRowCount( 0 )

   ::oUi:labelStatus:setText( "Debug Stopped and Exiting..." )
   ::oPM:outputText( "Debug Stopped and Exiting..." )
   ::hide()
   ::lTerminated := .T.
   RETURN NIL


METHOD IdeDebugger:exitDbg()
   IF ::nExitMode == 1
      IF ::hRequest != -1
         ::doCommand( CMD_EXIT, "exit" )
      ENDIF
   ELSEIF ::nExitMode == 2
      ::doCommand( CMD_QUIT, "quit" )
   ENDIF
   ::stopDebug()
   RETURN .T.


METHOD IdeDebugger:manageObjectLevelUp()
   LOCAL n, cObject

   IF Len( ::cInspectTypes ) > 1
      cObject := ::cInspectVar

      IF Right( cObject, 1 ) == "]"
         n := RAt( "[", cObject )
      ELSE
         n := RAt( ":", cObject )
      ENDIF
      cObject := SubStr( cObject, 1, n-1 )
      ::cInspectTypes := SubStr( ::cInspectTypes, 1, Len( ::cInspectTypes ) - 1 )

      ::cInspectVar := cObject
      ::cInspectType := Right( ::cInspectTypes, 1 )

      ::oUI:btnSubsObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )

      ::oUI:btnObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )
      ::requestObject()
   ENDIF
   RETURN NIL


METHOD IdeDebugger:inspectObjectEx()
   LOCAL oTable := ::oUI:tableObjectInspector
   LOCAL nIndex := oTable:currentRow()
   LOCAL oItem, cType, cObject, cOType

   IF nIndex >= 0
      IF ! Empty( oItem := oTable:item( nIndex, 1 ) )
         cType := oItem:text()
         IF cType $ "A,O"
            cObject := ::cInspectVar
            cOType  := ::cInspectType
            IF cType == "A"
               IF cOType == "O"
                  cObject := cObject + ":" + oTable:item( nIndex, 0 ):text()
               ELSE
                  cObject := cObject + "[" + hb_ntos( nIndex + 1 ) + "]"
               ENDIF
            ELSEIF cType == "O"
               IF cOType == "A"
                  cObject := cObject + "[" + hb_ntos( nIndex + 1 ) + "]"
               ELSE
                  cObject := cObject + ":" + oTable:item( nIndex, 0 ):text()
               ENDIF
            ENDIF
            ::cInspectVar   := cObject
            ::cInspectType  := cType
            ::cInspectTypes += cType
            ::oUI:btnObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )
            ::requestObject()
         ENDIF
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:manageTableVariablesClicked( oItem, cVariables )
   LOCAL oTable

   IF Empty( oItem )
      RETURN NIL
   ENDIF
   IF oItem:column() == 0
      ::inspectObject( .T. )
   ELSEIF oItem:column() == 4
      SWITCH cVariables
      CASE "Local"   ; oTable := ::oUI:tableVarLocal  ; EXIT
      CASE "Static"  ; oTable := ::oUI:tableVarStatic ; EXIT
      CASE "Public"  ; oTable := ::oUI:tableVarPublic ; EXIT
      CASE "Private" ; oTable := ::oUI:tableVarPrivate; EXIT
      ENDSWITCH
      IF oTable:item( oItem:Row(),1 ):text() $ "C,N,L,D"
         oTable:setCurrentItem( oItem )
         ::lVariableInEdit := .T.
         oTable:editItem( oItem )
      ENDIF
      //::editVariable( oItem )
   ENDIF
   HB_SYMBOL_UNUSED( cVariables )
   RETURN NIL


METHOD IdeDebugger:editVariableEx( oItem )
   LOCAL oTable, nIndex, cVar, cVal, xVal, nRow, cType, cVType, cT

   IF Empty( oItem )
      RETURN NIL
   ENDIF
   IF ! ::lVariableInEdit
      RETURN NIL
   ENDIF
   ::lVariableInEdit := .F.
   nIndex := ::oUI:tabWidgetVariables:currentIndex()
   DO CASE
   CASE nIndex == 0
      oTable := ::oUI:tableVarLocal
      cVType := "Local"
   CASE nIndex == 1
      oTable := ::oUI:tableVarPrivate
      cVType := "Private"
   CASE nIndex == 2
      oTable := ::oUI:tableVarPublic
      cVType := "Public"
   CASE nIndex == 3
      oTable := ::oUI:tableVarStatic
      cVType := "Static"
   ENDCASE
   IF oTable:rowCount() == 0
      RETURN NIL
   ENDIF

   nRow := oItem:row()
   cType := oTable:item( nRow, 1 ):text()
   IF cType $ "C,N,D,L"
      cVar := oTable:item( nRow, 0 ):text()
      cVal := oItem:text()
      xVal := iif( cType == "N", Val( cVal ), iif( cType == "D", CToD( cVal ), iif( cType == "L", iif( "T" $ Upper( cVal ), .T., .F. ), cVal ) ) )
      cT   := ValType( xVal )
      IF cT == "C"
         xVal := Trim( xVal )
         oItem:setText( xVal )
         xVal := StrTran( Trim( xVal ), '"' )
      ELSEIF cT == "N"
         oItem:setText( LTrim( Str( xVal ) ) )
      ELSEIF cT == "D"
         oItem:setText( DToC( xVal ) )
      ELSEIF cT == "L"
         oItem:setText( iif( xVal, ".T.", ".F." ) )
      ENDIF
      cVal := iif( cT == "N", LTrim( Str( xVal ) ), iif( cT == "D", DToS( xVal ), iif( cT == "L", iif( xVal, "T", "F" ), xVal ) ) )

      ::doCommand( CMD_SETVAR, ;
                              Str2Hex( cVar ), ;
                              Str2Hex( cVType + ":" + cType ), ;
                              Str2Hex( oTable:item( nRow, 2 ):text() ), ;
                              Str2Hex( oTable:item( nRow, 3 ):text() ), ;
                              Str2Hex( cVal ) )
   ENDIF

   RETURN NIL


METHOD IdeDebugger:editVariable( oItem )
   LOCAL oTable, nIndex, cVar, cVal, xVal, nRow, cType, cVType, cT, cPic, nWid, n

   IF Empty( oItem )
      RETURN NIL
   ENDIF
   nIndex := ::oUI:tabWidgetVariables:currentIndex()
   DO CASE
   CASE nIndex == 0
      oTable := ::oUI:tableVarLocal
      cVType := "Local"
   CASE nIndex == 1
      oTable := ::oUI:tableVarPrivate
      cVType := "Private"
   CASE nIndex == 2
      oTable := ::oUI:tableVarPublic
      cVType := "Public"
   CASE nIndex == 3
      oTable := ::oUI:tableVarStatic
      cVType := "Static"
   ENDCASE
   IF oTable:rowCount() == 0
      RETURN NIL
   ENDIF

   nRow := oItem:row()
   cType := oTable:item( nRow, 1 ):text()
   IF cType $ "C,N,D,L"
      cVar := oTable:item( nRow, 0 ):text()
      cVal := oItem:text()
      xVal := iif( cType == "N", Val( cVal ), iif( cType == "D", CToD( cVal ), iif( cType == "L", iif( "T" $ Upper( cVal ), .T., .F. ), cVal ) ) )
      cT   := ValType( xVal )
      nWid := Len( cVal )
      IF cT == "C"
         xVal := Pad( xVal, nWid * 2 )
      ELSEIF cT == "N"
         IF ( n := At( ".", cVal ) ) > 0
            nWid := Len( SubStr( cVal, n + 1 ) )
         ELSE
            nWid := 0
         ENDIF
         cPic := "@Z 999999999999" + iif( nWid > 0, "." + Replicate( "9", nWid ), "" )
      ENDIF
      xVal := HbQtBulkGet( xVal, cVar, cPic )
      IF cT == "C"
         xVal := Trim( xVal )
         oItem:setText( xVal )
         xVal := StrTran( Trim( xVal ), '"' )
      ELSEIF cT == "N"
         oItem:setText( LTrim( Str( xVal ) ) )
      ELSEIF cT == "D"
         oItem:setText( DToC( xVal ) )
      ELSEIF cT == "L"
         oItem:setText( iif( xVal, ".T.", ".F." ) )
      ENDIF
      cVal := iif( cT == "N", LTrim( Str( xVal ) ), iif( cT == "D", DToS( xVal ), iif( cT == "L", iif( xVal, "T", "F" ), xVal ) ) )

      ::doCommand( CMD_SETVAR, ;
                              Str2Hex( cVar ), ;
                              Str2Hex( cVType + ":" + cType ), ;
                              Str2Hex( oTable:item( nRow, 2 ):text() ), ;
                              Str2Hex( oTable:item( nRow, 3 ):text() ), ;
                              Str2Hex( cVal ) )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:inspectObject( lClicked )
   LOCAL index, oTable, nRow, cObjName
   LOCAL cType := ""

   IF lClicked
      ::oUI:btnObjBack:setEnabled( .F. )

      index := ::oUI:tabWidgetVariables:currentIndex()
      DO CASE
      CASE index = 0
         oTable := ::oUI:tableVarLocal
      CASE index = 1
         oTable := ::oUI:tableVarPrivate
      CASE index = 2
         oTable := ::oUI:tableVarPublic
      CASE index = 3
         oTable := ::oUI:tableVarStatic
      ENDCASE

      IF oTable:rowCount() == 0
         RETURN NIL
      ENDIF

      nRow := oTable:currentRow()
      IF nRow >= 0
         cType := oTable:item( nRow, 1 ):text()
      ENDIF
      IF ! ( cType $ "O,A" )
         hbide_showWarning( "Please select a variable of type O'bject or A'rray!" )
         ::oUI:activateWindow()
         RETURN NIL
      ENDIF

      cObjName := oTable:item( nRow, 0 ):text()
      ::cInspectVar := cObjName
      ::cInspectType := cType
      ::cInspectTypes := cType
   ENDIF

   ::requestObject()
   //
   RETURN NIL


STATIC FUNCTION __pullRecords( arr, n, nRecs, nFields, lHex )
   LOCAL i, j, d_
   LOCAL aRecs := {}

   DEFAULT lHex TO .T.

   FOR i := 1 TO nRecs
      d_:= Array( nFields )
      FOR j := 1 TO nFields
         d_[ j ] := AllTrim( iif( lHex, Hex2Str( arr[ ++n ] ), arr[ ++n ] ) )
      NEXT
      AAdd( aRecs, d_ )
   NEXT
   RETURN aRecs


STATIC FUNCTION __updateTable( oTable, aRecs, nFields )
   LOCAL i, j, nRecs

   IF oTable:isVisible()
      nRecs := Len( aRecs )
      oTable:setRowCount( nRecs )
      FOR i := 1 TO nRecs
         FOR j := 1 TO nFields
            oTable:setItem( i - 1, j - 1, QTableWidgetItem( aRecs[ i, j ] ) )
         NEXT
         QApplication():processEvents()
      NEXT
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showStack( arr, n )
   LOCAL aRecs
   LOCAL nRecs := Val( arr[ n ] )
   LOCAL nFields := 3

   IF ! Empty( aRecs :=__pullRecords( arr, n, nRecs, nFields, .F. ) )
      ::updateData( ::hBrowsers[ "Stack" ], aRecs )
      __updateTable( ::oUI:tableStack, aRecs, nFields )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showVars( arr, n, nVarType )
   LOCAL aRecs
   LOCAL nRecs   := Val( arr[ n ] )
   LOCAL nFields := 5
   LOCAL aTbl    := { ::oUI:tableVarLocal, ::oUI:tableVarPrivate, ::oUI:tableVarPublic, ::oUI:tableVarStatic }

   IF ! Empty( aRecs :=__pullRecords( arr, n, nRecs, nFields ) )
      DO CASE
      CASE nVarType = 1 ; ::updateData( ::hBrowsers[ "Locals"   ], aRecs, nFields )
      CASE nVarType = 2 ; ::updateData( ::hBrowsers[ "Privates" ], aRecs, nFields )
      CASE nVarType = 3 ; ::updateData( ::hBrowsers[ "Publics"  ], aRecs, nFields )
      CASE nVarType = 4 ; ::updateData( ::hBrowsers[ "Statics"  ], aRecs, nFields )
      ENDCASE

      __updateTable( aTbl[ nVarType ], aRecs, nFields )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showWatch( arr, n )
   LOCAL nWatch, cVal, d_, i
   LOCAL aRecs := {}
   LOCAL nRecs := Val( arr[ n ] )

   IF ::oUI:tableWatchExpressions:isVisible()
      FOR nWatch := 1 TO nRecs
         IF nWatch <= Len( ::aWatches )
            cVal := AllTrim( Hex2Str( arr[ ++n ] ) )
            AAdd( aRecs, { ::aWatches[ nWatch,2 ], cVal } )

            ::oUI:tableWatchExpressions:setItem( ::aWatches[ nWatch,1 ], 1, QTableWidgetItem( cVal ) )
         ENDIF
         ::processEvents()
      NEXT
   ELSE
      IF Empty( ::aNWatches )
         ::emptyBrowser( ::hBrowsers[ "Watches" ] )
      ELSE
         d_:= __pullRecords( arr, n, nRecs, 1 )
         IF ! Empty( d_ )
            FOR i := 1 TO Len( d_ )
               IF i <= Len( ::aNWatches )
                  AAdd( aRecs, { ::aNWatches[ i ], d_[ i,1 ] } )
               ENDIF
            NEXT
            IF ! Empty( aRecs )
               ::updateData( ::hBrowsers[ "Watches" ], aRecs )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showAreas( arr, n )
   LOCAL aRecs
   LOCAL nRecs   := Val( arr[ n ] )
   LOCAL nFields := Val( Hex2Str( arr[ ++n ] ) )

   IF ! Empty( aRecs :=__pullRecords( arr, n, nRecs, nFields ) )
      ::updateData( ::hBrowsers[ "Areas" ], aRecs )
      __updateTable( ::oUI:tableOpenTables, aRecs, nFields )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showRec( arr, n )
   LOCAL aRecs
   LOCAL nRecs   := Val( arr[ n ] )
   LOCAL nFields := 5
   LOCAL cAlias  := Trim( Hex2Str( arr[ ++n ] ) )
   LOCAL cRec    := Hex2Str( arr[ ++n ] )

   IF ! Empty( aRecs :=__pullRecords( arr, n, nRecs, nFields ) )
      ::hBrowsers[ "Record" ][ "ttl" ] := "[" + cAlias + ":" + cRec + "]"
      ::setTitle( ::hBrowsers[ "Record" ] )
      ::updateData( ::hBrowsers[ "Record" ], aRecs )
      ::oUI:labelCurrentRecord:setText( "Record Inspector [ " + cAlias + " : " + cRec + " ]" )
      __updateTable( ::oUI:tableCurrentRecord, aRecs, nFields )
   ELSE
      ::hBrowsers[ "Record" ][ "ttl" ] := ""
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showSets( arr, n )
   LOCAL aRecs
   LOCAL nRecs   := Val( arr[ n ] )
   LOCAL nFields := 2

   IF ! Empty( aRecs :=__pullRecords( arr, n, nRecs, nFields ) )
      ::updateData( ::hBrowsers[ "Sets" ], aRecs )
      __updateTable( ::oUI:tableSets, aRecs, nFields )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:showObject( arr, n )
   LOCAL i, j, d_, dat_
   LOCAL nLen := Val( arr[ n ] )

   IF nLen == 0
      ::oUI:tableObjectInspector:setRowCount( nLen )
      ::oUI:labelObjectInspector:setText( "Object Inspector" )
      ::cInspectVar := ""
      ::cInspectType := ""

      ::hBrowsers[ "Objects" ][ "ttl" ] := ""
      ::setTitle( ::hBrowsers[ "Objects" ] )
      ::updateData( ::hBrowsers[ "Objects" ], { ::hBrowsers[ "Objects" ][ "bln" ] } )
      RETURN NIL
   ENDIF
   IF ::oUI:tableObjectInspector:isVisible()
      ::oUI:tableObjectInspector:setRowCount( nLen )
      IF ::cInspectType == "O"
         ::oUI:labelObjectInspector:setText( "Object Inspector [" + ::cInspectVar + "]" )
         FOR i := 1 TO nLen
            FOR j := 1 TO 3
               ::oUI:tableObjectInspector:setItem( i - 1, j - 1, QTableWidgetItem( AllTrim( Hex2Str( arr[ ++n ] ) ) ) )
            NEXT
            ::processEvents()
         NEXT
      ELSEIF ::cInspectType == "A"
         ::oUI:labelObjectInspector:setText( "Array Inspector [" + ::cInspectVar + "]" )
         n += 2
         FOR i := 1 TO nLen
            ::oUI:tableObjectInspector:setItem( i - 1, 0, QTableWidgetItem( "E_" + hb_ntos( i ) ) )
            FOR j := 1 TO 2
               ::oUI:tableObjectInspector:setItem( i - 1, j, QTableWidgetItem( AllTrim( Hex2Str( arr[ ++n ] ) ) ) )
            NEXT
            ::processEvents()
         NEXT
      ENDIF
   ELSE
      IF ::cInspectType == "O"
         ::hBrowsers[ "Objects" ][ "ttl" ] := "[Object - " + ::cInspectVar + "]"
         ::setTitle( ::hBrowsers[ "Objects" ] )
         dat_:= __pullRecords( arr, n, nLen, 3 )
      ELSEIF ::cInspectType == "A"
         ::hBrowsers[ "Objects" ][ "ttl" ] := "[Array - " + ::cInspectVar + "]"
         ::setTitle( ::hBrowsers[ "Objects" ] )
         n += 2
         d_  := __pullRecords( arr, n, nLen, 2 )
         dat_:= {}
         FOR i := 1 TO Len( d_ )
            AAdd( dat_, { "E_" + hb_ntos( i ), d_[ i,1 ], d_[ i,2 ] } )
         NEXT
      ENDIF
      IF ! Empty( dat_ )
         ::updateData( ::hBrowsers[ "Objects" ], dat_ )
      ELSE
         ::updateData( ::hBrowsers[ "Objects" ], { ::hBrowsers[ "Objects" ][ "bln" ] } )
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:requestRecord( row, col )
   LOCAL item, cAlias

   IF ::oUi:labelStatus:text() != "Stopped"
      RETURN NIL
   ENDIF
   HB_SYMBOL_UNUSED( col )

   IF row == ::nRowAreas
      RETURN NIL
   ELSE
      ::nRowAreas := row
   ENDIF
   item := ::oUI:tableOpenTables:item( row, 0 )
   IF Left( item:text(), 1 ) == "*"
      cAlias := Right( item:text(), Len( item:text() ) - 1 )
   ELSE
      cAlias = item:text()
   ENDIF
   ::doCommand( CMD_REC, cAlias )
   RETURN NIL


METHOD IdeDebugger:requestObject()

   IF ::cInspectType == "O"
      ::doCommand( CMD_OBJECT, ::cInspectVar )
   ELSEIF ::cInspectType == "A"
      ::doCommand( CMD_ARRAY, ::cInspectVar  )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:requestVars( index )

   IF ::oUi:labelStatus:text() != "Stopped"
      RETURN NIL
   ENDIF
   ::nRequestedVarsIndex := index
   DO CASE
   CASE index == 0
      IF ::oUI:tableVarLocal:rowCount() == 0
         ::doCommand( CMD_LOCAL, "on" )
      ENDIF
   CASE index == 1
      IF ::oUI:tableVarPrivate:rowCount() == 0
         ::doCommand( CMD_PRIV, "on" )
      ENDIF
   CASE index == 2
      IF ::oUI:tableVarPublic:rowCount() == 0
         ::doCommand( CMD_PUBL, "on" )
      ENDIF
   CASE index == 3
      IF ::oUI:tableVarStatic:rowCount() == 0
         ::doCommand( CMD_STATIC, "on" )
      ENDIF
   ENDCASE
   //
   RETURN NIL


METHOD IdeDebugger:ui_load()
   LOCAL i, oItem

   IF ! ::isActive()
      RETURN Self
   ENDIF

   ::emptyBrowsers()

   ::hBrowsers[ "Record" ][ "ttl" ] := ""
   ::setTitle( ::hBrowsers[ "Record" ] )

   ::cInspectVar  := ""
   ::cInspectType := ""

   ::oUI:labelObjectInspector:setText( "Object Inspector" )
   ::oUI:labelOpenTables:setText( "Record Inspector" )

   ::oUI:tableVarLocal:setRowCount( 0 )
   ::oUI:tableVarPrivate:setRowCount( 0 )
   ::oUI:tableVarStatic:setRowCount( 0 )
   ::oUI:tableVarPublic:setRowCount( 0 )
   ::oUI:tableObjectInspector:setRowCount( 0 )
   //
   ::oUI:tableOpenTables:setRowCount( 0 )
   ::oUI:tableCurrentRecord:setRowCount( 0 )
   IF ::oUI:tableWatchExpressions:rowCount() > 0
      FOR i := 1 TO ::oUI:tableWatchExpressions:rowCount()
         IF ! Empty( oItem := ::oUI:tableWatchExpressions:item( i-1, 1 ) )
            oItem:setText( "" )
         ENDIF
         IF ! Empty( oItem := ::oUI:tableWatchExpressions:item( i-1, 2 ) )
            oItem:setText( "" )
         ENDIF
         ::processEvents()
      NEXT
   ENDIF
   //
   ::oUI:tableStack:setRowCount( 0 )
   //
   ::oUI:tableSets:setRowCount( 0 )

   ::processEvents()

   //::manageTabMain( Max( 0, ::oUI:tabWidgetMain:currentIndex() ) )
   ::ui_loadAll()

   ::nRowAreas := -1
   RETURN NIL


METHOD IdeDebugger:ui_loadAll()

   IF ::isStopped()
      ::manageTabMain( 0 )
      ::manageTabMain( 1 )
      ::manageTabMain( 2 )
      ::manageTabMain( 3 )
      ::manageTabMain( 4 )
      ::requestVars( 0 )
      ::requestVars( 1 )
      ::requestVars( 2 )
      ::requestVars( 3 )
      ::requestObject()
      IF ! Empty( ::cAliasArea )
         ::doCommand( CMD_REC, ::cAliasArea )
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:manageTabMain( index )
   SWITCH index
   CASE MAIN_TAB_VARIABLES
      ::requestVars( Max( 0, ::oUI:tabWidgetVariables:currentIndex() ) )
      EXIT
   CASE MAIN_TAB_WORKAREAS
      IF ::oUI:tableOpenTables:rowCount() == 0
         ::doCommand( CMD_AREA )
      ENDIF
      EXIT
   CASE MAIN_TAB_WATCHES
      ::doCommand( CMD_WATCH, "on" )
      EXIT
   CASE MAIN_TAB_STACK
      IF ::oUI:tableStack:rowCount() == 0
         ::doCommand( CMD_STACK, "on" )
      ENDIF
      EXIT
   CASE MAIN_TAB_SETS
      IF ::oUI:tableSets:rowCount() == 0
         ::doCommand( CMD_SETS )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD IdeDebugger:watch_save()
   LOCAL i, cFile, s, cPath, cName, cExt, oItem, aWatch
   LOCAL oTable   := ::oUI:tableWatchExpressions
   LOCAL nRows    := oTable:rowCount()
   LOCAL aWatches := {}

   IF ::isUIBrowsers()
      IF ! Empty( ::hBrowsers[ "Watches" ][ "dat" ][1,1] )
         FOR EACH aWatch IN ::hBrowsers[ "Watches" ][ "dat" ]
            AAdd( aWatches, aWatch[ 1 ] )
         NEXT
      ENDIF
   ELSE
      IF ::oUI:tableWatchExpressions:isVisible()
         FOR i := 1 TO nRows
            IF ! Empty( oItem := oTable:item( i-1, 0 ) ) .AND. ! Empty( oItem:text() )
               AAdd( aWatches, oItem:text() )
            ENDIF
         NEXT
      ELSE
         aWatches := ::aNWatches
      ENDIF
   ENDIF
   // how to get the BP from application ?
   IF ! Empty( aWatches )
      cFile := hbide_fetchAFile( ::oDlg, "Select IdeDebugger Watches|BP File", { { "IdeDebugger Watches|BP", "*.wch" } }, ;
                                      ::oPM:getProjectPathFromTitle( ::cCurrentProject ), "wch", .F. )
      IF ! Empty( cFile )
         hb_FNameSplit( cFile, @cPath, @cName, @cExt )
         IF ! ( Left( cName, Len( ::cCurrentProject ) ) == ::cCurrentProject )
            cName := ::cCurrentProject + "_" + cName
            IF Lower( cExt ) != ".wch"
               cExt := ".wch"
            ENDIF
         ENDIF
         cFile := cPath + cName + cExt
         s := "<WATCHES>" +  Chr( 13 )+Chr( 10 )
         AEval( aWatches, {|e| s += e + Chr( 13 )+Chr( 10 ) } )
         s += "</WATCHES>"
         hb_MemoWrit( cFile, s )
         IF hb_FileExists( cFile )
            Alert( "Watches|BP has been saved in " + cFile )
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeDebugger:watch_rest()
   LOCAL i, cFile, aWatches, cWatch, nSel, d_, lInit

   cFile := hbide_fetchAFile( ::oDlg, "Select a Watches|BP File", { { "Watches|BP", "*.wch" } }, ;
                                      ::oPM:getProjectPathFromTitle( ::cCurrentProject ), "wch", .F. )
   IF ! Empty( cFile ) .AND. hb_FileExists( cFile )
      d_:= hbide_readSource( cFile )
      aWatches := {}
      lInit := .F.
      FOR EACH cWatch IN d_
         IF cWatch == "<WATCHES>"
            lInit := .T.
            LOOP
         ELSEIF cWatch == "</WATCHES>"
            EXIT
         ENDIF
         IF lInit
            AAdd( aWatches, cWatch )
         ENDIF
      NEXT
      IF Len( aWatches ) == 0
         RETURN Self
      ENDIF
      nSel := Alert( "Merge with existing watches ?", { "Yes", "No" } )
      QApplication():processEvents()
   ENDIF
   IF Empty( aWatches )
      RETURN Self
   ENDIF

   IF ::oUI:tableWatchExpressions:isVisible()
      IF nSel != 1
         ::watch_del( .T. )
      ENDIF
      FOR EACH cWatch IN aWatches
         IF ! Empty( cWatch )
            ::watch_ins( .T., cWatch )
            QApplication():processEvents()
         ENDIF
      NEXT
   ELSE
      IF nSel != 1
         FOR i := Len( ::aNWatches ) TO 1 STEP -1
            ::doCommand( CMD_WATCH, "del", LTrim( Str( i ) ) )
         NEXT
         ::aNWatches := {}
         ::emptyBrowser( ::hBrowsers[ "Watches" ] )
      ENDIF
      FOR EACH cWatch IN aWatches
         IF ! Empty( cWatch )
            AAdd( ::aNWatches, cWatch )
            ::doCommand( CMD_WATCH, "add", Str2Hex( cWatch ) )
         ENDIF
      NEXT
   ENDIF
   RETURN Self


METHOD IdeDebugger:watch_ins( lPaste, cWatch )
   LOCAL i, oItem, nRow
   LOCAL oTable := ::oUI:tableWatchExpressions

   DEFAULT lPaste TO .F.
   IF lPaste
      DEFAULT cWatch TO ::oEM:getSelectedText()
   ELSE
      cWatch := ""
   ENDIF
   IF lPaste .AND. Empty( cWatch )
      RETURN Self
   ENDIF
   IF ::oUI:tableWatchExpressions:isVisible()
      FOR i := 1 TO oTable:rowCount()
         oItem := oTable:item( i - 1, 0 )
         IF oItem == NIL .OR. Empty( oItem:text() )
            EXIT
         ENDIF
      NEXT
      IF i > oTable:rowCount()
         oTable:insertRow( oTable:rowCount() )
         nRow := oTable:rowCount() - 1
         AAdd( ::aWatches, { nRow, cWatch } )
      ELSE
         nRow := i - 1
      ENDIF
      oTable:setItem( nRow, 0, QTableWidgetItem( cWatch ) )
      ::waitState( 0.25 )
   ELSE
      IF Empty( cWatch )
         cWatch := AllTrim( HbQtBulkGet( Space( 240 ), "Watch Exp ?", "@S50" ) )
      ENDIF
      IF ! Empty( cWatch )
         AAdd( ::aNWatches, cWatch )
         ::doCommand( CMD_WATCH, "add", Str2Hex( cWatch ) )
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:watch_del( lAll )
   LOCAL i, nn
   LOCAL oTable := ::oUI:tableWatchExpressions
   LOCAL nRow   := oTable:currentRow()
   local ri     := 0
   LOCAL nEmptyNames := 0

   DEFAULT lAll TO .F.

   IF ::oUI:tableWatchExpressions:isVisible()
      IF ! lAll .AND. nRow < 0
         RETURN NIL
      ELSEIF lAll .AND. oTable:rowCount() == 0
         RETURN NIL
      ENDIF
      FOR i := 0 TO nRow
         IF Empty( ::aWatches[ i+1, 2 ] )
            nEmptyNames++
         ENDIF
      NEXT
      IF lAll
         DO WHILE ! Empty( ::aWatches )
            nn := Len( ::aWatches )
            IF ! Empty( ::aWatches[ nn,2 ] )
               hb_ADel( ::aWatches, nn, .T. )
               ::doCommand( CMD_WATCH, "del", LTrim( Str( nn - nEmptyNames ) ) )
            ENDIF
            ::processEvents()
         ENDDO
         oTable:setRowCount( 0 )
      ELSE
         FOR i := 1 TO Len( ::aWatches )
            IF ::aWatches[ i,1 ] == nRow
               ri := i
               IF ! Empty( ::aWatches[ i,2 ] )
                  ::doCommand( CMD_WATCH, "del", LTrim( Str( i - nEmptyNames ) ) )
               ENDIF
            ENDIF
            IF ::aWatches[ i,1 ] > nRow
               --::aWatches[ i,1 ]
            ENDIF
         NEXT
         IF ri > 0
            hb_ADel( ::aWatches, ri, .T. )
         ENDIF
         oTable:removeRow( nRow )
      ENDIF
   ELSE
      IF lAll
         FOR nRow := Len( ::aNWatches ) TO 1 STEP -1
            ::doCommand( CMD_WATCH, "del", LTrim( Str( nRow ) ) )
         NEXT
         ::aNWatches := {}
         ::emptyBrowser( ::hBrowsers[ "Watches" ] )
      ELSE
         IF ( nRow := ::hBrowsers[ "Watches" ][ "rec" ] ) > 0
            IF ! Empty( ::hBrowsers[ "Watches" ][ "dat" ][ nRow, 1 ] )
               hb_ADel( ::aNWatches, nRow, .T. )
               ::doCommand( CMD_WATCH, "del", LTrim( Str( nRow ) ) )
            ENDIF
         ENDIF
      ENDIF

   ENDIF
   RETURN NIL


METHOD IdeDebugger:changeWatch( item )
   LOCAL i, xTmp
   LOCAL r := 0
   LOCAL nEmptyNames := 0

   IF item:column() == 0
      ::nRowWatch := item:Row()
      FOR i := 0 TO ::nRowWatch
         IF Empty( ::aWatches[ i+1, 2 ] )
            nEmptyNames++
         ENDIF
      NEXT

      FOR i := 1 TO Len( ::aWatches )
         IF ::aWatches[ i, 1 ] == ::nRowWatch
            IF Empty( item:text() )
               item:setText( ::aWatches[ i, 2 ] )
               RETURN NIL
            ENDIF
            IF Empty( ::aWatches[ i, 2 ] )
               ::aWatches[ i, 2 ] := item:text()
            ELSE
               IF ! Empty( xTmp := ::oUI:tableWatchExpressions:item( ::nRowWatch, 1 ) )
                  r := i
                  ::doCommand( CMD_WATCH, "del", Ltrim( Str( i - nEmptyNames ) ) )
               ENDIF
            ENDIF
         ENDIF
      NEXT

      IF ! Empty( item:text() )
         IF r > 0
            hb_ADel( ::aWatches, r, .T. )
            AAdd( ::aWatches, { ::nRowWatch, item:text() } )
         ENDIF
         ::doCommand( CMD_WATCH, "add", Str2Hex( item:text() ) )
      ELSE
         ::aWatches[ r,2 ] := ""
      ENDIF
   ENDIF
   HB_SYMBOL_UNUSED( xTmp )
   RETURN NIL


METHOD IdeDebugger:ui_init( oUI )
   LOCAL oHeaders

   oUI:stackedWidget:setCurrentIndex( 0 )
   ::buildBrowsers()

   oUI:tabWidgetMain:setCurrentIndex( 0 )
   oUI:tabWidgetVariables:setCurrentIndex( 0 )

   WITH OBJECT ::btnLoadAll := QToolButton( oUI:tabWidgetMain )
      :setIcon( QIcon( hbide_image( "go-jump" ) ) )
      :setTooltip( "Downlaod All Info" )
      :setAutoRaise( .T. )
      :connect( "clicked()", {|| ::ui_LoadAll() } )
   ENDWITH
   oUI:tabWidgetMain:setCornerWidget( ::btnLoadAll )

   WITH OBJECT oHeaders := QStringList()
      :append( "Expression" )
      :append( "Value"      )
   ENDWITH
   oUI:tableWatchExpressions:setHorizontalHeaderLabels( oHeaders )
   ::fineTune( oUI:tableWatchExpressions )
   oUI:tableWatchExpressions:setEditTriggers( QAbstractItemView_DoubleClicked )

   WITH OBJECT oHeaders := QStringList()
      :append( "Source" )
      :append( "Proc"   )
      :append( "Line"   )
   ENDWITH
   oUI:tableStack:setHorizontalHeaderLabels( oHeaders )
   ::fineTune( oUI:tableStack )

   WITH OBJECT oHeaders := QStringList()
      :append( "Name"  )
      :append( "Typ"   )
      :append( "Lvl"   )
      :append( "Pos"   )
      :append( "Value" )
   ENDWITH
   oUI:tableVarLocal  :setHorizontalHeaderLabels( oHeaders )
   oUI:tableVarPrivate:setHorizontalHeaderLabels( oHeaders )
   oUI:tableVarPublic :setHorizontalHeaderLabels( oHeaders )
   oUI:tableVarStatic :setHorizontalHeaderLabels( oHeaders )

   ::fineTune( oUI:tableVarLocal   )
   ::fineTune( oUI:tableVarPrivate )
   ::fineTune( oUI:tableVarPublic  )
   ::fineTune( oUI:tableVarStatic  )

   WITH OBJECT oHeaders := QStringList()
      :append( "Alias"           )
      :append( "Area"            )
      :append( "Rdd"             )
      :append( "Records"         )
      :append( "Current"         )
      :append( "Bof"             )
      :append( "Eof"             )
      :append( "Found"           )
      :append( "Del"             )
      :append( "Ord"             )
      :append( "OrdName"         )
      :append( "OrdExpression"   )
      :append( "Filter"          )
      :append( "TablePath"       )
      :append( "IndexPath"       )
      :append( "AllIndexes"      )
   ENDWITH
   oUI:tableOpenTables:setHorizontalHeaderLabels( oHeaders )
   oUI:tableOpenTables:setContextMenuPolicy( Qt_CustomContextMenu )
   oUI:tableOpenTables:connect( "customContextMenuRequested(QPoint)", {|oPoint| ::manageAreasContextManu( oPoint ) } )
   ::fineTune( oUI:tableOpenTables )

   WITH OBJECT oHeaders := QStringList()
      :append( "Field" )
      :append( "Typ"   )
      :append( "Len"   )
      :append( "Dec"   )
      :append( "Value" )
   ENDWITH
   oUI:tableCurrentRecord:setHorizontalHeaderLabels( oHeaders )
   ::fineTune( oUI:tableCurrentRecord )

   WITH OBJECT oHeaders := QStringList()
      :append( "Name"  )
      :append( "Typ"   )
      :append( "Value" )
   ENDWITH
   oUI:tableObjectInspector:setHorizontalHeaderLabels( oHeaders )
   ::fineTune( oUI:tableObjectInspector )

   WITH OBJECT oHeaders := QStringList()
      :append( "Set"   )
      :append( "Value" )
   ENDWITH
   oUI:tableSets:setHorizontalHeaderLabels( oHeaders )
   ::fineTune( oUI:tableSets )

   oUI:btnStructure         :connect( "clicked()", { || ::copyStructToClipboard() } )
   oUI:btnExpand            :connect( "clicked()", { || ::expandObject() } )
   oUI:btnObjBack           :connect( "clicked()", { || ::manageObjectLevelUp() } )
   oUI:btnObjBack:setEnabled( .F. )

   oUI:btnGo                :connect( "clicked()", { || ::doCommand( CMD_GO     ), ::waitState( 0.2 ) } )
   oUI:btnNextR             :connect( "clicked()", { || ::doCommand( CMD_NEXTR  ), ::waitState( 0.2 ) } )
   oUI:btnStep              :connect( "clicked()", { || ::doCommand( CMD_STEP   ), ::waitState( 0.2 ) } )
   oUI:btnToCursor          :connect( "clicked()", { || ::doCommand( CMD_TOCURS ), ::waitState( 0.2 ) } )
   oUI:btnTrace             :connect( "clicked()", { || ::doCommand( CMD_TRACE  ), ::waitState( 0.2 ) } )
   oUI:btnClipboard         :connect( "clicked()", { || ::copyOnClipboard() } )
   oUI:btnToggleUI          :connect( "clicked()", { || ::oUI:stackedWidget:setCurrentIndex( iif( ::isUIBrowsers(), 1, 0 ) ) } )
   oUI:btnExit              :connect( "clicked()", { || ::nExitMode := 2, ::exitDbg()         } )

   oUI:btnAddWatch          :connect( "clicked()", { || ::watch_ins()       } )
   oUI:btnPasteWatch        :connect( "clicked()", { || ::watch_ins( .T. )  } )
   oUI:btnDeleteWatch       :connect( "clicked()", { || ::watch_del()       } )
   oUI:btnClearWatches      :connect( "clicked()", { || ::watch_del( .T. )  } )
   oUI:btnSaveWatches       :connect( "clicked()", { || ::watch_save()      } )
   oUI:btnRestWatches       :connect( "clicked()", { || ::watch_rest()      } )

   oUI:tableWatchExpressions:connect( "itemChanged(QTableWidgetItem*)"      , {| oItem | ::changeWatch( oItem )         } )
   oUI:tableOpenTables      :connect( "cellActivated(int,int)"              , {| row, col | ::requestRecord( row, col ) } )
   oUI:tabWidgetVariables   :connect( "currentChanged(int)"                 , {| nIndex | ::requestVars( nIndex )       } )
   oUI:tabWidgetMain        :connect( "currentChanged(int)"                 , {| nIndex | ::manageTabMain( nIndex )     } )

   oUI:tableObjectInspector :connect( "itemDoubleClicked(QTableWidgetItem*)", {|/*oItem*/| ::inspectObjectEx() } )

   oUI                      :connect( QEvent_KeyPress        , {|oEvent| ::manageKey( oEvent:key() ) } )

   // Variables Tab
   oUI:tableVarLocal        :connect( "itemDoubleClicked(QTableWidgetItem*)", {| oItem | ::manageTableVariablesClicked( oItem, "Local"   ) } )
   oUI:tableVarPrivate      :connect( "itemDoubleClicked(QTableWidgetItem*)", {| oItem | ::manageTableVariablesClicked( oItem, "Private" ) } )
   oUI:tableVarPublic       :connect( "itemDoubleClicked(QTableWidgetItem*)", {| oItem | ::manageTableVariablesClicked( oItem, "Public"  ) } )
   oUI:tableVarStatic       :connect( "itemDoubleClicked(QTableWidgetItem*)", {| oItem | ::manageTableVariablesClicked( oItem, "Static"  ) } )

   oUI:tableVarLocal        :connect( "itemChanged(QTableWidgetItem*)", {| oItem | iif( oItem:column() == 4, ::editVariableEx( oItem ), NIL ) } )
   oUI:tableVarPrivate      :connect( "itemChanged(QTableWidgetItem*)", {| oItem | iif( oItem:column() == 4, ::editVariableEx( oItem ), NIL ) } )
   oUI:tableVarPublic       :connect( "itemChanged(QTableWidgetItem*)", {| oItem | iif( oItem:column() == 4, ::editVariableEx( oItem ), NIL ) } )
   oUI:tableVarStatic       :connect( "itemChanged(QTableWidgetItem*)", {| oItem | iif( oItem:column() == 4, ::editVariableEx( oItem ), NIL ) } )

   RETURN NIL


METHOD IdeDebugger:manageAreasContextManu( oPoint )
   LOCAL oItem, cInfo, n, cTable, cDrv, cAlias, cOrd, cRec
   LOCAL aPops := {}

   IF Empty( oItem := ::oUI:tableOpenTables:itemAt( oPoint ) )
      RETURN NIL
   ENDIF
   IF oItem:column() > 0
      RETURN NIL
   ENDIF
   cInfo := oItem:whatsThis()
   IF ( n := At( "TABLE_PATH[ ", cInfo ) ) == 0
      RETURN NIL
   ENDIF
   cInfo  := SubStr( cInfo, n + Len( "TABLE_PATH[ " ) )
   n      := At( " ]|", cInfo )
   cTable := SubStr( cInfo, 1, n - 1 )
   n      := At( "ORD_TAG_EXP[ ", cInfo )
   cInfo  := SubStr( cInfo, n + Len( "ORD_TAG_EXP[ " ) )
   cOrd   := SubStr( cInfo, 1, At( ":", cInfo ) - 2 )
   cAlias := StrTran( oItem:text(), "*" )
   cDrv   := ::oUI:tableOpenTables:item( oItem:Row(), 2 ):text()
   cRec   := ::oUI:tableOpenTables:item( oItem:Row(), 4 ):text()

   // Main,C:\harbour\tests\test.dbf,TEST,DBFCDX,0,500,2,0 0 300 504,21,1,,,,
   cTable := "Main," + cTable + "," + cAlias + "," + cDrv + "," + cOrd + "," + cRec + ","
   cTable := StrTran( cTable, " ", "" )

   aadd( aPops, { "Open in IdeDBU"  , {|| ::openTableInIdeDBU( cTable, .F. ) } } )
   aadd( aPops, { "" } )
   aadd( aPops, { "Open in HbDBU"   , {|| ::openTableInIdeDBU( cTable, .T. ) } } )

   hbide_execPopup( aPops, ::oUI:tableOpenTables:mapToGlobal( oPoint ) )

   RETURN oItem


METHOD IdeDebugger:openTableInIdeDBU( cTable, lByHbDBU )
   LOCAL aRecs, aRec

   IF ::isUIBrowsers()
      aRecs := ::hBrowsers[ "Areas" ][ "dat" ]
      aRec  := aRecs[ ::hBrowsers[ "Areas" ][ "rec" ] ]
      IF ! Empty( aRec[ 1 ] )
         // Main,C:\harbour\tests\test.dbf,TEST,DBFCDX,0,500,2,0 0 300 504,21,1,,,,
         cTable := "Main," + Trim( aRec[ 14 ] ) + "," + StrTran( Trim( aRec[ 1 ] ), "*" ) + "," + ;
                        Trim( aRec[ 3 ] ) + "," + Trim( aRec[ 10 ] ) + "," + Trim( aRec[ 5 ] ) + ","
         cTable := StrTran( cTable, " ", "" )
         ::oIde:oBM:oDbu:openATable( cTable )
         ::oIde:oParts:setStack( IDE_PART_DBU )
      ENDIF
   ELSE
      IF lByHbDBU
         hb_processRun( hb_DirBase() + "hbdbu " + cTable )
      ELSE
         ::oIde:oBM:oDbu:openATable( cTable )
         ::oIde:oParts:setStack( IDE_PART_DBU )
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:manageKey( nQtKey )
   IF ::isActive()
      SWITCH nQtKey
      CASE Qt_Key_F5 ; ::doCommand( CMD_GO     ) ; EXIT
      CASE Qt_Key_F6 ; ::doCommand( CMD_NEXTR  ) ; EXIT
      CASE Qt_Key_F7 ; ::doCommand( CMD_TOCURS ) ; EXIT
      CASE Qt_Key_F8 ; ::doCommand( CMD_STEP   ) ; EXIT
      CASE Qt_Key_F10; ::doCommand( CMD_TRACE  ) ; EXIT
      ENDSWITCH
   ENDIF
   RETURN .F.


METHOD IdeDebugger:fineTune( oTable )
   LOCAL i

   FOR i := 1 TO oTable:columnCount()
      oTable:horizontalHeader:setSectionResizeMode( i-1, QHeaderView_ResizeToContents )
   NEXT
   oTable:horizontalHeader:setHighlightSections( .F. )

   oTable:setEditTriggers( QAbstractItemView_NoEditTriggers )
   oTable:setSelectionBehavior( QAbstractItemView_SelectItems )
   oTable:setSelectionMode( QAbstractItemView_SingleSelection )
   RETURN Self


METHOD IdeDebugger:expandObject( nIndent, txt_ )
   LOCAL s, cVar, cType, cTypes, cText, aRec, aRecs

   DEFAULT nIndent TO 0
   DEFAULT txt_    TO {}

   ::lExpanding := .T.
   cVar   := ::cInspectVar
   cType  := ::cInspectType
   cTypes := ::cInspectTypes

   ::expandObjectDetail( nIndent, @txt_, iif( ::cInspectType == "O", ::cInspectVar, "" ) )

   IF ! Empty( txt_ )
      IF ::isUIBrowsers
         aRecs := {}
         FOR EACH cText IN txt_
            aRec := hb_ATokens( SubStr( cText, 3 ), "," )
            AEval( aRec, {|e,i| aRec[ i ] := iif( i == 1, Trim( e ), AllTrim( e ) ) } )
            AAdd( aRecs, aRec )
         NEXT
         ::updateData( ::hBrowsers[ "Expanded" ], aRecs )
      ELSE
         s := ""
         AEval( txt_, {|e| s += e + Chr( 13 )+Chr( 10 ) } )
         IF ! Empty( s )
            ::oIde:showFragment( s, cVar, QIcon( hbide_image( "fullscreen" ) ), "Sand Storm" )
         ENDIF
      ENDIF
   ENDIF
   ::lExpanding := .F.

   ::cInspectVar   := cVar
   ::cInspectType  := cType
   ::cInspectTypes := cTypes
   ::requestObject()

   RETURN NIL


METHOD IdeDebugger:expandObjectDetail( nIndent, txt_, cOriginVar )
   LOCAL d_, cVar, cName, dat_, cSaveVar, cSaveType, cSaveTypes

   nIndent++

   IF ::isUIBrowsers()
      dat_:= __pullBrowserData( ::hBrowsers[ "Objects" ] )
   ELSE
      dat_:= __pullData( ::oUI:tableObjectInspector )
   ENDIF
   FOR EACH d_ IN dat_
      IF ! ::isActive()
         EXIT
      ENDIF

      AAdd( txt_, Space( nIndent * 2 ) + __formatDataEx( d_, { 10, 1, 89 } ) )
      IF Trim( d_[ 2 ] ) == "A"
         cSaveVar := ::cInspectVar
         cSaveType := ::cInspectType
         cSaveTypes := ::cInspectTypes

         cName := AllTrim( d_[ 1 ] )
         cVar := ::cInspectVar
         IF Left( cName, 2 ) == "E_" .AND. IsDigit( Right( cName,1 ) )
            cVar := cVar + "[" + hb_ntos( d_:__enumIndex() ) + "]"
         ELSE
            cVar := cVar + ":" + cName
         ENDIF
         ::cInspectVar   := cVar
         ::cInspectType  := "A"
         ::cInspectTypes += "A"

         IF ! ::isUIBrowsers()
            ::oUI:tableObjectInspector:setRowCount( 0 )
            ::processEvents()
         ENDIF

         ::doCommand( CMD_ARRAY, cVar  )
         ::expandObjectDetail( nIndent, @txt_, cOriginVar )

         ::cInspectVar   := cSaveVar
         ::cInspectType  := cSaveType
         ::cInspectTypes := cSaveTypes
      ELSE
         IF ! Empty( cOriginVar )
            ::cInspectVar := cOriginVar
         ENDIF
      ENDIF
   NEXT
   RETURN NIL


METHOD IdeDebugger:copyStructToClipboard()
   LOCAL aStruct, i, cTmp

   IF ::oUI:tableCurrentRecord:isVisible()
      IF ::oUI:tableCurrentRecord:rowCount() == 0
         RETURN NIL
      ENDIF
      aStruct := {}
      FOR i := 1 TO ::oUI:tableCurrentRecord:rowCount()
         AAdd( aStruct, { ::oUI:tableCurrentRecord:item( i - 1, 0 ):text(), ;
                          ::oUI:tableCurrentRecord:item( i - 1, 1 ):text(), ;
                          Val( ::oUI:tableCurrentRecord:item( i - 1, 2 ):text() ), ;
                          Val( ::oUI:tableCurrentRecord:item( i - 1, 4 ):text() ) } )
      NEXT
      IF ! empty( aStruct )
         i := 0
         aeval( aStruct, {|e_| iif( Len( e_[ 1 ] ) > i, i := len( e_[ 1 ] ), NIL ) } )
         i += 2

         cTmp := "   LOCAL aStruct := {"
         aeval( aStruct, {|e_,n| cTmp += iif( n == 1, ' { ', space( 20 ) + '  { ' ) + ;
                                    pad( '"' + e_[ 1 ] + '"', i ) + ', "' + e_[ 2 ] + '", ' + ;
                                        str( e_[ 3 ], 4, 0 ) + ', ' + ;
                                            str( e_[ 4 ], 2, 0 ) + ' }' + ;
                                                iif( Len( aStruct ) == n, " }", ",;" ) + hb_eol() } )
         QApplication():clipboard():setText( cTmp )
         Alert( "Structure Copied to Clipboard!" )
      ENDIF
   ELSE
      aStruct := ::hBrowsers[ "Record" ][ "dat" ]
      IF Empty( aStruct[ 1,1 ] )
         RETURN NIL
      ENDIF

      i := Len( aStruct[ 1, 1 ] ) + 2

      cTmp := "   LOCAL aStruct := {"
      aeval( aStruct, {|e_,n| cTmp += iif( n == 1, ' { ', space( 20 ) + '  { ' ) + ;
                                 pad( '"' + Trim( e_[ 1 ] ) + '"', i ) + ', "' + e_[ 2 ] + '", ' + ;
                                     PadL( Trim( e_[ 3 ] ), 4 ) + ', ' + ;
                                         PadL( Trim( e_[ 4 ] ), 2 ) + ' }' + ;
                                             iif( Len( aStruct ) == n, " }", ",;" ) + hb_eol() } )
      QApplication():clipboard():setText( cTmp )
      Alert( "Structure Copied to Clipboard!" )
   ENDIF

   RETURN cTmp


METHOD IdeDebugger:copyOnClipboard()
   LOCAL aData, s
   LOCAL txt_:={}

   AAdd( txt_, "PROJECT: " + ::cCurrentProject + " [" + DToC( Date() ) + "  " + Time() + "]" )
   AAdd( txt_, ::cLastMessage )
   AAdd( txt_, " " )
   AAdd( txt_, " " )

   IF ::isUIBrowsers()
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Locals" ] ) )
         AAdd( txt_, "LOCAL VARIABLES" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Privates" ] ) )
         AAdd( txt_, "PRIVATE VARIABLES" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Publics" ] ) )
         AAdd( txt_, "PUBLIC VARIABLS" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Statics" ] ) )
         AAdd( txt_, "STATIC VARIABLS" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Watches" ] ) )
         AAdd( txt_, "WATCHES" )
         __formatData( txt_, { "Expression", "Value" }, aData, { 25, 72 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Areas" ] ) )
         AAdd( txt_, "WORKAREAS" )
         __formatData( txt_, { "Alias", "Area", "Rdd","Records","CurRec","Bof","Eof","Found","Del","Filter","TagName","IndexKey" }, ;
                         aData, { 10,4,8,10,8,3,3,3,3,30,10,30 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Record" ] ) )
         AAdd( txt_, Upper( ::oUI:labelCurrentRecord:text() ) )
         __formatData( txt_, { "Name", "Type", "Len", "Value" }, aData, { 10, 4, 4, 73 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Objects" ] ) )
         AAdd( txt_, Upper( ::oUI:labelObjectInspector:text() ) )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 20, 4, 70 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Stack" ] ) )
         AAdd( txt_, "STACK" )
         __formatData( txt_, { "Source", "Procedure", "Line" }, aData, { 20, 40, 6 } )
      ENDIF
      IF ! Empty( aData :=__pullBrowserData( ::hBrowsers[ "Sets" ] ) )
         AAdd( txt_, "SETS" )
         __formatData( txt_, { "Set", "Value" }, aData, { 30, 67 } )
      ENDIF
   ELSE
      IF ! Empty( aData :=__pullData( ::oUI:tableVarLocal ) )
         AAdd( txt_, "LOCAL VARIABLES" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableVarPrivate ) )
         AAdd( txt_, "PRIVATE VARIABLES" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableVarPublic ) )
         AAdd( txt_, "PUBLIC VARIABLS" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableVarStatic ) )
         AAdd( txt_, "STATIC VARIABLS" )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 10, 4, 80 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableWatchExpressions ) )
         AAdd( txt_, "WATCHES" )
         __formatData( txt_, { "Expression", "Value" }, aData, { 25, 72 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableOpenTables ) )
         AAdd( txt_, "WORKAREAS" )
         __formatData( txt_, { "Alias", "Area", "Rdd","Records","CurRec","Bof","Eof","Found","Del","Filter","TagName","IndexKey" }, ;
                         aData, { 10,4,8,10,8,3,3,3,3,30,10,30 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableCurrentRecord ) )
         AAdd( txt_, Upper( ::oUI:labelCurrentRecord:text() ) )
         __formatData( txt_, { "Name", "Type", "Len", "Value" }, aData, { 10, 4, 4, 73 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableObjectInspector ) )
         AAdd( txt_, Upper( ::oUI:labelObjectInspector:text() ) )
         __formatData( txt_, { "Name", "Type", "Value" }, aData, { 20, 4, 70 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableStack ) )
         AAdd( txt_, "STACK" )
         __formatData( txt_, { "Source", "Procedure", "Line" }, aData, { 20, 40, 6 } )
      ENDIF
      IF ! Empty( aData :=__pullData( ::oUI:tableSets ) )
         AAdd( txt_, "SETS" )
         __formatData( txt_, { "Set", "Value" }, aData, { 30, 67 } )
      ENDIF
   ENDIF

   s := ""
   AEval( txt_, {|e| s += e + Chr( 13 ) + Chr( 10 ) } )
   QApplication():clipboard():setText( s )

   ::oIde:showFragment( s, ;
              "PROJECT: " + ::cCurrentProject + " [" + DToC( Date() ) + "  " + Time() + "][" + ::cLastMessage + "]", ;
              QIcon( hbide_image( "fullscreen" ) ), ;
              "Evening Glamour" )
   RETURN Self


STATIC FUNCTION __formatData( txt_, aHdrs, aData, aWidths )
   LOCAL nCols := Len( aHdrs )
   LOCAL aRec, j, s

   s := "   "
   FOR j := 1 TO nCols
      s += Pad( aHdrs[ j ], aWidths[ j ] ) + iif( j == nCols, "", C_C )
   NEXT
   AAdd( txt_, s )
   FOR EACH aRec IN aData
      s := "   "
      FOR j := 1 TO nCols
         s += Pad( aRec[ j ], aWidths[ j ] ) + iif( j == nCols, "", C_C )
      NEXT
      AAdd( txt_, s )
   NEXT
   AAdd( txt_, " " )
   AAdd( txt_, " " )
   RETURN NIL


STATIC FUNCTION __formatDataEx( aData, aWidths )
   LOCAL nCols := Len( aWidths )
   LOCAL j, s

   s := ""
   FOR j := 1 TO nCols
      s += Pad( aData[ j ], aWidths[ j ] ) + iif( j == nCols, "", C_C )
   NEXT
   RETURN s


STATIC FUNCTION __pullBrowserData( hBrowser )
   LOCAL aData, aRec, dat_, cVal
   LOCAL nFields := Len( hBrowser[ "dat" ][ 1 ] )

   aData := {}
   FOR EACH dat_ IN hBrowser[ "dat" ]
      IF ! Empty( dat_[ 1 ] )
         aRec := Array( nFields )
         FOR EACH cVal IN dat_
            aRec[ cVal:__enumIndex() ] := StrTran( cVal, ",", ";" )
         NEXT
         AAdd( aData, aRec )
      ENDIF
   NEXT
   RETURN aData


STATIC FUNCTION __pullData( oTable )
   LOCAL aData := {}
   LOCAL nRows, nCols, nRow, nCol, oItem, aRec

   nRows  := oTable:rowCount()
   nCols  := oTable:columnCount()
   //
   FOR nRow := 0 TO nRows - 1
      aRec := {}
      FOR nCol := 0 TO nCols - 1
         IF ! Empty( oItem := oTable:item( nRow, nCol ) )
            AAdd( aRec, StrTran( oItem:text(), ",", ";" ) )
         ELSE
            AAdd( aRec, "" )
         ENDIF
      NEXT
      AAdd( aData, aRec )
   NEXT
   RETURN aData


STATIC FUNCTION Int2Hex( n )
   LOCAL n1 := Int( n/16 ), n2 := n % 16

   IF n > 255
      RETURN "XX"
   ENDIF
   RETURN Chr( iif( n1 < 10, n1 + 48, n1 + 55 ) ) + Chr( iif( n2 < 10, n2 + 48, n2 + 55 ) )


STATIC FUNCTION Str2Hex( stroka )
   LOCAL i
   LOCAL cRes := ""
   LOCAL nLen := Len( stroka )

   FOR i := 1 to nLen
      cRes += Int2Hex( Asc( Substr( stroka, i, 1 ) ) )
   NEXT
   RETURN cRes


STATIC FUNCTION Hex2Str( stroka )
   LOCAL cRes := ""
   LOCAL i    := 1
   LOCAL nLen := Len( stroka )

   IF nLen > 0
      DO WHILE i <= nLen
         cRes += Chr( Hex2Int( Substr( stroka, i, 2 ) ) )
         i += 2
      ENDDO
   ENDIF
   RETURN cRes


STATIC FUNCTION Hex2Int( stroka )
   LOCAL res
   LOCAL i := Asc( stroka )

   IF i > 64 .AND. i < 71
      res := ( i - 55 ) * 16
   ELSEIF i > 47 .AND. i < 58
      res := ( i - 48 ) * 16
   ELSE
      RETURN 0
   ENDIF
   i := Asc( SubStr( stroka, 2, 1 ) )
   IF i > 64 .AND. i < 71
      res += i - 55
   ELSEIF i > 47 .AND. i < 58
      res += i - 48
   ENDIF
   RETURN res


METHOD IdeDebugger:execMdiEvent( cEvent, p1 )
   LOCAL oSub, oList, oWnd, i, hBrowser, cFile, hInfo, aInfo, oRect
   LOCAL oMdiArea := ::oUI:mdiBrowsers

   SWITCH cEvent
   CASE "showSubsCascaded"
      oSub := oMdiArea:activeSubWindow()
      oMdiArea:cascadeSubWindows()
      oMdiArea:setActiveSubWindow( oSub )
      ::resizeSubWindows()
      EXIT
   CASE "showSubsTiled"
      oSub := oMdiArea:activeSubWindow()
      oMdiArea:tileSubWindows()
      oMdiArea:setActiveSubWindow( oSub )
      ::resizeSubWindows()
      EXIT
   CASE "showSubsMaximized"
      oSub := oMdiArea:activeSubWindow()
      oList := oMdiArea:subWindowList()
      FOR i := 1 TO oList:size()
         oWnd := oList:At( i-1 )
         oWnd:setWindowState( Qt_WindowMaximized )
         oWnd:resize( oWnd:width() + 1, oWnd:height() + 1 )
         oWnd:resize( oWnd:width() - 1, oWnd:height() - 1 )
      NEXT
      oMdiArea:setActiveSubWindow( oSub )
      ::resizeSubWindows()
      EXIT
   CASE "subWindowsRest"
      ::restUIState( ::oINI:cDebuggerState )
      ::resizeSubWindows()
      EXIT
   CASE "subWindowsSave"
      oSub := oMdiArea:activeSubWindow()
      hInfo := {=>}
      hb_HKeepOrder( hInfo, .T. )
      FOR EACH hBrowser IN ::hBrowsers
         oRect := hBrowser[ "mdi" ]:frameGeometry()
         hInfo[ hBrowser[ "id" ] ] := { iif( hBrowser[ "mdi" ]:isMinimized(), 1, iif( hBrowser[ "mdi" ]:isMaximized(), 2, 0 ) ), ;
                                        oRect:x(), oRect:y(), oRect:width(), oRect:height, oSub:whatsThis() }
      NEXT
      cFile := hbide_fetchAFile( ::oDlg, "Select a Debbuger View", { { "Debugger Views", "*.dvw" } }, ;
                                      ::oPM:getProjectPathFromTitle( ::cCurrentProject ), "dvw", .F. )
      IF ! Empty( cFile )
         IF hb_FileExists( cFile )
            IF Alert( cFile + " : already exists!", { "Overwrite","Cancel" } ) != 1
               RETURN NIL
            ENDIF
         ENDIF
         hb_MemoWrit( cFile, hb_Serialize( hInfo ) )
      ENDIF
      EXIT
   CASE "subWindowsLoad"
      cFile := hbide_fetchAFile( ::oDlg, "Select a Debbuger View", { { "Debugger Views", "*.dvw" } }, ;
                                      ::oPM:getProjectPathFromTitle( ::cCurrentProject ), "dvw", .F. )
      IF ! Empty( cFile ) .AND. hb_FileExists( cFile )
         hInfo := hb_Deserialize( hb_MemoRead( cFile ) )
         IF HB_ISHASH( hInfo )
            FOR EACH aInfo IN hInfo
               hBrowser := ::hBrowsers[ aInfo:__enumKey() ]
               IF HB_ISHASH( hBrowser )
                  IF aInfo[ 1 ] > 0
                     IF aInfo[ 1 ] == 1
                        hBrowser[ "mdi" ]:showMinimized()
                     ELSE
                        hBrowser[ "mdi" ]:showMaximized()
                     ENDIF
                  ELSE
                     hBrowser[ "mdi" ]:showNormal()
                     hBrowser[ "mdi" ]:move( aInfo[ 2 ], aInfo[ 3 ] )
                     hBrowser[ "mdi" ]:resize( aInfo[ 4 ], aInfo[ 5 ] )
                     hBrowser[ "mdi" ]:resize( hBrowser[ "mdi" ]:width()+1, hBrowser[ "mdi" ]:height()+1 )
                     hBrowser[ "mdi" ]:resize( hBrowser[ "mdi" ]:width()-1, hBrowser[ "mdi" ]:height()-1 )
                  ENDIF
               ENDIF
               oMdiArea:setActiveSubWindow( ::hBrowsers[ aInfo[ 6 ] ][ "mdi" ] )
            NEXT
         ENDIF
      ENDIF
      EXIT
   CASE "subWindowsPrint"
      IF ! Empty( oSub := oMdiArea:activeSubWindow() )
         ::hBrowsers[ oSub:whatsThis() ][ "brw" ]:print()
      ENDIF
      EXIT
   CASE "subWindowActivated"
      oSub := p1
      ::cActiveBrowser := oSub:whatsThis()

      ::oUI:btnSubsWatchSelText:setEnabled( oSub:whatsThis() == "Watches" )
      ::oUI:btnSubsWatchAdd    :setEnabled( oSub:whatsThis() == "Watches" )
      ::oUI:btnSubsWatchSave   :setEnabled( oSub:whatsThis() == "Watches" )
      ::oUI:btnSubsWatchLoad   :setEnabled( oSub:whatsThis() == "Watches" )
      ::oUI:btnSubsWatchDel    :setEnabled( oSub:whatsThis() == "Watches" )
      ::oUI:btnSubsWatchClear  :setEnabled( oSub:whatsThis() == "Watches" )

      ::oUI:btnSubsDbu         :setEnabled( oSub:whatsThis() == "Areas"   )
      ::oUI:btnSubsCopyStruct  :setEnabled( oSub:whatsThis() == "Record"  )

      ::oUI:btnSubsObjBack     :setEnabled( oSub:whatsThis() == "Objects" )
      ::oUI:btnSubsObjExpand   :setEnabled( oSub:whatsThis() == "Objects" )
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD IdeDebugger:resizeSubWindows()
   LOCAL hBrowser
   FOR EACH hBrowser IN ::hBrowsers
      IF HB_ISHASH( hBrowser )
         hBrowser[ "mdi" ]:resize( hBrowser[ "mdi" ]:width()+1, hBrowser[ "mdi" ]:height()+1 )
         hBrowser[ "mdi" ]:resize( hBrowser[ "mdi" ]:width()-1, hBrowser[ "mdi" ]:height()-1 )
      ENDIF
   NEXT
   RETURN NIL

METHOD IdeDebugger:restUIState( cState )
   LOCAL aState := hb_ATokens( cState, "|" )
   LOCAL i, a_, oSub

   IF Len( aState ) >= 10
      FOR i := 2 TO Len( aState )
         a_:= hb_ATokens( aState[ i ], "," )
         IF Len( a_ ) >= 6
            oSub := ::hBrowsers[ a_[ 1 ] ][ "mdi" ]
            IF     a_[ 2 ] == "0"
               oSub:showNormal()
               oSub:move( Val( a_[ 3 ] ), Val( a_[ 4 ] ) )
               oSub:resize( Val( a_[ 5 ] ), Val( a_[ 6 ] ) )
            ELSEIF a_[ 2 ] == "1"
               oSub:showMinimized()
            ELSEIF a_[ 2 ] == "2"
               oSub:showMaximized()
            ENDIF
         ENDIF
      NEXT
      IF hb_HHasKey( ::hBrowsers, aState[ 1 ] )
         ::oUI:mdiBrowsers:setActiveSubWindow( ::hBrowsers[ aState[ 1 ] ][ "mdi" ] )
      ENDIF
   ENDIF
   RETURN NIL


METHOD IdeDebugger:getUIState()
   LOCAL hBrowser, oRect
   LOCAL cState := ""

   FOR EACH hBrowser IN ::hBrowsers
      oRect := hBrowser[ "mdi" ]:frameGeometry()

      cState += ::cActiveBrowser + "|"
      cState += hBrowser[ "id" ] + "," + ;
                iif( hBrowser[ "mdi" ]:isMinimized(), "1", iif( hBrowser[ "mdi" ]:isMaximized(), "2", "0" ) ) + "," + ;
                hb_ntos( oRect:x() )     + "," + ;
                hb_ntos( oRect:y() )     + "," + ;
                hb_ntos( oRect:width() ) + "," + ;
                hb_ntos( oRect:height )  + "|"
   NEXT
   cState := SubStr( cState, 1, Len( cState ) - 1 )
   RETURN cState


METHOD IdeDebugger:buildBrowsers()

   SetKey( K_INS, {|| ReadInsert( ! ReadInsert() ) } )

   WITH OBJECT ::oUI:mdiBrowsers
      :setOption( QMdiArea_DontMaximizeSubWindowOnActivation, .T. )
      :setViewMode( QMdiArea_TabbedView )
      :setActivationOrder( QMdiArea_CreationOrder )
      :connect( "subWindowActivated(QMdiSubWindow*)", {|oSub| ::execMdiEvent( "subWindowActivated", oSub ) } )
   ENDWITH

   ::oUI:btnSubsTile        :connect( "clicked()", {|| ::execMdiEvent( "showSubsTiled" )     } )
   ::oUI:btnSubsCascade     :connect( "clicked()", {|| ::execMdiEvent( "showSubsCascaded" )  } )
   ::oUI:btnSubsMaximized   :connect( "clicked()", {|| ::execMdiEvent( "showSubsMaximized" ) } )
   ::oUI:btnSubsRest        :connect( "clicked()", {|| ::execMdiEvent( "subWindowsRest"  )   } )
   ::oUI:btnSubsSave        :connect( "clicked()", {|| ::execMdiEvent( "subWindowsSave"  )   } )
   ::oUI:btnSubsLoad        :connect( "clicked()", {|| ::execMdiEvent( "subWindowsLoad"  )   } )
   ::oUI:btnSubsPrint       :connect( "clicked()", {|| ::execMdiEvent( "subWindowsPrint" )   } )

   ::oUI:btnSubsWatchDel    :connect( "clicked()", {|| ::watch_del( .F. ) } )
   ::oUI:btnSubsWatchClear  :connect( "clicked()", {|| ::watch_del( .T. ) } )
   ::oUI:btnSubsWatchLoad   :connect( "clicked()", {|| ::watch_rest()     } )
   ::oUI:btnSubsWatchSave   :connect( "clicked()", {|| ::watch_save()     } )
   ::oUI:btnSubsWatchAdd    :connect( "clicked()", {|| ::watch_ins( .F. ) } )
   ::oUI:btnSubsWatchSelText:connect( "clicked()", {|| ::watch_ins( .T. ) } )

   ::oUI:btnSubsDbu         :connect( "clicked()", {|| ::openTableInIdeDBU( "", .F. ) } )
   ::oUI:btnSubsCopyStruct  :connect( "clicked()", {|| ::copyStructToClipboard() } )

   ::oUI:btnSubsObjBack     :connect( "clicked()", {|| ::manageObjectLevelUp() } )
   ::oUI:btnSubsObjExpand   :connect( "clicked()", {|| ::expandObject() } )

   ::hBrowsers[ "Locals"  ] := ::buildMdiBrowse( "Locals"  , { "Name"  , "Typ", "Lvl", "Pos", "Value" }, { 10,3,3,3,20 } )
   ::hBrowsers[ "Privates"] := ::buildMdiBrowse( "Privates", { "Name"  , "Typ", "Lvl", "Pos", "Value" }, { 10,3,3,3,20 } )
   ::hBrowsers[ "Publics" ] := ::buildMdiBrowse( "Publics" , { "Name"  , "Typ", "Lvl", "Pos", "Value" }, { 10,3,3,3,20 } )
   ::hBrowsers[ "Statics" ] := ::buildMdiBrowse( "Statics" , { "Name"  , "Typ", "Lvl", "Pos", "Value" }, { 10,3,3,3,20 } )

   ::hBrowsers[ "Sets"    ] := ::buildMdiBrowse( "Sets"    , { "Set"   , "Value" }                     , { 15,20 } )
   ::hBrowsers[ "Stack"   ] := ::buildMdiBrowse( "Stack"   , { "Source", "Procedure", "Line" }         , { 10,20,5 } )
   ::hBrowsers[ "Areas"   ] := ::buildMdiBrowse( "Areas"   , { "Alias" , "Area", "Rdd", "Records", "Current", "Bof", "Eof", "Found", "Del", ;
                                                               "Ord","Tag","OrdExpression","Filter","TablePath","IndexPath","AllIndexes" }, ;
                                                               { 10,4,6,8,8,3,3,3,3,3,8,10,10,10,10,10 } )
   ::hBrowsers[ "Record"  ] := ::buildMdiBrowse( "Record"  , { "Field", "Typ", "Len", "Dec", "Value" } , { 10,3,3,3,20 } )
   ::hBrowsers[ "Watches" ] := ::buildMdiBrowse( "Watches" , { "Expression", "Value" }                 , { 20,20 } )

   ::hBrowsers[ "Objects" ] := ::buildMdiBrowse( "Objects" , { "Name", "Typ", "Value" }                , { 10,3,20 } )
   ::hBrowsers[ "Expanded"] := ::buildMdiBrowse( "Expanded", { "Name", "Typ", "Value" }                , { 10,3,20 } )

   ::hBrowsers[ "Areas"   ][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Areas"   , nKey, aXY, oBrw ) }
   ::hBrowsers[ "Locals"  ][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Locals"  , nKey, aXY, oBrw ) }
   ::hBrowsers[ "Privates"][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Privates", nKey, aXY, oBrw ) }
   ::hBrowsers[ "Publics" ][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Publics" , nKey, aXY, oBrw ) }
   ::hBrowsers[ "Statics" ][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Statics" , nKey, aXY, oBrw ) }
   ::hBrowsers[ "Objects" ][ "brw" ]:navigationBlock := {| nKey, aXY, oBrw | ::manageNavigation( "Objects" , nKey, aXY, oBrw ) }

   IF Empty( ::oINI:cDebuggerState )
      ::oUI:mdiBrowsers:tileSubWindows()
   ELSE
      ::restUIState( ::oINI:cDebuggerState )
   ENDIF
   RETURN NIL


METHOD IdeDebugger:buildMdiBrowse( cTitle, aFields, aData )
   LOCAL cField
   LOCAL hBrowse := {=>}
   LOCAL aIcons := { 1,2,3,6,9,8,10,12,16,4,13 }
   LOCAL dat_:= {}

   STATIC nIcon := 0

   AEval( aData, {|n| AAdd( dat_, Space( n ) ) } )

   WITH OBJECT hBrowse[ "mdi" ] := QMdiSubWindow()
      :setWindowFlags( Qt_CustomizeWindowHint + Qt_WindowTitleHint + Qt_WindowMinimizeButtonHint + Qt_WindowMaximizeButtonHint )
      :setWindowIcon( QIcon( hbide_image( "b_" + hb_ntos( aIcons[ ++nIcon ] ) ) ) )
      :setWhatsThis( cTitle )
      :resize( 350, 200 )
      :connect( QEvent_Close , {|oEvent| oEvent:ignore(), .F. } )
   ENDWITH
   ::oUI:mdiBrowsers:addSubWindow( hBrowse[ "mdi" ] )
   hBrowse[ "mdi" ]:hide()
   hBrowse[ "mdi" ]:show()

   hBrowse[ "id"  ] := cTitle
   hBrowse[ "rec" ] := 1
   hBrowse[ "dat" ] := {}
   hBrowse[ "bln" ] := dat_
   hBrowse[ "ttl" ] := ""

  ::updateData( hBrowse, { hBrowse[ "bln" ] } )

   WITH OBJECT hBrowse[ "brw" ] := HbQtBrowseNew( 0, 0, 5, 30 )
      :colorSpec     := "N/W*, N/BG, W+/R*, W+/B"

      :goTopBlock    := {|| hBrowse[ "rec" ] := 1 }
      :goBottomBlock := {|| hBrowse[ "rec" ] := Len( hBrowse[ "dat" ] ) }
      :skipBlock     := {| nSkip, nPos | nPos := hBrowse[ "rec" ], ;
                             hBrowse[ "rec" ] := iif( nSkip > 0, Min( Len( hBrowse[ "dat" ] ), hBrowse[ "rec" ] + nSkip ), ;
                                Max( 1, hBrowse[ "rec" ] + nSkip ) ), hBrowse[ "rec" ] - nPos }

      :goPosBlock    := {|n| hBrowse[ "rec" ] := Max( 1, n ) }
      :phyPosBlock   := {|n| hBrowse[ "rec" ] := Max( 1, n ) }
      :firstPosBlock := {|| 1 }
      :lastPosBlock  := {|| Len( hBrowse[ "dat" ] ) }

      :addColumn( HbQtColumnNew( "Sr", {|| hBrowse[ "rec" ] } ) )
      :getColumn( 1 ):width   := 2
      :getColumn( 1 ):picture := "@Z 99"

      FOR EACH cField IN aFields
         :addColumn( HbQtColumnNew( cField, __fetchBlock( hBrowse, cField:__enumIndex() ) ) )
      NEXT
      :Configure()

      :freeze              := 1
      :editEnabled         := .F.
      :horizontalScrollbar := .T.
      :verticalScrollbar   := .T.
   ENDWITH

   hBrowse[ "mdi" ] : setWidget( hBrowse[ "brw" ]:oWidget )
   ::setTitle( hBrowse )
   ::oUI:mdiBrowsers:addSubWindow( hBrowse[ "mdi" ] )
   RETURN hBrowse


METHOD IdeDebugger:setTitle( hBrowser )
   hBrowser[ "mdi" ]:setWindowTitle( hBrowser[ "id" ] + " [ " + hb_ntos( Len( hBrowser[ "dat" ] ) ) + " ] " + hBrowser[ "ttl" ] )
   RETURN NIL


METHOD IdeDebugger:updateData( hBrowse, aData )
   LOCAL i, a_, nLen

   IF hb_HHasKey( hBrowse, "brw" ) .AND. HB_ISOBJECT( hBrowse[ "brw" ] )
      hBrowse[ "brw" ]:gotop()
      hBrowse[ "brw" ]:forceStable()
   ENDIF

   DO WHILE Len( hBrowse[ "dat" ] ) > 0
      hb_ADel( hBrowse[ "dat" ], 1, .T. )
   ENDDO
   IF HB_ISARRAY( aData )
      FOR EACH a_ IN aData
         AAdd( hBrowse[ "dat" ], a_ )
      NEXT
   ENDIF
   IF hb_HHasKey( hBrowse, "brw" ) .AND. HB_ISOBJECT( hBrowse[ "brw" ] )
      hBrowse[ "rec" ] := 1
      hBrowse[ "brw" ]:getColumn( 1 ):width := iif( Len( aData ) < 100, 2, iif( Len( aData ) < 1000, 3, 4 ) )
      hBrowse[ "brw" ]:getColumn( 1 ):picture := "@Z " + Replicate( "9", hBrowse[ "brw" ]:getColumn( 1 ):width )
      FOR i := 1 TO Len( aData[ 1 ] )
         nLen := 0
         AEval( aData, {|e_| nLen := Max( nLen, Len( e_[ i ] ) ) } )
         AEval( aData, {|e_| e_[ i ] := Pad( e_[ i ], nLen ) } )
      NEXT
      hBrowse[ "brw" ]:configure()
      hBrowse[ "brw" ]:forceStable()
      hBrowse[ "brw" ]:gotop()
      hBrowse[ "brw" ]:refreshAll()
   ENDIF
   IF Empty( hBrowse[ "dat" ][ 1,1 ] )
      hBrowse[ "ttl" ] := ""
   ENDIF
   ::setTitle( hBrowse )
   RETURN NIL


METHOD IdeDebugger:emptyBrowser( hBrowser )
   ::updateData( hBrowser, { AClone( hBrowser[ "bln" ] ) } )
   RETURN NIL


METHOD IdeDebugger:emptyBrowsers()
   LOCAL hBrowser
   FOR EACH hBrowser IN ::hBrowsers
      ::emptyBrowser( hBrowser )
   NEXT
   RETURN NIL


STATIC FUNCTION __fetchBlock( hBrowse, nField )
   hBrowse[ "rec" ] := Max( 1, hBrowse[ "rec" ] )
   RETURN {|| hBrowse[ "dat" ][ hBrowse[ "rec" ], nField ] }


STATIC FUNCTION __isRowEmpty( oBrw, aXY, oModelIndex )
   oModelIndex := oBrw:widget():indexAt( QPoint( aXY[ 1 ], aXY[ 2 ] ) )
   IF oModelIndex:isValid()
      IF ! Empty( oModelIndex:data():toString() )
         RETURN .F.
      ENDIF
   ENDIF
   RETURN .T.


METHOD IdeDebugger:manageNavigation( cBrowse, nKey, aXY, oBrw )
   LOCAL oModelIndex, nRow, nCol, cAlias, cOldVal, cValue, cVType, cType, dat_
   LOCAL cObject, cOType

   SWITCH nKey
   CASE K_LDBLCLK
      SWITCH cBrowse
      CASE "Areas"
         IF !__isRowEmpty( oBrw, aXY, @oModelIndex )
            IF ( nCol := oModelIndex:column() + 1 ) == 2
               nRow := ::hBrowsers[ "Areas" ][ "rec" ]
               ::cAliasArea := StrTran( ::hBrowsers[ "Areas" ][ "dat" ][ nRow, nCol - 1 ], "*" )
               ::doCommand( CMD_REC, ::cAliasArea )
            ENDIF
         ENDIF
         EXIT
      CASE "Publics"
      CASE "Privates"
      CASE "Locals"
      CASE "Statics"
         IF !__isRowEmpty( oBrw, aXY, @oModelIndex )
            IF ( oModelIndex:column() + 1 ) == 6
               nRow  := ::hBrowsers[ cBrowse ][ "rec" ]
               dat_  := ::hBrowsers[ cBrowse ][ "dat" ][ nRow ]
               cType := Trim( dat_[ 2 ] )
               IF cType $ "C,N,D,L"
                  cOldVal := dat_[ 5 ]
                  IF ! Empty( cValue := oBrw:editCell() )
                     cValue := Pad( cValue, Len( cOldVal ) )
                     ::hBrowsers[ cBrowse ][ "dat" ][ nRow, 5 ] := cValue
                     oBrw:refreshAll()
                     cVType := SubStr( cBrowse, 1, Len( cBrowse ) - 1 )
                     ::doCommand( CMD_SETVAR, ;
                              Str2Hex( Trim( dat_[ 1 ] ) ), ;
                              Str2Hex( cVType + ":" + cType ), ;
                              Str2Hex( Trim( dat_[ 3 ] ) ), ;
                              Str2Hex( Trim( dat_[ 4 ] ) ), ;
                              Str2Hex( StrTran( Trim( cValue ), '"' ) ) )
                  ENDIF
               ENDIF
            ELSEIF ( oModelIndex:column() + 1 ) == 2
               nRow  := ::hBrowsers[ cBrowse ][ "rec" ]
               dat_  := ::hBrowsers[ cBrowse ][ "dat" ][ nRow ]
               cType := Trim( dat_[ 2 ] )
               IF cType $ "O,A"
                  ::emptyBrowser( ::hBrowsers[ "Expanded" ] )
                  ::cInspectVar   := dat_[ 1 ]
                  ::cInspectType  := cType
                  ::cInspectTypes := cType
                  ::oUI:btnSubsObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )
                  ::requestObject()
               ENDIF
            ENDIF
         ENDIF
         EXIT
      CASE "Objects"
         IF !__isRowEmpty( oBrw, aXY, @oModelIndex )
            nRow  := ::hBrowsers[ cBrowse ][ "rec" ]
            dat_  := ::hBrowsers[ cBrowse ][ "dat" ][ nRow ]
            cType := Trim( dat_[ 2 ] )
            IF cType $ "O,A"
               cObject := ::cInspectVar
               cOType  := ::cInspectType
               IF cType == "A"
                  IF cOType == "O"
                     cObject := cObject + ":" + dat_[ 1 ]
                  ELSE
                     cObject := cObject + "[" + hb_ntos( nRow ) + "]"
                  ENDIF
               ELSEIF cType == "O"
                  IF cOType == "A"
                     cObject := cObject + "[" + hb_ntos( nRow ) + "]"
                  ELSE
                     cObject := cObject + ":" + dat_[ 1 ]
                  ENDIF
               ENDIF
               ::cInspectVar   := cObject
               ::cInspectType  := cType
               ::cInspectTypes += cType
               ::oUI:btnSubsObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )
               ::requestObject()
            ENDIF
         ENDIF
         EXIT
      CASE "X"
         EXIT
      ENDSWITCH
      EXIT

   CASE K_ENTER
      SWITCH cBrowse
      CASE "Areas"
         IF oBrw:colPos() == 2
            nRow := ::hBrowsers[ "Areas" ][ "rec" ]
            IF ! Empty( cAlias := ::hBrowsers[ "Areas" ][ "dat" ][ nRow, 1 ] )
               ::doCommand( CMD_REC, StrTran( Trim( cAlias ), "*" ) )
            ENDIF
         ENDIF
         EXIT
      CASE "Publics"
      CASE "Privates"
      CASE "Locals"
      CASE "Statics"
         IF oBrw:colPos() == 6
            nRow  := ::hBrowsers[ cBrowse ][ "rec" ]
            IF ! Empty( ::hBrowsers[ cBrowse ][ "dat" ][ nRow, 1 ] )
               dat_  := ::hBrowsers[ cBrowse ][ "dat" ][ nRow ]
               cType := Trim( dat_[ 2 ] )
               IF cType $ "C,N,D,L"
                  cOldVal := dat_[ 5 ]
                  IF ! Empty( cValue := oBrw:editCell() )
                     cValue := Pad( cValue, Len( cOldVal ) )
                     ::hBrowsers[ cBrowse ][ "dat" ][ nRow, 5 ] := cValue
                     oBrw:refreshAll()
                     cVType := SubStr( cBrowse, 1, Len( cBrowse ) - 1 )
                     ::doCommand( CMD_SETVAR, ;
                              Str2Hex( Trim( dat_[ 1 ] ) ), ;
                              Str2Hex( cVType + ":" + cType ), ;
                              Str2Hex( Trim( dat_[ 3 ] ) ), ;
                              Str2Hex( Trim( dat_[ 4 ] ) ), ;
                              Str2Hex( StrTran( Trim( cValue ), '"' ) ) )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         EXIT
      CASE "Objects"
         nRow  := ::hBrowsers[ cBrowse ][ "rec" ]
         dat_  := ::hBrowsers[ cBrowse ][ "dat" ][ nRow ]
         cType := Trim( dat_[ 2 ] )
         IF cType $ "O,A"
            cObject := ::cInspectVar
            cOType  := ::cInspectType
            IF cType == "A"
               IF cOType == "O"
                  cObject := cObject + ":" + dat_[ 1 ]
               ELSE
                  cObject := cObject + "[" + hb_ntos( nRow ) + "]"
               ENDIF
            ELSEIF cType == "O"
               IF cOType == "A"
                  cObject := cObject + "[" + hb_ntos( nRow ) + "]"
               ELSE
                  cObject := cObject + ":" + dat_[ 1 ]
               ENDIF
            ENDIF
            ::cInspectVar   := cObject
            ::cInspectType  := cType
            ::cInspectTypes += cType
            ::oUI:btnSubsObjBack:setEnabled( Len( ::cInspectTypes ) > 1 )
            ::requestObject()
         ENDIF
         EXIT
      ENDSWITCH
      EXIT
   ENDSWITCH
   RETURN NIL


