/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009-2014 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               HbQtEditor
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               05Dec2014
 */
/*----------------------------------------------------------------------*/

#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "common.ch"
#include "hbclass.ch"

#define __textChanged__                           2
#define __copyAvailable__                         3
#define __modificationChanged__                   4
#define __redoAvailable__                         5
#define __selectionChanged__                      6
#define __undoAvailable__                         7
#define __updateRequest__                         8
#define __cursorPositionChanged__                 9
#define __timerTimeout__                          10

#define __selectionMode_stream__                  1
#define __selectionMode_column__                  2
#define __selectionMode_line__                    3


CLASS HbQtEditor

   DATA   qEdit
   ACCESS widget()                                INLINE ::qEdit
   ACCESS document()                              INLINE ::oDocument
   METHOD setDocument( oDocument )                INLINE ::oDocument := oDocument, ::qEdit:setDocument( oDocument )

   DATA   oHilighter

   DATA   nLineNo                                 INIT  -99
   DATA   nMaxDigits                              INIT  5       // Tobe
   DATA   nMaxRows                                INIT  100
   DATA   nLastLine                               INIT  -99
   DATA   nCurLineNo                              INIT  0
   DATA   nPrevLineNo                             INIT  -1
   DATA   nPrevLineNo1                            INIT  -1

   DATA   lModified                               INIT  .F.
   DATA   lIndentIt                               INIT  .F.
   DATA   nEnterPos                               INIT 0
   DATA   lUpdatePrevWord                         INIT  .F.
   DATA   lCopyWhenDblClicked                     INIT  .F.
   DATA   cCurLineText                            INIT  ""

   DATA   cProto                                  INIT ""
   DATA   cProtoOrg                               INIT ""
   DATA   qTimer
   DATA   nProtoLine                              INIT -1
   DATA   nProtoCol                               INIT -1
   DATA   isSuspended                             INIT .F.

   DATA   nProtoRows                              INIT 1
   DATA   nProtoCols                              INIT 10

   DATA   oFont
   DATA   fontFamily
   DATA   pointSize
   DATA   currentPointSize
   DATA   qFont

   DATA   aLastEditingPosition                    INIT {}
   DATA   aBlockCopyContents                      INIT {}
   DATA   isLineSelectionON                       INIT .F.
   DATA   aSelectionInfo                          INIT { -1,-1,-1,-1, 1, 0 }
   DATA   aViewportInfo                           INIT { -1,-1,-1,-1,-1,-1 }

   DATA   isColumnSelectionON                     INIT .F.
   DATA   lReadOnly                               INIT .F.
   DATA   isHighLighted                           INIT .f.
   DATA   cLastWord, cCurWord
   DATA   hLogicals                               INIT __hbqtStandardHash()
   DATA   isMatchingPair                          INIT .F.
   DATA   oCompleter
   DATA   nTabSpaces                              INIT 3

   DATA   lCompleteArgumented                     INIT .F.
   DATA   lCompletionWithArgs                     INIT .T.

   DATA   lAutoIndent                             INIT .T.
   DATA   lSmartIndent                            INIT .T.
   DATA   lSupressHbKWordsToUpper                 INIT .F.
   DATA   lReturnAsBeginKeyword                   INIT .F.

   DATA   cSeparator                              INIT  "//" + replicate( "-", 70 ) + "//"
   DATA   lISClosing                              INIT .T.
   DATA   lISIf                                   INIT .T.
   DATA   lISElse                                 INIT .F.
   DATA   lISFor                                  INIT .T.
   DATA   lISDoWhile                              INIT .T.
   DATA   lISExitSameLine                         INIT .F.
   DATA   lISDoCase                               INIT .T.
   DATA   nISCaseCases                            INIT 3
   DATA   lISCaseOWise                            INIT .F.
   DATA   lISSwitch                               INIT .T.
   DATA   lISSwitchOWise                          INIT .F.
   DATA   nISSwitchCases                          INIT 3
   DATA   lISClosingP                             INIT .F.
   DATA   lISSpaceP                               INIT .F.
   DATA   lISCodeBlock                            INIT .T.
   DATA   lISOperator                             INIT .F.
   DATA   lISAlignAssign                          INIT .F.
   DATA   lISFmtLine                              INIT .F.
   DATA   lISEmbrace                              INIT .F.
   DATA   lISLocal                                INIT .T.
   DATA   lISReturn                               INIT .T.
   DATA   lISSeparator                            INIT .F.
   DATA   lISDocs                                 INIT .F.
   DATA   lISFunction                             INIT .T.
   DATA   lISClass                                INIT .T.
   DATA   cISData                                 INIT "VAR"
   DATA   cISMethods                              INIT "init"
   DATA   cISFormat                               INIT "class:method"

   DATA   lSelectionMode                          INIT .F.

   DATA   nGotoLast                               INIT 0

   METHOD init()
   METHOD create()
   METHOD destroy()

   METHOD execEvent( nMode, p, p1 )
   METHOD execKeyEvent( nMode, nEvent, p, p1, p2 )

   METHOD connectEditSignals()
   METHOD disconnectEditSignals()

   METHOD zoom( nKey )
   METHOD setFontInfo( cFontFamily, nPointSize )
   METHOD setFont( oFont )
   METHOD isModified()                            INLINE ::document():isModified()

   METHOD redo()
   METHOD undo()
   METHOD cut()
   METHOD copy()
   METHOD paste()
   METHOD selectAll()
   METHOD gotoMark( nIndex )

   METHOD duplicateLine()
   METHOD deleteLine()
   METHOD moveLine( nDirection )

   METHOD blockComment()
   METHOD streamComment()
   METHOD blockIndent( nDirection )
   METHOD caseUpper()
   METHOD caseLower()
   METHOD caseInvert()
   METHOD convertQuotes()
   METHOD convertDQuotes()
   METHOD findLastIndent()
   METHOD handleCurrentIndent()
   METHOD loadFuncHelp()
   METHOD clickFuncHelp()
   METHOD gotoFunction()

   METHOD setLineNumbers( lOn )
   METHOD setCurrentLineHighlightMode( lOn )
   METHOD setHorzRuler( lOn )
   METHOD toggleSelectionMode()
   METHOD toggleStreamSelectionMode()
   METHOD toggleColumnSelectionMode()
   METHOD toggleLineSelectionMode()
   METHOD togglePersistentSelection()
   METHOD toggleCodeCompetion()
   METHOD toggleCompetionTips()
   METHOD toggleBookmark( nBlock )

   METHOD clearSelection()

   METHOD getWord( lSelect )
   METHOD getLine( nLine, lSelect )
   METHOD getText()
   METHOD getSelectedText()
   METHOD getColumnNo()
   METHOD getLineNo()
   METHOD getCursor()                             INLINE ::qEdit:textCursor()
   METHOD getSelectionInfo( nPart )               INLINE ::aSelectionInfo[ nPart ]

   METHOD insertSeparator( cSep )
   METHOD insertText( cText )

   METHOD suspendPrototype()
   METHOD resumePrototype()
   METHOD showPrototype( cProto )
   METHOD hidePrototype()

   METHOD completeCode( p )

   METHOD find( cText, nPosFrom )
   METHOD findEx( cText, nFlags, nStart )

   DATA   aBookMarks                              INIT  {}
   ACCESS bookMarks()                             INLINE ::aBookMarks
   METHOD setBookmarks( aBookMarks )

   METHOD setLineNumbersBkColor( nR, nG, nB )
   METHOD setCurrentLineColor( nR, nG, nB )
   METHOD isReadOnly()
   METHOD setReadOnly( lReadOnly )
   METHOD setHilighter( oHilighter )
   METHOD setCompleter( oCompleter )              INLINE iif( HB_ISOBJECT( oCompleter ), ::oCompleter := oCompleter, NIL ), ::qEdit:hbSetCompleter( ::oCompleter )
   METHOD setTabSpaces( nSpaces )                 INLINE iif( HB_ISNUMERIC( nSpaces ), ::nTabSpaces := nSpaces, NIL ), ::qEdit:hbSetSpaces( ::nTabSpaces )
   METHOD setModified( lModified )                INLINE iif( HB_ISLOGICAL( lModified ), ::document():setModified( lModified ), NIL )
   METHOD centerCursor()                          INLINE ::qEdit:centerCursor()
   METHOD findBlockByNumber( nNumber )            INLINE ::document():findBlockByNumber( nNumber )

   METHOD refresh()
   METHOD copyBlockContents()
   METHOD pasteBlockContents()
   METHOD insertBlockContents( oKey )
   METHOD cutBlockContents( k )
   METHOD blockConvert( cMode )

   METHOD toPreviousFunction()
   METHOD toNextFunction()
   METHOD markCurrentFunction()

   METHOD tabs2spaces()
   METHOD spaces2tabs()
   METHOD removeTrailingSpaces()
   METHOD formatBraces( nMode )

   METHOD home()
   METHOD end()
   METHOD down()
   METHOD up()
   METHOD goBottom()
   METHOD goTop()
   METHOD left()
   METHOD right()
   METHOD panEnd()
   METHOD panHome()
   METHOD pageUp()
   METHOD pageDown()
   METHOD goto( nLine )

   METHOD upperCaseKeywords()
   METHOD highlightAll( cText )
   METHOD unHighlight()
   METHOD highlightPage()
   METHOD initHighlighter()
   METHOD parseCodeCompletion( cSyntax )

   METHOD reformatLine( nPos, nDeleted, nAdded )
   METHOD handleTab( key )
   METHOD alignAt( cAt )
   METHOD stringify()
   METHOD openHeaderFile()

   METHOD setActiveFieldsList( xList )

   METHOD printPreview()
   METHOD paintRequested( qPrinter )

   DATA   hInfo                                   INIT __hbqtStandardHash()
   METHOD setFormattingInfo( hInfo )

   DATA   bUpdateRequestBlock
   DATA   bBreakPointSetBlock
   DATA   bModificationChangedBlock
   DATA   bContextMenuBlock
   DATA   bEditorInfoBlock
   DATA   bSelectionChangedBlock
   DATA   bKeyPressedBlock
   DATA   bEventsBlock                            INIT {|| NIL }

   METHOD updateRequestBlock( bBlock )            SETGET
   METHOD breakPointSetBlock( bBlock )            SETGET
   METHOD modificationChangedBlock( bBlock )      SETGET
   METHOD contextMenuBlock( bBlock )              SETGET
   METHOD editorInfoBlock( bBlock )               SETGET
   METHOD selectionChangedBlock( bBlock )         SETGET
   METHOD keyPressedBlock( bBlock )               SETGET
   METHOD eventsBlock( bBlock )                   SETGET

   METHOD appendCLASS( oTxtCursor, cClassName )
   METHOD appendFUNCTION( oTxtCursor )
   METHOD appendSWITCH( oTxtCursor )
   METHOD appendWHILE( oTxtCursor )
   METHOD appendFOR( oTxtCursor )
   METHOD appendIF( oTxtCursor )
   METHOD appendCASE( oTxtCursor )
   METHOD appendWITH( oTxtCursor )

   METHOD documentContentsChanged( nPosition, nCharsRemoved, nCharsAdded )

   PROTECTED:
   DATA   oDocument

   ENDCLASS


METHOD HbQtEditor:init()

   ::hLogicals[ "t"   ] := NIL
   ::hLogicals[ "f"   ] := NIL
   ::hLogicals[ "or"  ] := NIL
   ::hLogicals[ "and" ] := NIL
   ::hLogicals[ "not" ] := NIL

   RETURN Self


METHOD HbQtEditor:create()
   LOCAL oPalette

   IF ! HB_ISOBJECT( ::qEdit )
      ::qEdit := HBQPlainTextEdit()
   ENDIF
   WITH OBJECT ::qEdit
      :setLineWrapMode( QTextEdit_NoWrap )
      :ensureCursorVisible()
      :setTabChangesFocus( .f. )
      :setFocusPolicy( Qt_StrongFocus )
      :setObjectName( __hbqtGetNextIdAsString( "HBQPlainTextEdit" ) )
      :setMouseTracking( .T. )
   ENDWITH

   WITH OBJECT oPalette := ::qEdit:palette()
      :setColor( QPalette_Inactive, QPalette_Highlight, QColor( Qt_yellow ) )
   ENDWITH
   ::qEdit:setPalette( oPalette )
   ::oDocument := ::qEdit:document()

   ::setFont()
   ::connectEditSignals()

   WITH OBJECT ::qEdit
      :connect( QEvent_KeyPress           , {|p| ::execKeyEvent( 101, QEvent_KeyPress           , p ) } )
      :connect( QEvent_Wheel              , {|p| ::execKeyEvent( 102, QEvent_Wheel              , p ) } )
      :connect( QEvent_FocusIn            , {| | ::execKeyEvent( 104, QEvent_FocusIn                ) } )
      :connect( QEvent_Resize             , {| | ::execKeyEvent( 106, QEvent_Resize                 ) } )
      :connect( QEvent_FocusOut           , {| | ::execKeyEvent( 105, QEvent_FocusOut               ) } )
      :connect( QEvent_MouseButtonPress   , {| | ::execKeyEvent( 106, QEvent_MouseButtonPress       ) } )

      ::oDocument:connect( "contentsChange(int,int,int)", {| nPosition, nCharsRemoved, nCharsAdded | ::documentContentsChanged( nPosition, nCharsRemoved, nCharsAdded ) } )

      :hbSetEventBlock( {|p,p1,p2| ::execKeyEvent( 115, 1001, p, p1, p2 ) } )
   ENDWITH

   WITH OBJECT ::qTimer := QTimer()
      :setInterval( 2000 )
      :connect( "timeout()",  {|| ::execEvent( __timerTimeout__ ) } )
   ENDWITH
   RETURN Self


METHOD HbQtEditor:destroy()

   IF ::qTimer:isActive()
      ::qTimer:stop()
   ENDIF
   ::qTimer := NIL

   WITH OBJECT ::qEdit
      :disconnect( QEvent_KeyPress            )
      :disconnect( QEvent_Wheel               )
      :disconnect( QEvent_FocusIn             )
      :disconnect( QEvent_FocusOut            )
      :disconnect( QEvent_Resize              )
      :disconnect( QEvent_MouseButtonDblClick )
      :disconnect( QEvent_MouseMove           )
   ENDWITH
   ::disconnectEditSignals()

   ::qEdit:setParent( QWidget() )
   ::qFont := NIL
   RETURN NIL


METHOD HbQtEditor:documentContentsChanged( nPosition, nCharsRemoved, nCharsAdded )
   ::reformatLine( nPosition, nCharsRemoved, nCharsAdded )
   ::aLastEditingPosition := { ::qEdit:horizontalScrollBar():value(), ;
                               ::qEdit:verticalScrollBar():value()  , ;
                               ::qEdit:textCursor() }
   RETURN Self


