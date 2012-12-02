/*
 * $Id$
 */

/*
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */

/*----------------------------------------------------------------------*/

#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "hbclass.ch"

/*----------------------------------------------------------------------*/

   #command QREAD => HbQtReadGets( aQGetList, .T. )
   #command QREAD PARENT <oParent> => HbQtReadGets( aQGetList, .F., <oParent> )

   #command @ <row>, <col> QGET <v> ;
                           [PICTURE <pic>] ;
                           [VALID <valid>] ;
                           [WHEN <when>  ] ;
                           [CAPTION <cap>] ;
                           [COLOR <color>] ;
                           [VALIDATOR <validator>] => ;
         AAdd( aQGetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ), <"v">, <pic>, <{valid}>, <{when}>, <cap>, <color>, <{validator}> } )

/*----------------------------------------------------------------------*/

FUNCTION Main( cMode )
   LOCAL oWnd, oVLayout, oHLayout, oFLayout, oBtnOK, oBtnCancel
   LOCAL oEdit1, oEdit2, oEdit3, oEdit4, oEdit5

   LOCAL cText := "DEF"
   LOCAL dDate := CToD( "04/06/1956" )
   LOCAL nNumb := 6030.130000
   LOCAL lMrd  := .T.
   LOCAL cJust := Space( 20 )

   LOCAL aQGetList := {}

   hb_default( @cMode, "O" )

   IF cMode == "O"
      oWnd    := QWidget()
      oWnd:resize( 400, 200 )
      oWnd:setWindowTitle( "Clipper Compliant Get System - Without Mouse" )

      oVLayout := QVBoxLayout( oWnd )
      oFLayout := QFormLayout()
      oHLayout := QHBoxLayout()

      oVLayout:addLayout( oFLayout )
      oVLayout:addLayout( oHLayout )

      oBtnOK := QPushButton( oWnd )
      oBtnOK:setText( "OK" )

      oBtnCancel := QPushButton( oWnd )
      oBtnCancel:setText( "Cancel" )

      oHLayout:addWidget( oBtnOK )
      oHLayout:addWidget( oBtnCancel )

      oBtnOK:setEnabled( .F. )

      oEdit1 := HbQtGet():new( oWnd )
      oEdit1:valid          := {|cValue| cValue == "ABC" .OR. cValue == "DEF" }
      oEdit1:picture        := "@!"
      oEdit1:dataLink       := {|x| iif( x == NIL, cText, cText := x ) }
      oEdit1:create()
      oFLayout:addRow( "Upper Cased Alphabets:", oEdit1 )

      oEdit2 := HbQtGet():new( oWnd )
      oEdit2:dataLink       := {|x| iif( x == NIL, dDate, dDate := x ) }
      oEdit2:when           := {|| cText == "ABC" }
      oEdit2:inputValidator := {|cText,nPos| DateBritish( cText, nPos ) }
      oEdit2:color          := "B/GR*"
      oEdit2:create()
      oFLayout:addRow( "British Date:", oEdit2 )

      oEdit3 := HbQtGet():new( oWnd )
      oEdit3:dataLink       := {|x| iif( x == NIL, nNumb, nNumb := x ) }
      oEdit3:valid          := {|| oBtnOK:setEnabled( .T. ) }
      oEdit3:inputValidator := {|cText,nPos| Upto6DecimalsOnly( cText, nPos ) }
      oEdit3:create()
      oFLayout:addRow( "Maximum 6 Decimals:", oEdit3 )

      oEdit4 := HbQtGet():new( oWnd )
      oEdit4:setMousable( .T. )
      oEdit4:picture        := "Y"
      oEdit4:dataLink       := {|x| iif( x == NIL, lMrd, lMrd := x ) }
      oEdit4:create()
      oFLayout:addRow( "Married ?", oEdit4 )

      oEdit5 := HbQtGet():new( oWnd )
      oEdit5:dataLink       := {|x| iif( x == NIL, cJust, cJust := x ) }
      oEdit5:inputValidator := {|cText,nPos| UpperLowerUpper( cText, nPos ) }
      oEdit5:color          := "W+/B*"
      oEdit5:create()
      oFLayout:addRow( "Upper Lower Upper:", oEdit5 )

      oEdit1:setFocus()
      oWnd:show()
      QApplication():exec()

   ELSE
      @ 10, 10 QGET cText VALID {|cValue| cValue == "ABC" .OR. cValue == "DEF" } PICTURE "@!" ;
             CAPTION "Upper Cased Alphabets:"

      @ 10, 40 QGET dDate WHEN {|| cText == "ABC" } VALIDATOR {|cText,nPos| DateBritish( cText, nPos ) } ;
             CAPTION "British Date:" COLOR "B/GR*"

      @ 10, 70 QGET nNumb VALIDATOR {|cText,nPos| Upto6DecimalsOnly( cText, nPos ) } ;
             CAPTION "Maximum 6 Decimals:"

      @ 10,100 QGET lMrd  PICTURE "Y" ;
             CAPTION "Married ?"

      @ 10,130 QGET cJust COLOR "W+/B*" VALIDATOR {|cText,nPos| UpperLowerUpper( cText, nPos ) } ;
             CAPTION "Upper Lower Upper:"

      QREAD

   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

