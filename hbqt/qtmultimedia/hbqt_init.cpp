/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * QT wrapper main header
 *
 * Copyright 2009-12 Pritpal Bedi (bedipritpal@hotmail.com)
 * Copyright 2010 Viktor Szakats (harbour syenar.net)
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

#include "hbgtinfo.ch"

#include "hbqt.h"
#include "hbqtinit.h"

#include "hbapierr.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbinit.h"

#if QT_VERSION >= 0x040500

#if QT_VERSION >= 0x050300
#include <QtCore/QStringList>

#include <QtMultimedia/QVideoSurfaceFormat>
#include <QtMultimedia/QAudioFormat>
#include <QtMultimedia/QMediaTimeRange>
#include <QtMultimedia/QVideoFrame>
#include <QtMultimedia/QAudioBuffer>
#include <QtMultimedia/QMediaContent>
#endif

HB_EXTERN_BEGIN

extern void hbqt_del_QVideoFrame( void * pObj, int iFlags );
extern void hbqt_del_QVideoSurfaceFormat( void * pObj, int iFlags );
extern void hbqt_del_QAudioFormat( void * pObj, int iFlags );
extern void hbqt_del_QMediaTimeRange( void * pObj, int iFlags );
extern void hbqt_del_QAudioBuffer( void * pObj, int iFlags );
extern void hbqt_del_QMediaContent( void * pObj, int iFlags );

HB_EXTERN_END

/*----------------------------------------------------------------------*/

#if QT_VERSION >= 0x050300

static void hbqt_SlotsExecIntQVideoFrame( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QVideoFrame( ( *reinterpret_cast< QVideoFrame( * ) >( arguments[ 2 ] ) ) ), "HB_QVIDEOFRAME", hbqt_del_QVideoFrame, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPushInteger( *reinterpret_cast< int( * ) >( arguments[ 1 ] ) );
      hb_vmPush( p0 );
      hb_vmSend( 2 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQVideoSurfaceFormat( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QVideoSurfaceFormat( ( *reinterpret_cast< QVideoSurfaceFormat( * ) >( arguments[ 1 ] ) ) ), "HB_QVIDEOSURFACEFORMAT", hbqt_del_QVideoSurfaceFormat, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQAudioFormat( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QAudioFormat( ( *reinterpret_cast< QAudioFormat( * ) >( arguments[ 1 ] ) ) ), "HB_QAUDIOFORMAT", hbqt_del_QAudioFormat, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQMediaTimeRange( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QMediaTimeRange( ( *reinterpret_cast< QMediaTimeRange( * ) >( arguments[ 1 ] ) ) ), "HB_QMEDIATIMERANGE", hbqt_del_QMediaTimeRange, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQVideoFrame( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QVideoFrame( ( *reinterpret_cast< QVideoFrame( * ) >( arguments[ 1 ] ) ) ), "HB_QVIDEOFRAME", hbqt_del_QVideoFrame, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQAudioBuffer( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QAudioBuffer( ( *reinterpret_cast< QAudioBuffer( * ) >( arguments[ 1 ] ) ) ), "HB_QAUDIOBUFFER", hbqt_del_QAudioBuffer, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

static void hbqt_SlotsExecQMediaContent( PHB_ITEM * codeBlock, void ** arguments, QStringList pList )
{
   Q_UNUSED( pList );
   PHB_ITEM p0 = hbqt_bindGetHbObject( NULL, new QMediaContent( ( *reinterpret_cast< QMediaContent( * ) >( arguments[ 1 ] ) ) ), "HB_QMEDIACONTENT", hbqt_del_QMediaContent, HBQT_BIT_OWNER );
   if( p0 )
   {
      hb_vmPushEvalSym();
      hb_vmPush( codeBlock );
      hb_vmPush( p0 );
      hb_vmSend( 1 );
      hb_itemRelease( p0 );
   }
}

#endif

/*----------------------------------------------------------------------*/

static void hbqt_registerCallbacks( void )
{
#if QT_VERSION >= 0x050300
   hbqt_slots_register_callback( "int$QVideoFrame"                           , hbqt_SlotsExecIntQVideoFrame                   );
   hbqt_slots_register_callback( "QVideoSurfaceFormat"                       , hbqt_SlotsExecQVideoSurfaceFormat              );
   hbqt_slots_register_callback( "QAudioFormat"                              , hbqt_SlotsExecQAudioFormat                     );
   hbqt_slots_register_callback( "QMediaTimeRange"                           , hbqt_SlotsExecQMediaTimeRange                  );
   hbqt_slots_register_callback( "QVideoFrame"                               , hbqt_SlotsExecQVideoFrame                      );
   hbqt_slots_register_callback( "QAudioBuffer"                              , hbqt_SlotsExecQAudioBuffer                     );
   hbqt_slots_register_callback( "QMediaContent"                             , hbqt_SlotsExecQMediaContent                    );
#endif
}

/*----------------------------------------------------------------------*/

HB_FUNC( __HBQTMULTIMEDIA ) {;}

static void hbqt_lib_init( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );

   hbqt_registerCallbacks();
}

static void hbqt_lib_exit( void * cargo )
{
   HB_SYMBOL_UNUSED( cargo );
}

HB_CALL_ON_STARTUP_BEGIN( _hbqtmultimedia_init_ )
   hb_vmAtInit( hbqt_lib_init, NULL );
   hb_vmAtExit( hbqt_lib_exit, NULL );
HB_CALL_ON_STARTUP_END( _hbqtmultimedia_init_ )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup _hbqtmultimedia_init_
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( _hbqtmultimedia_init_ )
   #include "hbiniseg.h"
#endif

#endif
