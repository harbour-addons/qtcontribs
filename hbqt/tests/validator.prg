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
#include "set.ch"

/*----------------------------------------------------------------------*/
//                   Part of separate - clip2hbqt.ch
/*----------------------------------------------------------------------*/
// #include "clip2hbqt.ch"

   #command @ <row>, <col> QSAY <exp> [PICTURE <pic>] [COLOR <clr>] => ;
         AAdd( SayList, { <row>, <col>, <exp>, <pic>, <clr> } )

   #command QREAD => HbQtReadGets( GetList, NIL, GetParent, .T. )
   #command QREAD [ PARENT <GetParent> ] [ FONT <oFont> ] => HbQtReadGets( GetList, SayList, <GetParent>, <oFont> )

   #command @ <row>, <col> QGET <v> ;
                              [PICTURE <pic>] ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [CAPTION <cap>] ;
                              [COLOR <color>] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE> ]=> ;
         AAdd( GetList, _QGET_( _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, NIL, NIL, NIL ) )

   #command @ <row>, <col> QSAY <sayExp> ;
                              [PICTURE <sayPic>] ;
                              [COLOR <sayColor>] ;
                           QGET <v> ;
                              [PICTURE <pic>] ;
                              [VALID <valid>] ;
                              [WHEN <when>  ] ;
                              [CAPTION <cap>] ;
                              [COLOR <color>] ;
                              [VALIDATOR <validator>] ;
                              [<noMouse: NOMOUSABLE> ]=> ;
         AAdd( GetList, _QGET_( _GET_( <v>, <"v">, <pic>, <{valid}>, <{when}> ),;
                                <cap>, <color>, <{validator}>, <.noMouse.>, <row>, <col>, ;
                                <sayExp>, <sayPic>, <sayColor> ) )

/*----------------------------------------------------------------------*/
//                         Application Code
/*----------------------------------------------------------------------*/

FUNCTION Main( cMode )

   LOCAL oWnd, oFLayout, oFrame
   LOCAL oEdit1, oEdit2, oEdit3, oEdit4, oEdit5, oEdit6, oEdit7, oEdit8
   LOCAL nPdL := 22, nColGet := 25

   LOCAL cText := "ABC"
   LOCAL dDate := 0d19560604
   LOCAL nNumb := 6030.130001
   LOCAL lMrd  := .T.
   LOCAL cTele := "(999)684-7318"
   LOCAL cJust := Space( 20 )
   LOCAL cCata := "IT3-BEL-903533AST63Z"
   LOCAL nSlry := 12 //000

   LOCAL GetList := {}
   LOCAL SayList := {}

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

      oFrame := QFrame( oWnd )
      oWnd:setWidget( oFrame )

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


      //QREAD PARENT oWnd
      QREAD PARENT oFrame FONT QFont( "Courier new", 12 )
      //QREAD PARENT oFrame

      oWnd:resize( oFrame:width()  + 2 + ( oWnd:frameGeometry():width()  - oWnd:geometry():width()  ),;
                   oFrame:height() + 2 + ( oWnd:frameGeometry():height() - oWnd:geometry():height() ) )
   ELSE
      oWnd := QWidget()
      oWnd:setWindowTitle( "Clipper Get System - Layout" )
      oWnd:connect( QEvent_KeyPress, {|oKeyEvent| iif( oKeyEvent:key() == Qt_Key_Escape, QApplication():sendEvent( QApplication(), QCloseEvent() ), NIL ) } )

      oFLayout := QFormLayout( oWnd )
      oFLayout:setLabelAlignment( Qt_AlignRight )
      oFLayout:setFieldGrowthPolicy( QFormLayout_FieldsStayAtSizeHint )
      oFLayout:setFormAlignment( Qt_AlignHCenter )

      oEdit1 := HbQtGet():new( oWnd )
      oEdit1:parent         := oWnd
      oEdit1:postBlock      := {|cValue| cValue == "ABC" .OR. cValue == "DEF" }
      oEdit1:picture        := "@!A"
      oEdit1:block          := {|x| iif( x == NIL, cText, cText := x ) }
      oEdit1:create()
      oFLayout:addRow( "Alpha - Upper Cased Alphabets:", oEdit1 )

      oEdit2 := HbQtGet():new( oWnd )
      oEdit2:parent         := oWnd
      oEdit2:block          := {|x| iif( x == NIL, dDate, dDate := x ) }
      oEdit2:preBlock       := {|| cText == "ABC" }
      oEdit2:postBlock      := {|| dDate >= 0d19560604 }
      oEdit2:color          := "B/GR*"
      oEdit2:create()
      oFLayout:addRow( "Date - Birthday:", oEdit2 )

      oEdit3 := HbQtGet():new( oWnd )
      oEdit3:parent         := oWnd
      oEdit3:block          := {|x| iif( x == NIL, nNumb, nNumb := x ) }
      oEdit3:postBlock      := {|| nNumb > 600 .AND. nNumb < 6000000 }
      oEdit3:picture        := "9,999,999.999999"
      oEdit3:create()
      oFLayout:addRow( "Numeric - Max 6 Decimals:", oEdit3 )

      oEdit4 := HbQtGet():new( oWnd )
      oEdit4:parent         := oWnd
      oEdit4:picture        := "@Y"
      oEdit4:block          := {|x| iif( x == NIL, lMrd, lMrd := x ) }
      oEdit4:create()
      oFLayout:addRow( "Logical - Married:", oEdit4 )

      oEdit5                := HbQtGet():new( oWnd )
      oEdit5:parent         := oWnd
      oEdit5:block          := {|x| iif( x == NIL, cTele, cTele := x ) }
      oEdit5:picture        := "(999)999-9999"
      oEdit5:create()
      oFLayout:addRow( "Telephone Number:", oEdit5 )

      oEdit6                := HbQtGet():new( oWnd )
      oEdit6:parent         := oWnd
      oEdit6:block          := {|x| iif( x == NIL, cJust, cJust := x ) }
      oEdit6:inputValidator := {|cText,nPos| UpperLowerUpper( @cText, @nPos ) }
      oEdit6:color          := "W+/B*"
      oEdit6:create()
      oFLayout:addRow( "Alpha - Upper Lower Upper:", oEdit6 )

      oEdit7                := HbQtGet():new( oWnd )
      oEdit7:parent         := oWnd
      oEdit7:block          := {|x| iif( x == NIL, cCata, cCata := x ) }
      oEdit7:picture        := "!!!-!!!-!!!!!!!!!!!!"
      oEdit7:create()
      oFLayout:addRow( "Catalog Item:", oEdit7 )

      oEdit8 := HbQtGet():new( oWnd )
      oEdit8:parent         := oWnd
      oEdit8:block          := {|x| iif( x == NIL, nSlry, nSlry := x ) }
      oEdit8:postBlock      := {|| nSlry > 600 .AND. nSlry < 17000 }
      oEdit8:picture        := "@Z 99,999"
      oEdit8:create()
      oFLayout:addRow( "Salary:", oEdit8 )

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
//                     Subject to Separate Library
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "hblang.ch"

