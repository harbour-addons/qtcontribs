/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbqtgui.ch"
#include "hbclass.ch"
#include "hbtrace.ch"
#include "hbqtstd.ch"


#define GET_CLR_UNSELECTED                        0
#define GET_CLR_ENHANCED                          1
#define GET_CLR_CAPTION                           2
#define GET_CLR_ACCEL                             3


THREAD STATIC t_sets := {=>}


INIT PROCEDURE __initHbQtSets()
   QResource():registerResource_1( hbqtres_hbqtwidgets() )

   t_sets[ _QSET_GETSFONT    ] := QFont( "Courier New", 10 )
   t_sets[ _QSET_LINESPACING ] := 6
   t_sets[ _QSET_NOMOUSABLE  ] := .F.
   RETURN


EXIT PROCEDURE __exitHbQtSets()
   t_sets := NIL
   RETURN


FUNCTION __hbqtImage( cName )
   RETURN ":/hbqt/resources" + "/" + cName + ".png"


FUNCTION __hbqtGetNextIdAsString( cString )
   STATIC hIDs := {=>}
   IF ! hb_hHasKey( hIDs, cString )
      hIDs[ cString ] := 0
   ENDIF
   RETURN cString + "_" + hb_ntos( ++hIDs[ cString ] )


FUNCTION HbQtSet( nSet, xValue )
   LOCAL xOldValue := t_sets[ nSet ]

   SWITCH nSet
   CASE _QSET_GETSFONT
      IF __objGetClsName( xValue ) == "QFONT"
         t_sets[ _QSET_GETSFONT    ] := xValue
      ENDIF
      EXIT
   CASE _QSET_LINESPACING
      IF HB_ISNUMERIC( xValue ) .AND. xValue >= 0
         t_sets[ _QSET_LINESPACING ] := xValue
      ENDIF
      EXIT
   CASE _QSET_NOMOUSABLE
      IF HB_ISLOGICAL( xValue )
         t_sets[ _QSET_NOMOUSABLE ] := xValue
      ENDIF
      EXIT
   ENDSWITCH

   RETURN xOldValue


FUNCTION HbQtClearGets( oWnd, ... )
   LOCAL oParent

   FOR EACH oParent IN hb_AParams()
      __hbqtBindGetList( oParent, NIL )
   NEXT
   IF HB_ISOBJECT( oWnd )
      oWnd:setParent( QWidget() )
   ENDIF

   RETURN NIL


FUNCTION __hbqtBindGetList( oWnd, GetList )
   LOCAL n, oGetList

   THREAD STATIC t_GetList := {}

   IF HB_ISOBJECT( oWnd )
      IF ( n := AScan( t_GetList, {|e_| e_[ 1 ] == oWnd } ) ) > 0
         oGetList := t_GetList[ n, 2 ]
      ENDIF
      IF HB_ISOBJECT( GetList )
         IF n > 0
            t_GetList[ n, 2 ] := GetList
         ELSE
            AAdd( t_GetList, { oWnd, GetList } )
         ENDIF
      ELSEIF PCount() == 2 .AND. n > 0
         t_GetList[ n,2 ]:oFocusFrame:setParent( QWidget() )
         hb_ADel( t_GetList, n, .T. )
      ENDIF
   ENDIF

   RETURN oGetList


