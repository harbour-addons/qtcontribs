/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2019 Pritpal Bedi <bedipritpal@hotmail.com>
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

#include "common.ch"
#include "hbclass.ch"
#include "hbmxml.ch"


CLASS HbQtHttpClient

   METHOD init( cServer, nPort, cEndPoint )
   METHOD create( cServer, nPort, cEndPoint )
   METHOD request( cVerb, cEndPoint, xData )

   METHOD addQueryParam( cKey, xValue )           INLINE iif( HB_ISSTRING( cKey ) .AND. ! Empty( cKey ), ::hQuery[ cKey ] := xValue, NIL )
   METHOD addHeader( cKey, xValue )               INLINE iif( HB_ISSTRING( cKey ) .AND. ! Empty( cKey ), ::hHeaders[ cKey ] := xValue, NIL )

   METHOD setAccessID( cAccessID )                INLINE ::cAccessID := cAccessID
   METHOD setAccessKey( cAccessKey )              INLINE ::cAccessKey := cAccessKey
   METHOD setAuthBlock( bBlock )                  INLINE ::bAuthBlock := bBlock

   METHOD setDebugBlock( bBlock )                 INLINE ::bDebugBlock := bBlock, ::lDebug := HB_ISBLOCK( ::bDebugBlock )

   ACCESS raw()                                   INLINE ::cRaw
   ACCESS response()                              INLINE ::hRspns
   ACCESS responseHeaders()                       INLINE ::hRspnsHeaders
   ACCESS reply()                                 INLINE ::cReply
   ACCESS replyCode()                             INLINE ::nReplyCode
   ACCESS contentType()                           INLINE ::cContentType
   ACCESS error()                                 INLINE ::cError

   PROTECTED:

   DATA   cRaw                                    INIT ""
   DATA   cReply                                  INIT ""
   DATA   nReplyCode                              INIT ""
   DATA   cContentType                            INIT ""
   DATA   cError                                  INIT ""
   DATA   hRspnsHeaders                           INIT {=>}

   DATA   cServer                                 INIT ""
   DATA   nPort                                   INIT NIL
   DATA   cEndPoint                               INIT "/"
   DATA   cUrl                                    INIT ""
   DATA   oUrl
   DATA   cVerb                                   INIT "GET"
   DATA   oHttpConxn

   DATA   hInfo
   DATA   hRspns
   DATA   cRspns

   DATA   bAuthBlock
   DATA   bDebugBlock

   DATA   lDebug                                  INIT .F.

   DATA   cQuery                                  INIT ""
   DATA   cPayload                                INIT ""
   DATA   hHeaders                                INIT {=>}
   DATA   hQuery                                  INIT {=>}

   DATA   cAccessID                               INIT ""
   DATA   cAccessKey                              INIT ""

   DATA   nTimeOut                                INIT 5000

   METHOD connected()

   METHOD buildAuthorization()
   METHOD buildQuery()
   METHOD buildHeaders()
   METHOD debug( ... )

   ENDCLASS


METHOD HbQtHttpClient:init( cServer, nPort, cEndPoint )

   DEFAULT cServer   TO ::cServer
   DEFAULT nPort     TO ::nPort
   DEFAULT cEndPoint TO ::cEndPoint

   ::cServer   := cServer
   ::nPort     := nPort
   ::cEndPoint := cEndPoint

   RETURN Self


METHOD HbQtHttpClient:create( cServer, nPort, cEndPoint )

   DEFAULT cServer   TO ::cServer
   DEFAULT nPort     TO ::nPort
   DEFAULT cEndPoint TO ::cEndPoint

   ::cServer   := cServer
   ::nPort     := nPort
   ::cEndPoint := cEndPoint

   IF Empty( ::cServer )
      RETURN NIL
   ENDIF
   IF ::nPort == NIL .OR. At( ":", ::cServer ) == 0
      IF "https://" $ lower( ::cServer )
         ::nPort := 443
      ELSE
         ::nPort := 80
      ENDIF
   ENDIF
   ::cUrl := ::cServer + ":" + hb_ntos( ::nPort )
   ::oUrl := tUrl():new( ::cUrl )

   RETURN Self


METHOD HbQtHttpClient:buildHeaders()
   LOCAL xTmp

   FOR EACH xTmp IN ::hHeaders
      ::oHttpConxn:hFields[ xTmp:__enumKey() ] := xTmp
   NEXT
   RETURN NIL