METHOD HbQtEditor:updateRequestBlock( bBlock )
   LOCAL bOldBlock := ::bUpdateRequestBlock
   IF HB_ISBLOCK( bBlock )
      ::bUpdateRequestBlock := bBlock
      ::qEdit:connect( "updateRequest(QRect,int)", {|oRect,nYScrolled| Eval( ::bUpdateRequestBlock, oRect, nYScrolled ) } )
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:breakPointSetBlock( bBlock )
   LOCAL bOldBlock := ::bBreakPointSetBlock
   IF HB_ISBLOCK( bBlock )
      ::bBreakPointSetBlock := bBlock
      ::qEdit:connect( "hbBreakPointSet(int)", {| nLine | Eval( ::bBreakPointSetBlock, nLine ) } )
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:modificationChangedBlock( bBlock )
   LOCAL bOldBlock := ::bModificationChangedBlock
   IF HB_ISBLOCK( bBlock )
      ::bModificationChangedBlock := bBlock
      ::qEdit:document():connect( "modificationChanged(bool)", {| lChanged | Eval( ::bModificationChangedBlock, lChanged ) } )
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:contextMenuBlock( bBlock )
   LOCAL bOldBlock := ::bContextMenuBlock
   IF HB_ISBLOCK( bBlock )
      ::bContextMenuBlock := bBlock
      ::qEdit:setContextMenuPolicy( Qt_CustomContextMenu )
      ::qEdit:connect( "customContextMenuRequested(QPoint)", {| oPos | Eval( ::bContextMenuBlock, oPos, Self ) } )
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:editorInfoBlock( bBlock )
   LOCAL bOldBlock := ::bEditorInfoBlock
   IF HB_ISBLOCK( bBlock )
      ::bEditorInfoBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:selectionChangedBlock( bBlock )
   LOCAL bOldBlock := ::bSelectionChangedBlock
   IF HB_ISBLOCK( bBlock )
      ::bSelectionChangedBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:keyPressedBlock( bBlock )
   LOCAL bOldBlock := ::bKeyPressedBlock
   IF HB_ISBLOCK( bBlock )
      ::bKeyPressedBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:eventsBlock( bBlock )
   LOCAL bOldBlock := ::bEventsBlock
   IF HB_ISBLOCK( bBlock )
      ::bEventsBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtEditor:connectEditSignals()
   ::qEdit:connect( "selectionChanged()"     , {|p| ::execEvent( __selectionChanged__, p    ) } )
   ::qEdit:connect( "cursorPositionChanged()", {| | ::execEvent( __cursorPositionChanged__  ) } )
   ::qEdit:connect( "copyAvailable(bool)"    , {|p| ::execEvent( __copyAvailable__, p       ) } )
   RETURN NIL


METHOD HbQtEditor:disconnectEditSignals()
   ::qEdit:disConnect( "selectionChanged()"                 )
   ::qEdit:disConnect( "cursorPositionChanged()"            )
   ::qEdit:disConnect( "copyAvailable(bool)"                )
   RETURN NIL


METHOD HbQtEditor:execEvent( nMode, p, p1 )
   LOCAL oTxtCursor, nChars

   oTxtCursor := ::qEdit:textCursor()
   ::nCurLineNo := oTxtCursor:blockNumber()

   SWITCH nMode
   CASE __timerTimeout__
      IF empty( ::cProto )
         ::hidePrototype()
      ELSE
         ::showPrototype()
      ENDIF
      EXIT
   CASE __cursorPositionChanged__
      IF HB_ISBLOCK( ::editorInfoBlock() )
         Eval( ::editorInfoBlock(), Self )
      ENDIF
      ::markCurrentFunction()
      EXIT
   CASE __selectionChanged__
      IF HB_ISBLOCK( ::selectionChangedBlock() )
         IF ::aSelectionInfo[ 1 ] > -1 .AND. ::aSelectionInfo[ 1 ] == ::aSelectionInfo[ 3 ]
            nChars := Len( ::getSelectedText() )
         ELSE
            nChars := 0
         ENDIF
         Eval( ::selectionChangedBlock(), Self, nChars )
      ENDIF
      ::unHighlight()
      EXIT
   CASE __copyAvailable__
      IF p .AND. ::lCopyWhenDblClicked
         ::qEdit:copy()
      ENDIF
      ::lCopyWhenDblClicked := .f.
      EXIT
   ENDSWITCH

   HB_SYMBOL_UNUSED( p1 )
   RETURN NIL


// the method is called prior to applying the key to the buffer
// and before firing any signals, so, is a placeholder to setup
// source wide behavior.
//
METHOD HbQtEditor:execKeyEvent( nMode, nEvent, p, p1, p2 )
   LOCAL key, kbm, lAlt, lCtrl, lShift, lProcessed

   HB_SYMBOL_UNUSED( nMode )
   HB_SYMBOL_UNUSED( p1 )
   HB_SYMBOL_UNUSED( p2 )

   IF nMode == 104
      Eval( ::bEventsBlock, __HBQTEDITOR_FOCUSIN__, NIL, Self )
      RETURN .F.
   ENDIF

   SWITCH nEvent

   CASE QEvent_KeyPress                           /* The key is sent here prior to applying to editor */
      key    := p:key()
      kbm    := p:modifiers()

      lAlt   := hb_bitAnd( kbm, Qt_AltModifier     ) == Qt_AltModifier
      lCtrl  := hb_bitAnd( kbm, Qt_ControlModifier ) == Qt_ControlModifier
      lShift := hb_bitAnd( kbm, Qt_ShiftModifier   ) == Qt_ShiftModifier

      SWITCH key                                  /* On top of any user defined action be executed - QPlainTextEdit's default keys */
      CASE Qt_Key_Tab
      CASE Qt_Key_Backtab
         IF ! lAlt .AND. ! lCtrl
            p:accept()
            ::handleTab( key )
            RETURN .T.
         ENDIF
         EXIT
      CASE Qt_Key_L
         IF lCtrl
            IF ! Empty( ::aLastEditingPosition )
               ::qEdit:horizontalScrollBar():setValue( ::aLastEditingPosition[ 1 ] )
               ::qEdit:verticalScrollBar():setValue( ::aLastEditingPosition[ 2 ] )
               ::qEdit:setTextCursor( ::aLastEditingPosition[ 3 ] )
               RETURN .T.
            ENDIF
         ENDIF
         EXIT
      ENDSWITCH

      IF HB_ISBLOCK( ::keyPressedBlock() )
         lProcessed := Eval( ::keyPressedBlock(), key, { lAlt, lCtrl, lShift }, Self )
         IF HB_ISLOGICAL( lProcessed )
            p:accept()
            RETURN lProcessed
         ENDIF
      ENDIF

      SWITCH ( key )
      CASE Qt_Key_Insert
         IF lCtrl
            ::copy()
         ELSE
            ::qEdit:setOverwriteMode( ! ::qEdit:overwriteMode() )
            IF HB_ISBLOCK( ::editorInfoBlock() )
               Eval( ::editorInfoBlock(), Self )
            ENDIF
         ENDIF
         EXIT
      CASE Qt_Key_Space
         IF ! lAlt .AND. ! lShift .AND. ! lCtrl
            ::lUpdatePrevWord := .t.
         ENDIF
         EXIT
      CASE Qt_Key_Return
      CASE Qt_Key_Enter
         IF lShift
            RETURN .T.
         ENDIF
         ::lIndentIt := .T.
         ::nEnterPos := ::getColumnNo()
         EXIT
      CASE Qt_Key_ParenLeft
         IF ! lCtrl .AND. ! lAlt
            ::loadFuncHelp()                /* Also invokes prototype display */
         ENDIF
         EXIT
      CASE Qt_Key_Backspace
         IF ! lCtrl .AND. ! lAlt
            IF ::getLineNo() == ::nProtoLine .AND. ::getColumnNo() <= ::nProtoCol + 1
               ::hidePrototype()
            ENDIF
         ENDIF
         EXIT
      CASE Qt_Key_Escape
      CASE Qt_Key_ParenRight
         IF ! lCtrl .AND. ! lAlt
            ::hidePrototype()
         ENDIF
         EXIT
      CASE Qt_Key_PageUp
         IF lAlt
            ::toPreviousFunction()
         ENDIF
         EXIT
      CASE Qt_Key_PageDown
         IF lAlt
            ::toNextFunction()
         ENDIF
         EXIT
      ENDSWITCH
      EXIT
   CASE QEvent_Enter
   CASE QEvent_FocusIn
      IF key == QEvent_FocusIn
         Eval( ::bEventsBlock, __HBQTEDITOR_FOCUSIN__, NIL, Self )
      ENDIF
      EXIT
   CASE QEvent_Resize
      Eval( ::bEventsBlock, __HBQTEDITOR_RESIZE__, NIL, Self )
      EXIT
   CASE 1001                                /* Fired from hbqt_hbqplaintextedit.cpp */
      SWITCH p
      CASE QEvent_MouseButtonDblClick
         // ::lCopyWhenDblClicked := .t.
         IF ! ::openHeaderFile()
            ::clickFuncHelp()
         ENDIF
         EXIT
      CASE 21000                            /* Sends Block Info { t,l,b,r,mode,state } hbGetBlockInfo() */
         ::aSelectionInfo := p1
         Eval( ::bEventsBlock, __HBQTEDITOR_SELECTIONINFO__, ::aSelectionInfo[ 5 ] > 1, Self )
         EXIT
      CASE 21011
         ::copyBlockContents()
         EXIT
      CASE 21012
         ::pasteBlockContents()
         EXIT
      CASE 21013
         ::insertBlockContents( p1 )
         EXIT
      CASE 21014                            /* ->hbCut() */
         ::cutBlockContents( p1 )
         EXIT
      CASE 21017                            /* Sends Block Info { t,l,b,r,mode,state } hbGetBlockInfo() */
         ::aViewportInfo := p1
         EXIT
      CASE 21041                            /* When -> is typed */
         Eval( ::bEventsBlock, __HBQTEDITOR_UPDATEFIELDSLIST__, p1, Self )
         EXIT
      CASE 21042                            /* Not being called, why it is here ? */
         Eval( ::bEventsBlock, __HBQTEDITOR_UPDATEFIELDSLIST__, NIL, Self )
         EXIT
      ENDSWITCH
      EXIT
   ENDSWITCH

   RETURN .F.  /* Important - NEVER CHANGE IT TO .T. */


METHOD HbQtEditor:setActiveFieldsList( xList )
   ::qEdit:hbSetFieldsListActive( xList )
   RETURN Self


METHOD HbQtEditor:zoom( nKey )

   DEFAULT nKey TO 0

   IF nKey == 1
      IF ::currentPointSize + 1 < 30
         ::currentPointSize++
      ENDIF
   ELSEIF nKey == -1
      IF ::currentPointSize - 1 > 3
         ::currentPointSize--
      ENDIF
   ELSEIF nKey == 0
      ::currentPointSize := ::pointSize
   ELSEIF nKey >= 3 .AND. nKey <= 30
      ::currentPointSize := nKey
   ELSE
      RETURN Self
   ENDIF
   ::setFont()

   RETURN Self


METHOD HbQtEditor:setFontInfo( cFontFamily, nPointSize )
   ::fontFamily       := cFontFamily
   ::pointSize        := nPointSize
   ::currentPointSize := nPointSize
   ::setFont()
   RETURN Self


METHOD HbQtEditor:setFont( oFont )
   IF HB_ISOBJECT( oFont )
      ::oFont := NIL
      ::oFont := oFont
      ::qEdit:setFont( oFont )
   ELSE
      ::oFont := NIL
      ::oFont := QFont( ::fontFamily, ::currentPointSize )
      ::oFont:setFixedPitch( .T. )
      ::qEdit:setFont( ::oFont )
   ENDIF
   RETURN Self


METHOD HbQtEditor:setHilighter( oHilighter )
   LOCAL oOldHiLighter := ::oHilighter

   IF HB_ISOBJECT( oHilighter )
      ::oHilighter := oHilighter
      ::qEdit:hbSetHighLighter( ::oHilighter )
      ::oHilighter:hbSetEditor( ::widget() )
   ENDIF
   RETURN oOldHiLighter


METHOD HbQtEditor:initHighlighter()
   IF HB_ISOBJECT( ::oHilighter )
      ::oHilighter:hbSetInitialized( .T. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:highlightPage()
   IF HB_ISOBJECT( ::oHilighter )
      ::qEdit:hbHighlightPage()
   ENDIF
   RETURN Self


STATIC FUNCTION hbide_blockContents( aContents )
   STATIC contents := {}
   LOCAL oldContents := contents
   IF HB_ISARRAY( aContents )
      contents := aclone( aContents )
   ENDIF
   RETURN oldContents


STATIC FUNCTION hbide_setQCursor( qEdit, a_ )
   LOCAL oTxtCursor

   IF HB_ISARRAY( a_ )
      WITH OBJECT oTxtCursor := a_[ 1 ]
         :movePosition( QTextCursor_Start, QTextCursor_MoveAnchor )
         :movePosition( QTextCursor_Down , QTextCursor_MoveAnchor, a_[ 2 ] )
         :movePosition( QTextCursor_Right, QTextCursor_MoveAnchor, a_[ 3 ] )
      ENDWITH
      qEdit:setTextCursor( oTxtCursor )
      oTxtCursor:endEditBlock()
   ELSE
      oTxtCursor := qEdit:textCursor()
      oTxtCursor:beginEditBlock()
      RETURN { oTxtCursor, oTxtCursor:blockNumber(), oTxtCursor:columnNumber() }
   ENDIF
   RETURN NIL


STATIC FUNCTION hbide_qReplaceLine( oTxtCursor, nLine, cLine )
   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_Start      , QTextCursor_MoveAnchor )
      :movePosition( QTextCursor_Down       , QTextCursor_MoveAnchor, nLine )
      :movePosition( QTextCursor_StartOfLine, QTextCursor_MoveAnchor )
      :movePosition( QTextCursor_EndOfLine  , QTextCursor_KeepAnchor )
      :insertText( cLine )
   ENDWITH
   RETURN NIL


STATIC FUNCTION hbide_qPositionCursor( oTxtCursor, nRow, nCol )
   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_Start, QTextCursor_MoveAnchor       )
      :movePosition( QTextCursor_Down , QTextCursor_MoveAnchor, nRow )
      :movePosition( QTextCursor_Right, QTextCursor_MoveAnchor, nCol )
   ENDWITH
   RETURN NIL


STATIC FUNCTION hbide_invert( cBuffer )
   LOCAL s, i, c, nLen

   s := ""
   nLen := Len( cBuffer )
   FOR i := 1 TO nLen
      c := substr( cBuffer, i, 1 )
      IF isAlpha( c )
         s += iif( isUpper( c ), lower( c ), upper( c ) )
      ELSE
         s += c
      ENDIF
   NEXT
   RETURN s


STATIC FUNCTION hbide_convertALine( cLine, cMode )

   SWITCH cMode
   CASE "toupper" ; cLine := upper( cLine )             ; EXIT
   CASE "tolower" ; cLine := lower( cLine )             ; EXIT
   CASE "invert"  ; cLine := hbide_invert( cLine )      ; EXIT
   CASE "sgl2dbl" ; cLine := strtran( cLine, "'", '"' ) ; EXIT
   CASE "dbl2sgl" ; cLine := strtran( cLine, '"', "'" ) ; EXIT
   ENDSWITCH
   RETURN cLine


STATIC FUNCTION hbide_qCursorDownInsert( oTxtCursor )
   LOCAL nRow

   WITH OBJECT oTxtCursor
      nRow := :blockNumber()
      :movePosition( QTextCursor_Down, QTextCursor_MoveAnchor )
      IF :blockNumber() == nRow
         :movePosition( QTextCursor_EndOfBlock, QTextCursor_MoveAnchor )
         :insertBlock()
         :movePosition( QTextCursor_NextBlock, QTextCursor_MoveAnchor )
      ENDIF
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:copyBlockContents()
   LOCAL nT, nL, nB, nR, nW, i, cLine, nMode, qClip, aCord
   LOCAL cClip := ""

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nMode := aCord[ 5 ]

   ::aBlockCopyContents := {}

   nW := nR - nL
   FOR i := nT TO nB
      cLine := ::getLine( i + 1 )
      cLine := strtran( cLine, chr( 13 ) )
      cLine := strtran( cLine, chr( 10 ) )

      IF nMode == __selectionMode_column__
         cLine := pad( substr( cLine, nL + 1, nW ), nW )

      ELSEIF nMode == __selectionMode_line__
         // Nothing to do, complete line is already pulled

      //IF nMode == __selectionMode_stream__
      ELSE
         IF aCord[ 1 ] > aCord[ 3 ]  // Selection - bottom to top
            IF i == nT .AND. i == nB
               cLine := substr( cLine, min( aCord[ 2 ], aCord[ 4 ] ) + 1, nW )
            ELSEIF i == aCord[ 1 ]
               cLine := substr( cLine, 1, aCord[ 2 ] )
            ELSEIF i == aCord[ 3 ]
               cLine := substr( cLine, aCord[ 4 ] + 1 )
            ENDIF
         ELSE                        // Selection - top to bottom or same row
            IF i == nT .AND. i == nB
               cLine := substr( cLine, min( aCord[ 2 ], aCord[ 4 ] ) + 1, nW )
            ELSEIF i == aCord[ 1 ]
               cLine := substr( cLine, aCord[ 2 ] + 1 )
            ELSEIF i == aCord[ 3 ]
               cLine := substr( cLine, 1, aCord[ 4 ] )
            ENDIF
         ENDIF
      ENDIF

      AAdd( ::aBlockCopyContents, cLine )
      cClip += cLine + iif( nT == nB, "", iif( i < nB, hb_eol(), "" ) )
   NEXT

   hbide_blockContents( { nMode, ::aBlockCopyContents } )

   qClip := QClipboard()
   qClip:clear()
   qClip:setText( cClip )
   RETURN Self


