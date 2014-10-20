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

   QApplication():setStyleSheet( __styleSheet() )
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
   ENDWITH
   oWnd:setCentralWidget( oDa )

   WITH OBJECT oVisualizer := HbQtVisualizer():new():create( oDa )
      :splitter():hbSetSizes( { 100, :oSplitter:width()-200, 100 } )
   ENDWITH

   oWnd:show()

   QApplication():exec()

   HB_SYMBOL_UNUSED( oRect + oVisualizer )
   RETURN NIL


STATIC FUNCTION __styleSheet()
   LOCAL cCSS := ""
   LOCAL aCSS := {}

   AAdd( aCSS, 'QListWidget{' )
   AAdd( aCSS, '   background-color: lightgray;' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QSplitter{' )
   AAdd( aCSS, '   min-height: '                 + __hbqtCssPX( 10 ) )
   AAdd( aCSS, '   min-width: '                  + __hbqtCssPX( 10 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QSplitter::handle{' )
   AAdd( aCSS, '   background-color: rgb(190,190,190);' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTabBar::tab {' )
   AAdd( aCSS, '    alignment: center;' )
   AAdd( aCSS, '    min-height: '                + __hbqtCssPX( 24 ) )
   AAdd( aCSS, '    font-size: '                 + __hbqtCssPX( 16 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView {' )
   AAdd( aCSS, '    show-decoration-selected: 0;' )
   AAdd( aCSS, '    font-size: '                 + __hbqtCssPX( 16 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QTreeView::item { ' )
   AAdd( aCSS, '    min-height: '                + __hbqtCssPX( 40 ) )
   AAdd( aCSS, '    border-right: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '    border-bottom: 0.5px ; border-style: solid ; border-color: lightgray ;' )
   AAdd( aCSS, '}' )

   AEval( aCSS, {|e| cCSS += e + Chr( 13 ) + Chr( 10 ) } )
   RETURN cCSS



