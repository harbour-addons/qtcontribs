/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * QT wrapper source code
 *
 * Copyright 2012 Przemyslaw Czerpak (druzus/at/poczta.onet.pl)
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
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

/****************************************************************************
 **
 ** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
 ** All rights reserved.
 ** Contact: Nokia Corporation (qt-info@nokia.com)
 **
 ** This file is part of the demos of the Qt Toolkit.
 **
 ** $QT_BEGIN_LICENSE:LGPL$
 ** GNU Lesser General Public License Usage
 ** This file may be used under the terms of the GNU Lesser General Public
 ** License version 2.1 as published by the Free Software Foundation and
 ** appearing in the file LICENSE.LGPL included in the packaging of this
 ** file. Please review the following information to ensure the GNU Lesser
 ** General Public License version 2.1 requirements will be met:
 ** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
 **
 ** In addition, as a special exception, Nokia gives you certain additional
 ** rights. These rights are described in the Nokia Qt LGPL Exception
 ** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
 **
 ** GNU General Public License Usage
 ** Alternatively, this file may be used under the terms of the GNU General
 ** Public License version 3.0 as published by the Free Software Foundation
 ** and appearing in the file LICENSE.GPL included in the packaging of this
 ** file. Please review the following information to ensure the GNU General
 ** Public License version 3.0 requirements will be met:
 ** http://www.gnu.org/copyleft/gpl.html.
 **
 ** Other Usage
 ** Alternatively, this file may be used in accordance with the terms and
 ** conditions contained in a signed written agreement between you and Nokia.
 **
 **
 **
 **
 **
 ** $QT_END_LICENSE$
 **
 ****************************************************************************/

#include "hbqt_flickcharm.h"

#if QT_VERSION >= 0x050000
#include <QtWidgets/QAbstractScrollArea>
#include <QtWidgets/QApplication>
#include <QtWidgets/QScrollBar>
#else
#include <QtGui/QAbstractScrollArea>
#include <QtGui/QApplication>
#include <QtGui/QScrollBar>
#endif
#include <QtGui/QMouseEvent>

#include <QtCore/QEvent>
#include <QtCore/QBasicTimer>
#include <QtCore/QHash>
#include <QtCore/QList>
#include <QtCore/QTime>
#include <QtCore/QDebug>

#if QT_VERSION >= 0x050000
#define __USETOUCHEVENTS__
#endif

#ifdef __USETOUCHEVENTS__
   #define BUTTON_PRESS    QEvent::TouchBegin
   #define BUTTON_MOVE     QEvent::TouchUpdate
   #define BUTTON_RELEASE  QEvent::TouchEnd
#else
   #define BUTTON_PRESS    QEvent::MouseButtonPress
   #define BUTTON_MOVE     QEvent::MouseMove
   #define BUTTON_RELEASE  QEvent::MouseButtonRelease
#endif


const int fingerAccuracyThreshold = 3;

struct FlickData {
   typedef enum {
      Steady,                // Interaction without scrolling
      ManualScroll,          // Scrolling manually with the finger on the screen
      AutoScroll,            // Scrolling automatically
      AutoScrollAcceleration // Scrolling automatically but a finger is on the screen
   } State;
   State state;
   QWidget *widget;
   QPoint pressPos;
   QPoint lastPos;
   QPoint speed;
   QTime speedTimer;
   QList<QEvent*> ignored;
   QTime accelerationTimer;
   bool lastPosValid:1;
   bool waitingAcceleration:1;
   QEvent::Type lastEvent;

   FlickData()
      : lastPosValid(false)
      , waitingAcceleration(false)
      , lastEvent(QEvent::None)
   {}

   void resetSpeed()
   {
      speed = QPoint();
      lastPosValid = false;
   }
   void updateSpeed(const QPoint &newPosition)
   {
      if (lastPosValid) {
         const int timeElapsed = speedTimer.elapsed();
         if (timeElapsed) {
            const QPoint newPixelDiff = (newPosition - lastPos);
            const QPoint pixelsPerSecond = newPixelDiff * (1000 / timeElapsed);
            // fingers are inacurates, we ignore small changes to avoid stopping the autoscroll because
            // of a small horizontal offset when scrolling vertically
            const int newSpeedY = (qAbs(pixelsPerSecond.y()) > fingerAccuracyThreshold) ? pixelsPerSecond.y() : 0;
            const int newSpeedX = (qAbs(pixelsPerSecond.x()) > fingerAccuracyThreshold) ? pixelsPerSecond.x() : 0;
            if (state == AutoScrollAcceleration) {
               const int max = 4000; // px by seconds
               const int oldSpeedY = speed.y();
               const int oldSpeedX = speed.x();
               if ((oldSpeedY <= 0 && newSpeedY <= 0) ||  ( (oldSpeedY >= 0 && newSpeedY >= 0)
                  && (oldSpeedX <= 0 && newSpeedX <= 0) ) ||  (oldSpeedX >= 0 && newSpeedX >= 0)) {
                  speed.setY(qBound(-max, (oldSpeedY + (newSpeedY / 4)), max));
                  speed.setX(qBound(-max, (oldSpeedX + (newSpeedX / 4)), max));
               } else {
                  speed = QPoint();
               }
            } else {
               const int max = 2500; // px by seconds
               // we average the speed to avoid strange effects with the last delta
               if (!speed.isNull()) {
                  speed.setX(qBound(-max, (speed.x() / 4) + (newSpeedX * 3 / 4), max));
                  speed.setY(qBound(-max, (speed.y() / 4) + (newSpeedY * 3 / 4), max));
               } else {
                  speed = QPoint(newSpeedX, newSpeedY);
               }
            }
         }
      } else {
         lastPosValid = true;
      }
      speedTimer.start();
      lastPos = newPosition;
   }

