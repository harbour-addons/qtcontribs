/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2009-2016 Pritpal Bedi <bedipritpal@hotmail.com>
 * Copyright 2010 Carlos Bacco <carlosbacco at gmail.com>
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

#if QT_VERSION >= 0x040500

#include "hbqt_hbqabstractitemmodel.h"

#include <QtGui/QIcon>
#include <QtGui/QFont>
#include <QtGui/QPixmap>
#include <QtCore/QFlags>
#include <QtCore/QDate>
#include <QtCore/QDateTime>
#include <QtCore/QString>
#include <QtCore/QModelIndex>

#if QT_VERSION <= 0x040900
#include <QtGui/QWidget>
#else
#include <QtWidgets/QWidget>
#endif

static QVariant hbqt_fetchData( PHB_ITEM block, int type, int role, int par1, int par2 )
{
   QVariant vv;

   if( hb_vmRequestReenter() )
   {
      PHB_ITEM p0 = hb_itemPutNI( NULL, type );
      PHB_ITEM p1 = hb_itemPutNI( NULL, role );
      PHB_ITEM p2 = hb_itemPutNI( NULL, par1 );
      PHB_ITEM p3 = hb_itemPutNI( NULL, par2 );

      PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( block, 4, p0, p1, p2, p3 ) );

      hb_itemRelease( p0 );
      hb_itemRelease( p1 );
      hb_itemRelease( p2 );
      hb_itemRelease( p3 );

      if( hb_itemType( ret ) & HB_IT_STRING )
      {
         void * pText01 = NULL;
         vv = hb_itemGetStrUTF8( ret, &pText01, NULL );
         hb_strfree( pText01 );
         HB_TRACE( HB_TR_DEBUG, ( "   fetchData[ s = %s ]", hb_itemGetCPtr( ret ) ) );
      }
      else if( hb_itemType( ret ) & HB_IT_LOGICAL )
      {
         vv = hb_itemGetL( ret );
         HB_TRACE( HB_TR_DEBUG, ( "   fetchData[ l = %i ]", hb_itemGetL( ret ) ) );
      }
      else if( hb_itemType( ret ) & HB_IT_DOUBLE  )
      {
         vv = hb_itemGetND( ret );
         HB_TRACE( HB_TR_DEBUG, ( "   fetchData[ d = %f ]", hb_itemGetND( ret ) ) );
      }
      else if( hb_itemType( ret ) & HB_IT_NUMERIC )
      {
         vv = hb_itemGetNI( ret );
         HB_TRACE( HB_TR_DEBUG, ( "   fetchData[ n = %i ]", hb_itemGetNI( ret ) ) );
      }
      else if( hb_itemType( ret ) & HB_IT_OBJECT )
      {
         void * p = hbqt_get_ptr( ret );

         if( hbqt_obj_isDerivedFrom( ret, "QBRUSH" ) )
            vv = * ( ( QBrush * ) ( p ) );
         else if( hbqt_obj_isDerivedFrom( ret, "QCOLOR" ) )
            vv = * ( ( QColor * ) ( p ) );
         else if( hbqt_obj_isDerivedFrom( ret, "QICON" ) )
            vv = * ( ( QIcon * ) ( p ) );
         else if( hbqt_obj_isDerivedFrom( ret, "QSIZE" ) )
            vv = * ( ( QSize * ) ( p ) );
         else if( hbqt_obj_isDerivedFrom( ret, "QFONT" ) )
            vv = * ( ( QFont * ) ( p ) );
         else if( hbqt_obj_isDerivedFrom( ret, "QPIXMAP" ) )
            vv = * ( ( QPixmap * ) ( p ) );
      }

      hb_itemRelease( ret );
      hb_vmRequestRestore();
   }

   return vv;
}

