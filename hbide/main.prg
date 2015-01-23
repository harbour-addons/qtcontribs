/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009-2015 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                               17Nov2009
 */
/*----------------------------------------------------------------------*/
/*
 *     Many thanks to Vailton Renato for adding new functionalities.
 */
/*----------------------------------------------------------------------*/

#include "hbide.ch"
#include "requests.ch"
#include "common.ch"
#include "xbp.ch"
#include "appevent.ch"
#include "inkey.ch"
#include "gra.ch"
#include "set.ch"

#include "hbclass.ch"
#include "hbver.ch"

#include "hbtoqt.ch"
#include "hbqtstd.ch"

#if defined( __PLATFORM__WINDOWS ) .OR. ;
    defined( __PLATFORM__LINUX )
    //#include "rddads.hbx"
#endif


/* Link all Harbour Functions : needed to run external scripts */
/* NOTE: Please only add what's actually requested by plugin developers */

REQUEST __HB_EXTERN__

REQUEST __HBEXTERN__HBCT__
REQUEST __HBEXTERN__HBNF__
REQUEST __HBEXTERN__HBTIP__
REQUEST __HBEXTERN__HBNETIO__
REQUEST __HBEXTERN__HBMXML__
REQUEST __HBEXTERN__HBMEMIO__
REQUEST __HBEXTERN__HBMZIP__
REQUEST __HBEXTERN__HBSMS__
REQUEST __HBEXTERN__HBTCPIO__
REQUEST __HBEXTERN__HBZIPARC__

//REQUEST __HBEXTERN__HBXBP__
//REQUEST __HBEXTERN__HBQTCORE__
//REQUEST __HBEXTERN__HBQTGUI__
//REQUEST __HBEXTERN__HBQTNETWORK__
//REQUEST __HBEXTERN__HBQTSQL__

REQUEST DBFCDX
REQUEST DBFNTX
REQUEST DBFNSX
//REQUEST ADS


FUNCTION Main( ... )
   LOCAL oTmp, hRDDADS, tmp

   hbqt_errorSys()

   QResource():registerResource_1( hbqtres_HbIde() )
   QResource():registerResource_1( hbqtres_Settings() )

   hb_cdpSelect( "UTF8EX" )
   SET EPOCH TO 1950

   hb_SetEnv( "__HBIDE__", hb_dirBase() )

   #ifdef HB_IDE_DISTRO
      LOCAL cBse := hb_dirBase() + ".."

      /* Set the path env variable to Qt's run-time which is used to compile Harbour binaries */
      hb_setEnv( "PATH", cBse + hb_ps() + "qt" + hb_ps() + "lib" + ;
                                      hb_osPathListSeparator() + hb_getEnv( "PATH" ) )

      /* Variable is used in hbide.env */
      hb_setEnv( "HB_IDE_INSTALL", cBse )
   #endif

   IF hb_FileExists( tmp := hb_dirBase() + hb_libName( "rddads" + hb_libPostfix() ) )
      hRDDADS := hb_libLoad( tmp )
      IF ! Empty( hRDDADS )
         hbide_setAdsAvailable( .t. )
         // hb_rddadsRegister()
      ENDIF
   ENDIF

   SET DATE TO ANSI
   SET CENTURY ON

   oTmp := HbIde():new( hb_aParams() )
   oTmp:create()

   RETURN NIL


