/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2013 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                        Harbour HbQtDBU Class
 *
 *                             Pritpal Bedi
 *                              03Jan2013
 */
/*----------------------------------------------------------------------*/

REQUEST DBFCDX
REQUEST DBFNTX
REQUEST DBFNSX

/*----------------------------------------------------------------------*/

#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "dbinfo.ch"

/*----------------------------------------------------------------------*/

#define __dbu_dragEnterEvent__                    2011
#define __dbu_dropEvent__                         2012
#define __dbStruct_closeEvent__                   2013
#define __fieldsTable_itemSelectionChanged__      2014
#define __buttonCopyStruct_clicked__              2015
#define __buttonOpen_clicked__                    2016
#define __buttonShowForm_clicked__                2017
#define __buttonDbStruct_clicked__                2018
#define __buttonFind_clicked__                    2019
#define __buttonGoto_clicked__                    2020
#define __buttonClose_clicked__                   2021
#define __buttonViewTabbed_clicked__              2022
#define __buttonViewOrganized_clicked__           2023
#define __buttonSaveLayout_clicked__              2024
#define __buttonViewCascaded_clicked__            2025
#define __buttonViewTiled_clicked__               2026
#define __buttonViewMaximized_clicked__           2027
#define __buttonViewStackedVert_clicked__         2028
#define __buttonViewStackedHorz_clicked__         2029
#define __buttonViewZoomedIn_clicked__            2030
#define __buttonViewZoomedOut_clicked__           2031
#define __buttonAppendRecord_clicked__            2032
#define __buttonDelRecord_clicked__               2033
#define __buttonLockRecord_clicked__              2034
#define __buttonGoTop_clicked__                   2035
#define __buttonGoBottom_clicked__                2036
#define __buttonScrollToFirst_clicked__           2037
#define __buttonScrollToLast_clicked__            2038
#define __buttonSearchInTable_clicked__           2039
#define __buttonZaptable_clicked__                2040
#define __qPanelsButton_clicked__                 2041
#define __buttonTables_clicked__                  2042
#define __buttonIndex_clicked__                   2043
#define __mdiArea_subWindowActivated__            2044

#define __browse_keyboard__                       2046
#define __timer_timeout__                         2047
#define __browser_contextMenu__                   2048
#define __mdiSubWindow_windowStateChanged__       2049
#define __mdiSubWindow_buttonXclicked__           2050
#define __dbu_treeTableDoubleClicked__            2051
#define __buttonLink_clicked__                    2052
#define __buttonOpenIndex_clicked__               2053

/*----------------------------------------------------------------------*/

#define  BRW_TYPE_DBF                             1
#define  BRW_TYPE_ARRAY                           2

/* Array elements supplied as aInfo of :addBrowser( aInfo ) */
#define  TBL_PANEL                                1
#define  TBL_NAME                                 2
#define  TBL_ALIAS                                3
#define  TBL_DRIVER                               4
#define  TBL_INDEX                                5
#define  TBL_RECORD                               6
#define  TBL_CURSOR                               7
#define  TBL_GEOMETRY                             8
#define  TBL_ROWPOS                               9
#define  TBL_COLPOS                               10
#define  TBL_HZSCROLL                             11
#define  TBL_CONXN                                12
#define  TBL_NEXT                                 13
#define  TBL_COLUMNS                              14

#define  TBL_VRBLS                                14

#define  SUB_ID                                   1
#define  SUB_WINDOW                               2
#define  SUB_GEOMETRY                             3
#define  SUB_BROWSER                              4
#define  SUB_NIL                                  5

#define  PNL_PANELS                               1
#define  PNL_TABLES                               2
#define  PNL_MISC                                 3
#define  PNL_READY                                4

/*----------------------------------------------------------------------*/
/*                      Harbour Parts Constants                         */
/*----------------------------------------------------------------------*/

#define HBPLAYOUT_TYPE_HORZBOX                    1
#define HBPLAYOUT_TYPE_VERTBOX                    2
#define HBPLAYOUT_TYPE_GRID                       3
#define HBPLAYOUT_TYPE_FORM                       4

#define HBPLAYOUT_TYPE_MAX                        4

/*----------------------------------------------------------------------*/
/*                             HbpMdiArea()                             */
/*----------------------------------------------------------------------*/

#define HBQTTOOLBAR_BUTTON_DEFAULT                0
#define HBQTTOOLBAR_BUTTON_SEPARATOR              1

/*----------------------------------------------------------------------*/

CLASS HbQtDBU

   FRIEND CLASS HbQtPanelBrowse
   FRIEND CLASS HbQtMdiBrowser
   FRIEND CLASS HbQtCreateTable

   DATA   oWidget

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD destroy()

   ACCESS tablesPanel                             INLINE ::qLeftFrame
   ACCESS structPanel                             INLINE ::qRightFrame
   ACCESS splitter                                INLINE ::qLeftSplitter

   FRIEND CLASS HbQtMdiBrowser
   FRIEND CLASS HbQtPanelBrowse

   ACCESS connectionsBlock                        METHOD getConnectionsBlock
   ASSIGN connectionsBlock                        METHOD setConnectionsBlock

   ACCESS selectTableBlock                        METHOD getSelectTableBlock
   ASSIGN selectTableBlock                        METHOD setSelectTableBlock

   ACCESS openTableBlock                          METHOD getOpenTableBlock
   ASSIGN openTableBlock                          METHOD setOpenTableBlock

   ACCESS saveTableBlock                          METHOD getSaveTableBlock
   ASSIGN saveTableBlock                          METHOD setSaveTableBlock

   ACCESS existsTableBlock                        METHOD getExistsTableBlock
   ASSIGN existsTableBlock                        METHOD setExistsTableBlock

   ACCESS rddsBlock                               METHOD getRddsBlock
   ASSIGN rddsBlock                               METHOD setRddsBlock

   ACCESS tablesStructureEnabled                  METHOD getTablesStructureEnabled
   ASSIGN tablesStructureEnabled                  METHOD setTablesStructureEnabled

   METHOD browseConfigureBlock( bBlock )          SETGET
   METHOD browseColumnsBlock( bBlock )            SETGET

   /* Tables Tree Management */
   ACCESS populateTreeBlock                       METHOD getPopulateTreeBlock
   ASSIGN populateTreeBlock                       METHOD setPopulateTreeBlock

   ACCESS tablesTreeEnabled                       METHOD getTablesTreeEnabled
   ASSIGN tablesTreeEnabled                       METHOD setTablesTreeEnabled

   METHOD clearTablesTree()
   METHOD populateTree( xSection, cParent, cNode, cTable, cDriver, cConxn, cIcon )

   METHOD background( oBrush )                    SETGET

   /* Upper level methods to access HbQtMdiBrowse detected via ::cAlias property */
   METHOD browser( cAlias )                       INLINE ::getBrowserByAlias( cAlias )
   METHOD driver( cAlias )
   METHOD connection( cAlias )
   METHOD goTop( cAlias )
   METHOD goBottom( cAlias )
   METHOD goTo( cAlias, nRec )
   METHOD gotoRecord( cAlias )
   METHOD goToAsk( cAlias )
   METHOD lock( cAlias, nRec )
   METHOD unlock( cAlias, nRec )
   METHOD append( cAlias )
   METHOD delete( cAlias, lAsk )
   METHOD recall( cAlias )
   METHOD recNo( cAlias )
   METHOD lastRec( cAlias )
   METHOD ordKeyCount( cAlias )
   METHOD ordKeyNo( cAlias )
   METHOD ordKeyGoto( cAlias, nRec )
   METHOD indexOrd( cAlias )
   METHOD ordName( cAlias, nOrder )
   METHOD indexKey( cAlias, nOrder )
   METHOD indexKeyValue( cAlias, nOrder )
   METHOD indexKeyType( cAlias, nOrder )
   METHOD refreshAll( cAlias )
   METHOD getIndexInfo( cAlias )
   METHOD setIndexInfo( cAlias )
   METHOD setIndex( cAlias, cIndex )
   METHOD setOrder( cAlias, nOrder )
   METHOD setScope( cAlias, cScopeTop, cScopeBottom )
   METHOD clearScope( cAlias, nScope )
   METHOD dbRLockList( cAlias )
   METHOD fieldBlock( cAlias, cFieldName )
   METHOD setFilter( cAlias, cFilter )
   METHOD clearFilter( cAlias )
   METHOD dbFieldInfo( cAlias, nInfoType, nFieldPos, expNewSetting )
   METHOD fCount( cAlias )
   METHOD indexExt( cAlias )
   METHOD ordKey( cAlias, ncOrder, cOrdBagName )
   METHOD dbStruct( cAlias )

   METHOD next( cAlias )
   METHOD previous( cAlias )

   METHOD search( cAlias, cSearch, lSoft, lLast, nMode )
   METHOD searchAsk( cAlias, nMode )
   METHOD seekAsk( cAlias, nMode )

   METHOD dispInfo( cAlias )
   METHOD getPanelNames()
   METHOD getPanelsInfo()
   METHOD getTreeInfo()

   METHOD addPanels( aPanels )
   METHOD loadTables( aPanelsInfo )

   METHOD updateLinks( cAlias )
   METHOD setLinksInfo( aInfo )
   METHOD getLinksInfo()

   METHOD openATable( cDBF )
   METHOD createTable( cDriver, cConxn, aStruct, aIndexes )

   ACCESS currentDriver()                         INLINE ::qRddCombo:currentText()
   METHOD setCurrentDriver( cDriver )             INLINE ::qRddCombo:setCurrentIndex( ::qRddCombo:findText( cDriver ) )
   ACCESS currentConxn()                          INLINE ::qConxnCombo:currentText()
   ACCESS currentConnection()                     INLINE ::qConxnCombo:currentText()

   DATA   cWrkEnvironment
   METHOD restEnvironment( cFile )
   METHOD saveEnvironment( cFile )

   /* END */

PROTECTED:
   DATA   oParent

   DATA   oCurBrw
   DATA   oCurPanel
   METHOD updateBrwStruct( oBrw )

   DATA   qMainHLayout
   DATA   qLeftFrameLay
   DATA   qRightFrameLay
   DATA   qStack
   DATA   qLayout
   DATA   qLeftFrame
   DATA   qMidFrame
   DATA   qRightFrame
   DATA   qLeftSplitter
   DATA   oTreeTables
   DATA   qVSplitter
   DATA   qToolBar
   DATA   qToolBarL
   DATA   qStruct
   DATA   qRddCombo
   DATA   qConxnCombo
   DATA   qStatus
   DATA   qTimer

   DATA   cWrkFolderLast                          INIT  ""
   DATA   cDbStructDialogGeometry                 INIT  ""

   DATA   aStatusPnls                             INIT  {}
   DATA   aPanels                                 INIT  {}
   DATA   aIndexAct                               INIT  {}
   DATA   aRdds                                   init  { "DBFCDX", "DBFNTX", "DBFNSX" }
   DATA   aConxns                                 INIT  {}

   DATA   qPanelsMenu
   DATA   qIndexMenu
   DATA   qTablesMenu
   DATA   qPanelsButton
   DATA   qIndexButton
   DATA   qTablesButton
   DATA   aPanelsAct                              INIT  {}

   DATA   lStructOpen                             INIT  .F.
   DATA   lDeletedOn                              INIT  .T.
   DATA   qComboAction
   DATA   sp0,sp1,sp2,sp3,sp4,sp5

   DATA   nPrevMode                               INIT  0
   DATA   cSettingsPath                           INIT  ""
   DATA   cSettingsFile                           INIT  ""

   METHOD open( aDbfs )
   METHOD buildToolbar()
   METHOD execEvent( nEvent, p, p1 )
   METHOD addArray( aData, aAttr )
   METHOD addPanel( cPanel )
   METHOD setPanel( cPanel )
   METHOD isPanel( cPanel )
   METHOD buildPanelsButton()
   METHOD buildIndexButton()
   METHOD addPanelsMenu( cPanel )
   METHOD updateIndexMenu( oBrw )
   METHOD buildRddsCombo()
   METHOD buildConxnCombo()
   METHOD loadConxnCombo( cDriver, oConxnCombo )
   METHOD buildStatusPanels()
   METHOD dispStatusInfo()
   METHOD buildLeftToolbar()
   METHOD buildTablesButton()
   METHOD linkTables()
   METHOD manageLinkTree( nMode, p, p1 )
   METHOD showTablesTree()
   METHOD fetchFldsList( cAlias )
   METHOD getBrowserByAlias( cAlias )

   /* Bring functionality on application level keeping defaults intact */
   METHOD loadRddsCombo( oRddCombo )

   DATA   bConnections
   DATA   bSelectTable
   DATA   bOpenTable
   DATA   bSaveTable
   DATA   bExistsTable
   DATA   bRdds
   DATA   bPopulateTree
   DATA   bBrowseConfigure
   DATA   bBrowseColumns

   METHOD buildBrwStruct()
   METHOD searchBrwStruct( xValue, nMode, oBrw )
   METHOD navigateBrwStruct( nKey )
   METHOD copyStructToClipboard()
   DATA   aBrwStruct                              INIT {}
   DATA   oBrwStruct
   DATA   aCopiedStruct                           INIT {}
   METHOD copiedStruct()                          INLINE ::aCopiedStruct

   DATA   sl_brush
   DATA   hTreeItems                              INIT {=>}

   DATA   lTablesStructure                        INIT .T.
   DATA   lTablesTree                             INIT .T.

   METHOD configureBrowse( oMdiBrowse )
   METHOD selectAField( cAlias )
   METHOD evalExpression( cExpression, cValue )
   METHOD fetchLinkedChildren( qItm, aMaps )

   DATA   hRelatns                                INIT {=>}
   DATA   hTopLevels                              INIT {=>}
   DATA   hMaps                                   INIT {=>}
   DATA   oRoot

   DATA   aLastClosePos                           INIT {}

   METHOD fetchRddInfo( cDriver )
   DATA   hRddInfo                                INIT {=>}

   METHOD saveEnvAs()
   METHOD restEnvFrom()
   METHOD getPath( cFile )
   DATA   cDefaultRDD                             INIT "DBFCDX"

   ENDCLASS


METHOD HbQtDBU:init( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   RETURN Self


METHOD HbQtDBU:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   WITH OBJECT ::qMainHLayout := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT ::qLeftFrameLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT ::qLayout := QGridLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT ::qRightFrameLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH

   WITH OBJECT ::oWidget := QWidget()
      :setAcceptDrops( .t. )
      :setLayout( ::qMainHLayout )
      :connect( QEvent_DragEnter, {|p| ::execEvent( __dbu_dragEnterEvent__, p ) } )
      :connect( QEvent_Drop     , {|p| ::execEvent( __dbu_dropEvent__     , p ) } )
      :hide()
   ENDWITH
   ::qLeftFrame    := QFrame( ::oWidget )
   ::qMidFrame     := QFrame( ::oWidget )
   ::qRightFrame   := QFrame( ::oWidget )
   ::qLeftSplitter := QSplitter( Qt_Horizontal )

   ::qMainHLayout:addWidget( ::qLeftSplitter )

   ::qLeftFrame:setSizePolicy( QSizePolicy( QSizePolicy_Fixed, QSizePolicy_Preferred ) )
   ::qLeftFrame:setLayout( ::qLeftFrameLay )
   ::qMidFrame:setLayout( ::qLayout )
   ::qRightFrame:setSizePolicy( QSizePolicy( QSizePolicy_Fixed, QSizePolicy_Preferred ) )
   ::qRightFrame:setLayout( ::qRightFrameLay )

   WITH OBJECT ::qLeftSplitter
      :addWidget( ::qLeftFrame  )
      :addWidget( ::qMidFrame   )
      :addWidget( ::qRightFrame )
   ENDWITH

   WITH OBJECT ::oTreeTables := QTreeWidget()
      :setColumnCount( 1 )
      :setHeaderHidden( .F. )
      :setHeaderLabel( " Tables" )
//    :setAnimated( .T. )
      :setRootIsDecorated( .T. )
      :setItemsExpandable( .T. )
      :setUniformRowHeights( .T. )
      :setIndentation( 10 )
      :setIconSize( QSize( 8,8 ) )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oItem,nColumn| ::execEvent( __dbu_treeTableDoubleClicked__, oItem, nColumn ) } )
   ENDWITH
   ::qLeftFrameLay:addWidget( ::oTreeTables )

   ::qLeftFrame:setMinimumWidth( 120 )
   ::qLeftFrame:hide()

   ::qRightFrame:setMinimumWidth( 125 )
   ::qRightFrame:setMaximumWidth( 205 )
   ::qRightFrame:hide()

   ::qStack := QStackedWidget()
   ::qStack:connect( "currentChanged(int)", {|i| iif( i >= 0 .AND. i < Len( ::aPanels ), ::oCurPanel := ::aPanels[ i+1 ], NIL ) } )

   ::buildToolbar()
   ::buildLeftToolbar()

   ::qStatus := QStatusBar()
   ::qStatus:setSizeGripEnabled( .f. )
   ::buildStatusPanels()

   /* Layout Widgets */
   WITH OBJECT ::qLayout
      :addWidget( ::qToolbar:oWidget , 0, 0, 1, 2 )
      :addWidget( ::qToolbarL:oWidget, 1, 0, 1, 1 )
      :addWidget( ::qStack           , 1, 1, 1, 1 )
      :addWidget( ::qStatus          , 2, 0, 1, 2 )
   ENDWITH

   /* Panels on the stacked widget */
   ::addPanels()

   ::buildBrwStruct()
   ::oBrwStruct:goTop()

   /* Switch to the default panel */
   ::setPanel( "Main" )

   /* Timer to update ststus bar */
   WITH OBJECT ::qTimer := QTimer()
      :setInterval( 2000 )
      :connect( "timeout()", {|| ::dispStatusInfo() } )
      :start()
   ENDWITH

   RETURN Self


METHOD HbQtDBU:destroy()
   ::oWidget:setParent( QWidget() )
   RETURN NIL


METHOD HbQtDBU:configureBrowse( oMdiBrowse )
   IF HB_ISBLOCK( ::bBrowseConfigure )
      Eval( ::bBrowseConfigure, oMdiBrowse:oBrw, oMdiBrowse, Self )
   ENDIF
   RETURN Self


STATIC FUNCTION findItem( oParent, cItem )
   LOCAL i, oItem
   IF oParent:text( 0 ) == cItem
      RETURN oParent
   ENDIF
   FOR i := 0 TO oParent:childCount() - 1
      oItem := findItem( oParent:child( i ), cItem )
      IF oItem != NIL
         RETURN oItem
      ENDIF
   NEXT
   RETURN NIL


