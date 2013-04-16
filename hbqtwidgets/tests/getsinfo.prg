/*
 * $Id$
 */

/*
 * Copyright 2013 Nenad
 * www - http://harbour-project.org
 * Refined by : Pritpal Bedi
 */

#ifdef __QT__
#include "hbqtstd.ch"
#include "hbtoqt.ch"
#endif

FUNCTION Main()

   LOCAL cVar1   := Space(5)
   LOCAL cVar2   := space( 13 )
   LOCAL cVar3   := CToD( "" )
   LOCAL cVar4   := 200
   LOCAL cVar5   := 10.15
   LOCAL GetList := {}
   LOCAL nRow
#ifdef __QT__
   LOCAL lOK     := .t.
   LOCAL lCancel := .f.
   LOCAL SayList := {}
#endif

   SET DATE GERMAN
   SET CENTURY ON

   Set( _SET_DATEFORMAT, "dd.mm.yyyy" )
   SetMode( 25,80 )

#ifdef __QT__
   hbqt_errorsys()
#endif

   nRow := 1

   @ nRow++,2 SAY "N:999.99       " GET cVar5 PICTURE "999.99"        VALID vName()
   @ nRow++,2 SAY "C:(999)999-9999" GET cVar2 PICTURE "(999)999-9999" VALID vName()
   @ nRow++,2 SAY "C:@R 99-99-9   " GET cVar1 PICTURE "@R 99-99-9"    VALID vName()
   @ nRow++,2 SAY "D:             " GET cVar3                         VALID vName()
   @ nRow++,2 SAY "N:@KZ 99999    " GET cVar4 PICTURE "@KZ 99999"     VALID vName()

#ifdef __QT__
   @ 1, 50, 1, 60 GET lCancel PUSHBUTTON "Cancel" ACTION {|| GetActive():parent():close() }
   @ 3, 50, 3, 60 GET lOk     PUSHBUTTON "Ok"     ACTION {|| GetActive():parent():close() }
#endif

   READ

#ifdef __QT__
   QApplication():exec()
#endif

   RETURN nRow


STATIC FUNCTION VName()

   LOCAL i
   LOCAL aMsg := {}

   AADD( aMsg, { "buffer     ," , "", GetActive():buffer()     , "" } )
   AADD( aMsg, { "original   ," , "", GetActive():original()   , "" } )
   AADD( aMsg, { "untransform," , "", GetActive():untransform(), "" } )
   AADD( aMsg, { "varget     ," , "", GetActive():varget()     , "" } )
   AADD( aMsg, { "picture    ," , "", GetActive():picture()    , "" } )
   AADD( aMsg, { "changed    ," , "", GetActive():changed()    , "" } )

   GetActive():updatebuffer()

   AADD( aMsg, { "buffer     ," , "", GetActive():buffer()     , "" } )
   AADD( aMsg, { "original   ," , "", GetActive():original()   , "" } )
   AADD( aMsg, { "untransform," , "", GetActive():untransform(), "" } )
   AADD( aMsg, { "varget     ," , "", GetActive():varget()     , "" } )
   AADD( aMsg, { "picture    ," , "", GetActive():picture()    , "" } )
   AADD( aMsg, { "changed    ," , "", GetActive():changed()    , "" } )

   FOR i := 1 TO Len( aMsg )
       aMsg[ i,2 ] := ValType( aMsg[ i, 3 ] )

       DO CASE
       CASE aMsg[ i, 2 ] == "C" ; aMsg[ i, 4 ] := StrTran( aMsg[ i, 3 ], " ", "*" )
       CASE aMsg[ i, 2 ] == "D" ; aMsg[ i, 4 ] := StrTran( DToC( aMsg[ i, 3 ] ), " ", "*" )
       CASE aMsg[ i, 2 ] == "N" ; aMsg[ i, 4 ] := StrTran( Str( aMsg[ i, 3 ] ), " ", "*" )
       CASE aMsg[ i, 2 ] == "L" ; aMsg[ i, 4 ] := iif( aMsg[ i, 3 ], ".T." , ".F." )
       OTHERWISE ; aMsg[ 1, 4 ] := "undefined"
       ENDCASE
   NEXT

   Msgwnd( NIL, aMsg )

   RETURN .T.


STATIC FUNCTION Msgwnd( oWnd, aMsg )

#ifdef __QT__
   LOCAL oDlg

   oDlg := QDialog( oWnd )

   oDlg:setFixedSize( 500, 480 )

   SetLabel( oDlg, 5, 1, BuildMsg( aMsg[ 1 ] ) )
   SetLabel( oDlg, 5, 2, BuildMsg( aMsg[ 2 ] ) )
   SetLabel( oDlg, 5, 3, BuildMsg( aMsg[ 3 ] ) )
   SetLabel( oDlg, 5, 4, BuildMsg( aMsg[ 4 ] ) )
   SetLabel( oDlg, 5, 5, BuildMsg( aMsg[ 5 ] ) )
   SetLabel( oDlg, 5, 6, BuildMsg( aMsg[ 6 ] ) )
   SetLabel( oDlg, 5, 8, "After GetActive():updatebuffer()" )
   SetLabel( oDlg, 5,10, BuildMsg( aMsg[ 7 ] ) )
   SetLabel( oDlg, 5,11, BuildMsg( aMsg[ 8 ] ) )
   SetLabel( oDlg, 5,12, BuildMsg( aMsg[ 9 ] ) )
   SetLabel( oDlg, 5,13, BuildMsg( aMsg[10 ] ) )
   SetLabel( oDlg, 5,14, BuildMsg( aMsg[11 ] ) )
   SetLabel( oDlg, 5,15, BuildMsg( aMsg[12 ] ) )

   oDlg:exec()

   oDlg:setParent( QWidget() )    /* Release the memory */
#else

   LOCAL aMnu := {}, s := ""

   HB_SYMBOL_UNUSED( oWnd )

   AAdd( aMnu, BuildMsg( aMsg[ 1 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 2 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 3 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 4 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 5 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 6 ] ) )
   AAdd( aMnu, "   ;" )
   AAdd( aMnu, "After GetActive():updatebuffer();" )
   AAdd( aMnu, "   ;" )
   AAdd( aMnu, BuildMsg( aMsg[ 7 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 8 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[ 9 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[10 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[11 ] ) )
   AAdd( aMnu, BuildMsg( aMsg[12 ] ) )

   AEval( aMnu, {|e| s += e } )
   Alert( s )

#endif

   RETURN NIL


#ifdef __QT__
STATIC FUNCTION SetLabel( oDlg, nCol, nRow, cMsg )
   LOCAL oLabel

   WITH OBJECT oLabel := QLabel( oDlg )
      :setFont( QFont( "Courier New", 12 ) )
      :move( nCol, nRow * 20 )
      :resize( 400, 20 )
      :setText( cMsg )
   ENDWITH

   RETURN oLabel
#endif


STATIC FUNCTION BuildMsg( aMsg )
   RETURN aMsg[ 1 ] + " " + aMsg[ 2 ] + " -> '" + aMsg[ 4 ] + "';"

