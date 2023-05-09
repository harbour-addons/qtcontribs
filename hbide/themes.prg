                                    /*
 * $Id$
 */

/*
 * Copyright 2009-2023 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               31Dec2009
 */
/*----------------------------------------------------------------------*/

#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"
#include "hbide.ch"


#define THM_ATR_R                                 1
#define THM_ATR_G                                 2
#define THM_ATR_B                                 3
#define THM_ATR_ITALIC                            4
#define THM_ATR_BOLD                              5
#define THM_ATR_ULINE                             6

#define THM_NUM_ATTRBS                            6


#define __listThemes_currentRowChanged__          2001
#define __listItems_currentRowChanged__           2002
#define __applyMenu_triggered_applyToCurrentTab__ 2003
#define __applyMenu_triggered_applyToAllTabs__    2004
#define __applyMenu_triggered_setAsDefault__      2005


CLASS IdeThemes INHERIT IdeObject

   VAR    lDefault                                INIT .t.
   VAR    cThemesFile                             INIT ""
   VAR    aIni                                    INIT {}
   VAR    aThemes                                 INIT {}
   VAR    aControls                               INIT {}
   VAR    aItems                                  INIT {}
   VAR    aPatterns                               INIT {}
   VAR    aApplyAct                               INIT {}
   VAR    nCurTheme                               INIT 1
   VAR    nCurItem                                INIT 1
   VAR    qEdit
   VAR    oEdit
   VAR    qHiliter
   VAR    qMenuApply
   VAR    lCreating                               INIT .f.
   VAR    oSL
   VAR    cSelTheme
   VAR    oStrList
   VAR    oStrModel

   METHOD init( oIde, cThemesFile )
   METHOD create( oIde, cThemesFile )
   METHOD destroy()
   METHOD setWrkTheme( cTheme )
   METHOD contains( cTheme )
   METHOD load( cFile )
   METHOD save( lAsk )
   METHOD execEvent( nEvent, p )
   METHOD getThemeAttribute( cAttr, cTheme )
   METHOD buildSyntaxFormat( aAttr )
   METHOD setForeBackGround( qEdit, cTheme )
   METHOD setQuotesRule( qHiliter, cTheme )
   METHOD setMultiLineCommentRule( qHiliter, cTheme )
   METHOD setSingleLineCommentRule( qHiliter, cTheme )
   METHOD setSyntaxRule( qHiliter, cName, cPattern, lCaseSensitive, aAttr )
   METHOD setSyntaxFormat( qHiliter, cName, aAttr )
   METHOD setSyntaxHilighting( qEdit, cTheme, lNew, lSetEditor )
   METHOD changeSyntaxHilighting( qEdit, cTheme, qHiliter )
   METHOD show()
   METHOD copy()
   METHOD setTheme()
   METHOD setAttributes()
   METHOD updateColor()
   METHOD updateAttribute( nAttr, iState )
   METHOD selectTheme()
   METHOD selectThemeProc( nMode, p )
   METHOD buildINI()
   METHOD parseINI( lAppend )
   METHOD updateLineNumbersBkColor()
   METHOD updateCurrentLineColor()
   METHOD mergeUserDictionaries( qHiliter, cTheme )
   METHOD getThemesList()                         INLINE ::aThemes

   ENDCLASS


METHOD IdeThemes:init( oIde, cThemesFile )
   ::oIde  := oIde
   ::cThemesFile := cThemesFile
   RETURN Self


METHOD IdeThemes:destroy()
   IF !empty( ::oSL )
      WITH OBJECT ::oSL
         :listOptions  :disConnect( "doubleClicked(QModelIndex)" )
         :buttonOk     :disConnect( "clicked()" )
         :buttonCancel :disConnect( "clicked()" )
         :destroy()
      ENDWITH
   ENDIF
   ::aIni        := NIL
   ::aThemes     := NIL
   ::aControls   := NIL
   ::aItems      := NIL
   ::aPatterns   := NIL
   ::aApplyAct   := NIL
   IF !empty( ::oUI )
      WITH OBJECT ::oUI
         :listThemes    :disconnect( "currentRowChanged(int)" )
         :listItems     :disconnect( "currentRowChanged(int)" )
         :buttonColor   :disconnect( "clicked()"              )
         :buttonSave    :disconnect( "clicked()"              )
         :buttonSaveAs  :disconnect( "clicked()"              )
         :buttonCopy    :disconnect( "clicked()"              )
         :buttonApply   :disconnect( "clicked()"              )
         :buttonApplyAll:disconnect( "clicked()"              )
         :buttonDefault :disconnect( "clicked()"              )
         :checkItalic   :disconnect( "stateChanged(int)"      )
         :checkBold     :disconnect( "stateChanged(int)"      )
         :checkUnderline:disconnect( "stateChanged(int)"      )
         :buttonClose   :disconnect( "clicked()"              )
      ENDWITH
      ::qHiliter := NIL
      ::qEdit    := NIL
      ::oUI:destroy()
   ENDIF
   RETURN Self


METHOD IdeThemes:create( oIde, cThemesFile )
   LOCAL s, b_
   IF .T.
      DEFAULT oIde     TO ::oIde
      DEFAULT cThemesFile TO ::cThemesFile
   ENDIF
   ::oIde  := oIde
   ::cThemesFile := cThemesFile
   /* next always load default themes */
   ::aIni := hbide_loadDefaultThemes()
   ::parseINI()
   /* first load user defined themes */
   ::load( ::cThemesFile )
   /* These are the supported patterns - rest will be ignore until implemented */
   //
   /* Compiler Directives */
   b_:= { "include","define","if","ifndef","ifdef","else","endif","command","xcommand","translate","xtranslate" }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "#" + e + "\b" } )
   aadd( ::aPatterns, { "PreprocessorDirectives", s, .f. } )
   
   /* Harbour Keywords */
   b_:= { "next","function","procedure","thread","return","static","local","default", ;
          "if","else","elseif","endif","end", ;
          "docase","case","endcase","otherwise", ;
          "switch","endswitch", ;
          "do","while","exit","enddo","loop",;
          "for","each","next","step","to","in",;
          "with","replace","object","endwith","request",;
          "nil","and","or","in","not","self",;
          "class","endclass","method","data","var","destructor","inline","assign","access",;
          "inherit","init","create","virtual","message", "from", "setget",;
          "begin","sequence","try","catch","always","recover","hb_symbol_unused", ;
          "error","handler","private","protected","public","memvar" }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "\b" + e + "\b" } )
   aadd( ::aPatterns, { "HarbourKeywords"   , s, .f. } )

   /* C Language Keywords - Only for C or CPP sources - mutually exclusive with Harbour Sources */
   b_:= { "char", "class", "const", "double", "enum", "explicit", "friend", "inline", ;
          "int",  "long", "namespace", "operator", "private", "protected", "public", ;
          "short", "signals", "signed", "slots", "static", "struct", "template", ;
          "typedef", "typename", "union", "unsigned", "virtual", "void", "volatile" }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "\b" + e + "\b" } )
   aadd( ::aPatterns, { "CLanguageKeywords" , s                       , .t. } )

   s := "\:\=|\:|\+|\-|\\|\*|\=|\>|\<|\^|\%|\$|\&|\@|\!"
   aadd( ::aPatterns, { "Operators"         , s                       , .f. } )
   aadd( ::aPatterns, { "NumericalConstants", "\b[0-9.]+\b"           , .f. } )
   aadd( ::aPatterns, { "BracketsAndBraces" , "\(|\)|\{|\}|\[|\]|\|"  , .f. } )
   aadd( ::aPatterns, { "FunctionsBody"     , "\b[A-Za-z0-9_]+(?=\()" , .f. } )
   //
   RETURN Self


