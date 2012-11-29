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

/*----------------------------------------------------------------------*/

FUNCTION Main()
   LOCAL oWnd, oLayout, oEdit

   oWnd    := QWidget()
   oLayout := QFormLayout( oWnd )

   oWnd:resize( 400, 100 )

   oEdit := QLineEdit( oWnd )
   oEdit:setValidator( HBQValidator( {|cText,nPos| ConvertToUpperCase( cText, nPos ) } ) )
   oLayout:addRow( "Upper Cased Alphabets:", oEdit )

   oEdit := QLineEdit( oWnd )
   oEdit:setValidator( HBQValidator( {|cText,nPos| DateBritish( cText, nPos ) } ) )
   oLayout:addRow( "British Date:", oEdit )

   oEdit := QLineEdit( oWnd )
   oEdit:setValidator( HBQValidator( {|cText,nPos| Upto6DecimalsOnly( cText, nPos ) } ) )
   oLayout:addRow( "Maximum 6 Decimals:", oEdit )

   oWnd:show()
   QApplication():exec()

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
