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

   DATA   oExitAct
   DATA   oDashAct

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
   METHOD configureBrowser( oHbQtBrowse, oMdiBrowse )
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

   ENDCLASS


METHOD DbuMGR:new( aParams )

   hb_HCaseMatch( ::hConxns , .F. )
   hb_HCaseMatch( ::hDbuData, .F. )

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
      ::openConnections( hb_ATokens( ::hDbuData[ "CacheServer" ], "|" ) )
   ENDIF

   RETURN Self


METHOD DbuMGR:create()

   WITH OBJECT ::oWidget := hbqtui_dbu()
      :dockCache:hide()
      :dockAdvantage:hide()

      :setWindowIcon( ::getImage( "cube" ) )
#ifdef __CACHE__
      :setWindowTitle( "CacheMGR - " + ::hConxns[ "Default_ServerIP" ] )
#else
      :setWindowTitle( "HbDBU" )
#endif
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

   WITH OBJECT ::oToolbar := QToolBar( ::oWidget:oWidget )
      :setObjectName( "MainToolBar" )
      :setIconSize( QSize( 24,24 ) )
      :addAction( ::oExitAct )
      :addAction( ::oDashAct )
   ENDWITH
   ::oWidget:addToolbar( Qt_TopToolBarArea, ::oToolbar )

   WITH OBJECT ::oDbu := HbQtDBU():new():create( ::oWidget:stackedWidget )
      :connectionsBlock     := {|cDriver                     | ::setMyConnections( cDriver )                   }
      :selectTableBlock     := {|cDriver,xConxn,oDbu         | ::selectMyTable( cDriver, xConxn, oDbu )        }
      :openTableBlock       := {|cTable,cAlias,cDriver,cConxn| ::openMyTable( cTable,cAlias,cDriver,cConxn )   }
      :existsTableBlock     := {|cTable,cDriver,cConxn       | ::checkIfTableExists( cTable, cDriver, cConxn ) }
      :populateTreeBlock    := {|cTable,cDriver,cConxn       | ::populateTree( cTable,cDriver,cConxn )         }
      :browseConfigureBlock := {|oBrowse,oMdiBrowse,oDbu     | ::configureBrowser( oBrowse, oMdiBrowse, oDbu ) }
#if defined(__CACHE__) .AND. defined(__ADS__)
      :rddsBlock         := {|| { "CACHERDD","ADS" } }
#else
 #if defined(__CACHE__)
      :rddsBlock         := {|| { "CACHERDD" } }
 #else
  #if defined(__ADS__)
      :rddsBlock         := {|| { "ADS" } }
  #endif
 #endif
#endif
   ENDWITH
   ::oWidget:stackedWidget:addWidget( ::oDbu:oWidget )
   ::oWidget:stackedWidget:setCurrentIndex( 1 )

   ::restEnvironment()
   ::oWidget:dockCache:hide()
   ::oWidget:show()
   ::oDbu:tablesStructureEnabled := .F.

   ::populateProdTables()

   RETURN Self


METHOD DbuMGR:exit( lAsk, oEvent )
   LOCAL lExit := .T.

   IF lAsk
      lExit := Alert( "Exit DbuMGR ?", { "Yes", "No" } ) == 1
   ENDIF
   IF HB_ISOBJECT( oEvent )
      oEvent:ignore()
   ENDIF
   IF lExit
      ::saveEnvironment()
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
            IF hb_HHasKey( ::hDbuData, cKey )
               ::hDbuData[ cKey ] := ::hDbuData[ cKey ] + cValue
            ELSE
               ::hDbuData[ cKey ] := cValue
            ENDIF
         ENDIF
      ENDIF
   NEXT

   RETURN Self


METHOD DbuMGR:populateProdTables()
   LOCAL aTables := {}, cTables, cTable, OpenViaCache

   IF ! ::lCache
      RETURN NIL
   ENDIF

   OpenViaCache := hb_ATokens( ::hDbuData[ "OpenViaCache" ], ";" )
   FOR EACH cTables IN OpenViaCache
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


METHOD DbuMGR:configureBrowser( oHbQtBrowse, oMdiBrowse )

   WITH OBJECT oHbQtBrowse
      :horizontalScrollbar := .T.
      :verticalScrollbar   := .F.
      :toolbar             := .T.
      :statusbar           := .F.
      :editBlock           := {|aMod,aData,oBrw   | ::saveRecord( aMod, aData, oBrw, oMdiBrowse )     }
      :searchBlock         := {|xValue,nMode,oBrw | ::manageSearch( xValue, nMode, oBrw, oMdiBrowse ) }
      :navigationBlock     := {|nKey,xData,oBrw   | ::handleOptions( nKey, xData, oBrw, oMdiBrowse )  }
      :helpBlock           := {|                  | { ::helpInfo(), 0 } }
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


