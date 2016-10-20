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
 *                        HbQtSilverLight Class
 *
 *                             Pritpal Bedi
 *                              29Nov2014
 */
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


#define __RGBA_STR__( r,g,b,a )                   "rgba("+hb_ntos(r)+","+hb_ntos(g)+","+hb_ntos(b)+","+hb_ntos(a)+")"


CLASS HbQtSilverLight

   METHOD init( xContent, oBackground, lAnimate, aOpacity, oParent )
   METHOD create( xContent, oBackground, lAnimate, aOpacity, oParent )

   METHOD activate( xContent, oBackground, lAnimate, aOpacity, oParent )
   METHOD deactivate()

   METHOD setContent( xContent )
   METHOD setBackground( oBackground )
   METHOD setAnimation( lAnimate )                INLINE iif( HB_ISLOGICAL( lAnimate ), ::lAnimate := lAnimate, NIL )
   METHOD setAnimationOpacity( aOpacity )
   METHOD setParent( oParent )                    INLINE iif( HB_ISOBJECT( oParent ), ::oParent := oParent, NIL )

   PROTECTED:

   METHOD manageAnimation()

   DATA   oWidget
   DATA   oParent
   DATA   oTimer

   DATA   oBackground                             INIT QColor( 50,50,50 )
   DATA   xContent                                INIT ""
   DATA   lAnimate                                INIT .T.
   DATA   aOpacity                                INIT { 127, 200 }

   DATA   nStart                                  INIT 127
   DATA   nEnd                                    INIT 200
   DATA   nIndex                                  INIT 127
   DATA   nDirection                              INIT 1

   DATA   oFocusWidget
   ENDCLASS


METHOD HbQtSilverLight:init( xContent, oBackground, lAnimate, aOpacity, oParent )

   DEFAULT xContent    TO ::xContent
   DEFAULT oBackground TO ::oBackground
   DEFAULT lAnimate    TO ::lAnimate
   DEFAULT aOpacity    TO ::aOpacity
   DEFAULT oParent     TO ::oParent

   ::xContent    := xContent
   ::oBackground := oBackground
   ::lAnimate    := lAnimate
   ::aOpacity    := aOpacity
   ::oParent     := oParent

   RETURN Self


METHOD HbQtSilverLight:create( xContent, oBackground, lAnimate, aOpacity, oParent )

   DEFAULT xContent    TO ::xContent
   DEFAULT oBackground TO ::oBackground
   DEFAULT lAnimate    TO ::lAnimate
   DEFAULT aOpacity    TO ::aOpacity
   DEFAULT oParent     TO ::oParent

   ::xContent    := xContent
   ::oBackground := oBackground
   ::lAnimate    := lAnimate
   ::aOpacity    := aOpacity
   ::oParent     := oParent

   DEFAULT ::oParent TO __hbqtAppWidget()

   WITH OBJECT ::oWidget := QLabel( ::oParent )
      :hide()
      :setMargin( 10 )
      :setWordWrap( .T. )
      :setOpenExternalLinks( .T. )
      :setTextInteractionFlags( Qt_LinksAccessibleByMouse )
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      :setMouseTracking( .T. )
      :connect( QEvent_MouseButtonPress  , {|oEvent| oEvent:ignore(), .T. } )
      :connect( QEvent_MouseButtonRelease, {|oEvent| oEvent:ignore(), .T. } )
      :connect( QEvent_Close             , {|oEvent| oEvent:ignore(), .T. } )
   ENDWITH

   WITH OBJECT ::oTimer := QTimer()
      :setInterval( 10 )
      :connect( "timeout()", {|| ::manageAnimation() } )
   ENDWITH

   ::setContent( ::xContent )
   ::setAnimation( ::lAnimate )
   ::setAnimationOpacity( ::aOpacity )
   ::setBackground( ::oBackground )

   RETURN Self


METHOD HbQtSilverLight:activate( xContent, oBackground, lAnimate, aOpacity, oParent )

   DEFAULT oParent TO ::oParent

   WITH OBJECT ::oWidget
      ::setContent( xContent )
      ::setAnimation( lAnimate )
      ::setAnimationOpacity( aOpacity )
      ::setBackground( oBackground )

      :setGeometry( oParent:geometry() )
      :move( 0, 0 )
      :resize( ::oParent:width(), ::oParent:height() )
      :raise()
      :show()
      IF ::lAnimate
         ::oTimer:start()
      ENDIF
   ENDWITH
   ::oFocusWidget := ::oParent:focusWidget()
   QApplication():processEvents()

   RETURN Self


METHOD HbQtSilverLight:deactivate()

   QApplication():processEvents( 0 )

   ::oTimer:stop()
   ::oWidget:lower()
   ::oWidget:hide()

   ::nIndex     := ::nStart
   ::nDirection := 1

   IF HB_ISOBJECT( ::oFocusWidget )
      ::oFocusWidget:setFocus()
      ::oFocusWidget := NIL
   ENDIF
   RETURN Self


