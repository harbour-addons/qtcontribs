#include "imagehandler.h"
#include "hbqt_qquickpainteditem.h"
#include <QtWidgets/QGraphicsObject>
#include <QtGui/QImage>
#include <QtGui/QPainter>
#include <QtWidgets/QStyleOptionGraphicsItem>
#include <QtCore/QDebug>
#include <QtQuick/QQuickPaintedItem>


ImageHandler::ImageHandler(QObject *parent) :
    QObject(parent)
{
}


QImage ImageHandler::extractQImage(QObject *imageObj,
                                   const double offsetX, const double offsetY,
                                   const double width, const double height)
{
    HBQQuickPaintedItem *item = static_cast< HBQQuickPaintedItem* >( imageObj );

    if( ! item )
    {
        qDebug() << "Item is NULL";
        return QImage();
    }
    QImage img( item->boundingRect().size().toSize(), QImage::Format_RGB32 );
    img.fill( QColor( 255, 255, 255 ).rgb() );
    QPainter painter( &img );

    item->paint( &painter );

    if( offsetX == 0 && offsetY == 0 && width == 0 && height == 0 )
        return img;
    else
    {
        return img.copy( offsetX, offsetY, width, height );
    }
}


void ImageHandler::save(QObject *imageObj, const QString &path,
                        const double offsetX, const double offsetY,
                        const double width, const double height)
{
    QImage img = extractQImage(imageObj, offsetX, offsetY, width, height);
    img.save(path);
}
