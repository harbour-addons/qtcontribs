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
#define HBQT_GRAPHICSITEM_GEOMETRYCHANGED         3


//#xTranslate HBQGraphicsItem( <x> )          =>    HBQGraphicsObject( <x> )



CLASS HbQtVisualItem

   DATA   oWidget
   DATA   cType                                   INIT ""
   DATA   cName                                   INIT ""

   DATA   qPen
   DATA   nPenWidth                               INIT 1
   DATA   cPenColor                               INIT "#000000"
   DATA   cPenStyle                               INIT "SolidLine"
   DATA   cCapStyle                               INIT "FlatCap"
   DATA   cJoinStyle                              INIT "BevelJoin"
   DATA   nMiterLimit                             INIT 0
   METHOD setPenProperties( cProperty, xValue )

   DATA   qBrush
   DATA   cBrushStyle                             INIT "NoBrush"
   DATA   cBrushColor                             INIT "#ffffff"
   DATA   cBrushTexture                           INIT ""
   METHOD setBrushProperties( cProperty, xValue )

   DATA   qBgBrush
   DATA   cBBrushStyle                            INIT "NoBrush"
   DATA   cBBrushColor                            INIT "#ffffff"
   DATA   cBBrushTexture                          INIT ""
   METHOD setBBrushProperties( cProperty, xValue )

   DATA   nPointSize                              INIT 3.5
   DATA   cFontFamily                             INIT "Arial"
   DATA   cFontStyle                              INIT "Normal"
   DATA   cFontSize                               INIT "3.5"
   METHOD setFontProperties( cProperty, xValue )

   DATA   cBackgroundMode                         INIT "TransparentMode"
   DATA   nOpacity                                INIT 100

   DATA   nX                                      INIT 0
   DATA   nY                                      INIT 0
   DATA   aPos                                    INIT {}
   DATA   aGeometry                               INIT {}
   DATA   cText                                   INIT ""

   DATA   qGBrush
   DATA   qPixmap
   DATA   qFont
   DATA   qGeometry
   DATA   nBarcodeType                            INIT HQR_BARCODE_3OF9
   DATA   nTextFlags                              INIT Qt_AlignCenter
   DATA   nWidth                                  INIT 100
   DATA   nHeight                                 INIT 100
   DATA   nStartAngle                             INIT 30
   DATA   nSpanAngle                              INIT 120
   DATA   xData

   DATA   nBorderWidth                            INIT 0
   DATA   nLineType                               INIT HBQT_GRAPHICSITEM_LINE_HORIZONTAL
   DATA   nLineStyle                              INIT HBQT_GRAPHICSITEM_LINE_HORIZONTAL

   DATA   lLocked                                 INIT .F.
   ACCESS isLocked()                              INLINE ::lLocked
   DATA   oDraw

   METHOD init( cType, cName, aPos, aGeometry, nWidth, nHeight )
   METHOD create( cType, cName, aPos, aGeometry, nWidth, nHeight )
   METHOD update()
   METHOD destroy()
   ACCESS name()                                  INLINE ::cName
   ACCESS type()                                  INLINE ::cType
   ACCESS defWidth()                              INLINE ::nWidth
   ACCESS defHeight()                             INLINE ::nHeight

   METHOD execEvent( cEvent, p, p1, p2 )
   METHOD contextMenu( p1, p2 )
   METHOD rotate( nAngle )                        INLINE ::oWidget:setRotation( ::oWidget:rotation() + nAngle )

   DATA   oState
   METHOD setState( oState )                      INLINE ::oState := oState, ::update()
   ACCESS state()                                 INLINE ::oState

   METHOD select()                                INLINE ::oWidget:setSelected( .T. ), ::update()
   METHOD unSelect()                              INLINE ::oWidget:setSelected( .F. ), ::update()
   METHOD toggleLock()

   ACCESS text()                                  INLINE ::setText()

   ACCESS textFlags()                             INLINE ::setTextFlags()
   ACCESS pen()                                   INLINE ::setPen()
   ACCESS brush()                                 INLINE ::setBrush()
   ACCESS backgroundBrush()                       INLINE ::setBackgroundBrush()
   ACCESS font()                                  INLINE ::setFont()
   ACCESS borderWidth()                           INLINE ::setBorderWidth()
   ACCESS gradient()                              INLINE ::setBrush()
   ACCESS pixmap()                                INLINE ::setPixmap()
   ACCESS lineStyle()                             INLINE ::setLineStyle()
   ACCESS backgroundMode()                        INLINE ::setBackgroundMode()
   ACCESS opacity()                               INLINE ::setOpacity()
   ACCESS width()                                 INLINE ::setWidth()
   ACCESS height()                                INLINE ::setHeight()
   ACCESS geometry()                              INLINE ::setGeometry()
   ACCESS pos()                                   INLINE ::setPos()
   ACCESS lineType()                              INLINE ::setLineType()
   ACCESS barcodeType()                           INLINE ::setBarcodeType()

   METHOD setText( ... )                          SETGET
   METHOD setPen( ... )                           SETGET
   METHOD setBrush( ... )                         SETGET
   METHOD setBackgroundBrush( ... )               SETGET
   METHOD setFont( ... )                          SETGET
   METHOD setGradient( ... )                      SETGET
   METHOD setPixmap( ... )                        SETGET
   METHOD setTextFlags( ... )                     SETGET
   METHOD setBorderWidth( ... )                   SETGET
   METHOD setLineStyle( ... )                     SETGET
   METHOD setBackgroundMode( ... )                SETGET
   METHOD setOpacity( ... )                       SETGET
   METHOD setWidth( ... )                         SETGET
   METHOD setHeight( ... )                        SETGET
   METHOD setGeometry( ... )                      SETGET
   METHOD setPos( ... )                           SETGET
   METHOD setLineType( ... )                      SETGET
   METHOD setBarcodeType( ... )                   SETGET

   METHOD drawOnPrinter( oPainter )
   METHOD setupPainter( oPainter, lDrawSelection )
   METHOD draw( oPainter, oRectF, lDrawSelection )
   METHOD drawChart( oPainter, oRect )
   METHOD drawText( oPainter, oRectF, lDrawSelection )
   METHOD drawField( oPainter, oRectF )
   METHOD drawGradient( oPainter, oRectF )

   METHOD drawSelection( oPainter, oRect )

   DATA   bAction
   METHOD actionsBlock( bBlock )                  SETGET

   METHOD getProperties()

   DATA   hData                                   INIT __hbqtStandardHash()
   METHOD setData( hData )
   METHOD setDataValue( cField, xValue )
   METHOD setDataValues( xData )
   METHOD getData()
   METHOD getDataEx()

   ERROR  HANDLER OnError( ... )
   ENDCLASS


