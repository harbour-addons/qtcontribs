/*
 * $Id$
 */

/*
 * Copyright 2014-2015 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                              ideDbuMgr
 *
 *                             Pritpal Bedi
 *                              26Jul2014
 */
/*----------------------------------------------------------------------*/

#include "inkey.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbide.ch"

REQUEST Descend
REQUEST Stuff
REQUEST StrTran
REQUEST RAt
REQUEST Left
REQUEST Right
REQUEST Pad
REQUEST PadC
REQUEST PadL
REQUEST PadR
REQUEST AllTrim
REQUEST Transform


CREATE CLASS ideDbuMGR INHERIT IdeObject

   DATA   oIde
   DATA   oDbu
   DATA   oContextMenu

   DATA   cSettingsPath                           INIT ""
   DATA   cSettingsFile                           INIT "settings.dbu"
   DATA   cDefaultRDD                             INIT "DBFCDX"

   METHOD new( oIde )
   METHOD create( oIde )
   METHOD configureBrowser( oHbQtBrowse, oMdiBrowse, oDBU )
   METHOD saveRecord( aMod, aData, oHbQtBrowse, oMdiBrowse )
   METHOD manageSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )
   METHOD manageExSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )
   METHOD handleOptions( nKey, xData, oHbQtBrowse, oMdiBrowse, oDbu )
   METHOD getSearchValue( oMdiBrowse, xValue )
   METHOD helpInfo()
   METHOD manageContextMenu( aPos, oHbQtBrowse, oMdiBrowse, oDbu )
   METHOD showStats( oMdiBrowse )

   ENDCLASS


METHOD ideDbuMGR:new( oIde )

   ::oIde := oIde

   SetKey( K_INS, {|| ReadInsert( ! ReadInsert() ) } )
   ReadInsert( .T. )

   RETURN Self


METHOD ideDbuMGR:create( oIde )

   DEFAULT oIde TO ::oIde
   ::oIde := oIde

   WITH OBJECT ::oDbu := HbQtDBU():new():create( ::oParts:oStackDbu )
      :browseConfigureBlock := {|oBrowse,oMdiBrowse,oDbu| ::configureBrowser( oBrowse, oMdiBrowse, oDbu ) }
   ENDWITH
   ::oParts:addWidget( IDE_PART_DBU, ::oDbu:oWidget, 0, 0, 1, 1 )

   ::oDbu:clearTablesTree()
   ::oDbu:restEnvironment()                            // explore how it be linked with HbIDE parameters

   ::oDbu:oWidget:show()
   RETURN Self


METHOD ideDbuMGR:configureBrowser( oHbQtBrowse, oMdiBrowse, oDBU )
   WITH OBJECT oHbQtBrowse
      :horizontalScrollbar := .T.
      :verticalScrollbar   := .T.
      :toolbar             := .T.
      :toolbarLeft         := .T.
      :statusbar           := .F.
      :editBlock           := {|aMod,aData,oBrw  | ::saveRecord( aMod, aData, oBrw, oMdiBrowse )     }
      :searchBlock         := {|xValue,nMode,oBrw| ::manageSearch( xValue, nMode, oBrw, oMdiBrowse ) }
      :searchExBlock       := {|xValue,nMode,oBrw| ::manageExSearch( xValue, nMode, oBrw, oMdiBrowse ) }
      :navigationBlock     := {|nKey,xData,oBrw  | ::handleOptions( nKey, xData, oBrw, oMdiBrowse, oDbu )  }
      :helpBlock           := {|                 | { ::helpInfo(), 0 } }
      :contextMenuBlock    := {|aPos             | ::manageContextMenu( aPos, oHbQtBrowse, oMdiBrowse, oDbu ) }
   ENDWITH
   RETURN NIL


METHOD ideDbuMGR:saveRecord( aMod, aData, oHbQtBrowse, oMdiBrowse )
   LOCAL cColumn, n, nField, aStruct

   HB_SYMBOL_UNUSED( oHbQtBrowse )

   IF oMdiBrowse:lock()
      FOR EACH cColumn IN aData[ 2 ]
         n := cColumn:__enumIndex()
         IF aMod[ n ] != aData[ 1, n ]   /* DATA Changed or Not */
            aStruct     := oMdiBrowse:dbStruct()
            IF ( nField := AScan( aStruct, {|e_| e_[ 1 ] == cColumn } ) ) > 0
               REPLACE ( oMdiBrowse:alias() )->&( aStruct[ nField,1 ] ) WITH aMod[ n ]
            ENDIF
         ENDIF
      NEXT
      ( oMdiBrowse:alias() )->( dbCommit() )
      oMdiBrowse:unlock()
      oMdiBrowse:refreshAll()
   ENDIF

   RETURN .T.


