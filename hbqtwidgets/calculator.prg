 /*
 * $Id$
 */

 /*
 * Harbour Project source code:
 *
 * Adapted by : M.,Ronaldo <ronmesq@gmail.com>
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

/*
 * Sample from qt:
 * http://qt-project.org/doc/qt-4.8/widgets-calculator-calculator-cpp.html
 *
 * 2013/09/09 M.,Ronaldo - First release
 * 2013/09/10 Luigi Ferraris
 *            CLASS INHERIT from hb_QDialog
 *            Send Result to OS ClipBoard
 *            Retrieve data from OS ClipBoard
 *            Tip About clear OS ClipBoard before exit app
 * 2013/09/11 M.,Ronaldo
 *            Fixed precision to 6 digits
 *            Keyboard events Added
 *            K_Escape: Exit Calculator
 * 2013/09/12 M.,Ronaldo
 *            Added ToolBar for Copy, Paste, Exit
 *            Added Operator for current op
 *            Added QMemo for calc actions ( -, +, *, /, = )
 * 2013/09/13 M.,Ronaldo
 *            Added a Spinner to manage precision
 *            Replaced QApplication:ClipBoard by Class methods [ paste(), copy(), ... ]
 *            SetFocus to equal button after any events ( prevent other button pressed by qt_Key_Enter )
 * 2013/09/13 QT standards
 *            PopUp menu to copy Memo/Display contents
 *
 */

 /*
 * How to use:
 *
 * SetKey( K_F2, {|| HbQtCalculate( <oParent>, [<lClipBoard>] ) } )
 *
 * Then OnExit event add:
 *
 * QApplication():clipboard:clear( QClipboard_Clipboard )
 * QApplication():clipboard:clear( QClipboard_Selection )
 *
 * QApplication():quit()
 */

/*  TODO:
 *        Printing Support
 *        Toolbar with Buttons
 */


#include "hbqtgui.ch"
#include "hbclass.ch"


STATIC oCalculator


FUNCTION HbQtCalculate( oParent )

   IF ! HB_ISOBJECT( oCalculator )
      oCalculator := HbQtCalculator():new( oParent, .T. ):create()
   ENDIF

   oCalculator:oWidget:show()
   oCalculator:oWidget:setFocus()

   RETURN NIL


CREATE CLASS HbQtCalculator

   /* PUBLISHED */
   DATA   oWidget

   METHOD new( oParent, bClipboard )
   METHOD Create()

   METHOD __getData( nLPrecision )
   METHOD __setData( nValue )


   PROTECTED:

   DATA   oDisplay
   DATA   oSpinner                                /* TO DO */
   DATA   oOperand
   DATA   oMemo
   DATA   oFont
   DATA   oLayout
   DATA   oTBar
   DATA   oActions                                INIT ARRAY(10)

   DATA   PointButton
   DATA   ChangeSignButton
   DATA   BackspaceButton
   DATA   ClearButton
   DATA   ClearAllButton
   DATA   ClearMemoryButton
   DATA   ReadMemoryButton
   DATA   SetMemoryButton
   DATA   AddToMemoryButton
   DATA   DivisionButton
   DATA   TimesButton
   DATA   MinusButton
   DATA   PlusButton
   DATA   SquareRootButton
   DATA   PowerButton
   DATA   ReciprocalButton
   DATA   EqualButton
   DATA   DigitButtons                            INIT ARRAY(10)
   DATA   oBtnShowMemo

   DATA   nSumInMemory                            INIT 0
   DATA   nSumSoFar                               INIT 0
   DATA   nFactorSoFar                            INIT 0
   DATA   nPrecision                              INIT 6

   DATA   cPendingAdditiveOperator                INIT ''
   DATA   cPendingMultiplicativeOperator          INIT ''

   DATA   lWaitingForOperand                      INIT .T.
   DATA   lSaveToClipboard                        INIT .T.

   METHOD AbortOperation()
   METHOD AdditiveOperatorClicked( cOp )
   METHOD AddToMemory()
   METHOD BackspaceClicked()
   METHOD Calculate( nRightOperand, cPendingOperator )
   METHOD ChangeSignClicked()
   METHOD ClearDisplay()
   METHOD ClearAll()
   METHOD ClearMemory()
   METHOD DigitClicked( nDig )
   METHOD EqualClicked()
   METHOD __KeyPress( oKeyEvent )
   METHOD MultiplicativeOperatorClicked( cOp )
   METHOD PointClicked()
   METHOD ReadMemory()
   METHOD SetMemory()
   METHOD UnaryOperatorClicked( cOp )
   METHOD __copyToClipboard()
   METHOD __pasteFromClipboard()

   METHOD tr( cText )                             INLINE ::oWidget:tr( cText )

   ENDCLASS


