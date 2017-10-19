 /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2017-2017 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
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


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "hbtrace.ch"
#include "common.ch"
#include "hbclass.ch"


#define __KBD_GENERIC__                           0
#define __KBD_PHONES__                            1
#define __KBD_EMAILS__                            2
#define __KBD_NAMES__                             3
#define __KBD_NUMBERS__                           4
            
                                      
#define DEFAULT_STYLE_BUTTON         "color:white; border: 1px solid #ffffff;"

#define DEFAULT_BACKGROUND_BUTTON    "background-color: #F26722;"
#define DISABLED_BACKGROUND_BUTTON   "background:gray;color:darkgray;"
#define CHANGED_BACKGROUND_BUTTON    "background:lightgray;color:darkred;"

#define DEFAULT_STYLE_NORMAL         "QAbstractButton:enabled{ color:white; background-color: #F26722; border: 1px solid #ffffff; }"                                                  
#define DEFAULT_STYLE_PRESSED        "QAbstractButton:pressed:enabled{ color: white; border: 1px solid black; background-color: lightgray;}"


CLASS HbQtKeyboardWidget
   
   DATA   oUI
   DATA   oUIPhones
   DATA   oWidget 
   DATA   oParent 
   
   DATA   oKBGeneric
   DATA   oKBPhones
   DATA   oKBEmails
   DATA   oKBNames
   DATA   oKBNumbers
   DATA   oFont 
   DATA   oFocusedLineEdit
   DATA   oLineEdit 
   
   DATA   hButtons                                INIT {=>}
   DATA   hButtonsN                               INIT {=>} 
   
   ACCESS widget()                                INLINE ::oWidget
   
   METHOD init( oParent )
   METHOD create( oParent )
   METHOD hide()
   METHOD activate( oLineEdit, nKeyboard, nX, nY )   
   METHOD buildGenericKeyboard()
   METHOD buildPhonesKeyboard()
   METHOD setupButton( oBtn, nQtKey )
   METHOD setupMode( nKeyboardMode )
   METHOD receiveKey( oKeyEvent )
   METHOD setKeyboardFont( oFont )                INLINE iif( HB_ISOBJECT( oFont ), ::oFont := oFont, NIL )
   METHOD refresh()
   
   ENDCLASS 


METHOD HbQtKeyboardWidget:init( oParent )
   DEFAULT oParent TO ::oParent 
   ::oParent := oParent
   
   hb_HKeepOrder( ::hButtons, .T. )
   
   RETURN Self 
   
   
METHOD HbQtKeyboardWidget:create( oParent )
   DEFAULT oParent TO ::oParent 
   ::oParent := oParent
   
   IF ! HB_ISOBJECT( ::oParent )
      ::oParent := __hbqtAppWidget()
   ENDIF

   WITH OBJECT ::oUI := hbqtui_keyboard( ::oParent )
      ::oWidget := :widget()
      :stackedWidget:setCurrentIndex( 0 )
   ENDWITH 

   WITH OBJECT ::oWidget
      //:setStyleSheet( "background-color: rgba( 150,150,150,255 );" )
      :lower()
      :setVisible( .F. )
   ENDWITH
   ::buildGenericKeyboard()
   ::buildPhonesKeyboard()
   RETURN Self 
   
   
METHOD HbQtKeyboardWidget:hide()
   WITH OBJECT ::oWidget
      :lower()
      :hide()  
   ENDWITH 
   IF HB_ISOBJECT( ::oUIPhones )
      WITH OBJECT ::oUIPhones:oWidget
         :lower()
         :hide()  
      ENDWITH 
   ENDIF
   RETURN NIL 
   
   
