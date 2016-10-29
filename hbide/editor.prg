/*
 * $Id$
 */

/*
 * Copyright 2010-2015 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               27Dec2009
 */
/*----------------------------------------------------------------------*/

#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"
#include "hbide.ch"
#include "xbp.ch"
#include "fileio.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"


#define EDT_LINNO_WIDTH                           50

#define __qcompleter_activated__                  2001
#define __qFldsCompleter_activated__              2002
#define __qTimeSave_timeout__                     2005
#define __qTab_contextMenu__                      2006


#define __selectionMode_stream__                  1
#define __selectionMode_column__                  2
#define __selectionMode_line__                    3


// this is application level, initiate any HbQtEditor specific calls in the constructor.
//
CLASS IdeEditsManager INHERIT IdeObject

   DATA   qContextMenu
   DATA   qThemesSub
   DATA   qContextSub
   DATA   qSrcControlSub
   DATA   aActions                                INIT  {}
   DATA   aProtos                                 INIT  {}
   DATA   qFldsStrList
   DATA   qFldsModel

   DATA   hEditingWords                           INIT {=>}
   DATA   hK                                      INIT {=>}
   DATA   k_

   METHOD init( oIde )
   METHOD create( oIde )
   METHOD destroy()
   METHOD removeSourceInTree( cSourceFile )
   METHOD addSourceInTree( cSourceFile, cView )
   METHOD execEvent( nEvent, p )
   METHOD buildEditor( cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )
   METHOD getTabBySource( cSource )
   METHOD getTabCurrent()
   METHOD getTabByIndex( nIndex )
   METHOD getDocumentCurrent()
   METHOD getEditObjectCurrent()
   METHOD getEditObjectByIndex( nIndex )
   METHOD getEditCurrent()
   METHOD getEditorCurrent()
   METHOD getEditorByIndex( nIndex )
   METHOD getEditorByTabObject( oTab )
   METHOD getEditorByTabPosition( nPos )
   METHOD getEditorBySource( cSource )
   METHOD reLoad( cSource )
   METHOD isOpen( cSource )
   METHOD setSourceVisible( cSource )
   METHOD setSourceVisibleByIndex( nIndex )
   METHOD undo()
   METHOD redo()
   METHOD cut()
   METHOD copy()
   METHOD paste()
   METHOD selectAll()
   METHOD findEx( cText, nFlags, nStart )
   METHOD highlightAll( cText )
   METHOD switchToReadOnly()
   METHOD convertSelection( cKey )
   METHOD insertText( cKey )
   METHOD insertSeparator( cSep )
   METHOD zoom( nKey )
   METHOD printPreview()
   METHOD printPreviewByIndex( nIndex )
   METHOD paintRequested( qPrinter )
   METHOD setMark()
   METHOD setTooltipMark( nIndex )
   METHOD gotoMark( nIndex )
   METHOD goto( nLine )
   METHOD formatBraces( nMode )
   METHOD upperCaseKeywords()
   METHOD removeTabs()
   METHOD RemoveTrailingSpaces()
   METHOD getSelectedText()
   METHOD duplicateLine()
   METHOD deleteLine()
   METHOD moveLine( nDirection )
   METHOD streamComment()
   METHOD blockComment()
   METHOD indent( nStep )
   METHOD convertQuotes()
   METHOD convertDQuotes()

   METHOD toggleLineNumbers( lOn )
   METHOD toggleHorzRuler( lOn )
   METHOD toggleCurrentLineHighlightMode( lOn )

   METHOD toggleSelectionMode()
   METHOD toggleStreamSelectionMode()
   METHOD toggleColumnSelectionMode()
   METHOD toggleLineSelectionMode()

   METHOD toggleCodeCompetion()
   METHOD toggleCompetionTips()

   METHOD getText()
   METHOD getWord( lSelect )
   METHOD getLine( nLine, lSelect )
   METHOD presentSkeletons()
   METHOD gotoFunction()
   METHOD clearSelection()

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

   METHOD find( cString, nPosFrom )
   METHOD showThumbnail()
   METHOD changeThumbnail()
   METHOD spaces2tabs()
   METHOD setStyleSheet( nMode )
   METHOD updateCompleter()
   METHOD updateCompleterByEditingWords( cWord )
   METHOD updateFieldsList( cAlias )
   METHOD getProto( cWord )
   METHOD alignAt()
   METHOD stringify()
   METHOD applyTheme( cTheme )
   METHOD setEncoding( cCodec )

   METHOD nextEditor()
   METHOD previousEditor()
   METHOD execToolsBox()

   ENDCLASS


METHOD IdeEditsManager:init( oIde )


   ::oIde := oIde

   hb_hCaseMatch( ::hEditingWords, .F. )
   hb_HKeepOrder( ::hEditingWords, .F. )

   hb_HCaseMatch( ::hK, .F. )
   hb_HKeepOrder( ::hK, .F. )

   //__hbqtStackHarbourFuncList()
   __hbqtStackQtFuncList()
   __hbqtStackUserFuncList( __pullDictFunctions( ::oIde:aUserDict ) )

   RETURN Self


METHOD IdeEditsManager:create( oIde )
   LOCAL qAct, aTheme, aAct := {}

   DEFAULT oIde TO ::oIde

   ::oIde := oIde

   WITH OBJECT ::qContextMenu := QMenu()
      aadd( ::aActions, { "GotoFunc"     , :addAction( ::oAC:getAction( "GotoFunc"      ) ) } )
      aadd( ::aActions, { ""             , :addSeparator() } )
      aadd( ::aActions, { "TB_Cut"       , :addAction( ::oAC:getAction( "TB_Cut"        ) ) } )
      aadd( ::aActions, { "TB_Copy"      , :addAction( ::oAC:getAction( "TB_Copy"       ) ) } )
      aadd( ::aActions, { "TB_Paste"     , :addAction( ::oAC:getAction( "TB_Paste"      ) ) } )
      aadd( ::aActions, { ""             , :addSeparator() } )
      aadd( ::aActions, { "TB_Undo"      , :addAction( ::oAC:getAction( "TB_Undo"       ) ) } )
      aadd( ::aActions, { "TB_Redo"      , :addAction( ::oAC:getAction( "TB_Redo"       ) ) } )
      aadd( ::aActions, { ""             , :addSeparator() } )
      aadd( ::aActions, { "TB_Save"      , :addAction( ::oAC:getAction( "TB_Save"       ) ) } )
      aadd( ::aActions, { "TB_Close"     , :addAction( ::oAC:getAction( "TB_Close"      ) ) } )
      aadd( ::aActions, { ""             , :addSeparator() } )
      aadd( ::aActions, { "TB_Compile"   , :addAction( ::oAC:getAction( "TB_Compile"    ) ) } )
      aadd( ::aActions, { "TB_CompilePPO", :addAction( ::oAC:getAction( "TB_CompilePPO" ) ) } )
      aadd( ::aActions, { ""             , :addSeparator() } )
   ENDWITH

   ::qThemesSub := ::qContextMenu:addMenu( QIcon( hbide_image( "syntaxhiliter" ) ), "Change Theme" )
   aadd( ::aActions, ::qThemesSub )
   FOR EACH aTheme IN ::oTH:getThemesList()
      aadd( aAct, ::qThemesSub:addAction( hb_ntos( aTheme:__enumIndex() ) + ". " + aTheme[ 1 ] ) )
   NEXT
   //aadd( ::aActions, { "Apply Theme"  , ::qContextMenu:addAction( QIcon( hbide_image( "syntaxhiliter" ) ), "Change Theme" ) } )

   aadd( ::aActions, { "Save as Skltn", ::qContextMenu:addAction( "Save as Skeleton..."              ) } )
   ::qContextSub := ::qContextMenu:addMenu( QIcon( hbide_image( "split" ) ), "Split" )
   //
   ::qContextSub:addAction( qAct := ::oAC:getAction( "SplitH" ) )
   aadd( ::aActions, { "Split H"      , qAct } )
   ::qContextSub:addAction( qAct := ::oAC:getAction( "SplitV" ) )
   aadd( ::aActions, { "Split V"      , qAct } )
   aadd( ::aActions, { ""             , ::qContextSub:addSeparator() } )
   ::qContextSub:addAction( qAct := ::oAC:getAction( "SplitClose" ) )
   aadd( ::aActions, { "Close Split"  , qAct } )
   aadd( ::aActions, { ""             , ::qContextSub:addSeparator() } )
   ::qContextMenu:addAction( qAct := ::oFormatDock:oWidget:toggleViewAction() )
   aadd( ::aActions, { "Format"       , qAct } )
   //
   ::qSrcControlSub := ::qContextMenu:addMenu( "Source Control - VSS" )
   aadd( ::aActions, { "Get"          , ::qSrcControlSub:addAction( "Get Latest Version" ) } )
   aadd( ::aActions, { ""             , ::qSrcControlSub:addSeparator() } )
   aadd( ::aActions, { "Checkout"     , ::qSrcControlSub:addAction( "Checkout"           ) } )
   aadd( ::aActions, { "UndoCheckout" , ::qSrcControlSub:addAction( "Undo Checkout"      ) } )
   aadd( ::aActions, { ""             , ::qSrcControlSub:addSeparator() } )
   aadd( ::aActions, { "Checkin"      , ::qSrcControlSub:addAction( "Checkin"            ) } )
   aadd( ::aActions, { ""             , ::qSrcControlSub:addSeparator() } )
   aadd( ::aActions, { "Diff"         , ::qSrcControlSub:addAction( "Diff"               ) } )
   //
   aadd( ::aActions, { "Show Selected Text", ::qContextMenu:addAction( "Show Selected Text" ) } )

   AAdd( ::aActions, aAct )

   /* Define code completer */
   ::oIde:qProtoList := QStringList()
   ::oIde:qCompModel := QStringListModel()
   ::qCompModel      :  setStringList( ::qProtoList )
   ::oIde:qCompleter := QCompleter()
   WITH OBJECT ::qCompleter
      :setWrapAround( .t. )
      :setCaseSensitivity( Qt_CaseInsensitive )
      :setModelSorting( QCompleter_CaseInsensitivelySortedModel )
      :setModel( ::qCompModel )
      :setCompletionMode( QCompleter_PopupCompletion )
      :popup():setAlternatingRowColors( .t. )
      :popup():setFont( QFont( "Courier New", 8 ) )
      :popup():setMaximumWidth( 400 )
      :connect( "activated(QString)", {|p| ::execEvent( __qcompleter_activated__, p ) } )
   ENDWITH

   /* Define fields completer */
   ::qFldsStrList   := QStringList()
   ::qFldsModel     := QStringListModel()
   RETURN Self