STATIC FUNCTION HbQtReadGets( aGetList, lModal, oParent )
   LOCAL oWnd, oVLayout, oFLayout, oHLayout, oBtnOK, oBtnCancel, oEdit, aEdit

   HB_SYMBOL_UNUSED( lModal )
   HB_SYMBOL_UNUSED( oParent )

   IF Len( aGetList ) >= 1
      oWnd    := QWidget()
      oWnd:resize( 400, 200 )
      oWnd:setWindowTitle( "Clipper Compliant Get System - Without Mouse" )

      oVLayout := QVBoxLayout( oWnd )
      oFLayout := QFormLayout()
      oHLayout := QHBoxLayout()

      oVLayout:addLayout( oFLayout )
      oVLayout:addLayout( oHLayout )

      oBtnOK := QPushButton( oWnd )
      oBtnOK:setText( "OK" )

      oBtnCancel := QPushButton( oWnd )
      oBtnCancel:setText( "Cancel" )

      oHLayout:addWidget( oBtnOK )
      oHLayout:addWidget( oBtnCancel )

      FOR EACH aEdit IN aGetList
         oEdit := HbQtGet():new()
         oEdit:dataLink := aEdit[ 1 ]:block()
         oEdit:name := aEdit[ 2 ]
         IF ! Empty( aEdit[ 3 ] )
            oEdit:picture := aEdit[ 3 ]
         ENDIF
         IF ! Empty( aEdit[ 4 ] )
            oEdit:valid := aEdit[ 4 ]
         ENDIF
         IF ! Empty( aEdit[ 5 ] )
            oEdit:when := aEdit[ 5 ]
         ENDIF
         IF ! Empty( aEdit[ 7 ] )
            oEdit:color := aEdit[ 7 ]
         ENDIF
         IF HB_ISBLOCK( aEdit[ 8 ] )
            oEdit:inputValidator := aEdit[ 8 ]
         ENDIF
         oEdit:create()
         oFLayout:addRow( iif( Empty( aEdit[ 6 ] ), aEdit[ 2 ], aEdit[ 6 ] ), oEdit )
      NEXT

      oWnd:show()
      QApplication():sendEvent( oWnd, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      QApplication():exec()
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/
//                            CLASS HbQtEdit
/*----------------------------------------------------------------------*/

CLASS HbQtGet INHERIT HB_QLineEdit

   METHOD create()
   METHOD name( cName )                           SETGET
   METHOD when( bBlock )                          SETGET
   METHOD valid( bBlock )                         SETGET
   METHOD picture( cPicture )                     SETGET
   METHOD color( cnaColor )                       SETGET
   METHOD inputValidator( bBlock )                SETGET
   METHOD dataLink( bBlock )                      SETGET
   METHOD setMousable( lEnable )                  SETGET
   METHOD setData( xData )
   METHOD getData()

   PROTECTED:

   VAR    sl_name                                 INIT ""
   VAR    sl_whenblock
   VAR    sl_validBlock
   VAR    sl_picture                              INIT ""
   VAR    sl_color
   VAR    sl_inputValidator
   VAR    sl_dataLink
   VAR    sl_mousable                             INIT .F.
   VAR    sl_type                                 INIT "C"
   VAR    sl_orgValue
   VAR    sl_width                                INIT 0
   VAR    sl_dec                                  INIT 0

   METHOD checkWhen( oFocusEvent )
   METHOD checkValid( oKeyEvent )
   METHOD acceptOnlyUppers( cText )
   METHOD setInputValidator()

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtGet:create()

   ::setFocusPolicy( iif( ::sl_mousable, Qt_StrongFocus, Qt_TabFocus ) )

   ::connect( "returnPressed()", {|| QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) ) } )
   ::connect( QEvent_FocusIn   , {|oFocusEvent| ::checkWhen( oFocusEvent ) } )
   ::connect( QEvent_KeyPress  , {|oKeyEvent  | ::checkValid( oKeyEvent ) } )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:name( cName )

   IF HB_ISCHAR( cName )
      ::sl_name := cName
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:setMousable( lEnable )

   IF HB_ISLOGICAL( lEnable )
      ::sl_mousable := lEnable
   ENDIF

   IF ::sl_mousable
      ::setFocusPolicy( Qt_StrongFocus )
   ELSE
      ::setFocusPolicy( Qt_TabFocus )
   ENDIF

   RETURN ::sl_mousable

