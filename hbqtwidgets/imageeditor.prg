/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2019 Pritpal Bedi <bedipritpal@hotmail.com>
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

#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "common.ch"
#include "hbclass.ch"
#include "hbtrace.ch"

#define HBQT_GRAPHICSVIEW_ZOOM_IN                 1
#define HBQT_GRAPHICSVIEW_ZOOM_OUT                2
#define HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG            3
#define HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL           4
#define HBQT_GRAPHICSVIEW_ZOOM_LOCATE             5
#define HBQT_GRAPHICSVIEW_ZOOM_ROTATE_L           6
#define HBQT_GRAPHICSVIEW_ZOOM_ROTATE_R           7


CREATE CLASS HbQtImageEditor

   DATA   oUI
   DATA   oWidget
   DATA   oParent
   DATA   oGraphicsView
   DATA   oScene
   DATA   oRubberBand
   DATA   oOPixmap
   DATA   oWPixmap
   DATA   oPixmapItem
   DATA   oPrevPos
   DATA   aCropInfo
   DATA   oCroppedPixmap
   DATA   bReturnBlock
   DATA   bFinishedBlock
   DATA   toolZoomIn, toolZoomOut, toolReturn, toolAsIs, toolFitInView, toolCrop, toolRotateLeft, toolRotateRight, toolFlush

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD buildWidget()
   METHOD connect()
   METHOD destroy()

   METHOD setOriginalPixmap( oPixmap )
   METHOD setPixmap( oPixmap )
   METHOD zoom( nMode )
   METHOD activateCropping( lChecked )
   METHOD manageCropping( oRect, oP1, oP2 )

   METHOD setReturnBlock( bBlock )                INLINE iif( HB_ISBLOCK( bBlock ), ::bReturnBlock := bBlock, NIL )
   METHOD setFinishedBlock( bBlock )              INLINE iif( HB_ISBLOCK( bBlock ), ::bFinishedBlock := bBlock, NIL )

   ENDCLASS


METHOD HbQtImageEditor:init( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   RETURN Self


METHOD HbQtImageEditor:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::buildWidget()
   ::oUI := Self

   HbQtLayInParent( ::oWidget, ::oParent )

   ::connect()

   RETURN Self


METHOD HbQtImageEditor:buildWidget()
   LOCAL vLayout, hLayout

   ::oWidget := QWidget( ::oParent )
   WITH OBJECT ::oGraphicsView := QGraphicsView( ::oWidget )
      :setDragMode( QGraphicsView_RubberBandDrag )
      :setBackgroundBrush( QBrush( QColor( 180, 180, 180 ) ) )
      :setScene( ::oScene := QGraphicsScene( ::oGraphicsView ) )
   ENDWITH
   WITH OBJECT hLayout := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
   ENDWITH
   WITH OBJECT vLayout := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :addWidget( ::oGraphicsView )
      :addLayout( hLayout )
   ENDWITH
   ::oWidget:setLayout( vLayout )
   //
   WITH OBJECT hLayout
      :addStretch()
      //
      :addWidget( ::toolReturn      := __buildToolButton( "brw-left"         , "Return to Previous Page"             ) )
      :addWidget( ::toolZoomIn      := __buildToolButton( "prv_zoom-in-1"    , "Zoom-In Image"            , .T.      ) )
      :addWidget( ::toolZoomOut     := __buildToolButton( "prv_zoom-out-1"   , "Zoom-Out Image"           , .T.      ) )
      :addWidget( ::toolFitInView   := __buildToolButton( "prv_zoom-1"       , "Fit Image in the Viewport"           ) )
      :addWidget( ::toolAsIs        := __buildToolButton( "prv_zoom-original", "Show Original Image"                 ) )
      :addWidget( ::toolRotateLeft  := __buildToolButton( "rotatel-3"        , "Rotae Image Left 90*"                ) )
      :addWidget( ::toolRotateRight := __buildToolButton( "rotate-3"         , "Rotate Image Right 90*"              ) )
      //
      :addWidget( ::toolCrop        := __buildToolButton( "crop"             , "Begin to Crop Image"      , .F., .T. ) )
      :addWidget( ::toolFlush       := __buildToolButton( "brw-right"        , "Retain this Image"                   ) )
      //
      :addStretch()
   ENDWITH
   RETURN Self


STATIC FUNCTION __buildToolButton( cImageName, cTooltip, lAutoRepeat, lCheckable )
   LOCAL oButton := QToolButton()

   DEFAULT lAutoRepeat TO .F.
   DEFAULT lCheckable TO .F.

   WITH OBJECT oButton
      :setMinimumWidth( 48 )
      :setMinimumHeight( 48 )
      :setAutoRaise( .T. )
      :setIconSize( QSize( 40, 40 ) )
      :setIcon( QIcon( __hbqtImage( cImageName ) ) )
      :setTooltip( cTooltip )
      :setAutoRepeat( lAutoRepeat )
      :setCheckable( lCheckable )
   ENDWITH
   RETURN oButton


METHOD HbQtImageEditor:connect()
   WITH OBJECT ::oUI
      :toolZoomIn     :connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_IN       ) } )
      :toolZoomOut    :connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_OUT      ) } )
      :toolAsIs       :connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL ) } )
      :toolFitInView  :connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG  ) } )
      :toolRotateLeft :connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ROTATE_L ) } )
      :toolRotateRight:connect( "clicked()", {|| ::zoom( HBQT_GRAPHICSVIEW_ZOOM_ROTATE_R ) } )
      //
      :toolCrop       :connect( "toggled(bool)", {|lChecked| ::activateCropping( lChecked ) } )
      :toolReturn     :connect( "clicked()", {|| iif( HB_ISBLOCK( ::bReturnBlock ), Eval( ::bReturnBlock, Self ), NIL ) } )
      :toolFlush      :connect( "clicked()", {|| iif( HB_ISBLOCK( ::bFinishedBlock ), Eval( ::bFinishedBlock, Self, ::oWPixmap ), NIL ) } )
      //
      :oGraphicsView  :connect( "rubberBandChanged(QRect,QPointF,QPointF)", {|oRect, oP1, oP2| ::manageCropping( oRect, oP1, oP2 ) } )
   ENDWITH
   RETURN NIL


