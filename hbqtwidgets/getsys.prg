/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbtoqt.ch"

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

#include "hbqtgui.ch"
#include "hbqtstd.ch"

#include "hbtrace.ch"


#define _QGET_NAV_NEXT                            0
#define _QGET_NAV_PREVIOUS                        1
#define _QGET_NAV_BOTTOM                          2
#define _QGET_NAV_TOP                             3
#define _QGET_NAV_SELF                            4


CLASS HbQtGet INHERIT GET

   METHOD new( oControl )
   METHOD create( oControl )
   METHOD destroy()

   METHOD edit()                                  INLINE ::oEdit
   METHOD get( oGet )                             SETGET
   METHOD control( oControl )                     SETGET
   METHOD getList( oGetList )                     SETGET
   METHOD parent( oParent )                       SETGET
   METHOD picture( cPicture )                     SETGET
   METHOD color( cnaColor )                       SETGET
   METHOD font( oFont )                           SETGET
   METHOD inputValidator( bBlock )                SETGET
   METHOD mousable( lEnable )                     SETGET
   METHOD setData( xData )
   METHOD getData( cBuffer )
   METHOD getDispWidth()                          INLINE ::sl_dispWidth
   METHOD getDispHeight()                         INLINE ::sl_dispHeight
   METHOD setPosAndSize( aPos, aSize )
   METHOD setFocus( nFocusReason )
   METHOD widget( cWidget )                       SETGET
   METHOD toRow( nRow )                           SETGET
   METHOD toCol( nCol )                           SETGET
   METHOD data( xData )                           SETGET
   METHOD tooltip( cTip )                         SETGET
   METHOD positionCursor()
   METHOD terminate()                             INLINE ::oGetList:terminate()
   METHOD keyboard( nHbKey )                      INLINE __hbqtKeyBoard( nHbKey, ::oEdit )


   PROTECTED:

   VAR    oEdit
   VAR    oGet
   VAR    oParent
   VAR    oControl
   VAR    oGetList

   VAR    lValidWhen                              INIT .T.
   VAR    sl_maskChrs                             INIT ""
   VAR    sl_qMask                                INIT ""

   VAR    sl_color
   VAR    sl_inputValidator
   VAR    sl_mousable                             INIT .T.

   VAR    sl_dispWidth                            INIT 0
   VAR    sl_dispHeight                           INIT 1
   VAR    sl_width                                INIT 0
   VAR    sl_dec                                  INIT 0
   VAR    sl_prime                                INIT 0

   VAR    sl_dFormat                              INIT Set( _SET_DATEFORMAT )

   VAR    sl_cssColor                             INIT ""
   VAR    sl_cssNotValid                          INIT "color: rgb(0,0,0); background-color: rgb(255,128,128);"
   VAR    sl_decSep                               INIT "."
   VAR    sl_decProxy                             INIT "."
   VAR    sl_commaSep                             INIT ","
   VAR    sl_commaProxy                           INIT ","
   VAR    sl_fixupCalled                          INIT .F.
   VAR    lUserControl                            INIT .F.
   VAR    aPos                                    INIT {}
   VAR    aSize                                   INIT {}
   VAR    cClassName                              INIT ""
   VAR    cWidget                                 INIT "QLineEdit"
   VAR    nToRow                                  INIT 0
   VAR    nToCol                                  INIT 0
   VAR    sl_data                                 INIT NIL
   VAR    sl_tooltip                              INIT ""
   VAR    lFocusFrame                             INIT .F.

   VAR    oFocusFrame

   METHOD execFocusOut( oFocusEvent )
   METHOD execFocusIn( oFocusEvent )
   METHOD execKeyPress( oKeyEvent )
   METHOD execMousePress( oMouseEvent )
   METHOD execMouseRelease( oMouseEvent )
   METHOD setParams()
   METHOD getNumber( cText, nPos )
   METHOD getDate( cText, nPos )
   METHOD getLogical( cText, nPos )
   METHOD getCharacter( cText, nPos )
   METHOD unTransformProper( cBuffer )
   METHOD transformProper( cBuffer )
   METHOD transformThis( xData, cMask )
   METHOD unTransformThis( cData )
   METHOD timesOccurs( cToken, cText )
   METHOD fixup( cText )
   METHOD isDateBad()
   METHOD postValidate()
   METHOD preValidate()
   METHOD setColor( cMode )
   METHOD connect()
   METHOD isQLineEdit()                           INLINE ::cClassName == "QLINEEDIT"
   METHOD navigate( nDirection )
   METHOD handlePushButton()

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

   METHOD end()                                   INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_End      , Qt_NoModifier      ) )
   METHOD home()                                  INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Home     , Qt_NoModifier      ) )
   METHOD left()                                  INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Left     , Qt_NoModifier      ) )
   METHOD right()                                 INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Right    , Qt_NoModifier      ) )
   METHOD toDecPos()                              INLINE iif( ::sl_dec == 0, NIL, ::oEdit:setCursorPosition( At( ::sl_decProxy, ::text() ) ) )
   METHOD wordLeft()                              INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Left     , Qt_ControlModifier ) )
   METHOD wordRight()                             INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Right    , Qt_ControlModifier ) )

   METHOD backSpace()                             INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Backspace, Qt_NoModifier      ) )
   METHOD delete()                                INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Delete   , Qt_NoModifier      ) )
   METHOD delEnd()                                INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_K        , Qt_ControlModifier ) )
   METHOD delLeft()                               INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Backspace, Qt_NoModifier      ) )
   METHOD delRight()                              INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Delete   , Qt_NoModifier      ) )
   METHOD delWordLeft()                           INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Backspace, Qt_ControlModifier ) )
   METHOD delWordRight()                          INLINE QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Delete   , Qt_ControlModifier ) )

   METHOD insert( cChar )                         VIRTUAL
   METHOD overStrike( cChar )                     VIRTUAL

   METHOD untransform()
   ACCESS buffer                                  METHOD getBuffer()
   ASSIGN buffer                                  METHOD setBuffer( cBuffer )

   METHOD varGet()
   METHOD varPut( xValue )
   METHOD display()
   METHOD manageCursor()

   FRIEND CLASS HbQtGetList

   CLASSVAR oStyle                                INIT HBQProxyStyle()
   CLASSVAR sl_font

   DATA   nKeyPressed
   DATA   cPastBuffer
   DATA   nPastPosition
   DATA   nCharWidth

   ENDCLASS


METHOD HbQtGet:new( oControl )

   IF HB_ISOBJECT( oControl )
      ::oControl := oControl
   ENDIF

   RETURN Self


METHOD HbQtGet:destroy()
   HB_TRACE( HB_TR_DEBUG, "HbQtGet:destroy()" )

   IF ::widget() == "HbQtBrowse"
      ::data()[ 1 ]:destroy()
   ENDIF
   IF HB_ISOBJECT( ::oEdit )
      ::oEdit:setParent( QWidget() )
   ENDIF

   ::oParent   := NIL
   ::sl_font   := NIL
   ::oEdit     := NIL
   ::oGet      := NIL
   ::oControl  := NIL
   //::oGetList  := NIL

   RETURN NIL


