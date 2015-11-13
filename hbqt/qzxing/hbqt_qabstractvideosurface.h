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


#ifndef HBQT_QABSTRACTVIDEOSURFACE_H
#define HBQT_QABSTRACTVIDEOSURFACE_H

#include <QtCore/QTimer>
#include <QtCore/QDebug>

#include <QtGui/QImage>
#include <QtGui/QPainter>

#include <QtWidgets/QApplication>
#include <QtWidgets/QWidget>

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>

#include <QtMultimedia/QVideoFrame>
#include <QtMultimedia/QVideoSurfaceFormat>
#include <QtMultimedia/QAbstractVideoSurface>
#include <QtMultimedia/QVideoRendererControl>
#include <QtMultimedia/QCamera>
#include <QtMultimedia/QVideoProbe>
#include <QtMultimedia/QMediaPlayer>
#include <QtMultimedia/QCameraViewfinderSettings>

#include <QtMultimediaWidgets/QCameraViewfinder>


#include "hbqt_hbqzxing.h"


#if QT_VERSION >= 0x040700 && QT_VERSION < 0x050000
#include <QtDeclarative>
#elif QT_VERSION >= 0x050000
#include <QtQml/qqml.h>
#endif



class HBQAbstractVideoSurface : public QAbstractVideoSurface
{
   Q_OBJECT

   Q_PROPERTY( QObject * decoder READ getDecoder WRITE setDecoder );
   Q_PROPERTY( QObject * source  READ getSource WRITE setSource );

public:
    HBQAbstractVideoSurface( QObject * parent = 0 );
    ~HBQAbstractVideoSurface();

    bool start( const QVideoSurfaceFormat &format );

    bool present( const QVideoFrame &frame );

    QList< QVideoFrame::PixelFormat > supportedPixelFormats(
                QAbstractVideoBuffer::HandleType handleType = QAbstractVideoBuffer::NoHandle ) const;

    static void registerQMLTypes()
    {
        qmlRegisterType<HBQAbstractVideoSurface>("HBQAbstractVideoSurface", 1, 0, "HBQAbstractVideoSurface");
    }


public slots:
    QObject * getDecoder(){ return m_decoder; } 
    void setDecoder( QObject * decoder );

    QObject * getSource(){ return m_source; } 
    void setSource( QObject * src );
    void detectBarCodes(const QVideoFrame & frame);

signals:
    void imageCaptured(QImage image);
    void imageAvailable(QImage image);
    void imageAvailableEx();
    void currentAction(int action);

private:
    QVideoFrame m_frame;
    QImage::Format m_imageFormat;
    QVideoSurfaceFormat m_videoFormat;
    QTimer * timer;
    QObject * m_source;
    QCamera * m_camera;
    QVideoProbe * m_probe;
    QObject * m_decoder;
    QZXing * m_qzxing;
    bool m_decoding;
};

#endif // HBQT_QABSTRACTVIDEOSURFACE_H