METHOD HbQtDBU:navigateBrwStruct( nKey )
   LOCAL cField
   LOCAL lHandelled := .T.

   DO CASE
   CASE nKey == K_CTRL_F
      ::oBrwStruct:search()
   CASE nKey == K_CTRL_C
      ::copyStructToClipboard()
   CASE nKey == K_LDBLCLK
      IF ! Empty( cField := ::aBrwStruct[ Eval( ::oBrwStruct:getColumn( 1 ):block ), 1 ] )
         ::oCurBrw:oBrw:toColumn( cField )
      ENDIF
   OTHERWISE
      lHandelled := .F.
   ENDCASE

   RETURN lHandelled


METHOD HbQtDBU:searchBrwStruct( xValue, nMode, oBrw )

   IF xValue == NIL .AND. oBrw == NIL
      /* search is finished */
   ELSEIF xValue == NIL                           /* Interface is requesting to initiate search */
      oBrw:goTop()
      IF oBrw:colPos == 2
         RETURN { Space( 10 ), "@!", HBQTBRW_SEARCH_BYFIELD }
      ELSE
         RETURN { NIL, NIL, HBQTBRW_SEARCH_BYFIELD }
      ENDIF
   ELSE
      IF nMode == HBQTBRW_SEARCH_BYFIELD
         RETURN  Eval( oBrw:getColumn( oBrw:colPos ):block ) = xValue
      ENDIF
   ENDIF

   RETURN .T.


METHOD HbQtDBU:updateBrwStruct( oBrw )
   LOCAL nRecLen := 0

   ::aBrwStruct := oBrw:dbStruct()

   ::oBrwStruct:colPos := 2
   ::oBrwStruct:goTop()

   AEval( ::aBrwStruct, {|e_| nRecLen += e_[ 3 ] } )

   ::oBrwStruct:statusMessage := "Flds:" + hb_ntos( Len( ::aBrwStruct ) ) + " RecSz:" + hb_ntos( nRecLen )

   ::qRightFrame:resize( ::qRightFrame:width()+5, ::qRightFrame:height()+5 )
   ::qRightFrame:resize( ::qRightFrame:width()-5, ::qRightFrame:height()-5 )

   RETURN Self


METHOD HbQtDBU:buildBrwStruct()
   LOCAL oBrowse, oColumn, aHelp
   LOCAL n := 1

   aHelp := {}
   AAdd( aHelp, "K_CTRL_F                Search a Field" )
   AAdd( aHelp, "K_CTRL_C   Copy Structure to Clipboard" )
   AAdd( aHelp, "L_DBLCLK            Navigate to Column" )

   oBrowse := HbQtBrowseNew( 0, 0, 10, 50, ::oWidget, QFont( "Courier New", 8 ) )
   oBrowse:colorSpec      := "N/W*, N/BG, W+/R*, W+/B"

   oBrowse:GoTopBlock     := {|| n := 1 }
   oBrowse:GoBottomBlock  := {|| n := Len( ::aBrwStruct ) }
   oBrowse:SkipBlock      := {| nSkip, nPos | nPos := n, ;
                                  n := iif( nSkip > 0, Min( Len( ::aBrwStruct ), n + nSkip ), ;
                                     Max( 1, n + nSkip ) ), n - nPos }

   oBrowse:firstPosBlock  := {| | 1          }
   oBrowse:lastPosBlock   := {| | Len( ::aBrwStruct ) }
   oBrowse:posBlock       := {| | n          }
   oBrowse:goPosBlock     := {|i| n := i     }
   oBrowse:phyPosBlock    := {| | n          }

   oBrowse:gotoBlock      := {|i| n := i     }

   oColumn           := HbQtColumnNew( "No"  , {|| n } )
   oColumn:picture   := "999"
   oBrowse:AddColumn( oColumn )

   oColumn           := HbQtColumnNew( "Name", {|| iif( Empty( ::aBrwStruct ) .OR. n > Len( ::aBrwStruct ), Space( 10 ), ::aBrwStruct[ n,1 ] ) } )
   oColumn:picture   := "@!S10"
   oBrowse:AddColumn( oColumn )

   oColumn           := HbQtColumnNew( "T"   , {|| iif( Empty( ::aBrwStruct ) .OR. n > Len( ::aBrwStruct ), Space( 1 ), ::aBrwStruct[ n,2 ] ) } )
   oColumn:picture   := "@! A"
   oColumn:postBlock := {|oGet| oGet:varGet() $ "CNDL" }
   oBrowse:AddColumn( oColumn )

   oColumn           := HbQtColumnNew( "Len" , {|| iif( Empty( ::aBrwStruct ) .OR. n > Len( ::aBrwStruct ), 0, ::aBrwStruct[ n,3 ] ) } )
   oColumn:picture   := "9999"
   oColumn:postBlock := {|oGet| oGet:varGet() > 0 .AND. oGet:varGet() < 10000 }
   oBrowse:AddColumn( oColumn )

   oColumn           := HbQtColumnNew( "Dec" , {|| iif( Empty( ::aBrwStruct ) .OR. n > Len( ::aBrwStruct ), 0, ::aBrwStruct[ n,4 ] ) } )
   oColumn:picture   := "99"
   oColumn:postBlock := {|oGet| oGet:varGet() > 0 .AND. oGet:varGet() < 100 }
   oBrowse:AddColumn( oColumn )

   oBrowse:statusBar           := .T.
   oBrowse:toolBar             := .T.
   oBrowse:toolBarLeft         := .F.
   oBrowse:editEnabled         := .F.
   oBrowse:columnsComboEnabled := .F.
   oBrowse:verticalScrollbar   := .T.
   oBrowse:horizontalScrollbar := .T.
   oBrowse:searchBlock         := {|xValue,nMode,oBrw| ::searchBrwStruct( xValue, nMode, oBrw ) }
   oBrowse:navigationBlock     := {|nKey| ::navigateBrwStruct( nKey ) }
   oBrowse:helpBlock           := {|| { aHelp, 0 } }

   ::oBrwStruct := oBrowse
   ::qRightFrameLay:addWidget( ::oBrwStruct:oWidget )

   ::oBrwStruct:configure()
   ::oBrwStruct:refreshWindow()

   RETURN Self


METHOD HbQtDBU:setSelectTableBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bSelectTable := bBlock
   ENDIF
   RETURN ::bSelectTable

METHOD HbQtDBU:getSelectTableBlock()
   RETURN ::bSelectTable

METHOD HbQtDBU:setOpenTableBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bOpenTable := bBlock
   ENDIF
   RETURN ::bOpenTable

METHOD HbQtDBU:getOpenTableBlock()
   RETURN ::bOpenTable

METHOD HbQtDBU:setSaveTableBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bSaveTable := bBlock
   ENDIF
   RETURN ::bSaveTable

METHOD HbQtDBU:getSaveTableBlock()
   RETURN ::bSaveTable

METHOD HbQtDBU:setConnectionsBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bConnections := bBlock
   ENDIF
   RETURN ::bConnections

METHOD HbQtDBU:getConnectionsBlock()
   RETURN ::bConnections

METHOD HbQtDBU:setExistsTableBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bExistsTable := bBlock
   ENDIF
   RETURN ::bExistsTable

METHOD HbQtDBU:getExistsTableBlock()
   RETURN ::bExistsTable

METHOD HbQtDBU:setRddsBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bRdds := bBlock
      ::loadRddsCombo( ::qRddCombo )
   ENDIF
   RETURN ::bRdds

METHOD HbQtDBU:getRddsBlock()
   RETURN ::bRdds

METHOD HbQtDBU:setPopulateTreeBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bPopulateTree := bBlock
   ENDIF
   RETURN ::bPopulateTree

METHOD HbQtDBU:getPopulateTreeBlock()
   RETURN ::bPopulateTree

METHOD browseConfigureBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bBrowseConfigure := bBlock
   ENDIF
   RETURN ::bBrowseConfigure

METHOD browseColumnsBlock( bBlock )
   IF HB_ISBLOCK( bBlock )
      ::bBrowseColumns := bBlock
   ENDIF
   RETURN ::bBrowseColumns

METHOD HbQtDBU:getTablesTreeEnabled()
   RETURN ::lTablesTree

METHOD HbQtDBU:setTablesTreeEnabled( lEnabled )
   IF HB_ISLOGICAL( lEnabled )
      ::lTablesTree := lEnabled
      IF ::lTableTree
         ::qLeftFrame:show()
      ELSE
         ::qLeftFrame:hide()
      ENDIF
   ENDIF
   RETURN ::lTablesTree

METHOD HbQtDBU:getTablesStructureEnabled()
   RETURN ::lTablesTree

METHOD HbQtDBU:setTablesStructureEnabled( lEnabled )
   IF HB_ISLOGICAL( lEnabled )
      ::lTablesStructure := lEnabled
      IF ::lTablesStructure
         ::qRightFrame:show()
      ELSE
         ::qRightFrame:hide()
      ENDIF
   ENDIF
   RETURN ::lTablesStructure


METHOD HbQtDBU:background( oBrush )
   LOCAL oOldBrush := ::sl_brush
   LOCAL oPanel

   IF HB_ISOBJECT( oBrush )
      ::sl_brush := oBrush
      FOR EACH oPanel IN ::aPanels
         oPanel:oWidget:setBackground( ::sl_brush )
      NEXT
   ENDIF

   RETURN oOldBrush


METHOD HbQtDBU:getTreeInfo()
   LOCAL aInfo := {}
   LOCAL oParent, oChild, oInfo
   LOCAL oSections := ::oTreeTables:invisibleRootItem()
   LOCAL n, nn, nnn, i, ii
   LOCAL cSection, cParent, cInfo, cTable, cDriver, cConxn

   FOR n := 0 TO oSections:childCount() - 1
      oParent := oSections:child( n )
      cSection := oParent:text( 0 )
      FOR nn := 0 TO oParent:childCount() - 1
         oChild  := oParent:child( nn )
         cParent := oChild:text( 0 )
         FOR nnn := 0 TO oChild:childCount() - 1
            oInfo := oChild:child( nnn )
            cInfo := oInfo:tooltip( 0 )
            i := At( "[", cInfo )    /* It must be > 0 */
            IF i > 0
               ii := At( "][", cInfo )
               IF ii > 0
                  cConxn := StrTran( AllTrim( SubStr( cInfo, ii + 2 ) ), "]" )
                  cInfo  := SubStr( cInfo, 1, ii - 1 )
               ELSE
                  cConxn := ""
               ENDIF
               cTable  := StrTran( AllTrim( SubStr( cInfo, 1, i - 1 ) ), ":", "&" )
               cDriver := StrTran( AllTrim( SubStr( cInfo, i + 1 ) ), "]" )
               AAdd( aInfo, cSection + " " + cParent + " " + oInfo:text( 0 ) + " " + cTable + " " + cDriver + " " + cConxn + " " )
            ENDIF
         NEXT
      NEXT
   NEXT

   RETURN aInfo


METHOD HbQtDBU:clearTablesTree()
   ::oTreeTables:clear()
   RETURN Self

METHOD HbQtDBU:populateTree( xSection, cParent, cNode, cTable, cDriver, cConxn, cIcon )
   LOCAL oTreeItem, oParent, cSection, oSection, oNode

   IF HB_ISARRAY( xSection )
      ASize( xSection, 7 )
      cSection := xSection[ 1 ]
      cParent  := xSection[ 2 ]
      cNode    := xSection[ 3 ]
      cTable   := xSection[ 4 ]
      cDriver  := xSection[ 5 ]
      cConxn   := xSection[ 6 ]
      cIcon    := xSection[ 7 ]
   ELSE
      cSection := xSection
   ENDIF
   cTable := StrTran( cTable, "&", ":" )

   IF HB_ISCHAR( cSection ) .AND. ! Empty( cSection )
      oSection := findItem( ::oTreeTables:invisibleRootItem(), cSection )
      IF oSection == NIL
         WITH OBJECT oSection := QTreeWidgetItem()
            :setText( 0, cSection )
            :setTooltip( 0, cSection )
            :setForeground( 0, QBrush( QColor( 120,75,75 ) ) )
         ENDWITH
         ::oTreeTables:invisibleRootItem():addChild( oSection )
      ENDIF
      oParent := findItem( oSection, cParent )
      IF oParent == NIL
         WITH OBJECT oParent := QTreeWidgetItem()
            :setText( 0, cParent )
            :setTooltip( 0, cParent )
            :setForeground( 0, QBrush( QColor( 75,120,75 ) ) )
         ENDWITH
         oSection:addChild( oParent )
         oSection:setExpanded( .T. )
      ENDIF

      oNode := findItem( oParent, cNode )
      IF oNode == nil
         WITH OBJECT oTreeItem := QTreeWidgetItem()
            :setText( 0, cNode )
            :setTooltip( 0, cTable + " [" + cDriver + iif( Empty( cConxn ), "", "][" + cConxn ) + "]" )
            :setIcon( 0, QIcon( iif( Empty( cIcon ), __hbqtImage( "table" ), cIcon ) ) )
         ENDWITH
         oParent:addChild( oTreeItem )
         oParent:sortChildren( 0, Qt_AscendingOrder )
      ENDIF
   ENDIF

   IF ::tablesTreeEnabled
      IF ! ::qLeftFrame:isVisible()
         ::qLeftFrame:show()
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtDBU:getPanelNames()
   LOCAL oPanel, aNames := {}, aAttr

   FOR EACH oPanel IN ::aPanels
      aAttr := {}

      aadd( aAttr, oPanel:cPanel )
      aadd( aAttr, hb_ntos( oPanel:oWidget:viewMode() ) )
      aadd( aAttr, hb_ntos( oPanel:nViewStyle ) )

      aadd( aNames, hbide_array2String( aAttr, "," ) )
   NEXT

   RETURN aNames


METHOD HbQtDBU:getPanelsInfo()
   LOCAL oMdiBrw, oPanel, aSub, n, cColumns
   LOCAL aInfo := {}, aAttr

   FOR EACH oPanel IN ::aPanels
      FOR EACH aSub IN oPanel:subWindows()
         aAttr := array( TBL_VRBLS )
         aAttr[ TBL_PANEL ] := oPanel:cPanel

         oMdiBrw := aSub[ 4 ]
         IF oMdiBrw:nType == BRW_TYPE_DBF
            aAttr[ TBL_NAME     ] := oMdiBrw:cTable
            aAttr[ TBL_ALIAS    ] := oMdiBrw:cAlias
            aAttr[ TBL_DRIVER   ] := oMdiBrw:cDriver
            aAttr[ TBL_INDEX    ] := hb_ntos( oMdiBrw:indexOrd()  )
            aAttr[ TBL_RECORD   ] := hb_ntos( oMdiBrw:recNo()     )
            aAttr[ TBL_CURSOR   ] := hb_ntos( oMdiBrw:nCursorType )
//          IF !HB_ISOBJECT( aSub[ SUB_GEOMETRY ] )
               aSub[ SUB_GEOMETRY ] := aSub[ SUB_WINDOW ]:geometry()
//          ENDIF
            aAttr[ TBL_GEOMETRY ] := hb_ntos( aSub[ SUB_GEOMETRY ]:x() )     + " " + hb_ntos( aSub[ SUB_GEOMETRY ]:y() ) + " " + ;
                                     hb_ntos( aSub[ SUB_GEOMETRY ]:width() ) + " " + hb_ntos( aSub[ SUB_GEOMETRY ]:height() )
            aAttr[ TBL_ROWPOS   ] := hb_ntos( oMdiBrw:oBrw:rowPos() )
            aAttr[ TBL_COLPOS   ] := hb_ntos( oMdiBrw:oBrw:colPos() )
            aAttr[ TBL_HZSCROLL ] := ""
            aAttr[ TBL_CONXN    ] := oMdiBrw:cConxn
            aAttr[ TBL_NEXT     ] := ""

            cColumns := ""
            FOR n := 1 TO oMdiBrw:oBrw:colCount
               cColumns += oMdiBrw:oBrw:getColumn( n ):heading + " "
            NEXT
            aAttr[ TBL_COLUMNS  ] := cColumns
         ENDIF
         aadd( aInfo, hbide_array2String( aAttr, "," ) )
      NEXT
   NEXT

   RETURN aInfo


METHOD HbQtDBU:addPanels( aPanels )
   LOCAL cPanel, aPnl

   ::addPanel( "Main", .T. )           /* The default one */

   IF HB_ISARRAY( aPanels )
      FOR EACH cPanel IN aPanels
         aPnl := hb_aTokens( cPanel, "," )
         aSize( aPnl, 2 )
         IF empty( aPnl[ 2 ] )
            aPnl[ 2 ] := "NO"
         ENDIF
         IF ! Empty( aPnl[ 1 ] ) .AND. ! ( Trim( aPnl[ 1 ] ) == "Main" )
            ::addPanel( Trim( aPnl[ 1 ] ), aPnl[ 2 ] == "YES" )
         ENDIF
      NEXT
   ENDIF
   ::setPanel( "Main" )

   RETURN Self


METHOD HbQtDBU:addPanel( cPanel )
   LOCAL qPanel

   qPanel := HbQtPanelBrowse():new( cPanel, self )
   ::qStack:addWidget( qPanel:oWidget )
   aadd( ::aPanels, qPanel )
   ::addPanelsMenu( cPanel )

   RETURN Self


METHOD HbQtDBU:setPanel( cPanel )
   LOCAL n

   IF ( n := ascan( ::aPanels, {|o| o:oWidget:objectName() == cPanel } ) ) > 0
      ::qStack:setCurrentWidget( ::aPanels[ n ]:oWidget )
      ::qStack:setCurrentIndex( n-1 )
      ::oCurPanel := ::aPanels[ n ]
      ::oCurPanel:prepare()
      ::oCurPanel:activateBrowser()
   ENDIF

   RETURN Self


METHOD HbQtDBU:addPanelsMenu( cPanel )
   LOCAL qAct

   IF AScan( ::aPanelsAct, {|oAct| oAct:text() == cPanel } ) > 0  /* Possible duplicate */
      RETURN Self
   ENDIF

   IF HB_ISOBJECT( ::qPanelsMenu )
      qAct := ::qPanelsMenu:addAction( cPanel )
      qAct:setIcon( QIcon( __hbqtImage( "panel_7" ) ) )
      qAct:connect( "triggered(bool)", {|| ::setPanel( cPanel ) } )
      aadd( ::aPanelsAct, qAct )
   ENDIF
   RETURN Self


METHOD HbQtDBU:isPanel( cPanel )
   RETURN ascan( ::aPanels, {|o| o:oWidget:objectName() == cPanel } ) > 0


