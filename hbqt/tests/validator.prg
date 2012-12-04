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
#include "set.ch"

/*----------------------------------------------------------------------*/

   #command QREAD => HbQtReadGets( aQGetList, .T. )
   #command QREAD PARENT <oParent> => HbQtReadGets( aQGetList, .F., <oParent> )

   #command @ <row>, <col> QGET <v> ;
                           [PICTURE <pic>] ;
                           [VALID <valid>] ;
                           [WHEN <when>  ] ;
                           [CAPTION <cap>] ;
                           [COLOR <color>] ;
                           [VALIDATOR <validator>] ;
                           [<noMouse: NOMOUSABLE> ]=> ;
         AAdd( aQGetList, { _GET_( <v>, <"v"> ), <"v">, <pic>, <{valid}>, <{when}>, <cap>, <color>, <{validator}>, <.noMouse.> } )
         //AAdd( aQGetList, { _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ), <"v">, <pic>, <{valid}>, <{when}>, <cap>, <color>, <{validator}>, <.noMouse.> } )

/*----------------------------------------------------------------------*/

FUNCTION Main( cMode )
   LOCAL oWnd, oVLayout, oHLayout, oFLayout, oBtnOK, oBtnCancel
   LOCAL oEdit1, oEdit2, oEdit3, oEdit4, oEdit5, oEdit6, oEdit7, oEdit8

   LOCAL cText := "ABC"
   LOCAL dDate := 0d19560604
   LOCAL nNumb := 6030.130001
   LOCAL lMrd  := .T.
   LOCAL cTele := "(999)684-7318"
   LOCAL cJust := Space( 20 )
   LOCAL cCata := "IT3-BEL-903533AST63Z"
   LOCAL nSlry := 12000

   LOCAL aQGetList := {}

   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )

   hb_default( @cMode, "O" )

   IF cMode == "O"
      oWnd    := QWidget()
      oWnd:resize( 400, 250 )
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

      oFLayout:setLabelAlignment( Qt_AlignRight )

      oBtnOK:setEnabled( .F. )

      oEdit1 := HbQtGet():new( oWnd )
      oEdit1:valid          := {|cValue| cValue == "ABC" .OR. cValue == "DEF" }
      oEdit1:picture        := "@!A"
      oEdit1:dataLink       := {|x| iif( x == NIL, cText, cText := x ) }
      oEdit1:create()
      oFLayout:addRow( "Alpha - Upper Cased Alphabets:", oEdit1 )

      oEdit2 := HbQtGet():new( oWnd )
      oEdit2:dataLink       := {|x| iif( x == NIL, dDate, dDate := x ) }
      oEdit2:when           := {|| cText == "ABC" }
      oEdit2:color          := "B/GR*"
      oEdit2:create()
      oFLayout:addRow( "Date - Birthday:", oEdit2 )

      oEdit3 := HbQtGet():new( oWnd )
      oEdit3:dataLink       := {|x| iif( x == NIL, nNumb, nNumb := x ) }
      oEdit3:valid          := {|| oBtnOK:setEnabled( .T. ), nNumb > 600 .AND. nNumb < 6000000 }
      oEdit3:picture        := "@Z 9,999,999.999999"
      oEdit3:create()
      oFLayout:addRow( "Numeric - Max 6 Decimals:", oEdit3 )

      oEdit4 := HbQtGet():new( oWnd )
      oEdit4:picture        := "@Y"
      oEdit4:dataLink       := {|x| iif( x == NIL, lMrd, lMrd := x ) }
      oEdit4:create()
      oFLayout:addRow( "Logical - Married:", oEdit4 )

      oEdit5                := HbQtGet():new( oWnd )
      oEdit5:dataLink       := {|x| iif( x == NIL, cTele, cTele := x ) }
      oEdit5:picture        := "(999)999-9999"
      oEdit5:create()
      oFLayout:addRow( "Telephone Number:", oEdit5 )

      oEdit6                := HbQtGet():new( oWnd )
      oEdit6:dataLink       := {|x| iif( x == NIL, cJust, cJust := x ) }
      oEdit6:inputValidator := {|cText,nPos| UpperLowerUpper( @cText, @nPos ) }
      oEdit6:color          := "W+/B*"
      oEdit6:create()
      oFLayout:addRow( "Alpha - Upper Lower Upper:", oEdit6 )

      oEdit7                := HbQtGet():new( oWnd )
      oEdit7:dataLink       := {|x| iif( x == NIL, cCata, cCata := x ) }
      oEdit7:picture        := "!!!-!!!-!!!!!!!!!!!!"
      oEdit7:create()
      oFLayout:addRow( "Catalog Item:", oEdit7 )

      oEdit8 := HbQtGet():new( oWnd )
      oEdit8:dataLink       := {|x| iif( x == NIL, nSlry, nSlry := x ) }
      oEdit8:valid          := {|| nSlry > 600 .AND. nSlry < 17000 }
      oEdit8:picture        := "@Z 99,999"
      oEdit8:create()
      oFLayout:addRow( "Salary:", oEdit8 )


      oWnd:connect( QEvent_KeyPress, {|oKeyEvent| iif( oKeyEvent:key() == Qt_Key_Escape, QApplication():sendEvent( QApplication(), QCloseEvent() ), NIL ) } )
      oWnd:show()
      QApplication():sendEvent( oWnd, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      QApplication():exec()

   ELSE
      @ 1, 10 QGET cText VALID {|cValue| cValue == "ABC" .OR. cValue == "DEF" } PICTURE "@!A" ;
             CAPTION "Alpha - Upper Cased Alphabets:"

      @ 2, 10 QGET dDate WHEN {|| cText == "ABC" } ;
             CAPTION "Date - Birthday:" COLOR "B/GR*"

      @ 3, 10 QGET nNumb PICTURE "@Z 9,999,999.999999" VALID {|| oBtnOK:setEnabled( .T. ), nNumb >= 600 .AND. nNumb <= 6000000 };
             CAPTION "Numeric - Max 6 Decimals:"

      @ 4, 10 QGET lMrd  PICTURE "Y" ;
             CAPTION "Logical - Married:"

      @ 5, 10 QGET cTele PICTURE "@! (999)999-9999" ;
             CAPTION "Telephone Number:"

      @ 6, 10 QGET cJust PICTURE "@A" COLOR "W+/B*" VALIDATOR {|cText,nPos| UpperLowerUpper( @cText, @nPos ) } ;
             CAPTION "Alpha - Upper Lower Upper:"

      @ 7, 10 QGET cCata PICTURE "@! !!!-!!!-!!!!!!!!!!!!" ;
             CAPTION "Catalog Item:"

      @ 3, 10 QGET nSlry PICTURE "@Z 99,999" VALID {|| nSlry > 600 .AND. nSlry < 17000 };
             CAPTION "Salary:"

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
      oWnd:resize( 400, 250 )
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
         oEdit:mousable := ! aEdit[ 9 ]

         oEdit:create()
         oFLayout:addRow( iif( Empty( aEdit[ 6 ] ), aEdit[ 2 ], aEdit[ 6 ] ), oEdit )
      NEXT

      oWnd:connect( QEvent_KeyPress, {|oKeyEvent| iif( oKeyEvent:key() == Qt_Key_Escape, QApplication():sendEvent( QApplication(), QCloseEvent() ), NIL ) } )
      oWnd:show()
      QApplication():sendEvent( oWnd, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      QApplication():exec()
   ENDIF

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
   METHOD mousable( lEnable )                     SETGET
   METHOD setData( xData )
   METHOD getData()

   PROTECTED:

   VAR    sl_name                                 INIT ""
   VAR    sl_whenblock
   VAR    sl_validBlock
   VAR    sl_pic                                  INIT ""
   VAR    sl_picture                              INIT ""
   VAR    sl_mask                                 INIT ""
   VAR    sl_qMask                                INIT ""
   VAR    sl_color
   VAR    sl_inputValidator
   VAR    sl_dataLink
   VAR    sl_mousable                             INIT .T.
   VAR    sl_type                                 INIT "C"
   VAR    sl_orgValue
   VAR    sl_width                                INIT 0
   VAR    sl_dec                                  INIT 0
   VAR    sl_prime                                INIT 0
   VAR    sl_dFormat                              INIT Set( _SET_DATEFORMAT )
   VAR    sl_cssColor                             INIT ""
   VAR    sl_cssNotValid                          INIT ""
   VAR    sl_decSep                               INIT "."
   VAR    sl_commaSep                             INIT ","

   METHOD checkWhen( oFocusEvent )
   METHOD checkValid( oKeyEvent )
   METHOD testValid()
   METHOD setParams()
   METHOD getNumber( cText, nPos )
   METHOD getDate( cText, nPos )
   METHOD getLogical( cText, nPos )
   METHOD getCharacter( cText, nPos )
   METHOD getRgbStringFromClipperColor( cToken, lExt )
   METHOD transformThis( xData, cMask )
   METHOD unTransformThis( cData )
   METHOD timesOccurs( cToken, cText )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtGet:create()

   ::setFocusPolicy( iif( ::sl_mousable, Qt_StrongFocus, Qt_TabFocus ) )

   ::connect( "returnPressed()", {|| QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) ) } )
   ::connect( QEvent_FocusIn   , {|oFocusEvent| ::checkWhen( oFocusEvent ) } )
   ::connect( QEvent_FocusOut  , {|| ::testValid() } )
   ::connect( QEvent_KeyPress  , {|oKeyEvent| ::checkValid( oKeyEvent ) } )

   ::setFont( QFont( "Courier New", 10 ) )

   ::sl_cssNotValid := "color: rgb(0,0,0); background-color: rgb(255,128,128);"

   ::setParams()
   ::setData( ::sl_orgValue )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:name( cName )

   IF HB_ISCHAR( cName )
      ::sl_name := cName
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:mousable( lEnable )

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

