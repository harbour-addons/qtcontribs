/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010-2014 Pritpal Bedi <bedipritpal@hotmail.com>
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
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                            Harbour-Qt IDE
 *
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                               05Oct2014
 */
/*----------------------------------------------------------------------*/

#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"
#include "hbtrace.ch"
#include "common.ch"


#define UNIT                                      0.1
#define HQR_BARCODE_3OF9                          1
#define TO_MMS( n )                               ( ( n ) * 10 / 25.4 )

#define HBQT_GRAPHICSITEM_SELECTED                1
#define HBQT_GRAPHICSITEM_DELETED                 2


CLASS HbQtVisualItem

   DATA   oWidget
   DATA   cType                                   INIT ""
   DATA   cName                                   INIT ""
   DATA   nX                                      INIT 0
   DATA   nY                                      INIT 0
   DATA   aPos                                    INIT {}
   DATA   aGeometry                               INIT {}
   DATA   cText                                   INIT ""
   DATA   qPen
   DATA   qBrush
   DATA   qGBrush
   DATA   qBgBrush
   DATA   qPixmap
   DATA   qFont
   DATA   xData
   DATA   qGeometry
   DATA   nBarcodeType                            INIT HQR_BARCODE_3OF9
   DATA   nTextFlags                              INIT Qt_AlignCenter
   DATA   nBorderWidth                            INIT 0
   DATA   nLineStyle                              INIT HBQT_GRAPHICSITEM_LINE_HORIZONTAL
   DATA   nBackgroundMode                         INIT Qt_TransparentMode
   DATA   nOpacity                                INIT 100
   DATA   nWidth                                  INIT 300
   DATA   nHeight                                 INIT 300
   DATA   nStartAngle                             INIT 30
   DATA   nSpanAngle                              INIT 120
   DATA   nLineType                               INIT HBQT_GRAPHICSITEM_LINE_HORIZONTAL
   DATA   nPointSize                              INIT 3.5

   METHOD init( cType, cName, aPos, aGeometry )
   METHOD create( cType, cName, aPos, aGeometry )
   METHOD execEvent( cEvent, p, p1, p2 )
   METHOD contextMenu( p1, p2 )
   METHOD update()
   METHOD destroy()

   ACCESS text()                                  INLINE ::setText()
   ACCESS textFlags()                             INLINE ::setTextFlags()
   ACCESS pen()                                   INLINE ::setPen()
   ACCESS brush()                                 INLINE ::setBrush()
   ACCESS backgroundBrush()                       INLINE ::setBackgroundBrush()
   ACCESS font()                                  INLINE ::setFont()
   ACCESS barcodeType()                           INLINE ::setBarcodeType()
   ACCESS gradient()                              INLINE ::setBrush()
   ACCESS pixmap()                                INLINE ::setPixmap()
   ACCESS borderWidth()                           INLINE ::setBorderWidth()
   ACCESS lineStyle()                             INLINE ::setLineStyle()
   ACCESS backgroundMode()                        INLINE ::setBackgroundMode()
   ACCESS opacity()                               INLINE ::setOpacity()
   ACCESS width()                                 INLINE ::setWidth()
   ACCESS height()                                INLINE ::setHeight()
   ACCESS geometry()                              INLINE ::setGeometry()
   ACCESS pos()                                   INLINE ::setPos()
   ACCESS lineType()                              INLINE ::setLineType()

   METHOD setText( ... )                          SETGET
   METHOD setPen( ... )                           SETGET
   METHOD setBrush( ... )                         SETGET
   METHOD setBackgroundBrush( ... )               SETGET
   METHOD setFont( ... )                          SETGET
   METHOD setGradient( ... )                      SETGET
   METHOD setPixmap( ... )                        SETGET
   METHOD setTextFlags( ... )                     SETGET
   METHOD setBarcodeType( ... )                   SETGET
   METHOD setBorderWidth( ... )                   SETGET
   METHOD setLineStyle( ... )                     SETGET
   METHOD setBackgroundMode( ... )                SETGET
   METHOD setOpacity( ... )                       SETGET
   METHOD setWidth( ... )                         SETGET
   METHOD setHeight( ... )                        SETGET
   METHOD setGeometry( ... )                      SETGET
   METHOD setPos( ... )                           SETGET
   METHOD setLineType( ... )                      SETGET

   METHOD drawOnPrinter( oPainter )
   METHOD draw( oPainter, oRectF, lDrawSelection )
   METHOD setupPainter( oPainter, lDrawSelection )
   METHOD drawBarcode( oPainter, oRectF )
   METHOD drawImage( oPainter, oRectF )
   METHOD drawChart( oPainter, oRect )
   METHOD drawText( oPainter, oRectF )
   METHOD drawField( oPainter, oRectF )
   METHOD drawGradient( oPainter, oRectF )
   METHOD drawLine( oPainter, oRect )
   METHOD drawRect( oPainter, oRectF )
   METHOD drawRoundRect( oPainter, oRectF )
   METHOD drawEllipse( oPainter, oRectF )
   METHOD drawPie( oPainter, oRectF )
   METHOD drawArc( oPainter, oRectF )
   METHOD drawChord( oPainter, oRectF )
   METHOD drawDiamond( oPainter, oRectF )
   METHOD drawTriangle( oPainter, oRectF )
   METHOD drawSelection( oPainter, oRect )

   DATA   bAction
   METHOD actionsBlock( bBlock )                  SETGET

   ERROR  HANDLER OnError( ... )
   ENDCLASS