#include "color.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "hblang.ch"

#include "color.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "button.ch"

#define GET_CLR_UNSELECTED                        0
#define GET_CLR_ENHANCED                          1
#define GET_CLR_CAPTION                           2
#define GET_CLR_ACCEL                             3

#define _QGET_GET                                 1
#define _QGET_CAPTION                             2
#define _QGET_COLOR                               3
#define _QGET_VALIDATOR                           4
#define _QGET_NOMOUSE                             5
#define _QGET_ROW                                 6
#define _QGET_COL                                 7
#define _QGET_SAY                                 8
#define _QGET_SAYPICTURE                          9
#define _QGET_SAYCOLOR                           10

/*----------------------------------------------------------------------*/

FUNCTION _QGET_( ... )
   LOCAL aParam := hb_aParams()

   aParam[ _QGET_GET ]:row := aParam[ _QGET_ROW ]
   aParam[ _QGET_GET ]:col := aParam[ _QGET_COL ]

   aParam[ _QGET_GET ]:cargo := aParam

   RETURN aParam[ _QGET_GET ]

/*----------------------------------------------------------------------*/
//              Called via QREAD - Equivalent TO ReadModal()
/*----------------------------------------------------------------------*/

FUNCTION __hbQtBindGetList( oWnd, GetList )
   LOCAL n, oGetList

   THREAD STATIC t_GetList := {}

   IF HB_ISOBJECT( oWnd )
      IF ( n := AScan( t_GetList, {|e_| e_[ 1 ] == oWnd } ) ) > 0
         oGetList := t_GetList[ n, 2 ]
      ENDIF
      IF HB_ISOBJECT( GetList )
         IF n > 0
            t_GetList[ n, 2 ] := GetList
         ELSE
            AAdd( t_GetList, { oWnd, GetList } )
         ENDIF
      ELSEIF PCount() >= 2 .AND. n > 0
         hb_ADel( t_GetList, n, .T. )
      ENDIF
   ENDIF

   RETURN oGetList

/*----------------------------------------------------------------------*/

