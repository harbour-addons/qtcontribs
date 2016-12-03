               /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2013-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                              17Nov2016
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "fileio.ch"
#include "hbgtinfo.ch"
#include "hbhrb.ch"
#include "hbqtgui.ch"

#if defined( __PLATFORM__WINDOWS )
REQUEST HB_GT_WVG
REQUEST HB_GT_WIN
REQUEST HB_GT_WVT
#else
REQUEST HB_GT_TRM
#endif

#define __btnAddGroupClicked__                    2005
#define __treeScriptsDoubleClicked__              2006
#define __treeScriptsContextMenuRequested__       2007
#define __btnSaveViewClicked__                    2008
#define __btnRestViewClicked__                    2009


FUNCTION HbQtSetScript( oHbQtScripts )
   STATIC s_oHbQtScripts
   LOCAL l_oHbQtScripts := s_oHbQtScripts
   IF HB_ISOBJECT( oHbQtScripts ) .AND. __objGetClsName( oHbQtScripts ) == "HBQTSCRIPTS"
      s_oHbQtScripts := oHbQtScripts
   ENDIF
   RETURN l_oHbQtScripts


CLASS HbQtScripts

   DATA   oWidget
   DATA   oUI
   DATA   oParent
   DATA   oHbQtEditor
   DATA   cCurScriptName                          INIT "new..."
   DATA   cLastPath                               INIT hb_DirBase()
   DATA   cScriptFile                             INIT "..."

   DATA   oTree
   DATA   hScripts                                INIT {=>}
   DATA   oRootNode

   ACCESS widget()                                INLINE ::oUI:widget()

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD execEvent( nEvent, p1, p2 )

   METHOD newScript()
   METHOD runScript( nMode )
   METHOD loadScript( cScript )
   METHOD saveScript()

   METHOD populateScriptsTree( cScript )
   METHOD prepareScriptsTree()
   METHOD findScriptNode( cNodeText )
   METHOD removeScripts( oItem )
   METHOD getFile( cTitle, cFilter, lAllowMulti, lCreateNew )

   METHOD keyPressed( nKey, aModifiers )

   ENDCLASS


