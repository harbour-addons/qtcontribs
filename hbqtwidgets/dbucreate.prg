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
 *                    Extension Harbour HbQtDBU Class
 *
 *                             Pritpal Bedi
 *                              26Feb2013
 */
/*----------------------------------------------------------------------*/

#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"

/*----------------------------------------------------------------------*/

CLASS HbQtCreateTable

   DATA   oDbu
   DATA   oWidget
   DATA   oLbl
   DATA   oComboRDD, oComboConxn
   DATA   oBrwStruct, oBrwIndex
   DATA   oBtnOK, oBtnCN

   METHOD new( oDbu )
   METHOD create()
   METHOD createIndexesBrowser( oBrowse, aData )
   METHOD createStructBrowser( oBrowse, aData )
   METHOD navigateStructBrowser( nKey, xData, oBrw, nType )
   METHOD createTable()
   METHOD pasteStruct()
   METHOD dispInfo()

   ENDCLASS


METHOD HbQtCreateTable:new( oDbu )

   ::oDbu := oDbu

   RETURN Self


METHOD HbQtCreateTable:create()
   LOCAL oLay, oHLay1, oHLay2, oBrwStruct
   LOCAL aData, oBrwIndex, aIndex
   LOCAL nW := 256 + 17

   WITH OBJECT oHLay1 := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 10 )
   ENDWITH
   WITH OBJECT oHLay2 := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 10 )
   ENDWITH
   WITH OBJECT oLay := QVBoxLayout()
      //
   ENDWITH

   WITH OBJECT ::oWidget := QWidget( ::oDbu:oWidget )
      :setWindowFlags( Qt_Sheet )
      :setWindowTitle( "Create a Table" )
      :setWindowIcon( QIcon( __hbqtImage( "table-add" ) ) )
      :setLayout( oLay )
      :setMaximumWidth( nW )
      :setMinimumWidth( nW )
      :connect( QEvent_Close, {|| ::oWidget:setParent( QWidget() ) } )
      :resize( nW, 500 )
      :setObjectName( Upper( __hbqtGetNextIdAsString( "CreateTable" ) ) )
   ENDWITH

   WITH OBJECT ::oComboConxn := QComboBox( ::oWidget )
      :setTooltip( "Connection to create this table." )
   ENDWITH
   WITH OBJECT ::oComboRDD := QComboBox( ::oWidget )
      ::oDbu:loadRddsCombo( ::oComboRDD )
      :setTooltip( "Rdd Driver to create this table." )
      :connect( "currentIndexChanged(QString)", {|p| ::oDbu:loadConxnCombo( p, ::oComboConxn ) } )
   ENDWITH
   oHLay1:addWidget( ::oComboRDD )
   oHLay1:addWidget( ::oComboConxn )
   oLay:addLayout( oHLay1 )

   oBrwStruct := HbQtBrowseNew( 0, 0, 0, 0, ::oWidget )
   ::createStructBrowser( oBrwStruct, @aData )
   oLay:addWidget( oBrwStruct:oWidget )

   WITH OBJECT ::oLbl := QLabel( ::oWidget )
      :setMinimumHeight( 20 )
      :setMaximumHeight( 20 )
      :setObjectName( "LABELSTRUCTINFO" )
   ENDWITH
   oLay:addWidget( ::oLbl )

   oBrwIndex := HbQtBrowseNew( 0, 0, 0, 0, ::oWidget )
   ::createIndexesBrowser( oBrwIndex, @aIndex )
   oLay:addWidget( oBrwIndex:oWidget )

   WITH OBJECT ::oBtnOK := QPushButton( ::oWidget )
      :setText( "Create" )
      :connect( "clicked()", {|| ::createTable() } )
   ENDWITH
   WITH OBJECT ::oBtnCN := QPushButton( ::oWidget )
      :setText( "Cancel" )
      :connect( "clicked()", {|| ::oWidget:close() } )
   ENDWITH
   oHLay2:addStretch()
   oHLay2:addWidget( ::oBtnOK )
   oHLay2:addWidget( ::oBtnCN )

   oLay:addLayout( oHLay2 )

   ::oWidget:show()

   oBrwStruct:setFocus()

   ::oBrwStruct := oBrwStruct
   ::oBrwIndex := oBrwIndex

   RETURN Self