// oLineEdit:connect( QEvent_FocusInEvent, {|| ::oKeyboard:activate( oLineEdit ) } )
//
METHOD HbQtKeyboardWidget:activate( oLineEdit, nKeyboard, nX, nY )   
   
   ::hide()
         
   DEFAULT nKeyboard TO __KBD_GENERIC__
   
   ::setupMode( nKeyboard )
   
   ::oFocusedLineEdit := oLineEdit
   
   SWITCH nKeyboard
   CASE __KBD_PHONES__
      ::oLineEdit := ::oUIPhones:lineEdit 
      //
      WITH OBJECT ::oUIPhones:oWidget
         :raise()
         :show() 
         IF HB_ISNUMERIC( nX )
            IF nX < 0
               nX := ::oParent:width() + nX - :width
            ENDIF
         ELSE 
            nX := ( ::oParent:width() - :width ) / 2            
         ENDIF
         IF HB_ISNUMERIC( nY )
            IF nY < 0
               nY := ::oParent:height() + nY - :height 
            ENDIF
         ELSE 
            nY := 120
         ENDIF 
         :move( nX, nY )   
      ENDWITH
      EXIT
   OTHERWISE 
      ::oLineEdit := ::oUI:lineEdit 
      //
      WITH OBJECT ::oWidget
         :raise()
         :show()  
         IF HB_ISNUMERIC( nX )
            IF nX < 0
               nX := ::oParent:width() + nX - :width
            ENDIF
         ELSE 
            nX := ( ::oParent:width() - :width ) / 2            
         ENDIF
         IF HB_ISNUMERIC( nY )
            IF nY < 0
               nY := ::oParent:height() + nY - :height 
            ENDIF
         ELSE 
            nY := 70
         ENDIF 
         :move( nX, nY )   
      ENDWITH
      ::oUI:stackedWidget:setCurrentIndex( /*nKeyboard*/ __KBD_GENERIC__ )
      EXIT
   ENDSWITCH
   //
   WITH OBJECT ::oLineEdit
      :setText( ::oFocusedLineEdit:text() )
      :setEchoMode( ::oFocusedLineEdit:echoMode() )
   ENDWITH 
   RETURN NIL 
   
   
METHOD HbQtKeyboardWidget:receiveKey( oKeyEvent )
   //LOCAL oEvent 
   
   IF HB_ISOBJECT( oKeyEvent ) .AND. HB_ISOBJECT( ::oFocusedLineEdit )
      QApplication():sendEvent( ::oFocusedLineEdit, oKeyEvent )
   ENDIF
   ::oWidget:parent():setFocus( Qt_TabFocusReason )
   ::refresh() 

   RETURN NIL 
   
   
METHOD HbQtKeyboardWidget:refresh()
   QApplication():processEvents()
   ::oLineEdit:setText( ::oFocusedLineEdit:text() )
   RETURN NIL  


STATIC FUNCTION __setEnabled( oBtn, lEnable ) 
  
   oBtn:setEnabled( lEnable )
   oBtn:setStyleSheet( "" )
   IF lEnable
      oBtn:setStyleSheet( DEFAULT_STYLE_NORMAL + DEFAULT_STYLE_PRESSED )
   ELSE 
      oBtn:setStyleSheet( DEFAULT_STYLE_BUTTON + DISABLED_BACKGROUND_BUTTON ) 
   ENDIF
   RETURN NIL

   
METHOD HbQtKeyboardWidget:setupButton( oBtn, nQtKey )
   STATIC nIndex := 200000
   oBtn:setMinimumWidth( 60 )
   IF HB_ISOBJECT( ::oFont )
      oBtn:setFont( ::oFont )
   ENDIF
   RETURN ::hButtons[ iif( HB_ISNUMERIC( nQtKey ), nQtKey, ++nIndex ) ] := HbQtKeyboardButton():new():create( Self, oBtn, nQtKey )


METHOD HbQtKeyboardWidget:buildPhonesKeyboard()
   LOCAL bEnter, oUI
   
   ::oUIPhones := hbqtui_keyboardn( ::oParent )
   oUI := ::oUIPhones

   oUI:btnBS:connect( "clicked()", {|| QApplication():sendEvent( ::oFocusedLineEdit, ;
                                       QKeyEvent( QEvent_KeyPress, Qt_Key_Backspace, Qt_NoModifier ) ), ::refresh()  } )
   bENTER := {||  
               ::hide()
               oUi:oWidget:parent():setFocus( Qt_TabFocusReason )
               QApplication():sendEvent( ::oFocusedLineEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Enter, Qt_NoModifier ) )
               RETURN NIL 
             }
   ::setupButton( oUI:btnEnter, bENTER )
   
   oUI:pushClear:connect( "clicked()", {|| ::oFocusedLineEdit:clear(), ::refresh() } )
   
   
   ::setupButton( oUI:btn0, Qt_Key_0 )
   ::setupButton( oUI:btn1, Qt_Key_1 )
   ::setupButton( oUI:btn2, Qt_Key_2 )
   ::setupButton( oUI:btn3, Qt_Key_3 )
   ::setupButton( oUI:btn4, Qt_Key_4 )
   ::setupButton( oUI:btn5, Qt_Key_5 )
   ::setupButton( oUI:btn6, Qt_Key_6 )
   ::setupButton( oUI:btn7, Qt_Key_7 )
   ::setupButton( oUI:btn8, Qt_Key_8 )
   ::setupButton( oUI:btn9, Qt_Key_9 )
   
   RETURN NIL 
   
   
