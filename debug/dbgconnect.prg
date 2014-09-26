/*
 * $Id$
 */

/*
 * HWGUI - Harbour Win32 GUI library source code:
 * The Debugger
 *
 * Copyright 2013 Alexander Kresin <alex@kresin.ru>
 * www - http://www.kresin.ru
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2 of the License, OR
 * ( at your option ) any later version, WITH one exception:
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR ( at your option )
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
 * Boston, MA 02111-1307 USA ( OR visit the web site http://www.gnu.org/ ).
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

#include "fileio.ch"


#define DEBUG_PROTO_VERSION                       3


#define CMD_GO                                    1
#define CMD_STEP                                  2
#define CMD_TRACE                                 3
#define CMD_NEXTR                                 4
#define CMD_TOCURS                                5
#define CMD_QUIT                                  6
#define CMD_EXIT                                  7
#define CMD_BADD                                  8
#define CMD_BDEL                                  9
#define CMD_CALC                                  10
#define CMD_STACK                                 11
#define CMD_LOCAL                                 12
#define CMD_PRIVATE                               13
#define CMD_PUBLIC                                14
#define CMD_STATIC                                15
#define CMD_WATCH                                 16
#define CMD_WADD                                  17
#define CMD_WDEL                                  18
#define CMD_AREAS                                 19
#define CMD_REC                                   20
#define CMD_OBJECT                                21
#define CMD_ARRAY                                 22
#define CMD_SETS                                  23
#define CMD_SETVAR                                24

#define BUFER_LEN                                 1024


#ifdef __XHARBOUR__
#xtranslate HB_AT( [ <n,...> ] )                  =>  AT( <n> )
#xtranslate HB_PROGNAME( [ <n,...> ] )            =>  EXENAME( <n> )
#xtranslate HB_PROCESSOPEN( [ <n,...> ] )         =>  HB_OPENPROCESS( <n> )
#xtranslate HB_DIRTEMP( [ <n,...> ] )             =>  ""
#endif


STATIC lDebugRun := .F., handl1, handl2, cBuffer
STATIC nId1 := -1, nId2 := 0, nId3 := 0


FUNCTION hwg_dbg_New()
   LOCAL cFile := hb_Progname()

   cBuffer := Space( BUFER_LEN )

   IF File( cFile + ".d1" ) .AND. File( cFile + ".d2" )
      IF ( handl1 := FOpen( cFile + ".d1", FO_READ + FO_SHARED ) ) != -1
         IF FRead( handl1, @cBuffer, BUFER_LEN ) > 0 .AND. Left( cBuffer,4 ) == "init"
            handl2 := FOpen( cFile + ".d2", FO_READWRITE + FO_SHARED )
            IF handl2 != -1
               lDebugRun := .T.
               RETURN NIL
            ENDIF
         ENDIF
         FClose( handl1 )
      ENDIF
   ENDIF
   RETURN NIL


STATIC FUNCTION hwg_dbg_Read()
   LOCAL n, s := "", arr

   FSeek( handl1, 0, 0 )
   DO WHILE ( n := Fread( handl1, @cBuffer, BUFER_LEN ) ) > 0
      s += Left( cBuffer, n )
      IF ( n := At( ",!", s ) ) > 0
         IF ( arr := hb_aTokens( Left( s,n+1 ), "," ) ) != NIL .AND. Len( arr ) > 2 .AND. arr[ 1 ] == arr[ Len( arr )-1 ]
            RETURN arr
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO
   RETURN NIL


STATIC FUNCTION hwg_dbg_Send( ... )
   LOCAL arr := hb_aParams(), i, s := ""

   FSeek( handl2, 0, 0 )
   FOR i := 2 TO Len( arr )
      s += arr[ i ] + ","
   NEXT
   IF Len( s ) > 800
      FWrite( handl2, "!," + Space( Len( arr[ 1 ] )-1 ) + s + arr[ 1 ] + ",!" )
      FSeek( handl2, 0, 0 )
      FWrite( handl2, arr[ 1 ] + "," )
   ELSE
      FWrite( handl2, arr[ 1 ] + "," + s + arr[ 1 ] + ",!" )
   ENDIF
   //
   FClose( handl2 )
   handl2 := FOpen( hb_ProgName() + ".d2", FO_READWRITE + FO_SHARED )
   //
   RETURN NIL


FUNCTION hwg_dbg_SetActiveLine( cPrgName, nLine, aStack, aVars, aWatch, nVarType )
   LOCAL i, nLen
   LOCAL s := cPrgName + "," + Ltrim( Str( nLine ) )

   IF !lDebugRun ; RETURN NIL; ENDIF

   IF nId2 == 0
      s += ",ver," + Ltrim( Str( DEBUG_PROTO_VERSION ) )
   ENDIF
   IF aStack != NIL
      s += ",stack"
      nLen := Len( aStack )
      FOR i := 1 TO nLen
         s += "," + aStack[ i ]
      NEXT
   ENDIF
   IF aVars != NIL
      s += Iif( nVarType==1, ",valuelocal,", ;
            Iif( nVarType==2, ",valuepriv,", Iif( nVarType==3, ",valuepubl,", ",valuestatic," ) ) ) + aVars[ 1 ]
      nLen := Len( aVars )
      FOR i := 2 TO nLen
         s += "," + Str2Hex( aVars[ i ] )
      NEXT
   ENDIF
   IF aWatch != NIL
      s += ",valuewatch," + aWatch[ 1 ]
      nLen := Len( aWatch )
      FOR i := 2 TO nLen
         s += "," + Str2Hex( aWatch[ i ] )
      NEXT
   ENDIF
   hwg_dbg_Send( "a"+Ltrim( Str( ++nId2 ) ), s )
   RETURN NIL


FUNCTION IdeTrace( xMessage )
   LOCAL i, nLen
   LOCAL s := "message"

   IF !lDebugRun ; RETURN NIL; ENDIF

   IF ValType( xMessage ) == "C"
      xMessage := { xMessage }
   ENDIF
   nLen := Len( xMessage )
   FOR i := 1 TO nLen
      s += "," + Str2Hex( __dbgValToStr( xMessage[ i ] ) )
   NEXT
   hwg_dbg_Send( "m" + Ltrim( Str( ++nId3 ) ), s )
   FOR i := 1 TO 5
      hb_ReleaseCPU()
   NEXT
   RETURN NIL


FUNCTION hwg_dbg_Wait( /*nWait*/ )
   IF !lDebugRun ; RETURN NIL; ENDIF
   RETURN NIL


