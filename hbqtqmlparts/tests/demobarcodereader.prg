/*
 * $Id$
 */

/*
 * Copyright 2015 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"


FUNCTION Main()
   LOCAL oWnd, oLay, oBtn

   WITH OBJECT oLay := QVBoxLayout()
      :setContentsMargins( 10,10,10,10 )
   ENDWITH
   WITH OBJECT oWnd := QWidget()
      :resize( 640, 500 )
      :setLayout( oLay )
   ENDWITH
   WITH OBJECT oBtn := QPushButton( "Activate Barcode Reader" )
      :connect( "clicked()", {|| __hbqtActivateBarcodeReader( {|cBarcode| Alert( cBarcode ) } ) } )
   ENDWITH
   oLay:addWidget( oBtn )

   // HbQt's Barcode Reader requires application window to be its parent
   //
   __hbqtAppWidget( oWnd )

   oWnd:show()

   QApplication():exec()
   RETURN NIL


