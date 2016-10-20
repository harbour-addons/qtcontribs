/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2013-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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

#include "hbqt.h"

#include "hbapiitm.h"
#include "hbvm.h"
#include "hbapicls.h"

#if QT_VERSION >= 0x040600

#include "hbqt_hbqproxystyle.h"


#define HBQT_DRAW_PRIMITIVE                       0
#define HBQT_DRAW_CONTROL                         1
#define HBQT_DRAW_COMPLEXCONTROL                  2
#define HBQT_DRAW_ITEMPIXMAP                      3
#define HBQT_DRAW_ITEMTEXT                        4

HBQProxyStyle::HBQProxyStyle( QStyle * style ) : QProxyStyle( style )
{
   this->drawBlock = NULL;
}

HBQProxyStyle::~HBQProxyStyle( void )
{
   if( this->drawBlock )
   {
      hb_itemRelease( this->drawBlock );
      this->drawBlock = NULL;
   }
}

void HBQProxyStyle::drawComplexControl( ComplexControl control, const QStyleOptionComplex * option, QPainter * painter, const QWidget * widget ) const
{
   if( this->drawBlock && hb_vmRequestReenter() )
   {
      bool bRet   = HB_FALSE;
      PHB_ITEM p0 = hb_itemPutNI( NULL, HBQT_DRAW_COMPLEXCONTROL );
      PHB_ITEM p1 = hb_itemPutNI( NULL, control );
      PHB_ITEM p2 = hbqt_bindGetHbObject( NULL, ( void * ) option , "HB_QSTYLEOPTIONCOMPLEX", NULL, 0 );
      PHB_ITEM p3 = hbqt_bindGetHbObject( NULL, ( void * ) painter, "HB_QPAINTER"           , NULL, 0 );
      PHB_ITEM p4 = hbqt_bindGetHbObject( NULL, ( void * ) widget , "HB_QWIDGET"            , NULL, 0 );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( this->drawBlock, 5, p0, p1, p2, p3, p4 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );
      hb_itemRelease( p4 );

      hb_vmRequestRestore();
      bRet = ( hb_itemType( ret ) & HB_IT_LOGICAL ) && ( hb_itemGetL( ret ) == HB_TRUE );
      hb_itemRelease( ret );

      if( bRet )
         return;
   }

   QProxyStyle::drawComplexControl( control, option, painter, widget );
}

void HBQProxyStyle::drawControl( ControlElement element, const QStyleOption * option, QPainter * painter, const QWidget * widget ) const
{
   if( this->drawBlock && hb_vmRequestReenter() )
   {
      bool bRet   = HB_FALSE;
      PHB_ITEM p0 = hb_itemPutNI( NULL, HBQT_DRAW_CONTROL );
      PHB_ITEM p1 = hb_itemPutNI( NULL, element );
      PHB_ITEM p2 = hbqt_bindGetHbObject( NULL, ( void * ) option , "HB_QSTYLEOPTION", NULL, 0 );
      PHB_ITEM p3 = hbqt_bindGetHbObject( NULL, ( void * ) painter, "HB_QPAINTER"    , NULL, 0 );
      PHB_ITEM p4 = hbqt_bindGetHbObject( NULL, ( void * ) widget , "HB_QWIDGET"     , NULL, 0 );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( this->drawBlock, 5, p0, p1, p2, p3, p4 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );
      hb_itemRelease( p4 );

      hb_vmRequestRestore();
      bRet = ( hb_itemType( ret ) & HB_IT_LOGICAL ) && ( hb_itemGetL( ret ) == HB_TRUE );
      hb_itemRelease( ret );

      if( bRet )
         return;
   }

   QProxyStyle::drawControl( element, option, painter, widget );
}

void HBQProxyStyle::drawItemPixmap( QPainter * painter, const QRect & rectangle, int alignment, const QPixmap & pixmap ) const
{
   if( this->drawBlock && hb_vmRequestReenter() )
   {
      bool bRet   = HB_FALSE;
      PHB_ITEM p0 = hb_itemPutNI( NULL, HBQT_DRAW_ITEMPIXMAP );
      PHB_ITEM p1 = hbqt_bindGetHbObject( NULL, ( void * ) painter   , "HB_QPAINTER", NULL, 0 );
      PHB_ITEM p2 = hbqt_bindGetHbObject( NULL, ( void * ) &rectangle, "HB_QRECT"   , NULL, 0 );
      PHB_ITEM p3 = hb_itemPutNI( NULL, alignment );
      PHB_ITEM p4 = hbqt_bindGetHbObject( NULL, ( void * ) &pixmap   , "HB_QPIXMAP" , NULL, 0 );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( this->drawBlock, 5, p0, p1, p2, p3, p4 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );
      hb_itemRelease( p4 );

      hb_vmRequestRestore();
      bRet = ( hb_itemType( ret ) & HB_IT_LOGICAL ) && ( hb_itemGetL( ret ) == HB_TRUE );
      hb_itemRelease( ret );

      if( bRet )
         return;
   }

   QProxyStyle::drawItemPixmap( painter, rectangle, alignment, pixmap );
}