static bool hbqt_setData( PHB_ITEM block, int type, int role, int iRow, int iCol, const QVariant & qVariantObj )
{
   bool bRet = false;

   if( hb_vmRequestReenter() )
   {
      PHB_ITEM p0 = hb_itemPutNI( NULL, type );
      PHB_ITEM p1 = hb_itemPutNI( NULL, role );
      PHB_ITEM p2 = hb_itemPutNI( NULL, iRow );
      PHB_ITEM p3 = hb_itemPutNI( NULL, iCol );
      PHB_ITEM p4;

      switch( qVariantObj.type() )
      {
         case QVariant::Bool:
         {
            p4 = hb_itemPutL( NULL, qVariantObj.toBool() );
         }
         break;

         case QVariant::Char:
         case QVariant::String:
         {
            QString qS;
            qS = qVariantObj.toString();
            p4 = hb_itemPutStrLenUTF8( NULL, qS.toUtf8().constData(), qS.size() );
         }
         break;

         case QVariant::Date:
         {
            QDate qD;
            qD = qVariantObj.toDate();
            p4 = hb_itemPutDL( NULL, qD.toJulianDay() );
         }
         break;
#if QT_VERSION >= 0x040900
         case QVariant::DateTime:
         {
            QDateTime qDT;
            QDate qD;
            qDT = qVariantObj.toDateTime();
            qD = qDT.date();
            p4 = hb_itemPutTDT( NULL, qD.toJulianDay(), qDT.time().msecsSinceStartOfDay());
         }
         break;
#endif
         case QVariant::LongLong:
         case QVariant::ULongLong:
         {
            p4 = hb_itemPutNLL( NULL, qVariantObj.toLongLong() );
         }
         break;

         case QVariant::Int:
         case QVariant::UInt:
         {
            p4 = hb_itemPutNI( NULL, qVariantObj.toInt() );
         }
         break;

         case QVariant::Double:
         {
            p4 = hb_itemPutND( NULL, qVariantObj.toDouble() );
         }
         break;
#if QT_VERSION >= 0x040900
         case QVariant::ModelIndex:
         {
            QModelIndex qMI;
            PHB_ITEM pRow;
            PHB_ITEM pCol;
            qMI = qVariantObj.toModelIndex();
            pRow = hb_itemPutNI( NULL, qMI.row() );
            pCol = hb_itemPutNI( NULL, qMI.column() );
            p4 = hb_itemArrayNew( 2 );
            hb_itemArrayPut( p4, 1, pRow );
            hb_itemArrayPut( p4, 2, pCol );
            hb_itemRelease( pCol );
            hb_itemRelease( pRow );
         }
         break;
#endif
         default:
            p4 = NULL;
      }

      if( p4 )
      {
         PHB_ITEM ret = hb_itemNew( hb_vmEvalBlockV( block, 5, p0, p1, p2, p3, p4 ) );
         hb_itemRelease( p4 );
         if( hb_itemType( ret ) & HB_IT_LOGICAL )
            bRet = hb_itemGetL( ret );
      }
      hb_itemRelease( p3 );
      hb_itemRelease( p2 );
      hb_itemRelease( p1 );
      hb_itemRelease( p0 );

      hb_vmRequestRestore();
   }

   return bRet;
}

HBQAbstractItemModel::HBQAbstractItemModel( PHB_ITEM pBlock ) : QAbstractItemModel()
{
   if( pBlock )
   {
      block = hb_itemNew( pBlock );
   }
}

HBQAbstractItemModel::~HBQAbstractItemModel( void )
{
   HB_TRACE( HB_TR_DEBUG, ( "HBQAbstractItemModel::~HBQAbstractItemModel( void )" ) );
   if( block )
   {
      hb_itemRelease( block );
      block = NULL;
   }
}

Qt::ItemFlags HBQAbstractItemModel::flags( const QModelIndex & index ) const
{
   if( ! index.isValid() )
      return 0;

   QVariant ret = hbqt_fetchData( block, HBQT_QAIM_flags, 0, index.column(), index.row() );
   if( ! ret.isValid() )
      return Qt::ItemIsEnabled | Qt::ItemIsSelectable;

   return ( QFlags<Qt::ItemFlag> ) ret.toInt();
}

QVariant HBQAbstractItemModel::data( const QModelIndex & index, int role ) const
{
   if( ! index.isValid() )
      return QVariant();

   return hbqt_fetchData( block, HBQT_QAIM_data, role, index.column(), index.row() );
}

bool HBQAbstractItemModel::setData( const QModelIndex & index, const QVariant & value, int role )
{
   if( ! index.isValid() )
      return false;

   bool ret = hbqt_setData( block, HBQT_QAIM_setdata, role, index.column(), index.row(), value );
   if( ret )
      emit QAbstractItemModel::dataChanged( index, index );

   return ret;
}

QVariant HBQAbstractItemModel::headerData( int section, Qt::Orientation orientation, int role ) const
{
   return hbqt_fetchData( block, HBQT_QAIM_headerData, role, orientation, section );
}

int HBQAbstractItemModel::rowCount( const QModelIndex & /*parent = QModelIndex()*/ ) const
{
   return hbqt_fetchData( block, HBQT_QAIM_rowCount, 0, 0, 0 ).toInt();
}

int HBQAbstractItemModel::columnCount( const QModelIndex & /*parent = QModelIndex()*/ ) const
{
   return hbqt_fetchData( block, HBQT_QAIM_columnCount, 0, 0, 0 ).toInt();
}

QModelIndex HBQAbstractItemModel::index( int row, int column, const QModelIndex & parent ) const
{
   HB_SYMBOL_UNUSED( parent );
   return createIndex( row, column );
}

QModelIndex HBQAbstractItemModel::parent( const QModelIndex & /* child */ ) const
{
   return QModelIndex();
}

void HBQAbstractItemModel::reset()
{
   emit QAbstractItemModel::layoutChanged();
}

#endif