METHOD HbQtGet:setParams()
   LOCAL cTmp, cChr, n

   SWITCH ::sl_type
   CASE "C"
      ::sl_width       := Len( ::sl_orgValue )
      IF ! Empty( ::sl_mask )
         ::sl_width := Len( ::sl_mask )
         ::setInputMask( ::sl_qMask )
      ENDIF
      ::setMaxLength( ::sl_width )
      ::setValidator( HBQValidator( {|cText,nPos| ::getCharacter( cText, nPos ) } ) )
      EXIT
   CASE "N"
      IF "E" $ ::sl_picture
         ::sl_decSep := ","
         ::sl_commaSep := "."
      ENDIF
      IF ! Empty( ::sl_mask )
         cTmp       := ::sl_mask
         n          := At( ::sl_decSep, cTmp )
         ::sl_width := ::timesOccurs( "9", cTmp ) + iif( n > 0, 1, 0 )
         ::sl_dec   := iif( n > 0, ::timesOccurs( "9", SubStr( cTmp, n+1 ) ), 0 )
         ::sl_prime := ::sl_width - ::sl_dec
      ELSE
         cTmp       := Str( ::sl_orgValue )
         ::sl_width := Len( cTmp )
         n          := At( ::sl_decSep, cTmp )
         ::sl_dec   := iif( n > 0, Len( SubStr( cTmp, n+1 ) ), 0 )
         ::sl_prime := iif( n == 0, ::sl_width, ::sl_width - 1 - ::sl_dec )
      ENDIF
      ::setValidator( HBQValidator( {|cText,nPos| ::getNumber( cText, nPos ) } ) )
      IF ! ( "B" $ ::sl_picture )
         ::setAlignment( Qt_AlignRight )
      ENDIF
      EXIT
   CASE "D"
      ::sl_width := Len( DToC( ::sl_orgValue ) )
      cTmp       := Set( _SET_DATEFORMAT )
      ::sl_mask  := ""
      ::sl_qMask := ""
      FOR EACH cChr IN cTmp
         IF cChr $ "mdy"
            ::sl_mask  += "9"
            ::sl_qMask += "9"
         ELSE
            ::sl_mask  += cChr
            ::sl_qMask += cChr
         ENDIF
         ::setInputMask( ::sl_qMask )
      NEXT
      ::setValidator( HBQValidator( {|cText,nPos| ::getDate( cText, @nPos ) } ) )
      EXIT
   CASE "L"
      ::sl_width       := 1
      ::sl_qMask       := "x"
      ::setInputMask( ::sl_qMask )
      ::setValidator( HBQValidator( {|cText,nPos| ::getLogical( cText, nPos ) } ) )
      EXIT
   ENDSWITCH

   RETURN Self