METHOD ideDbuMGR:manageExSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )
   LOCAL nRec

   HB_SYMBOL_UNUSED( nMode )

   IF oMdiBrowse:indexOrd() > 0
      nRec := ( oMdiBrowse:alias() )->( RecNo() )

      SWITCH oMdiBrowse:indexKeyType()
      CASE "C" ; xValue := xValue                 ; EXIT
      CASE "N" ; xValue := Val( xValue )          ; EXIT
      CASE "D" ; xValue := CToD( xValue )         ; EXIT
      CASE "L" ; xValue := Lower( xValue ) $ "ty" ; EXIT
      ENDSWITCH

      IF ! ( oMdiBrowse:alias() )->( dbSeek( xValue ) )
         ( oMdiBrowse:alias() )->( dbGoto( nRec ) )
      ELSE
         oHbQtBrowse:refreshAll()
      ENDIF
   ENDIF

   RETURN NIL


METHOD ideDbuMGR:manageSearch( xValue, nMode, oHbQtBrowse, oMdiBrowse )

   IF xValue == NIL .AND. oHbQtBrowse == NIL
      // Nothing TO do
   ELSEIF xValue == NIL
      IF oMdiBrowse:indexOrd() > 0
         xValue := __hbqtGetBlankValue( oMdiBrowse:indexKeyValue() )
         RETURN { xValue, "@ ", HBQTBRW_SEARCH_INCREMENTAL }
      ELSE
         RETURN { __hbqtGetBlankValue( Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block ) ), NIL, HBQTBRW_SEARCH_BYFIELD }
      ENDIF
   ELSE
      IF oMdiBrowse:indexOrd() > 0
         oMdiBrowse:search( xValue )
      ELSEIF nMode == HBQTBRW_SEARCH_BYFIELD
         RETURN Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block ) = xValue
      ENDIF
   ENDIF

   RETURN .T.


METHOD ideDbuMGR:handleOptions( nKey, xData, oHbQtBrowse, oMdiBrowse, oDbu )
   LOCAL i, xResult, nRec, xValue, aRecList, aList //, aStr, aMnu, oCol
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )
   HB_SYMBOL_UNUSED( oDbu )

   oMdiBrowse:dispInfo()

   DO CASE
   CASE nKey == K_ALT_O
      oHbQtBrowse:activateIndexMenu()

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
      oHbQtBrowse:activateColumnsMenu()

   CASE nKey == K_ALT_P                           /* SET SCOPE */
      IF oMdiBrowse:indexOrd() > 0
         oMdiBrowse:setScope()
      ELSE
         Alert( "Please set an index on current table !" )
      ENDIF

   CASE nKey == K_ALT_W                           /* clear SCOPE */
      IF oMdiBrowse:indexOrd() > 0
         oMdiBrowse:clearScope()
      ENDIF

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
      oMdiBrowse:setFilter()

   CASE nKey == K_ALT_R                           /* clear FILTER */
      oMdiBrowse:clearFilter()
      oMdiBrowse:goTop()

   CASE nKey == K_ALT_T
      ::showStats( oMdiBrowse )

   CASE nKey == K_ENTER
      IF oMdiBrowse:lock()
         xResult := oHbQtBrowse:editCell()
         IF xResult != NIL
            Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block, xResult )      /* Even this is not required, or DBU must not set the SETGET block, just the GET block */
            dbCommit()
            oHbQtBrowse:refreshCurrent()
         ENDIF
         oMdiBrowse:unLock()
      ENDIF

   CASE nKey == K_ALT_ENTER
      IF oMdiBrowse:lock()
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
         oMdiBrowse:dbCommit()
         oMdiBrowse:unLock()
      ENDIF

   CASE nKey == K_CTRL_ENTER
      DO WHILE .T.
         IF oMdiBrowse:lock()
            xResult := oHbQtBrowse:editCell()
            IF xResult == NIL
               EXIT
            ENDIF
            Eval( oHbQtBrowse:getColumn( oHbQtBrowse:colPos ):block, xResult )
            dbCommit()
            oMdiBrowse:unlock()
            oHbQtBrowse:refreshCurrent()
            oHbQtBrowse:down()
            IF oHbQtBrowse:hitBottom
               EXIT
            ENDIF
         ENDIF
      ENDDO

   CASE nKey == K_CTRL_F1
      oHbQtBrowse:search( NIL, NIL, HBQTBRW_SEARCH_BYFIELD )

   CASE nKey >= 32 .AND. nKey <= 127 .AND. oMdiBrowse:indexOrd() > 0
      oHbQtBrowse:searchEx( Chr( nKey ) )

   OTHERWISE
      lHandelled := .F.

   ENDCASE

   RETURN lHandelled


