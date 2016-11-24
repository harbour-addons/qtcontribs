/*
 * $Id$
 */

/*
 * Copyright 2009-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               17Nov2016
 */
/*----------------------------------------------------------------------*/

#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"


#define THM_ATR_R                                 1
#define THM_ATR_G                                 2
#define THM_ATR_B                                 3
#define THM_ATR_ITALIC                            4
#define THM_ATR_BOLD                              5
#define THM_ATR_ULINE                             6

#define THM_NUM_ATTRBS                            6


CLASS HbQtHilighter

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

   METHOD init()
   METHOD create()
   METHOD destroy()
   METHOD contains( cTheme )
   METHOD getThemeAttribute( cAttr, cTheme )
   METHOD buildSyntaxFormat( aAttr )
   METHOD setForeBackGround( qEdit, cTheme )
   METHOD setQuotesRule( qHiliter, cTheme )
   METHOD setMultiLineCommentRule( qHiliter, cTheme )
   METHOD setSingleLineCommentRule( qHiliter, cTheme )
   METHOD setSyntaxRule( qHiliter, cName, cPattern, lCaseSensitive, aAttr )
   METHOD setSyntaxFormat( qHiliter, cName, aAttr )
   METHOD setSyntaxHilighting( qEdit, cTheme, lSetEditor )
   METHOD changeSyntaxHilighting( qEdit, cTheme, qHiliter )
   METHOD parseINI( lAppend )

   ENDCLASS


METHOD HbQtHilighter:init()
   RETURN Self


METHOD HbQtHilighter:destroy()

   ::aIni        := NIL
   ::aThemes     := NIL
   ::aControls   := NIL
   ::aItems      := NIL
   ::aPatterns   := NIL
   ::aApplyAct   := NIL

   RETURN Self


METHOD HbQtHilighter:create()
   LOCAL s, b_

   ::aIni := hbqt_loadDefaultThemes()
   ::parseINI()

   /* These are the supported patterns - rest will be ignore until implemented */

   /* Compiler Directives */
   b_:= { "include","define","if","ifndef","ifdef","else","endif","command","xcommand","translate","xtranslate" }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "#" + e + "\b" } )
   aadd( ::aPatterns, { "PreprocessorDirectives", s, .f. } )

   /* Harbour Keywords */
   b_:= { 'next','function','procedure','thread','return','static','local','default', ;
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
          'error','handler','private','protected','public' }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "\b" + e + "\b" } )
   aadd( ::aPatterns, { "HarbourKeywords"   , s, .f. } )

   /* C Language Keywords - Only for C or CPP sources - mutually exclusive with Harbour Sources */
   b_:= { "char", "class", "const", "double", "enum", "explicit", "friend", "inline", ;
          "int",  "long", "namespace", "operator", "private", "protected", "public", ;
          "short", "signals", "signed", "slots", "static", "struct", "template", ;
          "typedef", "typename", "union", "unsigned", "virtual", "void", "volatile" }
   s := ""; aeval( b_, {|e| s += iif( empty( s ), "", "|" ) + "\b" + e + "\b" } )
   aadd( ::aPatterns, { "CLanguageKeywords" , s                       , .t. } )

   //s := "\:\=|\:|\+|\-|\\|\*|\ IN\ |\ in\ |\=|\>|\<|\^|\%|\$|\&|\@|\.or\.|\.and\.|\.OR\.|\.AND\.|\!"
   s := "\:\=|\:|\+|\-|\\|\*|\=|\>|\<|\^|\%|\$|\&|\@|\!"
   aadd( ::aPatterns, { "Operators"         , s                       , .f. } )

   aadd( ::aPatterns, { "NumericalConstants", "\b[0-9.]+\b"           , .f. } )

   aadd( ::aPatterns, { "BracketsAndBraces" , "\(|\)|\{|\}|\[|\]|\|"  , .f. } )

   aadd( ::aPatterns, { "FunctionsBody"     , "\b[A-Za-z0-9_]+(?=\()" , .f. } )
   RETURN Self


METHOD HbQtHilighter:contains( cTheme )
   RETURN ascan( ::aThemes, {|a_| a_[ 1 ] == cTheme } ) > 0


METHOD HbQtHilighter:getThemeAttribute( cAttr, cTheme )
   LOCAL nTheme, aAttr := {}

   IF !empty( cAttr )
      IF !empty( cTheme ) .and. HB_ISSTRING( cTheme ) .and. ( nTheme := ascan( ::aThemes, {|e_| e_[ 1 ] == cTheme } ) ) > 0
         aAttr := GetKeyValue( ::aThemes[ nTheme, 2 ], cAttr )
      ENDIF
   ENDIF
   RETURN aAttr


METHOD HbQtHilighter:buildSyntaxFormat( aAttr )
   LOCAL qFormat

   qFormat := QTextCharFormat()

   qFormat:setFontItalic( aAttr[ THM_ATR_ITALIC ] )
   IF aAttr[ THM_ATR_BOLD ]
      qFormat:setFontWeight( 1000 )
   ENDIF
   qFormat:setFontUnderline( aAttr[ THM_ATR_ULINE ] )
   //
   qFormat:setForeground( QBrush( QColor( aAttr[ THM_ATR_R ], aAttr[ THM_ATR_G ], aAttr[ THM_ATR_B ] ) ) )
   RETURN qFormat


