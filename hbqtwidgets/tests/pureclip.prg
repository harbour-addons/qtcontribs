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
   @ 1, 02 SAY PadL( "Upper Cased Alphabets:", nPdL ) GET cText VALID {|oGet| cText == "ABC" .OR. cText == "DEF" .OR. Udf1( oGet ) } PICTURE "@!A"

   @  2, 02 SAY PadL( "Birthday:", nPdL )
   @  2, nColGet GET dDate WHEN {|| cText == "ABC" } COLOR "B/GR*" VALID dDate >= 0d19560604

   @  3, 02 SAY PadL( "Max 6 Decimals:", nPdL )
   @  3, nColGet GET nNumb PICTURE "@Z 9,999,999.999999" VALID nNumb > 600 .AND. nNumb < 6000000

   @  4, 02 SAY PadL( "Logical - Married:", nPdL ) GET lMrd  PICTURE "Y"

   @  5, 02 SAY PadL( "Telephone Number:", nPdL )
   @  5, nColGet GET cTele PICTURE "@! (999)999-9999"

   @  6, 02 SAY PadL( "Upper Lower Upper:", nPdL )
   @  6, nColGet GET cJust PICTURE "@A" COLOR "W+/B*" VALIDATOR {|cText,nPos| UpperLowerUpper( @cText, @nPos ) }

   @  7, 02 SAY PadL( "Scrolling Catalog:", nPdL )
   @  7, nColGet GET cCata PICTURE "@S15 !!!-!!!-!!!!!!!!!!!!"

   @  1, 52 SAY "Val[1]"
   @  1, 60 GET val[1] PICTURE "@!"
   @  2, 52 SAY "Val[2]"
   @  2, 60 GET val[2] PICTURE "99"
   @  3, 52 SAY "Val[3]"
   @  3, 60 GET val[3]

   @  5, 52 SAY "Deptt:"
   @  5, 60, 5, 69 GET cDeptt COMBOBOX aDeptt VALID {|oGet| HB_TRACE( HB_TR_ALWAYS, oGet:varGet() ), .T. }

   @  7, 52 SAY "Salary:"
   @  7, 60 GET nSlry PICTURE "@E 99,999" VALID {|| nSlry > 600 .AND. nSlry < 17000 }

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

   READ PROPERTIES {|oWnd,oGetList| SetFormProperties( oWnd, oGetList ) }

   QApplication():exec()

   RETURN NIL


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