/*----------------------------------------------------------------------*/
#if 0
 Get Picture Functions
--------------------------------------------------------------------------------
 A     C     Allow only alpha characters
 B     N     Display numbers left-justified
 C     N     Display CR after positive numbers
 D     D,N   Display dates in SET DATE format
 E     D,N   Display dates with day and month inverted independent of the current DATE SETting,
             numerics with comma and period reverse
 K     All   Delete default text if first key is not a cursor key
 R     C     Insert non-template characters in the display but do not
             save in the Get variable
 S<n>  C     Allows horizontal scrolling within a Get.  <n> is an integer
             that specifies the width of the region
 X     N     Display DB after negative numbers
 Z     N     Display zero as blanks
 (     N     Display negative numbers in parentheses with leading spaces
 )     N     Display negative numbers in parentheses without leading spaces
 !     C     Convert alphabetic character to upper case


 Get Picture Template Symbols
--------------------------------------------------------------------------------
 A    Allow only alphabetic characters
 N    Allow only alphabetic and numeric characters
 X    Allow any character
 9    Allow digits for any data type including sign for numerics
 #    Allow digits, signs and spaces for any data type
 !    Convert alphabetic character to upper case

 L    Allow only T, F, Y or N
 Y    Allow only Y or N

 $    Display a dollar sign in place of a leading space in a numeric
 *    Display an asterisk in place of a leading space in a numeric
 .    Display a decimal point
 ,    Display a comma


   Some examples