METHOD HbQtVisualItem:init( cType, cName, aPos, aGeometry, nWidth, nHeight )

   HB_TRACE( HB_TR_DEBUG, "HbQtVisualItem:new" )

   DEFAULT cType     TO ::cType
   DEFAULT cName     TO ::cName
   DEFAULT aPos      TO ::aPos
   DEFAULT aGeometry TO ::aGeometry
   DEFAULT nWidth    TO ::nWidth
   DEFAULT nHeight   TO ::nHeight

   ::cType     := cType
   ::cName     := cName
   ::aPos      := aPos
   ::aGeometry := aGeometry
   ::nWidth    := nWidth
   ::nHeight   := nHeight

   ::oDraw := HbQtVisualItemDraw():new()
   RETURN Self


METHOD HbQtVisualItem:create( cType, cName, aPos, aGeometry, nWidth, nHeight )

   HB_TRACE( HB_TR_DEBUG, "HbQtVisualItem:new" )

   DEFAULT cType     TO ::cType
   DEFAULT cName     TO ::cName
   DEFAULT aPos      TO ::aPos
   DEFAULT aGeometry TO ::aGeometry
   DEFAULT nWidth    TO ::nWidth
   DEFAULT nHeight   TO ::nHeight

   ::cType     := cType
   ::cName     := cName
   ::aPos      := aPos
   ::aGeometry := aGeometry
   ::nWidth    := nWidth
   ::nHeight   := nHeight

   SWITCH cType
   CASE "Marker"
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
   CASE "RoundedRect"
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
      ::oWidget := HBQGraphicsItem( HBQT_GRAPHICSITEM_LINE )
      ::nLineType := HBQT_GRAPHICSITEM_LINE_HORIZONTAL
      EXIT
   CASE "LineV"
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
      SWITCH p
      CASE 22101                                  // right-click context menu
         ::contextMenu( p1:screenPos():x(), p1:screenPos():y() )
         ::select()
         EXIT
      CASE 22102                                  // left-click item selected
         IF HB_ISBLOCK( ::actionsBlock() )
            Eval( ::actionsBlock(), Self, HBQT_GRAPHICSITEM_SELECTED )
         ENDIF
         EXIT
      CASE 22103                                  // geometry changed
         IF HB_ISBLOCK( ::actionsBlock() )
            Eval( ::actionsBlock(), Self, HBQT_GRAPHICSITEM_GEOMETRYCHANGED )
         ENDIF
         EXIT
      CASE 22104
         ::draw( p1, p2 )
         EXIT
      ENDSWITCH
   ENDCASE
   RETURN Self


METHOD HbQtVisualItem:contextMenu( p1, p2 )
#if 0
   LOCAL oMenu, oAct

   WITH OBJECT oMenu := QMenu()
      :addAction( iif( ::lLocked, "Unlock", "Lock" ) )
      :addSeparator()
      IF ! ::lLocked
         :addAction( "Delete" )
         :addSeparator()
      ENDIF
      IF ! empty( oAct := :exec( QPoint( p1, p2 ) ) )
         SWITCH oAct:text()
         CASE "Delete"
            IF HB_ISBLOCK( ::actionsBlock() )
               Eval( ::actionsBlock(), Self, HBQT_GRAPHICSITEM_DELETED )
            ENDIF
            EXIT
         CASE "Lock"
         CASE "Unlock"
            ::toggleLock()
            EXIT
         ENDSWITCH
      ENDIF
      __hbqt_Delete( oMenu )
   ENDWITH
#endif
   HB_SYMBOL_UNUSED( p1 + p2 )
   RETURN NIL


METHOD HbQtVisualItem:toggleLock()
   ::lLocked := ! ::lLocked
   ::oWidget:hbSetLocked( ::lLocked )
   RETURN Self


METHOD HbQtVisualItem:update()
   ::oWidget:update()
   RETURN Self


METHOD HbQtVisualItem:getDataEx()
   RETURN ::hData


METHOD HbQtVisualItem:getData()
   LOCAL hTmp
   LOCAL hData := __hbqtStandardHash()

   FOR EACH hTmp IN ::hData
      hData[ hTmp:__enumKey() ] := hTmp[ "Value" ]
   NEXT
   RETURN hData


METHOD HbQtVisualItem:setData( hData )
   IF HB_ISHASH( hData )
      ::hData := hb_HClone( hData )
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:setDataValue( cField, xValue )

   IF ! Empty( cField ) .AND. hb_HHasKey( ::hData, cField )