METHOD HbQtCreateTable:createIndexesBrowser( oBrowse, aData )
   LOCAL n := 1

   aData := {}
   AAdd( aData, { Space( 10 ), Space( 100 ) } )

   oBrowse:GoTopBlock    := {|| n := 1 }
   oBrowse:GoBottomBlock := {|| n := Len( aData ) }
   oBrowse:SkipBlock     := {| nSkip, nPos | nPos := n, ;
                                 n := iif( nSkip > 0, Min( Len( aData ), n + nSkip ), ;
                                    Max( 1, n + nSkip ) ), n - nPos }

   oBrowse:firstPosBlock := {| | 1            }
   oBrowse:lastPosBlock  := {| | Len( aData ) }
   oBrowse:posBlock      := {| | n            }
   oBrowse:goPosBlock    := {|i| n := i       }
   oBrowse:phyPosBlock   := {| | n            }
   oBrowse:gotoBlock     := {|i| n := i       }

   oBrowse:AddColumn( HbQtColumnNew( "Sr"          , {|| n } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Tag"         , {|x| iif( x == NIL, aData[ n,1 ], aData[ n,1 ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Expression"  , {|x| iif( x == NIL, aData[ n,2 ], aData[ n,2 ] := x ) } ) )

   WITH OBJECT oBrowse:getColumn( 1 )
      :picture := "@Z 99"
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 2 )
      :picture := "@!"
      :postBlock := {|v| v := Trim( GetActive():varGet() ), ! Empty( v ) .AND. ! ( " " $ v ) }
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 3 )
      :picture := "@S14"
      :postBlock := {|| ! Empty( GetActive():varGet() ) }
   ENDWITH

   oBrowse:editEnabled   := .F.
   oBrowse:verticalScrollbar := .T.

   oBrowse:Configure()
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  ::navigateStructBrowser( nKey, xData, oBrw, 2 )  }

   oBrowse:cargo := aData
   oBrowse:oWidget:setMaximumHeight( 100 )

   RETURN Self


METHOD HbQtCreateTable:createStructBrowser( oBrowse, aData )
   LOCAL n := 1

   aData := {}
   AAdd( aData, { Space( 10 ), "C", 10, 0 } )

   oBrowse:GoTopBlock    := {|| n := 1 }
   oBrowse:GoBottomBlock := {|| n := Len( aData ) }
   oBrowse:SkipBlock     := {| nSkip, nPos | nPos := n, ;
                                 n := iif( nSkip > 0, Min( Len( aData ), n + nSkip ), ;
                                    Max( 1, n + nSkip ) ), n - nPos }

   oBrowse:firstPosBlock := {| | 1            }
   oBrowse:lastPosBlock  := {| | Len( aData ) }
   oBrowse:posBlock      := {| | n            }
   oBrowse:goPosBlock    := {|i| n := i       }
   oBrowse:phyPosBlock   := {| | n            }
   oBrowse:gotoBlock     := {|i| n := i       }

   oBrowse:AddColumn( HbQtColumnNew( "Sr"    , {|| n } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Name"  , {|x| iif( x == NIL, aData[ n,1 ], aData[ n,1 ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Type"  , {|x| iif( x == NIL, aData[ n,2 ], aData[ n,2 ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Len"   , {|x| iif( x == NIL, aData[ n,3 ], aData[ n,3 ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Dec"   , {|x| iif( x == NIL, aData[ n,4 ], aData[ n,4 ] := x ) } ) )

   WITH OBJECT oBrowse:getColumn( 1 )
      :picture := "@Z 999"
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 2 )
      :picture := "@!S10"
      :postBlock := {|v| v := Trim( GetActive():varGet() ), ! Empty( v ) .AND. ! ( " " $ v ) }
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 3 )
      :picture := "@! A"
      :postBlock := {|| GetActive():varGet() $ "CDNL" }
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 4 )
      :picture := "@Z 9999"
      :postBlock := {|| GetActive():varGet() > 0 }
      :preBlock  := {||
                        LOCAL v := iif( aData[ n,2 ] == "L", 1, iif( aData[ n,2 ] == "D", 8, NIL ) )
                        IF v != NIL
                           GetActive():varPut( v )
                           GetActive():display()
                           __hbqtKeyboard( K_ENTER )
                        ENDIF
                        RETURN .T.
                    }
   ENDWITH
   WITH OBJECT oBrowse:getColumn( 5 )
      :picture   := "@Z 99"
      :postBlock := {|| iif( aData[ n,2 ] == "N", GetActive():varGet() >= 0, GetActive():varGet() == 0 ) }
      :preBlock  := {||
                        IF aData[ n,2 ] != "N"
                           __hbqtKeyboard( K_ENTER )
                        ENDIF
                        RETURN .T.
                    }
   ENDWITH

   oBrowse:editEnabled       := .F.
   oBrowse:verticalScrollbar := .T.
   oBrowse:colPos            := 2
   oBrowse:Configure()
   oBrowse:navigationBlock   := {|nKey,xData,oBrw|  ::navigateStructBrowser( nKey, xData, oBrw, 1 )  }

   oBrowse:cargo := aData
   RETURN Self