METHOD HbQtVisualItem:init( cType, cName, aPos, aGeometry )

   HB_TRACE( HB_TR_DEBUG, "HbQtVisualItem:new" )

   DEFAULT cType     TO ::cType
   DEFAULT cName     TO ::cName
   DEFAULT aPos      TO ::aPos
   DEFAULT aGeometry TO ::aGeometry

   ::cType     := cType
   ::cName     := cName
   ::aPos      := aPos
   ::aGeometry := aGeometry

   RETURN Self


METHOD HbQtVisualItem:create( cType, cName, aPos, aGeometry )

   HB_TRACE( HB_TR_DEBUG, "HbQtVisualItem:new" )

   DEFAULT cType     TO ::cType
   DEFAULT cName     TO ::cName
   DEFAULT aPos      TO ::aPos
   DEFAULT aGeometry TO ::aGeometry

   ::cType     := cType
   ::cName     := cName
   ::aPos      := aPos
   ::aGeometry := aGeometry

   SWITCH cType
   CASE "Image"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_PICTURE )
      EXIT
   CASE "Chart"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_CHART )
      EXIT
   CASE "Gradient"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_RECT )
      EXIT
   CASE "Barcode"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_BARCODE )
      EXIT
   CASE "Text"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_SIMPLETEXT )
      EXIT
   CASE "Field"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_SIMPLETEXT )
      EXIT
   //
   CASE "Rectangle"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_RECT )
      EXIT
   CASE "RoundRect"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_ROUNDRECT )
      EXIT
   CASE "Ellipse"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_ELLIPSE )
      EXIT
   CASE "Arc"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_ARC )
      EXIT
   CASE "Chord"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_CHORD )
      EXIT
   CASE "LineH"
      ::nWidth := 300 ;  ::nHeight := 50
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_LINE )
      ::nLineType := HBQT_GRAPHICSITEM_LINE_HORIZONTAL
      EXIT
   CASE "LineV"
      ::nWidth := 50  ;  ::nHeight := 300
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_LINE )
      ::nLineType := HBQT_GRAPHICSITEM_LINE_VERTICAL
      EXIT
   CASE "LineDR"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_LINE )
      ::nLineType := HBQT_GRAPHICSITEM_LINE_BACKWARDDIAGONAL
      EXIT
   CASE "LineDL"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_LINE )
      ::nLineType := HBQT_GRAPHICSITEM_LINE_FORWARDDIAGONAL
      EXIT
   CASE "Diamond"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_ROUNDRECT )
      EXIT
   CASE "Triangle"
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_ROUNDRECT )
      EXIT
   OTHERWISE
      RETURN NIL
   ENDSWITCH

   ::oWidget:setObjectType( cType )
   ::oWidget:setObjectName( cName )
   ::oWidget:setTooltip( cName )

   ::oWidget:hbSetBlock( {|p,p1,p2| ::execEvent( "graphicsItem_block", p, p1, p2 ) } )

   IF Empty( ::aGeometry )
      ::aGeometry := { 0, 0, ::nWidth, ::nHeight }
   ENDIF
   ::setGeometry( ::aGeometry[ 1 ], ::aGeometry[ 2 ], ::aGeometry[ 3 ], ::aGeometry[ 4 ] )
   IF ! empty( ::aPos )
      ::setPos( ::aPos[ 1 ], ::aPos[ 2 ] )
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:destroy()
   ::oWidget:hbClearBlock()
   ::oWidget := NIL
   RETURN NIL


METHOD HbQtVisualItem:onError( ... )
   LOCAL cMsg := __GetMessage()
   IF SubStr( cMsg, 1, 1 ) == "_"
      cMsg := SubStr( cMsg, 2 )
   ENDIF
   RETURN ::oWidget:&cMsg( ... )


METHOD HbQtVisualItem:actionsBlock( bBlock )
   LOCAL bOldBlock := ::bAction
   IF HB_ISBLOCK( bBlock )
      ::bAction := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtVisualItem:execEvent( cEvent, p, p1, p2 )

   HB_TRACE( HB_TR_DEBUG, "HbQtVisualItem:execEvent", P, P1, P2 )

   DO CASE
   CASE cEvent == "graphicsItem_block"
      DO CASE
      CASE p == 21101
         IF HB_ISBLOCK( ::actionsBlock() )
            Eval( ::actionsBlock(), Self, HBQT_GRAPHICSITEM_SELECTED )
         ENDIF

      CASE p == 21017
         ::draw( p1, p2 )

      CASE p == QEvent_GraphicsSceneContextMenu
         ::contextMenu( p1, p2 )

      ENDCASE
   ENDCASE
   RETURN Self