   // scroll by dx, dy
   // return true if the widget was scrolled
   bool scrollWidget(const int dx, const int dy)
   {
      Q_UNUSED( dx );

      QAbstractScrollArea *scrollArea = qobject_cast<QAbstractScrollArea*>(widget);
      if (scrollArea) {
         const int x = scrollArea->horizontalScrollBar()->value();
         const int y = scrollArea->verticalScrollBar()->value();
         scrollArea->horizontalScrollBar()->setValue(x - dx);
         scrollArea->verticalScrollBar()->setValue(y - dy);
         return (scrollArea->horizontalScrollBar()->value() != x
                 || scrollArea->verticalScrollBar()->value() != y);
      }
      return false;
   }

   bool scrollTo(const QPoint &newPosition)
   {
      const QPoint delta = newPosition - lastPos;
      updateSpeed(newPosition);
      return scrollWidget(delta.x(), delta.y());
   }
};

class FlickCharmPrivate
{
public:
   QHash<QWidget*, FlickData*> flickData;
   QBasicTimer ticker;
   QTime timeCounter;
   void startTicker(QObject *object)
   {
      if (!ticker.isActive())
         ticker.start(15, object);
      timeCounter.start();
   }
};

HBQFlickCharm::HBQFlickCharm(QObject *parent): QObject(parent)
{
   d = new FlickCharmPrivate;
}

HBQFlickCharm::~HBQFlickCharm()
{
   delete d;
}

void HBQFlickCharm::activateOn(QWidget *widget)
{
   QAbstractScrollArea *scrollArea = qobject_cast<QAbstractScrollArea*>(widget);
   if (scrollArea) {
      scrollArea->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
      scrollArea->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);

      QWidget *viewport = scrollArea->viewport();

      viewport->installEventFilter(this);
      scrollArea->installEventFilter(this);

      d->flickData.remove(viewport);
      d->flickData[viewport] = new FlickData;
      d->flickData[viewport]->widget = widget;
      d->flickData[viewport]->state = FlickData::Steady;

      return;
   }
}

void HBQFlickCharm::deactivateFrom(QWidget *widget)
{
   QAbstractScrollArea *scrollArea = qobject_cast<QAbstractScrollArea*>(widget);
   if (scrollArea) {
      QWidget *viewport = scrollArea->viewport();

      viewport->removeEventFilter(this);
      scrollArea->removeEventFilter(this);

      delete d->flickData[viewport];
      d->flickData.remove(viewport);

      return;
   }
}

static QPoint deaccelerate(const QPoint &speed, const int deltatime)
{
   const int deltaSpeed = deltatime;

   int x = speed.x();
   int y = speed.y();
   x = (x == 0) ? x : (x > 0) ? qMax(0, x - deltaSpeed) : qMin(0, x + deltaSpeed);
   y = (y == 0) ? y : (y > 0) ? qMax(0, y - deltaSpeed) : qMin(0, y + deltaSpeed);
   return QPoint(x, y);
}

