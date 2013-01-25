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
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                                HbDBU
 *
 *                             Pritpal Bedi
 *                              17Jan2013
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "hbclass.ch"
#include "common.ch"

#ifdef __ADS__
#include "ads.ch"
#endif

#ifdef __CACHE__
REQUEST CACHERDD
#endif


FUNCTION Main( ... )
   LOCAL oMgr

   hbqt_errorSys()
   QResource():registerResource_1( hbqtres_dbu() )

   oMgr := DbuMGR():new( hb_AParams() )
   oMgr:create()

   QApplication():exec()

   RETURN NIL


CREATE CLASS DbuMGR
   DATA   oWidget
   DATA   oToolbar
   DATA   oDbu

   DATA   oDashBoard
   DATA   oLayDash
   DATA   aDash                                   INIT {}
   DATA   oTimerDash
   DATA   oSplash

   DATA   oExitAct
   DATA   oDashAct
   DATA   oInfoAct

   DATA   lCache                                  INIT .F.
   DATA   lAds                                    INIT .F.
   DATA   aParams                                 INIT {}
   DATA   hConxns                                 INIT {=>}
   DATA   aConxns                                 INIT {}
   DATA   hDbuData                                INIT {=>}

   METHOD getImage( cName )                       INLINE QIcon( ":/dbu/resources/" + cName + ".png" )

   METHOD new( aParams )
   METHOD create()
   METHOD exit( lAsk, oEvent )
   METHOD openConnections( aConxns )
   METHOD populateProdTables()
   METHOD setMyConnections( cDriver )
   METHOD selectMyTable( cDriver, cConxn )
   METHOD openMyTable( cTable,cAlias,cDriver,cConxn )
   METHOD checkIfTableExists( cTable, cDriver, cConxn )
   METHOD populateTree( cTable,cDriver,cConxn )
   METHOD configureBrowser( oHbQtBrowse, oMdiBrowse, oDBU )
   METHOD setDatabaseParams()
   METHOD getATable( cConxn )
   METHOD fetchDbuData()
   METHOD saveRecord( aMod, aData, oHbQtBrowse, oMdiBrowse )
   METHOD manageSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )
   METHOD handleOptions( nKey, xData, oHbQtBrowse, oMdiBrowse )
   METHOD getSearchValue( oMdiBrowse, xValue )
   METHOD helpInfo()
   METHOD saveEnvironment()
   METHOD restEnvironment()
   METHOD getPath( cFile )
   METHOD execDashboard()
   METHOD updateDashboard()
   METHOD showStats( oMdiBrowse )

   ENDCLASS


METHOD DbuMGR:new( aParams )

   hb_HCaseMatch( ::hConxns , .F. )
   hb_HCaseMatch( ::hDbuData, .F. )
   hb_HKeepOrder( ::hDbuData, .T. )

   ::aParams := aParams
#ifdef __CACHE__
   ::lCache := .T.
#endif
#ifdef __ADS__
   ::lAds := .T.
#endif

   ::fetchDbuData()
   ::setDatabaseParams()
   IF hb_HHasKey( ::hDbuData, "CacheServer" )
      ::openConnections( ::hDbuData[ "CacheServer" ] )
   ENDIF

   RETURN Self


METHOD DbuMGR:create()
   LOCAL aRdds := {}
   LOCAL cTitle

#if defined(__CACHE__)
   AAdd( aRdds, "CACHERDD" )
#endif
#ifdef __ADS__
   AAdd( aRdds, "ADS" )
#endif

#ifdef __CACHE__
   cTitle := "CacheMGR - " + ::hConxns[ "Default_ServerIP" ]
#else
   cTitle := "HbDBU"
#endif

   ::oSplash := QSplashScreen( QPixmap( __hbqtImage( "harbour-dbu" ) ) )
   ::oSplash:show()

   QApplication():processEvents()

   WITH OBJECT ::oWidget := hbqtui_dbu()
      :dockCache:hide()
      :dockAdvantage:hide()
      :setWindowIcon( ::getImage( "cube" ) )
      :setWindowTitle( cTitle )
      :statusBar():hide()
      :connect( QEvent_Close, {|oEvent| ::exit( .T., oEvent ) } )
   ENDWITH

   WITH OBJECT ::oExitAct := QAction( ::oWidget:oWidget )
      :setIcon( ::getImage( "exit" ) )
      :setTooltip( "Exit DbuMGR" )
      :connect( "triggered()", {|| ::exit( .F. ) } )
   ENDWITH
   WITH OBJECT ::oDashAct := QAction( ::oWidget:oWidget )
      :setIcon( ::getImage( "dashboard" ) )
      :setTooltip( "Cache Servers Dashboard" )
      :connect( "triggered()", {|| ::execDashboard() } )
   ENDWITH
   WITH OBJECT ::oInfoAct := QAction( ::oWidget:oWidget )
      :setIcon( QIcon( __hbqtImage( "info" ) ) )
      :setTooltip( "About HbDBU" )
      :connect( "triggered()", {|| dbu_help( 1 ) } )
   ENDWITH

   WITH OBJECT ::oToolbar := QToolBar( ::oWidget:oWidget )
      :setObjectName( "MainToolBar" )
      :setIconSize( QSize( 24,24 ) )
      :addAction( ::oExitAct )
      :addAction( ::oDashAct )
      :addSeparator()
      :addAction( ::oInfoAct )
   ENDWITH
   ::oWidget:addToolbar( Qt_TopToolBarArea, ::oToolbar )

   WITH OBJECT ::oDbu := HbQtDBU():new():create( ::oWidget:stackedWidget )
      :connectionsBlock     := {|cDriver                     | ::setMyConnections( cDriver )                   }
      :selectTableBlock     := {|cDriver,xConxn,oDbu         | ::selectMyTable( cDriver, xConxn, oDbu )        }
      :openTableBlock       := {|cTable,cAlias,cDriver,cConxn| ::openMyTable( cTable,cAlias,cDriver,cConxn )   }
      :existsTableBlock     := {|cTable,cDriver,cConxn       | ::checkIfTableExists( cTable, cDriver, cConxn ) }
      :populateTreeBlock    := {|cTable,cDriver,cConxn       | ::populateTree( cTable,cDriver,cConxn )         }
      :browseConfigureBlock := {|oBrowse,oMdiBrowse,oDbu     | ::configureBrowser( oBrowse, oMdiBrowse, oDbu ) }
      :rddsBlock            := {|| aRdds }
   ENDWITH
   ::oWidget:stackedWidget:addWidget( ::oDbu:oWidget )
   ::oWidget:stackedWidget:setCurrentIndex( 1 )

   ::populateProdTables()

   ::oWidget:dockCache:hide()
   ::restEnvironment()
   ::oWidget:show()
   ::oSplash:close()
   ::oSplash:setParent( QWidget() )


   RETURN Self