METHOD HbQtKeyboardWidget:buildGenericKeyboard()
   LOCAL bENTER 
   
   bENTER := {||  
               ::hide()
               ::oWidget:parent():setFocus( Qt_TabFocusReason )
               QApplication():sendEvent( ::oFocusedLineEdit, QKeyEvent( QEvent_KeyPress, Qt_Key_Enter, Qt_NoModifier ) )
               RETURN NIL 
             }
   ::setupButton( ::oUI:btnEnter, bENTER )
   
   ::oUI:btnBS:connect( "clicked()", {|| QApplication():sendEvent( ::oFocusedLineEdit, ;
                                         QKeyEvent( QEvent_KeyPress, Qt_Key_Backspace, Qt_NoModifier ) ), ::refresh() } )
   ::oUI:btnClear:connect( "clicked()", {|| ::oFocusedLineEdit:clear(), ::refresh() } )
   
   ::setupButton( ::oUI:btn0, Qt_Key_0 )
   ::setupButton( ::oUI:btn1, Qt_Key_1 )
   ::setupButton( ::oUI:btn2, Qt_Key_2 )
   ::setupButton( ::oUI:btn3, Qt_Key_3 )
   ::setupButton( ::oUI:btn4, Qt_Key_4 )
   ::setupButton( ::oUI:btn5, Qt_Key_5 )
   ::setupButton( ::oUI:btn6, Qt_Key_6 )
   ::setupButton( ::oUI:btn7, Qt_Key_7 )
   ::setupButton( ::oUI:btn8, Qt_Key_8 )
   ::setupButton( ::oUI:btn9, Qt_Key_9 )
   
   ::setupButton( ::oUI:btnA, Qt_Key_A )
   ::setupButton( ::oUI:btnB, Qt_Key_B )
   ::setupButton( ::oUI:btnC, Qt_Key_C )
   ::setupButton( ::oUI:btnD, Qt_Key_D )
   ::setupButton( ::oUI:btnE, Qt_Key_E )
   ::setupButton( ::oUI:btnF, Qt_Key_F )
   ::setupButton( ::oUI:btnG, Qt_Key_G )
   ::setupButton( ::oUI:btnH, Qt_Key_H )
   ::setupButton( ::oUI:btnI, Qt_Key_I )
   ::setupButton( ::oUI:btnJ, Qt_Key_J )
   ::setupButton( ::oUI:btnK, Qt_Key_K )
   ::setupButton( ::oUI:btnL, Qt_Key_L )
   ::setupButton( ::oUI:btnM, Qt_Key_M )
   ::setupButton( ::oUI:btnN, Qt_Key_N )
   ::setupButton( ::oUI:btnO, Qt_Key_O )
   ::setupButton( ::oUI:btnP, Qt_Key_P )
   ::setupButton( ::oUI:btnQ, Qt_Key_Q )
   ::setupButton( ::oUI:btnR, Qt_Key_R )
   ::setupButton( ::oUI:btnS, Qt_Key_S )
   ::setupButton( ::oUI:btnT, Qt_Key_T )
   ::setupButton( ::oUI:btnU, Qt_Key_U )
   ::setupButton( ::oUI:btnV, Qt_Key_V )
   ::setupButton( ::oUI:btnW, Qt_Key_W )
   ::setupButton( ::oUI:btnX, Qt_Key_X )
   ::setupButton( ::oUI:btnY, Qt_Key_Y )
   ::setupButton( ::oUI:btnZ, Qt_Key_Z )
   
   ::setupButton( ::oUI:btnPOINT, Qt_Key_Period )
   ::setupButton( ::oUI:btnDASH, Qt_Key_Minus )
   ::setupButton( ::oUI:btnAT, Qt_Key_At )
   ::setupButton( ::oUI:btnUSCORE, 95 )
   //::setupButton( ::oUI:btnBS, Qt_Key_Backspace )
   ::setupButton( ::oUI:btnSPACE, Qt_Key_Space )
   
   RETURN NIL 


