/*
 * $Id: hbqtalert.prg 169 2013-02-13 03:16:29Z bedipritpal $
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2015 Pritpal Bedi <bedipritpal@hotmail.com>
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
#include "common.ch"


FUNCTION HbQtAlert( xMessage, aOptions, cColorNorm, nDelay, cTitle, nInit, oParent )
   LOCAL cMessage, aOptionsOK, cOption, nEval, cColorHigh, xTmp

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
      IF "," $ cColorNorm
         xTmp := SubStr( cColorNorm, 1, At( ",", cColorNorm ) - 1 )
         cColorHigh := SubStr( cColorNorm, At( ",", cColorNorm ) + 1 )
         cColorNorm := xTmp
      ELSE
         cColorHigh := StrTran( StrTran( iif( At( "/", cColorNorm ) == 0, "N", SubStr( cColorNorm, At( "/", cColorNorm ) + 1 ) ) + "/" + ;
            iif( At( "/", cColorNorm ) == 0, cColorNorm, Left( cColorNorm, At( "/", cColorNorm ) - 1 ) ), "+", "" ), "*", "" )
      ENDIF
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
   LOCAL oDlg, oVBLayout, oHBLayout, oLabel, cBtn, oBtn, oTimer, oFocus, nResult, oLabel1, oWidgetInFocus
   LOCAL aButtons := {}

   oWidgetInFocus := QApplication():focusWidget()

   WITH OBJECT oFocus := QFocusFrame()
      :setStyleSheet( "border: 2px solid red;" )
      :hide()
   ENDWITH

   hb_default( @oParent, QApplication():focusWidget() )

   WITH OBJECT oDlg := QDialog( oParent )
      :setWindowTitle( cTitle )
      :setStyleSheet( __hbqtCSSFromColorString( cColorNorm ) )
      :connect( QEvent_KeyPress, {|oKeyEvent| Navigate( oKeyEvent, aOptions, aButtons, oFocus ) } )
   ENDWITH

   WITH OBJECT oVBLayout := QVBoxLayout( oDlg )
      :setSpacing( 10 )
   ENDWITH
   WITH OBJECT oHBLayout := QHBoxLayout()
      :setSpacing( 10 )
   ENDWITH

   oLabel := QLabel()

   oVBLayout:addWidget( oLabel )
   oVBLayout:addWidget( oLabel1 := QLabel() )
   oVBLayout:addLayout( oHBLayout )
   oLabel1:setMinimumHeight( 10 )

   WITH OBJECT oLabel
      :setAlignment( Qt_AlignHCenter )
      :setText( cMsg )
      :setOpenExternalLinks( .T. )
      :setFont( QFont( "Courier", iif( __hbqtIsMobile(), __hbqtPixelsByDPI( 12 ), 10 ) ) )
      :setStyleSheet( __hbqtCSSFromColorString( cColorNorm ) )
   ENDWITH

   FOR EACH cBtn IN aOptions
      WITH OBJECT oBtn := QPushButton( oDlg )
         :setText( cBtn )
         :setFocusPolicy( Qt_StrongFocus )
         :setFont( QFont( "Courier", iif( __hbqtIsMobile(), __hbqtPixelsByDPI( 12 ), 10 ) ) )
         :setStyleSheet( "" )
         :setStyleSheet( __hbqtCSSFromColorString( cColorHigh ) + "border-radius: 5px;" )
         :connect( "clicked()", BuildButtonBlock( @nResult, cBtn:__enumIndex(), oDlg ) )
         :connect( QEvent_KeyPress, {|oKeyEvent| Navigate( oKeyEvent, aOptions, aButtons, oFocus ) } )
      ENDWITH
      oHBLayout:addWidget( oBtn )
      AAdd( aButtons, oBtn )
   NEXT

   IF HB_ISNUMERIC( nDelay ) .AND. nDelay > 0
      WITH OBJECT oTimer := QTimer( oDlg )
         :setInterval( nDelay * 1000 )
         :setSingleShot( .T. )
         :connect( "timeout()", {|| TerminateAlert( aButtons ) } )
      ENDWITH
      oTimer:start()
   ENDIF

   aButtons[ nInit ]:setFocus()
   oFocus:setWidget( aButtons[ nInit ] )
   IF oDlg:exec() == 0
      nResult := 0
   ENDIF

   oDlg:setParent( QWidget() )  /* MUST DO - Releases the memory */

   QApplication():processEvents()
   IF HB_ISOBJECT( oWidgetInFocus )
      oWidgetInFocus:setFocus()
   ENDIF

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