METHOD DbuMGR:exit( lAsk, oEvent )
   LOCAL lExit := .T.

   IF lAsk
      lExit := Alert( "Exit DbuMGR ?", { "Yes", "No" } ) == 1
   ENDIF
   IF lExit
      ::saveEnvironment()
   ENDIF
   IF HB_ISOBJECT( oEvent )
      oEvent:ignore()
   ENDIF
   IF lExit
      QApplication():exit( 0 )
   ENDIF

   RETURN .T.


METHOD DbuMGR:setDatabaseParams()
#ifdef __CACHE__
   LOCAL i, cServerIP, cPort, cNameSpace, cUser, cPassword, nConxn
#endif

   SET( _SET_EVENTMASK, INKEY_ALL )
   SET SCOREBOARD OFF
   SET EPOCH TO 1950

#ifdef __ADS__
   RddSetDefault( "ADS" )
   AdsSetFileType( 2 )
   SET SERVER REMOTE
   AdsLocking( .T. )
#endif

#ifdef __CACHE__
   ASize( ::aParams, 5 )

   cServerIP  := ::aParams[ 1 ]
   cPort      := ::aParams[ 2 ]
   cNameSpace := ::aParams[ 3 ]
   cUser      := ::aParams[ 4 ]
   cPassword  := ::aParams[ 5 ]

   CacheSetServerParams( cServerIP, val( cPort ), cUser, cPassword, 30 )
   FOR i = 1 to 3
      IF ( nConxn := CacheAddConnectionEx( cServerIP, val( cPort ), cUser, cPassword, 30, cNameSpace ) ) > 0
         EXIT
      ENDIF
   NEXT
   IF nConxn <= 0
      Alert( "Could not Connect to Cache Server" )
      ::lCache := .F.
   ELSE
      ::hConxns[ "Default_ServerIP"   ] := cServerIP
      ::hConxns[ "Default_ServerPort" ] := cPort
      ::hConxns[ "Default_Namespace"  ] := cNameSpace
      ::hConxns[ "Default_User"       ] := cUser
      ::hConxns[ "Default_Password"   ] := cPassword
      ::hConxns[ "Default_Connection" ] := nConxn
      ::hConxns[ "Default_Alias"      ] := "Default"
      ::hConxns[ "Default_Alternate"  ] := "Default"
   ENDIF

   IF UserLogin()                                 /* Will implement later */
      CacheSetUserInfo( "QDBU" )
   ELSE
      CacheSetUserInfo( "QDBU" )
   ENDIF
   CacheLockTimeout( 0 )
   CacheSetUseExclusive( 1 )
#endif

   RETURN .T.


METHOD DbuMGR:openConnections( aConxns )
#ifdef __CACHE__
   LOCAL cConxn, nConxn, a_

   IF ::lCache
      FOR EACH cConxn IN aConxns
         IF ! Empty( cConxn )
         a_:= hb_atokens( cConxn, ";" )
         CacheSetServerParams( a_[ 2 ], val( a_[ 3 ] ), DecryptPass( a_[ 5 ],2 ), DecryptPass( a_[ 6 ],3 ), 20 )
         nConxn := CacheAddConnectionEx( a_[ 2 ], val( a_[ 3 ] ), DecryptPass( a_[ 5 ],2 ), DecryptPass( a_[ 6 ],3 ), 20, a_[ 4 ] )
         IF nConxn > 0
            ::hConxns[ a_[ 1 ] + "_ServerIP"   ] := a_[ 2 ]
            ::hConxns[ a_[ 1 ] + "_ServerPort" ] := a_[ 3 ]
            ::hConxns[ a_[ 1 ] + "_Namespace"  ] := a_[ 4 ]
            ::hConxns[ a_[ 1 ] + "_User"       ] := DecryptPass( a_[ 5 ],2 )
            ::hConxns[ a_[ 1 ] + "_Password"   ] := DecryptPass( a_[ 6 ],3 )
            ::hConxns[ a_[ 1 ] + "_Connection" ] := nConxn
            ::hConxns[ a_[ 1 ] + "_Alias"      ] := a_[ 1 ]
            ::hConxns[ a_[ 1 ] + "_Alternate"  ] := a_[ 7 ]

            AAdd( ::aConxns, a_[ 1 ] )
         ENDIF
         ENDIF
      NEXT
      AAdd( ::aConxns, "Default" )
      CacheSetServerParams( ::hConxns[ "Default_ServerIP" ], val( ::hConxns[ "Default_ServerPort" ] ), ::hConxns[ "Default_User" ], ::hConxns[ "Default_Password" ], 20 )
      CacheSetConnection( ::hConxns[ "Default_Connection" ] )
   ENDIF