METHOD IdeThemes:execEvent( nEvent, p )
   LOCAL oEditor, a_
   HB_SYMBOL_UNUSED( p )
   IF ::lQuitting
      RETURN Self
   ENDIF
   SWITCH nEvent
   CASE __listItems_currentRowChanged__
      ::nCurItem  := p+1
      IF ::nCurItem == 13
         ::updateCurrentLineColor()
      ELSEIF ::nCurItem == 16
         ::updateLineNumbersBkColor()
      ELSE
         ::setAttributes( p )
      ENDIF
      EXIT
   CASE __listThemes_currentRowChanged__
      ::nCurTheme := p+1
      ::setTheme( p )
      EXIT
   CASE __applyMenu_triggered_applyToAllTabs__
      FOR EACH a_ IN ::aTabs
         a_[ TAB_OEDITOR ]:applyTheme( ::aThemes[ ::nCurTheme, 1 ] )
      NEXT
      EXIT
   CASE __applyMenu_triggered_applyToCurrentTab__
      IF !empty( oEditor := ::oEM:getEditorCurrent() )
         oEditor:applyTheme( ::aThemes[ ::nCurTheme, 1 ] )
      ENDIF
      EXIT
   CASE __applyMenu_triggered_setAsDefault__
      ::setWrkTheme( ::aThemes[ ::nCurTheme, 1 ] )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD IdeThemes:setWrkTheme( cTheme )
   IF empty( cTheme )
      cTheme := ::selectTheme()
   ENDIF
   IF !empty( cTheme )
      ::oIde:cWrkTheme := cTheme
      ::oDK:setStatusText( SB_PNL_THEME, ::cWrkTheme )
   ENDIF
   RETURN Self


METHOD IdeThemes:contains( cTheme )
   RETURN ascan( ::aThemes, {|a_| a_[ 1 ] == cTheme } ) > 0


METHOD IdeThemes:load( cFile )
   IF HB_ISSTRING( cFile ) .AND. !empty( cFile ) .AND. hb_FileExists( cFile )
      ::aIni:= hbide_readSource( cFile )
      ::parseINI()
      ::lDefault := .f.
   ENDIF
   RETURN Self


METHOD IdeThemes:save( lAsk )
   LOCAL cFile
   DEFAULT lAsk TO .f.
   IF ::lDefault
      lAsk := .t.
   ENDIF
   IF lAsk
      cFile := hbide_saveAFile( ::oDlg, "Select a file to Save Theme ( .hbt )", ;
                                         { { "Syntax Themes", "*.hbt" } }, ::oINI:getThemesFile(), "hbt"  )
   ELSE
      cFile := ::oINI:getThemesFile()
   ENDIF
   IF !empty( cFile )
      hb_memowrit( cFile, ::buildINI() )
   ENDIF
   RETURN Self


METHOD IdeThemes:getThemeAttribute( cAttr, cTheme )
   LOCAL nTheme, aAttr := {}
   IF !empty( cAttr )
      IF !empty( cTheme ) .and. HB_ISSTRING( cTheme ) .and. ( nTheme := ascan( ::aThemes, {|e_| e_[ 1 ] == cTheme } ) ) > 0
         aAttr := GetKeyValue( ::aThemes[ nTheme, 2 ], cAttr )
      ENDIF
   ENDIF
   RETURN aAttr


METHOD IdeThemes:buildSyntaxFormat( aAttr )
   LOCAL qFormat
   WITH OBJECT qFormat := QTextCharFormat()
      :setFontItalic( aAttr[ THM_ATR_ITALIC ] )
      IF aAttr[ THM_ATR_BOLD ]
         :setFontWeight( 1000 )
      ENDIF
      :setFontUnderline( aAttr[ THM_ATR_ULINE ] )
      :setForeground( QBrush( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) ) )
   ENDWITH
   RETURN qFormat


METHOD IdeThemes:setForeBackGround( qEdit, cTheme )
   LOCAL aAttr, s
   IF !empty( aAttr := ::getThemeAttribute( "Background", cTheme ) )
      s := 'QPlainTextEdit { background-color: rgba( ' + Attr2StrRGB( aAttr ) +", 255 ); "
      aAttr := ::getThemeAttribute( "UnrecognizedText", cTheme )
      s += ' color:   rgba( ' +  Attr2StrRGB( aAttr ) + ", 255 ); "
      s += ' border:  0px; '
      s += ' padding: 0px; '
      s += ' margin:  0px; }'
      qEdit:setStyleSheet( s )
   ENDIF
   RETURN Self


