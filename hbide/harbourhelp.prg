      /*
 * $Id$
 */

/*
 * Copyright 2010-2023 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                               20Feb2010
 */
/*----------------------------------------------------------------------*/

#include "hbide.ch"
#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"


#define DOC_FUN_BEGINS                           -5
#define DOC_FUN_ENDS                             -1
#define DOC_FUN_NONE                              0
#define DOC_FUN_TEMPLATE                          1
#define DOC_FUN_FUNCNAME                          2
#define DOC_FUN_CATEGORY                          3
#define DOC_FUN_SUBCATEGORY                       4
#define DOC_FUN_ONELINER                          5
#define DOC_FUN_SYNTAX                            6
#define DOC_FUN_ARGUMENTS                         7
#define DOC_FUN_RETURNS                           8
#define DOC_FUN_DESCRIPTION                       9
#define DOC_FUN_EXAMPLES                          10
#define DOC_FUN_TESTS                             11
#define DOC_FUN_FILES                             12
#define DOC_FUN_STATUS                            13
#define DOC_FUN_PLATFORMS                         14
#define DOC_FUN_SEEALSO                           15
#define DOC_FUN_VERSION                           16
#define DOC_FUN_INHERITS                          17
#define DOC_FUN_METHODS                           18
#define DOC_FUN_EXTERNALLINK                      19


#define __buttonInstall_clicked__                 2001
#define __buttonHome_clicked__                    2002
#define __buttonBackward_clicked__                2003
#define __buttonForward_clicked__                 2004
#define __buttonUp_clicked__                      2005
#define __buttonRefresh_clicked__                 2006
#define __buttonPrint_clicked__                   2007
#define __buttonPdf_clicked__                     2008
#define __buttonPdfAll_clicked__                  2009
#define __browserView_anchorClicked__             2010
#define __tabWidgetContents_currentChanged__      2011
#define __editInstall_textChanged__               2012
#define __editIndex_textChanged__                 2013
#define __editIndex_returnPressed__               2014
#define __treeDoc_itemSelectionChanged__          2015
#define __treeCategory_itemSelectionChanged__     2016
#define __listIndex_ItemDoubleClicked__           2017


CLASS IdeDocFunction

   DATA   cName                                   INIT ""
   DATA   cTemplate                               INIT ""
   DATA   cCategory                               INIT ""
   DATA   cSubCategory                            INIT ""
   DATA   cOneliner                               INIT ""
   DATA   cStatus                                 INIT ""
   DATA   cCompliance                             INIT ""
   DATA   cPlatforms                              INIT ""
   DATA   cSeeAlso                                INIT ""
   DATA   cVersion                                INIT ""
   DATA   cInherits                               INIT ""
   DATA   cExternalLink                           INIT ""
   DATA   aSyntax                                 INIT {}
   DATA   aArguments                              INIT {}
   DATA   aReturns                                INIT {}
   DATA   aDescription                            INIT {}
   DATA   aExamples                               INIT {}
   DATA   aFiles                                  INIT {}
   DATA   aMethods                                INIT {}
   DATA   aSource                                 INIT {}
   DATA   oTVItem
   DATA   cSourceTxt                              INIT ""
   DATA   lOk                                     INIT .f.

   METHOD init()
   METHOD destroy()

   ENDCLASS


METHOD IdeDocFunction:init()
   RETURN Self 
   
   
METHOD IdeDocFunction:destroy()
   ::cName             := NIL
   ::cTemplate         := NIL
   ::cCategory         := NIL
   ::cSubCategory      := NIL
   ::cOneliner         := NIL
   ::cStatus           := NIL
   ::cCompliance       := NIL
   ::cPlatforms        := NIL
   ::cSeeAlso          := NIL
   ::cVersion          := NIL
   ::cInherits         := NIL
   ::cExternalLink     := NIL
   ::aSyntax           := NIL
   ::aArguments        := NIL
   ::aReturns          := NIL
   ::aDescription      := NIL
   ::aExamples         := NIL
   ::aFiles            := NIL
   ::aMethods          := NIL
   ::aSource           := NIL
   ::oTVItem           := NIL
   ::cSourceTxt        := NIL
   ::lOk               := NIL
   RETURN NIL


CLASS IdeHarbourHelp INHERIT IdeObject

   DATA   oUI
   DATA   cPathInstall                            INIT ""
   DATA   cDocPrefix
   DATA   aNodes                                  INIT {}
   DATA   aFunctions                              INIT {}
   DATA   aFuncByFile                             INIT {}
   DATA   aHistory                                INIT {}
   DATA   aCategory                               INIT {}
   DATA   nCurTVItem                              INIT 0
   DATA   nCurInHist                              INIT 0
   DATA   qHiliter
   DATA   hIndex                                  INIT {=>}
   DATA   aProtoTypes                             INIT {}
   DATA   lLoadedProto                            INIT .f.
   DATA   aFuncDefs                               INIT {}

   METHOD init( oIde )
   METHOD create( oIde )
   METHOD show()
   METHOD destroy()
   METHOD clear()
   METHOD execEvent( nEvent, p, p1 )
   METHOD setImages()
   METHOD setTooltips()
   METHOD setParameters()
   METHOD installSignals()
   METHOD refreshDocTree()
   METHOD updateViewer( aHtm, cDocName )
   METHOD populateFuncDetails( n )
   METHOD populateTextFile( cTextFile )
   METHOD populateRootInfo()
   METHOD populatePathInfo( cPath )
   METHOD populateIndex()
   METHOD populateIndexedSelection()
   METHOD buildView( oFunc )
   METHOD print()
   METHOD exportAsPdf()
   METHOD exportAsPdfAll()
   METHOD paintRequested( qPrinter )
   METHOD parseTextFile( cTextFile, oParent )
   METHOD jumpToFunction( cFunction )
   METHOD getDocFunction( acBuffer )
   METHOD getFunctionPrototypes()
   METHOD pullDefinitions( acBuffer )
   METHOD pullDefinitionsHBD( cFileHBD )

   ENDCLASS


METHOD IdeHarbourHelp:init( oIde )
   ::oIde := oIde
   RETURN Self