METHOD HbQtVisualItem:contextMenu( p1, p2 )
   LOCAL oMenu, oAct

   HB_SYMBOL_UNUSED( p2 )

   WITH OBJECT oMenu := QMenu()
      :addAction( "Cut"  )
      :addSeparator()
      :addAction( "Copy" )

      IF ! empty( oAct := :exec( p1:screenPos() ) )
         SWITCH oAct:text()
         CASE "Cut"
            IF HB_ISBLOCK( ::actionsBlock() )
               Eval( ::actionsBlock(), Self, HBQT_GRAPHICSITEM_DELETED )
            ENDIF
            EXIT
         CASE "Copy"
            EXIT
         ENDSWITCH
      ENDIF
   ENDWITH
   HB_SYMBOL_UNUSED( oMenu )
   RETURN NIL


METHOD HbQtVisualItem:update()
   ::oWidget:update()
   RETURN Self


METHOD HbQtVisualItem:setText( ... )
   LOCAL a_:= hb_aParams()
   IF empty( a_ )
      RETURN ::cText
   ENDIF
   IF HB_ISSTRING( a_[ 1 ] )
      ::cText := a_[ 1 ]
      ::update()
   ENDIF
   RETURN ::cText


METHOD HbQtVisualItem:setTextFlags( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nTextFlags := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nTextFlags


METHOD HbQtVisualItem:setPen( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qPen )
         ::qPen := QPen( Qt_black )
         ::qPen:setStyle( Qt_SolidLine )
      ENDIF
      RETURN ::qPen
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qPen := a_[ 1 ]
      ELSE
         ::qPen := QPen( ... )
      ENDIF
      ::update()
   ENDSWITCH
   RETURN ::qPen


METHOD HbQtVisualItem:setBrush( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qBrush )
         ::qBrush := QBrush()
      ENDIF
      EXIT
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qBrush := a_[ 1 ]
      ELSE
         ::qBrush := QBrush( ... )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::qBrush


METHOD HbQtVisualItem:setBackgroundBrush( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qBgBrush )
         ::qBgBrush := QBrush()
      ENDIF
      EXIT
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qBgBrush := a_[ 1 ]
      ELSE
         ::qBgBrush := QBrush( ... )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::qBgBrush


METHOD HbQtVisualItem:setFont( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qFont )
         ::qFont := QFont( "Serif" )
         ::qFont:setPointSizeF( ::nPointSize )
         ::qFont:setStyleStrategy( QFont_PreferMatch )
         ::qFont:setStyleStrategy( QFont_ForceOutline )
      ENDIF
      EXIT
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qFont := a_[ 1 ]
      ELSE
         ::qFont := QFont( ... )
      ENDIF
      ::nPointSize := ::qFont:pointSize()
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::qFont


METHOD HbQtVisualItem:setBarcodeType( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nBarcodeType := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nBarcodeType


METHOD HbQtVisualItem:setGradient( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qGBrush )
         ::qGBrush := QBrush()
      ENDIF
      EXIT
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qGBrush := a_[ 1 ]
      ELSE
         ::qGBrush := QBrush( ... )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::qGBrush


METHOD HbQtVisualItem:setPixmap( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qPixmap )
         ::qPixmap := QPixmap()
      ENDIF
      EXIT
   OTHERWISE
      IF HB_ISOBJECT( a_[ 1 ] )
         ::qPixmap := a_[ 1 ]
      ELSE
         ::qPixmap := QPixmap( ... )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::qPixmap


METHOD HbQtVisualItem:setBorderWidth( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nBorderWidth := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nBorderWidth


METHOD HbQtVisualItem:setWidth( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      RETURN ::oWidget:width()
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nWidth := a_[ 1 ]
         ::oWidget:setWidth( ::nWidth )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nBorderWidth


METHOD HbQtVisualItem:setHeight( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      RETURN ::oWidget:height()
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nHeight := a_[ 1 ]
         ::oWidget:setHeight( ::nHeight )
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nBorderWidth


METHOD HbQtVisualItem:setGeometry( ... )
   LOCAL oRectF, qPos, a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      qPos := ::oWidget:pos()
      RETURN QRectF( qPos:x(), qPos:y(), ::width(), ::height() )
   CASE 1
      IF HB_ISOBJECT( a_[ 1 ] )
         oRectF := a_[ 1 ]
         ::oWidget:setPos( QPointF( oRectF:x(), oRectF:y() ) )
         ::oWidget:setWidth( oRectF:width() )
         ::oWidget:setHeight( oRectF:height() )
         ::update()
      ENDIF
      EXIT
   CASE 4
      ::oWidget:setPos( QPointF( a_[ 1 ], a_[ 2 ] ) )
      ::oWidget:setWidth( a_[ 3 ] )
      ::oWidget:setHeight( a_[ 4 ] )
      ::update()
      EXIT
   ENDSWITCH
   RETURN QRectF( 0, 0, ::nWidth, ::nHeight )


METHOD HbQtVisualItem:setPos( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      RETURN ::oWidget:pos()
   CASE 1
      IF HB_ISOBJECT( a_[ 1 ] )
         ::oWidget:setPos( a_[ 1 ] )
         ::update()
      ENDIF
      EXIT
   CASE 2
      ::oWidget:setPos( QPointF( a_[ 1 ], a_[ 2 ] ) )
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::oWidget:pos()


METHOD HbQtVisualItem:setLineStyle( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nLineStyle := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nLineStyle


METHOD HbQtVisualItem:setBackgroundMode( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nBackgroundMode := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nBackgroundMode


METHOD HbQtVisualItem:setOpacity( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nOpacity := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nOpacity


METHOD HbQtVisualItem:setLineType( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      EXIT
   OTHERWISE
      IF HB_ISNUMERIC( a_[ 1 ] )
         ::nLineType := a_[ 1 ]
      ENDIF
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::nLineType


METHOD HbQtVisualItem:setupPainter( oPainter, lDrawSelection )
   LOCAL qFont := ::font()

   qFont:setPixelSize( iif( lDrawSelection, ::nPointSize / UNIT, TO_MMS( ::nPointSize / UNIT ) ) )
   WITH OBJECT oPainter
      :setPen( ::pen() )
      :setBrush( ::brush() )
      :setFont( qFont )
      :setBackgroundMode( ::backgroundMode() )
      :setBackground( ::backgroundBrush() )
      :setOpacity( ::opacity() / 100.0 )
      :setRenderHint( QPainter_TextAntialiasing )
   ENDWITH
   RETURN Self


METHOD HbQtVisualItem:drawSelection( oPainter, oRect )
   LOCAL a, p, lt, rt, lb, rb
   LOCAL drawSelectionBorder := .t.
   LOCAL iResizeHandle := 2 / UNIT
   LOCAL nW, nH

   oPainter:save()

   nW := oRect:width() ; nH := oRect:height()

   IF ::oWidget:isSelected()
      a := QBrush()
      a:setColor( QColor( 255,0,0 ) )
      a:setStyle( Qt_SolidPattern )
      IF drawSelectionBorder
         p := QPen()
         p:setStyle( Qt_DashLine )
         p:setBrush( a )
         oPainter:setPen( p )
         oPainter:drawRect( oRect )
      ENDIF
      lt := QPainterPath()
      lt:moveTo( 0,0 )
      lt:lineTo( 0, iResizeHandle )
      lt:lineTo( iResizeHandle, 0 )
      oPainter:fillPath( lt, a )

      rt := QPainterPath()
      rt:moveTo( nW,0 )
      rt:lineTo( nW, iResizeHandle )
      rt:lineTo( nW-iResizeHandle, 0 )
      oPainter:fillPath( rt,a )

      lb := QPainterPath()
      lb:moveTo( 0, nH )
      lb:lineTo( 0, nH - iResizeHandle )
      lb:lineTo( iResizeHandle, nH )
      oPainter:fillPath( lb,a )

      rb := QPainterPath()
      rb:moveTo( nW, nH )
      rb:lineTo( nW, nH - iResizeHandle )
      rb:lineTo( nW-iResizeHandle, nH )
      oPainter:fillPath( rb,a )
   ELSE
      IF drawSelectionBorder
         a := QBrush()
         a:setColor( QColor( 100,100,100,200 ) )
         a:setStyle( Qt_SolidPattern )

         p := QPen()
         p:setStyle( Qt_DashDotDotLine )
         p:setBrush( a )
         oPainter:setPen( p )
         oPainter:drawRect( oRect )
      ELSE
         WITH OBJECT oPainter
            :setPen( "QColor", QColor( 0, 0, 0, 100 ) )
            :drawLine( 0 , 0 , 0                 , 2*iResizeHandle    )
            :drawLine( 0 , 0 , 2*iResizeHandle   , 0                  )
            :drawLine( nW, 0 , nW-2*iResizeHandle, 0                  )
            :drawLine( nW, 0 , nW                , 2*iResizeHandle    )
            :drawLine( nW, nH, nW-2*iResizeHandle, nH                 )
            :drawLine( nW, nH, nW                , nH-2*iResizeHandle )
            :drawLine( 0 , nH, 2*iResizeHandle   , nH                 )
            :drawLine( 0 , nH, 0                 , nH-2*iResizeHandle )
         ENDWITH
      ENDIF
   ENDIF
   oPainter:restore()
   RETURN Self


METHOD HbQtVisualItem:drawOnPrinter( oPainter )
   LOCAL oRectF, oTrans

   oRectF := ::oWidget:geometry()
   oRectF := QRectF( TO_MMS( oRectF:x() ), TO_MMS( oRectF:y() ), TO_MMS( oRectF:width() ), TO_MMS( oRectF:height() ) )

   oTrans := ::oWidget:transform()
   oTrans:translate( 0,0 )
   oPainter:resetMatrix()
   oPainter:setWorldTransform( oTrans )

   ::draw( oPainter, oRectF, .F. )
   RETURN Self


METHOD HbQtVisualItem:draw( oPainter, oRectF, lDrawSelection )

   DEFAULT lDrawSelection TO .t.

   ::setupPainter( oPainter, lDrawSelection )

   SWITCH ::cType
   CASE "Barcode"    ;   ::drawBarcode( oPainter, oRectF )      ;    EXIT
   CASE "Image"      ;   ::drawImage( oPainter, oRectF )        ;    EXIT
   CASE "Chart"      ;   ::drawChart( oPainter, oRectF )        ;    EXIT
   CASE "Gradient"   ;   ::drawGradient( oPainter, oRectF )     ;    EXIT
   CASE "Text"       ;   ::drawText( oPainter, oRectF )         ;    EXIT
   CASE "Field"      ;   ::drawField( oPainter, oRectF )        ;    EXIT
   CASE "Rectangle"  ;   ::drawRect( oPainter, oRectF )         ;    EXIT
   CASE "RoundRect"  ;   ::drawRoundRect( oPainter, oRectF )    ;    EXIT
   CASE "Ellipse"    ;   ::drawEllipse( oPainter, oRectF )      ;    EXIT
   CASE "LineH"      ;   ::drawLine( oPainter, oRectF )         ;    EXIT
   CASE "LineV"      ;   ::drawLine( oPainter, oRectF )         ;    EXIT
   CASE "LineDR"     ;   ::drawLine( oPainter, oRectF )         ;    EXIT
   CASE "LineDL"     ;   ::drawLine( oPainter, oRectF )         ;    EXIT
   CASE "Arc"        ;   ::drawArc( oPainter, oRectF )          ;    EXIT
   CASE "Chord"      ;   ::drawChord( oPainter, oRectF )        ;    EXIT
   CASE "Diamond"    ;   ::drawDiamond( oPainter, oRectF )      ;    EXIT
   CASE "Triangle"   ;   ::drawTriangle( oPainter, oRectF )     ;    EXIT
   ENDSWITCH

   IF lDrawSelection
      ::drawSelection( oPainter, oRectF )
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:drawRect( oPainter, oRectF )
   oPainter:drawRect( oRectF )
   RETURN Self


METHOD HbQtVisualItem:drawRoundRect( oPainter, oRectF )
   oPainter:drawRoundedRect( oRectF, 10/UNIT, 10/UNIT )
   RETURN Self


METHOD HbQtVisualItem:drawEllipse( oPainter, oRectF )
   oPainter:drawEllipse( oRectF )
   RETURN Self


METHOD HbQtVisualItem:drawLine( oPainter, oRect )

   SWITCH ::lineType()
   CASE HBQT_GRAPHICSITEM_LINE_VERTICAL
      oPainter:drawLine( oRect:x() + oRect:width() / 2, oRect:y(), oRect:x() +  oRect:width() / 2, oRect:y() + oRect:height() )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_HORIZONTAL
      oPainter:drawLine( oRect:x(), oRect:y() + oRect:height() / 2, oRect:x() + oRect:width(), oRect:y() + oRect:height() / 2 )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_BACKWARDDIAGONAL
      oPainter:drawLine( oRect:right(), oRect:y(), oRect:x(), oRect:bottom() )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_FORWARDDIAGONAL
      oPainter:drawLine( QPointF( oRect:x(), oRect:y() ), QPointF( oRect:right(), oRect:bottom() ) )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtVisualItem:drawPie( oPainter, oRectF )
   oPainter:drawPie( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItem:drawDiamond( oPainter, oRectF )
   LOCAL p := QPainterPath()
   LOCAL x := oRectF:x(), y := oRectF:y(), w := oRectF:width(), h := oRectF:height()

   p:moveTo( x, y + h / 2 )
   p:lineTo( x + w / 2, y )
   p:lineTo( x + w, y + h / 2 )
   p:lineTo( x + w / 2, y + h )
   p:lineTo( x, y + h / 2 )

   oPainter:drawPath( p )
   RETURN Self


METHOD HbQtVisualItem:drawTriangle( oPainter, oRectF )
   LOCAL p := QPainterPath()

   p:moveTo( oRectF:x(), oRectF:y() + oRectF:height() )
   p:lineTo( oRectF:x() + oRectF:width() / 2, oRectF:y() )
   p:lineTo( oRectF:x() + oRectF:width(), oRectF:y() + oRectF:height() )
   p:lineTo( oRectF:x(), oRectF:y() + oRectF:height() )

   oPainter:drawPath( p )
   RETURN Self


METHOD HbQtVisualItem:drawArc( oPainter, oRectF )
   oPainter:drawArc( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItem:drawChord( oPainter, oRectF )
   oPainter:drawChord( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItem:drawText( oPainter, oRectF )
   oPainter:drawText( oRectF, ::textFlags(), ::text() )
   RETURN Self


METHOD HbQtVisualItem:drawField( oPainter, oRectF )
   oPainter:drawText( oRectF, ::textFlags(), ::text() )
   RETURN Self


METHOD HbQtVisualItem:drawGradient( oPainter, oRectF )
   oPainter:drawRect( oRectF )
   RETURN Self


METHOD HbQtVisualItem:drawBarcode( oPainter, oRectF )
   LOCAL rc, w, x, i, cCode

   rc    := oRectF:adjusted( 5, 5, -10, -10 )
   cCode := fetchBarString( ::text() )
   w     := rc:width() / Len( cCode )
   x     := 0.0

   FOR i := 1 TO Len( cCode )
      IF substr( cCode, i, 1 ) == "1"
         oPainter:fillRect( QRectF( rc:x() + x, rc:y(), w, rc:height() ), QColor( Qt_black ) )
      ELSE
         oPainter:fillRect( QRectF( rc:x() + x, rc:y(), w, rc:height() ), QColor( Qt_white ) )
      ENDIF
      x += w
   NEXT
   RETURN Self


METHOD HbQtVisualItem:drawImage( oPainter, oRectF )
   LOCAL qPix, image, rc, img, point
   LOCAL drawTextType := HBQT_GRAPHICSITEM_TEXT_DRAW_ABOVE
   LOCAL paintType    := HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_KEEP_ASPECT_RATIO
   LOCAL borderWidth  := 0
   LOCAL borderColor  := 0, pen, textH, sw, sh, cx, cy, cw, ch, textColor := 0
   LOCAL cText        := "Picture"
   LOCAL qObj         := ::oWidget

   rc    := oRectF:adjusted( 1, 1, -2, -2 )

   textH := 0
   sw    := 0
   sh    := 0

   IF drawTextType == HBQT_GRAPHICSITEM_TEXT_DRAW_ABOVE .OR. ::drawTextType == HBQT_GRAPHICSITEM_TEXT_DRAW_BELOW
      textH := oPainter:font():pixelSize()
   ENDIF

   qPix  := ::pixmap()
   image := qPix:toImage()

   IF image:isNull()
      oPainter:drawRect( oRectF )
   ELSE
      img   := QImage( 0, 0 )
      point := oRectF:topLeft()
      cx    := 0; cy := 0; cw := qPix:width(); ch := qPix:height()

      SWITCH paintType
      CASE HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_KEEP_ASPECT_RATIO
         img := QImage( image:scaled( rc:width(), rc:height() - textH, Qt_KeepAspectRatio, Qt_SmoothTransformation ) )
         EXIT
      CASE HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_IGNORE_ASPECT_RATIO
         img := QImage( image:scaled( rc:width(), rc:height() - textH, Qt_IgnoreAspectRatio, Qt_SmoothTransformation ) )
         EXIT
      CASE HBQT_GRAPHICSITEM_CENTER_PICTURE_TO_ITEM
         point:setX( point:x() + ( rc:width() - image:width() ) / 2 )
         point:setY( point:y() + ( rc:height() - image:height() - textH ) / 2 )
         IF point:x() < 0
            cx := abs( point:x() )
            cw -= 2 * cx
            point:setX( 0 )
         ENDIF
         IF point:y() < 0
            cy := abs( point:y() )
            ch -= 2 * cy
            point:setY( 0 )
         ENDIF
         img := QImage( image:copy( cx, cy, cw, ch ) )
         EXIT
      CASE HBQT_GRAPHICSITEM_RESIZE_ITEM_TO_PICTURE
         img := image
         sw := img:width() - qObj:width()
         sh := img:height() - ( qObj:height() - textH )
         EXIT
      ENDSWITCH

      IF drawTextType == HBQT_GRAPHICSITEM_TEXT_DRAW_ABOVE
         point:setY( point:y() + textH )
      ENDIF

      oPainter:drawImage( point, img )
   ENDIF
   oPainter:setPen( QPen( textColor ) )

   SWITCH drawTextType
   CASE HBQT_GRAPHICSITEM_TEXT_DRAW_TOP
      oPainter:drawText( rc, Qt_AlignTop + Qt_AlignHCenter, cText )
      EXIT
   CASE HBQT_GRAPHICSITEM_TEXT_DRAW_BOTTOM
      oPainter:drawText( rc, Qt_AlignBottom + Qt_AlignHCenter, cText )
      EXIT
   CASE HBQT_GRAPHICSITEM_TEXT_DRAW_ABOVE
      oPainter:drawText( rc, Qt_AlignTop + Qt_AlignHCenter, cText )
      EXIT
   CASE HBQT_GRAPHICSITEM_TEXT_DRAW_BELOW
      oPainter:drawText( rc, Qt_AlignBottom + Qt_AlignHCenter, cText )
      EXIT
   ENDSWITCH

   IF !empty( sw ) .OR. !empty( sh )
      qObj:setWidth( qObj:width() + sw )
      qObj:setHeight( qObj:height() + sh )
   ENDIF

   IF borderWidth > 0
      pen := QPen()
      pen:setWidth( borderWidth )
      pen:setColor( borderColor )
      pen:setJoinStyle( Qt_MiterJoin )
      oPainter:setPen( pen )
      oPainter:setBrush( QBrush( Qt_NoBrush ) )
      oPainter:drawRect( rc:x() + borderWidth / 2, rc:y() + borderWidth / 2, ;
                         rc:width() - borderWidth, rc:height() - borderWidth )
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:drawChart( oPainter, oRect )
   LOCAL qFMetrix, maxpv, minnv, absMaxVal, powVal, chartStep, powStep, maxHeight, valstep, maxLabelWidth
   LOCAL pw, rc, maxval, y, i, x, cv, barWidth, lg, py, f, cMaxVal, nDec, nFHeight, nLabelWidth, br, nPlanes
   LOCAL m_drawBorder      := .t.
   LOCAL m_showLabels      := .t.
   LOCAL m_showGrid        := .t.
   LOCAL m_barsIdentation  := 1.0 / UNIT
   LOCAL nColorFactor      := 1.7

   qFMetrix := oPainter:fontMetrics()
   nFHeight := qFMetrix:height()

   IF empty( ::xData )
      ::xData := {}

      aadd( ::xData, { "Bananas", 040.0, rmgr_generateNextColor() } )
      aadd( ::xData, { "Oranges", 150.0, rmgr_generateNextColor() } )
      aadd( ::xData, { "Mangoes", 095.0, rmgr_generateNextColor() } )
   ENDIF

   maxpv     := 0
   minnv     := 0
   aeval( ::xData, {|e_| iif( e_[ 2 ] < 0, minnv := min( minnv, e_[ 2 ] ), NIL ), iif( e_[ 2 ] > 0, maxpv := max( maxpv, e_[ 2 ] ), NIL ) } )

   absMaxVal := maxpv - minnv
   cMaxVal   := hb_ntos( absMaxVal )
   nDec      := at( ".", cMaxVal )

   powVal    := iif( absMaxVal < 1,  10.0 ^ ( Len( substr( cMaxVal, nDec+1 ) ) + 1 ), 1 )
   maxpv     *= powVal
   minnv     *= powVal

   maxpv     := maxpv
   minnv     := -minnv
   minnv     := -minnv

   oPainter:fillRect( oRect, ::brush() )

   IF m_drawBorder
      oPainter:drawRect( oRect )
   ENDIF

   pw := iif( abs( ::pen():widthF() ) > 0, abs( ::pen():widthF() ), 1 )
   rc := oRect:adjusted( pw / 2, pw / 2, -pw, -pw )

   f  := 2
   chartStep := ( 10.0 ^ ( Len( substr( cMaxVal, 1, nDec - 1 ) ) - 1 ) ) / f
   powStep   := iif( chartStep < 1, 10, 1 )
   chartStep *= powStep
   maxpv     *= powStep
   minnv     *= powStep
   powVal    *= powStep
   maxpv     := maxpv + ( iif( (   maxpv % chartStep ) != 0, ( chartStep - (   maxpv % chartStep ) ), 0 ) ) / powVal
   minnv     := minnv - ( iif( ( - minnv % chartStep ) != 0, ( chartStep - ( - minnv % chartStep ) ), 0 ) ) / powVal
   maxVal    := maxpv - minnv

   maxHeight := rc:height() - nFHeight
   valstep := maxHeight / ( maxVal / chartStep )

   IF ( valstep < nFHeight )
      chartStep *= ( ( ( nFHeight / valstep ) ) + 1 )
      valstep := ( ( ( nFHeight / valstep ) ) + 1 ) * valstep
   ENDIF

   nPlanes := maxVal / chartStep + 1 + iif( maxVal % chartStep != 0, 1, 0 )

   IF m_showLabels
      maxLabelWidth := 0
      FOR i := 1 TO nPlanes
         nLabelWidth := qFMetrix:width( hb_ntos( Int( ( maxVal * i - chartStep * i ) / powVal ) ) )
         IF maxLabelWidth < nLabelWidth
            maxLabelWidth := nLabelWidth
         ENDIF
      NEXT
      y := 0
      FOR i := 1 TO nPlanes
         oPainter:drawText( QRectF( rc:x(), rc:y() + y, maxLabelWidth, nFHeight ), ;
                         Qt_AlignRight + Qt_AlignVCenter, hb_ntos( Int( ( maxpv - chartStep * ( i - 1 ) ) / powVal ) ) )
         y += valstep
      NEXT

      oPainter:drawLine( rc:x() + maxLabelWidth + 1 / UNIT / 4, rc:y(), rc:x() + maxLabelWidth + 1 / UNIT / 4, rc:y() + oRect:height() )
      rc := rc:adjusted( maxLabelWidth + 1 / UNIT / 4, 0, 0, 0 )
   ENDIF

   IF m_showGrid
      y :=  nFHeight / 2
      FOR i := 1 TO nPlanes
         oPainter:drawLine( rc:x(), rc:y() + y, rc:x() + rc:width(), rc:y() + y )
         y += valstep
      NEXT
   ENDIF

   rc := rc:adjusted( 0,  nFHeight / 2, 0, 0 )
   x  := m_barsIdentation
   barWidth := ( rc:width() - m_barsIdentation * ( Len( ::xData ) + 1 ) ) / len( ::xData )
   py := maxHeight / maxVal

   FOR EACH cv IN ::xData
      lg := QLinearGradient( QPointF( x + barWidth / 2, 0.0 ), QPointF( x + barWidth, 0.0 ) )
      //
      lg:setSpread( QGradient_ReflectSpread )
      lg:setColorAt( 0, cv[ 3 ] )
      lg:setColorAt( 1, QColor( cv[ 3 ]:red() * nColorFactor, cv[ 3 ]:green() * nColorFactor, cv[ 3 ]:blue() * nColorFactor, cv[ 3 ]:alpha() ) )
      //
      br := QBrush( lg )
      //
      oPainter:fillRect( QRectF( rc:x() + x, rc:y() + py * maxpv - py * cv[ 2 ] * powVal, barWidth, py * cv[ 2 ] * powVal ), br )

      IF m_showLabels
         oPainter:drawText( QRectF( rc:x() + x - m_barsIdentation / 2, rc:y() + py * maxpv - iif( cv[ 2 ] >= 0, nFHeight, 0 ), ;
                                      barWidth + m_barsIdentation, nFHeight ), Qt_AlignCenter, hb_ntos( Int( cv[ 2 ] ) ) )
      ENDIF
      x += barWidth + m_barsIdentation
   NEXT

#if 0  /* Legend */
   oPainter:fillRect( oRect, ::brush() )
   oPainter:drawRect( oRect )
   oPainter:translate( oRect:topLeft() )
   qreal y := 1 / UNIT
   qreal vstep := ( oRect:height() - y - 1 / UNIT * val:size() ) / Len( ::aData )
   FOR EACH cv IN ::aData
   {
      oPainter:fillRect( QRectF( 1 / UNIT / 2, y, m_legendColoroRectWidth, vstep ), QBrush( cv[ 3 ] ) )
      oPainter:drawText( QRectF( 1 / UNIT + m_legendColoroRectWidth, y, oRect:width() - ( 1 / UNIT + m_legendColoroRectWidth ), vstep ),
                                                                            Qt_AlignVCenter + Qt_AlignLeft, cv[ 1 ] )
      y += vstep + 1 / UNIT
   }
#endif
   RETURN Self


/*   NOTE: the code below is works of someone else I do not remmeber    */
/*         the name. Please let me know who that is so due credits be   */
/*         given to him. I had downloaded this code many years back     */
/*         and adopted to Vouch32 library and Vouch32 Active-X Server.  */

STATIC FUNCTION fetchBarString( cCode, lCheck, nType )
   STATIC cCars   := '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%'
   STATIC aBarras := {  '1110100010101110',;  // 1
                        '1011100010101110',;  // 2
                        '1110111000101010',;  // 3
                        '1010001110101110',;  // 4
                        '1110100011101010',;  // 5
                        '1011100011101010',;  // 6
                        '1010001011101110',;  // 7
                        '1110100010111010',;  // 8
                        '1011100010111010',;  // 9
                        '1010001110111010',;  // 0
                        '1110101000101110',;  // A
                        '1011101000101110',;  // B
                        '1110111010001010',;  // C
                        '1010111000101110',;  // D
                        '1110101110001010',;  // E
                        '1011101110001010',;
                        '1010100011101110',;
                        '1110101000111010',;
                        '1011101000111010',;
                        '1010111000111010',;
                        '1110101010001110',;  // K
                        '1011101010001110',;
                        '1110111010100010',;
                        '1010111010001110',;
                        '1110101110100010',;
                        '1011101110100010',;  // p
                        '1010101110001110',;
                        '1110101011100010',;
                        '1011101011100010',;
                        '1010111011100010',;
                        '1110001010101110',;
                        '1000111010101110',;
                        '1110001110101010',;
                        '1000101110101110',;
                        '1110001011101010',;
                        '1000111011101010',;  // Z
                        '1000101011101110',;  // -
                        '1110001010111010',;  // .
                        '1000111010111010',;  // ' '
                        '1000101110111010',;  // *
                        '1000100010100010',;
                        '1000100010100010',;
                        '1000101000100010',;
                        '1010001000100010' }

   LOCAL cCar, m, n, cBarra := '',  nCheck := 0

   DEFAULT lCheck TO .f.
   DEFAULT nType  TO HQR_BARCODE_3OF9

   DO CASE
   CASE nType == HQR_BARCODE_3OF9
      cCode := upper( cCode )
      IF Len( cCode ) > 32
         cCode := left( cCode,32 )
      ENDIF

      cCode := '*' + cCode + '*'
      FOR n := 1 TO Len( cCode )
         cCar := substr( cCode,n,1 )
         m    := at( cCar, cCars )
         IF m > 0
            cBarra := cBarra + aBarras[ m ]
            nCheck += ( m-1 )
         ENDIF
      NEXT

      IF lCheck
         cBarra += aBarras[ nCheck % 43 + 1 ]
      ENDIF
   ENDCASE

   RETURN cBarra


STATIC FUNCTION rmgr_generateNextColor()
   RETURN QColor( hb_random( 0,255 ), hb_random( 0,255 ), hb_random( 0,255 ), 255 )


/*
STATIC FUNCTION rmgr_xtos( x )
   SWITCH valtype( x )
   CASE "C" ; RETURN x
   CASE "D" ; RETURN dtos( x )
   CASE "L" ; RETURN iif( x, "YES", "NO" )
   CASE "N" ; RETURN hb_ntos( x )
   ENDSWITCH
   RETURN ""


STATIC FUNCTION rmgr_array2String( aArray )
   LOCAL a_, x
   LOCAL s := ""
   FOR EACH a_ IN aArray
      FOR EACH x IN a_
         s += rmgr_xtos( x ) + " "
      NEXT
      s := trim( s ) + ","
   NEXT
   RETURN s
*/

