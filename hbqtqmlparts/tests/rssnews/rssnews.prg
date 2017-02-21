/*
 * $Id$
 */

/*
 * Copyright 2017 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"


FUNCTION Main()
   LOCAL oWnd, oBridge

   QResource():registerResource_1( hbqtres_rssnews() )
   
   WITH OBJECT oWnd := QWidget()
      :resize( 800, 400 )
   ENDWITH

   WITH OBJECT oBridge := HbQtQmlBridge():new():create( oWnd )
      :setQml( "qrc:/tests/rssnews/rssnews.qml" )
   ENDWITH

   oWnd:show()
      
   QApplication():exec()

   HB_SYMBOL_UNUSED( oBridge )
   RETURN NIL