FUNCTION HbQtReadGets( GetList, SayList, oWnd, oFont )
   LOCAL oFLayout, oEdit, aEdit, oGet, cClsName, oFontM, lFLayout
   LOCAL nLHeight, nAvgWid, cText, nObjHeight, oLabel, aPic
   LOCAL nLineSpacing := 6, nEditPadding := 4
   LOCAL nMinX := 50000, nMaxX := 0, nMinY := 50000, nMaxY := 0
   LOCAL nX, nY, nW, nH
   LOCAL aGetList := {}
   LOCAL oGetList

   IF Empty( oFont )
      oFont := QFont( QFont( "Courier New", 10 ) )
   ENDIF

   cClsName := __objGetClsName( oWnd )
   IF cClsName == "QFORMLAYOUT"
      oFLayout := oWnd
   ELSE
      oFLayout := oWnd:layout()
      IF ! Empty( oFLayout )
         oWnd:removeLayout( oFLayout )
      ENDIF
   ENDIF
   lFLayout := ! Empty( oFLayout )

   IF ! lFLayout                              /* Compute row height and formulae to have text width */
      oEdit := QLineEdit( oWnd )
      oEdit:setFont( oFont )
      oFontM     := QFontMetrics( oEdit:font() )
      nObjHeight := oFontM:height() + nEditPadding
      nAvgWid    := oFontM:averageCharWidth()
      nLHeight   := nObjHeight + nLineSpacing
      oEdit:setParent( QWidget() )
   ENDIF

   IF Len( GetList ) >= 1
      FOR EACH oGet IN GetList
         aEdit      := oGet:cargo
         IF ! Empty( aEdit[ _QGET_SAY ] )
            AAdd( SayList, { oGet:row, oGet:col, aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ], aEdit[ _QGET_SAYCOLOR ] } )
            oGet:col += Len( Transform( aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ] ) ) + 1
         ENDIF
      NEXT
   ENDIF

   /* This is independent of @ ... SAY ... GET combined */
   IF Len( SayList ) >= 1
      FOR EACH aPic IN SayList
         oLabel := QLabel( oWnd )
         cText  := Transform( aPic[ 3 ], aPic[ 4 ] )
         oLabel:setText( cText )
         oLabel:setFont( oFont )
         oLabel:setAlignment( Qt_AlignLeft + Qt_AlignVCenter )

         nX    := ( aPic[ 2 ] * nAvgWid ) + nLineSpacing
         nY    := aPic[ 1 ] * nLHeight
         nW    := nLineSpacing + ( Len( cText ) * nAvgWid )
         nH    := nObjHeight
         nMinX := Min( nMinX, nX )
         nMaxX := Max( nMaxX, nX + nW )
         nMinY := Min( nMinY, nY )
         nMaxY := Max( nMaxY, nY + nH )
         oLabel:move( nX, nY )
         oLabel:resize( nW, nH )
      NEXT
   ENDIF

   IF Len( GetList ) >= 1
      FOR EACH oGet IN GetList
         aEdit        := oGet:cargo
         oGet:cargo   := NIL

         oEdit        := HbQtGet():new( oWnd )
         oEdit:parent := oWnd
         oEdit:font   := oFont

         oEdit:get    := oGet   /* This is important - all variables will be initialized here instead of in :new() */

         IF ! Empty( aEdit[ _QGET_COLOR ] )
            oEdit:color := aEdit[ _QGET_COLOR ]
         ENDIF

         IF HB_ISBLOCK( aEdit[ _QGET_VALIDATOR ] )
            oEdit:inputValidator := aEdit[ _QGET_VALIDATOR ]
         ENDIF

         oEdit:mousable := ! aEdit[ _QGET_NOMOUSE ]

         oEdit:create()
         oEdit:setCursorPosition( 0 )

         IF lFLayout
            oFLayout:addRow( iif( Empty( aEdit[ _QGET_CAPTION ] ), oGet:name(), aEdit[ _QGET_CAPTION ] ), oEdit )
         ELSE
            nX    := ( oGet:col * nAvgWid ) + nLineSpacing
            nY    := oGet:row * nLHeight
            nW    := nLineSpacing + ( oEdit:getDispWidth() * nAvgWid )
            nH    := nObjHeight
            nMinX := Min( nMinX, nX )
            nMaxX := Max( nMaxX, nX + nW )
            nMinY := Min( nMinY, nY )
            nMaxY := Max( nMaxY, nY + nH )
            oEdit:move( nX, nY )
            oEdit:resize( nW, nH )
         ENDIF

         AAdd( aGetList, oEdit )
      NEXT

      aGetList[ 1 ]:setFocus()
      aGetList[ 1 ]:selectAll()

      oWnd:resize( nMaxX + nMinX, nMaxY + nMinY )  /* Fit to the contents maintaining margins */

   ENDIF

   oGetList := HbQtGetList():New( aGetList )
   __hbQtBindGetList( oWnd, oGetList )
   __GetListSetActive( oGetList )
   __GetListLast( oGetList )

   /* Because a LOOP cannot be initiated, we need a mechanism to set the active getlist based on focus in oWnd */
   oWnd:connect( QEvent_FocusIn, {|oGetList| oGetList := __hbQtBindGetList( oWnd ), __GetListSetActive( oGetList ), __GetListLast( oGetList ), .F. } )
   /* Probably will be fired only when oWnd is a top level window - needs to be investigated further */
   oWnd:connect( QEvent_Close  , {|| __hbQtBindGetList( oWnd, NIL ), .F. } )

   RETURN NIL

