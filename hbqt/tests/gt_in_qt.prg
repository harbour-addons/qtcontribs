/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 */

#include "hbqtgui.ch"


FUNCTION Main()
   LOCAL oWnd, oBtn
   LOCAL lDone := .f.

   oWnd := QWidget()
   oWnd:show()
   oWnd:connect( QEvent_Close, {|| lDone := .t. } )

   oBtn := QPushButton( "Activate a GT Window", oWnd )
   oBtn:move( 100, 100 )
   oBtn:show()
   oBtn:connect( "clicked()", {|| MyGtWindow() } )

   // NOTE: we cannot use QApplication():exec() here because
   //       QApplication must remain alive for the lifetime
   //       console application is alive.
   //
   DO WHILE ! lDone
      QApplication():processEvents( 0 )
   ENDDO

   RETURN NIL


FUNCTION MyGtWindow()
   LOCAL nSecs

   hb_gtReload( "QTC" )

   SetMode( 25, 80 )

   nSecs := Seconds()
   DO WHILE Inkey( 0.1 ) != 27
      IF Seconds() - nSecs > 2
         ? Time()
         nSecs := Seconds()
      ENDIF
   ENDDO

   RETURN NIL


FUNCTION hb_gtSys()

   REQUEST HB_GT_QTC_DEFAULT
   REQUEST HB_GT_WVT

   RETURN NIL

