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


FUNCTION HbQtAlert( xMessage, aOptions, cColorNorm, nDelay, cTitle, nInit, oParent )
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

   RETURN __hbqtAlert( cMessage, aOptionsOK, cColorNorm, cColorHigh, nDelay, cTitle, nInit, oParent )


STATIC FUNCTION  __hbqtAlert( cMsg, aOptions, cColorNorm, cColorHigh, nDelay, cTitle, nInit, oParent )

   LOCAL oDlg, oVBLayout, oHBLayout, oLabel, cBtn, oBtn, oTimer, oFocus
   LOCAL nResult
   LOCAL aButtons := {}

   oFocus := QFocusFrame()
   oFocus:setStyleSheet( "border: 2px solid red" )
   oFocus:hide()

   hb_default( @oParent, QApplication():focusWidget() )

   oDlg := QDialog( oParent )
   oDlg:setWindowTitle( cTitle )
   //oDlg:setStyleSheet( 'font-name: "Courier New"; font-size: 10pt;' + __hbqtCSSFromColorString( cColorNorm ) )
   oDlg:setStyleSheet( __hbqtCSSFromColorString( cColorNorm ) )
   oDlg:connect( QEvent_KeyPress, {|oKeyEvent| Navigate( oKeyEvent, aOptions, aButtons, oFocus ) } )

   oVBLayout := QVBoxLayout( oDlg )
   oHBLayout := QHBoxLayout()

   oLabel    := QLabel()

   oVBLayout:addWidget( oLabel )
   oVBLayout:addLayout( oHBLayout )

   oLabel:setAlignment( Qt_AlignHCenter )
   oLabel:setText( cMsg )
   oLabel:setFont( QFont( "Courier new", 10 ) )
   oLabel:setStyleSheet( "padding: 10px;" )

   FOR EACH cBtn IN aOptions
      oBtn := QPushButton( oDlg )
      oBtn:setText( cBtn )
      oBtn:setFocusPolicy( Qt_StrongFocus )
      oBtn:setStyleSheet( "" )
      oBtn:setStyleSheet( __hbqtCSSFromColorString( cColorHigh ) + " font-name: Courier; font-size: 10pt;" )
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

   oDlg:setParent( QWidget() )  /* MUST DO - Releases the memory */
   oFocus:setParent( QWidget() )

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


FUNCTION HbQtBulkGet( xVariable, xCaption, xPicture, xWhen, xValid, cTitle )
   LOCAL i, cType, oDlg, nVrbls, nRes, oLay, bWhen, bValid, aCombo
   LOCAL aVariables := {}
   LOCAL aCaptions  := {}
   LOCAL aPictures  := {}
   LOCAL aWhens     := {}
   LOCAL aValids    := {}
   LOCAL GetList    := {}
   LOCAL SayList    := {}

   hb_default( @cTitle, "Enter Some Values!" )

   cType := ValType( xVariable )
   IF cType $ "CDNL"
      AAdd( aVariables, xVariable )
      AAdd( aCaptions , xCaption  )
      AAdd( aPictures , xPicture  )
      AAdd( aWhens    , xWhen     )
      AAdd( aValids   , xValid    )
   ELSE
      aVariables := xVariable
      IF HB_ISARRAY( xCaption )
         aCaptions := xCaption
      ENDIF
      IF HB_ISARRAY( xPicture )
         aPictures := xPicture
      ENDIF
      IF HB_ISARRAY( xWhen )
         aWhens := xWhen
      ENDIF
      IF HB_ISARRAY( xValid )
         aValids := xValid
      ENDIF
   ENDIF
   nVrbls := Len( aVariables )

   ASize( aCaptions, nVrbls )
   ASize( aPictures, nVrbls )
   ASize( aWhens   , nVrbls )
   ASize( aValids  , nVrbls )

   FOR i := 1 TO nVrbls
      hb_default( @aCaptions[ i ], "Variable_" + hb_ntos( i ) )
      hb_default( @aPictures[ i ], "" )
      hb_default( @aWhens[ i ]   , {|| .T. } )
      hb_default( @aValids[ i ]  , {|| .T. } )
   NEXT

   WITH OBJECT oLay := QFormLayout()
      :setLabelAlignment( Qt_AlignRight )
      :setFieldGrowthPolicy( QFormLayout_FieldsStayAtSizeHint )
      :setFormAlignment( Qt_AlignHCenter )
   ENDWITH
   WITH OBJECT oDlg := QDialog( QApplication():focusWidget() )
      :setWindowTitle( cTitle )
      :setLayout( oLay )
   ENDWITH

   FOR i := 1 TO nVrbls
      bWhen  := __getBlock( aWhens, i )
      bValid := __getBlock( aValids, i )
      IF HB_ISARRAY( aVariables[ i ] )
         aCombo := aVariables[ i ]
         aVariables[ i ] := aCombo[ 1 ]
         @ 1, 1, 1, ( Len( aVariables[ i ] ) + 3 ) QGET aVariables[ i ] COMBOBOX aCombo CAPTION aCaptions[ i ] WHEN bWhen VALID bValid
      ELSE
         @ 1, 1 QGET aVariables[ i ] PICTURE aPictures[ i ] CAPTION aCaptions[ i ] WHEN bWhen VALID bValid
      ENDIF
   NEXT
   QREAD oLay LASTGETBLOCK {|| oDlg:done( 1 ) }

   nRes := oDlg:exec()
   oDlg:setParent( QWidget() )

   IF nRes > 0
      IF cType $ "CDNL"
         xVariable := aVariables[ 1 ]
      ELSE
         xVariable := aVariables
      ENDIF
   ENDIF

   RETURN xVariable


