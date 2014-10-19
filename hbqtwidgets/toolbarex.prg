/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
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
/*
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                  Harbour HbQtScrollableToolbar Class
 *
 *                             Pritpal Bedi
 *                              06Oct2014
 */
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


CLASS HbQtScrollableToolbar

   DATA   oWidget
   DATA   oParent
   DATA   oFirstIndicator
   DATA   oLastIndicator
   DATA   oLayout
   DATA   oSBarTools
   DATA   oPos

   DATA   aToolButtons                            INIT   {}

   DATA   nOrientation                            INIT   Qt_Horizontal                   // before :create()
   ACCESS orientation()                           INLINE ::nOrientation
   METHOD setOrientation( nOrient )               INLINE ::nOrientation := nOrient

   DATA   nAlignment                                                                     // before :create()
   ACCESS alignment()                             INLINE ::nAlignment
   METHOD setAlignment( nAlign )                  INLINE ::nAlignment := nAlign

   DATA   aRGB                                    INIT   { 0,0,255 }                     // Runtime
   ACCESS indicatorsRGB()                         INLINE ::aRGB
   METHOD setIndicatorsRGB( aRGB )                INLINE ::aRGB := aRGB

   DATA   nGap                                    INIT   0
   ACCESS gapInButtons()                          INLINE ::nGap
   METHOD setGapInButtons( nGap )                 INLINE ::nGap := nGap

   DATA   nIndicatorsSize                         INIT   3
   ACCESS indicatorsSize()                        INLINE ::nIndicatorsSize
   METHOD setIndicatorsSize( nSize )              INLINE ::nIndicatorsSize := nSize

   DATA   nButtonWidth                            INIT   48
   ACCESS buttonWidth()                           INLINE ::nButtonWidth
   METHOD setButtonWidth( nWidth )                INLINE ::nButtonWidth := nWidth

   DATA   nButtonHeight                           INIT   48
   ACCESS buttonHeight()                          INLINE ::nButtonHeight
   METHOD setButtonHeight( nHeight )              INLINE ::nButtonHeight := nHeight

   DATA   nImageWidth                             INIT   32
   ACCESS imageWidth()                            INLINE ::nImageWidth
   METHOD setImageWidth( nWidth )                 INLINE ::nImageWidth := nWidth

   DATA   nImageHeight                            INIT   32
   ACCESS imageHeight()                           INLINE ::nImageHeight
   METHOD setImageHeight( nHeight )               INLINE ::nImageHeight := nHeight

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD configure()
   METHOD destroy()                               VIRTUAL

   METHOD manageToolbar()

   METHOD addToolbarButton( xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise )
   METHOD manageIconDrag( oEvent, oButton )

   ACCESS isVertical()                            INLINE ( ::nOrientation == Qt_Vertical )

   METHOD setState( cName, nState )

   METHOD hide()                                  INLINE ::oWidget:hide()
   METHOD show()                                  INLINE ::oWidget:show()
   ENDCLASS


METHOD HbQtScrollableToolbar:init( oParent )
   DEFAULT oParent  TO ::oParent
   ::oParent := oParent
   RETURN Self


METHOD HbQtScrollableToolbar:create( oParent )
   LOCAL oRect

   DEFAULT oParent  TO ::oParent
   ::oParent := oParent

   IF __objDerivedFrom( ::oParent, "QVBOXLAYOUT" )
      ::nOrientation := Qt_Vertical
      ::oLayout := ::oParent
   ELSEIF __objDerivedFrom( ::oParent, "QHBOXLAYOUT" )
      ::nOrientation := Qt_Horizontal
      ::oLayout := ::oParent
   ELSE
      IF Empty( ::oLayout := ::oParent:layout() )
         IF ::isVertical()
            ::oLayout := QVBoxLayout()
         ELSE
            ::oLayout := QHBoxLayout()
         ENDIF
         ::oParent:setLayout( ::oLayout )
      ENDIF
   ENDIF
   IF Empty( ::oLayout )
      RETURN NIL                                  // not self, raise error as soon as possible
   ENDIF

   ::oParent := ::oLayout:parent()

   ::nGap             := HBQT_P_XX( ::nGap            )
   ::nImageWidth      := HBQT_P_XX( ::nImageWidth     )
   ::nImageHeight     := HBQT_P_XX( ::nImageHeight    )
   ::nButtonWidth     := HBQT_P_XX( ::nButtonWidth    )
   ::nButtonHeight    := HBQT_P_XX( ::nButtonHeight   )
   ::nIndicatorsSize  := HBQT_P_XX( ::nIndicatorsSize )

   WITH OBJECT ::oWidget := QListWidget()
      :setObjectName( __hbqtGetNextIdAsString( "HbQtScrollableToolbar" ) )
      :setFocusPolicy( Qt_NoFocus )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setEditTriggers( QAbstractItemView_NoEditTriggers )
      :setSelectionMode( QAbstractItemView_NoSelection )
      :setVerticalScrollMode( QAbstractItemView_ScrollPerPixel )
      :setHorizontalScrollMode( QAbstractItemView_ScrollPerPixel )
      :setFlow( iif( ::isVertical(), QListView_TopToBottom, QListView_LeftToRight ) )
      IF ::isVertical()
         :setGridSize( QSize( ::nButtonWidth, ::nButtonHeight + ::nGap ) )
         :setMaximumWidth( ::nButtonWidth )
      ELSE
         :setGridSize( QSize( ::nButtonWidth + ::nGap, ::nButtonHeight ) )
         :setMaximumHeight( ::nButtonHeight )
      ENDIF
   ENDWITH
   QScroller():scroller( ::oWidget ):grabGesture( ::oWidget, QScroller_LeftMouseButtonGesture )

   ::oFirstIndicator := QLabel()
   ::oLastIndicator  := QLabel()

   WITH OBJECT ::oLayout
      :addWidget( ::oFirstIndicator )
      :addWidget( ::oWidget )
      :addWidget( ::oLastIndicator )
   ENDWITH

   ::configure()
   IF ::isVertical()
      WITH OBJECT ::oSBarTools := ::oWidget:verticalScrollbar()
         :connect( "valueChanged(int)"    , {|| ::manageToolbar() } )
         :connect( "rangeChanged(int,int)", {|| ::manageToolbar() } )
      ENDWITH
   ELSE
      WITH OBJECT ::oSBarTools := ::oWidget:horizontalScrollbar()
         :connect( "valueChanged(int)"    , {|| ::manageToolbar() } )
         :connect( "rangeChanged(int,int)", {|| ::manageToolbar() } )
      ENDWITH
   ENDIF
   ::configure()

   WITH OBJECT ::oLayout
      oRect := :geometry()
      IF ::isVertical()
         oRect:setWidth( ::nButtonWidth )
      ELSE
         oRect:setHeight( ::nButtonHeight )
      ENDIF
      :setGeometry( oRect )
      IF ::nAlignment != NIL
         :setAlignment( ::nAlignment )
      ENDIF
   ENDWITH
   RETURN Self