METHOD HbQtSilverLight:manageAnimation()

   QApplication():processEvents()

   ::nIndex += ::nDirection

   IF ::nIndex < ::nStart
      ::nDirection := +1
   ELSEIF ::nIndex > ::nEnd
      ::nDirection := -1
   ENDIF
   ::setBackground()

   RETURN Self


METHOD HbQtSilverLight:setContent( xContent )

   IF PCount() == 1
      ::xContent := NIL
      ::xContent := xContent
   ENDIF

   IF HB_ISOBJECT( ::oWidget )
      WITH OBJECT ::oWidget
         IF HB_ISSTRING( ::xContent )
            :setText( ::xContent )
         ELSEIF HB_ISOBJECT( ::xContent )
            SWITCH __objGetClsName( ::xContent )
            CASE "QPIXMAP"  ; :setPixmap( ::xContent )  ; EXIT
            CASE "QPICTURE" ; :setPicture( ::xContent ) ; EXIT
            CASE "QMOVIE"   ; :setMovie( ::xContent )   ; EXIT
            ENDSWITCH
         ENDIF
      ENDWITH
   ENDIF

   RETURN Self


METHOD HbQtSilverLight:setBackground( oBackground )
   LOCAL oBG

   IF ! Empty( oBackground )
      ::oBackground := oBackground
   ENDIF
   IF HB_ISOBJECT( ::oWidget )
      IF HB_ISOBJECT( oBG := ::oBackground )
         ::oWidget:setStyleSheet( "font-size: " + __hbqtCssPX( 24 ) + "color: white; background-color: " + ;
                                             __RGBA_STR__( oBG:red(), oBG:green(), oBG:blue(), ::nIndex ) + ";" )
      ENDIF
   ENDIF

   RETURN Self


METHOD HbQtSilverLight:setAnimationOpacity( aOpacity )
   LOCAL nStart, nEnd

   IF HB_ISARRAY( aOpacity )
      ASize( aOpacity, 2 )
      ::aOpacity := aOpacity

      nStart := aOpacity[ 1 ]
      nEnd   := aOpacity[ 2 ]
   ENDIF

   IF HB_ISNUMERIC( nStart ) .AND. nStart >= 0 .AND. nStart <= 255
      ::nStart := nStart
      IF ::nEnd < ::nStart
         ::nEnd := ::nStart
      ENDIF
   ENDIF
   IF HB_ISNUMERIC( nEnd ) .AND. nEnd >= 0 .AND. nEnd <= 255 .AND. nEnd > ::nStart
      ::nEnd := nEnd
   ENDIF
   ::nIndex := ::nStart

   RETURN Self

//--------------------------------------------------------------------//
//                           CLASS HbQtLogs
//--------------------------------------------------------------------//

CLASS HbQtLogs

   DATA   oWidget
   DATA   oParent
   DATA   oPlainText
   DATA   oBtnDone

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD logText( cText )
   METHOD show()
   METHOD hide()
   METHOD clear()

   ENDCLASS


METHOD HbQtLogs:init( oParent )
   ::oParent := oParent
   RETURN Self


METHOD HbQtLogs:create( oParent )
   LOCAL oVLayout

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::oWidget := QWidget( ::oParent )

   __hbqtLayoutWidgetInParent( ::oWidget, ::oParent )

   WITH OBJECT oVLayout := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
   ENDWITH

   WITH OBJECT ::oWidget
      :setLayout( oVLayout )
      :hide()
   ENDWITH

   WITH OBJECT ::oPlainText := QPlainTextEdit()
      :setReadOnly( .T. )
      :setLineWrapMode( QPlainTextEdit_NoWrap )
   ENDWITH
   __hbqtApplyStandardScroller( ::oPlainText )

   WITH OBJECT ::oBtnDone := QPushButton( "Done" )
      :connect( "clicked()", {|| ::hide() } )
   ENDWITH

   WITH OBJECT oVLayout
      :addWidget( ::oPlainText )
      :addWidget( ::oBtnDone )
   ENDWITH

      __hbqtRegisterForEventClose( {|| iif( ::oWidget:isVisible(), ::hide(), NIL ), .F. } )
   RETURN Self


METHOD HbQtLogs:logText( cText )
   ::oPlainText:appendPlainText( cText )
   RETURN Self


METHOD HbQtLogs:clear()
   ::oPlainText:clear()
   RETURN Self


METHOD HbQtLogs:hide()
   ::oWidget:hide()
   HbQtActivateSilverLight( .F. )
   RETURN Self


METHOD HbQtLogs:show()
   HbQtActivateSilverLight( .T., "" )
   WITH OBJECT ::oWidget
      :resize( ::oParent:width() - 120, ::oParent:height() - 120 )
      :move( 60, 60 )
      :raise()
      :show()
   ENDWITH
   RETURN Self

//--------------------------------------------------------------------//