METHOD IdeEditsManager:destroy()
   LOCAL a_

   ::qCompleter:disconnect( "activated(QString)" )

   ::oIde:qCompModel := NIL
   ::oIde:qProtoList := NIL

   FOR EACH a_ IN ::aActions
      a_[ 2 ] := NIL
      a_:= NIL
   NEXT

   ::aActions     := NIL
   ::aProtos      := NIL

   ::qContextMenu := NIL
   ::qFldsStrList := NIL
   ::qFldsModel   := NIL

   FOR EACH a_ IN ::oIde:aTabs
      a_[ 2 ]:destroy()
      a_:= NIL
   NEXT
   RETURN Self


METHOD IdeEditsManager:updateCompleterByEditingWords( cWord )
   LOCAL s

   ::hK[ cWord ] := NIL

   ::qProtoList:clear()
   FOR EACH s IN ::hK
      ::qProtoList:append( s:__enumKey() )
   NEXT
   ::qCompModel:setStringList( ::qProtoList )
   RETURN Self


METHOD IdeEditsManager:updateCompleter()
   LOCAL aP := {}, s, n, aProto
   LOCAL lCompletionWithArgs := ::oINI:lCompletionWithArgs

   AAdd( aP, ::oFN:getFunctionPrototypes() )
   AAdd( aP, ::oHL:getFunctionPrototypes() )
   AAdd( aP, hbide_getUserPrototypes()     )

   FOR EACH aProto IN aP
      FOR EACH s IN aProto
         IF ! lCompletionWithArgs
            IF ( n := at( "(", s ) ) == 0
               IF ( n := at( " ", s ) ) > 0
                  s := substr( s, 1, n - 1 )
               ENDIF
            ELSE
               s := substr( s, 1, n - 1 )
            ENDIF
         ENDIF
         ::hK[ alltrim( s ) ] := NIL
      NEXT
   NEXT

   ::qProtoList:clear()
   FOR EACH s IN ::hK
      ::qProtoList:append( s:__enumKey() )
   NEXT
   ::qCompModel:setStringList( ::qProtoList )
   RETURN Self


METHOD IdeEditsManager:setStyleSheet( nMode )
   ::qContextMenu:setStyleSheet( GetStyleSheet( "QMenuPop", nMode ) )
   ::qContextSub:setStyleSheet( GetStyleSheet( "QMenuPop", nMode ) )
   RETURN Self


METHOD IdeEditsManager:updateFieldsList( cAlias )
   LOCAL aFlds

   IF ! empty( cAlias )
      IF ! empty( aFlds := ::oBM:oDbu:fetchFldsList( cAlias ) )
         asort( aFlds, , , {|e,f| lower( e ) < lower( f ) } )

         ::qFldsStrList:clear()
         aeval( aFlds, {|e| ::qFldsStrList:append( e ) } )
         ::qFldsModel:setStringList( ::qFldsStrList )

         ::qCompleter:setModel( ::qFldsModel )

         RETURN .t.
      ENDIF
   ENDIF
   ::qCompleter:setModel( ::qCompModel )
   RETURN .f.


METHOD IdeEditsManager:getProto( cWord )
   LOCAL n, nLen

   cWord := upper( cWord )
   nLen := Len( cWord )

   FOR EACH n IN ::hK
      IF Upper( Left( n:__enumKey(), nLen ) ) == cWord
         RETURN n:__enumKey()
      ENDIF
   NEXT
   RETURN ""


METHOD IdeEditsManager:removeSourceInTree( cSourceFile )
   LOCAL n

   IF ! Empty( cSourceFile )
      IF ( n := aScan( ::aProjData, {|e_| e_[ TRE_ORIGINAL ] == cSourceFile .AND. e_[ 2 ] == "Opened Source" } ) ) > 0
         ::aProjData[ n,3 ]:delItem( ::oIde:aProjData[ n,1 ] )
         hb_adel( ::aProjData, n, .T. )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditsManager:addSourceInTree( cSourceFile, cView )
   LOCAL cPath, cFile, cExt, oItem
   LOCAL oParent := ::oOpenedSources

   IF Empty( cSourceFile )
      RETURN Self
   ENDIF

   hb_fNameSplit( cSourceFile, @cPath, @cFile, @cExt )

   oItem := oParent:addItem( cFile + cExt )
   oItem:tooltipText := cSourceFile
   oItem:oWidget:setIcon( 0, QIcon( ::oDK:getPanelIcon( cView ) ) )
   aadd( ::aProjData, { oItem, "Opened Source", oParent, ;
                                   cSourceFile, hbide_pathNormalized( cSourceFile ) } )

   ::oEditTree:oWidget:sortItems( 0, Qt_AscendingOrder )
   RETURN Self


METHOD IdeEditsManager:execEvent( nEvent, p )
   LOCAL oEdit

   IF ::lQuitting
      RETURN Self
   ENDIF

   SWITCH nEvent
   CASE __qFldsCompleter_activated__
      IF !empty( oEdit := ::getEditObjectCurrent() )
         oEdit:completeFieldName( p )
      ENDIF
      EXIT
   CASE __qcompleter_activated__
      IF !empty( oEdit := ::getEditObjectCurrent() )
         oEdit:completeCode( p )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Nil


METHOD IdeEditsManager:buildEditor( cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )

   IdeEditor():new( ::oIde ):create( ::oIde, cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )

   RETURN Self


METHOD IdeEditsManager:getTabBySource( cSource )
   cSource := hbide_pathNormalized( cSource, .t. )
   RETURN ascan( ::aTabs, {|e_| hb_FileMatch( e_[ TAB_OEDITOR ]:pathNormalized, cSource ) } )


METHOD IdeEditsManager:getTabCurrent()
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget )
      qTab := ::qTabWidget:currentWidget()
      nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } )
   ENDIF
   RETURN nTab


METHOD IdeEditsManager:getTabByIndex( nIndex )
   LOCAL qTab, nTab

   IF HB_ISNUMERIC( nIndex ) .AND. nIndex >= 0 .AND. nIndex < ::qTabWidget:count()
      qTab := ::qTabWidget:widget( nIndex )
      nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } )
   ENDIF
   RETURN nTab


METHOD IdeEditsManager:getDocumentCurrent()
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget ) .AND. ::qTabWidget:count() > 0
      qTab := ::qTabWidget:currentWidget()
      IF ( nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } ) ) > 0
         RETURN ::aTabs[ nTab, TAB_OEDITOR ]:document()
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditObjectCurrent()
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget ) .AND. ::qTabWidget:count() > 0
      qTab := ::qTabWidget:currentWidget()
      IF ( nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } ) ) > 0
         RETURN ::aTabs[ nTab, TAB_OEDITOR ]:qCoEdit
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditObjectByIndex( nIndex )
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget ) .AND. ::qTabWidget:count() > 0 .AND. nIndex < ::qTabWidget:count()
      qTab := ::qTabWidget:widget( nIndex )
      IF ( nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } ) ) > 0
         RETURN ::aTabs[ nTab, TAB_OEDITOR ]:qCoEdit
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditCurrent()
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget ) .AND. ::qTabWidget:count() > 0
      qTab := ::qTabWidget:currentWidget()
      IF ( nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } ) ) > 0
         RETURN ::aTabs[ nTab, TAB_OEDITOR ]:qCqEdit
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditorCurrent()
   LOCAL qTab, nTab

   IF !empty( ::qTabWidget ) .AND. ::qTabWidget:count() > 0
      qTab := ::qTabWidget:currentWidget()
      IF ( nTab := ascan( ::aTabs, {|e_| hbqt_IsEqual( e_[ TAB_OTAB ]:oWidget, qTab ) } ) ) > 0
         RETURN ::aTabs[ nTab, TAB_OEDITOR ]
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditorByIndex( nIndex ) /* Index is 0 based */
   LOCAL qTab, a_

   IF HB_ISNUMERIC( nIndex ) .AND. nIndex >= 0 .AND. nIndex < ::qTabWidget:count()
      qTab := ::qTabWidget:widget( nIndex )
      FOR EACH a_ IN ::aTabs
         IF !empty( a_[ TAB_OTAB ] ) .AND. hbqt_IsEqual( a_[ TAB_OTAB ]:oWidget, qTab )
            RETURN ::aTabs[ a_:__enumIndex(), TAB_OEDITOR ]
         ENDIF
      NEXT
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditorByTabObject( oTab )
   LOCAL nPos

   IF HB_ISOBJECT( oTab )
      IF ( nPos := ascan( ::aTabs, {|e_| e_[ TAB_OTAB ] == oTab } ) ) > 0
         RETURN ::aTabs[ nPos, TAB_OEDITOR ]
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditorByTabPosition( nPos )

   IF HB_ISNUMERIC( nPos ) .AND. nPos > 0 .AND. nPos <= Len( ::aTabs )
      IF !empty( ::aTabs[ nPos, TAB_OEDITOR ] )
         RETURN ::aTabs[ nPos, TAB_OEDITOR ]
      ENDIF
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:getEditorBySource( cSource )
   LOCAL n

   cSource := hbide_pathNormalized( cSource, .t. )
   IF ( n := ascan( ::aTabs, {|e_| hb_FileMatch( e_[ TAB_OEDITOR ]:pathNormalized, cSource ) } ) ) > 0
      RETURN ::aTabs[ n, TAB_OEDITOR ]
   ENDIF
   RETURN Nil


METHOD IdeEditsManager:nextEditor()
   LOCAL nCurIndex := ::qTabWidget:currentIndex()

   IF ::qTabWidget:count() > 1
      IF nCurIndex == ::qTabWidget:count() - 1
         nCurIndex := 0
      ELSE
         nCurIndex++
      ENDIF
   ENDIF
   ::qTabWidget:setCurrentIndex( nCurIndex )

   RETURN Self


METHOD IdeEditsManager:previousEditor()

   LOCAL nCurIndex := ::qTabWidget:currentIndex()

   IF ::qTabWidget:count() > 1
      IF nCurIndex == 0
         nCurIndex := ::qTabWidget:count() - 1
      ELSE
         nCurIndex--
      ENDIF
   ENDIF
   ::qTabWidget:setCurrentIndex( nCurIndex )
   RETURN Self


