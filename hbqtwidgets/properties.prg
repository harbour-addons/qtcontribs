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
 *                    Harbour HbQtPropertySheet Class
 *
 *                             Pritpal Bedi
 *                              12Oct2014
 */
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


#define __HBQT_PRP_JUST__                         1000
#define __HBQT_PRP_EDIT__                         1001
#define __HBQT_PRP_COMBO__                        1002
#define __HBQT_PRP_COLOR__                        1003
#define __HBQT_PRP_FONT__                         1004


CLASS HbQtPropertiesManager

   DATA   oWidget
   DATA   oParent
   DATA   oLayout
   DATA   oPropertyWidget

   DATA   hSheets                                 INIT {=>}

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD destroy()                               VIRTUAL

   METHOD propertySheet( cSheet )
   METHOD addPropertySheet( cSheet, oHbQtPropertySheet )
   METHOD setCurrentPropertySheet( cSheet )
   METHOD setPropertySheetProperty( cSheet, cProperty, xValue )
   METHOD setPropertySheetProperties( cSheet, hProperties )

   ENDCLASS


METHOD HbQtPropertiesManager:init( oParent )
   DEFAULT oParent  TO ::oParent
   ::oParent := oParent
   hb_HKeepOrder( ::hSheets, .T. )
   hb_HCaseMatch( ::hSheets, .F. )
   RETURN Self


METHOD HbQtPropertiesManager:create( oParent )
   LOCAL oVLay, oHLay

   DEFAULT oParent  TO ::oParent
   ::oParent := oParent

   ::oWidget := QWidget()
   WITH OBJECT oVLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   ::oWidget:setLayout( oVLay )

   WITH OBJECT oHLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   oVLay:addLayout( oHLay )

   ::oPropertyWidget := QStackedWidget()
   oVLay:addWidget( ::oPropertyWidget )

   IF __objDerivedFrom( ::oParent, "QVBOXLAYOUT" )
      ::oLayout := ::oParent
   ELSEIF __objDerivedFrom( ::oParent, "QHBOXLAYOUT" )
      ::oLayout := ::oParent
   ELSE
      IF Empty( ::oLayout := ::oParent:layout() )
         WITH OBJECT ::oLayout := QVBoxLayout()
            :setContentsMargins( 0,0,0,0 )
            :setSpacing( 0 )
         ENDWITH
         ::oParent:setLayout( ::oLayout )
      ENDIF
   ENDIF
   IF ! Empty( ::oLayout )
      ::oLayout:addWidget( ::oWidget )
   ENDIF
   RETURN Self


METHOD HbQtPropertiesManager:addPropertySheet( cSheet, oHbQtPropertySheet )
   LOCAL oWidget, oLay

   DEFAULT oHbQtPropertySheet TO HbQtPropertySheet():new():create( cSheet )

   WITH OBJECT oLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT oWidget := QWidget()
      :setObjectName( cSheet )
      :setLayout( oLay )
   ENDWITH
   oLay:addWidget( oHbQtPropertySheet:oWidget )

   ::oPropertyWidget:addWidget( oWidget )
   ::hSheets[ cSheet ] := oHbQtPropertySheet

   RETURN oHbQtPropertySheet


METHOD HbQtPropertiesManager:propertySheet( cSheet )
   IF hb_HHasKey( ::hSheets, cSheet )
      RETURN ::hSheets[ cSheet ]
   ENDIF
   RETURN NIL


METHOD HbQtPropertiesManager:setCurrentPropertySheet( cSheet )
   LOCAL oWidget

   FOR EACH oWidget IN ::oPropertyWidget:count()
      IF Upper( oWidget:objectName() ) == Upper( cSheet )
         ::oPropertyWidget:setCurrentWidget( oWidget )
      ENDIF
   NEXT
   RETURN Self


METHOD HbQtPropertiesManager:setPropertySheetProperty( cSheet, cProperty, xValue )
   IF hb_HHasKey( ::hSheets, cSheet )
      ::hSheets[ cSheet ]:setProperty( cProperty, xValue )
   ENDIF
   RETURN Self


METHOD HbQtPropertiesManager:setPropertySheetProperties( cSheet, hProperties )
   LOCAL xValue, cProperty

   IF hb_HHasKey( ::hSheets, cSheet )
      FOR EACH xValue IN hProperties
         cProperty := xValue:__enumKey()
         ::hSheets[ cSheet ]:setProperty( cProperty, xValue )
      NEXT
   ENDIF
   RETURN Self

