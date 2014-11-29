/*
 * $Id: hbqtbrowse.prg 208 2013-04-19 02:44:23Z bedipritpal $
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR( at your option )
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
 * Boston, MA 02111-1307 USA( OR visit the web site http://www.gnu.org/ ).
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

/*
 *                         Inspired from, thanks
 *            https://github.com/0TheFox0/OpenChart/blob/master/
 */


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"
#include "common.ch"

#include "hbtrace.ch"


#define M_PI                                      3.14159265358979323846

#define HHB_NTOS( n )                             LTrim( Str( n, 12, 0 ) )

#define __toolbarButton_clicked__                 1001

/*----------------------------------------------------------------------*/

CLASS HbQtCharts

   DATA   oParent
   DATA   oWidget
   DATA   oLay
   DATA   oToolbar
   DATA   oLabel
   DATA   oScrollArea
   DATA   oPixmap
   DATA   oPainter

   DATA   oActBars, oActPie, oActPie3D, oActLines, oActShadows, oActLegends, oActLabels, oActValues, oActPrint
   DATA   sp0, sp1, sp2, sp3

   DATA   m_left, m_top, m_bottom, m_right, m_width, m_height, m_xAxis
   DATA   m_maxValue, m_mayor, m_menor
   DATA   m_type
   DATA   m_usingTitle
   DATA   m_title

   DATA   m_useLegend
   DATA   m_tipoLegend

   DATA   m_sombra
   DATA   m_labels
   DATA   m_values
   DATA   m_valuesEnY
   DATA   m_animation
   DATA   m_aniDuration

   DATA   m_letraLegend
   DATA   m_letra

   DATA   pieces
   DATA   multibarColors
   DATA   lineasStops
   DATA   m_percent

   DATA   lToolbar                                INIT .T.

   METHOD init( oParent )
   METHOD create()
   METHOD refresh()
   METHOD buildToolbar()

   METHOD isToolbarEnabled()                      INLINE ::lToolbar
   METHOD enableToolbar( lYes )                   INLINE iif( HB_ISLOGICAL( lYes ), ::lToolbar := lYes, NIL ), iif( ::lToolbar, ::oToolbar:show(), ::oToolbar:hide() )

   METHOD type()                                  INLINE ::m_type
   METHOD SetType( nType )                        INLINE ::m_type := nType, ::refresh()

   METHOD title()                                 INLINE ::m_title
   METHOD setTitle( s )                           INLINE ::m_title := s, ::refresh()

   METHOD isTitleEnabled()                        INLINE ::m_usingTitle
   METHOD enableTitle( b )                        INLINE ::m_usingTitle := b, ::refresh()

   METHOD isLegendEnabled()                       INLINE ::m_useLegend
   METHOD enableLegend( b )                       INLINE ::m_useLegend := b, ::refresh()

   METHOD isShadowsEnabled()                      INLINE ::m_sombra
   METHOD enableShadows( b )                      INLINE ::m_sombra := b, ::refresh()

   METHOD isLabelsEnabled()                       INLINE ::m_labels
   METHOD enableLabels( b )                       INLINE ::m_labels := b, ::refresh()

   METHOD isValuesEnabled()                       INLINE ::m_values
   METHOD enableValues( b )                       INLINE ::m_values := b, ::refresh()

   METHOD isValuesOnYEnabled()                    INLINE ::m_valuesEnY
   METHOD enableVluesOnY( b )                     INLINE ::m_valuesEnY := b, ::refresh()

   METHOD typeOfLegend()                          INLINE ::m_tipoLegend
   METHOD setLegendType( t )                      INLINE ::m_tipoLegend := t, ::refresh()

   METHOD legendFont()                            INLINE ::m_letraLegend
   METHOD setLegendFont( f )                      INLINE ::m_letraLegend := f, ::refresh()

   METHOD font()                                  INLINE ::m_letra
   METHOD setFont( f )                            INLINE ::m_letra := f, ::refresh()

   METHOD useAnimation()                          INLINE ::m_animation
   METHOD setAnimation( b )                       INLINE ::m_animation := b, ::refresh()

   METHOD animationDuration()                     INLINE ::m_aniDuration
   METHOD setAnimationDuration( i )               INLINE ::m_aniDuration := i

   METHOD addItem( name, value, color )

   METHOD addMulibarColor( name, color )
   METHOD addLineaStop( s )                       INLINE ::lineasStops:append( s )
   METHOD addLineaStops( sl )                     INLINE ::lineasStops := sl

   METHOD clear()

   METHOD draw( oSurface )
   METHOD drawBar( painter )
   METHOD drawMultiBar( painter )
   METHOD drawLines( painter )
   METHOD drawPie( painter )
   METHOD drawAxis( painter )
   METHOD drawLegendVertical( painter )
   METHOD drawLegendCircular( painter )
   METHOD drawYValues( painter )

   METHOD getQuater( angle )
   METHOD angle360( angle )
   METHOD getPoint( angle, R1, R2 )
   METHOD percent()                               INLINE ::m_percent
   METHOD setPercent( f )
   METHOD startAnimation()
   METHOD printPreview()
   METHOD printChart( oPrinter )
   METHOD manageKeyPress( oKeyEvent )

   METHOD height()                                INLINE ::oPixmap:height()
   METHOD width()                                 INLINE ::oPixmap:width()

   DATA   nColorIndex                             INIT 1

   DATA   aPallete                                INIT {}
   DATA   hPallete                                INIT {=>}
   METHOD getPallete( cName )                     INLINE iif( hb_HHasKey( ::hPallete, cName ), ::hPallete[ cName ], NIL )
   METHOD setPallete( cName, aPallete )           INLINE iif( HB_ISCHAR( cName ) .AND. HB_ISARRAY( aPallete ), ::hPallete[ cName ] := aPallete, NIL ), ::aPallete := ::hPallete[ cName ]
   DATA   nStartIndex                             INIT -1

   ENDCLASS