METHOD IdeThemes:setQuotesRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "TerminatedStrings", cTheme ) )
      qHiliter:hbSetFormat( "TerminatedStrings", ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD IdeThemes:setSingleLineCommentRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "CommentsAndRemarks", cTheme ) )
      qHiliter:hbSetSingleLineCommentFormat( ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD IdeThemes:setMultiLineCommentRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "CommentsAndRemarks", cTheme ) )
      qHiliter:hbSetMultiLineCommentFormat( ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD IdeThemes:setSyntaxRule( qHiliter, cName, cPattern, lCaseSensitive, aAttr )
   LOCAL qRegExp := QRegExp()
   WITH OBJECT qRegExp
      :setCaseSensitivity( iif( lCaseSensitive, Qt_CaseSensitive, Qt_CaseInsensitive ) )
      :setPattern( cPattern )
   ENDWITH
   qHiliter:hbSetRuleWithRegExp( cName, qRegExp, ::buildSyntaxFormat( aAttr ) )
   RETURN Self


METHOD IdeThemes:setSyntaxFormat( qHiliter, cName, aAttr )
   qHiliter:hbSetFormat( cName, ::buildSyntaxFormat( aAttr ) )
   RETURN Self


METHOD IdeThemes:setSyntaxHilighting( qEdit, cTheme, lNew, lSetEditor )
   LOCAL a_, aAttr, qHiliter
   IF .T.
      DEFAULT lNew       TO .F.                      /* Apply one which is already formed */
      DEFAULT lSetEditor TO .T.
   ENDIF
   IF empty( cTheme )
      cTheme := ::cWrkTheme
   ENDIF
   IF empty( cTheme )
      cTheme := "Bare Minimum"                    /* "Pritpal's Favourite" */
   ENDIF
   ::setForeBackGround( qEdit, cTheme )
   qHiliter := HBQSyntaxHighlighter( qEdit:document() )
   FOR EACH a_ IN ::aPatterns
      IF !empty( aAttr := ::getThemeAttribute( a_[ 1 ], cTheme ) )
         ::setSyntaxRule( qHiliter, a_[ 1 ], a_[ 2 ], a_[ 3 ], aAttr )
      ENDIF
   NEXT
   IF .T.
      ::mergeUserDictionaries( qHiliter, cTheme )
      ::setMultiLineCommentRule( qHiliter, cTheme )
      ::setSingleLineCommentRule( qHiliter, cTheme )
      ::setQuotesRule( qHiliter, cTheme )
   ENDIF
   IF __ObjGetClsName( qEdit ) == "HBQPLAINTEXTEDIT"
      IF !empty( aAttr := ::getThemeAttribute( "CurrentLineBackground", cTheme ) )
         qEdit:hbSetCurrentLineColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      IF !empty( aAttr := ::getThemeAttribute( "LineNumbersBkColor", cTheme ) )
         qEdit:hbSetLineAreaBkColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      IF !empty( aAttr := ::getThemeAttribute( "SelectionBackground", cTheme ) )
         qEdit:hbSetSelectionColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      qEdit:hbSetHighLighter( qHiliter )
      IF lSetEditor
         qHiliter:hbSetEditor( qEdit )
      ENDIF
   ENDIF
   RETURN qHiliter


METHOD IdeThemes:changeSyntaxHilighting( qEdit, cTheme, qHiliter )
   LOCAL a_, aAttr
   qHiliter:hbClear()
   ::setForeBackGround( qEdit, cTheme )
   FOR EACH a_ IN ::aPatterns
      IF !empty( aAttr := ::getThemeAttribute( a_[ 1 ], cTheme ) )
         ::setSyntaxRule( qHiliter, a_[ 1 ], a_[ 2 ], a_[ 3 ], aAttr )
      ENDIF
   NEXT
   IF .T.
      ::mergeUserDictionaries( qHiliter, cTheme )
      ::setMultiLineCommentRule( qHiliter, cTheme )
      ::setSingleLineCommentRule( qHiliter, cTheme )
      ::setQuotesRule( qHiliter, cTheme )
   ENDIF
   IF __ObjGetClsName( qEdit ) == "HBQPLAINTEXTEDIT"
      IF !empty( aAttr := ::getThemeAttribute( "CurrentLineBackground", cTheme ) )
         qEdit:hbSetCurrentLineColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      IF !empty( aAttr := ::getThemeAttribute( "LineNumbersBkColor", cTheme ) )
         qEdit:hbSetLineAreaBkColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      IF !empty( aAttr := ::getThemeAttribute( "SelectionBackground", cTheme ) )
         qEdit:hbSetSelectionColor( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) )
      ENDIF
      qEdit:hbHighlightPage()
   ENDIF
   RETURN NIL


METHOD IdeThemes:mergeUserDictionaries( qHiliter, cTheme )
   LOCAL oDict, s, aAttr, qFormat, qRegExp, cName, a_
   FOR EACH oDict IN ::oIde:aUserDict
      IF oDict:lActive .AND. ! empty( oDict:hItems )
         cName := "UserDictionary" + hb_ntos( oDict:__enumIndex() )
         s := ""
         FOR EACH a_ IN oDict:hItems
            s += "\b" + a_[ 1 ] + "\b|"
         NEXT
         s := substr( s, 1, Len( s ) - 1 )
         WITH OBJECT qRegExp := QRegExp()
            :setCaseSensitivity( iif( oDict:lCaseSens, Qt_CaseSensitive, Qt_CaseInsensitive ) )
            :setPattern( s )
         ENDWITH 
         /* Must be blended WITH dictionary definition attributes */
         aAttr := ::getThemeAttribute( "UserDictionary", cTheme )  // cName after slots are implemented
         //
         WITH OBJECT qFormat := QTextCharFormat()
            :setFontItalic( oDict:lItalic )
            IF oDict:lBold
               :setFontWeight( 1000 )
            ENDIF
            :setFontUnderline( oDict:lULine )
            IF ! empty( oDict:aTxtRGB )
               :setForeground( QBrush( QColor( oDict:aTxtRGB[ 1 ], oDict:aTxtRGB[ 2 ], oDict:aTxtRGB[ 3 ] ) ) )
            ELSE
               IF ! Empty( aAttr )
                  :setForeground( QBrush( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) ) )
               ENDIF
            ENDIF
            IF ! empty( oDict:aBgRGB )
               :setBackground( QBrush( QColor( oDict:aBgRGB[ 1 ], oDict:aBgRGB[ 2 ], oDict:aBgRGB[ 3 ] ) ) )
            ENDIF
         ENDWITH 
         //
         qHiliter:hbSetRuleWithRegExp( cName, qRegExp, qFormat )
      ENDIF
   NEXT
   RETURN Self


