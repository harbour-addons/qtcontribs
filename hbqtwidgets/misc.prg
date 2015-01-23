/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "hbtrace.ch"
#include "common.ch"



THREAD STATIC t_sets := {=>}

STATIC s_hHarbourFuncList := {=>}
STATIC s_hQtFuncList := {=>}
STATIC s_hUserFuncList := {=>}
STATIC s_timerSingleShot


INIT PROCEDURE __initHbQtSets()
   LOCAL oFont := QFont( "Courier New", 10 )

   oFont:setFixedPitch( .T. )

   QResource():registerResource_1( hbqtres_hbqtwidgets() )

   t_sets[ _QSET_GETSFONT     ] := oFont
   t_sets[ _QSET_LINESPACING  ] := 6
   t_sets[ _QSET_NOMOUSABLE   ] := .F.
   t_sets[ _QSET_EDITSPADDING ] := 4

   hb_HCaseMatch( s_hHarbourFuncList, .F. )
   hb_HKeepOrder( s_hHarbourFuncList, .T. )

   __hbqtStackHarbourFuncList()

   s_hHarbourFuncList[ "HB_SYMBOL_UNUSED" ] := "HB_SYMBOL_UNUSED"

   hb_HCaseMatch( s_hQtFuncList, .F. )
   hb_HKeepOrder( s_hQtFuncList, .T. )

   __hbqtStackQtFuncList()

   hb_HCaseMatch( s_hUserFuncList, .F. )
   hb_HKeepOrder( s_hUserFuncList, .T. )
   RETURN


EXIT PROCEDURE __exitHbQtSets()
   t_sets := NIL
   RETURN


FUNCTION __hbqtImage( cName )
   RETURN ":/hbqt/resources" + "/" + cName + ".png"


FUNCTION __hbqtGetNextIdAsString( cString )
   STATIC hIDs := {=>}
   IF Empty( hIDs )
      hb_HCaseMatch( hIDs, .F. )
   ENDIF
   IF ! hb_hHasKey( hIDs, cString )
      hIDs[ cString ] := 0
   ELSE
      cString += "_" + hb_ntos( ++hIDs[ cString ] )
   ENDIF
   RETURN cString


FUNCTION __hbqtGetBlankValue( xValue )
   SWITCH ValType( xValue )
   CASE "C" ; RETURN Space( Len( xValue ) )
   CASE "N" ; RETURN 0
   CASE "D" ; RETURN CToD( "" )
   CASE "L" ; RETURN .F.
   ENDSWITCH
   RETURN ""


FUNCTION HbQtSet( nSet, xValue )
   LOCAL xOldValue := t_sets[ nSet ]

   SWITCH nSet
   CASE _QSET_EDITSPADDING
      IF HB_ISNUMERIC( xValue ) .AND. xValue >= 0
         t_sets[ _QSET_EDITSPADDING ] := xValue
      ENDIF
      EXIT
   CASE _QSET_GETSFONT
      IF __objGetClsName( xValue ) == "QFONT"
         t_sets[ _QSET_GETSFONT    ] := NIL
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


FUNCTION __hbqtRgbStringFromColors( aColors )
   LOCAL cFore := "", cBack := ""

   /* Clipper color string "W+/BG" */
   IF HB_ISCHAR( aColors )
      RETURN __hbqtCSSFromColorString( aColors )
   ELSEIF HB_ISNUMERIC( aColors )
      cFore := "#" + hb_ntos( aColors )
   /* { {12,12,12},{13,13,13} } */
   ELSEIF HB_ISARRAY( aColors ) .AND. Len( aColors ) == 2 .AND. HB_ISARRAY( aColors[ 1 ] ) .AND. HB_ISARRAY( aColors[ 2 ] )
      cFore := __hbqtRgbStringFromRGB( aColors[ 1 ] )
      cBack := __hbqtRgbStringFromRGB( aColors[ 2 ] )
   /* { "rgb(12,12,12)","rgb(13,13,13)" } */
   ELSEIF HB_ISARRAY( aColors ) .AND. Len( aColors ) == 2 .AND. HB_ISCHAR( aColors[ 1 ] ) .AND. HB_ISCHAR( aColors[ 2 ] )
      cFore := aColors[ 1 ]
      cBack := aColors[ 2 ]
   /* {r, g, b }*/
   ELSEIF HB_ISARRAY( aColors ) .AND. Len( aColors ) == 3
      cFore := __hbqtRgbStringFromRGB( aColors )
   ENDIF

   RETURN iif( Empty( cFore ), "", "color: " + cFore + ";" ) + iif( Empty( cBack ), "", "background-color: " + cBack + ";" )


