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
   DATA   hButtons                                INIT __hbqtStandardHash()

   DATA   nOrientation                            INIT   Qt_Horizontal                   // before :create()
   ACCESS orientation()                           INLINE ::nOrientation
   METHOD setOrientation( nOrient )               INLINE ::nOrientation := nOrient
   ACCESS isVertical()                            INLINE ( ::nOrientation == Qt_Vertical )

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

   METHOD adjustSize()
   METHOD manageToolbar()

   METHOD buildToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   METHOD insertToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   METHOD addToolbarButton( xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   METHOD addSeparator( cName )
   METHOD manageIconDrag( oEvent, oButton )

   METHOD findButton( cName )
   METHOD swapImage( cName, oPixmap )
   METHOD setState( cName, nState )
   METHOD click( cName )
   METHOD setEnabled( cName, lEnable )
   METHOD setHidden( cName, lYes )

   METHOD hide()                                  INLINE ::oFirstIndicator:hide(), ::oLastIndicator:hide(), ::oWidget:hide()
   METHOD show()                                  INLINE ::oFirstIndicator:show(), ::oLastIndicator:show(), ::oWidget:show()
   ENDCLASS


METHOD HbQtScrollableToolbar:init( oParent )
   DEFAULT oParent  TO ::oParent
   ::oParent := oParent

   ::hButtons := __hbqtStandardHash()
   RETURN Self


METHOD HbQtScrollableToolbar:create( oParent )

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
      :setAttribute( Qt_WA_AlwaysShowToolTips, .T. )
      :setFrameShape( QFrame_NoFrame )
      :setSelectionRectVisible( .F. )
   ENDWITH
   __hbqtApplyStandardScroller( ::oWidget )

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
   RETURN Self


METHOD HbQtScrollableToolbar:findButton( cName )
   IF ! Empty( cName ) .AND. hb_HHasKey( ::hButtons, cName )
      RETURN ::hButtons[ cName ][ 1 ]
   ENDIF
   RETURN NIL


METHOD HbQtScrollableToolbar:swapImage( cName, oPixmap )
   LOCAL oToolButton
   IF ! Empty( oToolButton := ::findButton( cName ) )
      IF HB_ISOBJECT( oPixmap )
         oToolButton:setIcon( oPixmap )
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtScrollableToolbar:setEnabled( cName, lEnable )
   LOCAL oToolButton
   IF ! Empty( oToolButton := ::findButton( cName ) )
      oToolButton:setEnabled( lEnable )
   ENDIF
   RETURN Self


METHOD HbQtScrollableToolbar:click( cName )
   LOCAL oToolButton
   IF ! Empty( oToolButton := ::findButton( cName ) )
      oToolButton:click()
   ENDIF
   RETURN Self


METHOD HbQtScrollableToolbar:setState( cName, nState )
   LOCAL oldState, oToolButton

   IF ! Empty( oToolButton := ::findButton( cName ) )
      SWITCH nState
      CASE 1                                      // __HBQT_TBBUTTON_STATE_TOGGLE__
         IF oToolButton:isCheckable()
            oldState := oToolButton:isChecked()
            oToolButton:toggle()
         ENDIF
         EXIT
      CASE 2                                      // __HBQT_TBBUTTON_STATE_UNCHECKED__
         IF ( oldState := oToolButton:isChecked() )
            oToolButton:toggle()
         ENDIF
         EXIT
      CASE 3                                      // __HBQT_TBBUTTON_STATE_CHECKED__
         IF oToolButton:isCheckable()
            IF ! ( oldState := oToolButton:isChecked() )
               oToolButton:toggle()
            ENDIF
         ENDIF
         EXIT
      ENDSWITCH
   ENDIF
   RETURN oldState


METHOD HbQtScrollableToolbar:setHidden( cName, lYes )
   LOCAL oItem
   IF hb_HHasKey( ::hButtons, cName )
      WITH OBJECT oItem := ::hButtons[ cName ][ 2 ]
         :setWhatsThis( iif( lYes, "Y", "N" ) )
         :setHidden( lYes )
      ENDWITH
   ENDIF
   HB_SYMBOL_UNUSED( oItem )
   RETURN Self


METHOD HbQtScrollableToolbar:adjustSize()
   LOCAL aBtns
   LOCAL nButtons := 0

   FOR EACH aBtns IN ::hButtons
      nButtons += iif( aBtns[ 2 ]:whatsThis() == "Y", 0, 1 )
   NEXT
   IF ::isVertical()
      ::oWidget:setMaximumHeight( ::oWidget:gridSize():height() * nButtons + ::nGap * nButtons )
   // ::oWidget:setMinimumHeight( ::oWidget:gridSize():height() * nButtons + ::nGap * nButtons )
   ELSE
      ::oWidget:setMaximumWidth( ::oWidget:gridSize():width() * nButtons + ::nGap * nButtons )
   // ::oWidget:setMinimumWidth( ::oWidget:gridSize():width() * nButtons + ::nGap * nButtons )
   ENDIF
#if 0
   WITH OBJECT ::oLayout
      oRect := :geometry()
      IF ::isVertical()
         oRect:setWidth( ::nButtonWidth )
         oRect:setHeight( ::oWidget:gridSize():height() * nButtons + ::nGap * nButtons )
      ELSE
         oRect:setHeight( ::nButtonHeight )
         oRect:setWidth( ::oWidget:gridSize():width() * nButtons + ::nGap * nButtons )
      ENDIF
      :setGeometry( oRect )
      IF ::nAlignment != NIL
         :setAlignment( ::nAlignment )
      ENDIF
   ENDWITH
#endif
   RETURN Self


METHOD HbQtScrollableToolbar:manageToolbar()
   LOCAL i, oRect, oFirstVis, oLastVis

   IF Empty( ::aToolButtons )
      RETURN Self
   ENDIF
   FOR i := 1 TO Len( ::aToolButtons )
      IF ::aToolButtons[ i,2 ]:whatsThis() == "N"
         oFirstVis := ::aToolButtons[ i, 2 ]
         EXIT
      ENDIF
   NEXT
   FOR i := Len( ::aToolButtons ) TO 1 STEP -1
      IF ::aToolButtons[ i,2 ]:whatsThis() == "N"
         oLastVis := ::aToolButtons[ i, 2 ]
         EXIT
      ENDIF
   NEXT

   IF ::isVertical()
      oRect := ::oWidget:visualItemRect( oFirstVis )
      IF oRect:y() < 0
         ::oFirstIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oFirstIndicator:show()
      ELSE
         ::oFirstIndicator:setStyleSheet( " " )
         ::oFirstIndicator:hide()
      ENDIF
      oRect := ::oWidget:visualItemRect( oLastVis )
      IF oRect:y() + oRect:height() > ::oWidget:viewport():height()
         ::oLastIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oLastIndicator:show()
      ELSE
         ::oLastIndicator:setStyleSheet( " " )
         ::oLastIndicator:hide()
      ENDIF
   ELSE
      oRect := ::oWidget:visualItemRect( oFirstVis )
      IF oRect:x() < 0
         ::oFirstIndicator:setStyleSheet( "background-color: " + __hbqtRgbStringFromRGB( ::aRGB ) +  ";" )
         ::oFirstIndicator:show()
      ELSE
         ::oFirstIndicator:setStyleSheet( " " )
         ::oFirstIndicator:hide()
      ENDIF
      oRect := ::oWidget:visualItemRect( oLastVis )
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


METHOD HbQtScrollableToolbar:addSeparator( cName )
   LOCAL oToolBtn, oItm

   WITH OBJECT oToolBtn := QToolButton()
      :setIconSize( QSize( ::nImageWidth, ::nImageHeight ) )
      :setMaximumWidth( ::nButtonWidth )
      :setMinimumWidth( ::nButtonWidth )
      :setMaximumHeight( ::nButtonHeight )
      :setMinimumHeight( ::nButtonHeight )
      :setAutoRaise( .T. )
      :setEnabled( .F. )
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH
   oItm := QListWidgetItem()
   oItm:setSizeHint( oToolBtn:sizeHint() )
   oItm:setWhatsThis( "N" )
   ::oWidget:addItem( oItm )
   ::oWidget:setItemWidget( oItm, oToolBtn )

   ::hButtons[ cName ] := { oToolBtn, oItm }
   AAdd( ::aToolButtons, { oToolBtn, oItm, cName } )
   oItm:setData( Qt_UserRole, QVariant( Len( ::aToolButtons ) ) )

   ::adjustSize()
   RETURN Self


METHOD HbQtScrollableToolbar:insertToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   nIndex := Max( nIndex, 1 )
   RETURN ::buildToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )


