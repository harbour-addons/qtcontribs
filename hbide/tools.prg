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
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                               20Mar2010
 */
/*----------------------------------------------------------------------*/

#include "hbide.ch"
#include "common.ch"
#include "hbclass.ch"
#include "hbqtgui.ch"


#define __buttonAdd_clicked__                     2000
#define __buttonDelete_clicked__                  2001
#define __buttonUp_clicked__                      2002
#define __buttonDown_clicked__                    2003
#define __buttonExec_clicked__                    2004
#define __buttonBrowse_clicked__                  2005
#define __buttonUpdate_clicked__                  2006
#define __buttonClose_clicked__                   2007
#define __listNames_itemSelectionChanged__        2008
#define __buttonSetImage_clicked__                2019
#define __buttonUserToolbarUpd_clicked__          2010
#define __comboToolbarAsgnd_currentIndexChanged__ 2011
#define __listToolbars_itemSelectionChanged__     2012
#define __checkToolActive_stateChanged__          2013
#define __User_Toolbar_clicked__                  2014


CLASS IdeToolsManager INHERIT IdeObject

   DATA   aAct                                    INIT   {}
   DATA   aSetAct                                 INIT   {}
   DATA   qToolsMenu
   DATA   qToolsButton
   DATA   qViewsMenu
   DATA   qViewsButton
   DATA   aPanelsAct                              INIT   {}
   DATA   qPanelsButton
   DATA   qPanelsMenu
   DATA   oProcess
   DATA   lExecuting                              INIT   .f.
   DATA   aHdr                                    INIT   {}
   DATA   aBtns                                   INIT   {}
   DATA   aToolbars                               INIT   { NIL,NIL,NIL,NIL,NIL }
   DATA   aPlugins                                INIT   {}
   DATA   cSetsFolderLast
   DATA   oUIPnls

   ACCESS aTools                                  INLINE ::oINI:aTools
   ACCESS aUserToolBars                           INLINE ::oINI:aUserToolbars

   METHOD init( oIde )
   METHOD create( oIde )
   METHOD destroy()
   METHOD show()
   METHOD execEvent( nEvent, p )
   METHOD clearList()
   METHOD populateList( aList )
   METHOD execTool( ... )
   METHOD execToolByParams( cCmd, cParams, cStartIn, lCapture, lOpen )
   METHOD ini2controls( nIndex )
   METHOD controls2ini( nIndex )
   METHOD buildToolsButton()
   METHOD buildPanelsButton()
   METHOD addPanelsMenu( cPrompt )
   METHOD showOutput( cOut, mp2, oHbp )
   METHOD finished( nEC, nES, oHbp )
   METHOD ini2toolbarControls( nIndex, nMode )
   METHOD populateButtonsTable( nIndex )
   METHOD buildUserToolbars()
   METHOD populatePlugins( lClear )
   METHOD setStyleSheet( cCSS )
   METHOD buildViewsButton()
   METHOD saveView()
   METHOD execView( cView )
   METHOD managePanels()
   METHOD arrangePanels()
   METHOD deletePanel( cView )

   ENDCLASS


METHOD IdeToolsManager:init( oIde )
   ::oIde := oIde
   ::cSetsFolderLast := oIde:oINI:getINIPath()
   RETURN Self


METHOD IdeToolsManager:setStyleSheet( cCSS )
   LOCAL oToolbar
   FOR EACH oToolbar IN ::aToolbars
      IF !empty( oToolbar )
         oToolbar:setStyleSheet( cCSS )
      ENDIF
   NEXT
   ::qToolsMenu:setStyleSheet( GetStyleSheet( "QMenuPop", ::nAnimantionMode ) )
   ::qPanelsMenu:setStyleSheet( GetStyleSheet( "QMenuPop", ::nAnimantionMode ) )
   RETURN Self


METHOD IdeToolsManager:create( oIde )
   DEFAULT oIde TO ::oIde
   ::oIde := oIde

   IF empty( ::oINI:aUserToolbars )
      asize( ::oINI:aUserToolbars, 5 )
      DEFAULT ::oINI:aUserToolbars[ 1 ] TO { "","YES","","","YES","YES","YES" }
      DEFAULT ::oINI:aUserToolbars[ 2 ] TO { "","YES","","","YES","YES","YES" }
      DEFAULT ::oINI:aUserToolbars[ 3 ] TO { "","YES","","","YES","YES","YES" }
      DEFAULT ::oINI:aUserToolbars[ 4 ] TO { "","YES","","","YES","YES","YES" }
      DEFAULT ::oINI:aUserToolbars[ 5 ] TO { "","YES","","","YES","YES","YES" }
   ENDIF
   RETURN Self