METHOD HbQtCharts:init( oParent )

   ::oParent := oParent

   ::m_mayor        := 0
   ::m_maxValue     := 0
   ::m_menor        := 0
   ::m_type         := HBQT_CHART_BARS
   ::m_sombra       := .T.
   ::m_useLegend    := .T.
   ::m_tipoLegend   := HBQT_LEGEND_VERICAL
   ::m_usingTitle   := .T.
   ::m_title        := ""
   ::m_valuesEnY    := .T.
   ::m_animation    := .T.
   ::m_aniDuration  := 700

   ::m_letraLegend  := QFont( "verdana" )
   ::m_letra        := QFont( "verdana" )
   ::m_letraLegend:setPixelSize( 8 )
   ::m_letra:setPixelSize( 12 )

   ::multibarColors := HbQtList():new()
   ::pieces         := HbQtList():new()
   ::lineasStops    := HbQtList():new()

   ::m_labels       := .T.
   ::m_values       := .T.
   ::m_valuesEnY    := .F.

   hb_HCaseMatch( ::hPallete, .F. )

   AAdd( ::aPallete, QColor( Qt_yellow    ) )
   AAdd( ::aPallete, QColor( Qt_green     ) )
   AAdd( ::aPallete, QColor( Qt_blue      ) )
   AAdd( ::aPallete, QColor( Qt_cyan      ) )
   AAdd( ::aPallete, QColor( Qt_magenta   ) )
   AAdd( ::aPallete, QColor( Qt_red       ) )
   AAdd( ::aPallete, QColor( Qt_lightGray ) )

   AAdd( ::aPallete, QColor( 255,250,205  ) )    // LemonChiffon
   AAdd( ::aPallete, QColor( 124,255,0    ) )    // ChartReuse
   AAdd( ::aPallete, QColor( 0  ,191,255  ) )    // DeepSkyblue
   AAdd( ::aPallete, QColor( 127,255,212  ) )    // Aquamarine
   AAdd( ::aPallete, QColor( 238,130,238  ) )    // Violet
   AAdd( ::aPallete, QColor( 220,20,60    ) )    // Crimson
   AAdd( ::aPallete, QColor( 119,136,53   ) )    // LightSlateGray

   AAdd( ::aPallete, QColor( 240,230,140  ) )    // Khaki
   AAdd( ::aPallete, QColor( 60 ,179,113  ) )    // MediumGreen
   AAdd( ::aPallete, QColor( 30 ,144,255  ) )    // DoggerBlue
   AAdd( ::aPallete, QColor( 64 ,224,208  ) )    // Turquoise
   AAdd( ::aPallete, QColor( 123,104,238  ) )    // MediumSlateBlue
   AAdd( ::aPallete, QColor( 240,128,128  ) )    // LightCoral
   AAdd( ::aPallete, QColor( 255,240,245  ) )    // LavendarBlush

   ::hPallete[ "default" ] := ::aPallete

   ::oPixmap := QPixmap()

   ::nStartIndex := Max( 1, hb_Random( 99999 ) % Len( ::aPallete ) )

   RETURN Self


METHOD HbQtCharts:create()

   WITH OBJECT ::oLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH

   WITH OBJECT ::oWidget := QWidget( ::oParent )
      :setLayout( ::oLay )
      :connect( QEvent_KeyPress, {|k| ::manageKeyPress( k ) } )
   ENDWITH

   ::buildToolbar()

   WITH OBJECT ::oLabel := QLabel()
      :setContentsMargins( 0,0,0,0 )
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      :resize( 200, 150 )
   ENDWITH

   WITH OBJECT ::oScrollArea := QScrollArea()
      :setContentsMargins( 0,0,0,0 )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setWidgetResizable( .F. )
      :setWidget( ::oLabel )
      :connect( QEvent_Resize, {|| ::refresh() } )
   ENDWITH

   WITH OBJECT ::oLay
      :addWidget( ::oToolbar )
      :addWidget( ::oScrollArea )
   ENDWITH

   ::setPercent( 100 )

   IF HB_ISOBJECT( ::oParent )
      ::oWidget:resize( ::oParent:width(), ::oParent:height() )
   ELSE
      ::oWidget:resize( 200, 150 )
   ENDIF

   RETURN Self


METHOD HbQtCharts:manageKeyPress( oKeyEvent )

   SWITCH oKeyEvent:key()
   CASE Qt_Key_T
      ::enableToolbar( ! ::isToolbarEnabled() )
      EXIT
   CASE Qt_Key_P
      ::printPreview()
      EXIT
   CASE 0
      EXIT
   ENDSWITCH

   RETURN .F.


METHOD HbQtCharts:buildToolbar()

   WITH OBJECT ::sp0 := QLabel()
      :setMaximumWidth( 12 )
      :setMaximumHeight( 12 )
   ENDWITH

   WITH OBJECT ::oActBars := QAction( ::oWidget )
      :setText( "Bar Chart" )
      :setIcon( QIcon( __hbqtImage( "chart_bar" ) ) )
      :setTooltip( "Bar Chart" )
      :connect( "triggered()", {|| ::setType( HBQT_CHART_BARS ) } )
   ENDWITH
   WITH OBJECT ::oActPie := QAction( ::oWidget )
      :setText( "Pie Chart" )
      :setIcon( QIcon( __hbqtImage( "chart_pie" ) ) )
      :setTooltip( "Pie Chart" )
      :connect( "triggered()", {|| ::setType( HBQT_CHART_PIE ) } )
   ENDWITH
   WITH OBJECT ::oActPie3D := QAction( ::oWidget )
      :setText( "Pie Chart 3D" )
      :setIcon( QIcon( __hbqtImage( "chart_pie_3d" ) ) )
      :setTooltip( "Pie Chart 3D" )
      :connect( "triggered()", {|| ::setType( HBQT_CHART_PIE_3D ) } )
      :setEnabled( .F. )
   ENDWITH
   WITH OBJECT ::oActLines := QAction( ::oWidget )
      :setText( "Line Chart" )
      :setIcon( QIcon( __hbqtImage( "chart_line" ) ) )
      :setTooltip( "Line Chart" )
      :connect( "triggered()", {|| ::setType( HBQT_CHART_LINES ) } )
      :setEnabled( .F. )
   ENDWITH
   WITH OBJECT ::oActLegends := QAction( ::oWidget )
      :setText( "Legend" )
      :setIcon( QIcon( __hbqtImage( "legend" ) ) )
      :setTooltip( "Toggle Show Legend" )
      :connect( "triggered()", {|| ::enableLegend( ! ::isLegendEnabled() ) } )
   ENDWITH
   WITH OBJECT ::oActShadows := QAction( ::oWidget )
      :setText( "Shadows" )
      :setIcon( QIcon( __hbqtImage( "shading" ) ) )
      :setTooltip( "Toggle Show Shadows" )
      :connect( "triggered()", {|| ::enableShadows( ! ::isShadowsEnabled() ) } )
   ENDWITH
   WITH OBJECT ::oActLabels := QAction( ::oWidget )
      :setText( "Tags" )
      :setIcon( QIcon( __hbqtImage( "tag" ) ) )
      :setTooltip( "Toggle Show Tags" )
      :connect( "triggered()", {|| ::enableLabels( ! ::isLabelsEnabled() ) } )
   ENDWITH
   WITH OBJECT ::oActValues := QAction( ::oWidget )
      :setText( "Values" )
      :setIcon( QIcon( __hbqtImage( "dollar" ) ) )
      :setTooltip( "Toggle Show Values" )
      :connect( "triggered()", {|| ::enableValues( ! ::isValuesEnabled() ) } )
   ENDWITH
   WITH OBJECT ::oActPrint := QAction( ::oWidget )
      :setText( "Print" )
      :setIcon( QIcon( __hbqtImage( "print" ) ) )
      :setTooltip( "Print with Preview" )
      :connect( "triggered()", {|| ::printPreview() } )
   ENDWITH

   WITH OBJECT ::oToolbar := QToolBar()
      :setOrientation( Qt_Vertical )
      :setIconSize( QSize( 12,12 ) )
      :setMovable( .F. )
      :setFloatable( .F. )
      :setFocusPolicy( Qt_NoFocus )

      :addAction( ::oActBars )
      :addAction( ::oActPie )
      :addWidget( ::sp0 )
      :addAction( ::oActLegends )
      :addAction( ::oActShadows )
      :addAction( ::oActLabels )
      :addAction( ::oActValues )
      :addAction( ::oActPrint )
   ENDWITH

   RETURN Self