//Alert( {cField,xValue} )
      ::hData[ cField ][ "Value" ] := xValue
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:setDataValues( xData )
   LOCAL xTmp

   IF HB_ISARRAY( xData )
      FOR EACH xTmp IN xData
         IF hb_HHasKey( ::hData, xTmp[ 1 ] )
            ::hData[ xTmp[ 1 ] ][ "Value" ] := xTmp[ 2 ]
         ENDIF
      NEXT
   ELSEIF HB_ISHASH( xData )
      FOR EACH xTmp IN xData
         IF hb_HHasKey( xTmp, "Field" ) .AND. hb_HHasKey( xTmp, "Value" )
            ::hData[ xTmp[ "Field" ] ][ "Value" ] := xTmp[ "Value" ]
         ENDIF
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:getProperties()
   LOCAL hProp := {=>}
   LOCAL oRect := ::geometry()

   hb_HCaseMatch( hProp, .F. )
   hb_HKeepOrder( hProp, .T. )

   hProp[ "objectName"     ] := ::name()

   hProp[ "x"              ] := oRect:x()
   hProp[ "y"              ] := oRect:y()
   hProp[ "width"          ] := oRect:width()
   hProp[ "height"         ] := oRect:height()

   hProp[ "penColor"       ] := ::cPenColor
   hProp[ "penStyle"       ] := ::cPenStyle
   hProp[ "capStyle"       ] := ::cCapStyle
   hProp[ "joinStyle"      ] := ::cJoinStyle
   hProp[ "miterLimit"     ] := ::nMiterLimit
   hProp[ "penWidth"       ] := ::nPenWidth

   hProp[ "brushStyle"     ] := ::cBrushStyle
   hProp[ "brushColor"     ] := ::cBrushColor
   hProp[ "brushTexture"   ] := ::cBrushTexture

   hProp[ "bBrushStyle"    ] := ::cBBrushStyle
   hProp[ "bBrushColor"    ] := ::cBBrushColor
   hProp[ "bBrushTexture"  ] := ::cBBrushTexture

   hProp[ "backgroundMode" ] := ::cBackgroundMode
   hProp[ "opacity"        ] := ::nOpacity
   hProp[ "text"           ] := ::cText
   hProp[ "fontFamily"     ] := ::cFontFamily
   hProp[ "fontStyle"      ] := ::cFontStyle
   hProp[ "fontSize"       ] := ::cFontSize

   RETURN hProp


FUNCTION __hbqtStyleConvert( cProperty, cStyle )
   STATIC hBrushStyles
   STATIC hPenStyles
   STATIC hCapStyles
   STATIC hJoinStyles

   IF Empty( hBrushStyles )
      hBrushStyles := __hbqtStandardHash()
      hPenStyles   := __hbqtStandardHash()
      hCapStyles   := __hbqtStandardHash()
      hJoinStyles  := __hbqtStandardHash()

      hBrushStyles[ "NoBrush"                ] := Qt_NoBrush
      hBrushStyles[ "SolidPattern"           ] := Qt_SolidPattern
      hBrushStyles[ "Dense1Pattern"          ] := Qt_Dense1Pattern
      hBrushStyles[ "Dense2Pattern"          ] := Qt_Dense2Pattern
      hBrushStyles[ "Dense3Pattern"          ] := Qt_Dense3Pattern
      hBrushStyles[ "Dense4Pattern"          ] := Qt_Dense4Pattern
      hBrushStyles[ "Dense5Pattern"          ] := Qt_Dense5Pattern
      hBrushStyles[ "Dense6Pattern"          ] := Qt_Dense6Pattern
      hBrushStyles[ "Dense7Pattern"          ] := Qt_Dense7Pattern
      hBrushStyles[ "HorPattern"             ] := Qt_HorPattern
      hBrushStyles[ "VerPattern"             ] := Qt_VerPattern
      hBrushStyles[ "CrossPattern"           ] := Qt_CrossPattern
      hBrushStyles[ "BDiagPattern"           ] := Qt_BDiagPattern
      hBrushStyles[ "FDiagPattern"           ] := Qt_FDiagPattern
      hBrushStyles[ "DiagCrossPattern"       ] := Qt_DiagCrossPattern
      hBrushStyles[ "LinearGradientPattern"  ] := Qt_LinearGradientPattern
      hBrushStyles[ "ConicalGradientPattern" ] := Qt_ConicalGradientPattern
      hBrushStyles[ "RadialGradientPattern"  ] := Qt_RadialGradientPattern
      hBrushStyles[ "TexturePattern"         ] := Qt_TexturePattern

      hPenStyles[ "NoPen"          ] := Qt_NoPen
      hPenStyles[ "SolidLine"      ] := Qt_SolidLine
      hPenStyles[ "DashLine"       ] := Qt_DashLine
      hPenStyles[ "DotLine"        ] := Qt_DotLine
      hPenStyles[ "DashDotLine"    ] := Qt_DashDotLine
      hPenStyles[ "DashDotDotLine" ] := Qt_DashDotDotLine

      hCapStyles[ "FlatCap"        ] := Qt_FlatCap
      hCapStyles[ "RoundCap"       ] := Qt_RoundCap
      hCapStyles[ "SquareCap"      ] := Qt_SquareCap

      hJoinStyles[ "BevelJoin"     ] := Qt_BevelJoin
      hJoinStyles[ "MiterJoin"     ] := Qt_MiterJoin
      hJoinStyles[ "RoundJoin"     ] := Qt_RoundJoin
      hJoinStyles[ "SvgMiterJoin"  ] := Qt_SvgMiterJoin
   ENDIF

   SWITCH Lower( cProperty )
   CASE "penstyle"  ; RETURN iif( hb_HHasKey( hPenStyles, cStyle ), hPenStyles[ cStyle ], Qt_SolidLine )
   CASE "capstyle"  ; RETURN iif( hb_HHasKey( hCapStyles, cStyle ), hCapStyles[ cStyle ], Qt_FlatCap )
   CASE "joinstyle" ; RETURN iif( hb_HHasKey( hJoinStyles, cStyle ), hJoinStyles[ cStyle ], Qt_BevelJoin )
   CASE "brushstyle"; RETURN iif( hb_HHasKey( hBrushStyles, cStyle ), hBrushStyles[ cStyle ], Qt_NoBrush )
   ENDSWITCH
   RETURN ""


