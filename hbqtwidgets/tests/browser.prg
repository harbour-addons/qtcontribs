/*
 * $Id$
 */

/*
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtgui.ch"
#include "inkey.ch"


FUNCTION Main()

   LOCAL oBrowse
   LOCAL aTest0  := { "This", "is", "a", "browse", "on", "an", "array", "test", "with", "a", "long", "data" }
   LOCAL aTest1  := { 1, 2, 3, 4, 5, 6, 7, 8, 10000, - 1000, 54, 456342 }
   LOCAL aTest2  := { Date(), Date() + 4, Date() + 56, Date() + 14, Date() + 5, Date() + 6, Date() + 7, Date() + 8, Date() + 10000, Date() - 1000, Date() - 54, Date() + 456342 }
   LOCAL aTest3  := { .T., .F., .T., .T., .F., .F., .T., .F., .T., .T., .F., .F. }
   LOCAL n       := 1

   LOCAL oMain

   hbqt_errorSys()

   oMain := QMainWindow()
   oMain:resize( 360, 300 )
   oMain:setWindowTitle( "TBrowse Implemented" )

   oBrowse := HbQtBrowseNew( 5, 5, 16, 30, oMain, QFont( "Courier New", 10 ) )
   oBrowse:colorSpec     := "N/W*, N/BG, W+/R*, W+/B"

   oBrowse:ColSep        := hb_UTF8ToStrBox( "│" )             /* Does nothing, but no ERROR */
   oBrowse:HeadSep       := hb_UTF8ToStrBox( "╤═" )          /* Does nothing, but no ERROR */
   oBrowse:FootSep       := hb_UTF8ToStrBox( "╧═" )          /* Does nothing, but no ERROR */

   oBrowse:GoTopBlock    := {|| n := 1 }
   oBrowse:GoBottomBlock := {|| n := Len( aTest0 ) }
   oBrowse:SkipBlock     := {| nSkip, nPos | nPos := n, ;
                                 n := iif( nSkip > 0, Min( Len( aTest0 ), n + nSkip ), ;
                                    Max( 1, n + nSkip ) ), n - nPos }

   oBrowse:AddColumn( HbQtColumnNew( "First",  {|| n } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Second", {|x| iif( x == NIL, aTest0[ n ], aTest0[ n ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Third",  {|x| iif( x == NIL, aTest1[ n ], aTest1[ n ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Forth",  {|x| iif( x == NIL, aTest2[ n ], aTest2[ n ] := x ) } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Fifth",  {|x| iif( x == NIL, aTest3[ n ], aTest3[ n ] := x ) } ) )

   oBrowse:GetColumn( 1 ):Footing    := "Number"
// oBrowse:GetColumn( 1 ):preBlock   := {|| .F.  }

   oBrowse:GetColumn( 2 ):Footing    := "String"

   oBrowse:GetColumn( 2 ):Picture    := "@!"

   oBrowse:GetColumn( 3 ):Footing    := "Number"
   oBrowse:GetColumn( 3 ):Picture    := "999,999.99"
   oBrowse:GetColumn( 3 ):postBlock  := {|| GetActive():varGet() > 700 }
   oBrowse:GetColumn( 3 ):colorBlock := {|nVal| iif( nVal < 0, {3,2}, iif( nVal > 500, {4,2}, {1,2} ) ) }

   oBrowse:GetColumn( 4 ):Footing    := "Dates"

   oBrowse:GetColumn( 5 ):Footing    := "Logical"

   /* TBrowse will call this METHOD when ready TO save edited row. Block must receive 4 parameters and must RETURN true/false */
   oBrowse:editBlock   := {|aModified, aData, oBrw| SaveMyData( aModified, aData, oBrw, aTest0, aTest1, aTest2, aTest3, n ) }
   oBrowse:searchBlock := {|xSearch, nColPos, oBrw| SearchMyData( xSearch, nColPos, oBrw, aTest0, aTest1, aTest2, aTest3, @n ) }

   /* needed since I've changed some columns _after_ I've added them to TBrowse object */
   oBrowse:Configure()
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  Navigate( nKey, xData, oBrw )  }

   /* Freeze first column TO the left */
   oBrowse:freeze := 1
   hb_DispBox( 4, 4, 17, 31, hb_UTF8ToStrBox( "┌─┐│┘─└│ " ) )     /* Does nothing, but no ERROR */

   /* Make the toolbar visible */
   oBrowse:toolbar   := .T.                       /* I always longed for this interface */
   oBrowse:statusbar := .T.                       /* Yes, we want statusbar messages */
   oBrowse:editable  := .F.                       /* User must not be able to edit via edit button */
   oBrowse:statusMessage := "Ready !"

   oMain:setCentralWidget( oBrowse:oWidget )
   oMain:resize( 360, 360 )
   oMain:show()

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION navigate( nKey, xData, oBrowse )
   LOCAL lHandelled := .T.
   LOCAL i, xResult

   HB_SYMBOL_UNUSED( xData )

   oBrowse:statusMessage := DToC( Date() ) + " | " + Time() + " | " + hb_ntos( oBrowse:colPos )

   DO CASE
   CASE nKey == K_CTRL_F
      oBrowse:search()

   CASE nKey == K_F2
      oBrowse:toolbar   :=  ! oBrowse:toolbar
   CASE nKey == K_F3
      oBrowse:statusbar := ! oBrowse:statusbar

   CASE nKey == K_F4
      oBrowse:rFreeze++
   CASE nKey == K_F5
      oBrowse:rFreeze--

   CASE nKey == K_F6
      oBrowse:freeze++
   CASE nKey == K_F7
      oBrowse:freeze--

   CASE nKey == K_F8
      oBrowse:moveLeft()               /* HbQt Entention */

   CASE nKey == K_F9
      oBrowse:moveRight()              /* HbQt Entention */

   CASE nKey == K_F10
      oBrowse:moveHome()               /* HbQt Entention */

   CASE nKey == K_F11
      oBrowse:moveEnd()                /* HbQt Entention */

   CASE nKey == K_F12
      oBrowse:edit( "Update Info", .T., .T. )  /* Even IF :editable is OFF, still application code can initiate it */

   CASE nKey == K_SH_F12 // K_RETURN
      oBrowse:panHome()
      FOR i := 1 TO oBrowse:colCount
         xResult := oBrowse:editCell()  /* HbQt Entention */
         IF xResult == NIL
            EXIT                        /* Sure ESCape is pressed */
         ENDIF
         oBrowse:Right()
      NEXT

   OTHERWISE
      oBrowse:applyKey( nKey )
      lHandelled := .T.

   ENDCASE

   RETURN lHandelled


STATIC FUNCTION SaveMyData( aModified, aData, oBrw, aTest0, aTest1, aTest2, aTest3, n )
   LOCAL i, aCaptions := aData[ 2 ]

   HB_SYMBOL_UNUSED( oBrw )

   FOR i := 1 TO Len( aModified )
      SWITCH aCaptions[ i ]
      CASE "Second"
         aTest0[ n ] := aModified[ i ]            /* You can compare original and modified values */
         EXIT
      CASE "Third"
         aTest1[ n ] := aModified[ i ]
         EXIT
      CASE "Forth"
         aTest2[ n ] := aModified[ i ]
         EXIT
      CASE "Fifth"
         aTest3[ n ] := aModified[ i ]
         EXIT
      ENDSWITCH
   NEXT

   RETURN .T.


STATIC FUNCTION SearchMyData( xSearch, nColPos, oBrw, aTest0, aTest1, aTest2, aTest3, n )
   LOCAL nn

   IF ! Empty( xSearch )
      SWITCH nColPos
      CASE 1
         IF xSearch > 0 .AND. xSearch <= Len( aTest0 )
            n := xSearch
         ENDIF
         EXIT
      CASE 2
         xSearch := Lower( Trim( xSearch ) )
         IF ( nn := AScan( aTest0, {|e| Lower( e ) == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 3
         IF ( nn := AScan( aTest1, {|e|  e == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 4
         IF ( nn := AScan( aTest2, {|e|  e == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 5
         IF ( nn := AScan( aTest3, {|e|  e == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      ENDSWITCH

      IF ! Empty( nn )
         oBrw:refreshAll()
      ELSE
         Alert( "Sorry, not found!" )
      ENDIF
   ENDIF

   RETURN NIL