METHOD HbQtImageEditor:destroy()
   RETURN NIL


METHOD HbQtImageEditor:setOriginalPixmap( oPixmap )
   ::oOPixmap := NIL
   ::oOPixmap := oPixmap
   ::setPixmap( ::oOPixmap )
   ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )
   RETURN NIL


METHOD HbQtImageEditor:setPixmap( oPixmap )
   ::toolCrop:setChecked( .F. )
   //
   ::oScene := NIL
   ::oScene := QGraphicsScene( ::oGraphicsView )
   ::oGraphicsView:setScene( ::oScene )

   ::oWPixmap := NIL
   ::oWPixmap := QPixmap( oPixmap )
   ::oPixmapItem := QGraphicsPixmapItem( ::oWPixmap )
   //
   ::oScene:clear()
   ::oScene:addItem( ::oPixmapItem )
   RETURN NIL


METHOD HbQtImageEditor:zoom( nMode )
   LOCAL nScaleFactor := 1.10

   SWITCH nMode
   CASE HBQT_GRAPHICSVIEW_ZOOM_ROTATE_L
      ::setPixmap( ::oWPixmap:transformed( QTransform():rotate( -90 ), Qt_SmoothTransformation ) )
      ::oGraphicsView:fitInView( ::oScene:sceneRect(), Qt_KeepAspectRatio )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_ROTATE_R
      ::setPixmap( ::oWPixmap:transformed( QTransform():rotate( +90 ), Qt_SmoothTransformation ) )
      ::oGraphicsView:fitInView( ::oScene:sceneRect(), Qt_KeepAspectRatio )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_IN
      ::oGraphicsView:scale( nScaleFactor, nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_OUT
      ::oGraphicsView:scale( 1 / nScaleFactor, 1 / nScaleFactor )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      ::oGraphicsView:fitInView( ::oScene:sceneRect(), Qt_KeepAspectRatio )
      EXIT
   CASE HBQT_GRAPHICSVIEW_ZOOM_ORIGINAL
      ::setPixmap( ::oOPixmap )
      ::oGraphicsView:resetMatrix()
      ::oGraphicsView:centerOn( 0.0, 0.0 )
      EXIT
   ENDSWITCH
   RETURN sELF


METHOD HbQtImageEditor:activateCropping( lChecked )
   IF .T.
      ::toolZoomIn     :setEnabled( ! lChecked )
      ::toolZoomOut    :setEnabled( ! lChecked )
      ::toolAsIs       :setEnabled( ! lChecked )
      ::toolFitInView  :setEnabled( ! lChecked )
      ::toolRotateLeft :setEnabled( ! lChecked )
      ::toolRotateRight:setEnabled( ! lChecked )
   ENDIF
   IF ! lChecked
      IF HB_ISOBJECT( ::oCroppedPixmap )
         ::setPixmap( ::oCroppedPixmap )
         ::zoom( HBQT_GRAPHICSVIEW_ZOOM_WYSIWYG )
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtImageEditor:manageCropping( oRect, oP1, oP2 )
   LOCAL oSR, oR, oP, oSF

   IF ::toolCrop:isChecked()
      IF oRect:isNull()
         oSR := QRect( Int( ::aCropInfo[ 5 ] ), Int( ::aCropInfo[ 6 ] ), ;
                       Int( ::aCropInfo[ 7 ] - ::aCropInfo[ 5 ] ), Int( ::aCropInfo[ 8 ] - ::aCropInfo[ 6 ] ) )
         oSF := QRectF( ::aCropInfo[ 5 ], ::aCropInfo[ 6 ], ;
                        ::aCropInfo[ 7 ] - ::aCropInfo[ 5 ], ::aCropInfo[ 8 ] - ::aCropInfo[ 6 ] )

         oR := QPixmap( oSR:width(), oSR:height() )
         oP := QPainter()
         IF oP:begin( oR )
            ::oScene:render( oP, QRectF( 0.0, 0.0, oSF:width(), oSF:height() ), oSF )
            oP:end()
         ENDIF
         ::oCroppedPixmap := oR
      ELSE
         ::aCropInfo := { oRect:x(), oRect:y(), oRect:width(), oRect:height(), oP1:x(), oP1:y(), oP2:x(), oP2:y() }
      ENDIF
   ELSE
      ::oCroppedPixmap := QPixmap()
   ENDIF
   RETURN NIL