METHOD HbQtCharts:addItem( name, value, color )
   LOCAL p := HbQtChartsPiece():new()

   STATIC nColorIndex := 0

   IF ! HB_ISOBJECT( color )
      IF HB_ISNUMERIC( color )
         color := QColor( color )
      ELSEIF HB_ISARRAY( color ) .AND. Len( color ) == 3
         color := QColor( color[ 1 ], color[ 2 ], color[ 3 ] )
      ELSEIF HB_ISCHAR( color )
         color := QColor( __hbqtHbColorToQtValue( color, Qt_ForegroundRole ) )
      ELSE
         IF ::pieces:size() == 0
            nColorIndex := ::nStartIndex
         ENDIF
         nColorIndex++
         IF nColorIndex > Len( ::aPallete )
            nColorIndex := 1
         ENDIF
         color := ::aPallete[ nColorIndex ]
      ENDIF
   ENDIF

   p:name := name
   p:addValue( value )
   p:color  := NIL
   p:color  := color

   ::pieces:append( p )

   ::m_mayor    := Max( ::m_mayor, Int( value ) )
   ::m_menor    := Min( ::m_menor, Int( value ) )
   ::m_maxValue := Max( ::m_mayor, -::m_menor )

// ::startAnimation()
   ::setPercent( 100 )
   ::refresh()

   RETURN Self


METHOD HbQtCharts:addMulibarColor( name, color )
   LOCAL pare

   pare := HbQtPair():new()
   pare:first  := name
   pare:second := color
   ::multibarColors:append( pare )

   RETURN Self


METHOD HbQtCharts:refresh()

   IF HB_ISOBJECT( ::oWidget )
      ::oLabel:resize( ::oScrollArea:width(), ::oScrollArea:height() )
      ::oPixmap := QPixmap( ::oScrollArea:width()-10, ::oScrollArea:height()-10 )
      ::oPixmap:fill( QColor( 240,240,240 ) )
      ::draw( ::oPixmap )
      ::oLabel:setPixmap( ::oPixmap )
      ::oPixmap := NIL
   ENDIF

   RETURN Self


METHOD HbQtCharts:draw( oSurface )
   LOCAL fontH, title, maxLength, cToken, range, p, pieceHeight, s, i, pPerc, fm, painter

   painter := QPainter( oSurface )
   painter:setRenderHint( QPainter_Antialiasing )
   painter:setFont( ::m_letra )

   IF ::pieces:isEmpty()
      ::m_xAxis := ::height() / 2
      ::m_left  := 5
      ::m_right := ::width() - 5
      ::m_width := ::m_right - ::m_left
      ::drawAxis( painter )

      painter:end()
      painter := NIL
      RETURN Self
   ENDIF

   fm := painter:fontMetrics()
   fontH := fm:height()

   IF ::m_type == HBQT_CHART_PIE .OR. ::m_type == HBQT_CHART_PIE_3D
      ::m_left   := 0
      ::m_right  := ::width()
      ::m_top    := 0
      ::m_bottom := ::height()

      IF ::m_usingTitle
         ::m_top += fontH
         ::m_top += 3
         WITH OBJECT title := QFont( ::m_letra )
//          :setItalic( .T. )
            :setBold( .T. )
//          :setUnderline( .T. )
         ENDWITH
         WITH OBJECT painter
            :save()
            :setFont( title )
            :drawText( ::width() / 2 - painter:fontMetrics():width( ::m_title ) / 2, fontH, ::m_title )
            :restore()
         ENDWITH
      ENDIF

      IF ::m_useLegend
         maxLength := 0
         FOR i := 1 TO ::pieces:size()
            IF ::m_type != HBQT_CHART_LINES
               cToken := ::pieces:at( i ):name + ":" + HHB_NTOS( ::pieces:at( i ):value() )
               maxLength := Max( maxLength, fm:width( cToken ) )
            ELSE
               maxLength := Max( maxLength, fm:width( ::pieces:at( i ):name ) )
            ENDIF
         NEXT

         IF ::m_tipoLegend == HBQT_LEGEND_CIRCULAR
            ::m_top    += fontH + 15
            ::m_bottom -= fontH + 15
            maxLength  += fontH + 15
            ::m_right  -= maxLength
            ::m_left   += maxLength
         ELSE
            maxLength += fontH + 10
            ::m_right -= maxLength
         ENDIF
      ENDIF
      ::m_width := ::m_right - ::m_left
      ::m_height := ::m_bottom - ::m_top
   ELSE
      ::m_left := 5
      ::m_right := ::width() - 5
      IF ::m_valuesEnY
         s := HHB_NTOS( ::m_maxValue )
         IF ::m_menor < 0
             s := "-" + s
         ENDIF
         ::m_left += fm:width( s )
      ENDIF
      IF ::m_useLegend
         maxLength := 0
         IF ::m_tipoLegend == HBQT_LEGEND_VERICAL .AND. ::m_type != HBQT_CHART_BARS_M
            FOR i := 1 TO ::pieces:size()
               IF ::m_type != HBQT_CHART_LINES
                  cToken := ::pieces:at( i ):name() + ":" + HHB_NTOS( ::pieces:at( i ):value() )
                  maxLength := Max( maxLength, fm:width( cToken ) )
               ELSE
                  maxLength := Max( maxLength, fm:width( ::pieces:at( i ):name ) )
               ENDIF
            NEXT
         ELSEIF ::m_tipoLegend == HBQT_LEGEND_VERICAL .AND. ::m_type == HBQT_CHART_BARS_M
            FOR i := 1 TO ::multibarColors:size()
               maxLength := Max( maxLength, fm:width( ::multibarColors:at( i ):first ) )
            NEXT
         ENDIF
         maxLength += fontH + 10
         ::m_right -= maxLength
      ENDIF
      ::m_width := ::m_right - ::m_left

      ::m_top := 0
      ::m_bottom := ::height()
      IF ::m_labels
         IF ::m_type == HBQT_CHART_BARS_M .OR. ::m_type == HBQT_CHART_LINES
            IF ::m_mayor >= 0 .AND. ::m_menor >= 0
               ::m_bottom -= fontH
            ELSEIF ::m_mayor <= 0 .AND. ::m_menor <= 0
               ::m_top += fontH
            ELSE
               ::m_top += fontH
               ::m_bottom -= fontH
            ENDIF
         ELSEIF ( ::m_type == HBQT_CHART_BARS )
            IF ::m_mayor <= 0
               ::m_top += fontH
            ENDIF
            IF ::m_menor >= 0
               ::m_bottom -= fontH
            ENDIF
         ENDIF
      ENDIF
      IF ::m_values
         IF ::m_mayor > 0
            ::m_top += fontH + 2
         ENDIF
         IF ::m_menor < 0
            ::m_bottom -= fontH + 2
         ENDIF
      ENDIF
      IF ::m_usingTitle
         ::m_top += fontH
         ::m_top += 3
         WITH OBJECT title := QFont( ::m_letra )
