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
   oBrowse:AddColumn( HbQtColumnNew( "Third",  {|| aTest1[ n ] } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Forth",  {|| aTest2[ n ] } ) )
   oBrowse:AddColumn( HbQtColumnNew( "Fifth",  {|| aTest3[ n ] } ) )

   oBrowse:GetColumn( 1 ):Footing    := "Number"
   oBrowse:GetColumn( 2 ):Footing    := "String"

   oBrowse:GetColumn( 2 ):Picture    := "@!"

   oBrowse:GetColumn( 3 ):Footing    := "Number"
   oBrowse:GetColumn( 3 ):Picture    := "999,999.99"
   oBrowse:GetColumn( 3 ):colorBlock := {|nVal| iif( nVal < 0, {3,2}, iif( nVal > 500, {4,2}, {1,2} ) ) }

   oBrowse:GetColumn( 4 ):Footing    := "Dates"

   oBrowse:GetColumn( 5 ):Footing    := "Logical"

   // needed since I've changed some columns _after_ I've added them to TBrowse object
   oBrowse:Configure()
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  Navigate( nKey, xData, oBrw )  }

   oBrowse:Freeze := 1
   hb_DispBox( 4, 4, 17, 31, hb_UTF8ToStrBox( "┌─┐│┘─└│ " ) )     /* Does nothing, but no ERROR */

   oMain:setCentralWidget( oBrowse:oWidget )
   oMain:resize( 360, 300 )
   oMain:show()

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION navigate( nKey, xData, oBrowse )
   LOCAL lHandelled := .T.

   HB_SYMBOL_UNUSED( xData )

   DO CASE

   CASE nKey == K_RBUTTONDOWN
      Alert( "Right Down" )

   CASE nKey == K_F4
      oBrowse:rFreeze++

   CASE nKey == K_F5
      oBrowse:rFreeze--

   CASE nKey == K_F6
      oBrowse:freeze++

   CASE nKey == K_F7
      oBrowse:freeze--

   CASE nKey == K_F8
      BrwMoveLeft( oBrowse )

   CASE nKey == K_F9
      BrwMoveRight( oBrowse )

   CASE nKey > 32 .AND. nKey < 127
      oBrowse:edit()

   OTHERWISE
      oBrowse:applyKey( nKey )
      lHandelled := .T.

   ENDCASE

   RETURN lHandelled


STATIC FUNCTION BrwMoveLeft( oBrowse )
   LOCAL save_col, col_to_move := oBrowse:colPos

   IF col_to_move > 1
      save_col := oBrowse:getColumn( col_to_move )
      oBrowse:setColumn( col_to_move, oBrowse:getcolumn( col_to_move - 1 ) )
      oBrowse:setColumn( col_to_move - 1, save_col )
      oBrowse:left()
      oBrowse:refreshAll()
   ENDIF

   RETURN col_to_move > 1


FUNCTION BrwMoveRight( oBrowse )
   LOCAL save_col, col_to_move := oBrowse:colPos

   IF col_to_move < oBrowse:colCount
      save_col := oBrowse:getColumn( col_to_move )
      oBrowse:setColumn( col_to_move, oBrowse:getColumn( col_to_move + 1 ) )
      oBrowse:setColumn( col_to_move + 1, save_col )
      oBrowse:right()
      oBrowse:refreshall()
   ENDIF

   RETURN col_to_move < oBrowse:colCount