FUNCTION __hbqtRgbStringFromRGB( aRgb )
   RETURN "rgb(" + hb_ntos( aRgb[ 1 ] ) + "," + hb_ntos( aRgb[ 2 ] ) + "," + hb_ntos( aRgb[ 3 ] ) + ")"


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


FUNCTION __hbqtGetGlobalXYFromRowColumn( oWnd, nRow, nCol, oFont )  // => { nX, nY, nColWidth, nRowHeight }
   LOCAL oFM, nX, nY, oPos, nOH

   IF oWnd:font():fixedPitch()
      oFM  := QFontMetrics( oWnd:font() )
   ELSE
      __defaultNIL( @oFont , HbQtSet( _QSET_GETSFONT ) )
      oFM  := QFontMetrics( oFont )
   ENDIF

   nX   := ( oFM:averageCharWidth() * nCol ) + 6
   nOH  := oFM:height() + HbQtSet( _QSET_LINESPACING ) + HbQtSet( _QSET_EDITSPADDING )
   nY   := nOH * nRow
   oPos := oWnd:mapToGlobal( QPoint( nX, nY ) )

   RETURN { oPos:x(), oPos:y(), oFM:averageCharWidth(), nOH }


FUNCTION __hbqtGetXYFromRowColumn( oWnd, nRow, nCol, oFont )  // => { nX, nY, nColWidth, nRowHeight }
   LOCAL oFM, nX, nY, nOH

   IF oWnd:font():fixedPitch()
      oFM  := QFontMetrics( oWnd:font() )
   ELSE
      __defaultNIL( @oFont , HbQtSet( _QSET_GETSFONT ) )
      oFM  := QFontMetrics( oFont )
   ENDIF

   nX   := ( oFM:averageCharWidth() * nCol ) + 6
   nOH  := oFM:height() + HbQtSet( _QSET_LINESPACING ) + HbQtSet( _QSET_EDITSPADDING )
   nY   := nOH * nRow
   RETURN { nX, nY, oFM:averageCharWidth(), nOH }


FUNCTION __hbqtPositionWindowClientXY( oWnd, nX, nY )
   LOCAL a_:= __hbqtGetWindowFrameWidthHeight( oWnd )

   oWnd:move( nX - ( a_[ 1 ] / 2 ), nY - ( a_[ 2 ] - ( a_[ 1 ] / 2 ) ) )
   RETURN NIL


FUNCTION __hbqtGetADialogOnTopOf( oParent, nTop, nLeft, nBottom, nRight, cTitle, oFont, lResizable )
   LOCAL oDlg, aInfo, nX, nY, nW, nH, nFlags

   __defaultNIL( @lResizable, .T. )

   aInfo := __hbqtGetGlobalXYFromRowColumn( oParent, nTop, nLeft, oFont )
   nX := aInfo[ 1 ]; nY := aInfo[ 2 ]; nW := aInfo[ 3 ] * ( nRight - nLeft + 1 ) ; nH := aInfo[ 4 ] * ( nBottom - nTop + 1 )

   WITH OBJECT oDlg := QDialog( oParent )
      nFlags := Qt_Dialog + Qt_CustomizeWindowHint
      IF HB_ISCHAR( cTitle ) .AND. ! Empty( cTitle )
         nFlags += Qt_WindowTitleHint
         :setWindowTitle( cTitle )
      ENDIF
      :setWindowFlags( nFlags )
      IF HB_ISOBJECT( oFont )
         :setFont( oFont )
      ENDIF
      //
      // Initially, though not needed, but just in case
      :move( nX, nY )
      :resize( nW, nH )
      //
      :connect( QEvent_Close, {|| oDlg:setParent( QWidget() ) } )
      :connect( QEvent_Show , {|| __hbqtPositionWindowClientXY( oDlg, nX, nY ), iif( lResizable, NIL, __hbqtSetWindowFixedSized( oDlg ) ), .F. } )
   ENDWITH

   RETURN oDlg


