/*
 * $Id$
 */

/*
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtgui.ch"
#include "inkey.ch"


REQUEST DBFCDX


#define HBQTBRW_CURSOR_NONE                       1
#define HBQTBRW_CURSOR_CELL                       2
#define HBQTBRW_CURSOR_ROW                        3


FUNCTION Main()

   LOCAL oMain, oBrw

   hbqt_errorSys()

   oMain := QMainWindow()
   oMain:setWindowTitle( "Database TBrowse Implemented !" )

   oBrw := BrowseMe( oMain )
   IF ! Empty( oBrw )
      oMain:setCentralWidget( oBrw:oWidget )
   ENDIF

   oMain:resize( 900, 450 )
   oMain:show()

   QApplication():exec()

   dbCloseAll()

   RETURN NIL


STATIC FUNCTION BrowseMe( oWnd )
   LOCAL oBrowse, oColumn
   LOCAL cPath := hb_DirBase() + ".." + hb_ps() + ".." + hb_ps() + ".." + hb_ps() + "tests" + hb_ps()

   Set( _SET_DATEFORMAT, "yyyy.mm.dd" )

   USE ( cPath + "test.dbf" ) NEW SHARED VIA 'DBFCDX'
   IF NetErr()
      Alert( "Could not open table!" )
      RETURN NIL
   ENDIF
   IF ! hb_FileExists( cPath + "test.cdx" )
      INDEX ON test->last TAG "LAST" TO ( cPath + "test.cdx" )
   ENDIF
   SET INDEX TO ( cPath + "test.cdx" )

   DbGotop()

   oBrowse := HbQtBrowseNew( 0,0, 20, 80, oWnd, QFont( "Courier New", 10 ) )

   oBrowse:colorSpec := "N/W*, N/W, W+/R*, W+/B*, N/GR*, B+/GR*, N/R*"

   /* Navigation Blocks */
   oBrowse:skipBlock           := {|n| DbSkipBlock( n ) }
   oBrowse:goTopBlock          := {| | DbGoTop()        }
   oBrowse:goBottomBlock       := {| | DbGoBottom()     }

   oBrowse:horizontalScrollbar := .T.                        /* Not a TBrowse METHOD */
   oBrowse:verticalScrollbar   := .T.                        /* Not a TBrowse METHOD */
   oBrowse:cursorMode          := HBQTBRW_CURSOR_ROW         /* Not a TBrowse METHOD */

   /* Blocks TO control Scroolbars */
   oBrowse:firstPosBlock       := {| | 1                }    /* Not a TBrowse METHOD */
   oBrowse:lastPosBlock        := {| | LastRec()        }    /* Not a TBrowse METHOD */
   IF indexOrd() == 0
      oBrowse:posBlock         := {| | RecNo()          }    /* Not a TBrowse METHOD */
      oBrowse:goPosBlock       := {|n| DbGoto( n )      }    /* Not a TBrowse METHOD */
      oBrowse:phyPosBlock      := {| | RecNo()          }    /* Not a TBrowse METHOD */
   ELSE
      oBrowse:posBlock         := {| | OrdKeyNo()       }    /* Not a TBrowse METHOD */
      oBrowse:goPosBlock       := {|n| OrdKeyGoto( n )  }    /* Not a TBrowse METHOD */
      oBrowse:phyPosBlock      := {| | OrdKeyNo()       }    /* Not a TBrowse METHOD */
   ENDIF

   oColumn            := HbQtColumnNew( "Record #"   , {|| RecNo()        } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Last Name"  , {|| TEST->last     } )
   oColumn:colorBlock := {|| iif( SubStr( TEST->first,1,1 ) $ "ANLH", { 6,2 }, { 1,2 } ) }
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "First Name" , {|| TEST->first    } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Salary"     , {|| TEST->salary   } )
   oColumn:picture    := "@Z 999,999.00"
   oColumn:colorBlock := {|x| iif( x < 40000, { 7,2 }, { 1,2 } ) }
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "HireDate"   , {|| TEST->hireDate } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Age"        , {|| TEST->age      } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "City"       , {|| TEST->city     } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "State"      , {|| TEST->state    } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Zip"        , {|| TEST->zip      } )
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Notes"      , {|| TEST->notes    } )
   oBrowse:addColumn( oColumn )

   /* Tbrowse Methods */
   oBrowse:freeze := 1

   /* HbQtBrowse Extentions */
   oBrowse:toolbar         := .T.
   oBrowse:statusbar       := .T.
   oBrowse:statusMessage   := "This is Harbour TBrowse's Complete Implementation in HbQt Widgets with many Additional Goodies!"
   oBrowse:editBlock       := {|aMod,aData,oBrw| SaveMyRecord( aMod,aData,oBrw ) }
   oBrowse:searchBlock     := {|xValue,nColPos,oBrw| LookMySearch( xValue,nColPos,oBrw ) }
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  HandleMyOptions( nKey,xData,oBrw ) }

   RETURN oBrowse


STATIC FUNCTION HandleMyOptions( nKey,xData,oBrw )
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )

   DO CASE

   CASE nKey == K_F6
      oBrw:freeze++
   CASE nKey == K_F7
      oBrw:freeze--
   CASE nKey == K_F12
      oBrw:edit( "Update Field Values", .T., .T. )
   OTHERWISE
      lHandelled := .F.
   ENDCASE

   RETURN lHandelled


STATIC FUNCTION SaveMyRecord( aMod,aData,oBrw )
   LOCAL cColumn, nField

   IF dbRLock()
      FOR EACH cColumn IN aData[ 2 ]
         nField := cColumn:__enumIndex()
         IF aMod[ nField ] != aData[ 1, nField ]   /* DATA Changed or Not */
            SWITCH cColumn
            CASE "First Name"                      /* We are interested IN editing these two fields only */
               REPLACE TEST->first WITH aMod[ nField ]
               EXIT
            CASE "Last Name"
               REPLACE TEST->last  WITH aMod[ nField ]
               EXIT
            ENDSWITCH
         ENDIF
      NEXT
      dbCommit()
      dbRUnlock()
      oBrw:refreshCurrent()
   ENDIF

   RETURN .T.


STATIC FUNCTION DbSkipBlock( n )
   LOCAL nSkipped := 0

   if n == 0
      DBSkip( 0 )

   elseif n > 0
      do while nSkipped != n .and. TBNext()
         nSkipped++
      enddo
   else
      do while nSkipped != n .and. TBPrev()
         nSkipped--
      enddo
   endif

   RETURN  nSkipped


STATIC FUNCTION TBNext()
   LOCAL nSaveRecNum := recno()
   LOCAL lMoved := .T.

   if Eof()
      lMoved := .F.
   else
      DBSkip( 1 )
      if Eof()
         lMoved := .F.
         DBGoTo( nSaveRecNum )
      endif
   endif

   RETURN lMoved


STATIC FUNCTION TBPrev()
   LOCAL nSaveRecNum := Recno()
   LOCAL lMoved := .T.

   DBSkip( -1 )

   if Bof()
      DBGoTo( nSaveRecNum )
      lMoved := .F.
   endif

   RETURN lMoved


STATIC FUNCTION LookMySearch( xValue,nColPos,oBrw )
   LOCAL nRec

   IF IndexOrd() == 1 .AND. oBrw:getColumn( nColPos ):heading == "Last Name"
      nRec := RecNo()
      IF ! dbSeek( Trim( xValue ) )
         dbGoto( nRec )
      ELSE
         oBrw:refreshAll()
      ENDIF
   ENDIF

   RETURN .T.