METHOD HbQtEditor:pasteBlockContents()
   LOCAL i, nCol, oTxtCursor, nMaxCol, aCopy, a_, nPasteMode, nMode

   IF ::lReadOnly
      RETURN Self
   ENDIF

   nMode := ::aSelectionInfo[ 5 ]

   aCopy := hb_ATokens( StrTran( QClipboard():text(), Chr( 13 ) + Chr( 10 ), hb_eol() ), hb_eol() )
   IF empty( aCopy )
      RETURN Self
   ENDIF

   nPasteMode := nMode   /* OR Stream - needs to be thought carefully */

   a_:= hbide_blockContents()
   IF !empty( a_ )
      IF ( Len( a_[ 2 ] ) == len( aCopy ) ) .OR. ( len( a_[ 2 ] ) == len( aCopy ) + 1 )
         IF a_[ 2,1 ] == aCopy[ 1 ]
            nPasteMode := a_[ 1 ]
         ENDIF
      ENDIF
   ENDIF

   nPasteMode := iif( empty( nPasteMode ), __selectionMode_stream__, nPasteMode )
   oTxtCursor    := ::qEdit:textCursor()
   nCol       := oTxtCursor:columnNumber()

   oTxtCursor:beginEditBlock()
   //
   SWITCH nPasteMode
   CASE __selectionMode_column__
      FOR i := 1 TO Len( aCopy )
         oTxtCursor:insertText( aCopy[ i ] )
         IF i < Len( aCopy )
            hbide_qCursorDownInsert( oTxtCursor )

            oTxtCursor:movePosition( QTextCursor_EndOfLine, QTextCursor_MoveAnchor )
            nMaxCol := oTxtCursor:columnNumber()
            IF nMaxCol < nCol
               oTxtCursor:insertText( replicate( " ", nCol - nMaxCol ) )
            ENDIF
            oTxtCursor:movePosition( QTextCursor_StartOfLine, QTextCursor_MoveAnchor       )
            oTxtCursor:movePosition( QTextCursor_Right      , QTextCursor_MoveAnchor, nCol )
         ENDIF
      NEXT
      EXIT
   CASE __selectionMode_stream__
      FOR i := 1 TO Len( aCopy )
         oTxtCursor:insertText( aCopy[ i ] )
         IF i < Len( aCopy )
            oTxtCursor:insertText( hb_eol() )
         ENDIF
      NEXT
      EXIT
   CASE __selectionMode_line__
      oTxtCursor:movePosition( QTextCursor_StartOfLine, QTextCursor_MoveAnchor       )
      FOR i := 1 TO Len( aCopy )
         oTxtCursor:insertText( aCopy[ i ] )
         oTxtCursor:insertBlock()
      NEXT
      EXIT
   ENDSWITCH

   oTxtCursor:endEditBlock()
   ::qEdit:ensureCursorVisible()
   RETURN Self


METHOD HbQtEditor:insertBlockContents( oKey )  /* Only called if block selection is on */
   LOCAL nT, nL, nB, nR, nW, i, cLine, cKey, oTxtCursor, aCord, qCur

   IF ::lReadOnly
      RETURN Self
   ENDIF

   cKey := chr( HbQt_QtEventToHbEvent( oKey ) )

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL

   oTxtCursor := ::qEdit:textCursor()
   qCur := ::qEdit:textCursor()
   oTxtCursor:beginEditBlock()

   IF nW == 0
      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )
         cLine := pad( substr( cLine, 1, nL ), nL ) + cKey + substr( cLine, nL + 1 )
         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT

      hbide_qPositionCursor( oTxtCursor, qCur:blockNumber(), nR + 1 )
   ELSE
      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )
         cLine := pad( substr( cLine, 1, nL ), nL ) + replicate( cKey, nW ) + substr( cLine, nR + 1 )
         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT

      hbide_qPositionCursor( oTxtCursor, qCur:blockNumber(), nR )
   ENDIF

   ::qEdit:setTextCursor( oTxtCursor )
   oTxtCursor:endEditBlock()
   RETURN Self


METHOD HbQtEditor:cutBlockContents( k )
   LOCAL nT, nL, nB, nR, i, cLine, oTxtCursor, nSelMode, aCord, qCur

   IF ::lReadOnly
      RETURN Self
   ENDIF

   k := iif( empty( k ), Qt_Key_X, k )
   IF k == Qt_Key_X
      ::copyBlockContents()
   ENDIF
   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )

   nSelMode := aCord[ 5 ]

   oTxtCursor := ::qEdit:textCursor()
   qCur := ::qEdit:textCursor()
   oTxtCursor:beginEditBlock()

   IF k == Qt_Key_Backspace
      IF nSelMode == __selectionMode_column__
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            cLine := pad( substr( cLine, 1, nL - 1 ), nL - 1 ) + substr( cLine, nL + 1 )
            hbide_qReplaceLine( oTxtCursor, i, cLine )
         NEXT
         hbide_qPositionCursor( oTxtCursor, qCur:blockNumber(), nR - 1 )
      ENDIF
   ELSE
      IF k == Qt_Key_Delete .OR. k == Qt_Key_X
         IF nSelMode == __selectionMode_column__
            FOR i := nT TO nB
               cLine := ::getLine( i + 1 )
               cLine := pad( substr( cLine, 1, nL ), nL ) + substr( cLine, nR + 1 )
               hbide_qReplaceLine( oTxtCursor, i, cLine )
            NEXT
            hbide_qPositionCursor( oTxtCursor, qCur:blockNumber(), nL )
            ::qEdit:hbSetSelectionInfo( { nT, nL, nB, nL, __selectionMode_column__ } )

         ELSEIF nSelMode == __selectionMode_stream__
            hbide_qPositionCursor( oTxtCursor, nT, nL )
            IF oTxtCursor:atEnd()
               hbide_qPositionCursor( oTxtCursor, nT-1, nL )
            ENDIF
            WITH OBJECT oTxtCursor
               :movePosition( QTextCursor_Down       , QTextCursor_KeepAnchor, nB - nT )
               :movePosition( QTextCursor_StartOfLine, QTextCursor_KeepAnchor          )
               :movePosition( QTextCursor_Right      , QTextCursor_KeepAnchor, nR      )
               :removeSelectedText()
            ENDWITH
            ::qEdit:hbSetSelectionInfo( { -1, -1, -1, -1, __selectionMode_stream__ } )

         ELSEIF nSelMode == __selectionMode_line__
            hbide_qPositionCursor( oTxtCursor, nT, nL )
            oTxtCursor:movePosition( QTextCursor_Down       , QTextCursor_KeepAnchor, nB - nT + 1 )
            oTxtCursor:movePosition( QTextCursor_StartOfLine, QTextCursor_KeepAnchor          )
            oTxtCursor:removeSelectedText()
            ::qEdit:hbSetSelectionInfo( { -1, -1, -1, -1, __selectionMode_stream__ } )
            ::isLineSelectionON := .f.

         ENDIF
      ENDIF
   ENDIF

   ::qEdit:setTextCursor( oTxtCursor )
   oTxtCursor:endEditBlock()
   RETURN Self


METHOD HbQtEditor:blockComment()  /* Toggles the block comments - always inserted at the begining of the line */
   LOCAL nT, nL, nB, nR, nW, i, cLine, oTxtCursor, aCord, nMode, a_
   LOCAL cComment := "// "
   LOCAL nLen := Len( cComment )

   IF ::lReadOnly
      RETURN Self
   ENDIF

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL

   IF nW >= 0
      nMode := aCord[ 5 ]
      a_:= hbide_setQCursor( ::qEdit )
      oTxtCursor := a_[ 1 ]

      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )

         SWITCH nMode
         CASE __selectionMode_stream__
         CASE __selectionMode_line__
            IF substr( cLine, 1, nLen ) == cComment
               cLine := substr( cLine, nLen + 1 )
            ELSE
               cLine := cComment + cLine
            ENDIF
            EXIT
         CASE __selectionMode_column__
            IF substr( cLine, nL + 1, nLen ) == cComment
               cLine := pad( substr( cLine, 1, nL ), nL ) + substr( cLine, nL + nLen + 1 )
            ELSE
               cLine := pad( substr( cLine, 1, nL ), nL ) + cComment + substr( cLine, nL + 1 )
            ENDIF
            EXIT
         ENDSWITCH

         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT
#if 1
      hbide_setQCursor( ::qEdit, a_ )
#else
      hbide_qPositionCursor( oTxtCursor, qCur:blockNumber(), nL )
      ::qEdit:hbSetSelectionInfo( { nT, nL, nB, nL, __selectionMode_column__ } )
#endif
   ENDIF
   RETURN Self


METHOD HbQtEditor:streamComment()
   LOCAL nT, nL, nB, nR, nW, i, cLine, oTxtCursor, aCord, nMode, a_

   IF ::lReadOnly
      RETURN Self
   ENDIF

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL

   IF nW >= 0
      nMode   := aCord[ 5 ]
      a_:= hbide_setQCursor( ::qEdit ) ; oTxtCursor := a_[ 1 ]

      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )

         DO CASE
         CASE nMode == __selectionMode_stream__
            IF i == nT
               cLine := substr( cLine, 1, nL ) + "/* " + substr( cLine, nL + 1 )
            ELSEIF i == nB
               cLine := substr( cLine, 1, nR ) + " */" + substr( cLine, nR + 1 )
            ENDIF

         CASE nMode == __selectionMode_line__
            IF i == nT
               cLine := "/* " + cLine
            ELSEIF i == nB
               cLine += " */"
            ENDIF

         ENDCASE

         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT

      hbide_setQCursor( ::qEdit, a_ )
   ENDIF
   RETURN Self


METHOD HbQtEditor:handleTab( key )
   LOCAL nT, nL, nB, nR, i, cLine, oTxtCursor, aCord, nMode, nCol, nRow
   LOCAL nLen, cComment, nOff

   IF ::lReadOnly
      RETURN Self
   ENDIF

   nLen     := ::nTabSpaces
   cComment := space( nLen )
   nOff     := iif( key == Qt_Key_Tab, nLen, -nLen )

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nMode := aCord[ 5 ]

   oTxtCursor := ::qEdit:textCursor()
   oTxtCursor:beginEditBlock()
   nCol := oTxtCursor:columnNumber()
   nRow := oTxtCursor:blockNumber()

   SWITCH nMode
   CASE __selectionMode_column__
      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )
         IF key == Qt_Key_Tab
            //cLine := substr( cLine, 1, nCol ) + cComment + substr( cLine, nCol + 1 )
            cLine := substr( cLine, 1, nL ) + cComment + substr( cLine, nL + 1 )
         ELSE
            //cLine := substr( cLine, 1, nCol - 3 ) + substr( cLine, nCol + 1 )
            cLine := substr( cLine, 1, nL - 3 ) + substr( cLine, nL + 1 )
         ENDIF
         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT
      hbide_qPositionCursor( oTxtCursor, nRow, max( 0, nCol + nOff ) )
      ::qEdit:hbSetSelectionInfo( { nT, max( 0, nL + nOff ), nB, max( 0, nR + nOff ), __selectionMode_column__ } )
      EXIT
   CASE __selectionMode_stream__
   CASE __selectionMode_line__
      IF nL >= 0    /* Selection is marked */
      // ::cutBlockContents( Qt_Key_Delete )  /* Other editors do it like but for source code it must be different */
         FOR i := nT TO nB - 1
            cLine := ::getLine( i + 1 )
            IF key == Qt_Key_Tab
               cLine := cComment + cLine
            ELSE
               cLine := substr( cLine, nLen + 1 )
            ENDIF
            hbide_qReplaceLine( oTxtCursor, i, cLine )
         NEXT
         hbide_qPositionCursor( oTxtCursor, nRow, max( 0, nCol ) )
      ELSE
         IF key == Qt_Key_Tab
            oTxtCursor:insertText( Space( ::nTabSpaces ) )
         ELSE
            cLine := ::getLine( nRow + 1 )
            cLine := substr( cLine, 1, nCol - nLen ) + substr( cLine, nCol + 1 )
            hbide_qReplaceLine( oTxtCursor, nRow, cLine )
            hbide_qPositionCursor( oTxtCursor, nRow, max( 0, nCol + nOff ) )
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH
   ::qEdit:setTextCursor( oTxtCursor )
   oTxtCursor:endEditBlock()
   RETURN .t.


METHOD HbQtEditor:blockIndent( nDirection )
   IF nDirection == 1
      ::handleTab( Qt_Key_Tab )
   ELSE
      ::handleTab( Qt_Key_Backtab )
   ENDIF
   RETURN Self


METHOD HbQtEditor:stringify()
   LOCAL nT, nL, nB, nR, nW, i, cLine, oTxtCursor, aCord, a_, cTkn, cT1

   IF ::lReadOnly
      RETURN Self
   ENDIF
   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL
   IF nW > 0
      a_:= hbide_setQCursor( ::qEdit ) ; oTxtCursor := a_[ 1 ]
      IF aCord[ 5 ] == __selectionMode_column__
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            cTkn  := SubStr( cLine, nL + 1, nR - nL )
            cT1   := Trim( cTkn )
            cTkn  := '"' + cT1 + '"' + Space( Len( cTkn ) - Len( cT1 ) )
            cLine := SubStr( cLine, 1, nL ) + cTkn + SubStr( cLine, nR + 1 )
            hbide_qReplaceLine( oTxtCursor, i, cLine )
         NEXT
      ELSEIF aCord[ 1 ] == aCord[ 3 ]  /* same line selection */
         cLine := oTxtCursor:block():text()
         cTkn  := SubStr( cLine, nL + 1, nR - nL )
         cTkn  := '"' + cTkn + '"'
         cLine := SubStr( cLine, 1, nL ) + cTkn + SubStr( cLine, nR + 1 )
         hbide_qReplaceLine( oTxtCursor, oTxtCursor:blockNumber(), cLine )
      ENDIF
      hbide_setQCursor( ::qEdit, a_ )
   ENDIF
   RETURN Self