FUNCTION hwg_dbg_Input( p1, p2, p3, p4, p5 )
   LOCAL n, cmd, arr

   IF !lDebugRun ; RETURN CMD_GO; ENDIF

   DO WHILE .T.
      IF ! Empty( arr := hwg_dbg_Read() )
         IF ( n := Val( arr[ 1 ] ) ) > nId1 .AND. arr[ Len( arr ) ] == "!"
            nId1 := n
            IF arr[ 2 ] == "cmd"
               cmd := arr[ 3 ]
               IF     cmd == "go"
                  RETURN CMD_GO
               ELSEIF cmd == "step"
                  RETURN CMD_STEP
               ELSEIF cmd == "trace"
                  RETURN CMD_TRACE
               ELSEIF cmd == "nextr"
                  RETURN CMD_NEXTR
               ELSEIF cmd == "to"
                  p1 := arr[ 4 ]
                  p2 := Val( arr[ 5 ] )
                  RETURN CMD_TOCURS
               ELSEIF cmd == "quit"
                  FClose( handl1 )
                  FClose( handl2 )
                  RETURN CMD_QUIT
               ELSEIF cmd == "exit"
                  lDebugRun := .F.
                  RETURN CMD_EXIT
               ENDIF
            ELSEIF arr[ 2 ] == "brp"
               IF arr[ 3 ] == "add"
                  p1 := arr[ 4 ]
                  p2 := Val( arr[ 5 ] )
                  RETURN CMD_BADD
               ELSEIF arr[ 3 ] == "del"
                  p1 := arr[ 4 ]
                  p2 := Val( arr[ 5 ] )
                  RETURN CMD_BDEL
               ENDIF
            ELSEIF arr[ 2 ] == "watch"
               IF arr[ 3 ] == "add"
                  p1 := Hex2Str( arr[ 4 ] )
                  RETURN CMD_WADD
               ELSEIF arr[ 3 ] == "del"
                  p1 := Val( arr[ 4 ] )
                  RETURN CMD_WDEL
               ENDIF
            ELSEIF arr[ 2 ] == "exp"
               p1 := Hex2Str( arr[ 3 ] )
               RETURN CMD_CALC
            ELSEIF arr[ 2 ] == "set"
               p1 := Hex2Str( arr[ 3 ] )
               p2 := Hex2Str( arr[ 4 ] )
               p3 := Hex2Str( arr[ 5 ] )
               p4 := Hex2Str( arr[ 6 ] )
               p5 := Hex2Str( arr[ 7 ] )
               RETURN CMD_SETVAR
            ELSEIF arr[ 2 ] == "view"
               IF arr[ 3 ] == "stack"
                  p1 := arr[ 4 ]
                  RETURN CMD_STACK
               ELSEIF arr[ 3 ] == "local"
                  p1 := arr[ 4 ]
                  RETURN CMD_LOCAL
               ELSEIF arr[ 3 ] == "priv"
                  p1 := arr[ 4 ]
                  RETURN CMD_PRIVATE
               ELSEIF arr[ 3 ] == "publ"
                  p1 := arr[ 4 ]
                  RETURN CMD_PUBLIC
               ELSEIF arr[ 3 ] == "static"
                  p1 := arr[ 4 ]
                  RETURN CMD_STATIC
               ELSEIF arr[ 3 ] == "watch"
                  p1 := arr[ 4 ]
                  RETURN CMD_WATCH
               ELSEIF arr[ 3 ] == "areas"
                  RETURN CMD_AREAS
               ELSEIF arr[ 3 ] == "sets"
                  RETURN CMD_SETS
               ENDIF
            ELSEIF arr[ 2 ] == "insp"
               IF arr[ 3 ] == "rec"
                  p1 := arr[ 4 ]
                  RETURN CMD_REC
               ELSEIF arr[ 3 ] == "obj"
                  p1 := arr[ 4 ]
                  RETURN CMD_OBJECT
               ELSEIF arr[ 3 ] == "arr"
                  p1 := arr[ 4 ]
                  p2 := arr[ 5 ]
                  p3 := arr[ 6 ]
                  RETURN CMD_ARRAY
               ENDIF
            ENDIF
            hwg_dbg_Send( "e" + Ltrim( Str( ++nId2 ) ) )
         ENDIF
      ENDIF
      hb_ReleaseCpu()
   ENDDO
   RETURN 0