METHOD HbQtKeyboardWidget:setupMode( nKeyboardMode )

   __setEnabled( ::oUI:btn0, .T. )
   __setEnabled( ::oUI:btn1, .T. )
   __setEnabled( ::oUI:btn2, .T. )
   __setEnabled( ::oUI:btn3, .T. )
   __setEnabled( ::oUI:btn4, .T. )
   __setEnabled( ::oUI:btn5, .T. )
   __setEnabled( ::oUI:btn6, .T. )
   __setEnabled( ::oUI:btn7, .T. )
   __setEnabled( ::oUI:btn8, .T. )
   __setEnabled( ::oUI:btn9, .T. )
   
   __setEnabled( ::oUI:btnA, .T. )
   __setEnabled( ::oUI:btnB, .T. )
   __setEnabled( ::oUI:btnC, .T. )
   __setEnabled( ::oUI:btnD, .T. )
   __setEnabled( ::oUI:btnE, .T. )
   __setEnabled( ::oUI:btnF, .T. )
   __setEnabled( ::oUI:btnG, .T. )
   __setEnabled( ::oUI:btnH, .T. )
   __setEnabled( ::oUI:btnI, .T. )
   __setEnabled( ::oUI:btnJ, .T. )
   __setEnabled( ::oUI:btnK, .T. )
   __setEnabled( ::oUI:btnL, .T. )
   __setEnabled( ::oUI:btnM, .T. )
   __setEnabled( ::oUI:btnN, .T. )
   __setEnabled( ::oUI:btnO, .T. )
   __setEnabled( ::oUI:btnP, .T. )
   __setEnabled( ::oUI:btnQ, .T. )
   __setEnabled( ::oUI:btnR, .T. )
   __setEnabled( ::oUI:btnS, .T. )
   __setEnabled( ::oUI:btnT, .T. )
   __setEnabled( ::oUI:btnU, .T. )
   __setEnabled( ::oUI:btnV, .T. )
   __setEnabled( ::oUI:btnW, .T. )
   __setEnabled( ::oUI:btnX, .T. )
   __setEnabled( ::oUI:btnY, .T. )
   __setEnabled( ::oUI:btnZ, .T. )
   
   __setEnabled( ::oUI:btnAT, .T. )
   __setEnabled( ::oUI:btnUSCORE, .T. )
   __setEnabled( ::oUI:btnPOINT, .T. )
   __setEnabled( ::oUI:btnDASH, .T. )
   __setEnabled( ::oUI:btnSPACE, .T. )
   
   SWITCH nKeyboardMode
   CASE __KBD_PHONES__
      __setEnabled( ::oUI:btnA, .F. )
      __setEnabled( ::oUI:btnB, .F. )
      __setEnabled( ::oUI:btnC, .F. )
      __setEnabled( ::oUI:btnD, .F. )
      __setEnabled( ::oUI:btnE, .F. )
      __setEnabled( ::oUI:btnF, .F. )
      __setEnabled( ::oUI:btnG, .F. )
      __setEnabled( ::oUI:btnH, .F. )
      __setEnabled( ::oUI:btnI, .F. )
      __setEnabled( ::oUI:btnJ, .F. )
      __setEnabled( ::oUI:btnK, .F. )
      __setEnabled( ::oUI:btnL, .F. )
      __setEnabled( ::oUI:btnM, .F. )
      __setEnabled( ::oUI:btnN, .F. )
      __setEnabled( ::oUI:btnO, .F. )
      __setEnabled( ::oUI:btnP, .F. )
      __setEnabled( ::oUI:btnQ, .F. )
      __setEnabled( ::oUI:btnR, .F. )
      __setEnabled( ::oUI:btnS, .F. )
      __setEnabled( ::oUI:btnT, .F. )
      __setEnabled( ::oUI:btnU, .F. )
      __setEnabled( ::oUI:btnV, .F. )
      __setEnabled( ::oUI:btnW, .F. )
      __setEnabled( ::oUI:btnX, .F. )
      __setEnabled( ::oUI:btnY, .F. )
      __setEnabled( ::oUI:btnZ, .F. )
         
      __setEnabled( ::oUI:btnAT, .F. )
      __setEnabled( ::oUI:btnUSCORE, .F. )
      __setEnabled( ::oUI:btnPOINT, .F. )
      __setEnabled( ::oUI:btnDASH, .F. )
      __setEnabled( ::oUI:btnSPACE, .F. )
      EXIT
   CASE __KBD_EMAILS__
      __setEnabled( ::oUI:btnSPACE, .F. )
      EXIT 
   CASE __KBD_NAMES__
      __setEnabled( ::oUI:btnAT, .F. )
      __setEnabled( ::oUI:btnUSCORE, .F. )
      //__setEnabled( ::oUI:btnPOINT, .F. )
      //__setEnabled( ::oUI:btnDASH, .F. )
      EXIT
   CASE __KBD_NUMBERS__
      ::setupMode( __KBD_PHONES__ )
      __setEnabled( ::oUI:btnPOINT, .T. )
      __setEnabled( ::oUI:btnDASH, .T. )
      EXIT 
   ENDSWITCH
   RETURN NIL 