--------------------------------------------------------------------------------
 "@!"            -> all the alpha chars are uppercased
 "@! ANX9"       -> as above, but the first char must be alpha, the second alpha or numeric, the third any char, the fourth a digit
 "@E 999,999.99" -> comma is point (and viceversa) as for european numeric notation, two decimal are allowed
 "@Z 9999999"    -> no thousand separator, max 7 digits, if get value is 0 the edit buffer contains only spaces
 "999.99"        -> no thousand separator, max 3 integer (included the eventual sign) and 2 decimals, the decimal separator is point
 "@S20"          -> if the get buffer is more than 20 char long, editing after the 20th char causes the scrolling in place to manage the rest of the string
 "Y"             -> the get accept only one char corresponding to Y or N
 "L"             -> as above, but also T or F are accepted (true or false, obviously)

#endif

METHOD HbQtGet:getCharacter( cText, nPos )
   LOCAL cChr, lRet

   cChr := SubStr( cText, nPos, 1 )
HB_TRACE( HB_TR_ALWAYS, ::sl_qMask, ::sl_mask, nPos, cChr )
   IF "A" $ ::sl_picture .AND. ! IsAlpha( cChr )
      RETURN .F.
   ENDIF
   IF "!" $ ::sl_picture
      cText := Upper( cText )
   ENDIF
   IF ! Empty( ::sl_mask )
      SWITCH SubStr( ::sl_mask, nPos, 1 )
      CASE "A"
         IF ! IsAlpha( cChr )
            RETURN .F.
         ENDIF
         EXIT
      CASE "N"
         IF ! IsAlpha( cChr ) .OR. ! IsDigit( cChr )
            RETURN .F.
         ENDIF
         EXIT
      CASE "9"
         IF ! cChr $ "+-0123456789"
            RETURN .F.
         ENDIF
         EXIT
      CASE "#"
         IF ! cChr $ " +-0123456789"
            RETURN .F.
         ENDIF
         EXIT
      CASE "!"
         cText := SubStr( cText, 1, nPos - 1 ) + Upper( cChr ) + SubStr( cText, nPos + 1 )
         EXIT
      CASE "X"
         EXIT
      ENDSWITCH
   ENDIF
   lRet := .T.
   IF HB_ISBLOCK( ::sl_inputValidator )
      lRet := Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   RETURN { cText, nPos, lRet }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getNumber( cText, nPos )
   LOCAL cChr, lRet, nDecAt, lInDec, nTmp

   cChr := SubStr( cText, nPos, 1 )

   IF ! ( cChr $ ::sl_decSep + "+-1234567890" )
      RETURN .F.
   ENDIF
   IF cChr $ "+-" .AND. nPos == 1 .AND. SubStr( cText, 2, 1 ) $ "+-"
      cText := cChr + SubStr( cText, 3 )
   ENDIF
   IF cChr $ "+-" .AND. nPos > 1
      RETURN .F.
   ENDIF
   IF cChr $ "+-" .AND. ::timesOccurs( cChr, cText ) > 1
      RETURN .F.
   ENDIF
   IF cChr == ::sl_decSep .AND. ::sl_dec == 0
      RETURN .F.
   ENDIF
   IF cChr == ::sl_decSep .AND. ::timesOccurs( cChr, cText ) > 1
      cText  := SubStr( cText, 1, nPos - 1 ) + SubStr( cText, nPos + 1 )
      nPos   := At( ::sl_decSep, cText )
      nDecAt := At( ::sl_decSep, cText )
      cText  := SubStr( cText, 1, nDecAt ) + Left( SubStr( cText, nDecAt + 1 ), ::sl_dec )
      RETURN { cText, nPos, .T. }
   ELSEIF cChr == ::sl_decSep
      cText := ::transformThis( ::unTransformThis( cText ), ::sl_pic )
      RETURN { cText, nPos, .T. }
   ELSEIF Len( cText ) == 1              /* when selectall is active and a key is pressed */
      cText := ::transformThis( ::unTransformThis( cText ), ::sl_pic )
      RETURN { cText, nPos, .T. }
   ENDIF

   nDecAt := At( ::sl_decSep, cText )
   lInDec := iif( nDecAt == 0, .F., nPos >= nDecAt )
   IF lInDec
      cText := SubStr( cText, 1, nPos - 1 ) + cChr + SubStr( cText, nPos + 2, Len( cText ) - 1 )
      cText := ::transformThis( ::unTransformThis( cText ), ::sl_pic )
      RETURN { cText, nPos, .T. }
   ENDIF

   cText := ::unTransformThis( cText )
   nTmp := At( ::sl_decSep, cText )
   IF iif( nTmp > 0, nTmp - 1, Len( cText ) ) >= ::sl_prime
      RETURN .F.
   ENDIF
   cText := ::transformThis( cText, ::sl_pic )
   IF At( ::sl_decSep, cText ) > nDecAt
      nPos++
   ELSEIF At( ::sl_decSep, cText ) < nDecAt
      nPos--
   ENDIF

   lRet := .T.
   IF HB_ISBLOCK( ::sl_inputValidator )
      lRet := Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   IF Left( cText, 1 ) == "+"
      cText := SubStr( cText, 2 )
      nPos--
   ENDIF

   RETURN { cText, nPos, lRet }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getDate( cText, nPos )
   LOCAL lRet

   lRet  := .T.
   IF HB_ISBLOCK( ::sl_inputValidator )
      lRet := Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   RETURN { cText, nPos, lRet }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getLogical( cText, nPos )

   cText := Upper( SubStr( cText, nPos, 1 ) )

   IF ! cText $ "NnYyTtFf"
      RETURN .F.
   ENDIF
   IF "Y" $ ::sl_picture
      IF cText $ "Tt"
         cText :=  "Y"
      ELSEIF cText $ "Ff"
         cText :=  "N"
      ENDIF
   ELSE
      IF cText $ "Yy"
         cText := "T"
      ELSEIF cText $ "Nn"
         cText := "F"
      ENDIF
   ENDIF

   IF HB_ISBLOCK( ::sl_inputValidator )
      RETURN Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   RETURN { cText, 0, .T. }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getData()
   LOCAL cData := ::text()

   SWITCH ::sl_type
   CASE "C"
      RETURN Pad( cData, ::sl_width )
   CASE "N"
      RETURN Val( ::unTransformThis( cData ) )
   CASE "D"
      RETURN CToD( cData )
   CASE "L"
      RETURN Left( cData, 1 ) $ "YyTt"
   ENDSWITCH

   RETURN ""