//          :setItalic( .T. )
            :setBold( .T. )
//          :setUnderline( .T. )
         ENDWITH
         WITH OBJECT painter
            :save()
            :setFont( title )
            :drawText( ::width() / 2 - painter:fontMetrics():width( ::m_title ) / 2, fontH, ::m_title )
            :restore()
         ENDWITH
         title := NIL
      ENDIF
      ::m_height := ::m_bottom - ::m_top

      range := ::m_mayor
      IF ::m_menor < 0
         range -= ::m_menor
      ENDIF
      IF range == 0
         RETURN Self
      ENDIF
      IF ::m_mayor == ::m_maxValue
         pPerc       := ( ::m_mayor * 100 ) / range
         p           := pPerc / 100.0
         pieceHeight := ::m_height * p
         ::m_xAxis   := ::m_top + pieceHeight
      ELSE
         pPerc       := ( ::m_menor * 100 ) / range
         p           := pPerc / 100.0
         pieceHeight := ::m_height * p
         ::m_xAxis   := ::m_bottom + pieceHeight
      ENDIF
   ENDIF

   SWITCH ::m_type

   CASE HBQT_CHART_BARS
      IF ::m_valuesEnY
         ::drawYValues( painter )
      ENDIF
      ::drawBar( painter )
      ::drawAxis( painter )
      EXIT
   CASE HBQT_CHART_BARS_M
      IF ::m_valuesEnY
         ::drawYValues( painter )
      ENDIF
      ::drawMultiBar( painter )
      ::drawAxis( painter )
      EXIT
   CASE HBQT_CHART_LINES
      IF ::m_valuesEnY
         ::drawYValues( painter )
      ENDIF
      ::drawAxis( painter )
      ::drawLines( painter )
      EXIT
   CASE HBQT_CHART_PIE
   CASE HBQT_CHART_PIE_3D
      ::drawPie( painter )
      EXIT

   ENDSWITCH

   painter:end()
   painter := NIL
   RETURN Self


METHOD HbQtCharts:drawBar( painter )
   LOCAL pen, isPositive, range, fontHeight, p, pieceHeight, a, s, pDist, i, pieceXPos, label, pieceWidth
   LOCAL gradient, gradientNeg, pPerc, fm

   range := ::m_mayor
   IF ::m_menor < 0
      range -= ::m_menor
   ENDIF
   IF range == 0
      RETURN Self
   ENDIF

   painter:save()

   fm := painter:fontMetrics()
   pDist := 15
   pieceWidth := ( ::m_width -( ::pieces:size() ) * pDist ) / ::pieces:size()

   pen := QPen()
   pen:setWidth( 2 )

   FOR i := 1 TO ::pieces:size()
      isPositive := ::pieces:at( i ):value() >= 0

      pPerc := ( ::pieces:at( i ):value() * 100 ) / range
      p := pPerc / 100.0
      pieceHeight := ::m_height * p
      IF pieceHeight < 0
         pieceHeight := -pieceHeight
      ENDIF
      pieceXPos := pDist + ( i - 1 ) * ( pieceWidth + pDist )

      IF ::m_sombra
         painter:setPen( Qt_NoPen )
         painter:setBrush( QBrush( Qt_darkGray ))

         IF isPositive
            painter:drawRect( ::m_left + pieceXPos - pDist / 2, ::m_xAxis, pieceWidth, -pieceHeight * 0.8 )
         ELSE
            painter:drawRect( ::m_left + pieceXPos - pDist / 2, ::m_xAxis, pieceWidth, pieceHeight * 0.8 )
         ENDIF
      ENDIF

      IF isPositive
         gradient := QLinearGradient( ::m_left + ::m_width / 2, ::m_xAxis - pieceHeight - 180, ::m_left + ::m_width / 2, ::m_xAxis )
         gradient:setColorAt( 0, QColor( Qt_black ) )
         gradient:setColorAt( 1, ::pieces:at( i ):color )
         painter:setBrush( QBrush( gradient ) )
      ELSE
         gradientNeg := QLinearGradient( ::m_left + ::m_width / 2, ::m_xAxis, ::m_left + ::m_width / 2, ::m_xAxis+pieceHeight + 180 )
         gradientNeg:setColorAt( 1, QColor( Qt_black ) )
         gradientNeg:setColorAt( 0,::pieces:at( i ):color )
         painter:setBrush( QBrush( gradientNeg ) )
      ENDIF

      pen:setColor( ::pieces:at( i ):color )
      painter:setPen( pen )

      IF isPositive
         painter:drawRect( ::m_left + pieceXPos, ::m_xAxis, pieceWidth, -pieceHeight )
      ELSE
         painter:drawRect( ::m_left + pieceXPos, ::m_xAxis, pieceWidth, pieceHeight )
      ENDIF

      label := HHB_NTOS( ::pieces:at( i ):value() )

      painter:setPen( Qt_SolidLine )
      fontHeight := fm:height()

      IF ::m_labels
         s := ::pieces:at( i ):name
         IF fm:width( s ) > pieceWidth
            s := "..."
            FOR a := 1 TO Len( ::pieces:at( i ):name )
               IF fm:width( s ) >= pieceWidth - 10
                  EXIT
               ENDIF
               s := SubStr( ::pieces:at( i ):name, 1, a ) + "..."
            NEXT
         ENDIF
         IF isPositive
            painter:drawText( ::m_left + pieceXPos + pieceWidth / 2 - fm:width( s ) / 2, ::m_xAxis + fontHeight, s )
         ELSE
            painter:drawText( ::m_left + pieceXPos + pieceWidth / 2 - fm:width( s ) / 2, ::m_xAxis - fontHeight / 2, s )
         ENDIF
      ENDIF
      IF ::m_values
         IF isPositive
            painter:drawText( ::m_left + pieceXPos + pieceWidth / 2 - fm:width( label ) / 2, ::m_xAxis - pieceHeight - fontHeight / 2 + 2, label )
         ELSE
            painter:drawText( ::m_left + pieceXPos + pieceWidth / 2 - fm:width( label ) / 2, ::m_xAxis + pieceHeight + fontHeight - 1, label )
         ENDIF
      ENDIF
   NEXT
   painter:restore()

   pen := NIL
   IF ::m_useLegend
      ::drawLegendVertical( painter )
   ENDIF

   RETURN SELF