METHOD IdeEditsManager:reLoad( cSource )
   LOCAL oEditor

   IF empty( cSource )
      IF ! Empty( oEditor := ::getEditorCurrent() )
         oEditor:reload()
      ENDIF
   ELSE
      IF hb_fileExists( cSource ) .AND. hbide_isValidText( cSource )
         IF !empty( oEditor := ::getEditorBySource( cSource ) )
            oEditor:reload()
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditsManager:execToolsBox()
   LOCAL oEditor
   IF ! empty( oEditor := ::getEditorCurrent() )
      oEditor:execToolsBox()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:setEncoding( cCodec )
   LOCAL oEdit
   IF ! empty( oEdit := ::getEditorCurrent() )
      oEdit:setEncoding( cCodec )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:isOpen( cSource )
   RETURN ! Empty( ::getEditorBySource( cSource ) )


METHOD IdeEditsManager:setSourceVisible( cSource )
   LOCAL oEdit, nIndex

   IF ! Empty( oEdit := ::getEditorBySource( cSource ) )
      ::oDK:setView( oEdit:cView )

      nIndex := ::qTabWidget:indexOf( oEdit:oTab:oWidget )
      IF ::qTabWidget:currentIndex() != nIndex
         ::qTabWidget:setCurrentIndex( nIndex )
      ELSE
         oEdit:setDocumentProperties()
      ENDIF
      RETURN .t.
   ENDIF
   RETURN .f.


METHOD IdeEditsManager:setSourceVisibleByIndex( nIndex ) /* nIndex is 0 based */

   IF ::qTabWidget:count() == 0
      RETURN .f.
   ENDIF

   IF nIndex >= ::qTabWidget:count()
      nIndex := 0
   ENDIF

   ::qTabWidget:setCurrentIndex( nIndex )
   ::getEditorByIndex( nIndex ):setDocumentProperties()
   RETURN .f.


METHOD IdeEditsManager:undo()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:undo()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:redo()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:redo()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:cut()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:cut()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:copy()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:copy()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:paste()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:paste()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:selectAll()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:selectAll()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:findEx( cText, nFlags, nStart )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:findEx( cText, nFlags, nStart )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:highlightAll( cText )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:highlightAll( cText )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleSelectionMode()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleSelectionMode()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleStreamSelectionMode()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleStreamSelectionMode()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleColumnSelectionMode()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleColumnSelectionMode()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleLineSelectionMode()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleLineSelectionMode()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleLineNumbers( lOn )
   LOCAL oEditor
   IF ! Empty( oEditor := ::getEditorCurrent() )
      IF ! HB_ISLOGICAL( lOn )
         ::oIde:lLineNumbersVisible := lOn := ! ::oIde:lLineNumbersVisible
      ENDIF
      oEditor:setLineNumbers( lOn )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleHorzRuler( lOn )
   LOCAL oEditor
   IF ! Empty( oEditor := ::getEditorCurrent() )
      IF ! HB_ISLOGICAL( lOn )
         ::oIde:lHorzRulerVisible := lOn := ! ::oIde:lHorzRulerVisible
      ENDIF
      oEditor:setHorzRuler( lOn )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleCurrentLineHighlightMode( lOn )
   LOCAL oEditor
   IF ! Empty( oEditor := ::getEditorCurrent() )
      IF ! HB_ISLOGICAL( lOn )
         ::oIde:lCurrentLineHighlightEnabled := lOn := ! ::lCurrentLineHighlightEnabled
      ENDIF
      oEditor:setCurrentLineHighlightMode( lOn )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleCodeCompetion()
   LOCAL oEdit
   ::oIde:lHorzRulerVisible := ! ::lHorzRulerVisible
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleCodeCompetion()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:toggleCompetionTips()
   LOCAL oEdit
   ::oIde:lHorzRulerVisible := ! ::lHorzRulerVisible
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:toggleCompetionTips()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:duplicateLine()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:duplicateLine()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:moveLine( nDirection )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:moveLine( nDirection )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:deleteLine()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:deleteLine()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:streamComment()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:streamComment()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:blockComment()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:blockComment()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:indent( nStep )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:blockIndent( nStep )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:convertQuotes()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:convertQuotes()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:convertDQuotes()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:convertDQuotes()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:alignAt()
   LOCAL oEdit, cWord
   IF !empty( oEdit := ::getEditObjectCurrent() )
      IF oEdit:aSelectionInfo[ 5 ] == __selectionMode_column__
         IF Len( cWord := hbide_fetchAString( ::oDlg:oWidget, "", "Align At ?", "Selected-Text Alignment Proto" ) ) > 0
            oEdit:alignAt( cWord )
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditsManager:stringify()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:stringify()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:applyTheme( cTheme )
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:applyTheme( cTheme )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:switchToReadOnly()
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:setReadOnly()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:presentSkeletons()
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:presentSkeletons()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:clearSelection()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:clearSelection()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:gotoFunction()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:gotoFunction()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:getText()
   LOCAL oEdit, cText := ""
   IF !empty( oEdit := ::getEditObjectCurrent() )
      cText := oEdit:getText()
   ENDIF
   RETURN cText


METHOD IdeEditsManager:getWord( lSelect )
   LOCAL oEdit, cText := ""
   IF !empty( oEdit := ::getEditObjectCurrent() )
      cText := oEdit:getWord( lSelect )
   ENDIF
   RETURN cText


METHOD IdeEditsManager:getLine( nLine, lSelect )
   LOCAL oEdit, cText := ""
   IF !empty( oEdit := ::getEditObjectCurrent() )
      cText := oEdit:getLine( nLine, lSelect )
   ENDIF
   RETURN cText


METHOD IdeEditsManager:convertSelection( cKey )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      SWITCH cKey
      CASE "ToUpper"
         oEdit:caseUpper()
         EXIT
      CASE "ToLower"
         oEdit:caseLower()
         EXIT
      CASE "Invert"
         oEdit:caseInvert()
         EXIT
      ENDSWITCH
   ENDIF
   RETURN Self


METHOD IdeEditsManager:insertSeparator( cSep )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:insertSeparator( cSep )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:insertText( cKey )
   LOCAL cFile, cText, oEdit

   IF ! empty( oEdit := ::getEditObjectCurrent() )
      DO CASE

      CASE cKey == "InsertDateTime"
         cText := DTOC( Date() ) + ' - ' + Time()

      CASE cKey == "InsertRandomName"
         cText := hbide_getUniqueFuncName()

      CASE cKey == "InsertExternalFile"
         cFile := ::oSM:selectSource( "open" )
         IF Empty( cFile ) .OR. !hb_FileExists( cFile )
            RETURN Self
         ENDIF
         IF !( hbide_isValidText( cFile ) )
            MsgBox( "File type unknown or unsupported: " + cFile )
            RETURN Self
         ENDIF
         cText := hb_memoread( cFile )

      OTHERWISE
         RETURN Self

      ENDCASE

      oEdit:insertText( cText )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:upperCaseKeywords()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:upperCaseKeywords()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:formatBraces( nMode )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:formatBraces( nMode )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:removeTabs()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:tabs2spaces()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:spaces2tabs()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:spaces2tabs()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:removeTrailingSpaces()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:removeTrailingSpaces()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:zoom( nKey )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:zoom( nKey )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:printPreview()
   LOCAL oEdit, cCode
   IF !empty( oEdit := ::getEditObjectCurrent() )
      IF ! Empty( cCode := oEdit:getSelectedText() )
         ::oIde:showFragment( cCode, "Selected Text", QIcon( hbide_image( "selectionline" ) ), oEdit:theme(), .T. )
      ELSE
         oEdit:printPreview()
      ENDIF
   ENDIF
   RETURN self


METHOD IdeEditsManager:printPreviewByIndex( nIndex )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectByIndex( nIndex ) )
      oEdit:printPreview()
   ENDIF
   RETURN self


METHOD IdeEditsManager:paintRequested( qPrinter )
   ::qCurEdit:print( qPrinter )
   RETURN Self


METHOD IdeEditsManager:getSelectedText()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      RETURN oEdit:getSelectedText()
   ENDIF
   RETURN ""


METHOD IdeEditsManager:setMark()
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:setBookMark()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:setTooltipMark( nIndex )
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:setTooltipMark( nIndex )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:gotoMark( nIndex )
   LOCAL oEditor
   IF !empty( oEditor := ::getEditorCurrent() )
      oEditor:gotoMark( nIndex )
   ENDIF
   RETURN Self


METHOD IdeEditsManager:goto( nLine )
   LOCAL oEdit
   IF ! empty( oEdit := ::oEM:getEditObjectCurrent() )
      oEdit:goto( nLine )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
//                            Navigation
/*----------------------------------------------------------------------*/
METHOD IdeEditsManager:home()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:home()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:end()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:end()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:down()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:down()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:up()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:up()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:goBottom()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:goBottom()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:goTop()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:goTop()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:left()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:left()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:right()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:right()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:panEnd()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:panEnd()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:panHome()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:panHome()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:pageUp()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:pageUp()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:pageDown()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      oEdit:pageDown()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:showThumbnail()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditorCurrent() )
      oEdit:showThumbnail()
   ENDIF
   RETURN Self


METHOD IdeEditsManager:changeThumbnail()
   LOCAL oEdit
   IF !empty( oEdit := ::getEditorCurrent() )
      oEdit:changeThumbnail()
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
//                            Locating
/*----------------------------------------------------------------------*/

METHOD IdeEditsManager:find( cString, nPosFrom )
   LOCAL oEdit
   IF !empty( oEdit := ::getEditObjectCurrent() )
      IF empty( cString )
         ::oFR:show()
      ELSE
         oEdit:find( cString, nPosFrom )
      ENDIF
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
//
//                            CLASS IdeEditor
//                     Holds One Document in One Tab
//
/*----------------------------------------------------------------------*/

#define qTimeSave_timeout                         101