/*----------------------------------------------------------------------*/

METHOD HbQtGet:setData( xData )

   SWITCH ::sl_type
   CASE "C"
      ::setText( RTrim( xData ) )
      EXIT
   CASE "N"
      ::setText( ::transformThis( xData, ::sl_pic ) )
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

METHOD HbQtGet:inputValidator( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_inputValidator := bBlock
   ENDIF

   RETURN ::sl_inputValidator

/*----------------------------------------------------------------------*/

METHOD HbQtGet:picture( cPicture )
   LOCAL n, cChr, qMask

   hb_default( @cPicture, "" )
   ::sl_pic := cPicture
   cPicture := Upper( AllTrim( cPicture ) )
   IF ( n := At( " " , cPicture ) ) > 0
      ::sl_mask := AllTrim( SubStr( cPicture, n+1 ) )
      ::sl_picture := AllTrim( SubStr( cPicture, 1, n-1 ) )
   ELSE
      ::sl_picture := cPicture
   ENDIF

   IF ! ( "@" $ ::sl_picture )
      ::sl_mask := ::sl_picture
      ::sl_picture := ""
   ENDIF
   IF ::sl_mask == "Y"
      ::sl_picture := "Y"
      ::sl_mask := ""
   ENDIF
   IF ::sl_mask == "L"
      ::sl_picture := ""
      ::sl_mask := ""
   ENDIF
   ::sl_picture := StrTran( StrTran( ::sl_picture, " " ), "@" )

   IF ! Empty( ::sl_mask )
      qMask := ""
      FOR EACH cChr IN ::sl_mask
         IF cChr $ "ALX9#!"
            qMask += "x"
         ELSE
            qMask += cChr
         ENDIF
      NEXT
      ::sl_qMask := qMask
   ENDIF

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
         cCSSF := ::getRgbStringFromClipperColor( xFore, lExt )
      ENDIF
      IF ! Empty( xBack )
         lExt := "+" $ xBack .OR. "*" $ xBack
         xBack := StrTran( StrTran( xBack, "+" ), "*" )
         cCSSB := ::getRgbStringFromClipperColor( xBack, lExt )
      ENDIF
      IF ! Empty( cCSSF )
         cCSS := "color: " + cCSSF
      ENDIF
      IF ! Empty( cCSSB )
         cCSS += "; background-color: " + cCSSB
      ENDIF
      IF ! Empty( cCSS )
         cCSS += ";"
         ::sl_cssColor := cCSS
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

METHOD HbQtGet:testValid()
   LOCAL lValid := .T.

   IF HB_ISBLOCK( ::sl_validBlock )
      lValid := Eval( ::sl_validBlock, ::getData() )
   ENDIF
   IF ! lValid
      ::setStyleSheet( "" )
      ::setStyleSheet( ::sl_cssNotValid )
   ELSE
      ::setStyleSheet( "" )
      ::setStyleSheet( ::sl_cssColor )
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
      IF ::sl_type == "D"    /* Must be a valid date if not empty */
         IF ! Empty( ::text() )
            IF Empty( ::getData() )
               oKeyEvent:accept()
               RETURN .T.
            ENDIF
         ENDIF
      ENDIF
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

METHOD HbQtGet:getRgbStringFromClipperColor( cToken, lExt )

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

METHOD HbQtGet:timesOccurs( cToken, cText )
   LOCAL cChr, n

   n := 0
   FOR EACH cChr IN cText
      IF cChr == cToken
         n++
      ENDIF
   NEXT

   RETURN n

/*----------------------------------------------------------------------*/

METHOD HbQtGet:transformThis( xData, cMask )

   IF ValType( xData ) == "C"
      xData := Val( AllTrim( xData ) )
   ENDIF

   RETURN AllTrim( Transform( xData, cMask ) )

/*----------------------------------------------------------------------*/

METHOD HbQtGet:unTransformThis( cData )
   LOCAL cChr, cText := ""

   FOR EACH cChr IN cData
      IF cChr $ ::sl_decSep + "+-0123456789"
         cText += cChr
      ENDIF
   NEXT

   RETURN cText

/*----------------------------------------------------------------------*/