METHOD HbQtVisualItem:setPenProperties( cProperty, xValue )
   LOCAL oPen := ::setPen()

   SWITCH Lower( cProperty )
   CASE "pencolor"
      IF HB_ISSTRING( xValue )
         ::cPenColor := xValue
         oPen:setColor( QColor( xValue ) )
      ENDIF
      EXIT
   CASE "penwidth"
      ::nPenWidth := iif( HB_ISNUMERIC( xValue ), xValue, ::nPenWidth )
      oPen:setWidth( ::nPenWidth )
      EXIT
   CASE "penstyle"
      IF HB_ISSTRING( xValue )
         ::cPenStyle := xValue
         oPen:setStyle( __hbqtStyleConvert( cProperty, ::cPenStyle ) )
      ENDIF
      EXIT
   CASE "capstyle"
      IF HB_ISSTRING( xValue )
         ::cCapStyle := xValue
         oPen:setCapStyle( __hbqtStyleConvert( cProperty, ::cCapStyle ) )
      ENDIF
      EXIT
   CASE "joinstyle"
      IF HB_ISSTRING( xValue )
         ::cJoinStyle := xValue
         oPen:setJoinStyle( __hbqtStyleConvert( cProperty, ::cJoinStyle ) )
      ENDIF
      EXIT
   ENDSWITCH
   ::update()
   RETURN Self


METHOD HbQtVisualItem:setBrushProperties( cProperty, xValue )
   LOCAL oBrush := ::setBrush()

   SWITCH Lower( cProperty )
   CASE "brushcolor"
      IF HB_ISSTRING( xValue )
         ::cBrushColor := xValue
         oBrush:setColor( QColor( xValue ) )
      ENDIF
      EXIT
   CASE "brushstyle"
      IF HB_ISSTRING( xValue )
         ::cBrushStyle := xValue
         oBrush:setStyle( __hbqtStyleConvert( "brushstyle", xValue ) )
      ENDIF
   ENDSWITCH
   ::update()
   RETURN Self


METHOD HbQtVisualItem:setBBrushProperties( cProperty, xValue )
   LOCAL oBrush := ::backgroundBrush()

   SWITCH Lower( cProperty )
   CASE "bbrushcolor"
      IF HB_ISSTRING( xValue )
         ::cBBrushColor := xValue
         oBrush:setColor( QColor( xValue ) )
      ENDIF
      EXIT
   CASE "bbrushstyle"
      IF HB_ISSTRING( xValue )
         ::cBBrushStyle := xValue
         oBrush:setStyle( __hbqtStyleConvert( "brushstyle", xValue ) )
      ENDIF
   ENDSWITCH
   ::update()
   RETURN Self


METHOD HbQtVisualItem:setFontProperties( cProperty, xValue )
   SWITCH Lower( cProperty )
   CASE "fontfamily"
      ::cFontFamily := xValue
      EXIT
   CASE "fontstyle"
      ::cFontStyle := xValue
      EXIT
   CASE "fontsize"
      ::cFontSize := xValue
      EXIT
   ENDSWITCH
   ::qFont := NIL
   ::setFont()
   ::update()
   RETURN Self


METHOD HbQtVisualItem:setPen( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qPen )
         WITH OBJECT ::qPen := QPen()
            :setStyle( __hbqtStyleConvert( "penstyle", ::cPenStyle ) )
            :setCapStyle( __hbqtStyleConvert( "capstyle", ::cCapStyle ) )
            :setJoinStyle( __hbqtStyleConvert( "joinstyle", ::cJoinStyle ) )
            :setWidth( ::nPenWidth )
            :setColor( QColor( ::cPenColor ) )
         ENDWITH
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
         WITH OBJECT ::qBrush := QBrush()
            :SetColor( QColor( ::cBrushColor ) )
            :setStyle( __hbqtStyleConvert( "brushstyle", ::cBrushStyle ) )
         ENDWITH
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
         WITH OBJECT ::qBgBrush := QBrush()
            :setColor( QColor( ::cBBrushColor ) )
            :setStyle( __hbqtStyleConvert( "brushstyle", ::cBBrushStyle ) )
         ENDWITH
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


METHOD HbQtVisualItem:setFont( ... )
   LOCAL a_:= hb_aParams()
   SWITCH Len( a_ )
   CASE 0
      IF empty( ::qFont )
         WITH OBJECT ::qFont := QFont()
            :setFamily( ::cFontFamily )
            :setPointSizeF( Val( ::cFontSize ) )
            :setStyleStrategy( QFont_PreferMatch )
            :setStyleStrategy( QFont_ForceOutline )
            SWITCH ::cFontStyle
            CASE "Normal" ; ; EXIT
            CASE "Italic" ; :setItalic( .T. ); EXIT
            CASE "Bold"   ; :setBold( .T. ); EXIT
            CASE "Bold Italic" ; :setItalic( .T. ); :setBold( .T. ); EXIT
            ENDSWITCH
         ENDWITH
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
      ::cBackgroundMode := a_[ 1 ]
      ::update()
      EXIT
   ENDSWITCH
   RETURN ::cBackgroundMode


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


METHOD HbQtVisualItem:drawSelection( oPainter, oRect )
   LOCAL a, p, lt, rt, lb, rb, nW, nH
   LOCAL drawSelectionBorder := .t.
   LOCAL iResizeHandle := 2 / UNIT

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
            :setBrush( QBrush() )
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