METHOD HbQtCharts:drawMultiBar( painter )
   LOCAL pDist, iDist, pen, i, s, fontHeight, a, piecewidth, blockxpos, r, g, b, z
   LOCAL label, subwidth, piecexpos, pieceHeight, ispositive, gradientneg, gradient, range, p, pperc, par
   LOCAL fm := painter:fontMetrics()

   pDist := 15
   iDist := 4
   pieceWidth := ( ::m_width -( ::pieces:size() ) * pDist ) / ::pieces:size()

   pen := QPen()
   pen:setWidth( 3 )

   range := ::m_mayor
   IF ::m_menor < 0
      range -= ::m_menor
   ENDIF
   IF range == 0
      RETURN Self
   ENDIF
   FOR i := 1 TO ::pieces:size()
      DO WHILE ::multibarColors:size() < ::pieces:at( i ):getValues():size()
         r := hb_Random( 255 )
         g := hb_Random( 255 )
         b := hb_Random( 255 )
         par := HbQtPair():new()
         par:first  := ""
         par:second := QColor( r,g,b )
         ::multibarColors:append( par )
      ENDDO
      subWidth := ( pieceWidth - ( ( ::pieces:at( i ):getValues():size() - 1 ) * iDist ) ) / ::pieces:at( i ):getValues():size()

      FOR a := ::pieces:at( i ):getValues():size() TO 1 STEP -1
         isPositive := ::pieces:at( i ):getValues():at( a ) >= 0

         pPerc := ( ::pieces:at( i ):getValues():at( a ) * 100 ) / range
         p := pPerc / 100.0
         pieceHeight := ::m_height * p
         IF pieceHeight < 0
            pieceHeight := -pieceHeight
         ENDIF
         pieceXPos := pDist + i * ( pieceWidth + pDist ) + ( a * ( iDist + subWidth ) )

         blockXPos := pDist + i * ( pieceWidth + pDist )

         IF ::m_sombra
            painter:setPen( Qt_NoPen )
            painter:setBrush( QBrush( Qt_darkGray ) )

            IF ( isPositive )
               painter:drawRect( ::m_left + pieceXPos - pDist / 2, ::m_xAxis, subWidth, -pieceHeight * 0.8 )
            ELSE
               painter:drawRect( ::m_left + pieceXPos - pDist/2, ::m_xAxis, subWidth, pieceHeight * 0.8 )
            ENDIF
         ENDIF

         IF ( isPositive )
            gradient := QLinearGradient( ::m_left + ::m_width / 2, ::m_xAxis - pieceHeight - 180, ::m_left + ::m_width / 2, ::m_xAxis )
            gradient:setColorAt( 0, QColor( Qt_black ) )
            gradient:setColorAt( 1,::multibarColors:at( a ):second )
            painter:setBrush( QBrush( gradient ) )
         ELSE
            gradientNeg := QLinearGradient( ::m_left + ::m_width / 2, ::m_xAxis, ::m_left + ::m_width / 2, ::m_xAxis + pieceHeight + 180 )
            gradientNeg:setColorAt( 1, QColor( Qt_black ) )
            gradientNeg:setColorAt( 0,::multibarColors:at( a ):second )
            painter:setBrush( QBrush( gradientNeg ) )
         ENDIF

         pen:setColor( ::multibarColors:at( a ):second )
         painter:setPen( pen )

         IF ( isPositive )
            painter:drawRect( ::m_left+pieceXPos , ::m_xAxis , subWidth , -pieceHeight )
         ELSE
            painter:drawRect( ::m_left+pieceXPos , ::m_xAxis , subWidth , pieceHeight )
         ENDIF
         label := HHB_NTOS( ::pieces:at( i ):getValues():at( a ) )

         painter:setPen( Qt_SolidLine )
         fontHeight := fm:height()

         IF ::m_values
            IF isPositive
               painter:drawText( ::m_left + pieceXPos + subWidth / 2 - fm:width( label ) / 2, ::m_xAxis - pieceHeight - fontHeight / 2, label )
            ELSE
               painter:drawText( ::m_left + pieceXPos + subWidth / 2 - fm:width( label ) / 2, ::m_xAxis + pieceHeight + fontHeight, label )
            ENDIF
         ENDIF
         IF ::m_labels
            s := ::pieces:at( i ):name
            IF fm:width( s ) > pieceWidth
               s := "..."
               FOR z := 1 TO Len( ::pieces:at( i ):name )
                  IF fm:width( s ) >= pieceWidth - 10
                     EXIT
                  ENDIF
                  s := SubStr( ::pieces:at( i ):name, 1, z ) + "..."
               NEXT
            ENDIF
            IF ::m_mayor <= 0
               painter:drawText( ::m_left + blockXPos + pieceWidth / 2 - fm:width( s ) / 2, ::m_top - fontHeight / 2 + 3, s )
            ELSE
               painter:drawText( ::m_left + blockXPos + pieceWidth / 2 - fm:width( s ) / 2, ::height() - fontHeight / 2 + 3, s )
            ENDIF
         ENDIF
      NEXT
   NEXT

   IF ::m_useLegend
      ::drawLegendVertical( painter )
   ENDIF

   RETURN SELF