METHOD IdeToolsManager:destroy()
   LOCAL qAct, xTmp
   IF !empty( ::oUI )
      WITH OBJECT ::oUI
         FOR EACH qAct IN ::aAct
            qAct:disconnect( "triggered(bool)" )
            qAct := NIL
         NEXT
         FOR EACH qAct IN ::aPanelsAct
            qAct:disconnect( "triggered(bool)" )
            qAct := NIL
         NEXT
         ::qToolsButton:disconnect( "clicked()" )
         ::qToolsButton := NIL
         ::clearList()
         ::qPanelsButton      :disconnect( "clicked()" )
         //
         :buttonAdd           :disconnect( "clicked()" )
         :buttonDelete        :disconnect( "clicked()" )
         :buttonUp            :disconnect( "clicked()" )
         :buttonDown          :disconnect( "clicked()" )
         :buttonExec          :disconnect( "clicked()" )
         :buttonBrowse        :disconnect( "clicked()" )
         :buttonUpdate        :disconnect( "clicked()" )
         :buttonClose         :disconnect( "clicked()" )
         :buttonSetImage      :disconnect( "clicked()" )
         :buttonUserToolbarUpd:disconnect( "clicked()" )
         :comboToolbarAsgnd   :disconnect( "currentIndexChanged(int)" )
         :listToolbars        :disconnect( "itemSelectionChanged()"   )
         :listNames           :disconnect( "itemSelectionChanged()"   )
         //
         :destroy()
      ENDWITH
   ENDIF
   FOR EACH xTmp IN ::aBtns
      xTmp:disconnect( "clicked()" )
      xTmp := NIL
   NEXT
   FOR EACH xTmp IN ::aToolbars
      xTmp := NIL
   NEXT
   IF .T.
      ::aAct            := NIL
      ::qToolsMenu      := NIL
      ::qToolsButton    := NIL
      ::aPanelsAct      := NIL
      ::qPanelsButton   := NIL
      ::qPanelsMenu     := NIL
      ::oProcess        := NIL
      ::lExecuting      := NIL
      ::aHdr            := NIL
      ::aBtns           := NIL
      ::aToolbars       := NIL
      ::aPlugins        := NIL
   ENDIF
   RETURN Self


METHOD IdeToolsManager:show()
   LOCAL hdr_, n, qItm
   
   IF empty( ::oUI )
      WITH OBJECT ::oUI := hbide_getUI( "toolsutilities", ::oDlg:oWidget )
         :setWindowFlags( Qt_Sheet )
         :setWindowIcon( QIcon( hbide_image( "hbide" ) ) )
         :setMaximumWidth( :width() )
         :setMinimumWidth( :width() )
         :setMaximumHeight( :height() )
         :setMinimumHeight( :height() )
         :buttonAdd   :connect( "clicked()", {|| ::execEvent( __buttonAdd_clicked__    ) } )
         :buttonDelete:connect( "clicked()", {|| ::execEvent( __buttonDelete_clicked__ ) } )
         :buttonUp    :connect( "clicked()", {|| ::execEvent( __buttonUp_clicked__     ) } )
         :buttonDown  :connect( "clicked()", {|| ::execEvent( __buttonDown_clicked__   ) } )
         :buttonExec  :connect( "clicked()", {|| ::execEvent( __buttonExec_clicked__   ) } )
         :buttonBrowse:connect( "clicked()", {|| ::execEvent( __buttonBrowse_clicked__ ) } )
         :buttonUpdate:connect( "clicked()", {|| ::execEvent( __buttonUpdate_clicked__ ) } )
         :buttonClose :connect( "clicked()", {|| ::execEvent( __buttonClose_clicked__  ) } )
         :listNames   :connect( "itemSelectionChanged()", {|| ::execEvent( __listNames_itemSelectionChanged__ ) } )
         :buttonBtnDown :setIcon( QIcon( hbide_image( "dc_down" ) ) )
         :buttonBtnUp :setIcon( QIcon( hbide_image( "dc_up"   ) ) )
         WITH OBJECT :buttonSetImage()
            :setIcon( QIcon( hbide_image( "open"    ) ) )
            :connect( "clicked()", {|| ::execEvent( __buttonSetImage_clicked__ ) } )
         ENDWITH 
         :buttonUserToolbarUpd:connect( "clicked()", {|| ::execEvent( __buttonUserToolbarUpd_clicked__ ) } )
         WITH OBJECT :comboToolbarAsgnd()
            :addItem( "User_Toolbar_1" )
            :addItem( "User_Toolbar_2" )
            :addItem( "User_Toolbar_3" )
            :addItem( "User_Toolbar_4" )
            :addItem( "User_Toolbar_5" )
            :setCurrentIndex( -1 )
            :connect( "currentIndexChanged(int)", {|p| ::execEvent( __comboToolbarAsgnd_currentIndexChanged__, p ) } )
         ENDWITH
         WITH OBJECT :listToolbars()
            :addItem( "User_Toolbar_1" )
            :addItem( "User_Toolbar_2" )
            :addItem( "User_Toolbar_3" )
            :addItem( "User_Toolbar_4" )
            :addItem( "User_Toolbar_5" )
            :connect( "itemSelectionChanged()", {|| ::execEvent( __listToolbars_itemSelectionChanged__ ) } )
         ENDWITH 
         WITH OBJECT :comboInitPos()
            :addItem( "Left"   )
            :addItem( "Top"    )
            :addItem( "Right"  )
            :addItem( "Bottom" )
         ENDWITH 
         :comboToolbarAsgnd:setCurrentIndex( -1 )
         :checkDockTop   :setChecked( .f. )
         :checkDockLeft  :setChecked( .t. )
         :checkDockBottom:setChecked( .t. )
         :checkDockRight :setChecked( .t. )
         :checkFloatable :setChecked( .t. )
         :checkToolActive:setChecked( .t. )
         :checkInactive:connect( "stateChanged(int)", {|p| ::execEvent( __checkToolActive_stateChanged__, p ) } )
         hdr_:= { { "Img", 30 }, { "Tool", 218 } }
         WITH OBJECT :tableButtons()
            :verticalHeader():hide()
            :horizontalHeader():setStretchLastSection( .t. )
            :setAlternatingRowColors( .t. )
            :setColumnCount( Len( hdr_ ) )
            :setShowGrid( .t. )
            :setSelectionMode( QAbstractItemView_SingleSelection )
            :setSelectionBehavior( QAbstractItemView_SelectRows )
            FOR n := 1 TO Len( hdr_ )
               WITH OBJECT qItm := QTableWidgetItem()
                  :setText( hdr_[ n,1 ] )
               ENDWITH 
               :setHorizontalHeaderItem( n-1, qItm )
               :setColumnWidth( n-1, hdr_[ n,2 ] )
               aadd( ::aHdr, qItm )
            NEXT
         ENDWITH 
         IF .T.
            :listToolbars:setCurrentRow( 0 )
         ENDIF
      ENDWITH 
   ENDIF
   IF .T.
      ::populatePlugins( .t. )
      ::clearList()
      ::populateList( ::oINI:aTools )
      ::oUI:listNames:setCurrentRow( 0 )
      ::oIde:setPosByIniEx( ::oUI:oWidget, ::oINI:cToolsDialogGeometry )
      ::oUI:show()
   ENDIF
   RETURN Nil