CLASS HbIde

   DATA   aParams                                 INIT {}
   DATA   cProjIni                                INIT ""

   DATA   oAC                                            /* Actions Manager                */
   DATA   oBM                                            /* Database Browser Manager       */
   DATA   oDK                                            /* Main Window Components Manager */
   DATA   oDW                                            /* Document Writer Manager        */
   DATA   oEM                                            /* Editor Tabs Manager            */
   DATA   oEV                                            /* Available Environments         */
   DATA   oFF                                            /* Find in Files Manager          */
   DATA   oFN                                            /* Functions Tags Manager         */
   DATA   oFR                                            /* Find Replace Manager           */
   DATA   oHL                                            /* Harbour Help Manager           */
   DATA   oHM                                            /* <Stats> panel manager          */
   DATA   oPM                                            /* Project Manager                */
   DATA   oSM                                            /* Souces Manager                 */
   DATA   oSK                                            /* Skeletons Manager              */
   DATA   oSC                                            /* Shortcuts Manager              */
   DATA   oTM                                            /* Plugin Tools Manager           */
   DATA   oTH                                            /* Themes Manager                 */
   DATA   oRM                                            /* Reports Manager                */
   DATA   oSetup                                         /* Setup Manager                  */
   DATA   oINI                                           /* INI Manager                    */
   DATA   oFmt                                           /* Code Formatter Manager         */
   DATA   oCL                                            /* ChangeLog Manager              */
   DATA   oCUI                                           /* CUI Screen Designer Console    */
   DATA   oUiS                                           /* UI Source Writer               */
   DATA   oPWZ                                           /* Project Wizard                 */
   DATA   oParts                                         /* HbIDE Parts Manager            */
   DATA   oFM                                            /* Functions Map Manager          */

   DATA   nRunMode                                INIT   HBIDE_RUN_MODE_INI
   DATA   nAnimantionMode                         INIT   HBIDE_ANIMATION_NONE
   DATA   oUI
   DATA   oColorizeEffect
   DATA   aMeta                                   INIT   {}  /* Holds current definition only  */
   DATA   mp1, mp2, oXbp, nEvent
   DATA   aTabs                                   INIT   {}
   DATA   aViews                                  INIT   {}
   DATA   aMdies                                  INIT   {}
   DATA   aProjData                               INIT   {}
   DATA   aPrpObjs                                INIT   {}
   DATA   aEditorPath                             INIT   {}
   DATA   aSrcOnCmdLine                           INIT   {}
   DATA   aHbpOnCmdLine                           INIT   {}
   DATA   aDbfOnCmdLine                           INIT   {}

   //DATA   qLayout

   DATA   qTabWidget
   DATA   oTabParent
   DATA   oFrame
   DATA   qLayoutFrame
   DATA   qViewsCombo
   DATA   qFindDlg
   DATA   qFontWrkProject
   DATA   qBrushWrkProject
   DATA   qProcess
   DATA   qHelpBrw
   DATA   qTBarLines
   DATA   qTBarPanels
   DATA   qTBarDocks
   DATA   qCompleter
   DATA   qCompModel
   DATA   qProtoList
   ACCESS oCurEditor                              INLINE ::oEM:getEditorCurrent()
   ACCESS qCurEdit                                INLINE ::oEM:getEditCurrent()
   ACCESS qCurDocument                            INLINE ::oEM:getDocumentCurrent()

   /* XBP Objects */
   DATA   oDlg
   DATA   oDa
   DATA   oSBar
   DATA   oMenu
   DATA   oTBar
   DATA   oStackedWidget
   DATA   oStackedWidgetMisc
   DATA   oFont
   DATA   oProjTree
   DATA   oEditTree
   DATA   oFuncList
   DATA   oOutputResult
   DATA   oCompileResult
   DATA   oLinkResult
   DATA   oNewDlg
   DATA   oPBFind, oPBRepl, oPBClose, oFind, oRepl
   DATA   oCurProjItem
   DATA   oCurProject
   DATA   oProjRoot
   DATA   oExes
   DATA   oLibs
   DATA   oDlls
   DATA   oProps
   DATA   oGeneral
   DATA   oSearchReplace
   DATA   oMainToolbar
   DATA   oDockR
   DATA   oDockB
   DATA   oDockB1
   DATA   oDockB2
   DATA   oDockPT
   DATA   oDockED
   DATA   oThemesDock
   DATA   oPropertiesDock
   DATA   oEnvironDock
   DATA   oFuncDock
   DATA   oDocViewDock
   DATA   oDocWriteDock
   DATA   oFunctionsDock
   DATA   oSkltnsTreeDock
   DATA   oHelpDock
   DATA   oSkeltnDock
   DATA   oFindDock
   DATA   oSourceThumbnailDock
   DATA   oQScintillaDock
   DATA   oUpDn
   DATA   oReportsManagerDock
   DATA   oFormatDock
   DATA   oCuiEdDock
   DATA   oUISrcDock
   DATA   oFunctionsMapDock
   DATA   oDebuggerDock
   DATA   qAnimateAction
   DATA   qStatusBarAction
   DATA   qFuncFragmentWindowGeometry
   DATA   lProjTreeVisible                        INIT   .t.
   DATA   lDockRVisible                           INIT   .f.
   DATA   lDockBVisible                           INIT   .f.

   DATA   lLineNumbersVisible                     INIT   .t.
   DATA   lHorzRulerVisible                       INIT   .t.
   DATA   lCurrentLineHighlightEnabled            INIT   .t.

   DATA   lTabCloseRequested                      INIT   .f.
   DATA   isColumnSelectionEnabled                INIT   .f.
   DATA   cWrkFolderLast                          INIT   ""
   DATA   cWrkProject                             INIT   ""
   DATA   cWrkTheme                               INIT   ""
   DATA   cWrkCodec                               INIT   "EN"  // "UTF8EX"
   DATA   cWrkPathMk2                             INIT   hb_getenv( "HBIDE_DIR_HBMK2" )
   DATA   cWrkPathEnv                             INIT   hb_DirBase()
   DATA   cWrkEnvironment                         INIT   ""
   DATA   cWrkFind                                INIT   ""
   DATA   cWrkFolderFind                          INIT   ""
   DATA   cWrkReplace                             INIT   ""
   DATA   cWrkView                                INIT   "Main"
   DATA   cWrkHarbour                             INIT   ""
   DATA   cPathShortcuts                          INIT   ""
   DATA   cTextExtensions                         INIT   ""
   DATA   oEnvironment
   DATA   cPathSkltns                             INIT   ""
   DATA   cSaveTo                                 INIT   ""
   DATA   oOpenedSources
   DATA   resPath                                 INIT   ":/resources" + hb_ps()
   DATA   pathSep                                 INIT   hb_ps()
   DATA   cLastFileOpenPath                       INIT   hb_DirBase() + "projects" + hb_ps()
   DATA   cProcessInfo
   DATA   cIniThemes
   DATA   cSeparator                              INIT   "/*" + replicate( "-", 70 ) + "*/"
   DATA   nTabSpaces                              INIT   3           // Via User Setup
   DATA   cTabSpaces                              INIT   space( 3 )
   DATA   aTags                                   INIT   {}
   DATA   aText                                   INIT   {}
   DATA   aSkltns                                 INIT   {}
   DATA   aSources                                INIT   {}
   DATA   aFuncList                               INIT   {}
   DATA   aLines                                  INIT   {}
   DATA   aComments                               INIT   {}
   DATA   aProjects                               INIT   {}
   DATA   aUserDict                               INIT   {}
   DATA   aMarkTBtns                              INIT   array( 6 )
   DATA   lClosing                                INIT   .f.
   DATA   lStatusBarVisible                       INIT   .t.
   DATA   nModeUI                                 INIT   UI_MODE_DEFAULT
   DATA   oSys
   DATA   oSysMenu
   DATA   lSortedFuncList                         INIT   .t.
   DATA   lQuitting                               INIT   .f.
   DATA   hHeaderFiles                            INIT   {=>}

   // debugger interface
   DATA   oDebugger
   DATA   oDebugWatch
   DATA   oDebugVariables
   DATA   oDebugStack
   DATA   oDebugWorkAreas


   METHOD new( aParams )
   METHOD create( aParams )
   METHOD destroy()

   METHOD setPosAndSizeByIniEx( qWidget, cParams )
   METHOD setPosByIniEx( qWidget, cParams )

   METHOD manageFocusInEditor()
   METHOD removeProjectTree( aPrj )
   METHOD updateProjectTree( aPrj )
   METHOD manageItemSelected( oXbpTreeItem )
   METHOD manageProjectContext( mp1, mp2, oXbpTreeItem )
   METHOD updateFuncList( lSorted )
   METHOD gotoFunction( mp1, mp2, oListBox )
   METHOD manageFuncContext( mp1, mp2, oXbp )
   METHOD createTags()
   METHOD updateProjectMenu()
   METHOD updateTitleBar()
   METHOD setCodec( cCodec, lMenuOption )

   METHOD execAction( cKey )
   METHOD execProjectAction( cKey )
   METHOD execSourceAction( cKey )
   METHOD execEditorAction( cKey )

   METHOD showApplicationCursor( nCursor )
   METHOD testPainter( qPainter )

   METHOD parseParams()
   METHOD showCodeFregment( oXbp )
   METHOD setCodePage( cCodePage )
   METHOD showFragment( cCode, cTitle, oIcon, cTheme )
   METHOD showHeaderFile( cCode, cTitle, oIcon, lSave )
   METHOD printFragment( oPlainTextEdit )
   METHOD ideAlert( ... )                            INLINE Alert( ... )

   ENDCLASS


METHOD HbIde:destroy()
   RETURN self


METHOD HbIde:new( aParams )

   hb_HCaseMatch( ::hHeaderFiles, .F. )

   DEFAULT aParams TO ::aParams
   ::aParams := aParams
   RETURN self