#else
   HB_SYMBOL_UNUSED( aConxns )
#endif
   RETURN Self


METHOD DbuMGR:populateTree( cTable,cDriver,cConxn )
   LOCAL cPath, cName, cExt

   IF cDriver == "CACHERDD"
#ifdef __CACHE__
      RETURN { "CACHERDD", ::hConxns[ cConxn + "_Alternate" ], Upper( cTable ), cTable, cDriver, cConxn }
#endif
   ELSE
      hb_FNameSplit( cTable, @cPath, @cName, @cExt )
      RETURN { cDriver, Upper( cPath ), Lower( cName ), cTable, cDriver, cConxn }
   ENDIF
   RETURN NIL


METHOD DbuMGR:setMyConnections( cDriver )
   IF cDriver == "CACHERDD"
      RETURN ::aConxns
   ENDIF
   RETURN {}


METHOD DbuMGR:selectMyTable( cDriver, cConxn /*, oDbu */ )
   IF cDriver == "CACHERDD" .AND. ::lCache
      IF cConxn + "_ServerIP" $ ::hConxns
         RETURN ::getATable( cConxn )
      ENDIF
   ENDIF
   RETURN NIL


METHOD DbuMGR:openMyTable( cTable, cAlias, cDriver, cConxn )

   HB_SYMBOL_UNUSED( cTable )
   HB_SYMBOL_UNUSED( cAlias )

   IF cDriver == "CACHERDD" .AND. ::lCache .AND. cConxn + "_ServerIP" $ ::hConxns
#ifdef __CACHE__
      CacheSetConnection( ::hConxns[ cConxn + "_Connection" ] )
      IF empty( cAlias )
         USE ( cTable ) NEW SHARED VIA ( cDriver )
      ELSE
         USE ( cTable ) ALIAS ( cAlias ) NEW SHARED VIA ( cDriver )
      ENDIF
      CacheSetConnection( ::hConxns[ "Default_Connection" ] )
      RETURN NetErr()
#endif
   ENDIF
   RETURN NIL


METHOD DbuMGR:checkIfTableExists( cTable, cDriver, cConxn )

   HB_SYMBOL_UNUSED( cTable )

   IF cDriver == "CACHERDD" .AND. ::lCache .AND. cConxn + "_ServerIP" $ ::hConxns
#ifdef __CACHE__
      RETURN CacheExistTable( cTable, ::hConxns[ cConxn + "_Connection" ] )
#endif
   ENDIF
   RETURN NIL


METHOD DbuMGR:getATable( cConxn )
   LOCAL oDlg, qStrList, cTable
#ifdef __CACHE__
   LOCAL aTables := CacheGetTables( , ::hConxns[ cConxn + "_Connection" ] )
#else
   LOCAL aTables := {}
#endif

   IF ! empty( aTables )
      qStrList := QStringList():new()
      FOR EACH cTable IN aTables
         qStrList:append( cTable )
      NEXT
      oDlg := QInputDialog()
      cTable := oDlg:getItem( QApplication():focusWidget(), cConxn, "Table?", qStrList )
      oDlg:setParent( QWidget() )
   ENDIF

   RETURN cTable


METHOD DbuMGR:fetchDbuData()
   LOCAL cText, s, n, a_, cKey, cValue

   cText := hb_memoread( hb_dirBase() + "hbdbu.ini" )
   IF !( hb_eol() == Chr( 10 ) )
      cText := StrTran( cText, hb_eol(), Chr( 10 ) )
   ENDIF
   IF !( hb_eol() == Chr( 13 ) + Chr( 10 ) )
      cText := StrTran( cText, Chr( 13 ) + Chr( 10 ), Chr( 10 ) )
   ENDIF
   a_:= hb_aTokens( cText, chr( 10 ) )
   FOR EACH s IN a_
      s := alltrim( s )
      IF ! ( left( s,1 ) $ "#/*" )
         IF ( n := at( "=", s ) ) > 0
            cKey   := upper( alltrim( substr( s, 1, n-1 ) ) )
            cValue := alltrim( substr( s, n+1 ) )
            IF ! hb_HHasKey( ::hDbuData, cKey )
               ::hDbuData[ cKey ] := {}
            ENDIF
            AAdd( ::hDbuData[ cKey ], cValue )
         ENDIF
      ENDIF
   NEXT

   RETURN Self


METHOD DbuMGR:populateProdTables()
   LOCAL aTables := {}, cTables, cTable

   IF ! ::lCache
      RETURN NIL
   ENDIF

   FOR EACH cTables IN ::hDbuData[ "OpenViaCache" ]
      FOR EACH cTable IN hb_ATokens( cTables, ";" )
         AAdd( aTables, cTable )
      NEXT
   NEXT

   FOR EACH cTable IN aTables
      IF ! Empty( cTable )
         ::oDbu:populateTree( "CACHERDD", "Production", cTable, cTable, "CACHERDD", "ECP_1", NIL )
      ENDIF
   NEXT
   FOR EACH cTable IN aTables
      IF ! Empty( cTable )
         ::oDbu:populateTree( "CACHERDD", "Test", cTable, cTable, "CACHERDD", "Test", NIL )
      ENDIF
   NEXT

   RETURN NIL


METHOD DbuMGR:configureBrowser( oHbQtBrowse, oMdiBrowse, oDBU )

   HB_SYMBOL_UNUSED( oDBU )

   WITH OBJECT oHbQtBrowse
      :horizontalScrollbar := .T.
      :verticalScrollbar   := .T.
      :toolbar             := .T.
      :statusbar           := .F.
      :editBlock           := {|aMod,aData,oBrw  | ::saveRecord( aMod, aData, oBrw, oMdiBrowse )     }
      :searchBlock         := {|xValue,nMode,oBrw| ::manageSearch( xValue, nMode, oBrw, oMdiBrowse ) }
      :navigationBlock     := {|nKey,xData,oBrw  | ::handleOptions( nKey, xData, oBrw, oMdiBrowse )  }
      :helpBlock           := {|                 | { ::helpInfo(), 0 } }