METHOD IdeToolsManager:execEvent( nEvent, p )
   LOCAL cFile, cFileName, nIndex, qItem, cName, nRow
   LOCAL aTools := ::oINI:aTools
   HB_SYMBOL_UNUSED( p )
   IF ::lQuitting
      RETURN Self
   ENDIF
   SWITCH nEvent
   CASE __checkToolActive_stateChanged__
      nRow := ::oUI:listToolbars:currentRow()
      ::aUserToolbars[ nRow + 1, 3 ] := "YES"
      IF !empty( ::aToolbars[ nRow + 1 ] )
         IF p > 0
            ::aToolbars[ nRow + 1 ]:hide()
         ELSE
            ::aToolbars[ nRow + 1 ]:show()
         ENDIF
      ENDIF
      EXIT
   CASE __buttonSetImage_clicked__
      cFileName := hbide_fetchAFile( ::oDlg, "Select an PNG image", { { "Image Files", "*.png" } },/* cFolder */ , /*cDftSuffix*/ )
      IF !empty( cFileName )
         ::oUI:editImage:setText( hbide_pathNormalized( cFileName, .f. ) )
         ::oUI:buttonSetImage:setIcon( QIcon( hbide_pathToOsPath( cFileName ) ) )
      ENDIF
      EXIT
   CASE __buttonUserToolbarUpd_clicked__
      ::ini2toolbarControls( ::oUI:listToolbars:currentRow(), 2 )
      EXIT
   CASE __listToolbars_itemSelectionChanged__
      // Clear tableButtons and populate with new values
      ::ini2toolbarControls( ::oUI:listToolbars:currentRow(), 1 )
      ::populateButtonsTable( ::oUI:listToolbars:currentRow() )
      EXIT
   CASE __comboToolbarAsgnd_currentIndexChanged__
      ::oUI:listToolbars:setCurrentRow( p )
      EXIT
   CASE __listNames_itemSelectionChanged__
      qItem := ::oUI:listNames:currentItem()
      cName := qItem:text()
      IF ( nIndex := ascan( aTools, {|e_| e_[ 1 ] == cName } ) ) > 0
         ::ini2Controls( nIndex )
      ENDIF
      EXIT
   CASE __buttonAdd_clicked__
      IF !empty( ::oUI:editName:text() )
         ::controls2ini()
         ::oUI:listNames:addItem( ::oUI:editName:text() )
      ENDIF
      EXIT
   CASE __buttonDelete_clicked__
      IF ::oUI:listNames:currentRow() >= 0
         qItem := ::oUI:listNames:currentItem()
         cName := qItem:text()
         IF ( nIndex := ascan( aTools, {|e_| e_[ 1 ] == cName } ) ) > 0
            hb_adel( ::oINI:aTools, nIndex, .t. )
            ::clearList()
            ::populateList()
         ENDIF
      ENDIF
      EXIT
   CASE __buttonUp_clicked__
      EXIT
   CASE __buttonDown_clicked__
      EXIT
   CASE __buttonExec_clicked__
      IF ! ::lExecuting
         ::lExecuting := .t.
         IF ::oUI:listNames:currentRow() >= 0
            qItem := ::oUI:listNames:currentItem()
            ::execTool( qItem:text() )
         ENDIF
         ::lExecuting := .f.
      ENDIF
      EXIT
   CASE __buttonBrowse_clicked__
      IF !empty( cFile := hbide_fetchAFile( ::oDlg, "Select a Tool" ) )
         hb_fNameSplit( cFile, , @cFileName )
         //::ini2controls()
         ::oUI:editName    : setText( cFileName )
         ::oUI:editCmdLine : setText( cFile )
      ENDIF
      EXIT
   CASE __buttonUpdate_clicked__
      IF ( nRow := ::oUI:listNames:currentRow() ) >= 0
         qItem := ::oUI:listNames:currentItem()
         cName := qItem:text()

         IF ( nIndex := ascan( aTools, {|e_| e_[ 1 ] == cName } ) ) > 0
            ::controls2ini( nIndex )
            ::clearList()
            ::populateList()
            ::oUI:listNames:setCurrentRow( nRow )
         ENDIF
      ENDIF
      EXIT
   CASE __buttonClose_clicked__
      ::oIde:oINI:cToolsDialogGeometry := hbide_posAndSize( ::oUI:oWidget )
      ::oUI:done( 1 )
      EXIT
   CASE __User_Toolbar_clicked__
      ::execTool( p )
      EXIT
   ENDSWITCH
   RETURN Self