METHOD IdeThemes:show()
   IF empty( ::oUI )
      ::lCreating := .t.
      WITH OBJECT ::oUI := hbide_getUI( "themesex" )
         ::oThemesDock:oWidget:setWidget( :oWidget )
         //
         :listThemes    :connect( "currentRowChanged(int)"  , {|i| ::execEvent( __listThemes_currentRowChanged__, i ) } )
         :listItems     :connect( "currentRowChanged(int)"  , {|i| ::execEvent( __listItems_currentRowChanged__, i )  } )
         :buttonColor   :connect( "clicked()"               , {| | ::updateColor() } )
         :buttonSave    :connect( "clicked()"               , {| | ::save( .f. )   } )
         :buttonSaveAs  :connect( "clicked()"               , {| | ::save( .t. )   } )
         :buttonCopy    :connect( "clicked()"               , {| | ::copy( .t. )   } )
         :buttonApply   :connect( "clicked()"               , {| | ::execEvent( __applyMenu_triggered_applyToCurrentTab__ ) } )
         :buttonApplyAll:connect( "clicked()"               , {| | ::execEvent( __applyMenu_triggered_applyToAllTabs__    ) } )
         :buttonDefault :connect( "clicked()"               , {| | ::execEvent( __applyMenu_triggered_setAsDefault__      ) } )
         :checkItalic   :connect( "stateChanged(int)"       , {|i| ::updateAttribute( THM_ATR_ITALIC, i ) } )
         :checkBold     :connect( "stateChanged(int)"       , {|i| ::updateAttribute( THM_ATR_BOLD  , i ) } )
         :checkUnderline:connect( "stateChanged(int)"       , {|i| ::updateAttribute( THM_ATR_ULINE , i ) } )
         :buttonClose   :connect( "clicked()"               , {| | ::oThemesDock:hide() } )
         /* Fill Themes Dialog Values */
         :setWindowTitle( GetKeyValue( ::aControls, "dialogTitle" ) )
         //   
         :checkItalic    :setText( GetKeyValue( ::aControls, "checkItalic"   , "Italic"    ) )
         :checkBold      :setText( GetKeyValue( ::aControls, "checkBold"     , "Bold"      ) )
         :checkUnderline :setText( GetKeyValue( ::aControls, "checkUnderline", "Underline" ) )
         :buttonColor    :setText( GetKeyValue( ::aControls, "buttonColor"   , "Color"     ) )
         :buttonSave     :setText( GetKeyValue( ::aControls, "buttonSave"    , "Save"      ) )
         :buttonSaveAs   :setText( GetKeyValue( ::aControls, "buttonSaveAs"  , "SaveAs"    ) )
         :buttonClose    :setText( GetKeyValue( ::aControls, "buttonClose"   , "Close"     ) )
         :buttonCopy     :setText( GetKeyValue( ::aControls, "buttonCopy"    , "Copy"      ) )
         //
         ::qEdit := :plainThemeText
         WITH OBJECT ::oEdit := HbQtEditor():new()
            :qEdit := ::qEdit
            :create()
         ENDWITH 
         WITH OBJECT ::qEdit
            :setPlainText( GetSource() )
            :setLineWrapMode( QTextEdit_NoWrap )
            :setFont( ::oIde:oFont:oWidget )
            :ensureCursorVisible()
            :setFocusPolicy( Qt_NoFocus )
         ENDWITH
         aeval( ::aThemes, {|e_| ::oUI:listThemes:addItem( e_[ 1 ] ) } )
         aeval( ::aItems , {|e_| ::oUI:listItems:addItem( e_[ 2 ] )  } )
         WITH OBJECT :listThemes()
            :setCurrentRow( 0 )
            :setCurrentRow( 0 )
         ENDWITH
      ENDWITH
      ::lCreating := .f.
      ::setTheme()
   ENDIF
   IF .T.
      ::qEdit:hbHighlightPage()
   ENDIF
   RETURN Self


METHOD IdeThemes:setTheme()
   IF ! ::lCreating
      ::qHiliter := ::setSyntaxHilighting( ::qEdit, ::aThemes[ ::nCurTheme, 1 ], .t., .t. )
      ::setAttributes()
      ::qHiliter:hbSetInitialized( .t. )
      ::setAttributes()
      ::qEdit:hbHighlightPage()
   ENDIF
   RETURN Self


METHOD IdeThemes:setAttributes()
   LOCAL aAttr
   IF ! ::lCreating
      aAttr := ::aThemes[ ::nCurTheme, 2, ::nCurItem, 2 ]
      WITH OBJECT ::oUI
         :checkItalic    :setChecked( aAttr[ THM_ATR_ITALIC ] )
         :checkBold      :setChecked( aAttr[ THM_ATR_BOLD   ] )
         :checkUnderline :setChecked( aAttr[ THM_ATR_ULINE  ] )
         :buttonColor    :setStyleSheet( "color: " + Attr2RGBfnRev( aAttr ) + ";" + ;
                                   "background-color: " + Attr2RGBfn( aAttr ) + ";" )
      ENDWITH
   ENDIF
   RETURN Self


METHOD IdeThemes:updateLineNumbersBkColor()
   LOCAL aAttr
   IF ! Empty( aAttr := ::getThemeAttribute( "LineNumbersBkColor", ::aThemes[ ::nCurTheme, 1 ] ) )
      ::oEdit:setLineNumbersBkColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] )
   ENDIF
   ::setAttributes()
   ::oEdit:refresh()
   RETURN Self


METHOD IdeThemes:updateCurrentLineColor()
   LOCAL aAttr
   IF ! Empty( aAttr := ::getThemeAttribute( "CurrentLineBackground", ::aThemes[ ::nCurTheme, 1 ] ) )
      ::oEdit:setCurrentLineColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] )
   ENDIF
   ::setAttributes()
   ::oEdit:refresh()
   RETURN Self


METHOD IdeThemes:updateColor()
   LOCAL aAttr, oDlg, qColor, s, aF, aB
   aAttr := ::aThemes[ ::nCurTheme, 2, ::nCurItem ]
   qColor := QColor( aAttr[ 2, THM_ATR_R ], aAttr[ 2, THM_ATR_G ], aAttr[ 2, THM_ATR_B ] )
   WITH OBJECT oDlg := QColorDialog( ::oUI:oWidget )
      :setWindowTitle( "Select a Color" )
      :setCurrentColor( qColor )
      :exec()
   ENDWITH 
   qColor := oDlg:currentColor()
   ::aThemes[ ::nCurTheme, 2, ::nCurItem, 2, THM_ATR_R ] := qColor:red()
   ::aThemes[ ::nCurTheme, 2, ::nCurItem, 2, THM_ATR_G ] := qColor:green()
   ::aThemes[ ::nCurTheme, 2, ::nCurItem, 2, THM_ATR_B ] := qColor:blue()
   IF aAttr[ 1 ] $ "Background,UnrecognizedText"
      aF := GetKeyValue( ::aThemes[ ::nCurTheme, 2 ], "UnrecognizedText" )
      aB := GetKeyValue( ::aThemes[ ::nCurTheme, 2 ], "Background"       )
      //
      s := "QPlainTextEdit { "
      s += "           color: rgba( " + Attr2StrRGB( aF ) + ", 255 );  "
      s += "background-color: rgba( " + Attr2StrRGB( aB ) + ", 255 ); }"
      //
      ::qEdit:setStyleSheet( s )
   ELSEIF aAttr[ 1 ] == "CommentsAndRemarks"
      ::setMultiLineCommentRule( ::qHiliter, ::aThemes[ ::nCurTheme, 1 ] )
      ::setSyntaxFormat( ::qHiliter, aAttr[ 1 ], aAttr[ 2 ] )
   ELSEIF aAttr[ 1 ] == "CurrentLineBackground"
      ::updateCurrentLineColor()
      RETURN Self
   ELSEIF aAttr[ 1 ] == "LineNumbersBkColor"
      ::updateLineNumbersBkColor()
      RETURN Self
   ELSE
      ::setSyntaxFormat( ::qHiliter, aAttr[ 1 ], aAttr[ 2 ] )
   ENDIF
   ::qHiliter:rehighlight()
   ::setAttributes()
   RETURN Self


