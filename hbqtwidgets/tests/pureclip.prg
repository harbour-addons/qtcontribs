/*
 * $Id$
 */

/*
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"

#include "set.ch"
#include "hbqtstd.ch"
#include "inkey.ch"

#include "hbtrace.ch"


FUNCTION Main()

   LOCAL nPdL := 22, nColGet := 25

   LOCAL cText   := "ABC"
   LOCAL dDate   := 0d19560604
   LOCAL nNumb   := 6030.130001
   LOCAL lMrd    := .T.
   LOCAL cTele   := "(999)684-7318"
   LOCAL cJust   := Space( 20 )
   LOCAL cCata   := "IT3-BEL-903533AST63Z"
   LOCAL nSlry   := 3000
   LOCAL cNotes  := "We, the Harboureans, are entering a new era of true GUI implementation of our beloved Clipper language, let us keep the emotions high..."
   LOCAL cList   := "Two"
   LOCAL aList   := { "One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten" }
   LOCAL lOk     := .F.
   LOCAL lCancel := .F.
   LOCAL cDeptt  := "MIS"
   LOCAL aDeptt  := { "Accounts","Store","MIS","HR","Technical" }
   LOCAL lDone   := .T.

   LOCAL GetList := {}
   LOCAL SayList := {}

   LOCAL val := Array( 3 )

   hbqt_errorsys()              /* ALWAYS place it as first FUNCTION call; you will know your errors */

   val[ 1 ] := Space( 10 )
   val[ 2 ] := 0
   val[ 3 ] := ctod( "" )

   /* Harbour Standard Settings */
   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )

   /* Harbour standards SAYs and GETs */
   @ 1, 02 SAY PadL( "Upper Cased Alphabets:", nPdL ) GET cText VALID {|oGet| cText == "ABC" .OR. cText == "DEF" .OR. Udf1( oGet ) } PICTURE "@!KA"

   @  2, 02 SAY PadL( "Birthday:", nPdL )
   @  2, nColGet GET dDate WHEN {|| cText == "ABC" } COLOR "B/GR*" ;
      VALID {|oGet| HB_TRACE( HB_TR_ALWAYS, oGet:buffer(), oGet:varGet(), oGet:updateBuffer(), oGet:buffer(), oGet:unTransform() ), dDate >= 0d19560604 }

   @  3, 02 SAY PadL( "Max 6 Decimals:", nPdL )
   @  3, nColGet GET nNumb PICTURE "@Z 9,999,999.999999" VALID nNumb > 600 .AND. nNumb < 6000000

   @  4, 02 SAY PadL( "Logical - Married:", nPdL ) GET lMrd  PICTURE "Y"

   @  5, 02 SAY PadL( "Telephone Number:", nPdL )
   @  5, nColGet GET cTele PICTURE "@! (999)999-9999"

   @  6, 02 SAY PadL( "Upper Lower Upper:", nPdL )
   @  6, nColGet GET cJust PICTURE "@A" COLOR "W+/B*" VALIDATOR {|cText,nPos| UpperLowerUpper( @cText, @nPos ) } VALID {|| GetAsChild_1() }

   @  7, 02 SAY PadL( "Scrolling Catalog:", nPdL )
   @  7, nColGet GET cCata PICTURE "@S15 !!!-!!!-!!!!!!!!!!!!"  VALID {|| GetAsChild() }

   @  1, 52 SAY "Val[1]"
   @  1, 60 GET val[1] PICTURE "@!"
   @  2, 52 SAY "Val[2]"
   @  2, 60 GET val[2] PICTURE "@K 99"
   @  3, 52 SAY "Val[3]"
   @  3, 60 GET val[3]

   @  5, 52 SAY "Deptt:"
   @  5, 60, 5, 69 GET cDeptt COMBOBOX aDeptt VALID {|oGet| HB_TRACE( HB_TR_ALWAYS, oGet:varGet() ), .T. }

   @  7, 52 SAY "Salary:"
   @  7, 60 GET nSlry PICTURE "@KE 99,999" VALID {|| nSlry > 600 .AND. nSlry < 17000 }

   @  9, 48 SAY "Done:"
   @  9, 54 GET lDone CHECKBOX

   @  9, 02 SAY "Notes:"
   @ 10, 02, 17, 55 GET cNotes MEMOEDIT COLOR "N/rgb(255,255,230)" WHEN cText == "DEF" VALID "Harbour" $ cNotes ;
                                  PROPERTIES {|oGet,oControl| SetControlProp( oGet, oControl, "tooltip", "The notes must contain 'Harbour' somewhere" ) }

   @  9, 60 SAY "Select:"
   @ 10, 60, 17, 69 GET cList LISTBOX aList WHEN cText == "ABC" VALID {|| HB_TRACE( HB_TR_ALWAYS, cList ), .T. }

   @ 19, 25, 19, 44 GET lOk     PUSHBUTTON "OK"     ACTION {|| iif( HbQtAlert( "Save Data?", {"Yes","No"} ) == 1, "cText", "cNotes" ) } ;
                                                        WHEN nSlry > 700 .AND. nSlry < 17000
   @ 19, 50, 19, 69 GET lCancel PUSHBUTTON "Cancel" ACTION {|v| v := HbQtAlert( { "Cancel Pressed!", "Should we terminate the Form ?" }, { "Ok","Cancel" }, "W+/N", 5, "Really?", 2 ), ;
                                                        iif( v == 1, GetActive():parent():close(), NIL ) }

   SetKey( K_F2, {|| BrowseArray( GetActive():parent() ) } )

   READ PROPERTIES {|oWnd,oGetList| SetFormProperties( oWnd, oGetList ) }

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION GetAsChild_1()
   LOCAL oWnd    := GetActive():parent()
   LOCAL nYear   := 0, nMonth := 0
   LOCAL SayList := {}, GetList := {}
   LOCAL kf2     := SetKey( K_F2, {|| BrowseArray( oWnd ) } )

   @ 1, 2 SAY "Year :" GET nYear  PICTURE "@Z 9999"
   @ 2, 2 SAY "Month:" GET nMonth PICTURE "@Z 99"

   READ ;
      LASTGETBLOCK {|| GetActive():parent():close() } ;
      ATTRIBUTES   { { _QGET_ATTRB_ATROWCOLUMNONTOPOF, { oWnd, GetActive():Row(), GetActive():Col() } } } ;

   SetKey( K_F2, kf2 )

   RETURN .T.

