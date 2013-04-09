/*
 * $$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2013 Luigi Ferraris <luigferraris at gmail.com>
 * www - http://harbour-project.org
 *
 *
 * This sample demonstrates usage of settings to use Drag And Drop.
 * Follow official QT documents to better understand
 * http://qt-project.org/doc/qt-4.8/dnd.html
 *
 * This sample uses two QTableWidget as container, but different
 * QT objects can be used: QTreeWidget, QListWidget, ...
 *
 * This is a very simple sample: play with different settings and
 * look what happens.
 *
 * Enjoy with qtconribs!
 *
 */


#include "hbqtgui.ch"


MEMVAR oQtApp


/*
   standard main function
*/
PROCEDURE Main( ... )

   PUBLIC oQtApp := QApplication()

   hbqt_errorsys()

   ShowMainForm()

   oQtApp:exit()
   oQtApp:quit()

   RETURN


/*
   show mainwindow
*/
PROCEDURE ShowMainForm()

   LOCAL oWnd

   WITH OBJECT oWnd := QMainWindow()
      :resize(600,50)
      :setWindowTitle( "QTableWidget Drag & Drop examples" )
      WITH OBJECT QPushButton( oWnd )
         :resize(200,30)
         :move(60,10)
         :setText( "&COPYaction" )
         :connect( "clicked()", {|| CopyAction( oWnd ) } )
      END WITH
      WITH OBJECT QPushButton( oWnd )
         :resize(200,30)
         :move(320,10)
         :setText( "&MOVEaction" )
         :connect( "clicked()", {|| MoveAction( oWnd ) } )
      END WITH
   END WITH

   oWnd:show()
   oQtApp:exec()

   RETURN


/*
   COPYAction example
*/
STATIC PROCEDURE CopyAction( oParent )

   LOCAL oWnd
   LOCAL nRow
   LOCAL nCol
   LOCAL oItem

   WITH OBJECT oWnd := QMainWindow( oParent )
      :setWindowModality( Qt_ApplicationModal )
      :setAttribute( Qt_WA_DeleteOnClose, .T. )
      :resize(600,600)
      :setWindowTitle( "QTableWidget COPYAction example" )

      WITH OBJECT QLabel( oWnd )
         :resize(100,30)
         :move(85,10)
         :setText( "SOURCE" )
      END WITH
      WITH OBJECT QLabel( oWnd )
         :resize(100,30)
         :move(415,10)
         :setText( "TARGET" )
      END WITH

      WITH OBJECT QTableWidget( oWnd )
         :resize(250,200)
         :move(10,50)
         :setObjectName( "SOURCE" )
         :setEditTriggers( QAbstractItemView_NoEditTriggers )        // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#editTriggers-prop
         :setSelectionBehavior( QAbstractItemView_SelectRows )       // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#selectionBehavior-prop
         :setSelectionMode( QAbstractItemView_ExtendedSelection )    // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#selectionMode-prop
         :setAlternatingRowColors( .T. )
         :connect( "cellActivated(int,int)", {|nRow,nCol| QcellActivated( nRow, nCol ) } )   // trick to keep object alive
         // to perform Drag&Drop
         :viewport:setAcceptDrops(.F.)                               // http://qt-project.org/doc/qt-4.8/qabstractscrollarea.html#viewport
                                                                     // http://qt-project.org/doc/qt-4.8/qwidget.html#acceptDrops-prop
         :setDragEnabled( .T. )                                      // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragEnabled-prop
         :setDropIndicatorShown(.T.)                                 // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#showDropIndicator-prop
         :setDragDropMode( QAbstractItemView_DragOnly )              // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragDropMode-prop
         //by default is         :setDefaultDropAction( Qt_CopyAction )                      // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#defaultDropAction-prop
         :setDragDropOverwriteMode( .F. )                            // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragDropOverwriteMode-prop

         :setColumnCount( 2 )
         FOR nRow := 1 TO 3
            :insertRow( nRow-1 )
            FOR nCol := 1 TO 2
               oItem := QTableWidgetItem( "cellText" + hb_Ntos(nRow) + "." + hb_Ntos(nCol ) )
               :setItem( nRow-1, nCol-1, oItem )
            NEXT nCol
         NEXT nRow
      END WITH

      WITH OBJECT QTableWidget( oWnd )
         :resize(250,200)
         :move(340,50)
         :setObjectName( "TARGET" )
         :setEditTriggers( QAbstractItemView_NoEditTriggers )
         :setSelectionBehavior( QAbstractItemView_SelectRows )
         :setSelectionMode( QAbstractItemView_ExtendedSelection )
         :setAlternatingRowColors( .T. )
         :setColumnCount( 2 )
         :connect( "cellActivated(int,int)", {|nRow,nCol| QcellActivated( nRow, nCol ) } )   // trick to keep object alive
         // to perform Drag&Drop
         :viewport:setAcceptDrops(.T.)
         :setDragEnabled( .T. )
         :setDropIndicatorShown(.T.)
         :setDragDropMode( QAbstractItemView_DropOnly )
          //by default is         :setDefaultDropAction( Qt_CopyAction )                      // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#defaultDropAction-prop
         :setDragDropOverwriteMode( .F. )
      END WITH

      WITH OBJECT QPushButton( oWnd )
         :resize(250,30)
         :move(10,300)
         :setText( "&SOURCE row number" )
         :connect( "clicked()", {|| udf_howManyRowOnSource( oWnd ) } )
      END WITH

      WITH OBJECT QPushButton( oWnd )
         :resize(250,30)
         :move(340,300)
         :setText( "&TARGET row number" )
         :connect( "clicked()", {|| udf_howManyRowOnTarget( oWnd ) } )
      END WITH

      WITH OBJECT QLabel( oWnd )
         :resize(500,30)
         :move(10,360)
         :setText( "You can only Drag&Drop from Left to Right. Play with settings for different solutions" )
      END WITH
   END WITH

   oWnd:show()

   RETURN