//----------------------------------------------------------------------//
//                        CLASS HbQtPropertySheet
//----------------------------------------------------------------------//

CLASS HbQtPropertySheet

   DATA   oWidget
   DATA   cSheet                                  INIT ""
   DATA   cParent
   DATA   hProperties                             INIT {=>}

   METHOD init( cSheet )
   METHOD create( cSheet )
   METHOD destroy()                               VIRTUAL

   METHOD addProperty( cProperty, cParent, nType, xValue, xValues, xAttr )
   METHOD setProperty( cProperty, xValue )
   METHOD editTriggered( oTreeWidgetItem )
   ENDCLASS


METHOD HbQtPropertySheet:init( cSheet )
   hb_HKeepOrder( ::hProperties, .T. )
   hb_HCaseMatch( ::hProperties, .F. )

   DEFAULT cSheet TO ::cSheet
   ::cSheet := cSheet
   RETURN Self


METHOD HbQtPropertySheet:create( cSheet )
   LOCAL oListLabels

   DEFAULT cSheet TO ::cSheet
   ::cSheet := cSheet

   WITH OBJECT oListLabels := QStringList()
      :append( "  Property" )
      :append( "  Value" )
   ENDWITH
   WITH OBJECT ::oWidget := QTreeWidget()
      :setColumnCount( 2 )
      :setHeaderLabels( oListLabels )
      :setAlternatingRowColors( .T. )
      :setIndentation( 15 )
      :setEditTriggers( QAbstractItemView_NoEditTriggers )
      :setSelectionMode( QAbstractItemView_NoSelection )
      :setFocusPolicy( Qt_NoFocus )
      //:connect( "itemClicked(QTreeWidgetItem*,int)", {|oItem,nColumn| iif( nColumn == 1, ::editTriggered( oItem ), NIL ) } )
   ENDWITH
   //QScroller():scroller( ::oWidget ):grabGesture( ::oWidget, QScroller_LeftMouseButtonGesture )
   RETURN Self


METHOD HbQtPropertySheet:addProperty( cProperty, cParent, nType, xValue, xValues, xAttr )
   LOCAL oHbQtProperty := HbQtProperty():new():create( cProperty, cParent, nType, xValue, xValues, xAttr )

   ::hProperties[ cProperty ] := oHbQtProperty
   IF Empty( cParent ) .OR. ! hb_HHasKey( ::hProperties, cParent )
      ::oWidget:addTopLevelItem( oHbQtProperty:oWidget )
   ELSE
      ::hProperties[ cParent ]:oWidget:addChild( oHbQtProperty:oWidget )
   ENDIF
   ::oWidget:setItemWidget( oHbQtProperty:oWidget, 1, oHbQtProperty:oStack )
   RETURN Self


METHOD HbQtPropertySheet:setProperty( cProperty, xValue )
   IF hb_HHasKey( ::hProperties, cProperty )
      ::hProperties[ cProperty ]:setValue( xValue )
   ENDIF
   RETURN .F.


METHOD HbQtPropertySheet:editTriggered( oTreeWidgetItem )
   LOCAL cProperty := oTreeWidgetItem:text( 0 )

   IF hb_HHasKey( ::hProperties, cProperty )
      ::hProperties[ cProperty ]:editTriggered()
   ENDIF
   RETURN Self

//----------------------------------------------------------------------//
//                        CLASS HbQtProperty
//----------------------------------------------------------------------//

CLASS HbQtProperty

   DATA   oStack
   DATA   oWidget
   DATA   oValueLabel
   DATA   oPropertyWidget
   DATA   oComboWidget

   DATA   cProperty                               INIT ""
   DATA   cParent                                 INIT ""
   DATA   nType                                   INIT 0
   DATA   cValueType                              INIT ""
   DATA   xOrigValue
   DATA   xValue
   DATA   xValues
   DATA   xAttr

   METHOD init( cProperty, cParent, nType, xValue, xValues, xAttr )
   METHOD create( cProperty, cParent, nType, xValue, xValues, xAttr )
   METHOD destroy()                               VIRTUAL
   METHOD propertyWidget()

   DATA   bValueChanged
   METHOD valueChangedBlock( bBlock )             SETGET
   METHOD setValue( xValue )
   METHOD valueChanged( xValue )
   METHOD editTriggered()
   METHOD manageEvent( oKeyEvent, oWidget )

   ENDCLASS