FUNCTION HbQtBulkGet( xVariable, xCaption, xPicture, xWhen, xValid, cTitle, xIcon )
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
      IF HB_ISCHAR( xIcon ) .AND. ! Empty( xIcon )
         :setWindowIcon( QIcon( xIcon ) )
      ELSEIF HB_ISOBJECT( xIcon )
         :setWindowIcon( xIcon )
      ENDIF
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
   ELSE
      xVariable := NIL
   ENDIF

   RETURN xVariable


STATIC FUNCTION __getBlock( aBlocks, nIndex )
   RETURN aBlocks[ nIndex ]


FUNCTION HbQtAChoice( nTop, nLeft, nBottom, nRight, acMenuItems, xSelectableItems, cUserFunc, nInitItem, nWindowRow, oParent, cTitle )
   LOCAL oDlg, oVLay, oBtnOK, oBtnCancel, oHLay, oList, nRes, nChoice, cItem, oItem
   LOCAL lDecorate := .T., lSelectable

   HB_SYMBOL_UNUSED( cUserFunc        )
   HB_SYMBOL_UNUSED( nWindowRow       )

   hb_default( @cTitle, "Select an Option" )
   hb_default( @nInitItem, 1 )

   IF HB_ISNUMERIC( nTop ) .AND. HB_ISNUMERIC( nLeft ) .AND. HB_ISNUMERIC( nBottom ) .AND. HB_ISNUMERIC( nRight )
      IF ! HB_ISOBJECT( oParent )
         oParent := __hbqtGetsActiveWindow()
      ENDIF
      lDecorate := .F.
      oDlg := __hbqtGetADialogOnTopOf( oParent, nTop, nLeft, nBottom, nRight, NIL, NIL, .F. )
   ELSE
      oDlg := QDialog( oParent )
   ENDIF

   oVLay := QVBoxLayout( oDlg )
   WITH OBJECT oList := QListWidget( oDlg )
      :setFont( QFont( "Courier New", 10 ) )
//    :connect( "itemDoubleClicked(QListWidgetItem*)", {||  oDlg:done( 1 ) } )
      :connect( "itemActivated(QListWidgetItem*)", {||  oDlg:done( 1 ) } )
   ENDWITH
   oVLay:addWidget( oList )
   oVLay:setContentsMargins( 0,0,0,0 )

   IF lDecorate
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
   ENDIF

   FOR EACH cItem IN acMenuItems
      oItem := QListWidgetItem()
      oItem:setText( cItem )
      IF HB_ISARRAY( xSelectableItems )
         lSelectable :=  xSelectableItems[ cItem:__enumIndex() ]
      ELSEIF HB_ISLOGICAL( xSelectableItems )
         lSelectable :=  xSelectableItems
      ELSE
         lSelectable := .T.
      ENDIF
      oItem:setFlags( iif( lSelectable, Qt_ItemIsEnabled + Qt_ItemIsSelectable, Qt_NoItemFlags ) )
      oList:addItem( oItem )
   NEXT

   oDlg:setWindowTitle( cTitle )
   oDlg:connect( QEvent_Show, {|| oList:setCurrentRow( nInitItem - 1 ), oList:setFocus() } )
   nRes := oDlg:exec()

   nChoice := iif( nRes == 0, 0, oList:currentRow()+1 )

   oDlg:setParent( QWidget() )

   RETURN nChoice