/*----------------------------------------------------------------------*/

METHOD HbQtGet:setInputValidator()
   LOCAL cTmp, n

   IF ! Empty( ::sl_inputValidator )
      RETURN Self
   ENDIF

   SWITCH ::sl_type
   CASE "C"
      ::sl_width       := Len( ::sl_orgValue )
      EXIT
   CASE "N"
      cTmp             := Str( ::sl_orgValue )
      ::sl_width       := Len( cTmp )
      n                := At( ".", cTmp )
      ::sl_dec         := iif( n > 0, Len( SubStr( cTmp, n+1 ) ), 0 )
      ::inputValidator := {|cText,nPos,v| v := SubStr( cText, nPos, 1 ), iif( nPos == 1, v $ "+-.1234567890", v $ ".1234567890" ) }
      EXIT
   CASE "D"
      ::sl_width       := Len( DToC( ::sl_orgValue ) )
      ::inputValidator := {|cText,nPos| DateBritish( cText, nPos ) }
      EXIT
   CASE "L"
      ::sl_width       := 1
      ::inputValidator := {|cText,nPos| GetLogical( cText, nPos, ::sl_picture ) }
      EXIT
   ENDSWITCH

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:inputValidator( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_inputValidator := bBlock
      ::setValidator( HBQValidator( ::sl_inputValidator ) )
   ENDIF

   RETURN ::sl_inputValidator

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getData()
   LOCAL xData := ::text()

   SWITCH ::sl_type
   CASE "C"
      RETURN Pad( xData, ::sl_width )
   CASE "N"
      RETURN Val( xData )
   CASE "D"
      RETURN CToD( xData )
   CASE "L"
      RETURN Left( xData, 1 ) $ "YyTt"
   ENDSWITCH

   RETURN ""

/*----------------------------------------------------------------------*/

METHOD HbQtGet:setData( xData )

   SWITCH ::sl_type
   CASE "C"
      ::setText( RTrim( xData ) )
      EXIT
   CASE "N"
      ::setText( hb_ntos( xData ) )
      EXIT
   CASE "D"
      ::setText( DToC( xData ) )
      EXIT
   CASE "L"
      ::setText( iif( xData, iif( ::sl_picture $ "Y", "Y", "T" ), iif( ::sl_picture $ "Y", "N", "F" ) ) )
      EXIT
   ENDSWITCH

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtGet:dataLink( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_orgValue := Eval( bBlock )
      ::sl_type     := ValType( ::sl_orgValue )
      ::sl_dataLink := bBlock
      ::setData( ::sl_orgValue )
      ::setInputValidator()
   ENDIF

   RETURN ::sl_dataLink

/*----------------------------------------------------------------------*/

METHOD HbQtGet:when( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_whenBlock := bBlock
   ENDIF

   RETURN ::sl_whenBlock

/*----------------------------------------------------------------------*/

METHOD HbQtGet:valid( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_validBlock := bBlock
   ENDIF

   RETURN ::sl_validBlock

/*----------------------------------------------------------------------*/

METHOD HbQtGet:picture( cPicture )

   hb_default( @cPicture, " " )
   ::sl_picture := cPicture

   SWITCH ::sl_picture
   CASE "@!"
      ::inputValidator := {|cText| ::acceptOnlyUppers( cText ) }
      EXIT
   CASE ""
      EXIT
   CASE " "
      EXIT
   ENDSWITCH

   RETURN ::sl_picture

/*----------------------------------------------------------------------*/

METHOD HbQtGet:color( cnaColor )
   LOCAL n, lExt, xFore, xBack, cCSS := "" , cCSSF, cCSSB

   hb_default( @cnaColor, "" )
   ::sl_color := cnaColor
   IF Empty( ::sl_color )
      RETURN ""
   ENDIF
   SWITCH ValType( ::sl_color )
   CASE "C"
      IF ( n := At( "/", ::sl_color ) ) > 0
         xFore := AllTrim( SubStr( ::sl_color, 1, n-1 ) )
         xBack := AllTrim( SubStr( ::sl_color, n+1 ) )
      ELSE
         xFore := AllTrim( cnaColor )
         xBack := ""
      ENDIF

      IF ! Empty( xFore )
         lExt := At( "+", xFore ) > 0
         xFore := StrTran( StrTran( xFore, "+" ), "*" )
         cCSSF := GetRgbStringFromClipperColor( xFore, lExt )
      ENDIF
      IF ! Empty( xBack )
         lExt := "+" $ xBack .OR. "*" $ xBack
         xBack := StrTran( StrTran( xBack, "+" ), "*" )
         cCSSB := GetRgbStringFromClipperColor( xBack, lExt )
      ENDIF
      IF ! Empty( cCSSF )
         cCSS := "color: " + cCSSF
      ENDIF
      IF ! Empty( cCSSB )
         cCSS += "; background-color: " + cCSSB
      ENDIF
      IF ! Empty( cCSS )
         cCSS += ";"
         ::setStyleSheet( cCSS )
      ELSE
         ::setStyleSheet( "" )
      ENDIF

      EXIT
   CASE "N"
      EXIT
   CASE "A"
      EXIT
   ENDSWITCH

   RETURN ::sl_color

/*----------------------------------------------------------------------*/

METHOD HbQtGet:checkWhen( oFocusEvent )

   IF HB_ISBLOCK( ::sl_whenBlock )
      IF ! Eval( ::sl_whenBlock, ::text() )
         oFocusEvent:accept()
         QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, iif( oFocusEvent:reason() == Qt_TabFocusReason, Qt_Key_Tab, Qt_Key_Backtab ), Qt_NoModifier ) )
         RETURN .T.
      ENDIF
   ENDIF

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:checkValid( oKeyEvent )

   SWITCH oKeyEvent:key()
   CASE Qt_Key_Up
      QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Backtab, Qt_NoModifier ) )
      EXIT
   CASE Qt_Key_Down
      QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      EXIT
   CASE Qt_Key_Tab
   CASE Qt_Key_Backtab
      IF HB_ISBLOCK( ::sl_validBlock )
         IF ! Eval( ::sl_validBlock, ::text() )
            oKeyEvent:accept()
            RETURN .T.
         ENDIF
      ENDIF
      IF HB_ISBLOCK( ::sl_dataLink )
         Eval( ::sl_dataLink, ::getData() )
      ENDIF
      EXIT
   ENDSWITCH

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:acceptOnlyUppers( cText )

   RETURN Upper( cText )