/*----------------------------------------------------------------------*/
//                            CLASS HbQtEdit
/*----------------------------------------------------------------------*/

CLASS HbQtGet INHERIT HB_QLineEdit, Get

   METHOD create()
   METHOD get( oGet )                             SETGET
   METHOD parent( oParent )                       SETGET
   METHOD picture( cPicture )                     SETGET
   METHOD color( cnaColor )                       SETGET
   METHOD font( oFont )                           SETGET
   METHOD inputValidator( bBlock )                SETGET
   METHOD mousable( lEnable )                     SETGET
   METHOD setData( xData )
   METHOD getData()
   METHOD getDispWidth()                          INLINE ::sl_dispWidth

   PROTECTED:
   VAR    oGet
   VAR    oParent

   VAR    lValidWhen                              INIT .T.
   VAR    sl_maskChrs                             INIT ""
   VAR    sl_qMask                                INIT ""

   VAR    sl_color
   VAR    sl_inputValidator
   VAR    sl_mousable                             INIT .T.

   VAR    sl_dispWidth                            INIT 0
   VAR    sl_width                                INIT 0
   VAR    sl_dec                                  INIT 0
   VAR    sl_prime                                INIT 0

   VAR    sl_dFormat                              INIT Set( _SET_DATEFORMAT )

   VAR    sl_cssColor                             INIT ""
   VAR    sl_cssNotValid                          INIT ""
   VAR    sl_decSep                               INIT "."
   VAR    sl_commaSep                             INIT ","
   VAR    sl_fixupCalled                          INIT .F.
   VAR    sl_font

   METHOD execFocusOut( oFocusEvent )
   METHOD execFocusIn( oFocusEvent )
   METHOD execKeyPress( oKeyEvent )
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
   METHOD fixup( cText )
   METHOD returnPressed()
   METHOD isBufferValid()
   METHOD isDateBad()

   EXPORTED:
   /* ::oGet operation methods overloaded from GET : begins */
   METHOD assign()
   METHOD block( bBlock )                         SETGET
   ACCESS pos                                     METHOD getPos()
   ASSIGN pos                                     METHOD setPos( nPos )
   METHOD updateBuffer()
   METHOD putMask( xValue, lEdit )
   METHOD reset()
   /* ::oGet operation methods overloaded from GET : ends */

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtGet:create()

   ::setFocusPolicy( iif( ::sl_mousable, Qt_StrongFocus, Qt_TabFocus ) )

   ::connect( "textEdited(QString)" , {|| ::testValid() } )
   ::connect( "textChanged(QString)", {|| ::testValid() } )

   ::connect( QEvent_FocusOut       , {|oFocusEvent| ::execFocusOut( oFocusEvent ) } )

   ::connect( "returnPressed()"     , {|| ::returnPressed(), .F. } )

   ::connect( QEvent_FocusIn        , {|oFocusEvent| ::execFocusIn( oFocusEvent ) } )
   ::connect( QEvent_KeyPress       , {|oKeyEvent| ::execKeyPress( oKeyEvent ) } )

   IF ! HB_ISOBJECT( ::sl_font )
      ::sl_font := QFont( "Courier New", 10 )
   ENDIF
   ::setFont( ::sl_font )

   ::sl_cssNotValid := "color: rgb(0,0,0); background-color: rgb(255,128,128);"

   ::setParams()
   ::setData( ::original )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:get( oGet )

   IF HB_ISOBJECT( oGet )
      ::oGet      := oGet

      ::subScript := ::oGet:subScript()
      ::preBlock  := ::oGet:preBlock()
      ::postBlock := ::oGet:postBlock()
      ::picture   := ::oGet:picture()
      ::name      := ::oGet:name()
      ::row       := ::oGet:row()
      ::col       := ::oGet:col()
      ::block     := ::oGet:block()
   ENDIF

   RETURN ::oGet

/*----------------------------------------------------------------------*/

METHOD HbQtGet:parent( oParent )

   IF HB_ISOBJECT( oParent )
      ::oParent := oParent
   ENDIF

   RETURN ::oParent

