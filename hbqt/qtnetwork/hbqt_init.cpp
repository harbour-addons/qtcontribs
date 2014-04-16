/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * QT wrapper main header
 *
 * Copyright 2009 Marcos Antonio Gambeta (marcosgambeta at gmail dot com)
 * Copyright 2009 Pritpal Bedi (pritpal@vouchcac.com)
 * Copyright 2010 Viktor Szakats (harbour syenar.net)
 * Copyright 2010 Francesco Perillo ()
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

#include "hbqt.h"
#include "hbqtinit.h"

#include "hbapiitm.h"
#include "hbvm.h"
#include "hbinit.h"
#include "hbstack.h"

#if QT_VERSION <= 0x040900

#include <QtNetwork/QUrlInfo>
#include <QtNetwork/QNetworkProxy>
#include <QtNetwork/QHttpResponseHeader>
#include <QtNetwork/QNetworkRequest>

HB_EXTERN_BEGIN

extern void hbqt_del_QObject( void * pObj, int iFlags );
extern void hbqt_del_QHttpResponseHeader( void * pObj, int iFlags );
extern void hbqt_del_QNetworkRequest( void * pObj, int iFlags );
extern void hbqt_del_QNetworkProxy( void * pObj, int iFlags );
extern void hbqt_del_QUrlInfo( void * pObj, int iFlags );

HB_EXTERN_END



static void hbqt_SlotsExecQHttpResponseHeader( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );

   hb_vmPushEvalSym();
   hb_vmPush( codeBlock );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QHttpResponseHeader( ( *reinterpret_cast< QHttpResponseHeader( * ) >( arguments[ 1 ] ) ) ), "HB_QHTTPRESPONSEHEADER", hbqt_del_QHttpResponseHeader, HBQT_BIT_OWNER );
   hb_vmPush( p0 );
   hb_vmSend( 1 );
   hb_itemRelease( p0 );
}


static void hbqt_SlotsExecQNetworkProxyPointer( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );

   hb_vmPushEvalSym();
   hb_vmPush( codeBlock );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QNetworkProxy( ( *reinterpret_cast< QNetworkProxy( * ) >( arguments[ 1 ] ) ) ), "HB_QNETWORKPROXY", hbqt_del_QNetworkProxy, HBQT_BIT_OWNER );
   PHB_ITEM p1 = hbqt_bindGetHbObject( NULL, *reinterpret_cast< void*( * ) >( arguments[ 2 ] ), ( const char * ) pList.at( 1 ).data(), NULL, HBQT_BIT_QOBJECT );
   hb_vmPush( p0 );
   hb_vmPush( p1 );
   hb_vmSend( 2 );
   hb_itemRelease( p0 );
   hb_itemRelease( p1 );
}


static void hbqt_SlotsExecQNetworkRequest( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );

   hb_vmPushEvalSym();
   hb_vmPush( codeBlock );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QNetworkRequest( ( *reinterpret_cast< QNetworkRequest( * ) >( arguments[ 1 ] ) ) ), "HB_QNETWORKREQUEST", hbqt_del_QNetworkRequest, HBQT_BIT_OWNER );
   hb_vmPush( p0 );
   hb_vmSend( 1 );
   hb_itemRelease( p0 );
}


static void hbqt_SlotsExecQUrlInfo( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );

   hb_vmPushEvalSym();
   hb_vmPush( codeBlock );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QUrlInfo( ( *reinterpret_cast< QUrlInfo( * ) >( arguments[ 1 ] ) ) ), "HB_QURLINFO", hbqt_del_QUrlInfo, HBQT_BIT_OWNER );
   hb_vmPush( p0 );
   hb_vmSend( 1 );
   hb_itemRelease( p0 );
}


static void hbqt_registerCallbacks( void )
{
   hbqt_slots_register_callback( "QHttpResponseHeader"   , hbqt_SlotsExecQHttpResponseHeader  );
   hbqt_slots_register_callback( "QNetworkProxy$pointer" , hbqt_SlotsExecQNetworkProxyPointer );
   hbqt_slots_register_callback( "QNetworkRequest"       , hbqt_SlotsExecQNetworkRequest      );
   hbqt_slots_register_callback( "QUrlInfo"              , hbqt_SlotsExecQUrlInfo             );
}


#else


#include <QtNetwork/QNetworkProxy>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QAuthenticator>
#include <QtNetwork/QNetworkConfiguration>

HB_EXTERN_BEGIN

extern void hbqt_del_QNetworkProxy( void * pObj, int iFlags );
extern void hbqt_del_QNetworkReply( void * pObj, int iFlags );
extern void hbqt_del_QNetworkConfiguration( void * pObj, int iFlags );

HB_EXTERN_END


