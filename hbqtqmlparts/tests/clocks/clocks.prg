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

   QResource():registerResource_1( hbqtres_clocks() )
   
   WITH OBJECT oWnd := QWidget()
      :resize( 800, 400 )
   ENDWITH
   __hbqtAppWidget( oWnd )
	
   WITH OBJECT oBridge := HbQtQmlBridge():new():create( oWnd )
      :setQml( "qrc:/tests/clocks/clocks.qml" )
   ENDWITH

   oWnd:show()
   //__hbqtShowLog()
   
   QApplication():exec()

   HB_SYMBOL_UNUSED( oBridge )
   RETURN NIL