STATIC FUNCTION hbide_toolBlock( o, a_ )
   LOCAL cTool := a_[ 1 ]
   RETURN {|| o:execEvent( __User_Toolbar_clicked__, cTool ) }


METHOD IdeToolsManager:buildUserToolbars()
   LOCAL a_:={}, b_, qTbar, qTBtn, nn, nIndex
   LOCAL area_:= { Qt_LeftToolBarArea, Qt_TopToolBarArea, Qt_RightToolBarArea, Qt_BottomToolBarArea }
   LOCAL aIndex := {}
   FOR nIndex := 0 TO 4
      nn := nIndex + 1
      FOR EACH b_ IN ::aTools
         IF !empty( b_[ 7 ] ) .AND. val( b_[ 7 ] ) == nIndex
            aadd( a_, b_ )
            aadd( aIndex, b_:__enumIndex() )
         ENDIF
      NEXT
      IF !empty( a_ )
         WITH OBJECT qTBar := QToolBar()
            :setStyleSheet( GetStyleSheet( "QToolBarLR5", ::nAnimantionMode ) )
            :setObjectName( "User_Toolbar_" + hb_ntos( nIndex ) )
            :setWindowTitle( "User Toolbar : " + hb_ntos( nIndex ) )
            :setIconSize( QSize( 16,16 ) )
            :setToolButtonStyle( Qt_ToolButtonIconOnly )
            :setAllowedAreas( iif( ::aUserToolbars[ nn,4 ] == "YES", Qt_TopToolBarArea   , 0 ) + ;
                              iif( ::aUserToolbars[ nn,5 ] == "YES", Qt_LeftToolBarArea  , 0 ) + ;
                              iif( ::aUserToolbars[ nn,6 ] == "YES", Qt_BottomToolBarArea, 0 ) + ;
                              iif( ::aUserToolbars[ nn,7 ] == "YES", Qt_RightToolBarArea , 0 ) )
         ENDWITH    
         FOR EACH b_ IN a_
            WITH OBJECT qTBtn := QToolButton( qTBar )
               :setText( b_[ 1 ] )
               :setTooltip( b_[ 10 ] )
               :setIcon( QIcon( hbide_pathToOSPath( b_[ 9 ] ) ) )
               :setMaximumWidth( 20 )
               :setMaximumHeight( 20 )
               :connect( "clicked()", hbide_toolBlock( Self, b_ ) )
               :addWidget( qTBtn )
            ENDWITH 
            IF ! b_[ 8 ] == "YES"
               qTBtn:setEnabled( .f. )
            ENDIF
            aadd( ::aBtns, qTBtn )
         NEXT
         ::oDlg:oWidget:addToolBar( area_[ val( ::aUserToolbars[ nn,4 ] ) + 1 ], qTBar )
         IF ::aUserToolbars[ nn, 3 ] == "YES"
            qTBar:hide()
         ENDIF
         ::aToolbars[ nn ] := qTBar
         a_:= {}
      ENDIF
   NEXT
   RETURN Self


METHOD IdeToolsManager:populateButtonsTable( nIndex )
   LOCAL a_:={}, b_, q0, q1, nRow
   WITH OBJECT ::oUI:tableButtons
      :clearContents()
      IF nIndex > -1
         FOR EACH b_ IN ::aTools
            IF !empty( b_[ 7 ] ) .AND. val( b_[ 7 ] ) == nIndex
               aadd( a_, b_ )
            ENDIF
         NEXT
         :setRowCount( Len( a_ ) )
         IF !empty( a_ )
            FOR EACH b_ IN a_
               nRow := b_:__enumIndex() - 1
               WITH OBJECT q0 := QTableWidgetItem()
                  :setIcon( QIcon( hbide_pathToOSPath( b_[ 9 ] ) ) )
                  :setTooltip( b_[ 10 ] )
               ENDWITH 
               :setItem( nRow, 0, q0 )
               WITH OBJECT q1 := QTableWidgetItem()
                  :setText( b_[ 1 ] )
               ENDWITH 
               :setItem( nRow, 1, q1 )
               :setRowHeight( nRow, 16 )
            NEXT
         ENDIF
      ENDIF
   ENDWITH 
   RETURN Self


