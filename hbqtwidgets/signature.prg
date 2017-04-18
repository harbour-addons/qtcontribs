 /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2017 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                             Pritpal Bedi
 *                             04March2017
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "fileio.ch"
#include "hbgtinfo.ch"
#include "hbhrb.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"


CLASS HbQtSignature

   DATA   oWidget
   DATA   oParent
   DATA   oSignature
   DATA   oBtnOK
   DATA   oBtnCancel
   DATA   oBtnRefresh
   DATA   oMsgLabel
   DATA   cMessage                                INIT "Your Signatures Please"
   DATA   oTimer
   DATA   nImageFormat                            INIT QImage_Format_RGB32
   DATA   oBackgroundColor                        INIT QColor( 255, 255, 255 )
   DATA   oSilverLightColor                       INIT QColor( 50, 50, 50 )
   DATA   lAnimate                                INIT .F.

   DATA   nPenWidth                               INIT 3
   DATA   lModified                               INIT .F.
   DATA   lScribbling                             INIT .F.
   DATA   oImage
   DATA   oLastPoint
   DATA   oPenColor                               INIT QColor( Qt_blue )
   DATA   nWaitPeriod                             INIT 60
   DATA   bFinishedBlock

   ACCESS widget()                                INLINE ::oWidget

   METHOD init( oParent, bBlock )
   METHOD create( oParent, bBlock )
   METHOD show()
   METHOD hide( nStatus )
   METHOD clear()

   METHOD setImageFormat( nFormat )               INLINE iif( HB_ISNUMERIC( nFormat ), ::nImageFormat := nFormat, NIL )
   METHOD setSilverLightAnimation( lAnimate )     INLINE iif( HB_ISLOGICAL( lAnimate ), ::lAnimate := lAnimate, NIL )
   METHOD setSilverLightColor( oColor )           INLINE iif( HB_ISOBJECT( oColor ), ::oSilverLightColor := oColor, NIL )
   METHOD setBackgroundColor( oColor )            INLINE iif( HB_ISOBJECT( oColor ), ::oBackgroundColor := oColor, NIL )
   METHOD setFinishedBlock( bBlock )              INLINE iif( HB_ISBLOCK( bBlock ), ::bFinishedBlock := bBlock, NIL )
   METHOD setWaitPeriod( nSeconds )               INLINE iif( HB_ISNUMERIC( nSeconds ) .AND. nSeconds > 10, ::nWaitPeriod := nSeconds, NIL )
   METHOD setMessage( cMessage )                  INLINE iif( HB_ISSTRING( cMessage ) .AND. ! Empty( cMessage ), ::cMessage := cMessage, NIL ), ::oMsgLabel:setText( ::cMessage )
   METHOD setPenWidth( nWidth )                   INLINE iif( HB_ISNUMERIC( nWidth ) .AND. nWidth >= 1, ::nPenWidth := nWidth, NIL )
   METHOD setPenColor( oColor )                   INLINE iif( HB_ISOBJECT( oColor ), ::oPenColor := oColor, NIL )
   METHOD isModified()                            INLINE ::lModified

   METHOD mousePressed( oEvent )
   METHOD mouseReleased( oEvent )
   METHOD mouseMoved( oEvent )
   METHOD paint( oEvent, oPainter )
   METHOD resize( oEvent )
   METHOD drawLineTo( oEndPoint )
   METHOD resizeImage( nWidth, nHeight )

   METHOD getSignature()

   ENDCLASS


METHOD HbQtSignature:init( oParent, bBlock )

   DEFAULT oParent TO ::oParent
   DEFAULT bBlock  TO ::bFinishedBlock

   ::oParent := oParent
   ::bFinishedBlock := bBlock
   RETURN Self