STATIC FUNCTION __getBlock( aBlocks, nIndex )
   RETURN aBlocks[ nIndex ]


FUNCTION HbQtAChoice( nTop, nLeft, nBottom, nRight, acMenuItems, xSelectableItems, cUserFunc, nInitItem, nWindowRow, cTitle, oParent )
   LOCAL oDlg, oVLay, oBtnOK, oBtnCancel, oHLay, oList, nRes, nChoice, cItem

   HB_SYMBOL_UNUSED( nLeft            )
   HB_SYMBOL_UNUSED( nRight           )
   HB_SYMBOL_UNUSED( nTop             )
   HB_SYMBOL_UNUSED( nBottom          )
   HB_SYMBOL_UNUSED( xSelectableItems )
   HB_SYMBOL_UNUSED( cUserFunc        )
   HB_SYMBOL_UNUSED( nInitItem        )
   HB_SYMBOL_UNUSED( nWindowRow       )

// hb_default( @oParent, QApplication():focusWidget() )
   hb_default( @cTitle, "Select an Option" )
   hb_default( @nInitItem, 1 )

   oDlg   := QDialog( oParent )
   oVLay  := QVBoxLayout( oDlg )
   oList  := QListWidget( oDlg )
   oVLay  :  addWidget( oList )
   oHLay  := QHBoxLayout()
   oVLay  :  addLayout( oHLay )
   oBtnOK := QPushButton( oDlg )
   oBtnOK :  setText( "OK" )
   oHLay  :  addWidget( oBtnOK )

   oBtnCancel := QPushButton( oDlg )
   oBtnCancel :  setText( "Cancel" )
   oHLay      :  addWidget( oBtnCancel )

   oBtnOK     :  connect( "clicked()", {|| oDlg:done( 1 ) } )
   oBtnCancel :  connect( "clicked()", {|| oDlg:done( 0 ) } )
   oList      :  setFont( QFont( "Courier New", 10 ) )
   oList      :  connect( "itemDoubleClicked(QListWidgetItem*)", {||  oDlg:done( 1 ) } )

   FOR EACH cItem IN acMenuItems
      oList:addItem( cItem )
   NEXT

   oDlg:setWindowTitle( cTitle )
   oDlg:connect( QEvent_Show, {|| oList:setCurrentRow( nInitItem - 1 ), oList:setFocus() } )
   nRes := oDlg:exec()

   nChoice := iif( nRes == 0, 0, oList:currentRow()+1 )

   oDlg:setParent( QWidget() )

   RETURN nChoice


FUNCTION HbQtMsgBox( cMsg, cTitle )
   LOCAL oMB

   hb_default( @cTitle, "  " )

   cMsg := strtran( cMsg, chr( 13 ) + chr( 10 ), "<br />" )
   cMsg := strtran( cMsg, chr( 13 ), "<br />" )
   cMsg := strtran( cMsg, chr( 10 ), "<br />" )

   oMB := QMessageBox()
   oMB:setText( /* "<b>" + */ cMsg /* + "</b>" */ )
   oMB:setIcon( QMessageBox_Information )
   oMB:setParent( QApplication():focusWidget() )
   oMB:setWindowFlags( Qt_Dialog )
   oMB:setWindowTitle( cTitle )

   oMB:exec()

   oMB:setParent( QWidget() )

   RETURN NIL


FUNCTION HbQtGetAt( nGlobalX, nGlobalY, cVar, cPic, cColor, bValid )
   LOCAL oDlg, nRes
   LOCAL GetList := {}, SayList := {}

//   hb_default( @bValid, {|| .T. } )

   WITH OBJECT oDlg  := QDialog()
      :connect( QEvent_Show, {|| oDlg:move( nGlobalX, nGlobalY ) } )
      :setWindowFlags( Qt_Dialog + Qt_FramelessWindowHint )
      :setAttribute( Qt_WA_TranslucentBackground, .T. )
   ENDWITH

   @ 0,0 QGET cVar PICTURE cPic COLOR cColor VALID {|| Eval( bValid ) }
   QREAD PARENT oDlg LASTGETBLOCK {|| oDlg:done( 1 ) } NOFOCUSFRAME

   nRes := oDlg:exec()

   oDlg:setParent( QWidget() )

   RETURN iif( nRes == 0, NIL, cVar )