METHOD HbQtEditor:alignAt( cAt )
   LOCAL nT, nL, nB, nR, nW, i, cLine, oTxtCursor, aCord, a_, nMax, n, c1st, c2nd
   LOCAL  nCol, nMode, aAt, cREdgt, aReg

   IF ::lReadOnly
      RETURN Self
   ENDIF

   nMax := 0
   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL + 1
   a_:= hbide_setQCursor( ::qEdit ) ; oTxtCursor := a_[ 1 ]

   IF Left( cAt, 2 ) == "\L"          //   \L    align at left column of selected block
      nCol := nL
      nMode := 4
   ELSEIF Left( cAt, 2 ) == "\R"          //   \L    align at right column of selected block
      nCol := nR
      nMode := 5
   ELSEIF Left( cAt, 1 ) == "\"
      cAt := SubStr( cAt, 2 )
      IF IsDigit( Left( cAt,1 ) )         //   \52   align at column 52
         nMode := 2
         nCol  := Val( cAt )
      ELSEIF ! Empty( cAt )               //   \[]   regular expression
         nMode := 3
      ENDIF
   ELSE
      nMode := 1
   ENDIF

   SWITCH nMode
   CASE 1
      IF nR - nL >= 0
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            IF ( n := At( cAt, SubStr( cLine, nL, nW ) ) ) > 0
               nMax := Max( nMax, n )
            ENDIF
         NEXT
      ENDIF
      IF nMax > 0
         nMax += nL - 2
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            IF ( n := At( cAt, SubStr( cLine, nL, nW ) ) ) > 0
               c1st := SubStr( cLine, 1, nL + n - 2 )
               c2nd := SubStr( cLine, nL + n - 1 )
               cLine := PadR( c1st, nMax ) + c2nd
            ENDIF
            hbide_qReplaceLine( oTxtCursor, i, cLine )
         NEXT
      ENDIF
      EXIT
   CASE 2
      IF nR - nL == 0 .AND. nL != nCol  /* Only when a thin vertical line is visible */
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            c1st  := PadR( SubStr( cLine, 1, nL ), nCol - 1 ) + SubStr( cLine, nL + 1 )
            hbide_qReplaceLine( oTxtCursor, i, c1st )
         NEXT
      ENDIF
      EXIT
   CASE 3
      cREdgt := hb_regexComp( cAt )
      IF ! hb_IsRegEx( cREdgt )
         Alert( "Not a valid RegEx" )
         RETURN Self
      ENDIF
      aAt := {}
      IF nR - nL == 0
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            //                exp, string, lMatchCase, lNewLine, nMaxMatch, nMatchWhich, lMatchOnly
            IF ! Empty( aReg := hb_regExAll( cREdgt, SubStr( cLine, nL + 1 ), .F., .F., 0, 1, .F.  ) )
               AAdd( aAt, nL + aReg[ 1, 2 ] )
            ELSE
               AAdd( aAt, 0 )
            ENDIF
         NEXT
         AEval( aAt, {|e| nMax := Max( nMax, e ) } )
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            c1st  := PadR( SubStr( cLine, 1, nL ), nMax - 1 ) + LTrim( SubStr( cLine, nL + 1 ) )
            hbide_qReplaceLine( oTxtCursor, i, c1st )
         NEXT
      ELSE
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            //                exp, string, lMatchCase, lNewLine, nMaxMatch, nMatchWhich, lMatchOnly
            IF ! Empty( aReg := hb_regExAll( cREdgt, SubStr( cLine, nL, nW ), .F., .F., 0, 1, .F.  ) )
               AAdd( aAt, nL + aReg[ 1, 2 ] - 1 )
            ELSE
               AAdd( aAt, 0 )
            ENDIF
         NEXT
         AEval( aAt, {|e| nMax := Max( nMax, e ) } )
         IF nMax > 0
            n := 0
            FOR i := nT TO nB
               n++
               IF aAt[ n ] > 0
                  cLine := ::getLine( i + 1 )
                  c1st  := SubStr( cLine, 1, aAt[ n ] - 1 )
                  c2nd  := SubStr( cLine, aAt[ n ] )
                  cLine := PadR( c1st, nMax - 1 ) + c2nd
                  hbide_qReplaceLine( oTxtCursor, i, cLine )
               ENDIF
            NEXT
         ENDIF
      ENDIF
      EXIT
   CASE 4                                         /* align left text right to the selection line */
      IF nR - nL == 0                             /* Only when a thin vertical line is visible */
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            c1st  := PadR( SubStr( cLine, 1, nL ), nL ) + LTrim( SubStr( cLine, nL + 1 ) )
            hbide_qReplaceLine( oTxtCursor, i, c1st )
         NEXT
      ENDIF
      EXIT
   CASE 5                                         /* align right text left to the selection line */
      IF nR - nL == 0                             /* Only when a thin vertical line is visible */
         FOR i := nT TO nB
            cLine := ::getLine( i + 1 )
            c1st  := PadL( Trim( SubStr( cLine, 1, nL ) ), nL ) + SubStr( cLine, nL + 1 )
            hbide_qReplaceLine( oTxtCursor, i, c1st )
         NEXT
      ENDIF
      EXIT
   ENDSWITCH

   hbide_setQCursor( ::qEdit, a_ )
   RETURN Self


METHOD HbQtEditor:blockConvert( cMode )
   LOCAL nT, nL, nB, nR, nW, i, cLine, oTxtCursor, aCord, a_, nMode

   IF ::lReadOnly
      RETURN Self
   ENDIF

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL

   IF nW >= 0
      nMode := aCord[ 5 ]
      a_:= hbide_setQCursor( ::qEdit ) ; oTxtCursor := a_[ 1 ]

      FOR i := nT TO nB
         cLine := ::getLine( i + 1 )

         DO CASE
         CASE nMode == __selectionMode_stream__
            IF nT == nB
               cLine := substr( cLine, 1, nL ) + hbide_convertALine( substr( cLine, nL + 1, nW ), cMode ) + substr( cLine, nL + 1 + nW )
            ELSE
               IF i == nT
                  cLine := substr( cLine, 1, nL ) + hbide_convertALine( substr( cLine, nL + 1 ), cMode )
               ELSEIF i == nB
                  cLine := hbide_convertALine( substr( cLine, 1, nR ), cMode ) + substr( cLine, nR + 1 )
               ELSE
                  cLine := hbide_convertALine( cLine, cMode )
               ENDIF
            ENDIF

         CASE nMode == __selectionMode_column__
            cLine := pad( substr( cLine, 1, nL ), nL ) + hbide_convertALine( pad( substr( cLine, nL + 1, nW ), nW ), cMode ) + substr( cLine, nR + 1 )

         CASE nMode == __selectionMode_line__
            cLine := hbide_convertALine( cLine, cMode )

         ENDCASE

         hbide_qReplaceLine( oTxtCursor, i, cLine )
      NEXT

      hbide_setQCursor( ::qEdit, a_ )
   ENDIF
   RETURN Self


METHOD HbQtEditor:getSelectedText()
   LOCAL nT, nL, nB, nR, nW, i, cLine, nMode, cClip := "", aCord

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nMode := aCord[ 5 ]

   nW := nR - nL
   FOR i := nT TO nB
      cLine := ::getLine( i + 1 )

      IF nMode == __selectionMode_stream__
         IF i == nT .AND. i == nB
            cLine := substr( cLine, nL + 1, nR - nL )
         ELSEIF i == nT
            cLine := substr( cLine, nL + 1 )
         ELSEIF i == nB
            cLine := substr( cLine, 1, nR + 1 )
         ENDIF

      ELSEIF nMode == __selectionMode_column__
         cLine := pad( substr( cLine, nL + 1, nW ), nW )

      ELSEIF nMode == __selectionMode_line__
         // Nothing to do, complete line is already pulled

      ENDIF

      cClip += cLine + iif( i < nB, hb_eol(), "" )
   NEXT
   RETURN cClip


METHOD HbQtEditor:caseUpper()
   RETURN ::blockConvert( "toupper" )


METHOD HbQtEditor:caseLower()
   RETURN ::blockConvert( "tolower" )


METHOD HbQtEditor:caseInvert()
   RETURN ::blockConvert( "invert" )


METHOD HbQtEditor:convertQuotes()
   RETURN ::blockConvert( "dbl2sgl" )


METHOD HbQtEditor:convertDQuotes()
   RETURN ::blockConvert( "sgl2dbl" )


METHOD HbQtEditor:toNextFunction()
   Eval( ::bEventsBlock, __HBQTEDITOR_GOTONEXTFUNCTION__, ::getLineNo(), Self )
   RETURN Self


METHOD HbQtEditor:toPreviousFunction()
   Eval( ::bEventsBlock, __HBQTEDITOR_GOTOPREVIOUSFUNCTION__, ::getLineNo(), Self )
   RETURN Self


METHOD HbQtEditor:markCurrentFunction()
   IF ::nPrevLineNo1 != ::getLineNo()
      ::nPrevLineNo1 := ::getLineNo()
      Eval( ::bEventsBlock, __HBQTEDITOR_MARKCURRENTFUNCTION__, ::nPrevLineNo1, Self )
   ENDIF
   RETURN Self


METHOD HbQtEditor:setLineNumbers( lOn )
   ::qEdit:hbNumberBlockVisible( lOn )
   RETURN Self


METHOD HbQtEditor:setCurrentLineHighlightMode( lOn )
   ::qEdit:hbHighlightCurrentLine( lOn )
   RETURN Self


METHOD HbQtEditor:setHorzRuler( lOn )
   ::qEdit:hbHorzRulerVisible( lOn )
   RETURN Self


/* Fired by icon */
METHOD HbQtEditor:toggleSelectionMode()
   ::lSelectionMode := ! ::lSelectionMode
   ::qEdit:hbSetSelectionMode( iif( ::lSelectionMode, 2, 1 ), .f. )
   RETURN Self


METHOD HbQtEditor:toggleStreamSelectionMode()
   ::qEdit:hbSetSelectionMode( 1, .t. )
   RETURN Self


METHOD HbQtEditor:toggleColumnSelectionMode()
   ::qEdit:hbSetSelectionMode( 2, .t. )
   RETURN Self


METHOD HbQtEditor:toggleLineSelectionMode()
   ::qEdit:hbSetSelectionMode( 3, .t. )
   RETURN Self


METHOD HbQtEditor:clearSelection()
   ::qEdit:hbSetSelectionMode( 0, .t. )
   RETURN Self


METHOD HbQtEditor:togglePersistentSelection()
   ::qEdit:hbTogglePersistentSelection()
   RETURN Self


METHOD HbQtEditor:toggleCodeCompetion()
   ::qEdit:hbToggleCodeCompetion()
   RETURN Self


METHOD HbQtEditor:toggleCompetionTips()
   ::qEdit:hbToggleCompetionTips()
   RETURN Self


METHOD HbQtEditor:redo()
   ::qEdit:redo()
   RETURN Self


METHOD HbQtEditor:undo()
   ::qEdit:undo()
   RETURN Self


METHOD HbQtEditor:cut()
   IF ::lReadOnly
      RETURN Self
   ENDIF
   ::cutBlockContents( Qt_Key_X )
   RETURN Self


METHOD HbQtEditor:copy()
   ::copyBlockContents()
   RETURN Self


METHOD HbQtEditor:paste()

   IF ::lReadOnly
      RETURN Self
   ENDIF
   IF ::aSelectionInfo[ 1 ] > -1
      ::cutBlockContents( Qt_Key_Delete )
   ENDIF
   ::pasteBlockContents()
   RETURN Self


METHOD HbQtEditor:selectAll()
   ::qEdit:hbSelectAll()
   RETURN Self


METHOD HbQtEditor:isReadOnly()
   RETURN iif( HB_ISLOGICAL( ::lReadOnly ), ::lReadOnly, ::qEdit:isReadOnly() )

METHOD HbQtEditor:setReadOnly( lReadOnly )
   IF ! HB_ISLOGICAL( lReadOnly )
      lReadOnly := ! ::qEdit:isReadOnly()
   ENDIF
   ::lReadOnly := lReadOnly
   ::qEdit:setReadOnly( lReadOnly )
   RETURN Self


METHOD HbQtEditor:setBookmarks( aBookMarks )
   LOCAL nBlock
   LOCAL aOldBookMarks := {}

   IF HB_ISARRAY( aBookMarks )
      ::aBookMarks := aBookMarks
      FOR EACH nBlock IN ::aBookMarks
         ::qEdit:hbBookMarks( nBlock )
      NEXT
   ENDIF
   FOR EACH nBlock IN ::aBookMarks
      IF ::qEdit:blockCount() >= nBlock
         AAdd( aOldBookMarks, nBlock )
      ENDIF
   NEXT
   RETURN aOldBookmarks


METHOD HbQtEditor:toggleBookmark( nBlock )
   ::qEdit:hbBookMarks( nBlock )
   ::qEdit:repaint()
   RETURN Self


METHOD HbQtEditor:gotoMark( nIndex )
   IF Len( ::aBookMarks ) >= nIndex
      ::qEdit:hbGotoBookmark( ::aBookMarks[ nIndex ] )
      ::qEdit:centerCursor()
   ENDIF
   RETURN Self


METHOD HbQtEditor:setLineNumbersBkColor( nR, nG, nB )
   ::qEdit:hbSetLineAreaBkColor( QColor( nR, nG, nB ) )
   RETURN Self


METHOD HbQtEditor:setCurrentLineColor( nR, nG, nB )
   ::qEdit:hbSetCurrentLineColor( QColor( nR, nG, nB ) )
   RETURN Self


/*  TO BE EXTENDED
 */
METHOD HbQtEditor:find( cText, nPosFrom )
   LOCAL lFound, nPos
   LOCAL oTxtCursor := ::getCursor()

   nPos := oTxtCursor:position()
   IF HB_ISNUMERIC( nPosFrom )
      oTxtCursor:setPosition( nPosFrom )
   ENDIF
   ::qEdit:setTextCursor( oTxtCursor )
   IF ! ( lFound := ::qEdit:find( cText, QTextDocument_FindCaseSensitively ) )
      IF ! HB_ISNUMERIC( nPosFrom )
         lFound := ::qEdit:find( cText, QTextDocument_FindBackward + QTextDocument_FindCaseSensitively )
      ENDIF
   ENDIF
   IF ! lFound
      oTxtCursor:setPosition( nPos )
      ::qEdit:setTextCursor( oTxtCursor )
   ELSE
      ::qEdit:centerCursor()
   ENDIF
   RETURN lFound


/*  nFlags will decide the position, case sensitivity and direction
 */
METHOD HbQtEditor:findEx( cText, nFlags, nStart )
   LOCAL oTxtCursor, lFound, nPos

   DEFAULT cText  TO ::getSelectedText()
   IF Empty( cText )
      RETURN Self
   ENDIF
   DEFAULT nFlags TO 0
   DEFAULT nStart TO 0

   oTxtCursor := ::getCursor()
   nPos := oTxtCursor:position()

   IF nStart == 0
      // No need to move cursor
   ELSEIF nStart == 1
      ::qEdit:moveCursor( QTextCursor_Start )
   ELSEIF nStart == 2
      ::qEdit:moveCursor( QTextCursor_End )
   ENDIF

   IF ( lFound := ::qEdit:find( cText, nFlags ) )
      ::qEdit:centerCursor()
      oTxtCursor := ::qEdit:textCursor()
      ::qEdit:hbSetSelectionInfo( { oTxtCursor:blockNumber(), oTxtCursor:columnNumber() - Len( cText ), ;
                                    oTxtCursor:blockNumber(), oTxtCursor:columnNumber(), 1, .t., .f. } )
      oTxtCursor:clearSelection()
   ELSE
      oTxtCursor:setPosition( nPos )
      ::qEdit:setTextCursor( oTxtCursor )
   ENDIF
   RETURN lFound


METHOD HbQtEditor:unHighlight()
   LOCAL oTxtCursor, nPos, lModified

   IF ::isHighLighted
      ::isHighLighted := .f.
      oTxtCursor := ::getCursor()
      nPos := oTxtCursor:position()
      lModified := ::qEdit:document():isModified()
      ::qEdit:undo()
      IF ! lModified
         ::qEdit:document():setModified( .f. )
      ENDIF
      oTxtCursor:setPosition( nPos )
      ::qEdit:setTextCursor( oTxtCursor )
      RETURN .t.
   ENDIF
   RETURN .f.


