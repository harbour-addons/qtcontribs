/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009-2010 Pritpal Bedi <bedipritpal@hotmail.com>
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
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                            Harbour-Qt IDE
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               08May2010
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include "common.ch"
#include "hbclass.ch"
#include "inkey.ch"
#include "hbide.ch"
#include "hbhrb.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"

/*----------------------------------------------------------------------*/

STATIC s_aPlugins := { { "", NIL } }
STATIC s_aLoaded  := { { "", .f. } }
STATIC s_aPersist := {}

/*----------------------------------------------------------------------*/

FUNCTION hbide_loadPlugins( oIde, cVer )
   LOCAL a_, cPlugin

   FOR EACH a_ IN oIde:oINI:aTools
      IF a_[ 12 ] == "YES"
         hb_fNameSplit( a_[ 11 ], , @cPlugin )

         RETURN hbide_loadAPlugin( cPlugin, oIde, cVer )
      ENDIF
   NEXT

   RETURN .f.

/*----------------------------------------------------------------------*/

FUNCTION hbide_execPlugin( cPlugin, oIde, ... )
   LOCAL n, lLoaded

   cPlugin := lower( cPlugin )

   IF ( n := ascan( s_aLoaded, {|e_| e_[ 1 ] == cPlugin } ) ) == 0
      lLoaded := hbide_loadAPlugin( cPlugin, oIde, "1.0" )
   ELSE
      lLoaded := s_aLoaded[ n,2 ]
   ENDIF
   IF lLoaded
      IF ( n := ascan( s_aPlugins, {|e_| e_[ 1 ] == cPlugin } ) ) > 0
         RETURN eval( s_aPlugins[ n, 2 ], oIde, ... )
      ENDIF
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

STATIC FUNCTION hbide_loadAPlugin( cPlugin, oIde, cVer )
   LOCAL pHrb, bBlock, lLoaded, cFileName, cFile, cPath

   IF !empty( cPath := oIde:oINI:getResourcesPath() )

      cFileName := cPath + "hbide_plugin_" + cPlugin + ".hrb"
      IF hb_fileExists( cFileName )
         pHrb := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, cFileName )
      ELSE
         cFileName := cPath + "hbide_plugin_" + cPlugin + ".prg"
         IF hb_fileExists( cFileName )
            cFile := hb_memoread( cFileName )
            cFile := hb_compileFromBuf( cFile, "-n2", "-w3", "-es2", "-q0" )
            IF ! Empty( cFile )
               pHrb := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, cFile )
            ENDIF
         ELSE
            cFileName := cPath + "hbide_plugin_" + cPlugin + ".hb"
            IF hb_fileExists( cFileName )
               cFile := hb_memoread( cFileName )
               cFile := hb_compileFromBuf( cFile, "-n2", "-w3", "-es2", "-q0" )
               IF ! Empty( cFile )
                  pHrb := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, cFile )
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ( lLoaded := ! empty( pHrb ) )
         IF ! Empty( hb_hrbGetFunSym( pHrb, cPlugin + "_init" ) )
            bBlock := &( "{|...| " + cPlugin + "_init(...) }" )

            IF eval( bBlock, oIde, cVer )
               IF ! Empty( hb_hrbGetFunSym( pHrb, cPlugin + "_exec" ) )
                  aadd( s_aPlugins, { cPlugin, &( "{|...| " + cPlugin + "_exec(...) }" ), pHrb } )
                  lLoaded := .t.

               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   aadd( s_aLoaded, { cPlugin, lLoaded } )

   RETURN lLoaded

/*----------------------------------------------------------------------*/

FUNCTION hbide_runAScript( cBuffer, cCompFlags, xParam )
   LOCAL cFile, pHrb, oErr, a_:={}
   LOCAL lError := .f.
   LOCAL bError := ErrorBlock( {|o| break( o ) } )

   BEGIN SEQUENCE
      AAdd( a_, cBuffer )
      AEval( hb_ATokens( cCompFlags, " " ), {|s| iif( ! Empty( s ), AAdd( a_,s ), NIL ) } )
      cFile := hb_compileFromBuf( hb_ArrayToParams( a_ ) )
      IF ! Empty( cFile )
         pHrb := hb_hrbLoad( HB_HRB_BIND_FORCELOCAL, cFile )
      ENDIF
   RECOVER USING oErr
      MsgBox( hbide_errorDesc( oErr ) )
      lError := .t.
   END SEQUENCE

   IF ! lError .AND. !empty( pHrb )
      BEGIN SEQUENCE
         hb_hrbDo( pHrb, xParam )
      RECOVER USING oErr
         MsgBox( hbide_errorDesc( oErr ), "Error Running Script!" )
      END SEQUENCE
   ENDIF

   ErrorBlock( bError )
   RETURN NIL


STATIC FUNCTION hbide_errorDesc( e )
   LOCAL n
   LOCAL cErrorLog := e:description + Chr( 10 ) + e:operation + Chr( 10 )
   LOCAL aStack := {}

   if ValType( e:Args ) == "A"
      cErrorLog += "   Args:" + Chr( 10 )
      FOR n := 1 to Len( e:Args )
         cErrorLog += "     [" + Str( n, 4 ) + "] = " + ValType( e:Args[ n ] ) + ;
                      "   " + hbide_cValToChar( hbide_cValToChar( e:Args[ n ] ) ) + ;
                      iif( ValType( e:Args[ n ] ) == "A", " length: " + ;
                      AllTrim( Str( Len( e:Args[ n ] ) ) ), "" ) + Chr( 10 )
      next
   endif

   cErrorLog += Chr( 10 ) + "Stack Calls" + Chr( 10 )
   cErrorLog += "===========" + Chr( 10 )
   n := 1
   WHILE  ( n < 74 )
      IF ! Empty( ProcName( n ) )
         AAdd( aStack, "   Called from: " + ProcFile( n ) + " => " + Trim( ProcName( n ) ) + ;
                        "( " + hb_ntos( ProcLine( n ) ) + " )" )
         cErrorLog += ATail( aStack ) + Chr( 10 )
      ENDIF
      n++
    END
   RETURN cErrorLog