/*----------------------------------------------------------------------*/
//                        Utility Functions
/*----------------------------------------------------------------------*/

STATIC FUNCTION UpperLowerUpper( cText, nPos )
   LOCAL cChr, s

   IF ! IsAlpha( SubStr( cText, nPos, 1 ) )
      RETURN .F.
   ENDIF
   s := ""
   FOR EACH cChr IN cText
      IF cChr:__enumIndex() % 2 == 0
         s += Lower( cChr )
      ELSE
         s += Upper( cChr )
      ENDIF
   NEXT

   RETURN s

/*----------------------------------------------------------------------*/

STATIC FUNCTION Upto6DecimalsOnly( cText, nPos )
   LOCAL n, cChr := SubStr( cText, nPos, 1 )

   IF cChr == "."
      // Ok, check also required FOR doubling
   ELSEIF ! IsDigit( cChr )
      RETURN .F.
   ENDIF

   IF ! cChr == "." .AND. ( n := At( ".", cText ) ) > 0 .AND. Len( SubStr( cText, n + 1 ) ) > 6
      RETURN .F.
   ENDIF

   RETURN .T.

/*----------------------------------------------------------------------*/

STATIC FUNCTION DateBritish( cText, nPos )

   IF ! IsDigit( SubStr( cText, nPos, 1 ) ) .OR. Len( cText ) > 10
      RETURN .F.
   ENDIF

   SWITCH nPos
   CASE 2
      RETURN { cText + "/", ++nPos }
   CASE 5
      RETURN { cText + "/", ++nPos }
   ENDSWITCH

   RETURN .T.