METHOD HbQtScripts:init( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   hb_HCaseMatch( ::hScripts, .F. )
   RETURN Self


METHOD HbQtScripts:create( oParent )
   LOCAL oLay

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   WITH OBJECT oLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
   ENDWITH

   ::oParent:setLayout( oLay )

   WITH OBJECT ::oUI := hbqtui_scripts()
      ::oTree := :treeScripts
      ::oRootNode := ::oTree:invisibleRootItem()

      oLay:addWidget( ::oUI:widget() )

      WITH OBJECT ::oHbQtEditor := HbQtEditor():new( ::oUI:hbqTextEdit, "Bare Minimum" )
         :create()
         :keyPressedBlock := {| nKey, aModifiers | ::keyPressed( nKey, aModifiers ) }
      ENDWITH
      ::newScript()

      :labelSourceName:setText( ::cCurScriptName )

      :btnRunScript:connect( "clicked()", {|| ::runScript( 0 ) } )
      :btnRunConsole:connect( "clicked()", {|| ::runScript( 1 ) } )
      :btnOpenClose:connect( "clicked()", {|| iif( ::oUI:frameLeft:isVisible(), ::oUI:frameLeft:hide(), ::oUI:frameLeft:show() ), ;
            ::oUI:btnOpenClose:setIcon( QIcon( __hbqtImage( iif( ::oUI:frameLeft:isVisible(), "left-close", "left-open" ) ) ) ), ;
            ::oUI:btnOpenClose:setToolTip( iif( ::oUI:frameLeft:isVisible(), "Close Left Pane", "Open Left Pane" ) ) } )
      :btnNewSource :connect( "clicked()", {|| ::newScript() } )
      :btnLoadSource:connect( "clicked()", {|| ::loadScript() } )
      :btnSaveSource:connect( "clicked()", {|| ::saveScript() } )
      :btnAddGroup  :connect( "clicked()", {|| ::execEvent( __btnAddGroupClicked__ ) } )
      :btnSaveView  :connect( "clicked()", {|| ::execEvent( __btnSaveViewClicked__ ) } )
      :btnRestView  :connect( "clicked()", {|| ::execEvent( __btnRestViewClicked__ ) } )

      :comboInc     :connect( "customContextMenuRequested(QPoint)", {|oPoint,v| v := __hbqtExecPopup( { "Delete This Entry" }, ;
                                                                                       ::oUI:comboInc:mapToGlobal( oPoint ) ), ;
                            iif( v == "Delete This Entry", ::oUI:comboInc:removeItem( ::oUI:comboInc:currentIndex() ), NIL ) } )

      :progressBar:hide()

      ::prepareScriptsTree()
   ENDWITH
   ::oWidget := ::oUI:widget()
   HbQtSetScript( Self )
   RETURN Self


METHOD HbQtScripts:keyPressed( nKey, aModifiers )
   IF nKey == Qt_Key_S .AND. aModifiers[ 2 ]
      ::saveScript()
      RETURN .T.
   ENDIF
   RETURN NIL


METHOD HbQtScripts:execEvent( nEvent, p1, p2 )
   LOCAL i, cGroup, oItem, xTmp, hTree, hNode, cHsv

   HB_SYMBOL_UNUSED( p2 )

   SWITCH nEvent
   CASE __btnAddGroupClicked__
      IF ! Empty( cGroup := HbQtFetchString( ::oTree, "", "Scripts Group" ) )
         ::oTree:addTopLevelItem( __treeWidgetItem( cGroup, "Group - " + cGroup, "group" ) )
      ENDIF
      EXIT
   CASE __treeScriptsContextMenuRequested__
      IF ! Empty( oItem := ::oTree:itemAt( p1 ) )
         IF ! Empty( xTmp := __hbqtExecPopup( { "Collapse Children", "Expand Children", "Delete" }, ::oTree:mapToGlobal( p1 ) ) )
            SWITCH xTmp
            CASE "Collapse Children" ; __hbqtTreeCollapseAll( oItem ) ; EXIT
            CASE "Expand Children"   ; __hbqtTreeExpandAll( oItem ) ; EXIT
            CASE "Delete"
               IF ! oItem:text( 0 ) == "Default"
                  IF HbQtAlert( { "Do you want to delete [ " + oItem:text( 0 ) + " ]", "and all its children?" }, { "No", "Yes" } ) == 2
                     ::removeScripts( oItem )
                  ENDIF
               ENDIF
               EXIT
            ENDSWITCH
         ENDIF
      ENDIF
      EXIT
   CASE __btnSaveViewClicked__
      cHsv := ::getFile( "Save this Scripts View", "Scripts View (*.hsv)", .F., .T. )
      IF ! Empty( cHsv )
         hTree := {=>}
         //
         hTree[ "es2"      ] := ::oUI:checkES2:isChecked()
         hTree[ "w3"       ] := ::oUI:checkW3:isChecked()
         hTree[ "switches" ] := ::oUI:editSwitches:text()
         xTmp := ""
         IF ::oUI:comboInc:count() > 0
            FOR i := 0 TO ::oUI:comboInc:count() - 1
               xTmp += AllTrim( ::oUI:comboInc:itemText( i ) ) + " "
            NEXT
            xTmp := AllTrim( xTmp )
         ENDIF
         hTree[ "includes" ] := xTmp
         hTree[ "items"    ] := {}

         FOR i := 0 TO ::oTree:topLevelItemCount() - 1
            __itemToJson( ::oTree:topLevelItem( i ), hTree[ "items" ] )
         NEXT

         hb_MemoWrit( cHsv, hb_jsonEncode( hTree ) )
      ENDIF
      EXIT
   CASE __btnRestViewClicked__
      cHsv := ::getFile( "Restore Scripts View From...", "Scripts View (*.hsv)", .F., .F. )
      IF ! Empty( cHsv )
         hb_jsonDecode( hb_MemoRead( cHsv ), @hTree )
         IF HB_ISHASH( hTree ) .AND. ! Empty( hTree )
            ::cScriptFile := cHsv
            ::oTree:setHeaderLabel( " " + ::cScriptFile )
            ::oTree:clear()
            ::newScript()
            WITH OBJECT ::oUI
               :checkES2:setChecked( hTree[ "es2" ] )
               :checkW3:setChecked( hTree[ "w3" ] )
               :editSwitches:setText( hTree[ "switches" ] )
               :comboInc:clear()
               FOR EACH xTmp IN hb_ATokens( hTree[ "includes" ], " " )
                  IF ! Empty( xTmp )
                     :comboInc:addItem( xTmp )
                  ENDIF
               NEXT
               :comboInc:setCurrentIndex( 0 )
            ENDWITH
            IF hb_HHasKey( hTree, "items" ) .AND. ! Empty( hTree[ "items" ] )
               hNode := hTree[ "items" ]
               FOR EACH xTmp IN hNode
                  __jsonToTree( ::oTree:invisibleRootItem(), xTmp, ::hScripts )
               NEXT
            ENDIF
            __hbqtTreeExpandAll( ::oRootNode )
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtScripts:getFile( cTitle, cFilter, lAllowMulti, lCreateNew )
   LOCAL cFileName, cPath, cOpenPath

   IF ".hsv" $ cFilter .AND. ! ::cScriptFile == "..."
      cOpenPath := ::cScriptFile
   ELSE
      cOpenPath := ::cLastPath
   ENDIF
   IF ! Empty( cFileName := HbQtOpenFileDialog( cOpenPath, cTitle, cFilter, lAllowMulti, lCreateNew ) )
      IF lCreateNew .AND. hb_FileExists( cFileName )
         IF HbQtAlert( "File already exists, overright ?", { "No", "Overwrite" } ) != 2
            RETURN NIL
         ENDIF
      ENDIF
      IF ".hsv" $ cFilter
         ::cScriptFile := cFileName
         ::oTree:setHeaderLabel( " " + ::cScriptFile )
      ELSE
         hb_FNameSplit( cFileName, @cPath )
         ::cLastPath := cPath
      ENDIF
   ENDIF
   RETURN cFileName


STATIC FUNCTION __treeWidgetItem( cText, cTooltip, cWhatsThis )
   LOCAL oItem
   WITH OBJECT oItem := QTreeWidgetItem()
      :setText( 0, cText )
      :setTooltip( 0, cTooltip )
      :setWhatsThis( 0, cWhatsThis )
   ENDWITH
   RETURN oItem


STATIC FUNCTION __jsonToTree( oParent, hChild, hScripts )
   LOCAL oItem, hNode

   oItem := __treeWidgetItem( hChild[ "text" ], hChild[ "tooltip" ], hChild[ "whatsthis" ] )
   oParent:addChild( oItem )
   IF hChild[ "whatsthis" ] == "script"
      hScripts[ hChild[ "tooltip" ] ] := NIL
   ENDIF
   IF hb_HHasKey( hChild, "items" ) .AND. ! Empty( hChild[ "items" ] )
      FOR EACH hNode IN hChild[ "items" ]
         __jsonToTree( oItem, hNode, hScripts )
      NEXT
   ENDIF
   RETURN NIL


STATIC FUNCTION __itemToJson( oItem, aItems )
   LOCAL i, hNode

   hNode := hb_Hash( "text", oItem:text( 0 ), "tooltip", oItem:tooltip( 0 ), "whatsthis", oItem:whatsThis( 0 ), "items", {} )
   AAdd( aItems, hNode )
   IF oItem:childCount() > 0
      FOR i := 0 TO oItem:childCount() - 1
         __itemToJson( oItem:child( i ), hNode[ "items" ] )
      NEXT
   ENDIF
   RETURN NIL


METHOD HbQtScripts:removeScripts( oItem )
   LOCAL i, nChildren, oItm, nIndex, cScript

   IF ( nChildren := oItem:childCount() ) > 0
      FOR i := nChildren TO 1 STEP -1
         ::removeScripts( oItem:child( i - 1 ) )
      NEXT
      ::removeScripts( oItem )
   ELSE
      IF ( nIndex := ::oTree:indexOfTopLevelItem( oItem ) ) >= 0
         oItm := ::oTree:takeTopLevelItem( nIndex )
      ELSE
         nIndex := oItem:parent():indexOfChild( oItem )
         oItm := oItem:parent():takeChild( nIndex )
      ENDIF
      IF ! Empty( oItm )
         IF oItm:whatsThis( 0 ) == "script"
            cScript := oItm:tooltip( 0 )
            IF hb_HHasKey( ::hScripts, cScript )
               hb_HDel( ::hScripts, cScript )
               IF ::cCurScriptName == cScript
                  ::cCurScriptName := "new..."
                  ::oHbQtEditor:clear()
                  ::oUI:labelSourceName:setText( ::cCurScriptName )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtScripts:populateScriptsTree( cScript )
   LOCAL oParent, cName, cExt

   IF ! hb_HHasKey( ::hScripts, cScript )
      IF ! Empty( oParent := ::findScriptNode( "Default" ) )
         hb_FNameSplit( cScript, , @cName, @cExt )
         oParent:addChild( __treeWidgetItem( cName + cExt, cScript, "script" ) )
         oParent:setExpanded( .T. )
         //
         ::hScripts[ cScript ] := NIL
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtScripts:findScriptNode( cNodeText )
   LOCAL i, oNode

   FOR i := 0 TO ::oTree:topLevelItemCount() - 0
      IF ::oTree:topLevelItem( i ):text( 0 ) == cNodeText
         RETURN ::oTree:topLevelItem( i )
      ENDIF
   NEXT
   // Not one of the top level items - find in children
   //
   FOR i := 0 TO ::oTree:topLevelItemCount() - 0
      IF ! Empty( oNode := __hbqtTreeFindNode( ::oTree:topLevelItem( i ), cNodeText ) )
         RETURN oNode
      ENDIF
   NEXT
   RETURN oNode


METHOD HbQtScripts:prepareScriptsTree()
   LOCAL oItem := __treeWidgetItem( "Default", "Group - Default", "group" )

   WITH OBJECT ::oTree
      :setHeaderLabel( " " + ::cScriptFile )
      :addTopLevelItem( oItem )
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oItem| iif( oItem:whatsThis( 0 ) == "script", ::loadScript( oItem:tooltip( 0 ) ), NIL ) } )
      :connect( "customContextMenuRequested(QPoint)"     , {|oPoint| ::execEvent( __treeScriptsContextMenuRequested__, oPoint ) } )
   ENDWITH

   ::oUI:btnCSoft:connect( "clicked()", {|| __hbqtTreeCollapseAll( ::oRootNode, .T. ) } )
   ::oUI:btnCAll :connect( "clicked()", {|| __hbqtTreeCollapseAll( ::oRootNode  )     } )
   ::oUI:btnESoft:connect( "clicked()", {|| __hbqtTreeExpandAll( ::oRootNode, .T. )   } )
   ::oUI:btnEAll :connect( "clicked()", {|| __hbqtTreeExpandAll( ::oRootNode  )       } )
   RETURN Self


