/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2015 Luigi Ferraris <luigferraris at gmail.com>
 * www - http://harbour-project.org
 *
 *
 * This simple example shows how to make a glossy button, using QEvent_Paint management
 *
 * Enjoy with qtconribs!
 *
 */

#include "hbqtgui.ch"

MEMVAR oQtApp


/*
   standard main function
*/
PROCEDURE Main( ... )

   PUBLIC oQtApp := QApplication()

   hbqt_errorsys()

   ShowMainForm()

   RETURN


/*
   
   show form

*/
PROCEDURE ShowMainForm()

   LOCAL oWnd
   LOCAL oBtn

   WITH OBJECT oWnd := QMainWindow()
      :resize( 300, 300 )
      :setWindowTitle( "Glossy button using paint event" )
   END WITH

   WITH OBJECT oBtn := QToolButton( oWnd )
      :setGeometry( 100, 135, 100, 30 )
      :setToolButtonStyle( Qt_ToolButtonTextOnly )
      :setText( "press" )
      :connect( "clicked()", {|| udf_test() } )
      :connect( QEvent_Paint, { | oEvent, oPainter | udf_paint( oEvent, oPainter, oBtn ) } )
   END WITH

   oWnd:show()
   
   oQtApp:exec()

   HB_SYMBOL_UNUSED( oBtn )
  
   RETURN


/*
   
   paint event

*/
STATIC FUNCTION udf_paint( oEvent, oPainter, oWdg1 )

   LOCAL oBtRect
   LOCAL oColor
   LOCAL oShadow
   LOCAL nRoundNess
   LOCAL nOpacity
   LOCAL oGradient
   LOCAL oBrush
   LOCAL oPainterPath
   LOCAL cText
   LOCAL oFont

   oBtRect := oWdg1:geometry()

   oColor := QColor( Qt_gray )
   oShadow := QColor( Qt_black )

   oGradient := QLinearGradient( 0, 0, 0, oBtRect:height() )
   oGradient:setSpread( QGradient_ReflectSpread )
   oGradient:setColorAt( 0.0, oColor )
   oGradient:setColorAt( 0.4, oShadow )
   oGradient:setColorAt( 0.6, oShadow )
   oGradient:setColorAt( 1.0, oColor )

   oBrush := QBrush( oGradient )
   oPainter:setBrush( oBrush )
   oPainter:setPen(  QPen( QBrush( oColor), 2.0 ) )

   oPainterPath := QPainterPath()
   nRoundNess := 0
   oPainterPath:addRoundedRect( 1, 1, oBtRect:width() - 2, oBtRect:height() - 2, nRoundNess, nRoundNess )
   oPainter:setClipPath( oPainterPath )
 
   nOpacity := 1
   oPainter:setOpacity( nOpacity )
   oPainter:drawRoundedRect( 1, 1, oBtRect:width() - 2, oBtRect:height() - 2, nRoundNess, nRoundNess )

   // enable these lines to add highlight

   oPainter:setBrush( QBrush( QColor( Qt_white ) ) )
   oPainter:setPen( QPen( QBrush( QColor( Qt_white ) ), 0.01 ) )
   oPainter:setOpacity( 0.30 )
   oPainter:drawRect( 1, 1, oBtRect:width() - 2, ( oBtRect:height() / 2 ) - 2 )

   cText := oWdg1:text()
   IF ! EMPTY( cText )
      oFont := oWdg1:font()
      oPainter:setFont( oFont )
      oPainter:setPen( QColor( Qt_white ) )
      oPainter:setOpacity( 1.0 )
      oPainter:drawText( 0, 0, oBtRect:width(), oBtRect:height(), Qt_AlignCenter, cText )
   ENDIF
   
   HB_SYMBOL_UNUSED( oEvent )

   RETURN .T.


/*
   
   clicked event

*/
PROCEDURE udf_test()
   
   HbQtMsgBox( "button pressed", "button pressed" )

   RETURN