METHOD IdeThemes:updateAttribute( nAttr, iState )
   LOCAL aAttr := ::aThemes[ ::nCurTheme, 2, ::nCurItem ]
   IF .T.
      ::aThemes[ ::nCurTheme, 2, ::nCurItem, 2, nAttr ] := ( iState == 2 )
      ::setSyntaxFormat( ::qHiliter, aAttr[ 1 ], aAttr[ 2 ] )
      ::qHiliter:rehighlight()
   ENDIF
   RETURN Self


METHOD IdeThemes:selectTheme()
   LOCAL a_, nDone
   IF empty( ::oSL )
      WITH OBJECT ::oSL := hbide_getUI( "selectionlist", ::oIde:oDlg:oWidget )
         :setWindowTitle( "Available Themes" )
         :connect( QEvent_Close                , {|| ::oSL:hide()               } )
         :listOptions :connect( "doubleClicked(QModelIndex)", {|p| ::selectThemeProc( 1, p ) } )
         :buttonOk    :connect( "clicked()"                 , {|p| ::selectThemeProc( 2, p ) } )
         :buttonCancel:connect( "clicked()"                 , {|p| ::selectThemeProc( 3, p ) } )
         //
         ::oStrList := QStringList()
         ::oStrModel := QStringListModel()
         ::oStrModel:setStringList( ::oStrList )
         :listOptions:setModel( ::oStrModel )
      ENDWITH 
   ENDIF
   //
   ::oStrList:clear()
   FOR EACH a_ IN ::aThemes
      ::oStrList:append( a_[ 1 ] )
   NEXT
   ::oStrModel:setStringList( ::oStrList )
   IF .T. 
      nDone := ::oSL:exec()
   ENDIF 
   RETURN iif( nDone == 1, ::cSelTheme, "" )


METHOD IdeThemes:selectThemeProc( nMode, p )
   LOCAL qModalIndex
   DO CASE
   CASE nMode == 1
      ::cSelTheme := ::aThemes[ p:row() + 1, 1 ]
      ::oSL:done( 1 )
   CASE nMode == 2
      qModalIndex := ::oSL:listOptions:currentIndex()
      ::cSelTheme := ::aThemes[ qModalIndex:row() + 1, 1 ]
      ::oSL:done( 1 )
   CASE nMode == 3
      ::oSL:done( 0 )
   ENDCASE
   RETURN Nil


METHOD IdeThemes:copy()
   LOCAL aItems, qGo, cTheme
   WITH OBJECT qGo := QInputDialog( ::oUI:oWidget )
      :setTextValue( ::aThemes[ ::nCurTheme, 1 ] )
      :setLabelText( "Name of new Theme?" )
      :setWindowTitle( "Harbour-Qt [ Get a Value ]" )
      :exec()
   ENDWITH
   cTheme := qGo:textValue()
   IF !empty( cTheme ) .and. !( cTheme == ::aThemes[ ::nCurTheme, 1 ] )
      aItems := aclone( ::aThemes[ ::nCurTheme ] )
      aItems[ 1 ] := cTheme
      aadd( ::aThemes, aItems )
      ::oUI:listThemes:addItem( cTheme )
      ::oUI:listThemes:setCurrentRow( Len( ::aThemes ) - 1 )
   ENDIF
   RETURN Self


METHOD IdeThemes:buildINI()
   LOCAL a_, b_
   LOCAL txt_ := {}
   LOCAL cINI := ""
   aadd( txt_, "#  " )
   aadd( txt_, "#  Harbour IDE Editor Themes" )
   aadd( txt_, "#  Version 0.7" )
   aadd( txt_, "#  Generated on " + dtoc( date() ) + "  " + time() )
   aadd( txt_, "#  " )
   aadd( txt_, "   " )
   aadd( txt_, "[ Controls ]" )
   aadd( txt_, "   " )
   FOR EACH a_ IN ::aControls
      aadd( txt_, pad( a_[ 1 ], 30 ) + " = " + a_[ 2 ] )
   NEXT
   aadd( txt_, "   " )
   aadd( txt_, "   " )
   aadd( txt_, "[ Items ]" )
   aadd( txt_, "   " )
   FOR EACH a_ IN ::aItems
      aadd( txt_, pad( a_[ 1 ], 30 ) + " = " + a_[ 2 ] )
   NEXT
   FOR EACH a_ IN ::aThemes
      aadd( txt_, "   " )
      aadd( txt_, "   " )
      aadd( txt_, "[ Theme : " + a_[ 1 ] + " ]" )
      aadd( txt_, "   " )
      FOR EACH b_ IN a_[ 2 ]
          aadd( txt_, pad( b_[ 1 ], 30 ) + " = " + Attr2Str( b_[ 2 ] ) )
      NEXT
   NEXT
   aadd( txt_, "   " )
   //
   aeval( txt_, {|e| cINI += e + hb_eol() } )
   RETURN cINI