METHOD HbQtDBU:fetchFldsList( cAlias )
   LOCAL aFlds := {}, cA, oBrw, a_, oPanel, aBrw

   cA := upper( cAlias )

   SWITCH cA
   CASE "FIELD"
      FOR EACH oPanel IN ::aPanels
         FOR EACH aBrw IN oPanel:aBrowsers
            oBrw := aBrw[ SUB_BROWSER ]
            FOR EACH a_ IN oBrw:aStruct
               aadd( aFlds, pad( a_[ 1 ], 10 ) + " (" + padc( oBrw:cTableOnly, 12 ) + ")" + str( a_:__enumIndex(),3,0 ) + ", " + a_[ 2 ] + ", " + str( a_[ 3 ],3,0 ) + ", " + hb_ntos( a_[ 4 ] ) + " [f]" )
            NEXT
         NEXT
      NEXT
      EXIT
   OTHERWISE
      IF ! empty( oBrw := ::getBrowserByAlias( cA ) )
         FOR EACH a_ IN oBrw:aStruct
            aadd( aFlds, pad( a_[ 1 ], 10 ) + " ( " + str( a_:__enumIndex(),3,0 ) + ", " + a_[ 2 ] + ", " + str( a_[ 3 ],3,0 ) + ", " + hb_ntos( a_[ 4 ] ) + " )"  + " [f]" )
         NEXT
      ENDIF
      EXIT
   ENDSWITCH

   RETURN aFlds


METHOD HbQtDBU:getBrowserByAlias( cAlias )
   LOCAL oPanel, aBrw
   cAlias := Upper( cAlias )
   FOR EACH oPanel IN ::aPanels
      FOR EACH aBrw IN oPanel:aBrowsers
         IF aBrw[ SUB_BROWSER ]:cAlias == cAlias
            RETURN aBrw[ SUB_BROWSER ]
         ENDIF
      NEXT
   NEXT
   RETURN NIL


METHOD HbQtDBU:dispStatusInfo()

   ::aStatusPnls[ PNL_PANELS ]:setText( "Panels: " + hb_ntos( Len( ::aPanels ) ) + ":" + ::oCurPanel:cPanel )
   ::aStatusPnls[ PNL_TABLES ]:setText( "Tables: " + hb_ntos( Len( ::oCurPanel:aBrowsers ) ) )

   ::aStatusPnls[ PNL_MISC   ]:setText( "M:"    )
   ::aStatusPnls[ PNL_READY  ]:setText( "Ready" )

   RETURN Self


METHOD HbQtDBU:buildStatusPanels()
   LOCAL qLabel

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 0 )
   aadd( ::aStatusPnls, qLabel )

   qLabel := QLabel(); qLabel:setMinimumWidth( 40 )
   ::qStatus:addPermanentWidget( qLabel, 1 )
   aadd( ::aStatusPnls, qLabel )

   RETURN Self


METHOD HbQtDBU:execEvent( nEvent, p, p1 )
   LOCAL cTable, cPath, cPanel, qMime, qList, i, cExt, qUrl, aPopulate, cInfo, n, nn, cDriver, cConxn

   HB_SYMBOL_UNUSED( p1 )

   SWITCH nEvent
   CASE __dbu_dragEnterEvent__
      p:acceptProposedAction()
      EXIT

   CASE __dbu_dropEvent__
      qMime := p:mimeData()
      IF qMime:hasUrls()
         qList := qMime:urls()
         FOR i := 0 TO qList:size() - 1
            qUrl := qList:at( i )
            hb_fNameSplit( qUrl:toLocalFile(), @cPath, @cTable, @cExt )
            IF lower( cExt ) == ".dbf"
               ::oCurPanel:addBrowser( { NIL, ;
                                         hbide_pathToOSPath( cPath + cTable + cExt ), ;
                                         NIL, ;
                                         iif( ! ( ::qRddCombo:currentText() $ "DBFCDX,DBFNTX,DBFNSX" ), "DBFCDX", ::qRddCombo:currentText() ) } )
               IF HB_ISBLOCK( ::populateTreeBlock )
                  aPopulate := Eval( ::populateTreeBlock(), hbide_pathToOSPath( cPath + cTable + cExt ), iif( ! ( ::qRddCombo:currentText() $ "DBFCDX,DBFNTX,DBFNSX" ), "DBFCDX", ::qRddCombo:currentText() ), ::currentConxn() )
                  IF HB_ISARRAY( aPopulate ) .AND. Len( aPopulate ) >= 6
                     ::populateTree( aPopulate )
                  ENDIF
               ENDIF
            ENDIF
         NEXT
      ENDIF
      EXIT

   CASE __buttonOpenIndex_clicked__
      IF ! Empty( ::oCurBrw )
         IF ! empty( cTable := hbdbu_fetchAFile( ::oWidget, "Select an Index", "All Files (*)", ::oCurBrw:path() ) )
            ::oCurBrw:addIndexFile( cTable )
            ::oCurBrw:setIndexInfo()
            ::updateIndexMenu( ::oCurBrw )
         ENDIF
      ENDIF
      EXIT

   CASE __buttonOpen_clicked__
      IF HB_ISBLOCK( ::selectTableBlock ) .AND. ! Empty( cTable := Eval( ::selectTableBlock, ::currentDriver(), ::currentConxn(), Self ) )
         ::oCurPanel:addBrowser( { NIL, cTable } )
         IF HB_ISBLOCK( ::populateTreeBlock )
            aPopulate := Eval( ::populateTreeBlock(), cTable, ::currentDriver(), ::currentConxn() )
            IF HB_ISARRAY( aPopulate ) .AND. Len( aPopulate ) >= 6
               ::populateTree( aPopulate )
            ENDIF
         ENDIF
      ELSE
         IF ::currentDriver() $ "DBFCDX,DBFNTX,DBFNSX,ADS"
            IF !empty( cTable := hbdbu_fetchAFile( ::oWidget, "Select a Table", "Database File (*.dbf)", ::cWrkFolderLast ) )
               hb_fNameSplit( cTable, @cPath )
               ::cWrkFolderLast := cPath
               ::oCurPanel:addBrowser( { NIL, cTable } )

               IF HB_ISBLOCK( ::populateTreeBlock )
                  aPopulate := Eval( ::populateTreeBlock(), hbide_pathToOSPath( cTable ), ::currentDriver(), ::currentConxn() )
                  IF HB_ISARRAY( aPopulate ) .AND. Len( aPopulate ) >= 6
                     ::populateTree( aPopulate )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      EXIT

   CASE __dbu_treeTableDoubleClicked__
      cConxn := ""
      cInfo := p:tooltip( 0 )
      IF ( n := At( "[", cInfo ) ) > 0
         cTable := SubStr( cInfo, 1, n - 2 )
         nn     := At( "]", cInfo )
         cDriver := SubStr( cInfo, n + 1, nn - n - 1 )
         n      := At( "][", cInfo )
         IF n > 0
            cConxn := StrTran( SubStr( cInfo, n + 2 ), "]" )
         ENDIF
         ::oCurPanel:addBrowser( { NIL, cTable, NIL, cDriver, , , , , , , , cConxn } )
      ENDIF
      EXIT

   CASE __buttonShowForm_clicked__
      IF ::tablesTreeEnabled
         IF ::qLeftFrame:isVisible()
            ::qLeftFrame:hide()
         ELSE
            ::qLeftFrame:show()
         ENDIF
      ENDIF
      EXIT

   CASE __buttonDbStruct_clicked__
      IF ::tablesStructureEnabled
         IF ::qRightFrame:isVisible()
            ::qRightFrame:hide()
         ELSE
            ::qRightFrame:show()
         ENDIF
      ENDIF
      EXIT

   CASE __buttonClose_clicked__
      IF !empty( ::oCurBrw )
         ::oCurPanel:destroyBrw( ::oCurBrw )
      ENDIF
      EXIT

   CASE __buttonLink_clicked__
      ::linkTables()
      EXIT

   CASE __qPanelsButton_clicked__
      cPanel := HbQtBulkGet( Pad( "New...", 20 ), "Name of Panel:", , , , "New Panel" )
      IF ! Empty( cPanel )
         cPanel := Trim( cPanel )
         IF !( cPanel == "New..." ) .AND. !( cPanel == "Main" )
            IF ::isPanel( cPanel )
               Alert( "Panel: " + cPanel + ", already exists" )
            ELSE
               ::addPanel( cPanel )
               ::setPanel( cPanel )
            ENDIF
         ENDIF
      ENDIF
      EXIT

   /* Left-toolbar actions */
   CASE __buttonViewTabbed_clicked__
      ::oCurPanel:oWidget:setViewMode( iif( ::oCurPanel:oWidget:viewMode() == QMdiArea_TabbedView, QMdiArea_SubWindowView, QMdiArea_TabbedView ) )
      EXIT
   CASE __buttonViewOrganized_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_ORGANIZED )
      EXIT
   CASE __buttonSaveLayout_clicked__
      ::oCurPanel:saveGeometry()
      EXIT
   CASE __buttonViewCascaded_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_CASCADED )
      EXIT
   CASE __buttonViewTiled_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_TILED )
      EXIT
   CASE __buttonViewMaximized_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_MAXIMIZED )
      EXIT
   CASE __buttonViewStackedVert_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_TILEDVERT )
      EXIT
   CASE __buttonViewStackedHorz_clicked__
      ::oCurPanel:setViewStyle( HBQTMDI_STYLE_TILEDHORZ )
      EXIT
   CASE __buttonViewZoomedIn_clicked__
      ::oCurPanel:tilesZoom( +1 )
      EXIT
   CASE __buttonViewZoomedOut_clicked__
      ::oCurPanel:tilesZoom( -1 )
      EXIT

   /* Left-toolbar Table Manipulation Actions */
   CASE __buttonTables_clicked__
      ::showTablesTree()
      EXIT

   CASE __buttonIndex_clicked__
      EXIT

   CASE __dbStruct_closeEvent__
      ::cDbStructDialogGeometry := hbide_posAndSize( ::qStruct:oWidget )
      ::qStruct:close()
      ::lStructOpen := .f.
      EXIT

   CASE __fieldsTable_itemSelectionChanged__
      ::populateFieldData()
      EXIT

   CASE __buttonFind_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:searchAsk()
      ENDIF
      EXIT

   CASE __buttonGoto_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:gotoAsk()
      ENDIF
      EXIT

   CASE __buttonAppendRecord_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:append()
      ENDIF
      EXIT
   CASE __buttonDelRecord_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:delete( .t. )
      ENDIF
      EXIT
   CASE __buttonLockRecord_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:lock()
      ENDIF
      EXIT
   CASE __buttonGoTop_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:goTop()
      ENDIF
      EXIT
   CASE __buttonGoBottom_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:goBottom()
      ENDIF
      EXIT
   CASE __buttonScrollToFirst_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:toColumn( 1 )
      ENDIF
      EXIT
   CASE __buttonScrollToLast_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:toColumn( Len( ::oCurBrw:aStruct ) )
      ENDIF
      EXIT
   CASE __buttonSearchInTable_clicked__
      IF !empty( ::oCurBrw )
         ::oCurBrw:searchAsk()
      ENDIF
      EXIT
   CASE __buttonZaptable_clicked__
      EXIT
   CASE __buttonCopyStruct_clicked__
      ::copyStructToClipboard()
      EXIT
   /*  End - left-toolbar actions */

   ENDSWITCH

   RETURN Self


METHOD HbQtDBU:copyStructToClipboard()
   LOCAL aStruct, i, cTmp

   IF ! empty( aStruct := ::oCurBrw:dbStruct() )
      ::aCopiedStruct := AClone( aStruct )

      i := 0
      aeval( aStruct, {|e_| iif( Len( e_[ 1 ] ) > i, i := len( e_[ 1 ] ), NIL ) } )
      i += 2

      cTmp := "   LOCAL aStruct := {"
      aeval( aStruct, {|e_,n| cTmp += iif( n == 1, ' { ', space( 20 ) + '  { ' ) + ;
                                 pad( '"' + e_[ 1 ] + '"', i ) + ', "' + e_[ 2 ] + '", ' + ;
                                     str( e_[ 3 ], 4, 0 ) + ', ' + ;
                                         str( e_[ 4 ], 2, 0 ) + ' }' + ;
                                             iif( Len( aStruct ) == n, " }", ",;" ) + hb_eol() } )

      QClipboard():setText( cTmp )
   ENDIF

   RETURN cTmp


METHOD HbQtDBU:updateLinks( cAlias )
   LOCAL aRel, cScope

   IF hb_HHasKey( ::hRelatns, cAlias )
      FOR EACH aRel IN ::hRelatns[ cAlias ]
         IF aRel[ 4 ] == Qt_Checked
            ::evalExpression( aRel[ 2 ], @cScope )
            ::setScope( aRel[ 1 ], cScope, cScope )
            ::updateLinks( aRel[ 1 ] )
         ELSE
            ::setScope( aRel[ 1 ], "", "" )
         ENDIF
      NEXT
   ENDIF

   RETURN .F.


METHOD HbQtDBU:setLinksInfo( aInfo )
   LOCAL s, ss, a_, x_, n, cPanel

   FOR EACH s IN aInfo
      IF ( n := At( ":", s ) ) > 0
         cPanel := SubStr( s, 1, n-1 )
         s      := SubStr( s, n+1 )
         a_     := {}
         FOR EACH ss IN hb_ATokens( s, "^" )
            IF ! Empty( ss )
               x_:= hb_ATokens( ss, ";" )
               x_[ 5 ] := Val( x_[ 5 ] )
               AAdd( a_, x_ )
            ENDIF
         NEXT
         ::hMaps[ cPanel ] := a_
      ENDIF
   NEXT

   RETURN Self


METHOD HbQtDBU:getLinksInfo()
   LOCAL aMap, s, a_, aInfo := {}

   IF ! Empty( ::hMaps )
      FOR EACH aMap IN ::hMaps
         s      := ""
         FOR EACH a_ IN aMap
            s += a_[ 1 ] + ";" + a_[ 2 ] + ";" + a_[ 3 ] + ";" + a_[ 4 ] + ";" + hb_ntos( a_[ 5 ] ) + ";^"
         NEXT
         AAdd( aInfo, aMap:__enumKey() + ":" + s )
      NEXT
   ENDIF

   RETURN aInfo


METHOD HbQtDBU:linkTables()
   LOCAL oDlg, oTree, oLay, oHLay, oBtnOK, oBtnCancel, a_, oChild, aMaps
   LOCAL nRet, aBrowser, oBrw, qItm, oFont, oParent, oList, i, n, aRelatns, cScope, aRel

   IF Empty( ::oCurPanel:aBrowsers )
      Alert( "No tables is open on this panel !" )
      RETURN Self
   ELSEIF Len( ::oCurPanel:aBrowsers ) == 1
      Alert( "Link can only be established if more than one table is open !" )
      RETURN nil
   ENDIF

   oFont := QFont( "Courier new", 10 )

   oLay  := QVBoxLayout()
   oHLay := QHBoxLayout()

   WITH OBJECT oDlg := QDialog( ::oWidget )
      :setWindowTitle( "Build Links Map for Tables on " + ::oCurPanel:name() )
      :setWindowIcon( QIcon( __hbqtImage( "link" ) ) )
      :setLayout( oLay )
      :setAcceptDrops( .t. )
      :connect( QEvent_DragEnter, {|p| ::manageLinkTree( 11, p ) } )
      :connect( QEvent_DragMove , {|p| ::manageLinkTree( 12, p ) } )
      :connect( QEvent_Drop     , {|p| ::manageLinkTree( 13, p ) } )
   ENDWITH

   oList := QStringList()
   oList:append( "Table" )
   oList:append( "Link Expression" )
   oList:append( "FOR Expression" )
   WITH OBJECT oTree := QTreeWidget()
      :setColumnCount( 3 )
      :setHeaderLabels( oList )
      :setContextMenuPolicy( Qt_CustomContextMenu )
      :setDragEnabled( .T. )
      :setDropIndicatorShown( .T. )
      :setAcceptDrops( .T. )
      :setDragDropMode( QAbstractItemView_InternalMove )
      :setExpandsOnDoubleClick( .F. )
      :setAutoExpandDelay( 100 )
      :setAlternatingRowColors( .T. )
      :setIndentation( 10 )
      :connect( "itemCollapsed(QTreeWidgetItem*)"        , {|p   | ::manageLinkTree( 1, p     ) } )
      :connect( "itemExpanded(QTreeWidgetItem*)"         , {|p   | ::manageLinkTree( 2, p     ) } )
      :connect( "customContextMenuRequested(QPoint)"     , {|p   | ::manageLinkTree( 3, p     ) } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|p,p1| ::manageLinkTree( 4, p, p1 ) } )
   ENDWITH
   WITH OBJECT oTree:Header()
      :resizeSection( 0, 150 )
      :resizeSection( 1, 250 )
      :resizeSection( 2, 150 )
      :setDefaultAlignment( Qt_AlignHCenter )
   ENDWITH

   oLay:addWidget( oTree )
   oBtnOK     := QPushButton()
   oBtnOK     :  setText( "OK" )
   oBtnOK     :  connect( "clicked()", {||  oDlg:done( 1 ) } )

   oBtnCancel := QPushButton()
   oBtnCancel :  setText( "Cancel" )
   oBtnCancel :  connect( "clicked()", {||  oDlg:done( 0 ) } )

   oLay:addLayout( oHLay )
   WITH OBJECT oHLay
      :addStretch()
      :addWidget( oBtnOK )
      :addWidget( oBtnCancel )
   ENDWITH

   WITH OBJECT ::oRoot := QTreeWidgetItem()
      :setText( 0, "Aliases" )
      :setFlags( 0 )
      :setFlags( hb_bitOr( Qt_ItemIsSelectable, Qt_ItemIsEnabled, Qt_ItemIsDropEnabled ) )
   ENDWITH
   oTree:invisibleRootItem():addChild( ::oRoot )

   IF hb_HHasKey( ::hMaps, ::oCurPanel:name() )
      aMaps := ::hMaps[ ::oCurPanel:name() ]
   ENDIF
   IF Empty( aMaps )
      aMaps := {}
   ENDIF
   FOR EACH aBrowser IN ::oCurPanel:aBrowsers
      oBrw := aBrowser[ SUB_BROWSER ]
      IF AScan( aMaps, {|e_| e_[ 1 ] == oBrw:cAlias } ) == 0
         AAdd( aMaps, { oBrw:cAlias, "", "", "", Qt_Checked } )
      ENDIF
   NEXT
   FOR EACH a_ IN aMaps
      oParent := findItem( ::oRoot, a_[ 2 ] )
      IF Empty( oParent )
         oParent := ::oRoot
      ENDIF
      IF ( n := AScan( ::oCurPanel:aBrowsers, {|e_| e_[ SUB_BROWSER ]:cAlias == a_[ 1 ] } ) ) > 0
         oBrw := ::oCurPanel:aBrowsers[ n, SUB_BROWSER ]
         WITH OBJECT qItm := QTreeWidgetItem()
            :setFlags( 0 )
            :setFlags( hb_bitOr( Qt_ItemIsSelectable, Qt_ItemIsDragEnabled, Qt_ItemIsEnabled, Qt_ItemIsDropEnabled, Qt_ItemIsUserCheckable ) )

            :setText( 0, oBrw:cAlias )
            :setFont( 0, oFont )
            :setBackground( 0, QBrush( QColor( 250, 250, 250 ) ) )
            :setToolTip( 0, oBrw:cTable + "[" + oBrw:cDriver + " " + ;
                          hb_ntos( oBrw:indexOrd() ) + " " + iif( oBrw:indexOrd() > 0, oBrw:ordName(), "" ) + "]" )

            :setText( 1, iif( oParent == ::oRoot, "", a_[ 3 ] ) )
            :setFont( 1, oFont )
            :setTooltip( 1, "Provide a link expression based on parent!" + Chr( 10 ) + "Must use parents alias to identify a field." + Chr( 10 ) + "F2 <List of Fields>" )

            :setText( 2, iif( oParent == ::oRoot, "", a_[ 4 ] ) )
            :setFont( 2, oFont )
            :setTooltip( 2, "Provide a FOR expression if needs further filtering!" + Chr( 10 ) + "Must use table alias to identify a field." + Chr( 10 ) + "F2 <List of Fields>" )

            :setCheckState( 0, a_[ 5 ] )
         ENDWITH
         oParent:addChild( qItm )
         oParent:setExpanded( .T. )
      ENDIF
   NEXT

   oDlg:resize( 600, 400 )
   nRet := oDlg:exec()

   IF nRet > 0
      ::hRelatns := {=>}
      aMaps := {}
      IF ::oRoot:childCount() > 0
         FOR i := 0 TO ::oRoot:childCount() - 1
            oChild := ::oRoot:child( i )
            AAdd( aMaps, { oChild:text( 0 ), "", oChild:text( 1 ), oChild:text( 2 ), oChild:checkState( 0 ) } )
            ::fetchLinkedChildren( oChild, @aMaps )
         NEXT
      ENDIF
      ::hMaps[ ::oCurPanel:name() ] := aMaps
      IF ! Empty( ::hRelatns )
         FOR EACH aRelatns IN ::hRelatns
            FOR EACH aRel IN aRelatns
               IF aRel[ 4 ] == Qt_Checked
                  ::evalExpression( aRel[ 2 ], @cScope )
                  ::setScope( aRel[ 1 ], cScope, cScope )
               ELSE
                  ::setScope( aRel[ 1 ], "", "" )
               ENDIF
            NEXT
         NEXT
      ENDIF
   ENDIF

   oDlg:setParent( QWidget() )
   RETURN Self