METHOD HbQtScripts:newScript()
   LOCAL cNew := ""

   cNew += Chr( 10 )
   cNew += "FUNCTION __test()"
   cNew += Chr( 10 )
   cNew += Chr( 10 )
   cNew += "   RETURN Alert( 'Wow, Harbour Scripts!' )"
   cNew += Chr( 10 )
   cNew += Chr( 10 )

   ::cCurScriptName := "new..."
   ::oUI:labelSourceName:setText( ::cCurScriptName )
   ::oHbQtEditor:setSource( cNew )
   RETURN Self


METHOD HbQtScripts:loadScript( cScript )
   LOCAL cBuffer

   IF Empty( cScript )
      cScript := ::getFile( "Select a Harbour Script", "Harbour Source (*.prg);Harbour Script (*.hb)", .F., .F. )
      IF ! Empty( cBuffer := hb_MemoRead( cScript ) )
         ::oHbQtEditor:setSource( cBuffer )
         ::cCurScriptName := cScript
         ::oUI:labelSourceName:setText( ::cCurScriptName )
         //
         ::populateScriptsTree( cScript )
      ENDIF
   ELSE
      IF ! Empty( cBuffer := hb_MemoRead( cScript ) )
         ::oHbQtEditor:setSource( cBuffer )
         ::cCurScriptName := cScript
         ::oUI:labelSourceName:setText( ::cCurScriptName )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtScripts:saveScript()
   LOCAL cScript

   IF ::cCurScriptName == "new..."
      cScript := ::getFile( "Save this Harbour Script", "Harbour Source (*.prg);Harbour Script (*.hb)", .F., .T. )
      IF Empty( cScript )
         RETURN Self
      ENDIF
      ::cCurScriptName := cScript
      ::oUI:labelSourceName:setText( ::cCurScriptName )
      //
      ::populateScriptsTree( cScript )
   ENDIF

   hb_MemoWrit( ::cCurScriptName, ::oHbQtEditor:getSource() )
   RETURN Self