/*
   MOVEAction example
*/
STATIC PROCEDURE MoveAction( oParent )

   LOCAL oWnd
   LOCAL nRow
   LOCAL nCol
   LOCAL oItem

   WITH OBJECT oWnd := QMainWindow( oParent )
      :setWindowModality( Qt_ApplicationModal )
      :setAttribute( Qt_WA_DeleteOnClose, .T. )
      :resize(600,600)
      :setWindowTitle( "QTableWidget COPYAction example" )
      WITH OBJECT QLabel( oWnd )
         :resize(100,30)
         :move(85,10)
         :setText( "SOURCE" )
      END WITH

      WITH OBJECT QLabel( oWnd )
         :resize(100,30)
         :move(415,10)
         :setText( "TARGET" )
      END WITH

      WITH OBJECT QTableWidget( oWnd )
         :resize(250,200)
         :move(10,50)
         :setObjectName( "SOURCE" )
         :setEditTriggers( QAbstractItemView_NoEditTriggers )        // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#editTriggers-prop
         :setSelectionBehavior( QAbstractItemView_SelectRows )       // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#selectionBehavior-prop
         :setSelectionMode( QAbstractItemView_ExtendedSelection )    // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#selectionMode-prop
         :setAlternatingRowColors( .T. )
         :connect( "cellActivated(int,int)", {|nRow,nCol| QcellActivated( nRow, nCol ) } )   // trick to keep object alive
         // to perform Drag&Drop
         :viewport:setAcceptDrops(.F.)                               // http://qt-project.org/doc/qt-4.8/qabstractscrollarea.html#viewport
                                                                     // http://qt-project.org/doc/qt-4.8/qwidget.html#acceptDrops-prop
         :setDragEnabled( .T. )                                      // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragEnabled-prop
         :setDropIndicatorShown(.T.)                                 // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#showDropIndicator-prop
         :setDragDropMode( QAbstractItemView_DragOnly )              // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragDropMode-prop
         :setDefaultDropAction( Qt_MoveAction )                      // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#defaultDropAction-prop
         :setDragDropOverwriteMode( .F. )                            // http://qt-project.org/doc/qt-4.8/qabstractitemview.html#dragDropOverwriteMode-prop

         :setColumnCount( 2 )
         FOR nRow := 1 TO 3
            :insertRow( nRow-1 )
            FOR nCol := 1 TO 2
               oItem := QTableWidgetItem( "cellText" + hb_Ntos(nRow) + "." + hb_Ntos(nCol ) )
               :setItem( nRow-1, nCol-1, oItem )
            NEXT nCol
         NEXT nRow
      END WITH

      WITH OBJECT QTableWidget( oWnd )
         :resize(250,200)
         :move(340,50)
         :setObjectName( "TARGET" )
         :setEditTriggers( QAbstractItemView_NoEditTriggers )
         :setSelectionBehavior( QAbstractItemView_SelectRows )
         :setSelectionMode( QAbstractItemView_ExtendedSelection )
         :setAlternatingRowColors( .T. )
         :setColumnCount( 2 )
         :connect( "cellActivated(int,int)", {|nRow,nCol| QcellActivated( nRow, nCol ) } )   // trick to keep object alive
         // to perform Drag&Drop
         :viewport:setAcceptDrops(.T.)
         :setDragEnabled( .T. )
         :setDropIndicatorShown(.T.)
         :setDragDropMode( QAbstractItemView_DropOnly )
 	      :setDragDropOverwriteMode( .F. )
      END WITH

      WITH OBJECT QPushButton( oWnd )
         :resize(250,30)
         :move(10,300)
         :setText( "&SOURCE row number" )
         :connect( "clicked()", {|| udf_howManyRowOnSource( oWnd ) } )
      END WITH

      WITH OBJECT QPushButton( oWnd )
         :resize(250,30)
         :move(340,300)
         :setText( "&TARGET row number" )
         :connect( "clicked()", {|| udf_howManyRowOnTarget( oWnd ) } )
      END WITH

      WITH OBJECT QLabel( oWnd )
         :resize(500,30)
         :move(10,360)
         :setText( "You can only Drag&Drop from Left to Right. Play with settings for different solutions" )
      END WITH

   END WITH

   oWnd:show()

   RETURN


STATIC PROCEDURE udf_howManyRowOnSource( oWnd )

   LOCAL oQtObject := oWnd:findChild( "SOURCE" )

   MsgBox( "There are " + hb_Ntos( oQtObject:rowCount() ) + " rows" )

   RETURN


STATIC PROCEDURE udf_howManyRowOnTarget( oWnd )

   LOCAL oQtObject := oWnd:findChild( "TARGET" )

   MsgBox( "There are " + hb_Ntos( oQtObject:rowCount() ) + " rows" )

   RETURN


STATIC FUNCTION QcellActivated( nRow, nCol )
   HB_SYMBOL_UNUSED( nRow )
   HB_SYMBOL_UNUSED( nCol )
   RETURN .F.


STATIC FUNCTION MsgBox( cText )

   LOCAL oQtObject, nReturn

   WITH OBJECT oQtObject := QMessageBox()
      :setWindowTitle( "Simple Message" )
      :setText( cText )
   END WITH

   nReturn := oQtObject:exec()
   oQtObject := NIL

   RETURN nReturn