/*----------------------------------------------------------------------*/

METHOD HbQtGet:font( oFont )

   IF HB_ISOBJECT( oFont )
      ::sl_font := oFont
   ENDIF

   RETURN ::sl_font

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

METHOD HbQtGet:returnPressed()

   QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )

   RETURN .T.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:fixup( cText )

   ::sl_fixupCalled := .T.

   IF Len( cText ) == 0
      SWITCH ::cType
      CASE "C"   ; RETURN ""
      CASE "N"   ; RETURN "0"
      CASE "D"   ; RETURN CToD( "" )
      CASE "L"   ; RETURN "F"
      ENDSWITCH
   ENDIF

   RETURN NIL

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

   LOCAL cChr, lRet, cMask, nP

   IF ::sl_fixupCalled
      ::sl_fixupCalled := .F.
      RETURN .T.
   ENDIF

   IF Len( cText ) == 0
      RETURN .T.
   ENDIF
   cChr := SubStr( cText, nPos, 1 )

   IF "A" $ ::cPicFunc .AND. ! IsAlpha( cChr )
      RETURN .F.
   ENDIF
   IF "!" $ ::cPicFunc
      cText := Upper( cText )
   ENDIF
   IF ! Empty( ::cPicMask )
      IF cChr $ ::sl_maskChrs
         nP := nPos - 1
         cMask := SubStr( ::cPicMask, nP-1, 1 )
         cChr := SubStr( cText, nP, 1 )
      ELSE
         nP := nPos
         cMask := SubStr( ::cPicMask, nP, 1 )
      ENDIF

      SWITCH cMask
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
         cText := SubStr( cText, 1, nP - 1 ) + Upper( cChr ) + SubStr( cText, nP + 1 )
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

   LOCAL cChr, lRet, nDecAt, lInDec, nTmp, cImage

   IF ::sl_fixupCalled
      ::sl_fixupCalled := .F.
      RETURN .T.
   ENDIF
   cImage := cText

   cChr := SubStr( cText, nPos, 1 )

   IF cChr == "-" .AND. Len( cText ) == 1
      RETURN .T.
   ENDIF
   IF ! ( cChr $ ::sl_decSep + "+-1234567890" )   /* It must be a number character */
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF
   IF cChr $ "+-" .AND. nPos > 1
      RETURN .F.
   ENDIF
   IF cChr $ "+-" .AND. nPos == 1 .AND. SubStr( cText, 2, 1 ) $ "+-"
      RETURN .F.
   ENDIF
   IF cChr == ::sl_decSep .AND. ::sl_dec == 0  /* Variable does not hold decimal places */
      RETURN .F.
   ENDIF
   IF cChr == ::sl_decSep .AND. ::timesOccurs( cChr, cText ) > 1 /* Jump to decimal if present */
      cText  := SubStr( cText, 1, nPos - 1 ) + SubStr( cText, nPos + 1 )
      nPos   := At( ::sl_decSep, cText )
      nDecAt := At( ::sl_decSep, cText )
      cText  := SubStr( cText, 1, nDecAt ) + Left( SubStr( cText, nDecAt + 1 ), ::sl_dec )
      RETURN { cText, nPos, .T. }
   ELSEIF cChr == ::sl_decSep
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ELSEIF Len( cText ) <= 1              /* when selectall is active and a key is pressed */
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF

   nDecAt := At( ::sl_decSep, cText )
   lInDec := iif( nDecAt == 0, .F., nPos >= nDecAt )
   IF lInDec
      cText := SubStr( cText, 1, nPos - 1 ) + cChr + SubStr( cText, nPos + 2, Len( cText ) - 1 )
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF

   cText := ::unTransformThis( cText )
   nTmp := At( ::sl_decSep, cText )
   IF iif( nTmp > 0, nTmp - 1, Len( cText ) ) > ::sl_prime
      RETURN .F.
   ENDIF
   cText := ::transformThis( cText, ::cPicture )
   IF nDecAt > 0
      IF At( ::sl_decSep, cText ) > nDecAt
         nPos++
      ELSEIF At( ::sl_decSep, cText ) < nDecAt
         nPos--
      ENDIF
   ENDIF

   lRet := .T.
   IF HB_ISBLOCK( ::sl_inputValidator )
      lRet := Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   IF Left( cText, 1 ) == "+"
      cText := SubStr( cText, 2 )
      nPos--
   ENDIF

   IF cChr $ "+-" .AND. Len( cText ) == 0
      RETURN { "-", 1, .T. }
   ENDIF

   IF Len( cImage ) < Len( cText )  /* Some formatting character is inserted */
      nTmp := 0
      FOR EACH cChr IN cImage
         IF SubStr( cText, cChr:__enumIndex(), 1 ) != cChr
            EXIT
         ENDIF
         nTmp++
      NEXT
      IF nTmp < nPos .AND. nPos == Len( cText ) - 1
         nPos++
      ENDIF
   ELSEIF Len( cImage ) > Len( cText )
      // Some formatting character is deleted
   ENDIF

   RETURN { cText, nPos, lRet }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getDate( cText, nPos )

   LOCAL lRet

   IF ::sl_fixupCalled
      ::sl_fixupCalled := .F.
      RETURN .T.
   ENDIF

   lRet  := .T.
   IF HB_ISBLOCK( ::sl_inputValidator )
      lRet := Eval( ::sl_inputValidator, @cText, @nPos )
   ENDIF

   RETURN { cText, nPos, lRet }

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getLogical( cText, nPos )

   IF ::sl_fixupCalled
      ::sl_fixupCalled := .F.
      RETURN .T.
   ENDIF

   cText := Upper( SubStr( cText, nPos, 1 ) )

   IF ! cText $ "NnYyTtFf"
      RETURN .F.
   ENDIF
   IF "Y" $ ::cPicFunc
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

