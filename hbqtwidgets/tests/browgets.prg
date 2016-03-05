/*
 * $Id$
 */

/*
 * Copyright 2013 Zoran Sibinovic <zoran/sibinovic/at/gmail/com>
 * www - http://harbour-project.org
 */



#include "inkey.ch"
#include "common.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"

REQUEST DBFCDX


FUNCTION MAIN()
   LOCAL oMain, oBrw, oELoop, lExit

   hbqt_errorSys()

   oMain := QMainWindow()
   oMain:setWindowTitle( "Database TBrowse Implemented !" )
   oMain:connect( QEvent_Close, {|| lExit := .T. } )

   oBrw := BrowseMe( oMain )
   IF ! Empty( oBrw )
      oMain:setCentralWidget( oBrw:oWidget )
   ENDIF

   oMain:resize( 670, 200 )
   oMain:show()


   lExit := .F.
   oELoop := QEventLoop( oMain )
   oMain:setWindowTitle( hb_ntos( __hbqt_dump_ItemsInGlobalList() ) ) 
   DO WHILE .t.
      oELoop:processEvents()
      IF lExit
         EXIT
      ENDIF
      oMain:setWindowTitle( hb_ntos( __hbqt_ItemsInGlobalList() ) ) 
   ENDDO
   HB_TRACE( HB_TR_ALWAYS, "=====================================" )
   oMain:setWindowTitle( hb_ntos( __hbqt_dump_ItemsInGlobalList() ) ) 
   oELoop:exit( 0 )


   dbCloseAll()

   RETURN NIL


FUNCTION BrowseMe( oWnd )
   LOCAL oBrowse
   LOCAL field_list := { "N001", "N002", "N003", "N004", "N005", "C001" }
   LOCAL asm        := { "No Picture", "@K 9999999.99", "@K", "@ZK", "@K 9,999,999.99", "ABCD" }

   CreateUseTable()

   oBrowse := HbQtBrowseNew( 0, 0, 20, 20, oWnd )
   SBMW( oBrowse, field_list, asm )
   FBMWL( oBrowse, field_list )
   oBrowse:skipBlock       := {|n| GSkipper( n ) }
   oBrowse:navigationBlock := {|nKey, xData, oBrowse| ApplyKey( nKey, xData, oBrowse ) }

   oBrowse:configure()

   RETURN obrowse


STATIC FUNCTION ApplyKey( nKey, xData, oBrowse )
   LOCAL lRet := .t.
   LOCAL oCol := oBrowse:getColumn( oBrowse:colPos )
   LOCAL tget_data

   HB_SYMBOL_UNUSED( xData )

   DO CASE
   CASE ( nKey == K_ENTER .OR. nKey == K_RETURN .OR. nKey == K_LDBLCLK .OR. ( nKey >= 32 .AND. nKey <= 255 ) )

      tget_data := iif( nKey == K_ENTER .OR. nKey == K_RETURN .OR. nKey == K_LDBLCLK, ;
                         oBrowse:editCell( oCol:picture, "N/rgb(255,255,175)" ), ;
                         oBrowse:editCell( oCol:picture, "N/rgb(255,255,175)", , , nKey ) )
      IF tget_data == NIL
         RETURN lRet
      ENDIF

      IF tget_data != Eval( oCol:block )
         IF RLock()
            Eval( oCol:block, tget_data )
            dbCommit()
            dbUnlock()
         ENDIF
         oBrowse:right():refreshCurrent()
      ENDIF
   OTHERWISE
      lRet := .f.
   ENDCASE

   RETURN lRet


STATIC FUNCTION SBMW( oBrowse, field_list, asm )
   LOCAL i

   FOR i := 1 to len( field_list )
      oBrowse:addColumn( HbQtColumnNew( asm[ i ], iif( VALTYPE( field_list[ i ] ) == "B", field_list[ i ], FieldWBlock( field_list[ i ], select() ) ) ) )
   NEXT

   oBrowse:goTopBlock          := {| | DbGoTop()        }
   oBrowse:goBottomBlock       := {| | DbGoBottom()     }

   oBrowse:firstPosBlock       := {| | 1                }
   oBrowse:lastPosBlock        := {| | LastRec()        }
   IF indexOrd() == 0
      oBrowse:posBlock         := {| | RecNo()          }
      oBrowse:goPosBlock       := {|n| DbGoto( n )      }
      oBrowse:phyPosBlock      := {| | RecNo()          }
   ELSE
      oBrowse:posBlock         := {| | OrdKeyNo()       }
      oBrowse:goPosBlock       := {|n| OrdKeyGoto( n )  }
      oBrowse:phyPosBlock      := {| | OrdKeyNo()       }
   ENDIF

   /* HbQtBrowse Extentions */
   oBrowse:horizontalScrollbar := .T.
   oBrowse:verticalScrollbar   := .T.
   oBrowse:toolbar             := .F.
   oBrowse:statusbar           := .F.

   RETURN oBrowse


STATIC FUNCTION Gskipper( nSkip)
   LOCAL i:=0

   DO CASE
   CASE ( nSkip == 0 .or. LastRec() == 0 ) ; dbskip( 0 )
   CASE ( nSkip > 0 .and. !eof() )
       DO WHILE ( i < nSkip )
          dbSkip( 1 )
          IF EOF()
             dbskip( -1 )
             EXIT
          ENDIF
          i++
       ENDDO
   CASE ( nSkip < 0 )
       DO WHILE ( i > nSkip )
          dbSkip( -1 )
          IF BOF()
             EXIT
          ENDIF
          i--
       ENDDO
   ENDCASE

   RETURN i


STATIC FUNCTION FBMWL( oBrowse, field_list )
   LOCAL i, oColumn

   FOR i := 1 TO oBrowse:colCount
      oColumn := oBrowse:getColumn( i )
      DO CASE
      CASE field_list[ i ] == "N001"
      CASE field_list[ i ] == "N002" ; oColumn:picture := "@K 9999999.99"
      CASE field_list[ i ] == "N003" ; oColumn:picture := "@K"
      CASE field_list[ i ] == "N004" ; oColumn:picture := "@ZK"
      CASE field_list[ i ] == "N005" ; oColumn:picture := "@K 9,999,999.99"
      CASE field_list[ i ] == "C001" ; oColumn:picture := "@K!" //"@R 99-99-999-99999/9"
      ENDCASE
   NEXT

   RETURN NIL


STATIC FUNCTION CreateUseTable()
   LOCAL aStr := {}

   AAdd( aStr, { "N001", "N", 10, 2 } )
   AAdd( aStr, { "N002", "N", 10, 2 } )
   AAdd( aStr, { "N003", "N", 10, 2 } )
   AAdd( aStr, { "N004", "N", 10, 2 } )
   AAdd( aStr, { "N005", "N", 10, 2 } )
   AAdd( aStr, { "C001", "C", 13, 0 } )

   IF ! dbCreate( "brwgets.dbf", aStr, "DBFCDX" )
      Alert( "Could not create <brwgets> !" )
   ENDIF
   dbCloseAll()

   USE "brwgets" NEW SHARED VIA "DBFCDX"
   IF ! NetErr()
      dbAppend()
      REPLACE brwgets->n001 WITH 1010.00
      REPLACE brwgets->n002 WITH 0.12
      REPLACE brwgets->n003 WITH -12.00
      REPLACE brwgets->n004 WITH 0.33
      REPLACE brwgets->n005 WITH 34567.89
      REPLACE brwgets->c001 WITH "0123456789012"
      dbCommit()
      dbUnlock()
   ELSE
      Alert( "Could not open <brwgets> !" )
   ENDIF

   RETURN NIL