#ifdef __CACHE__                                  /* CacheRDD does not support OrdKey*() functions */
      :firstPosBlock       := {| | 1                    }
      :lastPosBlock        := {| | oMdiBrowse:lastRec() }
      :posBlock            := {| | oMdiBrowse:recNo()   }
      :goPosBlock          := {|n| oMdiBrowse:goto( n ) }
      :phyPosBlock         := {| | oMdiBrowse:recNo()   }
#endif
   ENDWITH

   /* Indicate that the table belongs TO production environment and hence be modified WITH care */
   IF oMdiBrowse:connection() $ "ECP_1,ECP_2,ECP_3,Cluster"
      oHbQtBrowse:showIndicator( "red" )
   ENDIF

   RETURN NIL


METHOD DbuMGR:saveRecord( aMod, aData, oHbQtBrowse, oMdiBrowse )
   HB_SYMBOL_UNUSED( aMod )
   HB_SYMBOL_UNUSED( aData )
   HB_SYMBOL_UNUSED( oHbQtBrowse )
   HB_SYMBOL_UNUSED( oMdiBrowse )
   RETURN .T.


STATIC FUNCTION __getBlankValue( xValue )

   SWITCH ValType( xValue )
   CASE "C" ; RETURN Space( Len( xValue ) )
   CASE "N" ; RETURN 0
   CASE "D" ; RETURN CToD( "" )
   CASE "L" ; RETURN .F.
   ENDSWITCH

   RETURN ""

METHOD DbuMGR:manageSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )

   IF xValue == NIL .AND. oHbQtBrowse == NIL
      // Nothing TO do
   ELSEIF xValue == NIL
      IF oMdiBrowse:indexOrd() > 0
         xValue := __getBlankValue( oMdiBrowse:indexKeyValue() )
         RETURN { xValue, "@ ", HBQTBRW_SEARCH_INCREMENTAL }
      ELSE
         RETURN { __getBlankValue( Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block ) ), NIL, HBQTBRW_SEARCH_BYFIELD }
      ENDIF
   ELSE
      IF oMdiBrowse:indexOrd() > 0
         oMdiBrowse:search( xValue )
      ELSEIF nMode == HBQTBRW_SEARCH_BYFIELD
         RETURN Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block ) = xValue
      ENDIF
   ENDIF

   RETURN .T.


