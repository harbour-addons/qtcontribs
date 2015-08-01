/*
 * $Id$
 */

/*
 * Copyright 2015 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                              05Jul2015
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"

REQUEST JustToLinkEverything


CLASS HbQtBarcodeReader

   DATA   oParent
   DATA   oWidget
   DATA   oStackedWidget
   DATA   oQmlContainerWidget
   DATA   oViewfinderLabel
   DATA   oQmlBridge
   DATA   oLabel
   DATA   oBtnDone
   DATA   oBtnAgain
   DATA   oBtnCancel
   DATA   cBarcode                                INIT ""

   DATA   oBarDecoder
   DATA   lInDecoding                             INIT .F.

   DATA   bBarcodeFound
   DATA   oLastFocusWidget
   DATA   isAndroid
   DATA   lIsAppWidgetParent                      INIT .F.

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD show()
   METHOD close()
   METHOD startCamera()
   METHOD stopCamera()
   METHOD stopScanning()
   METHOD geometryChanged()
   METHOD manageBarcodeFound( cBarcode )
   METHOD manageEvent( cEvent )
   METHOD manageEventClose()

   METHOD barcodeFoundBlock( bBlock )             SETGET
   METHOD dispImage( oImage )

   ACCESS widget()                                INLINE ::oWidget
   ENDCLASS


METHOD HbQtBarcodeReader:init( oParent )
   ::oParent := oParent
#ifdef __ANDROID__
   ::isAndroid := .T.
#else
   ::isAndroid := .F.
#endif
   RETURN Self


METHOD HbQtBarcodeReader:create( oParent )
   LOCAL oVLayout, oHLayout

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::lIsAppWidgetParent := ( ::oParent == __hbqtAppWidget() )

   IF HB_ISOBJECT( ::oParent )
      ::oWidget := QWidget( ::oParent )
      __hbqtLayoutWidgetInParent( ::oWidget, ::oParent )
   ELSE
      ::oWidget := QWidget()
   ENDIF

   WITH OBJECT oVLayout := QVBoxLayout()
      :setContentsMargins( 10, 10, 10, 10 )
   ENDWITH

   WITH OBJECT ::oWidget
      :setFocusPolicy( Qt_NoFocus )
      :setLayout( oVLayout )
      :hide()
   ENDWITH

   WITH OBJECT ::oStackedWidget := QStackedWidget()
      :setFocusPolicy( Qt_NoFocus )
   ENDWITH
   oVLayout:addWidget( ::oStackedWidget )

   WITH OBJECT ::oQmlContainerWidget := QWidget()
       //
   ENDWITH
   ::oStackedWidget:addWidget( ::oQmlContainerWidget )
   WITH OBJECT ::oLabel := QLabel()
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      :setStyleSheet( "background-color: rgba(0,0,0,200); color: white; font-size: " + __hbqtCssPX( 36 ) )
   ENDWITH
   ::oStackedWidget:addWidget( ::oLabel )
   WITH OBJECT ::oViewfinderLabel := QLabel()
      :setAlignment( Qt_AlignHCenter + Qt_AlignVCenter )
      :setStyleSheet( "background-color: rgba(0,0,0,255);" )
   ENDWITH
   ::oStackedWidget:addWidget( ::oViewfinderLabel )

   ::oStackedWidget:setCurrentIndex( iif( ::isAndroid, 0, 2 ) )

   WITH OBJECT oHLayout := QHBoxLayout()
      :setContentsMargins( 10,10,10,10 )
   ENDWITH
   oVLayout:addLayout( oHLayout )

   WITH OBJECT ::oBtnDone := QPushButton( "Done" )
      :setFocusPolicy( Qt_NoFocus )
      :connect( "clicked()", {|| ::manageEvent( "done" ) } )
   ENDWITH
   WITH OBJECT ::oBtnAgain := QPushButton( "Try Again" )
      :setFocusPolicy( Qt_NoFocus )
      :connect( "clicked()", {|| ::manageEvent( "tryagain" ) } )
   ENDWITH
   WITH OBJECT ::oBtnCancel := QPushButton( "Cancel" )
      :setFocusPolicy( Qt_NoFocus )
      :connect( "clicked()", {|| ::manageEvent( "cancelled" ) } )
   ENDWITH
   WITH OBJECT oHLayout
      :addWidget( ::oBtnDone )
      :addWidget( ::oBtnAgain )
      :addWidget( ::oBtnCancel )
   ENDWIT
   __hbqtRegisterForEventClose( {|| ::manageEventClose() } )

   // register C++ classes in order to access them inside QML
   // immediately before those are about to be Used
   //
   HBQAbstractVideoSurface():registerQmlTypes()
   QZXing():registerQmlTypes()

   ::oQmlBridge := HbQtQmlBridge():new():create( ::oQmlContainerWidget )

   // provide the QML document location needed
   //
   IF ::oQmlBridge:setQml( "qrc:/hbqtqml/resources/qml/BarcodeReader.qml" )
      ::stopCamera()

#ifndef __ANDROID__
      // because QVideoProbe() is only available for Android
      // we need render the frame ourselves, so this connection
      //
      ::oQmlBridge:connectChild( "videosurface", "imageAvailable(QImage)", {| oImage | ::dispImage( oImage ) } )
#endif
      // we could have connected the "qzxing" child also for the same effect
      // but we decided to receive signal via QML document as it implements
      // more constructs.
      //
      ::oQmlBridge:connect( "tagFound(QString)", {| cTag | ::manageBarcodeFound( cTag ) } )

      __hbqtAppRefresh()
   ENDIF

   RETURN Self


METHOD HbQtBarcodeReader:show()
   ::oLastFocusWidget := QApplication():focusWidget()
   ::cBarcode := ""

   WITH OBJECT ::oWidget
      IF HB_ISOBJECT( ::oParent )
         :resize( ::oParent:width(), ::oParent:height() )
      ELSE
         :resize( __hbqtAppWidget():width(), __hbqtAppWidget():height() )
      ENDIF
      :move( 0, 0 )
      :show()
      :raise()
   ENDWITH

   ::oStackedWidget:setCurrentIndex( iif( ::isAndroid, 0, 2 ) )
   ::startCamera()
   RETURN Self


METHOD HbQtBarcodeReader:close()
   ::stopCamera()
   ::oWidget:lower()
   ::oWidget:setGeometry( QRect( 0, 0, 0, 0 ) )
   ::oWidget:hide()
   IF HB_ISOBJECT( ::oLastFocusWidget )
      ::oLastFocusWidget:setFocus()
   ENDIF
   RETURN NIL


METHOD HbQtBarcodeReader:manageEvent( cEvent )

   ::oStackedWidget:setCurrentIndex( iif( ::isAndroid, 0, 2 ) )

   SWITCH Lower( cEvent )
   CASE "done"
      IF ! Empty( ::cBarcode )
         __hbqtLog( ::cBarcode )
      ENDIF
      IF HB_ISBLOCK( ::barcodeFoundBlock() ) .AND. ! Empty( ::cBarcode )
         Eval( ::barcodeFoundBlock(), ::cBarcode )
      ENDIF
      ::close()
      EXIT
   CASE "tryagain"
      ::cBarcode := ""
      ::startCamera()
      EXIT
   CASE "cancelled"
      ::cBarcode := ""
      ::close()
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtBarcodeReader:startCamera()
   ::oQmlBridge:invokeMethod( "startCamera" )
   RETURN Self


METHOD HbQtBarcodeReader:stopCamera()
   ::oQmlBridge:invokeMethod( "stopCamera" )
   RETURN Self


METHOD HbQtBarcodeReader:stopScanning()
   ::oQmlBridge:invokeMethod( "stopScanning" )
   RETURN Self


METHOD HbQtBarcodeReader:manageBarcodeFound( cBarcode )

   ::cBarcode := cBarcode
   ::oLabel:setText( ::cBarcode )
   ::oStackedWidget:setCurrentIndex( 1 )

   RETURN Self


METHOD HbQtBarcodeReader:barcodeFoundBlock( bBlock )
   LOCAL bOldBlock := ::bBarcodeFound
   IF HB_ISBLOCK( bBlock )
      ::bBarcodeFound := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtBarcodeReader:manageEventClose()
   IF ::oWidget:isVisible()
      ::close()
      RETURN .T.
   ENDIF
   RETURN .F.


METHOD HbQtBarcodeReader:geometryChanged()
   IF ::oWidget:isVisible()
      ::oWidget:setGeometry( __hbqtAppWidget():geometry() )
      ::oWidget:move( 0,0 )
   ENDIF
   RETURN Self


METHOD HbQtBarcodeReader:dispImage( oImage )
   LOCAL scaledImage := oImage:scaled( ::oViewfinderLabel:size(), Qt_KeepAspectRatio, Qt_SmoothTransformation )

   ::oViewfinderLabel:setPixmap( QPixmap():fromImage( scaledImage:mirrored() ) )
   RETURN Self


