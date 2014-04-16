/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * QT wrapper main header
 *
 * Copyright 2009 Marcos Antonio Gambeta (marcosgambeta at gmail dot com)
 * Copyright 2014 Pritpal Bedi (bedipritpal@hotmail.com)
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

#if QT_VERSION >= 0x050200

#include <QtCore/QString>
#include <QtBluetooth/QBluetoothDeviceInfo>
#include <QtBluetooth/QBluetoothServiceInfo>
#include <QtBluetooth/QBluetoothAddress>
#include <QtBluetooth/QBluetoothTransferReply>

/*----------------------------------------------------------------------*/

HB_EXTERN_BEGIN

extern void hbqt_del_QBluetoothDeviceInfo( void * pObj, int iFlags );
extern void hbqt_del_QBluetoothServiceInfo( void * pObj, int iFlags );
extern void hbqt_del_QBluetoothAddress( void * pObj, int iFlags );

HB_EXTERN_END


static void hbqt_SlotsExecQBluetoothDeviceInfo( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QBluetoothDeviceInfo( ( *reinterpret_cast< QBluetoothDeviceInfo( * ) >( arguments[ 1 ] ) ) ), "HB_QBLUETOOTHDEVICEINFO", hbqt_del_QBluetoothDeviceInfo, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQBluetoothServiceInfo( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QBluetoothServiceInfo( ( *reinterpret_cast< QBluetoothServiceInfo( * ) >( arguments[ 1 ] ) ) ), "HB_QBLUETOOTHSERVICEINFO", hbqt_del_QBluetoothServiceInfo, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQBluetoothAddress( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QBluetoothAddress( ( *reinterpret_cast< QBluetoothAddress( * ) >( arguments[ 1 ] ) ) ), "HB_QBLUETOOTHADDRESS", hbqt_del_QBluetoothAddress, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQBluetoothAddressQString( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QBluetoothAddress( ( *reinterpret_cast< QBluetoothAddress( * ) >( arguments[ 1 ] ) ) ), "HB_QBLUETOOTHADDRESS", hbqt_del_QBluetoothAddress, HBQT_BIT_OWNER );
   if( p0 )
   {
      QString text = *reinterpret_cast< QString( * ) >( arguments[ 2 ] );
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmPushString( text.toLatin1().data(), text.toLatin1().length() );
      hb_vmSend( 2 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQBluetoothAddressInt( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QBluetoothAddress( ( *reinterpret_cast< QBluetoothAddress( * ) >( arguments[ 1 ] ) ) ), "HB_QBLUETOOTHADDRESS", hbqt_del_QBluetoothAddress, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmPushInteger( *reinterpret_cast< int( * ) >( arguments[ 2 ] ) );
      hb_vmSend( 2 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQBluetoothTransferReply( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   void * obj = *reinterpret_cast< void*( * ) >( arguments[ 1 ] );
   if( obj )
   {
      PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, obj , "HB_QBLUETOOTHTRANSFERREPLY", NULL, HBQT_BIT_QOBJECT );
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


HB_FUNC_EXTERN( HB_QBLUETOOTHDEVICEINFO );
HB_FUNC_EXTERN( HB_QBLUETOOTHADDRESS );
HB_FUNC_EXTERN( HB_QBLUETOOTHSERVICEINFO );
HB_FUNC_EXTERN( HB_QBLUETOOTHTRANSFERREPLY );

void _hbqtgui_force_link_for_event( void )
{
   HB_FUNC_EXEC( HB_QBLUETOOTHDEVICEINFO );
   HB_FUNC_EXEC( HB_QBLUETOOTHADDRESS );
   HB_FUNC_EXEC( HB_QBLUETOOTHSERVICEINFO );
   HB_FUNC_EXEC( HB_QBLUETOOTHTRANSFERREPLY );
}

static void hbqt_registerCallbacks( void )
{
   hbqt_slots_register_callback( "QBluetoothDeviceInfo"                   , hbqt_SlotsExecQBluetoothDeviceInfo                  );
   hbqt_slots_register_callback( "QBluetoothServiceInfo"                  , hbqt_SlotsExecQBluetoothServiceInfo                 );
   hbqt_slots_register_callback( "QBluetoothAddress"                      , hbqt_SlotsExecQBluetoothAddress                     );
   hbqt_slots_register_callback( "QBluetoothAddress$QString"              , hbqt_SlotsExecQBluetoothAddressQString              );
   hbqt_slots_register_callback( "QBluetoothAddress$int"                  , hbqt_SlotsExecQBluetoothAddressInt                  );
   hbqt_slots_register_callback( "QBluetoothTransferReply*"               , hbqt_SlotsExecQBluetoothTransferReply               );
}

/*----------------------------------------------------------------------*/

HB_FUNC( __HBQTBLUETOOTH ) {;}

static void hbqt_lib_init( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );

   hbqt_registerCallbacks();
}

static void hbqt_lib_exit( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );
}

HB_CALL_ON_STARTUP_BEGIN( _hbqtbluetooth_init_ )
   hb_vmAtInit( hbqt_lib_init, NULL );
   hb_vmAtExit( hbqt_lib_exit, NULL );
HB_CALL_ON_STARTUP_END( _hbqtbluetooth_init_ )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup _hbqtbluetooth_init_
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( _hbqtbluetooth_init_ )
   #include "hbiniseg.h"
#endif

#endif
