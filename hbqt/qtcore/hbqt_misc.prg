/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009-2014 Pritpal Bedi <pritpal@vouchcac.com>
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

   VAR    __hEvents  INIT { => }

   VAR    __Slots
   VAR    __Events

   METHOD connect( cnEvent, bBlock )
   METHOD disconnect( cnEvent )
   METHOD setSlots()
   METHOD setEvents()
   METHOD findChild( cObjectName )
   METHOD isConnected( cnEvent )

   DESTRUCTOR FUNCTION __hbqt_destroy()
   ERROR HANDLER onError()

   ENDCLASS


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
   RETURN hb_hHasKey( ::__hEvents, cnEvent )


METHOD HbQtObjectHandler:connect( cnEvent, bBlock )
   LOCAL nResult

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
      RETURN .f.
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

//--------------------------------------------------------------------//
//                                  .
//--------------------------------------------------------------------//

CLASS HbQtTouchPoint
   DATA   hData                                   INIT __hbqtStandardHash()
   DATA   oRect

   METHOD init()
   ENDCLASS


METHOD HbQtTouchPoint:init()
   RETURN Self