STATIC FUNCTION __hbqtValToChar( uVal )
   SWITCH ValType( uVal )
   CASE "C"
   CASE "M"
      RETURN uVal
   CASE "D"
      RETURN DToC( uVal )
   CASE "T"
      RETURN iif( Year( uVal ) == 0, HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) ), HB_TToC( uVal ) )
   CASE "L"
      RETURN If( uVal, ".T.", ".F." )
   CASE "N"
      RETURN AllTrim( Str( uVal ) )
   CASE "B"
      RETURN "{|| ... }"
   CASE "A"
      RETURN "{ ... }"
   CASE "O"
      RETURN iif( __ObjHasData( uVal, "cClassName" ), uVal:cClassName, uVal:ClassName() )
   CASE "H"
      RETURN "{=>}"
   CASE "P"
      RETURN "0x" + hb_NumToHex( uVal )
   ENDSWITCH
   RETURN ""


STATIC FUNCTION __errorDesc( e )
   LOCAL n
   LOCAL cErrorLog := e:description + Chr( 10 ) + e:operation + Chr( 10 )
   LOCAL aStack := {}

   IF ValType( e:Args ) == "A"
      cErrorLog += "   Args:" + Chr( 10 )
      FOR n := 1 to Len( e:Args )
         cErrorLog += "     [" + Str( n, 4 ) + "] = " + ValType( e:Args[ n ] ) + ;
                      "   " + __hbqtValToChar( __hbqtValToChar( e:Args[ n ] ) ) + ;
                      iif( ValType( e:Args[ n ] ) == "A", " length: " + ;
                      AllTrim( Str( Len( e:Args[ n ] ) ) ), "" ) + Chr( 10 )
      NEXT
   ENDIF

   cErrorLog += Chr( 10 ) + "Stack Calls" + Chr( 10 )
   cErrorLog += "===========" + Chr( 10 )
   n := 1
   WHILE  ( n < 74 )
      IF ! Empty( ProcName( n ) )
         AAdd( aStack, "   Called from: " + ProcFile( n ) + " => " + Trim( ProcName( n ) ) + ;
                        "( " + hb_ntos( ProcLine( n ) ) + " )" )
         cErrorLog += ATail( aStack ) + Chr( 10 )
      ENDIF
      n++
   END
   RETURN cErrorLog