METHOD HbIde:create( aParams )
   LOCAL qPixmap, qSplash, cView
   LOCAL mp1, mp2, oXbp, nEvent

   ::oColorizeEffect := QGraphicsColorizeEffect()

   qPixmap := QPixmap( ":/resources/hbide-2014.png" )
   qSplash := QSplashScreen()
   qSplash:setPixmap( qPixmap )
   qSplash:show()
   ::showApplicationCursor( Qt_BusyCursor )
   QApplication():processEvents()

   DEFAULT aParams TO ::aParams
   ::aParams := aParams
   ::parseParams()

   /* Setup GUI Error Reporting System*/
   hbqt_errorsys()

   /* Post self to set/get function - object variables may be needed on functions level */
   hbide_setIde( Self )

   /* Editor's Font - TODO: User Managed Interface */
   ::oFont := XbpFont():new()
   ::oFont:fixed := .t.
   ::oFont:create( "10.Courier" )

   /* Functions Tag Manager */
   ::oFN := IdeFunctions():new( Self ):create()

   /* Skeletons Manager     */
   ::oSK := IdeSkeletons():new( Self ):create()

   /* Initiate UI Source Manager */
   ::oUiS := IdeUISrcManager():new( Self ):create()

   /* Initiate Project Wizard */
   ::oPWZ := IdeProjectWizard():new( Self ):create()

   /* Initialte Project Manager */
   ::oPM := IdeProjManager():new( Self ):create()

   /* INI Manager - array base to be removed later */
   ::oINI := IdeINI():new( Self ):create()
   IF ::nRunMode == HBIDE_RUN_MODE_INI
      ::oINI:load( ::cProjIni )
   ENDIF

   /* Load Persistent Scripts - hbide_persist_*.prg | hbs */
   hbide_loadPersistentScripts()

   /* Load User Dictionaries */
   hbide_loadUserDictionaries( Self )

   /* Shortcuts */
   ::oSC := IdeShortcuts():new( Self ):create()

   /* Insert command line projects */
   aeval( ::aHbpOnCmdLine, {|e| aadd( ::oINI:aProjFiles, e ) } )
   /* Insert command line sources */
   aeval( ::aSrcOnCmdLine, {|e| aadd( ::oINI:aFiles, hbide_parseSourceComponents( e ) ) } )

   /* Store to restore when all preliminary operations are completed */
   cView := ::cWrkView

   /* Setup Manager */
   ::oSetup := IdeSetup():new( Self ):create()
   ::oSetup:setBaseColor()

   /* Load Code Skeletons */
   hbide_loadSkltns( Self )

   /* Parts Manager */
   ::oParts := IdeParts():new( Self ):create()

   /* Load IDE|User defined Themes */
   ::oTH := IdeThemes():new( Self, ::oINI:getThemesFile() ):create()

   /* DOCKing windows and ancilliary windows */
   ::oDK := IdeDocks():new( Self ):create()

   /* Tools Manager */
   ::oTM := IdeToolsManager():new( Self ):create()

   /* Actions */
   ::oAC := IdeActions():new( Self ):create()

   /* IDE's Main Window */
   ::oDK:buildDialog()

   /* Docking Widgets */
   ::oDK:buildDockWidgets()

   /* Toolbars */
   ::oAC:buildToolBars()

   /* Main Menu */
   ::oAC:buildMainMenu()

   /* Initialize ChangeLog Manager */
   ::oCL := IdeChangeLog():new( Self ):create()

   /* Initialize Doc Writer Manager */
   ::oDW := IdeDocWriter():new( Self ):create()

   /* Once create Find/Replace dialog */
   ::oFR := IdeFindReplace():new( Self ):create()
   ::oFF := IdeFindInFiles():new( Self ):create()
   ::oFM := IdeFunctionsMap():new( Self ):create()

   /* Sources Manager */
   ::oSM := IdeSourcesManager():new( Self ):create()

   /* Edits Manager */
   ::oEM := IdeEditsManager():new( Self ):create()

   /* Harbour Help Object */
   ::oHL := ideHarbourHelp():new( Self ):create()

   /* Load Environments */
   ::oEV := IdeEnvironments():new( Self ):create()

   /* Home Implementation */
   ::oHM := IdeHome():new( Self ):create()

   /* Browser Manager */
   ::oBM := IdeDbuMGR():new( Self ):create()

   /* HbIDE debugger */
   ::oDebugger := IdeDebugger():new( Self ):create()

   /* Reports Manager */
   ::oRM := HbpReports():new():create( ::oParts:oStackReports )

   /* Code Formatter Manager */
   ::oFmt := IdeFormat():new( Self ):create()

   /* Console Editor */
   ::oCUI := IdeConsole():new( Self ):create()

   ::oDlg:show()     /* Shifted here - it gives the effect that time opening HbIDE is much less */
   qSplash:raise()

   /* Fill various elements of the IDE */
   ::oPM:populate()
   ::oSM:loadSources()

   ::updateTitleBar()
   /* Set some last settings */
   ::oPM:setCurrentProject( ::cWrkProject, .f. )

   /* Again to be displayed in Statusbar */
   ::setCodec( ::cWrkCodec, .F. )
   ::oDK:setStatusText( SB_PNL_THEME, ::cWrkTheme )

   /* Display cWrkEnvironment in StatusBar */
   ::oDK:dispEnvironment( ::cWrkEnvironment )

   #if 0 /* for screen capture */
   n := seconds()
   DO WHILE .t.
      IF seconds() > n + 10
         EXIT
      ENDIF
      QApplication():processEvents()
   ENDDO
   #endif

   IF empty( ::cWrkFolderLast )
      ::cWrkFolderLast := hb_dirBase() + "projects" + hb_ps()
   ENDIF

   /* Request Main Window to Appear on the Screen */
   ::oHM:refresh()

   ::oDK:setViewInitials()

   /* Refresh Stylesheet for all components at once */
   ::oDK:animateComponents( ::nAnimantionMode )

   /* Restore Settings - just before making application visible */
   hbide_restSettings( Self )
   IF ! ::oINI:lShowHideDocks
      ::oINI:lShowHideDocks := .t.
      ::oINI:showHideDocks()
   ENDIF

   ::oDockB2:hide() /* This widget never contains anything so must be forced to hide */

   IF ::nRunMode == HBIDE_RUN_MODE_PRG
      ::oDockPT:hide()
      ::oDockED:hide()
      ::oAC:qTBarDocks:hide()
      ::oMainToolbar:hide()
      ::oDK:setView( "Main" )
   ELSEIF ::nRunMode == HBIDE_RUN_MODE_HBP
      ::oDockED:hide()
      ::oDockPT:show()
      ::oDK:setView( "Main" )
   ELSE
      ::oDK:setView( "Main" )
      ::oDK:setView( cView )
   ENDIF

   IF ! empty( ::aDbfOnCmdLine )      /* Will take priority and allot more width to browser than editor : logical */
      ::oBM:oDbu:open( ::aDbfOnCmdLine )
      ::oParts:setStack( IDE_PART_DBU )
   ENDIF

   ::qTabWidget:setCurrentIndex( -1 )
   ::qTabWidget:setCurrentIndex( 0 )
   ::qTabWidget:setCurrentIndex( ::qTabWidget:count() - 1 )
   ::qTabWidget:setCurrentIndex( val( ::oINI:cRecentTabIndex ) )

   ::showApplicationCursor()
   qSplash:close()
   qSplash := NIL
   qPixMap := NIL

   /* Load tags last tagged projects */
   ::oFN:loadTags( ::oINI:aTaggedProjects, .F. )

   /* Run Auto Scripts */
   hbide_execAutoScripts()

   /* Initialize plugins  */
   hbide_loadPlugins( Self, "1.0" )

   /* Fill auto completion lists - it must be the last action and be present here always */
   ::oEM:updateCompleter()
   ::oAC:qSelToolbar:hide()

   DO WHILE .t.
      nEvent := AppEvent( @mp1, @mp2, @oXbp )
      IF nEvent != 0
         IF nEvent == xbeP_Quit
            ::lQuitting := .t.
            ::oINI:save()
            EXIT
         ENDIF

         IF nEvent == xbeP_Close .AND. oXbp == ::oDlg
            IF hbide_setClose()
               ::lQuitting := .t.
               ::oDebugger:quit()
               ::oINI:save()
               ::oSM:closeAllSources( .f. /* can not cancel */ )
               EXIT
            ENDIF

         ELSEIF nEvent == xbeP_Keyboard
            SWITCH mp1

            CASE xbeK_INS
               IF !empty( ::qCurEdit )
                  ::qCurEdit:setOverwriteMode( !::qCurEdit:overwriteMode() )
                  ::oCurEditor:dispEditInfo( ::qCurEdit )
               ENDIF

            ENDSWITCH
         ENDIF

         oXbp:handleEvent( nEvent, mp1, mp2 )
      ENDIF
   ENDDO

   hbide_setExitCuiEd( .t. )

   DbCloseAll()
   ::cProjIni := NIL
   hbide_setIde( NIL )
   hbide_destroyPlugins()
   RETURN self


METHOD HbIde:parseParams()
   LOCAL s, cPath, cName, cExt, cCurPath
   LOCAL aIni := {}

   FOR EACH s IN ::aParams
      s := alltrim( s )

      DO CASE
      CASE left( s, 1 ) == "-"
         // Switches, futuristic
      OTHERWISE
         cCurPath := hb_CurDrive() + hb_osDriveSeparator() + hb_osPathSeparator() + CurDir() + hb_osPathSeparator()
         hb_fNameSplit( s, @cPath, @cName, @cExt )
         IF ! Empty( cExt )
            IF Empty( cPath )
               cPath := cCurPath
            ELSEIF Left( s, 2 ) == ".."
               cPath := cCurPath
            ENDIF
            IF Left( s, 2 ) == ".."
               s := cPath + s
            ELSE
               s := cPath + cName + cExt
            ENDIF
         ENDIF
         cExt := lower( cExt )
         DO CASE
         CASE cExt == ".ini"
            aadd( aIni, s )
         CASE cExt == ".dbf"
            aadd( ::aDbfOnCmdLine, s )
         CASE cExt == ".hbp"
            aadd( ::aHbpOnCmdLine, s )
         CASE cExt $ ".prg.hb.cpp"
            aadd( ::aSrcOnCmdLine, s )
         CASE hbide_isValidText( s )
            aadd( ::aSrcOnCmdLine, s )
         ENDCASE
      ENDCASE
   NEXT

   IF !empty( aIni )                       /* Discard aHbp */
      ::cProjIni := aIni[ 1 ]
      ::nRunMode := HBIDE_RUN_MODE_INI
   ELSEIF !empty( ::aHbpOnCmdLine )
      ::cProjIni := ""
      ::nRunMode := HBIDE_RUN_MODE_HBP
   ELSEIF !empty( ::aSrcOnCmdLine )
      ::cProjIni := ""
      ::nRunMode := HBIDE_RUN_MODE_PRG
   ELSEIF !empty( ::aDbfOnCmdLine )
      ::cProjIni := ""
      ::nRunMode := HBIDE_RUN_MODE_PRG    /* Because then bare-bone HbIDE will be presented like sources */
   ELSE
      ::cProjIni := ""
      ::nRunMode := HBIDE_RUN_MODE_INI
   ENDIF
   RETURN Self


