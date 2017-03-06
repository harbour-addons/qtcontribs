/*
 * $Id$
 */

/*
 * Copyright 2017 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbqtgui.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"


FUNCTION Main()
   LOCAL oWnd, oBtn

   hbqt_errorSys()

   oWnd := QMainWindow()
   __hbqtAppWidget( oWnd )

   WITH OBJECT oBtn := QPushButton( "Fetch Signatures" )
      :connect( "clicked()", {|| HbQtFetchSignature( {|nStatus, oImg| __manageImage( nStatus, oImg ) } ) } )
   ENDWITH

   oWnd:setCentralWidget( oBtn )
   oWnd:resize( 500, 350 )
   oWnd:show()

   QApplication():exec()
   RETURN NIL


STATIC FUNCTION __manageImage( nStatus, oImg )

   Alert( { nStatus, oImg } )

   SWITCH nStatus
   CASE 0
      IF HB_ISOBJECT( oImg )                      // success
         oImg:save( hb_DirBase() + "signature.png" )
      ENDIF
      EXIT
   CASE 1                                         // cancelled by user
      EXIT
   CASE 2                                         // timed-out, take decision as per app logic
      IF HB_ISOBJECT( oImg )                      // success
         oImg:save( hb_DirBase() + "signature.png" )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN NIL

