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

   #command QREAD => QReadGets( aQGetList, .T. )
   #command QREAD PARENT <oParent> => QReadGets( aQGetList, .F., <oParent> )

   #command @ <row>, <col> QGET <v> [PICTURE <pic>] ;
                           [VALID <valid>] [WHEN <when>] [VALIDATOR <validator>];
                           [CAPTION <cap>] [COLOR <color>] => ;
         aQGetList := {} ;;
         AAdd( aQGetList, { <v>, <"v">, <pic>, <{valid}>, <{when}>, <cap>, <color>, <{validator}> } )

/*----------------------------------------------------------------------*/

FUNCTION Main( cMode )
   LOCAL oWnd, oEdit1, oEdit2, oEdit3, aQGetList, oVLayout, oHLayout, oFLayout, oBtnOK, oBtnCancel
   LOCAL cText := "DEF"
   LOCAL cDate := "04/06/1956"
   LOCAL cNumb := "6030.130000"

   hb_default( @cMode, "O" )

   IF cMode == "O"
      oWnd    := QWidget()
      oWnd:resize( 400, 200 )
      oWnd:setWindowTitle( "Clipper Like Get System" )

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

      oEdit1 := HbQtGet():new( oWnd ):create()
      oEdit1:valid := {|cValue| cValue $ "ABC,DEF" }
      oEdit1:inputValidator := {|cText,nPos| ConvertToUpperCase( cText, nPos ) }
      oFLayout:addRow( "Upper Cased Alphabets:", oEdit1 )

      oEdit2 := HbQtGet():new( oWnd ):create()
      oEdit2:when := {|| oEdit1:text() == "ABC" }
      oEdit2:inputValidator := {|cText,nPos| DateBritish( cText, nPos ) }
      oFLayout:addRow( "British Date:", oEdit2 )

      oEdit3 := HbQtGet():new( oWnd ):create()
      oEdit3:valid := {|| oBtnOK:setEnabled( .T. ) }
      oEdit3:inputValidator := {|cText,nPos| Upto6DecimalsOnly( cText, nPos ) }
      oFLayout:addRow( "Maximum 6 Decimals:", oEdit3 )

   ELSE /* A Futuristic but Required Implementation based on above Concept */
      @ 10,10 QGET cText VALID {|cValue| cValue $ "ABC,DEF" } PICTURE "@!" COLOR "W+/B" ;
             VALIDATOR {|cText,nPos| ConvertToUpperCase( cText, nPos ) } ;
             CAPTION "Upper Cased Alphabets:"

      @ 10,40 QGET cDate WHEN {|| cText == "ABC" } VALIDATOR {|cText,nPos| DateBritish( cText, nPos ) } ;
             CAPTION "British Date:"

      @ 10,70 QGET cNumb VALIDATOR {|cText,nPos| Upto6DecimalsOnly( cText, nPos ) } CAPTION "Maximum 6 Decimals:"

      QREAD

   ENDIF

   oEdit1:setFocus()
   oWnd:show()
   QApplication():exec()


   RETURN NIL

/*----------------------------------------------------------------------*/

STATIC FUNCTION QReadGets( aGetList, lModal, oParent )

   HB_SYMBOL_UNUSED( lModal )
   HB_SYMBOL_UNUSED( oParent )

   AEval( aGetList, {|e| HB_TRACE( HB_TR_ALWAYS, ValType( e ), e ) } )

   RETURN NIL

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

STATIC FUNCTION ConvertToUpperCase( cText, nPos )

   IF IsDigit( SubStr( cText, nPos, 1 ) )
      RETURN .F.
   ENDIF

   RETURN Upper( cText )

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
//                            CLASS HbQtEdit
/*----------------------------------------------------------------------*/

CLASS HbQtGet INHERIT HB_QLineEdit

   METHOD create()
   METHOD when( bBlock )                          SETGET
   METHOD valid( bBlock )                         SETGET
   METHOD inputValidator( bBlock )                SETGET

   PROTECTED:

   VAR    sl_whenblock
   VAR    sl_validBlock
   VAR    sl_inputValidator

   METHOD checkWhen( oFocusEvent )
   METHOD checkValid( oKeyEvent )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD HbQtGet:create()

   ::setFocusPolicy( Qt_TabFocus )

   ::connect( "returnPressed()", {|| QApplication():sendEvent( Self, QKeyEvent( QEvent_KeyPress, Qt_Key_Tab, Qt_NoModifier ) ) } )
   ::connect( QEvent_FocusIn   , {|oFocusEvent| ::checkWhen( oFocusEvent ) } )
   ::connect( QEvent_KeyPress  , {|oKeyEvent  | ::checkValid( oKeyEvent ) } )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD HbQtGet:inputValidator( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::sl_inputValidator := bBlock
      ::setValidator( HBQValidator( ::sl_inputValidator ) )
   ENDIF

   RETURN ::sl_inputValidator

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
      EXIT
   ENDSWITCH

   RETURN .F.

/*----------------------------------------------------------------------*/