CLASS IdeEditor INHERIT IdeObject

   DATA   oTab
   DATA   cPath
   DATA   cFile                                   INIT   ""
   DATA   cExt                                    INIT   ""
   DATA   cType                                   INIT   ""
   DATA   cTheme                                  INIT   ""
   DATA   cView
   DATA   aBookMarks                              INIT   {}
   DATA   cCodePage
   DATA   cExtras                                 INIT   ""
   DATA   qDocLayout
   DATA   qHiliter
   DATA   qTimerSave
   DATA   pathNormalized
   DATA   qLayout
   DATA   lLoaded                                 INIT   .F.
   DATA   lInitLoad                               INIT   .t.

   DATA   qThumbnail
   DATA   qTNFont
   DATA   qTNHiliter
   DATA   qHSpltr
   DATA   qVSpltr

   DATA   aEdits                                  INIT   {}   /* Hold IdeEdit Objects */
   DATA   oEdit
   DATA   qEdit
   DATA   qCqEdit
   DATA   qCoEdit

   DATA   nBlock                                  INIT   -1
   DATA   nColumn                                 INIT   -1

   DATA   nPos                                    INIT   0
   DATA   nHPos                                   INIT   0
   DATA   nVPos                                   INIT   0
   DATA   nID

   DATA   aSplits                                 INIT   {}

   DATA   qHLayout
   DATA   qLabel
   DATA   nnRow                                   INIT -99

   DATA   qEvents
   DATA   lReadOnly                               INIT  .F.

   DATA   cEol                                    INIT  ""
   DATA   nSplOrient                              INIT  -1
   DATA   qVSplitter
   DATA   qHSplitter

   DATA   lIsPRG                                  INIT .t.
   DATA   oTabBar
   DATA   oTabContextMenu
   DATA   aActions                                INIT {}

   DATA   qDocument
   ACCESS document()                              INLINE ::oEdit:document()

   METHOD execTabContextMenu( oPos )

   METHOD init( oIde, cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )
   METHOD create( oIde, cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )

   METHOD split( nOrient )
   METHOD relay( oHbQtEditor, nOrient )
   METHOD destroy()
   METHOD execEvent( nEvent, p, p1, p2 )
   METHOD setDocumentProperties()
   METHOD activateTab( mp1, mp2, oXbp )
   METHOD buildTabPage( cSource )
   METHOD dispEditInfo( oEdit )
   METHOD setTabImage( qEdit )
   METHOD applyTheme( cTheme )
   METHOD showThumbnail()
   METHOD changeThumbnail()
   METHOD scrollThumbnail()
   METHOD prepareBufferToLoad( cBuffer )
   METHOD prepareBufferToSave( cBuffer )
   METHOD reload()
   METHOD vssExecute( cAction )
   METHOD updateComponents()
   METHOD setEncoding( cCodec )
   METHOD setBreakPoint( cPrg, nLine )
   METHOD extras()
   METHOD manageExtras()
   ACCESS source()                                INLINE ::sourceFile
   METHOD setSource( cSource )                    INLINE iif( HB_ISSTRING( cSource ) .AND. ! Empty( cSource ), ::sourceFile := cSource, NIL )
   METHOD execEditContextMenu( oPos, oInEdit )
   METHOD selectionChanged( oEdit, nSelectedChars )
   METHOD connectBlocks( oHbQtEditor )
   METHOD dispStatusInfo()
   METHOD setReadOnly( lReadOnly )

   METHOD handleKeyPressed( nQtKey, aModifiers, oEdit )
   METHOD execToolsBox( p )
   METHOD supplyFormattingInfo()
   METHOD handleEditorEvents( nEvent, xData, oEdit )

   METHOD currentFunctionIndex( nCurLine )
   METHOD updateWordsInCompleter( cWord )
   METHOD updateFieldsList( cAlias )
   METHOD markCurrentFunction( nCurLine )
   METHOD toNextFunction( nCurLine )
   METHOD toPreviousFunction( nCurLine )

   METHOD relayMarkButtons()
   METHOD setBookmark()
   METHOD setTooltipMark( nIndex )
   METHOD gotoMark( nIndex )

   METHOD showHeader( aHeader )
   METHOD jumpToHarbourHelp( cWord )
   METHOD jumpToFunction( cWord )
   METHOD loadFunctionHelp( cWord )

   METHOD setLineNumbers( lOn, oHbQtEditor )
   METHOD setHorzRuler( lOn, oHbQtEditor )
   METHOD setCurrentLineHighlightMode( lOn, oHbQtEditor )

   METHOD presentSkeletons()
   METHOD refresh()
   METHOD buildHbQtEditor( lBase )

   PROTECTED:
   DATA   sourceFile                              INIT   ""

   METHOD manageFocusIn( oEdit )

   ENDCLASS


METHOD IdeEditor:init( oIde, cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )

   DEFAULT oIde        TO ::oIde
   DEFAULT cSourceFile TO ::sourceFile
   DEFAULT nPos        TO ::nPos
   DEFAULT nHPos       TO ::nHPos
   DEFAULT nVPos       TO ::nVPos
   DEFAULT cTheme      TO ::cTheme
   DEFAULT cView       TO ::cView
   DEFAULT aBookMarks  TO ::aBookMarks
   DEFAULT cCodePage   TO ::cCodePage
   DEFAULT cExtras     TO ::cExtras

   ::oIde       := oIde
   ::sourceFile := cSourceFile
   ::nPos       := nPos
   ::nHPos      := nHPos
   ::nVPos      := nVPos
   ::cTheme     := cTheme
   ::cView      := cView
   ::aBookMarks := aBookMarks
   ::cCodePage  := cCodePage
   ::cExtras    := cExtras

   ::nID        := hbide_getNextUniqueID()

   RETURN Self


METHOD IdeEditor:create( oIde, cSourceFile, nPos, nHPos, nVPos, cTheme, cView, aBookMarks, cCodePage, cExtras )
   LOCAL cFileTemp, nAttr

   DEFAULT oIde        TO ::oIde
   DEFAULT cSourceFile TO ::sourceFile
   DEFAULT nPos        TO ::nPos
   DEFAULT nHPos       TO ::nHPos
   DEFAULT nVPos       TO ::nVPos
   DEFAULT cTheme      TO ::cTheme
   DEFAULT cView       TO ::cView
   DEFAULT aBookMarks  TO ::aBookMarks
   DEFAULT cCodePage   TO ::cCodePage
   DEFAULT cExtras     TO ::cExtras

   ::oIde           := oIde
   ::SourceFile     := hbide_pathNormalized( cSourceFile, .F. )
   ::nPos           := nPos
   ::nHPos          := nHPos
   ::nVPos          := nVPos
   ::cTheme         := cTheme
   ::cView          := cView
   ::aBookMarks     := aBookMarks
   ::cCodePage      := cCodePage
   ::cExtras        := cExtras

   ::cCodePage := iif( Empty( ::cCodePage ), ::cWrkCodec, ::cCodePage )

   DEFAULT ::cView TO iif( ::cWrkView == "Stats", "Main", ::cWrkView )
   ::oDK:setView( ::cView )

   ::pathNormalized := hbide_pathNormalized( cSourceFile, .t. )

   hb_fNameSplit( cSourceFile, @::cPath, @::cFile, @::cExt )

   cFileTemp := hbide_pathToOSPath( ::cPath + ::cFile + ::cExt + ".tmp" )
   IF hb_fileExists( cFileTemp )
      IF hbide_getYesNo( "An auto saved version already exists, restore ?", cSourceFile, "Last run crash detected!" )
         hb_memowrit( hbide_pathToOSPath( cSourceFile ), hb_memoread( cFileTemp ) )
      ELSE
         ferase( cFileTemp )
      ENDIF
   ENDIF
   IF hb_fGetAttr( cSourceFile, @nAttr )
      ::lReadOnly := hb_bitAnd( nAttr, FC_READONLY ) == FC_READONLY
   ENDIF

   ::cType := upper( strtran( ::cExt, ".", "" ) )
   ::cType := iif( ::cType $ "PRG,HB,C,CPP,H,CH,PPO,HBS", ::cType, "U" )

   ::lIsPRG := ::cType $ "PRG,HB"

   ::buildTabPage( ::source() )

   ::qLayout := QBoxLayout(  Qt_Vertical )
   ::qLayout:setContentsMargins( 0,0,0,0 )

   ::oTab:oWidget:setLayout( ::qLayout )
   aadd( ::aTabs, { ::oTab, Self } )
   ::oEM:addSourceInTree( ::source(), ::cView )

   ::oEdit     := ::buildHbQtEditor( .T. )
   ::qEdit     := ::oEdit:widget()
   ::qCqEdit   := ::oEdit:widget()
   ::qCoEdit   := ::oEdit
   ::qDocument := ::oEdit:document()

   ::connectBlocks( ::oEdit )

   WITH OBJECT ::qVSplitter := QSplitter( Qt_Vertical )
      :setHandleWidth( 10 )
   ENDWITH
   WITH OBJECT ::qHSplitter := QSplitter( Qt_Horizontal )
      :setHandleWidth( 10 )
   ENDWITH
   IF ::oINI:lSplitVertical
      ::qLayout:addWidget( ::qVSplitter )
      ::qHSplitter:addWidget( ::oEdit:widget() )
      ::qVSplitter:addWidget( ::qHSplitter )
   ELSE
      ::qLayout:addWidget( ::qHSplitter )
      ::qVSplitter:addWidget( ::oEdit:widget() )
      ::qHSplitter:addWidget( ::qVSplitter )
   ENDIF
   RETURN Self


METHOD IdeEditor:destroy()
   LOCAL n, oEdit

   HB_TRACE( HB_TR_DEBUG, "IdeEditor:destroy()", 0 )

   ::oAC:qSelToolbar:setParent( ::oIde:oDlg:oWidget )

   ::oEdit:qEdit:disconnect( "updateRequest(QRect,int)" )

   IF !empty( ::qTimerSave )
      ::qTimerSave:disconnect( "timeout()" )
      ::qTimerSave:stop()
      ::qTimerSave := NIL
   ENDIF
   /* This code is reached under normal circumstances, so delete auto saved file */
   ferase( hbide_pathToOSPath( ::cPath + ::cFile + ::cExt + ".tmp" ) )

   IF ! Empty( ::oIde:oDebugger )
      IF ! Empty( ::oIde:oDebugger:cAppName )
         ::oIde:oDebugger:clearBreakPoints( ::cFile + ::cExt )
      ENDIF
   ENDIF

   DO WHILE Len( ::aEdits ) > 0
      oEdit := ::aEdits[ 1 ]
      hb_adel( ::aEdits, 1, .t. )
      oEdit:destroy()
   ENDDO
   ::oEdit:destroy()

   IF !Empty( ::qDocument )
      ::qDocument := NIL
   ENDIF

   IF ( n := ascan( ::aTabs, {|e_| e_[ TAB_OEDITOR ] == Self } ) ) > 0
      hb_adel( ::oIde:aTabs, n, .T. )
   ENDIF

   ::oEM:removeSourceInTree( ::source() )

   ::qTabWidget:removeTab( ::qTabWidget:indexOf( ::oTab:oWidget ) )
   ::oTab:oWidget:setParent( QWidget() )
   ::oTab:destroy()
   ::oTab:oWidget := NIL
   ::oTab := NIL

   IF ::qTabWidget:count() == 0
      IF ::lDockRVisible
         ::oFuncDock:hide()
         ::oIde:lDockRVisible := .f.
      ENDIF
   ENDIF
   HB_TRACE( HB_TR_DEBUG, "IdeEditor:destroy()", 1 )
   RETURN Self