METHOD HbQtVisualItem:setupPainter( oPainter, lDrawSelection )
   LOCAL qFont := ::font()

   qFont:setPixelSize( iif( lDrawSelection, ::nPointSize / UNIT, TO_MMS( ::nPointSize / UNIT ) ) )
   WITH OBJECT oPainter
      :setPen( ::pen() )
      :setBrush( ::brush() )
      :setOpacity( ::opacity() / 100.0 )
      :setBackgroundMode( iif( ::backgroundMode() == "OpaqueMode", Qt_OpaqueMode, Qt_TransparentMode ) )
      :setBackground( ::backgroundBrush() )
      :setRenderHint( QPainter_TextAntialiasing )
      :setFont( qFont )
   ENDWITH
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

   DEFAULT lDrawSelection TO .T.

   SWITCH ::cType
   CASE "Barcode" ; ::oDraw:drawShape( oPainter, oRectF, ::cType, ::pen(), ::brush(), ::text()   ) ; EXIT
   CASE "Marker"  ; ::oDraw:drawShape( oPainter, oRectF, ::cType, ::pen(), ::brush(), ::pixmap() ) ; EXIT
   CASE "Image"   ; ::oDraw:drawShape( oPainter, oRectF, ::cType, ::pen(), ::brush(), ::pixmap() ) ; EXIT
   CASE "Chart"   ; ::drawChart( oPainter, oRectF )        ;    EXIT
   CASE "Gradient"; ::drawGradient( oPainter, oRectF )     ;    EXIT
   CASE "Text"    ; ::drawText( oPainter, oRectF, lDrawSelection ) ;    EXIT
   CASE "Field"   ; ::drawField( oPainter, oRectF )        ;    EXIT
   OTHERWISE
      ::oDraw:drawShape( oPainter, oRectF, ::cType, ::pen(), ::brush() )
      EXIT
   ENDSWITCH

   IF lDrawSelection
      ::drawSelection( oPainter, oRectF )
   ENDIF
   IF HB_ISOBJECT( ::oState )
      ::state():draw( oPainter, oRectF )
   ENDIF
   IF ::lLocked
      ::oDraw:Lock( oPainter, oRectF )
   ENDIF
   RETURN Self


METHOD HbQtVisualItem:drawText( oPainter, oRectF, lDrawSelection )
   LOCAL oFont

   WITH OBJECT oFont := QFont()
      :setFamily( ::cFontFamily )
      :setPixelSize( iif( lDrawSelection, Val( ::cFontSize ) / UNIT, TO_MMS( Val( ::cFontSize ) / UNIT ) ) )
      :setStyleStrategy( QFont_PreferMatch )
      :setStyleStrategy( QFont_ForceOutline )
      SWITCH ::cFontStyle
      CASE "Italic"      ; :setItalic( .T. ); EXIT
      CASE "Bold"        ; :setBold( .T. )  ; EXIT
      CASE "Bold Italic" ; :setItalic( .T. ); :setBold( .T. ); EXIT
      ENDSWITCH
   ENDWITH

   WITH OBJECT oPainter
      :save()
      :setPen( ::pen() )
      :setBrush( ::brush() )
      :setOpacity( ::opacity() / 100.0 )
      :setBackgroundMode( iif( ::backgroundMode() == "OpaqueMode", Qt_OpaqueMode, Qt_TransparentMode ) )
      :fillRect( oRectF, ::backgroundBrush() )
      :setFont( oFont )
      :drawText( oRectF, ::textFlags(), ::text() )
      :restore()
   ENDWITH
   RETURN Self


METHOD HbQtVisualItem:drawField( oPainter, oRectF )
   RETURN ::drawText( oPainter, oRectF )


METHOD HbQtVisualItem:drawGradient( oPainter, oRectF )
   oPainter:drawRect( oRectF )
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

//--------------------------------------------------------------------//
//                      CLASS HbQtVisualItemState
//--------------------------------------------------------------------//

CLASS HbQtVisualItemState

   DATA   nArea                                   INIT __STATE_AREA_NONE__
   DATA   cType                                   INIT "Rectangle"
   DATA   nOffsetX                                INIT 0
   DATA   nOffsetY                                INIT 0
   DATA   xImage
   DATA   oPen
   DATA   oBrush
   DATA   oPixmap

   DATA   oDraw                                   INIT HbQtVisualItemDraw():new()

   METHOD init( hState )

   ACCESS area()                                  INLINE ::setArea()
   METHOD setArea( nArea )                        SETGET
   ACCESS image()                                 INLINE ::setImage()
   METHOD setImage( xImage )                      SETGET
   METHOD type()                                  INLINE ::setType()
   METHOD setType( cType )                        SETGET

   DATA   bStateChanged
   METHOD stateChangedBlock( bBlock )             SETGET
   METHOD stateChanged()

   METHOD pixmap( nWidth, nHeight )
   METHOD draw( oPainter, oRectF )

   ENDCLASS


