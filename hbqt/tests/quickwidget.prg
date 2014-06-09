/*
 * $Id$
 */

/*
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */

/*
   This example is exactly the same as shipped WITH Qt 5.3.0.
   And its behavior is also exactly the same as if compiled with QtCreator.
   But the behavior is not what is expected. I feel there seems TO be some bug on Qt part
   which will be fixed eventually.

   Bottom line is that HbQt now has the power of QtQuick, a versatile GUI component.
*/

#include "hbqtgui.ch"


FUNCTION Main()

   Test_1()

   RETURN NIL


STATIC FUNCTION Test_1()
   LOCAL oMainWnd, oCentralWidget, oLcd, oSource, oQuickWidget, oRes

   oRes := QResource()
   oRes:registerResource_1( HBQTRES_QuickWidget() )

   oMainWnd := QMainWindow()
   oCentralWidget := QMdiArea( oMainWnd )
   oMainWnd:setCentralWidget( oCentralWidget )
   oMainWnd:resize( 650,350 )

   oLcd := QLCDNumber( oCentralWidget )
   oLcd:display( 1337 )
   oLcd:setMinimumSize( 250,100 )
   oCentralWidget:addSubWindow( oLcd )

   oSource := QUrl( "qrc:quickwidget/rotatingsquare.qml" )
   //
   oQuickWidget := QQuickWidget()
   //
   oQuickWidget:connect( "statusChanged(QQuickWidget::Status)", {|nStatus| quickWidgetStatusChanged( nStatus ) } )
   oQuickWidget:connect( "sceneGraphError(QQuickWindow::SceneGraphError,QString)", {|nError,cString| sceneGraphError( nError, cString, oMainWnd ) } )
   //
   oQuickWidget:resize( 300, 300 )
   oQuickWidget:setResizeMode( QQuickView_SizeViewToRootObject )
   //oQuickWidget:setResizeMode( QQuickWidget_SizeRootObjectToView )
   oQuickWidget:setSource( oSource )
   //
   oCentralWidget:addSubWindow( oQuickWidget )

   oMainWnd:show()

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION quickWidgetStatusChanged( nStatus )
   HB_SYMBOL_UNUSED( nStatus )
   RETURN NIL


STATIC FUNCTION sceneGraphError( nError, cString, oMainWnd )
   oMainWnd:statusBar():showMessage( hb_ntos( nError ) + ": " + cString )
   RETURN NIL