FUNCTION hwg_dbg_Answer( ... )
   LOCAL arr := hb_aParams(), i, j, s := "", lConvert

   IF !lDebugRun ; RETURN NIL; ENDIF

   FOR i := 1 TO Len( arr )
      IF Valtype( arr[ i ] ) == "A"
         lConvert := ( i > 1 .AND. Valtype( arr[ i-1 ] ) == "C" .AND. Left( arr[ i-1 ],5 ) == "value" )
         FOR j := 1 TO Len( arr[ i ] )
            s += Iif( j>1.AND.lConvert, Str2Hex( arr[ i,j ] ), arr[ i,j ] ) + ","
         NEXT
      ELSE
         IF arr[ i ] $ "value" .AND. i < Len( arr )
            s += arr[ i ] + "," + Str2Hex( arr[ ++i ] ) + ","
         ELSE
            s += arr[ i ] + ","
         ENDIF
      ENDIF
   NEXT
   hwg_dbg_Send( "b"+Ltrim( Str( nId1 ) ), Left( s,Len( s )-1 ) )

   RETURN NIL


FUNCTION hwg_dbg_Msg( /*cMessage*/ )
   IF !lDebugRun ; RETURN NIL; ENDIF
   RETURN NIL


FUNCTION hwg_dbg_Alert( cMessage )
   LOCAL bCode := &( Iif( Type( "hwg_msginfo()" ) == "UI", "{ |s|hwg_msginfo( s ) }", ;
                   Iif( Type( "msginfo()" ) == "UI", "{ |s|msginfo( s ) }", "{ |s|alert( s ) }" ) ) )
   Eval( bCode, cMessage )
   RETURN NIL


FUNCTION hwg_dbg_Quit()
   LOCAL bCode := &( Iif( Type( "hwg_endwindow()" ) == "UI", "{ |s|hwg_endwindow() }", ;
            Iif( Type( "ReleaseAllWindows()" ) == "UI","{ ||ReleaseAllWindows() }", "{ ||__Quit() }" ) ) )
   Eval( bCode )
   RETURN NIL


STATIC FUNCTION Hex2Int( stroka )
   LOCAL i := ASC( stroka ), res

   IF i > 64 .AND. i < 71
      res := ( i - 55 ) * 16
   ELSEIF i > 47 .AND. i < 58
      res := ( i - 48 ) * 16
   ELSE
      RETURN 0
   ENDIF
   i := ASC( SubStr( stroka,2,1 ) )
   IF i > 64 .AND. i < 71
      res += i - 55
   ELSEIF i > 47 .AND. i < 58
      res += i - 48
   ENDIF
   RETURN res


STATIC FUNCTION Int2Hex( n )
   LOCAL n1 := Int( n/16 ), n2 := n % 16

   IF n > 255
      RETURN "XX"
   ENDIF
   RETURN Chr( Iif( n1<10,n1+48,n1+55 ) ) + Chr( Iif( n2<10,n2+48,n2+55 ) )


STATIC FUNCTION Str2Hex( stroka )
   LOCAL cRes := "", i, nLen := Len( stroka )

   FOR i := 1 TO nLen
      cRes += Int2Hex( Asc( Substr( stroka,i,1 ) ) )
   NEXT
   RETURN cRes


STATIC FUNCTION Hex2Str( stroka )
   LOCAL cRes := "", i := 1, nLen := Len( stroka )

   DO WHILE i <= nLen
      cRes += Chr( Hex2Int( Substr( stroka,i,2 ) ) )
      i += 2
   ENDDO
   RETURN cRes


EXIT PROCEDURE hwg_dbg_exit

   hwg_dbg_Send( "quit" )
   FClose( handl1 )
   FClose( handl2 )
   RETURN