STATIC FUNCTION GetAsChild()
   LOCAL oWnd    := GetActive():parent()
   LOCAL nYear   := 0, nMonth := 0
   LOCAL SayList := {}, GetList := {}
   LOCAL kf2     := SetKey( K_F2, {|| BrowseArray( oWnd ) } )

   @ 0.2, 1 SAY "Year :" GET nYear  PICTURE "@Z 9999"
   @ 1.2, 1 SAY "Month:" GET nMonth PICTURE "@Z 99"

   READ ;
      LASTGETBLOCK {|| GetActive():parent():close() } ;
      ATTRIBUTES   { { _QGET_ATTRB_ATROWCOLUMNONTOPOF, { oWnd, GetActive():Row(), GetActive():Col(), .T. } } } ;
      NOFOCUSFRAME ;
      TITLE        "MonthYear"

   SetKey( K_F2, kf2 )

   RETURN .T.


STATIC FUNCTION UpperLowerUpper( cText, nPos )
   LOCAL cChr, s

   HB_SYMBOL_UNUSED( nPos )

   s := ""
   FOR EACH cChr IN cText
      IF cChr:__enumIndex() % 2 == 0
         s += Lower( cChr )
      ELSE
         s += Upper( cChr )
      ENDIF
   NEXT
   cText := s

   RETURN .T.  /* Must always return TRUE/FALSE */


STATIC FUNCTION Udf1( oGet )

   IF "TST" $ oGet:buffer
      oGet:varPut( "DEF" )
      oGet:display()
      RETURN .T.
   ENDIF

   RETURN .F.


STATIC FUNCTION SetFormProperties( oWnd, oGetList )

   HB_SYMBOL_UNUSED( oGetList )

   oWnd:setWindowTitle( "Clipper Compatible GET System" )
   oWnd:setWindowIcon( QIcon( "harbour.png" ) )

   RETURN NIL


STATIC FUNCTION SetControlProp( oGet, oControl, cProp, xValue )

   HB_SYMBOL_UNUSED( oGet )

   SWITCH cProp
   CASE "tooltip"
      oControl:setToolTip( xValue )
      EXIT
   ENDSWITCH

   RETURN NIL


