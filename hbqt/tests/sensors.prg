/*
 * $Id$
 */

/*
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbclass.ch"
#include "hbqtgui.ch"


FUNCTION Main()
   LOCAL oGesture

   oGesture := Gestures():new():create()
   oGesture:destroy()

   RETURN NIL


CLASS Gestures

   DATA   oUI
   DATA   recognizerMap                           INIT {=>}

   METHOD new()
   METHOD create()
   METHOD destroy()
   METHOD onShake()
   METHOD detectedShake( cName )
   METHOD on_pushButton_clicked()
   METHOD on_startPushButton_clicked()
   METHOD on_stopPushButton_clicked()

   ENDCLASS


METHOD Gestures:new()
   RETURN Self


METHOD Gestures:destroy()
   ::oUI:destroy()
   RETURN Self


METHOD Gestures:create()
   LOCAL i, j, Gesture, gestureId, recognizerSignals, oneSignal, oSensorGesMgr, oGesIds

   ::oUI := hbqtui_sensors()

   ::oUI:treeWidget:setHeaderLabel( "Available Sensors" )

   ::oUI:startPushButton:connect( "clicked()", {|| ::on_startPushButton_Clicked() } )
   ::oUI:stopPushButton :connect( "clicked()", {|| ::on_stopPushButton_Clicked()  } )
   ::oUI:pushButton     :connect( "clicked()", {|| ::on_pushButton_clicked()      } )

   oSensorGesMgr := QSensorGestureManager()
   oGesIds := oSensorGesMgr:gestureIds()

   FOR i := 0 TO oGesIds:size()-1
      gesture := oGesIds:at( i )
      gestureId := QTreeWidgetItem( ::oUI:treeWidget )
      gestureId:setText( 0, gesture )
      recognizerSignals := oSensorGesMgr:recognizerSignals( gesture )
      FOR j := 0 TO recognizerSignals:size()-1
         oneSignal := QTreeWidgetItem()
         oneSignal:setText( 0, recognizerSignals:at( j ) )
         gestureId:addChild( oneSignal )
      NEXT
      ::oUI:treeWidget:insertTopLevelItem( 0, gestureId )
   NEXT

   ::oUI:textEdit:setReadOnly( .T. )

   ::oUI:oWidget:show()
   QApplication():exec()

   RETURN Self


METHOD Gestures:on_startPushButton_clicked()
   LOCAL currentRecognizer, thisGesture, cStr

   IF Empty( ::oUI:treeWidget:currentItem() )
      RETURN Self
   ENDIF

   IF ::oUI:treeWidget:currentItem():childCount() == 0
      currentRecognizer := ::oUI:treeWidget:currentItem():parent():text( 0 )
   ELSE
      currentRecognizer := ::oUI:treeWidget:currentItem():text( 0 )
   ENDIF

   IF hb_HHasKey( ::recognizerMap, currentRecognizer )
      RETURN self
   ENDIF

   thisGesture := QSensorGesture( QStringList( currentRecognizer ), ::oUI:oWidget )

   IF "QtSensors.shake" $ currentRecognizer
      thisGesture:connect( "shake()", {|| ::onShake() } )
   ENDIF
   thisGesture:connect( "detected(QString)", {|str| ::detectedShake( str ) } )
   thisGesture:startDetection()

   ::recognizerMap[ currentRecognizer ] := thisGesture

   cStr := "<font size=+2><B>Started " + currentRecognizer + "</b></font><br>"
   ::oUI:textEdit:insertHtml( cStr )
   ::oUI:textEdit:ensureCursorVisible()

   RETURN Self


METHOD Gestures:on_stopPushButton_clicked()
   LOCAL currentRecognizer, cStr

   IF Empty( ::oUI:treeWidget:currentItem() )
      RETURN self
   ENDIF

   IF ::oUI:treeWidget:currentItem():childCount() == 0
      currentRecognizer = ::oUI:treeWidget:currentItem():parent():text(0)
   ELSE
      currentRecognizer = ::oUI:treeWidget:currentItem():text(0)
   ENDIF

   IF ! hb_HHasKey( ::recognizerMap, currentRecognizer )
      RETURN self
   ENDIF

   ::recognizerMap[ currentRecognizer ]:stopDetection()

   IF currentRecognizer == "QtSensors.shake"
      ::recognizerMap[ currentRecognizer ]:disconnect( "shake()" )
   ENDIF
   ::recognizerMap[ currentRecognizer ]:disconnect( "detected(QString)" )

   hb_HDel( ::recognizerMap, currentRecognizer )

   cStr := "<font size=+2><B>Stopped " + currentRecognizer + "</b></font><br>"
   ::oUI:textEdit:insertHtml( cStr )
   ::oUI:textEdit:ensureCursorVisible()

   RETURN Self


METHOD Gestures:on_pushButton_clicked()
   ::oUI:textEdit:clear()
   RETURN Self


METHOD Gestures:detectedShake( cName )
   LOCAL cStr := "<font size=+2><B>detectedShake . " + cName + "</b></font><br>"
   ::oUi:textEdit:insertHtml( cStr )
   ::oUi:textEdit:ensureCursorVisible()
   RETURN Self


METHOD Gestures:onShake()
   LOCAL cStr := "<font size=+2><B>onShake()</b></font><br>"
   ::oUi:textEdit:insertHtml( cStr )
   ::oUi:textEdit:ensureCursorVisible()
   RETURN Self