METHOD HbQtDBU:fetchLinkedChildren( qItm, aMaps )
   LOCAL i, oChild, aChilds := {}

   IF qItm:childCount() > 0
      FOR i := 0 TO qItm:childCount() - 1
         oChild := qItm:child( i )
         IF ! Empty( oChild:text( 1 ) )             /* Must have a valid link expression */
            AAdd( aChilds, { oChild:text( 0 ), oChild:text( 1 ), oChild:text( 2 ), oChild:checkState( 0 ) } )
         ENDIF
      NEXT
      IF ! Empty( aChilds )
         ::hRelatns[ qItm:text( 0 ) ] := aChilds
      ENDIF
      FOR i := 0 TO qItm:childCount() - 1
         oChild := qItm:child( i )
         AAdd( aMaps, { oChild:text( 0 ), qItm:text( 0 ), oChild:text( 1 ), oChild:text( 2 ), oChild:checkState( 0 ) } )
         ::fetchLinkedChildren( qItm:child( i ), @aMaps )
      NEXT
   ENDIF

   RETURN Self

METHOD HbQtDBU:manageLinkTree( nMode, p, p1 )
   LOCAL nW, nX, nY, nCol, oRec, oPos, cPic, cVar, cAlias, kf2

   SWITCH nMode
   CASE 1
      EXIT
   CASE 2
      EXIT
   CASE 3
      EXIT
   CASE 4    /* Double-clicked*/
      IF p1 == 0
         RETURN Self
      ENDIF
      nCol    := p1
      cVar    := pad( p:text( nCol ), 100 )
      nX      := p:treeWidget():Header():sectionViewportPosition( nCol )
      nW      := p:treeWidget():Header():sectionSize( nCol )
      oRec    := p:treeWidget():visualItemRect( p )
      nY      := oRec:y()
      oPos    := p:treeWidget():viewport():mapToGlobal( QPoint( nX, nY ) )
      cPic    :=  "@S" + hb_ntos( Int( nW/8 )-1 )
      cAlias  := iif( nCol == 2, p:text( 0 ), iif( Empty( p:parent() ), "", iif( p:parent():text( 0 ) == "Aliases", "", p:parent():text( 0 ) ) ) )

      kf2 := SetKey( K_F2, {|| ::selectAField( cAlias )  } )

      cVar := HbQtGetAt( oPos:x() - 6, oPos:y(), cVar, cPic, "B/W*", {|| ::evalExpression( Trim( GetActive():varGet() ) ) } )
      IF cVar != NIL
         p:setText( p1, AllTrim( cVar ) )
      ENDIF
      SetKey( K_F2, kf2 )
      EXIT
   CASE 11   /* Just IN CASE we need external drops */
      p:acceptProposedAction()
      EXIT
   CASE 12
      p:acceptProposedAction()
      EXIT
   CASE 13
      EXIT
   ENDSWITCH

   RETURN Self


METHOD HbQtDBU:evalExpression( cExpression, cValue )
   LOCAL bError := ErrorBlock( {|| ErrorBreak() } )
   LOCAL lRet := .F.

   BEGIN SEQUENCE
      cValue := Eval( &( "{|| " + cExpression + " }" ) )
      IF cValue != NIL
         lRet := .T.
      ENDIF
   END SEQUENCE

   ErrorBlock( bError )
   RETURN lRet


STATIC PROCEDURE ErrorBreak()
   IF .T.
      BREAK
   ENDIF
   RETURN


METHOD HbQtDBU:selectAField( cAlias )
   LOCAL aStruct, nChoice, cVar, nPos, aMenu := {}

   IF Empty( cAlias )
      RETURN Self
   ENDIF

   aStruct := ::dbStruct( cAlias )
   AEval( aStruct, {|e_| AAdd( aMenu, e_[ 1 ] ) } )

   nChoice := HbQtAChoice( , , , , aMenu, , , , , , cAlias + " : Select a Field" )
   IF nChoice > 0
      cVar := GetActive():buffer()
      nPos := GetActive():pos()
      cVar := SubStr( cVar, 1, nPos ) + ( cAlias + "->" + aStruct[ nChoice, 1 ] ) + SubStr( cVar, nPos + 1 )
      GetActive():varPut( cVar )
      GetActive():display()
      GetActive():pos := nPos + Len( cAlias + "->" + aStruct[ nChoice, 1 ] )
   ENDIF

   RETURN NIL


METHOD HbQtDBU:showTablesTree()
   LOCAL oDlg, qTree, oLay, qBtnOK, qParent, oPanel, qItm, aBrowser, q, aFld, nMax, nSz, oBrw
   LOCAL a_:={}

   oDlg := QDialog( ::oWidget )
   oLay := QVBoxLayout()
   oDlg:setLayout( oLay )

   qTree := QTreeWidget()
   qTree:setFont(  QFont( "Courier New", 8 ) )
   qTree:setHeaderHidden( .T. )
   qTree:setIndentation( 10 )

   qBtnOK := QPushButton()
   qBtnOK:setText( "OK" )
   qBtnOK:connect( "clicked()", {|| oDlg:done( 1 ) } )

   oLay:addWidget( qTree )
   oLay:addWidget( qBtnOK )

   FOR EACH oPanel IN ::aPanels
      qParent := QTreeWidgetItem()
      qParent:setText( 0, oPanel:cPanel )
      qTree:addTopLevelItem( qParent )
      aadd( a_, qParent )
      FOR EACH aBrowser IN oPanel:aBrowsers
         oBrw := aBrowser[ SUB_BROWSER ]

         qItm := QTreeWidgetItem()
         qItm:setText( 0, oBrw:cTable )

         qItm:setToolTip( 0, oBrw:cTableOnly + " [ " + oBrw:cDriver + "  " + ;
                          hb_ntos( oBrw:indexOrd() ) + "/" + hb_ntos( oBrw:numIndexes() ) + iif( oBrw:indexOrd() > 0, ":" + oBrw:ordName(), "" ) + ;
                          "  " + hb_ntos( oBrw:recno() ) + "/" + hb_ntos( oBrw:lastRec() ) + " ]  " )

         qParent:addChild( qItm )
         nSz := 0 ; aeval( aBrowser[ SUB_BROWSER ]:aStruct, {|e_| nSz += e_[ 3 ] } )
         nMax := 12
         FOR EACH aFld IN aBrowser[ SUB_BROWSER ]:aStruct
            q := QTreeWidgetItem()
            q:setText( 0, Str( aFld:__enumIndex(),3,0 ) + "  " + pad( aFld[ 1 ], nMax ) + aFld[ 2 ] + str( aFld[ 3 ], 4, 0 ) + str( aFld[ 4 ], 2, 0 ) )
            q:setToolTip( 0, "" )
            qItm:addChild( q )
         NEXT
         q := QTreeWidgetItem()
         q:setText( 0, "     " + pad( "T", nMax - 2 ) + str( nSz, 7, 0 ) )
         qItm:addChild( q )
     NEXT
      qParent:setExpanded( .t. )
   NEXT

   oDlg:exec()
   oDlg:setParent( QWidget() )

   RETURN Self


METHOD HbQtDBU:createTable( cDriver, cConxn, aStruct, aIndexes )
   LOCAL cTable, cName, cPath, cExt, aIdx, nArea

   IF HB_ISBLOCK( ::saveTableBlock ) .AND. ! Empty( cTable := Eval( ::saveTableBlock, cDriver, cConxn, aStruct, aIndexes, Self ) )
      HB_SYMBOL_UNUSED( cTable )
   ELSE
      IF cDriver $ "DBFCDX,DBFNTX,DBFNSX,ADS"
         IF ! Empty( cTable := hbdbu_saveAFile( ::oWidget, "Save Table", "Database File (*.dbf)", ::cWrkFolderLast ) )
            hb_fNameSplit( cTable, @cPath, @cName, @cExt )
            ::cWrkFolderLast := cPath
            IF Lower( cExt ) == ".dbf"
               nArea := Select()
               dbCreate( cTable, aStruct, cDriver )
               IF ! NetErr() .AND. hb_FileExists( cTable )
                  USE ( cTable ) NEW EXCLUSIVE ALIAS "NewTable" VIA ( cDriver )
                  IF ! NetErr()
                     FOR EACH aIdx IN aIndexes
                        INDEX ON &( aIdx[ 2 ] ) TAG ( aIdx[ 1 ] )
                     NEXT
                     USE
                     Alert( "Table: " + cTable + ", has been created successfully!" )
                  ELSE
                     Alert( "Some error in creating : " + cTable )
                  ENDIF
               ENDIF
               Select( nArea )
            ELSE
               Alert( "Table name must be of type .dbf" )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtDBU:openATable( cDBF )

   ::oCurPanel:addBrowser( { NIL, ;
                             cDBF, ;
                             NIL, ;
                             iif( ! ( ::qRddCombo:currentText() $ "DBFCDX,DBFNTX,DBFNSX" ), "DBFCDX", ::qRddCombo:currentText() ) } )
   RETURN Self

METHOD HbQtDBU:open( aDbfs )
   LOCAL aInfo, cTable
   LOCAL nX := 0, nY := 0

   FOR EACH cTable IN aDbfs
      nX += 20; nY += 20
      // Main,C:\harbour\tests\test.dbf,TEST,DBFCDX,0,500,2,0 0 300 504,21,1,,,,
      aInfo := array( TBL_VRBLS )
      aInfo[ TBL_PANEL    ] := "Main"
      aInfo[ TBL_NAME     ] := cTable
      aInfo[ TBL_GEOMETRY ] := hb_ntos( nX ) + " " + hb_ntos( nY ) + " 610 400"

      ::oCurPanel:addBrowser( aInfo )
   NEXT

   RETURN Self


METHOD HbQtDBU:loadTables( aPanelsInfo )
   LOCAL cInfo, aInfo, oCurPanel

   oCurPanel := ::oCurPanel

   FOR EACH cInfo IN aPanelsInfo
      IF ! Empty( aInfo := hb_aTokens( cInfo, "," ) )
         IF ::isPanel( aInfo[ TBL_PANEL ] )
            ::setPanel( aInfo[ TBL_PANEL ] )
            aInfo[ TBL_ALIAS ] := NIL
            ::oCurPanel:addBrowser( aInfo )
         ENDIF
      ENDIF
   NEXT

   IF HB_ISOBJECT( oCurPanel )
      ::qStack:setCurrentWidget( oCurPanel:oWidget )
   ENDIF

   RETURN Self


METHOD HbQtDBU:addArray( aData, aAttr )

   HB_SYMBOL_UNUSED( aData )
   HB_SYMBOL_UNUSED( aAttr )

   RETURN Self


METHOD HbQtDBU:buildToolbar()

   LOCAL nW := 20
   LOCAL qTBar

   ::sp0 := QLabel(); ::sp0:setMinimumWidth( nW )
   ::sp1 := QLabel(); ::sp1:setMinimumWidth( nW )
   ::sp2 := QLabel(); ::sp2:setMinimumWidth( nW )
   ::sp3 := QLabel(); ::sp3:setMinimumWidth( nW )
   ::sp4 := QLabel(); ::sp4:setMinimumWidth( nW )
   ::sp5 := QLabel(); ::sp5:setMinimumWidth( nW )

   qTBar := HbQtToolbar():new()
   qTBar:imageWidth  := 12
   qTBar:imageHeight := 12
   qTBar:create()

   qTBar:buttonClick := {|oButton| iif( HB_ISBLOCK( oButton:key ), Eval( oButton:key ), NIL ) }

   ::qToolbar := qTBar

   ::buildPanelsButton()
   qTBar:addItem( ::sp0 )
   ::buildRddsCombo()
   ::buildConxnCombo()
   qTBar:addItem( { "Open"     , "Open a Table"                   , QIcon( __hbqtImage( "open3"     ) ), {|| ::execEvent( __buttonOpen_clicked__     ) }, .F. } )
   qTBar:addItem( { "OpenIndex", "Attach an Index"                , QIcon( __hbqtImage( "open3"     ) ), {|| ::execEvent( __buttonOpenIndex_clicked__) }, .F. } )
   qTBar:addItem( ::sp1 )
   ::buildIndexButton()
   qTBar:addItem( { "Search"   , "Search in Table"                , QIcon( __hbqtImage( "find"      ) ), {|| ::execEvent( __buttonFind_clicked__     ) }, .F. } )
   qTBar:addItem( { "Goto"     , "Goto Record"                    , QIcon( __hbqtImage( "gotoline3" ) ), {|| ::execEvent( __buttonGoto_clicked__     ) }, .F. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "Close"    , "Close Current Table"            , QIcon( __hbqtImage( "dc_delete" ) ), {|| ::execEvent( __buttonClose_clicked__    ) }, .F. } )
   qTBar:addItem( ::sp2 )
   ::buildTablesButton()
   qTBar:addItem( ::sp3 )
   qTBar:addItem( { "Link"     , "Link A Child Table"             , QIcon( __hbqtImage( "link"      ) ), {|| ::execEvent( __buttonLink_clicked__     ) }, .F. } )
   qTBar:addItem( { "Create"   , "Create a Table"                 , QIcon( __hbqtImage( "table-add" ) ), {|| hbQtCreateTable():new( Self ):create()    }, .F. } )
   qTBar:addItem( ::sp4 )
   qTBar:addItem( { "Toggle"   , "Show/Hide Tables Tree Pane"     , QIcon( __hbqtImage( "form"      ) ), {|| ::execEvent( __buttonShowForm_clicked__ ) }, .F. } )
   qTBar:addItem( { "Structure", "Show/Hide Tables Structure Pane", QIcon( __hbqtImage( "dbstruct"  ) ), {|| ::execEvent( __buttonDbStruct_clicked__ ) }, .F. } )
   qTBar:addItem( ::sp5 )
   qTBar:addItem( { "SaveEnv"  , "Save Environment"               , QIcon( __hbqtImage( "save-env"  ) ), {|| ::saveEnvironment() }                      , .F. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "SaveEnvAs", "Save Environment As..."         , QIcon( __hbqtImage( "save3"     ) ), {|| ::saveEnvAs() }                            , .F. } )
   qTBar:addItem( { "RestEnv"  , "Merge Environment"              , QIcon( __hbqtImage( "rest-env"  ) ), {|| ::restEnvFrom() }                          , .F. } )

   RETURN Self