STATIC FUNCTION __consoleScript( cBuffer, cCompFlags, xParam, cPath )
   IF hb_mtvm()
#if defined( __PLATFORM__WINDOWS )
      hb_threadStart( {||
                        LOCAL cGuiPath
                        LOCAL oCrt := WvgCrt():New( NIL, NIL, { -1, -1 }, { 24, 79 }, NIL, .T. )

                        cGuiPath := hb_cwd( cPath )
                        WITH OBJECT oCrt
                           :resizeMode := HB_GTI_RESIZEMODE_ROWS
                           :create()
                           hb_gtInfo( HB_GTI_WINTITLE, "Harbour Script" )
                           __runScript( cBuffer, cCompFlags, xParam, .T. )
                           :destroy()
                        ENDWITH
                        hb_cwd( cGuiPath )
                        RETURN NIL
                      } )
#else
      hb_threadStart( {|| hb_gtReload( "TRM" ),__runScript( cBuffer, cCompFlags, xParam, .T. ) } )
#endif
   ELSE
      __runScript( cBuffer, cCompFlags, xParam, .F. )
   ENDIF
   RETURN NIL


METHOD HbQtScripts:runScript( nMode )
   LOCAL cBuffer, cCompFlags, xParam, cInc, cI, i, cPath

   cCompFlags := ""
   IF ::oUI:checkES2:isChecked()
      cCompFlags += " -es2"
   ENDIF
   IF ::oUI:checkW3:isChecked()
      cCompFlags += " -w3"
   ENDIF

   IF ! Empty( cInc := ::oUI:editSwitches:text() )
      cInc := StrTran( cInc, "    ", " " )
      cInc := StrTran( cInc, "   ", " " )
      cInc := StrTran( cInc, "  ", " " )
      FOR EACH cI IN hb_ATokens( cInc, " " )
         cI := AllTrim( cI )
         IF Left( cI, 1 ) == "-"
            cCompFlags += " " + cI
         ENDIF
      NEXT
   ENDIF
   IF ::oUI:comboInc:count() > 0
      FOR i := 0 TO ::oUI:comboInc:count() - 1
         cCompFlags += " -i" + ::oUI:comboInc:itemText( i )
      NEXT
   ENDIF
   cCompFlags += " -i" + hb_DirBase()
   IF ::oUI:labelSourceName:text() != "new..."
      hb_FNameSplit( ::oUI:labelSourceName:text(), @cPath )
      IF ! Empty( cPath )
         cCompFlags += " -i" + cPath
      ENDIF
   ENDIF
   cCompFlags += " -D__HBQTSCRIPTS__"
   cCompFlags := AllTrim( cCompFlags )

   cBuffer := ::oHbQtEditor:getSource()

   cBuffer := '#command SELECT <fld,...> FROM <from> [INTO <into>] [ORDER BY <order,...>] [WHERE <*whr*>] ' + ;
              ' => ' + ;
              ' __hbqtExecSelect( #<fld>, <"from">, #<whr>, #<order>, <"into"> )' + ;
              Chr( 10 ) + Chr( 10 ) + cBuffer

   xParam := NIL
   IF nMode == 1
      __consoleScript( cBuffer, cCompFlags, xParam, cPath )
   ELSE
      __runScript( cBuffer, cCompFlags, xParam, .F. )
   ENDIF
   RETURN NIL