METHOD HbIde:showApplicationCursor( nCursor )
   LOCAL qCrs

   IF empty( nCursor )
      QApplication():restoreOverrideCursor()
   ELSE
      qCrs := QCursor( nCursor )
      QApplication():setOverrideCursor( qCrs )
   ENDIF
   RETURN Self


METHOD HbIde:execAction( cKey )

   SWITCH cKey
   CASE "Hide"                 ; ::oINI:showHideDocks()       ; EXIT
   CASE "SaveState"            ; ::oINI:save()                ; EXIT
   CASE "ToggleStatusBar"
      IF ::lStatusBarVisible
         ::oSBar:oWidget:hide()
      ELSE
         ::oSBar:oWidget:show()
      ENDIF
      ::lStatusBarVisible := ! ::lStatusBarVisible
      ::qStatusBarAction:setChecked( ::lStatusBarVisible )    ; EXIT
   CASE "ChangeLog"            ; ::oCL:show()                 ; EXIT
   CASE "Tools"                ; ::oTM:show()                 ; EXIT
   CASE "Environments"         ; ::oEV:fetchNew()             ; EXIT
   CASE "Exit"
      ::lQuitting := .t.
      hbide_setClose( .T. )
      PostAppEvent( xbeP_Close, NIL, NIL, ::oDlg )            ; EXIT
   CASE "Home"                 ; ::oHM:show()                 ; RETURN Self
   CASE "Animate"              ; ::oDK:animateComponents()    ; EXIT
   CASE "Setup"                ; ::oSetup:show()              ; EXIT
   CASE "Shortcuts"            ; ::oSC:show()                 ; EXIT
   CASE "NewProject"
   CASE "LoadProject"
   CASE "LaunchProject"
   CASE "LaunchDebug"
   CASE "RunAsScript"
   CASE "BuildSource"
   CASE "Build"
   CASE "BuildLaunch"
   CASE "BuildLaunchDebug"
   CASE "Rebuild"
   CASE "RebuildLaunch"
   CASE "RebuildLaunchDebug"
   CASE "Compile"
   CASE "CompilePPO"
   CASE "Properties"
   CASE "SelectProject"
   CASE "CloseProject"         ; ::execProjectAction( cKey )  ; EXIT
   CASE "New"
   CASE "Open"
   CASE "Save"
   CASE "SaveAs"
   CASE "SaveAll"
   CASE "SaveExit"
   CASE "Revert"
   CASE "Close"
   CASE "CloseAll"
   CASE "CloseOther"           ; ::execSourceAction( cKey )   ; EXIT
   CASE "Print"
   CASE "Undo"
   CASE "Redo"
   CASE "Cut"
   CASE "Copy"
   CASE "Paste"
   CASE "SelectAll"
   CASE "SelectionMode"
   CASE "DuplicateLine"
   CASE "DeleteLine"
   CASE "MoveLineUp"
   CASE "MoveLineDown"
   CASE "BlockComment"
   CASE "StreamComment"
   CASE "BlockIndentR"
   CASE "BlockIndentL"
   CASE "BlockSgl2Dbl"
   CASE "BlockDbl2Sgl"
   CASE "switchReadOnly"
   CASE "Find"
   CASE "FindEx"
   CASE "SetMark"
   CASE "GotoMark"
   CASE "Goto"
   CASE "ToUpper"
   CASE "ToLower"
   CASE "Invert"
   CASE "MatchPairs"
   CASE "InsertSeparator"
   CASE "InsertDateTime"
   CASE "InsertRandomName"
   CASE "InsertExternalFile"
   CASE "ZoomIn"
   CASE "ZoomOut"
   CASE "UpperCaseKeywords"
   CASE "FormatBraces"
   CASE "FormatOperators"
   CASE "FormatCommas"
   CASE "RemoveTabs"
   CASE "Spaces2Tabs"
   CASE "RemoveTrailingSpaces" ; ::execEditorAction( cKey )                    ; EXIT
   CASE "Help"                 ; ::oHelpDock:show()                            ; EXIT
   CASE "EDITOR"               ; ::oParts:setStack( IDE_PART_EDITOR )          ; EXIT
   CASE "DBU"                  ; ::oParts:setStack( IDE_PART_DBU )             ; EXIT
   CASE "REPORTS"              ; ::oParts:setStack( IDE_PART_REPORTSDESIGNER ) ; EXIT
   CASE "ToggleProjectTree"
   CASE "ToggleBuildInfo"
   CASE "ToggleFuncList"       ;                                               ; EXIT
   ENDSWITCH
   ::manageFocusInEditor()
   RETURN nil


METHOD HbIde:execEditorAction( cKey )

   SWITCH cKey

   CASE "Print"                ;  ::oEM:printPreview()           ;  EXIT
   CASE "Undo"                 ;  ::oEM:undo()                   ;  EXIT
   CASE "Redo"                 ;  ::oEM:redo()                   ;  EXIT
   CASE "Cut"                  ;  ::oEM:cut()                    ;  EXIT
   CASE "Copy"                 ;  ::oEM:copy()                   ;  EXIT
   CASE "Paste"                ;  ::oEM:paste()                  ;  EXIT
   CASE "SelectAll"            ;  ::oEM:selectAll()              ;  EXIT
   CASE "SelectionMode"        ;  ::oEM:toggleSelectionMode()    ;  EXIT
   CASE "DuplicateLine"        ;  ::oEM:duplicateLine()          ;  EXIT
   CASE "MoveLineUp"           ;  ::oEM:moveLine( -1 )           ;  EXIT
   CASE "MoveLineDown"         ;  ::oEM:moveLine( 1 )            ;  EXIT
   CASE "DeleteLine"           ;  ::oEM:deleteLine()             ;  EXIT
   CASE "BlockComment"         ;  ::oEM:blockComment()           ;  EXIT
   CASE "StreamComment"        ;  ::oEM:streamComment()          ;  EXIT
   CASE "BlockIndentR"         ;  ::oEM:indent( 1 )              ;  EXIT
   CASE "BlockIndentL"         ;  ::oEM:indent( -1 )             ;  EXIT
   CASE "BlockSgl2Dbl"         ;  ::oEM:convertDQuotes()         ;  EXIT
   CASE "BlockDbl2Sgl"         ;  ::oEM:convertQuotes()          ;  EXIT
   CASE "switchReadOnly"       ;  ::oEM:switchToReadOnly()       ;  EXIT
   CASE "Find"                 ;  ::oEM:find()                   ;  EXIT
   CASE "SetMark"              ;  ::oEM:setMark()                ;  EXIT
   CASE "GotoMark"             ;  ::oEM:gotoMark()               ;  EXIT
   CASE "Goto"                 ;  ::oEM:goTo()                   ;  EXIT
   CASE "ToUpper"              ;  ::oEM:convertSelection( cKey ) ;  EXIT
   CASE "ToLower"              ;  ::oEM:convertSelection( cKey ) ;  EXIT
   CASE "Invert"               ;  ::oEM:convertSelection( cKey ) ;  EXIT
   CASE "Tools"                ;  ::oTM:show()                   ;  EXIT
   CASE "InsertSeparator"      ;  ::oEM:insertSeparator()        ;  EXIT
   CASE "InsertDateTime"       ;  ::oEM:insertText( cKey )       ;  EXIT
   CASE "InsertRandomName"     ;  ::oEM:insertText( cKey )       ;  EXIT
   CASE "InsertExternalFile"   ;  ::oEM:insertText( cKey )       ;  EXIT
   CASE "ZoomIn"               ;  ::oEM:zoom( +1 )               ;  EXIT
   CASE "ZoomOut"              ;  ::oEM:zoom( -1 )               ;  EXIT
   CASE "UpperCaseKeywords"    ;  ::oEM:upperCaseKeywords()      ;  EXIT
   CASE "FormatBraces"         ;  ::oEM:formatBraces( 0 )        ;  EXIT
   CASE "FormatOperators"      ;  ::oEM:formatBraces( 1 )        ;  EXIT
   CASE "FormatCommas"         ;  ::oEM:formatBraces( 2 )        ;  EXIT
   CASE "RemoveTabs"           ;  ::oEM:removeTabs()             ;  EXIT
   CASE "Spaces2Tabs"          ;  ::oEM:spaces2tabs()            ;  EXIT
   CASE "RemoveTrailingSpaces" ;  ::oEM:removeTrailingSpaces()   ;  EXIT
   CASE "FindEx"               ;  IF ! Empty( ::qCurEdit ) ; ::oSearchReplace:beginFind() ; ENDIF ; EXIT
   CASE "MatchPairs"           ;  EXIT
   ENDSWITCH
   RETURN Self


