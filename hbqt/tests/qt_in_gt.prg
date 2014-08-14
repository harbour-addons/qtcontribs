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

   SetMode( 25, 80 )

   DO WHILE .T.
      IF Alert( "Execute Qt Widget ?", { "Yes","No" } ) <> 1
         EXIT
      ENDIF
      MyQtWidget()
   ENDDO

   RETURN NIL


FUNCTION MyQtWidget()
   LOCAL oWnd
   LOCAL lDone := .f.

   oWnd := QWidget()
   oWnd:show()
   oWnd:connect( QEvent_Close, {|| lDone := .t. } )

   // NOTE: we cannot use QApplication():exec() here because
   //       QApplication must remain alive for the lifetime
   //       console application is alive.
   //
   DO WHILE ! lDone
      QApplication():processEvents( 0 )
   ENDDO

   RETURN NIL


FUNCTION hb_gtSys()

   REQUEST HB_GT_WIN_DEFAULT
   REQUEST HB_GT_WVT

   RETURN NIL