METHOD HbQtScrollableToolbar:configure()
//   LOCAL oRect

   IF ::isVertical()
      WITH OBJECT ::oFirstIndicator
         :setMinimumWidth( ::nButtonWidth )
         :setMaximumWidth( ::nButtonWidth )
         :setMinimumHeight( ::nIndicatorsSize )
         :setMaximumHeight( ::nIndicatorsSize )
      ENDWITH
      WITH OBJECT ::oLastIndicator
         :setMinimumWidth( ::nButtonWidth )
         :setMaximumWidth( ::nButtonWidth )
         :setMinimumHeight( ::nIndicatorsSize )
         :setMaximumHeight( ::nIndicatorsSize )
      ENDWITH
   ELSE
      WITH OBJECT ::oFirstIndicator
         :setMinimumHeight( ::nButtonHeight )
         :setMaximumHeight( ::nButtonHeight )
         :setMaximumWidth( ::nIndicatorsSize )
         :setMinimumWidth( ::nIndicatorsSize )
      ENDWITH
      WITH OBJECT ::oLastIndicator
         :setMinimumHeight( ::nButtonHeight )
         :setMaximumHeight( ::nButtonHeight )
         :setMaximumWidth( ::nIndicatorsSize )
         :setMinimumWidth( ::nIndicatorsSize )
      ENDWITH
   ENDIF

   ::manageToolbar()

#if 0
   WITH OBJECT ::oLayout
      oRect := :geometry()
      IF ::isVertical()
         oRect:setWidth( ::nButtonWidth )
      ELSE
         oRect:setHeight( ::nButtonHeight )
      ENDIF
      :setGeometry( oRect )
      IF ::nAlignment != NIL
         :setAlignment( ::nAlignment )
      ENDIF
   ENDWITH
#endif
   RETURN Self