FUNCTION HbQtMsgbox( cMsg, cTitle, cnBGround, nTimeout, nX, nY )
   LOCAL oMB, oTimer

   hb_default( @cTitle, "  " )

   cMsg := strtran( cMsg, chr( 13 ) + chr( 10 ), "<br />" )
   cMsg := strtran( cMsg, chr( 13 ), "<br />" )
   cMsg := strtran( cMsg, chr( 10 ), "<br />" )

   WITH OBJECT oMB := QMessageBox( __hbqtAppWidget() )
      :setText( /* "<b>" + */ cMsg /* + "</b>" */ )
      :setIcon( QMessageBox_Information )
      :setWindowFlags( Qt_Dialog )
      :setWindowTitle( cTitle )
      IF HB_ISSTRING( cnBGround )
         :setStyleSheet( "background-color: " + cnBGround + ";" )
      ELSEIF HB_ISNUMERIC( cnBGround )
         :setStyleSheet( "background-color: " + QColor( cnBGround ):name() + ";" )
      ELSEIF HB_ISOBJECT( cnBGround )
         :setStyleSheet( "background-color: " + cnBGround:name() + ";" )
      ENDIF
      IF HB_ISNUMERIC( nX ) .AND. HB_ISNUMERIC( nY )
         :move( nX, nY )
      ENDIF
   ENDWITH 
   IF HB_ISNUMERIC( nTimeout ) .AND. nTimeout > 0
      WITH OBJECT oTimer := QTimer()
         :setInterval( nTimeout * 1000 )
         :setSingleShot( .T. )
         :connect( "timeout()", {|| oMB:done( 0 ) } )
      ENDWITH 
      oTimer:start()
   ENDIF
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


FUNCTION HbQtDispOutAt( nRow, nCol, cText, cColor, oWnd )
   LOCAL oGetList, aSay, aXY, oLabel

   IF GetActive() == NIL
      RETURN NIL
   ENDIF

   hb_default( @cText, "" )

   IF Empty( oWnd )
      oWnd := __hbqtGetsActiveWindow()
   ENDIF
   IF ! HB_ISOBJECT( oWnd )
      RETURN NIL
   ENDIF
   oGetList := GetActive():getList()

   IF ! ( oGetList:oWindow == oWnd )
      RETURN NIL
   ENDIF

   FOR EACH aSay IN oGetList:SayList
      IF aSay[ _QSAY_ROW ] == nRow .AND. aSay[ _QSAY_COL ] == nCol
         // Should we resize oLabel to new dimentions ?
         aSay[ _QSAY_OBJECT ]:setText( cText )
         RETURN NIL
      ENDIF
   NEXT

   aXY := __hbqtGetXYFromRowColumn( oWnd, nRow, nCol )

   WITH OBJECT oLabel := QLabel( oWnd )
      :move( aXY[ 1 ], aXY[ 2 ] )
      :resize( aXY[ 3 ] * Len( cText ), aXY[ 4 ] )
      :show()
   ENDWITH

   AAdd( oGetList:SayList, { nRow, nCol, cText, NIL, cColor, NIL, oLabel } )

   RETURN NIL


FUNCTION HbQtMaxRow( oWnd )
   LOCAL aInfo

   IF Empty( oWnd )
      oWnd := __hbqtGetsActiveWindow()
   ENDIF
   IF ! HB_ISOBJECT( oWnd )
      RETURN -1
   ENDIF

   aInfo := __hbqtGetXYFromRowColumn( oWnd, 1, 1 )

   RETURN Int( oWnd:height() / aInfo[ 4 ] ) - 1


FUNCTION HbQtMaxCol( oWnd )
   LOCAL aInfo

   IF Empty( oWnd )
      oWnd := __hbqtGetsActiveWindow()
   ENDIF
   IF ! HB_ISOBJECT( oWnd )
      RETURN -1
   ENDIF

   aInfo := __hbqtGetXYFromRowColumn( oWnd, 0, 0 )

   RETURN Int( oWnd:width() / aInfo[ 3 ] ) - 1