METHOD IdeThemes:parseINI( lAppend )
   LOCAL s, n, cKey, cVal, nPart, nTheme, aVal, aV
   IF empty( ::aIni )
      RETURN Self
   ENDIF
   DEFAULT lAppend TO .t.
   IF ! lAppend 
      ::aControls := {}
      ::aThemes   := {}
      ::aItems    := {}
   ENDIF
   FOR EACH s IN ::aIni
      IF !empty( s := alltrim( s ) ) .and. !left( s, 1 ) == "#" /* Comment */
         DO case
         CASE s == "[ Controls ]"
            nPart := 1
         CASE s == "[ Items ]"
            nPart := 2
         CASE left( s, 7 ) == "[ Theme"
            IF ( n := at( ":", s ) ) > 0
               cKey := alltrim( strtran( substr( s, n + 1 ), "]", "" ) )
            ENDIF
            IF !empty( cKey )
               nPart := 3
               IF ( nTheme := ascan( ::aThemes, {|e_| e_[ 1 ] == cKey } ) ) == 0
                  aadd( ::aThemes, { cKey, {} } )
                  nTheme := Len( ::aThemes )
               ENDIF
            ELSE
               nPart := 0
            ENDIF
         OTHERWISE
            DO CASE
            CASE nPart == 1 /* Controls */
               IF hbide_parseKeyValPair( s, @cKey, @cVal )
                  IF ( n := ascan( ::aControls, {|e_| e_[ 1 ] == cKey } ) ) > 0
                     ::aControls[ n, 2 ] := cVal
                  ELSE
                     aadd( ::aControls, { cKey, cVal } )
                  ENDIF
               ENDIF
            CASE nPart == 2 /* Items   */
               IF hbide_parseKeyValPair( s, @cKey, @cVal )
                  IF ( n := ascan( ::aItems, {|e_| e_[ 1 ] == cKey } ) ) > 0
                     ::aItems[ n, 2 ] := cVal
                  ELSE
                     aadd( ::aItems, { cKey, cVal } )
                  ENDIF
               ENDIF
            CASE nPart == 3 /* Theams  */
               IF hbide_parseKeyValPair( s, @cKey, @cVal )

                  aV   := FillAttrbs()
                  aVal := hb_aTokens( cVal, "," )
                  FOR n := 1 TO THM_NUM_ATTRBS
                     s := alltrim( aVal[ n ] )
                     IF n <= 3
                        aV[ n ] := val( s )
                     ELSE
                        aV[ n ] := lower( s ) == "yes"
                     ENDIF
                  NEXT
                  IF ( n := ascan( ::aThemes[ nTheme, 2 ], {|e_| e_[ 1 ] == cKey } ) ) > 0
                     ::aThemes[ nTheme, 2, n, 2 ] := aV
                  ELSE
                     aadd( ::aThemes[ nTheme, 2 ], { cKey, aV } )
                  ENDIF
               ENDIF
            ENDCASE
         ENDCASE
      ENDIF
   NEXT
   RETURN Self


STATIC FUNCTION FillAttrbs()
   RETURN { 0, 0, 0, .f., .f., .f. }


STATIC FUNCTION Attr2RGBfn( a_ )
   RETURN "rgba( " + Attr2StrRGB( a_ ) + ", 255 )"


STATIC FUNCTION Attr2RGBfnRev( a_ )
   LOCAL b_:= { ( a_[ THM_ATR_R ] + 255 ) % 256, ( a_[ THM_ATR_G ] + 255 ) % 256, ( a_[ THM_ATR_B ] + 255 ) % 256 }
   RETURN "rgba( " + Attr2StrRGB( b_ ) + ", 255 )"


STATIC FUNCTION Attr2StrRGB( a_ )
   RETURN hb_ntos( a_[ THM_ATR_R ] ) +","+ hb_ntos( a_[ THM_ATR_G ] ) +","+ hb_ntos( a_[ THM_ATR_B ] )


STATIC FUNCTION Attr2Str( a_ )
   RETURN padl( hb_ntos( a_[ 1 ] ), 4 ) + "," +;
          padl( hb_ntos( a_[ 2 ] ), 4 ) + "," +;
          padl( hb_ntos( a_[ 3 ] ), 4 ) + "," +;
          iif( a_[ 4 ], " Yes", "  No" ) + "," +;
          iif( a_[ 5 ], " Yes", "  No" ) + "," +;
          iif( a_[ 6 ], " Yes", "  No" ) + ","


STATIC FUNCTION GetKeyValue( aKeys, cKey, cDef )
   LOCAL xVal, n
   DEFAULT cDef TO ""
   IF ( n := ascan( aKeys, {|e_| e_[ 1 ] == cKey } ) ) > 0
      xVal := aKeys[ n, 2 ]
   ELSE
      xVal := cDef
   ENDIF
   RETURN xVal


