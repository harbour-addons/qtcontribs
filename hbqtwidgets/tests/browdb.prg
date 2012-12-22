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

   USE ( cPath + "test.dbf" ) NEW SHARED READONLY VIA 'DBFCDX'
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

   oBrowse:colorSpec     := "N/W*, N/W, W+/R*, W+/B*, N/GR*, B+/GR*, N/R*"

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

   oColumn            := HbQtColumnNew( "Record #", {|| RecNo()         } )
// oColumn:type       := XBPCOL_TYPE_FILEICON
   oBrowse:addColumn( oColumn )

   oColumn            := HbQtColumnNew( "Last Name", {|| TEST->last     } )
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

   oBrowse:freeze := 1

   RETURN oBrowse

/*----------------------------------------------------------------------*/

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

/*----------------------------------------------------------------------*/

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

/*----------------------------------------------------------------------*/

STATIC FUNCTION TBPrev()
   LOCAL nSaveRecNum := Recno()
   LOCAL lMoved := .T.

   DBSkip( -1 )

   if Bof()
      DBGoTo( nSaveRecNum )
      lMoved := .F.
   endif

   RETURN lMoved

/*----------------------------------------------------------------------*/