STATIC FUNCTION BrowseArray( oMain )

   LOCAL oBrowse
   LOCAL aTest0  := { "This", "is", "a", "browse", "on", "an", "array", "test", "with", "a", "long", "data" }
   LOCAL aTest1  := { 1, 2, 3, 4, 5, 6, 7, 8, 10000, - 1000, 54, 456342 }
   LOCAL aTest2  := { Date(), Date() + 4, Date() + 56, Date() + 14, Date() + 5, Date() + 6, Date() + 7, Date() + 8, Date() + 10000, Date() - 1000, Date() - 54, Date() + 456342 }
   LOCAL aTest3  := { .T., .F., .T., .T., .F., .F., .T., .F., .T., .T., .F., .F. }
   LOCAL n       := 1

   oBrowse := HbQtBrowseNew( 10, 25, 17, 70, oMain, QFont( "Courier New", 10 ), .T. )
   oBrowse:colorSpec     := "N/W*, N/BG, W+/R*, W+/B"

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

   oBrowse:GetColumn( 2 ):Picture    := "@!"

   oBrowse:GetColumn( 3 ):Picture    := "999,999.99"
   oBrowse:GetColumn( 3 ):postBlock  := {|| GetActive():varGet() > 700 }
   oBrowse:GetColumn( 3 ):colorBlock := {|nVal| iif( nVal < 0, {3,2}, iif( nVal > 500, {4,2}, {1,2} ) ) }

   /* TBrowse will call this METHOD when ready TO save edited row. Block must receive 4 parameters and must RETURN true/false */
   oBrowse:editBlock   := {|aModified, aData, oBrw| SaveMyData( aModified, aData, oBrw, aTest0, aTest1, aTest2, aTest3, n ) }
   oBrowse:searchBlock := {|xSearch, nColPos, oBrw| SearchMyData( xSearch, nColPos, oBrw, aTest0, aTest1, aTest2, aTest3, @n ) }
   oBrowse:searchExBlock := {|xSearch, nColPos, oBrw| SearchExMyData( xSearch, nColPos, oBrw, aTest0, aTest1, aTest2, aTest3, @n ) }

   /* needed since I've changed some columns _after_ I've added them to TBrowse object */
   oBrowse:Configure()
   oBrowse:navigationBlock := {|nKey,xData,oBrw|  Navigate( nKey, xData, oBrw )  }

   /* Freeze first column TO the left */
   oBrowse:freeze := 1

   oBrowse:editEnabled   := .F.                       /* User must not be able to edit via edit button */

   oBrowse:execute()

   RETURN NIL


STATIC FUNCTION navigate( nKey, xData, oBrowse )
   LOCAL lHandelled := .T.
   LOCAL i, xResult

   HB_SYMBOL_UNUSED( xData )

   oBrowse:statusMessage := DToC( Date() ) + " | " + Time() + " | " + hb_ntos( oBrowse:colPos )

   IF nKey == K_RIGHT .OR. nKey == K_LEFT .OR. nKey == K_END .OR. nKey == K_HOME
      oBrowse:searchEx()
   ENDIF

   DO CASE
   CASE nKey == K_ENTER
      IF ! Empty( GetActive() ) .AND. Upper( GetActive():name() ) == "CTEXT"
         GetActive():varPut( Eval( oBrowse:getColumn( 2 ):block ) )
         GetActive():display()
      ENDIF
      oBrowse:terminate()             /* Here we need TO inform which record is selected and appln acts accordingly */

   CASE nKey == K_ESC
      oBrowse:terminate()             /* Here appln should act OTHERWISE */

   CASE nKey == K_CTRL_F
      oBrowse:search()

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

   CASE nKey == K_SH_F12
      oBrowse:panHome()
      FOR i := 1 TO oBrowse:colCount
         xResult := oBrowse:editCell()  /* HbQt Entention */
         IF xResult == NIL
            EXIT                        /* Sure ESCape is pressed */
         ENDIF
         IF i < oBrowse:colCount
            oBrowse:Right()
         ENDIF
      NEXT

   CASE nKey >= 32 .AND. nKey <= 127
      oBrowse:searchEx( Chr( nKey ) )

   OTHERWISE
      lHandelled := .F.

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


STATIC FUNCTION SearchMyData( xSearch, nMode, oBrw, aTest0, aTest1, aTest2, aTest3, n )
   LOCAL nn

   HB_SYMBOL_UNUSED( nMode )

   IF ! Empty( xSearch )
      SWITCH oBrw:colPos
      CASE 1
         IF xSearch > 0 .AND. xSearch <= Len( aTest0 )
            n := xSearch
         ENDIF
         EXIT
      CASE 2
         xSearch := Lower( Trim( xSearch ) )
         IF ( nn := AScan( aTest0, {|e| Lower( e ) = xSearch } ) ) > 0
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


STATIC FUNCTION SearchExMyData( xSearch, nMode, oBrw, aTest0, aTest1, aTest2, aTest3, n )
   LOCAL nn

   HB_SYMBOL_UNUSED( nMode )

   IF ! Empty( xSearch )
      SWITCH oBrw:colPos
      CASE 1
         xSearch := Val( xSearch )
         IF xSearch > 0 .AND. xSearch <= Len( aTest0 )
            n := xSearch
         ENDIF
         EXIT
      CASE 2
         xSearch := Lower( Trim( xSearch ) )
         IF ( nn := AScan( aTest0, {|e| Lower( e ) = xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 3
         xSearch := Val( xSearch )
         IF ( nn := AScan( aTest1, {|e|  e == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 4
         xSearch := CToD( xSearch )
         IF ( nn := AScan( aTest2, {|e|  e == xSearch } ) ) > 0
            n := nn
         ENDIF
         EXIT
      CASE 5
         xSearch := Lower( xSearch ) $ "y,t"
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



