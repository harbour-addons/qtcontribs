/*
 * $Id$
 */

/*
 * Copyright 2009-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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

#include "hbclass.ch"
#include "error.ch"
#include "hbtrace.ch"


CREATE CLASS HbQtObjectHandler

   VAR    __hEvents

   VAR    __Slots
   VAR    __Events

   VAR    pPtr
   ACCESS pointer()                               INLINE ::pPtr
   METHOD getPointer()

   METHOD connect( cnEvent, bBlock )
   METHOD disconnect( cnEvent )
   METHOD setSlots()
   METHOD setEvents()
   METHOD findChild( cObjectName )
   METHOD isConnected( cnEvent )
   METHOD initialize()
   METHOD connectClose( bBlock )

   DESTRUCTOR FUNCTION __hbqt_destroy()
   ERROR HANDLER onError()

   ENDCLASS


METHOD HbQtObjectHandler:initialize()
   IF Empty( ::__hEvents )
      ::__hEvents := {=>}
      hb_HCaseMatch( ::__hEvents, .F. )
   ENDIF
   RETURN Self


METHOD HbQtObjectHandler:findChild( cObjectName )

   IF ! __objDerivedFrom( Self, "QOBJECT" )
      RETURN NIL
   ENDIF

   RETURN __hbqt_findChild( Self, cObjectName )


METHOD HbQtObjectHandler:setSlots()

   IF empty( ::__Slots )
      ::__Slots := { => }
      hb_hDefault( ::__Slots, {} )
   ENDIF

   RETURN Self


METHOD HbQtObjectHandler:setEvents()

   IF empty( ::__Events )
      ::__Events := { => }
      hb_hDefault( ::__Events, {} )
   ENDIF

   RETURN Self


METHOD HbQtObjectHandler:onError()
   LOCAL cMsg := __GetMessage()
   LOCAL oError, oObj

   IF SubStr( cMsg, 1, 1 ) == "_"
      cMsg := SubStr( cMsg, 2 )
   ENDIF
   IF ! Empty( oObj := ::findChild( cMsg ) )
      RETURN oObj
   ENDIF

   oError := ErrorNew()

   oError:severity    := ES_ERROR
   oError:genCode     := EG_NOMETHOD
   oError:subSystem   := "HBQT"
   oError:subCode     := 1000
   oError:canRetry    := .F.
   oError:canDefault  := .F.
   oError:Args        := hb_AParams()
   oError:operation   := ProcName()
   oError:Description := "Message not found..:" + cMsg

   Eval( ErrorBlock(), oError )

   RETURN NIL


METHOD HbQtObjectHandler:isConnected( cnEvent )
   ::initialize()
   RETURN hb_hHasKey( ::__hEvents, cnEvent )


METHOD HbQtObjectHandler:connect( cnEvent, bBlock )
   LOCAL nResult

   ::initialize()
   IF ! __objDerivedFrom( Self, "QOBJECT" )
      RETURN .f.
   ENDIF

   IF ! HB_ISBLOCK( bBlock )
      RETURN .f.
   ENDIF

   IF hb_hHasKey( ::__hEvents, cnEvent )
      IF HB_ISNUMERIC( ::__hEvents[ cnEvent ] )
         hbqt_disconnectEvent( Self, cnEvent )
      ELSE
         hbqt_disconnect( Self, cnEvent )
      ENDIF
      hb_hDel( ::__hEvents, cnEvent )
   ENDIF

   SWITCH ValType( cnEvent )
   CASE "C"
      nResult := hbqt_connect( Self, cnEvent, bBlock )

      SWITCH nResult
      CASE 0
         ::__hEvents[ cnEvent ] := cnEvent
         RETURN .T.
      CASE 8 /* QT connect call failure */
         RETURN .F.
      ENDSWITCH
      EXIT

   CASE "N"
      nResult := hbqt_connectEvent( Self, cnEvent, bBlock )

      SWITCH nResult
      CASE 0
         ::__hEvents[ cnEvent ] := cnEvent
         RETURN .T.
      CASE -3 /* bBlock not supplied */
         RETURN .F.
      ENDSWITCH
      EXIT

   OTHERWISE
      nResult := 99

   ENDSWITCH

   __hbqt_error( 1200 + nResult )
   RETURN .F.


