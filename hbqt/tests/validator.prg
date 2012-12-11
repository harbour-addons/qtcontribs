/*
 * $Id$
 */

/*
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */

/*----------------------------------------------------------------------*/

#include "hbqtgui.ch"
#include "set.ch"

#include "hbqtstd.ch"
#include "hbtrace.ch"


FUNCTION Main( cMode )

   LOCAL oWnd, oFLayout
   LOCAL oEdit1, oEdit2, oEdit3, oEdit4, oEdit5, oEdit6, oEdit7, oEdit8
   LOCAL nPdL := 22, nColGet := 25

   LOCAL cText := "ABC"
   LOCAL dDate := 0d19560604
   LOCAL nNumb := 6030.130001
   LOCAL lMrd  := .T.
   LOCAL cTele := "(999)684-7318"
   LOCAL cJust := Space( 20 )
   LOCAL cCata := "IT3-BEL-903533AST63Z"
   LOCAL nSlry := 3000

   LOCAL GetList := {}
   LOCAL SayList := {}
   LOCAL GetParent := NIL

   LOCAL val := Array( 3 )

   hbqt_errorSys()

   val[ 1 ] := Space( 10 )
   val[ 2 ] := 0
   val[ 3 ] := ctod( "" )

   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )

   hb_default( @cMode, "O" )

   IF cMode == "O"
      oWnd := QScrollArea()
      oWnd:setWindowTitle( "Clipper Get System - Scrollable Widget" )
      oWnd:connect( QEvent_KeyPress, {|oKeyEvent| iif( oKeyEvent:key() == Qt_Key_Escape, QApplication():sendEvent( QApplication(), QCloseEvent() ), NIL ) } )

      GetParent := QFrame( oWnd )
      oWnd:setWidget( GetParent )

      @ 1, 02 QSAY PadL( "Upper Cased Alphabets:", nPdL ) QGET cText VALID {|| cText == "ABC" .OR. cText == "DEF" } PICTURE "@!A"

      @ 2, 02 QSAY PadL( "Birthday:", nPdL )
      @ 2, nColGet QGET dDate WHEN {|| cText == "ABC" } COLOR "B/GR*" VALID dDate >= 0d19560604

      @ 3, 02 QSAY PadL( "Max 6 Decimals:", nPdL )
      @ 3, nColGet QGET nNumb PICTURE "@Z 9,999,999.999999" VALID nNumb > 600 .AND. nNumb < 6000000

      @ 4, 02 QSAY PadL( "Logical - Married:", nPdL ) QGET lMrd  PICTURE "Y"

      @ 5, 02 QSAY PadL( "Telephone Number:", nPdL )
      @ 5, nColGet QGET cTele PICTURE "@! (999)999-9999"

      @ 6, 02 QSAY PadL( "Upper Lower Upper:", nPdL )
      @ 6, nColGet QGET cJust PICTURE "@A" COLOR "W+/B*" VALIDATOR {|cText,nPos| UpperLowerUpper( @cText, @nPos ) }

      @ 7, 02 QSAY PadL( "Scrolling Catalog:", nPdL )
      @ 7, nColGet QGET cCata PICTURE "@S15 !!!-!!!-!!!!!!!!!!!!"

      @ 1, 52 QSAY "Val[1]"
      @ 1, 60 QGET val[1] PICTURE "@!"
      @ 2, 52 QSAY "Val[2]"
      @ 2, 60 QGET val[2] PICTURE "99"
      @ 3, 52 QSAY "Val[3]"
      @ 3, 60 QGET val[3]

      @ 7, 52 QSAY "Salary:"
      @ 7, 60 QGET nSlry PICTURE "@E 99,999" VALID {|| nSlry > 600 .AND. nSlry < 17000 }


      QREAD

      oWnd:resize( GetParent:width()  + 2 + ( oWnd:frameGeometry():width()  - oWnd:geometry():width()  ),;
                   GetParent:height() + 2 + ( oWnd:frameGeometry():height() - oWnd:geometry():height() ) )
   ELSE
      oWnd := QWidget()
      oWnd:setWindowTitle( "Clipper Get System - Layout" )
      oWnd:connect( QEvent_KeyPress, {|oKeyEvent| iif( oKeyEvent:key() == Qt_Key_Escape, QApplication():sendEvent( QApplication(), QCloseEvent() ), NIL ) } )

      oFLayout := QFormLayout( oWnd )
      oFLayout:setLabelAlignment( Qt_AlignRight )
      oFLayout:setFieldGrowthPolicy( QFormLayout_FieldsStayAtSizeHint )
      oFLayout:setFormAlignment( Qt_AlignHCenter )

      oEdit1                := HbQtGet():new()
      oEdit1:parent         := oWnd
      oEdit1:postBlock      := {|cValue| cValue == "ABC" .OR. cValue == "DEF" }
      oEdit1:picture        := "@!A"
      oEdit1:block          := {|x| iif( x == NIL, cText, cText := x ) }
      oEdit1:create()
      oFLayout:addRow( "Alpha - Upper Cased Alphabets:", oEdit1:edit() )

      oEdit2                := HbQtGet():new()
      oEdit2:parent         := oWnd
      oEdit2:block          := {|x| iif( x == NIL, dDate, dDate := x ) }
      oEdit2:preBlock       := {|| cText == "ABC" }
      oEdit2:postBlock      := {|| dDate >= 0d19560604 }
      oEdit2:color          := "B/GR*"
      oEdit2:create()
      oFLayout:addRow( "Date - Birthday:", oEdit2:edit() )

      oEdit3                := HbQtGet():new()
      oEdit3:parent         := oWnd
      oEdit3:block          := {|x| iif( x == NIL, nNumb, nNumb := x ) }
      oEdit3:postBlock      := {|| nNumb > 600 .AND. nNumb < 6000000 }
      oEdit3:picture        := "9,999,999.999999"
      oEdit3:create()
      oFLayout:addRow( "Numeric - Max 6 Decimals:", oEdit3:edit() )

      oEdit4                := HbQtGet():new()
      oEdit4:parent         := oWnd
      oEdit4:picture        := "@Y"
      oEdit4:block          := {|x| iif( x == NIL, lMrd, lMrd := x ) }
      oEdit4:create()
      oFLayout:addRow( "Logical - Married:", oEdit4:edit() )

      oEdit5                := HbQtGet():new()
      oEdit5:parent         := oWnd
      oEdit5:block          := {|x| iif( x == NIL, cTele, cTele := x ) }
      oEdit5:picture        := "(999)999-9999"
      oEdit5:create()
      oFLayout:addRow( "Telephone Number:", oEdit5:edit() )

      oEdit6                := HbQtGet():new()
      oEdit6:parent         := oWnd
      oEdit6:block          := {|x| iif( x == NIL, cJust, cJust := x ) }
      oEdit6:inputValidator := {|cText,nPos| UpperLowerUpper( @cText, @nPos ) }
      oEdit6:color          := "W+/B*"
      oEdit6:create()
      oFLayout:addRow( "Alpha - Upper Lower Upper:", oEdit6:edit() )

      oEdit7                := HbQtGet():new()
      oEdit7:parent         := oWnd
      oEdit7:block          := {|x| iif( x == NIL, cCata, cCata := x ) }
      oEdit7:picture        := "!!!-!!!-!!!!!!!!!!!!"
      oEdit7:create()
      oFLayout:addRow( "Catalog Item:", oEdit7:edit() )

      oEdit8                := HbQtGet():new()
      oEdit8:parent         := oWnd
      oEdit8:block          := {|x| iif( x == NIL, nSlry, nSlry := x ) }
      oEdit8:postBlock      := {|| nSlry > 600 .AND. nSlry < 17000 }
      oEdit8:picture        := "@Z 99,999"
      oEdit8:create()
      oFLayout:addRow( "Salary:", oEdit8:edit() )

   ENDIF

   oWnd:show()
   QApplication():exec()

   RETURN NIL

/*----------------------------------------------------------------------*/

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

   RETURN .T.

/*----------------------------------------------------------------------*/