METHOD HbQtScrollableToolbar:addToolbarButton( xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   LOCAL nIndex := Len( ::aToolButtons ) + 1
   RETURN ::buildToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )


METHOD HbQtScrollableToolbar:buildToolbarButton( nIndex, xCaption, cTooltip, xButton, bBlock, lCheckable, lDraggable, lAutoRepeat, lNoAutoRaise, nStyle )
   LOCAL oToolBtn, oItm, cName

   IF HB_ISARRAY( xCaption )
      ASize( xCaption, 9 )

      cName       := xCaption[ 1 ]
      cTooltip    := xCaption[ 2 ]
      xButton     := xCaption[ 3 ]
      bBlock      := xCaption[ 4 ]
      lCheckable  := xCaption[ 5 ]
      lDraggable  := xCaption[ 6 ]
      lAutoRepeat := xCaption[ 7 ]
      lNoAutoRaise:= xCaption[ 8 ]
      nStyle      := xCaption[ 9 ]
   ELSE
      cName := xCaption
   ENDIF

   DEFAULT cTooltip     TO cName
   DEFAULT lCheckable   TO .F.
   DEFAULT lAutoRepeat  TO .F.
   DEFAULT lDraggable   TO .F.
   DEFAULT lNoAutoRaise TO .F.
   DEFAULT nStyle       TO Qt_ToolButtonIconOnly


   WITH OBJECT oToolBtn := QToolButton()
      :setFocusPolicy( Qt_NoFocus )
      :setToolButtonStyle( nStyle )
      :setIconSize( QSize( ::nImageWidth, ::nImageHeight ) )
      :setMaximumWidth( ::nButtonWidth )
      :setMinimumWidth( ::nButtonWidth )
      :setMaximumHeight( ::nButtonHeight )
      :setMinimumHeight( ::nButtonHeight )
      //
      :setObjectName( cName )
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
         ENDIF
      ENDIF