STATIC FUNCTION __runScript( cBuffer, cCompFlags, xParam, lThreaded )
   LOCAL cFile, pHrb, oErr
   LOCAL a_:={}
   LOCAL lError := .F.
   LOCAL bError := ErrorBlock( {|o| break( o ) } )

   BEGIN SEQUENCE
      AAdd( a_, cBuffer )
      AEval( hb_ATokens( cCompFlags, " " ), {|s| iif( ! Empty( s ), AAdd( a_,s ), NIL ) } )
      cFile := hb_compileFromBuf( hb_ArrayToParams( a_ ) )
      IF ! Empty( cFile )
         IF lThreaded
            pHrb := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, cFile )
         ELSE
            pHrb := hb_hrbLoad( HB_HRB_BIND_LOCAL, cFile )
         ENDIF
      ENDIF
   RECOVER USING oErr
      IF lThreaded
         Alert( __errorDesc( oErr ) )
      ELSE
         HbQtAlert( __errorDesc( oErr ) )
      ENDIF
      lError := .t.
   END SEQUENCE

   IF ! lError .AND. !empty( pHrb )
      BEGIN SEQUENCE
         hb_hrbDo( pHrb, xParam )
      RECOVER USING oErr
         IF lThreaded
            Alert( __errorDesc( oErr ) )
         ELSE
            HbQtAlert( __errorDesc( oErr ) )
         ENDIF
      END SEQUENCE
   ENDIF
   IF ! Empty( pHrb )
      hb_hrbUnload( pHrb )
   ENDIF
   ErrorBlock( bError )
   RETURN NIL

//--------------------------------------------------------------------//
//               Select Statement Parser & Executer
//--------------------------------------------------------------------//

FUNCTION __hbqtExecSelect( cFields, cFrom, cWhere, cOrder, cInto )
   LOCAL n, nS, nE, i, cDriver, aFields, cField, nField, cPath, cName, cExt, aStruct, xTmp, cTable
   LOCAL aWhere, aTags, nWhere, aData, cSearch, cMsg, cValue, cFor, bFor, aOrder, cE, nLastOrder
   LOCAL cAlias := "__SOURCE__"
   LOCAL cTarget := "__TARGET__"
   LOCAL lTableExists := .F.
   LOCAL cOrgInto := cInto
   LOCAL nIndex := 0

   IF Empty( cFrom )
      Alert( "FROM clause missing!" )
      RETURN NIL
   ENDIF
   DEFAULT cWhere TO ""
   DEFAULT cOrder TO ""
   DEFAULT cInto  TO ""

   IF ( n := At( "|", cFrom ) ) > 0
      cDriver := SubStr( cFrom, 1, n - 1 )
      cTable := SubStr( cFrom, n + 1 )
   ELSE
      cDriver := "DBFCDX"
      cTable := cFrom
   ENDIF
   hb_FNameSplit( cTable, @cPath, @cName, @cExt )

   SWITCH Upper( cDriver )
   CASE "DBFCDX"
   CASE "DBFNTX"
   CASE "DBFNSX"
   CASE "ADS"
      IF Empty( cExt )
         cTable := cTable + ".dbf"
      ENDIF
      lTableExists := hb_FileExists( cTable )
      EXIT
   CASE "CACHERDD"
#if defined( __CACHE__ )
      lTableExists := CacheExistTable( cName )
