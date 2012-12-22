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

#include "hbtrace.ch"


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
   oMain:setWindowTitle( "TBrowse Implemented" )

   oBrowse := HbQtBrowseNew( 5, 5, 16, 30, oMain )
   oBrowse:colorSpec     := "W+/B, N/BG"
   oBrowse:ColSep        := hb_UTF8ToStrBox( "│" )
   oBrowse:HeadSep       := hb_UTF8ToStrBox( "╤═" )
   oBrowse:FootSep       := hb_UTF8ToStrBox( "╧═" )
   oBrowse:GoTopBlock    := {|| n := 1 }
   oBrowse:GoBottomBlock := {|| n := Len( aTest0 ) }
   oBrowse:SkipBlock     := {| nSkip, nPos | nPos := n, ;
      n := iif( nSkip > 0, Min( Len( aTest0 ), n + nSkip ), ;
      Max( 1, n + nSkip ) ), n - nPos }

   oBrowse:AddColumn( HbQtColumnNew( "First",  {|| n } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Second", {|| aTest0[ n ] } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Third",  {|| aTest1[ n ] } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Forth",  {|| aTest2[ n ] } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Fifth",  {|| aTest3[ n ] } ) )
   oBrowse:GetColumn( 1 ):Footing := "Number"
   oBrowse:GetColumn( 2 ):Footing := "String"

   oBrowse:GetColumn( 2 ):Picture := "@!"

   oBrowse:GetColumn( 3 ):Footing := "Number"
   oBrowse:GetColumn( 3 ):Picture := "999,999.99"
   oBrowse:GetColumn( 4 ):Footing := "Dates"
   oBrowse:GetColumn( 5 ):Footing := "Logical"
   // needed since I've changed some columns _after_ I've added them to TBrowse object
   oBrowse:Configure()
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  Navigate( nKey, xData, oBrw )  }

   //Alert( oBrowse:GetColumn( 1 ):ClassName() )

   oBrowse:Freeze := 1
   hb_DispBox( 4, 4, 17, 31, hb_UTF8ToStrBox( "┌─┐│┘─└│ " ) )

   oMain:setCentralWidget( oBrowse:oWidget )
   oMain:resize( oMain:width() + 1, oMain:height() + 1 )
   oMain:show()

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION navigate( nKey, xData, oBrowse )
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )

   DO CASE
   CASE nKey == K_DOWN
      oBrowse:Down()
   CASE nKey == K_UP
      oBrowse:Up()
   CASE nKey == K_LEFT
      oBrowse:Left()
   CASE nKey == K_RIGHT
      oBrowse:Right()
   CASE nKey == K_PGDN
      oBrowse:pageDown()
   CASE nKey == K_PGUP
      oBrowse:pageUp()
   CASE nKey == K_CTRL_PGUP
      oBrowse:goTop()
   CASE nKey == K_CTRL_PGDN
      oBrowse:goBottom()
   CASE nKey == K_HOME
      oBrowse:home()
   CASE nKey == K_END
      oBrowse:end()
   CASE nKey == K_CTRL_LEFT
      oBrowse:panLeft()
   CASE nKey == K_CTRL_RIGHT
      oBrowse:panRight()
   CASE nKey == K_CTRL_HOME
      oBrowse:panHome()
   CASE nKey == K_CTRL_END
      oBrowse:panEnd()
   CASE nKey == K_F6
      oBrowse:freeze++
   CASE nKey == K_F7
      oBrowse:freeze--
   CASE nKey == K_F8
      Alert( oBrowse:ClassName() )
   OTHERWISE
      lHandelled := .F.
   ENDCASE

   RETURN lHandelled

