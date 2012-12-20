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


#include "hbqtgui.ch"
#include "hbqtstd.ch"
#include "inkey.ch"
#include "hbtrace.ch"


FUNCTION HbQtAlert( xMessage, aOptions, cColorNorm, nDelay, cTitle, nInit )
   LOCAL cMessage, aOptionsOK, cOption, nEval, cColorHigh

   IF PCount() == 0
      RETURN NIL
   ENDIF

   IF HB_ISARRAY( xMessage )
      cMessage := ""
      FOR nEval := 1 TO Len( xMessage )
         cMessage += iif( nEval == 1, "", Chr( 10 ) ) + hb_CStr( xMessage[ nEval ] )
      NEXT
   ELSEIF HB_ISSTRING( xMessage )
      cMessage := StrTran( xMessage, ";", Chr( 10 ) )
   ELSE
      cMessage := hb_CStr( xMessage )
   ENDIF

   hb_default( @aOptions, {} )
   hb_default( @cTitle, "Alert!" )
   hb_default( @nInit, 1 )

   IF ! HB_ISSTRING( cColorNorm ) .OR. Empty( cColorNorm )
      cColorNorm := "W+/R" // first pair color (Box line and Text)
      cColorHigh := "W+/B" // second pair color (Options buttons)
   ELSE
      cColorHigh := StrTran( StrTran( iif( At( "/", cColorNorm ) == 0, "N", SubStr( cColorNorm, At( "/", cColorNorm ) + 1 ) ) + "/" + ;
         iif( At( "/", cColorNorm ) == 0, cColorNorm, Left( cColorNorm, At( "/", cColorNorm ) - 1 ) ), "+", "" ), "*", "" )
   ENDIF

   aOptionsOK := {}
   FOR EACH cOption IN aOptions
      IF HB_ISSTRING( cOption ) .AND. ! Empty( cOption )
         AAdd( aOptionsOK, cOption )
      ENDIF
   NEXT

   IF Len( aOptionsOK ) == 0
      aOptionsOK := { "Ok" }
   ENDIF

   RETURN __hbqtAlert( cMessage, aOptionsOK, cColorNorm, cColorHigh, nDelay, cTitle, nInit )


STATIC FUNCTION  __hbqtAlert( cMsg, aOptions, cColorNorm, cColorHigh, nDelay, cTitle, nInit )

   LOCAL oDlg, oVBLayout, oHBLayout, oLabel, cBtn, oBtn, oTimer, oFocus
   LOCAL nResult
   LOCAL aButtons := {}

   oFocus := QFocusFrame()
   oFocus:setStyleSheet( "border: 2px solid red;" )
   oFocus:hide()

   oDlg      := QDialog()
   oDlg:setWindowTitle( cTitle )
   oDlg:setStyleSheet( __hbqtCSSFromColorString( cColorNorm ) +  " font-name: Courier; font-size: 10pt;" )
   oDlg:connect( QEvent_KeyPress, {|oKeyEvent| Navigate( oKeyEvent, aOptions, aButtons, oFocus ) } )

   oVBLayout := QVBoxLayout( oDlg )
   oHBLayout := QHBoxLayout()

   oLabel    := QLabel()

   oVBLayout:addWidget( oLabel )
   oVBLayout:addLayout( oHBLayout )

   oLabel:setAlignment( Qt_AlignHCenter )
   oLabel:setText( StrTran( cMsg, ";", Chr( 10 ) ) )
   oLabel:setStyleSheet( "padding: 10px;" )

   FOR EACH cBtn IN aOptions
      oBtn := QPushButton( oDlg )
      oBtn:setText( cBtn )
      oBtn:setFocusPolicy( Qt_StrongFocus )
      oBtn:setStyleSheet( __hbqtCSSFromColorString( cColorHigh ) )
      oBtn:connect( "clicked()", BuildButtonBlock( @nResult, cBtn:__enumIndex(), oDlg ) )
      oBtn:connect( QEvent_KeyPress, {|oKeyEvent| Navigate( oKeyEvent, aOptions, aButtons, oFocus ) } )
      oHBLayout:addWidget( oBtn )
      AAdd( aButtons, oBtn )
   NEXT

   IF HB_ISNUMERIC( nDelay ) .AND. nDelay > 0
      oTimer := QTimer( oDlg )
      oTimer:setInterval( nDelay * 1000 )
      oTimer:setSingleShot( .T. )
      oTimer:connect( "timeout()", {||  TerminateAlert( aButtons ) } )
      oTimer:start()
   ENDIF

   aButtons[ nInit ]:setFocus()
   oFocus:setWidget( aButtons[ nInit ] )
   IF oDlg:exec() == 0
      nResult := 0
   ENDIF

   oDlg:setParent( QWidget() )

   RETURN nResult


STATIC FUNCTION BuildButtonBlock( nResult, nIndex, oDlg )
   RETURN {|| nResult := nIndex, oDlg:done( 1 ) }


STATIC FUNCTION Navigate( oKeyEvent, aOptions, aButtons, oFocus )
   LOCAL n, cKey, nKey

   nKey := hbqt_qtEventToHbEvent( oKeyEvent )

   SWITCH nKey

   CASE K_LEFT
      FOR n := 1 TO Len( aButtons )
         IF aButtons[ n ]:hasFocus()
            EXIT
         ENDIF
      NEXT
      n := iif( n > 1, n - 1, Len( aButtons ) )
      aButtons[ n ]:setFocus()
      oFocus:setWidget( aButtons[ n ] )
      oKeyEvent:accept()
      RETURN .T.

   CASE K_RIGHT
      FOR n := 1 TO Len( aButtons )
         IF aButtons[ n ]:hasFocus()
            EXIT
         ENDIF
      NEXT
      n := iif( n == Len( aButtons ), 1, n + 1 )
      aButtons[ n ]:setFocus()
      oFocus:setWidget( aButtons[ n ] )
      oKeyEvent:accept()
      RETURN .T.

   OTHERWISE
      cKey := Lower( Chr( nKey ) )
      IF ( n := AScan( aOptions, {|e|  Lower( Left( e,1 ) ) == cKey } ) ) > 0
         oFocus:setWidget( aButtons[ n ] )
         aButtons[ n ]:click()
      ENDIF
      EXIT

   ENDSWITCH

   RETURN .F.


STATIC FUNCTION TerminateAlert( aButtons )
   LOCAL oButton

   FOR EACH oButton IN aButtons
      IF oButton:hasFocus()
         oButton:click()
         EXIT
      ENDIF
   NEXT

   RETURN .T.