METHOD HbQtEditor:highlightAll( cText )
   LOCAL qDoc, qFormat, oTxtCursor, qFormatHL, qCur, lModified

   IF ::unHighLight()
      RETURN Self
   ENDIF

   DEFAULT cText TO ::getSelectedText()
   IF Empty( cText )
      RETURN Self
   ENDIF
   ::isHighLighted := .t.

   qDoc := ::qEdit:document()
   lModified := qDoc:isModified()

   qCur := ::getCursor()
   qCur:beginEditBlock()

   oTxtCursor   := QTextCursor( qDoc )
   qFormat   := oTxtCursor:charFormat()
   qFormatHL := qFormat
   qFormatHL:setBackground( QBrush( QColor( Qt_yellow ) ) )

   DO WHILE .t.
      oTxtCursor := qDoc:find( cText, oTxtCursor, 0 )
      IF oTxtCursor:isNull()
         EXIT
      ENDIF
      oTxtCursor:mergeCharFormat( qFormatHL )
   ENDDO
   qCur:endEditBlock()

   IF ! lModified
      qDoc:setModified( .f. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:refresh()
   ::qEdit:hbRefresh()
   RETURN Self

/*----------------------------------------------------------------------*/
//                       TBrowse Like Navigation
/*----------------------------------------------------------------------*/

METHOD HbQtEditor:home()
   ::qEdit:hbApplyKey( Qt_Key_Home )
   RETURN Self


METHOD HbQtEditor:end()
   ::qEdit:hbApplyKey( Qt_Key_End )
   RETURN Self


METHOD HbQtEditor:down()
   ::qEdit:hbApplyKey( Qt_Key_Down )
   RETURN Self


METHOD HbQtEditor:up()
   ::qEdit:hbApplyKey( Qt_Key_Up )
   RETURN Self


METHOD HbQtEditor:goBottom()
   ::qEdit:hbApplyKey( Qt_Key_End, Qt_ControlModifier )
   RETURN Self


METHOD HbQtEditor:goTop()
   ::qEdit:hbApplyKey( Qt_Key_Home, Qt_ControlModifier )
   RETURN Self


METHOD HbQtEditor:left()
   ::qEdit:hbApplyKey( Qt_Key_Left )
   RETURN Self


METHOD HbQtEditor:right()
   ::qEdit:hbApplyKey( Qt_Key_Right )
   RETURN Self


METHOD HbQtEditor:panEnd()
   LOCAL oTxtCursor := ::getCursor()
   LOCAL cLine := ::getLine()
   ::qEdit:hbGetViewportInfo()
   IF Len( cLine ) - ::aViewportInfo[ 2 ] > ::aViewportInfo[ 4 ]
      oTxtCursor:movePosition( QTextCursor_Right, QTextCursor_MoveAnchor, Len( cLine ) - ::aViewportInfo[ 2 ] )
   ELSE
      oTxtCursor:movePosition( QTextCursor_EndOfLine )
   ENDIF
   ::qEdit:setTextCursor( oTxtCursor )
   RETURN Self


METHOD HbQtEditor:panHome()
   LOCAL oTxtCursor := ::getCursor()
   ::qEdit:hbGetViewportInfo()
   IF ::aViewportInfo[ 2 ] == 0
      oTxtCursor:movePosition( QTextCursor_StartOfLine )
   ELSE
      oTxtCursor:movePosition( QTextCursor_Left, QTextCursor_MoveAnchor, oTxtCursor:columnNumber() - ::aViewportInfo[ 2 ] )
   ENDIF
   ::qEdit:setTextCursor( oTxtCursor )
   RETURN Self


METHOD HbQtEditor:pageUp()
   ::qEdit:hbApplyKey( Qt_Key_PageUp )
   RETURN Self


METHOD HbQtEditor:pageDown()
   ::qEdit:hbApplyKey( Qt_Key_PageDown )
   RETURN Self

/*----------------------------------------------------------------------*/
//                            Print Preview
/*----------------------------------------------------------------------*/

METHOD HbQtEditor:printPreview()
   LOCAL qDlg := QPrintPreviewDialog( ::qEdit )

   qDlg:setWindowTitle( "HbIDE Preview Dialog" )
   qDlg:connect( "paintRequested(QPrinter*)", {|p| ::paintRequested( p ) } )
   qDlg:exec()
   qDlg:disconnect( "paintRequested(QPrinter*)" )

   RETURN self


METHOD HbQtEditor:paintRequested( qPrinter )
   ::qEdit:print( qPrinter )
   RETURN Self


METHOD HbQtEditor:upperCaseKeywords()
   LOCAL qDoc, cText, cRegEx, aMatches, aMatch
   STATIC b_

   qDoc := ::qEdit:document()

   IF !( qDoc:isEmpty() )
      qDoc:setUndoRedoEnabled( .f. )

      cText := qDoc:toPlainText()

      IF Empty( b_ )
         b_:= { 'function','procedure','thread','return','static','local','default', ;
                'if','else','elseif','endif','end', ;
                'docase','case','endcase','otherwise', ;
                'switch','endswitch', ;
                'do','while','exit','enddo','loop',;
                'for','each','next','step','to','in',;
                'with','replace','object','endwith','request',;
                'nil','and','or','in','not','self',;
                'class','endclass','method','data','var','destructor','inline','assign','access',;
                'inherit','init','create','virtual','message', 'from', 'setget',;
                'begin','sequence','try','catch','always','recover','hb_symbol_unused', ;
                'error','handler','private','public' }
      ENDIF
      cRegEx := ""
      aeval( b_, {|e| cRegEx += iif( empty( cRegEx ), "", "|" ) + "\b" + e + "\b" } )

      aMatches := hb_regExAll( cRegEx, cText, .f., .f., 0, 1, .f. )

      IF ! empty( aMatches )
         FOR EACH aMatch IN aMatches
            cText := stuff( cText, aMatch[ 2 ], aMatch[ 3 ] - aMatch[ 2 ] + 1, upper( aMatch[ 1 ] ) )
         NEXT
      ENDIF

      qDoc:clear()
      qDoc:setPlainText( cText )

      qDoc:setUndoRedoEnabled( .t. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:formatBraces( nMode )
   LOCAL qDoc, cText

   IF ! HB_ISNUMERIC( nMode )
      nMode := 0
   ENDIF
   qDoc := ::qEdit:document()

   IF ! qDoc:isEmpty()
      qDoc:setUndoRedoEnabled( .f. )

      cText := qDoc:toPlainText()

      SWITCH nMode
      CASE 0
         cText := __formatBrace( cText, "(", ")", 6 )
         cText := __formatBrace( cText, "{", "}", 6 )
         cText := __formatBrace( cText, "[", "]", 6 )
         EXIT
      CASE 1
         cText := __formatOperators( cText, { ":=", "==", ">=", "<=", "!=", "<>", ".AND.", ".OR.", ".NOT." }, 1 )
         EXIT
      CASE 2
         cText := __formatCommas( cText, 1 )
         EXIT
      ENDSWITCH

      qDoc:clear()
      qDoc:setPlainText( cText )

      qDoc:setUndoRedoEnabled( .t. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:removeTrailingSpaces()
   LOCAL qDoc, cText, a_, s

   qDoc := ::qEdit:document()
   IF !( qDoc:isEmpty() )
      qDoc:setUndoRedoEnabled( .f. )
      cText := qDoc:toPlainText()
      a_:= __memoToArray( cText )
      FOR EACH s IN a_
         s := trim( s )
      NEXT
      cText := __arrayToMemo( a_ )
      qDoc:clear()
      qDoc:setPlainText( cText )
      qDoc:setUndoRedoEnabled( .t. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:tabs2spaces()
   LOCAL qDoc, cText, cSpaces

   qDoc := ::qEdit:document()
   IF !( qDoc:isEmpty() )
      cSpaces := space( ::nTabSpaces )

      qDoc:setUndoRedoEnabled( .f. )

      cText := qDoc:toPlainText()
      qDoc:clear()
      cText := strtran( cText, chr( 9 ), cSpaces )
      qDoc:setPlainText( cText )

      qDoc:setUndoRedoEnabled( .t. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:spaces2tabs()
   LOCAL qDoc, cText, cSpaces

   qDoc := ::qEdit:document()
   IF !( qDoc:isEmpty() )
      cSpaces := space( ::nTabSpaces )

      qDoc:setUndoRedoEnabled( .f. )

      cText := qDoc:toPlainText()
      qDoc:clear()
      qDoc:setPlainText( strtran( cText, cSpaces, chr( 9 ) ) )

      qDoc:setUndoRedoEnabled( .t. )
   ENDIF
   RETURN Self


METHOD HbQtEditor:duplicateLine()
   ::qEdit:hbDuplicateLine()
   RETURN Self


METHOD HbQtEditor:deleteLine()
   ::qEdit:hbDeleteLine()
   RETURN Self


METHOD HbQtEditor:moveLine( nDirection )
   ::qEdit:hbMoveLine( nDirection )
   RETURN Self


METHOD HbQtEditor:getText()
   RETURN ::qEdit:textCursor():selectedText()


METHOD HbQtEditor:getWord( lSelect )
   LOCAL cText, oTxtCursor := ::qEdit:textCursor()

   DEFAULT lSelect TO .F.

   oTxtCursor:select( QTextCursor_WordUnderCursor )
   cText := oTxtCursor:selectedText()

   IF lSelect
      ::qEdit:setTextCursor( oTxtCursor )
   ENDIF
   RETURN cText


METHOD HbQtEditor:goto( nLine )
   LOCAL nRows, oGo
   LOCAL oTxtCursor := ::qEdit:textCursor()

   IF empty( nLine )
      nRows := ::qEdit:blockCount()
      nLine := iif( Empty( ::nGotoLast ), oTxtCursor:blockNumber(), ::nGotoLast )

      WITH OBJECT oGo := QInputDialog( ::qEdit )
         :setInputMode( 1 )
         :setIntMinimum( 1 )
         :setIntMaximum( nRows )
         :setIntValue( nLine + 1 )
         :setLabelText( "Goto Line Number [1-" + hb_ntos( nRows ) + "]" )
         :setWindowTitle( "Harbour" )
      ENDWITH
      oGo:exec()

      nLine := oGo:intValue()
      ::nGotoLast := nLine
      oGo:setParent( QWidget() )
      ::qEdit:setFocus()
   ENDIF

   oTxtCursor:movePosition( QTextCursor_Start )
   oTxtCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine - 1 )
   ::qEdit:setTextCursor( oTxtCursor )
   ::qEdit:centerCursor()
   RETURN Self


METHOD HbQtEditor:getLine( nLine, lSelect )
   LOCAL cText, oTxtCursor := ::qEdit:textCursor()

   DEFAULT nLine   TO oTxtCursor:blockNumber() + 1
   DEFAULT lSelect TO .F.

   IF nLine != oTxtCursor:blockNumber() + 1
      oTxtCursor:movePosition( QTextCursor_Start )
      oTxtCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine - 1 )
   ENDIF

   oTxtCursor:select( QTextCursor_LineUnderCursor )
   cText := oTxtCursor:selectedText()
   IF lSelect
      ::qEdit:setTextCursor( oTxtCursor )
   ENDIF

   RETURN cText


METHOD HbQtEditor:getColumnNo()
   RETURN ::qEdit:textCursor():columnNumber() + 1


METHOD HbQtEditor:getLineNo()
   RETURN ::qEdit:textCursor():blockNumber() + 1


METHOD HbQtEditor:insertSeparator( cSep )
   LOCAL oTxtCursor := ::qEdit:textCursor()

   IF empty( cSep )
      cSep := ::cSeparator
   ENDIF
   WITH OBJECT oTxtCursor
      :beginEditBlock()
      :movePosition( QTextCursor_StartOfBlock )
      :insertBlock()
      :movePosition( QTextCursor_PreviousBlock )
      :insertText( cSep )
      :movePosition( QTextCursor_NextBlock )
      :movePosition( QTextCursor_StartOfBlock )
      :endEditBlock()
   ENDWITH
   RETURN Self


METHOD HbQtEditor:insertText( cText )
   LOCAL oTxtCursor, nL, nB

   IF HB_ISSTRING( cText ) .AND. !Empty( cText )
      oTxtCursor := ::qEdit:textCursor()

      nL := Len( cText )
      nB := oTxtCursor:position() + nL

      WITH OBJECT oTxtCursor
         :beginEditBlock()
         :removeSelectedText()
         :insertText( cText )
         :setPosition( nB )
         :endEditBlock()
      ENDWITH
   ENDIF
   RETURN Self


/* called via ::contentsChangedBlock if assigned */
METHOD HbQtEditor:reformatLine( nPos, nDeleted, nAdded )
   LOCAL cProto, nRows, nCols, nCol, cWord
   LOCAL cPWord, cPPWord, nPostn, nLine, nLPrev, nLPrevPrev, nCPrev, nCPrevPrev, nOff, cCased
   LOCAL cCWord  := ""
   LOCAL cRest   := ""
   LOCAL oTxtCursor := ::qEdit:textCursor()

   IF .T.
      oTxtCursor:joinPreviousEditBlock()
      IF ! __IsInCommentOrString( oTxtCursor:block():text(), oTxtCursor:columnNumber() )

         nPostn := oTxtCursor:position()
         nLine  := oTxtCursor:blockNumber()

         IF nPos == -1
            cCWord := " "
         ELSE
            IF ( nCol := nPostn - oTxtCursor:block():position() ) > 0
               cCWord := SubStr( oTxtCursor:block():text(), nCol, 1 )
            ENDIF
         ENDIF

         IF oTxtCursor:movePosition( QTextCursor_EndOfLine, QTextCursor_KeepAnchor ) .AND. oTxtCursor:position() > nPostn
            cRest := oTxtCursor:selectedText()
         ENDIF
         oTxtCursor:clearSelection()
         oTxtCursor:setPosition( nPostn )

         oTxtCursor:movePosition( QTextCursor_PreviousWord, QTextCursor_MoveAnchor, 1 )
         nLPrev := oTxtCursor:blockNumber()
         IF nLPrev == nLine
            nCPrev := oTxtCursor:position() - oTxtCursor:block():position()
            oTxtCursor:select( QTextCursor_WordUnderCursor )
            cPWord := oTxtCursor:selectedText()
            oTxtCursor:clearSelection()
            oTxtCursor:setPosition( nPostn )

            oTxtCursor:movePosition( QTextCursor_PreviousWord, QTextCursor_MoveAnchor, 2 )
            nLPrevPrev := oTxtCursor:blockNumber()
            IF nLPrevPrev == nLine
               nCPrevPrev := oTxtCursor:position() - oTxtCursor:block():position()
               oTxtCursor:select( QTextCursor_WordUnderCursor )
               cPPWord := oTxtCursor:selectedText()
            ELSE
               nCPrevPrev := -1
               cPPWord := ""
            ENDIF
            oTxtCursor:clearSelection()
            oTxtCursor:setPosition( nPostn )

            /* Group I operations */
            IF cPWord == "." .AND. cPPWord $ ::hLogicals     /* ALWAYS */
               IF ! ::lSupressHbKWordsToUpper
                  WITH OBJECT oTxtCursor
                     :movePosition( QTextCursor_PreviousWord, QTextCursor_MoveAnchor, 2 )
                     :select( QTextCursor_WordUnderCursor )
                     :removeSelectedText()
                     :insertText( upper( cPPWord ) )
                     :setPosition( nPostn )
                  ENDWITH
               ENDIF

            ELSEIF cPWord == ":=" .AND. cCWord == "=" .AND. nAdded == 1
               IF ::lISOperator
                  oTxtCursor:insertText( " " )
               ENDIF
               IF ::lISAlignAssign
                  // look for previous lines and if 2nd keyword is assignment operator then align both to same offset
                  __alignAssignments( oTxtCursor )
               ENDIF

            ELSEIF ::lISCodeBlock .AND. Right( cPWord, 2 ) == "{|" .AND. cCWord == "|" .AND. nAdded == 1 .AND. Empty( cRest )
               oTxtCursor:insertText( "|  }" )
               oTxtCursor:setPosition( nPostn )

            ELSEIF cCWord == "(" .AND. ( __hbqtIsHarbourFunction( cPPWord, @cCased ) .OR. __hbqtIsQtFunction( cPPWord, @cCased ) .OR. __hbqtIsUserFunction( cPPWord, @cCased ) )
               __replaceWord( oTxtCursor, 2, cCased, nPostn )
               IF ::lISClosingP
                  IF cCWord == "(" .AND. nAdded == 1
                     oTxtCursor:insertText( ")" )
                     IF ::lISSpaceP
                        oTxtCursor:setPosition( nPostn )
                        oTxtCursor:insertText( "  " )
                        nPostn++
                     ENDIF
                  ENDIF
               ENDIF
               oTxtCursor:setPosition( nPostn )

            ELSEIF cCWord == " " .AND. __hbqtIsUserFunction( cPPWord, @cCased ) /* User dictionaries : only keywords */
               __replaceWord( oTxtCursor, 2, cCased, nPostn )

            ELSEIF cCWord == " " .AND. cPPWord != "#" .AND. __isHarbourKeyword( cPWord )
               IF ! ::lSupressHbKWordsToUpper
                  WITH OBJECT oTxtCursor
                     :movePosition( QTextCursor_PreviousWord, QTextCursor_MoveAnchor, 1 )
                     :select( QTextCursor_WordUnderCursor )
                     :removeSelectedText()
                     :insertText( upper( cPWord ) )
                     :setPosition( nPostn )
                  ENDWITH
               ENDIF

            ENDIF

            IF cCWord == " " .AND. ! Empty( cPWord ) .AND. ! ( Left( cPWord, 1 ) $ "`~!@#$%^&*()+1234567890-=+[]{}|\':;?/>.<," )
               IF Len( cPWord ) > 3
                  Eval( ::bEventsBlock, __HBQTEDITOR_UPDATEWORDSINCOMPLETER__, cPWord, Self )
               ENDIF

            ELSEIF cCWord $ ",:(" .AND. ! Empty( cPPWord ) .AND. ! ( Left( cPPWord, 1 ) $ "`~!@#$%^&*()+1234567890-=+[]{}|\':;?/>.<," )
               IF Len( cPPWord ) > 3
                  Eval( ::bEventsBlock, __HBQTEDITOR_UPDATEWORDSINCOMPLETER__, cPPWord, Self )
               ENDIF
            ENDIF

            /* Group II operations */
            IF empty( cPPWord ) .AND. cCWord == " "
               IF __isStartingKeyword( cPWord, ::lReturnAsBeginKeyword )
                  WITH OBJECT oTxtCursor                                       /* FUNCTION PROCEDURE CLASS */
                     :movePosition( QTextCursor_StartOfBlock )
                     :movePosition( QTextCursor_NextCharacter, QTextCursor_KeepAnchor, nCPrev )
                     :removeSelectedText()
                     :movePosition( QTextCursor_NextCharacter, QTextCursor_MoveAnchor, Len( cPWord ) + 1 )
                  ENDWITH

               ELSEIF ::lAutoIndent .AND. __isMinimumIndentableKeyword( cPWord, ::lReturnAsBeginKeyword )  /* LOCAL STATIC DEFAULT PRIVATE PUBLIC ENDCLASS RETURN */
                  WITH OBJECT oTxtCursor
                     :movePosition( QTextCursor_StartOfBlock )
                     :movePosition( QTextCursor_NextCharacter, QTextCursor_KeepAnchor, nCPrev )
                     :removeSelectedText()
                     :insertText( space( ::nTabSpaces ) )
                     :movePosition( QTextCursor_NextCharacter, QTextCursor_MoveAnchor, Len( cPWord ) + 1 )
                  ENDWITH

               ELSEIF  ::lAutoIndent .AND. __isIndentableKeyword( cPWord )         /* IF SWITCH FOR DO */
                  IF nCPrev < ::nTabSpaces
                     nOff := ::nTabSpaces - nCPrev
                     WITH OBJECT oTxtCursor
                        :movePosition( QTextCursor_StartOfBlock )
                        :insertText( space( nOff ) )
                        :setPosition( nPostn + nOff )
                     ENDWITH

                  ELSEIF ( nOff := nCPrev % ::nTabSpaces ) > 0            /* We always go back to the previous indent */
                     WITH OBJECT oTxtCursor
                        :movePosition( QTextCursor_StartOfBlock )
                        :movePosition( QTextCursor_NextCharacter, QTextCursor_KeepAnchor, nOff )
                        :removeSelectedText()
                        :setPosition( nPostn - nOff )
                     ENDWITH

                  ENDIF
               ENDIF
            ENDIF

            /* Group III operations */
            IF cCWord == " " .AND. nAdded == 1 .AND. Empty( cRest )   /* Only first time having only word on a line */
               cWord := Lower( cPWord )

               IF ::lISClosing
                  IF     ::lISIf      .AND. cWord == "if" .AND. Empty( cPPWord ) /* Protected for #if */
                     ::appendIF( oTxtCursor )
                  ELSEIF ::lISFor     .AND. cWord == "for"
                     ::appendFOR( oTxtCursor )
                  ELSEIF ::lISSwitch  .AND. cWord == "switch"
                     ::appendSWITCH( oTxtCursor )
                  ELSEIF ::lISDoCase  .AND. Lower( cPPWord ) == "do" .AND. cWord == "case"
                     ::appendCASE( oTxtCursor )
                  ELSEIF ::lISDoWhile .AND. Lower( cPPWord ) == "do" .AND. cWord == "while"
                     ::appendWHILE( oTxtCursor )
                  ELSEIF Lower( cPPWord ) == "with" .AND. cWord == "object"
                     ::appendWITH( oTxtCursor )
                  ENDIF
               ENDIF

               IF cWord == "elseif" .OR. cWord == "else" .OR. cWord == "endif"
                  __alignToPrevWord( oTxtCursor, "if", "endif", Len( cWord ), nPostn )
               ELSEIF cWord == "next"
                  __alignToPrevWord( oTxtCursor, "for", "next", Len( cWord ), nPostn )
               ELSEIF cWord == "endwith"
                  __alignToPrevWord( oTxtCursor, "with", "endwith", Len( cWord ), nPostn )
               ELSEIF Lower( cPPWord ) == "static" .AND. ( cPWord == "function" .OR. cPWord == "procedure" )
                  __removeStartingSpaces( oTxtCursor, nCPrevPrev )
                  IF ::lISFunction
                     ::appendFUNCTION( oTxtCursor )
                  ENDIF
               ELSEIF Empty( cPPWord ) .AND. ( cPWord == "function" .OR. cPWord == "procedure" )
                  IF ::lISFunction
                     ::appendFUNCTION( oTxtCursor )
                  ENDIF
               ELSEIF Lower( cPPWord ) == "create" .AND. cPWord == "class"
                  __removeStartingSpaces( oTxtCursor, nCPrevPrev )
               ELSEIF Lower( cPPWord ) == "class" .AND. ! Empty( cPWord )
                  IF ::lISClass
                     ::appendCLASS( oTxtCursor, cPWord )
                  ENDIF
               ENDIF
            ENDIF
            ::qEdit:setTextCursor( oTxtCursor )
         ENDIF
      ENDIF /* __IsInCommentOrString( oTxtCursor:block():text(), oTxtCursor:columnNumber() ) */
      oTxtCursor:endEditBlock()
   ENDIF

   IF nPos != -1
      ::handleCurrentIndent()
   ENDIF

   IF ::nProtoLine != -1
      IF ::getLineNo() == ::nProtoLine .AND. ::getColumnNo() >= ::nProtoCol + 1
         IF !empty( cProto := __formatProto_1( ::cProtoOrg, ::getLine(), ::nProtoCol, ::getColumnNo(), @nRows, @nCols ) )
            ::cProto     := cProto
            ::nProtoRows := nRows
            ::nProtoCols := nCols
            ::showProtoType()
         ENDIF
      ENDIF
   ENDIF

   HB_SYMBOL_UNUSED( nDeleted )
   RETURN cRest


METHOD HbQtEditor:appendCLASS( oTxtCursor, cClassName )
   LOCAL cMethod
   LOCAL nTabSpaces := ::nTabSpaces
   LOCAL aMethods   := hb_ATokens( ::cISMethods, ";" )
   LOCAL nPostn     := oTxtCursor:position()
   LOCAL nClosingIndent := iif( ::lReturnAsBeginKeyword, 0, nTabSpaces )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      :insertBlock()
      :insertText( Space( nTabSpaces ) + PadR( ::cISData, 7 ) + "xDummy" + Space( 34 ) + "INIT NIL" )
      :insertBlock()
      FOR EACH cMethod IN aMethods
         :insertBlock()
         :insertText( Space( nTabSpaces ) + "METHOD " + cMethod + "()" )
      NEXT
      :insertBlock()
      :insertBlock()
      :insertText( Space( nClosingIndent ) + "ENDCLASS " )
      :insertBlock()
      :insertBlock()
      FOR EACH cMethod IN aMethods
         :insertBlock()
         IF ::cISFormat == "class:method"
            :insertText( "METHOD " + cClassName + ":" + cMethod + "()" )
         ELSE
            :insertText( "METHOD " + cMethod + "() CLASS " + cClassName )
         ENDIF
         :insertBlock()
         :insertBlock()
         :insertText( Space( nClosingIndent ) + "RETURN Self " )
         :insertBlock()
         :insertBlock()
      NEXT
      :insertBlock()
      :setPosition( nPostn )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendFUNCTION( oTxtCursor )
   LOCAL nPostn := oTxtCursor:position()

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      IF ::lISLocal
         :insertBlock()
         :insertText( Space( ::nTabSpaces ) + "LOCAL " )
         :insertBlock()
      ENDIF
      IF ::lISReturn
         :insertBlock()
         :insertText( Space( iif( ::lReturnAsBeginKeyword, 0, ::nTabSpaces ) ) + "RETURN " )
         :insertBlock()
         IF ::lISSeparator
            :insertBlock()
            :insertText( ::cSeparator )
            :insertBlock()
         ELSE
            :insertBlock()
         ENDIF
      ENDIF
      :insertBlock()
      :setPosition( nPostn )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendCASE( oTxtCursor )
   LOCAL i
   LOCAL nCurPos := oTxtCursor:position()
   LOCAL nIndent := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      FOR i := 1 TO ::nISCaseCases
         :insertBlock()
         :insertText( Space( nIndent ) + "CASE " )
      NEXT
      IF ::lISCaseOWise
         :insertBlock()
         :insertText( Space( nIndent ) + "OTHERWISE" )
      ENDIF
      :insertBlock()
      :insertText( Space( nIndent ) + "ENDCASE" )
      :setPosition( nCurPos )
      :movePosition( QTextCursor_NextBlock )
      :movePosition( QTextCursor_EndOfLine )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendSWITCH( oTxtCursor )
   LOCAL i
   LOCAL nCurPos  := oTxtCursor:position()
   LOCAL nIndent  := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      FOR i := 1 TO ::nISSwitchCases
         :insertBlock()
         IF ::lISExitSameLine
            :insertText( Space( nIndent ) + "CASE   ; EXIT" )
         ELSE
            :insertText( Space( nIndent ) + "CASE " )
            :insertBlock()
            :insertText( Space( nIndent + ::nTabSpaces ) + "EXIT" )
         ENDIF
      NEXT
      IF ::lISSwitchOWise
         :insertBlock()
         :insertText( Space( nIndent ) + "OTHERWISE" )
      ENDIF
      :insertBlock()
      :insertText( Space( nIndent ) + "ENDSWITCH" )
      :setPosition( nCurPos )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendWHILE( oTxtCursor )
   LOCAL nCurPos  := oTxtCursor:position()
   LOCAL nIndent  := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      :insertBlock()
      :insertText( Space( nIndent ) + "ENDDO" )
      :setPosition( nCurPos )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendFOR( oTxtCursor )
   LOCAL nCurPos  := oTxtCursor:position()
   LOCAL nIndent  := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      :insertBlock()
      :insertText( Space( nIndent ) + "NEXT" )
      :setPosition( nCurPos )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendWITH( oTxtCursor )
   LOCAL nCurPos  := oTxtCursor:position()
   LOCAL nIndent  := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_EndOfBlock )
      :insertBlock()
      :insertText( Space( nIndent ) + "ENDWITH" )
      :setPosition( nCurPos )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:appendIF( oTxtCursor )
   LOCAL nCol, cLine
   LOCAL lAligned := .F.
   LOCAL nCurPos  := oTxtCursor:position()
   LOCAL nIndent  := __getFrontSpacesAndWord( oTxtCursor:block():text() )

   IF ::lISEmbrace
      oTxtCursor:movePosition( QTextCursor_StartOfBlock )
      IF oTxtCursor:movePosition( QTextCursor_NextBlock )
         cLine := oTxtCursor:block():text()
         nCol := __getFrontSpacesAndWord( cLine )
         IF ! Empty( cLine ) .AND. nCol == nIndent
            lAligned := .T.
            oTxtCursor:insertText( Space( ::nTabSpaces ) )
            DO WHILE oTxtCursor:movePosition( QTextCursor_NextBlock )
               nCol := __getFrontSpacesAndWord( oTxtCursor:block():text() )
               IF nCol < nIndent
                  oTxtCursor:movePosition( QTextCursor_PreviousBlock )
                  EXIT
               ENDIF
               oTxtCursor:insertText( Space( ::nTabSpaces ) )
               QApplication():processEvents()
            ENDDO
         ENDIF
      ENDIF
   ENDIF

   WITH OBJECT oTxtCursor
      IF ! lAligned
         :movePosition( QTextCursor_PreviousBlock )
         :setPosition( nCurPos )
      ENDIF
      :movePosition( QTextCursor_EndOfBlock )
      IF ::lISElse
         :insertBlock()
         :insertText( Space( nIndent ) + "ELSE" )
      ENDIF
      :insertBlock()
      :insertText( Space( nIndent ) + "ENDIF" )
      :setPosition( nCurPos )
   ENDWITH
   RETURN NIL


METHOD HbQtEditor:findLastIndent()
   LOCAL oTxtCursor, qTextBlock, cText, cWord
   LOCAL nSpaces := 0

   oTxtCursor := ::qEdit:textCursor()
   qTextBlock := oTxtCursor:block()

   qTextBlock := qTextBlock:previous()
   DO WHILE .t.
      IF !( qTextBlock:isValid() )
         EXIT
      ENDIF
      IF !empty( cText := qTextBlock:text() )
         nSpaces := __getFrontSpacesAndWord( cText, @cWord )
         IF !empty( cWord )
            IF ::lSmartIndent .AND. __isIndentableKeyword( cWord )
               nSpaces += ::nTabSpaces
            ENDIF
            EXIT
         ENDIF
      ENDIF
      qTextBlock := qTextBlock:previous()
   ENDDO
   RETURN nSpaces


METHOD HbQtEditor:handleCurrentIndent()
   LOCAL oTxtCursor, nSpaces

   IF ::lIndentIt
      ::lIndentIt := .F.
      IF ( nSpaces := ::findLastIndent() ) > 0
         oTxtCursor := ::qEdit:textCursor()
         IF ::nEnterPos > nSpaces
            oTxtCursor:insertText( Space( nSpaces ) )
         ENDIF
      ENDIF
      ::nEnterPos := 0
   ENDIF
   RETURN Self


METHOD HbQtEditor:openHeaderFile()
   LOCAL aCord, nT, nL, nB, nR, nW, cLine, cExt, cNext, cHeader
   LOCAL lOpened := .F.

   aCord := ::aSelectionInfo
   __normalizeRect( aCord, @nT, @nL, @nB, @nR )
   nW := nR - nL

   IF nW >= 0 .AND. nT == nB
      cLine := ::getLine( nT + 1 )
      IF SubStr( cLine, nL, 1 ) $ ['"]
         cExt := SubStr( cLine, nR + 1, 3 )
         cNext := SubStr( cLine, nR + 1 + 3, 1 )
         IF Lower( cExt ) == ".ch" .AND. cNext $ ['"]
            cHeader := SubStr( cLine, nL + 1, nW ) + cExt
         ELSEIF Lower( Left( cExt, 2 ) ) == ".h" .AND. Right( cExt, 1 ) $ ['"]
            cHeader := SubStr( cLine, nL + 1, nW ) + Left( cExt, 2 )
         ENDIF
         IF ! Empty( cHeader )
            lOpened := Eval( ::bEventsBlock, __HBQTEDITOR_SHOWHEADERFILE__, { cHeader, cExt }, Self )
         ENDIF
      ENDIF
   ENDIF
   RETURN lOpened


METHOD HbQtEditor:gotoFunction()
   LOCAL cWord
   IF ! Empty( cWord := ::getWord( .f. ) )
      Eval( ::bEventsBlock, __HBQTEDITOR_JUMPTOFUNCTION__, cWord, Self )
   ENDIF
   RETURN Self


METHOD HbQtEditor:clickFuncHelp()
   LOCAL cWord
   IF ! empty( cWord := ::getWord( .F. ) )
      Eval( ::bEventsBlock, __HBQTEDITOR_JUMPTOFUNCTIONHELP__, cWord, Self )
   ENDIF
   RETURN Self


METHOD HbQtEditor:loadFuncHelp()
   LOCAL oTxtCursor, cText, cWord

   oTxtCursor := ::qEdit:textCursor()
   cText   := oTxtCursor:block():text()
   cWord   := __getPreviousWord( cText, oTxtCursor:columnNumber() )

   IF ! Empty( cWord )
      Eval( ::bEventsBlock, __HBQTEDITOR_LOADFUNCTIONHELP__, cWord, Self )
   ENDIF
   RETURN Self


METHOD HbQtEditor:resumePrototype()
   ::isSuspended := .f.
   IF !empty( ::qEdit )
      IF ::getLineNo() == ::nProtoLine .AND. ::getColumnNo() >= ::nProtoCol
         ::qEdit:hbShowPrototype( ::cProto, ::nProtoRows, ::nProtoCols )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtEditor:suspendPrototype()
   ::isSuspended := .t.
   IF !empty( ::qEdit )
      ::qEdit:hbShowPrototype( "", 0, 0 )
   ENDIF
   RETURN Self


METHOD HbQtEditor:showPrototype( cProto )
   IF ! ::isSuspended  .AND. !empty( ::qEdit )
      IF !empty( cProto )
         ::cProtoOrg  := cProto
         ::cProto     := __formatProto( cProto )
         ::nProtoLine := ::getLineNo()
         ::nProtoCol  := ::getColumnNo()
      ENDIF
      ::qEdit:hbShowPrototype( ::cProto, ::nProtoRows, ::nProtoCols )
   ENDIF
   RETURN Self


METHOD HbQtEditor:hidePrototype()
   IF !empty( ::qedit )
      ::nProtoLine := -1
      ::nProtoCol  := -1
      ::cProto     := ""
      ::nProtoCols := 10
      ::nProtoRows := 1
      ::qEdit:hbShowPrototype( "", 0, 0 )
   ENDIF
   RETURN Self


METHOD HbQtEditor:parseCodeCompletion( cSyntax )
   LOCAL cText, n, nFun, nAbr, nSpc

   nAbr := at( "-", cSyntax )
   nSpc := at( " ", cSyntax )
   nFun := at( "(", cSyntax )

   IF "[f]" $ cSyntax
      cText := alltrim( substr( cSyntax, 1, nSpc ) )

   ELSEIF nAbr > 0 .AND. iif( nSpc == 0, .t., nAbr < nSpc ).AND. iif( nFun == 0, .t., nAbr < nFun )
      cText := AllTrim( substr( cSyntax, nAbr + 1 ) )

   ELSE
      IF ::lCompleteArgumented
         IF ( n := RAt( ")", cSyntax ) ) > 0
            cText := Trim( SubStr( cSyntax, 1, n ) )
         ELSE
            cText := Trim( cSyntax )
         ENDIF
      ELSE
         IF nFun > 0 .AND. iif( nSpc == 0, .t., nFun < nSpc )
            cText := Trim( SubStr( cSyntax, 1, nFun - 1 ) )
         ELSE
            cText := Trim( cSyntax )
         ENDIF
      ENDIF
   ENDIF
   RETURN cText


METHOD HbQtEditor:completeCode( p )
   LOCAL cWord
   LOCAL oTxtCursor := ::qEdit:textCursor()

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_Left )
      :movePosition( QTextCursor_StartOfWord )
      :movePosition( QTextCursor_EndOfWord, QTextCursor_KeepAnchor )
      cWord := :selectedText()
      IF cWord == "->"
         :clearSelection()
      ENDIF
      :insertText( ::parseCodeCompletion( p ) )
      :movePosition( QTextCursor_Left )
      :movePosition( QTextCursor_Right )
   ENDWITH

   ::qEdit:setTextCursor( oTxtCursor )
   Eval( ::bEventsBlock, __HBQTEDITOR_UPDATEFIELDSLIST__, NIL, Self )
   RETURN Self


METHOD HbQtEditor:setFormattingInfo( hInfo )

   IF HB_ISHASH( hInfo )
      IF hb_HHasKey( hInfo, "lAutoIndent"             )
         ::lAutoIndent             := hInfo[ "lAutoIndent"             ]
      ENDIF
      IF hb_HHasKey( hInfo, "lSmartIndent"            )
         ::lSmartIndent            := hInfo[ "lSmartIndent"            ]
      ENDIF
      IF hb_HHasKey( hInfo, "lSupressHbKWordsToUpper" )
         ::lSupressHbKWordsToUpper := hInfo[ "lSupressHbKWordsToUpper" ]
      ENDIF
      IF hb_HHasKey( hInfo, "lReturnAsBeginKeyword"   )
         ::lReturnAsBeginKeyword   := hInfo[ "lReturnAsBeginKeyword"   ]
      ENDIF
      IF hb_HHasKey( hInfo, "lCompleteArgumented"     )
         ::lCompleteArgumented     := hInfo[ "lCompleteArgumented"     ]
      ENDIF

      IF hb_HHasKey( hInfo, "lISOperator"             )
         ::lISOperator             := hInfo[ "lISOperator"             ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISAlignAssign"          )
         ::lISAlignAssign          := hInfo[ "lISAlignAssign"          ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISCodeBlock"            )
         ::lISCodeBlock            := hInfo[ "lISCodeBlock"            ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISClosingP"             )
         ::lISClosingP             := hInfo[ "lISClosingP"             ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISSpaceP"               )
         ::lISSpaceP               := hInfo[ "lISSpaceP"               ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISClosing"              )
         ::lISClosing              := hInfo[ "lISClosing"              ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISIf"                   )
         ::lISIf                   := hInfo[ "lISIf"                   ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISElse"                 )
         ::lISElse                 := hInfo[ "lISElse"                 ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISEmbrace"              )
         ::lISEmbrace              := hInfo[ "lISEmbrace"              ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISFor"                  )
         ::lISFor                  := hInfo[ "lISFor"                  ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISSwitch"               )
         ::lISSwitch               := hInfo[ "lISSwitch"               ]
      ENDIF
      IF hb_HHasKey( hInfo, "nISSwitchCases"          )
         ::nISSwitchCases          := hInfo[ "nISSwitchCases"          ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISSwitchOWise"          )
         ::lISSwitchOWise          := hInfo[ "lISSwitchOWise"          ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISExitSameLine"         )
         ::lISExitSameLine         := hInfo[ "lISExitSameLine"         ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISDoCase"               )
         ::lISDoCase               := hInfo[ "lISDoCase"               ]
      ENDIF
      IF hb_HHasKey( hInfo, "nISCaseCases"            )
         ::nISCaseCases            := hInfo[ "nISCaseCases"            ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISCaseOWise"            )
         ::lISCaseOWise            := hInfo[ "lISCaseOWise"            ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISDoWhile"              )
         ::lISDoWhile              := hInfo[ "lISDoWhile"              ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISFunction"             )
         ::lISFunction             := hInfo[ "lISFunction"             ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISLocal"                )
         ::lISLocal                := hInfo[ "lISLocal"                ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISReturn"               )
         ::lISReturn               := hInfo[ "lISReturn"               ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISSeparator"            )
         ::lISSeparator            := hInfo[ "lISSeparator"            ]
      ENDIF
      IF hb_HHasKey( hInfo, "lISClass"                )
         ::lISClass                := hInfo[ "lISClass"                ]
      ENDIF
      IF hb_HHasKey( hInfo, "cISMethods"              )
         ::cISMethods              := hInfo[ "cISMethods"              ]
      ENDIF
      IF hb_HHasKey( hInfo, "cISData"                 )
         ::cISData                 := hInfo[ "cISData"                 ]
      ENDIF
      IF hb_HHasKey( hInfo, "cISFormat"               )
         ::cISFormat               := hInfo[ "cISFormat"               ]
      ENDIF

      IF hb_HHasKey( hInfo, "cSeparator"              )
         ::cSeparator              := hInfo[ "cSeparator"              ]
      ENDIF
   ENDIF
   RETURN Self

//--------------------------------------------------------------------//
//                        Supporting Functions
//--------------------------------------------------------------------//

STATIC FUNCTION __alignAssignments( oTxtCursor )
   LOCAL aWords, cLine, nIndent, nPostn, cCLine, nCBlock, nAssgnAt, nCol
   LOCAL lAssign := .F.

   nIndent := __getFrontSpacesAndWordsByCursor( oTxtCursor, @aWords )
   IF Len( aWords ) >= 2
      IF Len( aWords ) == 2 .AND. aWords[ 2 ] == ":=" .OR. ;
         Len( aWords ) == 4 .AND. aWords[ 4 ] == ":=" .OR. ;
         Len( aWords ) == 5 .AND. aWords[ 5 ] == ":=" .AND. aWords[ 1 ] == "::"

         cCLine   := oTxtCursor:block():text()
         nPostn   := oTxtCursor:position()
         nAssgnAt := At( ":=", cCLine )
         nCBlock  := oTxtCursor:blockNumber()

         DO WHILE .T.
            IF oTxtCursor:movePosition( QTextCursor_PreviousBlock, QTextCursor_MoveAnchor )
               IF ! Empty( cLine := oTxtCursor:block():text() )
                  nCol := __getFrontSpacesAndWordsByCursor( oTxtCursor, @aWords )
                  IF nCol == nIndent .AND. Len( aWords ) >= 2 .AND. aWords[ 2 ] == ":="
                     nAssgnAt := Max( nAssgnAt, At( ":=", cLine ) )
                     lAssign  := .T.
                  ELSEIF nCol == nIndent .AND. Len( aWords ) >= 4 .AND. aWords[ 2 ] == ":" .AND. aWords[ 4 ] == ":="
                     nAssgnAt := Max( nAssgnAt, At( ":=", cLine ) )
                     lAssign  := .T.
                  ELSEIF nCol == nIndent .AND. Len( aWords ) >= 5 .AND. aWords[ 1 ] == "::" .AND. aWords[ 3 ] == ":" .AND. aWords[ 5 ] == ":="
                     nAssgnAt := Max( nAssgnAt, At( ":=", cLine ) )
                     lAssign  := .T.
                  ELSE
                     EXIT
                  ENDIF
               ENDIF
            ELSE
               EXIT
            ENDIF
         ENDDO
         /* Anyway we are TO move TO NEXT block */
         oTxtCursor:movePosition( QTextCursor_NextBlock, QTextCursor_MoveAnchor )
         IF lAssign
            DO WHILE .T.
               cLine := oTxtCursor:block():text()
               IF ! Empty( cLine )
                  nCol  := At( ":=", cLine )
                  cLine := Pad( Trim( SubStr( cLine, 1, nCol - 1 ) ), nAssgnAt - 1 ) + ":=" + Trim( SubStr( cLine, nCol + 2 ) )
                  WITH OBJECT oTxtCursor
                     :movePosition( QTextCursor_EndOfLine, QTextCursor_KeepAnchor )
                     :removeSelectedText()
                     :insertText( cLine )
                  ENDWITH
               ENDIF
               IF oTxtCursor:blockNumber() == nCBlock
                  EXIT
               ENDIF
               oTxtCursor:movePosition( QTextCursor_NextBlock, QTextCursor_MoveAnchor )
            ENDDO
            /* We have reached on current line */
            oTxtCursor:movePosition( QTextCursor_EndOfBlock, QTextCursor_MoveAnchor )
         ELSE
            oTxtCursor:setPosition( nPostn )
         ENDIF
      ENDIF
   ENDIF
   RETURN NIL


STATIC FUNCTION __getPreviousWord( cText, nPos )
   LOCAL cWord, n

   cText := alltrim( substr( cText, 1, nPos ) )
   IF ( n := rat( " ", cText ) ) > 0
      cWord := substr( cText, n + 1 )
   ELSE
      cWord := cText
   ENDIF
   RETURN cWord


STATIC FUNCTION __getFirstWord( cText )
   LOCAL cWord, n

   cText := alltrim( cText )
   IF ( n := at( " ", cText ) ) > 0
      cWord := left( cText, n-1 )
   ELSE
      cWord := cText
   ENDIF
   RETURN cWord


STATIC FUNCTION __getSecondWord( cText )
   LOCAL cWord := "", a_

   a_:= hb_ATokens( AllTrim( cText ), " " )
   IF Len( a_ ) >= 2
      cWord := a_[ 2 ]
   ENDIF
   RETURN cWord


STATIC FUNCTION __getFrontSpacesAndWord( cText, cWord, cSWord )
   LOCAL n := 0

   DO WHILE .t.
      IF !( substr( cText, ++n, 1 ) == " " )
         EXIT
      ENDIF
   ENDDO
   n--

   cWord := __getFirstWord( cText )
   cSWord := __getSecondWord( cText )
   RETURN n


STATIC FUNCTION __formatProto_1( cProto, cText, nProtoCol, nCurCol, nRows, nCols )
   LOCAL s, nArgs, cArgs, aArgs, cArg, n, n1, i, nnn, cPro, cFunc

   IF nCurCol > nProtoCol
      n  := at( "(", cProto ) ; n1 := at( ")", cProto )
      IF n > 0 .AND. n1 > 0 .AND. "," $ cProto
         cProto := substr( cProto, 1, n1 )

         s := substr( cText, nProtoCol, nCurCol - nProtoCol )
         nArgs := 1
         FOR i := 1 TO Len( s )
            IF substr( s, i, 1 ) == ","
               nArgs++
            ENDIF
         NEXT

         nRows := 1; nCols := 0

         IF nArgs > 0
            n := at( "(", cProto ) ; n1 := at( ")", cProto )

            cFunc := substr( cProto, 1, n - 1 )
            cArgs := substr( cProto, n + 1, n1 - n - 1 )
            aArgs := hb_aTokens( cArgs, "," )
            cArgs := ""
            nCols := Len( cFunc ) + 1
            FOR EACH cArg IN aArgs
               cArg := alltrim( cArg )

               nRows++
               nCols := max( nCols, Len( cArg ) + 3 )

               cArg := StrTran( cArg, "<", "&lt;" )
               cArg := StrTran( cArg, ">", "&gt;" )

               nnn  := cArg:__enumIndex()
               IF nnn == nArgs
                  cArg := "<font color=red><b>" + cArg + "</b></font>"
               ENDIF
               IF nnn == Len( aArgs )
                  cArgs += "<br>" + "   " + cArg
               ELSE
                  cArgs += "<br>" + "   " + cArg + "<font color=red><b>" + "," + "</b></font>"
               ENDIF
            NEXT
            nCols += iif( nCols <= Len( cFunc ), 0, 1 )

            cPro  := "<p style='white-space:pre'>" + "<b>" + cFunc + "</b>" + ;
                        "<font color=red><b>" + "(" + "</b></font>" + ;
                           cArgs + ;
                              "<font color=red><b>" + ")" + "</font>" + "</b></p>"
         ENDIF
      ENDIF
   ENDIF
   RETURN cPro


STATIC FUNCTION __formatProto( cProto )
   LOCAL n, n1, cArgs

   cProto := StrTran( cProto, "<", "&lt;" )
   cProto := StrTran( cProto, ">", "&gt;" )

   n  := at( "(", cProto )
   n1 := at( ")", cProto )

   IF n > 0 .AND. n1 > 0
      cArgs  := substr( cProto, n + 1, n1 - n - 1 )
      cArgs  := strtran( cArgs, ",", "<font color=red><b>" + "," + "</b></font>" )
      cProto := "<p style='white-space:pre'>" + "<b>" + substr( cProto, 1, n - 1 ) + "</b>" + ;
                   "<font color=red><b>" + "(" + "</b></font>" + ;
                      cArgs + ;
                         "<font color=red><b>" + ")" + "</font>" + "</b></p>"
   ENDIF
   RETURN cProto


STATIC FUNCTION __normalizeRect( aCord, nT, nL, nB, nR )
   nT := iif( aCord[ 1 ] > aCord[ 3 ], aCord[ 3 ], aCord[ 1 ] )
   nB := iif( aCord[ 1 ] > aCord[ 3 ], aCord[ 1 ], aCord[ 3 ] )
   nL := iif( aCord[ 2 ] > aCord[ 4 ], aCord[ 4 ], aCord[ 2 ] )
   nR := iif( aCord[ 2 ] > aCord[ 4 ], aCord[ 2 ], aCord[ 4 ] )
   RETURN NIL

STATIC FUNCTION __isHarbourKeyword( cWord )
   RETURN cWord $ __harbourKeywords()


STATIC FUNCTION __getFrontSpacesAndWordsByCursor( oTxtCursor, /*@*/aWords )
   LOCAL cLine, cWord
   LOCAL nPos   := oTxtCursor:position()
   LOCAL nBlock := oTxtCursor:blockNumber()
   LOCAL nStart := 0

   aWords := {}
   IF Empty( cLine := oTxtCursor:block():text() )
      RETURN 0

   ELSE
      DO WHILE SubStr( cLine, ++nStart, 1 ) == " " ; QApplication():processEvents() ; ENDDO
      nStart--

      oTxtCursor:movePosition( QTextCursor_StartOfBlock )
      oTxtCursor:movePosition( QTextCursor_StartOfWord )
      DO WHILE .T.
         QApplication():processEvents()
         IF ! oTxtCursor:movePosition( QTextCursor_EndOfWord, QTextCursor_KeepAnchor )
            oTxtCursor:movePosition( QTextCursor_NextWord )
         ENDIF
         IF oTxtCursor:blockNumber() != nBlock
            EXIT
         ENDIF
         IF ! Empty( cWord := oTxtCursor:selectedText() )
            AAdd( aWords, cWord )
         ENDIF
         oTxtCursor:clearSelection()
      ENDDO

   ENDIF
   oTxtCursor:clearSelection()
   oTxtCursor:setPosition( nPos )
   RETURN nStart


STATIC FUNCTION __removeStartingSpaces( oTxtCursor, nCPrevPrev )
   LOCAL nPostn

   IF nCPrevPrev > 0
      nPostn := oTxtCursor:position()
      WITH OBJECT oTxtCursor
         :movePosition( QTextCursor_StartOfBlock )
         :movePosition( QTextCursor_NextWord, QTextCursor_KeepAnchor )
         :removeSelectedText()
         :setPosition( nPostn - nCPrevPrev )
      ENDWITH
   ENDIF
   RETURN NIL


STATIC FUNCTION __alignToPrevWord( oTxtCursor, cWord, cEWord, nLenCWord, nPostn )
   LOCAL cFWord, nCol, nInner := 0
   LOCAL lFound := .F.

   DO WHILE .T.
      IF oTxtCursor:movePosition( QTextCursor_Up, QTextCursor_MoveAnchor )
         nCol := __getFrontSpacesAndWord( oTxtCursor:block():text(), @cFWord )
         IF Lower( cFWord ) == cWord .AND. nInner == 0
            lFound := .T.
            EXIT
         ELSEIF Lower( cFWord ) == cWord .AND. nInner > 0
            nInner--
         ELSEIF Lower( cFWord ) == cEWord
            nInner++
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO
   oTxtCursor:setPosition( nPostn )
   IF lFound
      WITH OBJECT oTxtCursor
         :movePosition( QTextCursor_StartOfBlock, QTextCursor_MoveAnchor )
         :movePosition( QTextCursor_NextWord, QTextCursor_KeepAnchor )
         :removeSelectedText()
         :insertText( Space( nCol ) )
         :movePosition( QTextCursor_Right, QTextCursor_MoveAnchor, nLenCWord + 1 )
      ENDWITH
   ENDIF
   RETURN NIL


STATIC FUNCTION __replaceWord( oTxtCursor, nWord, cWord, nPostn )

   WITH OBJECT oTxtCursor
      :movePosition( QTextCursor_PreviousWord, QTextCursor_MoveAnchor, nWord )
      :select( QTextCursor_WordUnderCursor )
      :removeSelectedText()
      :insertText( cWord )
      :setPosition( nPostn )
   ENDWITH
   RETURN NIL


STATIC FUNCTION __isStartingKeyword( cWord, lReturnAsBeginKeyword )
   LOCAL s_b_

   IF Empty( s_b_ )
      s_b_:= {=>}
      hb_HCaseMatch( s_b_, .F. )

      s_b_[ 'function'  ] := NIL
      s_b_[ 'procedure' ] := NIL
      s_b_[ 'class'     ] := NIL
      s_b_[ 'method'    ] := NIL
      s_b_[ 'static'    ] := NIL

      IF ! lReturnAsBeginKeyword
         s_b_[ 'return'    ] := NIL
      ENDIF
   ENDIF
   RETURN cWord $ s_b_


STATIC FUNCTION __isMinimumIndentableKeyword( cWord, lReturnAsBeginKeyword )
   LOCAL s_b_

   IF Empty( s_b_ )
      s_b_:= {=>}
      hb_HCaseMatch( s_b_, .F. )

      IF ! lReturnAsBeginKeyword
         s_b_[ 'local'    ] := NIL
         s_b_[ 'private'  ] := NIL
         s_b_[ 'public'   ] := NIL
         s_b_[ 'endclass' ] := NIL
         s_b_[ 'default'  ] := NIL
         s_b_[ 'return'   ] := NIL
      ELSE
         s_b_[ 'local'    ] := NIL
         s_b_[ 'private'  ] := NIL
         s_b_[ 'public'   ] := NIL
         s_b_[ 'endclass' ] := NIL
         s_b_[ 'default'  ] := NIL
      ENDIF
   ENDIF
   RETURN cWord $ s_b_


STATIC FUNCTION __isIndentableKeyword( cWord )
   STATIC s_b_

   IF Empty( s_b_ )
      s_b_:= {=>}
      hb_HCaseMatch( s_b_, .F. )

      s_b_[ 'if'        ] := NIL
      s_b_[ 'else'      ] := NIL
      s_b_[ 'elseif'    ] := NIL
      s_b_[ 'docase'    ] := NIL
      s_b_[ 'case'      ] := NIL
      s_b_[ 'otherwise' ] := NIL
      s_b_[ 'do'        ] := NIL
      s_b_[ 'while'     ] := NIL
      s_b_[ 'switch'    ] := NIL
      s_b_[ 'for'       ] := NIL
      s_b_[ 'begin'     ] := NIL
      s_b_[ 'sequence'  ] := NIL
      s_b_[ 'try'       ] := NIL
      s_b_[ 'catch'     ] := NIL
      s_b_[ 'always'    ] := NIL
      s_b_[ 'recover'   ] := NIL
      s_b_[ 'finally'   ] := NIL
      s_b_[ 'with'      ] := NIL
   ENDIF
   RETURN cWord $ s_b_


STATIC FUNCTION __harbourKeywords()
   STATIC s_b_

   IF Empty( s_b_ )
      s_b_:= {=>}
      hb_HCaseMatch( s_b_, .F. )

      s_b_[ 'function'         ] := NIL
      s_b_[ 'procedure'        ] := NIL
      s_b_[ 'thread'           ] := NIL
      s_b_[ 'return'           ] := NIL
      s_b_[ 'request'          ] := NIL
      s_b_[ 'static'           ] := NIL
      s_b_[ 'local'            ] := NIL
      s_b_[ 'default'          ] := NIL
      s_b_[ 'if'               ] := NIL
      s_b_[ 'else'             ] := NIL
      s_b_[ 'elseif'           ] := NIL
      s_b_[ 'endif'            ] := NIL
      s_b_[ 'end'              ] := NIL
      s_b_[ 'docase'           ] := NIL
      s_b_[ 'case'             ] := NIL
      s_b_[ 'endcase'          ] := NIL
      s_b_[ 'otherwise'        ] := NIL
      s_b_[ 'switch'           ] := NIL
      s_b_[ 'endswitch'        ] := NIL
      s_b_[ 'do'               ] := NIL
      s_b_[ 'while'            ] := NIL
      s_b_[ 'enddo'            ] := NIL
      s_b_[ 'exit'             ] := NIL
      s_b_[ 'for'              ] := NIL
      s_b_[ 'each'             ] := NIL
      s_b_[ 'next'             ] := NIL
      s_b_[ 'step'             ] := NIL
      s_b_[ 'to'               ] := NIL
      s_b_[ 'class'            ] := NIL
      s_b_[ 'endclass'         ] := NIL
      s_b_[ 'method'           ] := NIL
      s_b_[ 'data'             ] := NIL
      s_b_[ 'var'              ] := NIL
      s_b_[ 'destructor'       ] := NIL
      s_b_[ 'inline'           ] := NIL
      s_b_[ 'setget'           ] := NIL
      s_b_[ 'assign'           ] := NIL
      s_b_[ 'access'           ] := NIL
      s_b_[ 'inherit'          ] := NIL
      s_b_[ 'init'             ] := NIL
      s_b_[ 'create'           ] := NIL
      s_b_[ 'virtual'          ] := NIL
      s_b_[ 'message'          ] := NIL
      s_b_[ 'begin'            ] := NIL
      s_b_[ 'sequence'         ] := NIL
      s_b_[ 'try'              ] := NIL
      s_b_[ 'catch'            ] := NIL
      s_b_[ 'always'           ] := NIL
      s_b_[ 'recover'          ] := NIL
      s_b_[ 'with'             ] := NIL
      s_b_[ 'replace'          ] := NIL
      s_b_[ 'hb_symbol_unused' ] := NIL
      s_b_[ 'error'            ] := NIL
      s_b_[ 'handler'          ] := NIL
      s_b_[ 'loop'             ] := NIL
      s_b_[ 'in'               ] := NIL
      s_b_[ 'object'           ] := NIL
      s_b_[ 'endwith'          ] := NIL
      s_b_[ 'nil'              ] := NIL
   ENDIF
   RETURN s_b_


#if 0
STATIC FUNCTION __isMatchingWord( cWord )
   STATIC hMatches

   IF Empty( hMatches )
      hMatches := {=>}
      hb_HCaseMatch( hMatches, .F. )
      hMatches[ "if"        ] := NIL
      hMatches[ "endif"     ] := NIL
      hMatches[ "for"       ] := NIL
      hMatches[ "next"      ] := NIL
      hMatches[ "switch"    ] := NIL
      hMatches[ "endswitch" ] := NIL
      hMatches[ "do"        ] := NIL
      hMatches[ "enddo"     ] := NIL
      hMatches[ "endcase"   ] := NIL
      hMatches[ "return"    ] := NIL
      hMatches[ "function"  ] := NIL
      hMatches[ "procedure" ] := NIL
      hMatches[ "method"    ] := NIL
      hMatches[ "class"     ] := NIL
      hMatches[ "endclass"  ] := NIL
      hMatches[ "with"      ] := NIL
      hMatches[ "endwith"   ] := NIL
   ENDIF
   RETURN cWord $ hMatches
#endif


STATIC FUNCTION __formatBrace( cText, cBraceO, cBraceC, nSpaces, lOuter )
   LOCAL i

   DEFAULT nSpaces TO 6
   DEFAULT lOuter  TO .F.

   IF .T.
      FOR i := nSpaces TO 1 STEP -1
         cText := StrTran( cText, cBraceO + Space( i ), cBraceO )
      NEXT
      IF lOuter
         FOR i := nSpaces TO 2 STEP -1
            cText := StrTran( cText, Space( i ) + cBraceO, cBraceO )
         NEXT
      ENDIF
      cText := StrTran( cText, cBraceO, cBraceO + Space( 1 ) )

      FOR i := nSpaces TO 1 STEP -1
         cText := StrTran( cText, Space( i ) + cBraceC, cBraceC )
      NEXT
      IF lOuter
         FOR i := nSpaces TO 2 STEP -1
            cText := StrTran( cText, cBraceC + Space( i ), cBraceC )
         NEXT
      ENDIF
      cText := StrTran( cText, cBraceC, Space( 1 ) + cBraceC )

      FOR i := nSpaces TO 1 STEP -1
         cText := StrTran( cText, cBraceO + Space( i ) + cBraceC, cBraceO + cBraceC )
      NEXT
   ENDIF
   RETURN cText


STATIC FUNCTION __formatOperators( cText, aOprtrs, nSpaces )
   LOCAL i, cOprtr

   DEFAULT nSpaces TO 1

   FOR EACH cOprtr IN aOprtrs
      FOR i := nSpaces TO 1 STEP -1
         cText := StrTran( cText, Space( i ) + cOprtr, cOprtr )
         cText := StrTran( cText, cOprtr + Space( i ), cOprtr )
      NEXT
      cText := StrTran( cText, cOprtr, Space( 1 ) + cOprtr + Space( 1 ) )
   NEXT
   RETURN cText


STATIC FUNCTION __formatCommas( cText, nSpaces )
   LOCAL i, cOprtr := ","

   DEFAULT nSpaces TO 1

   FOR i := nSpaces TO 1 STEP -1
      cText := StrTran( cText, cOprtr + Space( i ), cOprtr )
   NEXT
   RETURN StrTran( cText, cOprtr, cOprtr + Space( 1 ) )


STATIC FUNCTION __memoToArray( s )
   LOCAL aLine := hb_ATokens( StrTran( RTrim( s ), Chr( 13 ) + Chr( 10 ), hb_eol() ), hb_eol() )
   LOCAL nNewSize := 0
   LOCAL line

   FOR EACH line IN aLine DESCEND
      IF ! Empty( line )
         nNewSize := line:__enumIndex()
         EXIT
      ENDIF
   NEXT
   ASize( aLine, nNewSize )
   RETURN aLine


STATIC FUNCTION __arrayToMemo( a_ )
   LOCAL s := ""

   aeval( a_, {|e| s += e + hb_eol() } )
   RETURN s += hb_eol()


STATIC FUNCTION __IsInCommentOrString( cText, nPos )
   LOCAL  nCmt

   IF ( nCmt := At( "//", cText ) ) > 0
      IF nPos > nCmt
         RETURN .T.
      ENDIF
   ENDIF
   IF ( nCmt := At( "/*", cText ) ) > 0
      IF nPos > nCmt
         DO WHILE .T.
            nCmt := hb_At( "*/", cText, nCmt )
            IF nCmt > 0 .AND. nPos < nCmt
               RETURN .T.
            ELSEIF nCmt > 0 .AND. nPos > nCmt
               nCmt := hb_At( "/*", cText, nCmt )
               IF nCmt == 0 .OR. nPos < nCmt
                  RETURN .F.
               ENDIF
            ELSE
               RETURN .F.
            ENDIF
         ENDDO
      ENDIF
   ENDIF
   RETURN __IsInString( cText, nPos, 1 )


STATIC FUNCTION __IsInString( cText, nPos, nStart, cQuote )
   LOCAL j, cTkn
   LOCAL lInString := .F.

   STATIC cAnyQuote  := '"' + "'"

   FOR j := nStart TO nPos-1          // check if string did not begin before it
       cTkn := substr( cText, j, 1 )
       IF cTkn $ cAnyQuote            // any quote characters present ?
          IF lInstring                // if we are already in string
             IF cTkn == cQuote        // is it a matching quote ?
                lInstring := .F.      // yes, we are no in string any more
             ENDIF
          ELSE                        // we are not in string yet
             cQuote    := cTkn        // this is the streing quote
             lInstring := .T.         // now we are in string
         ENDIF
      ENDIF
   NEXT
   RETURN lInString