METHOD IdeToolsManager:ini2toolbarControls( nIndex, nMode )
   IF nIndex > -1
      nIndex++
      IF nMode == 1
         WITH OBJECT ::oUI
            :comboInitPos   :setCurrentIndex( val( ::aUserToolBars[ nIndex, 1 ] ) )
            :checkFloatable :setChecked( ::aUserToolBars[ nIndex, 2 ] == "YES" )
            :checkInactive  :setChecked( ::aUserToolBars[ nIndex, 3 ] == "YES" )
            :checkDockTop   :setChecked( ::aUserToolBars[ nIndex, 4 ] == "YES" )
            :checkDockLeft  :setChecked( ::aUserToolBars[ nIndex, 5 ] == "YES" )
            :checkDockBottom:setChecked( ::aUserToolBars[ nIndex, 6 ] == "YES" )
            :checkDockRight :setChecked( ::aUserToolBars[ nIndex, 7 ] == "YES" )
         ENDWITH
      ELSE
         ::aUserToolBars[ nIndex, 1 ] := hb_ntos( ::oUI:comboInitPos:currentIndex() )
         ::aUserToolBars[ nIndex, 2 ] := iif( ::oUI:checkFloatable :isChecked(), "YES", "NO" )
         ::aUserToolBars[ nIndex, 3 ] := iif( ::oUI:checkInactive  :isChecked(), "YES", "NO" )
         ::aUserToolBars[ nIndex, 4 ] := iif( ::oUI:checkDockTop   :isChecked(), "YES", "NO" )
         ::aUserToolBars[ nIndex, 5 ] := iif( ::oUI:checkDockLeft  :isChecked(), "YES", "NO" )
         ::aUserToolBars[ nIndex, 6 ] := iif( ::oUI:checkDockBottom:isChecked(), "YES", "NO" )
         ::aUserToolBars[ nIndex, 7 ] := iif( ::oUI:checkDockRight :isChecked(), "YES", "NO" )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeToolsManager:ini2controls( nIndex )
   WITH OBJECT ::oUI
      IF nIndex > 0
         :editName         :setText( ::aTools[ nIndex, 1 ] )
         :editCmdLine      :setText( ::aTools[ nIndex, 2 ] )
         :editParams       :setText( ::aTools[ nIndex, 3 ] )
         :editStayIn       :setText( ::aTools[ nIndex, 4 ] )
         :checkCapture     :setChecked( !empty( ::aTools[ nIndex, 5 ] ) )
         :checkOpenCons    :setChecked( !empty( ::aTools[ nIndex, 6 ] ) )
         :comboToolbarAsgnd:setCurrentIndex( iif( empty( ::aTools[ nIndex, 7 ] ), -1, val( ::aTools[ nIndex, 7 ] ) ) )
         :checkToolActive  :setChecked( ::aTools[ nIndex, 8 ] == "YES" )
         :editImage        :setText( hbide_pathNormalized( ::aTools[ nIndex, 9 ], .f. ) )
         :buttonSetImage   :setIcon( QIcon( iif( empty( ::aTools[ nIndex, 9 ] ), hbide_image( "open" ), ;
                                                             hbide_pathToOsPath( ::aTools[ nIndex, 9 ] ) ) ) )
         :editTooltip      :setText( ::aTools[ nIndex, 10 ] )
         :comboPlugin      :setCurrentIndex( ascan( ::aPlugins, {|e| ::aTools[ nIndex, 11 ] == e } ) - 1 )
         :checkPlugInit    :setChecked( ::aTools[ nIndex, 12 ] == "YES" )
      ELSE
         :editName         :setText( "" )
         :editCmdLine      :setText( "" )
         :editParams       :setText( "" )
         :editStayIn       :setText( "" )
         :checkCapture     :setChecked( .f. )
         :checkOpenCons    :setChecked( .f. )
         :comboToolbarAsgnd:setCurrentIndex( -1 )
         :checkToolActive  :setChecked( .t. )
         :editImage        :setText( "" )
         :buttonSetImage   :setIcon( QIcon( hbide_image( "open" ) ) )
         :editTooltip      :setText( "" )
         :comboPlugin      :setCurrentIndex( -1 )
         :checkPlugInit    :setChecked( .f. )
      ENDIF
   ENDWITH 
   RETURN Self


METHOD IdeToolsManager:controls2ini( nIndex )
   IF empty( nIndex )
      aadd( ::oINI:aTools, {} )
      nIndex := Len( ::oINI:aTools )
   ENDIF
   ::oINI:aTools[ nIndex ] := { ::oUI:editName:text()   , ;
                                 hbide_pathNormalized( ::oUI:editCmdLine:text() ), ;
                                 hbide_pathNormalized( ::oUI:editParams:text()  ), ;
                                 hbide_pathNormalized( ::oUI:editStayIn:text()  ), ;
                                 iif( ::oUI:checkCapture :isChecked(), "YES", "" ), ;
                                 iif( ::oUI:checkOpenCons:isChecked(), "YES", "" ), ;
                                 ;
                                 hb_ntos( ::oUI:comboToolbarAsgnd:currentIndex() ), ;
                                 iif( ::oUI:checkToolActive:isChecked(), "YES", "NO" ), ;
                                 ::oUI:editImage:text(), ;
                                 ::oUI:editTooltip:text(), ;
                                 ::oUI:comboPlugin:currentText(), ;
                                 iif( ::oUI:checkPlugInit:isChecked(), "YES", "NO" ) ;
                              }
   RETURN Self


METHOD IdeToolsManager:clearList()
   ::oUI:listNames:clear()
   RETURN Self