METHOD IdeHarbourHelp:create( oIde )
   LOCAL cPath
   DEFAULT oIde TO ::oIde
   ::oIde := oIde
   ::cPathInstall := ::oINI:getHarbourPath()
   IF empty( ::cPathInstall )
      hb_fNameSplit( hb_dirBase(), @cPath )
      IF hb_fileExists( cPath + "hbmk2.exe" )
         ::cPathInstall := cPath + ".." + hb_ps()
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:show()
   IF empty( ::oUI )
      ::oUI := hbide_getUI( "docviewgenerator" )
      ::oDocViewDock:oWidget:setWidget( ::oUI:oWidget )
      //
      ::setImages()
      ::setTooltips()
      ::installSignals()
      ::setParameters()
      ::populateRootInfo()
      ::refreshDocTree()
      //
      ::oUI:editInstall:setText( ::cPathInstall )
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:destroy()
   LOCAL aTmp, oFun
   IF ! empty( ::oUI )
      WITH OBJECT ::oUI
         :buttonInstall    : disconnect( "clicked()"                           )
         :buttonHome       : disconnect( "clicked()"                           )
         :buttonBackward   : disconnect( "clicked()"                           )
         :buttonForward    : disconnect( "clicked()"                           )
         :buttonUp         : disconnect( "clicked()"                           )
         :buttonRefresh    : disconnect( "clicked()"                           )
         :buttonPrint      : disconnect( "clicked()"                           )
         :buttonPdf        : disconnect( "clicked()"                           )
         :buttonPdfAll     : disconnect( "clicked()"                           )
         :browserView      : disconnect( "anchorClicked(QUrl)"                 )
         :tabWidgetContents: disconnect( "currentChanged(int)"                 )
         :editInstall      : disconnect( "textChanged(QString)"                )
         :editIndex        : disconnect( "textChanged(QString)"                )
         :editIndex        : disconnect( "returnPressed()"                     )
         :listIndex        : disconnect( "itemDoubleClicked(QListWidgetItem*)" )
         :treeDoc          : disconnect( "itemSelectionChanged()"              )
         :treeCategory     : disconnect( "itemSelectionChanged()"              )
      ENDWITH
      ::clear()
      ::oUI:destroy()
   ENDIF
   IF .T.
      ::aNodes              := NIL
      ::aFunctions          := NIL
      FOR EACH aTmp IN ::aFuncByFile
         aTmp[ 1 ] := NIL
         FOR EACH oFun IN aTmp[ 2 ]
            oFun:destroy()
            oFun := NIL
         NEXT
         aTmp[ 2 ] := NIL
      NEXT
      ::aFuncByFile         := NIL
      ::aHistory            := NIL
      ::aCategory           := NIL
      ::nCurTVItem          := NIL
      ::nCurInHist          := NIL
      ::hIndex              := NIL
      ::aProtoTypes         := NIL
      ::lLoadedProto        := NIL
      ::aFuncDefs           := NIL
      ::qHiliter            := NIL
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:clear()
   LOCAL a_

   ::aHistory    := {}
   ::aFuncByFile := {}

   FOR EACH a_ IN ::aCategory
      a_[ 4 ] := NIL              // Reference to Contents node
   NEXT
   FOR EACH a_ IN ::aFunctions
      a_[ 4 ] := NIL              // Reference to Contents node
   NEXT
   /* Contents Tab */
   FOR EACH a_ IN ::aNodes
      IF a_[ 2 ] == "Function"
         a_[ 1 ] := NIL ; a_[ 3 ] := NIL
      ENDIF
   NEXT
   FOR EACH a_ IN ::aNodes
      IF a_[ 2 ] == "File"
         a_[ 1 ] := NIL ; a_[ 3 ] := NIL
      ENDIF
   NEXT
   FOR EACH a_ IN ::aNodes
      IF a_[ 2 ] == "Path"
         IF HB_ISOBJECT( a_[ 3 ] )
            a_[ 3 ] := NIL
         ENDIF
         a_[ 1 ] := NIL
      ENDIF
   NEXT
   IF !empty( ::aNodes )
      ::aNodes[ 1, 1 ] := NIL
   ENDIF
   ::aNodes := {}
   /* Index Tab */
   FOR EACH a_ IN ::aFunctions
      a_[ 5 ] := NIL
   NEXT
   ::aFunctions := {}
   /* Category Tab */
   FOR EACH a_ IN ::aCategory
      IF a_[ 7 ] == " "
         a_[ 5 ] := NIL
         a_[ 6 ] := NIL
      ENDIF
   NEXT
   FOR EACH a_ IN ::aCategory
      IF a_[ 7 ] == "U"
         a_[ 5 ] := NIL
      ENDIF
   NEXT
   ::aCategory := {}
   WITH OBJECT ::oUI
      :treeDoc:clear()
      :treeCategory:clear()
      :listIndex:clear()
   ENDWITH
   RETURN Self


METHOD IdeHarbourHelp:setImages()
   WITH OBJECT ::oUI
      :buttonHome    : setIcon( QIcon( hbide_image( "dc_home"    ) ) )
      :buttonBackward: setIcon( QIcon( hbide_image( "dc_left"    ) ) )
      :buttonForward : setIcon( QIcon( hbide_image( "dc_right"   ) ) )
      :buttonUp      : setIcon( QIcon( hbide_image( "dc_up"      ) ) )
      :buttonRefresh : setIcon( QIcon( hbide_image( "dc_refresh" ) ) )
      :buttonPrint   : setIcon( QIcon( hbide_image( "dc_print"   ) ) )
      :buttonPdf     : setIcon( QIcon( hbide_image( "dc_pdffile" ) ) )
      :buttonPdfAll  : setIcon( QIcon( hbide_image( "dc_pdffile" ) ) )
      :buttonSave    : setIcon( QIcon( hbide_image( "save"       ) ) )
      :buttonExit    : setIcon( QIcon( hbide_image( "dc_quit"    ) ) )
      :buttonInstall : setIcon( QIcon( hbide_image( "dc_folder"  ) ) )
