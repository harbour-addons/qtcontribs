/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Pritpal Bedi <pritpal@vouchcac.com>
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
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                            Harbour-Qt IDE
 *
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                               14Mar2010
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include "hbide.ch"
#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"

/*----------------------------------------------------------------------*/

#define __buttonArgs_clicked__                    101
#define __buttonDesc_clicked__                    102
#define __buttonExample_clicked__                 103

#define __buttonCloseArgs_clicked__               111
#define __buttonCloseDesc_clicked__               112
#define __buttonCloseExample_clicked__            113

#define __buttonLoadFromCurFunc_clicked__         115

#define __buttonClear_clicked__                   116
#define __buttonSaveInFunc_clicked__              117
#define __buttonSave_clicked__                    118
#define __buttonLoadFromDocFile_clicked__         119
#define __comboFunctions_currentIndexChanged__    120


#define qqTemplate                                1
#define qqVersion                                 2
#define qqStatus                                  3
#define qqCompliance                              4
#define qqPlatforms                               5
#define qqCategory                                6
#define qqSubCategory                             7
#define qqName                                    8
#define qqExtLink                                 9
#define qqOneLiner                                10
#define qqSyntax                                  11
#define qqReturns                                 12
#define qqSeeAlso                                 13
#define qqFiles                                   14
#define qqArgs                                    15
#define qqDesc                                    16
#define qqExamples                                17
#define qqTests                                   18

#define qqNumVrbls                                18

/*----------------------------------------------------------------------*/

FUNCTION hbide_getSVNHeader()

   RETURN "/* " + hb_eol() + " * $Id: " + "$" + hb_eol() + " */" + hb_eol() + hb_eol()

/*----------------------------------------------------------------------*/

FUNCTION hbide_populateParam( txt_, cToken, cParam )
   LOCAL a_
   IF !empty( cParam )
      aadd( txt_, cToken )
      a_:= hbide_memoToArray( cParam )
      aeval( a_, {|e| aadd( txt_, " *      " + strtran( strtran( e, chr( 13 ), "" ), chr( 10 ), "" ) ) } )
   ENDIF
   RETURN nil

/*----------------------------------------------------------------------*/

FUNCTION hbide_ar2paramList( aArg )
   LOCAL s, cList := ""
   FOR EACH s IN aArg
      s := alltrim( s )
      cList += s + iif( s:__enumIndex() < Len( aArg ), ", ", "" )
   NEXT
   RETURN cList

/*----------------------------------------------------------------------*/

FUNCTION hbide_arg2memo( aArg )
   LOCAL s, cMemo := ""

   FOR EACH s IN aArg
      cMemo += "<" + s + ">" + iif( s:__enumIndex() < Len( aArg ), hb_eol(), "" )
   NEXT

   RETURN cMemo

/*----------------------------------------------------------------------*/