METHOD HbQtDBU:buildLeftToolbar()

   LOCAL qTBar

   qTBar             := HbQtToolbar():new()
   qTBar:orientation := Qt_Vertical
   qTBar:imageWidth  := 12
   qTBar:imageHeight := 12
   qTBar:create()
   qTBar:buttonClick := {|oButton| iif( HB_ISBLOCK( oButton:key ), Eval( oButton:key ), NIL ) }

   ::qToolbarL := qTBar

   qTBar:addItem( { "view_tabbed"      , "Toggle Tabbed View"      , QIcon( __hbqtImage( "view_tabbed"       ) ), {|| ::execEvent( __buttonViewTabbed_clicked__      ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "view_organized"   , "View as Arranged"        , QIcon( __hbqtImage( "view_organized"    ) ), {|| ::execEvent( __buttonViewOrganized_clicked__   ) }, .f. } )
   qTBar:addItem( { "save3"            , "Save Layout"             , QIcon( __hbqtImage( "save3"             ) ), {|| ::execEvent( __buttonSaveLayout_clicked__      ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "view_cascaded"    , "View as Cascaded"        , QIcon( __hbqtImage( "view_cascaded"     ) ), {|| ::execEvent( __buttonViewCascaded_clicked__    ) }, .f. } )
   qTBar:addItem( { "view_tiled"       , "View as Tiled"           , QIcon( __hbqtImage( "view_tiled"        ) ), {|| ::execEvent( __buttonViewTiled_clicked__       ) }, .f. } )
   qTBar:addItem( { "fullscreen"       , "View Maximized"          , QIcon( __hbqtImage( "fullscreen"        ) ), {|| ::execEvent( __buttonViewMaximized_clicked__   ) }, .f. } )
   qTBar:addItem( { "view_vertstacked" , "View Vertically Tiled"   , QIcon( __hbqtImage( "view_vertstacked"  ) ), {|| ::execEvent( __buttonViewStackedVert_clicked__ ) }, .f. } )
   qTBar:addItem( { "view_horzstacked" , "View Horizontally Tiled" , QIcon( __hbqtImage( "view_horzstacked"  ) ), {|| ::execEvent( __buttonViewStackedHorz_clicked__ ) }, .f. } )
   qTBar:addItem( { "view_zoomin"      , "View Zoom In"            , QIcon( __hbqtImage( "view_zoomin"       ) ), {|| ::execEvent( __buttonViewZoomedIn_clicked__    ) }, .f. } )
   qTBar:addItem( { "view_zoomout"     , "View Zoom Out"           , QIcon( __hbqtImage( "view_zoomout"      ) ), {|| ::execEvent( __buttonViewZoomedOut_clicked__   ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "database_add"     , "Append Record"           , QIcon( __hbqtImage( "database_add"      ) ), {|| ::execEvent( __buttonAppendRecord_clicked__    ) }, .f. } )
   qTBar:addItem( { "database_remove"  , "Delete Record"           , QIcon( __hbqtImage( "database_remove"   ) ), {|| ::execEvent( __buttonDelRecord_clicked__       ) }, .f. } )
   qTBar:addItem( { "database_lock"    , "Lock/Unlock Record"      , QIcon( __hbqtImage( "database_lock"     ) ), {|| ::execEvent( __buttonLockRecord_clicked__      ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "database_up"      , "Goto Top"                , QIcon( __hbqtImage( "database_up"       ) ), {|| ::execEvent( __buttonGoTop_clicked__           ) }, .f. } )
   qTBar:addItem( { "database_down"    , "Goto Bottom"             , QIcon( __hbqtImage( "database_down"     ) ), {|| ::execEvent( __buttonGoBottom_clicked__        ) }, .f. } )
   qTBar:addItem( { "database_previous", "Scroll to First Column"  , QIcon( __hbqtImage( "database_previous" ) ), {|| ::execEvent( __buttonScrollToFirst_clicked__   ) }, .f. } )
   qTBar:addItem( { "database_next"    , "Scroll to Last Column"   , QIcon( __hbqtImage( "database_next"     ) ), {|| ::execEvent( __buttonScrollToLast_clicked__    ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "database_search"  , "Search in Table"         , QIcon( __hbqtImage( "database_search"   ) ), {|| ::execEvent( __buttonSearchInTable_clicked__   ) }, .f. } )
   qTBar:addItem( , , , , , HBQTTOOLBAR_BUTTON_SEPARATOR )
   qTBar:addItem( { "database_process" , "Zap Table"               , QIcon( __hbqtImage( "database_process"  ) ), {|| ::execEvent( __buttonZaptable_clicked__        ) }, .f. } )

   RETURN NIL


METHOD HbQtDBU:buildPanelsButton()

   ::qPanelsMenu := QMenu()

   WITH OBJECT ::qPanelsButton := QToolButton()
      :setTooltip( "HbQtDBU Panels" )
      :setIcon( QIcon( __hbqtImage( "panel_8" ) ) )
      :setPopupMode( QToolButton_MenuButtonPopup )
      :setMenu( ::qPanelsMenu )
      :connect( "clicked()", {|| ::execEvent( __qPanelsButton_clicked__ ) } )
   ENDWITH

   ::qToolbar:addItem( ::qPanelsButton )

   RETURN Self


METHOD HbQtDBU:fetchRddInfo( cDriver )
   LOCAL oDlg, oLay, oCheck1, oCheck2, oCheck3, oBtnOK, oLayH

   IF ! hb_HHasKey( ::hRddInfo, cDriver )
      IF ! Empty( cDriver ) .AND. ! ( cDriver $ "DBFCDX,CACHERDD,ADS" )
         oDlg := QDialog( ::oWidget )
         oDlg:setWindowTitle( cDriver + " : Info" )
         oLay := QVBoxLayout()
         oDlg:setLayout( oLay )

         oCheck1 := QCheckBox()
         oCheck1:setText( "Using Structured Indexes ?" )
         oCheck2 := QCheckBox()
         oCheck2:setText( "Using Multitagged Indexes ?" )
         oCheck3 := QCheckBox()
         oCheck3:setText( "Using FPT Memoes ?" )

         oLay:addWidget( oCheck1 )
         oLay:addWidget( oCheck2 )
         oLay:addWidget( oCheck3 )
         oLayH  := QHBoxLayout()
         oLay:addLayout( oLayH )
         oBtnOK := QPushButton()
         oBtnOK:setText( "OK" )
         oLayH:addStretch()
         oLayH:addWidget( oBtnOK )
         oBtnOK:connect( "clicked()", {|| oDlg:done( 1 ) } )
         IF oDlg:exec() > 0
            ::hRddInfo[ cDriver ] := { oCheck1:isChecked(), oCheck2:isChecked(), oCheck3:isChecked() }
            IF oCheck1:isChecked()
               RddInfo( RDDI_STRUCTORD, .T., cDriver )
            ENDIF
            IF oCheck2:isChecked()
               RddInfo( RDDI_MULTITAG , .T., cDriver )
            ENDIF
            IF oCheck3:isChecked()
               RddInfo( RDDI_MEMOTYPE , DB_MEMO_FPT, cDriver )
            ENDIF
         ENDIF
         oDlg:setParent( QWidget() )
      ENDIF
   ENDIF

   RETURN Self

METHOD HbQtDBU:buildRddsCombo()

   WITH OBJECT ::qRddCombo := QComboBox()
      :setToolTip( "Rdd to open next table" )
   ENDWITH
   ::qToolBar:addItem( ::qRddCombo )
   //
   ::loadRddsCombo( ::qRddCombo )
   ::qRddCombo:setCurrentIndex( 0 )
   ::qRddCombo:connect( "currentIndexChanged(QString)", {|p| ::fetchRddInfo( p ), ::loadConxnCombo( p, ::qConxnCombo ) } )

   RETURN Self

METHOD HbQtDBU:loadRddsCombo( oRddCombo )
   LOCAL aRdds := {}, r_, cRdd

   IF HB_ISBLOCK( ::rddsBlock ) .AND. HB_ISARRAY( r_:= Eval( ::rddsBlock, NIL, NIL, Self ) )
      aeval( ::aRdds, {|e| aadd( aRdds, e ) } )
      aeval( r_     , {|e| aadd( aRdds, e ) } )
   ELSE
      aRdds := ::aRdds
   ENDIF
   oRddCombo:clear()
   FOR EACH cRdd IN aRdds
      cRdd := alltrim( cRdd )
      oRddCombo:addItem( cRdd )
   NEXT
   RETURN Self


METHOD HbQtDBU:buildConxnCombo()

   ::qConxnCombo := QComboBox()
   ::qConxnCombo:setToolTip( "Connection to open next table" )
   ::qToolBar:addItem( ::qConxnCombo )

   RETURN Self

METHOD HbQtDBU:loadConxnCombo( cDriver, oConxnCombo )
   LOCAL aConxns, cConxn, a_

   IF HB_ISOBJECT( ::qConxnCombo )
      DEFAULT cDriver TO ::currentDriver()

      ::aConxns := {}
      IF HB_ISBLOCK( ::connectionsBlock ) .AND. HB_ISARRAY( aConxns := Eval( ::connectionsBlock, cDriver, NIL, Self ) )
         aeval( aConxns, {|e| aadd( ::aConxns, e ) } )
      ENDIF
      oConxnCombo:clear()
      FOR EACH cConxn IN ::aConxns
         a_:= hb_aTokens( cConxn, ";" )
         oConxnCombo:addItem( alltrim( a_[ 1 ] ) )
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtDBU:buildTablesButton()

   ::qTablesMenu := QMenu()

   ::qTablesButton := QToolButton()
   ::qTablesButton:setTooltip( "Tables" )
   ::qTablesButton:setIcon( QIcon( __hbqtImage( "table" ) ) )
   ::qTablesButton:setPopupMode( QToolButton_MenuButtonPopup )
   ::qTablesButton:setMenu( ::qTablesMenu )

   ::qTablesButton:connect( "clicked()", {|| ::execEvent( __buttonTables_clicked__ ) } )

   ::qToolbar:addItem( ::qTablesButton )

   RETURN Self


METHOD HbQtDBU:buildIndexButton()

   ::qIndexMenu := QMenu()

   ::qIndexButton := QToolButton()
   ::qIndexButton:setTooltip( "Indexes" )
   ::qIndexButton:setIcon( QIcon( __hbqtImage( "sort" ) ) )
   ::qIndexButton:setPopupMode( QToolButton_MenuButtonPopup )
   ::qIndexButton:setMenu( ::qIndexMenu )

   ::qIndexButton:connect( "clicked()", {|| ::execEvent( __buttonIndex_clicked__ ) } )

   ::qToolbar:addItem( ::qIndexButton )

   RETURN Self


STATIC FUNCTION hbide_getMenuBlock( oPanel, oBrw, cIndex )
   RETURN {|| oPanel:setIndex( oBrw, cIndex ) }


METHOD HbQtDBU:updateIndexMenu( oBrw )
   LOCAL qAct, aIndex, cIndex

   FOR EACH qAct IN ::aIndexAct
      qAct:disconnect( "triggered(bool)" )
      qAct := NIL
   NEXT
   ::aIndexAct := {}

   ::qIndexMenu:clear()

   aIndex := ::oCurPanel:getIndexInfo( oBrw )
   FOR EACH cIndex IN aIndex
      qAct := ::qIndexMenu:addAction( cIndex )
      qAct:connect( "triggered(bool)", hbide_getMenuBlock( ::oCurPanel, oBrw, cIndex ) )
      aadd( ::aIndexAct, qAct )
   NEXT

   RETURN Self


/*----------------------------------------------------------------------*/
//             Methods TO ACCESS HbQtMdiBrowse methods
/*----------------------------------------------------------------------*/

METHOD HbQtDBU:driver( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:driver()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:connection( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:connection()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:goTop( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:goTop()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:goBottom( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:goBottom()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:goTo( cAlias, nRec )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:goto( nRec )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:gotoRecord( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:gotoRecord()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:goToAsk( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:goToAsk()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:lock( cAlias, nRec )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:lock( nRec )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:unlock( cAlias, nRec )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:unLock( nRec )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:append( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:append()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:delete( cAlias, lAsk )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:delete( lAsk )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:recall( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:recall()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:recNo( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:RecNo()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:lastRec( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:LastRec()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:ordKeyCount( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:ordKeyCount()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:dbStruct( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:dbStruct()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:ordKeyNo( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:ordKeyNo()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:ordKeyGoto( cAlias, nRec )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:ordKeyGoto( nRec )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:indexOrd( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:IndexOrd()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:ordName( cAlias, nOrder )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:ordName( nOrder )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:indexKey( cAlias, nOrder )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:indexKey( nOrder )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:indexKeyValue( cAlias, nOrder )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:indexKeyValue( nOrder )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:indexKeyType( cAlias, nOrder )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:indexKeyType( nOrder )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:refreshAll( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:refreshAll()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:setIndexInfo( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:setIndexInfo()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:getIndexInfo( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:getIndexInfo()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:setIndex( cAlias, cIndex )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:setIndex( cIndex )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:setOrder( cAlias, nOrder )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:setOrder( nOrder )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:setScope( cAlias, cScopeTop, cScopeBottom )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:setScope( cScopeTop, cScopeBottom )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:clearScope( cAlias, nScope )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias, nScope )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:clearScope()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:dbRLockList( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:dbRLockList()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:fieldBlock( cAlias, cFieldName )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:fieldBlock( cFieldName )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:setFilter( cAlias, cFilter )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:setFilter( cFilter )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:clearFilter( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:clearFilter()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:dbFieldInfo( cAlias, nInfoType, nFieldPos, expNewSetting )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:dbFieldInfo( nInfoType, nFieldPos, expNewSetting )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:fCount( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:fCount()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:indexExt( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:indexExt()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:ordKey( cAlias, ncOrder, cOrdBagName )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:ordKey( ncOrder, cOrdBagName )
   ENDIF
   RETURN NIL


METHOD HbQtDBU:next( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:next()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:previous( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:previous()
   ENDIF
   RETURN NIL

METHOD HbQtDBU:search( cAlias, cSearch, lSoft, lLast, nMode )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:search( cSearch, lSoft, lLast, nMode )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:searchAsk( cAlias, nMode )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:searchAsk( nMode )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:seekAsk( cAlias, nMode )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:seekAsk( nMode )
   ENDIF
   RETURN NIL

METHOD HbQtDBU:dispInfo( cAlias )
   LOCAL oMdiBrowse := ::getBrowserByAlias( cAlias )
   IF ! Empty( oMdiBrowse )
      RETURN oMdiBrowse:dispInfo()
   ENDIF
   RETURN NIL


METHOD HbQtDBU:saveEnvironment( cFile )
   LOCAL oSettings

   DEFAULT cFile TO ::getPath()

   WITH OBJECT oSettings := QSettings( cFile, QSettings_IniFormat )
      :setValue( "dbuSplitter"     , QVariant( ::splitter:saveState() ) )
      :setValue( "dbuTablesVisible", QVariant( ::tablesPanel:isVisible() ) )
      :setValue( "dbuStructVisible", QVariant( ::structPanel:isVisible() ) )
      :setValue( "dbuPanelNames"   , QVariant( __arrayToString( ::getPanelNames(), "~" ) ) )
      :setValue( "dbuPanelsInfo"   , QVariant( __arrayToString( ::getPanelsInfo(), "~" ) ) )
      :setValue( "dbuTreeInfo"     , QVariant( __arrayToString( ::getTreeInfo()  , "~" ) ) )
      :setValue( "dbuLinksInfo"    , QVariant( __arrayToString( ::getLinksInfo() , "~" ) ) )
      :setValue( "dbuDriver"       , QVariant( ::currentDriver() ) )
   ENDWITH

   RETURN oSettings


METHOD HbQtDBU:restEnvironment( cFile )
   LOCAL oSettings
   LOCAL lVal, cInfo

   DEFAULT cFile TO ::getPath()

   oSettings := QSettings( cFile, QSettings_IniFormat )

   IF oSettings:contains( "dbuTablesVisible" )
      lVal := oSettings:value( "dbuTablesVisible" ):toBool()
      IF lVal
         IF ! ::tablesPanel:isVisible()
            ::tablesPanel:show()
         ENDIF
      ELSE
         IF ::tablesPanel:isVisible()
            ::tablesPanel:hide()
         ENDIF
      ENDIF
   ENDIF
   IF oSettings:contains( "dbuStructVisible" )
      lVal := oSettings:value( "dbuStructVisible" ):toBool()
      IF lVal
         IF ! ::structPanel:isVisible()
            ::structPanel:show()
         ENDIF
      ELSE
         IF ::structPanel:isVisible()
            ::structPanel:hide()
         ENDIF
      ENDIF
   ENDIF
   IF oSettings:contains( "dbuSplitter" )
      ::splitter:restoreState( oSettings:value( "dbuSplitter" ):toByteArray() )
   ENDIF

   IF oSettings:contains( "dbuPanelNames" )
      ::addPanels( hb_ATokens( oSettings:value( "dbuPanelNames" ):toString(), "~" ) )
   ENDIF
   IF oSettings:contains( "dbuPanelsInfo" )
      ::loadTables( hb_ATokens( oSettings:value( "dbuPanelsInfo" ):toString(), "~" ) )
   ENDIF

   IF oSettings:contains( "dbuTreeInfo" )
      FOR EACH cInfo IN hb_ATokens( oSettings:value( "dbuTreeInfo" ):toString(), "~" )
         IF ! Empty( cInfo )
            ::populateTree( hb_ATokens( cInfo, " " ) )
         ENDIF
      NEXT
   ENDIF
   IF oSettings:contains( "dbuLinksInfo" )
     ::setLinksInfo( hb_ATokens( oSettings:value( "dbuLinksInfo" ):toString(), "~" ) )
   ENDIF
   IF oSettings:contains( "dbuDriver" )
      ::cDefaultRDD := Upper( oSettings:value( "dbuDriver" ):toString() )
   ENDIF

   RETURN NIL


METHOD HbQtDBU:saveEnvAs()
   LOCAL cFile
   cFile := hbdbu_saveAFile( ::oWidget, "Select HbDBU Env File", "HbDBU Env File (*.dbu)", ::cSettingsPath )
   IF ! Empty( cFile ) .AND. ".dbu" $ Lower( cFile )
      ::getPath( cFile )
      ::saveEnvironment()
   ENDIF
   RETURN Self


METHOD HbQtDBU:restEnvFrom()
   LOCAL cFile

   cFile := hbdbu_fetchAFile( ::oWidget, "Select HbDBU Env File", "HbDBU Env File (*.dbu)", ::cSettingsPath )
   IF ! Empty( cFile ) .AND. ".dbu" $ Lower( cFile )
      ::getPath( cFile )
      // Close existing panels and browsers or should we merge ?
      // merging make sense as .dbu can be opened via "Open With" option of explorer.
      //
      ::restEnvironment()
   ENDIF
   RETURN Self


METHOD HbQtDBU:getPath( cFile )
   LOCAL cPath, cName, cExt

   DEFAULT cFile TO ( ::cSettingsPath + ::cSettingsFile )

   hb_FNameSplit( cFile, @cPath, @cName, @cExt )

   IF Lower( cExt ) == ".dbu"
      IF Empty( cPath )
#if defined( __PLATFORM__WINDOWS )
         cPath := hb_DirSepAdd( GetEnv( "APPDATA" ) ) + "dbu\"
#elif defined( __PLATFORM__UNIX )
         cPath := hb_DirSepAdd( GetEnv( "HOME" ) ) + ".dbu/"
#elif defined( __PLATFORM__OS2 )
         cPath := hb_DirSepAdd( GetEnv( "HOME" ) ) + ".dbu/"
#endif
         IF ! hb_dirExists( cPath )
            hb_DirCreate( cPath )
         ENDIF
      ELSEIF Left( cPath, 2 ) == ".."
         cPath := hb_CurDrive() + hb_osDriveSeparator() + hb_osPathSeparator() + CurDir() + hb_osPathSeparator() + cPath
      ENDIF

      ::cSettingsPath := cPath
      ::cSettingsFile := cName + cExt

   ELSE
      IF Empty( cPath )
         cPath := hb_CurDrive() + hb_osDriveSeparator() + hb_osPathSeparator() + CurDir() + hb_osPathSeparator()
      ELSEIF Left( cPath, 2 ) == ".."
         cPath := hb_CurDrive() + hb_osDriveSeparator() + hb_osPathSeparator() + CurDir() + hb_osPathSeparator() + cPath
      ENDIF

   ENDIF

   RETURN ( cPath + cName + cExt )


STATIC FUNCTION __arrayToString( aStrings, cDlm )
   LOCAL cStr := ""
   aeval( aStrings, {|e| cStr += e + cDlm } )
   RETURN cStr

/*----------------------------------------------------------------------*/
//                         Class HbQtPanelBrowse
/*----------------------------------------------------------------------*/

CLASS HbQtPanelBrowse

   FRIEND CLASS HbQtDBU
   FRIEND CLASS HbQtMdiBrowser

   METHOD setIndex( oBrw, cIndex )

PROTECTED:
   DATA   oManager

   DATA   oWidget
   DATA   qMenuWindows

   DATA   cPanel                                  INIT  ""
   DATA   nViewStyle                              INIT  0    /* 0=asWindows 1=tabbed */
   DATA   lLayoutLocked                           INIT  .f.

   DATA   aBrowsers                               INIT  {}
   ACCESS subWindows()                            INLINE ::aBrowsers
   ACCESS name                                    INLINE ::oWidget:objectName()

   METHOD init( cPanel, oManager )
   METHOD destroy()
   METHOD destroyBrw( oBrw )
   METHOD execEvent( nEvent, p )
   METHOD setCurrentBrowser( oBrw )
   METHOD getIndexInfo( oBrw )

   METHOD addBrowser( aInfo )
   METHOD prepare()
   METHOD saveGeometry()
   METHOD restGeometry()
   METHOD activateBrowser()
   METHOD setViewStyle( nStyle )
   METHOD tileVertically()
   METHOD tileHorizontally()
   METHOD tilesZoom( nMode )

   ENDCLASS


METHOD HbQtPanelBrowse:init( cPanel, oManager )

   ::cPanel := cPanel
   ::oManager := oManager

   WITH OBJECT ::oWidget := QMdiArea()
      :setObjectName( ::cPanel )
      :setDocumentMode( .t. )
      :setOption( QMdiArea_DontMaximizeSubWindowOnActivation, .t. )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAsNeeded )
      :setDocumentMode( .t. )
      :setTabShape( QTabWidget_Triangular )
      :setViewMode( QMdiArea_TabbedView )
      :connect( "subWindowActivated(QMdiSubWindow*)", {|p| ::execEvent( __mdiArea_subWindowActivated__, p ) } )
   ENDWITH

   RETURN Self


METHOD HbQtPanelBrowse:destroy()
   LOCAL aBrw, oSub

   ::oWidget:disconnect( "subWindowActivated(QMdiSubWindow*)" )

   FOR EACH aBrw IN ::aBrowsers
      oSub := aBrw[ SUB_WINDOW ]
      ::oWidget:removeSubWindow( oSub )
      aBrw[ SUB_BROWSER ]:destroy()
      oSub := NIL
      aBrw := NIL
   NEXT
   ::aBrowsers    := NIL
   ::qMenuWindows := NIL
   ::qStruct      := NIL
   ::oWidget      := NIL

   RETURN Self


METHOD HbQtPanelBrowse:setViewStyle( nStyle )
   LOCAL qObj, a_
   LOCAL nOldStyle := ::nViewStyle

   IF HB_ISNUMERIC( nStyle )
      IF nStyle != ::nViewStyle
         IF ::nViewStyle == HBQTMDI_STYLE_ORGANIZED
            ::saveGeometry()
         ENDIF

         IF ::nViewStyle == HBQTMDI_STYLE_MAXIMIZED
            qObj := ::oWidget:activeSubWindow()
            FOR EACH a_ IN ::aBrowsers
               a_[ 2 ]:setWindowState( Qt_WindowNoState )
            NEXT
            IF ! Empty( qObj )
               ::oWidget:setActiveSubWindow( qObj )
            ENDIF
         ENDIF

         SWITCH nStyle
         CASE HBQTMDI_STYLE_ORGANIZED
            ::restGeometry()
            EXIT
         CASE HBQTMDI_STYLE_CASCADED
            ::oWidget:cascadeSubWindows()
            EXIT
         CASE HBQTMDI_STYLE_TILED
            ::oWidget:tileSubWindows()
            EXIT
         CASE HBQTMDI_STYLE_MAXIMIZED
            qObj := ::oWidget:activeSubWindow()
            FOR EACH a_ IN ::aBrowsers
               a_[ 2 ]:setWindowState( Qt_WindowMaximized )
            NEXT
            IF ! Empty( qObj )
               ::oWidget:setActiveSubWindow( qObj )
            ENDIF
            EXIT
         CASE HBQTMDI_STYLE_TILEDVERT
            ::tileVertically()
            EXIT
         CASE HBQTMDI_STYLE_TILEDHORZ
            ::tileHorizontally()
            EXIT
         ENDSWITCH

         ::nViewStyle := nStyle
         ::prepare()
      ENDIF
   ENDIF
   RETURN nOldStyle


METHOD HbQtPanelBrowse:tileVertically()
   LOCAL qObj, qVPort, nH, nT, nW, a_

   IF Len( ::aBrowsers ) > 0
      qObj   := ::oWidget:activeSubWindow()
      qVPort := ::oWidget:viewport()
      nH     := qVPort:height() / Len( ::aBrowsers )
      nW     := qVPort:width()
      nT     := 0
      FOR EACH a_ IN ::aBrowsers
         a_[ 2 ]:setGeometry( QRect( 0, nT, nW, nH ) )
         nT += nH
      NEXT
      IF ! Empty( qObj )
         ::oWidget:setActiveSubWindow( qObj )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:tileHorizontally()
   LOCAL qObj, qVPort, nH, nT, nW, nL, a_

   IF Len( ::aBrowsers ) > 0
      qObj   := ::oWidget:activeSubWindow()
      qVPort := ::oWidget:viewport()
      nH     := qVPort:height()
      nW     := qVPort:width() / Len( ::aBrowsers )
      nT     := 0
      nL     := 0
      FOR EACH a_ IN ::aBrowsers
         a_[ 2 ]:setGeometry( QRect( nL, nT, nW, nH ) )
         nL += nW
      NEXT
      IF ! Empty( qObj )
         ::oWidget:setActiveSubWindow( qObj )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:tilesZoom( nMode )
   LOCAL qMdi, nT, nL, nH, nW, qRect, a_

   IF Len( ::aBrowsers ) > 0
      IF ::nViewStyle == HBQTMDI_STYLE_TILEDVERT .OR. ::nViewStyle == HBQTMDI_STYLE_TILEDHORZ
         IF ::nViewStyle == HBQTMDI_STYLE_TILEDVERT
            nT := 0
            FOR EACH a_ IN ::aBrowsers
               qMdi  := a_[ 2 ]
               qRect := qMdi:geometry()
               nH    := qRect:height() + ( nMode * ( qRect:height() / 4 ) )
               qMdi:setGeometry( QRect( 0, nT, qRect:width(), nH ) )
               nT    += nH
            NEXT
         ELSE
            nL := 0
            FOR EACH a_ IN ::aBrowsers
               qMdi  := a_[ 2 ]
               qRect := qMdi:geometry()
               nW    := qRect:width() + ( nMode * ( qRect:width() / 4 ) )
               qMdi:setGeometry( QRect( nL, 0, nW, qRect:height() ) )
               nL    += nW
            NEXT
         ENDIF

         ::prepare()
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:saveGeometry()
   LOCAL a_
   IF ::nViewStyle == HBQTMDI_STYLE_ORGANIZED
      FOR EACH a_ IN ::aBrowsers
         a_[ SUB_GEOMETRY ] := a_[ SUB_WINDOW ]:geometry()
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:restGeometry()
   LOCAL a_
   FOR EACH a_ IN ::aBrowsers
      IF HB_ISOBJECT( a_[ SUB_GEOMETRY ] )
         a_[ SUB_WINDOW ]:setGeometry( a_[ SUB_GEOMETRY ] )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtPanelBrowse:destroyBrw( oBrw )
   LOCAL n, oSub

   IF ( n := ascan( ::aBrowsers, {|e_| e_[ SUB_BROWSER ] == oBrw } ) )  > 0
      ::oManager:aBrwStruct := {}
      ::oManager:oBrwStruct:goTop()
      oSub := ::aBrowsers[ n, SUB_WINDOW ]
      ::oWidget:removeSubWindow( oSub )
      hb_ADel( ::aBrowsers, n, .t. )
      oSub:setParent( QWidget() )
      oBrw:destroy()
   ENDIF

   RETURN Self


METHOD HbQtPanelBrowse:execEvent( nEvent, p )
   LOCAL n, oBrw

   SWITCH nEvent
   CASE __mdiArea_subWindowActivated__
      IF ! empty( ::aBrowsers )
         IF ( n := ascan( ::aBrowsers, {|e_| hbqt_IsEqual( e_[ SUB_WINDOW ], p ) } ) )  > 0
            oBrw := ::aBrowsers[ n, SUB_BROWSER ]
            IF Select( oBrw:Alias() ) > 0
               oBrw:configure()
               oBrw:oBrw:refreshAll()
               oBrw:oBrw:setFocus()

               ::oManager:updateIndexMenu( oBrw )
               ::oManager:updateBrwStruct( oBrw )
            ENDIF
         ENDIF
      ENDIF
      EXIT
   ENDSWITCH

   RETURN Self


METHOD HbQtPanelBrowse:setIndex( oBrw, cIndex )
   IF ascan( ::aBrowsers, {|e_| e_[ SUB_BROWSER ] == oBrw } ) > 0
      RETURN oBrw:setIndex( cIndex )
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:getIndexInfo( oBrw )
   IF ascan( ::aBrowsers, {|e_| e_[ SUB_BROWSER ] == oBrw } )  > 0
      RETURN oBrw:getIndexInfo()
   ENDIF
   RETURN {}


METHOD HbQtPanelBrowse:setCurrentBrowser( oBrw )
   IF ascan( ::aBrowsers, {|e_| e_[ SUB_BROWSER ] == oBrw } )  > 0
      ::oManager:oCurBrw := oBrw
   ENDIF
   RETURN Self


METHOD HbQtPanelBrowse:prepare()
   LOCAL aSub
   FOR EACH aSub IN ::aBrowsers
      aSub[ SUB_BROWSER ]:configure()
   NEXT
   RETURN Self


METHOD HbQtPanelBrowse:addBrowser( aInfo )
   LOCAL oMdiBrw
   oMdiBrw := HbQtMdiBrowser():new( ::oManager, Self, aInfo ):create()
   IF empty( oMdiBrw:oBrw )
      RETURN Self
   ENDIF
   aadd( ::aBrowsers, { oMdiBrw:nID, oMdiBrw:qMdi, oMdiBrw:qMdi:geometry(), oMdiBrw, NIL } )
   ::oManager:updateIndexMenu( oMdiBrw )
   ::oManager:updateBrwStruct( oMdiBrw )
   RETURN Self


METHOD HbQtPanelBrowse:activateBrowser()
   LOCAL aBrowse
   IF Len( ::aBrowsers ) > 0
      FOR EACH aBrowse IN ::aBrowsers
         ::oWidget:setActiveSubWindow( aBrowse[ SUB_WINDOW ] )
      NEXT
      ::oWidget:setActiveSubWindow( ::aBrowsers[ 1, SUB_WINDOW ] )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
//                            Class HbQtMdiBrowser
/*----------------------------------------------------------------------*/

CLASS HbQtMdiBrowser

   FRIEND CLASS HbQtDbu
   FRIEND CLASS HbQtPanelBrowse

   METHOD init( oManager, oPanel, aInfo )
   METHOD create( oManager, oPanel, aInfo )
   METHOD configure()
   METHOD destroy()

   ACCESS alias                                   INLINE ::cAlias
   ACCESS path                                    INLINE ::cPath
   ACCESS driver                                  INLINE ::cDriver
   ACCESS connection                              INLINE ::cConxn

   METHOD goTop()
   METHOD goBottom()
   METHOD goTo( nRec )
   METHOD gotoRecord()
   METHOD goToAsk()
   METHOD lock( nRec )
   METHOD unLock( nRec )
   METHOD append()
   METHOD delete( lAsk )
   METHOD recall()
   METHOD recNo()
   METHOD lastRec()
   METHOD ordKeyCount()
   METHOD ordKeyNo()
   METHOD ordKeyGoto( nRec )
   METHOD indexOrd()
   METHOD ordName( nOrder )
   METHOD indexKey( nOrder )
   METHOD indexKeyValue( nOrder )
   METHOD indexKeyType( nOrder )
   METHOD refreshAll()
   METHOD getIndexInfo()
   METHOD setIndexInfo()
   METHOD setIndex( cIndex )
   METHOD setOrder( nOrder )
   METHOD setScope( cScopeTop, cScopeBottom )
   METHOD clearScope( nScope )
   METHOD dbRLockList()
   METHOD fieldBlock( cFieldName )
   METHOD setFilter( cFilter )
   METHOD clearFilter()
   METHOD dbFieldInfo( nInfoType, nFieldPos, expNewSetting )
   METHOD fCount()
   METHOD indexExt()
   METHOD ordKey( ncOrder, cOrdBagName )
   METHOD addIndexFile( cIndexFile )

   METHOD search( cSearch, lSoft, lLast, nMode )
   METHOD searchAsk( nMode )
   METHOD seekAsk( nMode )
   METHOD next()
   METHOD previous()

   METHOD dispInfo()

   DATA   aIndex                                  INIT  {}
   ACCESS dbStruct                                INLINE ::aStruct

   METHOD selectAField()

PROTECTED:

   DATA   oWnd
   DATA   oBrw
   DATA   qLayout
   DATA   qTimer
   DATA   qScrollArea
   DATA   oTreeItem

   DATA   nID                                     INIT  0

   DATA   aForm                                   INIT  {}
   DATA   oManager
   DATA   oPanel
   DATA   qMDI
   DATA   aInfo                                   INIT  {}

   DATA   nType                                   INIT  BRW_TYPE_DBF
   DATA   cAlias                                  INIT  ""
   DATA   cTable                                  INIT  ""
   DATA   cTableOnly                              INIT  ""
   DATA   cPath                                   INIT  ""
   DATA   aData                                   INIT  {}
   DATA   aStruct                                 INIT  {}
   DATA   aAttr                                   INIT  {}
   DATA   nIndex                                  INIT  0
   DATA   cDriver                                 INIT  "DBFCDX"
   DATA   cConxn                                  INIT  ""
   DATA   cIndex                                  INIT  ""
   DATA   nOrder                                  INIT  0
   DATA   nArea                                   INIT  0
   DATA   nCursorType                             INIT  HBQTBRW_CURSOR_CELL
   DATA   lOpened                                 INIT  .f.

   DATA   qVerSpl
   DATA   qClose

   DATA   xSearch
   DATA   lInSearch                               INIT  .f.

   DATA   aMenu                                   INIT  {}
   DATA   aIdx                                    INIT  {}
   DATA   aFlds                                   INIT  {}
   DATA   aSeek                                   INIT  {}
   DATA   aToFld                                  INIT  {}

   CLASSDATA  nIdentity                           INIT  0

   METHOD execEvent( nEvent, p, p1 )
   METHOD buildBrowser()
   METHOD buildColumns()
   METHOD buildMdiWindow()
   METHOD dataLink( nField )

   METHOD skipBlock( nHowMany )

   ACCESS numIndexes                              INLINE iif( Len( ::aIndex ) == 0, 0,  Len( ::aIndex ) - 1 )

   METHOD use()
   METHOD exists()
   METHOD fetchAlias( cTable )
   METHOD saveField( nField, x )
   METHOD toColumn( ncIndex )
   METHOD buildContextMenu()

   METHOD execAddAColumn( nMode, xData )

   FRIEND FUNCTION __setOrderBlock

   DATA   hScope                                  INIT {=>}
   DATA   cFilter                                 INIT ""

   ENDCLASS


METHOD HbQtMdiBrowser:init( oManager, oPanel, aInfo )

   ::oManager := oManager
   ::oPanel   := oPanel
   ::aInfo    := aInfo

   RETURN Self


METHOD HbQtMdiBrowser:destroy()
   LOCAL nArea

   IF !empty( ::qTimer )
      ::qTimer:disconnect( "timeout()" )
   ENDIF
   ::qTimer := NIL

   nArea := Select()
   Select( ::cAlias )
   dbCloseArea()
   Select( nArea )

   ::oBrw:destroy()                               // Call HbQtBrowse()
   ::oBrw := NIL
   RETURN Self


METHOD HbQtMdiBrowser:create( oManager, oPanel, aInfo )
   LOCAL xVrb, cT, cName, cPath
   LOCAL lMissing := .t.

   DEFAULT oManager TO ::oManager
   DEFAULT oPanel   TO ::oPanel
   DEFAULT aInfo    TO ::aInfo

   ::oManager := oManager
   ::oPanel   := oPanel
   ::aInfo    := aInfo

   aSize( ::aInfo, TBL_VRBLS )

   DEFAULT ::aInfo[ TBL_PANEL    ] TO ::oPanel:cPanel
   DEFAULT ::aInfo[ TBL_NAME     ] TO ""
   DEFAULT ::aInfo[ TBL_ALIAS    ] TO ""
   DEFAULT ::aInfo[ TBL_DRIVER   ] TO ::oManager:currentDriver()
   DEFAULT ::aInfo[ TBL_INDEX    ] TO ""
   DEFAULT ::aInfo[ TBL_RECORD   ] TO ""
   DEFAULT ::aInfo[ TBL_CURSOR   ] TO ""
   DEFAULT ::aInfo[ TBL_GEOMETRY ] TO ""
   DEFAULT ::aInfo[ TBL_ROWPOS   ] TO "1"
   DEFAULT ::aInfo[ TBL_COLPOS   ] TO "1"
   DEFAULT ::aInfo[ TBL_HZSCROLL ] TO ""
   DEFAULT ::aInfo[ TBL_CONXN    ] TO ::oManager:currentConxn()
   DEFAULT ::aInfo[ TBL_NEXT     ] TO ""

   ::cTable := hbide_pathToOSPath( ::aInfo[ TBL_NAME ] )
   hb_fNameSplit( ::cTable, @cPath, @cName )
   ::cPath      := cPath
   ::cTableOnly := cName
   ::cAlias     := ::aInfo[ TBL_ALIAS  ]
   ::cDriver    := ::aInfo[ TBL_DRIVER ]
   ::cConxn     := ::aInfo[ TBL_CONXN  ]

   IF ! ::exists()
      RETURN Self
   ENDIF

   ::cAlias := Upper( ::fetchAlias( cName ) )

   IF ::nType == BRW_TYPE_DBF
      IF !empty( ::cAlias ) .AND. empty( ::cTable )
         IF select( ::cAlias ) > 0
            lMissing := .f.
         ENDIF
      ENDIF

      IF lMissing .AND. !empty( ::cTable )
         IF ! ( ::lOpened := ::use() )
            RETURN Self
         ENDIF
      ENDIF

      ::aStruct := ( ::cAlias )->( DbStruct() )
   ELSE
      FOR EACH xVrb IN ::aData[ 1 ]
         cT := valtype( xVrb )
         aadd( ::aStruct, "Fld_" + hb_ntos( xVrb:__enumIndex() ) )
         aadd( ::aStruct, cT )
         IF cT == "N"
            aadd( ::aStruct, 12 )
            aadd( ::aStruct,  2 )
         ELSEIF cT == "D"
            aadd( ::aStruct,  8 )
            aadd( ::aStruct,  0 )
         ELSEIF cT == "L"
            aadd( ::aStruct,  1 )
            aadd( ::aStruct,  0 )
         ELSE
            aadd( ::aStruct, Len( xVrb ) )
            aadd( ::aStruct,  0 )
         ENDIF
      NEXT
   ENDIF

   ::buildBrowser()
   ::buildColumns()
   ::buildMdiWindow()

   ::oManager:oCurBrw := Self

   ::oBrw:configure()
   ::oBrw:forceStable()
   ::oBrw:rowPos := max( 1, val( aInfo[ TBL_ROWPOS ] ) )
   ::oBrw:colPos := max( 1, val( aInfo[ TBL_COLPOS ] ) )
   ::oBrw:forceStable()
   ::setOrder( val( aInfo[ TBL_INDEX ] ) )
   ::goto( max( 1, val( aInfo[ TBL_RECORD ] ) ) )
   ::oBrw:refreshAll()

   ::qTimer := QTimer()
   ::qTimer:setInterval( 5 )
   ::qTimer:connect( "timeout()",  {|| ::execEvent( __timer_timeout__ ) } )

   ::setIndexInfo()

   ::oBrw:addColumnsBlock := {|nMode, xData|  ::execAddAColumn( nMode, xData ) }

   ::oBrw:oWidget:connect( QEvent_WindowActivate, {|| ::oBrw:refreshWindow() } )

   RETURN Self


METHOD HbQtMdiBrowser:execAddAColumn( nMode, xData )
   LOCAL aNames, n

   IF nMode == 0
      aNames := {}
      AEval( ::aStruct, {|e_| AAdd( aNames, e_[ 1 ] ) } )
      RETURN aNames

   ELSEIF nMode == 1
      IF HB_ISSTRING( xData )
         IF ( n := AScan( ::aStruct, {|e_| e_[ 1 ] == xData } ) ) > 0
            ::oBrw:insColumn( ::oBrw:colPos, HbQtColumnNew( ::aStruct[ n,1 ], ::dataLink( n ) ) )
            ::refreshAll()
         ENDIF
      ENDIF

   ENDIF

   RETURN NIL


STATIC FUNCTION __setOrderBlock( oMdiBrowse, cIndex )
   RETURN {|n| n := iif( cIndex == "Natural Order", 0, AScan( oMdiBrowse:aIndex, {|e| e == cIndex } ) ), oMdiBrowse:setOrder( n ), oMdiBrowse:dispInfo() }


METHOD HbQtMdiBrowser:buildBrowser()

   ::oWnd := QWidget()

   WITH OBJECT ::oBrw := HbQtBrowseNew( 0, 0, 10, 10, ::oWnd, QFont( "Courier new", 10 ) )
      :cursorMode            := ::nCursorType

      :skipBlock             := {|n| ::skipBlock( n )  }
      :goTopBlock            := {| | ::goTop()         }
      :goBottomBlock         := {| | ::goBottom()      }
      :gotoBlock             := {| | ::gotoRecord()    }

      :firstPosBlock         := {| | 1                 }
      :lastPosBlock          := {| | iif( ::indexOrd() == 0, ::lastRec(), ::ordKeyCount()   ) }
      :posBlock              := {| | iif( ::indexOrd() == 0, ::recNo()  , ::ordKeyNo()      ) }
      :goPosBlock            := {|n| iif( ::indexOrd() == 0, ::goto( n ), ::ordKeyGoto( n ) ) }
      :phyPosBlock           := {| | iif( ::indexOrd() == 0, ::recNo()  , ::ordKeyNo()      ) }

      :verticalMovementBlock := {|| ::dispInfo(),::oManager:updateLinks( ::cAlias ) }

//    :hbContextMenu         := {|mp1| ::execEvent( __browser_contextMenu__, mp1 ) }
      :oWidget:connect( QEvent_FocusIn, {|| ::oManager:oCurBrw := Self  } )
   ENDWITH

   WITH OBJECT ::qLayout := QHBoxLayout( ::oWnd )
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
      :addWidget( ::oBrw:oWidget )
   ENDWITH

   ::oWnd:setLayout( ::qLayout )

   ::oManager:configureBrowse( Self )

   RETURN Self


METHOD HbQtMdiBrowser:buildColumns()
   LOCAL a_, b_, cName, n

   IF ::nType == BRW_TYPE_DBF
      IF ! Empty( ::aInfo[ TBL_COLUMNS ] )
         b_:= hb_ATokens( ::aInfo[ TBL_COLUMNS ], " " )
      ENDIF
      IF Empty( b_ )
         b_:={}
         AEval( ::aStruct, {|e_| AAdd( b_, e_[ 1 ] ) } )
      ENDIF
      FOR EACH cName IN b_
         IF ( n := AScan( ::aStruct, {|e_| e_[ 1 ] == cName } ) ) > 0
            ::oBrw:addColumn( HbQtColumnNew( ::aStruct[ n, 1 ], ::dataLink( n ) ) )
         ENDIF
      NEXT
   ELSE
      FOR EACH a_ IN ::aStruct
         ::oBrw:addColumn( HbQtColumnNew( ::aStruct[ a_:__enumIndex(), 1 ], ::dataLink( a_:__enumIndex() ) ) )
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:dataLink( nField )
   LOCAL bBlock

   IF ::nType == BRW_TYPE_DBF
      bBlock := {|x| iif( x == NIL, ( ::cAlias )->( fieldget( nField ) ), ::saveField( nField, x ) ) }
   ELSE
      bBlock := {|| ::aData[ ::nIndex, nField ] }
   ENDIF

   RETURN bBlock


METHOD HbQtMdiBrowser:buildMdiWindow()
   LOCAL qRect, cR

   STATIC nID := 0

   ::nID := ++nID

   ::qMdi := QMdiSubWindow()
   //
   ::qMdi:setWidget( ::oWnd )
   ::oPanel:oWidget:addSubWindow( ::qMdi )

   ::oWnd:show()
   ::qMdi:show()

   ::qMdi:setWindowTitle( ::cTable )
   ::qMdi:setObjectName( ::cAlias )
   ::qMdi:setWindowIcon( QIcon( __hbqtImage( "dbf_p" + hb_ntos( ::nID ) ) ) )

   IF ! empty( ::aInfo[ TBL_GEOMETRY ] )
      qRect := hb_aTokens( ::aInfo[ TBL_GEOMETRY ], " " )
      FOR EACH cR IN qRect
         cR := val( cR )
      NEXT
      qRect := QRect( qRect[ 1 ], qRect[ 2 ], qRect[ 3 ], qRect[ 4 ] )
      ::qMdi:setGeometry( qRect )
   ELSE
      ::qMdi:resize( 610, 400 )
      IF ! Empty( ::oManager:aLastClosePos )
         ::qMdi:move( ::oManager:aLastClosePos[ 1 ], ::oManager:aLastClosePos[ 2 ] )
      ENDIF
   ENDIF
   ::dispInfo()

// ::qMdi:connect( "aboutToActivate()", {|| ::oManager:oCurBrw := Self } ) ///*::execEvent( "mdiSubWindow_aboutToActivate"*/ ) } )
   ::qMdi:connect( "windowStateChanged(Qt::WindowStates,Qt::WindowStates)", ;
                                 {|p,p1| ::execEvent( __mdiSubWindow_windowStateChanged__, p, p1 ) } )
   ::qMdi:connect( QEvent_Close, {|oEvent| oEvent:accept(), ::execEvent( __mdiSubWindow_buttonXclicked__ ) } )

   ::qMdi:hide()
   ::qMdi:show()

   RETURN Self


METHOD HbQtMdiBrowser:configure()
   LOCAL nOff
   LOCAL nRowPos := ::oBrw:rowPos()
   LOCAL nColPos := ::oBrw:colPos()

   ::oBrw:configure()

   IF nRowPos > ::oBrw:rowCount()
      nOff := nRowPos - ::oBrw:rowCount()
      ::oBrw:rowPos := ::oBrw:rowCount()
   ELSE
      nOff := 0
   ENDIF
   ::oBrw:colPos := nColPos

   ::oBrw:refreshAll()
   IF nOff > 0
      ::oBrw:skipRows( nOff )
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:execEvent( nEvent, p, p1 )

   HB_SYMBOL_UNUSED( p  )
   HB_SYMBOL_UNUSED( p1 )

   SWITCH nEvent

   CASE __timer_timeout__
      ::oBrw:down()
      IF ::oBrw:hitBottom
         ::qTimer:stop()
         ::dispInfo()
      ELSEIF Left( eval( ::oBrw:getColumn( ::oBrw:colPos ):block ), Len( ::xSearch ) ) == ::xSearch
         ::qTimer:stop()
         ::dispInfo()
      ENDIF
      EXIT
   CASE __mdiSubWindow_buttonXclicked__
      HB_TRACE( HB_TR_DEBUG, "HbQtMdiBrowser:execEvent( nEvent, p, p1 )  __mdiSubWindow_buttonXclicked__" )
      ::oManager:aLastClosePos := { ::qMdi:pos():x(), ::qMdi:pos():y() }
      ::oPanel:destroyBrw( Self )
      RETURN .T.
#if 0
   CASE __browser_ScrollToColumn__
   CASE __mdiSubWindow_aboutToActivate__
      ::oBrw:configure()
      ::oBrw:refreshAll()
      EXIT
#endif
   CASE __mdiSubWindow_windowStateChanged__
      HB_TRACE( HB_TR_DEBUG, p, p1, ::qMdi:objectName() )
      IF p1 == 8
         ::oPanel:setCurrentBrowser( Self )
      ENDIF
      EXIT
#if 0
   CASE __browser_contextMenu__
      IF empty( ::aMenu )
         ::buildContextMenu()
      ENDIF
      hbide_execPopup( ::aMenu, p, ::qMdi )
      EXIT
#endif
   ENDSWITCH

   #if 0
   activateNextSubWindow()
   activatePreviousSubWindow()
   closeActiveSubWindow()
   closeAllSubWindows()
   setActiveSubWindow( QMdiSubWindow * )
   #endif

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtMdiBrowser:buildContextMenu()
   LOCAL a_, cPmt, nZeros, cIndex

   ::qMdi:setFocus( 0 )

   IF Len( ::aIndex ) > 0
      aadd( ::aMenu, { "Set to Natural Order", {|| ::setOrder( 0 ) } } )
      aadd( ::aMenu, { "" } )
   ENDIF

   /* Indexed Order */
   ::getIndexInfo()
   FOR EACH cIndex IN ::aIndex
      aadd( ::aIdx,  hbide_indexArray( Self, cIndex, cIndex:__enumIndex() ) )
   NEXT
   IF ! empty( ::aIdx )
      aadd( ::aMenu, { ::aIdx, "Set to Indexed Order" } )
      aadd( ::aMenu, { "" } )
   ENDIF

   /* Column Scrolling */
   nZeros := iif( Len( ::aStruct ) < 10, 1, iif( len( ::aStruct ) < 100, 2, 3 ) )
   FOR EACH a_ IN ::aStruct
      cPmt := strzero( a_:__enumIndex(), nZeros ) + " " + a_[ 2 ] + " . " + a_[ 1 ]
      aadd( ::aFlds, hbide_fieldsArray( Self, cPmt, a_:__enumIndex() ) )
   NEXT
   aadd( ::aMenu, { ::aFlds, "Scroll to Column" } )
   aadd( ::aMenu, { "Scroll to ..."  , {|v| v := QInputDialog():getText( ::qMdi, "Field Name", "" ), ::toColumn( v ) } } )
   aadd( ::aMenu, { "" } )

   /* Seeks */
   aadd( ::aSeek, { "Seek"           , {|| ::seekAsk( 0 )   } } )
   aadd( ::aSeek, { "Seek Soft"      , {|| ::seekAsk( 1 )   } } )
   aadd( ::aSeek, { "Seek Last"      , {|| ::seekAsk( 2 )   } } )
   aadd( ::aMenu, { ::aSeek          , "Seek..." } )
   aadd( ::aMenu, { "Search in Field", {|| ::searchAsk( 1 ) } } )
   aadd( ::aMenu, { "" } )

   /* Navigation */
   aadd( ::aMenu, { "Go Top"         , {|| ::goTop()        } } )
   aadd( ::aMenu, { "Go Bottom"      , {|| ::goBottom()     } } )
   aadd( ::aMenu, { "Goto Record"    , {|| ::gotoAsk()      } } )
   aadd( ::aMenu, { "" } )

   /* Manipulation */
   aadd( ::aMenu, { "Append Blank"   , {|| ::append()       } } )
   aadd( ::aMenu, { "Delete Record"  , {|| ::delete( .t. )  } } )
   aadd( ::aMenu, { "Recall Deleted" , {|| ::recall()       } } )
   aadd( ::aMenu, { "" } )

   /* Miscellaneous */
   aadd( ::aMenu, { "Form View"      , {|| ::oManager:execEvent( __buttonShowForm_clicked__  ) } } )


   RETURN Self


STATIC FUNCTION hbide_fieldsArray( obj, cPmt, nIndex )
   RETURN { cPmt, {|| obj:toColumn( nIndex ) } }


STATIC FUNCTION hbide_indexArray( obj, cIndex, nOrder )
   RETURN { cIndex, {|| obj:setOrder( nOrder ) } }


METHOD HbQtMdiBrowser:dispInfo()
   LOCAL cTitle

   IF !empty( ::qMdi )
      cTitle := "[" + ::cAlias + "  " + ::cDriver + iif( Empty( ::cConxn ), "", "  " + ::cConxn ) + "][" + ;
                hb_ntos( ::indexOrd() ) + "/" + hb_ntos( ::numIndexes() ) + iif( ::indexOrd() > 0, ":" + ::ordName(), "" ) + ;
                "  " + hb_ntos( ::recNo() ) + "/" + hb_ntos( ::lastRec() ) + "] " + ;
                ::cTableOnly
      ::qMdi:setWindowTitle( cTitle )
      ::qMdi:setTooltip( ::cAlias + "  " + ::cDriver + iif( Empty( ::cConxn ), "", "  " + ::cConxn ) + "  " + ::cTable )
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:fetchAlias( cTable )
   RETURN __hbqtGetNextIdAsString( cTable )


METHOD HbQtMdiBrowser:saveField( nField, x )
   IF ( ::cAlias )->( DbrLock() )
      ( ::cAlias )->( FieldPut( nField, x ) )
      ( ::cAlias )->( DbCommit() )
      ( ::cAlias )->( DbrUnlock() )
      ::oBrw:refreshCurrent()
   ENDIF
   RETURN x


METHOD HbQtMdiBrowser:skipBlock( nHowMany )
   LOCAL nRecs, nCurPos
   LOCAL nSkipped := 0

   IF ::nType == BRW_TYPE_DBF
      IF nHowMany == 0
         ( ::cAlias )->( DBSkip( 0 ) )

      ELSEIF nHowMany > 0
         DO WHILE nSkipped != nHowMany .AND. ::next()
            nSkipped++
         ENDDO
      ELSE
         DO WHILE nSkipped != nHowMany .AND. ::previous()
            nSkipped--
         ENDDO
      ENDIF

   ELSE
      nRecs    := Len( ::aData )
      nCurPos  := ::nIndex

      IF nHowMany >= 0
         IF ( nCurpos + nHowMany ) > nRecs
            nSkipped := nRecs - nCurpos
            ::nIndex := nRecs
         ELSE
            nSkipped := nHowMany
            ::nIndex += nHowMany
         ENDIF

      ELSE
         IF ( nCurpos + nHowMany ) < 1
            nSkipped := 1 - nCurpos
            ::nIndex := 1
         ELSE
            nSkipped := nHowMany
            ::nIndex += nHowMany
         ENDIF

      ENDIF

   ENDIF

   RETURN nSkipped


METHOD HbQtMdiBrowser:next()
   LOCAL nSaveRecNum := ( ::cAlias )->( recno() )
   LOCAL lMoved := .T.

   IF ( ::cAlias )->( Eof() )
      lMoved := .F.
   ELSE
      ( ::cAlias )->( DbSkip( 1 ) )
      IF ( ::cAlias )->( Eof() )
         lMoved := .F.
         ( ::cAlias )->( DbGoTo( nSaveRecNum ) )
      ENDIF
   ENDIF

   RETURN lMoved


METHOD HbQtMdiBrowser:previous()
   LOCAL nSaveRecNum := ( ::cAlias )->( recno() )
   LOCAL lMoved := .T.

   ( ::cAlias )->( DbSkip( -1 ) )

   IF ( ::cAlias )->( Bof() )
      ( ::cAlias )->( DbGoTo( nSaveRecNum ) )
      lMoved := .F.
   ENDIF

   RETURN lMoved


METHOD HbQtMdiBrowser:seekAsk( nMode )
   LOCAL xValue

   IF ::indexOrd() == 0
      RETURN Self
   ENDIF
   IF ( xValue := HbQtBulkGet( ::indexKeyValue(), "IndexKey: " + ::indexKey() ) ) != NIL
      xValue := iif( ValType( xValue ) == "C", Trim( xValue ), xValue )
      ::search( xValue, nMode == 1, nMode == 2 )
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:searchAsk( nMode )
   LOCAL xValue, cFor

   DEFAULT nMode TO 0

   IF nMode == 0
      xValue := iif( ::indexOrd() > 0, ::indexKeyValue(), eval( ::oBrw:getColumn( ::oBrw:colPos ):block ) )
      cFor   := iif( ::indexOrd() > 0, "Indexed: " + ::indexKey(), ::aStruct[ ::oBrw:colPos, 1 ] )
   ELSEIF nMode == 1
      xValue := eval( ::oBrw:getColumn( ::oBrw:colPos ):block )
      cFor   := ::aStruct[ ::oBrw:colPos, 1 ]
   ENDIF

   IF ( xValue := HbQtBulkGet( xValue, cFor ) ) != NIL
      xValue := iif( ValType( xValue ) == "C", Trim( xValue ), xValue )
      ::search( xValue, .f., .f., nMode )
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:search( cSearch, lSoft, lLast, nMode )
   LOCAL nRec, lFound := .F.

   DEFAULT nMode TO 0

   IF ::lInSearch
      ::qTimer:stop()
      ::lInSearch := .f.
   ENDIF

   IF ::nType == BRW_TYPE_DBF
      IF nMode == 0
         IF ( ::cAlias )->( IndexOrd() ) > 0

            DEFAULT lLast TO .f.
            DEFAULT lSoft TO .f.

            nRec := ::recNo()
            IF ( ::cAlias )->( DbSeek( cSearch, lSoft, lLast ) )
               lFound := .T.
               ::refreshAll()
               ::dispInfo()
            ELSEIF ! lSoft
               ::goto( nRec )
            ENDIF
         ELSE
            ::xSearch   := cSearch
            ::lInSearch := .t.
            ::qTimer:start()
         ENDIF
      ELSE
         ::xSearch   := cSearch
         ::lInSearch := .t.
         ::qTimer:start()
      ENDIF
   ELSE
      // Ascan
   ENDIF

   RETURN lFound


METHOD HbQtMdiBrowser:refreshAll()

   ::oBrw:refreshAll()
   ::dispInfo()

   RETURN Self


METHOD HbQtMdiBrowser:toColumn( ncIndex )
   LOCAL nIndex

   IF valtype( ncIndex ) == "C"
      ncIndex := upper( ncIndex )
      nIndex := ascan( ::aStruct, {|e_| Left( e_[ 1 ], Len( ncIndex ) ) == ncIndex } )
   ELSE
      nIndex := ncIndex
   ENDIF

   IF empty( nIndex )
      RETURN Self
   ENDIF

   ::oBrw:colPos := nIndex
   ::oBrw:refreshAll()

   RETURN Self


METHOD HbQtMdiBrowser:setFilter( cFilter )
   LOCAL kf2

   IF ::nType == BRW_TYPE_DBF
      IF Empty( cFilter ) .OR. ! HB_ISSTRING( cFilter )
         cFilter := ::cFilter
      ENDIF

      kf2 := SetKey( K_F2, {|| ::selectAField() } )
      cFilter := trim( HbQtBulkGet( Pad( cFilter, 100 ), 'Filter Expression', "@S50", , , ::cAlias + " [F2-Field]" ) )
      SetKey( K_F2, kf2 )

      IF Empty( cFilter )
         RETURN NIL
      ENDIF
      ::cFilter := cFilter
      ( ::cAlias )->( dbSetFilter( &( "{|| " + cFilter + " }" ), '"' + cFilter + '"' ) )
      ::oBrw:rowPos := 1
      ::oBrw:goTop()
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:clearFilter()

   IF ::nType == BRW_TYPE_DBF
      ( ::cAlias )->( dbClearFilter() )
      ::oBrw:goTop()
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:dbFieldInfo( nInfoType, nFieldPos, expNewSetting )

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( dbFieldInfo( nInfoType, nFieldPos, expNewSetting ) )
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:ordKey( ncOrder, cOrdBagName )

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( ordKey( ncOrder, cOrdBagName ) )
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:fCount()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( fCount() )
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:indexExt()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( indexExt() )
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:fieldBlock( cFieldName )

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( FieldBlock( cFieldName ) )
   ELSE
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:dbrLockList()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( DbrLockList() )
   ELSE
   ENDIF

   RETURN {}


METHOD HbQtMdiBrowser:lock( nRec )

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( DbrLock( nRec ) )
   ELSE
   ENDIF

   RETURN .F.


METHOD HbQtMdiBrowser:unLock( nRec )

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( DbrUnLock( nRec ) )
   ELSE
   ENDIF

   RETURN .F.


METHOD HbQtMdiBrowser:gotoRecord()   /* On browser toolbar icon */
   LOCAL nPRec := ::recNo()
   LOCAL nRec

   IF ( nRec := HbQtBulkGet( nPRec, "Record Number", , , , "GoTo ?" ) ) > 0
      ::goto( nRec )
   ELSE
      RETURN .F.
   ENDIF

   RETURN nPRec != nRec


METHOD HbQtMdiBrowser:goToAsk()       /* On DBU toolbar icon */
   LOCAL nRec

   IF ( nRec := HbQtBulkGet( 0, "Record Number", , , , "GoTo ?" ) ) > 0
      ::goto( nRec )
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:ordKeyGoto( nRec )

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         ( ::cAlias )->( OrdKeyGoto( nRec ) )
         ::refreshAll()
      ENDIF
   ELSE
      IF nRec > 0 .AND. nRec <= Len( ::aData )
         ::nIndex := nRec
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:goto( nRec )

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         ( ::cAlias )->( DbGoto( nRec ) )
         ::refreshAll()
      ENDIF
   ELSE
      IF nRec > 0 .AND. nRec <= Len( ::aData )
         ::nIndex := nRec
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:goTop()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         ( ::cAlias )->( DbGotop() )
      ENDIF
   ELSE
      ::nIndex := 1
   ENDIF
   RETURN NIL


METHOD HbQtMdiBrowser:goBottom()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         ( ::cAlias )->( DbGoBottom() )
      ENDIF
   ELSE
      ::nIndex := Len( ::aData )
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:setOrder( nOrder )

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         ( ::cAlias )->( DbSetOrder( nOrder ) )
         ::refreshAll()
      ENDIF
   ENDIF

   RETURN NIL


METHOD HbQtMdiBrowser:indexOrd()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         RETURN ( ::cAlias )->( IndexOrd() )
      ENDIF
   ENDIF

   RETURN 0


METHOD HbQtMdiBrowser:ordKeyNo()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         RETURN ( ::cAlias )->( OrdKeyNo() )
      ENDIF
   ELSE
      RETURN ::nIndex
   ENDIF

   RETURN 0


METHOD HbQtMdiBrowser:recNo()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         RETURN ( ::cAlias )->( RecNo() )
      ENDIF
   ELSE
      RETURN ::nIndex
   ENDIF

   RETURN 0


METHOD HbQtMdiBrowser:ordKeyCount()

   IF ::nType == BRW_TYPE_DBF
      IF Select( ::cAlias ) > 0
         RETURN ( ::cAlias )->( ordKeyCount() )
      ENDIF
   ELSE
      RETURN Len( ::aData )
   ENDIF

   RETURN 0


METHOD HbQtMdiBrowser:lastRec()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( LastRec() )
   ELSE
      RETURN Len( ::aData )
   ENDIF

   RETURN 0


METHOD HbQtMdiBrowser:setIndex( cIndex )
   LOCAL n

   IF ( n := ascan( ::aIndex, cIndex ) ) >= 0
      ( ::cAlias )->( DbSetOrder( n ) )
      ::oBrw:refreshAll()
      ::dispInfo()
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:setIndexInfo()
   LOCAL a_, cName

   ::getIndexInfo()
   IF ! Empty( ::aIndex  )
      a_:={}
      FOR EACH cName IN ::aIndex
         AAdd( a_, { cName, __setOrderBlock( Self, cName ) } )
      NEXT
      IF ! Empty( a_ )
         ::oBrw:indexes := a_
      ENDIF
      ::dispInfo()
   ENDIF

   RETURN Self

METHOD HbQtMdiBrowser:getIndexInfo()
   LOCAL a_:= {}, i, cKey

   IF ::nType == BRW_TYPE_DBF
      FOR i := 1 to 50
         IF ( cKey := ( ::cAlias )->( IndexKey( i ) ) ) == ""
            EXIT
         ENDIF
         aadd( a_, ( ::cAlias )->( OrdName( i ) ) + " : " + cKey )
      NEXT
   ENDIF
   AAdd( a_, "Natural Order" )

   ::aIndex := a_

   RETURN ::aIndex


METHOD HbQtMdiBrowser:ordName( nOrder )
   DEFAULT nOrder TO ::indexOrd()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( OrdName( nOrder ) )
   ENDIF

   RETURN ""


METHOD HbQtMdiBrowser:indexKeyValue( nOrder )
   LOCAL xValue

   IF ::nType == BRW_TYPE_DBF
      xValue := ( ::cAlias )->( &( ::indexKey( nOrder ) ) )
   ENDIF

   RETURN xValue


METHOD HbQtMdiBrowser:indexKeyType( nOrder )
   LOCAL xValue

   IF ::nType == BRW_TYPE_DBF
      xValue := ( ::cAlias )->( &( ::indexKey( nOrder ) ) )
   ENDIF

   RETURN ValType( xValue )


METHOD HbQtMdiBrowser:indexKey( nOrder )
   DEFAULT nOrder TO ::indexOrd()

   IF ::nType == BRW_TYPE_DBF
      RETURN ( ::cAlias )->( IndexKey( nOrder ) )
   ENDIF

   RETURN ""


METHOD HbQtMdiBrowser:append()

   IF ::nType == BRW_TYPE_DBF
      ( ::cAlias )->( DbAppend() )
      IF ! ( ::cAlias )->( NetErr() )
         ( ::cAlias )->( DbCommit() )
         ( ::cAlias )->( DbrUnlock() )
         ::refreshAll()
      ENDIF
   ELSE

   ENDIF
   RETURN Self


METHOD HbQtMdiBrowser:setScope( cScopeTop, cScopeBottom )
   LOCAL cScope, nOrd

   IF ( nOrd := ::indexOrd() ) > 0
      IF ! hb_HHasKey( ::hScope, nOrd )
         cScope := __hbqtGetBlankValue( ::indexKeyValue() )
         ::hScope[ nOrd ] := { cScope, cScope }
      ENDIF
      IF cScopeTop != NIL
         cScope := cScopeTop
      ELSE
         cScope := ::hScope[ nOrd ][ 1 ]
         IF ValType( cScope ) == "C"
            cScope := Pad( cScope, Len( ::indexKeyValue() ) )
         ENDIF
         cScope := HbQtBulkGet( cScope, 'Scope Top' )
      ENDIF
      ::hScope[ nOrd ][ 1 ] := cScope
      IF valtype( cScope ) == 'C'
         cScope := trim( cScope )
      ENDIF

      IF Empty( cScope )
         ( ::cAlias )->( OrdScope( 0, NIL ) )
      ELSE
         ( ::cAlias )->( OrdScope( 0, cScope ) )
         ::oBrw:goTop()

         IF cScopeBottom != NIL
            cScope := cScopeBottom
         ELSE
            IF ValType( cScope ) == "C"
               cScope := Pad( ::hScope[ nOrd ][ 2 ], Len( __hbqtGetBlankValue( ::indexKeyValue() ) ) )
            ENDIF
            cScope := HbQtBulkGet( cScope, 'Scope Bottom' )
         ENDIF
         ::hScope[ nOrd ][ 2 ] := cScope

         IF  valtype( cScope ) == 'C'
             cScope := trim( cScope )
         ENDIF
         IF Empty( cScope )
            ( ::cAlias )->( OrdScope( 1, NIL ) )
         ELSE
            ( ::cAlias )->( OrdScope( 1, cScope ) )
         ENDIF
         ::oBrw:goTop()
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:clearScope( nScope )

   IF ::indexOrd() > 0
      IF nScope == NIL
         ( ::cAlias )->( OrdScope( 0, NIL ) )
         ( ::cAlias )->( OrdScope( 1, NIL ) )
      ELSEIF nScope == 0
         ( ::cAlias )->( OrdScope( 0, NIL ) )
      ELSEIF nScope == 1
         ( ::cAlias )->( OrdScope( 1, NIL ) )
      ENDIF
      ::oBrw:goTop()
   ENDIF

   RETURN Self


METHOD HbQtMdiBrowser:delete( lAsk )

   DEFAULT lAsk TO .T.
   IF lAsk
      IF Alert( 'Delete Current Record ?', { 'No','Yes' } ) != 2
         RETURN Self
      ENDIF
   ENDIF

   IF ::nType == BRW_TYPE_DBF
      IF ( ::cAlias )->( DbRLock()   )
         ( ::cAlias )->( DbDelete()  )
         ( ::cAlias )->( DbCommit()  )
         ( ::cAlias )->( DbRUnlock() )
         ::refreshAll()
      ENDIF
   ELSE

   ENDIF
   RETURN Self


METHOD HbQtMdiBrowser:recall()

   IF ::nType == BRW_TYPE_DBF
      IF ( ::cAlias )->( Deleted() )
         IF ( ::cAlias )->( DbRLock() )
            ( ::cAlias )->( DbRecall() )
            ( ::cAlias )->( DbCommit() )
            ( ::cAlias )->( DbRUnlock() )
            ::refreshAll()
         ENDIF
      ENDIF
   ELSE

   ENDIF
   RETURN Self


METHOD HbQtMdiBrowser:use()
   LOCAL bError, oErr
   LOCAL lErr := .f.

   IF HB_ISBLOCK( ::oManager:openTableBlock ) .AND. HB_ISLOGICAL( lErr := Eval( ::oManager:openTableBlock, ::cTable, ::cAlias, ::cDriver, ::cConxn ) )
      // Nothing TO DO !
   ELSE
      lErr := .F.

      SWITCH ::cDriver
      CASE "DBFCDX"
      CASE "DBFNTX"
      CASE "DBFNSX"
      CASE "ADS"
         bError := ErrorBlock( {|o| break( o ) } )
         BEGIN SEQUENCE
            USE ( ::cTable ) ALIAS ( ::cAlias ) SHARED NEW VIA ( ::cDriver )
            IF ( ::cAlias )->( NetErr() )
               Alert( { ::cTable, "Could Not Been Opened!" } )
               lErr := .t.
            ENDIF
         RECOVER USING oErr
            Alert( { oErr:description, "Error Opening Table" } )
            RETURN Self
         ENDSEQUENCE
         ErrorBlock( bError )

         EXIT
      ENDSWITCH
   ENDIF

   IF lErr
      RETURN .f.
   ENDIF

   RETURN .T.


METHOD HbQtMdiBrowser:exists()
   LOCAL lExists

   IF HB_ISBLOCK( ::oManager:existsTableBlock ) .AND. HB_ISLOGICAL( lExists := Eval( ::oManager:existsTableBlock, ::cTable, ::cDriver, ::cConxn ) )
      RETURN lExists
   ELSE
      SWITCH ::cDriver
      CASE "DBFCDX"
      CASE "DBFNSX"
      CASE "DBFNTX"
      CASE "ADS"
         RETURN hb_fileExists( ::cTable )
      ENDSWITCH
   ENDIF

   RETURN .F.


METHOD HbQtMdiBrowser:addIndexFile( cIndexFile )

   ( ::cAlias )->( ordListAdd( cIndexFile ) )

   RETURN Self


METHOD HbQtMdiBrowser:selectAField()
   LOCAL aStruct, nChoice, cVar, nPos, aMenu := {}

   aStruct := ::dbStruct
   AEval( aStruct, {|e_| AAdd( aMenu, e_[ 1 ] ) } )

   nChoice := HbQtAChoice( , , , , aMenu, , , , , , ::cAlias + " : Select a Field" )
   IF nChoice > 0
      cVar := GetActive():buffer()
      nPos := GetActive():pos()
      cVar := SubStr( cVar, 1, nPos ) + ( ::cAlias + "->" + aStruct[ nChoice, 1 ] ) + SubStr( cVar, nPos + 1 )
      GetActive():varPut( cVar )
      GetActive():display()
      GetActive():pos := nPos + Len( ::cAlias + "->" + aStruct[ nChoice, 1 ] )
   ENDIF

   RETURN NIL


STATIC FUNCTION hbide_pathToOSPath( cPath )
   LOCAL n

   cPath := strtran( cPath, "//", hb_ps() )
   cPath := strtran( cPath, "/" , hb_ps() )
   cPath := strtran( cPath, "\\", hb_ps() )
   cPath := strtran( cPath, "\" , hb_ps() )

   IF ( n := at( ":", cPath ) ) > 0
      cPath := substr( cPath, 1, n - 1 ) + substr( cPath, n )
   ENDIF

   RETURN cPath


STATIC FUNCTION hbide_array2string( a_, cDlm )
   LOCAL s := ""

   aeval( a_, {|e| s += e + cDlm } )

   RETURN s


FUNCTION hbdbu_fetchAFile( oWnd, cTitle, cFilter, cDftDir, cDftSuffix, lAllowMulti )
   LOCAL i, oDlg, nRes, oList, aFiles := {}

   DEFAULT cTitle      TO "Please Select a File"
   DEFAULT cFilter     TO "Database Tables (*.dbf)"
   DEFAULT cDftDir     TO hb_dirBase()
   DEFAULT lAllowMulti TO .F.

   HB_SYMBOL_UNUSED( cDftSuffix )

   WITH OBJECT oDlg := QFileDialog( oWnd )
      :setWindowTitle( cTitle )
      :setNameFilter( cFilter )
      :setDirectory( cDftDir )
      :setFilter( QDir_AllDirs + QDir_Files + QDir_NoDotAndDotDot )
      :setFileMode( iif( lAllowMulti, QFileDialog_ExistingFiles, QFileDialog_ExistingFile ) )
   ENDWITH

   nRes := oDlg:exec()
   IF nRes > 0
      oList := oDlg:selectedFiles()
      FOR i := 0 TO oList:size() - 1
         AAdd( aFiles, oList:At( i ) )
      NEXT
   ENDIF
   oDlg:setParent( QWidget() )

   RETURN iif( nRes == 0, NIL, iif( lAllowMulti, aFiles, aFiles[ 1 ] ) )


FUNCTION hbdbu_saveAFile( oWnd, cTitle, cFilter, cDftDir )
   LOCAL oDlg, xRes

   DEFAULT cTitle   TO "Save File"
   DEFAULT cFilter  TO "Database Tables (*.dbf)"
   DEFAULT cDftDir  TO hb_dirBase()

   WITH OBJECT oDlg := QFileDialog( oWnd )
      :setWindowTitle( cTitle )
      :setNameFilter( cFilter )
      :setDirectory( cDftDir )
      :setFilter( QDir_AllDirs + QDir_Files + QDir_NoDotAndDotDot )
      :setFileMode( QFileDialog_AnyFile )
      :setAcceptMode( QFileDialog_AcceptSave )
      :setConfirmOverwrite( .T. )
   ENDWITH

   xRes := oDlg:getSaveFileName( oWnd, cTitle, "", cFilter )

   oDlg:setParent( QWidget() )

   RETURN xRes


STATIC FUNCTION hbide_posAndSize( oWidget )

   RETURN hb_ntos( oWidget:x() )     + "," + hb_ntos( oWidget:y() )      + "," + ;
          hb_ntos( oWidget:width() ) + "," + hb_ntos( oWidget:height() ) + ","


