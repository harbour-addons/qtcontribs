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

   ReadInsert( .T. )
   SetKey( K_INS, {|| ReadInsert( ! ReadInsert() ) } )

   WITH OBJECT oMain := QMainWindow()
      :setWindowTitle( "Database TBrowse Implemented !" )
      :connect( QEvent_Close, {|| lExit := .T. } )
   ENDWITH
   __hbqtAppWidget( oMain )

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
   LOCAL aFields := { "N001", "N002", "N003", "N004", "N005", "C001" }
   LOCAL aTitles := { "No Picture", "@K 9999999.99", "@K", "@ZK", "@K 9,999,999.99", "ABCD" }

   CreateUseTable()

   WITH OBJECT oBrowse := HbQtBrowseNew( 0, 0, 20, 20, oWnd )
      SetBlocks( oBrowse, aFields, aTitles )
      SetPicture( oBrowse, aFields )

      :skipBlock                := {|n| GSkipper( n ) }
      :navigationBlock          := {|nKey, xData, oBrowse| ApplyKey( nKey, xData, oBrowse ) }
      :cellEditingFinishedBlock := {|xValue, oCol, oBrowse| UpdateColumn( xValue, oCol, oBrowse ) }
      :configure()
   ENDWITH

   RETURN obrowse


STATIC FUNCTION ApplyKey( nKey, xData, oBrowse )
   LOCAL lRet := .T.
   LOCAL oCol := oBrowse:getColumn( oBrowse:colPos )

   HB_SYMBOL_UNUSED( xData )

   DO CASE
   CASE ( nKey == K_ENTER .OR. nKey == K_RETURN .OR. nKey == K_LDBLCLK .OR. ( nKey >= 32 .AND. nKey <= 255 ) )
      IF nKey == K_ENTER .OR. nKey == K_RETURN .OR. nKey == K_LDBLCLK
         oBrowse:editCellEx( oCol:picture, "N/rgb(255,255,175)" )
      ELSE
         oBrowse:editCellEx( oCol:picture, "N/rgb(255,255,175)", , , nKey )
      ENDIF
   OTHERWISE
      lRet := .F.
   ENDCASE

   RETURN lRet


STATIC FUNCTION UpdateColumn( xValue, oCol, oBrowse )
   LOCAL nKey := __hbqtSetLastKey()

   IF nKey != K_ESC
      WITH OBJECT oBrowse
         IF xValue != NIL
            IF RLock()
               Eval( oCol:block, xValue )
               dbCommit()
               dbUnlock()
            ENDIF
         ENDIF
         :refreshCurrent()
         :forceStable()
         IF :colPos < :colCount
            :right()
         ELSE
            :down()
            :panHome()
         ENDIF
         :forceStable()
         IF ( nKey == K_ENTER .OR. nKey == K_RETURN )
            oCol := :getColumn( :colPos )
            :editCellEx( oCol:picture, "N/rgb(255,255,175)" )
         ENDIF
      ENDWITH
   ENDIF
   RETURN NIL


STATIC FUNCTION SetBlocks( oBrowse, aFields, aTitles )
   LOCAL i

   FOR i := 1 to Len( aFields )
      oBrowse:addColumn( HbQtColumnNew( aTitles[ i ], iif( ValType( aFields[ i ] ) == "B", aFields[ i ], FieldWBlock( aFields[ i ], select() ) ) ) )
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


STATIC FUNCTION SetPicture( oBrowse, aFields )
   LOCAL i, oColumn

   FOR i := 1 TO oBrowse:colCount
      oColumn := oBrowse:getColumn( i )
      DO CASE
      CASE aFields[ i ] == "N001"
      CASE aFields[ i ] == "N002" ; oColumn:picture := "@K 9999999.99"
      CASE aFields[ i ] == "N003" ; oColumn:picture := "@K"
      CASE aFields[ i ] == "N004" ; oColumn:picture := "@ZK"
      CASE aFields[ i ] == "N005" ; oColumn:picture := "@K 9,999,999.99"
      CASE aFields[ i ] == "C001" ; oColumn:picture := "@K!" //"@R 99-99-999-99999/9"
      ENDCASE
   NEXT

   RETURN NIL


STATIC FUNCTION Gskipper( nSkip )
   LOCAL i := 0

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