//--------------------------------------------------------------------//
//                  Helper CLASS HbQtKeyboardButton
//--------------------------------------------------------------------//

CLASS HbQtKeyboardButton

   DATA   oWidget 
   DATA   oKeyboard 
   DATA   oPlayer
   DATA   nQtKey                                  INIT 0
   DATA   oBtn 
   
   METHOD init( oKeyboard, oBtn, nQtKey )
   METHOD create( oKeyboard, oBtn, nQtKey )
   
   METHOD manageKey()
   
   ENDCLASS 
   

METHOD HbQtKeyboardButton:init( oKeyboard, oBtn, nQtKey )

   DEFAULT oKeyboard TO ::oKeyboard 
   DEFAULT oBtn TO ::oBtn 
   DEFAULT nQtKey TO ::nQtKey
    
   ::oKeyboard := oKeyboard
   ::oBtn := oBtn
   ::nQtKey := nQtKey
   
   RETURN Self 
   
   
METHOD HbQtKeyboardButton:create( oKeyboard, oBtn, nQtKey )

   DEFAULT oKeyboard TO ::oKeyboard 
   DEFAULT oBtn TO ::oBtn 
   DEFAULT nQtKey TO ::nQtKey
    
   ::oKeyboard := oKeyboard
   ::oBtn := oBtn
   ::nQtKey := nQtKey
   
   WITH OBJECT ::oWidget := ::oBtn
      :setStyleSheet( DEFAULT_STYLE_NORMAL + DEFAULT_STYLE_PRESSED )
      :connect( "clicked()", {|| ::manageKey() } )
   ENDWITH
   RETURN Self 
   
   
METHOD HbQtKeyboardButton:manageKey()
   LOCAL oKeyEvent

   IF HB_ISBLOCK( ::nQtKey )
      Eval( ::nQtKey )
   ELSEIF ::nQtKey >= Qt_Key_0 .AND. ::nQtKey <= Qt_Key_9
      oKeyEvent := QKeyEvent( QEvent_KeyPress, ::nQtKey, Qt_NoModifier, Chr( ::nQtKey ) )
   ELSEIF ::nQtKey >= Qt_Key_A .AND. ::nQtKey <= Qt_Key_Z
      oKeyEvent := QKeyEvent( QEvent_KeyPress, ::nQtKey, Qt_ShiftModifier, Upper( Chr( ::nQtKey ) ) )
   ELSE    
      oKeyEvent := QKeyEvent( QEvent_KeyPress, ::nQtKey, Qt_NoModifier, Chr( ::nQtKey ) )
   ENDIF
   RETURN ::oKeyboard:receiveKey( oKeyEvent )   
   