#endif
      EXIT
   ENDSWITCH

   IF ! lTableExists
      Alert( "Table " + cTable + ";" + "does not exists!" )
      RETURN NIL
   ENDIF

   USE ( cTable ) VIA ( cDriver ) Alias ( cAlias ) SHARED NEW
   IF NetErr()
      Alert( "Some error in opening ;" + cTable )
      RETURN NIL
   ENDIF
   aStruct:= dbStruct()

   IF "*" == cFields
      aFields := {}
      AEval( aStruct, {|e_| AAdd( aFields, e_[ 1 ] ) } )
   ELSE
      aFields := {}
      xTmp := hb_ATokens( cFields, "," )
      FOR EACH cField IN xTmp
         cField := Upper( AllTrim( cField ) )
         IF AScan( aStruct, {|e_| e_[ 1 ] == cField } ) > 0
            AAdd( aFields, cField )
         ENDIF
      NEXT
   ENDIF
   IF Empty( aFields )
      RETURN __closeAndAlert( "Fields requested are not present in the table!" )
   ENDIF

   aTags := {}
   FOR n := 1 TO 50
      IF ( xTmp := ( cAlias )->( IndexKey( n ) ) ) == ""
         EXIT
      ENDIF
      AAdd( aTags, Upper( xTmp ) )
   NEXT

   IF ! Empty( cWhere )
      IF ! __pullWheres( aStruct, cWhere, @aWhere, @cMsg )
         RETURN __closeAndAlert( cMsg )
      ENDIF
      IF ! Empty( aWhere )
         nWhere := 0
         IF ! Empty( aTags )
            FOR EACH xTmp IN aWhere
               IF xTmp[ 3 ] == "="
                  n := Len( xTmp[ 1 ] )
                  IF ( nIndex := AScan( aTags, {|e| Left( e, n ) == xTmp[ 1 ] } ) ) > 0
                     dbSetOrder( nIndex )
                     nWhere := xTmp:__enumIndex()
                     cSearch := xTmp[ 2 ]
                     IF Left( cSearch, 1 ) == '"'
                        cSearch := SubStr( cSearch, 2, Len( cSearch ) - 2 )
                     ENDIF
                     xTmp[ 4 ] := cSearch
                     EXIT
                  ENDIF
               ENDIF
            NEXT
         ENDIF
         //
         cFor := ""
         FOR EACH xTmp IN aWhere
            n := xTmp:__enumIndex()
            IF n != nWhere       // we already processed it as seek field
               nField := AScan( aStruct, {|e_| e_[ 1 ] == xTmp[ 1 ] } )
               cValue := xTmp[ 2 ]
               IF Left( cValue, 1 ) == '"'
                  cValue := SubStr( cValue, 2, Len( cValue ) - 2 )
               ENDIF
               xTmp[ 2 ] := cValue
               SWITCH aStruct[ nField, 2 ]
               CASE "C"
                  cValue := '"' + cValue + '"'
                  EXIT
               CASE "D"
                  cValue := StrTran( cValue, "-", "" )
                  cValue := "StoD('" + cValue + "')"
                  EXIT
               CASE "N"
                  cValue := Val( cValue )
                  cValue := hb_ntos( cValue )
                  EXIT
               ENDSWITCH
               xTmp[ 2 ] := cValue
               xTmp[ 5 ] := nField
               //                                               operator          value
               cFor += "fieldget(" + hb_ntos( nField ) + ") " + xTmp[ 3 ] + " " + xTmp[ 2 ] + " .AND. "
            ENDIF
         NEXT
         IF Right( cFor,7 ) == " .AND. "
            cFor := Left( cFor, Len( cFor ) - 7 )
         ENDIF

         IF ! Empty( cFor )
            bFor := &( "{|| " + cFor + "}" )
         ENDIF
      ENDIF
   ENDIF

   aData := {}
   IF ! HB_ISBLOCK( bFor )
      IF nIndex > 0                                  // We have the index
         IF dbSeek( cSearch )
            DO WHILE ( cAlias )->( &( IndexKey( nIndex ) ) ) = cSearch
               xTmp := {}
               FOR EACH cField IN aFields
                  AAdd( xTmp, ( cAlias )->&cField )
               NEXT
               AAdd( aData, xTmp )
               ( cAlias )->( dbSkip() )
            ENDDO
         ENDIF
      ELSE
         DO WHILE ! ( cAlias )->( Eof() )
            xTmp := {}
            FOR EACH cField IN aFields
               AAdd( xTmp, ( cAlias )->&cField )
            NEXT
            AAdd( aData, xTmp )
            ( cAlias )->( dbSkip() )
         ENDDO
      ENDIF
   ELSE
      IF nIndex > 0                                  // We have the index
         IF dbSeek( cSearch )
            DO WHILE ( cAlias )->( &( IndexKey( nIndex ) ) ) = cSearch
               IF Eval( bFor )
                  xTmp := {}
                  FOR EACH cField IN aFields
                     AAdd( xTmp, ( cAlias )->&cField )
                  NEXT
                  AAdd( aData, xTmp )
               ENDIF
               ( cAlias )->( dbSkip() )
            ENDDO
         ENDIF
      ELSE
         DO WHILE ! ( cAlias )->( Eof() )
            IF Eval( bFor )
               xTmp := {}
               FOR EACH cField IN aFields
                  AAdd( xTmp, ( cAlias )->&cField )
               NEXT
               AAdd( aData, xTmp )
            ENDIF
            ( cAlias )->( dbSkip() )
         ENDDO
      ENDIF
   ENDIF
   Select( cAlias )                               // we are done with the source, close it
   dbCloseArea()

   IF ! Empty( aData )
      IF ! Empty( cOrder )
         cOrder := Upper( cOrder )
         aOrder := hb_ATokens( cOrder, "," )
         FOR EACH cOrder IN aOrder
            IF Right( cOrder, 4 ) == "-ASC"
               cOrder := Left( cOrder, Len( cOrder ) - 4 )
            ENDIF
            xTmp := Right( cOrder, 5 ) == "-DESC"
            IF xTmp
               cOrder := Left( cOrder, Len( cOrder ) - 5 )
            ENDIF
            nS := 1
            IF ( n := AScan( aFields, {|e| e == cOrder } ) ) > 0
               cFor := "e_[" + hb_ntos( n ) + "]" + iif( xTmp, ">", "<" ) +  "f_[" + hb_ntos( n ) + "]"
               bFor := &( "{|e_,f_| " + cFor + " }" )

               IF cOrder:__enumIndex() == 1
                  ASort( aData, NIL, NIL, bFor )
               ELSE
                  cE := aData[ nS, nLastOrder ]
                  nE := 0
                  DO WHILE .T.
                     FOR i := nS TO Len( aData )
                        IF aData[ i, nLastOrder ] != cE
                           ASort( aData, nS, nE, bFor )
                           cE := aData[ i, nLastOrder ]
                           nS := i
                           nE := 0
                           EXIT
                        ENDIF
                        nE++
                     NEXT
                     IF nE >= Len( aData )
                        EXIT
                     ENDIF
                  ENDDO
                  IF nS < Len( aData )
                     ASort( aData, nS, NIL, bFor )
                  ENDIF
               ENDIF
               nLastOrder := n
            ENDIF
         NEXT
      ENDIF
      IF Empty( cInto )
         IF ( xTmp := hb_FTempCreateEx( @cInto, NIL, NIL, ".dbf" ) ) != F_ERROR
            FClose( xTmp )
         ENDIF
      ENDIF
      xTmp := {}
      FOR EACH cField IN aFields
         IF ( n := AScan( aStruct, {|e_| e_[ 1 ] == cField } ) ) > 0
            AAdd( xTmp, aStruct[ n ] )
         ENDIF
      NEXT
      IF ! Empty( cInto )
         dbCreate( cInto, xTmp, "DBFCDX" )
         IF ! NetErr() .AND. hb_FileExists( cInto )
            USE ( cInto ) ALIAS ( cTarget ) EXCLUSIVE NEW VIA "DBFCDX"
            IF ! NetErr()
               FOR EACH xTmp IN aData
                  dbAppend()
                  FOR EACH cField IN aFields
                     REPLACE ( cTarget )->&cField WITH xTmp[ cField:__enumIndex() ]
                  NEXT
               NEXT
               dbCommit()
               dbGoTop()
               Browse()
               dbCloseArea()
               IF Empty( cOrgInto )
                  FErase( cInto )
               ENDIF
            ENDIF
         ELSE
            Alert( "Some error in opening result cursor" )
         ENDIF
      ENDIF
   ENDIF