METHOD HbQtScrollableToolbar:addToolbarButton( xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise )
   LOCAL oToolBtn, oItm, cText

   IF HB_ISARRAY( xCaption )
      ASize( xCaption, 8 )
      //
      cText       := xCaption[ 1 ]
      cTooltip    := xCaption[ 2 ]
      xButton     := xCaption[ 3 ]
      bBlock      := xCaption[ 4 ]
      lCheckable  := xCaption[ 5 ]
      lDraggable  := xCaption[ 6 ]
      lAutoRepeat := xCaption[ 7 ]
      lNoAutoRaise:= xCaption[ 8 ]
   ELSE
      cText := xCaption
   ENDIF

   DEFAULT cTooltip     TO cText
   DEFAULT lCheckable   TO .F.
   DEFAULT lAutoRepeat  TO .F.
   DEFAULT lDraggable   TO .F.
   DEFAULT lNoAutoRaise TO .F.

   WITH OBJECT oToolBtn := QToolButton()
      :setIconSize( QSize( ::nImageWidth, ::nImageHeight ) )
      :setMaximumWidth( ::nButtonWidth )
      :setMinimumWidth( ::nButtonWidth )
      :setMaximumHeight( ::nButtonHeight )
      :setMinimumHeight( ::nButtonHeight )
      //
      :setObjectName( cText )
      :setTooltip( cTooltip )
      IF ! Empty( xButton )
         IF HB_ISOBJECT( xButton ) .AND. __objDerivedFrom( xButton, "QICON" )
            :setIcon( xButton )
         ELSEIF HB_ISSTRING( xButton )
            IF ( "." $ xButton )
               :setIcon( QIcon( xButton ) )
            ELSE
               :setIcon( QIcon( __hbqtImage( xButton ) ) )
            ENDIF
         ELSE
            :setText( cText )
         ENDIF
      ELSE
         :setText( cText )
      ENDIF

      :setCheckable( lCheckable )
      :setAutoRepeat( lAutoRepeat )
      :setAutoRaise( ! lNoAutoRaise )

      :connect( "clicked()", bBlock )
      IF lDraggable
         :connect( QEvent_MouseButtonPress, {|oEvent| ::oPos := oEvent:pos() } )
         :connect( QEvent_MouseMove       , {|oEvent| ::manageIconDrag( oEvent, oToolBtn ) } )
      ENDIF
   ENDWITH

   oItm := QListWidgetItem()
   oItm:setSizeHint( oToolBtn:sizeHint() )
   ::oWidget:addItem( oItm )
   ::oWidget:setItemWidget( oItm, oToolBtn )

   AAdd( ::aToolButtons, { oToolBtn, oItm } )
   oItm:setData( Qt_UserRole, QVariant( Len( ::aToolButtons ) ) )
   RETURN oToolBtn


METHOD HbQtScrollableToolbar:setState( cName, nState )
   HB_SYMBOL_UNUSED( cName + nState )
   RETURN Self


METHOD HbQtScrollableToolbar:manageToolbar()
   LOCAL i, oRect

   IF Empty( ::aToolButtons )
      RETURN Self
   ENDIF

   IF ::isVertical()
      FOR i := 1 TO Len( ::aToolButtons )
         IF ! ::aToolButtons[ i,2 ]:isHidden()
            EXIT
         ENDIF
      NEXT
      oRect := ::oWidget:visualItemRect( ::aToolButtons[ i,2 ] )
      IF oRect:y() < 0
         ::oFirstIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oFirstIndicator:show()
      ELSE
         ::oFirstIndicator:setStyleSheet( " " )
         ::oFirstIndicator:hide()
      ENDIF
      FOR i := Len( ::aToolButtons ) TO 1 STEP -1
         IF ! ::aToolButtons[ i,2 ]:isHidden()
            EXIT
         ENDIF
      NEXT
      oRect := ::oWidget:visualItemRect( ::aToolButtons[ i,2 ] )
      IF oRect:y() + oRect:height() > ::oWidget:viewport():height()
         ::oLastIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oFirstIndicator:show()
      ELSE
         ::oLastIndicator:setStyleSheet( " " )
         ::oLastIndicator:hide()
      ENDIF
   ELSE
      FOR i := 1 TO Len( ::aToolButtons )
         IF ! ::aToolButtons[ i,2 ]:isHidden()
            EXIT
         ENDIF
      NEXT
      oRect := ::oWidget:visualItemRect( ::aToolButtons[ i,2 ] )
      IF oRect:x() < 0
         ::oFirstIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oFirstIndicator:show()
      ELSE
         ::oFirstIndicator:setStyleSheet( " " )
         ::oFirstIndicator:hide()
      ENDIF
      FOR i := Len( ::aToolButtons ) TO 1 STEP -1
         IF ! ::aToolButtons[ i,2 ]:isHidden()
            EXIT
         ENDIF
      NEXT
      oRect := ::oWidget:visualItemRect( ::aToolButtons[ i,2 ] )
      IF oRect:x() + oRect:width() > ::oWidget:viewport():width()
         ::oLastIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oLastIndicator:show()
      ELSE
         ::oLastIndicator:setStyleSheet( " " )
         ::oLastIndicator:hide()
      ENDIF
   ENDIF
   ::oLayout:update()
   RETURN Self


METHOD HbQtScrollableToolbar:manageIconDrag( oEvent, oButton )
   LOCAL qrC, qByte, qPix, qMime, qDrag

   qRC := QRect( ::oPos:x() - 5, ::oPos:y() - 5, 10, 10 ):normalized()
   IF qRC:contains( oEvent:pos() )
      qByte := QByteArray( oButton:objectName() )
      qPix  := oButton:icon():pixmap( 16,16 )
      WITH OBJECT qMime := QMimeData()
         :setData( "application/x-toolbaricon", qByte )
         :setHtml( oButton:objectName() )
      ENDWITH
      WITH OBJECT qDrag := QDrag( ::oWidget )
         :setMimeData( qMime )
         :setPixmap( qPix )
         :setHotSpot( QPoint( 15,15 ) )
         :setDragCursor( qPix, Qt_CopyAction + Qt_IgnoreAction )
      ENDWITH
      qDrag:exec( Qt_CopyAction + Qt_IgnoreAction )
      qDrag:setParent( QWidget() )
      qDrag := NIL
      ::oPos := NIL
   ENDIF
   RETURN Self