METHOD new( oParent, bClipboard ) Class HbQtCalculator

   hb_Default( bClipboard, .F. )

   ::lSaveToClipboard := bClipboard

   WITH OBJECT ::oWidget := QWidget( oParent )
      :setWindowFlags( Qt_Sheet )
      :setWindowTitle( ::tr( 'HbQt Calculator' ) )
      :connect( QEvent_KeyPress, { |k| ::__KeyPress( k ) } )
   ENDWITH

   RETURN  Self


METHOD Create() Class HbQtCalculator

   LOCAL i
   LOCAL nRow
   LOCAL nCol

   /* ToolBar */
   WITH OBJECT ::oTBar := QToolbar( ::oWidget )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setFloatable( .T. )
      :setMovable( .T. )
      /* Actions */
      IF !( ::lSaveToClipboard )
         ::oActions[ 1] := :addAction( ::tr( "&Copy" ) )
         ::oActions[ 1]:connect( "triggered(bool)", { || ::__copyToClipboard() } )
      ENDIF
      ::oActions[ 2] := :addAction( ::tr( "Paste" ) )
      ::oActions[ 2]:connect( "triggered(bool)", { || ::__pasteFromClipboard() } )
      :addSeparator()
      ::oActions[10] := :addAction( ::tr( "E&xit" ) )
      ::oActions[10]:connect( "triggered(bool)", { || ::Accept() } )
   END WITH

   /* oSpinner Display */
   WITH OBJECT ::oSpinner := QSpinBox( ::oWidget )
      :setRange( 0, 9 )
      :setValue( ::nPrecision )
      :setPrefix( ::tr( 'Precision ' ) )
      :setSuffix( ::tr( ' Digits' ) )
      :connect( "valueChanged(int)", { |i| ::nPrecision := i, ::EqualButton():SetFocus() } )
   END WITH

   /* Add to ToolBar */
   ::oTBar:addSeparator()
   ::oTBar:addWidget( ::oSpinner )

   /* oMemo Display */
   WITH OBJECT ::oMemo := QTextEdit()
      :setReadOnly( .T. )
      :setAlignment( Qt_AlignRight )   // 1: Qt_AlignLeft  2: Qt_AlignRight  4: Qt_AlignCenter 8: use all textbox length
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 * 9 )
      :setMaximumWidth(  48 * 6 )
      /* Font */
      ::oFont := QFont( 'Courier New' )
      ::oFont:setPointSize( 12 )
      :setFont( ::oFont )
   END WITH

   /* Display */
   WITH OBJECT ::oDisplay := QLineEdit( '0', ::oWidget )
      :setReadOnly( .T. )
      :setAlignment( Qt_AlignRight )   // 1: Qt_AlignLeft  2: Qt_AlignRight  4: Qt_AlignCenter 8: use all textbox length
      :setMaxLength( 22 )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 * 5 )
      /* Font */
      ::oFont := :Font()
      ::oFont:setPointSize( 12 )
      :setFont( ::oFont )
   END WITH

   /* oOperand Display */
   WITH OBJECT ::oOperand := QLineEdit( ::oWidget )
      :setReadOnly( .T. )
      :setAlignment( Qt_AlignCenter )   // 1: Qt_AlignLeft  2: Qt_AlignRight  4: Qt_AlignCenter 8: use all textbox length
      :setMaxLength( 5 )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 * 1 )
      /* Font */
      :setFont( ::oFont )
   END WITH

   /* Digits 0..9 */
   FOR i := 1 To 10
     WITH OBJECT ::DigitButtons[i] := QPushButton( ::oWidget )
        :setText( hb_NtoS( i ) )
        :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
        :setMinimumHeight( 32 )
        :setMaximumWidth( 48 )
     END WITH
   NEXT
   ::DigitButtons[ 1]:connect( "clicked()", {|| ::DigitClicked( 1 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 2]:connect( "clicked()", {|| ::DigitClicked( 2 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 3]:connect( "clicked()", {|| ::DigitClicked( 3 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 4]:connect( "clicked()", {|| ::DigitClicked( 4 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 5]:connect( "clicked()", {|| ::DigitClicked( 5 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 6]:connect( "clicked()", {|| ::DigitClicked( 6 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 7]:connect( "clicked()", {|| ::DigitClicked( 7 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 8]:connect( "clicked()", {|| ::DigitClicked( 8 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[ 9]:connect( "clicked()", {|| ::DigitClicked( 9 ), ::EqualButton():SetFocus() } )
   ::DigitButtons[10]:setText( '0' )
   ::DigitButtons[10]:connect( "clicked()", {|| ::DigitClicked( 0 ), ::EqualButton():SetFocus() } )

   /* Ponto */
   WITH OBJECT ::PointButton := QPushButton( ::oWidget )
      :setText( '.' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::PointClicked(), ::EqualButton():SetFocus() } )
   END WITH

   /* Change */
   WITH OBJECT ::ChangeSignButton := QPushButton( ::oWidget )
      :setText( '+/-' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::ChangeSignClicked(), ::EqualButton():SetFocus() } )
   END WITH

   /* Backspace */
   WITH OBJECT ::BackspaceButton := QPushButton( ::oWidget )
      :setText( ::tr( 'BackSpace' ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 * 2 )
      :connect( "clicked()", {|| ::BackspaceClicked(), ::EqualButton():SetFocus() } )
   END WITH

   /* ClearButton */
   WITH OBJECT ::ClearButton := QPushButton( ::oWidget )
      :setText( ::tr( '&Clear' ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 * 2 )
      :connect( "clicked()", {|| ::ClearDisplay(), ::EqualButton():SetFocus() } )
   END WITH

   /* ClearAllButton  */
   WITH OBJECT ::ClearAllButton := QPushButton( ::oWidget )
      :setText( ::tr( 'Cl&ear All' ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 * 2 )
      :connect( "clicked()", {|| ::ClearAll(), ::EqualButton():SetFocus() } )
   END WITH

   /* ClearMemoryButton */
   WITH OBJECT ::ClearMemoryButton := QPushButton( ::oWidget )
      :setText( 'MC' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::ClearMemory(), ::EqualButton():SetFocus() } )
   END WITH

   /* ReadMemoryButton */
   WITH OBJECT ::ReadMemoryButton := QPushButton( ::oWidget )
      :setText( 'MR' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::ReadMemory(), ::EqualButton():SetFocus() } )
   END WITH

   /* SetMemoryButton */
   WITH OBJECT ::SetMemoryButton := QPushButton( ::oWidget )
      :setText( 'MS' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::SetMemory(), ::EqualButton():SetFocus() } )
   END WITH

   /* AddToMemoryButton */
   WITH OBJECT ::AddToMemoryButton := QPushButton( ::oWidget )
      :setText( 'M+' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::AddToMemory(), ::EqualButton():SetFocus() } )
   END WITH

   /* DivisionButton */
   WITH OBJECT ::DivisionButton := QPushButton( ::oWidget )
      :setText( '/' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::MultiplicativeOperatorClicked( '/' ), ::EqualButton():SetFocus() } )
   END WITH

   /* TimesButton */
   WITH OBJECT ::TimesButton := QPushButton( ::oWidget )
      :setText( '*' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::multiplicativeOperatorClicked( '*' ), ::EqualButton():SetFocus() } )
   END WITH

   /* MinusButton */
   WITH OBJECT ::MinusButton := QPushButton( ::oWidget )
      :setText( '-' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::AdditiveOperatorClicked( '-' ), ::EqualButton():SetFocus() } )
   END WITH

   /* PlusButton */
   WITH OBJECT ::PlusButton := QPushButton( ::oWidget )
      :setText( '+' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::AdditiveOperatorClicked( '+' ), ::EqualButton():SetFocus() } )
   END WITH

   /* SquareRootButton */
   WITH OBJECT ::SquareRootButton := QPushButton( ::oWidget )
      :setText( ::tr( 'Sqrt' ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::UnaryOperatorClicked( 'Sqrt' ), ::EqualButton():SetFocus() } )
   END WITH

   /* PowerButton */
   WITH OBJECT ::PowerButton := QPushButton( ::oWidget )
      :setText( ::tr( "^2" ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::UnaryOperatorClicked( '^2' ), ::EqualButton():SetFocus() } )
   END WITH

   /* ReciprocalButton */
   WITH OBJECT ::ReciprocalButton := QPushButton( ::oWidget )
      :setText( ::tr( '1/x' ) )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::UnaryOperatorClicked( '1/x' ), ::EqualButton():SetFocus() } )
   END WITH

   /* EqualButton */
   WITH OBJECT ::EqualButton := QPushButton( ::oWidget )
      :setText( '=' )
      :setSizePolicy( QSizePolicy_Expanding, QSizePolicy_Preferred )
      :setMinimumHeight( 32 )
      :setMaximumWidth( 48 )
      :connect( "clicked()", {|| ::EqualClicked() } )
   END WITH

   /* Place all widgets in a Grid Layout */
   WITH OBJECT ::oLayout := QGridLayout( ::oWidget )
      :setSizeConstraint( QLayout_SetFixedSize )
      :setContentsMargins( 0, 0, 0, 0 )
      :setHorizontalSpacing( 0 )
      :setVerticalSpacing( 0 )
   END WITH

   /* oLayout */

   ::oLayout:addWidget( ::oTBar,               0, 0, 1, 6 )

   ::oLayout:addWidget( ::oMemo,               1, 0, 1, 6 )

   ::oLayout:addWidget( ::oDisplay,            2, 0, 1, 5 )
   ::oLayout:addWidget( ::oOperand,            2, 5, 1, 1 )

   ::oLayout:addWidget( ::BackspaceButton,     3, 0, 1, 2 )
   ::oLayout:addWidget( ::ClearButton,         3, 2, 1, 2 )
   ::oLayout:addWidget( ::ClearAllButton,      3, 4, 1, 2 )

   ::oLayout:addWidget( ::ClearMemoryButton,   4, 0 )
   ::oLayout:addWidget( ::ReadMemoryButton,    5, 0 )
   ::oLayout:addWidget( ::SetMemoryButton,     6, 0 )
   ::oLayout:addWidget( ::AddToMemoryButton,   7, 0 )

   ::oLayout:addWidget( ::DivisionButton,      4, 4 )
   ::oLayout:addWidget( ::TimesButton,         5, 4 )
   ::oLayout:addWidget( ::MinusButton,         6, 4 )
   ::oLayout:addWidget( ::PlusButton,          7, 4 )

   ::oLayout:addWidget( ::SquareRootButton,    4, 5 )
   ::oLayout:addWidget( ::PowerButton,         5, 5 )
   ::oLayout:addWidget( ::ReciprocalButton,    6, 5 )
   ::oLayout:addWidget( ::EqualButton,         7, 5 )

   /* Digitos 0..9 */
   FOR i := 1 To 9
      nRow := INT( ( ( 9 - i ) / 3 ) + 4 )
      nCol := INT( ( ( i - 1 ) % 3 ) + 1 )
      ::oLayout:addWidget( ::DigitButtons[i], nRow, nCol )
   NEXT
   ::oLayout:addWidget( ::DigitButtons[10],    7, 1 )

   ::oLayout:addWidget( ::PointButton,         7, 2 )
   ::oLayout:addWidget( ::ChangeSignButton,    7, 3 )

   ::oWidget:setLayout( ::oLayout )

   ::EqualButton():SetFocus()

   ::oMemo:setHidden( .T. )
   WITH OBJECT ::oTBar
      :addSeparator()
      ::oBtnShowMemo := :addAction( ::tr( "Show Details" ) )
      ::oBtnShowMemo:connect( "triggered(bool)", { |lVis| lVis := ::oMemo:isVisible(), ;
                                                          ::oBtnShowMemo:setText( iif( lVis, "Show Details", "Hide Details" ) ), ;
                                                          iif( lVis, ::oMemo:hide(), ::oMemo:show() ) } )
   ENDWITH

   RETURN Self


METHOD DigitClicked( nDig ) Class HbQtCalculator

   LOCAL cAux := ::oDisplay():text()
   LOCAL nAux := VAL( cAux )

   IF ( ABS( nAux ) + ABS( nDig ) ) <> 0

      IF ::lWaitingForOperand
         cAux := ''
         ::lWaitingForOperand := .F.
      ENDIF

      ::oDisplay():setText( cAux + hb_NtoS( nDig ) )
   ENDIF

   RETURN .F.


METHOD PointClicked() Class HbQtCalculator

   LOCAL cAux := ::oDisplay():Text()

   IF ::lWaitingForOperand
      cAux := '0'
   ENDIF

   IF AT( '.', cAux ) < 1
     cAux += '.'
   ENDIF

   ::lWaitingForOperand := .F.

   ::oDisplay():setText( cAux )

   RETURN .F.


METHOD ChangeSignClicked() Class HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay():Text() )

   IF nAux <> 0
      nAux *= ( -1 )
      ::oDisplay():setText( hb_NtoS( nAux ) )
   ENDIF

   RETURN .F.


METHOD BackspaceClicked() Class HbQtCalculator

   LOCAL cAux := ::oDisplay():Text()
   LOCAL nAux := LEN( cAux )

   IF !( ::lWaitingForOperand )

      IF VAL( cAux ) <> 0
         cAux := SUBSTR( cAux, 1, nAux - 1 )
      ELSE
         cAux := '0'
         ::lWaitingForOperand := .T.
      ENDIF

      ::oDisplay():setText( cAux )

   ENDIF

   RETURN .F.


METHOD ClearDisplay() Class HbQtCalculator

   IF !( ::lWaitingForOperand )
      ::oDisplay():setText( '0' )
      ::lWaitingForOperand := .T.
   ENDIF

   RETURN .F.


METHOD ClearAll() Class HbQtCalculator

   ::nSumSoFar    := 0
   ::nFactorSoFar := 0

   ::cPendingAdditiveOperator := ''
   ::cPendingMultiplicativeOperator := ''

   ::oDisplay():SetText( '0' )

   ::lWaitingForOperand := .T.

   RETURN .F.


METHOD ClearMemory() Class HbQtCalculator

   ::nSumInMemory := 0

   RETURN .F.


METHOD ReadMemory() Class HbQtCalculator

   ::oDisplay():setText( hb_NtoS( ::nSumInMemory ) )
   :: lWaitingForOperand := .T.

   RETURN .F.


METHOD SetMemory() Class HbQtCalculator

   ::EqualClicked()
   ::nSumInMemory := VAL( ::oDisplay():Text() )

   RETURN .F.


METHOD AddToMemory() Class HbQtCalculator

   ::EqualClicked()
   ::nSumInMemory += VAL( ::oDisplay():Text() )

   RETURN .F.


METHOD MultiplicativeOperatorClicked( cOp ) Class HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay():text() )
   LOCAL bAux := .T.
   LOCAL aAux := AFILL( Array( 10 ), '' )

   aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )

   IF !( EMPTY( ::cPendingMultiplicativeOperator ) )
      IF !( ::Calculate( nAux, ::cPendingMultiplicativeOperator ) )
         ::AbortOperation()
         bAux := .F.
      ENDIF
      IF bAux
         ::oDisplay():setText( hb_NtoS( ::nFactorSoFar ) )
      ENDIF
   ELSE
     ::nFactorSoFar := nAux
   ENDIF

   IF bAux
      aAux[3] := PADC( cOp, 3 )
      ::oMemo:Append( aAux[2] + aAux[3] )
      ::cPendingMultiplicativeOperator := cOp
      ::lWaitingForOperand := .T.
   ENDIF

   ::oOperand:setText( aAux[3] )

   RETURN .F.


METHOD AdditiveOperatorClicked( cOp ) Class HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay():text() )
   LOCAL bAux := .T.
   LOCAL aAux := AFILL( Array( 10 ), '' )

   aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )

   IF !( EMPTY( ::cPendingMultiplicativeOperator ) )

      IF bAux := ( ::Calculate( nAux, ::cPendingMultiplicativeOperator ) )
         aAux[1] := hb_NtoS( ::nFactorSoFar )
         ::oDisplay():setText( aAux[1] )
         nAux := ::nFactorSoFar
         ::nFactorSoFar := 0
         ::cPendingMultiplicativeOperator := ''
      ELSE
         ::AbortOperation()
      ENDIF

   ENDIF

   IF bAux
      IF !( EMPTY( ::cPendingAdditiveOperator) )
         IF bAux := ( ::Calculate( nAux, ::cPendingAdditiveOperator ) )
            aAux[1] := hb_NtoS( ::nFactorSoFar )
            ::oDisplay():setText( aAux[1] )
         ELSE
            ::abortOperation()
         ENDIF
      ELSE
         ::nSumSoFar := nAux
      ENDIF
   ENDIF

   IF bAux
      aAux[3] := PADC( cOp, 3 )
      ::oMemo:Append( aAux[2] + aAux[3] )
      ::cPendingAdditiveOperator := cOp
      ::lWaitingForOperand := .T.
   ENDIF

   ::oOperand:setText( aAux[3] )

   RETURN .F.


METHOD UnaryOperatorClicked( cOp ) Class HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay():text() )
   LOCAL bAct := .T.
   LOCAL nResult := 0
   LOCAL aAux := AFILL( Array( 10 ), '' )

   aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )

   IF cOp == 'Sqrt'
      IF bAct := ( nAux >= 0 )
         aAux[3] := PADC( ')', 3 )
         nResult := sqrt( nAux )
        ::oMemo:Append( cOp + '( ' + aAux[2] + aAux[3] )
      ELSE
         ::AbortOperation()
      ENDIF
   ENDIF

   IF cOp == '^2'
      aAux[3] := PADL( cOp, 3 )
      nResult := ( nAux ^ 2 )
      ::oMemo:Append( aAux[2] + aAux[3] )
   ENDIF

   IF cOp == '1/x'
      IF bAct := ( nAux >= 0 )
         aAux[2] := hb_NtoS( ROUND( 1, ::nPrecision ) )
         aAux[3] := PADC( '/', 3 )
         ::oMemo:Append( aAux[2] + aAux[3] )
         aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )
         aAux[3] := PADC( '', 3 )
         ::oMemo:Append( aAux[2] + aAux[3] )
         nResult := ( 1 / nAux )
      ELSE
         ::AbortOperation()
      ENDIF
   ENDIF

   IF bAct
      aAux[1] := Repl( '-', 26 )
      aAux[2] := hb_NtoS( ROUND( nResult, ::nPrecision ) )
      aAux[3] := '(=)'
      ::oMemo:Append( aAux[1] )
      ::oMemo:Append( aAux[2] + aAux[3] )
      ::oMemo:Append( aAux[10] )
      ::oDisplay():setText( aAux[2] )
      ::lWaitingForOperand := .T.
   ELSE
      aAux[3] := ''
   ENDIF

   ::oOperand:setText( aAux[3] )

   RETURN .F.