METHOD HbQtSignature:create( oParent, bBlock )
   LOCAL oVLay, oHLay

   DEFAULT oParent TO ::oParent
   DEFAULT bBlock  TO ::bFinishedBlock

   ::oParent := oParent
   ::bFinishedBlock := bBlock

   DEFAULT ::oParent TO __hbqtAppWidget()

   WITH OBJECT ::oImage := QImage( QSize( 100, 100 ), ::nImageFormat )
      :fill( QColor( 255, 255, 255 ) )
   ENDWITH

   WITH OBJECT oVLay := QVBoxLayout()
      :setContentsMargins( 10, 10, 10, 0 )
   ENDWITH
   WITH OBJECT ::oWidget := QWidget( ::oParent )
      :setLayout( oVLay )
      :setMaximumWidth( 500 )
      :setMaximumHeight( 350 )
      :setStyleSheet( "background-color: rgb(100,100,100);" )
   ENDWITH
   WITH OBJECT ::oSignature := QWidget( ::oWidget )
      :setAttribute( Qt_WA_StaticContents )
      :connect( QEvent_MouseButtonPress  , {|oEvent| ::mousePressed( oEvent ) } )
      :connect( QEvent_MouseButtonRelease, {|oEvent| ::mouseReleased( oEvent ) } )
      :connect( QEvent_MouseMove         , {|oEvent| ::mouseMoved( oEvent ) } )
      :connect( QEvent_Paint             , {|oEvent, oPainter| ::paint( oEvent, oPainter ) } )
      :connect( QEvent_Resize            , {|oEvent| ::resize( oEvent ) } )
   ENDWITH
   WITH OBJECT ::oMsgLabel := QLabel()
      :setWordWrap( .T. )
      :setText( ::cMessage )
      :setFont( QFont( "Arial Black", 16 ) )
      :setMaximumHeight( 30 )
      :setAlignment( Qt_AlignHCenter )
      :setStyleSheet( "color: #00FF7F;" )
   ENDWITH

   WITH OBJECT oHLay := QHBoxLayout()
      :setContentsMargins( 0, 0, 0, 0 )
   ENDWITH

   WITH OBJECT oVLay
      :addWidget( ::oMsgLabel )
      :addWidget( ::oSignature )
      :addLayout( oHLay )
   ENDWITH

   WITH OBJECT ::oBtnOK := QToolButton()
      :setMinimumWidth( 64 )
      :setMinimumHeight( 64 )
      :setAutoRaise( .T. )
      :setIconSize( QSize( 64, 64 ) )
      :setIcon( QIcon( __hbqtImage( "select-3" ) ) )
      :connect( "clicked()", {|| ::hide( 0 ) } )
   ENDWITH
   WITH OBJECT ::oBtnCancel := QToolButton()
      :setMinimumWidth( 64 )
      :setMinimumHeight( 64 )
      :setAutoRaise( .T. )
      :setIconSize( QSize( 64, 64 ) )
      :setIcon( QIcon( __hbqtImage( "cancel" ) ) )
      :connect( "clicked()", {|| ::hide( 1 ) } )
   ENDWITH
   WITH OBJECT ::oBtnRefresh := QToolButton()
      :setMinimumWidth( 64 )
      :setMinimumHeight( 64 )
      :setAutoRaise( .T. )
      :setIconSize( QSize( 64, 64 ) )
      :setIcon( QIcon( __hbqtImage( "refresh-2" ) ) )
      :connect( "clicked()", {|| ::clear() } )
   ENDWITH
   WITH OBJECT oHLay
      :addWidget( ::oBtnCancel )
      :addWidget( ::oBtnRefresh )
      :addStretch()
      :addWidget( ::oBtnOK )
   ENDWITH
   ::oWidget:resize( 480, 320 )

   WITH OBJECT ::oTimer := QTimer()
      :setInterval( ::nWaitPeriod * 1000 )
      :connect( "timeout()", {|| ::hide( 2 ) } )
   ENDWITH

   RETURN Self


METHOD HbQtSignature:show()
   ::clear()
   HbQtActivateSilverLight( .T., "", ::oSilverLightColor, ::lAnimate )
   WITH OBJECT ::oWidget
      :raise()
      :move( ( ::oParent:width() - :width() ) / 2, ( ::oParent:height() - :height() ) / 2 )
      :show()
   ENDWITH
   ::oTimer:start()
   ::lModified := .F.
   RETURN NIL


METHOD HbQtSignature:hide( nStatus )
   ::oTimer:stop()
   WITH OBJECT ::oWidget
      :lower()
      :hide()
   ENDWITH
   HbQtActivateSilverLight( .F. )
   RETURN iif( HB_ISBLOCK( ::bFinishedBlock ), Eval( ::bFinishedBlock, nStatus, iif( ::lModified, QImage( ::oImage ), NIL ) ), NIL )