#if 0
      :setText( ft_proper( cName ) )
#else
      :setText( cName )
#endif
      :setCheckable( lCheckable )
      :setAutoRepeat( lAutoRepeat )
      :setAutoRaise( ! lNoAutoRaise )

      :connect( "clicked(bool)", bBlock )
      IF lDraggable
         :connect( QEvent_MouseButtonPress, {|oEvent| ::oPos := oEvent:pos() } )
         :connect( QEvent_MouseMove       , {|oEvent| ::manageIconDrag( oEvent, oToolBtn ) } )
      ENDIF
   ENDWITH

   oItm := QListWidgetItem()
   oItm:setSizeHint( oToolBtn:sizeHint() )
   oItm:setWhatsThis( "N" )

   ::oWidget:insertItem( nIndex, oItm )
   ::oWidget:setItemWidget( oItm, oToolBtn )

   ::hButtons[ cName ] := { oToolBtn, oItm }
   AAdd( ::aToolButtons, { oToolBtn, oItm, cName } )
   //hb_AIns( ::aToolButtons, nIndex, { oToolBtn, oItm, cName }, .T. )
   oItm:setData( Qt_UserRole, QVariant( Len( ::aToolButtons ) ) )
   //oItm:setData( Qt_UserRole, QVariant( nIndex ) )

   ::adjustSize()
   RETURN oToolBtn


METHOD HbQtScrollableToolbar:manageIconDrag( oEvent, oButton )
   LOCAL qrC, qByte, qPix, qMime, oDrag

   qRC := QRect( ::oPos:x() - 5, ::oPos:y() - 5, 10, 10 ):normalized()
   IF qRC:contains( oEvent:pos() )
      qByte := QByteArray( oButton:objectName() )
      qPix  := oButton:icon():pixmap( 32,32 )
      WITH OBJECT qMime := QMimeData()
         :setData( "application/x-toolbaricon", qByte )
         :setHtml( oButton:objectName() )
      ENDWITH
      WITH OBJECT oDrag := QDrag( ::oWidget )
         :setMimeData( qMime )
         :setPixmap( qPix )
         :setHotSpot( QPoint( 15,15 ) )
         :setDragCursor( qPix, Qt_CopyAction + Qt_IgnoreAction )
      ENDWITH
      oDrag:exec( Qt_CopyAction + Qt_IgnoreAction )
      oDrag:setParent( QWidget() )
      oDrag := NIL
      ::oPos := QPoint()
   ENDIF
   RETURN Self


METHOD HbQtScrollableToolbar:configure()

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
   RETURN Self