FUNCTION HbQtReadGets( GetList, SayList, oParent, oFont, nLineSpacing, cTitle, xIcon, lNoModal, bProperties, bOnLastGet, lNoFocusFrame )
   LOCAL oFLayout, oEdit, aEdit, oGet, cClsName, oFontM, lFLayout, cCaption, oGetList, oWnd
   LOCAL nLHeight, nAvgWid, cText, nObjHeight, oLabel, aPic
   LOCAL nEditPadding := 4
   LOCAL nMinX := 50000, nMaxX := 0, nMinY := 50000, nMaxY := 0, nMLabW := 0, nMObjW := 0, nCumObjH := 0
   LOCAL nX, nY, nW, nH
   LOCAL aGetList := {}
   LOCAL lFit := .T.

   hb_default( @oFont       , HbQtSet( _QSET_GETSFONT    ) )
   hb_default( @nLineSpacing, HbQtSet( _QSET_LINESPACING ) )
   hb_default( @cTitle      , "Please Fill-up Info!" )
   hb_default( @lNoModal    , .F. )

   IF HB_ISOBJECT( oParent )
      oWnd := oParent
   ELSE
      oWnd := QDialog()
      oWnd:setWindowTitle( cTitle )
      IF HB_ISOBJECT( xIcon ) .AND. __objGetClsName( xIcon ) == "QICON"
         oWnd:setWindowIcon( xIcon )
      ELSEIF HB_ISCHAR( xIcon )
         oWnd:setWindowIcon( QIcon( xIcon ) )
      ENDIF
   ENDIF

   cClsName := __objGetClsName( oWnd )
   IF cClsName == "QFORMLAYOUT"
      oFLayout := oWnd
      oWnd := oFLayout:parent()
   ELSE
      oFLayout := oWnd:layout()
   ENDIF
   lFLayout := ! Empty( oFLayout )

   IF .T.                                         /* Compute row height and formulae to have text width */
      oEdit      := QLineEdit( oWnd )
      oEdit      :  setFont( oFont )
      oFontM     := QFontMetrics( oEdit:font() )
      nObjHeight := oFontM:height() + nEditPadding
      nAvgWid    := oFontM:averageCharWidth()
      nLHeight   := nObjHeight + nLineSpacing
      oEdit      :  setParent( QWidget() )        /* We no longer need it, destroy */
   ENDIF

   IF Len( GetList ) >= 1
      FOR EACH aEdit IN GetList
         oGet       := aEdit[ _QGET_GET ]
         oGet:row   := aEdit[ _QGET_ROW ]
         oGet:col   := aEdit[ _QGET_COL ]
         IF Empty( aEdit[ _QGET_CONTROL ] )
            IF ! Empty( aEdit[ _QGET_SAY ] )
               AAdd( SayList, { aEdit[ _QGET_ROW ], aEdit[ _QGET_COL ], aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ], aEdit[ _QGET_SAYCOLOR ] } )
               oGet:col += Len( Transform( aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ] ) ) + 1
            ENDIF
         ELSE
            lFit := .F.
         ENDIF
      NEXT
   ENDIF

   /* This is independent of @ ... SAY ... GET combined */
   IF Len( SayList ) >= 1 .AND. ! lFLayout
      FOR EACH aPic IN SayList
         cText  := Transform( aPic[ 3 ], aPic[ 4 ] )

         nX    := ( aPic[ 2 ] * nAvgWid ) + 6
         nY    := aPic[ 1 ] * nLHeight
         nW    := 6 + ( Len( cText ) * nAvgWid )
         nH    := nObjHeight
         nMinX := Min( nMinX, nX )
         nMaxX := Max( nMaxX, nX + nW )
         nMinY := Min( nMinY, nY )
         nMaxY := Max( nMaxY, nY + nH )

         oLabel := QLabel( oWnd )
         oLabel:setText( cText )
         oLabel:setFont( oFont )
         oLabel:setAlignment( Qt_AlignLeft + Qt_AlignVCenter )
         oLabel:move( nX, nY )
         oLabel:resize( nW, nH )
      NEXT
   ENDIF

   oGetList := HbQtGetList():New( aGetList )
   oGetList:lastGetBlock := bOnLastGet
   oGetList:focusFrame := ! lNoFocusFrame

   IF Len( GetList ) >= 1
      FOR EACH aEdit IN GetList
         oGet := aEdit[ _QGET_GET ]

         IF Empty( aEdit[ _QGET_CONTROL ] )
            oEdit      := HbQtGet():new()
         ELSE
            oEdit      := HbQtGet():new( aEdit[ _QGET_CONTROL ] )
         ENDIF
         oEdit:widget  := aEdit[ _QGET_TYPE ]
         oEdit:parent  := oWnd
         oEdit:font    := oFont
         oEdit:getList := oGetList
         oEdit:get     := oGet                    /* This is important - all variables will be initialized here instead of in :new() */

         oEdit:toRow   := aEdit[ _QGET_TOROW  ]
         oEdit:toCol   := aEdit[ _QGET_TOCOL  ]
         oEdit:data    := aEdit[ _QGET_DATA   ]

         IF ! Empty( aEdit[ _QGET_COLOR ] )
            oEdit:color := aEdit[ _QGET_COLOR ]
         ENDIF

         IF HB_ISBLOCK( aEdit[ _QGET_VALIDATOR ] )
            oEdit:inputValidator := aEdit[ _QGET_VALIDATOR ]
         ENDIF

         oEdit:mousable := ! aEdit[ _QGET_NOMOUSE ]

         oEdit:create()

         IF Empty( aEdit[ _QGET_CONTROL ] )
            nX    := ( oGet:col * nAvgWid ) + 6
            nY    := oGet:row * nLHeight
            nW    := 6 + ( oEdit:getDispWidth() * nAvgWid )
            nH    := nObjHeight * oEdit:getDispHeight() + iif( aEdit[ _QGET_TYPE ] == "QLineEdit", 0, oEdit:getDispHeight() * nLineSpacing )
            nMinX := Min( nMinX, nX )
            nMaxX := Max( nMaxX, nX + nW )
            nMinY := Min( nMinY, nY )
            nMaxY := Max( nMaxY, nY + nH )
            nMObjW := Max( nMObjW, nW )
            nCumObjH += nH + 6
            //
            IF ! lFLayout
               oEdit:setPosAndSize( { nX, nY }, { nW, nH } )
            ELSE
               oEdit:edit():setMinimumWidth( nW )
               oEdit:edit():setMinimumHeight( nH )
               oEdit:edit():setMaximumWidth( nW )
               oEdit:edit():setMaximumHeight( nH )
            ENDIF
         ENDIF

         IF lFLayout
            cCaption := iif( Empty( aEdit[ _QGET_CAPTION ] ), oGet:name(), aEdit[ _QGET_CAPTION ] )
            nMLabW := Max( nMLabW, 6 + ( Len( cCaption ) * nAvgWid ) )
            oFLayout:addRow( iif( Empty( aEdit[ _QGET_CAPTION ] ), oGet:name(), aEdit[ _QGET_CAPTION ] ), oEdit:edit() )
         ENDIF

         AAdd( aGetList, oEdit )

         IF HB_ISBLOCK( aEdit[ _QGET_PROPERTIES ] )
            Eval( aEdit[ _QGET_PROPERTIES ], oEdit, oEdit:edit() )
         ENDIF

         IF __objGetClsName( oEdit:edit() ) == "QLINEEDIT"
            oEdit:edit:selectAll()
         ENDIF
      NEXT

      aGetList[ 1 ]:edit:setFocus()

      IF lFit                                     /* Fit to the contents maintaining margins */
         IF lFLayout
            oWnd:resize( nMLabW + nMObjW + 10, nCumObjH )
         ELSE
            oWnd:resize( nMaxX + nMinX, nMaxY + nMinY )
         ENDIF
      ENDIF

   ENDIF

   GetList := aGetList                            /* TO match Clipper behavior */
   __hbQtBindGetList( oWnd, oGetList )
   __GetListSetActive( oGetList )
   __GetListLast( oGetList )

   /* Probably will be fired only when oWnd is a top level window - needs to be investigated further */
   oWnd:connect( QEvent_Close, {|| HbQtClearGets( oWnd ), .F. } )

   IF HB_ISBLOCK( bProperties )
      Eval( bProperties, oWnd, oGetList )
   ENDIF

   IF ! HB_ISOBJECT( oParent )
      IF ! lNoModal
         oWnd:setModal( .T. )
      ENDIF
      oWnd:show()
   ENDIF

   RETURN NIL