METHOD HbQtProperty:init( cProperty, cParent, nType, xValue, xValues, xAttr )

   DEFAULT cProperty TO ::cProperty
   DEFAULT cParent   TO ::cParent
   DEFAULT nType     TO ::nType
   DEFAULT xValue    TO ::xValue
   DEFAULT xValues   TO ::xValues
   DEFAULT xAttr     TO ::xAttr

   ::cProperty := cProperty
   ::cParent   := cParent
   ::nType     := nType
   ::xValue    := xValue
   ::xValues   := xValues
   ::xAttr     := xAttr

   RETURN Self


METHOD HbQtProperty:create( cProperty, cParent, nType, xValue, xValues, xAttr )
   LOCAL oLay

   DEFAULT cProperty TO ::cProperty
   DEFAULT cParent   TO ::cParent
   DEFAULT nType     TO ::nType
   DEFAULT xValue    TO ::xValue
   DEFAULT xValues   TO ::xValues
   DEFAULT xAttr     TO ::xAttr

   ::cProperty := cProperty
   ::cParent   := cParent
   ::nType     := nType
   ::xValue    := xValue
   ::xValues   := xValues
   ::xAttr     := xAttr

   ::xOrigValue := ::xValue
   ::cValueType := ValType( ::xOrigValue )

   WITH OBJECT oLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT ::oWidget := QTreeWidgetItem()
      :setText( 0, cProperty )
   ENDWITH
   WITH OBJECT ::oValueLabel := QLabel( __xtos( ::xValue ) )
      :setStyleSheet( "border-left: 1px solid black; font-size: " + __hbqtCssPX( 16 ) + "font-weight: bold;" )
      :connect( QEvent_MouseButtonPress, {|oEvent| iif( oEvent:button() == Qt_LeftButton, ::editTriggered(), NIL ) } )
   ENDWITH
   WITH OBJECT ::oPropertyWidget := ::propertyWidget()
   ENDWITH
   WITH OBJECT ::oStack := QStackedWidget()
      :addWidget( ::oValueLabel )
      :addWidget( ::oPropertyWidget )
      :setCurrentIndex( 0 )
   ENDWITH
   HB_SYMBOL_UNUSED( oLay )
   RETURN Self


METHOD HbQtProperty:propertyWidget()
   LOCAL oWidget, xTmp

   SWITCH ::nType
   CASE __HBQT_PRP_EDIT__
      SWITCH ::cValueType
      CASE "C"
         WITH OBJECT oWidget := QLineEdit()
            :setText( __xtos( ::xValue ) )
            :connect( "editingFinished()", {|| ::valueChanged() } )
            :connect( "returnPressed()"  , {|| ::valueChanged(), ::oStack:setCurrentIndex( 0 ) } )
            :connect( QEvent_FocusOut    , {|| ::oStack:setCurrentIndex( 0 ) } )
            :connect( QEvent_KeyRelease  , {|e| ::manageEvent( e, oWidget  ) } )
         ENDWITH
         EXIT
      CASE "N"
         WITH OBJECT oWidget := QLineEdit()
            :setText( __xtos( ::xValue ) )
            :connect( "editingFinished()", {|| ::valueChanged() } )
            :connect( "returnPressed()"  , {|| ::valueChanged(), ::oStack:setCurrentIndex( 0 ) } )
            :connect( QEvent_FocusOut    , {|| ::oStack:setCurrentIndex( 0 ) } )
            :connect( QEvent_KeyRelease  , {|e| ::manageEvent( e, oWidget  ) } )
         ENDWITH
         EXIT
      CASE "D"
         WITH OBJECT oWidget := QDateEdit()
            :setDate( __d2QDate( ::xValue ) )
            :connect( "dateChanged(QDate)", {|oDate| ::valueChanged( oDate ) } )
            :connect( QEvent_FocusOut     , {|| ::oStack:setCurrentIndex( 0 ) } )
            :connect( QEvent_KeyRelease   , {|e| ::manageEvent( e, oWidget  ) } )
         ENDWITH
         EXIT
      CASE "L"
         WITH OBJECT oWidget := QCheckBox()
            :setCheckState( iif( ! ::xValue, Qt_Unchecked, Qt_Checked ) )
            :connect( "stateChanged(int)", {|nState| ::valueChanged( nState ) } )
            :connect( QEvent_FocusOut    , {|| ::oStack:setCurrentIndex( 0 ) } )
         ENDWITH
         EXIT
      ENDSWITCH
      EXIT
   CASE __HBQT_PRP_COMBO__
      WITH OBJECT oWidget := QComboBox()
         IF HB_ISARRAY( ::xValues )
            FOR EACH xTmp IN ::xValues
               :addItem( __xtos( xTmp ) )
            NEXT
         ENDIF
         :connect( "activated(QString)", {|cString| ::valueChanged( cString ), ::oStack:setCurrentIndex( 0 ) } )
         :connect( QEvent_FocusOut     , {|| iif( oWidget:view():isVisible(), NIL, ::oStack:setCurrentIndex( 0 ) ) } )
      ENDWITH
      EXIT
   CASE __HBQT_PRP_COLOR__
      WITH OBJECT oWidget := QPushButton( hb_ntos( ::xValue ) )
         :connect( "clicked()"    , {|| ::valueChanged() } )
         :connect( QEvent_FocusOut, {|| ::oStack:setCurrentIndex( 0 ) } )
      ENDWITH
      EXIT
   CASE __HBQT_PRP_FONT__
      WITH OBJECT oWidget := QPushButton( ::xValue )
         :connect( "clicked()"    , {|| ::valueChanged() } )
         :connect( QEvent_FocusOut, {|| ::oStack:setCurrentIndex( 0 ) } )
      ENDWITH
      EXIT
   OTHERWISE
      WITH OBJECT oWidget := QLabel()
         :connect( QEvent_FocusOut, {|| ::oStack:setCurrentIndex( 0 ) } )
      ENDWITH
   ENDSWITCH
   RETURN oWidget