METHOD HbQtGet:create( oControl )
   LOCAL xTmp

   hb_default( @oControl, ::oControl )

   IF HB_ISOBJECT( oControl )
      ::oControl := oControl
   ENDIF

   IF HB_ISOBJECT( ::oControl )
      ::lUserControl := .T.
      ::oEdit := ::oControl
   ELSE
      SWITCH ::widget
      CASE "QLineEdit"
         ::oEdit := QLineEdit( ::oParent )
         EXIT
      CASE "QPlainTextEdit"
         ::oEdit := QPlainTextEdit( ::oParent )
         ::oEdit:setTabChangesFocus( .T. )
         EXIT
      CASE "QListWidget"
         ::oEdit := QListWidget( ::oParent )
         EXIT
      CASE "QComboBox"
         ::oEdit := QComboBox( ::oParent )
         EXIT
      CASE "QPushButton"
         ::oEdit := QPushButton( ::oParent )
         ::oEdit:setText( ::sl_data[ _QDATA_PUSHBUTTON_TEXT ] )
         EXIT
      CASE "QCheckBox"
         ::oEdit := QCheckBox( ::oParent )
         EXIT
      CASE "HbQtBrowse"
         ::oEdit := QFrame( ::oParent )
         WITH OBJECT xTmp := QVBoxLayout( ::oEdit )
            :setContentsMargins( 0, 0, 0, 0 )
            :addWidget( ::data()[ 1 ]:oWidget )
         ENDWITH
         EXIT
      CASE "QImage"
         ::oEdit := QLabel( ::oParent )
         ::oEdit:setAlignment( Qt_AlignVCenter + Qt_AlignHCenter )
         EXIT
      ENDSWITCH
   ENDIF
   IF ! Empty( ::name )
      ::oEdit:setObjectName( ::name() )
   ENDIF

   ::cClassName :=__objGetClsName( ::oEdit )

   ::connect()

   ::oEdit:setFocusPolicy( iif( ::sl_mousable, Qt_StrongFocus, Qt_TabFocus ) )
   SWITCH ::cClassName
   CASE "QLINEEDIT"
   CASE "QPLAINTEXTEDIT"
   CASE "QLISTWIDGET"
   CASE "QCOMBOBOX"
      ::oEdit:setStyleSheet( ::sl_cssColor )
      ::oEdit:setFont( __getFont( ::sl_font ) )
      EXIT
   CASE "QPUSHBUTTON"
      ::oEdit:setStyleSheet( ::sl_cssColor )
      IF ! ::lUserControl
         ::oEdit:setFont( __getFont( ::sl_font ) )
      ENDIF
      EXIT
   CASE "QCHECKBOX"
   CASE "QFRAME"
   CASE "QLABEL"
      EXIT
   ENDSWITCH

   ::nCharWidth := QFontMetrics( __getFont( ::sl_font ) ):averageCharWidth()

   ::setParams()
   ::setData( ::original )

   ::oEdit:setToolTip( ::tooltip )
   ::lChanged := .F.

   IF ::cClassName == "QLINEEDIT"
   //   ::oStyle := HBQProxyStyle()
      ::oEdit:setStyle( ::oStyle )
      ::oEdit:home( .F. )
      ::positionCursor()
   ENDIF
   HB_SYMBOL_UNUSED( xTmp )
   RETURN Self


METHOD HbQtGet:connect()

   ::oEdit:connect( QEvent_FocusOut, {|oFocusEvent| ::execFocusOut( oFocusEvent ) } )
   ::oEdit:connect( QEvent_FocusIn , {|oFocusEvent| ::execFocusIn( oFocusEvent )  } )
   ::oEdit:connect( QEvent_KeyPress, {|oKeyEvent  | ::execKeyPress( oKeyEvent )   } )

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      ::oEdit:connect( "textEdited(QString)"    , {|| ::lChanged := .T. } )
      EXIT
   CASE "QPLAINTEXTEDIT"
      EXIT
   CASE "QLISTWIDGET"
      ::oEdit:connect( "itemSelectionChanged()" , {||  ::cBuffer := ::oEdit:currentItem():text(), ::assign() } )
      EXIT
   CASE "QCOMBOBOX"
      ::oEdit:connect( "currentIndexChanged(QString)", {|p|  ::cBuffer := p, ::assign()            } )
      EXIT
   CASE "QPUSHBUTTON"
      ::oEdit:connect( QEvent_MouseButtonPress  , {|oMouseEvent| ::execMousePress( oMouseEvent )   } )
      ::oEdit:connect( QEvent_MouseButtonRelease, {|oMouseEvent| ::execMouseRelease( oMouseEvent ) } )
      EXIT
   CASE "QCHECKBOX"
      ::oEdit:connect( "stateChanged(int)"      , {|i| ::varPut( i == Qt_Checked ) } )
      ::oEdit:connect( QEvent_MouseButtonPress  , {|oMouseEvent| ::execMousePress( oMouseEvent )   } )
      ::oEdit:connect( QEvent_MouseButtonRelease, {|oMouseEvent| ::execMouseRelease( oMouseEvent ) } )
      EXIT
   CASE "QFRAME"
   CASE "QLABEL"
      EXIT
   ENDSWITCH

   RETURN Self


METHOD HbQtGet:widget( cWidget )

   IF HB_ISCHAR( cWidget )
      ::cWidget := cWidget
   ENDIF

   RETURN ::cWidget


METHOD HbQtGet:control( oControl )

   IF HB_ISOBJECT( oControl )
      ::oControl := oControl
   ENDIF

   RETURN ::oControl


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


METHOD HbQtGet:parent( oParent )

   IF HB_ISOBJECT( oParent )
      ::oParent := oParent
   ENDIF

   RETURN ::oParent


METHOD HbQtGet:data( xData )

   IF PCount() == 1 .AND. ! Empty( xData )
      ::sl_data := xData
   ENDIF

   RETURN ::sl_data


METHOD HbQtGet:getList( oGetList )
   IF HB_ISOBJECT( oGetList )
      ::oGetList := oGetList
      ::lFocusFrame := oGetList:focusFrame()
      ::oFocusFrame := oGetList:oFocusFrame
      ::oFocusFrame:setStyleSheet( "border: 2px solid red" )
      ::oFocusFrame:hide()
   ENDIF
   RETURN ::oGetList


METHOD HbQtGet:setFocus( nFocusReason )
   IF HB_ISOBJECT( ::oEdit )
      IF ! Empty( nFocusReason )
         ::oEdit:setFocus( nFocusReason )
      ELSE
         ::oEdit:setFocus()
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtGet:manageCursor()
   IF ! Empty( ::oStyle )
      ::oStyle:hb_setPixelMetric( QStyle_PM_TextCursorWidth, iif( ReadInsert(), 1, ::nCharWidth ) )
   ENDIF
   RETURN Self


METHOD HbQtGet:font( oFont )
   IF HB_ISOBJECT( oFont )
      ::sl_font := NIL
      ::sl_font := oFont
   ENDIF
   RETURN ::sl_font


METHOD HbQtGet:setPosAndSize( aPos, aSize )

   hb_default( @aPos, ::aPos )
   hb_default( @aSize, ::aSize )

   ::aPos := aPos
   ::aSize := aSize

   IF HB_ISARRAY( ::aPos ) .AND. Len( ::aPos ) == 2
      ::oEdit:move( ::aPos[ 1 ], ::aPos[ 2 ] )
   ENDIF
   IF HB_ISARRAY( ::aSize ) .AND. Len( ::aSize ) == 2
      ::oEdit:resize( ::aSize[ 1 ], ::aSize[ 2 ] )
   ENDIF

   RETURN Self