static void hbqt_SlotsExecQNetworkReply( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   void * obj = *reinterpret_cast< void*( * ) >( arguments[ 1 ] );
   if( obj )
   {
      PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, obj, "HB_QNETWORKREPLY", NULL, HBQT_BIT_QOBJECT );
      if( p0 )
      {
         hb_vmPushEvalSym();
         hb_vmPush( codeBlock );
         hb_vmPush( p0 );
         hb_vmSend( 1 );
         hb_itemRelease( p0 );
      }
   }
}

static void hbqt_SlotsExecQNetworkProxyQAuthenticator( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QNetworkProxy( ( *reinterpret_cast< QNetworkProxy( * ) >( arguments[ 1 ] ) ) ), "HB_QNETWORKPROXY", hbqt_del_QNetworkProxy, HBQT_BIT_OWNER );
   if( p0 )
   {
      void * obj = *reinterpret_cast< void*( * ) >( arguments[ 2 ] );
      if( obj )
      {
         PHB_ITEM p1 = hbqt_bindGetHbObject( NULL, obj, "HB_QAUTHENTICATOR", NULL, HBQT_BIT_QOBJECT );
         if( p1 )
         {
            hb_vmPushEvalSym();
            hb_vmPush( codeBlock );
            hb_vmPush( p0 );
            hb_vmPush( p1 );
            hb_vmSend( 2 );
            hb_itemRelease( p1 );
         }
      }
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQNetworkReplyQAuthenticator( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   void * obj = *reinterpret_cast< void*( * ) >( arguments[ 1 ] );
   if( obj )
   {
      PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, obj, "HB_QNETWORKREPLY", NULL, HBQT_BIT_QOBJECT );
      if( p0 )
      {
         void * obj1 = *reinterpret_cast< void*( * ) >( arguments[ 2 ] );
         if( obj1 )
         {
            PHB_ITEM p1 = hbqt_bindGetHbObject( NULL, obj1, "HB_QAUTHENTICATOR", NULL, HBQT_BIT_QOBJECT );
            if( p1 )
            {
               hb_vmPushEvalSym();
               hb_vmPush( codeBlock );
               hb_vmPush( p0 );
               hb_vmPush( p1 );
               hb_vmSend( 2 );
               hb_itemRelease( p1 );
            }
         }
         hb_itemRelease( p0 );
      }
   }
}

static void hbqt_SlotsExecQNetworkConfiguration( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QNetworkConfiguration( ( *reinterpret_cast< QNetworkConfiguration( * ) >( arguments[ 1 ] ) ) ), "HB_QNETWORKCONFIGURATION", hbqt_del_QNetworkConfiguration, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQNetworkConfigurationBool( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QNetworkConfiguration( ( *reinterpret_cast< QNetworkConfiguration( * ) >( arguments[ 1 ] ) ) ), "HB_QNETWORKCONFIGURATION", hbqt_del_QNetworkConfiguration, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmPushLogical( *reinterpret_cast< bool( * ) >( arguments[ 2 ] ) );
      hb_vmSend( 2 );
      hb_itemRelease( p0 );
   }
}


HB_FUNC_EXTERN( HB_QAUTHENTICATOR );

void _hbqtnetwork_force_link_for_event( void )
{
   HB_FUNC_EXEC( HB_QAUTHENTICATOR );
}


static void hbqt_registerCallbacks( void )
{
   hbqt_slots_register_callback( "QNetworkReply*"                  , hbqt_SlotsExecQNetworkReply                );
   hbqt_slots_register_callback( "QNetworkProxy$QAuthenticator*"   , hbqt_SlotsExecQNetworkProxyQAuthenticator  );
   hbqt_slots_register_callback( "QNetworkReply*$QAuthenticator*"  , hbqt_SlotsExecQNetworkReplyQAuthenticator  );
   hbqt_slots_register_callback( "QNetworkConfiguration"           , hbqt_SlotsExecQNetworkConfiguration        );
   hbqt_slots_register_callback( "QNetworkConfiguration$bool"      , hbqt_SlotsExecQNetworkConfigurationBool    );
}

#endif


HB_FUNC( __HBQTNETWORK ) {;}

static void hbqt_lib_init( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );

   hbqt_registerCallbacks();
}

static void hbqt_lib_exit( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );
}

HB_CALL_ON_STARTUP_BEGIN( _hbqtnetwork_init_ )
   hb_vmAtInit( hbqt_lib_init, NULL );
   hb_vmAtExit( hbqt_lib_exit, NULL );
HB_CALL_ON_STARTUP_END( _hbqtnetwork_init_ )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup _hbqtnetwork_init_
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( _hbqtnetwork_init_ )
   #include "hbiniseg.h"
#endif