METHOD IdeEditor:refresh()
   ::setDocumentProperties()
   ::relayMarkButtons()
   ::setLineNumbers()
   ::setHorzRuler()
   ::setCurrentLineHighlightMode()
   ::dispStatusInfo()
   ::changeThumbnail()
   RETURN Self


METHOD IdeEditor:buildHbQtEditor( lBase )
   LOCAL oHbQtEditor := HbQtEditor():new():create()

   DEFAULT lBase TO .T.

   WITH OBJECT oHbQtEditor
      :setFormattingInfo( ::supplyFormattingInfo() )
      :setFontInfo( ::oINI:cFontName, ::oINI:nPointSize )
      :setCompleter( ::qCompleter )
      :setTabSpaces( ::nTabSpaces )
      IF lBase
         :setBookmarks( ::aBookMarks )
      ENDIF
      :setModified( .F. )
      IF ::lReadOnly
         :setReadOnly( .T. )
      ENDIF
   ENDWITH
   ::setLineNumbers( NIL, oHbQtEditor )
   ::setCurrentLineHighlightMode( NIL, oHbQtEditor )
   ::setHorzRuler( NIL, oHbQtEditor )

   IF ! ( ::cType == "U" )
      IF ! lBase
         oHbQtEditor:setHilighter( ::oEdit:setHilighter() )
         ::connectBlocks( oHbQtEditor )
      ELSE
         oHbQtEditor:setHilighter( ::oTH:setSyntaxHilighting( oHbQtEditor:widget(), @::cTheme ) )
         oHbQtEditor:setTheme( ::cTheme )
      ENDIF
   ENDIF
   RETURN oHbQtEditor


METHOD IdeEditor:connectBlocks( oHbQtEditor )
   WITH OBJECT oHbQtEditor
      :updateRequestBlock       := {| oRect, nYScrolled | HB_SYMBOL_UNUSED( oRect + nYScrolled ), ::scrollThumbnail() }
      :breakPointSetBlock       := {| nLine | ::setBreakPoint( ::cFile + ::cExt, nLine ) }
      :modificationChangedBlock := {| lChanged | HB_SYMBOL_UNUSED( lChanged ), ::setTabImage() }
      :contextMenuBlock         := {| oPos, oInEdit | ::execEditContextMenu( oPos, oInEdit ) }
      :editorInfoBlock          := {| oEdit | ::dispEditInfo( oEdit ) }
      :selectionChangedBlock    := {| oEdit, nSelectedChars | ::selectionChanged( oEdit, nSelectedChars ) }
      :keyPressedBlock          := {| nQtKey, aModifiers, oEdit | ::handleKeyPressed( nQtKey, aModifiers, oEdit ) }
      :eventsBlock              := {| nEvent, xData, oEdit | ::handleEditorEvents( nEvent, xData, oEdit ) }
   ENDWITH
   RETURN Self


METHOD IdeEditor:split( nOrient )
   LOCAL oEdit

   WITH OBJECT oEdit := ::buildHbQtEditor( .F. )
      //:setReadOnly( .T. )
      ::qCoEdit := oEdit
      ::qCqEdit := oEdit:widget()
      :setDocument( ::oEdit:document() )
      :initHighlighter()
      :highlightPage()
      QApplication():processEvents( 0 )
   ENDWITH
   ::relay( oEdit, nOrient )
   QApplication():processEvents( 0 )
   RETURN Self


METHOD IdeEditor:relay( oHbQtEditor, nOrient )

   IF HB_ISOBJECT( oHbQtEditor )
      aadd( ::aEdits, oHbQtEditor )
   ENDIF
   IF nOrient == 1
      ::qHSplitter:addWidget( oHbQtEditor:widget() )
   ELSE
      ::qVSplitter:addWidget( oHbQtEditor:widget() )
   ENDIF
   ::manageFocusInEditor()
   RETURN Self


METHOD IdeEditor:prepareBufferToSave( cBuffer )
   LOCAL cE, cEOL, a_, s

   cE := ::oSetup:eol()

   // here we can extercise user settings via Setup
   //
   cEOL := iif( ::cEOL == "", cE, ::cEOL )
   IF !( cEOL == cE )
      // MsgBox( "Difference in set EOL and current file EOL mode, saving with original mode!" )
   ENDIF

   cBuffer := strtran( cBuffer, chr( 13 ) )
   IF !( cEOL == chr( 10 ) )
      cBuffer := strtran( cBuffer, chr( 10 ), cEOL )
   ENDIF
   IF ::oINI:lTrimTrailingBlanks
      a_:= hb_atokens( cBuffer, cEOL )
      FOR EACH s IN a_
         s := trim( s )
      NEXT
      cBuffer := ""
      aeval( a_, {|e| cBuffer += e + cEOL } )
      cBuffer := substr( cBuffer, 1, Len( cBuffer ) - len( cEOL ) )
   ENDIF
   RETURN cBuffer


METHOD IdeEditor:prepareBufferToLoad( cBuffer )
   LOCAL cSpaces

   ::cEOL := hbide_getEol( @cBuffer )

   IF ::oINI:lConvTabToSpcWhenLoading
      cSpaces := space( ::nTabSpaces )
      cBuffer := strtran( cBuffer, chr( 9 ), cSpaces )
   ENDIF
   RETURN cBuffer


METHOD IdeEditor:setEncoding( cCodec )
   LOCAL cBuffer
   LOCAL nPos, qCursor, nHPos, nVPos

   IF ::oEdit:isReadOnly()
      RETURN Self
   ENDIF
   IF ::cCodePage == cCodec
      ::oIde:setCodePage( ::cCodePage )
      RETURN Self
   ENDIF

   WITH OBJECT ::oEdit:widget()
      cBuffer := :toPlainText()   /* Will ALWAYS IN UTF8 */

      qCursor := :textCursor()
      nPos    := qCursor:position()
      nHPos   := :horizontalScrollBar():value()
      nVPos   := :verticalScrollBar():value()

      :clear()

      ::cCodePage := cCodec
      ::oIde:setCodePage( ::cCodePage )

      :setPlainText( cBuffer )
      :document():setModified( .T. )

      ::oDK:setStatusText( SB_PNL_CODEC, ::cCodePage + " | " + ::cWrkCodec )

      qCursor:setPosition( nPos )
      :setTextCursor( qCursor )
      :horizontalScrollBar():setValue( nHPos )
      :verticalScrollBar():setValue( nVPos )
   ENDWITH
   RETURN Self


METHOD IdeEditor:reload()
   LOCAL nAttr, nPos, qCursor, nHPos, nVPos

   IF ::qEdit:document():isModified()
      IF ! hbide_getYesNo( "Source is in modified state.", "Reload it anyway?", "Reload" )
         RETURN Self
      ENDIF
   ENDIF

   IF hb_fGetAttr( ::source(), @nAttr )
      ::lReadOnly := hb_bitAnd( nAttr, FC_READONLY ) == FC_READONLY
   ENDIF
   ::oEdit:setReadOnly( ::lReadOnly )
   ::setTabImage()

   qCursor := ::qEdit:textCursor()
   nPos    := qCursor:position()
   nHPos   := ::qEdit:horizontalScrollBar():value()
   nVPos   := ::qEdit:verticalScrollBar():value()

   ::qEdit:clear()
   ::qEdit:setPlainText( ::prepareBufferToLoad( hb_memoread( ::source() ) ) )

   qCursor:setPosition( nPos )
   WITH OBJECT ::qEdit
      :setTextCursor( qCursor )
      :horizontalScrollBar():setValue( nHPos )
      :verticalScrollBar():setValue( nVPos )
   ENDWITH
   RETURN Self


METHOD IdeEditor:setDocumentProperties()
   LOCAL qCursor

   qCursor := ::qEdit:textCursor()
   IF ! ::lLoaded
      ::oIde:setCodePage( ::cCodePage )

      ::qEdit:setPlainText( ::prepareBufferToLoad( hb_memoread( ::source() ) ) )

      IF !( ::cType == "U" )
         ::qHiliter := ::oTH:setSyntaxHilighting( ::qEdit, @::cTheme )
         ::oEdit:setHilighter( ::qHiliter )
      ENDIF

      qCursor:setPosition( ::nPos )
      ::qEdit:setTextCursor( qCursor )

      ::qEdit:horizontalScrollBar():setValue( ::nHPos )
      ::qEdit:verticalScrollBar():setValue( ::nVPos )

      ::qEdit:document():setModified( .F. )
      ::qEdit:document():setMetaInformation( QTextDocument_DocumentTitle, hb_FNameName( ::source() ) )

      ::lLoaded := .T.

      IF HB_ISOBJECT( ::qHiliter )
         ::qHiliter:hbSetInitialized( .T. )
         ::oEdit:highlightPage()
      ENDIF

      ::manageExtras()

      IF ::cType $ "PRG,HB,C,CPP,H,CH,HBS"
         WITH OBJECT ::qTimerSave := QTimer()
            :setInterval( max( 30000, ::oINI:nTmpBkpPrd * 1000 ) )
            :connect( "timeout()", {|| ::execEvent( __qTimeSave_timeout__ ) } )
            :start()
         ENDWITH
      ENDIF
      ::oUpDn:show()
   ENDIF

   ::nBlock  := qCursor:blockNumber()
   ::nColumn := qCursor:columnNumber()

   ::oIde:aSources := { ::source() }
   ::oIde:createTags()
   ::oIde:updateFuncList()
   ::oIde:updateTitleBar()

   ::dispEditInfo( ::oEdit )
   ::oIde:manageFocusInEditor()
   RETURN Self