METHOD HbQtGet:mousable( lEnable )

   IF HB_ISLOGICAL( lEnable )
      ::sl_mousable := lEnable
   ENDIF

   RETURN ::sl_mousable


METHOD HbQtGet:fixup( cText )
   HB_TRACE( HB_TR_DEBUG, "HbQtGet:fixup( " + cText + " )" )
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

   HB_TRACE( HB_TR_DEBUG, "nPos:", nPos, "::nPastPosition:", ::nPastPosition, "cChr:", cChr, "cText:", cText, "::cPastBuffer:", ::cPastBuffer )

   IF ::nKeyPressed != K_DEL .AND. ::nKeyPressed != K_BS
   ENDIF

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


METHOD HbQtGet:getNumber( cText, nPos )

   LOCAL cChr, lRet, nDecAt, lInDec, nTmp, cImage, cDel
   LOCAL lMinus := .F.

   IF ::sl_fixupCalled
      ::sl_fixupCalled := .F.
      RETURN .T.
   ENDIF
   IF cText == ::cPastBuffer   // Seems to be Fixup Call by HBQValidator() ?
      RETURN .T.
   ENDIF
   cImage := cText

   cChr := SubStr( cText, nPos, 1 )

   HB_TRACE( HB_TR_DEBUG, "nPos:", nPos, "::nPastPosition:", ::nPastPosition, "cChr:", cChr, "cText:", cText, "::cPastBuffer:", ::cPastBuffer )

   IF ::nKeyPressed == K_BS
      cDel := SubStr( ::cPastBuffer, ::nPastPosition, 1 )
      HB_TRACE( HB_TR_DEBUG, "BS - Deleted character:", cDel )
      IF cDel $ ".,"
         RETURN { ::cPastBuffer, --::nPastPosition, .T. }
      ENDIF
      IF nPos == 0
         RETURN { cText, nPos, .T. }
      ENDIF
   ELSEIF ::nKeyPressed == K_DEL
      cDel := SubStr( ::cPastBuffer, ::nPastPosition + 1, 1 )
      HB_TRACE( HB_TR_DEBUG, "DEL - Deleted character:", cDel )
      IF cDel $ ".,"
         RETURN { ::cPastBuffer, nPos + 1, .T. }
      ENDIF
   ENDIF

   /* Non-Numeric Characters Handelled */
   IF ! ( cChr $ ",.+-1234567890" )
      RETURN .F.
   ENDIF

   IF cChr == cText      /* when Editing starts with programatic insertion of chracters, like oHbQtBrowse:editCell() */
      IF cChr == "."
         IF "Z" $ ::cPicFunc
            RETURN { "." + ::transformThis( ::unTransformThis( "0" ), ::cPicture ), nPos, .T. }
         ENDIF
         RETURN { ::transformThis( ::unTransformThis( "0" ), ::cPicture ), nPos, .T. }
      ELSEIF cChr == "-"
         RETURN { "-" + ::transformThis( ::unTransformThis( "0" ), ::cPicture ), nPos, .T. }
      ENDIF
   ENDIF

   IF cChr == "-"
      IF ::timesOccurs( "-", cText ) > 1      /* Jump to minus if present */
         IF ::cPastBuffer == NIL
            cText := SubStr( cText, 1, nPos - 1 ) + SubStr( cText, nPos + 1 )
            RETURN { cText, 1, .T. }
         ELSE
            RETURN { ::cPastBuffer, 1, .T. }
         ENDIF
      ENDIF
      lMinus := .T.
   ENDIF
   /* Plus Minus Signs Handelled */
   IF cChr $ "+-"
      IF nPos == 1 .AND. SubStr( cText, 2, 1 ) $ "+-"
         RETURN .F.
      ELSEIF nPos == 2
         IF SubStr( cText, 1, 1 ) $ "-+"
            RETURN .F.
         ENDIF
         RETURN { cChr + Left( cText, 1 ) + SubStr( cText, 3 ), nPos, .T. }
      ELSEIF nPos > 2
         RETURN .F.
      ENDIF
   ENDIF
   /* Decimal Point Handelled */
   IF cChr $ ",."
      IF ::sl_dec == 0  /* Variable does not hold decimal places */
         RETURN .F.
      ENDIF

      cText := SubStr( cText, 1, nPos - 1 ) + ::sl_decProxy + SubStr( cText, nPos + 1 )
      IF ::timesOccurs( ::sl_decProxy, cText ) > 1      /* Jump to decimal if present */
         cText  := SubStr( cText, 1, nPos - 1 ) + SubStr( cText, nPos + 1 )
         nDecAt := At( ::sl_decProxy, cText )
         nPos   := nDecAt
         cText  := SubStr( cText, 1, nDecAt ) + Left( SubStr( cText, nDecAt + 1 ), ::sl_dec )
         RETURN { cText, nPos, .T. }
      ENDIF
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF

   IF Len( cText ) <= 1              /* when selectall is active and a key is pressed */
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF

   nDecAt := At( ::sl_decProxy, cText )

   lInDec := iif( nDecAt == 0, .F., nPos >= nDecAt )
   IF lInDec
      cText := SubStr( cText, 1, nPos - 1 ) + cChr + SubStr( cText, nPos + 2, Len( cText ) - 1 )
      cText := ::transformThis( ::unTransformThis( cText ), ::cPicture )
      RETURN { cText, nPos, .T. }
   ENDIF

   cText := ::unTransformThis( cText )
   nTmp := At( ::sl_decProxy, cText )
   IF iif( nTmp > 0, nTmp - 1, Len( cText ) ) > ::sl_prime
      RETURN .F.
   ENDIF
   cText := ::transformThis( cText, ::cPicture )

   IF nDecAt > 0
      IF At( ::sl_decProxy, cText ) > nDecAt
         nPos++
      ELSEIF At( ::sl_decProxy, cText ) < nDecAt
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

   IF lMinus .AND. Left( cText,1 ) != "-"
      cText := "-" + cText
      nPos++
   ENDIF

   RETURN { cText, nPos, lRet }


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