METHOD HbQtSignature:clear()

   ::oImage:fill( ::oBackgroundColor )
   ::lModified := .T.
   ::oSignature:update()

   RETURN NIL


METHOD HbQtSignature:mousePressed( oEvent )
   IF oEvent:button() == Qt_LeftButton
      ::oLastPoint := oEvent:pos()
      ::lScribbling := .T.
   ENDIF
   RETURN .F.


METHOD HbQtSignature:mouseReleased( oEvent )
   IF oEvent:button() == Qt_LeftButton .AND. ::lScribbling
      ::drawLineTo( oEvent:pos() )
      ::lScribbling := .F.
   ENDIF
   RETURN .F.


METHOD HbQtSignature:mouseMoved( oEvent )
   IF hb_bitAnd( oEvent:buttons(), Qt_LeftButton ) == Qt_LeftButton .AND. ::lScribbling
      ::drawLineTo( oEvent:pos() )
   ENDIF
   RETURN .F.


METHOD HbQtSignature:paint( oEvent, oPainter )
   LOCAL oDirtyRect := oEvent:rect()
   oPainter:drawImage( oDirtyRect, ::oImage, oDirtyRect )
   RETURN .F.


METHOD HbQtSignature:resize( oEvent )
   LOCAL nNewWidth, nNewHeight
   LOCAL nWndWidth := ::oSignature:width()
   LOCAL nWndHeight := ::oSignature:height()

   IF nWndWidth > ::oImage:width() .OR. nWndHeight > ::oImage:height()
      nNewWidth := Max( nWndWidth, ::oImage:width() )
      nNewHeight := Max( nWndHeight, ::oImage:height() )
      ::resizeImage( nNewWidth, nNewHeight )
      ::oSignature:update()
   ENDIF
   HB_SYMBOL_UNUSED( oEvent )
   RETURN .F.


METHOD HbQtSignature:drawLineTo( oEndPoint )
   LOCAL oPainter, nRad

   WITH OBJECT oPainter := QPainter( ::oImage )
      :setPen( QPen( QBrush( ::oPenColor ), ::nPenWidth, Qt_SolidLine, Qt_RoundCap, Qt_RoundJoin ) )
      :drawLine( ::oLastPoint, oEndPoint )
   ENDWITH

   ::lModified := .T.
   nRad := ( ::nPenWidth / 2 ) + 2

   ::oSignature:update( QRect( ::oLastPoint, oEndPoint ):normalized():adjusted( -nRad, -nRad, nRad, nRad ) )
   ::oLastPoint := oEndPoint

   HB_SYMBOL_UNUSED( oPainter )
   RETURN NIL


METHOD HbQtSignature:resizeImage( nWidth, nHeight )
   LOCAL oImg, oPainter

   IF ::oImage:width() == nWidth .AND. ::oImage:height() == nHeight
      RETURN NIL
   ENDIF

   WITH OBJECT oImg :=  QImage( QSize( nWidth, nHeight ), ::nImageFormat )
      :fill( QColor( 255, 255, 255 ) )
   ENDWITH
   WITH OBJECT oPainter := QPainter( oImg )
      :drawImage( QPoint( 0, 0 ), ::oImage )
   ENDWITH
   ::oImage := NIL
   ::oImage := oImg

   HB_SYMBOL_UNUSED( oPainter )
   RETURN NIL


METHOD HbQtSignature:getSignature()
   // ask for the format
   RETURN ::oImage

//--------------------------------------------------------------------//
//                        HbQtFetchSignature()
//--------------------------------------------------------------------//

FUNCTION HbQtFetchSignature( bBlock )
   STATIC oSignature
   IF ! HB_ISOBJECT( oSignature )
      oSignature := HbQtSignature():new():create()
   ENDIF
   IF HB_ISOBJECT( oSignature )
      WITH OBJECT oSignature
         :setPenWidth( 2 )
         :setSilverLightColor( QColor( 100,100,100 ) )
         :setSilverLightAnimation( .T. )
         :setFinishedBlock( bBlock )
         :show()
      ENDWITH
   ENDIF
   RETURN NIL



