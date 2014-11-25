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


#include "hbqtgui.ch"
#include "hbqtstd.ch"
#include "inkey.ch"
#include "hbtrace.ch"
#include "common.ch"


#define P_X( n )                                  ( LTrim( Str( ::oApp:primaryScreen():logicalDotsPerInchY() * n / 96, 10, 0 ) ) + "px;" )
#define P_XX( n )                                 ( Int( ::oApp:primaryScreen():logicalDotsPerInchY() * n / 96 ) )


THREAD STATIC t_sets := {=>}


INIT PROCEDURE __initHbQtSets()
   QResource():registerResource_1( hbqtres_hbqtwidgets() )

   t_sets[ _QSET_GETSFONT     ] := QFont( "Courier New", 10 )
   t_sets[ _QSET_LINESPACING  ] := 6
   t_sets[ _QSET_NOMOUSABLE   ] := .F.
   t_sets[ _QSET_EDITSPADDING ] := 4
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
   DEFAULT lDeviceRatio TO .T.

   RETURN Int( ( nDpi * nPixels / nBase ) * QApplication():primaryScreen():devicePixelRatio() )


FUNCTION __hbqtCssPX( nPixels, nBase, lDeviceRatio )
   RETURN LTrim( Str( __hbqtPixelsByDPI( nPixels, nBase, lDeviceRatio ) ) ) + "px;"


FUNCTION __hbqtStandardHash()
   LOCAL hHash := {=>}
   hb_HKeepOrder( hHash, .T. )
   hb_HCaseMatch( hHash, .F. )
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


FUNCTION __hbqtTreeViewStyleSheet()
   LOCAL aCSS := {}
   LOCAL cCSS := ""
   LOCAL cColorTreeBranch := "rgba( 255, 255, 220, 255 );"

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