METHOD DbuMGR:handleOptions( nKey, xData, oHbQtBrowse, oMdiBrowse )
   LOCAL i, xResult, nRec, xValue, aRecList, aList, astr, aMnu, oCol, cFilter
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )

   oMdiBrowse:dispInfo()

   DO CASE
   CASE nKey == K_CTRL_PGUP
      oHbQtBrowse:goTop()
      RETURN .F.

   CASE nKey == K_CTRL_PGDN
      oHbQtBrowse:goBottom()
      RETURN .F.

   CASE nKey == K_F5
      oHbQtBrowse:Scroll()

   CASE nKey == K_F1
      oHbQtBrowse:help()

   CASE nKey == K_F2
      oMdiBrowse:setOrder( 0 )
      oMdiBrowse:dispInfo()

   CASE nKey == K_F3
      IF ! Empty( nRec := HbQtBulkGet( 0, "Goto?", "@Z 999999999999" ) )
         oMdiBrowse:goto( nRec )
         oMdiBrowse:dispInfo()
      ENDIF

   CASE nKey == K_F8
      oHbQtBrowse:freeze++
   CASE nKey == K_SH_F8
      oHbQtBrowse:freeze--

   CASE nKey == K_F7
      IF ::getSearchValue( oMdiBrowse, @xValue )    /* Seek      */
         oMdiBrowse:search( xValue, .F., .F. )
         oMdiBrowse:dispInfo()
      ENDIF
   CASE nKey == K_ALT_E
      IF ::getSearchValue( oMdiBrowse, @xValue )    /* Seek Last */
         oMdiBrowse:search( xValue, .F., .T. )
         oMdiBrowse:dispInfo()
      ENDIF
   CASE nKey == K_ALT_Y
      IF ::getSearchValue( oMdiBrowse, @xValue )    /* Seek Soft */
         oMdiBrowse:search( xValue, .T., .F. )
         oMdiBrowse:dispInfo()
      ENDIF

   CASE nKey == K_SH_F5
      oHbQtBrowse:moveRight()
   CASE nKey == K_SH_F6
      oHbQtBrowse:moveLeft()

   CASE nKey == K_ALT_F6
      IF oHbQtBrowse:colCount > 1
         oHbQtBrowse:DelColumn( oHbQtBrowse:colPos )
         oHbQtBrowse:RefreshAll()
      ENDIF

   CASE nKey == K_ALT_F5                          /* Insert Column */
      aStr := oMdiBrowse:dbStruct()
      aMnu := {}
      aeval( aStr, {|e_| AAdd( aMnu, e_[ 1 ] ) } )
      IF ! Empty( nRec := HbQtAChoice( , , , , aMnu, , , , , "Select a Field" ) )
         oCol := HbQtColumnNew( aStr[ nRec, 1 ], oMdiBrowse:fieldBlock( aStr[ nRec, 1 ] ) )
         oHbQtBrowse:insColumn( oHbQtBrowse:ColPos, oCol )
         oHbQtBrowse:RefreshAll()
      ENDIF

   CASE nKey == K_ALT_P                           /* SET SCOPE */
      oMdiBrowse:setScope()

   CASE nKey == K_ALT_W                           /* clear SCOPE */
      oMdiBrowse:clearScope()

   CASE nKey == K_ALT_INS                         /* append BLANK */
      oMdiBrowse:append()

   CASE nKey == K_ALT_DEL                         /* delete RECORD */
      oMdiBrowse:delete( .T. )

   CASE nKey == K_ALT_L                           /* Lock RECORD */
      IF ! oMdiBrowse:lock()
         Alert( "Could not lock record!" )
      ENDIF

   CASE nKey == K_ALT_U                           /* Unlock RECORD */
      IF ! oMdiBrowse:unLock()
         Alert( "Could not unlock record!" )
      ENDIF

   CASE nKey == K_ALT_K                           /* Unlock a selective RECORD */
      IF ! Empty( aRecList := oMdiBrowse:dbrLockList() )
         aList := {}
         AEval( aRecList, {|n| AAdd( aList, hb_ntos( n ) ) } )
         IF ! Empty( nRec := HbQtAChoice( , , , , aList ) )
            oMdiBrowse:unLock( aRecList[ nRec ] )
         ENDIF
      ENDIF

   CASE nKey ==  K_ALT_F                          /* FILTER */
      cFilter := trim( HbQtBulkGet( Space( 50 ), 'Filter Expression' ) )
      IF ! Empty( cFilter )
         oMdiBrowse:setFilter( cFilter )
         oMdiBrowse:goTop()
      ENDIF

   CASE nKey == K_ALT_R                           /* clear FILTER */
      oMdiBrowse:clearFilter()
      oMdiBrowse:goTop()

   CASE nKey == K_ALT_T
      ::showStats( oMdiBrowse )

   CASE nKey == K_ENTER
      IF dbRLock()
         xResult := oHbQtBrowse:editCell()
         IF xResult != NIL
            Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block, xResult )      /* Even this is not required, or DBU must not set the SETGET block, just the GET block */
            dbCommit()
            oHbQtBrowse:refreshCurrent()
         ENDIF
         dbRUnlock()
      ENDIF

   CASE nKey == K_ALT_ENTER
      IF dbRLock()
         FOR i := oHbQtBrowse:colPos TO oHbQtBrowse:colCount()
            xResult := oHbQtBrowse:editCell()
            IF xResult == NIL
               EXIT
            ENDIF
            Eval( oHbQtBrowse:getColumn( i ):block, xResult )      /* Even this is not required, or DBU must not set the SETGET block, just the GET block */
            oHbQtBrowse:refreshCurrent()
            IF i < oHbQtBrowse:colCount()
               oHbQtBrowse:right()
            ENDIF
         NEXT
         dbCommit()
         dbRUnlock()
      ENDIF

   CASE nKey == K_CTRL_ENTER
      DO WHILE .T.
         IF dbRLock()
            xResult := oHbQtBrowse:editCell()
            IF xResult == NIL
               EXIT
            ENDIF
            Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block, xResult )
            dbCommit()
            dbRUnlock()
            oHbQtBrowse:refreshCurrent()
            oHbQtBrowse:down()
            IF oHbQtBrowse:hitBottom
               EXIT
            ENDIF
         ENDIF
      ENDDO

   CASE nKey == K_CTRL_F1
      oHbQtBrowse:search( NIL, NIL, HBQTBRW_SEARCH_BYFIELD )

   OTHERWISE
      lHandelled := .F.

   ENDCASE

   RETURN lHandelled


METHOD DbuMGR:showStats( oMdiBrowse )
   LOCAL aStats := {}

   aadd( aStats, pad( '   Generic'                                    ,                32 ) + "." )
#ifdef __CACHE__
   aadd( aStats, pad( 'Server Time     = ' + CacheGetServerTime(),                     32 ) + "." )
   aadd( aStats, pad( 'Server Date     = ' + DToC( CacheGetServerDate()  ),            32 ) + "." )
   aadd( aStats, pad( 'Insert Lock Mode= ' + hb_ntos( CacheInsertLockMode() ),         32 ) + "." )
#endif
   aadd( aStats, pad( 'LastRec()       = ' + hb_ntos( oMdiBrowse:lastRec()  ),         32 ) + "." )
   aadd( aStats, pad( 'OrdKeyNo()      = ' + hb_ntos( oMdiBrowse:ordKeyNo() ),         32 ) + "." )
   aadd( aStats, pad( 'OrdKeyCount()   = ' + hb_ntos( oMdiBrowse:ordKeyCount() ),      32 ) + "." )
   aadd( aStats, pad( '   Field Info'                                           ,      32 ) + "." )
   aadd( aStats, pad( 'FCount()        = ' + hb_ntos( oMdiBrowse:fCount() ),           32 ) + "." )
   aadd( aStats, pad( 'DbFieldInfo()   = ' + hb_ntos( oMdiBrowse:dbFieldInfo( 1,1 ) ), 32 ) + "." )
   aadd( aStats, pad( '   Index Info'                              ,                   32 ) + "." )
   aadd( aStats, pad( 'IndexKey()      = ' + hb_ntos( oMdiBrowse:indexKey() ),         32 ) + "." )
   aadd( aStats, pad( 'IndexOrd()      = ' + hb_ntos( oMdiBrowse:indexOrd() ),         32 ) + "." )
   aadd( aStats, pad( 'IndexExt()      = ' + hb_ntos( oMdiBrowse:indexExt() ),         32 ) + "." )
   aadd( aStats, Pad( 'OrdKey()        = ' + hb_ntos( oMdiBrowse:ordKey() ),           32 ) + "." )

   Alert( aStats, , , , "Various Statistics" )

   RETURN NIL