bool HBQFlickCharm::eventFilter(QObject *object, QEvent *event)
{
   if (!object->isWidgetType())
      return false;

   const QEvent::Type type = event->type();

   switch (type) {
   case BUTTON_PRESS:
   case BUTTON_MOVE:
   case BUTTON_RELEASE:
      break;
   default:
      return false;
   }

   QPoint globalPos, pos;

#ifdef __USETOUCHEVENTS__
   QTouchEvent* const mouseEvent = static_cast<QTouchEvent*>( event );
   QTouchEvent::TouchPoint point( mouseEvent->touchPoints()[0] );
   globalPos = QPoint( ( int ) point.screenPos().x(), ( int ) point.screenPos().y() );
   pos =  QPoint( ( int ) point.pos().x(), ( int ) point.pos().y() );
#else
   QMouseEvent* const mouseEvent = static_cast<QMouseEvent*>(event);
   if (type == QEvent::MouseMove && mouseEvent->buttons() != Qt::LeftButton)
      return false;
   if (mouseEvent->modifiers() != Qt::NoModifier)
      return false;
   globalPos = mouseEvent->globalPos();
   pos = mouseEvent->pos();
#endif

   QWidget *viewport = qobject_cast<QWidget*>( object );
   FlickData *data = d->flickData.value( viewport );
   if( ! viewport || !data || data->ignored.removeAll( event ) )
       return false;

   if( data->lastEvent == BUTTON_PRESS && type == BUTTON_RELEASE )
   {
       data->state = FlickData::Steady;
       data->lastPosValid = false;
       return false;
   }
   data->lastEvent = type;

   const QPoint mousePos = pos;
   bool consumed = false;
   switch (data->state) {

   case FlickData::Steady:
      if (type == BUTTON_PRESS) {
         consumed = true;
         data->pressPos = mousePos;
      } else if (type == BUTTON_RELEASE) {
         consumed = true;
#ifdef __USETOUCHEVENTS__
        QTouchEvent* mousePress = new QTouchEvent( QEvent::TouchBegin, mouseEvent->device(), Qt::NoModifier, 0, mouseEvent->touchPoints() );
        QTouchEvent* mouseRelease = new QTouchEvent( QEvent::TouchEnd, mouseEvent->device(), Qt::NoModifier, 0, mouseEvent->touchPoints() );
#else
        QMouseEvent* mousePress = new QMouseEvent(QEvent::MouseButtonPress,
           data->pressPos, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
        QMouseEvent* mouseRelease = new QMouseEvent(QEvent::MouseButtonRelease,
           data->pressPos, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
#endif

         data->ignored << mousePress;
         data->ignored << mouseRelease;
         QApplication::postEvent(object, mousePress);
         QApplication::postEvent(object, mouseRelease);
      } else if (type == BUTTON_MOVE) {
         consumed = true;
         data->scrollTo(mousePos);

         const QPoint delta = mousePos - data->pressPos;
         if (delta.x() > fingerAccuracyThreshold || delta.y() > fingerAccuracyThreshold)
            data->state = FlickData::ManualScroll;
      }
      break;

   case FlickData::ManualScroll:
      if (type == BUTTON_MOVE) {
         consumed = true;
         data->scrollTo(mousePos);
      } else if (type == BUTTON_RELEASE) {
         consumed = true;
         data->state = FlickData::AutoScroll;
         data->lastPosValid = false;
         d->startTicker(this);
      }
      break;

   case FlickData::AutoScroll:
      if (type == BUTTON_PRESS) {
         consumed = true;
         data->state = FlickData::AutoScrollAcceleration;
         data->waitingAcceleration = true;
         data->accelerationTimer.start();
         data->updateSpeed(mousePos);
         data->pressPos = mousePos;
      } else if (type == BUTTON_RELEASE) {
         consumed = true;
         data->state = FlickData::Steady;
         data->resetSpeed();
      }
      break;

   case FlickData::AutoScrollAcceleration:
      if (type == BUTTON_MOVE) {
         consumed = true;
         data->updateSpeed(mousePos);
         data->accelerationTimer.start();
         if (data->speed.isNull())
             data->state = FlickData::ManualScroll;
      } else if (type == BUTTON_RELEASE) {
         consumed = true;
         data->state = FlickData::AutoScroll;
         data->waitingAcceleration = false;
         data->lastPosValid = false;
      }
      break;
   default:
      break;
   }
   data->lastPos = mousePos;
   Q_UNUSED( consumed );
   return true;
}

void HBQFlickCharm::timerEvent(QTimerEvent *event)
{
   int count = 0;
   QHashIterator<QWidget*, FlickData*> item(d->flickData);
   while (item.hasNext()) {
      item.next();
      FlickData *data = item.value();
      if (data->state == FlickData::AutoScrollAcceleration
         && data->waitingAcceleration
         && data->accelerationTimer.elapsed() > 40) {
         data->state = FlickData::ManualScroll;
         data->resetSpeed();
      }
      if (data->state == FlickData::AutoScroll || data->state == FlickData::AutoScrollAcceleration) {
         const int timeElapsed = d->timeCounter.elapsed();
         const QPoint delta = (data->speed) * timeElapsed / 1000;
         bool hasScrolled = data->scrollWidget(delta.x(), delta.y());

         if (data->speed.isNull() || !hasScrolled)
             data->state = FlickData::Steady;
         else
             count++;
         data->speed = deaccelerate(data->speed, timeElapsed);
      }
   }

   if (!count)
      d->ticker.stop();
   else
      d->timeCounter.start();

   QObject::timerEvent(event);
}