METHOD EqualClicked() Class HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay():text() )
   LOCAL bAux
   LOCAL aAux := AFILL( Array( 10 ), '' )

   aAux[3] := SPACE( 3 )

   IF !( bAux := ( EMPTY( ::cPendingMultiplicativeOperator) ) )
      IF bAux := ( ::Calculate( nAux, ::cPendingMultiplicativeOperator ) )
         aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )
         ::oMemo:Append( aAux[2] + aAux[3] )
         nAux := ::nFactorSoFar
         ::nFactorSoFar := 0.0
         ::cPendingMultiplicativeOperator := ''
      ELSE
         ::AbortOperation()
      ENDIF
   ENDIF

   IF bAux
      IF ( EMPTY( ::cPendingAdditiveOperator) )
         ::nSumSoFar := nAux
      ELSE
         IF ( ::Calculate( nAux, ::cPendingAdditiveOperator ) )
            aAux[2] := hb_NtoS( ROUND( nAux, ::nPrecision ) )
            ::oMemo:Append( aAux[2] + aAux[3] )
            ::cPendingAdditiveOperator := ''
         ELSE
            ::abortOperation()
         ENDIF
      ENDIF
   ENDIF

   aAux[1] := Repl( '-', 26 )
   aAux[2] := hb_NtoS( ROUND( ::nSumSoFar, ::nPrecision ) )
   aAux[3] := '(=)'

   ::oMemo:Append( aAux[1] )
   ::oMemo:Append( aAux[2] + aAux[3] )
   ::oMemo:Append( aAux[10] )

   ::oDisplay():setText( aAux[2] )

   ::oOperand:setText( aAux[3] )

   ::nSumSoFar := 0
   ::lWaitingForOperand := .T.

   IF ::lSaveToClipboard
      ::__copyToClipboard()
   ENDIF

   RETURN .F.