STATIC FUNCTION GetSource()
   LOCAL s := ""
   LOCAL txt_:= {}
   aadd( txt_, '/* Copyright 2009-2014 Pritpal Bedi <bedipritpal@hotmail.com>              ' )
   aadd( txt_, ' *                                                                         ' )
   aadd( txt_, ' * This program is free software; you can redistribute it and/or modify    ' )
   aadd( txt_, '*/                                                                         ' )
   aadd( txt_, '#include "hbide.ch"                                                        ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, 'CLASS IdeThemes   /* This Class Manages Syntax Higlighting */              ' )
   aadd( txt_, '   VAR    oIde                                                             ' )
   aadd( txt_, '   METHOD new()                                                            ' )
   aadd( txt_, '   ENDCLASS                                                                ' )
   aadd( txt_, '/*----------------------------------------------------------------------*/ ' )
   aadd( txt_, 'METHOD IdeThemes:new( oIde, cThemesFile )                                  ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, '   * Legacy comment syntax, advised not be used                                                                        ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, '   ::oIde  := oIde                                                         ' )
   aadd( txt_, '   ::cThemesFile := cThemesFile                                            ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, '   RETURN Self                                                             ' )
   aadd( txt_, '/*----------------------------------------------------------------------*/ ' )
   aadd( txt_, '// This function is used to retrieve value given a key ...                 ' )
   aadd( txt_, 'STATIC FUNCTION GetKeyValue( aKeys, cKey, cDef )                           ' )
   aadd( txt_, '   LOCAL xVal                                                              ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, '   DEFAULT cDef TO ""                                                      ' )
   aadd( txt_, '                                                                           ' )
   aadd( txt_, '   IF ( n := ascan( aKeys, {|e_| e_[ 1 ] == cKey } ) ) > 0                 ' )
   aadd( txt_, '      xVal := aKeys[ n, 2 ]                                                ' )
   aadd( txt_, '   ELSE                                                                    ' )
   aadd( txt_, '      xVal := cDef                                                         ' )
   aadd( txt_, '   ENDIF                                                                   ' )
   aadd( txt_, '   RETURN xVal                                                             ' )
   aadd( txt_, '/*----------------------------------------------------------------------*/ ' )
   IF .T.
      aeval( txt_, {|e| s += trim( e ) + hb_eol() } )
   ENDIF
   RETURN s

/*
STATIC FUNCTION hbide_setSyntaxAttrbs( qHiliter, cPattern, cName, nR, nG, nB, lItalic, lBold, lUnderline )
   LOCAL qFormat

   qFormat  := QTextCharFormat()

   IF HB_ISLOGICAL( lItalic )
      qFormat:setFontItalic( lItalic )
   ENDIF
   IF HB_ISLOGICAL( lBold ) .and. lBold
      qFormat:setFontWeight( 1000 )
   ENDIF
   IF HB_ISLOGICAL( lUnderline )
      qFormat:setFontUnderline( lUnderline )
   ENDIF
   qFormat:setForeGround( QBrush( QColor( nR, nG, nB ) ) )

   qHiliter:hbSetRule( cName, cPattern, qFormat )

   RETURN nil
*/


STATIC FUNCTION hbide_loadDefaultThemes()
   LOCAL aIni := {}
   IF .T. 
      aadd( aIni, "[ Controls ]                                                         " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "dialogTitle                    = HbIDE - Source Syntax Highlighting  " )
      aadd( aIni, "labelItem                      = Item                                " )
      aadd( aIni, "labelTheme                     = Theme                               " )
      aadd( aIni, "checkItalic                    = Italic                              " )
      aadd( aIni, "checkBold                      = Bold                                " )
      aadd( aIni, "checkUnderline                 = Underline                           " )
      aadd( aIni, "buttonColor                    = Color                               " )
      aadd( aIni, "buttonSave                     = Save                                " )
      aadd( aIni, "buttonSaveAs                   = Save As                             " )
      aadd( aIni, "buttonApply                    = Apply                               " )
      aadd( aIni, "buttonCancel                   = Cancel                              " )
      aadd( aIni, "buttonCopy                     = Copy                                " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Items ]                                                            " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     = Background                          " )
      aadd( aIni, "PreprocessorDirectives         = Preprocessor Directives             " )
      aadd( aIni, "HarbourKeywords                = Harbour Keywords                    " )
      aadd( aIni, "CLanguageKeywords              = C-CPP Language Keywords             " )
      aadd( aIni, "Operators                      = Operators                           " )
      aadd( aIni, "NumericalConstants             = Numerical Constants                 " )
      aadd( aIni, "BracketsAndBraces              = Brackets and Braces                 " )
      aadd( aIni, "FunctionsBody                  = Functions Body                      " )
      aadd( aIni, "TerminatedStrings              = Terminated Strings                  " )
      aadd( aIni, "CommentsAndRemarks             = Comments and Remarks                " )
      aadd( aIni, "UnrecognizedText               = Unrecognized Text                   " )
      aadd( aIni, "BookMarkLineBackground         = BookMark Line Background            " )
      aadd( aIni, "SelectionBackground            = Selection Background                " )
      aadd( aIni, "CurrentLineBackground          = Current Line Background             " )
      aadd( aIni, "UnterminatedStrings            = Unterminated Strings                " )
      aadd( aIni, "LineNumbersBkColor             = Line Numbers Background             " )
      aadd( aIni, "UserDictionary                 = UserDictionary                      " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : Pritpal's Favourite ]                                      " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     =  245, 255, 216,  No,  No,  No,      " )
      aadd( aIni, "PreprocessorDirectives         =   69, 138,   0,  No, Yes,  No,      " )
      aadd( aIni, "HarbourKeywords                =   54,   0, 162,  No, Yes,  No,      " )
      aadd( aIni, "CLanguageKeywords              =    0,   0, 128,  No,  No,  No,      " )
      aadd( aIni, "Operators                      =  172,  39, 255,  No, Yes,  No,      " )
      aadd( aIni, "NumericalConstants             =    0, 128,   0,  No,  No,  No,      " )
      aadd( aIni, "BracketsAndBraces              =  255,  85,   0,  No,  No,  No,      " )
      aadd( aIni, "FunctionsBody                  =   15, 122, 255,  No, Yes,  No,      " )
      aadd( aIni, "TerminatedStrings              =  255,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "CommentsAndRemarks             =  165, 165, 165,  No,  No,  No,      " )
      aadd( aIni, "UnrecognizedText               =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "BookMarkLineBackground         =    0, 255, 255,  No,  No,  No,      " )
      aadd( aIni, "SelectionBackground            =  220, 200, 135,  No,  No,  No,      " )
      aadd( aIni, "CurrentLineBackground          =  255, 215, 155,  No,  No,  No,      " )
      aadd( aIni, "UnterminatedStrings            =  255, 128, 128,  No,  No,  No,      " )
      aadd( aIni, "LineNumbersBkColor             =  255, 215, 155,  No,  No,  No,      " )
      aadd( aIni, "UserDictionary                 =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : Bare Minimum ]                                             " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     =  255, 255, 255,  No,  No,  No,      " )
      aadd( aIni, "PreprocessorDirectives         =  127,   0, 127,  No,  No,  No,      " )
      aadd( aIni, "HarbourKeywords                =    0, 127, 127,  No, Yes,  No,      " )
      aadd( aIni, "CLanguageKeywords              =    0,   0, 128,  No,  No,  No,      " )
      aadd( aIni, "Operators                      =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "NumericalConstants             =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "BracketsAndBraces              =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "FunctionsBody                  =    0,   0, 255,  No,  No,  No,      " )
      aadd( aIni, "TerminatedStrings              =  255,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "CommentsAndRemarks             =  165, 165, 165,  No,  No,  No,      " )
      aadd( aIni, "UnrecognizedText               =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "BookMarkLineBackground         =    0, 255, 255,  No,  No,  No,      " )
      aadd( aIni, "SelectionBackground            =  160, 200, 255,  No,  No,  No,      " )
      aadd( aIni, "CurrentLineBackground          =  235, 235, 235,  No,  No,  No,      " )
      aadd( aIni, "UnterminatedStrings            =  255, 128, 128,  No,  No,  No,      " )
      aadd( aIni, "LineNumbersBkColor             =  235, 235, 235,  No,  No,  No,      " )
      aadd( aIni, "UserDictionary                 =    0,   0,   0,  No,  No,  No,      " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : Classic ]                                                  " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     = 255,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "PreprocessorDirectives         = 128,128,0      ,  No,  No,  No,     " )
      aadd( aIni, "HarbourKeywords                = 128,0,128      ,  No,  No,  No,     " )
      aadd( aIni, "CLanguageKeywords              = 0,0,128        ,  No,  No,  No,     " )
      aadd( aIni, "Operators                      = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "NumericalConstants             = 0,128,0        ,  No,  No,  No,     " )
      aadd( aIni, "BracketsAndBraces              = 64,0,0         ,  No,  No,  No,     " )
      aadd( aIni, "FunctionsBody                  = 0,0,192        ,  No,  No,  No,     " )
      aadd( aIni, "TerminatedStrings              = 255,0,0        ,  No,  No,  No,     " )
      aadd( aIni, "CommentsAndRemarks             = 0,128,255      ,  No,  No,  No,     " )
      aadd( aIni, "UnrecognizedText               = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "BookMarkLineBackground         = 0,255,255      ,  No,  No,  No,     " )
      aadd( aIni, "SelectionBackground            = 255,200,220    ,  No,  No,  No,     " )
      aadd( aIni, "CurrentLineBackground          = 220,220,220    ,  No,  No,  No,     " )
      aadd( aIni, "UnterminatedStrings            = 255,128,128    ,  No,  No,  No,     " )
      aadd( aIni, "LineNumbersBkColor             = 220,220,220    ,  No,  No,  No,     " )
      aadd( aIni, "UserDictionary                 = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : City Lights ]                                              " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "PreprocessorDirectives         = 255,0,0        ,  No,  No,  No,     " )
      aadd( aIni, "HarbourKeywords                = 128,0,128      ,  No,  No,  No,     " )
      aadd( aIni, "CLanguageKeywords              = 0,0,128        ,  No,  No,  No,     " )
      aadd( aIni, "Operators                      = 128,255,0      ,  No,  No,  No,     " )
      aadd( aIni, "NumericalConstants             = 0,255,255      ,  No,  No,  No,     " )
      aadd( aIni, "BracketsAndBraces              = 255,128,128    ,  No,  No,  No,     " )
      aadd( aIni, "FunctionsBody                  = 128,128,255    ,  No,  No,  No,     " )
      aadd( aIni, "TerminatedStrings              = 0,255,0        ,  No,  No,  No,     " )
      aadd( aIni, "CommentsAndRemarks             = 255,255,0      ,  No,  No,  No,     " )
      aadd( aIni, "UnrecognizedText               = 255,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "BookMarkLineBackground         = 128,128,128    ,  No,  No,  No,     " )
      aadd( aIni, "SelectionBackground            = 255,128,255    ,  No,  No,  No,     " )
      aadd( aIni, "CurrentLineBackground          = 0,0,255        ,  No,  No,  No,     " )
      aadd( aIni, "UnterminatedStrings            = 255,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "LineNumbersBkColor             = 0,0,255        ,  No,  No,  No,     " )
      aadd( aIni, "UserDictionary                 = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : Evening Glamour ]                                          " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     = 0,64,128       ,  No,  No,  No,     " )
      aadd( aIni, "PreprocessorDirectives         = 255,128,192    ,  No,  No,  No,     " )
      aadd( aIni, "HarbourKeywords                = 255,128,192    ,  No,  No,  No,     " )
      aadd( aIni, "CLanguageKeywords              = 0,0,128        ,  No,  No,  No,     " )
      aadd( aIni, "Operators                      = 255,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "NumericalConstants             = 0,255,0        ,  No,  No,  No,     " )
      aadd( aIni, "BracketsAndBraces              = 128,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "FunctionsBody                  = 128,255,128    ,  No,  No,  No,     " )
      aadd( aIni, "TerminatedStrings              = 255,255,128    ,  No,  No,  No,     " )
      aadd( aIni, "CommentsAndRemarks             = 192,192,192    ,  No,  No,  No,     " )
      aadd( aIni, "UnrecognizedText               = 255,255,255    ,  No,  No,  No,     " )
      aadd( aIni, "BookMarkLineBackground         = 128,0,255      ,  No,  No,  No,     " )
      aadd( aIni, "SelectionBackground            = 0,128,255      ,  No,  No,  No,     " )
      aadd( aIni, "CurrentLineBackground          = 90,180,180     ,  No,  No,  No,     " )
      aadd( aIni, "UnterminatedStrings            = 255,128,64     ,  No,  No,  No,     " )
      aadd( aIni, "LineNumbersBkColor             = 90,180,180     ,  No,  No,  No,     " )
      aadd( aIni, "UserDictionary                 = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "[ Theme : Sand Storm ]                                               " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "Background                     = 255,255,192    ,  No,  No,  No,     " )
      aadd( aIni, "PreprocessorDirectives         = 255,0,0        ,  No,  No,  No,     " )
      aadd( aIni, "HarbourKeywords                = 128,0,128      ,  No,  No,  No,     " )
      aadd( aIni, "CLanguageKeywords              = 0,0,128        ,  No,  No,  No,     " )
      aadd( aIni, "Operators                      = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "NumericalConstants             = 0,128,128      ,  No,  No,  No,     " )
      aadd( aIni, "BracketsAndBraces              = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "FunctionsBody                  = 0,0,192        ,  No,  No,  No,     " )
      aadd( aIni, "TerminatedStrings              = 0,128,0        ,  No,  No,  No,     " )
      aadd( aIni, "CommentsAndRemarks             = 128,128,128    ,  No,  No,  No,     " )
      aadd( aIni, "UnrecognizedText               = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "BookMarkLineBackground         = 0,255,255      ,  No,  No,  No,     " )
      aadd( aIni, "SelectionBackground            = 125,170,150    ,  No,  No,  No,     " )
      aadd( aIni, "CurrentLineBackground          = 220,220,110    ,  No,  No,  No,     " )
      aadd( aIni, "UnterminatedStrings            = 128,128,0      ,  No,  No,  No,     " )
      aadd( aIni, "LineNumbersBkColor             = 220,220,110    ,  No,  No,  No,     " )
      aadd( aIni, "UserDictionary                 = 0,0,0          ,  No,  No,  No,     " )
      aadd( aIni, "                                                                     " )
   ENDIF
   RETURN aIni

//-------------------------------------------------------------------//
#if 0                  // Placeholder of Syntax
//-------------------------------------------------------------------//
                                                       [Classic]     [CityLights]  [Evening]     [SandStorm]

Background                 = Background                255,255,255   0,0,0         0,64,128      255,255,192
PreprocessorDirectives     = Preprocessor Directives   128,128,0     255,0,0       255,128,192   255,0,0
HarbourKeywords            = Harbour Keywords          128,0,128     128,0,128     255,128,192   128,0,128
CLanguageKeywords          = C-CPP Language Keywords   0,0,128       0,0,128       0,0,128       0,0,128
Operators                  = Operators                 0,0,0         128,255,0     255,255,255   0,0,0
NumericalConstants         = Numerical Constants       0,128,0       0,255,255     0,255,0       0,128,128
BracketsAndBraces          = Brackets and Braces       64,0,0        255,128,128   128,255,255   0,0,0
FunctionsBody              = Functions Body            0,0,192       128,128,255   128,255,128   0,0,192
TerminatedStrings          = Terminated Strings        255,0,0       0,255,0       255,255,128   0,128,0
CommentsAndRemarks         = Comments and Remarks      0,128,255     255,255,0     192,192,192   128,128,128
BookMarkLineBackground     = BookMark Line Background  0,255,255     128,128,128   128,0,255     0,255,255
SelectionBackground        = Selection Background      255,128,255   255,128,255   0,128,255     255,0,255
CurrentLineBackground      = Current Line Background   128,0,0       0,0,255       128,255,255   128,0,0
UnrecognizedText           = Unrecognized Text         0,0,0         255,255,255   255,255,255   0,0,0
UnterminatedStrings        = Unterminated Strings      255,128,128   255,255,255   255,128,64    128,128,0
LineNumbersBkColor         = WAPIDictionary            0,0,128       0,0,128       128,128,64    0,0,128
UserDictionary             = UserDictionary            0,0,0         0,0,0         0,0,0         0,0,0
//-------------------------------------------------------------------//
#endif
//-------------------------------------------------------------------//