METHOD HbQtGet:setParams()

   LOCAL cTmp, cChr, n

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      SWITCH ::cType
      CASE "C"
         ::sl_width := Len( ::original )
         IF ! Empty( ::cPicMask )
            ::sl_width := Len( ::cPicMask )
            ::oEdit:setInputMask( ::sl_qMask )
         ENDIF
         ::sl_dispWidth := Len( Transform( ::original, ::cPicture ) )
         ::oEdit:setMaxLength( ::sl_width )
         ::oEdit:setValidator( HBQValidator( {|cText,nPos| ::getCharacter( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
#ifdef __HBQTMOBILE__
         ::oEdit:setInputMethodHints( Qt_ImhNoPredictiveText )
#endif
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
            ::cPicMask := iif( ::sl_dec == 0, Replicate( "9", ::sl_width ), Replicate( "9", ::sl_width - ::sl_dec - 1 ) + "." + Replicate( "9", ::sl_dec ) )
            ::cPicture := iif( Empty( ::cPicFunc ), "", "@" + ::cPicFunc ) + iif( Empty( ::cPicMask ), "", " " + ::cPicMask )
            ::sl_prime := iif( n == 0, ::sl_width, ::sl_width - 1 - ::sl_dec )
         ENDIF
         ::sl_dispWidth := Len( Transform( ::original, ::cPicture ) )
         ::oEdit:setValidator( HBQValidator( {|cText,nPos| ::getNumber( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
         IF ! ( "B" $ ::cPicFunc )
            ::oEdit:setAlignment( Qt_AlignRight )
         ENDIF
         IF "E" $ ::cPicFunc
            ::sl_decProxy := ","
            ::sl_commaProxy := "."
         ENDIF
#ifdef __HBQTMOBILE__
         ::oEdit:setInputMethodHints( Qt_ImhFormattedNumbersOnly )
#endif
         EXIT
      CASE "D"
         ::sl_width     := Len( DToC( ::varGet() ) )
         cTmp           := Set( _SET_DATEFORMAT )
         ::sl_dispWidth := Len( Transform( ::varGet(), ::cPicture ) )
         ::cPicMask     := ""
         ::sl_qMask     := ""
         FOR EACH cChr IN cTmp
            IF cChr $ "mMdDyY"
               ::cPicMask += "9"
               ::sl_qMask += "9"
            ELSE
               ::cPicMask  += cChr
               ::sl_qMask += cChr
            ENDIF
            ::oEdit:setInputMask( ::sl_qMask )
         NEXT
         ::oEdit:setValidator( HBQValidator( {|cText,nPos| ::getDate( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
#ifdef __HBQTMOBILE__
         ::oEdit:setInputMethodHints( Qt_ImhFormattedNumbersOnly )
#endif
         EXIT
      CASE "L"
         ::sl_width     := 1
         ::sl_dispWidth := 1
         ::oEdit:setValidator( HBQValidator( {|cText,nPos| ::getLogical( cText, nPos ) }, {|cText| ::fixup( cText ) } ) )
#ifdef __HBQTMOBILE__
         ::oEdit:setInputMethodHints( Qt_ImhUppercaseOnly + Qt_ImhNoPredictiveText )
#endif
         EXIT
      ENDSWITCH
      EXIT
   CASE "QPLAINTEXTEDIT"
#ifdef __HBQTMOBILE__
      ::oEdit:setInputMethodHints( Qt_ImhNoPredictiveText )
#endif
   CASE "QLISTWIDGET"
   CASE "QCOMBOBOX"
   CASE "QPUSHBUTTON"
   CASE "QFRAME"
      ::sl_dispWidth  := ::nToCol - iif( Empty( ::nCol ), 0, ::nCol ) + 1
      ::sl_dispHeight := ::nToRow - iif( Empty( ::nRow ), 0, ::nRow ) + 1
      EXIT
   CASE "QLABEL"
      ::sl_dispWidth  := ::nToCol - iif( Empty( ::nCol ), 0, ::nCol ) + 1
      ::sl_dispHeight := ::nToRow - iif( Empty( ::nRow ), 0, ::nRow ) + 1
      EXIT
   CASE "QCHECKBOX"
      ::sl_dispWidth  := 2
      ::sl_dispHeight := 1
      EXIT
   ENDSWITCH

   RETURN Self


METHOD HbQtGet:picture( cPicture )

   LOCAL n, cChr, qMask

   IF ! HB_ISCHAR( cPicture )
      RETURN ::cPicture
   ENDIF

   hb_default( @cPicture, "" )
   ::cPicture := cPicture
   cPicture := Upper( AllTrim( cPicture ) )
   IF "@" $ cPicture .AND. ( n := At( " " , cPicture ) ) > 0
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
      ::sl_qMask := qMask //+ ";~"
   ENDIF

   RETURN ::cPicture


METHOD HbQtGet:setColor( cMode )

   IF HB_ISOBJECT( ::oEdit )
      IF cMode == "normal"
         SWITCH ::cClassName
         CASE "QLINEEDIT"
         CASE "QPLAINTEXTEDIT"
         CASE "QLISTWIDGET"
         CASE "QCOMBOBOX"
         CASE "QPUSHBUTTON"
            ::oEdit:setStyleSheet( "" )
            ::oEdit:setStyleSheet( "outline: 5px solid #000; " + ::sl_cssColor )
            ::oEdit:repaint()
            EXIT
         ENDSWITCH
      ELSEIF cMode == "warning"
         SWITCH ::cClassName
         CASE "QLINEEDIT"
         CASE "QPLAINTEXTEDIT"
         CASE "QLISTWIDGET"
         CASE "QCOMBOBOX"
         CASE "QPUSHBUTTON"
            ::oEdit:setStyleSheet( "" )
            ::oEdit:setStyleSheet( "outline: 1px solid #000; " + ::sl_cssNotValid )
            ::oEdit:repaint()
            EXIT
         ENDSWITCH
      ENDIF
   ENDIF

   RETURN ::sl_cssColor


METHOD HbQtGet:color( cnaColor )

   hb_default( @cnaColor, "" )
   ::sl_color := cnaColor
   IF Empty( ::sl_color )
      RETURN ""
   ENDIF

   ::sl_cssColor := ""

   SWITCH ValType( ::sl_color )
   CASE "C"
      ::sl_cssColor := __hbqtCSSFromColorString( ::sl_color )
      EXIT

   ENDSWITCH

   ::setColor( "normal" )

   RETURN ::sl_color

/*----------------------------------------------------------------------*/
//                            QEvent_FocusOut
/*----------------------------------------------------------------------*/

METHOD HbQtGet:execFocusOut( oFocusEvent )  /* Should we validate before leaving */
   HB_TRACE( HB_TR_DEBUG, "HbQtGet:execFocusOut( oFocusEvent )", ::name() )

   HB_SYMBOL_UNUSED( oFocusEvent )

   IF ::cClassName == "QPLAINTEXTEDIT"
      ::cBuffer := ::oEdit:toPlainText()
      ::assign()
   ENDIF

   IF ::cClassName == "QLINEEDIT" .AND. oFocusEvent:reason() == Qt_MouseFocusReason .AND. ! ::postValidate()
      oFocusEvent:accept()
      ::navigate( _QGET_NAV_SELF )
      RETURN .T.
   ENDIF

   IF HB_ISOBJECT( ::oFocusFrame ) .AND. ::lFocusFrame
      ::oFocusFrame:hide()
   ENDIF
   ::hasFocus := .F.

   RETURN .F.


METHOD HbQtGet:execFocusIn( oFocusEvent )
   HB_TRACE( HB_TR_DEBUG, "HbQtGet:execFocusIn( oFocusEvent )", ::name() )

   IF ! Empty( ::oGetList )
      __GetListSetActive( ::oGetList )
      __GetListLast( ::oGetList )
      ::oGetList:getActive( Self )
      __hbqtGetsActiveWindow( ::oGetList:oWindow )
   ENDIF

   IF HB_ISOBJECT( ::oFocusFrame ) .AND. ::lFocusFrame
      ::oFocusFrame:setWidget( ::oEdit )
      ::oFocusFrame:show()
   ENDIF
   ::manageCursor()

   ::hasFocus := .T.

   IF ! ::preValidate()
      oFocusEvent:accept()
      ::navigate( iif( oFocusEvent:reason() == Qt_BacktabFocusReason, _QGET_NAV_PREVIOUS, _QGET_NAV_NEXT  ) )
      RETURN .T.

   ELSEIF ::cClassName == "QCOMBOBOX"
      QApplication():sendEvent( ::oEdit, QMouseEvent( QEvent_MouseButtonPress, QPoint( 1,1 ), Qt_LeftButton, Qt_LeftButton, Qt_NoModifier ) )

   ELSEIF ::cClassName == "QFRAME"
      ::data[ 1 ]:setFocus()

   ELSEIF ::cClassName == "QLABEL"
      ::keyBoard( K_ENTER )

   ENDIF

   RETURN .F.


METHOD HbQtGet:preValidate()

   LOCAL lWhen

   IF HB_ISBLOCK( ::preBlock )
      lWhen := Eval( ::preBlock, Self )

      IF HB_ISLOGICAL( lWhen ) .AND. ! lWhen
         ::display()
      ENDIF

      __GetListLast( ::oGetList )
   ENDIF

   RETURN iif( HB_ISLOGICAL( lWhen ), lWhen, .T. )


METHOD HbQtGet:postValidate()

   LOCAL lValid := .T.

   IF ::isDateBad()
      RETURN .F.
   ENDIF

   ::assign()                                     /* Has to be assigned no matter what */

   IF HB_ISBLOCK( ::postBlock )
      lValid := Eval( ::postBlock, Self )
      __GetListLast( ::oGetList )
   ENDIF

   lValid := iif ( HB_ISLOGICAL( lValid ), lValid, .T. )

   ::setColor( iif( lValid, "normal", "warning" ) )

   IF lValid
      ::original := ::varGet()    /* Is it OK ? */
      ::lChanged := .F.

      IF ! Empty( ::oGetList )
         IF ::oGetList:isLastGet( Self )
            IF HB_ISBLOCK( ::oGetList:lastGetBlock() )
               Eval( ::oGetList:lastGetBlock(), ::getData() )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lValid


METHOD HbQtGet:isDateBad()
   LOCAL cChr

   IF ::cType == "D" .AND. ::isQLineEdit()
      FOR EACH cChr IN ::oEdit:text()
         IF IsDigit( cChr )
            IF Empty( ::getData() )
               RETURN .T.
            ENDIF
         ENDIF
      NEXT
   ENDIF

   RETURN .F.


METHOD HbQtGet:execKeyPress( oKeyEvent )
   LOCAL cTmp
   LOCAL nKey := oKeyEvent:key()
   LOCAL nHbKey := HbQt_QtEventToHbEvent( oKeyEvent )

   IF HB_ISBLOCK( SetKey( nHbKey ) )
      Eval( SetKey( nHbKey ) )
      IF nHbKey == K_INS
         ::manageCursor()
      ENDIF
      oKeyEvent:accept()
      RETURN .T.
   ENDIF
   IF nHbKey == K_INS
      ::manageCursor()
   ENDIF

   ::nKeyPressed := nHbKey
   __hbqtSetLastKey( nHbKey )

   IF ::cClassName == "QLINEEDIT"
      ::cPastBuffer := ::oEdit:text()
      ::nPastPosition := ::oEdit:cursorPosition()
      HB_TRACE( HB_TR_DEBUG, nHbKey, ::nPastPosition, ::cPastBuffer, ReadInsert() )

      IF ::nKeyPressed >= 32 .AND. ::nKeyPressed < 127 .AND. ::Type() == "C" .AND. Empty( ::cPicMask ) .AND. ! ::oEdit:hasSelectedText()
         DO CASE
         CASE Len( ::cPastBuffer ) == ::sl_width
            IF ReadInsert()
               cTmp := Trim( PadC( SubStr( ::cPastBuffer, 1, ::nPastPosition ) + Chr( ::nKeyPressed ) + SubStr( ::cPastBuffer, ::nPastPosition + 1 ), ::sl_width ) )
            ELSE
               cTmp := Trim( PadC( SubStr( ::cPastBuffer, 1, ::nPastPosition ) + Chr( ::nKeyPressed ) + SubStr( ::cPastBuffer, ::nPastPosition + 2 ), ::sl_width ) )
            ENDIF
            ::oEdit:setText( cTmp )
            ::oEdit:setCursorPosition( ::nPastPosition + 1 )
         CASE ! ReadInsert()
            cTmp := SubStr( ::cPastBuffer, 1, ::nPastPosition ) + SubStr( ::cPastBuffer, ::nPastPosition + 2 )
            ::oEdit:setText( cTmp )
            ::oEdit:setCursorPosition( ::nPastPosition )
         ENDCASE
      ELSEIF nHbKey == K_CTRL_Y .AND. ::Type() == "C" .AND. Empty( ::cPicMask ) .AND. ! ::oEdit:hasSelectedText()
         cTmp := Trim( Pad( SubStr( ::cPastBuffer, 1, ::nPastPosition ), ::sl_width ) )
         ::oEdit:setText( cTmp )
      ENDIF
   ENDIF

   IF ::cClassName == "QCHECKBOX"
      IF nKey == Qt_Key_T .OR. nKey == Qt_Key_Y
         ::oEdit:setChecked( .T. )
         ::varPut( .T. )
         oKeyEvent:accept() ; RETURN .T.
      ELSEIF nKey == Qt_Key_F .OR. nKey == Qt_Key_N
         ::oEdit:setChecked( .F. )
         ::varPut( .F. )
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
   ENDIF

   SWITCH nKey
#if 0
   CASE Qt_Key_Escape
      ::varPut( ::original )
      ::setData( ::original )
      oKeyEvent:accept() ; RETURN .T.
#endif

   CASE Qt_Key_PageUp
      IF ! ( ::cClassName $ "QPLAINTEXTEDIT,QLISTWIDGET,QCOMBOBOX" )
         IF ::postValidate()
            ::navigate( _QGET_NAV_TOP )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
      EXIT

   CASE Qt_Key_PageDown
      IF ! ( ::cClassName $ "QPLAINTEXTEDIT,QLISTWIDGET,QCOMBOBOX" )
         IF ::postValidate()
            ::navigate( _QGET_NAV_BOTTOM )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
      EXIT

   CASE Qt_Key_Up
      IF ! ( ::cClassName $ "QPLAINTEXTEDIT,QLISTWIDGET,QCOMBOBOX" )
         IF ::postValidate()
            ::navigate( _QGET_NAV_PREVIOUS )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
      EXIT

   CASE Qt_Key_Down
      IF ! ( ::cClassName $ "QPLAINTEXTEDIT,QLISTWIDGET,QCOMBOBOX" )
         IF ::postValidate()
            ::navigate( _QGET_NAV_NEXT )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
      EXIT

   CASE Qt_Key_Enter
   CASE Qt_Key_Return
      IF ::cClassName $ "QLISTWIDGET,QCOMBOBOX,QPUSHBUTTON"
         IF ::postValidate()
            IF ::cClassName == "QPUSHBUTTON"
               ::handlePushButton()
            ELSE
               ::navigate( _QGET_NAV_NEXT )
            ENDIF
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ELSEIF ::cClassName == "QPLAINTEXTEDIT" .AND. hb_bitAnd( oKeyEvent:modifiers(), Qt_ControlModifier ) == Qt_ControlModifier
         IF ::postValidate()
            ::navigate( _QGET_NAV_NEXT )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ELSEIF ::cClassName == "QCHECKBOX"
         IF ::postValidate()
            ::navigate( _QGET_NAV_NEXT )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ELSEIF ::cClassName == "QLINEEDIT"
         IF ::postValidate()
            ::navigate( _QGET_NAV_NEXT )
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ELSEIF ::cClassName == "QFRAME"
         IF nHbKey == K_CTRL_ENTER
            ::navigate( _QGET_NAV_NEXT )
         ENDIF
      ELSEIF ::cClassName == "QLABEL"
         ::navigate( _QGET_NAV_NEXT )
      ENDIF
      EXIT

   CASE Qt_Key_W
      IF ::cClassName == "QPLAINTEXTEDIT" .AND. hb_bitAnd( oKeyEvent:modifiers(), Qt_ControlModifier ) == Qt_ControlModifier
         ::navigate( _QGET_NAV_NEXT )
      ENDIF
      EXIT

   CASE Qt_Key_Tab
   CASE Qt_Key_Backtab
      IF ! Empty( ::oGetList )
         IF ( nKey == Qt_Key_Tab .AND. ! ::oGetList:isLastGet( Self ) ) .OR. ;
            ( nKey == Qt_Key_Backtab .AND. ! ::oGetList:isFirstGet( Self ) )
            IF ::postValidate()
               ::navigate( iif( oKeyEvent:key() == Qt_Key_Tab, _QGET_NAV_NEXT, _QGET_NAV_PREVIOUS ) )
            ENDIF
         ENDIF
         oKeyEvent:accept() ; RETURN .T.
      ENDIF
      EXIT

   ENDSWITCH

   RETURN .F.


METHOD HbQtGet:execMouseRelease( oMouseEvent )

   SWITCH oMouseEvent:button()

   CASE Qt_LeftButton
      IF ::cClassName $ "QPUSHBUTTON"
         IF ::postValidate()
            ::handlePushButton()
         ENDIF
         oMouseEvent:accept(); RETURN .T.
      ENDIF
      EXIT

   ENDSWITCH

   RETURN .F.


METHOD HbQtGet:execMousePress( oMouseEvent )

   SWITCH oMouseEvent:button()

   CASE Qt_LeftButton   /* Focus-IN will handle */
      IF ::cClassName $ "PUSHBUTTON"
         #if 0
         IF ! ::preValidate()
            oMouseEvent:accept()
            RETURN .T.
         ENDIF
         #endif
         IF ! ::postValidate()
            oMouseEvent:accept()
            RETURN .T.
         ENDIF
         IF HB_ISBLOCK( ::sl_data[ _QDATA_PUSHBUTTON_ACTION ] )
            Eval( ::sl_data[ _QDATA_PUSHBUTTON_ACTION ] )
         ENDIF
      ENDIF
      EXIT

   CASE Qt_RightButton
      EXIT

   ENDSWITCH

   RETURN .F.


METHOD HbQtGet:handlePushButton()
   LOCAL cNextGet

   IF HB_ISBLOCK( ::sl_data[ _QDATA_PUSHBUTTON_ACTION ] )
      cNextGet := Eval( ::sl_data[ _QDATA_PUSHBUTTON_ACTION ], Self )
      IF ! Empty( cNextGet ) .AND. ! Empty( ::oGetList )
         ::oGetList:setFocus( cNextGet )
      ELSE
         ::navigate( _QGET_NAV_NEXT )
      ENDIF
   ENDIF

   RETURN NIL


METHOD HbQtGet:navigate( nDirection )

   IF ! Empty( ::oGetList )
      SWITCH nDirection
      CASE _QGET_NAV_NEXT     ; ::oGetList:goNext( Self )     ; EXIT
      CASE _QGET_NAV_PREVIOUS ; ::oGetList:goPrevious( Self ) ; EXIT
      CASE _QGET_NAV_TOP      ; ::oGetList:goTop( Self )      ; EXIT
      CASE _QGET_NAV_BOTTOM   ; ::oGetList:goBottom( Self )   ; EXIT
      CASE _QGET_NAV_SELF     ; ::oGetList:setFocus( Self )   ; EXIT
      ENDSWITCH
   ELSE
      IF nDirection == _QGET_NAV_NEXT
         QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) )
      ELSEIF nDirection == _QGET_NAV_PREVIOUS
         QApplication():sendEvent( ::oEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Backtab, Qt_NoModifier ) )
      ENDIF
   ENDIF

   RETURN .T.


METHOD HbQtGet:timesOccurs( cToken, cText )

   LOCAL cChr, n

   n := 0
   FOR EACH cChr IN cText
      IF cChr == cToken
         n++
      ENDIF
   NEXT

   RETURN n


METHOD HbQtGet:transformThis( xData, cMask )
   LOCAL cTmp, nTmp

   IF ValType( xData ) == "C"
      nTmp := Val( AllTrim( xData ) )
   ELSEIF ValType( xData ) == "N"
      nTmp := xData
   ENDIF
   cTmp := AllTrim( Transform( nTmp, cMask ) )
   IF Left( cTmp, 2 ) == "0."
      cTmp := SubStr( cTmp, 2 )
   ELSEIF Left( cTmp, 1 ) == "0"
      cTmp := ""
   ENDIF
   RETURN cTmp


METHOD HbQtGet:unTransformThis( cData )
   LOCAL cChr, cText := ""

   SWITCH ::cType
   CASE "C"
      IF Empty( ::cPicMask )
         RETURN cData
      ENDIF
      RETURN cData

   CASE "N"
      FOR EACH cChr IN cData
         IF cChr $ "+-0123456789"
            cText += cChr
         ELSEIF cChr == ::sl_decProxy
            cText += "."
         ENDIF
      NEXT
      EXIT
   CASE "L"
      RETURN cData
   CASE "D"
      FOR EACH cChr IN cData
         IF IsDigit( cChr )
            cText += cChr
         ENDIF
      NEXT
      cText := Pad( cText, Len( ::cPicMask ) )
      EXIT
   ENDSWITCH

   RETURN cText

/*----------------------------------------------------------------------*/
//                          GET Specific Methods
/*----------------------------------------------------------------------*/

METHOD HbQtGet:assign()

   IF ::hasFocus
      ::varPut( ::getData() )
   ENDIF

   RETURN Self


METHOD HbQtGet:putMask( xValue, lEdit )

   hb_default( @lEdit, ::hasFocus )

   HB_SYMBOL_UNUSED( lEdit )

   RETURN Transform( xValue, ::cPicture )


METHOD HbQtGet:updateBuffer()

   IF ::hasFocus
      ::cBuffer := ::putMask( ::varGet(), .F. )
      ::xVarGet := ::original
      ::oEdit:setText( ::cBuffer )
   ELSE
      ::varGet()
   ENDIF

   RETURN Self


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
      ::oEdit:setText( ::cBuffer )
   ENDIF

   RETURN Self


METHOD HbQtGet:getPos()
   RETURN ::oEdit:cursorPosition()


METHOD HbQtGet:setPos( nPos )

   IF HB_ISNUMERIC( nPos )
      nPos := Int( nPos )

      IF ::hasFocus
         ::oEdit:setCursorPosition( nPos )
      ENDIF

      RETURN ::oEdit:cursorPosition()
   ENDIF

   RETURN 0


METHOD HbQtGet:block( bBlock )

   IF PCount() == 0 .OR. bBlock == NIL
      RETURN ::bBlock
   ENDIF

   ::bBlock   := bBlock
   ::xVarGet  := ::original := ::varGet()
   ::cType    := ValType( ::original )

   RETURN ::bBlock


METHOD HbQtGet:tooltip( cTip )

   IF HB_ISCHAR( cTip )
      ::sl_tooltip := cTip
      IF HB_ISOBJECT( ::oEdit )
         ::oEdit:setToolTip( cTip )
      ENDIF
   ENDIF

   RETURN ::sl_tooltip


METHOD HbQtGet:toRow( nRow )

   IF HB_ISNUMERIC( nRow ) .AND. nRow > 0
      ::nToRow := nRow
   ENDIF

   RETURN ::nToRow


METHOD HbQtGet:toCol( nCol )

   IF HB_ISNUMERIC( nCol ) .AND. nCol > 0
      ::nToCol := nCol
   ENDIF

   RETURN ::nToCol


METHOD HbQtGet:inputValidator( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_inputValidator := bBlock
   ENDIF

   RETURN ::sl_inputValidator


METHOD HbQtGet:display()

   ::setData( ::varGet() )

   RETURN Self


METHOD HbQtGet:varPut( xValue )

   LOCAL aSubs
   LOCAL nLen
   LOCAL i
   LOCAL aValue

   IF HB_ISBLOCK( ::bBlock ) .AND. ValType( xValue ) $ "CNDTLU"
      aSubs := ::xSubScript
      IF HB_ISARRAY( aSubs ) .AND. ! Empty( aSubs )
         nLen := Len( aSubs )
         aValue := Eval( ::bBlock )
         FOR i := 1 TO nLen - 1
            IF HB_ISNUMERIC( aSubs[ i ] ) .OR. ;
                  ( HB_ISHASH( aValue ) .AND. ValType( aSubs[ i ] ) $ "CDT" )
               aValue := aValue[ aSubs[ i ] ]
            ELSE
               EXIT
            ENDIF
         NEXT
         IF HB_ISNUMERIC( aSubs[ i ] ) .OR. ;
            ( HB_ISHASH( aValue ) .AND. ValType( aSubs[ i ] ) $ "CDT" )
            aValue[ aSubs[ i ] ] := xValue
         ENDIF
      ELSE
         Eval( ::bBlock, xValue )
      ENDIF
   ELSE
      xValue := NIL
   ENDIF

   RETURN xValue


METHOD HbQtGet:varGet()

   LOCAL aSubs
   LOCAL nLen
   LOCAL i
   LOCAL xValue

   IF HB_ISBLOCK( ::bBlock )
      aSubs := ::xSubScript
      IF HB_ISARRAY( aSubs ) .AND. ! Empty( aSubs )
         nLen := Len( aSubs )
         xValue := Eval( ::bBlock )
         FOR i := 1 TO nLen
            IF HB_ISNUMERIC( aSubs[ i ] ) .OR. ;
               ( HB_ISHASH( xValue ) .AND. ValType( aSubs[ i ] ) $ "CDT" )
               xValue := xValue[ aSubs[ i ] ]
            ELSE
               EXIT
            ENDIF
         NEXT
      ELSE
         xValue := Eval( ::bBlock )
      ENDIF
   ELSE
      xValue := ::xVarGet
   ENDIF

   RETURN xValue

/*----------------------------------------------------------------------*/

METHOD HbQtGet:getData( cBuffer )

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      hb_default( @cBuffer, ::oEdit:text() )
      SWITCH ::cType
      CASE "C"
         RETURN ::unTransformProper( cBuffer )
      CASE "N"
         RETURN Val( ::unTransformThis( cBuffer ) )
      CASE "D"
         RETURN CToD( cBuffer )
      CASE "L"
         RETURN Left( cBuffer, 1 ) $ "YyTt"
      ENDSWITCH
      EXIT
   CASE "QPLAINTEXTEDIT"
      hb_default( @cBuffer, ::oEdit:toPlainText() )
      RETURN cBuffer
   CASE "QLISTWIDGET"
      RETURN ::oEdit:currentItem():text()
   CASE "QCOMBOBOX"
      RETURN ::oEdit:currentText()
   CASE "QPUSHBUTTON"
      RETURN ::oEdit:isDown()
   CASE "QCHECKBOX"
      RETURN ::oEdit:isChecked()
   CASE "QFRAME"
      RETURN .T.
   CASE "QLABEL"
      RETURN ::varGet()
   ENDSWITCH

   RETURN ""


METHOD HbQtGet:setData( xData )
   LOCAL cTmp, oImage

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      SWITCH ::cType
      CASE "C"
         RETURN ::oEdit:setText( RTrim( xData ) )
      CASE "N"
         RETURN ::oEdit:setText( ::transformThis( xData, ::cPicture ) )
      CASE "D"
         RETURN ::oEdit:setText( DToC( xData ) )
      CASE "L"
         RETURN ::oEdit:setText( iif( xData, iif( ::cPicFunc $ "Y", "Y", "T" ), iif( ::cPicFunc $ "Y", "N", "F" ) ) )
      ENDSWITCH
      EXIT
   CASE "QPLAINTEXTEDIT"
      ::oEdit:setPlainText( Trim( xData ) )
      EXIT
   CASE "QLISTWIDGET"
      ::oEdit:clear()
      IF HB_ISARRAY( ::data ) .AND. ! Empty( ::sl_data[ _QDATA_LISTBOX_ITEMS ] )
         FOR EACH cTmp IN ::sl_data[ _QDATA_LISTBOX_ITEMS ]
            ::oEdit:addItem( cTmp )
         NEXT
         IF ! Empty( cTmp := ::varGet() )
            ::oEdit:setCurrentRow( AScan( ::sl_data[ _QDATA_LISTBOX_ITEMS ], {|e| e == cTmp } ) - 1 )
         ENDIF
      ENDIF
      EXIT
   CASE "QCOMBOBOX"
      ::oEdit:clear()
      IF HB_ISARRAY( ::data ) .AND. ! Empty( ::sl_data[ _QDATA_COMBOBOX_ITEMS ] )
         FOR EACH cTmp IN ::sl_data[ _QDATA_COMBOBOX_ITEMS ]
            ::oEdit:addItem( cTmp )
         NEXT
         IF ! Empty( cTmp := ::varGet() )
            ::oEdit:setCurrentIndex( AScan( ::sl_data[ _QDATA_COMBOBOX_ITEMS ], {|e| e == cTmp } ) - 1 )
         ENDIF
      ENDIF
      EXIT
   CASE "QPUSHBUTTON"
      EXIT
   CASE "QCHECKBOX"
      ::oEdit:setChecked( xData )
      EXIT
   CASE "QFRAME"
      EXIT
   CASE "QLABEL"
      oImage := QImage( ::oEdit:width(), ::oEdit:height() )
      oImage:fill( Qt_darkGray )
      IF ! oImage:load( xData )
         oImage := QImage()
      ENDIF
      cTmp := QPixmap():fromImage( oImage )
      IF Empty( ::data() )
         ::oEdit:setPixmap( cTmp:scaled( ::oEdit:width(), ::oEdit:height(), Qt_KeepAspectRatio ) )
      ELSE
         ::oEdit:setPixmap( cTmp )
      ENDIF
      EXIT
   ENDSWITCH

   RETURN NIL


// ACCESS buffer
METHOD HbQtGet:getBuffer()

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      SWITCH ::cType
      CASE "C"
         ::cBuffer := Transform( ::unTransformProper( ::oEdit:text() ), ::cPicture )
         EXIT
      CASE "D"
         ::cBuffer := Transform( ::oEdit:text(), ::cPicture )
         EXIT
      OTHERWISE
         ::cBuffer := ::transformProper( ::unTransformProper( ::oEdit:text() ) )
         EXIT
      ENDSWITCH
      EXIT
   CASE "QPLAINTEXTEDIT"
      ::cBuffer := ::oEdit:toPlainText()
      EXIT
   CASE "QLISTWIDGET"
      ::cBuffer := ::oEdit:currentItem():text()
      EXIT
   CASE "QCOMBOBOX"
      ::cBuffer := ::oEdit:currentText()
      EXIT
   CASE "QPUSHBUTTON"
      ::cBuffer := ::oEdit:isDown()
      EXIT
   CASE "QCHECKBOX"
      ::cBuffer := ::oEdit:isChecked()
      EXIT
   CASE "QFRAME"
      ::cBuffer := .T.
      EXIT
   CASE "QLABEL"
      ::cBuffer := ::varGet()
      EXIT
   ENDSWITCH

   RETURN ::cBuffer


// ASSIGN buffer
METHOD HbQtGet:setBuffer( cBuffer )

   ::cBuffer := cBuffer

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      ::oEdit:setText( ::unTransformThis( ::cBuffer ) )
      EXIT
   CASE "QPLAINTEXTEDIT"
      ::oEdit:setPlainText( ::cBuffer )
      EXIT
   CASE "QLISTWIDGET"
      ::oEdit:setCurrentRow( AScan( ::sl_data[ _QDATA_LISTBOX_ITEMS ], {|e|  e == cBuffer } ) - 1 )
      EXIT
   CASE "QCOMBOBOX"
      ::oEdit:setCurrentIndex( AScan( ::sl_data[ _QDATA_LISTBOX_ITEMS ], {|e|  e == cBuffer } ) - 1 )
      EXIT
   CASE "QPUSHBUTTON"
      EXIT
   CASE "QFRAME"
      EXIT
   CASE "QCHECKBOX"
      ::oEdit:setChecked( cBuffer )
      EXIT
   CASE "QLABEL"
      ::oEdit:setPixmap( QPixmap():fromImage( QImage( cBuffer ) ):scaled( ::oEdit:width(), ::oEdit:height(), Qt_KeepAspectRatio ) )
      EXIT
   ENDSWITCH

   RETURN NIL


METHOD HbQtGet:transformProper( cBuffer )
   LOCAL cRet := ""
   LOCAL n, s, cChr

   SWITCH ::cType
   CASE "C"
      IF ! Empty( ::cPicMask )
         n := 0
         cRet := ""
         FOR EACH cChr IN ::cPicMask
            IF cChr $ ::sl_maskChrs
               cRet += cChr
            ELSE
               s := SubStr( cBuffer, ++n, 1 )
               cRet += iif( s == "", " ", s )
            ENDIF
         NEXT
      ELSE
         cRet := cBuffer
      ENDIF
      EXIT

   CASE "N"
#if 0
      IF ! Empty( ::cPicMask )
         n := 0
         cRet := ""
         FOR EACH cChr IN ::cPicMask
            IF cChr $ "9"
               cRet += cChr
            ELSE
               s := SubStr( cBuffer, ++n, 1 )
               cRet += iif( s == "", " ", s )
            ENDIF
         NEXT
      ELSE
         cRet := cBuffer
      ENDIF
#endif
      IF ! Empty( ::cPicMask )
         cRet := PadL( cBuffer, Len( ::cPicMask ) )
      ELSE
         cRet := cBuffer
      ENDIF
      EXIT

   CASE "D"
      cRet :=  cBuffer
      EXIT

   OTHERWISE
      cRet := cBuffer
      EXIT

   ENDSWITCH

   RETURN cRet


METHOD HbQtGet:unTransformProper( cBuffer )

   LOCAL cRet, cChr

   SWITCH ::cType
   CASE "C"
      IF "R" $ ::cPicFunc
         IF ! Empty( ::sl_maskChrs )
            cRet := ""
            FOR EACH cChr IN cBuffer
               IF ! ( cChr $ ::sl_maskChrs )
                  cRet += cChr
               ENDIF
            NEXT
         ELSE
            cRet := cBuffer
         ENDIF
         cRet := Pad( cRet, ::sl_width - Len( ::sl_maskChrs ) )

      ELSEIF ! Empty( ::cPicMask )
         cBuffer := Pad( cBuffer, ::sl_width )
         IF ! Empty( ::sl_maskChrs )
            cRet := ""
            FOR EACH cChr IN cBuffer
               IF ! ( cChr $ ::sl_maskChrs )
                  cRet += cChr
               ENDIF
            NEXT
         ELSE
            cRet := cBuffer
         ENDIF
         cRet := ::transformProper( cRet )
      ELSE
         cRet := Pad( cBuffer, ::sl_width )
      ENDIF
      EXIT

   CASE "N"
      IF ! Empty( ::cPicMask )
         cRet := ""
         FOR EACH cChr IN cBuffer
            IF cChr $ "+-0123456789"
               cRet += cChr
            ELSEIF cChr == ::sl_decProxy
               cRet += "."
            ENDIF
         NEXT
         cRet := ::transformProper( cRet )
      ELSE
         cRet := cBuffer
      ENDIF
      EXIT

   CASE "D"
      cRet := iif( Empty( CToD( cBuffer ) ), StrTran( ::sl_qMask, "9", " " ), Transform( cBuffer, ::sl_qMask ) )
      EXIT

   CASE "L"
      cRet := cBuffer
      EXIT

   OTHERWISE
      cRet := cBuffer
      EXIT

   ENDSWITCH

   RETURN cRet


METHOD HbQtGet:untransform()

   SWITCH ::cClassName
   CASE "QLINEEDIT"
      RETURN ::unTransformProper( ::oEdit:text() )
   CASE "QPLAINTEXTEDIT"
      RETURN ::oEdit:toPlainText()
   CASE "QLISTWIDGET"
      RETURN ::oEdit:currentItem():text()
   CASE "QCOMBOBOX"
      RETURN ::oEdit:currentText()
   CASE "QPUSHBUTTON"
      RETURN iif( ::oEdit:isDown(), "T", "F" )
   CASE "QCHECKBOX"
      RETURN iif( ::oEdit:isChecked(), "T", "F" )
   CASE "QFRAME"
      RETURN "T"
   CASE "QLABEL"
      RETURN ::varGet()
   ENDSWITCH

   RETURN ""


METHOD HbQtGet:positionCursor()
   LOCAL cChr

   IF ! ( "K" $ ::cPicFunc )
      ::oEdit:home( .F. )
      IF ! Empty( ::sl_qMask )
         FOR EACH cChr IN ::sl_qMask
            IF cChr $ "x9"
               EXIT
            ENDIF
           ::oEdit:setCursorPosition( ::oEdit:cursorPosition() + 1 )
         NEXT
      ENDIF
   ELSE
      ::oEdit:selectAll()
   ENDIF

   RETURN NIL


STATIC FUNCTION __getFont( oFont )
   RETURN iif( HB_ISOBJECT( oFont ), oFont, QFont( "Courier New", 10 ) )



