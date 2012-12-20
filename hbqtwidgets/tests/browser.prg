/*
 * $Id$
 */

/*
 * Copyright 2012 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbqtgui.ch"

#include "hbtrace.ch"


FUNCTION Main()
   LOCAL oMain, oBrw

   hbqt_errorSys()


   oMain := QWidget()
   oMain:setWindowTitle( "TBrowse Implemented" )

   oBrw := HbQtBrowseNew( 1, 1, 10, 10, oMain )

   oMain:show()
   QApplication():exec()

   RETURN oBrw