METHOD HbIde:execSourceAction( cKey )
   SWITCH cKey
   CASE "New"        ; ::oSM:editSource( "" )                              ; EXIT
   CASE "Open"       ; ::oSM:openSource()                                  ; EXIT
   CASE "Save"       ; ::oSM:saveSource( ::oEM:getTabCurrent(), .f., .f. ) ; EXIT
   CASE "SaveAs"     ; ::oSM:saveSource( ::oEM:getTabCurrent(), .t., .t. ) ; EXIT
   CASE "SaveAll"    ; ::oSM:saveAllSources()                              ; EXIT
   CASE "SaveExit"   ; ::oSM:saveAndExit()                                 ; EXIT
   CASE "Revert"     ; ::oSM:RevertSource()                                ; EXIT
   CASE "Close"      ; ::oSM:closeSource()                                 ; EXIT
   CASE "CloseAll"   ; ::oSM:closeAllSources()                             ; EXIT
   CASE "CloseOther" ; ::oSM:closeAllOthers()                              ; EXIT
   ENDSWITCH
   RETURN Self


METHOD HbIde:execProjectAction( cKey )
   SWITCH cKey
   CASE "NewProject"         ; ::oPM:loadProperties( , .t., .t., .t. )      ; EXIT
   CASE "LoadProject"        ; ::oPM:loadProperties( , .f., .f., .t. )      ; EXIT
   CASE "LaunchProject"      ; ::oPM:launchProject()                        ; EXIT
   CASE "LaunchDebug"        ; ::oPM:launchDebug()                          ; EXIT
   CASE "RunAsScript"        ; ::oPM:runAsScript( .t. )                     ; EXIT
   CASE "BuildSource"        ; ::oPM:buildSource( .t. )                     ; EXIT
   CASE "Build"              ; ::oPM:buildProject( '', .F., .F. )           ; EXIT
   CASE "BuildLaunch"        ; ::oPM:buildProject( '', .T., .F. )           ; EXIT
   CASE "BuildLaunchDebug"   ; ::oPM:buildProject( '', .T., .F., NIL, NIL, NIL, .T. ) ; EXIT
   CASE "Rebuild"            ; ::oPM:buildProject( '', .F., .T. )           ; EXIT
   CASE "RebuildLaunch"      ; ::oPM:buildProject( '', .T., .T. )           ; EXIT
   CASE "RebuildLaunchDebug" ; ::oPM:buildProject( '', .T., .T., NIL, NIL, NIL, .T. ) ; EXIT
   CASE "Compile"            ; ::oPM:buildSource( .f. )                     ; EXIT
   CASE "CompilePPO"         ; ::oPM:buildProject( '', .F., .F., .T., .T. ) ; EXIT
   CASE "Properties"         ; ::oPM:getProperties()                        ; EXIT
   CASE "SelectProject"      ; ::oPM:selectCurrentProject()                 ; EXIT
   CASE "CloseProject"       ; ::oPM:removeProject()                        ; EXIT
   ENDSWITCH
   RETURN Self


METHOD HbIde:setPosAndSizeByIniEx( qWidget, cParams )
   LOCAL aRect

   IF !empty( cParams )
      aRect := hb_atokens( cParams, "," )
      aeval( aRect, {|e,i| aRect[ i ] := val( e ) } )

      qWidget:move( aRect[ 1 ], aRect[ 2 ] )
      qWidget:resize( aRect[ 3 ], aRect[ 4 ] )
   ENDIF
   RETURN Self


METHOD HbIde:setPosByIniEx( qWidget, cParams )
   LOCAL aRect

   IF !empty( cParams )
      aRect := hb_atokens( cParams, "," )
      aeval( aRect, {|e,i| aRect[ i ] := val( e ) } )

      qWidget:move( aRect[ 1 ], aRect[ 2 ] )
   ENDIF
   RETURN Self


METHOD HbIde:manageFocusInEditor()
   LOCAL qEdit

   IF !empty( qEdit := ::oEM:getEditCurrent() )
      qEdit:setFocus( 0 )
   ENDIF
   RETURN self


METHOD HbIde:removeProjectTree( aPrj )
   LOCAL oProject, nIndex, oParent, oP, n

   oProject := IdeProject():new( Self, aPrj )
   IF empty( oProject:title )
      RETURN Self
   ENDIF
   nIndex := AScan( ::aProjData, {|e_| e_[ TRE_TYPE ] == "Project Name" .AND. e_[ TRE_ORIGINAL ] == oProject:title } )
   IF nIndex > 0
      oParent := ::aProjData[ nIndex, TRE_OITEM ]
      DO WHILE .t.
         n := ascan( ::aProjData, {|e_| e_[ TRE_OPARENT ] == oParent } )
         IF n == 0
            EXIT
         ENDIF
         oParent:delItem( ::aProjData[ n, TRE_OITEM ] )
         hb_adel( ::aProjData, n, .t. )
      ENDDO
   ENDIF

   oP := oParent

   SWITCH oProject:type
   CASE "Executable"
      oParent := ::aProjData[ 1, 1 ]
      EXIT
   CASE "Lib"
      oParent := ::aProjData[ 2, 1 ]
      EXIT
   CASE "Dll"
      oParent := ::aProjData[ 3, 1 ]
      EXIT
   ENDSWITCH

   nIndex := aScan( ::aProjData, {|e_| e_[ TRE_OITEM ] == oP } )
   oParent:delItem( oP )
   hb_adel( ::aProjData, nIndex, .t. )
   RETURN Self