/*----------------------------------------------------------------------*/


CREATE CLASS HbQtGetList INHERIT HbGetList

   METHOD new( aGetList )
   METHOD goNext( oGet )
   METHOD goPrevious( oGet )
   METHOD goTop( oGet )
   METHOD goBottom( oGet )
   METHOD isFirstGet( oGet )
   METHOD isLastGet( oGet )
   METHOD nextGet( oGet )
   METHOD previousGet( oGet )
   METHOD getIndex( oGet )
   METHOD setFocus( cGet )

   DATA   bOnLastGet
   METHOD lastGetBlock( bBlock )                  SETGET

   DATA   oFocusFrame
   DATA   lFocusFrame                             INIT .T.
   METHOD focusFrame                              SETGET

   ENDCLASS


METHOD HbQtGetList:new( aGetList )

   ::HbGetList:new( aGetList )
   ::oFocusFrame := QFocusFrame()
   ::oFocusFrame:setStyleSheet( "border: 1px solid red;" )

   RETURN Self


METHOD HbQtGetList:lastGetBlock( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::bOnLastGet := bBlock
   ENDIF

   RETURN ::bOnLastGet


METHOD HbQtGetList:getIndex( oGet )
   RETURN AScan( ::aGetList, {|o| o == oGet } )


METHOD HbQtGetList:goNext( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n < Len( ::aGetList )
         ::aGetList[ n + 1 ]:setFocus( Qt_TabFocusReason )
         RETURN ::aGetList[ n + 1 ]
      ELSE
         ::aGetList[ 1 ]:setFocus( Qt_TabFocusReason )
         RETURN ::aGetList[ 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goPrevious( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n > 1
         ::aGetList[ n - 1 ]:setFocus( Qt_BacktabFocusReason )
         RETURN ::aGetList[ n - 1 ]
      ELSE
         ATail( ::aGetList ):setFocus( Qt_BacktabFocusReason )
         RETURN ATail( ::aGetList )
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goTop( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n > 1
         ::aGetList[ 1 ]:setFocus( Qt_TabFocusReason )
         RETURN ::aGetList[ 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goBottom( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n < Len( ::aGetList )
         ::aGetList[ Len( ::aGetList ) ]:setFocus( Qt_BacktabFocusReason )
         RETURN ::aGetList[ Len( ::aGetList ) ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:isFirstGet( oGet )
   RETURN ::getIndex( oGet ) == 1


METHOD HbQtGetList:isLastGet( oGet )
   RETURN ::getIndex( oGet ) == Len( ::aGetList )


METHOD HbQtGetList:nextGet( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n == Len( ::aGetList )
         RETURN ::aGetList[ 1 ]
      ELSE
         RETURN ::aGetList[ n + 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:previousGet( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n == 1
         RETURN ATail( ::aGetList )
      ELSE
         RETURN ::aGetList[ n - 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:setFocus( cGet )

   LOCAL n, oGet

   IF HB_ISCHAR( cGet )
      cGet := Upper( cGet )
      IF ( n := AScan( ::aGetList, {|oGet| Upper( oGet:name() ) == cGet } ) ) > 0
         oGet := ::aGetList[ n ]
         oGet:setFocus( Qt_TabFocusReason )
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:focusFrame( lFocusFrame )

   IF HB_ISLOGICAL( lFocusFrame )
      ::lFocusFrame := lFocusFrame
   ENDIF

   RETURN ::lFocusFrame

/*----------------------------------------------------------------------*/

FUNCTION __hbqtRgbStringFromColorString( cToken, lExt )

   IF Upper( Left( cToken, 3 ) ) == "RGB"    /* rgb notation : rgb(200,12,201)/rgb(104,56,19) */
      RETURN cToken
   ENDIF
   IF Left( cToken, 1 ) == "#"               /* Hex notation : #fffccc/#da3f78 */
      RETURN cToken
   ENDIF

   SWITCH Upper( cToken )                    /* Clipper notation : W+/BG* */
   CASE "N"
      RETURN iif( lExt, "rgb( 198,198,198 )", "rgb( 0 ,0 ,0  )"   )
   CASE "B"
      RETURN iif( lExt, "rgb( 0,0,255 )"    , "rgb( 0,0,133 )"    )
   CASE "G"
      RETURN iif( lExt, "rgb( 96,255,96 )"  , "rgb( 0 ,133,0  )"  )
   CASE "BG"
      RETURN iif( lExt, "rgb( 96,255,255 )" , "rgb( 0 ,133,133 )" )
   CASE "R"
      RETURN iif( lExt, "rgb( 248,0,38 )"   , "rgb( 133,0 ,0  )"  )
   CASE "RB"
      RETURN iif( lExt, "rgb( 255,96,255 )" , "rgb( 133,0 ,133  " )
   CASE "GR"
      RETURN iif( lExt, "rgb( 255,255,0 )"  , "rgb( 133,133,0 )"  )
   CASE "W"
      RETURN iif( lExt, "rgb( 255,255,255 )", "rgb( 96,96,96 )"   )
   ENDSWITCH
   RETURN ""


FUNCTION __hbqtCSSFromColorString( cColor )
   LOCAL cCSS := ""
   LOCAL n, xFore, xBack, lExt, cCSSF, cCSSB

      IF ( n := At( "/", cColor ) ) > 0
         xFore := AllTrim( SubStr( cColor, 1, n-1 ) )
         xBack := AllTrim( SubStr( cColor, n+1 ) )
      ELSE
         xFore := AllTrim( cColor )
         xBack := ""
      ENDIF

      IF ! Empty( xFore )
         lExt := At( "+", xFore ) > 0
         xFore := StrTran( StrTran( xFore, "+" ), "*" )
         cCSSF := __hbqtRgbStringFromColorString( xFore, lExt )
      ENDIF
      IF ! Empty( xBack )
         lExt := "+" $ xBack .OR. "*" $ xBack
         xBack := StrTran( StrTran( xBack, "+" ), "*" )
         cCSSB := __hbqtRgbStringFromColorString( xBack, lExt )
      ENDIF
      IF ! Empty( cCSSF )
         cCSS := "color: " + cCSSF
      ENDIF
      IF ! Empty( cCSSB )
         cCSS += "; background-color: " + cCSSB
      ENDIF

      IF ! Empty( cCSS )
         cCSS += ";"
      ENDIF

   RETURN cCSS


FUNCTION __hbqtHbColorToQtValue( cColor, nRole )

   LOCAL lExt, cClr, n, xFore, xBack

   IF Empty( cColor )
      IF nRole == Qt_BackgroundRole
         RETURN Qt_white
      ELSE
         RETURN Qt_black
      ENDIF
   ENDIF

   cColor := Upper( cColor )

   IF ( n := At( "/", cColor ) ) > 0
      xFore := AllTrim( SubStr( cColor, 1, n-1 ) )
      xBack := AllTrim( SubStr( cColor, n+1 ) )
   ELSE
      xFore := AllTrim( cColor )
      xBack := ""
   ENDIF

   IF nRole == Qt_BackgroundRole
      lExt := "+" $ xBack .OR. "*" $ xBack
      cClr := StrTran( StrTran( xBack, "+" ), "*" )
   ELSEIF nRole == Qt_ForegroundRole
      lExt := "+" $ xFore .OR. "*" $ xFore
      cClr := StrTran( StrTran( xFore, "+" ), "*" )
   ENDIF

   SWITCH cClr
   CASE "N"
      RETURN iif( lExt, Qt_darkGray, Qt_black       )
   CASE "B"
      RETURN iif( lExt, Qt_blue    , Qt_darkBlue    )
   CASE "G"
      RETURN iif( lExt, Qt_green   , Qt_darkGreen   )
   CASE "BG"
      RETURN iif( lExt, Qt_cyan    , Qt_darkCyan    )
   CASE "R"
      RETURN iif( lExt, Qt_red     , Qt_darkRed     )
   CASE "RB"
      RETURN iif( lExt, Qt_magenta , Qt_darkMagenta )
   CASE "GR"
      RETURN iif( lExt, Qt_yellow  , Qt_darkYellow  )
   CASE "W"
      RETURN iif( lExt, Qt_white   , Qt_lightGray   )

   ENDSWITCH

   RETURN 0


FUNCTION __hbqtGetWindowFrameWidthHeight( oWnd )
   LOCAL oRectFG := oWnd:frameGeometry()
   LOCAL oRectG  := oWnd:geometry()

   RETURN { oRectFG:width() - oRectG:width(), oRectFG:height() - oRectG:height() }