void HBQProxyStyle::drawItemText( QPainter * painter, const QRect & rectangle, int alignment, const QPalette & palette, bool enabled, const QString & text, QPalette::ColorRole textRole ) const
{
   if( this->drawBlock && hb_vmRequestReenter() )
   {
      bool bRet   = HB_FALSE;
      PHB_ITEM p0 = hb_itemPutNI( NULL, HBQT_DRAW_ITEMTEXT );
      PHB_ITEM p1 = hbqt_bindGetHbObject( NULL, ( void * ) painter   , "HB_QPAINTER", NULL, 0 );
      PHB_ITEM p2 = hbqt_bindGetHbObject( NULL, ( void * ) &rectangle, "HB_QRECT"   , NULL, 0 );
      PHB_ITEM p3 = hb_itemPutNI( NULL, alignment );
      PHB_ITEM p4 = hbqt_bindGetHbObject( NULL, ( void * ) &palette  , "HB_QPALETTE", NULL, 0 );
      PHB_ITEM p5 = hb_itemPutL( NULL, enabled );
      PHB_ITEM p6 = hb_itemPutC( NULL, text.toUtf8().data() );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( this->drawBlock, 7, p0, p1, p2, p3, p4, p5, p6 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );
      hb_itemRelease( p4 );
      hb_itemRelease( p5 );
      hb_itemRelease( p6 );

      hb_vmRequestRestore();
      bRet = ( hb_itemType( ret ) & HB_IT_LOGICAL ) && ( hb_itemGetL( ret ) == HB_TRUE );
      hb_itemRelease( ret );

      if( bRet )
         return;
   }

   QProxyStyle::drawItemText( painter, rectangle, alignment, palette, enabled, text, textRole );
}

void HBQProxyStyle::drawPrimitive( PrimitiveElement element, const QStyleOption * option, QPainter * painter, const QWidget * widget ) const
{
   if( this->drawBlock && hb_vmRequestReenter() )
   {
      bool bRet   = HB_FALSE;
      PHB_ITEM p0 = hb_itemPutNI( NULL, HBQT_DRAW_PRIMITIVE );
      PHB_ITEM p1 = hb_itemPutNI( NULL, element );
      PHB_ITEM p2 = hbqt_bindGetHbObject( NULL, ( void * ) option , "HB_QSTYLEOPTION", NULL, 0 );
      PHB_ITEM p3 = hbqt_bindGetHbObject( NULL, ( void * ) painter, "HB_QPAINTER"    , NULL, 0 );
      PHB_ITEM p4 = hbqt_bindGetHbObject( NULL, ( void * ) widget , "HB_QWIDGET"     , NULL, 0 );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( this->drawBlock, 5, p0, p1, p2, p3, p4 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );
      hb_itemRelease( p4 );

      hb_vmRequestRestore();
      bRet = ( hb_itemType( ret ) & HB_IT_LOGICAL ) && ( hb_itemGetL( ret ) == HB_TRUE );
      hb_itemRelease( ret );

      if( bRet )
         return;
   }

   QProxyStyle::drawPrimitive( element, option, painter, widget );
}

/*----------------------------------------------------------------------*/

int HBQProxyStyle::styleHint( StyleHint hint, const QStyleOption * option, const QWidget * widget, QStyleHintReturn * returnData ) const
{
   return QProxyStyle::styleHint( hint, option, widget, returnData );
}

int HBQProxyStyle::pixelMetric( PixelMetric metric, const QStyleOption * option, const QWidget * widget ) const
{
   if( this->pixelMetrics.contains( metric ) )
   {
      return this->pixelMetrics[ metric ];
   }
   return QProxyStyle::pixelMetric( metric, option, widget );
}

/*----------------------------------------------------------------------*/
/*                        Harbour Defined Methods                       */
/*----------------------------------------------------------------------*/

void HBQProxyStyle::hb_setDrawBlock( PHB_ITEM block )
{
   if( block )
   {
      this->drawBlock = hb_itemNew( block );
   }
}

int HBQProxyStyle::hb_setPixelMetric( QStyle::PixelMetric metric, int pixels )
{
   int value = -1;
   if( this->pixelMetrics.contains( metric ) )
   {
      value = this->pixelMetrics[ metric ];
   }
   pixelMetrics[ metric ] = pixels;

   return value;
}

#endif