METHOD HbIde:updateProjectTree( aPrj )
   LOCAL oProject, n, oSource, oItem, nProjExists, oP, oParent, a_:={}, b_

   oProject := IdeProject():new( Self, aPrj )

   IF empty( oProject:title )
      RETURN Self
   ENDIF

   SWITCH oProject:type
   CASE "Executable"
      oParent := ::aProjData[ 1, 1 ]
      EXIT
   CASE "Lib"
      oParent := ::aProjData[ 2, 1 ]
      EXIT
   CASE "Dll"
      oParent := ::aProjData[ 3, 1 ]
      EXIT
   ENDSWITCH

   nProjExists := aScan( ::aProjData, {|e_| e_[ TRE_TYPE ] == "Project Name" .AND. e_[ TRE_ORIGINAL ] == oProject:title } )

   IF nProjExists > 0
      nProjExists := aScan( oParent:aChilds, {|o| o:caption == oProject:title } )
      IF nProjExists > 0
         oP := oParent:aChilds[ nProjExists ]
      ELSE
         RETURN Self  /* Some Error - It must never happen */
      ENDIF
      /* Delete Existing Nodes */
      DO WHILE .t.
         IF ( n := ascan( ::aProjData, {|e_| e_[ TRE_OPARENT ] == oP } ) ) == 0
            EXIT
         ENDIF
         oP:delItem( ::aProjData[ n, TRE_OITEM ] )
         hb_adel( ::aProjData, n, .t. )
      ENDDO
   ENDIF
   IF empty( oP )
      oParent:expand( .T. )
      oP := oParent:addItem( oProject:title )
      oP:tooltipText := hbide_pathNormalized( ::oPM:getProjectFileNameFromTitle( oProject:title ) )
      aadd( ::aProjData, { oP, "Project Name", oParent, oProject:title, aPrj, oProject } )
   ENDIF
   FOR EACH oSource IN oProject:hSources
      aadd( a_, { oSource:ext, oSource:file, oSource } )
   NEXT
   IF !empty( a_ )
      asort( a_, , , {|e_,f_| lower( e_[ 1 ] + e_[ 2 ] ) < lower( f_[ 1 ] + f_[ 2 ] ) } )
   ENDIF
   FOR EACH b_ IN a_
      oSource := b_[ 3 ]
      oItem := oP:addItem( oSource:file + oSource:ext )
      oItem:tooltipText := oSource:original
      oItem:oWidget:setIcon( 0, QIcon( hbide_image( hbide_imageForFileType( oSource:ext ) ) ) )
      aadd( ::aProjData, { oItem, "Source File", oP, oSource:original, oProject:title } )
   NEXT
   RETURN Self


METHOD HbIde:manageItemSelected( oXbpTreeItem )
   LOCAL n, cHbp, cSource, cExt

   IF     oXbpTreeItem == ::oProjRoot
      n := -1
   ELSEIF oXbpTreeItem == ::oOpenedSources
      n := -2
   ELSE
      n := ascan( ::aProjData, {|e_| e_[ 1 ] == oXbpTreeItem } )
   ENDIF

   DO CASE
   CASE n ==  0  // Source File - nothing to do
   CASE n == -2  // "Files"
   CASE n == -1
   CASE ::aProjData[ n, TRE_TYPE ] == "Project Name"
      cHbp := ::oPM:getProjectFileNameFromTitle( ::aProjData[ n, TRE_ORIGINAL ] )
      ::oPM:loadProperties( cHbp, .f., .t., .f. )

   CASE ::aProjData[ n, TRE_TYPE ] == "Source File"
      cSource := AllTrim( hbide_stripFilter( ::aProjData[ n, TRE_ORIGINAL ] ) )
      IF Left( cSource, 2 ) == ".."               /* Assumed that relative paths for upper folder than .hbp base path start with ".." */
         cSource := hbide_pathNormalized( ::oPM:getProjectPathFromTitle( ::aProjData[ n,5 ] ) + cSource )
      ENDIF
      hb_fNameSplit( cSource, , , @cExt )
      IF lower( cExt ) == ".ui"
         ::oUiS:openUi( cSource )
      ELSE
         ::oSM:editSource( cSource )
      ENDIF

   CASE ::aProjData[ n, TRE_TYPE ] == "Opened Source"
      ::oEM:setSourceVisible( ::aProjData[ n, TRE_DATA ] )

   CASE ::aProjData[ n, TRE_TYPE ] == "Path"

   ENDCASE
   RETURN Self


METHOD HbIde:manageProjectContext( mp1, mp2, oXbpTreeItem )
   LOCAL n, cHbp, s, cProjectName
   LOCAL aPops := {}, aSub :={}, aEnv :={}

   HB_SYMBOL_UNUSED( mp2 )

   IF oXbpTreeItem == ::oProjRoot
      n  := -1
   ELSEIF oXbpTreeItem == ::oOpenedSources
      n  := -2
   ELSE
      n := ascan( ::aProjData, {|e_| e_[ 1 ] == oXbpTreeItem } )
   ENDIF

   DO CASE
   CASE n ==  0  // Source File - nothing to do
   CASE n == -2  // "Files"
   CASE n == -1  // Project Root
      aadd( aPops, { ::oAC:getAction( "CreateProject" )  , {|| ::oPM:loadProperties( NIL, .t., .t., .t. ) } } )
      aadd( aPops, { "" } )
      aadd( aPops, { ::oAC:getAction( "OpenProject" )    , {|| ::oPM:loadProperties( NIL, .f., .f., .t. ) } } )
      aadd( aPops, { "" } )
      //
      IF !empty( ::oEV:getNames() )
         aadd( aPops, { "" } )
         FOR EACH s IN ::oEV:getNames()
            aadd( aSub, { s, {|x| ::cWrkEnvironment := x, ::oDK:dispEnvironment( x ) } } )
         NEXT
         aadd( aPops, { aSub, "Environment..." } )
      ENDIF
      //
      hbide_ExecPopup( aPops, mp1, ::oProjTree:oWidget )

   CASE ::aProjData[ n, TRE_TYPE ] == "Project Name"
      cProjectName := oXbpTreeItem:caption

      cHbp := hbide_pathToOSPath( ::oPM:getProjectFileNameFromTitle( ::aProjData[ n, TRE_ORIGINAL ] ) )
      //
      IF !( Alltrim( Upper( ::cWrkProject ) ) == Alltrim( Upper( cProjectName ) ) )
         aadd( aPops, { "Set as Current"                      , {|| ::oPM:setCurrentProject( oXbpTreeItem:caption ) } } )
      ENDIF
      aadd( aPops, { ::oAC:getAction( "Properties"      )     , {|| ::oPM:loadProperties( cHbp, .f., .t., .t. ) } } )
      aadd( aPops, { "" } )
      aadd( aPops, { ::oAC:getAction( "BuildQt"         )     , {|| ::oPM:buildProject( cProjectName, .F., NIL, NIL, .T., NIL, .F. ) } } )
      aadd( aPops, { ::oAC:getAction( "BuildLaunchQt"   )     , {|| ::oPM:buildProject( cProjectName, .T., NIL, NIL, .T., NIL, .F. ) } } )
      aadd( aPops, { ::oAC:getAction( "ReBuildQt"       )     , {|| ::oPM:buildProject( cProjectName, .F., .T., NIL, .T., NIL, .F. ) } } )
      aadd( aPops, { ::oAC:getAction( "ReBuildLaunchQt" )     , {|| ::oPM:buildProject( cProjectName, .T., .T., NIL, .T., NIL, .F. ) } } )
      aadd( aPops, { "" } )
      //
      aadd( aPops, { ::oAC:getAction( "BuildLaunchDebug")     , {|| ::oPM:buildProject( cProjectName, .T., NIL, NIL, .T., NIL, .T. ) } } )
      aadd( aPops, { ::oAC:getAction( "ReBuildLaunchDebug")   , {|| ::oPM:buildProject( cProjectName, .T., .T., NIL, .T., NIL, .T. ) } } )
      //
      IF ! empty( ::oEV:getNames() )
         aadd( aPops, { "" } )
         FOR EACH s IN ::oEV:getNames()
            aadd( aEnv, { s                                   , {|x| ::oPM:buildProject( cProjectName, .T., NIL, NIL, .T., x, .F. ) } } )
         NEXT
         aadd( aPops, { aEnv, "Build and Launch with..." } )
      ENDIF
      //
      aadd( aPops, { "" } )
      aadd( aPops, { ::oAC:getAction( "LaunchProjectByTitle" ), {|| ::oPM:launchProject( cProjectName, NIL, ::cWrkEnvironment ) } } )
      aadd( aPops, { "" } )
      aadd( aPops, { "Remove Project"                         , {|| ::oPM:removeProject( cProjectName ) } } )
      //
      IF ! empty( ::oEV:getNames() )
         aadd( aPops, { "" } )
         FOR EACH s IN ::oEV:getNames()
            aadd( aSub, { s                                   , {|x| ::cWrkEnvironment := x, ::oDK:dispEnvironment( x ) } } )
         NEXT
         aadd( aPops, { aSub, "Select an Environment" } )
      ENDIF
      //
      aadd( aPops, { "" } )
      aadd( aPops, { ::oAC:getAction( "Dictionary"      )     , {|v| v := ::oFN:tagProject( ::aProjData[ n, TRE_ORIGINAL ], .F., .F. ), ;
                                                                     MsgBox( iif( Empty( v ), "Not Succeeded", v ), "Dictionary Creation" ) } } )

      hbide_ExecPopup( aPops, mp1, ::oProjTree:oWidget )

   CASE ::aProjData[ n, TRE_TYPE ] == "Source File"
      //

   CASE ::aProjData[ n, TRE_TYPE ] == "Opened Source"
      n := ::oEM:getTabBySource( ::aProjData[ n, 5 ] )
      //
      aadd( aPops, { "Save"                              , {|| ::oSM:saveSource( n )                 } } )
      aadd( aPops, { "Save As"                           , {|| ::oSM:saveSource( n, , .t. )          } } )
      aadd( aPops, { "" } )
      aadd( aPops, { "Close"                             , {|| ::oSM:closeSource( n )                } } )
      aadd( aPops, { "Close Others"                      , {|| ::oSM:closeAllOthers( n )             } } )
      aadd( aPops, { "" } )
      aadd( aPops, { "Apply Theme"                       , {|| ::oEM:getEditorCurrent():applyTheme() } } )
      //
      hbide_ExecPopup( aPops, mp1, ::oProjTree:oWidget )

   CASE ::aProjData[ n, 2 ] == "Path"

   ENDCASE

   ::manageFocusInEditor()
   RETURN Self