CLASS IdeDocWriter INHERIT IdeObject

   DATA   qHiliter
   DATA   qHiliter1

   DATA   oEdit
   DATA   cFuncPtoto                              INIT ""
   DATA   nFuncLine                               INIT 0
   DATA   nTagsIndex                              INIT 0
   DATA   cSourceFile                             INIT ""

   METHOD new( oIde )
   METHOD create( oIde )
   METHOD destroy()
   METHOD show()
   METHOD execEvent( nMode, p )
   METHOD setImages()
   METHOD installSignals()
   METHOD setParameters()
   METHOD loadCurrentFuncDoc()
   METHOD parsePrototype( cProto )
   METHOD clear()
   METHOD fillForm( aFacts )
   METHOD fillFormByObject( oFunc )
   METHOD buildDocument( lText, hDoc )
   METHOD saveInFunction()
   METHOD saveInDocFile()
   METHOD pullDocFromSource( nLineFrom, oEdit )
   METHOD removeDocHelp( nLineFrom, oEdit )
   METHOD loadFromDocFile( cFile )
   METHOD dispTitle( cTitle )
   METHOD loadAFunction( cName )
   METHOD getTemplateIndex( cTemplate )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:new( oIde )

   ::oIde := oIde

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:create( oIde )

   DEFAULT oIde TO ::oIde
   ::oIde := oIde

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:destroy()

   ::oEdit := NIL

   IF !empty( ::oUI )
      ::oUI:destroy()
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:show()

   IF empty( ::oUI )
      ::oUI := hbide_getUI( "docwriter" )

      ::oDocWriteDock:oWidget:setWidget( ::oUI:oWidget )

      ::setImages()
      ::installSignals()
      ::setParameters()
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:dispTitle( cTitle )

   ::oDocWriteDock:oWidget:setWindowTitle( "Documentation Writer" + iif( Empty( cTitle ), "", ": " + cTitle ) )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:setImages()

   ::oUI:buttonLoadFromDocFile :setIcon( QIcon( hbide_image( "load_3"      ) ) )
   ::oUI:buttonLoadFromSource  :setIcon( QIcon( hbide_image( "load_2"      ) ) )
   ::oUI:buttonLoadFromCurFunc :setIcon( QIcon( hbide_image( "load_1"      ) ) )

   ::oUI:buttonArgs            :setIcon( QIcon( hbide_image( "arguments"   ) ) )
   ::oUI:buttonDesc            :setIcon( QIcon( hbide_image( "description" ) ) )
   ::oUI:buttonExamples        :setIcon( QIcon( hbide_image( "example"     ) ) )

   ::oUI:buttonClear           :setIcon( QIcon( hbide_image( "clean"       ) ) )
   ::oUI:buttonSaveInFunc      :setIcon( QIcon( hbide_image( "unload_1"    ) ) )
   ::oUI:buttonSave            :setIcon( QIcon( hbide_image( "helpdoc"     ) ) )

   ::oUI:buttonCloseArgs       :setIcon( QIcon( hbide_image( "closetab"    ) ) )
   ::oUI:buttonCloseDesc       :setIcon( QIcon( hbide_image( "closetab"    ) ) )
   ::oUI:buttonCloseExamples   :setIcon( QIcon( hbide_image( "closetab"    ) ) )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:installSignals()

   ::oUI:buttonArgs           :connect( "toggled(bool)", {|p| ::execEvent( __buttonArgs_clicked__        , p ) } )
   ::oUI:buttonDesc           :connect( "toggled(bool)", {|p| ::execEvent( __buttonDesc_clicked__        , p ) } )
   ::oUI:buttonExamples       :connect( "toggled(bool)", {|p| ::execEvent( __buttonExample_clicked__     , p ) } )
   ::oUI:buttonCloseArgs      :connect( "clicked()"    , {| | ::execEvent( __buttonCloseArgs_clicked__       ) } )
   ::oUI:buttonCloseDesc      :connect( "clicked()"    , {| | ::execEvent( __buttonCloseDesc_clicked__       ) } )
   ::oUI:buttonCloseExamples  :connect( "clicked()"    , {| | ::execEvent( __buttonCloseExample_clicked__    ) } )
   ::oUI:buttonClear          :connect( "clicked()"    , {| | ::execEvent( __buttonClear_clicked__           ) } )
   ::oUI:buttonSaveInFunc     :connect( "clicked()"    , {| | ::execEvent( __buttonSaveInFunc_clicked__      ) } )
   ::oUI:buttonSave           :connect( "clicked()"    , {| | ::execEvent( __buttonSave_clicked__            ) } )
   ::oUI:buttonLoadFromCurFunc:connect( "clicked()"    , {| | ::execEvent( __buttonLoadFromCurFunc_clicked__ ) } )
   ::oUI:buttonLoadFromDocFile:connect( "clicked()"    , {| | ::execEvent( __buttonLoadFromDocFile_clicked__ ) } )
   ::oUI:comboFunctions       :connect( "currentIndexChanged(QString)", {|p| ::execEvent( __comboFunctions_currentIndexChanged__, p ) } )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:setParameters()

   ::oUI:buttonArgs    :setCheckable( .t. )
   ::oUI:buttonDesc    :setCheckable( .t. )
   ::oUI:buttonExamples:setCheckable( .t. )

   ::oUI:buttonArgs    :setChecked( .t. )
   ::oUI:buttonDesc    :setChecked( .t. )
   ::oUI:buttonExamples:setChecked( .t. )

   //::oUI:frameExamples:hide()

   ::oUI:comboTemplate:addItem( "Function"  )
   ::oUI:comboTemplate:addItem( "Procedure" )
   ::oUI:comboTemplate:addItem( "Class"     )
   ::oUI:comboTemplate:addItem( "Document"  )
   ::oUI:comboTemplate:addItem( "Command"   )
   ::oUI:comboTemplate:addItem( "Run time error" )

   ::qHiliter  := ::oTH:SetSyntaxHilighting( ::oUI:plainExamples, "Pritpal's Favourite" )

   ::oUI:plainExamples:setFont( ::oFont:oWidget )

   ::oUI:frameGeneral:setSizePolicy( QSizePolicy_Preferred, QSizePolicy_Fixed )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:execEvent( nMode, p )

   IF ::lQuitting
      RETURN Self
   ENDIF

   SWITCH nMode
   CASE __buttonArgs_clicked__
      IF p
         ::oUI:frameArgs:show()
      ELSE
         ::oUI:frameArgs:hide()
      ENDIF
      EXIT
   CASE __buttonDesc_clicked__
      IF p
         ::oUI:frameDesc:show()
      ELSE
         ::oUI:frameDesc:hide()
      ENDIF
      EXIT
   CASE __buttonExample_clicked__
      IF p
         ::oUI:frameExamples:show()
      ELSE
         ::oUI:frameExamples:hide()
      ENDIF
      EXIT

   CASE __buttonCloseArgs_clicked__
      ::oUI:buttonArgs:setChecked( .f. )
      EXIT
   CASE __buttonCloseDesc_clicked__
      ::oUI:buttonDesc:setChecked( .f. )
      EXIT
   CASE __buttonCloseExample_clicked__
      ::oUI:buttonExamples:setChecked( .f. )
      EXIT

   CASE __comboFunctions_currentIndexChanged__
      ::loadAFunction( p )
      EXIT
   CASE __buttonLoadFromDocFile_clicked__
      ::loadFromDocFile()
      EXIT
   CASE __buttonLoadFromCurFunc_clicked__
      ::loadCurrentFuncDoc()
      EXIT
   CASE __buttonClear_clicked__
      ::clear()
      EXIT
   CASE __buttonSaveInFunc_clicked__
      ::saveInFunction()
      EXIT
   CASE __buttonSave_clicked__
      ::saveInDocFile()
      EXIT

   ENDSWITCH

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:clear()

   ::oEdit       := NIL
   ::cFuncPtoto  := ""
   ::nFuncLine   := 0
   ::nTagsIndex  := 0
   ::cSourceFile := ""

   ::fillForm()
   ::dispTitle()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:getTemplateIndex( cTemplate )
   LOCAL aTmplt := { "Function", "Procedure", "Class", "Document", "Command", "Run time error" }
   LOCAL nIndex := AScan( aTmplt, cTemplate )

   RETURN iif( nIndex == 0, 0, nIndex - 1 )

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:fillForm( aFacts )

   hb_default( @aFacts,  afill( array( qqNumVrbls ), "" ) )

   ::oUI:editVersion     :setText     ( aFacts[ qqVersion     ] )
   ::oUI:editStatus      :setText     ( aFacts[ qqStatus      ] )
   ::oUI:editCompliance  :setText     ( aFacts[ qqCompliance  ] )
   ::oUI:editPlatforms   :setText     ( aFacts[ qqPlatforms   ] )
   ::oUI:editCategory    :setText     ( aFacts[ qqCategory    ] )
   ::oUI:editSubCategory :setText     ( aFacts[ qqSubCategory ] )
   ::oUI:editName        :setText     ( aFacts[ qqName        ] )
   ::oUI:editExtLink     :setText     ( aFacts[ qqExtLink     ] )
   ::oUI:editOneLiner    :setText     ( aFacts[ qqOneLiner    ] )
   ::oUI:editSyntax      :setPlainText( aFacts[ qqSyntax      ] )
   ::oUI:editReturns     :setPlainText( aFacts[ qqReturns     ] )
   ::oUI:editSeeAlso     :setText     ( aFacts[ qqSeeAlso     ] )
   ::oUI:editFiles       :setPlainText( aFacts[ qqFiles       ] )
   ::oUI:plainArgs       :setPlainText( aFacts[ qqArgs        ] )
   ::oUI:plainDesc       :setPlainText( aFacts[ qqDesc        ] )
   ::oUI:plainExamples   :setPlainText( aFacts[ qqExamples    ] )

   ::oUI:comboTemplate:setCurrentIndex( ::getTemplateIndex( aFacts[ qqVersion ] ) )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:fillFormByObject( oFunc )

   ::oUI:editVersion     :setText(      oFunc:cVersion      )
   ::oUI:editStatus      :setText(      oFunc:cStatus       )
   ::oUI:editCompliance  :setText(      oFunc:cCompliance   )
   ::oUI:editPlatforms   :setText(      oFunc:cPlatForms    )
   ::oUI:editCategory    :setText(      oFunc:cCategory     )
   ::oUI:editSubCategory :setText(      oFunc:cSubCategory  )
   ::oUI:editName        :setText(      oFunc:cName         )
   ::oUI:editExtLink     :setText(      oFunc:cExternalLink )
   ::oUI:editOneLiner    :setText(      oFunc:cOneLiner     )
   ::oUI:editSyntax      :setPlainText( hbide_arrayTOmemo( oFunc:aSyntax      ) )
   ::oUI:editReturns     :setPlainText( hbide_arrayTOmemo( oFunc:aReturns     ) )
   ::oUI:editSeeAlso     :setText(      oFunc:cSeeAlso      )
   ::oUI:editFiles       :setPlainText( hbide_arrayTOmemo( oFunc:aFiles       ) )
   ::oUI:plainArgs       :setPlainText( hbide_arrayTOmemo( oFunc:aArguments   ) )
   ::oUI:plainDesc       :setPlainText( hbide_arrayTOmemo( oFunc:aDescription ) )
   ::oUI:plainExamples   :setPlainText( hbide_arrayTOmemo( oFunc:aExamples    ) )

   ::oUI:comboTemplate:setCurrentIndex( ::getTemplateIndex( oFunc:cTemplate ) )

   IF ::oUI:buttonExamples:isDown()
      ::oUI:buttonExamples:click()
   ENDIF
   IF AScan( oFunc:aExamples, {|e| ! Empty( e ) } ) > 0
      ::oUI:buttonExamples:click()
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:removeDocHelp( nLineFrom, oEdit )
   LOCAL i, cLine, n, lExists, lDone, nFrom, nTo

   n       := 0
   lExists := .f.
   lDone   := .f.

   FOR i := ( nLineFrom - 1 ) TO 1 STEP -1
      cLine := oEdit:getLine( i )

      IF "$END$" $ cLine
         nTo := i + 1
         lExists := .t.
      ENDIF
      IF "$DOC$" $ cLine
         lDone := .t.
         nFrom := i
      ENDIF
      IF ++n > 4 .AND. ! lExists
         EXIT
      ENDIF
      IF lDone
         EXIT
      ENDIF
   NEXT

   IF !empty( nFrom ) .AND. !empty( nTo )
      oEdit:goto( nFrom )
      FOR i := 1 TO ( nTo - nFrom + 1 )
         oEdit:deleteLine()
      NEXT
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:pullDocFromSource( nLineFrom, oEdit )
   LOCAL aDoc, i, cLine, n, lExists, lDone, a_

   aDoc    := {}
   n       := 0
   lExists := .f.
   lDone   := .f.

   FOR i := ( nLineFrom - 1 ) TO 1 STEP -1
      cLine := oEdit:getLine( i )

      IF "$END$" $ cLine
         lExists := .t.
      ENDIF
      IF "$DOC$" $ cLine
         lDone := .t.
      ENDIF

      IF lExists
         aadd( aDoc, cLine )
      ENDIF

      IF ++n > 4 .AND. ! lExists /* Search must terminate after 4 lines if document is not in sight */
         EXIT
      ENDIF
      IF lDone
         EXIT
      ENDIF
   NEXT

   a_:={}
   IF lDone
      FOR i := Len( aDoc ) TO 1 STEP -1
         aadd( a_, aDoc[ i ] )
      NEXT
   ENDIF

   RETURN a_

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:loadCurrentFuncDoc()
   LOCAL oEdit, nCurLine, n, cProto, nProtoLine, aFacts, aDoc, oFunc

   IF !empty( oEdit := ::oEM:getEditObjectCurrent() )
      IF oEdit:isModified()
         MsgBox( oEdit:oEditor:sourceFile + " is modified.", "Please save the source first" )
         RETURN Self
      ENDIF

      IF !empty( ::aTags )
         nCurLine := oEdit:getLineNo()
         IF Len( ::aTags ) == 1
            n := 1
         ELSEIF ( n := ascan( ::aTags, {|e_| e_[ 3 ] >= nCurLine } ) ) == 0
            n := Len( ::aTags )
         ELSEIF n > 0
            n--
         ENDIF
         IF n > 0
            nProtoLine := ::aTags[ n, 3 ]
            cProto := oEdit:getLine( nProtoLine )

            IF ! Empty( aFacts := ::parsePrototype( cProto ) )
               ::clear()
               ::oEdit       := oEdit
               ::cFuncPtoto  := cProto
               ::nFuncLine   := nProtoLine
               ::nTagsIndex  := n
               ::cSourceFile := oEdit:oEditor:sourceFile
               IF Empty( aDoc := ::pullDocFromSource( nProtoLine, oEdit ) )
                  ::fillForm( aFacts )
               ELSE
                  IF !empty( oFunc := ::oHL:getDocFunction( aDoc ) )
                     ::fillFormByObject( oFunc )
                  ELSE
                     ::fillForm( aFacts )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:parsePrototype( cProto )
   LOCAL aFacts, n, n1, cPre, cArg, aArg, cSyn, cTpl, cFun, s

   IF ( n := at( "(", cProto ) ) > 0
      IF ( n1 := at( ")", cProto ) ) > 0
         cPre := alltrim( substr( cProto, 1, n - 1 ) )
         cArg := alltrim( substr( cProto, n + 1, n1 - n - 1 ) )
         aArg := hb_aTokens( cArg, "," )
         FOR EACH s IN aArg
            s := alltrim( s )
         NEXT
         n := rat( " ", cPre )                       /* and it must be */
         cTpl := alltrim( substr( cPre, 1, n - 1 ) )
         cFun := alltrim( substr( cPre, n + 1 ) )

         cSyn := cFun + "( " + hbide_ar2paramList( aArg ) + " )"
         cSyn := strtran( cSyn, "(  )", "()" )

         aFacts := afill( array( qqNumVrbls ), "" )
         cTpl   := lower( cTpl )
         aFacts[ qqTemplate    ] := iif( "comm"   $ cTpl, "Command"  , ;
                                    iif( "doc"    $ cTpl, "Document" , ;
                                    iif( "func"   $ cTpl, "Function" , ;
                                    iif( "proc"   $ cTpl, "Procedure", ;
                                    iif( "class"  $ cTpl, "Class"    , "Function" ) ) ) ) )

         aFacts[ qqVersion     ] := ""
         aFacts[ qqStatus      ] := ""
         aFacts[ qqCompliance  ] := ""
         aFacts[ qqPlatforms   ] := ""
         aFacts[ qqCategory    ] := ""
         aFacts[ qqSubCategory ] := ""
         aFacts[ qqName        ] := upper( cFun ) + "()"
         aFacts[ qqExtLink     ] := ""
         aFacts[ qqOneLiner    ] := ""
         aFacts[ qqSyntax      ] := cSyn
         aFacts[ qqReturns     ] := ""
         aFacts[ qqSeeAlso     ] := ""
         aFacts[ qqFiles       ] := ""
         aFacts[ qqArgs        ] := hbide_arg2memo( aArg )
         aFacts[ qqDesc        ] := ""
         aFacts[ qqExamples    ] := ""
         aFacts[ qqTests       ] := ""

      ENDIF
   ENDIF

   RETURN aFacts

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:saveInFunction()
   LOCAL nCurLine, oEdit, qCursor, a_

   /* Bring it on top and make it current */
   ::oSM:editSource( ::cSourceFile, , , , , , .f. )

   IF !empty( oEdit := ::oEM:getEditObjectCurrent() )
      IF oEdit:lReadOnly
         RETURN Self
      ENDIF

      IF oEdit:isModified()
         MsgBox( oEdit:oEditor:sourceFile + " is modified.", "Please save the source first!" )
         RETURN Self
      ENDIF
      IF oEdit:find( ::cFuncPtoto, 0 )
         nCurLine := oEdit:getLineNo()
         IF nCurLine != ::nFuncLine
            // This is possible user might have edited the source; just issue warning
            MsgBox( "Source is modified, anyway proceeding.", "Documentation Save Alert" )
         ENDIF

         qCursor := oEdit:qEdit:textCursor()
         qCursor:beginEditBlock()

         ::removeDocHelp( nCurLine, oEdit )

         a_:= ::buildDocument( .T. )

         oEdit:home()
         oEdit:insertText( a_ )

         qCursor:endEditBlock()
         oEdit:qEdit:setTextCursor( qCursor )
         oEdit:qEdit:centerCursor()
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:loadFromDocFile( cFile )
   LOCAL hFile, hDoc, cBuffer

   IF Empty( cFile ) .OR. ! hb_FileExists( cFile )
      cFile := hbide_fetchAFile( ::oDlg, "Select a document(.txt) file", , hbide_SetWrkFolderLast() )
   ENDIF
   IF Empty( cFile )
      RETURN NIL
   ENDIF
   hbide_SetWrkFolderLast( cFile )

   ::cSourceFile := cFile
   ::dispTitle( cFile )

   cBuffer := hb_MemoRead( cFile )
   hFile := __hbdoc_FromSource( cBuffer )

   ::oUI:comboFunctions:clear()
   FOR EACH hDoc IN hFile
      IF "NAME" $ hDoc
         ::oUI:comboFunctions:addItem( hDoc[ "NAME" ] )
      ENDIF
   NEXT
   ::oUI:comboFunctions:setCurrentIndex( 0 )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:loadAFunction( cName )
   LOCAL cBuffer, hFile, oFunc, hDoc

   IF ! Empty( cName )
      cBuffer := hb_MemoRead( ::cSourceFile )
      hFile := __hbdoc_FromSource( cBuffer )

      FOR EACH hDoc IN hFile
         IF "NAME" $ hDoc .AND. cName == hDoc[ "NAME" ]
            oFunc := hbide_getFuncObjectFromHash( hDoc )
            EXIT
         ENDIF
      NEXT
   ENDIF

   IF ! Empty( oFunc )
      ::fillFormByObject( oFunc )
   ELSE
      ::fillForm()
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:saveInDocFile()
   LOCAL cFile, cBuffer, hNewDoc, hDoc, cName, hFile, cFiltered, hD
   LOCAL cTmplt  := ::oUI:comboTemplate:currentText()
   LOCAL cPrefix := Lower( AllTrim( Left( cTmplt, 3 ) ) )
   LOCAL lFound  := .F.

   cName   := lower( Trim( ::oUI:editName:text() ) )
   cFile   := ::cSourceFile
   IF Empty( cFile ) .OR. Lower( hb_fNameExt( cFile ) ) != ".txt"
      cFile := cPrefix + alltrim( strtran( strtran( cName, "(" ), ")" ) ) + ".txt"
   ENDIF
   cFile := hbide_saveAFile( ::oDlg, "Provide filename to save documentation", ;
                                    { { "Harbour Documentation File", "*.txt" } }, cFile, "txt" )

   IF ! Empty( cFile )
      cFile := hbide_pathToOsPath( cFile )

      cBuffer := hb_MemoRead( cFile )
      hFile := __hbdoc_FromSource( cBuffer )
      cFiltered := hbide_stripTrailingBlanks( __hbdoc_FilterOut( cBuffer ) )
      FOR EACH hDoc IN hFile
         IF "NAME" $ hDoc .AND. cName == Lower( hDoc[ "NAME" ] )
            hD := hDoc
            lFound := .T.
            EXIT
         ENDIF
      NEXT
      hNewDoc := ::buildDocument( .F., iif( lFound, hD, {=>} ) )
      IF ! lFound
         AAdd( hFile, hNewDoc )
      ELSE
         FOR EACH hDoc IN hFile
            IF "NAME" $ hDoc .AND. cName == Lower( hDoc[ "NAME" ] )
               hDoc := hNewDoc
               EXIT
            ENDIF
         NEXT
      ENDIF

      IF Empty( cFiltered )
         cFiltered := hbide_getSVNHeader()
      ENDIF
      hb_memowrit( cFile, cFiltered + hb_eol() + __hbdoc_ToSource( hFile ) )

      ::cSourceFile := cFile
      ::dispTitle( cFile )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD IdeDocWriter:buildDocument( lText, hDoc )
   LOCAL s
   LOCAL cTemplate := ::oUI:comboTemplate:currentText()
   LOCAL hEntry := { => }

   hb_HKeepOrder( hEntry, .T. )

   hEntry[ "TEMPLATE" ] := iif( Empty( cTemplate ), "Function", cTemplate )
   IF !empty( s := ::oUI:editName:text() ) .OR. "NAME" $ hDoc
      hEntry[ "NAME"         ] := s
   ENDIF
   IF !empty( s := ::oUI:editCategory:text() ) .OR. "CATEGORY" $ hDoc
      hEntry[ "CATEGORY"     ] := s
   ENDIF
   IF !empty( s := ::oUI:editSubCategory:text() ) .OR. "SUBCATEGORY" $ hDoc
      hEntry[ "SUBCATEGORY"  ] := s
   ENDIF
   IF !empty( s := ::oUI:editExtLink:text() ) .OR. "EXTERNALLINK" $ hDoc
      hEntry[ "EXTERNALLINK" ] := s
   ENDIF
   IF !empty( s := ::oUI:editOneLiner:text() ) .OR. "ONELINER" $ hDoc
      hEntry[ "ONELINER"     ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:editSyntax    : toPlainText() ) ) .OR. "SYNTAX" $ hDoc
      hEntry[ "SYNTAX"       ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:plainArgs     : toPlainText() ) ) .OR. "ARGUMENTS" $ hDoc
      hEntry[ "ARGUMENTS"    ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:editReturns   : toPlainText() ) ) .OR. "RETURNS" $ hDoc
      hEntry[ "RETURNS"      ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:plainDesc     : toPlainText() ) ) .OR. "DESCRIPTION" $ hDoc
      hEntry[ "DESCRIPTION"  ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:plainExamples : toPlainText() ) ) .OR. "EXAMPLES" $ hDoc
      hEntry[ "EXAMPLES"     ] := s
   ENDIF
   IF !empty( s := ::oUI:editStatus:text() ) .OR. "STATUS" $ hDoc
      hEntry[ "STATUS"       ] := s
   ENDIF
   IF !empty( s := ::oUI:editCompliance:text() ) .OR. "COMPLIANCE" $ hDoc
      hEntry[ "COMPLIANCE"   ] := s
   ENDIF
   IF !empty( s := ::oUI:editPlatforms:text() ) .OR. "PLATFORMS" $ hDoc
      hEntry[ "PLATFORMS"    ] := s
   ENDIF
   IF !empty( s := ::oUI:editVersion:text() ) .OR. "VERSION" $ hDoc
      hEntry[ "VERSION"      ] := s
   ENDIF
   IF !empty( s := hbide_stripTrailingBlanks( ::oUI:editFiles    : toPlainText() ) ) .OR. "FILES" $ hDoc
      hEntry[ "FILES"        ] := s
   ENDIF
   IF !empty( s := ::oUI:editSeeAlso:text() ) .OR. "SEEALSO" $ hDoc
      hEntry[ "SEEALSO"      ] := s
   ENDIF

   RETURN iif( lText, hbide_stripPreceedingBlanks( hbide_stripTrailingBlanks( __hbdoc_ToSource( { hEntry } ) ) ), hEntry )

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbide_stripTrailingBlanks( cMemo )

   DO WHILE .T.
      cMemo := RTrim( cMemo )
      IF Right( cMemo, 2 ) == Chr( 13 ) + Chr( 10 )
         cMemo := SubStr( cMemo, 1, Len( cMemo ) - 2 )
      ELSEIF Right( cMemo, 1 ) == Chr( 10 )
         cMemo := SubStr( cMemo, 1, Len( cMemo ) - 1 )
      ELSE
         EXIT
      ENDIF
   ENDDO

   RETURN cMemo

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbide_stripPreceedingBlanks( cMemo )

   DO WHILE .T.
      cMemo := LTrim( cMemo )
      IF Left( cMemo, 2 ) == Chr( 13 ) + Chr( 10 )
         cMemo := SubStr( cMemo, 3 )
      ELSEIF Left( cMemo, 1 ) == Chr( 10 )
         cMemo := SubStr( cMemo, 2 )
      ELSE
         EXIT
      ENDIF
   ENDDO

   RETURN cMemo

/*----------------------------------------------------------------------*/