#if 0                  
      :buttonArgPlus : setIcon( QIcon( hbide_image( "dc_plus" ) ) )
      :buttonArgMinus: setIcon( QIcon( QIcon( hbide_image( "dc_delete" ) ) )
      :buttonArgUp   : setIcon( QIcon( hbide_image( "dc_up" ) ) )
      :buttonArgDown : setIcon( QIcon( hbide_image( "dc_down" ) ) )
#endif
   ENDWITH
   RETURN Self


METHOD IdeHarbourHelp:setTooltips()
   WITH OBJECT ::oUI
      :buttonHome    : setToolTip( "Home"     )
      :buttonBackward: setToolTip( "Backward" )
      :buttonForward : setToolTip( "Forward"  )
      :buttonRefresh : setToolTip( "Refresh"  )
      :buttonUp      : setToolTip( "Up"       )
      :buttonPrint   : setToolTip( "Print"    )
      :buttonPdf     : setToolTip( "Export as PDF Document" )
      :buttonPdfAll  : setToolTip( "Export ALL as PDF Documents" )
      :buttonSave    : setToolTip( "Save"     )
      :buttonExit    : setToolTip( "Exit"     )
      :buttonInstall : setToolTip( "Select Harbour Installation Path" )
   ENDWITH
   RETURN Self


METHOD IdeHarbourHelp:setParameters()
   WITH OBJECT ::oUI
      :treeDoc          : setHeaderHidden( .t. )
      :treeCategory     : setHeaderHidden( .t. )
      :editInstall      : setText( ::cWrkHarbour )
      :treeDoc          : setExpandsOnDoubleClick( .f. )
      :browserView      : setOpenLinks( .t. )
      :browserView      : setOpenExternalLinks( .t. )
      :tabWidgetContents: setFocusPolicy( Qt_NoFocus )
#if 0
      ::qHiliter        := ::oTH:SetSyntaxHilighting( :plainExamples, "Bare Minimum" )
      //   
      :plainExamples    : setFont( ::oFont:oWidget )
      :plainDescription : setFont( ::oFont:oWidget )
      :plainArguments   : setFont( ::oFont:oWidget )
      :plainArgDesc     : setFont( ::oFont:oWidget )
      :plainTests       : setFont( ::oFont:oWidget )
      :plainExamples    : setLineWrapMode( QTextEdit_NoWrap )
      :plainTests       : setLineWrapMode( QTextEdit_NoWrap )
#endif
   ENDWITH 
   RETURN Self


METHOD IdeHarbourHelp:installSignals()
   WITH OBJECT ::oUI
      :buttonInstall    : connect( "clicked()"                 , {| | ::execEvent( __buttonInstall_clicked__               ) } )
      :buttonHome       : connect( "clicked()"                 , {| | ::execEvent( __buttonHome_clicked__                  ) } )
      :buttonBackward   : connect( "clicked()"                 , {| | ::execEvent( __buttonBackward_clicked__              ) } )
      :buttonForward    : connect( "clicked()"                 , {| | ::execEvent( __buttonForward_clicked__               ) } )
      :buttonUp         : connect( "clicked()"                 , {| | ::execEvent( __buttonUp_clicked__                    ) } )
      :buttonRefresh    : connect( "clicked()"                 , {| | ::execEvent( __buttonRefresh_clicked__               ) } )
      :buttonPrint      : connect( "clicked()"                 , {| | ::execEvent( __buttonPrint_clicked__                 ) } )
      :buttonPdf        : connect( "clicked()"                 , {| | ::execEvent( __buttonPdf_clicked__                   ) } )
      :buttonPdfAll     : connect( "clicked()"                 , {| | ::execEvent( __buttonPdfAll_clicked__                ) } )
      :browserView      : connect( "anchorClicked(QUrl)"       , {|p| ::execEvent( __browserView_anchorClicked__       , p ) } )
      :tabWidgetContents: connect( "currentChanged(int)"       , {|p| ::execEvent( __tabWidgetContents_currentChanged__, p ) } )
      :editInstall      : connect( "textChanged(QString)"      , {|p| ::execEvent( __editInstall_textChanged__         , p ) } )
      :editIndex        : connect( "textChanged(QString)"      , {|p| ::execEvent( __editIndex_textChanged__           , p ) } )
      :editIndex        : connect( "returnPressed()"           , {| | ::execEvent( __editIndex_returnPressed__             ) } )
      :treeDoc          : connect( "itemSelectionChanged()"    , {| | ::execEvent( __treeDoc_itemSelectionChanged__        ) } )
      :treeCategory     : connect( "itemSelectionChanged()"    , {| | ::execEvent( __treeCategory_itemSelectionChanged__   ) } )
      :listIndex        : connect( "itemDoubleClicked(QListWidgetItem*)", {|p| ::execEvent( __listIndex_ItemDoubleClicked__, p ) } )
   ENDWITH 
   RETURN Self


METHOD IdeHarbourHelp:execEvent( nEvent, p, p1 )
   LOCAL cPath, qTWItem, cText, n, nn, nLen, cLower
   HB_SYMBOL_UNUSED( p1 )
   IF ::lQuitting
      RETURN Self
   ENDIF
   SWITCH nEvent
   CASE __buttonInstall_clicked__
      cPath := hbide_fetchADir( ::oDocViewDock, "Harbour Install Root" )
      IF !empty( cPath )
         ::oUI:editInstall:setText( cPath )
      ENDIF
      EXIT
   CASE __tabWidgetContents_currentChanged__
      IF p == 1
         ::oUI:editIndex:setFocus()
      ENDIF
      EXIT
   CASE __browserView_anchorClicked__
      cText := lower( p:toString() )
      nLen := Len( cText )
      IF ( n := ascan( ::aFunctions, {|e_| left( e_[ 6 ], nLen ) == cText } ) ) > 0
         ::oUI:listIndex:setCurrentItem( ::aFunctions[ n, 5 ] )
         ::populateIndexedSelection()
      ENDIF
      EXIT
   CASE __listIndex_ItemDoubleClicked__
      ::populateIndexedSelection()
      ::oUI:editIndex:setFocus()
      EXIT
   CASE __editIndex_returnPressed__
      IF !empty( ::oUI:editIndex:text() )
         ::populateIndexedSelection()
         ::oUI:editIndex:setFocus()
      ENDIF
      EXIT
   CASE __editIndex_textChanged__
      IF ( nLen := Len( p ) ) > 0
         cLower := lower( p )
         IF ( n := ascan( ::aFunctions, {|e_| left( e_[ 6 ], nLen ) == cLower } ) ) > 0
            ::oUI:listIndex:setCurrentItem( ::aFunctions[ n, 5 ] )
         ENDIF
      ENDIF
      EXIT
   CASE __editInstall_textChanged__
      IF hb_dirExists( p )
         ::oUI:editInstall:setStyleSheet( "" )
         ::cPathInstall := hbide_pathStripLastSlash( hbide_pathNormalized( p, .f. ) )
      ELSE
         ::oUI:editInstall:setStyleSheet( getStyleSheet( "PathIsWrong", ::nAnimantionMode ) )
      ENDIF
      EXIT
   CASE __buttonHome_clicked__
      IF !empty( ::aNodes )
         ::oUI:treeDoc:setCurrentItem( ::aNodes[ 1, 1 ], 0 )
      ENDIF
      EXIT
   CASE __buttonBackward_clicked__
      IF ::nCurInHist > 1
         ::oUI:treeDoc:setCurrentItem( ::aNodes[ ::aHistory[ ::nCurInHist - 1 ], 1 ], 0 )
      ENDIF
      EXIT
   CASE __buttonForward_clicked__
      IF ::nCurInHist < Len( ::aHistory )
         ::oUI:treeDoc:setCurrentItem( ::aNodes[ ::aHistory[ ::nCurInHist + 1 ], 1 ], 0 )
      ENDIF
      EXIT
   CASE __buttonUp_clicked__
      IF ::nCurInHist > 1 .AND. ::nCurInHist <= Len( ::aHistory )
         IF ! empty( qTWItem := ::oUI:treeDoc:itemAbove( ::oUI:treeDoc:currentItem( 0 ) ) )
            ::oUI:treeDoc:setCurrentItem( qTWItem, 0 )
         ENDIF
      ENDIF
      EXIT
   CASE __buttonRefresh_clicked__
      ::refreshDocTree()
      ::aProtoTypes := {}
      ::lLoadedProto := .f.
      ::oEM:updateCompleter()
      EXIT
   CASE __buttonPrint_clicked__
      ::print()
      EXIT
   CASE __buttonPdf_clicked__
      ::exportAsPdf()
      EXIT
   CASE __buttonPdfAll_clicked__
      ::exportAsPdfAll()
      EXIT
   CASE __treeCategory_itemSelectionChanged__
      qTWItem := ::oUI:treeCategory:currentItem()
      n := ascan( ::aCategory, {|e_| hbqt_IsEqual( e_[ 5 ], qTWItem ) } )
      IF n > 0
         IF ::aCategory[ n, 5 ]:childCount() == 0
            ::oUI:treeDoc:setCurrentItem( ::aCategory[ n, 4 ], 0 )
         ENDIF
      ENDIF
      EXIT
   CASE __treeDoc_itemSelectionChanged__
      qTWItem := ::oUI:treeDoc:currentItem()
      cText   := qTWItem:text( 0 )
      IF ( n := ascan( ::aNodes, {|e_| e_[ 5 ] == cText } ) ) > 0
         IF ( nn := ascan( ::aHistory, n ) ) == 0
            aadd( ::aHistory, n )
            ::nCurInHist := Len( ::aHistory )
         ELSE
            ::nCurInHist := nn
         ENDIF
         ::nCurTVItem := n
         IF     ::aNodes[ n, 2 ] == "Root"
            ::populateRootInfo()
         ELSEIF ::aNodes[ n, 2 ] == "Path"
            ::populatePathInfo( ::aNodes[ n, 4 ] )
         ELSEIF ::aNodes[ n, 2 ] == "File"
            ::populateTextFile( ::aNodes[ n, 4 ] )
         ELSEIF ::aNodes[ n, 2 ] == "Function"
            ::populateFuncDetails( n )
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Self


METHOD IdeHarbourHelp:jumpToFunction( cFunction )
   LOCAL n, nLen
   nLen := Len( cFunction )
   cFunction := lower( cFunction )
   IF !empty( ::aNodes )
      IF ( n := ascan( ::aFunctions, {|e_| lower( left( e_[ 2 ], nLen ) ) == cFunction } ) ) > 0
         ::oUI:treeDoc:setCurrentItem( ::aFunctions[ n, 4 ] )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:populateIndexedSelection()
   LOCAL qItem, cText, n
   IF !empty( ::aNodes )
      IF !empty( qItem := ::oUI:listIndex:currentItem() )
         cText := qItem:text()
         IF ( n := ascan( ::aFunctions, {|e_| e_[ 2 ] == cText } ) ) > 0
            ::oUI:treeDoc:setCurrentItem( ::aFunctions[ n, 4 ] )
         ENDIF
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:refreshDocTree()
   LOCAL aPaths, cFolder, cNFolder, aDocs, oChild, oParent, oRoot, cRoot
   LOCAL aDir, a_, cTextFile, n, aHbd
   IF empty( ::cPathInstall ) .OR. ! hb_dirExists( ::cPathInstall )
      RETURN Self
   ENDIF
   ::showApplicationCursor( Qt_BusyCursor )
   /* Clean Environment */
   ::clear()
   //
   ::aNodes      := {}
   ::aFuncByFile := {}
   ::aHistory    := {}
   ::aFunctions  := {}
   ::nCurTVItem  := 0
   ::nCurInHist  := 0
   //
   aPaths := {}
   aDocs  := {}
   //
   cRoot := ::cPathInstall
   IF ! ( right( cRoot, 1 ) $ "/\" )
      cRoot += hb_ps()
   ENDIF
   cRoot := hbide_pathToOSPath( cRoot + "/doc/" )
   aHbd := directory( cRoot + "*.hbd" )
   IF ! empty( aHbd )
      aPaths := { cRoot }
      aDocs := { cRoot }
   ELSE
      hbide_fetchSubPaths( @aPaths, ::cPathInstall, .t. )
      cRoot := aPaths[ 1 ]
      FOR EACH cFolder IN aPaths
         cNFolder := hbide_pathNormalized( cFolder, .t. )
         IF ( "/doc" $ cNFolder ) .OR. ( "/doc/en" $ cNFolder )
            aadd( aDocs, cFolder )
         ENDIF
      NEXT
   ENDIF
   WITH OBJECT oRoot := QTreeWidgetItem()
      :setText( 0, aPaths[ 1 ] )
      :setIcon( 0, QIcon( hbide_image( "dc_home" ) ) )
      :setToolTip( 0, aPaths[ 1 ] )
      :setExpanded( .t. )
   ENDWITH 
   ::oUI:treeDoc:addTopLevelItem( oRoot )
   aadd( ::aNodes, { oRoot, "Path", NIL, cRoot, cRoot } )
   hbide_buildFoldersTree( ::aNodes, aDocs )
   ::aNodes[ 1,2 ] := iif( empty( aHbd ), "Root", "Path" )
   FOR EACH cFolder IN aDocs
      IF ( n := ascan( ::aNodes, {|e_| e_[ 2 ] == "Path" .AND. lower( e_[ 4 ] ) == lower( cFolder ) } ) ) > 0
         oParent := ::aNodes[ n, 1 ]
         IF ! empty( aHbd )
            aDir := aHbd
         ELSE
            aDir := directory( cFolder + "*.txt" )
         ENDIF
         FOR EACH a_ IN aDir
            IF !( a_[ 5 ] == "D" )
               cTextFile := cFolder + a_[ 1 ]
               WITH OBJECT oChild := QTreeWidgetItem()
                  :setText( 0, a_[ 1 ]  )
                  :setIcon( 0, QIcon( ::resPath + "dc_textdoc.png" ) )
                  :setToolTip( 0, cTextFile )
               ENDWITH 
               oParent:addChild( oChild )
               aadd( ::aNodes, { oChild, "File", oParent, cTextFile, a_[ 1 ] } )
               ::parseTextFile( cTextFile, oChild )
            ENDIF
         NEXT
      ENDIF
   NEXT
   IF .T.
      ::populateIndex()
      ::oUI:treeDoc:expandItem( oRoot )
      ::showApplicationCursor()
   ENDIF 
   RETURN Self


STATIC FUNCTION hbide_buildFoldersTree( aNodes, aPaths )
   LOCAL cRoot, cPath, s, aSubs, i, n, cCPath, cPPath, nP, cOSPath, oParent, oChild
   LOCAL cIcon := hbide_image( "dc_folder" )
   cRoot := aNodes[ 1, 4 ]
   FOR EACH s IN aPaths
      cPath := s
      cPath := hbide_stripRoot( cRoot, cPath )
      cPath := hbide_pathNormalized( cPath, .f. )
      aSubs := hb_aTokens( cPath, "/" )
      FOR i := 1 TO Len( aSubs )
         IF !empty( aSubs[ i ] )
            cCPath := hbide_buildPathFromSubs( aSubs, i )
            n := ascan( aNodes, {|e_| hb_FileMatch( hbide_pathNormalized( e_[ 4 ], .f. ), hbide_pathNormalized( cRoot + cCPath, .f. ) ) } )
            IF n == 0
               cPPath  := hbide_buildPathFromSubs( aSubs, i - 1 )
               nP      := ascan( aNodes, {|e_| hb_FileMatch( hbide_pathNormalized( e_[ 4 ], .f. ), hbide_pathNormalized( cRoot + cPPath, .f. ) ) } )
               IF nP > 0
                  oParent := aNodes[ nP, 1 ]
                  cOSPath := hbide_pathToOSPath( cRoot + cCPath )
                  WITH OBJECT oChild  := QTreeWidgetItem()
                     :setText( 0, aSubs[ i ] )
                     :setIcon( 0, QIcon( cIcon ) )
                     :setToolTip( 0, cOSPath )
                  ENDWITH 
                  oParent:addChild( oChild )
                  aadd( aNodes, { oChild, "Path", oParent, cOSPath, aSubs[ i ] } )
               ENDIF
            ENDIF
         ENDIF
      NEXT
   NEXT
   RETURN NIL


STATIC FUNCTION hbide_buildPathFromSubs( aSubs, nUpto )
   LOCAL i, cPath := ""
   IF nUpto > 0
      FOR i := 1 TO nUpto
         cPath += aSubs[ i ] + "/"
      NEXT
   ENDIF
   RETURN cPath


METHOD IdeHarbourHelp:populateIndex()
   LOCAL a_, qItem, oFunc, oParent, n
   LOCAL aUnq := {}
   //
   asort( ::aFunctions, , , {|e_, f_| e_[ 2 ] < f_[ 2 ] } )
   ::oUI:listIndex:setSortingEnabled( .t. )
   FOR EACH a_ IN ::aFunctions
      IF !empty( a_[ 2 ] )
         qItem := QListWidgetItem()
         qItem:setText( a_[ 2 ] )
         a_[ 5 ] := qItem
         ::oUI:listIndex:addItem( qItem )
      ENDIF
   NEXT
   FOR EACH a_ IN ::aFunctions
      oFunc := a_[ 3 ]
      IF !empty( oFunc:cCategory )
         IF ascan( aUnq, {|e_| e_[ 1 ] == oFunc:cCategory } ) == 0
            aadd( aUnq, { oFunc:cCategory, NIL } )
            aadd( ::aCategory, { oFunc:cCategory, oFunc:cSubCategory, oFunc, a_[ 4 ], NIL, NIL, "U" } )
         ELSE
            aadd( ::aCategory, { oFunc:cCategory, oFunc:cSubCategory, oFunc, a_[ 4 ], NIL, NIL, " " } )
         ENDIF
      ENDIF
   NEXT
   IF !empty( ::aCategory )
      asort( ::aCategory, , , {|e_, f_| e_[ 1 ] < f_[ 1 ] } )
   ENDIF
   FOR EACH a_ IN aUnq
      qItem := QTreeWidgetItem()
      qItem:setText( 0, a_[ 1 ] )
      ::oUI:treeCategory:addTopLevelItem( qItem )
      a_[ 2 ] := qItem
   NEXT
   FOR EACH a_ IN ::aCategory
      IF ( n := ascan( aUnq, {|e_| e_[ 1 ] == a_[ 1 ] } ) ) > 0
         oParent := aUnq[ n, 2 ]
         qItem := QTreeWidgetItem()
         qItem:setText( 0, a_[ 3 ]:cName )
         oParent:addChild( qItem )
         a_[ 5 ] := qItem
         a_[ 6 ] := oParent
      ENDIF
   NEXT
   RETURN Self


METHOD IdeHarbourHelp:pullDefinitions( acBuffer )
   IF HB_ISARRAY( acBuffer )
      RETURN doc2functions( __hbdoc_fromSource( hbide_arrayToMemo( acBuffer ) ) )
   ELSE
      IF hb_fileExists( acBuffer )
         RETURN doc2functions( __hbdoc_fromSource( MemoRead( acBuffer ) ) )
      ELSE
         RETURN doc2functions( __hbdoc_fromSource( acBuffer ) )
      ENDIF
   ENDIF
   RETURN {}


METHOD IdeHarbourHelp:pullDefinitionsHBD( cFileHBD )
   IF hb_fileExists( cFileHBD )
      RETURN doc2functions( __hbdoc_LoadHBD( cFileHBD ) )
   ENDIF
   RETURN {}


STATIC FUNCTION doc2functions( hFile )
   LOCAL hDoc
   LOCAL aFn := {}
   IF HB_ISARRAY( hFile )
      FOR EACH hDoc IN hFile
         AAdd( aFn, hbide_getFuncObjectFromHash( hDoc ) )
      NEXT
   ENDIF
   RETURN aFn


METHOD IdeHarbourHelp:parseTextFile( cTextFile, oParent )
   LOCAL aFn, oFunc, oTWItem
   LOCAL cIcon   := hbide_image( "dc_function" )
   LOCAL nParsed := ascan( ::aFuncByFile, {|e_| e_[ 1 ] == cTextFile } )
   IF nParsed == 0
      IF ".hbd" $ lower( cTextFile )
         aFn := ::pullDefinitionsHBD( cTextFile )
      ELSE
         aFn := ::pullDefinitions( cTextFile )
      ENDIF
      IF ! empty( aFn  )
         FOR EACH oFunc IN aFn
            oTWItem   := QTreeWidgetItem()
            oTWItem:setText( 0, oFunc:cName )
            oTWItem:setIcon( 0, QIcon( cIcon ) )
            oTWItem:setTooltip( 0, oFunc:cName )
            oParent:addChild( oTWItem )
            aadd( ::aNodes, { oTWItem, "Function", oParent, cTextFile + "<::>" + oFunc:cName, oFunc:cName } )
            aadd( ::aFunctions, { cTextFile, oFunc:cName, oFunc, oTWItem, NIL, lower( oFunc:cName ) } )
         NEXT
      ENDIF
      aadd( ::aFuncByFile, { cTextFile, aFn } )
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:getDocFunction( acBuffer )
   LOCAL aFn
   IF !empty( aFn := ::pullDefinitions( acBuffer ) )
      RETURN aFn[ 1 ]
   ENDIF
   RETURN NIL


METHOD IdeHarbourHelp:getFunctionPrototypes()
   LOCAL a_, cFolder, aFN, oFunc, cNFolder, cRoot, aHbd
   LOCAL aPaths := {}
   LOCAL aDocs  := {}
   LOCAL aProto
   IF empty( ::aProtoTypes )
      IF ! empty( ::cPathInstall )
         IF ! ::lLoadedProto
            cRoot := ::cPathInstall
            IF ! ( right( cRoot, 1 ) $ "/\" )
               cRoot += hb_ps()
            ENDIF
            cRoot := hbide_pathToOSPath( cRoot + "/doc/" )
            aHbd := directory( cRoot + "*.hbd" )
            IF ! empty( aHbd )
               aPaths := { cRoot }
               aDocs := { cRoot }
            ELSE
               hbide_fetchSubPaths( @aPaths, ::cPathInstall, .t. )
               FOR EACH cFolder IN aPaths
                  cNFolder := hbide_pathNormalized( cFolder, .t. )
                  IF ( "/doc" $ cNFolder ) .OR. ( "/doc/en" $ cNFolder )
                     aadd( aDocs, cFolder )
                  ENDIF
               NEXT
            ENDIF
            aProto := {}
            IF empty( aHbd )
               FOR EACH cFolder IN aDocs
                  FOR EACH a_ IN directory( cFolder + "*.txt" )
                     IF !( a_[ 5 ] == "D" )
                        aFn := ::pullDefinitions( cFolder + a_[ 1 ] )
                        FOR EACH oFunc IN aFn
                           IF HB_ISOBJECT( oFunc )
                              IF !empty( oFunc:aSyntax )
                                 IF "C Prototype" $ oFunc:aSyntax[ 1 ]
                                    aadd( aProto, alltrim( oFunc:aSyntax[ Len( oFunc:aSyntax ) ] ) )
                                 ELSE
                                    aadd( aProto, alltrim( oFunc:aSyntax[ 1 ] ) )
                                 ENDIF
                              ENDIF
                           ENDIF
                        NEXT
                     ENDIF
                  NEXT
               NEXT
            ELSE
               FOR EACH a_ IN aHbd
                  aFn := ::pullDefinitionsHBD( cRoot + a_[ 1 ] )
                  FOR EACH oFunc IN aFn
                     IF HB_ISOBJECT( oFunc )
                        IF !empty( oFunc:aSyntax )
                           IF "C Prototype" $ oFunc:aSyntax[ 1 ]
                              aadd( aProto, alltrim( oFunc:aSyntax[ Len( oFunc:aSyntax ) ] ) )
                           ELSE
                              aadd( aProto, alltrim( oFunc:aSyntax[ 1 ] ) )
                           ENDIF
                        ENDIF
                     ENDIF
                  NEXT
               NEXT
            ENDIF
            ::aProtoTypes := aProto
            ::lLoadedProto := .t.
         ENDIF
      ENDIF
   ENDIF
   RETURN ::aProtoTypes


METHOD IdeHarbourHelp:updateViewer( aHtm, cDocName )
   ::oUI:browserView:setHTML( hbide_arrayToMemo( aHtm ) )
   ::oUI:browserView:setDocumentTitle( cDocName )
   RETURN Self


METHOD IdeHarbourHelp:populateRootInfo()
   LOCAL aHtm := {}
   aadd( aHtm, "<html>" )
   aadd( aHtm, ' <body align=center valign=center>' )
   aadd( aHtm, '  <h1><font color=green>' + "Welcome" + '</font></h1>' )
   aadd( aHtm, '  <br>' + '&nbsp;' + '</br>' )
   aadd( aHtm, '  <h2><font color=blue>' + ::cPathInstall + '</font></h2>' )
   aadd( aHtm, '  <br>&nbsp;</br>' )
   aadd( aHtm, '  <br>&nbsp;</br>' )
   aadd( aHtm, '  <img src="' + ':/resources/harbour.png' + '" width="300" height="200"</img></br>' )
   aadd( aHtm, " </body>" )
   aadd( aHtm, "</html>" )
   //
   ::updateViewer( aHtm, "Welcome" )
   RETURN Self


METHOD IdeHarbourHelp:populatePathInfo( cPath )
   LOCAL aHtm := {}
   aadd( aHtm, "<html>" )
   aadd( aHtm, " <body align=center valign=center>" )
   aadd( aHtm, '  <h2><font color=blue>' + cPath + '</font></h2>' )
   aadd( aHtm, " </body>" )
   aadd( aHtm, "</html>" )
   //
   ::updateViewer( aHtm, cPath )
   RETURN Self


METHOD IdeHarbourHelp:populateTextFile( cTextFile )
   LOCAL aHtm, aFn, oFunc
   LOCAL nParsed := ascan( ::aFuncByFile, {|e_| e_[ 1 ] == cTextFile } )
   /* Build HTML */
   aHtm := {}
   aadd( aHtm, "<html>" )
   aadd( aHtm, " <body>" )
   aadd( aHtm, '  <h3 align=center><font color=blue>' + cTextFile + '</font></h3>' )
   aadd( aHtm, '   <br>' + '&nbsp;  <hr></hr></br>' )
   IF nParsed > 0
      aFn := ::aFuncByFile[ nParsed, 2 ]
      IF Len( aFn ) > 0
         FOR EACH oFunc IN aFn
            IF HB_ISOBJECT( oFunc )
               aadd( aHtm, '   <br>' + hbide_arrayToMemoHtml( oFunc:aSyntax ) + '</br>' )
            ENDIF
         NEXT
      ELSE
         aadd( aHtm, '   <br><pre>' + hb_memoread( cTextFile ) + '</pre></br>' )
      ENDIF
   ENDIF
   aadd( aHtm, " </body>" )
   aadd( aHtm, "</html>" )
   //
   ::updateViewer( aHtm, cTextFile )
   RETURN Self


METHOD IdeHarbourHelp:populateFuncDetails( n )
   LOCAL oTWItem := ::aNodes[ n, 1 ]
   LOCAL nIndex, oFunc
   IF ( nIndex := ascan( ::aFunctions, {|e_| e_[ 4 ] == oTWItem } ) ) > 0
      oFunc := ::aFunctions[ nIndex, 3 ]
   ENDIF
   IF !empty( oFunc )
      ::buildView( oFunc )
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:buildView( oFunc )
   LOCAL s, x, y, v, w, z, n, s1, a_, cTxt
   LOCAL aHtm := {}

   aadd( aHtm, "<html>" )
   aadd( aHtm, '<head>                                                             ' )
   aadd( aHtm, '  <meta name="Author" content=Pritpal Bedi [pritpal@vouchcac.com]">' )
   aadd( aHtm, '  <meta http-equiv="content-style-type" content="text/css" >       ' )
   aadd( aHtm, '  <meta http-equiv="content-script-type" content="text/javascript">' )
   aadd( aHtm, '                                                                   ' )
   aadd( aHtm, '  <style type="text/css">                                          ' )
   aadd( aHtm, '    a                                                              ' )
   aadd( aHtm, '    {                                                              ' )
   aadd( aHtm, '      text-decoration  : none;                                     ' )
   aadd( aHtm, '      color-hover      : #FF9900;                                  ' )
   aadd( aHtm, '    }                                                              ' )
   aadd( aHtm, '    th                                                             ' )
   aadd( aHtm, '    {                                                              ' )
   aadd( aHtm, '      colspan          : 1;                                        ' )
   aadd( aHtm, '      text-align       : center;                                   ' )
   aadd( aHtm, '      vertical-align   : baseline;                                 ' )
   aadd( aHtm, '      horizontal-align : left;                                     ' )
   aadd( aHtm, '    }                                                              ' )
   aadd( aHtm, '    td                                                             ' )
   aadd( aHtm, '    {                                                              ' )
   aadd( aHtm, '      vertical-align   : top;                                      ' )
   aadd( aHtm, '      horizontal-align : left;                                     ' )
   aadd( aHtm, '    }                                                              ' )
   aadd( aHtm, '    pre                                                            ' )
   aadd( aHtm, '    {                                                              ' )
   aadd( aHtm, '      font-family      : Courier New;                              ' )
   aadd( aHtm, '      font-size        : .9;                                       ' )
   aadd( aHtm, '      color            : black;                                    ' )
   aadd( aHtm, '      cursor           : text;                                     ' )
   aadd( aHtm, '    }                                                              ' )
   aadd( aHtm, '  </style>                                                         ' )
   aadd( aHtm, '</head>                                                            ' )
   aadd( ahtm, ' <body>'    )
   aadd( ahtm, '  <center>' )
   s := '   <table '            +;
        'Border='      + '0 '   +;
        'Frame='       + 'ALL ' +;
        'CellPadding=' + '0 '   +;
        'CellSpacing=' + '0 '   +;
        'Cols='        + '1 '   +;
        'Width='       + '95% ' +;
        '   >'
   aadd( aHtm, s )
   aadd( aHtm, '<caption align=top><font size="6"><b>' + oFunc:cName + '</b></font></caption>' )
   aadd( aHtm, '<br><font color="#FF4719"><b>' + oFunc:cOneLiner + '</b></font></br>' )
   cTxt := " "
   IF !empty( oFunc:cCategory )
      cTxt += "Category: <b>" + oFunc:cCategory + "</b> "
   ENDIF
   IF !empty( oFunc:cSubCategory )
      cTxt += "Sub: <b>" + oFunc:cSubCategory + "</b> "
   ENDIF
   IF !empty( oFunc:cVersion )
      cTxt += "Version: <b>" + oFunc:cVersion + "</b> "
   ENDIF
   IF !empty( cTxt )
      aadd( aHtm, "<br>" + "[" + cTxt + "]" + "</br>" )
   ENDIF
   IF !empty( s1 := oFunc:cExternalLink )
      aadd( aHtm, '<br><a href="' + s1 + '">' + "<b>" + s1 + "</b>" + "</a></br>" )
   ENDIF
   aadd( aHtm, '<hr color="#6699ff" size="5"></hr>' )
   //
   x := '<tr><td align=left><font size="5" color="#FF4719">' ; y := "</font></td></tr>"
   v := '<tr><td margin-left: 20px><pre>'                    ; w := "</pre></td></tr>"
   z := "<tr><td>&nbsp;</td></tr>"
   //
   IF !empty( oFunc:cInherits )
      aadd( aHtm, x + "Inherits"       + y )
      a_:= hb_aTokens( oFunc:cInherits, "," )
      IF !empty( a_ )
         aadd( aHtm, "<tr><td>" )
         FOR EACH s IN a_
            s := alltrim( s )
            IF ( n := at( "(", s ) ) > 0
               s1 := substr( s, 1, n-1 )
            ELSE
               s1 := s
            ENDIF
            aadd( aHtm, '<a href="' + s1 + '">' + s + "</a>" + ;
                                        iif( s:__enumIndex() == Len( a_ ), "", ",&nbsp;" ) )
         NEXT
         aadd( aHtm, "</td></tr>" )
      ENDIF
      //aadd( aHtm, v + oFunc:cInherits  + w )
      aadd( aHtm, z )
   ENDIF
#if 0
   aadd( aHtm, x + "Category"       + y )
   aadd( aHtm, v + oFunc:cCategory  + w )
   aadd( aHtm, z )
   aadd( aHtm, x + "SubCategory"    + y )
   aadd( aHtm, v + oFunc:cSubCategory+ w )
   aadd( aHtm, z )
#endif
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aSyntax ) )
      aadd( aHtm, x + "Syntax"         + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aArguments ) )
      aadd( aHtm, x + "Arguments"      + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aReturns ) )
      aadd( aHtm, x + "Returns"        + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aMethods ) )
      aadd( aHtm, x + "Methods"     + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aDescription ) )
      aadd( aHtm, x + "Description"    + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aExamples ) )
      aadd( aHtm, x + "Examples"       + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
#if 0
   aadd( aHtm, x + "Vesrion"        + y )
   aadd( aHtm, v + oFunc:cVersion   + w )
   aadd( aHtm, z )
#endif
   IF !empty( s := hbide_arrayToMemoHtml( oFunc:aFiles ) )
      aadd( aHtm, x + "Files"          + y )
      aadd( aHtm, v + s + w )
      aadd( aHtm, z )
   ENDIF
   IF ! empty( oFunc:cSeeAlso )
      a_:= hb_atokens( oFunc:cSeeAlso, "," )
      IF !empty( a_ )
         aadd( aHtm, x + "SeeAlso"        + y )
         aadd( aHtm, "<tr><td>" )
         FOR EACH s IN a_
            s := alltrim( s )
            IF ( n := at( "(", s ) ) > 0
               s1 := substr( s, 1, n-1 )
            ELSE
               s1 := s
            ENDIF
            aadd( aHtm, '<a href="' + s1 + '">' + s + "</a>" + ;
                                        iif( s:__enumIndex() == Len( a_ ), "", ",&nbsp;" ) )
         NEXT
         aadd( aHtm, "</td></tr>" )
         aadd( aHtm, z )
      ENDIF
   ENDIF
   IF !empty( oFunc:cCompliance )
      aadd( aHtm, x + "Compliance" + y )
      aadd( aHtm, v + oFunc:cCompliance + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( oFunc:cPlatforms )
      aadd( aHtm, x + "Platforms" + y )
      aadd( aHtm, v + oFunc:cPlatforms + w )
      aadd( aHtm, z )
   ENDIF
   IF !empty( oFunc:cStatus )
      aadd( aHtm, x + "Status"         + y )
      aadd( aHtm, v + oFunc:cStatus    + w )
      aadd( aHtm, z )
   ENDIF
   aadd( aHtm, "   </table>"  )
   aadd( aHtm, "  </center>"  )
   aadd( aHtm, " </body>"     )
   aadd( aHtm, "</html>"      )
   ::updateViewer( aHtm, strtran( strtran( oFunc:cName, ")" ), "(" ) )
   RETURN Self


METHOD IdeHarbourHelp:print()
   WITH OBJECT QPrintPreviewDialog( ::oUI:oWidget() )
      :setWindowTitle( "Harbour Help Document" )
      :connect( "paintRequested(QPrinter*)", {|p| ::paintRequested( p ) } )
      :exec()
      :disconnect( "paintRequested(QPrinter*)" )
      :setParent( QWidget() )
   ENDWITH 
   RETURN self


METHOD IdeHarbourHelp:paintRequested( qPrinter )
   ::oUI:browserView:print( qPrinter )
   RETURN Self


METHOD IdeHarbourHelp:exportAsPdf()
   LOCAL cPdf, qPrinter, cExt, cPath, cFile
   IF !empty( cPdf := hbide_fetchAFile( ::oDlg, "Provide a file name", { { "Pdf Document", "*.pdf" } } ) )
      hb_fNameSplit( cPdf, @cPath, @cFile, @cExt )
      WITH OBJECT qPrinter := QPrinter()
         :setOutputFileName( cPath + cFile + "_" + trim( ::oUI:browserView:documentTitle() ) + ".pdf" )
         :setFullPage( .t. )
      ENDWITH 
      ::oUI:browserView:print( qPrinter )
   ENDIF
   RETURN Self


METHOD IdeHarbourHelp:exportAsPdfAll()
   LOCAL cPdf, qPrinter, cExt, cPath, cFile, aItems
   LOCAL qApp := QApplication()
   IF empty( ::aNodes )
      RETURN Self
   ENDIF
   IF !empty( cPdf := hbide_fetchAFile( ::oDlg, "Provide a file name", { { "Pdf Documents", "*.pdf" } } ) )
      hb_fNameSplit( cPdf, @cPath, @cFile, @cExt )
      WITH OBJECT qPrinter := QPrinter()
         FOR EACH aItems IN ::aNodes
            ::oUI:treeDoc:setCurrentItem( aItems[ 1 ], 0 )
            qApp:processEvents()
            IF ::lQuitting
               EXIT
            ENDIF
            :setOutputFileName( cPath + cFile + "_" + trim( ::oUI:browserView:documentTitle() ) + ".pdf" )
            :setFullPage( .t. )
            ::oUI:browserView:print( qPrinter )
            :newPage()
         NEXT
      ENDWITH 
   ENDIF
   RETURN Self