METHOD IdeEditor:handleEditorEvents( nEvent, xData, oEdit )
   SWITCH nEvent
   CASE __HBQTEDITOR_FOCUSIN__
      ::oUpDn:show()
      ::oDK:showSelectedTextToolbar()
      ::manageFocusIn( oEdit )
      EXIT
   CASE __HBQTEDITOR_RESIZE__
      ::oUpDn:show()
      ::oDK:showSelectedTextToolbar()
      EXIT
   CASE __HBQTEDITOR_SELECTIONINFO__
      ::oDK:setButtonState( "SelectionMode", xData )
      EXIT

   CASE __HBQTEDITOR_UPDATEFIELDSLIST__
      RETURN ::updateFieldsList( xData )

   CASE __HBQTEDITOR_MARKCURRENTFUNCTION__
      RETURN ::markCurrentFunction( xData )
   CASE __HBQTEDITOR_GOTOPREVIOUSFUNCTION__
      RETURN ::toPreviousFunction( xData )
   CASE __HBQTEDITOR_GOTONEXTFUNCTION__
      RETURN ::toNextFunction( xData )

   CASE __HBQTEDITOR_SHOWHEADERFILE__
      RETURN ::showHeader( xData )

   CASE __HBQTEDITOR_LOADFUNCTIONHELP__
      RETURN ::loadFunctionHelp( xData )

   CASE __HBQTEDITOR_JUMPTOFUNCTION__
      RETURN ::jumpToFunction( xData )

   CASE __HBQTEDITOR_JUMPTOFUNCTIONHELP__
      RETURN ::jumpToHarbourHelp( xData )

   CASE __HBQTEDITOR_UPDATEWORDSINCOMPLETER__
      RETURN ::updateWordsInCompleter( xData )

   ENDSWITCH
   RETURN NIL


METHOD IdeEditor:handleKeyPressed( nQtKey, aModifiers, oEdit )
   LOCAL lAlt   := aModifiers[ 1 ]
   LOCAL lCtrl  := aModifiers[ 2 ]
   LOCAL lShift := aModifiers[ 3 ]

   IF ::oIde:oDebugger:isActive() .AND. ( AScan( { Qt_Key_F5, Qt_Key_F6, Qt_Key_F7, Qt_Key_F8, Qt_Key_F10 }, nQtKey ) > 0 )
      ::oIde:oDebugger:manageKey( nQtKey )
      RETURN .T.
   ENDIF

   IF ::oSC:execKey( oEdit, nQtKey, lAlt, lCtrl, lShift )   /* User Defined Actions */
      RETURN .T.
   ENDIF

   SWITCH nQtKey
   CASE Qt_Key_Right
      IF lAlt
         ::oEM:nextEditor()
         RETURN .T.
      ENDIF
      EXIT
   CASE Qt_Key_Left
      IF lAlt
         ::oEM:previousEditor()
         RETURN .T.
      ENDIF
      EXIT
   CASE Qt_Key_F3
      IF ! lCtrl .AND. ! lAlt
         ::oFR:find( .f. )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD IdeEditor:execEvent( nEvent, p, p1, p2 )
   LOCAL cFileTemp

   IF ::lQuitting
      RETURN Self
   ENDIF

   SWITCH nEvent
   CASE __qTimeSave_timeout__
      IF ::oEdit:document():isModified()
         cFileTemp := hbide_pathToOSPath( ::cPath + ::cFile + ::cExt + ".tmp" )
         hb_memowrit( cFileTemp, ::qEdit:toPlainText() )
      ENDIF
      EXIT
   ENDSWITCH
   HB_SYMBOL_UNUSED( p + p1 + p2 )
   RETURN Self


METHOD IdeEditor:updateComponents()

   ::oAC:qSelToolbar:setParent( ::oDlg:oWidget )

   ::setDocumentProperties()
   ::setCurrentLineHighlightMode()
   ::setLineNumbers()
   ::setHorzRuler()


   ::oIde:updateTitleBar()
   ::oUpDn:show()
   ::oDK:showSelectedTextToolbar()
   ::oIde:setCodePage( ::cCodePage )
   ::oDK:setStatusText( SB_PNL_CODEC, ::cCodePage + " | " + ::cWrkCodec )
   ::dispStatusInfo()
   ::changeThumbnail()
   ::relayMarkButtons()
   RETURN Self


METHOD IdeEditor:dispStatusInfo()
   LOCAL nMode := ::oEdit:getSelectionInfo( 5 )

   ::oDK:setButtonState( "SelectionMode", nMode > 1 )
   ::oDK:setStatusText( SB_PNL_STREAM, iif( nMode == 2, "Column", iif( nMode == 3, "Line", "Stream" ) ) )
   RETURN Self


METHOD IdeEditor:activateTab( mp1, mp2, oXbp )
   LOCAL oEdit

   HB_SYMBOL_UNUSED( mp1 )
   HB_SYMBOL_UNUSED( mp2 )

   IF !empty( oEdit := ::oEM:getEditorByTabObject( oXbp ) )
      oEdit:updateComponents()
   ENDIF

   RETURN Self


METHOD IdeEditor:execTabContextMenu( oPos )
   LOCAL qAct, nIndex, nTabIndex

   IF ! HB_ISOBJECT( ::oTabContextMenu )
      ::oTabContextMenu := QMenu()

      aadd( ::aActions, { "Save" , ::oTabContextMenu:addAction( QIcon( hbide_image( "save3"  ) ), "Save"  ) } )
      aadd( ::aActions, { "Close", ::oTabContextMenu:addAction( QIcon( hbide_image( "close3" ) ), "Close" ) } )
      aadd( ::aActions, { "Print", ::oTabContextMenu:addAction( QIcon( hbide_image( "print"  ) ), "Print" ) } )
   ENDIF

   IF ! Empty( qAct := ::oTabContextMenu:exec( ::oTabBar:mapToGlobal( oPos ) ) )
      nIndex := ::oTabBar:tabAt( oPos )
      nTabIndex := ::oEM:getTabByIndex( nIndex )

      SWITCH strtran( qAct:text(), "&", "" )
      CASE "Save"
         ::oSM:saveSource( nTabIndex, .f., .f. )
         EXIT
      CASE "Close"
         ::oSM:closeSource( nTabIndex )
         EXIT
      CASE "Print"
         ::oEM:printPreviewByIndex( nIndex )
         EXIT
      ENDSWITCH
   ENDIF
   RETURN Self


METHOD IdeEditor:buildTabPage( cSource )

   ::oTab := XbpTabPage():new( ::oTabParent, , { 5,5 }, { 700,400 }, , .t. )

   IF Empty( cSource )
      ::oTab:caption := "Untitled " + hb_ntos( hbide_getNextUntitled() )
   ELSE
      ::oTab:caption := ::cFile + iif( ::oINI:lTabRemoveExt, "", ::cExt )
   ENDIF
   ::oTab:minimized := .F.

   ::oTab:create()
#ifndef __HB_QT_MAJOR_VER_4__
   WITH OBJECT ::oTabBar := ::qTabWidget:tabBar()
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :setAcceptDrops( .T. )
      :connect( QEvent_DragEnter, {|p| p:acceptProposedAction() } )
      :connect( QEvent_DragMove , {|p| p:acceptProposedAction() } )
      :connect( QEvent_Drop     , {|p| p:setDropAction( Qt_IgnoreAction ), p:accept() } )
      :connect( "customContextMenuRequested(QPoint)", {|oPos| ::execTabContextMenu( oPos )  } )
   ENDWITH
#endif
   IF ::oINI:lTabAddClose
      ::qTabWidget:setTabsClosable( .T. )
      ::qTabWidget:connect( "tabCloseRequested(int)", {|i|  ::oSM:closeSource( i + 1 ) } )
   ENDIF
   ::qTabWidget:setTabTooltip( ::qTabWidget:indexOf( ::oTab:oWidget ), cSource )
   ::oTab:tabActivate := {|mp1,mp2,oXbp| ::activateTab( mp1, mp2, oXbp ) }

   RETURN Self


METHOD IdeEditor:dispEditInfo( oEdit )
   LOCAL s, qDocument, qCursor
   LOCAL qEdit := oEdit:widget()

   DEFAULT qEdit TO ::qEdit

   qDocument := qEdit:document()
   qCursor   := qEdit:textCursor()

   s := "<b>Line "+ hb_ntos( qCursor:blockNumber() + 1 ) + " of " + ;
                    hb_ntos( qDocument:blockCount() ) + "</b>"

   WITH OBJECT ::oIde:oSBar
      :getItem( SB_PNL_MAIN     ):caption := "Success"
      :getItem( SB_PNL_READY    ):caption := "Ready"
      :getItem( SB_PNL_LINE     ):caption := s
      :getItem( SB_PNL_COLUMN   ):caption := "Col " + hb_ntos( qCursor:columnNumber() + 1 )
      :getItem( SB_PNL_INS      ):caption := iif( qEdit:overwriteMode() , " ", "Ins" )
      :getItem( SB_PNL_MODIFIED ):caption := iif( qDocument:isModified(), "Modified", iif( qEdit:isReadOnly(), "ReadOnly", " " ) )
      :getItem( SB_PNL_EDIT     ):caption := "Edit"
   ENDWITH
   RETURN Self


METHOD IdeEditor:manageFocusIn( oEdit )
   ::qCoEdit := oEdit
   ::qCqEdit := oEdit:widget()
   oEdit:setHilighter( ::oEdit:setHilighter() )
   oEdit:highlightPage()
   ::relayMarkButtons()
   RETURN Self


METHOD IdeEditor:selectionChanged( oEdit, nSelectedChars )

   ::oDK:setStatusText( SB_PNL_SELECTEDCHARS, nSelectedChars )
   ::oDK:showSelectedTextToolbar( oEdit )
   ::oUpDn:show( oEdit )
   RETURN Self