METHOD ideDbuMGR:manageContextMenu( aPos, oHbQtBrowse, oMdiBrowse, oDbu )
   LOCAL oContextMenu

   HB_SYMBOL_UNUSED( oDbu )

   WITH OBJECT oContextMenu := HbQtMenu():new():create()
      :addItem( { "Seek"           , {||
                                        LOCAL xValue
                                        IF ::getSearchValue( oMdiBrowse, @xValue )
                                           oMdiBrowse:search( xValue, .F., .F. )
                                           oMdiBrowse:dispInfo()
                                        ENDIF
                                        RETURN NIL
                                     } } )
      :addItem( { "Search in Field", {|| oHbQtBrowse:search( NIL, NIL, HBQTBRW_SEARCH_BYFIELD ) } } )
      :addItem( { "Scroll"         , {|| oHbQtBrowse:Scroll() } } )
      :addItem( { "Show Stat"      , {|| ::showStats( oMdiBrowse ) } } )
      :addItem( { "Natural Order " , {|| oMdiBrowse:setOrder( 0 ), oMdiBrowse:dispInfo() } } )
      :addItem( { "Index Order"    , {|| oHbQtBrowse:activateIndexMenu() } } )
      :addItem( {} )
      :addItem( { "Set Scope"      , {|| iif( oMdiBrowse:indexOrd() > 0, oMdiBrowse:setScope(), Alert( "Please set an index on current table !" ) ) } } )
      :addItem( { "Clear Scope"    , {|| iif( oMdiBrowse:indexOrd() > 0, oMdiBrowse:clearScope(), NIL ) } } )
      :addItem( { "Set Filter"     , {|| oMdiBrowse:setFilter() } } )
      :addItem( { "Clear Filter"   , {|| oMdiBrowse:clearFilter() } } )
      :addItem( {} )
      :addItem( { "Lock Record"    , {|| iif( oMdiBrowse:lock(), NIL, Alert( "Could not lock record!" ) ) } } )
      :addItem( { "UnLock Record"  , {|| iif( oMdiBrowse:unLock(), NIL, Alert( "Could not unlock record!" ) ) } } )
      :addItem( {} )
      :addItem( { "Add Record"     , {|| oMdiBrowse:append() } } )
      :addItem( { "Delete Record"  , {|| oMdiBrowse:delete( .T. ) } } )
   ENDWITH

   oContextMenu:popUp( aPos )

   RETURN Self


METHOD ideDbuMGR:showStats( oMdiBrowse )
   LOCAL aStats := {}

   aadd( aStats, pad( '   Generic'                                    ,                32 ) + "." )
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


METHOD ideDbuMGR:getSearchValue( oMdiBrowse, xValue )
   IF oMdiBrowse:indexOrd() > 0
      xValue := oMdiBrowse:indexKeyValue()
      IF ( xValue := HbQtBulkGet( xValue, oMdiBrowse:IndexKey() ) ) != NIL
         xValue := iif( ValType( xValue ) == "C", Trim( xValue ), xValue )
         RETURN .T.
      ENDIF
   ENDIF
   RETURN .F.


METHOD ideDbuMGR:helpInfo()
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
   aadd( v_, 'Ctrl_F1                                 Find in field' )
   aadd( v_, '                                                     ' )
   aadd( v_, 'Alt_L                             Lock Current Record' )
   aadd( v_, 'Alt_U                           Unlock Current Record' )
   aadd( v_, 'Alt_K                       Unlock a Selective Record' )
   aadd( v_, 'Alt_S                          List of Locked Records' )

   RETURN v_