METHOD HbQtCharts:drawLines( painter )
   LOCAL range, start, pDist, i, xPositions, a, s, points, pointcount, above, c, pen, y, x, _p
   LOCAL use, gradient, c1, _min, _max, fontH, fm

   range := ::m_mayor
   IF ::m_menor < 0
      range -= ::m_menor
   ENDIF
   IF range == 0
      RETURN Self
   ENDIF

   fm := painter:fontMetrics()

   fontH := fm:height()
   start := ::m_left + 15
   pDist := ( ::m_width - start ) / ( ::lineasStops:size() - 1 )
   xPositions := HbQtList():new()
   FOR i := 1 TO ::lineasStops:size()
      xPositions:append( start + pDist * i )
   NEXT
   IF ( ::m_labels .AND. ! ::lineasStops:isEmpty() )
       xPositions:clear()
       start := ::m_left + 15 + fm:width( ::lineasStops:at( 0 ) )
       pDist := ( ::m_width - start - fm:width( ::lineasStops:last() ) ) / ( ::lineasStops:size() - 1 )
       FOR i := 1 TO ::lineasStops:size()
          xPositions:append( start + pDist * i )
       NEXT
   ENDIF

   IF ::m_sombra
      painter:setPen( Qt_NoPen )
      FOR i := 1 TO ::pieces:size()
         c := ::pieces:at( i ):color
         c:setAlpha( 5 )

         c1 := ::pieces:at( i ):color
         c1:setAlpha( 50 )

         use := Min( ::pieces:at( i ):getValues():size(), ::lineasStops:size() )
         pointCount := use + 2

         points := HbQtList():new()
         points:resize( pointCount )

         FOR a := 1 TO pointCount - 2
            _p := ( ::pieces:at( i ):getValues():at( a ) * 100 ) / range
            IF _p < 0
               _p := -_p
            ENDIF
            x := _p / 100.0
            y := ::m_height * x

            IF ::pieces:at( i ):getValues():at( a ) >= 0
               points[ a ] := QPoint( xPositions:at( a ), ::m_xAxis - y )
            ELSE
               points[ a ] := QPoint( xPositions:at( a ), ::m_xAxis + y )
            ENDIF
         NEXT

         points:At( pointCount - 2, QPoint( xPositions:at( use - 1 ), ::m_xAxis ) )
         points:At( pointCount - 1, QPoint( xPositions:at( 0 )      , ::m_xAxis ) )

         _max := 0
         _min := 0
         FOR a := 1 TO pointCount - 2
            _max := Max( _max, points:At( a ):y() )
            _min := Min( _min, points:At( a ):y() )
         NEXT
         WITH OBJECT gradient := QLinearGradient( ::m_left, _max, ::m_left, _min )
            :setColorAt( 0, c )
            :setColorAt( 0.5, c1 )
            :setColorAt( 1, c )
         ENDWITH
         painter:setBrush( QBrush( gradient ) )

         painter:drawPolygon( points:data(), pointCount )   /* How to handle this ?? */
      NEXT
   ENDIF
   IF ::m_labels
      painter:setPen( Qt_SolidLine )
      FOR i := 1 TO ::lineasStops:size()
         IF ::m_mayor <= 0
            painter:drawText( xPositions:at( i ) - fm:width( ::lineasStops:at( i ) ) / 2, ;
                                            ::m_top - fontH / 2 + 3, ::lineasStops:at( i ) )
         ELSE
            painter:drawText( xPositions:at( i ) - fm:width( ::lineasStops:at( i ) ) / 2, ;
                                            ::height() - fontH / 2 + 3, ::lineasStops:at( i ) )
         ENDIF
      NEXT
   ENDIF

   FOR i := 1 TO ::pieces:size()
      use := Min( ::pieces:at( i ):getValues():size(), ::lineasStops:size() )
      pointCount := use

      points := HbQtList():new()
      points:resize( pointCount )

      pen := QPen()
      pen:setColor( ::pieces:at( i ):color )
      pen:setWidth( 2 )
      FOR a := 1 TO pointCount
         _p := ( ::pieces:at( i ):getValues():at( a ) * 100 ) / range
         IF _p < 0
            _p := -_p
         ENDIF
         x := _p / 100.0
         y := ::m_height * x

         IF ::pieces:at( i ):getValues():at( a ) >= 0
            points[ a ] := QPoint( xPositions:at( a ), ::m_xAxis - y )
         ELSE
            points[ a ] := QPoint( xPositions:at( a ), ::m_xAxis + y )
         ENDIF
      NEXT
      painter:setPen( pen )
      painter:drawPolyline( points:data(),pointCount )
      c := ::pieces:at( i ):color
      c:setAlpha( 50 )
      painter:setBrush( QBrush( c ) )
      FOR a := 1 TO pointCount
         painter:drawEllipse( points[ a ], 3, 3 )
      NEXT
      IF ::m_values
         painter:setPen( Qt_SolidLine )
         FOR a := 1 TO pointCount
            s := HHB_NTOS( ::pieces:at( i ):getValues():at( a ) )
            above := .T.
            IF a != pointCount - 1
               IF ( points[ a ]:y() > points[ a + 1 ]:y() )
                  above := .F.
               ENDIF
            ENDIF
            IF above
               painter:drawText( points[ a ]:x() - fm:width( s ), points[ a ]:y() - fm:height() / 2, s )
            ELSE
               painter:drawText( points[ a ]:x() - fm:width( s ), points[ a ]:y() + fm:height(), s )
            ENDIF
         NEXT
      ENDIF
   NEXT

   IF ::m_useLegend
      ::drawLegendVertical( painter )
   ENDIF

   RETURN SELF


METHOD HbQtCharts:drawPie( painter )
   LOCAL i, pen, pdegree, palpha, total, gradient

   IF ::m_useLegend
      IF ::m_tipoLegend == HBQT_LEGEND_VERICAL
         ::drawLegendVertical( painter )
      ELSE
         ::drawLegendCircular( painter )
      ENDIF
   ENDIF

   painter:save()

   palpha := 0
   total := 0
   FOR i := 1 TO ::pieces:size()
      total += ::pieces:at( i ):value()
   NEXT
   IF ::m_sombra
      painter:setBrush( QBrush( Qt_darkGray ) )
      painter:setPen( Qt_NoPen )
      painter:drawEllipse( ::m_left, ::m_top + 5, ::m_width, ::m_height - 5 )
   ENDIF

   pen := QPen()
   pen:setWidth( 2 )

   gradient := QRadialGradient( QPointF( ::m_left + ::m_width * 0.5, ::m_top + ::m_height * 0.5 ), Max( ::m_height, ::m_width ) )
   gradient:setColorAt( 1, QColor( Qt_black ) )
   FOR i := 1 TO ::pieces:size()
      pdegree := 3.6 * ( ::pieces:at( i ):value() * 100 / total )

      pen:setColor( ::pieces:at( i ):color )
      gradient:setColorAt( 0, ::pieces:at( i ):color )

      WITH OBJECT painter
         :setPen( pen )
         :setBrush( QBrush( gradient ) )
         :drawPie( ::m_left, ::m_top, ::m_width, ::m_height - 5, palpha * 16, pdegree * 16 )
      ENDWITH

      palpha += pdegree
   NEXT
   painter:restore()

   RETURN SELF


METHOD HbQtCharts:drawAxis( painter )
   LOCAL top, pen
   LOCAL fm := painter:fontMetrics()

   painter:save()

   pen := QPen()
   pen:setWidth( 3 )
   pen:setColor( QColor( Qt_darkGray ) )
   painter:setPen( pen )

   top := 1
   IF ::m_usingTitle
      top += fm:height()
   ENDIF
   painter:drawLine( ::m_left, top + 2, ::m_left, ::height() - 4 )
   painter:drawLine( ::m_left, ::m_xAxis, ::m_left + ::m_width, ::m_xAxis )

   pen:setWidth( 1 )
   painter:setPen( pen )
   IF ::m_mayor > 0
      painter:drawLine( ::m_left, top, ::m_left + 4, top + 9 )
      painter:drawLine( ::m_left, top, ::m_left - 4, top + 9 )
   ENDIF
   IF ::m_menor < 0
      painter:drawLine( ::m_left, ::height() - 1, ::m_left + 4, ::height() - 11 )
      painter:drawLine( ::m_left, ::height() - 1, ::m_left - 4, ::height() - 11 )
   ENDIF

   painter:restore()
   pen := NIL
   RETURN SELF