METHOD DbuMGR:getSearchValue( oMdiBrowse, xValue )
   IF oMdiBrowse:indexOrd() > 0
      xValue := oMdiBrowse:indexKeyValue()
      IF ( xValue := HbQtBulkGet( xValue, oMdiBrowse:IndexKey() ) ) != NIL
         xValue := iif( ValType( xValue ) == "C", Trim( xValue ), xValue )
         RETURN .T.
      ENDIF
   ENDIF
   RETURN .F.


METHOD DbuMGR:helpInfo()
   LOCAL v_:= {}

   aadd( v_, 'F2       Sets the index to 0 for natural record order' )
   aadd( v_, 'F3                              Set a new index order' )
   aadd( v_, 'F4                   Goto a specific record by number' )
   aadd( v_, 'F5        Auto scrolls the browser current-bottom-top' )
   aadd( v_, 'F7               Search for a record by Current Index' )
   aadd( v_, 'F8                           Freezes leftmoost column' )
   aadd( v_, 'F10           Toggles locks status of currents record' )
   aadd( v_, 'Sh+F8                   UnFreezes last freezed column' )
   aadd( v_, 'Sh+F5         Moves current column right one position' )
   aadd( v_, 'Sh+F6           Moves current column left on position' )
   aadd( v_, 'Alt+F5              Insert column at current location' )
   aadd( v_, 'Alt+F6             Deletes currently hilighted column' )
   aadd( v_, '                                                     ' )
   aadd( v_, 'ENTER                               Edit current cell' )
   aadd( v_, 'Alt+ENTER      Edit current row starting current cell' )
   aadd( v_, 'Ctrl+ENTER          Edit current column then next row' )
   aadd( v_, '                                                     ' )
   aadd( v_, 'Alt_E                                       Seek Last' )
   aadd( v_, 'Alt_Y                                       Seek Soft' )
   aadd( v_, 'ALT_Z                                    Skip Records' )
   aadd( v_, 'Alt_F                                    Set a Filter' )
   aadd( v_, 'Alt_R                                    Clear Filter' )
   aadd( v_, 'Alt_P                                       Set Scope' )
   aadd( v_, 'Alt_O                                     Clear Scope' )
   aadd( v_, 'Alt_INS                         Append a blank Record' )
   aadd( v_, 'Alt_DEL                         Delete Current Record' )
   aadd( v_, 'Alt_T                                 Show Statistics' )
// aadd( v_, 'Alt_V                               Performance Stats' )
// aadd( v_, 'Alt_X                            Sum Average High Low' )
   aadd( v_, 'Ctrl_F1                                 Find in field' )
   aadd( v_, '                                                     ' )
   aadd( v_, 'Alt_L                             Lock Current Record' )
   aadd( v_, 'Alt_U                           Unlock Current Record' )
   aadd( v_, 'Alt_K                       Unlock a Selective Record' )
   aadd( v_, 'Alt_S                          List of Locked Records' )
// aadd( v_, 'Alt_I                                       Lock Info' )
// aadd( v_, 'Alt_G                            List of Global Locks' )
// aadd( v_, 'Alt_X                       Lock Info Column (Toggle)' )

   RETURN v_


STATIC FUNCTION __arrayToString( aStrings, cDlm )
   LOCAL cStr := ""
   aeval( aStrings, {|e| cStr += e + cDlm } )
   RETURN cStr


METHOD DbuMGR:saveEnvironment()
   LOCAL oSettings
   LOCAL oWgt := ::oWidget:oWidget
   LOCAL cFile := ::getPath( "settings.dbu" )

   WITH OBJECT oSettings := QSettings( cFile, QSettings_IniFormat )
      :setValue( "dbuSettings"     , QVariant( oWgt:saveState() ) )
      :setValue( "dbuSplitter"     , QVariant( ::oDbu:splitter:saveState() ) )
      :setValue( "dbuPosAndSize"   , QVariant( QRect( oWgt:x(), oWgt:y(), oWgt:width(), oWgt:height() ) ) )
      :setValue( "dbuTablesVisible", QVariant( ::oDbu:tablesPanel:isVisible() ) )
      :setValue( "dbuStructVisible", QVariant( ::oDbu:structPanel:isVisible() ) )
      :setValue( "dbuPanelNames"   , QVariant( __arrayToString( ::oDbu:getPanelNames(), "~" ) ) )
      :setValue( "dbuPanelsInfo"   , QVariant( __arrayToString( ::oDbu:getPanelsInfo(), "~" ) ) )
      :setValue( "dbuTreeInfo"     , QVariant( __arrayToString( ::oDbu:getTreeInfo()  , "~" ) ) )
   ENDWITH

   RETURN oSettings


