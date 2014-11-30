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
 *                        HbQtSlidingList Class
 *
 *                             Pritpal Bedi
 *                              17Nov2014
 */
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


#define PI                                        3.14159265358979323846


//--------------------------------------------------------------------//
//                      CLASS HbQtSlidingsManager
//--------------------------------------------------------------------//

CLASS HbQtSlidingsManager

   DATA   oParent
   DATA   hSlidings                               INIT __hbqtStandardHash()
   DATA   lInMeasure                              INIT .F.
   DATA   cCurrentActiveSlider                    INIT "x.x"
   DATA   nActiveArea                             INIT 0
   DATA   nX                                      INIT 0
   DATA   nY                                      INIT 0
   DATA   cCurLeftSliding                         INIT "x.x"
   DATA   cCurRightSliding                        INIT "x.x"

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD addSliding( cName, bBlock )
   METHOD activateSlidings( cNameLeftSliding, cNameRightSliding )

   PROTECTED:
   METHOD manageSlidings( oEvent, nEvent )

   ENDCLASS


METHOD HbQtSlidingsManager:init( oParent )
   ::oParent := oParent
   RETURN Self


METHOD HbQtSlidingsManager:create( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::oParent:connect( QEvent_MouseMove         , {|oEvent| ::manageSlidings( oEvent, QEvent_MouseMove          ) } )
   ::oParent:connect( QEvent_MouseButtonRelease, {|oEvent| ::manageSlidings( oEvent, QEvent_MouseButtonRelease ) } )
   ::oParent:connect( QEvent_MouseButtonPress  , {|oEvent| ::manageSlidings( oEvent, QEvent_MouseButtonPress   ) } )
   RETURN Self


METHOD HbQtSlidingsManager:addSliding( cName, bBlock )
   IF HB_ISBLOCK( bBlock )
      ::hSlidings[ cName ] := bBlock
   ENDIF
   RETURN Self


METHOD HbQtSlidingsManager:activateSlidings( cNameLeftSliding, cNameRightSliding )

   DEFAULT cNameLeftSliding  TO "x.x"
   DEFAULT cNameRightSliding TO "x.x"

   ::cCurLeftSliding  := cNameLeftSliding
   ::cCurRightSliding := cNameRightSliding

   RETURN Self


METHOD HbQtSlidingsManager:manageSlidings( oEvent, nEvent )
   LOCAL nX := oEvent:x()
   LOCAL nY := oEvent:y()

   SWITCH nEvent

   CASE QEvent_MouseMove
      IF ::lInMeasure
         IF Abs( nX - ::nX ) > 32
            IF ::nActiveArea == 1 .AND. hb_HHasKey( ::hSlidings, ::cCurLeftSliding )
               Eval( ::hSlidings[ ::cCurLeftSliding ] )
            ELSEIF ::nActiveArea == 2 .AND. hb_HHasKey( ::hSlidings, ::cCurRightSliding )
               Eval( ::hSlidings[ ::cCurRightSliding ] )
            ENDIF
            ::lInMeasure := .F.
         ENDIF
      ENDIF
      EXIT
   CASE QEvent_MouseButtonRelease
      IF ::lInMeasure
         IF Abs( nX - ::nX ) > 32
            IF ::nActiveArea == 1 .AND. hb_HHasKey( ::hSlidings, ::cCurLeftSliding )
               Eval( ::hSlidings[ ::cCurLeftSliding ] )
            ELSEIF ::nActiveArea == 2 .AND. hb_HHasKey( ::hSlidings, ::cCurRightSliding )
               Eval( ::hSlidings[ ::cCurRightSliding ] )
            ENDIF
         ENDIF
      ENDIF
      ::lInMeasure := .F.
      EXIT
   CASE QEvent_MouseButtonPress
      ::lInMeasure := .T.
      ::nActiveArea := iif( nX < 15, 1, iif( nX > ::oParent:width() - 15, 2, 0 ) )
      ::nX := nX
      ::nY := nY
      EXIT
   ENDSWITCH
   RETURN .F.

//--------------------------------------------------------------------//
//                       CLASS HbQtSlidingList
//--------------------------------------------------------------------//

CLASS HbQtSlidingList

   DATA   oParent
   DATA   oWidget
   DATA   oHeaderLabel
   DATA   oListWidget
   DATA   oLayout
   DATA   oAnimation1
   DATA   oAnimation2

   DATA   oFiller
   DATA   oColor                                  INIT QColor( 170,170,170 )
   DATA   oTextColor                              INIT QColor( 255,255,255 )
   DATA   oSeparatorColor                         INIT QColor( 220,220,220 )

   DATA   nOpacity                                INIT 255                // Fully Opaque
   DATA   nDirection                              INIT __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
   DATA   nMiliSeconds                            INIT 100
   DATA   nWidth                                  INIT 200
   DATA   nItemsHeight                            INIT 50
   DATA   nClickEvent                             INIT QEvent_MouseButtonPress
   DATA   nSeparatorHeight                        INIT 0
   DATA   nPressX                                 INIT 0
   DATA   nPressY                                 INIT 0
   DATA   cHeaderText                             INIT "Options"

   DATA   hItems                                  INIT __hbqtStandardHash()
   DATA   hSeparators                             INIT __hbqtStandardHash()

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD hide()
   METHOD show()
   METHOD activate()                              INLINE ::show()

   ACCESS slidingDirection()                      INLINE ::nDirection
   ACCESS backgroundColor()                       INLINE ::oColor
   ACCESS opacity()                               INLINE ::nOpacity
   ACCESS duration()                              INLINE ::nMiliSeconds
   ACCESS width()                                 INLINE ::nWidth
   ACCESS itemsHeight()                           INLINE ::nItemsHeight
   ACCESS clickEvent()                            INLINE ::nClickEvent

   METHOD setSlidingDirection( nDirection )
   METHOD setBackgroundColor( oColor )
   METHOD setTextColor( oColor )
   METHOD setOpacity( nOpacity )
   METHOD setDuration( nMiliSeconds )
   METHOD setWidth( nWidth )
   METHOD setItemsHeight( nHeight )
   METHOD setClickEvent( nEvent )

   METHOD setHeader( nHeight, cText, oTextColor, oBackColor )
   METHOD setHeaderText( cText )                  INLINE iif( HB_ISSTRING( cText ), ::cHeaderText := cText, NIL ), ;
                                                         iif( HB_ISOBJECT( ::oHeaderLabel ), ::oHeaderLabel:setText( ::cHeaderText ), NIL )
   METHOD setSeparator( nHeight, oColor )
   METHOD addSeparator()
   METHOD addItem( cName, xItem, bBlock )
   METHOD setEnabled( cName, lEnable )
   METHOD setHidden( cName, lHide )
   METHOD manageItemClicked( cName )
   METHOD applyAnimation()
   METHOD applyStyleSheet()
   METHOD manageLeftRight( oEvent, nEvent )

   DATA   lFocusOut                               INIT .T.
   ACCESS focusOut()                              INLINE ::lFocusOut
   METHOD setFocusOut( lFocusOut )                INLINE iif( HB_ISLOGICAL( lFocusOut ), ::lFocusOut := lFocusOut, NIL )

   DATA   bHidingBlock
   METHOD hidingBlock( bBlock )                   SETGET

   DATA   bActivatedBlock
   METHOD activatedBlock( bBlock )                SETGET
   ENDCLASS


METHOD HbQtSlidingList:init( oParent )
   ::oParent := oParent
   RETURN Self


METHOD HbQtSlidingList:create( oParent )
   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   IF Empty( ::oParent )
      ::oParent := __hbqtAppWidget()
   ENDIF
   IF Empty( ::oParent )
      Alert( "No Parent Provided!" )
      RETURN NIL
   ENDIF

   ::oLayout := QVBoxLayout()
   WITH OBJECT ::oWidget := QWidget( ::oParent )
      :hide()
      :setContentsMargins( 1,1,1,1 )
      :setObjectName( "SlidingWidget" )
      :setLayout( ::oLayout )
   ENDWITH

   WITH OBJECT ::oHeaderLabel := QLabel( ::cHeaderText )
      :setObjectName( "SlidingHeader" )
      :setMaximumHeight( __hbqtPixelsByDPI( 24 ) )
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      //:hide()
   ENDWITH

   WITH OBJECT ::oListWidget := QListWidget()
      :setObjectName( "SlidingList" )
      :setHorizontalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setVerticalScrollBarPolicy( Qt_ScrollBarAlwaysOff )
      :setIconSize( QSize( __hbqtPixelsByDPI( 36 ), __hbqtPixelsByDPI( 36 ) ) )
      :setFocusPolicy( Qt_NoFocus )
      :setSelectionRectVisible( .F. )
      :connect( "itemDoubleClicked(QListWidgetItem*)", {|oItem| ::manageItemClicked( oItem:whatsThis() ) } )
   ENDWITH
   __hbqtApplyStandardScroller( ::oListWidget )

   WITH OBJECT ::oFiller := QLabel()
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      :setMinimumHeight( 0 )
      :setSizePolicy( QSizePolicy_Preferred, QSizePolicy_Expanding )
      :setStyleSheet( "background-color: rgba(0,0,0,60);" )
      :connect( QEvent_MouseButtonPress  , {|oEvent| ::manageLeftRight( oEvent, QEvent_MouseButtonPress   ) } )
      :connect( QEvent_MouseButtonRelease, {|oEvent| ::manageLeftRight( oEvent, QEvent_MouseButtonRelease ) } )
   ENDWITH

   WITH OBJECT ::oLayout
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
      :addWidget( ::oHeaderLabel )
      :addWidget( ::oListWidget )
      :addWidget( ::oFiller )

      :setStretch( 0, 0 )
      :setStretch( 1, 1 )
      :setStretch( 2, 0 )
   ENDWITH

   ::applyStyleSheet()
   ::applyAnimation()

   WITH OBJECT ::oWidget
      IF ::focusOut()
         :connect( QEvent_FocusOut, {|| ::hide() } )
      ENDIF
   ENDWITH
   RETURN Self


METHOD HbQtSlidingList:addItem( cName, xItem, bBlock )
   LOCAL oItem, oLay, oFrame, oLabel, cText, oPixmap, nHeight, i

   WITH OBJECT oLay := QHBoxLayout()
      :setSpacing( 5 )
   ENDWITH
   WITH OBJECT oFrame := QFrame()
      :setLayout( oLay )
      :setMinimumWidth( __hbqtPixelsByDPI( ::nWidth ) )
      :setMinimumHeight( __hbqtPixelsByDPI( ::nItemsHeight ) )
      :setMaximumHeight( __hbqtPixelsByDPI( ::nItemsHeight ) )
      :connect( QEvent_MouseButtonPress   , {|oEvent| ::manageLeftRight( oEvent, QEvent_MouseButtonPress   ) } )
      :connect( QEvent_MouseButtonRelease , {|oEvent| ::manageLeftRight( oEvent, QEvent_MouseButtonRelease ) } )
   ENDWITH
   WITH OBJECT oLay
      DO CASE
      CASE HB_ISARRAY( xItem ) .AND. Len( xItem ) >= 2
         ASize( xItem, 3 )
         cText := xItem[ 1 ]
         IF HB_ISOBJECT( xItem[ 2 ] )
            oPixmap := xItem[ 2 ]
            WITH OBJECT oLabel := QLabel()
               :setPixmap( oPixmap:scaled( __hbqtPixelsByDPI( 36 ), __hbqtPixelsByDPI( 36 ) ) )
               :setMaximumWidth( __hbqtPixelsByDPI( 36 ) )
            ENDWITH
            :addWidget( oLabel )
         ENDIF
         WITH OBJECT oLabel := QLabel( cText )
            :setObjectName( "SlidingLabel" )
         ENDWITH
         IF HB_ISOBJECT( xItem[ 3 ] )
            oLabel:setFont( xItem[ 3 ] )
         ENDIF
         :addWidget( oLabel )
      CASE HB_ISOBJECT( xItem )
         :addWidget( xItem )
      CASE HB_ISHASH( xItem )
      ENDCASE
   ENDWITH

   WITH OBJECT oItem := QListWidgetItem()
      :setData( Qt_WhatsThisRole, QVariant( cName ) )
      :setSizeHint( oFrame:sizeHint() )
   ENDWITH

   ::hItems[ cName ] := { oItem, bBlock, oFrame }

   WITH OBJECT ::oListWidget
      :addItem( oItem )
      :setItemWidget( oItem, oFrame )
   ENDWITH
   ::addSeparator()

   nHeight := 0
   FOR i := 0 TO ::oListWidget:count() - 1
      nHeight += ::oListWidget:item( i ):sizeHint():height()
   NEXT
   ::oListWidget:setMaximumHeight( nHeight )
   RETURN Self


METHOD HbQtSlidingList:addSeparator()
   LOCAL oLabel

   WITH OBJECT oLabel := QLabel()
      :setMaximumHeight( __hbqtPixelsByDPI( ::nSeparatorHeight ) )
      :setStyleSheet( "background-color: " + ::oSeparatorColor:name() )
   ENDWITH
   ::hSeparators[ hb_ntos( Seconds() ) ] := oLabel
   RETURN Self


METHOD HbQtSlidingList:manageItemClicked( cName )
   ::hide()
   IF hb_HHasKey( ::hItems, cName ) .AND. HB_ISBLOCK( ::hItems[ cName ][ 2 ] )
      Eval( ::hItems[ cName ][ 2 ], cName )
   ENDIF
   IF HB_ISBLOCK( ::bActivatedBlock )
      Eval( ::bActivatedBlock, cName )
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:applyAnimation()
   LOCAL nWidth := __hbqtPixelsByDPI( ::nWidth )

   IF ! HB_ISOBJECT( ::oWidget )
      RETURN Self
   ENDIF

   ::oAnimation1 := NIL
   ::oAnimation2 := NIL

   SWITCH ::nDirection
   CASE __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
      WITH OBJECT ::oAnimation1 := QPropertyAnimation( ::oWidget, QByteArray( "pos" ) )
         :setDuration( ::nMiliSeconds )
         :setStartValue( QVariant( QPoint( nWidth * -1, 0 ) ) )
         :setEndValue( QVariant( QPoint( 0, 0 ) ) )
      ENDWITH
      WITH OBJECT ::oAnimation2 := QPropertyAnimation( ::oWidget, QByteArray( "pos" ) )
         :setDuration( ::nMiliSeconds - ::nMiliSeconds / 3 )
         :setStartValue( QVariant( QPoint( 0, 0 ) ) )
         :setEndValue( QVariant( QPoint( nWidth * -1, 0 ) ) )
      ENDWITH
      EXIT
   CASE __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__
      WITH OBJECT ::oAnimation1 := QPropertyAnimation( ::oWidget, QByteArray( "pos" ) )
         :setDuration( ::nMiliSeconds )
         :setStartValue( QVariant( QPoint( ::oParent:width(), 0 ) ) )
         :setEndValue( QVariant( QPoint( ::oParent:width() - nWidth, 0 ) ) )
      ENDWITH
      WITH OBJECT ::oAnimation2 := QPropertyAnimation( ::oWidget, QByteArray( "pos" ) )
         :setDuration( ::nMiliSeconds - ::nMiliSeconds / 3 )
         :setStartValue( QVariant( QPoint( ::oParent:width() - nWidth, 0 ) ) )
         :setEndValue( QVariant( QPoint( ::oParent:width(), 0 ) ) )
      ENDWITH
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtSlidingList:show()
   LOCAL nWidth := __hbqtPixelsByDPI( ::nWidth )

   ::oWidget:setFocus()
   WITH OBJECT ::oWidget
      :raise()
      :resize( nWidth, ::oParent:height() )
      SWITCH ::nDirection
      CASE __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
         WITH OBJECT ::oAnimation1
            :setDuration( ::nMiliSeconds )
            :setStartValue( QVariant( QPoint( nWidth * -1, 0 ) ) )
            :setEndValue( QVariant( QPoint( 0, 0 ) ) )
         ENDWITH
         WITH OBJECT ::oAnimation2
            :setDuration( ::nMiliSeconds - ::nMiliSeconds / 3 )
            :setStartValue( QVariant( QPoint( 0, 0 ) ) )
            :setEndValue( QVariant( QPoint( nWidth * -1, 0 ) ) )
         ENDWITH
         EXIT
      CASE __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__
         WITH OBJECT ::oAnimation1
            :setDuration( ::nMiliSeconds )
            :setStartValue( QVariant( QPoint( ::oParent:width(), 0 ) ) )
            :setEndValue( QVariant( QPoint( ::oParent:width() - nWidth, 0 ) ) )
         ENDWITH
         WITH OBJECT ::oAnimation2
            :setDuration( ::nMiliSeconds - ::nMiliSeconds / 3 )
            :setStartValue( QVariant( QPoint( ::oParent:width() - nWidth, 0 ) ) )
            :setEndValue( QVariant( QPoint( ::oParent:width(), 0 ) ) )
         ENDWITH
         EXIT
      ENDSWITCH
#if 0
      IF ! ::focusOut()
         ::oWidget:setWindowModality( Qt_ApplicationModal )
      ENDIF
#endif
      :show()
   ENDWITH
   ::oAnimation1:start()
   RETURN .F.


METHOD HbQtSlidingList:hide()

   ::oAnimation2:start()
   SWITCH ::nDirection
   CASE __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
      DO WHILE ::oWidget:x() > ( -1 * ::oWidget:width() )
         QApplication():processEvents()
      ENDDO
      EXIT
   CASE __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__
      DO WHILE ::oWidget:x() < ::oParent:width()
         QApplication():processEvents()
      ENDDO
      EXIT
   ENDSWITCH
#if 0
   IF ! ::focusOut()
      ::oWidget:setWindowModality( Qt_NonModal )
   ENDIF
#endif
   ::oWidget:hide()
   IF HB_ISBLOCK( ::bHidingBlock )
      Eval( ::bHidingBlock )
   ENDIF
   RETURN .F.


METHOD HbQtSlidingList:manageLeftRight( oEvent, nEvent )
   LOCAL lRight, nAngle
   LOCAL nX := oEvent:x()
   LOCAL nY := oEvent:y()

   IF nEvent == QEvent_MouseButtonRelease
      IF Abs( nX - ::nPressX ) > __hbqtPixelsByDPI( 32 )
         nAngle := Abs( atn2( nY - ::nPressY, nX - ::nPressX ) * 180 / PI )
         IF nAngle < 30         // right to left swiped - nexr action
            lRight := .F.
         ELSEIF nAngle > 150    // left to right swapped - previous action
            lRight := .T.
         ENDIF
      ENDIF
      IF HB_ISLOGICAL( lRight )
         IF lRight .AND. ::nDirection == __HBQTSLIDINGLIST_DIRECTION_LEFTTORIGHT__
            ::hide()
         ELSEIF ! lRight .AND. ::nDirection == __HBQTSLIDINGLIST_DIRECTION_RIGHTTOLEFT__
            ::hide()
         ENDIF
      ENDIF
   ELSE
      ::nPressX := nX
      ::nPressY := nY
   ENDIF
   RETURN .F.


METHOD HbQtSlidingList:setSlidingDirection( nDirection )
   IF HB_ISNUMERIC( nDirection )
      ::nDirection := nDirection
      ::applyAnimation()
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setTextColor( oColor )
   IF HB_ISOBJECT( oColor )
      ::oTextColor := NIL
      ::oTextColor := oColor
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setBackgroundColor( oColor )
   IF HB_ISOBJECT( oColor )
      ::oColor := NIL
      ::oColor := oColor
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setOpacity( nOpacity )
   IF HB_ISNUMERIC( nOpacity )
      ::nOpacity := nOpacity
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setDuration( nMiliSeconds )
   IF HB_ISNUMERIC( nMiliSeconds )
      ::nMiliSeconds := nMiliSeconds
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setWidth( nWidth )
   IF HB_ISNUMERIC( nWidth )
      ::nWidth := nWidth
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setItemsHeight( nHeight )
   LOCAL aItem

   DEFAULT nHeight TO ::nItemsHeight
   ::nItemsHeight := nHeight
   FOR EACH aItem IN ::hItems
      aItem[ 1 ]:setSizeHint( QSize( __hbqtPixelsByDPI( ::nWidth ), __hbqtPixelsByDPI( ::nItemsHeight ) ) )
   NEXT
   RETURN Self


METHOD HbQtSlidingList:setClickEvent( nEvent )
   IF HB_ISNUMERIC( nEvent )
      ::nClickEvent := nEvent
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setHeader( nHeight, cText, oTextColor, oBackColor )
   HB_SYMBOL_UNUSED( nHeight + cText + oTextColor + oBackColor )
   RETURN Self


METHOD HbQtSlidingList:setSeparator( nHeight, oColor )
   LOCAL oLabel

   IF HB_ISNUMERIC( nHeight )
      ::nSeparatorHeight := nHeight
      FOR EACH oLabel IN ::hSeparators
         oLabel:setMaximumHeight( __hbqtPixelsByDPI( ::nSeparatorHeight ) )
      NEXT
   ENDIF
   IF HB_ISOBJECT( oColor )
      ::oSeparatorColor := NIL
      ::oSeparatorColor := oColor
      FOR EACH oLabel IN ::hSeparators
         oLabel:setStyleSheet( "background-color: " + ::oSeparatorColor:name() )
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtSlidingList:setEnabled( cName, lEnable )
   HB_SYMBOL_UNUSED( cName + lEnable )
   RETURN Self


METHOD HbQtSlidingList:setHidden( cName, lHide )
   HB_SYMBOL_UNUSED( cName + lHide )
   RETURN Self


METHOD HbQtSlidingList:hidingBlock( bBlock )
   LOCAL oldBlock := ::bHidingBlock
   IF HB_ISBLOCK( bBlock )
      ::bHidingBlock := bBlock
   ENDIF
   RETURN oldBlock


METHOD HbQtSlidingList:activatedBlock( bBlock )
   LOCAL oldBlock := ::bActivatedBlock
   IF HB_ISBLOCK( bBlock )
      ::bActivatedBlock := bBlock
   ENDIF
   RETURN oldBlock


METHOD HbQtSlidingList:applyStyleSheet()
   LOCAL s := ""
   LOCAL aSS := {}

   AAdd( aSS, '#SlidingWidget {' )
   AAdd( aSS, '   background: '                 + 'rgba( 0,0,0,60 );' )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingHeader {' )
   AAdd( aSS, '   min-height: '                 + __hbqtCssPX( 25 ) )
   AAdd( aSS, '   font-size: '                  + __hbqtCssPX( 18 ) )
   AAdd( aSS, '   color: white;'  )
   AAdd( aSS, '   background-color: lightgray;' )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingLabel {' )
   AAdd( aSS, '   font-size: '                  + __hbqtCssPX( 18 ) )
   AAdd( aSS, '   color: white;'  )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList {' )
   AAdd( aSS, '   color: white;' )
   AAdd( aSS, '   background-color: '           + 'rgba(0,0,0,60);' )
   AAdd( aSS, '   font-size: '                  + __hbqtCssPX( 18 ) )
   AAdd( aSS, '   padding-left: '               + __hbqtCssPX( 2 ) )
   AAdd( aSS, '   padding-right: '              + __hbqtCssPX( 2 ) )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList::item {' )
   AAdd( aSS, '   color: white;' )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList::item::icon {' )
   AAdd( aSS, '   padding-left: '               + __hbqtCssPX( 10 ) )
   AAdd( aSS, '   padding-right: '              + __hbqtCssPX( 10 ) )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList::item::text {' )
   AAdd( aSS, '   padding-left: '               + __hbqtCssPX( 10 ) )
   AAdd( aSS, '   padding-right: '              + __hbqtCssPX( 10 ) )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList::item:selected {' )
   AAdd( aSS, '   background-color: '           + 'rgba(100,100,100,200);' )
   AAdd( aSS, '}' )
   AAdd( aSS, '#SlidingList::item:!selected {' )
   AAdd( aSS, '   background-color: '           + 'rgba(100,100,100,200);' )
   AAdd( aSS, '}' )

   AEval( aSS, {|e| s += e + Chr( 13 ) + Chr( 10 ) } )

   ::oWidget:setStyleSheet( s )
   RETURN s