METHOD IdeToolsManager:populateList( aList )
   LOCAL a_
   DEFAULT aList TO ::oINI:aTools
   FOR EACH a_ IN aList
      ::oUI:listNames:addItem( a_[ 1 ] )
   NEXT
   RETURN Self


METHOD IdeToolsManager:populatePlugins( lClear )
   LOCAL cDir, aDir, aFile
   IF lClear
      ::oUI:comboPlugin:clear()
   ENDIF
   ::aPlugins := {}
   cDir := hb_dirBase() + "plugins" + hb_ps()
   aDir := directory( cDir + "*" )
   IF !empty( aDir )
      FOR EACH aFile IN aDir
         ::oUI:comboPlugin:addItem( aFile[ 1 ] )
         aadd( ::aPlugins, aFile[ 1 ] )
      NEXT
      ::oUI:comboPlugin:setCurrentIndex( -1 )
   ENDIF
   RETURN Self


METHOD IdeToolsManager:buildToolsButton()
   LOCAL a_, qAct
   WITH OBJECT ::qToolsMenu := QMenu()
      :setStyleSheet( GetStyleSheet( "QMenuPop", ::nAnimantionMode ) )
   ENDWITH
   FOR EACH a_ IN ::aTools
      qAct := ::qToolsMenu:addAction( a_[ 1 ] )
      qAct:connect( "triggered(bool)", {|| ::execTool( a_[ 1 ] ) } )
      aadd( ::aAct, qAct )
   NEXT
   WITH OBJECT ::qToolsButton := QToolButton()
      :setTooltip( "Tools & Utilities" )
      :setIcon( QIcon( hbide_image( "tools" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::qToolsMenu )
      :connect( "clicked()", {|| ::show() } )
   ENDWITH 
   RETURN ::qToolsButton


METHOD IdeToolsManager:execToolByParams( cCmd, cParams, cStartIn, lCapture, lOpen )
   LOCAL cArg, lTokened
   WITH OBJECT ::oProcess := HbpProcess():new()
      :output      := {|cOut, mp2, oHbp| ::showOutput( cOut, mp2, oHbp ) }
      :finished    := {|nEC , nES, oHbp| ::finished( nEC, nES, oHbp ) }
      :workingPath := cStartIn
      :lDetached   := !( lCapture )
   ENDWITH 
   IF empty( cCmd )
      lTokened := .f.
      cCmd := hbide_getShellCommand()
      cArg := iif( hbide_getOS() == "nix", "", "/C " )
   ELSE
      lTokened := .t.
      cArg := ""
   ENDIF
   cArg += hbide_parseMacros( cParams )
   IF lCapture
      IF lOpen
         ::oDockB2:show()
      ENDIF
      WITH OBJECT ::oOutputResult:oWidget
         :clear()
         :append( cCmd )
         :append( cArg )
         :append( hbide_outputLine() )
      ENDWITH 
   ENDIF
   WITH OBJECT ::oProcess
      :addArg( cArg, lTokened )
      :start( cCmd )
   ENDWITH 
   RETURN Self


METHOD IdeToolsManager:execTool( ... )
   LOCAL nIndex, cCmd, cParams, cStayIn, lCapture, lOpen, aParam, cPlugin, a_
   aParam := hb_aParams()
   IF Len( aParam ) == 1
      IF ( nIndex := ascan( ::aTools, {|e_| e_[ 1 ] == aParam[ 1 ] } ) ) > 0
         hb_fNameSplit( ::aTools[ nIndex, 11 ], , @cPlugin )
         cCmd     := hbide_pathToOSPath( ::aTools[ nIndex, 2 ] )
         cParams  := ::aTools[ nIndex, 3 ]
         cParams  := iif( "http://" $ lower( cParams ) .OR. !empty( cPlugin ), cParams, hbide_pathToOSPath( cParams ) )
         cParams  := hbide_parseMacros( cParams )
         cStayIn  := hbide_pathToOSPath( ::aTools[ nIndex, 4 ] )
         lCapture := ::aTools[ nIndex, 5 ] == "YES"
         lOpen    := ::aTools[ nIndex, 6 ] == "YES"
      ENDIF
   ELSEIF Len( aParam ) > 1
      asize( aParam, 5 )
      IF .T.
         DEFAULT aParam[ 1 ] TO ""
         DEFAULT aParam[ 2 ] TO ""
         DEFAULT aParam[ 3 ] TO ""
         DEFAULT aParam[ 4 ] TO ""
         DEFAULT aParam[ 5 ] TO ""
      ENDIF
      cCmd     := hbide_pathToOSPath( aParam[ 1 ] )
      cParams  := aParam[ 2 ]
      cParams  := iif( "http://" $ lower( cParams ), cParams, hbide_pathToOSPath( cParams ) )
      cParams  := hbide_parseMacros( cParams )
      cStayIn  := hbide_pathToOSPath( aParam[ 3 ] )
      lCapture := iif( HB_ISLOGICAL( aParam[ 4 ] ), aParam[ 4 ], aParam[ 4 ] == "YES" )
      lOpen    := iif( HB_ISLOGICAL( aParam[ 5 ] ), aParam[ 5 ], aParam[ 5 ] == "YES" )
   ENDIF
   IF HB_ISLOGICAL( lCapture )
      IF !empty( cPlugin )
         a_:= hb_aTokens( cParams, " " )
         FOR EACH cParams IN a_
            cParams := hbide_evalAsis( cParams )
         NEXT
         hbide_execPlugin( cPlugin, ::oIde, hb_arrayToParams( a_ ) )
      ELSE
         ::execToolByParams( cCmd, cParams, cStayIn, lCapture, lOpen )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeToolsManager:showOutput( cOut, mp2, oHbp )
   HB_SYMBOL_UNUSED( mp2 )
   HB_SYMBOL_UNUSED( oHbp )
   hbide_convertBuildStatusMsgToHtml( cOut, ::oOutputResult:oWidget )
   RETURN Self


METHOD IdeToolsManager:finished( nEC, nES, oHbp )
   HB_SYMBOL_UNUSED( oHbp )
   ::oOutputResult:oWidget:append( hbide_outputLine() )
   ::oOutputResult:oWidget:append( "Finished: Exit Code = " + hb_ntos( nEC ) + " Status = " + hb_ntos( nES ) )
   RETURN Self


STATIC FUNCTION hbide_blockView( oSelf, cView )
   RETURN {|| oSelf:execView( cView ) }


METHOD IdeToolsManager:buildViewsButton()
   LOCAL a_, b_, qAct, aSettings, cPath, cView
   cPath := ::oINI:getIniPath()
   b_:= directory( cPath + "*.ide"  )
   aSettings := {}
   aadd( aSettings, "Browse..." )
   aadd( aSettings, "..." )
   aadd( aSettings, "Pritpals Favourite" )
   aadd( aSettings, "..." )
   FOR EACH a_ IN b_
      IF ! ( a_[ 1 ] == "settings.ide" ) .AND. ! ( a_[ 1 ] == "tempsettings.ide" )
         aadd( aSettings, hbide_pathNormalized( cPath + a_[ 1 ] ) )
      ENDIF
   NEXT
   ::qViewsMenu := QMenu()
   ::qViewsMenu:setStyleSheet( GetStyleSheet( "QMenuPop", ::nAnimantionMode ) )
   FOR EACH cView IN aSettings
      IF cView == "..."
         qAct := ::qViewsMenu:addSeparator()
      ELSE
         qAct := ::qViewsMenu:addAction( cView )
         qAct:connect( "triggered(bool)", hbide_blockView( Self, cView ) )
      ENDIF
      aadd( ::aSetAct, { qAct, cView } )
   NEXT
   WITH OBJECT ::qViewsButton := QToolButton()
      :setObjectName( "HbIDE Views" )
      :setTooltip( "HbIDE Views" )
      :setIcon( QIcon( hbide_image( "view_docks" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::qViewsMenu )
      :connect( "clicked()", {|| ::saveView() } )
   ENDWITH 
   RETURN ::qViewsButton


METHOD IdeToolsManager:saveView()
   LOCAL cView, qAct
   cView := hbide_saveAFile( ::oDlg, "Select a HbIDE Settings File", { { "HbIDE Settings", "*.ide" } }, ::cSetsFolderLast, "ide" )
   IF ! empty( cView )
      ::cSetsFolderLast := cView
      cView := lower( hbide_pathNormalized( cView ) )
      hbide_saveEnvironment( ::oIde, cView )
      IF ascan( ::aSetAct, {|e_| e_[ 2 ] == cView } ) == 0
         qAct := ::qViewsMenu:addAction( cView )
         qAct:connect( "triggered(bool)", hbide_blockView( Self, cView ) )
         aadd( ::aAct, { qAct, cView } )
      ENDIF
   ENDIF
   RETURN Self


METHOD IdeToolsManager:execView( cView )
   IF cView == "Browse..."
      cView := hbide_fetchAFile( ::oDlg, "Select a HbIDE Settings File", { { "HbIDE Settings", "*.ide" } }, ::cSetsFolderLast, "ide", .f. )
      IF empty( cView )
         RETURN Self
      ENDIF
      ::cSetsFolderLast := cView
      hbide_restEnvironment( ::oIde, cView )
   ELSEIF cView == "Pritpals Favourite"
      hbide_restEnvironment_byResource( ::oIde, "pritpalsfav" )
   ELSE
      hbide_restEnvironment( ::oIde, cView )
   ENDIF
   RETURN Self


METHOD IdeToolsManager:buildPanelsButton()
   LOCAL s, a_
   WITH OBJECT ::qPanelsMenu := QMenu()
      :setStyleSheet( GetStyleSheet( "QMenuPop", ::nAnimantionMode ) )
   ENDWITH 
   FOR EACH s IN ::oINI:aViews
      a_:= hb_atokens( s, "," )
      ::addPanelsMenu( a_[ 1 ] )
   NEXT
   WITH OBJECT ::qPanelsButton := QToolButton()
      :setTooltip( "Panels" )
      :setIcon( QIcon( hbide_image( "b_20" ) ) ) //panel_8" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::qPanelsMenu )
      :connect( "clicked()", {|| ::managePanels() } )
   ENDWITH 
   RETURN ::qPanelsButton


METHOD IdeToolsManager:addPanelsMenu( cPrompt )
   LOCAL qAct
   WITH OBJECT qAct := ::qPanelsMenu:addAction( cPrompt )
      :setIcon( QIcon( ::oDK:getPanelIcon( cPrompt ) ) )
      :connect( "triggered(bool)", {|| ::oDK:setView( cPrompt ) } )
   ENDWITH 
   aadd( ::aPanelsAct, qAct )
   RETURN Self


METHOD IdeToolsManager:managePanels()
   LOCAL a_
   IF empty( ::oUIPnls )
      WITH OBJECT ::oUIPnls := ui_panels():new( ::oDlg:oWidget )
         WITH OBJECT :listOrder()
            :setDragEnabled( .t. )
            :setAcceptDrops( .t. )
            :setDragDropMode( QAbstractItemView_InternalMove )
         ENDWITH 
         WITH OBJECT :comboPos()
            :addItem( "Top" )
            :addItem( "Bottom" )
            :addItem( "Left" )
            :addItem( "Right" )
            :setCurrentIndex( ::oINI:nPanelsTabPosition )
         ENDWITH
         WITH OBJECT :comboShape()
            :addItem( "Round" )
            :addItem( "Triangular" )
            :setCurrentIndex( ::oINI:nPanelsTabShape )
         ENDWITH
         //
         :connect( QEvent_Close, {|| ::oUIPnls:hide()  } )
      ENDWITH 
      ::oUIPnls:btnOk    : connect( "clicked()" , {|| ::oUIPnls:hide(), ::arrangePanels() } )
      ::oUIPnls:btnCancel: connect( "clicked()" , {|| ::oUIPnls:hide()  } )
   ENDIF
   //
   WITH OBJECT ::oUIPnls
      :move( ::qPanelsButton:mapToGlobal( QPoint( 0, 20 ) ) )
      :listOrder:clear()
      :comboDelete:clear()
      FOR EACH a_ IN ::oDK:aViewsInfo
         :listOrder:addItem( a_[ 1 ] )
         :comboDelete:addItem( a_[ 1 ] )
      NEXT
      :comboDelete:setCurrentIndex( -1 )
      :show()
   ENDWITH 
   RETURN Self


METHOD IdeToolsManager:arrangePanels()
   LOCAL a_:={}, v_:={}, w_:={}, n, i, cView
   LOCAL lOrder := .f.
   ::oINI:nPanelsTabShape := ::oUIPnls:comboShape:currentIndex()
   ::oINI:nPanelsTabPosition := ::oUIPnls:comboPos:currentIndex()
   /* These are easy */
   ::oDK:oStackedWidget:setTabShape( ::oINI:nPanelsTabShape )
   ::oDK:oStackedWidget:setTabPosition( ::oINI:nPanelsTabPosition )
   /* Rearrange panels */
   FOR i := 1 TO ::oUIPnls:listOrder:count()
      cView := ::oUIPnls:listOrder:item( i - 1 ):text()
      n := ascan( ::oDK:aViewsInfo, {|e_| e_[ 1 ] == cView } )
      aadd( a_, n )
      IF n != i
         lOrder := .t.
      ENDIF
   NEXT
   IF lOrder
      FOR EACH n IN a_
         aadd( v_, ::oDK:aViewsInfo[ n ] )
         aadd( w_, ::oIde:aViews[ n ] )
      NEXT
      ::oDK:aViewsInfo := v_
      ::oIde:aViews    := w_
   ENDIF
   /* tobe done at the end after re-order */
   IF ! empty( cView := trim( ::oUIPnls:editView:text() ) )
      ::oDK:setView( cView )
   ENDIF
   IF ::oUIPnls:comboDelete:currentIndex() >= 0
      ::deletePanel( ::oUIPnls:comboDelete:currentText() )
   ENDIF
   /* Reordering needs that HbIDE be re-executed */
   IF lOrder
      MsgBox( "You will need to close HbIDE for panels re-order to take effect !" )
   ENDIF
   RETURN Self


METHOD IdeToolsManager:deletePanel( cView )
   LOCAL nTab, n, pTab, oEdit
   ::oDK:setView( cView )
   IF ! hbide_getYesNo( "Are you sure to remove - " + cView + " - panel ?" )
      RETURN NIL
   ENDIF
   DO WHILE ::oIde:qTabWidget:count() > 0
      pTab  := ::oIde:qTabWidget:widget( 0 )
      IF ( nTab  := ascan( ::oIde:aTabs, {|e_| hbqt_IsEqual( e_[ 1 ]:oWidget, pTab ) } ) ) > 0
         oEdit := ::oIde:aTabs[ nTab, TAB_OEDITOR ]
         IF ! Empty( oEdit:source() ) .AND. !( ".ppo" == lower( oEdit:cExt ) )
            ::oSM:closeSource( nTab, .F., .F., .T. )  /* This deletes the tabs also */
         ENDIF
      ENDIF
   ENDDO
   //
   n := ascan( ::oDK:aViewsInfo, {|e_| e_[ 1 ] == cView } )
   //
   ::oStackedWidget:oWidget:removeSubWindow( ::oIde:aMdies[ n ] )
   ::oIde:aMdies[ n ]:setParent( QWidget() )  /* Release memory */
   hb_adel( ::oIde:aMdies   , n, .t. )
   hb_adel( ::oDK:aViewsInfo, n, .t. )
   hb_adel( ::oIde:aViews   , n, .t. )
   RETURN Self