METHOD HbIde:updateFuncList( lSorted )
   LOCAL aFunc :={}, a_, nIndex

   DEFAULT lSorted TO ::lSortedFuncList

   ::lSortedFuncList := lSorted

   ::oFuncList:clear()
   IF !empty( ::aTags )
      IF lSorted
         aeval( ::aTags, {|e_| aadd( aFunc, { e_[ 6 ], e_[ 7 ] } ) } )
         asort( aFunc, , , {|e,f| lower( e[ 2 ] ) < lower( f[ 2 ] ) } )
         FOR EACH a_ IN aFunc
            nIndex := ::oFuncList:addItem( a_[ 2 ] )
            ::oFuncList:setIcon( nIndex, QIcon( hbide_identifierImage( a_[ 1 ] ) ) )
         NEXT
      ELSE
         FOR EACH a_ IN ::aTags
            nIndex := ::oFuncList:addItem( a_[ 7 ] )
            ::oFuncList:setIcon( nIndex, QIcon( hbide_identifierImage( a_[ 6 ] ) ) )
         NEXT
      ENDIF
   ENDIF
   RETURN Self


METHOD HbIde:showCodeFregment( oXbp )
   LOCAL xTmp2, n, i, cAnchor, oEdit, lFound, qCursor, nLine, cCode, nVPos

   xTmp2 := oXbp:text()

   IF ( n := ascan( ::aTags, {|e_| xTmp2 == e_[ 7 ] } ) ) > 0
      nLine := ::aTags[ n,3 ]
      cAnchor := trim( ::aText[ nLine ] )
      IF !empty( oEdit := ::oEM:getEditCurrent() )
         qCursor := oEdit:textCursor()
         nVPos := oEdit:verticalScrollBar():value()

         IF ! ( lFound := oEdit:find( cAnchor, QTextDocument_FindCaseSensitively ) )
            lFound := oEdit:find( cAnchor, QTextDocument_FindBackward + QTextDocument_FindCaseSensitively )
         ENDIF
         IF lFound
            oEdit:setTextCursor( QCursor )
            oEdit:verticalScrollBar():setValue( nVPos )

            cCode := ""
            qCursor:movePosition( QTextCursor_Start )
            IF Len( ::aTags ) == n
               IF qCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine - 1 )
                  cCode += qCursor:block():text() + hb_eol()
                  DO WHILE qCursor:movePosition( QTextCursor_Down )
                     cCode += qCursor:block():text() + hb_eol()
                  ENDDO
               ENDIF
            ELSE
               IF qCursor:movePosition( QTextCursor_Down, QTextCursor_MoveAnchor, nLine - 1 )
                  cCode += qCursor:block():text() + hb_eol()
                  FOR i := ::aTags[ n, 3 ] TO ::aTags[ n+1, 3 ] - 2
                     IF qCursor:movePosition( QTextCursor_Down )
                        cCode += qCursor:block():text() + hb_eol()
                     ENDIF
                  NEXT
               ENDIF
            ENDIF
         ENDIF
         IF ! Empty( cCode )
            ::showFragment( cCode, oEdit:document():metaInformation( QTextDocument_DocumentTitle ) + " : " + cAnchor, QIcon( hbide_identifierImage( ::aTags[ n, 6 ] ) )  )
         ENDIF
      ENDIF
   ENDIF
   ::manageFocusInEditor()
   RETURN Self


METHOD HbIde:showFragment( cCode, cTitle, oIcon, cTheme )
   LOCAL qWidget, qH

   DEFAULT cTheme TO "Pritpal's Favourite"

   WITH OBJECT qWidget := QPlainTextEdit( ::oDlg:oWidget )
      :setWindowFlags( hb_bitOr( Qt_Sheet, Qt_CustomizeWindowHint, Qt_WindowTitleHint, Qt_WindowCloseButtonHint ) )
      :setWindowTitle( cTitle )
      :setWindowIcon( oIcon )
      :setWordWrapMode( QTextOption_NoWrap )
      :setFont( QFont( "Courier New", 8 ) )
      qH := ::oTH:setSyntaxHilighting( qWidget, cTheme, , .F. )
      qH:hbSetInitialized( .T. )
      :setPlainText( cCode )
      :setGeometry( iif( Empty( ::qFuncFragmentWindowGeometry ), QRect( 500, 200, 300, 300 ), ::qFuncFragmentWindowGeometry:translated( 10,20 ) ) )
      :connect( QEvent_Close   , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry(), qWidget:setParent( QWidget() ) } )
      :connect( QEvent_Move    , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry() } )
      :connect( QEvent_Resize  , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry() } )
      :connect( QEvent_KeyPress, {|oKeyEvent|
                                    IF oKeyEvent:key() == Qt_Key_P .AND. hb_bitAnd( oKeyEvent:modifiers(), Qt_ControlModifier ) == Qt_ControlModifier
                                       ::printFragment( qWidget )
                                    ENDIF
                                    RETURN .F.
                                 } )
      :show()
   ENDWITH
   RETURN Self