METHOD DbuMGR:restEnvironment()
   LOCAL oSettings, oWgt := ::oWidget:oWidget
   LOCAL cFile := ::getPath( "settings.dbu" )
   LOCAL oRect, lVal, cInfo

   oSettings := QSettings( cFile, QSettings_IniFormat )
   oWgt:restoreState( oSettings:value( "dbuSettings" ):toByteArray() )

   IF oSettings:contains( "dbuPosAndSize" )
      oRect := oSettings:value( "dbuPosAndSize" ):toRect()
      oWgt:move( oRect:x(), oRect:y() )
      oWgt:resize( oRect:width(), oRect:height() )
   ENDIF

   IF oSettings:contains( "dbuTablesVisible" )
      lVal := oSettings:value( "dbuTablesVisible" ):toBool()
      IF lVal
         IF ! ::oDbu:tablesPanel:isVisible()
            ::oDbu:tablesPanel:show()
         ENDIF
      ELSE
         IF ::oDbu:tablesPanel:isVisible()
            ::oDbu:tablesPanel:hide()
         ENDIF
      ENDIF
   ENDIF
   IF oSettings:contains( "dbuStructVisible" )
      lVal := oSettings:value( "dbuStructVisible" ):toBool()
      IF lVal
         IF ! ::oDbu:structPanel:isVisible()
            ::oDbu:structPanel:show()
         ENDIF
      ELSE
         IF ::oDbu:structPanel:isVisible()
            ::oDbu:structPanel:hide()
         ENDIF
      ENDIF
   ENDIF
   IF oSettings:contains( "dbuSplitter" )
      ::oDbu:splitter:restoreState( oSettings:value( "dbuSplitter" ):toByteArray() )
   ENDIF

   IF oSettings:contains( "dbuPanelNames" )
      ::oDbu:addPanels( hb_ATokens( oSettings:value( "dbuPanelNames" ):toString(), "~" ) )
   ENDIF
   IF oSettings:contains( "dbuPanelsInfo" )
      ::oDbu:loadTables( hb_ATokens( oSettings:value( "dbuPanelsInfo" ):toString(), "~" ) )
   ENDIF

   IF oSettings:contains( "dbuTreeInfo" )
      FOR EACH cInfo IN hb_ATokens( oSettings:value( "dbuTreeInfo" ):toString(), "~" )
         IF ! Empty( cInfo )
            IF ! ( "CACHERDD" $ cInfo )
               ::oDbu:populateTree( hb_ATokens( cInfo, " " ) )
            ENDIF
         ENDIF
      NEXT
   ENDIF

   RETURN NIL


METHOD DbuMGR:getPath( cFile )
   LOCAL cPath, cIni

   IF .T.
      IF ! hb_FileExists( cIni := hb_dirBase() + cFile )
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
         cIni := cPath + cFile
      ENDIF
   ENDIF

   RETURN cIni


METHOD DbuMGR:execDashboard()
   LOCAL oDock := ::oWidget:dockCache
   LOCAL cConxn, oDash

   IF Empty( ::oDashBoard )
      ::oDashBoard := QWidget()

      FOR EACH cConxn IN ::aConxns
         IF cConxn != "Default"
            IF hb_HHasKey( ::hConxns, cConxn + "_ServerIP" )
               AAdd( ::aDash, DashBoard():new( Self, ::hConxns[ cConxn + "_ServerIP" ], cConxn ) )
            ENDIF
         ENDIF
      NEXT
      WITH OBJECT ::oLayDash := QVBoxLayout( ::oDashBoard )
         :setContentsMargins( 0,0,0,0 )
         :addStretch( 0 )
         IF ! Empty( ::aDash )
            FOR EACH oDash IN ::aDash
               :addWidget( oDash:oWidget )
            NEXT
         ELSE        /* Just to demonstrate - exploit it as you wish */
            AAdd( ::aDash, DashBoard():new( Self, "10.0.0.101", "NONE" ) )
            :addWidget( ::aDash[ 1 ]:oWidget )
         ENDIF
         :addStretch( 0 )
      ENDWITH

      ::oDashBoard:setLayout( ::oLayDash )

      ::oTimerDash := QTimer( ::oDashBoard )
      ::oTimerDash:setInterval( 10000 )
      ::oTimerDash:connect( "timeout()", {|| ::updateDashBoard() } )

      oDock:setWidget( ::oDashBoard )
   ENDIF

   IF ::oWidget:dockCache:isVisible()
      ::oWidget:dockCache:hide()
      ::oTimerDash:stop()
   ELSE
      ::oWidget:dockCache:show()
      ::updateDashboard()
      ::oTimerDash:start()
   ENDIF

   RETURN Self


METHOD DbuMGR:updateDashboard()
   LOCAL oDash
   FOR EACH oDash IN ::aDash
      oDash:update()
   NEXT
   RETURN NIL


/*----------------------------------------------------------------------*/
//                            CLASS DashBoard
/*----------------------------------------------------------------------*/


CLASS DashBoard

   DATA   oDbuMGR
   DATA   cServerIP
   DATA   cConxn

   DATA   oWidget
   DATA   oLay
   DATA   oHLay
   DATA   oHLayD
   DATA   oFrameTop
   DATA   oFrameBtm

   DATA   oLabelLic
   DATA   oLabelLicUsed
   DATA   oLabelLockAvail
   DATA   oLabelLockUsed
   DATA   oLabelLocks

   METHOD new( oDbuMGR, cServerIP, cConxn )
   METHOD update()

   FRIEND CLASS DbuMGR

   ENDCLASS