METHOD HbQtVisualItemState:init( hState )
   LOCAL oPen, oBrush, nArea, cShape

   IF HB_ISHASH( hState )
      IF hb_HHasKey( hState, "BorderStyle" ) .AND. hState[ "BorderStyle" ] > Qt_NoPen
         WITH OBJECT oPen := QPen( hState[ "BorderStyle" ] )
            IF hb_HHasKey( hState, "BorderWidth" ) .AND. hState[ "BorderWidth" ] > 0
               oPen:setWidth( hState[ "BorderWidth" ] )
            ELSE
               oPen:setWidth( 1 )
            ENDIF
            IF hb_HHasKey( hState, "BorderColor" ) .AND. HB_ISSTRING( hState[ "BorderColor" ] )
               oPen:SetColor( QColor( hState[ "BorderColor" ] ) )
            ENDIF
         ENDWITH
      ENDIF
      IF hb_HHasKey( hState, "Style" ) .AND. hState[ "Style" ] > Qt_NoBrush
         oBrush := QBrush( hState[ "Style" ] )
         IF hb_HHasKey( hState, "Color" ) .AND. HB_ISSTRING( hState[ "Color" ] )
            oBrush:SetColor( QColor(  hState[ "Color" ] ) )
         ENDIF
      ENDIF
      IF hb_HHasKey( hState, "Area" ) .AND. hState[ "Area" ] > 0
         nArea := hState[ "Area" ]
      ELSE
         nArea := __STATE_AREA_TOPLEFT__
      ENDIF
      IF nArea > __STATE_AREA_MAXIMUM__
         nArea := __STATE_AREA_TOPLEFT__
      ENDIF
      IF hb_HHasKey( hState, "Shape" ) .AND. HB_ISSTRING( hState[ "Shape" ] )
         cShape := hState[ "Shape" ]
      ELSE
         cShape := "Rectangle"
      ENDIF
      IF hb_HHasKey( hState, "Image" )
         ::xImage := hState[ "Image" ]
      ENDIF
      IF hb_HHasKey( hState, "OffsetX" ) .AND. HB_ISNUMERIC( hState[ "OffsetX" ] )
         ::nOffsetX := hState[ "OffsetX" ]
      ENDIF
      IF hb_HHasKey( hState, "OffsetY" ) .AND. HB_ISNUMERIC( hState[ "OffsetY" ] )
         ::nOffsetY := hState[ "OffsetY" ]
      ENDIF
   ENDIF
   IF ! Empty( nArea )
      ::nArea := nArea
   ENDIF
   IF ! Empty( cShape )
      ::cType := cShape
   ENDIF
   IF Empty( oPen )
      oPen := QPen( Qt_SolidLine )
   ENDIF
   ::oPen := oPen
   IF Empty( oBrush )
      oBrush := QBrush( Qt_NoBrush )
   ENDIF
   ::oBrush := oBrush

   ::oDraw := HbQtVisualItemDraw():new()

   RETURN Self


METHOD HbQtVisualItemState:pixmap( nWidth, nHeight )
   LOCAL oPixmap, oPainter, oRectF

   WITH OBJECT oPixmap := QPixmap( nWidth, nHeight )
      :fill( QColor( 255,255,255,0 ) )
   ENDWITH
   WITH OBJECT oPainter := QPainter()
      IF :begin( oPixmap )
         :drawRect( QRectF( 0, 0, nWidth-1, nHeight-1 ) )
         oRectF := __hbqtRectByArea( QRect( 0, 0, nWidth, nHeight ), ::nArea, ::nOffsetX, ::nOffsetY )
         ::oDraw:drawShape( oPainter, oRectF, ::cType, ::oPen, ::oBrush )
         :end()
      ENDIF
   ENDWITH
   ::oPixmap := oPixmap
   RETURN oPixmap


METHOD HbQtVisualItemState:draw( oPainter, oRectF )
   LOCAL oRF, nX, nY, nW, nH, nHalfW, nHalfH, nOffX, nOffY

   IF ::nArea > __STATE_AREA_NONE__
      nX     := oRectF:x()
      nY     := oRectF:y()
      nW     := oRectF:width()
      nH     := oRectF:height()
      nHalfW := nW/2
      nHalfH := nH/2
      nOffX  := ::nOffsetX
      nOffY  := ::nOffsetY

      SWITCH ::nArea
      CASE __STATE_AREA_TOPLEFT__     ; oRF := QRectF( nX + nOffX           , nY + nOffY           , nHalfW, nHalfH ) ; EXIT
      CASE __STATE_AREA_TOPRIGHT__    ; oRF := QRectF( nX + nOffX + nHalfW  , nY + nOffY           , nHalfW, nHalfH ) ; EXIT
      CASE __STATE_AREA_BOTTOMRIGHT__ ; oRF := QRectF( nX + nOffX + nHalfW  , nY + nOffY + nHalfH  , nHalfW, nHalfH ) ; EXIT
      CASE __STATE_AREA_BOTTOMLEFT__  ; oRF := QRectF( nX + nOffX           , nY + nOffY + nHalfH  , nHalfW, nHalfH ) ; EXIT
      CASE __STATE_AREA_CENTER__      ; oRF := QRectF( nX + nOffX + nHalfW/2, nY + nOffY + nHalfH/2, nHalfW, nHalfH ) ; EXIT
      ENDSWITCH

      ::oDraw:drawShape( oPainter, oRF, ::cType, ::oPen, ::oBrush )
   ENDIF
   RETURN Self


METHOD HbQtVisualItemState:stateChanged()
   IF HB_ISBLOCK( ::stateChangedBlock() )
      Eval( ::stateChangedBlock(), Self )
   ENDIF
   RETURN Self


METHOD HbQtVisualItemState:stateChangedBlock( bBlock )
   LOCAL oldBlock := ::bStateChanged
   IF HB_ISBLOCK( bBlock )
      ::bStateChanged := bBlock
   ENDIF
   RETURN oldBlock


METHOD HbQtVisualItemState:setArea( nArea )
   LOCAL oldArea := ::nArea
   IF HB_ISNUMERIC( nArea ) .AND. nArea >= __STATE_AREA_NONE__ .AND. nArea <= __STATE_AREA_MAXIMUM__
      ::nArea := nArea
      ::stateChanged()
   ENDIF
   RETURN oldArea


METHOD HbQtVisualItemState:setType( cType )
   LOCAL oldType := ::cType
   IF HB_ISSTRING( cType )
      ::cType := cType
      ::stateChanged()
   ENDIF
   RETURN oldType