METHOD HbQtCreateTable:navigateStructBrowser( nKey, xData, oBrw, nType )
   LOCAL lHandelled := .T.
   LOCAL lDone := .F.
   LOCAL oBrowse := oBrw
   LOCAL i, n, xResult, aRow

   HB_SYMBOL_UNUSED( xData )

   DO CASE
   CASE nKey == K_ENTER
      IF nType == 1
         DO WHILE .T.
            ::dispInfo()
            oBrowse:panHome()
            oBrowse:Right()
            FOR i := 2 TO 5
               xResult := oBrowse:editCell()  /* HbQt Entention */
               IF xResult == NIL
                  lDone := .T.
                  IF Empty( Eval( oBrowse:getColumn( 2 ):block ) )
                     IF Len( oBrowse:cargo ) > 1
                        n := Eval( oBrowse:getColumn( 1 ):block )
                        hb_ADel( oBrowse:cargo, n, .T. )
                        oBrowse:refreshAll()
                     ENDIF
                  ENDIF
                  EXIT                        /* Sure ESCape is pressed */
               ENDIF
               Eval( oBrowse:getColumn( oBrowse:colPos ):block, xResult )
               IF i < 5
                  oBrowse:Right()
               ELSE
                  oBrowse:down()
                  IF oBrowse:hitBottom()
                     AAdd( oBrowse:cargo, { Space( 10 ), "C", 10, 0 } )
                     oBrowse:refreshAll()
                     oBrowse:goBottom()
                  ENDIF
               ENDIF
            NEXT
            IF lDone
               EXIT
            ENDIF
         ENDDO

      ELSEIF nType == 2
         DO WHILE .T.
            oBrowse:panHome()
            oBrowse:Right()
            FOR i := 1 TO 2
               xResult := oBrowse:editCell()  /* HbQt Entention */
               IF xResult == NIL
                  lDone := .T.
                  IF Empty( Eval( oBrowse:getColumn( 2 ):block ) )
                     IF Len( oBrowse:cargo ) > 1
                        n := Eval( oBrowse:getColumn( 1 ):block )
                        hb_ADel( oBrowse:cargo, n, .T. )
                        oBrowse:refreshAll()
                     ENDIF
                  ENDIF
                  EXIT                        /* Sure ESCape is pressed */
               ENDIF
               Eval( oBrowse:getColumn( oBrowse:colPos ):block, xResult )
               IF i < 2
                  oBrowse:Right()
               ELSE
                  oBrowse:down()
                  IF oBrowse:hitBottom()
                     AAdd( oBrowse:cargo, { Space( 10 ), Space( 100 ) } )
                     oBrowse:refreshAll()
                     oBrowse:goBottom()
                  ENDIF
               ENDIF
            NEXT
            IF lDone
               EXIT
            ENDIF
         ENDDO
      ENDIF

   CASE nKey == K_F1
      Alert( { "K_CTRL_P                       Print", ;
               ".", ;
               "K_CTRL_UP        Move current row up", ;
               "K_CTRL_DOWN    Move current row down", ;
               "K_CTRL_DEL        Delete current row", ;
               "K_CTRL_INS            Insert new row", ;
               ".", ;
               "K_CTRL_V      Paste copied structure", ;
               ".", ;
               "K_ENTER                Start editing"  ;
             }, , , , "Help - Create Table" )

   CASE nKey == K_CTRL_DEL
      IF ( n := Eval( oBrowse:getColumn( 1 ):block ) ) > 1
         hb_ADel( oBrowse:cargo, n, .T. )
         oBrowse:refreshAll()
      ENDIF

   CASE nKey == K_CTRL_INS
      IF ( n := Eval( oBrowse:getColumn( 1 ):block ) ) > 1
         hb_AIns( oBrowse:cargo, n, { Space( 10 ), "C", 10, 0 }, .T. )
         oBrowse:refreshAll()
         __hbqtKeyboard( K_ENTER )
      ENDIF

   CASE nKey == K_CTRL_V
      ::pasteStruct()

   CASE nKey == K_CTRL_P
      oBrowse:print()

   CASE nKey == K_CTRL_UP
      IF ( n := Eval( oBrowse:getColumn( 1 ):block ) ) > 1
         aRow := oBrowse:cargo[ n ]
         hb_ADel( oBrowse:cargo, n, .T. )
         hb_AIns( oBrowse:cargo, n - 1, aRow, .T. )
         oBrowse:refreshAll()
         oBrowse:up()
      ENDIF

   CASE nKey == K_CTRL_DOWN
      IF ( n := Eval( oBrowse:getColumn( 1 ):block ) ) < Len( oBrowse:cargo )
         aRow := oBrowse:cargo[ n ]
         hb_ADel( oBrowse:cargo, n, .T. )
         hb_AIns( oBrowse:cargo, n + 1, aRow, .T. )
         oBrowse:refreshAll()
         oBrowse:down()
      ENDIF

   OTHERWISE
      lHandelled := .F.

   ENDCASE

   RETURN lHandelled