METHOD DbuMGR:manageSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )
   HB_SYMBOL_UNUSED( xValue )
   HB_SYMBOL_UNUSED( nMode )
   HB_SYMBOL_UNUSED( oHbQtBrowse )
   HB_SYMBOL_UNUSED( oMdiBrowse )
   RETURN .T.


METHOD DbuMGR:handleOptions( nKey, xData, oHbQtBrowse, oMdiBrowse )
   LOCAL i, xResult, nRec, xValue
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )

   oMdiBrowse:dispInfo()

   DO CASE
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

   CASE nKey == K_ENTER
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

   CASE nKey == K_ALT_F5                          /* Add Column */

   OTHERWISE
      lHandelled := .F.
   ENDCASE

   RETURN lHandelled


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

   aadd( v_, 'F2      NatOrd    Sets the index to 0 for natural record order' )
   aadd( v_, 'F3      Order                            Set a new index order' )
   aadd( v_, 'F4      Goto                  Goto a specific record by number' )
   aadd( v_, 'F5      Scroll     Auto scrolls the browser current-bottom-top' )
   aadd( v_, 'F7      Seek              Search for a record by Current Index' )
   aadd( v_, 'F8      Freeze                        Freezes leftmoost column' )
   aadd( v_, 'F10     Lock           Toggles locks status of currents record' )
   aadd( v_, 'Sh+F8   UnFreeze                 UnFreezes last freezed column' )
   aadd( v_, 'Sh+F5   MoveRight      Moves current column right one position' )
   aadd( v_, 'Sh+F6   MoveLeft         Moves current column left on position' )
   aadd( v_, 'Alt+F5  InsColumn            Insert column at current location' )
   aadd( v_, 'Alt+F6  DelColumn           Deletes currently hilighted column' )
   aadd( v_, '                                                              ' )
   aadd( v_, 'ENTER   Edit                                 Edit current cell' )
   aadd( v_, '                                                              ' )
   aadd( v_, 'Alt_E                                                Seek Last' )
   aadd( v_, 'Alt_Y                                                Seek Soft' )
   aadd( v_, 'ALT_Z                                             Skip Records' )
   aadd( v_, 'Alt_F                                             Set a Filter' )
   aadd( v_, 'Alt_R                                             Clear Filter' )
   aadd( v_, 'Alt_P                                                Set Scope' )
   aadd( v_, 'Alt_O                                              Clear Scope' )
   aadd( v_, 'Alt_INS                                  Append a blank Record' )
   aadd( v_, 'Alt_DEL                                  Delete Current Record' )
   aadd( v_, 'Alt_T                                          Show Statistics' )
   aadd( v_, 'Alt_V                                        Performance Stats' )
   aadd( v_, 'Alt_X                                     Sum Average High Low' )
   aadd( v_, 'Ctrl_F1                                          Find in field' )
   aadd( v_, '                                                              ' )
   aadd( v_, 'Alt_L                                      Lock Current Record' )
   aadd( v_, 'Alt_U                                    Unlock Current Record' )
   aadd( v_, 'Alt_K                                Unlock a Selective Record' )
   aadd( v_, 'Alt_S                                   List of Locked Records' )
   aadd( v_, 'Alt_I                                                Lock Info' )
   aadd( v_, 'Alt_G                                     List of Global Locks' )
   aadd( v_, 'Alt_X                                Lock Info Column (Toggle)' )

   RETURN v_


METHOD DbuMGR:saveEnvironment()
   LOCAL oSettings
   LOCAL cFile := ::getPath( "settings.dbu" )

   oSettings := QSettings( cFile, QSettings_IniFormat )
   oSettings:setValue( "dbusettings", QVariant( ::oWidget:oWidget:saveState() ) )

   RETURN NIL


METHOD DbuMGR:restEnvironment()
   LOCAL oSettings
   LOCAL cFile := ::getPath( "settings.dbu" )

   oSettings := QSettings( cFile, QSettings_IniFormat )
   ::oWidget:oWidget:restoreState( oSettings:value( "dbusettings" ):toByteArray() )

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