METHOD HbQtCharts:drawLegendVertical( painter )
   LOCAL i, dist, x, y, s, fontH
   LOCAL fm := painter:fontMetrics()

   fontH := fm:height()
   dist := 5
   IF ::m_type != HBQT_CHART_BARS_M
      FOR i := ::pieces:size() TO 1 STEP -1
         painter:setBrush( QBrush( ::pieces:at( i ):color ) )
         x := ::m_right + dist
         y := ::m_top + dist + ( i - 1 ) * ( fontH + 2 * dist )
         painter:drawRect( x, y, fm:height(), fontH )
         s := ::pieces:at( i ):name
         IF ( ::m_type != HBQT_CHART_LINES )
            s += ":" + HHB_NTOS( ::pieces:at( i ):value() )
         ENDIF
         painter:drawText( x + fontH + dist, y + fontH / 2 + dist, s )
      NEXT
   ELSE
      FOR i := ::multibarColors:size() TO 1 STEP -1
         painter:setBrush( QBrush( ::multibarColors:at( i ):second ) )
         x := ::m_right + dist
         y := ::m_top + dist + i * ( fontH + 2 * dist )
         painter:drawRect( x, y, fontH, fontH )
         s := ::multibarColors:at( i ):first
         painter:drawText( x + fontH + dist, y + fontH / 2 + dist, s )
      NEXT
   ENDIF

   RETURN SELF


METHOD HbQtCharts:drawLegendCircular( painter )
   LOCAL i, pdegree, palpha, total
   LOCAL label, len, p, p_, angle, pPerc, recH, recW, q
   LOCAL fm := painter:fontMetrics()

   painter:save()

   len     := 50 //100
   palpha  := 0
   total   := 0
   angle   := palpha
   FOR i := 1 TO ::pieces:size()
      total += ::pieces:at( i ):value()
   NEXT

   ::m_right -= 30
   ::m_top += 30
   ::m_left += 30
   ::m_bottom -= 30
   ::m_width := ::m_right - ::m_left
   ::m_height := ::m_bottom - ::m_top

   FOR i := ::pieces:size() TO 1 STEP -1
      pPerc := ::pieces:at( i ):value() * 100 / total

      pdegree := 3.6 * pPerc
      angle -= pdegree / 2
      p := ::GetPoint( angle )
      p_:= ::GetPoint( angle, ::m_width + len, ::m_height + len )
      q := ::GetQuater( angle )
      IF q == 3 .OR. q == 4
          p:setY( p:y() + ::m_width / 2 )
          p_:setY( p_:y() + ::m_width / 2 )
      ENDIF
      painter:drawLine( p:x(), p:y(), p_:x(), p_:y() )
      label := ::pieces:at( i ):name() + "-" + HHB_NTOS( pPerc ) + "%"
      recW := fm:width( label ) + 10
      recH := fm:height() + 10
      p_:setX( p_:x() - recW / 2 + recW / 2 * cos( angle * M_PI / 180 ) )
      p_:setY( p_:y() + recH / 2 + recH / 2 * sin( angle * M_PI / 180 ) )
      painter:setBrush( QBrush( Qt_white ) )
      painter:drawRoundedRect( p_:x(), p_:y(), recW, -recH, 3, 3 )
      painter:drawText( p_:x() + 5, p_:y() - recH / 2 + 5, label )
      angle -= pdegree / 2
   NEXT
   painter:restore()

   RETURN SELF


METHOD HbQtCharts:drawYValues( painter )
   LOCAL w, h, s, range, aux, toDiv, porcion, pAux, i, a, porcionHeight
   LOCAL fm := painter:fontMetrics()

   painter:save()
   painter:setPen( Qt_DotLine )
   painter:setFont( ::m_letra )

   s := "-" + HHB_NTOS( ::m_maxValue )
   range := ::m_mayor
   IF ::m_menor < 0
      range -= ::m_menor
   ENDIF
   w := fm:width( s )
   h := fm:height()
   s := SubStr( s, 2 )

   painter:drawText( 0, ::m_xAxis - h / 2, w, h, Qt_AlignRight, "0" )

   aux           := left( s, 1 )
   toDiv         := Val( aux )
   porcion       := ::m_maxValue / toDiv
   porcion       := iif( porcion > 0, porcion, -porcion )
   pAux          := porcion / range
   porcionHeight := ::m_height * pAux

   i := ::m_xAxis - porcionHeight
   FOR a := 1 TO ::m_mayor STEP porcion
      IF ( a + porcion > ::m_mayor + 5 )
         EXIT
      ENDIF
      painter:drawLine( ::m_left, i, ::m_left + ::m_width, i )
      painter:drawText( 0, i - h / 2, w, h, Qt_AlignRight, HHB_NTOS( a + porcion ) )
      i -= porcionHeight
   NEXT
   i := ::m_xAxis + porcionHeight
   FOR a := 1 TO ::m_menor STEP porcion
      painter:drawLine( ::m_left, i, ::m_left + ::m_width, i )
      painter:drawText( 0, i - h / 2, w, h, Qt_AlignRight, HHB_NTOS( a - porcion ) )
      i += porcionHeight
   NEXT
   painter:restore()

   RETURN SELF


METHOD HbQtCharts:getPoint( angle, R1, R2 )
   LOCAL point, x, y

   DEFAULT R1 TO 0
   DEFAULT R2 TO 0

   IF ( R1 == 0 .AND. R2 == 0 )
      R1 := ::m_width
      R2 := ::m_height
   ENDIF
   point := QPointF()
   x := R1 / 2 * cos( angle * M_PI / 180 )
   x += ::m_width / 2 + ::m_left
   y := -R2 / 2 * sin( angle * M_PI / 180 )
   y += ::m_height / 2 + ::m_top
   point:setX( x )
   point:setY( y )

   RETURN point


METHOD HbQtCharts:setPercent( f )
   LOCAL i

   FOR i := 1 TO ::pieces:size()
      ::pieces:at( i ):setPercent( f )
   NEXT
   ::refresh()

   RETURN SELF


METHOD HbQtCharts:getQuater( angle )

   angle := ::angle360( angle )

   IF angle >= 0 .AND. angle < 90
      RETURN 1
   ENDIF
   IF angle >= 90 .AND. angle < 180
      RETURN 2
   ENDIF
   IF angle >= 180 .AND. angle < 270
      RETURN 3
   ENDIF
   IF angle >= 270 .AND. angle < 360
      RETURN 4
   ENDIF

   RETURN 0