METHOD HbQtCreateTable:createTable()
   LOCAL aStruct := {}
   LOCAL aIndex := {}
   LOCAL aStr, aIdx

   FOR EACH aStr IN ::oBrwStruct:cargo
      IF ! Empty( aStr[ 1 ] )
         aStr[ 1 ] := Trim( aStr[ 1 ] )
         AAdd( aStruct, aStr )
      ENDIF
   NEXT

   IF ! Empty( aStruct )
      FOR EACH aIdx IN ::oBrwIndex:cargo
         IF ! Empty( aIdx[ 1 ] )
            aIdx[ 1 ] := Trim( aIdx[ 1 ] )
            aIdx[ 2 ] := Trim( aIdx[ 2 ] )
            AAdd( aIndex, aIdx )
         ENDIF
      NEXT
      ::oDbu:createTable( ::oComboRDD:currentText(), ::oComboConxn:currentText(), aStruct, aIndex )
   ELSE
      Alert( "Please define structure first!" )
   ENDIF

   RETURN Self


METHOD HbQtCreateTable:pasteStruct()
   LOCAL aStruct := ::oDBU:copiedStruct()
   LOCAL aStr

   IF ! Empty( aStruct )
      DO WHILE Len( ::oBrwStruct:cargo ) > 0
         hb_ADel( ::oBrwStruct:cargo, 1, .T. )
      ENDDO
      FOR EACH aStr IN aStruct
         AAdd( ::oBrwStruct:cargo, aStr )
      NEXT
      AEval( ::oBrwStruct:cargo, {|e_| e_[ 1 ] := Pad( e_[ 1 ], 10 ) } )

      ::oBrwStruct:refreshAll()
      ::oBrwStruct:forceStable()

      ::dispInfo()
   ENDIF

   RETURN Self


METHOD HbQtCreateTable:dispInfo()
   LOCAL n := 0, f := 0

   aeval( ::oBrwStruct:cargo, {|e_| n += iif( Empty( e_[ 1 ] ), 0, e_[ 3 ] ), f += iif( Empty( e_[ 1 ] ), 0, 1 ) } )

   ::oLbl:setText( "Fields: " + hb_ntos( f ) + "   Bytes: " + hb_ntos( n ) )

   RETURN Self

