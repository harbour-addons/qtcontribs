/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file FOR the Xbp*Classes
 *
 * Copyright 2009-2023 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR (at your option)
 * any later version.
 *
 * This program is distributed IN the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General PUBLIC License FOR more details.
 *
 * You should have received a copy of the GNU General PUBLIC License
 * along WITH this software; see the file COPYING.  IF NOT, write TO
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (OR visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission FOR
 * additional uses of the text contained IN its release of Harbour.
 *
 * The exception is that, IF you link the Harbour libraries WITH other
 * files TO produce an executable, this does NOT by itself cause the
 * resulting executable TO be covered by the GNU General PUBLIC License.
 * Your use of that executable is IN no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does NOT however invalidate any other reasons why
 * the executable file might be covered by the GNU General PUBLIC License.
 *
 * This exception applies only TO the code released by the Harbour
 * Project under the name Harbour.  IF you copy code FROM other
 * Harbour Project OR Free Software Foundation releases into a copy of
 * Harbour, as the General PUBLIC License permits, the exception does
 * NOT apply TO the code that you add IN this way.  TO avoid misleading
 * anyone as TO the status of such modified files, you must delete
 * this exception notice FROM them.
 *
 * IF you write modifications of your own FOR Harbour, it is your choice
 * whether TO permit this exception TO apply TO your modifications.
 * IF you DO NOT wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/
/*
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                 Xbase++ Compatible xbpClipBoard CLASS
 *
 *                            Pritpal Bedi
 *                              13Mar2010
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"

#include "xbp.ch"
#include "appevent.ch"


CLASS XbpClipBoard

   DATA   oWidget
   DATA   oOldXbp

   METHOD init()
   METHOD create()
   METHOD destroy()

   METHOD clear()                               //  lSuccess     Deletes the DATA currently IN the clipboard.
   METHOD close()                               //  SELF         Closes the clipboard.
   METHOD getBuffer( nFormat )                  //  xBuffer      Retrieves the DATA FROM the clipboard.
   METHOD getFormatName( nFormatID )            //  cName        Retrieves the name of a clipboard DATA format.
   METHOD open()                                //  lSuccess     Opens the clipboard.
   METHOD queryFormats()                        //  aFormats     Returns the DATA formats FOR which there is DATA currently available IN the clipboard.
   METHOD registerChangeHandler( oXbp )         //  oOldXbp|NIL  Registers an Xbase Part as recipient FOR "change" messages
   METHOD registerFormat( cFormatName )         //  nFormatID    Registers a user-defined DATA format
   METHOD setBuffer( xBuffer, nFormatId )       //  lSuccess     Writes DATA TO the clipboard.

   ENDCLASS


METHOD XbpClipBoard:init()
   RETURN SELF


METHOD XbpClipBoard:create()
   ::oWidget := QClipBoard()
   RETURN SELF


METHOD XbpClipBoard:destroy()
   ::oWidget:clear()
   ::oWidget := NIL
   RETURN SELF


METHOD XbpClipBoard:clear()
   ::oWidget:clear()
   RETURN .T. 


METHOD XbpClipBoard:close()
   // ALWAYS open
   RETURN SELF


METHOD XbpClipBoard:getBuffer( nFormat )
   LOCAL xBuffer

   IF nFormat == XBPCLPBRD_TEXT
      xBuffer := ::oWidget:text()
   ELSEIF nFormat == XBPCLPBRD_BITMAP
      xBuffer := XbpBitmap():new()
      xBuffer:oWiget := ::oWidget:image()
   ENDIF
   RETURN xBuffer


METHOD XbpClipBoard:getFormatName( nFormatID )
   LOCAL cName := ""
   
   HB_SYMBOL_UNUSED( nFormatID )
   RETURN cName


METHOD XbpClipBoard:open()
   LOCAL lSuccess := .t.
   // ALWAYS open
   RETURN lSuccess


METHOD XbpClipBoard:queryFormats()
   LOCAL aFormats := {}
   LOCAL cText  := ::oWidget:text()
   LOCAL qImage := ::oWidget:image()

   IF !empty( cText )
      aadd( aFormats, XBPCLPBRD_TEXT )
   ENDIF
   IF !qImage:isNull()
      aadd( aFormats, XBPCLPBRD_BITMAP )
   ENDIF
   RETURN aFormats


METHOD XbpClipBoard:registerChangeHandler( oXbp )
   LOCAL oOld := ::oOldXbp

   ::oOldXbp := oXbp
   RETURN oOld


METHOD XbpClipBoard:registerFormat( cFormatName )
   LOCAL nFormatID := 0
   HB_SYMBOL_UNUSED( cFormatName )
   RETURN nFormatID


METHOD XbpClipBoard:setBuffer( xBuffer, nFormatId )
   LOCAL lSuccess := .t.

   IF nFormatId == XBPCLPBRD_TEXT
      ::oWidget:setText( xBuffer )
   ELSEIF nFormatId == XBPCLPBRD_BITMAP
      ::oWidget:setImage( xBuffer:oWidget )   /* XbpBitmap */
   ENDIF
   RETURN lSuccess

