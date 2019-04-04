 /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2018 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                              30July2018
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


CLASS HbQtWarnTimeout

   DATA   oWidget
   DATA   oParent
   DATA   oSignature
   DATA   oBtnExtend
   DATA   oLabel
   DATA   oMsgLabel
   DATA   cMessage                                INIT "Session expires in ... seconds!"
   DATA   oTimer
   DATA   oBackgroundColor                        INIT QColor( 255, 255, 255 )
   DATA   oSilverLightColor                       INIT QColor( 50, 50, 50 )
   DATA   lAnimate                                INIT .F.

   DATA   nWaitPeriod                             INIT 10
   DATA   nWaiting                                INIT 10
   DATA   bFinishedBlock

   ACCESS widget()                                INLINE ::oWidget

   METHOD init( oParent, bBlock )
   METHOD create( oParent, bBlock )
   METHOD show()
   METHOD hide( nStatus )

   METHOD setSilverLightAnimation( lAnimate )     INLINE iif( HB_ISLOGICAL( lAnimate ), ::lAnimate := lAnimate, NIL )
   METHOD setSilverLightColor( oColor )           INLINE iif( HB_ISOBJECT( oColor ), ::oSilverLightColor := oColor, NIL )
   METHOD setBackgroundColor( oColor )            INLINE iif( HB_ISOBJECT( oColor ), ::oBackgroundColor := oColor, NIL )
   METHOD setFinishedBlock( bBlock )              INLINE iif( HB_ISBLOCK( bBlock ), ::bFinishedBlock := bBlock, NIL )
   METHOD setWaitPeriod( nSeconds )               INLINE iif( HB_ISNUMERIC( nSeconds ) .AND. nSeconds > 10, ::nWaitPeriod := nSeconds, NIL )
   METHOD setMessage( cMessage )                  INLINE iif( HB_ISSTRING( cMessage ) .AND. ! Empty( cMessage ), ::cMessage := cMessage, NIL ), ::oMsgLabel:setText( ::cMessage )

   ENDCLASS


METHOD HbQtWarnTimeout:init( oParent, bBlock )

   DEFAULT oParent TO ::oParent
   DEFAULT bBlock  TO ::bFinishedBlock

   ::oParent := oParent
   ::bFinishedBlock := bBlock
   RETURN Self


METHOD HbQtWarnTimeout:create( oParent, bBlock )
   LOCAL oVLay
   
   DEFAULT oParent TO ::oParent
   DEFAULT bBlock  TO ::bFinishedBlock

   ::oParent := oParent
   ::bFinishedBlock := bBlock

   DEFAULT ::oParent TO __hbqtAppWidget()

   WITH OBJECT oVLay := QVBoxLayout()
      :setContentsMargins( 20, 20, 20, 20 )
   ENDWITH
   WITH OBJECT ::oWidget := QWidget( ::oParent )
      :setLayout( oVLay )
      :setMaximumWidth( 500 )
      :setMaximumHeight( 350 )
      :setStyleSheet( "background-color: rgb(100,100,100);" )
   ENDWITH
   WITH OBJECT ::oMsgLabel := QLabel()
      :setWordWrap( .T. )
      :setText( ::cMessage )
      :setFont( QFont( "Arial Black", 16 ) )
      :setMaximumHeight( 30 )
      :setAlignment( Qt_AlignHCenter )
      :setStyleSheet( "color: #00FF7F;" )
   ENDWITH
   WITH OBJECT ::oLabel := QLabel( hb_ntos( ::nWaitPeriod ) )
      :setFont( QFont( "Arial Black", 96 ) )
      :setAlignment( Qt_AlignHCenter )
      :setStyleSheet( "color: #00FF7F;" )
      :setWordWrap( .F. )
   ENDWITH
   WITH OBJECT ::oBtnExtend := QPushButton( "Extend Time" )
      :setFont( QFont( "Areal Black", 24 ) )     
      :setStyleSheet( "color: yellow;" )
      :connect( "clicked()", {|| ::hide( 1 ) } )
   ENDWITH

   WITH OBJECT oVLay
      :addWidget( ::oMsgLabel )
      :addWidget( ::oLabel )
      :addWidget( ::oBtnExtend )
   ENDWITH

   ::oWidget:resize( 480, 320 )

   WITH OBJECT ::oTimer := QTimer()
      :setInterval( 1000 )
      :connect( "timeout()", {|| ::hide( 2 ) } )
   ENDWITH
   RETURN Self


METHOD HbQtWarnTimeout:show()
   ::nWaiting := ::nWaitPeriod
   ::oLabel:setText( hb_ntos( ::nWaiting ) )
   HbQtActivateSilverLight( .T., "", ::oSilverLightColor, ::lAnimate )
   WITH OBJECT ::oWidget
      :raise()
      :move( ( ::oParent:width() - :width() ) / 2, ( ::oParent:height() - :height() ) / 2 )
      :show()
   ENDWITH
   ::oTimer:start()
   RETURN NIL


METHOD HbQtWarnTimeout:hide( nStatus )
   ::nWaiting--
   IF nStatus == 2 .AND. ::nWaiting > 0
      ::oLabel:setText( hb_ntos( ::nWaiting ) )
      RETURN NIL 
   ELSE 
      ::oTimer:stop()
      WITH OBJECT ::oWidget
         :lower()
         :hide()
      ENDWITH
      HbQtActivateSilverLight( .F. )
   ENDIF 
   RETURN iif( HB_ISBLOCK( ::bFinishedBlock ), Eval( ::bFinishedBlock, nStatus ), NIL )

//--------------------------------------------------------------------//
//                        HbQtFetchTimeout()
//--------------------------------------------------------------------//

FUNCTION HbQtSessionTimeout( bBlock, nWaitPeriod )
   STATIC oTimeout
   IF ! HB_ISOBJECT( oTimeout )
      oTimeout := HbQtWarnTimeout():new():create()
   ENDIF
   IF HB_ISOBJECT( oTimeout )
      WITH OBJECT oTimeout
         :setSilverLightColor( QColor( 100,100,100 ) )
         :setFinishedBlock( bBlock )
         :setWaitPeriod( nWaitPeriod )
         :show()
      ENDWITH
   ENDIF
   RETURN NIL