METHOD HbQtVisualItemState:setImage( xImage )
   LOCAL oldImage := ::xImage
   IF PCount() == 1
      ::xImage := NIL                                // clear qt object if it has been QImage, etc.
      ::xImage := xImage
      ::stateChanged()
   ENDIF
   RETURN oldImage


STATIC FUNCTION __hbqtRectByArea( oRectF, nArea, nOffX, nOffY )
   LOCAL oRF, nX, nY, nW, nH, nHalfW, nHalfH

   IF nArea > __STATE_AREA_NONE__
      nX     := oRectF:x()
      nY     := oRectF:y()
      nW     := oRectF:width()
      nH     := oRectF:height()
      nHalfW := nW/2
      nHalfH := nH/2

      SWITCH nArea
      CASE __STATE_AREA_TOPLEFT__     ; oRF := QRectF( nX + nOffX           , nY + nOffY           , nHalfW-1, nHalfH-1 ) ; EXIT
      CASE __STATE_AREA_TOPRIGHT__    ; oRF := QRectF( nX + nOffX + nHalfW  , nY + nOffY           , nHalfW-1, nHalfH-1 ) ; EXIT
      CASE __STATE_AREA_BOTTOMRIGHT__ ; oRF := QRectF( nX + nOffX + nHalfW  , nY + nOffY + nHalfH  , nHalfW-1, nHalfH-1 ) ; EXIT
      CASE __STATE_AREA_BOTTOMLEFT__  ; oRF := QRectF( nX + nOffX           , nY + nOffY + nHalfH  , nHalfW-1, nHalfH-1 ) ; EXIT
      CASE __STATE_AREA_CENTER__      ; oRF := QRectF( nX + nOffX + nHalfW/2, nY + nOffY + nHalfH/2, nHalfW-1, nHalfH-1 ) ; EXIT
      ENDSWITCH
   ENDIF
   RETURN oRF

//--------------------------------------------------------------------//
//         CLASS HbQtVisualItemDraw( oPainter, oRectF, cWhat )
//--------------------------------------------------------------------//

CLASS HbQtVisualItemDraw

   DATA   oBrush
   DATA   oPen
   DATA   oLock
   DATA   nStartAngle                             INIT 30
   DATA   nSpanAngle                              INIT 120

   METHOD init()
   METHOD drawShape( oPainter, oRectF, cShape, oPen, oBrush, xCargo )
   METHOD lock( oPainter, oRectF )

   PROTECTED:

   METHOD setOptions( oPainter, oPen, oBrush )

   METHOD diamond( oPainter, oRectF )
   METHOD rectangle( oPainter, oRectF )
   METHOD triangle( oPainter, oRectF )
   METHOD roundedRect( oPainter, oRectF )
   METHOD ellipse( oPainter, oRectF )
   METHOD arc( oPainter, oRectF )
   METHOD pie( oPainter, oRectF )
   METHOD chord( oPainter, oRectF )
   METHOD line( oPainter, oRectF, nLineType )
   METHOD barcode( oPainter, oRectF, oLineColor, oBGColor, cText )
   METHOD image( oPainter, oRectF, oPixmap )

   ENDCLASS


METHOD HbQtVisualItemDraw:init()
   ::oPen   := QPen( Qt_NoPen )
   ::oBrush := QBrush( Qt_NoBrush )
   ::oLock  := QPixmap( __hbqtImage( "lock" ) ):toImage()
   RETURN Self


METHOD HbQtVisualItemDraw:setOptions( oPainter, oPen, oBrush )
   DEFAULT oPen TO ::oPen
   DEFAULT oBrush TO ::oBrush
   WITH OBJECT oPainter
      :setPen( oPen )
      :setBrush( oBrush )
   ENDWITH
   RETURN Self


METHOD HbQtVisualItemDraw:drawShape( oPainter, oRectF, cShape, oPen, oBrush, xCargo )

   oPainter:save()

   ::setOptions( oPainter, oPen, oBrush )

   SWITCH Lower( cShape )
   CASE "barcode"     ; ::barcode( oPainter, oRectF, oPen:color(), oBrush:color(), xCargo ) ; EXIT
   CASE "marker"      ; ::image( oPainter, oRectF, xCargo   ) ; EXIT
   CASE "image"       ; ::image( oPainter, oRectF, xCargo   ) ; EXIT
   CASE "rectangle"   ; ::rectangle( oPainter, oRectF       ) ; EXIT
   CASE "ellipse"     ; ::ellipse( oPainter, oRectF         ) ; EXIT
   CASE "roundedrect" ; ::roundedRect( oPainter, oRectF     ) ; EXIT
   CASE "diamond"     ; ::diamond( oPainter, oRectF         ) ; EXIT
   CASE "triangle"    ; ::triangle( oPainter, oRectF        ) ; EXIT
   CASE "arc"         ; ::arc( oPainter, oRectF             ) ; EXIT
   CASE "pie"         ; ::pie( oPainter, oRectF             ) ; EXIT
   CASE "chord"       ; ::chord( oPainter, oRectF           ) ; EXIT
   CASE "linev"       ; ::line( oPainter, oRectF, HBQT_GRAPHICSITEM_LINE_VERTICAL         ) ; EXIT
   CASE "lineh"       ; ::line( oPainter, oRectF, HBQT_GRAPHICSITEM_LINE_HORIZONTAL       ) ; EXIT
   CASE "linedl"      ; ::line( oPainter, oRectF, HBQT_GRAPHICSITEM_LINE_FORWARDDIAGONAL  ) ; EXIT
   CASE "linedr"      ; ::line( oPainter, oRectF, HBQT_GRAPHICSITEM_LINE_BACKWARDDIAGONAL ) ; EXIT
   ENDSWITCH

   oPainter:restore()
   HB_SYMBOL_UNUSED( xCargo )
   RETURN Self