METHOD HbQtHttpClient:buildQuery()
   LOCAL xTmp
   LOCAL s := ""

   FOR EACH xTmp IN ::hQuery
      s := __urlEncode( xTmp:__enumKey() ) + iif( Empty( xTmp ), "", "=" + __urlEncode( xTmp ) ) + "&"
   NEXT
   s := Left( s, Len( s ) - 1 )
   ::cQuery := iif( Empty( s ), "", "?" + s )
   RETURN NIL

// For HbQtHttpServer()
//
METHOD HbQtHttpClient:buildAuthorization()
   LOCAL cPassDigest, cNonce, cDateTime

   IF ! Empty( ::cAccessID ) .AND. ! Empty( ::cAccessKey )
      cNonce := __getNonce( 32 )
      cDateTime := hb_TSToStr( hb_TSToUTC( hb_DateTime() ) )
      cPassDigest := hb_base64Encode( hb_SHA1( cNonce + cDateTime + ::cAccessKey, .F. ) )
      //
      ::oHttpConxn:hFields[ "X-AUTHORIZE" ] := hb_base64Encode( hb_jsonEncode( { ::cAccessID, cPassDigest, cNonce, cDateTime } ) )
   ELSE
      IF HB_ISBLOCK( ::bAuthBlock )
         Eval( ::bAuthBlock, Self )
      ENDIF
   ENDIF
   RETURN NIL


METHOD HbQtHttpClient:request( cVerb, cEndPoint, xData )
   LOCAL cRspns
   LOCAL lSent := .F.

   // Clean variables - single class instance be able to make multiple requests
   //
   ::cRspns     := ""
   ::hRspns     := {=>}
   ::cRaw       := ""
   ::cReply     := ""
   ::nReplyCode := 0
   ::hRspnsHeaders := {=>}

   ::cPayload := ""
   IF ! Empty( xData )
      ::cPayload := hb_jsonEncode( xData )
   ENDIF
   // Normalize end-point
   //
   DEFAULT cEndPoint TO ::cEndPoint
   ::cEndPoint := cEndPoint
   IF ! Left( ::cEndPoint, 1 ) == "/"
      ::cEndPoint := "/" + ::cEndPoint
   ENDIF

   IF ::connected()
      ::buildAuthorization()                      // Must be first step
      //
      ::buildQuery()
      ::buildHeaders()

      WITH OBJECT ::oHttpConxn
         SWITCH Upper( cVerb )
         CASE "GET"
            lSent := :get( ::cEndPoint + ::cQuery ) ; EXIT
         CASE "HEAD"
            lSent := :head( "", ::cEndPoint + ::cQuery ) ; EXIT
         CASE "DELETE"
            lSent := :delete( "", ::cEndPoint + ::cQuery ) ; EXIT
         CASE "POST"
            lSent := :post( ::cPayload, ::cEndPoint ) ; EXIT
         CASE "PUT"
            lSent := :put( ::cPayload, ::cEndPoint ) ; EXIT
         ENDSWITCH

         IF lSent
            cRspns := :readAll()
            ::cReply := :cReply
            ::nReplyCode := :nReplyCode
            ::hRspnsHeaders := :hHeaders
            IF "<?xml " $ cRspns
               ::hRspns := hb_XmlToHash( cRspns )
            ELSE
               ::hRspns := hb_jsonDecode( cRspns )
            ENDIF
         ELSE
            cRspns := :cReply
         ENDIF
         :close()

         ::cRspns := cRspns
      ENDWITH
      // Refresh Variables for next call in case
      //
      ::hHeaders := {=>}
      ::hQuery := {=>}
   ENDIF
   ::oHttpConxn := NIL
   RETURN ::cRspns


METHOD HbQtHttpClient:connected()
   WITH OBJECT ::oHttpConxn := TipClientHttp():new( ::oUrl )
      :nConnTimeout := ::nTimeOut
      IF :open( ::cUrl )
         :bInitialized := .T.
         RETURN .T.
      ELSE
         ::cError := "1001:Could not connect to " + ::cUrl + "."
         ::debug( ::cError )
      ENDIF
   ENDWITH
   RETURN .F.


METHOD HbQtHttpClient:debug( ... )
   IF ::lDebug
      Eval( ::bDebugBlock, ... )
   ENDIF
   RETURN NIL