METHOD HbQtObjectHandler:disconnect( cnEvent )
   LOCAL hEvent, xKey, nResult := 0

   ::initialize()
   IF ! __objDerivedFrom( Self, "QOBJECT" )
      RETURN .f.
   ENDIF

   IF PCount() == 0                               // Intent is to disconnect all connections.
      IF ! Empty( ::__hEvents )
         FOR EACH hEvent IN ::__hEvents
            xKey := hEvent:__enumKey()
            IF HB_ISNUMERIC( xKey )
               hbqt_disconnectEvent( Self, xKey )
            ELSE
               hbqt_disconnect( Self, xKey )
            ENDIF
            ::__hEvents[ xKey ] := NIL
         NEXT
         ::__hEvents := { => }
      ENDIF
      RETURN .T.
   ENDIF

   IF ! hb_hHasKey( ::__hEvents, cnEvent )
      RETURN .F.
   ENDIF

   SWITCH ValType( cnEvent )
   CASE "C"
      nResult := hbqt_disconnect( Self, cnEvent )

      SWITCH nResult
      CASE 0
      CASE 4 /* signal not found in object */
      CASE 5 /* disconnect failure */
         hb_hDel( ::__hEvents, cnEvent )
         RETURN .T.
      CASE 1 /* wrong slot container, no connect was called yet */
      CASE 2 /* object has been already freed */
      CASE 3 /* event not found */
         RETURN .F.
      ENDSWITCH
      EXIT

   CASE "N"
      nResult := hbqt_disconnectEvent( Self, cnEvent )

      SWITCH nResult
      CASE 0
         hb_hDel( ::__hEvents, cnEvent )
         RETURN .T.
      CASE -3 /* event not found */
      CASE -2 /* event not found */
      CASE -1 /* event not found */
         RETURN .F.
      ENDSWITCH
      EXIT

   OTHERWISE
      nResult := 99

   ENDSWITCH

   __hbqt_error( 1300 + nResult )
   RETURN .F.


METHOD HbQtObjectHandler:getPointer()
   ::pPtr := __hbqt_getptr( Self )
   RETURN ::pointer()


METHOD HbQtObjectHandler:connectClose( bBlock )
   LOCAL pPtr := __hbqt_getptr( Self )

   IF HB_ISPOINTER( pPtr )
      ::pPtr := pPtr
      RETURN ::connect( /*QEvent_Close*/ 19, {|| HbQtExitEx( ::pPtr, .T. ), QApplication():processEvents( 0 ), iif( HB_ISBLOCK( bBlock ), Eval( bBlock ), NIL ) } )
   ENDIF
   RETURN .F.


FUNCTION HbQtExitEx( cUnique, lExit, lDelete )
   STATIC s_lExit := {=>}

   IF HB_ISLOGICAL( lDelete )
      hb_HDel( s_lExit, cUnique )
   ENDIF
   IF HB_ISLOGICAL( lExit )
      s_lExit[ cUnique ] := lExit
   ENDIF
   RETURN iif( hb_HHasKey( s_lExit, cUnique ), s_lExit[ cUnique ], .F. )


FUNCTION HbQtExecEx( oWidget, bBlock )
   LOCAL oEventLoop

   IF ! HB_ISBLOCK( bBlock )
      bBlock := {|| .T. }
   ENDIF

   oEventLoop := QEventLoop()
   DO WHILE .T.
      oEventLoop:processEvents( 0 )
      Eval( bBlock )
      IF HbQtExitEx( oWidget:pointer() )
         HbQtExitEx( oWidget:pointer(), NIL, .T. )
         EXIT
      ENDIF
   ENDDO
   oEventLoop:exit( 0 )
   RETURN NIL



//--------------------------------------------------------------------//
//                          CLASS HbQtTouchPoint
//--------------------------------------------------------------------//

CLASS HbQtTouchPoint

   DATA   hData
   DATA   oRect

   METHOD init()

   ENDCLASS


METHOD HbQtTouchPoint:init()

   ::hData := {=>}
   hb_HKeepOrder( ::hData, .T. )
   hb_HCaseMatch( ::hData, .T. )

   RETURN Self

//--------------------------------------------------------------------//
//                     Hacks to Cover Qt 4.x
//--------------------------------------------------------------------//
#ifdef __HB_QT_MAJOR_VER_4__
FUNCTION QApplication_translate( p1, p2 )
   HB_SYMBOL_UNUSED( p1 )
   RETURN p2
#endif