FUNCTION __hbqtSetWindowFixedSized( oWnd )

   oWnd:setMaximumHeight( oWnd:height() )
   oWnd:setMaximumWidth( oWnd:width() )
   oWnd:setMinimumHeight( oWnd:height() )
   oWnd:setMinimumWidth( oWnd:width() )

   RETURN NIL


FUNCTION __hbqtSetLastKey( nKey )
   LOCAL l_nKey
   STATIC s_nKey := 0
   l_nKey := s_nKey
   IF HB_ISNUMERIC( nKey )
      s_nKey := nKey
   ENDIF
   RETURN l_nKey


FUNCTION __hbqtPixelsByDPI( nPixels, nBase, lDeviceRatio )
   LOCAL nDpi := QApplication():primaryScreen():logicalDotsPerInchY()

   DEFAULT nBase        TO 96
   DEFAULT lDeviceRatio TO .F.

   HB_SYMBOL_UNUSED( lDeviceRatio )
   RETURN Int( ( nDpi * nPixels / nBase ) * iif( lDeviceRatio, QApplication():primaryScreen():devicePixelRatio(), 1 ) )


FUNCTION __hbqtCssPX( nPixels, nBase, lDeviceRatio )
   RETURN LTrim( Str( __hbqtPixelsByDPI( nPixels, nBase, lDeviceRatio ) ) ) + "px;"


FUNCTION __hbqtHHasKey( hHash, xKey, xValue )     // <xValue> must be passed by reference
   IF HB_ISHASH( hHash ) .AND. hb_HHasKey( hHash, xKey )
      xValue := hHash[ xKey ]
      RETURN .T.
   ENDIF
   RETURN .F.


FUNCTION __hbqtStandardHash( cKey, xValue )
   LOCAL hHash := {=>}

   hb_HKeepOrder( hHash, .T. )
   hb_HCaseMatch( hHash, .F. )
   IF HB_ISSTRING( cKey ) .AND. ! Empty( cKey )
      hHash[ cKey ] := xValue
   ENDIF
   RETURN hHash


FUNCTION __hbqtLoadPixmapFromBuffer( cBuffer, cFormat )
   LOCAL oPixmap := QPixmap()
   DEFAULT cFormat TO "PNG"
   oPixmap:loadFromData( cBuffer, Len( cBuffer ), cFormat )
   RETURN oPixmap


FUNCTION  __hbqtIconFromBuffer( cBuffer )
   LOCAL oPixmap := QPixmap()
   oPixmap:loadFromData( cBuffer, Len( cBuffer ), "PNG" )
   RETURN QIcon( oPixmap )


FUNCTION __hbqtLoadResource( cResource )
   LOCAL cBuffer, oB, oFile

   oFile := QFile( cResource )
   IF oFile:open( QIODevice_ReadOnly )
      oB := oFile:readAll()
      cBuffer := oB:toBase64():data()
      oFile:close()
   ELSE
      cBuffer := ""
   ENDIF
   RETURN cBuffer


FUNCTION __hbqtLoadResourceAsBase64String( cResource )
   LOCAL cBuffer, oB, oFile

   oFile := QFile( ":/hbqt/resources/" + cResource )
   IF oFile:open( QIODevice_ReadOnly )
      oB := oFile:readAll()
      cBuffer := oB:toBase64():data()
      oFile:close()
   ELSE
      cBuffer := ""
   ENDIF
   RETURN cBuffer


FUNCTION __hbqtRgbaCssStr( aRgb )
   RETURN "rgba(" + hb_ntos( aRgb[ 1 ] ) + "," +  hb_ntos( aRgb[ 2 ] ) + "," + hb_ntos( aRgb[ 3 ] ) + ",255)"


FUNCTION __hbqtRgbaCssStrDarker( aRgb, nFactor )
   LOCAL oColor := QColor( aRgb[ 1 ], aRgb[ 2 ], aRgb[ 3 ] ):darker( nFactor )
   RETURN "rgba(" + hb_ntos( oColor:red() ) + "," +  hb_ntos( oColor:green() ) + "," + hb_ntos( oColor:blue() ) + ",255)"