METHOD IdeEditor:manageExtras()
   LOCAL n, n1, cExtras, cLine
   IF ! Empty( ::cExtras )
      IF ( n := At( "<BREAKPOINTS>", ::cExtras ) ) > 0
         IF ( n1 := At( "</BREAKPOINTS>", ::cExtras ) ) > 0
            cExtras := SubStr( ::cExtras, n + Len( "<BREAKPOINTS>" ), n1 - n - Len( "<BREAKPOINTS>" ) )
            FOR EACH cLine IN hb_ATokens( cExtras, " " )
               IF ( n := Val( cLine ) ) > 0
                  ::qEdit:hbSetBreakPoint( n )
               ENDIF
            NEXT
         ENDIF
      ELSE
         // any other futuristic feature
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:extras()
   LOCAL cExtras := iif( ! ::lLoaded, ::cExtras, "<BREAKPOINTS>" + StrTran( ::qEdit:hbGetBreakPoints(), ",", " " ) + "</BREAKPOINTS>" )
   RETURN iif( Empty( cExtras ), "", cExtras )


METHOD IdeEditor:setBreakPoint( cPrg, nLine )
   IF ! Empty( ::oIde:oDebugger ) .AND. ::oIde:oDebugger:isActive()
      ::oIde:oDebugger:addBreakPoint( cPrg, nLine )
   ENDIF
   RETURN Nil


METHOD IdeEditor:setTabImage( qEdit )
   LOCAL nIndex, lModified, lReadOnly, cIcon

   DEFAULT qEdit TO ::oEdit:widget()

   nIndex    := ::qTabWidget:indexOf( ::oTab:oWidget )
   lModified := ::oEdit:document():isModified()
   lReadOnly := iif( ::lReadOnly, ::lReadOnly, qEdit:isReadOnly() )

   IF lReadOnly
      cIcon := "tabreadonly"
   ELSE
      IF lModified
         cIcon := "tabmodified"
      ELSE
         cIcon := "tabunmodified"
      ENDIF
   ENDIF

   ::qTabWidget:setTabIcon( nIndex, QIcon( hbide_image( cIcon ) ) )
   ::oDK:setStatusText( SB_PNL_MODIFIED, iif( lModified, "Modified", iif( lReadOnly, "ReadOnly", " " ) ) )
   RETURN Self


METHOD IdeEditor:applyTheme( cTheme )

   IF !( ::cType == "U" )
      IF empty( cTheme )
         cTheme := ::oTH:selectTheme()
      ENDIF
      IF ::oTH:contains( cTheme )
         ::cTheme := cTheme
         IF HB_ISOBJECT( ::qHiliter )
            ::oTH:changeSyntaxHilighting( ::qEdit, @::cTheme, ::qHiliter )
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:vssExecute( cAction )
   LOCAL cPath, cFile, cExt, cCmd, cC, oProcess, cBatch, cOutput := ""
   LOCAL aCmd := {}

   IF ! empty( ::oINI:cVSSExe ) .AND. ! empty( ::oINI:cVSSDatabase )
      hb_fNameSplit( ::source(), @cPath, @cFile, @cExt )

      aadd( aCmd, "SET ssdir=" + hbide_pathToOSPath( ::oINI:cVSSDatabase ) )
      aadd( aCmd, "SET Force_dir=YES" )
      IF cAction == "Checkin"
         aadd( aCmd, "call " + '"' + ::oINI:cVSSExe + '/ss.exe' + '" ' + cAction + " " + cFile + cExt + " -ChbIDE" )
      ELSEIF cAction == "Checkout"
         aadd( aCmd, "call " + '"' + ::oINI:cVSSExe + '/ss.exe' + '" ' + cAction + " " + cFile + cExt + " -C-" )
      ELSE
         aadd( aCmd, "call " + '"' + ::oINI:cVSSExe + '/ss.exe' + '" ' + cAction + " " + cFile + cExt )
      ENDIF

      cBatch := hbide_getShellCommandsTempFile( aCmd )

      cCmd   := hbide_getShellCommand()
      cC     := iif( hbide_getOS() == "nix", "", "/C " )

      oProcess := HbpProcess():new()
      //
      oProcess:output      := {|cOut| cOutput += cOut }
      oProcess:finished    := {|| iif( !empty( cOutput ), ::reload(), NIL ), MsgBox( cOutput ) }
      oProcess:workingPath := hbide_pathToOSPath( cPath )

      oProcess:addArg( cC + cBatch )
      oProcess:start( cCmd )
   ENDIF
   RETURN Self


METHOD IdeEditor:showThumbnail()

   IF empty( ::qThumbnail )
      WITH OBJECT ::qThumbnail := HbQtEditor():new():create()
         :currentPointSize := 4
         :fontFamily := "Courier New"
         :setFont()
         :setReadOnly( .t. )
      ENDWITH
      IF !( ::cType == "U" )
         ::qTNHiliter := ::oTH:SetSyntaxHilighting( ::qThumbnail:qEdit, @::cTheme )
      ENDIF
      ::qThumbnail:qEdit:setTextInteractionFlags( Qt_TextSelectableByMouse + Qt_TextSelectableByKeyboard )
   ENDIF

   ::oSourceThumbnailDock:oWidget:setWidget( ::qThumbnail:qEdit )
   ::qThumbnail:qEdit:clear()
   ::qThumbnail:qEdit:setPlainText( hb_memoRead( ::source() ) )
   RETURN Self


METHOD IdeEditor:changeThumbnail()
   IF ::lLoaded .AND. ::oSourceThumbnailDock:oWidget:isVisible()
      ::showThumbnail()
   ENDIF
   RETURN Self


METHOD IdeEditor:scrollThumbnail()
   LOCAL qScroll

   IF ::lLoaded .AND. ::oSourceThumbnailDock:oWidget:isVisible() .AND. !empty( ::qThumbnail )
      qScroll := ::oEdit:qEdit:verticalScrollBar()
      ::qThumbnail:qEdit:verticalScrollBar():setValue( qScroll:value() )

      ::oEdit:qEdit:hbGetViewportInfo()

      ::qThumbnail:qEdit:hbHighlightArea( ::oEdit:aViewportInfo[ 1 ], 0, ::oEdit:aViewportInfo[ 1 ]+::oEdit:aViewportInfo[ 3 ]-1, 0, 1 )
   ENDIF
   RETURN Self


METHOD IdeEditor:updateFieldsList( cAlias )
   LOCAL xResp
   IF ! Empty( xResp := ::oEM:updateFieldsList( cAlias ) )
      ::oEdit:setActiveFieldsList( xResp )
   ENDIF
   RETURN Self


METHOD IdeEditor:currentFunctionIndex( nCurLine )
   LOCAL n := -1

   IF ! Empty( ::aTags )
      DEFAULT nCurLine TO ::oEdit:getLineNo()
      IF Len( ::aTags ) == 1
         n := 1
      ELSEIF ( n := ascan( ::aTags, {|e_| e_[ 3 ] >= nCurLine } ) ) == 0
         n := Len( ::aTags )
      ELSEIF n > 0
         n--
      ENDIF
   ENDIF
   RETURN n


METHOD IdeEditor:toNextFunction( nCurLine )
   LOCAL n

   IF ( n := ::currentFunctionIndex( nCurLine ) ) >= 0
      IF n < Len( ::aTags )
         IF ::oEdit:find( ::aTags[ n+1, 8 ], QTextDocument_FindCaseSensitively )
            ::oEdit:centerCursor()
            ::oEdit:down()
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:toPreviousFunction( nCurLine )
   LOCAL n

   IF ( n := ::currentFunctionIndex( nCurLine ) ) > 1
      IF ::oEdit:find( ::aTags[ n-1, 8 ], QTextDocument_FindCaseSensitively )
         ::oEdit:centerCursor()
         ::oEdit:down()
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:markCurrentFunction( nCurLine )
   LOCAL n

   IF ::oFuncDock:oWidget:isVisible()
      IF ( n := ::currentFunctionIndex( nCurLine ) ) > 0
         ::oIde:oFuncList:setItemColorFG( ::aTags[ n,7 ], { 255,0,0 } )
         ::oIde:oFuncList:setVisible( ::aTags[ n,7 ] )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:relayMarkButtons()
   LOCAL oBtn, nBlock, n, nn
   LOCAL aUnused := {}

   FOR EACH oBtn IN ::aMarkTBtns
      oBtn:hide()
   NEXT

   n := 0
   FOR EACH nBlock IN ::qCoEdit:bookMarks()
      IF ::qCoEdit:widget():blockCount() >= nBlock
         n++
         ::aMarkTBtns[ n ]:show()
      ELSE
         AAdd( aUnused, nBlock )
      ENDIF
   NEXT
   FOR EACH n IN aUnused
      IF ( nn := AScan( ::qCoEdit:bookMarks(), {|e| e == n } ) ) > 0
         hb_ADel( ::qCoEdit:bookMarks(), nn, .T. )
      ENDIF
   NEXT
   RETURN Self


METHOD IdeEditor:setBookmark()
   LOCAL qCursor, nBlock, n, aBookMarks
   LOCAL oEdit := ::qCoEdit

   IF ! ( qCursor := oEdit:getCursor() ):isNull()
      nBlock := qCursor:blockNumber() + 1
      aBookMarks := oEdit:bookMarks()

      IF ( n := ascan( aBookMarks, nBlock ) ) > 0
         hb_ADel( aBookMarks, n, .t. )
         ::aMarkTBtns[ Len( aBookMarks ) + 1 ]:hide()
      ELSE
         IF Len( aBookMarks ) == 6
            RETURN Self
         ENDIF
         AAdd( aBookMarks, nBlock )
         ::aMarkTBtns[ Len( aBookMarks ) ]:show()
      ENDIF
      oEdit:toggleBookmark( nBlock )
   ENDIF
   RETURN Self


METHOD IdeEditor:gotoMark( nIndex )
   ::qCoEdit:gotoMark( nIndex )
   RETURN Self


METHOD IdeEditor:setTooltipMark( nIndex )
   LOCAL oBlock
   LOCAL aBookMarks := ::qCoEdit:bookMarks()

   IF Len( aBookMarks ) >= nIndex
      oBlock := ::qCoEdit:findBlockByNumber( aBookMarks[ nIndex ] - 1 )
      IF oBlock:isValid()
         ::aMarkTBtns[ nIndex ]:setTooltip( hb_ntos( aBookMarks[ nIndex ] ) + " : " + oBlock:text() )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeEditor:loadFunctionHelp( cWord )
   LOCAL cPro

   IF Empty( cPro := ::oEM:getProto( cWord ) )
      IF ! Empty( ::oHL )
         ::oHL:jumpToFunction( cWord )
      ENDIF
      IF ! Empty( cPro := ::oFN:positionToFunction( cWord, .T. ) )
         IF Empty( ::cProto )
            ::oEdit:showPrototype( cPro )
         ENDIF
      ENDIF
   ELSE
      ::oEdit:showPrototype( cPro )
   ENDIF
   RETURN Self