METHOD __KeyPress( oKeyEvent ) Class HbQtCalculator

   LOCAL nKey := oKeyEvent:key()

   ::EqualButton():SetFocus()

   IF     nKey == Qt_Key_Escape
      ::oWidget:close()

   ELSEIF nKey == Qt_Key_Backspace
      ::BackspaceClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Enter
      ::EqualClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Return
      ::EqualClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Equal
      ::EqualClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Asterisk
      ::MultiplicativeOperatorClicked( '*' )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_C
      ::ClearDisplay()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_E
      ::ClearAll()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Plus
      ::AdditiveOperatorClicked( '+' )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Comma
      ::PointClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Period
      ::PointClicked()
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Minus
      ::AdditiveOperatorClicked( '-' )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Less
      ::AdditiveOperatorClicked( '-' )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_Slash
      ::MultiplicativeOperatorClicked( '/' )
      oKeyEvent:accept()

   //ELSEIF nKey == Qt_Key_Ctrl_V
   //   ::__pasteFromClipboard()

   ELSEIF nKey == Qt_Key_division
      ::MultiplicativeOperatorClicked( '/' )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_0
      ::DigitClicked( 0 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_1
      ::DigitClicked( 1 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_2
      ::DigitClicked( 2 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_3
      ::DigitClicked( 3 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_4
      ::DigitClicked( 4 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_5
      ::DigitClicked( 5 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_6
      ::DigitClicked( 6 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_7
      ::DigitClicked( 7 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_8
      ::DigitClicked( 8 )
      oKeyEvent:accept()

   ELSEIF nKey == Qt_Key_9
      ::DigitClicked( 9 )
      oKeyEvent:accept()

   ENDIF

   RETURN .F.


METHOD Calculate( nRightOperand, cPendingOperator ) Class HbQtCalculator

   LOCAL bResult := .T.

   IF     cPendingOperator == '+'
      ::nSumSoFar += nRightOperand

   ELSEIF cPendingOperator == '-'
      ::nSumSoFar -= nRightOperand

   ELSEIF cPendingOperator == '*'
      ::nFactorSoFar *= nRightOperand

   ELSEIF cPendingOperator == '/'
      IF ( bResult := ( nRightOperand <> 0 ) )
         ::nFactorSoFar /= nRightOperand
      ENDIF

   ELSE
      bResult := .F.

   ENDIF

   RETURN( bResult )


METHOD AbortOperation() Class HbQtCalculator

   ::ClearAll()
   ::oDisplay():setText( 'Error' )

   RETURN .F.


METHOD __copyToClipboard() CLASS HbQtCalculator

   LOCAL cAux := ::oDisplay:text()

   ::oDisplay:selectAll()
   ::oDisplay:copy()
   ::oDisplay:clear()
   ::oDisplay:setText( cAux )

   RETURN .F.


METHOD __pasteFromClipboard() CLASS HbQtCalculator

   LOCAL cAux

   ::ClearAll()
   ::oDisplay:paste()

   cAux := ::oDisplay:text()
   cAux := hb_NtoS( ROUND( VAL( STRTRAN( cAux, ',', '.' ) ), ::nPrecision ) )

   ::oDisplay:setText( cAux )

   RETURN .F.


METHOD __getData( nLPrecision ) CLASS HbQtCalculator

   LOCAL nAux := VAL( ::oDisplay:Text() )

   hb_Default( nLPrecision, ::nPrecision )

   RETURN( hb_NtoS( ROUND( nAux, nLPrecision ) ) )


METHOD __setData( nValue ) CLASS HbQtCalculator

   hb_Default( nValue, 0 )

   ::ClearAll()

   ::oDisplay:setText( hb_NtoS( ROUND( nValue, ::nPrecision ) ) )

   RETURN .F.