FUNCTION __hbqtUndoScroller( oScrollableWidget )
   QScroller():scroller( oScrollableWidget ):ungrabGesture( oScrollableWidget )
   RETURN NIL


FUNCTION __hbqtApplyStandardScroller( oScrollableWidget )
   LOCAL oScrollerProperties
   LOCAL oScroller := QScroller():scroller( oScrollableWidget )

   WITH OBJECT oScrollerProperties := oScroller:scrollerProperties()
      :setScrollMetric( QScrollerProperties_OvershootDragDistanceFactor  , QVariant( 0 ) )
      :setScrollMetric( QScrollerProperties_OvershootScrollDistanceFactor, QVariant( 0 ) )
   ENDWITH
   oScroller:setScrollerProperties( oScrollerProperties )
   oScroller:grabGesture( oScrollableWidget, QScroller_LeftMouseButtonGesture )
   RETURN oScroller                               // in case to finetune other properties


FUNCTION __hbqtApplyTouchScroller( oScrollableWidget )
   LOCAL oScrollerProperties
   LOCAL oScroller := QScroller():scroller( oScrollableWidget )

   WITH OBJECT oScrollerProperties := oScroller:scrollerProperties()
      :setScrollMetric( QScrollerProperties_OvershootDragDistanceFactor  , QVariant( 0 ) )
      :setScrollMetric( QScrollerProperties_OvershootScrollDistanceFactor, QVariant( 0 ) )
   ENDWITH
   oScroller:setScrollerProperties( oScrollerProperties )
   oScroller:grabGesture( oScrollableWidget, QScroller_TouchGesture )
   RETURN oScroller                               // in case to finetune other properties


FUNCTION __hbqtGradientBrush( oColorStart, oColorStop, nType )
   LOCAL oGrad

   DEFAULT nType TO 0

   SWITCH nType
   CASE 0                              // default left-right {0,0},{1,0}
      oGrad := QLinearGradient( 0, 0, 100, 100 )
      EXIT
   CASE 1                              // top-down
      oGrad := QLinearGradient()
      EXIT
   ENDSWITCH

   WITH OBJECT oGrad
      :setColorAt( 0, oColorStart )
      :setColorAt( 1, oColorStop  )
   ENDWITH
   RETURN QBrush( oGrad )


FUNCTION __hbqtApplicationWidget()
   RETURN QApplication():topLevelAt( 0,0 )


FUNCTION __hbqtAppWidget( oWidget )
   STATIC s_oWidget
   LOCAL oldWidget := s_oWidget

   IF HB_ISOBJECT( oWidget )
      s_oWidget := oWidget
   ELSE
      IF PCount() == 1 .AND. oWidget == NIL
         s_oWidget := NIL
      ELSEIF Empty( oldWidget )
         oldWidget := __hbqtApplicationWidget()
      ENDIF
   ENDIF
   RETURN oldWidget