function hbide_cValToChar( uVal )
  local cType := ValType( uVal )

  do case
     case cType == "C" .or. cType == "M"
          return uVal

     case cType == "D"
          return DToC( uVal )

     case cType == "T"
           return If( Year( uVal ) == 0, HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) ), HB_TToC( uVal ) )

     case cType == "L"
          return If( uVal, ".T.", ".F." )

     case cType == "N"
          return AllTrim( Str( uVal ) )

     case cType == "B"
          return "{|| ... }"

     case cType == "A"
          return "{ ... }"

     case cType == "O"
          RETURN iif( __ObjHasData( uVal, "cClassName" ), uVal:cClassName, uVal:ClassName() )

     case cType == "H"
          return "{=>}"

     case cType == "P"
          return "0x" + hb_NumToHex( uVal )

     otherwise

          return ""
  endcase

   return nil


FUNCTION hbide_execAutoScripts()
   LOCAL cPath, a_, dir_, cFileName, cBuffer

   IF !empty( cPath := hbide_setIde():oINI:getResourcesPath() )
      a_:= {}
      dir_:= directory( cPath + "hbide_auto_*.prg" )
      aeval( dir_, {|e_| aadd( a_, e_[ 1 ] ) } )
      dir_:= directory( cPath + "hbide_auto_*.hb" )
      aeval( dir_, {|e_| aadd( a_, e_[ 1 ] ) } )

      FOR EACH cFileName IN a_
         IF !empty( cBuffer := hb_memoRead( cPath + cFileName ) )
            hbide_runAScript( cBuffer, /* No Compiler Flag */, hbide_setIde() )
         ENDIF
      NEXT
   ENDIF
   RETURN NIL

/*------------------------------------------------------------------------*/

FUNCTION hbide_getUserPrototypes()
   LOCAL aProto := {}
   LOCAL cPath, aDir, cMask, a_, b_

   IF ! empty( cPath := hbide_setIde():oINI:getResourcesPath() )
      cMask := cPath + "hbide_protos_*"
      IF ! empty( aDir := directory( cMask ) )
         FOR EACH a_ IN aDir
            b_:= hbide_loadProtoTypes( cPath + a_[ 1 ] )
            aeval( b_, {|e| aadd( aProto, e ) } )
         NEXT
      ENDIF
   ENDIF

   RETURN aProto

/*------------------------------------------------------------------------*/

FUNCTION hbide_loadPrototypes( cPath )
   LOCAL a_, s, nLen, i
   LOCAL aProto := {}, b_:={}

   IF hb_fileExists( cPath )
      a_:= hbide_readSource( cPath )

      FOR EACH s IN a_
         s := alltrim( s )
         IF empty( s )
            LOOP
         ENDIF
         aadd( b_, s )
      NEXT
   ENDIF

   nLen := Len( b_ )
   FOR EACH s IN b_
      i := s:__enumIndex()
      IF right( s, 1 ) == ";"
         s := substr( s, 1, Len( s ) - 1 )
         IF i < nLen
            b_[ i + 1 ] := s + " " + b_[ i + 1 ]
            s := ""
         ENDIF
      ENDIF
   NEXT

   FOR EACH s IN b_
      IF empty( s )
         LOOP
      ENDIF
      aadd( aProto, s )
   NEXT

   RETURN aProto

/*------------------------------------------------------------------------*/
/* Silent Mode */

FUNCTION hbide_compileAScript( cBuffer, cCompFlags )
   LOCAL cFile, pHrb
   LOCAL bError := ErrorBlock( {|o| break( o ) } )

   BEGIN SEQUENCE
      cFile := hb_compileFromBuf( cBuffer, cCompFlags )
      IF ! Empty( cFile )
         pHrb := hb_hrbLoad( HB_HRB_BIND_OVERLOAD, cFile )
      ENDIF
   END SEQUENCE

   ErrorBlock( bError )
   RETURN pHrb

/*----------------------------------------------------------------------*/

FUNCTION hbide_loadPersistentScripts()
   LOCAL cPath, a_, dir_, cFileName, cBuffer, pHrb

   IF !empty( cPath := hbide_setIde():oINI:getResourcesPath() )
      a_:= {}
      dir_:= directory( cPath + "hbide_persist_*.prg" )
      aeval( dir_, {|e_| aadd( a_, e_[ 1 ] ) } )
      dir_:= directory( cPath + "hbide_persist_*.hb" )
      aeval( dir_, {|e_| aadd( a_, e_[ 1 ] ) } )

      FOR EACH cFileName IN a_
         IF !empty( cBuffer := hb_memoRead( cPath + cFileName ) )
            IF !empty( pHrb := hbide_compileAScript( cBuffer ) )
               aadd( s_aPersist, pHrb )
            ENDIF
         ENDIF
      NEXT
   ENDIF

   RETURN NIL

/*------------------------------------------------------------------------*/

FUNCTION hbide_execScriptFunction( cFunc, ... )

   IF hb_IsFunction( "script_" + cFunc )
      RETURN eval( &( "{|...| " + "script_" + cFunc + "( ... )" + "}" ), ... )
   ENDIF

   RETURN .F.

/*----------------------------------------------------------------------*/

FUNCTION hbide_destroyPlugins()

   s_aPlugins := NIL
   s_aLoaded  := NIL
   s_aPersist := NIL

   RETURN NIL

/*----------------------------------------------------------------------*/