#ifdef __HBQTSCRIPTS__
   RETURN Alert( cFields + ";" + cFrom + ";" + cWhere + ";" + cOrder + ";" + cInto )
#else
   RETURN NIL
#endif


STATIC FUNCTION __pullWheres( aStruct, cWhere, aWhere, cMsg )
   LOCAL xTmp, n, cClone, cField
   LOCAL a_:={}

   aWhere := {}

   cClone := StrTran( cWhere, " and ", " AND " )
   DO WHILE .T.
      IF ( n := At( " AND ", cClone ) ) > 0
         AAdd( a_, AllTrim( SubStr( cClone, 1, n - 1 ) ) )
         cClone := SubStr( cClone, n + 5 )
      ELSE
         EXIT
      ENDIF
   ENDDO
   IF ! Empty( cClone )
      AAdd( a_, cClone )
   ENDIF

   FOR EACH xTmp IN a_
      // parse for OR condition
   NEXT

   FOR EACH cWhere IN a_
      DO CASE
      CASE At( ">=", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, ">=" ) )
      CASE At( "<=", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, "<=" ) )
      CASE At( "!=", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, "!=" ) )
      CASE At( "<>", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, "<>" ) )
      CASE At( "=", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, "=" ) )
      CASE At( ">", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, ">" ) )
      CASE At( "<", cWhere ) > 0
         AAdd( aWhere, __pullKeyValueOperator( cWhere, "<" ) )
      ENDCASE
   NEXT

   FOR EACH a_ IN aWhere
      IF ! HB_ISARRAY( a_ )
         cMsg := "WHERE clause - mal-formed!"
         RETURN .F.
      ENDIF
      cField := a_[ 1 ]
      IF AScan( aStruct, {|e_| e_[ 1 ] == cField } ) == 0
         cMsg := "WHERE clause - field does not exists!"
         RETURN .F.
      ENDIF
   NEXT
   HB_SYMBOL_UNUSED( cMsg )
   RETURN .T.


STATIC FUNCTION __pullKeyValueOperator( cWhere, cOperator )
   LOCAL cField, cValue
   LOCAL n := hb_At( cOperator, cWhere )
   IF n > 0
      cField := Upper( AllTrim( SubStr( cWhere, 1, n - 1 ) ) )
      cValue := AllTrim( SubStr( cWhere, n + Len( cOperator ) ) )
      RETURN { cField, cValue, cOperator, NIL, NIL, NIL }
   ENDIF
   RETURN NIL


STATIC FUNCTION __closeAndAlert( cAlert )
   Select( "__SOURCE__" )
   dbCloseArea()
   RETURN Alert( cAlert )