METHOD HbIde:showHeaderFile( cCode, cTitle, oIcon, lSave )
   LOCAL qWidget, qH

   DEFAULT lSave TO .T.

   IF ! hb_HHasKey( ::hHeaderFiles, cTitle ) .OR. Empty( ::hHeaderFiles[ cTitle ] )

      WITH OBJECT qWidget := QPlainTextEdit( ::oDlg:oWidget )
         ::hHeaderFiles[ cTitle ] := qWidget

         :setWindowFlags( hb_bitOr( Qt_Sheet, Qt_CustomizeWindowHint, Qt_WindowTitleHint, Qt_WindowCloseButtonHint ) )
         :setWindowTitle( cTitle )
         :setWindowIcon( oIcon )
         :setWordWrapMode( QTextOption_NoWrap )
         :setFont( QFont( "Courier New", 8 ) )
         qH := ::oTH:setSyntaxHilighting( qWidget, "Evening Glamour", , .F. )
         qH:hbSetInitialized( .T. )
         :setPlainText( cCode )
         :setGeometry( iif( Empty( ::qFuncFragmentWindowGeometry ), QRect( 500, 200, 300, 300 ), ::qFuncFragmentWindowGeometry:translated( 10,20 ) ) )
         :connect( QEvent_Close   , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry(), qWidget:hide() } )
         :connect( QEvent_Move    , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry() } )
         :connect( QEvent_Resize  , {|| ::qFuncFragmentWindowGeometry := qWidget:geometry() } )
         :connect( QEvent_KeyPress, {|oKeyEvent|
                                       IF oKeyEvent:key() == Qt_Key_P .AND. hb_bitAnd( oKeyEvent:modifiers(), Qt_ControlModifier ) == Qt_ControlModifier
                                          ::printFragment( qWidget )
                                       ENDIF
                                       IF lSave .AND. oKeyEvent:key() == Qt_Key_S .AND. hb_bitAnd( oKeyEvent:modifiers(), Qt_ControlModifier ) == Qt_ControlModifier
                                          hb_MemoWrit( cTitle, qWidget:toPlainText() )
                                       ENDIF
                                       RETURN .F.
                                    } )
         :show()
      ENDWITH
   ELSE
      ::hHeaderFiles[ cTitle ]:show()
      ::hHeaderFiles[ cTitle ]:raise()
   ENDIF
   RETURN Self


METHOD HbIde:printFragment( oPlainTextEdit )
   LOCAL qDlg := QPrintPreviewDialog( oPlainTextEdit )

   qDlg:setWindowTitle( "HbIDE Fragment Previewer" )
   qDlg:connect( "paintRequested(QPrinter*)", {|p| oPlainTextEdit:print( p ) } )
   qDlg:resize( 500, 600 )
   qDlg:exec()
   RETURN self


METHOD HbIde:gotoFunction( mp1, mp2, oListBox )
   LOCAL n, cAnchor, oEdit, lFound, nHPos, nVPos, qCursor

   mp1 := oListBox:getData()
   mp2 := oListBox:getItem( mp1 )

   IF ( n := ascan( ::aTags, {|e_| mp2 == e_[ 7 ] } ) ) > 0
      cAnchor := trim( ::aText[ ::aTags[ n,3 ] ] )
      IF !empty( oEdit := ::oEM:getEditCurrent() )
         nHPos := oEdit:horizontalScrollBar():value()
         nVPos := oEdit:verticalScrollBar():value()
         qCursor := oEdit:textCursor()
         IF !( lFound := oEdit:find( cAnchor, QTextDocument_FindCaseSensitively ) )
            lFound := oEdit:find( cAnchor, QTextDocument_FindBackward + QTextDocument_FindCaseSensitively )
         ENDIF
         IF lFound
            oEdit:centerCursor()
            ::oEM:getEditObjectCurrent():aLastEditingPosition := { nHPos, nVPos, qCursor }
         ENDIF
      ENDIF
   ENDIF
   ::manageFocusInEditor()
   RETURN Self


METHOD HbIde:manageFuncContext( mp1, mp2, oXbp )
   LOCAL aPops := {}

   HB_SYMBOL_UNUSED( mp2 )

   IF ::oFuncList:numItems() > 0
      aadd( aPops, { "Show Sorted"           , {|| ::updateFuncList( .t. ) } } )
      aadd( aPops, { "Show in Natural Order" , {|| ::updateFuncList( .f. ) } } )
      aadd( aPops, { "" } )
      aadd( aPops, { "Show Code Fregment"    , {|| ::showCodeFregment( oXbp ) } } )
      aadd( aPops, { "" } )
      aadd( aPops, { "Comment out"           , {|| NIL } } )
      aadd( aPops, { "Reformat"              , {|| NIL } } )
      aadd( aPops, { "Print"                 , {|| NIL } } )
      aadd( aPops, { "Delete"                , {|| NIL } } )
      aadd( aPops, { "Move to another source", {|| NIL } } )

      hbide_ExecPopup( aPops, mp1, ::oFuncList:oWidget )

      ::manageFocusInEditor()
   ENDIF
   RETURN Self


METHOD HbIde:createTags()
   LOCAL aSumData := ""
   LOCAL cComments, aSummary, i, cPath, cSource, cExt

   ::aTags := {}

   FOR i := 1 TO Len( ::aSources )
      HB_FNameSplit( ::aSources[ i ], @cPath, @cSource, @cExt )

      IF Upper( cExt ) $ ".PRG.HB.CPP"
         IF !empty( ::aText := hbide_readSource( ::aSources[ i ] ) )
            aSumData  := {}

            cComments := CheckComments( ::aText )
            aSummary  := Summarize( ::aText, cComments, @aSumData , iif( Upper( cExt ) $ ".PRG.HB", 9, 1 ) )
            ::aTags   := UpdateTags( ::aSources[ i ], aSummary, aSumData, @::aFuncList, @::aLines, ::aText )

            #if 0
            IF !empty( aTags )
               aeval( aTags, {|e_| aadd( ::aTags, e_ ) } )
               ::hData[ cSource+cExt ] := { a[ i ], aTags, aclone( ::aText ), cComments, ::aFuncList, ::aLines }
               aadd( ::aSrcLines, ::aText   )
               aadd( ::aComments, cComments )
            ENDIF
            #endif
         ENDIF
      ENDIF
   NEXT
   RETURN NIL


/* Update the project menu to show current info.
 * 03/01/2010 - 12:48:18 - vailtom
 */
METHOD HbIde:updateProjectMenu()
   LOCAL oItem := hbide_mnuFindItem( Self, 'Project' )

   IF Empty( oItem )
      RETURN Self
   ENDIF
   IF Empty( ::cWrkProject )
      oItem[ 2 ]:setDisabled( .T. )
      RETURN Self
   ENDIF
   oItem[ 2 ]:setEnabled( .T. )
   RETURN Self


/* Updates the title bar of the main window, indicating the project and the
 * current filename.
 * 02/01/2010 - 16:30:06 - vailtom
 */
METHOD HbIde:updateTitleBar()
   LOCAL cTitle := "Harbour IDE (r" + __HBQT_REVISION__ + ")"
   LOCAL oEdit

   IF Empty( ::oDlg )
      RETURN Self
   ENDIF

   IF !Empty( ::cWrkProject )
      cTitle += " [" + ::cWrkProject + "] "
   ENDIF

   IF !empty( oEdit := ::oEM:getEditorCurrent() )
      IF Empty( oEdit:sourceFile )
         cTitle += " [" + oEdit:oTab:caption + "]"
      ELSE
         cTitle += " [" + oEdit:sourceFile + "]"
      ENDIF
   ENDIF

   ::oDlg:Title := cTitle
   ::oDlg:oWidget:setWindowTitle( ::oDlg:Title )
   RETURN Self


METHOD HbIde:setCodePage( cCodePage )
   hb_cdpSelect( cCodePage )
   RETURN Self


METHOD HbIde:setCodec( cCodec, lMenuOption )

   DEFAULT cCodec      TO ::cWrkCodec
   DEFAULT lMenuOption TO .T.

   IF lMenuOption
      IF hbide_getYesNo( "Want to make this codepage the default ?", "", cCodec, ::oDlg:oWidget )
         ::cWrkCodec := cCodec // hbide_getCDPforID( cCodec )
      ENDIF
   ENDIF
   ::oEM:setEncoding( cCodec )
   RETURN Self


METHOD HbIde:testPainter( qPainter )

   HB_TRACE( HB_TR_DEBUG, "qPainter:isActive()", qPainter:isActive() )

   qPainter:setPen( Qt_red )
   qPainter:drawEllipse( 100,300,100,150 )
   qPainter:setFont( ::oFont:oWidget )
   qPainter:drawText( 100,300,"Harbour" )

   //qPainter:fillRect( 100, 100, 500, 500, QColor( 175, 175, 255 ) )
   RETURN NIL