FUNCTION __hbqtTreeViewStyleSheet()
   LOCAL aCSS := {}
   LOCAL cCSS := ""
   //LOCAL cColorTreeBranch := "rgba( 255, 255, 220, 255 );"
   LOCAL cColorTreeBranch := "rgba( 180,180,180, 255 );"

   AAdd( aCSS, 'QTreeView {' )
   AAdd( aCSS, '    paint-alternating-row-colors-for-empty-area: true;' )
   AAdd( aCSS, '    show-decoration-selected: 1;' )
   AAdd( aCSS, '    font-size: '                 + __hbqtCssPX( 16 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item { ' )
   AAdd( aCSS, '    min-height: '                + __hbqtCssPX( 40 ) )
   AAdd( aCSS, '    border-right: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '    border-bottom: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::branch:has-children {' )
   AAdd( aCSS, '    background: ' + cColorTreeBranch )
   AAdd( aCSS, '    border-color: ' + cColorTreeBranch )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item:has-children {' )
   AAdd( aCSS, '    background: ' + cColorTreeBranch )
   AAdd( aCSS, '    color: black;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::branch:has-children:!has-siblings:closed,' )
   AAdd( aCSS, 'QTreeView::branch:closed:has-children:has-siblings {' )
   AAdd( aCSS, '    border-image: none;' )
   AAdd( aCSS, '    border-bottom: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '    image: url(:/hbqt/resources/branch-closed.png);' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::branch:open:has-children:!has-siblings,' )
   AAdd( aCSS, 'QTreeView::branch:open:has-children:has-siblings  {' )
   AAdd( aCSS, '    border-image: none;' )
   AAdd( aCSS, '    border-bottom: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '    image: url(:/hbqt/resources/branch-open.png);' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item:selected:!active {' )
   AAdd( aCSS, '    background: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 yellow, stop: 1 red);' )
   AAdd( aCSS, '    color: black;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item:pressed {' )
   AAdd( aCSS, '    background: white;' )
   AAdd( aCSS, '    color: black;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item:selected:active {' )
   AAdd( aCSS, '    background: white;' )
   AAdd( aCSS, '    color: black;' )
   AAdd( aCSS, '}' )

   AEval( aCSS, {|e| cCSS += e + Chr( 13 )+Chr( 10 ) } )

   RETURN cCSS


FUNCTION HbQtActivateSilverLight( lActivate, xContent, oColor, lAnimate, aOpacity, oWidget )
   STATIC oSilverLight

   IF Empty( oSilverLight )
      oSilverLight := HbQtSilverLight():new():create( "Please Wait..." )
   ENDIF
   IF lActivate
      oSilverLight:activate( xContent, oColor, lAnimate, aOpacity, oWidget )
   ELSE
      oSilverLight:deactivate()
   ENDIF

   RETURN NIL


FUNCTION __hbqtSetPosAndSizeByCParams( oWidget, cParams )
   LOCAL aRect

   IF ! Empty( cParams )
      aRect := hb_ATokens( cParams, "," )
      aeval( aRect, {|e,i| aRect[ i ] := val( e ) } )
      oWidget:move( aRect[ 1 ], aRect[ 2 ] )
      oWidget:resize( aRect[ 3 ], aRect[ 4 ] )
   ENDIF
   RETURN NIL


FUNCTION __hbqtSetPosByCParams( oWidget, cParams )
   LOCAL aRect

   IF ! Empty( cParams )
      aRect := hb_ATokens( cParams, "," )
      aeval( aRect, {|e,i| aRect[ i ] := val( e ) } )
      oWidget:move( aRect[ 1 ], aRect[ 2 ] )
   ENDIF
   RETURN NIL


FUNCTION __hbqtPosAndSizeAsCParams( oWidget )
   LOCAL cParams := ""
   IF HB_ISOBJECT( oWidget )
      cParams := hb_ntos( oWidget:x() ) + "," + hb_ntos( oWidget:y() ) + "," +hb_ntos( oWidget:width() ) + "," +hb_ntos( oWidget:height() )
   ENDIF
   RETURN cParams


FUNCTION __hbqtStyleConvert( cProperty, cnStyleOrValue )
   LOCAL cStyle
   LOCAL nValue

   STATIC hBrushStyles
   STATIC hPenStyles
   STATIC hCapStyles
   STATIC hJoinStyles

   IF Empty( hBrushStyles )
      hBrushStyles := __hbqtStandardHash()
      hPenStyles   := __hbqtStandardHash()
      hCapStyles   := __hbqtStandardHash()
      hJoinStyles  := __hbqtStandardHash()

      hBrushStyles[ "NoBrush"                ] := Qt_NoBrush
      hBrushStyles[ "SolidPattern"           ] := Qt_SolidPattern
      hBrushStyles[ "Dense1Pattern"          ] := Qt_Dense1Pattern
      hBrushStyles[ "Dense2Pattern"          ] := Qt_Dense2Pattern
      hBrushStyles[ "Dense3Pattern"          ] := Qt_Dense3Pattern
      hBrushStyles[ "Dense4Pattern"          ] := Qt_Dense4Pattern
      hBrushStyles[ "Dense5Pattern"          ] := Qt_Dense5Pattern
      hBrushStyles[ "Dense6Pattern"          ] := Qt_Dense6Pattern
      hBrushStyles[ "Dense7Pattern"          ] := Qt_Dense7Pattern
      hBrushStyles[ "HorPattern"             ] := Qt_HorPattern
      hBrushStyles[ "VerPattern"             ] := Qt_VerPattern
      hBrushStyles[ "CrossPattern"           ] := Qt_CrossPattern
      hBrushStyles[ "BDiagPattern"           ] := Qt_BDiagPattern
      hBrushStyles[ "FDiagPattern"           ] := Qt_FDiagPattern
      hBrushStyles[ "DiagCrossPattern"       ] := Qt_DiagCrossPattern
      hBrushStyles[ "LinearGradientPattern"  ] := Qt_LinearGradientPattern
      hBrushStyles[ "ConicalGradientPattern" ] := Qt_ConicalGradientPattern
      hBrushStyles[ "RadialGradientPattern"  ] := Qt_RadialGradientPattern
      hBrushStyles[ "TexturePattern"         ] := Qt_TexturePattern

      hPenStyles[ "NoPen"          ] := Qt_NoPen
      hPenStyles[ "SolidLine"      ] := Qt_SolidLine
      hPenStyles[ "DashLine"       ] := Qt_DashLine
      hPenStyles[ "DotLine"        ] := Qt_DotLine
      hPenStyles[ "DashDotLine"    ] := Qt_DashDotLine
      hPenStyles[ "DashDotDotLine" ] := Qt_DashDotDotLine

      hCapStyles[ "FlatCap"        ] := Qt_FlatCap
      hCapStyles[ "RoundCap"       ] := Qt_RoundCap
      hCapStyles[ "SquareCap"      ] := Qt_SquareCap

      hJoinStyles[ "BevelJoin"     ] := Qt_BevelJoin
      hJoinStyles[ "MiterJoin"     ] := Qt_MiterJoin
      hJoinStyles[ "RoundJoin"     ] := Qt_RoundJoin
      hJoinStyles[ "SvgMiterJoin"  ] := Qt_SvgMiterJoin
   ENDIF

   IF HB_ISSTRING( cnStyleOrValue )
      cStyle := cnStyleOrValue

      SWITCH Lower( cProperty )
      CASE "penstyle"  ; RETURN iif( hb_HHasKey( hPenStyles, cStyle ), hPenStyles[ cStyle ], Qt_SolidLine )
      CASE "capstyle"  ; RETURN iif( hb_HHasKey( hCapStyles, cStyle ), hCapStyles[ cStyle ], Qt_FlatCap )
      CASE "joinstyle" ; RETURN iif( hb_HHasKey( hJoinStyles, cStyle ), hJoinStyles[ cStyle ], Qt_BevelJoin )
      CASE "brushstyle"; RETURN iif( hb_HHasKey( hBrushStyles, cStyle ), hBrushStyles[ cStyle ], Qt_NoBrush )
      ENDSWITCH
   ELSE
      SWITCH Lower( cProperty )
      CASE "penstyle"
         FOR EACH nValue IN hPenStyles
            IF nValue == cnStyleOrValue
               RETURN nValue:__enumKey()
            ENDIF
         NEXT
         EXIT
      CASE "capstyle"
         FOR EACH nValue IN hCapStyles
            IF nValue == cnStyleOrValue
               RETURN nValue:__enumKey()
            ENDIF
         NEXT
         EXIT
      CASE "joinstyle"
         FOR EACH nValue IN hJoinStyles
            IF nValue == cnStyleOrValue
               RETURN nValue:__enumKey()
            ENDIF
         NEXT
         EXIT
      CASE "brushstyle"
         FOR EACH nValue IN hBrushStyles
            IF nValue == cnStyleOrValue
               RETURN nValue:__enumKey()
            ENDIF
         NEXT
         EXIT
      ENDSWITCH
   ENDIF

   RETURN iif( HB_ISSTRING( cnStyleOrValue ), -1, "" )


PROCEDURE __hbqtActivateTimerSingleShot( nMSeconds, bBlock )

   s_timerSingleShot := NIL
   WITH OBJECT s_timerSingleShot := QTimer()
      :setSingleShot( .T. )
      :setInterval( nMSeconds )
      :connect( "timeout()", bBlock )
      :start()
   ENDWITH
   RETURN

//--------------------------------------------------------------------//
//                Managed Function Lists for HbQtEditor
//--------------------------------------------------------------------//

STATIC FUNCTION __addInList( hHash, aList )
   LOCAL s

   FOR EACH s IN aList
      s := AllTrim( s )
      IF ! Empty( s )
         hHash[ s ] := s
      ENDIF
   NEXT
   RETURN NIL


PROCEDURE __hbqtStackHarbourFuncList( aFunctions )
   DEFAULT aFunctions TO  __hbqtPullHarbourFunctions( __getHarbourHbx() )
   __addInList( s_hHarbourFuncList, aFunctions )
   RETURN


PROCEDURE __hbqtStackQtFuncList( aFunctions )
   IF Empty( aFunctions )
      __addInList( s_hQtFuncList, __hbqtPullQtFunctions( __getQtCoreFilelist() ) )
      __addInList( s_hQtFuncList, __hbqtPullQtFunctions( __getQtGuiFilelist() ) )
      __addInList( s_hQtFuncList, __hbqtPullQtFunctions( __getQtNetworkFilelist() ) )
   ELSE
      __addInList( s_hQtFuncList, aFunctions )
   ENDIF
   RETURN


PROCEDURE __hbqtStackUserFuncList( aFunctions )
   __addInList( s_hUserFuncList, aFunctions )
   RETURN


FUNCTION __hbqtIsHarbourFunction( cWord, cCased )
   IF hb_HHasKey( s_hHarbourFuncList, cWord )
      cCased := s_hHarbourFuncList[ cWord ]
      RETURN .T.
   ENDIF
   RETURN .F.


FUNCTION __hbqtIsQtFunction( cWord, cCased )      // cCased sent by reference
   IF cWord $ s_hQtFuncList
      cCased := s_hQtFuncList[ cWord ]
      RETURN .T.
   ENDIF
   RETURN .F.


FUNCTION __hbqtIsUserFunction( cWord, cCased )
   IF cWord $ s_hUserFuncList
      cCased := s_hUserFuncList[ cWord ]
      RETURN .T.
   ENDIF
   RETURN .F.


/* Pulled from harbour/bin/find.hb and adopted for file as buffer */
STATIC FUNCTION __hbqtPullHarbourFunctions( cBuffer )
   LOCAL pRegex, tmp
   LOCAL aDynamic := {}

   IF ! Empty( cBuffer ) .AND. ;
      ! Empty( pRegex := hb_regexComp( "^DYNAMIC ([a-zA-Z0-9_]*)$", .T., .T. ) )
      FOR EACH tmp IN hb_regexAll( pRegex, StrTran( cBuffer, Chr( 13 ) ),,,,, .T. )
         AAdd( aDynamic, tmp[ 2 ] )
      NEXT
   ENDIF
   RETURN aDynamic


STATIC FUNCTION __hbqtPullQtFunctions( cBuffer )
   LOCAL pRegex, tmp
   LOCAL aDynamic := {}

   IF ! Empty( cBuffer ) .AND. ;
      ! Empty( pRegex := hb_regexComp( "^([a-zA-Z0-9_]*.qth)$", .T., .T. ) )
      FOR EACH tmp IN hb_regexAll( pRegex, StrTran( cBuffer, Chr( 13 ) ),,,,, .T. )
         AAdd( aDynamic, StrTran( tmp[ 1 ], ".qth" ) )
      NEXT
   ENDIF
   RETURN aDynamic

//--------------------------------------------------------------------//
//           This Section Must be the Last in this Source
//--------------------------------------------------------------------//

#pragma -km+

STATIC FUNCTION __getHarbourHbx()
   #pragma __binarystreaminclude "harbour.hbx" | RETURN %s

FUNCTION __getQtCoreFilelist()
   #pragma __binarystreaminclude "../hbqt/qtcore/qth/filelist.hbm" | RETURN %s

FUNCTION __getQtGuiFilelist()
   #pragma __binarystreaminclude "../hbqt/qtgui/qth/filelist.hbm" | RETURN %s

FUNCTION __getQtNetworkFilelist()
   #pragma __binarystreaminclude "../hbqt/qtnetwork/qth/filelist.hbm" | RETURN %s