METHOD HbQtProperty:manageEvent( oKeyEvent, oWidget )
   SWITCH oKeyEvent:key()
   CASE Qt_Key_Return
      ::oApp:postEvent( oWidget, QEvent( QEvent_CloseSoftwareInputPanel ) )
      RETURN .T.
   ENDSWITCH
   RETURN .F.


METHOD HbQtProperty:editTriggered()
   IF HB_ISOBJECT( ::oPropertyWidget )
      ::oStack:setCurrentIndex( 1 )
      ::oPropertyWidget:setFocus()
   ENDIF
   RETURN Self


METHOD HbQtProperty:setValue( xValue )
   ::xValue := xValue
   ::oValueLabel:setText( __xtos( ::xValue ) )
   RETURN .T.


METHOD HbQtProperty:valueChanged( xValue )
   LOCAL zValue

   SWITCH ::nType
   CASE __HBQT_PRP_EDIT__
      SWITCH ::cValueType
      CASE "C" ; zValue := ::oPropertyWidget:text()        ; EXIT
      CASE "N" ; zValue := Val( ::oPropertyWidget:text() ) ; EXIT
      CASE "L" ; zValue := xValue == Qt_Checked            ; EXIT
      CASE "D" ; zValue := __qDate2d( xValue )             ; EXIT
      ENDSWITCH
      EXIT
   CASE __HBQT_PRP_COMBO__
      zValue := ::oPropertyWidget:itemText( xValue )
      EXIT
   CASE __HBQT_PRP_COLOR__
      EXIT
   CASE __HBQT_PRP_FONT__
      EXIT
   ENDSWITCH
   ::setValue( zValue )
   IF HB_ISBLOCK( ::valueChangedBlock() )
      Eval( ::valueChangedBlock(), zValue )
   ENDIF
   RETURN Self


METHOD HbQtProperty:valueChangedBlock( bBlock )
   LOCAL bOldBlock := ::bValueChanged
   IF HB_ISBLOCK( bBlock )
      ::bValueChanged := bBlock
   ENDIF
   RETURN bOldBlock


STATIC FUNCTION __xtos( xValue )
   SWITCH ValType( xValue )
   CASE "C" ; RETURN Trim( xValue )
   CASE "N" ; RETURN LTrim( Str( xValue ) )
   CASE "D" ; RETURN DToC( xValue )
   CASE "L" ; RETURN iif( xValue, "Yes", "No" )
   ENDSWITCH
   RETURN ""


STATIC FUNCTION __d2QDate( dDate )
   LOCAL oDate := QDate()
   IF HB_ISDATE( dDate )
      oDate:setDate( Year( dDate ), Month( dDate ), Day( dDate ) )
   ENDIF
   RETURN oDate

STATIC FUNCTION __qDate2d( oDate )
   LOCAL dDate := SToD( StrZero( oDate:year(), 4 ) + StrZero( oDate:month(), 2 ) + StrZero( oDate:day(), 2 ) )
   RETURN dDate