METHOD HbQtHilighter:setQuotesRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "TerminatedStrings", cTheme ) )
      qHiliter:hbSetFormat( "TerminatedStrings", ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD HbQtHilighter:setSingleLineCommentRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "CommentsAndRemarks", cTheme ) )
      qHiliter:hbSetSingleLineCommentFormat( ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD HbQtHilighter:setMultiLineCommentRule( qHiliter, cTheme )
   LOCAL aAttr
   IF !empty( aAttr := ::getThemeAttribute( "CommentsAndRemarks", cTheme ) )
      qHiliter:hbSetMultiLineCommentFormat( ::buildSyntaxFormat( aAttr ) )
   ENDIF
   RETURN Self


METHOD HbQtHilighter:setSyntaxRule( qHiliter, cName, cPattern, lCaseSensitive, aAttr )
   LOCAL qRegExp := QRegExp()

   qRegExp:setCaseSensitivity( iif( lCaseSensitive, Qt_CaseSensitive, Qt_CaseInsensitive ) )
   qRegExp:setPattern( cPattern )

   qHiliter:hbSetRuleWithRegExp( cName, qRegExp, ::buildSyntaxFormat( aAttr ) )
   RETURN Self


METHOD HbQtHilighter:setSyntaxFormat( qHiliter, cName, aAttr )
   qHiliter:hbSetFormat( cName, ::buildSyntaxFormat( aAttr ) )
   RETURN Self


METHOD HbQtHilighter:setSyntaxHilighting( qEdit, cTheme, lSetEditor )
   LOCAL a_, aAttr, qHiliter

   IF empty( cTheme )
      cTheme := "Bare Minimum"
   ENDIF
   IF AScan( ::aThemes, {|e_| e_[ 1 ] == cTheme } ) == 0
      cTheme := "Bare Minimum"
   ENDIF
   DEFAULT lSetEditor TO .T.

   ::setForeBackGround( qEdit, cTheme )

   qHiliter := HBQSyntaxHighlighter( qEdit:document() )

   FOR EACH a_ IN ::aPatterns
      IF !empty( aAttr := ::getThemeAttribute( a_[ 1 ], cTheme ) )
         ::setSyntaxRule( qHiliter, a_[ 1 ], a_[ 2 ], a_[ 3 ], aAttr )
      ENDIF
   NEXT

   ::setMultiLineCommentRule( qHiliter, cTheme )
   ::setSingleLineCommentRule( qHiliter, cTheme )
   ::setQuotesRule( qHiliter, cTheme )

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


METHOD HbQtHilighter:changeSyntaxHilighting( qEdit, cTheme, qHiliter )
   LOCAL a_, aAttr

   qHiliter:hbClear()

   ::setForeBackGround( qEdit, cTheme )

   FOR EACH a_ IN ::aPatterns
      IF !empty( aAttr := ::getThemeAttribute( a_[ 1 ], cTheme ) )
         ::setSyntaxRule( qHiliter, a_[ 1 ], a_[ 2 ], a_[ 3 ], aAttr )
      ENDIF
   NEXT

// ::mergeUserDictionaries( qHiliter, cTheme )
   ::setMultiLineCommentRule( qHiliter, cTheme )
   ::setSingleLineCommentRule( qHiliter, cTheme )
   ::setQuotesRule( qHiliter, cTheme )

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


METHOD HbQtHilighter:parseINI( lAppend )
   LOCAL s, n, cKey, cVal, nPart, nTheme, aVal, aV

   IF empty( ::aIni )
      RETURN Self
   ENDIF

   DEFAULT lAppend TO .t.

   IF !( lAppend )
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
               IF hbqt_parseKeyValPair( s, @cKey, @cVal )
                  IF ( n := ascan( ::aControls, {|e_| e_[ 1 ] == cKey } ) ) > 0
                     ::aControls[ n, 2 ] := cVal
                  ELSE
                     aadd( ::aControls, { cKey, cVal } )
                  ENDIF
               ENDIF
            CASE nPart == 2 /* Items   */
               IF hbqt_parseKeyValPair( s, @cKey, @cVal )
                  IF ( n := ascan( ::aItems, {|e_| e_[ 1 ] == cKey } ) ) > 0
                     ::aItems[ n, 2 ] := cVal
                  ELSE
                     aadd( ::aItems, { cKey, cVal } )
                  ENDIF
               ENDIF
            CASE nPart == 3 /* Theams  */
               IF hbqt_parseKeyValPair( s, @cKey, @cVal )

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


METHOD HbQtHilighter:setForeBackGround( qEdit, cTheme )
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


STATIC FUNCTION hbqt_parseKeyValPair( s, cKey, cVal )
   LOCAL n, lYes := .f.

   IF ( n := at( "=", s ) ) > 0
      cKey := alltrim( substr( s, 1, n - 1 ) )
      cVal := alltrim( substr( s, n + 1 ) )
      lYes := ( !empty( cKey ) .and. !empty( cVal ) )
   ENDIF
   RETURN lYes


STATIC FUNCTION Attr2StrRGB( a_ )
   RETURN hb_ntos( a_[ THM_ATR_R ] ) +","+ hb_ntos( a_[ THM_ATR_G ] ) +","+ hb_ntos( a_[ THM_ATR_B ] )


STATIC FUNCTION FillAttrbs()
   RETURN { 0, 0, 0, .f., .f., .f. }


STATIC FUNCTION GetKeyValue( aKeys, cKey, cDef )
   LOCAL xVal, n

   DEFAULT cDef TO ""

   IF ( n := ascan( aKeys, {|e_| e_[ 1 ] == cKey } ) ) > 0
      xVal := aKeys[ n, 2 ]
   ELSE
      xVal := cDef
   ENDIF
   RETURN xVal


STATIC FUNCTION hbqt_loadDefaultThemes()
   LOCAL aIni := {}

   IF .t.
      aadd( aIni, "[ Controls ]                                                         " )
      aadd( aIni, "                                                                     " )
      aadd( aIni, "dialogTitle                    = HbQtWidgets - Source Syntax Highlighting  " )
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