METHOD DashBoard:new( oDbuMGR, cServerIP, cConxn )
   LOCAL n, cSrv, oLabel

   ::oDbuMGR := oDbuMGR
   ::cServerIP := cServerIP
   ::cConxn    := cConxn

   n    := RAt( ".", ::cServerIP )
   cSrv := SubStr( ::cServerIP, n+1 )

   ::oWidget   := QFrame()

   ::oLay      := QVBoxLayout( ::oWidget )
   ::oLay:setContentsMargins( 0,0,0,0 )
   ::oLay:setSpacing( 0 )

   ::oWidget   :  setLayout( ::oLay )

   ::oFrameTop := QFrame( ::oWidget )
   ::oFrameTop:setMaximumHeight( 50 )
   ::oFrameBtm := QFrame( ::oWidget )
   ::oFrameBtm:setMaximumHeight( 35 )

   ::oHLay     := QHBoxLayout( ::oFrameTop )
   ::oHLayD    := QHBoxLayout( ::oFrameBtm )

   ::oLay      :  addWidget( ::oFrameTop )
   ::oLay      :  addWidget( ::oFrameBtm )

   ::oHLay:setSpacing( 0 )

   ::oHLay:addStretch( 0 )
   FOR n := 1 TO Len( cSrv )
      WITH OBJECT oLabel := QLabel( ::oWidget )
         :setPixmap( QPixmap( ":/dbu/resources/n-" + SubStr( cSrv, n, 1 ) + ".png" ):scaled( 24,24 ) )
         :setTooltip( ::cServerIP + "  " + ::cConxn )
      ENDWITH
      ::oHLay:addWidget( oLabel )
   NEXT
   ::oHLay:addStretch( 0 )

   WITH OBJECT ::oLabelLic       := QLabel()
      :setAlignment( Qt_AlignRight + Qt_AlignVCenter )
      :setStyleSheet( "background-color: pink;" )
   ENDWITH
   WITH OBJECT ::oLabelLicUsed   := QLabel()
      :setAlignment( Qt_AlignRight + Qt_AlignVCenter )
      :setStyleSheet( "background-color: lightblue;" )
   ENDWITH
   WITH OBJECT ::oLabelLockAvail := QLabel()
      :setAlignment( Qt_AlignRight + Qt_AlignVCenter )
      :setStyleSheet( "background-color: lightgreen;" )
   ENDWITH
   WITH OBJECT ::oLabelLockUsed  := QLabel()
      :setAlignment( Qt_AlignRight + Qt_AlignVCenter )
      :setStyleSheet( "background-color: cyan;" )
   ENDWITH
   WITH OBJECT ::oLabelLocks     := QLabel()
      :setAlignment( Qt_AlignRight + Qt_AlignVCenter )
      :setStyleSheet( "background-color: yellow;" )
   ENDWITH

   ::oHLayD:addWidget( ::oLabelLic       )
   ::oHLayD:addWidget( ::oLabelLicUsed   )
   ::oHLayD:addWidget( ::oLabelLockAvail )
   ::oHLayD:addWidget( ::oLabelLockUsed  )
   ::oHLayD:addWidget( ::oLabelLocks     )

   ::update()

   RETURN Self


METHOD DashBoard:update()
#ifdef __CACHE__
   LOCAL cText, aLInfo
   LOCAL nConxn    := ::oDbuMGR:hConxns[ ::cConxn + "_Connection" ]
   LOCAL a_        := CacheGetLicenseInfo( nConxn )
   LOCAL cLockInfo := CacheGetLockTableInfo( nConxn )
   LOCAL cLockList := CacheGetLockList( nConxn )

   aLInfo := hb_ATokens( cLockInfo, "," )
   ASize( aLInfo, 4 )
   DEFAULT aLInfo[1] TO "0"
   DEFAULT aLInfo[2] TO "0"
   DEFAULT aLInfo[3] TO "0"
   DEFAULT aLInfo[4] TO "0"

   cText := a_[ 6 ]
   ::oLabelLic       : setText( cText )
   cText := a_[ 11 ]
   ::oLabelLicUsed   : setText( cText )
   cText := aLInfo[ 2 ]
   ::oLabelLockAvail : setText( cText )
   cText := aLInfo[ 4 ]
   ::oLabelLockUsed  : setText( cText )
   cText := cLockList
   ::oLabelLocks     : setText( cText )
#endif
   RETURN Self


FUNCTION dbu_help( nOption )
   LOCAL txt_:= {}
   LOCAL cTitle, s

   SWITCH nOption
   CASE 1
      cTitle := 'About HbDBU'
      AAdd( txt_, "<b>Harbour DBU ( HbDBU )</b>" )
      AAdd( txt_, "Developed by" )
      AAdd( txt_, "Pritpal Bedi ( bedipritpal@hotmail.com )" )
      AAdd( txt_, "" )
      AAdd( txt_, "built with:" )
      AAdd( txt_, "QtContribs " + " r" + "145" )
      AAdd( txt_, HB_COMPILER() )
      AAdd( txt_, "Qt " + QT_VERSION_STR() )
      AAdd( txt_, "" )
      AAdd( txt_, "Visit the project website at:" )
      AAdd( txt_, "<a href='http://harbour-project.org/'>http://harbour-project.org/</a>" )
      AAdd( txt_, "<a href='http://hbide.vouch.info/'>http://hbide.vouch.info/</a>" )
      EXIT

   CASE 2
      cTitle := 'Mailing List'
      AAdd( txt_, "<b>Harbour Development Mailing List</b>" )
      AAdd( txt_, "" )
      AAdd( txt_, "Please visit the home page:" )
      AAdd( txt_, "<a href='http://groups.google.com/group/harbour-devel/'>http://groups.google.com/group/harbour-devel/</a>" )
      AAdd( txt_, "" )
      AAdd( txt_, "<b>QtContribs Developers/Users Mailing List</b>" )
      AAdd( txt_, "" )
      AAdd( txt_, "<a href='http://groups.google.com/group/qtcontribs/'>http://groups.google.com/group/qtcontribs/</a>" )
      EXIT

   CASE 4
      cTitle := 'About Harbour'
      AAdd( txt_, "<b>About Harbour</b>" )
      AAdd( txt_, "" )
      AAdd( txt_, '"Harbour is the Free Open Source Software implementation' )
      AAdd( txt_, 'of a multi-platform, multi-threading, object-oriented, scriptable' )
      AAdd( txt_, 'programming language, backwards compatible with Clipper/xBase.' )
      AAdd( txt_, 'Harbour consists of a compiler and runtime libraries with multiple' )
      AAdd( txt_, 'UI and database backends, its own make system and a large' )
      AAdd( txt_, 'collection of libraries and interfaces to many popular APIs."' )
      AAdd( txt_, "" )
      AAdd( txt_, "Get downloads, samples, contribs and much more at:" )
      AAdd( txt_, "<a href='http://harbour-project.org/'>http://harbour-project.org/</a>" )
      EXIT

   END

   IF !Empty( txt_ )
      s := ""
      AEval( txt_, {|e| s += e + Chr( 10 ) } )
      HbQtMsgBox( s, cTitle )
   ENDIF

   RETURN nil