/*----------------------------------------------------------------------*/

STATIC FUNCTION GetLogical( cText, nPos, cPicture )

   IF nPos > 1
      RETURN .F.
   ENDIF
   IF ! cText $ "NnYyTtFf"
      RETURN .F.
   ENDIF
   IF "Y" $ cPicture
      IF cText $ "Tt"
         RETURN "Y"
      ELSEIF cText $ "Ff"
         RETURN "N"
      ENDIF
   ELSE
      IF cText $ "Yy"
         RETURN "T"
      ELSEIF cText $ "Nn"
         RETURN "F"
      ENDIF
   ENDIF

   RETURN Upper( cText )

/*----------------------------------------------------------------------*/

STATIC FUNCTION GetRgbStringFromClipperColor( cToken, lExt )

   SWITCH Upper( cToken )
   CASE "N"
      RETURN iif( lExt, "rgb( 198,198,198 )", "rgb( 0 ,0 ,0  )"   )
   CASE "B"
      RETURN iif( lExt, "rgb( 0,0,255 )"    , "rgb( 0,0,133 )"    )
   CASE "G"
      RETURN iif( lExt, "rgb( 96,255,96 )"  , "rgb( 0 ,133,0  )"  )
   CASE "BG"
      RETURN iif( lExt, "rgb( 96,255,255 )" , "rgb( 0 ,133,133 )" )
   CASE "R"
      RETURN iif( lExt, "rgb( 248,0,38 )"   , "rgb( 133,0 ,0  )"  )
   CASE "RB"
      RETURN iif( lExt, "rgb( 255,96,255 )" , "rgb( 133,0 ,133  " )
   CASE "GR"
      RETURN iif( lExt, "rgb( 255,255,0 )"  , "rgb( 133,133,0 )"  )
   CASE "W"
      RETURN iif( lExt, "rgb( 255,255,255 )", "rgb( 96,96,96 )"   )
   ENDSWITCH
   RETURN ""

/*----------------------------------------------------------------------*/