METHOD IdeEditor:jumpToFunction( cWord )
   LOCAL n
   LOCAL lFindCur := .f.

   IF ( n := AScan( ::aTags, {|e_| Lower( cWord ) $ Lower( e_[ 7 ] ) } ) ) > 0
      lFindCur := ::oEdit:find( AllTrim( ::aTags[ n,8 ] ) )
   ENDIF
   IF ! lFindCur
      ::oFN:jumpToFunction( cWord, .T. )
   ENDIF
   RETURN Self


METHOD IdeEditor:jumpToHarbourHelp( cWord )
   IF ! Empty( ::oHL )
      ::oHL:jumpToFunction( cWord )
   ENDIF
   RETURN Self


METHOD IdeEditor:updateWordsInCompleter( cWord )
   IF ! hb_HHasKey( ::oEM:hEditingWords, cWord )
      ::oEM:hEditingWords[ cWord ] := cWord
      ::oEM:updateCompleterByEditingWords( cWord )
   ENDIF
   RETURN Self


METHOD IdeEditor:setLineNumbers( lOn, oHbQtEditor )
   DEFAULT oHbQtEditor TO ::oEdit
   oHbQtEditor:setLineNumbers( iif( HB_ISLOGICAL( lOn ), lOn, ::oIde:lLineNumbersVisible ) )
   RETURN Self


METHOD IdeEditor:setHorzRuler( lOn, oHbQtEditor )
   DEFAULT oHbQtEditor TO ::oEdit
   oHbQtEditor:setHorzRuler( iif( HB_ISLOGICAL( lOn ), lOn, ::oIde:lHorzRulerVisible ) )
   RETURN Self


METHOD IdeEditor:setCurrentLineHighlightMode( lOn, oHbQtEditor )
   DEFAULT oHbQtEditor TO ::oEdit
   oHbQtEditor:setCurrentLineHighlightMode( iif( HB_ISLOGICAL( lOn ), lOn, ::oIde:lCurrentLineHighlightEnabled ) )
   RETURN Self


METHOD IdeEditor:showHeader( aHeader )
   LOCAL cPath
   LOCAL lOpened := .F.
   LOCAL cHeader := aHeader[ 1 ]
   LOCAL cExt    := aHeader[ 2 ]

   FOR EACH cPath IN ::oINI:aIncludePaths
      IF hb_FileExists( hbide_pathToOSPath( cPath + cHeader ) )
         ::oIde:showHeaderFile( hb_MemoRead( cPath + cHeader ), cPath + cHeader, QIcon( hbide_image( hbide_imageForFileType( cExt ) ) ), .T. )
         lOpened := .T.
         EXIT
      ENDIF
   NEXT
   RETURN lOpened


METHOD IdeEditor:presentSkeletons()
   ::oSK:selectByMenuAndPostText( ::qEdit )
   RETURN Self


METHOD IdeEditor:supplyFormattingInfo()
   LOCAL hInfo := __hbqtStandardHash()

   hInfo[ "lSupressHbKWordsToUpper" ] := ::oINI:lSupressHbKWordsToUpper
   hInfo[ "lISOperator"             ] := ::oINI:lISOperator
   hInfo[ "lISAlignAssign"          ] := ::oINI:lISAlignAssign
   hInfo[ "lISCodeBlock"            ] := ::oINI:lISCodeBlock
   hInfo[ "lISClosingP"             ] := ::oINI:lISClosingP
   hInfo[ "lISSpaceP"               ] := ::oINI:lISSpaceP
   hInfo[ "lAutoIndent"             ] := ::oINI:lAutoIndent
   hInfo[ "lISClosing"              ] := ::oINI:lISClosing
   hInfo[ "lISIf"                   ] := ::oINI:lISIf
   hInfo[ "lISElse"                 ] := ::oINI:lISElse
   hInfo[ "lISEmbrace"              ] := ::oINI:lISEmbrace
   hInfo[ "lISFor"                  ] := ::oINI:lISFor
   hInfo[ "lISSwitch"               ] := ::oINI:lISSwitch
   hInfo[ "nISSwitchCases"          ] := ::oINI:nISSwitchCases
   hInfo[ "lISSwitchOWise"          ] := ::oINI:lISSwitchOWise
   hInfo[ "lISExitSameLine"         ] := ::oINI:lISExitSameLine
   hInfo[ "lISDoCase"               ] := ::oINI:lISDoCase
   hInfo[ "nISCaseCases"            ] := ::oINI:nISCaseCases
   hInfo[ "lISCaseOWise"            ] := ::oINI:lISCaseOWise
   hInfo[ "lISDoWhile"              ] := ::oINI:lISDoWhile
   hInfo[ "lISFunction"             ] := ::oINI:lISFunction
   hInfo[ "lISLocal"                ] := ::oINI:lISLocal
   hInfo[ "lISReturn"               ] := ::oINI:lISReturn
   hInfo[ "lISSeparator"            ] := ::oINI:lISSeparator
   hInfo[ "lReturnAsBeginKeyword"   ] := ::oINI:lReturnAsBeginKeyword
   hInfo[ "lISClass"                ] := ::oINI:lISClass
   hInfo[ "cISMethods"              ] := ::oINI:cISMethods
   hInfo[ "lSmartIndent"            ] := ::oINI:lSmartIndent
   hInfo[ "lCompleteArgumented"     ] := ::oINI:lCompleteArgumented
   hInfo[ "cGotoDialogGeometry"     ] := ::oINI:cGotoDialogGeometry
   hInfo[ "cISData"                 ] := ::oINI:cISData
   hInfo[ "cISFormat"               ] := ::oINI:cISFormat

   hInfo[ "cSeparator"              ] := ::oIde:cSeparator
   RETURN hInfo


METHOD IdeEditor:execToolsBox( p )
   IF Empty( p )
      RETURN ::oAC:showContextWidget( ::qCoEdit )
   ENDIF
   RETURN Self


METHOD IdeEditor:setReadOnly( lReadOnly )
   IF ! HB_ISLOGICAL( lReadOnly )
      IF ! ::lReadOnly
         ::oEdit:setReadOnly()                    // toggle readonly status
      ENDIF
   ELSE
      ::oEdit:setReadOnly( lReadOnly )
   ENDIF
   ::setTabImage()
   RETURN Self


METHOD IdeEditor:execEditContextMenu( oPos, oInEdit )
   LOCAL n, cAct, qAct, qCursor

   IF .T.
      qCursor := oInEdit:getCursor()

      ::oEM:aActions[ 17, 2 ]:setEnabled( ! empty( qCursor:selectedText() ) )

      n := ascan( ::aEdits, {|oEdit| oEdit == oInEdit } )

      ::oEM:aActions[ 18, 2 ]:setEnabled( .T. )
      ::oEM:aActions[ 19, 2 ]:setEnabled( .T. )
      ::oEM:aActions[ 21, 2 ]:setEnabled( n > 0 )
      IF empty( qAct := ::oEM:qContextMenu:exec( oInEdit:widget():mapToGlobal( oPos ) ) )
         RETURN Self
      ENDIF
      cAct := strtran( qAct:text(), "&", "" )
      SWITCH cAct
      CASE "Split Horizontally"
         ::split( 1 )
         EXIT
      CASE "Split Vertically"
         ::split( 2 )
         EXIT
      CASE "Close Splitted Instance"
         IF n > 0  /* 1 == Main Edit */
            hb_ADel( ::aEdits, n, .t. )
            ::qCqEdit := ::qEdit
            ::qCoEdit := ::oEdit
            IF oInEdit == ::oEdit
               ::oSourceThumbnailDock:oWidget:hide()
            ENDIF
            oInEdit:destroy()
            ::oIde:manageFocusInEditor()
         ENDIF
         EXIT
      CASE "Save as Skeleton..."
         ::oSK:saveAs( ::getSelectedText() )
         EXIT
      CASE "Change Theme"
         ::applyTheme()
         EXIT
      CASE "Goto Function"
         oInEdit:gotoFunction()
         EXIT
      CASE "Cut"
         oInEdit:cut()
         EXIT
      CASE "Copy"
         oInEdit:copy()
         EXIT
      CASE "Paste"
         oInEdit:paste()
         EXIT
      CASE "Undo"
         oInEdit:undo()
         EXIT
      CASE "Redo"
         oInEdit:redo()
         EXIT
      CASE "Show Selected Text"
         ::oIde:showFragment( oInEdit:getSelectedText(), "Selected Text", QIcon( hbide_image( "selectionline" ) ) )
         EXIT
      CASE "Diff"
         ::vssExecute( "Diff" )
         EXIT
      CASE "Get Latest Version"
         ::vssExecute( "Get" )
         EXIT
      CASE "Checkin"
         ::vssExecute( "Checkin" )
         EXIT
      CASE "Undo Checkout"
         ::vssExecute( "Undocheckout" )
         EXIT
      CASE "Checkout"
         ::vssExecute( "Checkout" )
         EXIT
      OTHERWISE
         IF "." $ cAct
            ::cTheme := SubStr( cAct, At( ".", cAct ) + 2 )
            ::oTH:changeSyntaxHilighting( ::qEdit, @::cTheme, ::qHiliter )
         ENDIF
         EXIT
      ENDSWITCH
   ENDIF
   RETURN NIL


FUNCTION __pullDictFunctions( aUserDict )
   LOCAL oDict, aDict, aList := {}

   FOR EACH oDict IN aUserDict
      IF oDict:lActive
         SWITCH oDict:cConvMode
         CASE "ASIS"
            FOR EACH aDict IN oDict:hItems
               AAdd( aList, aDict[ 1 ] )
            NEXT
            EXIT
         CASE "LOWER"
            FOR EACH aDict IN oDict:hItems
               AAdd( aList, Lower( aDict[ 1 ] ) )
            NEXT
            EXIT
         CASE "UPPER"
            FOR EACH aDict IN oDict:hItems
               AAdd( aList, Upper( aDict[ 1 ] ) )
            NEXT
            EXIT
         CASE "NONE"
            FOR EACH aDict IN oDict:hItems
               AAdd( aList, aDict:__enumKey() )
            NEXT
            EXIT
         ENDSWITCH
      ENDIF
   NEXT
   RETURN aList