FUNCTION HbQtGetSome( xValue, bEditingFinishedBlock, cLabel, cPicture, cColor, bWhen, bValid )
   STATIC bEscape
   LOCAL oCellEditor
   LOCAL GetList := {}, SayList := {}
   LOCAL nOffset := __hbqtPixelsByDPI( 50 )

   DEFAULT cLabel TO "Enter Some Value"

   bEscape := SetKey( K_ESC, {|| __hbqtEditingTerminate( oCellEditor, bEscape ) } )

   IF Empty( oCellEditor )
      oCellEditor := QLineEdit( __hbqtAppWidget() )
   ENDIF

   IF Empty( cPicture )
      cPicture := ""
   ENDIF

   HbQtActivateSilverLight( .T., cLabel, NIL, .F. )

   WITH OBJECT oCellEditor
      :setGeometry( QRect( nOffset, nOffset, __hbqtAppWidget():width() - nOffset - nOffset, nOffset ) )
      :show()
      :raise()
   ENDWITH

   @ 0,0 QGET xValue CONTROL oCellEditor ;
                     PICTURE cPicture ;
                     COLOR   iif( Empty( cColor ), "N/BG*", cColor ) ;
                     WHEN    {|oGet| iif( HB_ISBLOCK( bWhen  ), Eval( bWhen , oGet ), .T. ) } ;
                     VALID   {|oGet| HbQtSetGetSomeValue( oGet:varGet() ), iif( HB_ISBLOCK( bValid ), Eval( bValid, oGet ), .T. ) }
   QREAD PARENT __hbqtAppWidget() NOFOCUSFRAME LASTGETBLOCK  {|| __hbqtEditingFinished( bEditingFinishedBlock, oCellEditor, bEscape ) }

   oCellEditor:setFocus()
   RETURN NIL


STATIC FUNCTION __hbqtEditingFinished( bBlock, oCellEditor, bEscape )

   oCellEditor:hide()
   oCellEditor:setParent( QWidget() )
   HbQtActivateSilverLight( .F. )
   SetKey( K_ESC, bEscape )
   IF HB_ISBLOCK( bBlock )
      Eval( bBlock, HbQtSetGetSomeValue() )
   ENDIF
   RETURN NIL


STATIC FUNCTION __hbqtEditingTerminate( oCellEditor, bEscape )

   oCellEditor:hide()
   oCellEditor:setParent( QWidget() )
   HbQtActivateSilverLight( .F. )
   SetKey( K_ESC, bEscape )
   HbQtSetGetSomeValue( NIL )
   RETURN NIL


FUNCTION HbQtSetGetSomeValue( xValue )
   STATIC s_value
   LOCAL l_value := s_value
   IF PCount() == 1
      s_value := xValue
   ENDIF
   RETURN l_value


FUNCTION HbQtFetchString( oParent, cDftText, cWhat, cTitle )
   LOCAL oInput, cText

   DEFAULT cDftText TO ""
   DEFAULT cWhat    TO ""
   DEFAULT cTitle   TO "A String Value"

   WITH OBJECT oInput := QInputDialog( oParent )
      :setTextValue( cDftText )
      :setLabelText( cWhat )
      :setWindowTitle( cTitle )
      :exec()
   ENDWITH
   cText := oInput:textValue()
   oInput:setParent( QWidget() )
   RETURN cText


FUNCTION HbQtFetchInteger( oParent, nDftInteger, nMin, nMax, cWhat, cTitle )
   LOCAL oInput, nInteger

   DEFAULT nDftInteger TO 0
   DEFAULT nMin        TO 0
   DEFAULT nMax        TO 99999999999999999
   DEFAULT cWhat       TO ""
   DEFAULT cTitle      TO "An Integer Value"

   WITH OBJECT oInput := QInputDialog( oParent )
      :setInputMode( 1 )
      :setIntMinimum( nMin )
      :setIntMaximum( nMax )
      //
      :setIntValue( nDftInteger )
      :setLabelText( cWhat )
      :setWindowTitle( cTitle )
      :exec()
   ENDWITH
   nInteger := oInput:intValue()
   oInput:setParent( QWidget() )
   RETURN nInteger