METHOD HbQtCharts:angle360( angle )
   LOCAL i := Int( angle )
   LOCAL delta := angle - i

   RETURN  ( i % 360 + delta )


METHOD HbQtCharts:startAnimation()
   LOCAL ani

   IF ::m_animation
      ani := QWidget() //QPropertyAnimation( ::oWidget, "percent", ::oWidget )
      ani:connect( "finished()", {|| ani:deleteLater() } )
      ani:setStartValue( 0 )
      ani:setEndValue( 100 )
      ani:setDuration( ::m_aniDuration )
      ani:start()
   ELSE
      ::setPercent( 100 )
   ENDIF

   RETURN SELF


METHOD HbQtCharts:Clear()
   LOCAL i

   FOR i := 1 TO ::pieces:size()
      ::pieces:at( i ):destroy()
   NEXT
   ::pieces:clear()

   FOR i := 1 TO ::multibarColors:size()
      ::multibarColors:at( i ):second := NIL
   NEXT
   ::multibarColors:clear()

   ::lineasStops:clear()

   ::m_mayor    := 0
   ::m_maxValue := 0
   ::m_menor    := 0

   RETURN SELF


METHOD HbQtCharts:printPreview()
   LOCAL oDlg, oPrinter

   WITH OBJECT oPrinter := QPrinter()
      :setOutputFormat( QPrinter_PdfFormat )
      :setPageOrientation( QPrinter_Landscape )
      :setPaperSize( QPageSize( QPrinter_A4 ) )
   ENDWITH

   oDlg := QPrintPreviewDialog( oPrinter )
   oDlg:connect( "paintRequested(QPrinter*)", {|p| ::printChart( p ) } )

   oDlg:setWindowTitle( ::title() )
   oDlg:move( 20, 20 )
   oDlg:resize( 400, 600 )
   oDlg:exec()

   oDlg:setParent( QWidget() )

   RETURN NIL


METHOD HbQtCharts:printChart( oPrinter )
   LOCAL oPaper, oPage, nMY, nMX, nH, nW, oImage
   LOCAL oPainter := QPainter( oPrinter )

   oPaper := oPrinter:paperRect( QPrinter_DevicePixel )
   oPage  := oPrinter:pageRect( QPrinter_DevicePixel )

   nMX    := oPaper:width()  - oPage:width()
   nMY    := oPaper:height() - oPage:height()

   nW     := oPrinter:width()  - nMX
   nH     := oPrinter:height() - nMY

   oImage := QImage( nW, nH, QImage_Format_ARGB32 )
   ::draw( oImage )
   oPainter:drawPixmap( QPoint( nMX, nMY ), QPixmap():fromImage( oImage ) )

   RETURN Self

/*----------------------------------------------------------------------*/

CLASS HbQtChartsPiece

   DATA   values                                  INIT NIL
   DATA   i_values                                INIT NIL
   DATA   oColor                                  INIT QColor()
   DATA   cName                                   INIT ""

   ACCESS name()                                  INLINE ::cName
   ASSIGN name( cName )                           INLINE ::cName := cName

   ACCESS color()                                 INLINE ::oColor
   ASSIGN color( oColor )                         INLINE ::oColor := NIL, ::oColor := oColor

   METHOD init( oHbQtChartsPiece )
   METHOD destroy()
   METHOD setPercent( nPerc )

   METHOD value()                                 INLINE iif( ::values:isEmpty(), NIL, ::values:at( 1 ) )
   METHOD getValues()                             INLINE ::values

   METHOD addValue( xValue )

   ENDCLASS


METHOD HbQtChartsPiece:init( oHbQtChartsPiece )
   LOCAL i

   ::values   := HbQtList():new()
   ::i_values := HbQtList():new()

   IF HB_ISOBJECT( oHbQtChartsPiece )
      ::i_values := oHbQtChartsPiece:i_values
      ::oColor   := NIL
      ::oColor   := oHbQtChartsPiece:color()
      ::cName    := oHbQtChartsPiece:name()
      FOR i := 1 TO ::i_values:size()
         ::values:append( 0 )
      NEXT
   ENDIF

   RETURN Self


METHOD HbQtChartsPiece:destroy()

   ::oColor := NIL
   ::values:clear()
   ::values := NIL
   ::i_values:clear()
   ::i_values := NIL

   RETURN NIL


METHOD HbQtChartsPiece:addValue( xValue )

   IF HB_ISOBJECT( xValue )
      ::i_values := xValue
   ELSE
      ::i_values:append( xValue )
      ::values:append( 0 )
   ENDIF

   RETURN Self


METHOD HbQtChartsPiece:setPercent( nPerc )
   LOCAL i, f1

   f1 := nPerc / 100.0
   FOR i := 1 TO Len( ::values )
      ::values:at( i, ::i_values:at( i ) * f1 )
   NEXT

   RETURN Self

/*----------------------------------------------------------------------*/

CLASS HbQtPair

   DATA   xFirst                                  INIT NIL
   DATA   xSecond                                 INIT NIL

   METHOD init()

   ACCESS first()                                 INLINE ::xFirst
   ASSIGN first( first )                          INLINE ::xFirst := NIL, ::xFirst := first

   ACCESS second()                                INLINE ::xSecond
   ASSIGN second( second )                        INLINE ::xSecond := NIL, ::xSecond := second

   ENDCLASS


METHOD HbQtPair:init()
   RETURN Self

/*----------------------------------------------------------------------*/

CLASS HbQtList

   DATA   aItems                                  INIT {}

   METHOD init()
   METHOD clear()

   METHOD isEmpty()                               INLINE Len( ::aItems ) == 0
   METHOD prepend( xValue )                       INLINE hb_AIns( ::aItems, 1, xValue, .T. )
   METHOD append( xValue )                        INLINE AAdd( ::aItems, xValue )
   METHOD size()                                  INLINE Len( ::aItems )
   METHOD resize( nSize )                         INLINE ASize( ::aItems, nSize )
   METHOD last()                                  INLINE ATail( ::aItems )
   METHOD first()                                 INLINE iif( ::isEmpty(), NIL, ::aItems[ 1 ] )
   METHOD insert( nIndex, xValue )                INLINE hb_AIns( ::aItems, nIndex, xValue, .T. )

   METHOD at( i, xValue )

   ENDCLASS


METHOD HbQtList:init()
   RETURN Self


METHOD HbQtList:at( i, xValue )
   LOCAL l_xValue

   IF HB_ISNUMERIC( i ) .AND. i > 0 .AND. i <= Len( ::aItems )
      l_xValue := ::aItems[ i ]
      IF PCount() == 2
         ::aItems[ i ] := xValue
      ENDIF
   ENDIF

   RETURN l_xValue


METHOD HbQtList:clear()
   LOCAL xTmp

   FOR EACH xTmp IN ::aItems
      xTmp := NIL
   NEXT
   ::aItems := {}

   RETURN Len( ::aItems )