METHOD HbQtGet:setParams()

   LOCAL cTmp, cChr, n

   SWITCH ::cType
   CASE "C"
      ::sl_width := Len( ::original )
      IF ! Empty( ::cPicMask )
         ::sl_width := Len( ::cPicMask )
         ::setInputMask( ::sl_qMask )
      ENDIF
      ::sl_dispWidth := Len( Transform( ::original, ::cPicture ) )
      ::setMaxLength( ::sl_width )
      ::setValidator( HBQValidator( {|cText,nPos| ::getCharacter( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
      EXIT
   CASE "N"
      IF ! Empty( ::cPicMask )
         cTmp       := ::cPicMask
         n          := At( ::sl_decSep, cTmp )
         ::sl_width := ::timesOccurs( "9", cTmp ) + iif( n > 0, 1, 0 )
         ::sl_dec   := iif( n > 0, ::timesOccurs( "9", SubStr( cTmp, n+1 ) ), 0 )
         ::sl_prime := ::sl_width - iif( ::sl_dec > 0, ::sl_dec + 1, 0 )
      ELSE
         cTmp       := Str( ::original )
         ::sl_width := Len( cTmp )
         n          := At( ::sl_decSep, cTmp )
         ::sl_dec   := iif( n > 0, Len( SubStr( cTmp, n+1 ) ), 0 )
         ::sl_prime := iif( n == 0, ::sl_width, ::sl_width - 1 - ::sl_dec )
      ENDIF
      ::sl_dispWidth := Len( Transform( ::original, ::cPicture ) )
      ::setValidator( HBQValidator( {|cText,nPos| ::getNumber( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
      IF ! ( "B" $ ::cPicFunc )
         ::setAlignment( Qt_AlignRight )
      ENDIF
      IF "E" $ ::cPicFunc
         ::sl_decSep := ","
         ::sl_commaSep := "."
      ENDIF
      EXIT
   CASE "D"
      ::sl_width     := Len( DToC( ::original ) )
      cTmp           := Set( _SET_DATEFORMAT )
      ::sl_dispWidth := Len( Transform( ::original, ::cPicture ) )
      ::cPicMask      := ""
      ::sl_qMask     := ""
      FOR EACH cChr IN cTmp
         IF cChr $ "mdy"
            ::cPicMask  += "9"
            ::sl_qMask += "9"
         ELSE
            ::cPicMask  += cChr
            ::sl_qMask += cChr
         ENDIF
         ::setInputMask( ::sl_qMask )
      NEXT
      ::setValidator( HBQValidator( {|cText,nPos| ::getDate( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
      EXIT
   CASE "L"
      ::sl_width     := 1
      ::sl_dispWidth := 1
      ::setValidator( HBQValidator( {|cText,nPos| ::getLogical( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
      EXIT
   ENDSWITCH

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getData()

   LOCAL cData := ::text()

   SWITCH ::cType

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

   SWITCH ::cType

   CASE "C"
      ::setText( RTrim( xData ) )
      EXIT
   CASE "N"
      ::setText( ::transformThis( xData, ::cPicture ) )
      EXIT
   CASE "D"
      ::setText( DToC( xData ) )
      EXIT
   CASE "L"
      ::setText( iif( xData, iif( ::cPicFunc $ "Y", "Y", "T" ), iif( ::cPicFunc $ "Y", "N", "F" ) ) )
      EXIT

   ENDSWITCH

   RETURN NIL

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
   ::cPicture := cPicture
   cPicture := Upper( AllTrim( cPicture ) )
   IF ( n := At( " " , cPicture ) ) > 0
      ::cPicMask := AllTrim( SubStr( cPicture, n+1 ) )
      ::cPicFunc := AllTrim( SubStr( cPicture, 1, n-1 ) )
   ELSE
      ::cPicFunc := cPicture
   ENDIF

   IF ! ( "@" $ ::cPicFunc )
      ::cPicMask := ::cPicFunc
      ::cPicFunc := ""
   ENDIF
   IF ::cPicMask == "Y"
      ::cPicFunc := "Y"
      ::cPicMask := ""
   ENDIF
   IF ::cPicMask == "L"
      ::cPicFunc := ""
      ::cPicMask := ""
   ENDIF
   ::cPicFunc := StrTran( StrTran( ::cPicFunc, " " ), "@" )

   IF ! Empty( ::cPicMask )
      qMask := ""
      FOR EACH cChr IN ::cPicMask
         IF cChr $ "ALX9#!"
            qMask += "x"
         ELSE
            qMask += cChr
            ::sl_maskChrs += cChr
         ENDIF
      NEXT
      ::sl_qMask := qMask
   ENDIF

   RETURN ::cPicFunc

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
//                            QEvent_FocusOut
/*----------------------------------------------------------------------*/

METHOD HbQtGet:execFocusOut( oFocusEvent )

   LOCAL lValid := ::isBufferValid()

   IF lValid
      RETURN .F.
   ENDIF

   ::hasFocus := .F.

   oFocusEvent:ignore()
   ::setFocus()

   RETURN .T.

/*----------------------------------------------------------------------*/
//                             QEvent_FocusIn
/*----------------------------------------------------------------------*/

METHOD HbQtGet:execFocusIn( oFocusEvent )

   LOCAL oGetList

   IF ! Empty( oGetList := __hbQtBindGetList( ::oParent ) )
      __GetListSetActive( oGetList )
      __GetListLast( oGetList )
      oGetList:getActive( Self )
   ENDIF

   ::hasFocus := .T.

   IF HB_ISBLOCK( ::bPreBlock )
      IF ! ( ::lValidWhen := Eval( ::bPreBlock, ::getData() ) )
         oFocusEvent:accept()
         QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, iif( oFocusEvent:reason() == Qt_TabFocusReason, Qt_Key_Tab, Qt_Key_Backtab ), Qt_NoModifier ) )
         RETURN .T.
      ENDIF
   ENDIF

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:isBufferValid()

   LOCAL xValInVar, xValInBuffer
   LOCAL lValid := .T.

   IF ::cType == "D"
      IF ::isDateBad()
         RETURN ! lValid
      ENDIF
   ENDIF
   IF HB_ISBLOCK( ::bPostBlock )
      /* Fetch Clipper Variable Value */
      xValInVar    := ::varGet()
      xValInBuffer := ::getData()
      /* Set Clipper Variable Value with Value in Buffer */
      ::varPut( xValInBuffer )
      /* Validate passing value in buffer, in case OOP gets are constructed */
      lValid := Eval( ::bPostBlock, xValInBuffer )
      /* Set Clipper Variable back to Original Value */
      //Eval( ::sl_dataLink, xValInVar )
      ::varPut( xValInVar )
   ENDIF

   RETURN lValid

/*----------------------------------------------------------------------*/

METHOD HbQtGet:testValid()

   LOCAL lValid := ::isBufferValid()

   IF ! lValid
      ::setStyleSheet( "" )
      ::setStyleSheet( ::sl_cssNotValid )
      ::repaint()
   ELSE
      ::setStyleSheet( "" )
      ::setStyleSheet( ::sl_cssColor )
      ::repaint()
   ENDIF

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:isDateBad()
   LOCAL cChr

   FOR EACH cChr IN ::text()
      IF IsDigit( cChr )
         IF Empty( ::getData() )
            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtGet:execKeyPress( oKeyEvent )

   LOCAL oGetList

   SWITCH oKeyEvent:key()

   CASE Qt_Key_Escape
      ::varPut( ::original )
      ::setData( ::original )
      EXIT

   CASE Qt_Key_PageUp
      IF HB_ISOBJECT( oGetList := __hbQtBindGetList( ::parent() ) )
         oGetList:goTop( Self )
      ENDIF
      EXIT

   CASE Qt_Key_PageDown
      IF HB_ISOBJECT( oGetList := __hbQtBindGetList( ::parent() ) )
         oGetList:goBottom( Self )
      ENDIF
      EXIT

   CASE Qt_Key_Up
      QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Backtab, Qt_NoModifier ) )
      RETURN .T.

   CASE Qt_Key_Down
      QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      RETURN .T.

   CASE Qt_Key_Tab
   CASE Qt_Key_Backtab
      IF ! ::lValidWhen
         ::lValidWhen := .T.
         EXIT
      ENDIF

      IF ::cType == "D" .AND. ::isDateBad()
         oKeyEvent:accept()
         RETURN .T.
      ENDIF

      ::original := ::getData()
      ::varPut( ::original )
      IF HB_ISBLOCK( ::bPostBlock )
         IF ! Eval( ::bPostBlock, ::original )
            oKeyEvent:accept()
            RETURN .T.
         ELSE
            ::repaint()
         ENDIF
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
      IF cChr $ "+-0123456789"
         cText += cChr
      ELSEIF cChr == ::sl_decSep
         cText += "."
      ENDIF
   NEXT

   RETURN cText

/*----------------------------------------------------------------------*/
//                          GET Specific Methods
/*----------------------------------------------------------------------*/

METHOD HbQtGet:assign()

   IF ::hasFocus
      ::varPut( ::getData() )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:putMask( xValue, lEdit )

   hb_default( @lEdit, ::hasFocus )

   HB_SYMBOL_UNUSED( lEdit )

   RETURN Transform( xValue, ::cPicture )

/*----------------------------------------------------------------------*/

METHOD HbQtGet:updateBuffer()

   IF ::hasFocus
      ::cBuffer := ::putMask( ::varGet(), .F. )
      ::xVarGet := ::original
      ::setText( ::cBuffer )
   ELSE
      ::varGet()
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:reset()

   IF ::hasFocus
      ::cBuffer  := ::putMask( ::varGet(), .F. )
      ::xVarGet  := ::original
      ::cType    := ValType( ::xVarGet )
      ::pos      := 0
      ::lClear   := ( "K" $ ::cPicFunc .OR. ::cType == "N" )
      ::lEdit    := .F.
      ::lMinus   := .F.
      ::rejected := .F.
      ::typeOut  := !( ::type $ "CNDTL" ) .OR. ( ::nPos == 0 )
      ::setText( ::cBuffer )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getPos()
   RETURN ::cursorPosition()

/*----------------------------------------------------------------------*/

METHOD HbQtGet:setPos( nPos )

   IF HB_ISNUMERIC( nPos )
      nPos := Int( nPos )

      IF ::hasFocus
         ::setCursorPosition( nPos )
      ENDIF

      RETURN ::cursorPosition()
   ENDIF

   RETURN 0

/*----------------------------------------------------------------------*/

METHOD HbQtGet:block( bBlock )

   IF PCount() == 0 .OR. bBlock == NIL
      RETURN ::bBlock
   ENDIF

   ::bBlock   := bBlock
   ::xVarGet  := ::original := ::varGet()
   ::cType    := ValType( ::xVarGet )

   RETURN ::bBlock

/*----------------------------------------------------------------------*/
//                           CLASS HbQtGetList
/*----------------------------------------------------------------------*/

CLASS HbQtGetList INHERIT HbGetList

   METHOD goNext( oGet )
   METHOD goPrevious( oGet )
   METHOD goTop( oGet )
   METHOD goBottom( oGet )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtGetList:goNext( oGet )

   LOCAL n

   IF ( n := AScan( ::aGetList, {|o| o == oGet } ) ) > 0
      IF n < Len( ::aGetList )
         ::aGetList[ n + 1 ]:setFocus()
         RETURN ::aGetList[ n + 1 ]
      ENDIF
   ENDIF

   RETURN oGet

/*----------------------------------------------------------------------*/

METHOD HbQtGetList:goPrevious( oGet )

   LOCAL n

   IF ( n := AScan( ::aGetList, {|o| o == oGet } ) ) > 0
      IF n > 1
         ::aGetList[ n - 1 ]:setFocus()
         RETURN ::aGetList[ n - 1 ]
      ENDIF
   ENDIF

   RETURN oGet

/*----------------------------------------------------------------------*/

METHOD HbQtGetList:goTop( oGet )

   LOCAL n

   IF ( n := AScan( ::aGetList, {|o| o == oGet } ) ) > 0
      IF n > 1
         ::aGetList[ 1 ]:setFocus()
         RETURN ::aGetList[ 1 ]
      ENDIF
   ENDIF

   RETURN oGet

/*----------------------------------------------------------------------*/

METHOD HbQtGetList:goBottom( oGet )

   LOCAL n

   IF ( n := AScan( ::aGetList, {|o| o == oGet } ) ) > 0
      IF n < Len( ::aGetList )
         ::aGetList[ Len( ::aGetList ) ]:setFocus()
         RETURN ::aGetList[ Len( ::aGetList ) ]
      ENDIF
   ENDIF

   RETURN oGet

/*----------------------------------------------------------------------*/
