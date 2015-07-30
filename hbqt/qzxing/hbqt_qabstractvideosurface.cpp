/*
 * $Id$
 */

/*
 * Copyright 2015 Pritpal Bedi (bedipritpal@hotmail.com)
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


#include "hbqt_qabstractvideosurface.h"

/*
   COPIED from Qt Sources as this function is not available as public API.
*/
void qt_convert_NV21_to_ARGB32(const uchar *yuv, quint32 *rgb, int width, int height)
{
   const int frameSize = width * height;

   int a = 0;
   for( int i = 0, ci = 0; i < height; ++i, ci += 1 )
   {
      for( int j = 0, cj = 0; j < width; ++j, cj += 1 )
      {
         int y = (0xff & ((int) yuv[ci * width + cj]));
         int v = (0xff & ((int) yuv[frameSize + (ci >> 1) * width + (cj & ~1) + 0]));
         int u = (0xff & ((int) yuv[frameSize + (ci >> 1) * width + (cj & ~1) + 1]));
         y = y < 16 ? 16 : y;

         int r = (int) (1.164f * (y - 16) + 1.596f * (v - 128));
         int g = (int) (1.164f * (y - 16) - 0.813f * (v - 128) - 0.391f * (u - 128));
         int b = (int) (1.164f * (y - 16) + 2.018f * (u - 128));

         r = qBound(0, r, 255);
         g = qBound(0, g, 255);
         b = qBound(0, b, 255);

         rgb[a++] = 0xff000000 | (r << 16) | (g << 8) | b;
      }
      qApp->processEvents( 0 );
   }
}

HBQAbstractVideoSurface::HBQAbstractVideoSurface( QObject * parent )
    : QAbstractVideoSurface( parent )
{
    m_source   = NULL;
    m_camera   = NULL;
    m_probe    = NULL;
    m_decoder  = NULL;
    m_decoding = false;

    m_imageFormat = QImage::Format_Invalid;
}


HBQAbstractVideoSurface::~HBQAbstractVideoSurface()
{
   if( m_probe )
      delete m_probe;
}


QList< QVideoFrame::PixelFormat > HBQAbstractVideoSurface::supportedPixelFormats(
            QAbstractVideoBuffer::HandleType handleType ) const
{
   if( handleType == QAbstractVideoBuffer::NoHandle )
   {
      return QList< QVideoFrame::PixelFormat >()
              << QVideoFrame::Format_UYVY
              << QVideoFrame::Format_RGB32
              << QVideoFrame::Format_ARGB32
              << QVideoFrame::Format_ARGB32_Premultiplied
              << QVideoFrame::Format_RGB565
              << QVideoFrame::Format_RGB555;
   }
   return QList< QVideoFrame::PixelFormat >();
}


bool HBQAbstractVideoSurface::start( const QVideoSurfaceFormat &format )
{
   m_videoFormat = format;
   const QImage::Format imageFormat = QVideoFrame::imageFormatFromPixelFormat( format.pixelFormat() );
   const QSize size = format.frameSize();

   if( imageFormat != QImage::Format_Invalid && ! size.isEmpty() )
   {
      m_imageFormat = imageFormat;
      QAbstractVideoSurface::start( format );
      return true;
   }
   return false;
}


bool HBQAbstractVideoSurface::present( const QVideoFrame &frame )
{
   if( m_decoding || ! frame.isValid() )
      return true;
   m_decoding = true;

   QVideoFrame mm_frame( frame );

   if( mm_frame.map( QAbstractVideoBuffer::ReadOnly ) )
   {
      QImage image(
             mm_frame.bits(),
             mm_frame.width(),
             mm_frame.height(),
             mm_frame.bytesPerLine(),
             m_imageFormat
             );

      mm_frame.unmap();

      if( m_imageFormat != QImage::Format_RGB32 )
         emit imageAvailable( image.convertToFormat( QImage::Format_RGB32 ) );
      else
         emit imageAvailable( image );

      if( m_qzxing )
      {
         m_qzxing->decodeImage( image );
      }
   }
   m_decoding = false;
   return true;
}


void HBQAbstractVideoSurface::setDecoder( QObject * decoder )
{
   if( decoder )
   {
      m_decoder = decoder;
      m_qzxing = qobject_cast< QZXing * >( decoder );
      if( m_qzxing )
         emit currentAction( 3100 );
   }
}


void HBQAbstractVideoSurface::setSource( QObject * src )
{
   if( src )
   {
      m_source = src;

      QVariant mediaObject = m_source->property( "mediaObject" );
      m_camera = qvariant_cast< QCamera * >( mediaObject );
      if( m_camera )
      {
#ifdef __ANDROID__
         if( m_probe )
            delete m_probe;
         m_probe = new QVideoProbe( this );
         if( m_probe->setSource( m_camera ) )
         {
            connect( m_probe, SIGNAL(videoFrameProbed(QVideoFrame)), this, SLOT(detectBarCodes(QVideoFrame)) );
         }
#else
         m_camera->setViewfinder( this );
         QVideoSurfaceFormat format( QSize( 640, 480 ), QVideoFrame::Format_ARGB32_Premultiplied );
         start( format );
#endif
      }
   }
}


void HBQAbstractVideoSurface::detectBarCodes( const QVideoFrame & frame )
{
   if( m_decoding || ! frame.isValid() )
      return;
   m_decoding = true;

   QVideoFrame mm_frame( frame );
   if( mm_frame.map( QAbstractVideoBuffer::ReadOnly ) )
   {
      m_frame = mm_frame;

      QImage image( mm_frame.size(), QImage::Format_ARGB32 );
      qt_convert_NV21_to_ARGB32( mm_frame.bits(), ( quint32 * ) image.bits(), mm_frame.width(), mm_frame.height() );

      if( m_qzxing )
      {
         int x = ( ( image.width() - 480 ) / 2 );
         int y = ( ( image.height() - 300 ) / 2 );
         m_qzxing->decodeImage( image.copy( x, y, 480, 300 ) );
      }
      mm_frame.unmap();
   }
   m_decoding = false;
}