STATIC FUNCTION __getNonce( nKeys )
   LOCAL i
   LOCAL cKey := ""
   LOCAL cAlphaNum := "0a1b2c3d4e5f6g7h8i9jklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

   FOR i := 1 TO nKeys
      cKey += SubStr( cAlphaNum, __randomStr( 62 ), 1 )
   NEXT
   RETURN cKey


STATIC FUNCTION __randomStr( nUpto )
   LOCAL n

   DO WHILE .T.
      n := hb_Random( nUpto )
      IF n > 0 .AND. n <= nUpto
         EXIT
      ENDIF
   ENDDO
   RETURN n

// Mindaugus
//
STATIC FUNCTION __urlEncode( cString )
   LOCAL nI, cI, cRet := ""

   FOR nI := 1 TO Len( cString )
      cI := SubStr( cString, nI, 1 )
      IF cI == " "
         cRet += "+"
      ELSEIF Asc( cI ) >= 127 .OR. Asc( cI ) <= 31 .OR. cI $ '=&%+'
         cRet += "%" + hb_StrToHex( cI )
      ELSE
         cRet += cI
      ENDIF
   NEXT
   RETURN cRet


FUNCTION __urlDecode( cString )
   LOCAL nI

   cString := StrTran( cString, "+", " " )
   nI := 1
   DO WHILE nI <= Len( cString )
      nI := hb_At( "%", cString, nI )
      IF nI == 0
         EXIT
      ENDIF
      IF Upper( SubStr( cString, nI + 1, 1 ) ) $ "0123456789ABCDEF" .AND. ;
            Upper( SubStr( cString, nI + 2, 1 ) ) $ "0123456789ABCDEF"
         cString := Stuff( cString, nI, 3, hb_HexToStr( SubStr( cString, nI + 1, 2 ) ) )
      ENDIF
      nI++
   ENDDO
   RETURN cString


// Przemek
//
STATIC FUNCTION hb_XMLtoHash( cXML, lOmitHeader )
   LOCAL pXML

   hb_default( @lOmitHeader, .T. )

   pXML := mxmlLoadString( NIL, hb_utf8ToStr( cXML ), MXML_OPAQUE_CALLBACK )
   IF !empty( pXML )
      IF lOmitHeader
         RETURN hb_XML_getnodes( mxmlGetFirstChild( pXML ) )
      ELSE
         RETURN hb_XML_getnodes( pXML )
      ENDIF
   ENDIF
   RETURN NIL


STATIC FUNCTION hb_XML_getnodes( pNode )
   LOCAL cKey, pChild, xResult, xValue, aValue

   WHILE  !empty( pNode )
      IF mxmlGetType( pNode ) == MXML_ELEMENT
         cKey := mxmlGetElement( pNode )
         pChild := mxmlGetFirstChild( pNode )
         xValue := hb_XML_getnodes( pChild )
         IF xValue == NIL
            xValue := mxmlGetOpaque( pNode )
         ENDIF
         IF xResult == NIL
            xResult := {=>}
            hb_hKeepOrder( xResult, .t. )
            xResult[ cKey ] := xValue
         ELSEIF cKey $ xResult
            aValue := xResult[ cKey ]
            IF !hb_isArray( aValue )
               aValue := { aValue }
               xResult[ cKey ] := aValue
            ENDIF
            aadd( aValue, xValue )
         ELSE
            xResult[ cKey ] := xValue
         ENDIF
      ENDIF
      pNode := mxmlGetNextSibling( pNode )
   ENDDO
   RETURN xResult


STATIC FUNCTION h_GetValueDef( hHash, cKey, xDefault )
   LOCAL xTmp, xTmp1

   IF HB_ISHASH( hHash )
      IF cKey $ hHash
         RETURN hHash[ cKey ]
      ELSE
         FOR EACH xTmp IN hHash
            IF HB_ISHASH( xTmp )
               RETURN h_GetValueDef( xTmp, cKey, xDefault )
            ELSEIF HB_ISARRAY( xTmp )
               FOR EACH xTmp1 IN xTmp
                  IF HB_ISHASH( xTmp1 )
                     IF cKey $ xTmp1
                        RETURN xTmp1[ cKey ]
                     ELSE
                        RETURN h_GetValueDef( xTmp1, cKey, xDefault )
                     ENDIF
                  ENDIF
               NEXT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   RETURN xDefault