METHOD HbQtVisualItemDraw:lock( oPainter, oRectF )
   LOCAL nX := oRectF:x(), nY := oRectF:y(), nW := oRectF:width()/4, nH := oRectF:height()/4
   oPainter:drawImage( QRectF( nX + nW * 3, nY  + nH * 3, nW, nH ), ::oLock:scaled( nW, nH ) )
   RETURN Self


METHOD HbQtVisualItemDraw:ellipse( oPainter, oRectF )
   oPainter:drawEllipse( oRectF )
   RETURN Self


METHOD HbQtVisualItemDraw:rectangle( oPainter, oRectF )
   oPainter:drawRect( oRectF )
   RETURN Self


METHOD HbQtVisualItemDraw:roundedRect( oPainter, oRectF )
   LOCAL nW := oRectF:width() / 30
   LOCAL nH := oRectF:height() / 30

   oPainter:drawRoundedRect( oRectF, nW/UNIT, nH/UNIT )
   RETURN Self


METHOD HbQtVisualItemDraw:diamond( oPainter, oRectF )
   LOCAL oPath
   LOCAL nX := oRectF:x(), nY := oRectF:y(), nW := oRectF:width(), nH := oRectF:height()

   WITH OBJECT oPath := QPainterPath()
      :moveTo( nX         , nY + nH / 2 )
      :lineTo( nX + nW / 2, nY          )
      :lineTo( nX + nW    , nY + nH / 2 )
      :lineTo( nX + nW / 2, nY + nH     )
      :lineTo( nX         , nY + nH / 2 )
   ENDWITH
   oPainter:drawPath( oPath )
   RETURN Self


METHOD HbQtVisualItemDraw:triangle( oPainter, oRectF )
   LOCAL oPath
   LOCAL nX := oRectF:x(), nY := oRectF:y(), nW := oRectF:width(), nH := oRectF:height()

   WITH OBJECT oPath := QPainterPath()
      :moveTo( nX         , nY + nH )
      :lineTo( nX + nW / 2, nY      )
      :lineTo( nX + nW    , nY + nH )
      :lineTo( nX         , nY + nH )
   ENDWITH
   oPainter:drawPath( oPath )
   RETURN Self


METHOD HbQtVisualItemDraw:line( oPainter, oRectF, nLineType )

   SWITCH nLineType
   CASE HBQT_GRAPHICSITEM_LINE_VERTICAL
      oPainter:drawLine( oRectF:x() + oRectF:width() / 2, oRectF:y(), oRectF:x() +  oRectF:width() / 2, oRectF:y() + oRectF:height() )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_HORIZONTAL
      oPainter:drawLine( oRectF:x(), oRectF:y() + oRectF:height() / 2, oRectF:x() + oRectF:width(), oRectF:y() + oRectF:height() / 2 )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_BACKWARDDIAGONAL
      oPainter:drawLine( oRectF:right(), oRectF:y(), oRectF:x(), oRectF:bottom() )
      EXIT
   CASE HBQT_GRAPHICSITEM_LINE_FORWARDDIAGONAL
      oPainter:drawLine( QPointF( oRectF:x(), oRectF:y() ), QPointF( oRectF:right(), oRectF:bottom() ) )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtVisualItemDraw:pie( oPainter, oRectF )
   oPainter:drawPie( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItemDraw:arc( oPainter, oRectF )
   oPainter:drawArc( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItemDraw:chord( oPainter, oRectF )
   oPainter:drawChord( oRectF, ::nStartAngle * 16, ::nSpanAngle * 16 )
   RETURN Self


METHOD HbQtVisualItemDraw:barcode( oPainter, oRectF, oLineColor, oBGColor, cText )
   LOCAL rc, w, x, i, cCode

   rc    := oRectF:adjusted( 5, 5, -5, -5 )
   cCode := fetchBarString( cText )
   w     := rc:width() / Len( cCode )
   x     := 0.0

   oPainter:fillRect( oRectF, oBGColor )
   FOR i := 1 TO Len( cCode )
      IF substr( cCode, i, 1 ) == "1"
         oPainter:fillRect( QRectF( rc:x() + x, rc:y(), w, rc:height() ), oLineColor )
      ENDIF
      x += w
   NEXT
   RETURN Self


METHOD HbQtVisualItemDraw:image( oPainter, oRectF, oPixmap )
   LOCAL image, rc, img, point, pen, cx, cy, cw, ch
   LOCAL paintType    := HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_KEEP_ASPECT_RATIO
   LOCAL borderWidth  := 0
   LOCAL borderColor  := 0

   rc    := oRectF:adjusted( 1, 1, -2, -2 )
   image := oPixmap:toImage()

   IF image:isNull()
      oPainter:drawRect( oRectF )

   ELSE
      img   := QImage( 0, 0 )
      point := oRectF:topLeft()
      cx    := 0
      cy    := 0
      cw    := oPixmap:width()
      ch    := oPixmap:height()

      SWITCH paintType
      CASE HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_KEEP_ASPECT_RATIO
         img := QImage( image:scaled( rc:width(), rc:height(), Qt_KeepAspectRatio, Qt_SmoothTransformation ) )
         EXIT
      CASE HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_IGNORE_ASPECT_RATIO
         img := QImage( image:scaled( rc:width(), rc:height(), Qt_IgnoreAspectRatio, Qt_SmoothTransformation ) )
         EXIT
      CASE HBQT_GRAPHICSITEM_CENTER_PICTURE_TO_ITEM
         point:setX( point:x() + ( rc:width() - image:width() ) / 2 )
         point:setY( point:y() + ( rc:height() - image:height() ) / 2 )
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
         EXIT
      ENDSWITCH

      oPainter:drawImage( point, img )
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


