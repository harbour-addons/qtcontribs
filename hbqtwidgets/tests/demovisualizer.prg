/*
 * $Id$
 */

/*
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "inkey.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


FUNCTION Main()
   LOCAL oWnd, oDa, oLay, oVisualizer, oRect

   oRect := QApplication():desktop():availableGeometry()
   WITH OBJECT oWnd := QMainWindow()
#ifdef __ANDROID__
      :resize( oRect:width(), oRect:height() )
#else
      :resize( 480, 760 )
#endif
   ENDWITH

   WITH OBJECT oLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT oDa := QWidget()
      :setLayout( oLay )
#if 1
      :setStyleSheet( "QListWidget{ background-color: lightgray; }" )
#endif
   ENDWITH
   oWnd:setCentralWidget( oDa )

   WITH OBJECT oVisualizer := HbQtVisualizer():new():create( oDa )
      :oSplitter:hbSetSizes( { 0, :oSplitter:width(), 0 } )
   ENDWITH

   oWnd:show()

   QApplication():exec()

   HB_SYMBOL_UNUSED( oRect + oVisualizer )
   RETURN NIL

