/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2012-2013 Pritpal Bedi <bedipritpal@hotmail.com>
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


#include "hbqtgui.ch"
#include "inkey.ch"


STATIC FUNCTION hbqt_QTranslateKey( kbm, key, shiftkey, altkey, controlkey )
   LOCAL c

   IF hb_bitAnd( kbm, Qt_AltModifier ) == Qt_AltModifier
      c := altkey
   ELSE
      IF hb_bitAnd( kbm, Qt_ControlModifier ) == Qt_ControlModifier
         c := controlkey
      ELSE
         IF hb_bitAnd( kbm, Qt_ShiftModifier ) == Qt_ShiftModifier
            c := shiftkey
         ELSE
            c := key
         ENDIF
      ENDIF
   ENDIF

   RETURN c

STATIC FUNCTION hbqt_QTranslateKey5( kbm, key, shiftkey, altkey, controlkey, sh_controlkey )
   LOCAL c, lShift, lControl

   IF hb_bitAnd( kbm, Qt_AltModifier ) == Qt_AltModifier
      c := altkey
   ELSE
      lShift   := hb_bitAnd( kbm, Qt_ShiftModifier   ) == Qt_ShiftModifier
      lControl := hb_bitAnd( kbm, Qt_ControlModifier ) == Qt_ControlModifier

      IF lShift .and. lControl
         c := sh_controlkey
      ELSEIF lControl
         c := controlkey
      ELSEIF lShift
         c := shiftkey
      ELSE
         c := key
      ENDIF
   ENDIF

   RETURN c

STATIC FUNCTION hbqt_QTranslateKeyDigit( kbm, key, altkey )
   LOCAL c

   IF hb_bitAnd( kbm, Qt_AltModifier ) == Qt_AltModifier
      c := altkey
   ELSE
      c := key
   ENDIF

   RETURN c

STATIC FUNCTION hbqt_QTranslateKeyAlpha( kbm, key, shiftkey, altkey, controlkey, text )
   LOCAL c

   HB_SYMBOL_UNUSED( key )
   HB_SYMBOL_UNUSED( shiftkey )

   IF hb_bitAnd( kbm, Qt_AltModifier ) == Qt_AltModifier
      c := altkey
   ELSE
      IF hb_bitAnd( kbm, Qt_ControlModifier ) == Qt_ControlModifier
         c := controlkey
      ELSE
         c := ASC( text )
      ENDIF
   ENDIF

   RETURN c

STATIC FUNCTION hbqt_QTranslateKeyKP( kbm, key, shiftkey, altkey, controlkey, keyKP, shiftkeyKP, altkeyKP, controlkeyKP )
   LOCAL c

   IF hb_bitAnd( kbm, Qt_KeypadModifier ) == Qt_KeypadModifier
      key        := keyKP
      shiftkey   := shiftkeyKP
      altkey     := altkeyKP
      controlkey := controlkeyKP
   ENDIF

   IF hb_bitAnd( kbm, Qt_AltModifier ) == Qt_AltModifier
      c := altkey
   ELSE
      IF hb_bitAnd( kbm, Qt_ControlModifier ) == Qt_ControlModifier
         c := controlkey
      ELSE
         IF hb_bitAnd( kbm, Qt_ShiftModifier ) == Qt_ShiftModifier
            c := shiftkey
         ELSE
            c := key
         ENDIF
      ENDIF
   ENDIF

   RETURN c


FUNCTION hbqt_qtEventToHbEvent( oKeyEvent )
   LOCAL c := 0
   LOCAL key, kbm, txt, x

   key := oKeyEvent:key()
   kbm := oKeyEvent:modifiers()
   txt := oKeyEvent:text()

   SWITCH( key )
   CASE Qt_Key_Escape
      c := hbqt_QTranslateKey( kbm, K_ESC, K_ESC, K_ESC, K_ESC )
      EXIT
   CASE Qt_Key_Return
   CASE Qt_Key_Enter            /* Typically located on the keypad. */
      c := hbqt_QTranslateKey( kbm, K_ENTER, K_ENTER, K_ALT_ENTER, K_CTRL_ENTER )
      EXIT
   CASE Qt_Key_Tab
   CASE Qt_Key_Backtab
      c := hbqt_QTranslateKey( kbm, K_TAB, K_SH_TAB, K_TAB, K_CTRL_TAB, K_CTRL_SH_TAB )
      EXIT
   CASE Qt_Key_Backspace
      c := hbqt_QTranslateKey( kbm, K_BS, K_SH_BS, K_ALT_BS, K_CTRL_BS )
      EXIT
   CASE Qt_Key_Insert
      c := hbqt_QTranslateKey( kbm, K_INS, K_INS, K_ALT_INS, K_CTRL_INS )
      EXIT
   CASE Qt_Key_Delete
      c := hbqt_QTranslateKey( kbm, K_DEL, K_DEL, K_ALT_DEL, K_CTRL_DEL )
      EXIT

   CASE Qt_Key_Home
      c := hbqt_QTranslateKey5( kbm, K_HOME, K_HOME, K_ALT_HOME, K_CTRL_HOME, K_CTRL_HOME )
      EXIT
   CASE Qt_Key_End
      c := hbqt_QTranslateKey5( kbm, K_END, K_END, K_ALT_END, K_CTRL_END )
      EXIT
   CASE Qt_Key_Left
      c := hbqt_QTranslateKey5( kbm, K_LEFT, K_LEFT, K_ALT_LEFT, K_CTRL_LEFT )
      EXIT
   CASE Qt_Key_Up
      c := hbqt_QTranslateKey5( kbm, K_UP, K_UP, K_ALT_UP, K_CTRL_UP )
      EXIT
   CASE Qt_Key_Right
      c := hbqt_QTranslateKey5( kbm, K_RIGHT, K_RIGHT, K_ALT_RIGHT, K_CTRL_RIGHT )
      EXIT
   CASE Qt_Key_Down
      c := hbqt_QTranslateKey5( kbm, K_DOWN, K_DOWN, K_ALT_DOWN, K_CTRL_DOWN )
      EXIT
   CASE Qt_Key_PageUp
      c := hbqt_QTranslateKey5( kbm, K_PGUP, K_PGUP, K_ALT_PGUP, K_CTRL_PGUP )
      EXIT
   CASE Qt_Key_PageDown
      c := hbqt_QTranslateKey5( kbm, K_PGDN, K_PGDN, K_ALT_PGDN, K_CTRL_PGDN )
      EXIT

   CASE Qt_Key_F1
      c := hbqt_QTranslateKey( kbm, K_F1, K_SH_F1, K_ALT_F1, K_CTRL_F1 )
      EXIT
   CASE Qt_Key_F2
      c := hbqt_QTranslateKey( kbm, K_F2, K_SH_F2, K_ALT_F2, K_CTRL_F2 )
      EXIT
   CASE Qt_Key_F3
      c := hbqt_QTranslateKey( kbm, K_F3, K_SH_F3, K_ALT_F3, K_CTRL_F3 )
      EXIT
   CASE Qt_Key_F4
      c := hbqt_QTranslateKey( kbm, K_F4, K_SH_F4, K_ALT_F4, K_CTRL_F4 )
      EXIT
   CASE Qt_Key_F5
      c := hbqt_QTranslateKey( kbm, K_F5, K_SH_F5, K_ALT_F5, K_CTRL_F5 )
      EXIT
   CASE Qt_Key_F6
      c := hbqt_QTranslateKey( kbm, K_F6, K_SH_F6, K_ALT_F6, K_CTRL_F6 )
      EXIT
   CASE Qt_Key_F7
      c := hbqt_QTranslateKey( kbm, K_F7, K_SH_F7, K_ALT_F7, K_CTRL_F7 )
      EXIT
   CASE Qt_Key_F8
      c := hbqt_QTranslateKey( kbm, K_F8, K_SH_F8, K_ALT_F8, K_CTRL_F8 )
      EXIT
   CASE Qt_Key_F9
      c := hbqt_QTranslateKey( kbm, K_F9, K_SH_F9, K_ALT_F9, K_CTRL_F9 )
      EXIT
   CASE Qt_Key_F10
      c := hbqt_QTranslateKey( kbm, K_F10, K_SH_F10, K_ALT_F10, K_CTRL_F10 )
      EXIT
   CASE Qt_Key_F11
      c := hbqt_QTranslateKey( kbm, K_F11, K_SH_F11, K_ALT_F11, K_CTRL_F11 )
      EXIT
   CASE Qt_Key_F12
      c := hbqt_QTranslateKey( kbm, K_F12, K_SH_F12, K_ALT_F12, K_CTRL_F12 )
      EXIT

   CASE Qt_Key_Asterisk
      x := Qt_Key_Asterisk
      c := hbqt_QTranslateKeyKP( kbm, x, x, x, x, x, x, KP_ALT_ASTERISK, KP_CTRL_ASTERISK )
      EXIT
   CASE Qt_Key_Plus
      x := Qt_Key_Plus
      c := hbqt_QTranslateKeyKP( kbm, x, x, x, x, x, x, KP_ALT_PLUS, KP_CTRL_PLUS )
      EXIT
   CASE Qt_Key_Minus
      x := Qt_Key_Minus
      c := hbqt_QTranslateKeyKP( kbm, x, x, K_ALT_MINUS, x, x, x, KP_ALT_MINUS, KP_CTRL_MINUS )
      EXIT
   CASE Qt_Key_Slash
      x := Qt_Key_Slash
      c := hbqt_QTranslateKeyKP( kbm, x, x, x, x, x, x, KP_ALT_SLASH, KP_CTRL_SLASH )
      EXIT

   CASE Qt_Key_Space
      c := hbqt_QTranslateKey( kbm, K_SPACE, K_SPACE, K_SPACE, K_SPACE )
      EXIT
   CASE Qt_Key_Equal
      x := Qt_Key_Equal
      c := hbqt_QTranslateKey( kbm, x, x, K_ALT_EQUALS, x )
      EXIT

   CASE Qt_Key_0
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_0, K_ALT_0 )
      EXIT
   CASE Qt_Key_1
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_1, K_ALT_1 )
      EXIT
   CASE Qt_Key_2
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_2, K_ALT_2 )
      EXIT
   CASE Qt_Key_3
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_3, K_ALT_3 )
      EXIT
   CASE Qt_Key_4
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_4, K_ALT_4 )
      EXIT
   CASE Qt_Key_5
      c := hbqt_QTranslateKeyKP( kbm, Qt_Key_5, Qt_Key_5, K_ALT_5, Qt_Key_5, Qt_Key_5, Qt_Key_5, KP_ALT_5, KP_CTRL_5 )
      EXIT
   CASE Qt_Key_6
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_6, K_ALT_6 )
      EXIT
   CASE Qt_Key_7
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_7, K_ALT_7 )
      EXIT
   CASE Qt_Key_8
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_8, K_ALT_8 )
      EXIT
   CASE Qt_Key_9
      c := hbqt_QTranslateKeyDigit( kbm, Qt_Key_9, K_ALT_9 )
      EXIT

   CASE Qt_Key_A
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_A, 'a', K_ALT_A, K_CTRL_A, txt )
      EXIT
   CASE Qt_Key_B
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_B, 'b', K_ALT_B, K_CTRL_B, txt )
      EXIT
   CASE Qt_Key_C
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_C, 'c', K_ALT_C, K_CTRL_C, txt )
      EXIT
   CASE Qt_Key_D
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_D, 'd', K_ALT_D, K_CTRL_D, txt )
      EXIT
   CASE Qt_Key_E
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_E, 'e', K_ALT_E, K_CTRL_E, txt )
      EXIT
   CASE Qt_Key_F
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_F, 'f', K_ALT_F, K_CTRL_F, txt )
      EXIT
   CASE Qt_Key_G
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_G, 'g', K_ALT_G, K_CTRL_G, txt )
      EXIT
   CASE Qt_Key_H
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_H, 'h', K_ALT_H, K_CTRL_H, txt )
      EXIT
   CASE Qt_Key_I
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_I, 'i', K_ALT_I, K_CTRL_I, txt )
      EXIT
   CASE Qt_Key_J
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_J, 'j', K_ALT_J, K_CTRL_J, txt )
      EXIT
   CASE Qt_Key_K
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_K, 'k', K_ALT_K, K_CTRL_K, txt )
      EXIT
   CASE Qt_Key_L
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_L, 'l', K_ALT_L, K_CTRL_L, txt )
      EXIT
   CASE Qt_Key_M
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_M, 'm', K_ALT_M, K_CTRL_M, txt )
      EXIT
   CASE Qt_Key_N
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_N, 'n', K_ALT_N, K_CTRL_N, txt )
      EXIT
   CASE Qt_Key_O
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_O, 'o', K_ALT_O, K_CTRL_O, txt )
      EXIT
   CASE Qt_Key_P
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_P, 'p', K_ALT_P, K_CTRL_P, txt )
      EXIT
   CASE Qt_Key_Q
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_Q, 'q', K_ALT_Q, K_CTRL_Q, txt )
      EXIT
   CASE Qt_Key_R
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_R, 'r', K_ALT_R, K_CTRL_R, txt )
      EXIT
   CASE Qt_Key_S
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_S, 's', K_ALT_S, K_CTRL_S, txt )
      EXIT
   CASE Qt_Key_T
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_T, 't', K_ALT_T, K_CTRL_T, txt )
      EXIT
   CASE Qt_Key_U
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_U, 'u', K_ALT_U, K_CTRL_U, txt )
      EXIT
   CASE Qt_Key_V
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_V, 'v', K_ALT_V, K_CTRL_V, txt )
      EXIT
   CASE Qt_Key_W
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_W, 'w', K_ALT_W, K_CTRL_W, txt )
      EXIT
   CASE Qt_Key_X
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_X, 'x', K_ALT_X, K_CTRL_X, txt )
      EXIT
   CASE Qt_Key_Y
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_Y, 'y', K_ALT_Y, K_CTRL_Y, txt )
      EXIT
   CASE Qt_Key_Z
      c := hbqt_QTranslateKeyAlpha( kbm, Qt_Key_Z, 'z', K_ALT_Z, K_CTRL_Z, txt )
      EXIT

   OTHERWISE
      IF key >= 0 .and. key <= 255
         c := key
      ENDIF
      EXIT

   ENDSWITCH

   RETURN c


FUNCTION hbqt_hbEventToQtEvent( key )

   SWITCH( key )

   CASE K_ESC
      RETURN Qt_Key_Escape
   CASE K_ENTER
   CASE K_ALT_ENTER
   CASE K_CTRL_ENTER
      RETURN Qt_Key_Enter
   CASE K_TAB
      RETURN Qt_Key_Tab
   CASE K_SH_TAB
      RETURN Qt_Key_Backtab
   CASE K_CTRL_TAB
      RETURN Qt_Key_Tab
   CASE K_SH_BS
   CASE K_ALT_BS
   CASE K_CTRL_BS
      RETURN Qt_Key_Backspace
   CASE K_INS
   CASE K_ALT_INS
   CASE K_CTRL_INS
      RETURN Qt_Key_Insert
   CASE K_DEL
   CASE K_ALT_DEL
   CASE K_CTRL_DEL
      RETURN Qt_Key_Delete
   CASE K_HOME
   CASE K_ALT_HOME
   CASE K_CTRL_HOME
      RETURN Qt_Key_Home
   CASE K_END
   CASE K_ALT_END
   CASE K_CTRL_END
      RETURN Qt_Key_End
   CASE K_LEFT
   CASE K_ALT_LEFT
   CASE K_CTRL_LEFT
      RETURN Qt_Key_Left
   CASE K_UP
   CASE K_ALT_UP
   CASE K_CTRL_UP
      RETURN Qt_Key_Up
   CASE K_RIGHT
   CASE K_ALT_RIGHT
   CASE K_CTRL_RIGHT
      RETURN Qt_Key_Right
   CASE K_DOWN
   CASE K_ALT_DOWN
   CASE K_CTRL_DOWN
      RETURN Qt_Key_Down
   CASE K_PGUP
   CASE K_ALT_PGUP
   CASE K_CTRL_PGUP
      RETURN Qt_Key_PageUp
   CASE K_PGDN
   CASE K_ALT_PGDN
   CASE K_CTRL_PGDN
      RETURN Qt_Key_PageDown
   CASE K_F1
   CASE K_SH_F1
   CASE K_ALT_F1
   CASE K_CTRL_F1
      RETURN Qt_Key_F1
   CASE K_F2
   CASE K_SH_F2
   CASE K_ALT_F2
   CASE K_CTRL_F2
      RETURN Qt_Key_F2
   CASE K_F3
   CASE K_SH_F3
   CASE K_ALT_F3
   CASE K_CTRL_F3
      RETURN Qt_Key_F3
   CASE K_F4
   CASE K_SH_F4
   CASE K_ALT_F4
   CASE K_CTRL_F4
      RETURN Qt_Key_F4
   CASE K_F5
   CASE K_SH_F5
   CASE K_ALT_F5
   CASE K_CTRL_F5
      RETURN Qt_Key_F5
   CASE K_F6
   CASE K_SH_F6
   CASE K_ALT_F6
   CASE K_CTRL_F6
      RETURN Qt_Key_F6
   CASE K_F7
   CASE K_SH_F7
   CASE K_ALT_F7
   CASE K_CTRL_F7
      RETURN Qt_Key_F7
   CASE K_F8
   CASE K_SH_F8
   CASE K_ALT_F8
   CASE K_CTRL_F8
      RETURN Qt_Key_F8
   CASE K_F9
   CASE K_SH_F9
   CASE K_ALT_F9
   CASE K_CTRL_F9
      RETURN Qt_Key_F9
   CASE K_F10
   CASE K_SH_F10
   CASE K_ALT_F10
   CASE K_CTRL_F10
      RETURN Qt_Key_F10
   CASE K_F11
   CASE K_SH_F11
   CASE K_ALT_F11
   CASE K_CTRL_F11
      RETURN Qt_Key_F11
   CASE K_F12
   CASE K_SH_F12
   CASE K_ALT_F12
   CASE K_CTRL_F12
      RETURN Qt_Key_F12
   CASE KP_ALT_ASTERISK
   CASE KP_CTRL_ASTERISK
      RETURN Qt_Key_Asterisk
   CASE KP_ALT_PLUS
   CASE KP_CTRL_PLUS
      RETURN Qt_Key_Plus
   CASE K_ALT_MINUS
   CASE KP_ALT_MINUS
   CASE KP_CTRL_MINUS
      RETURN Qt_Key_Minus
   CASE KP_ALT_SLASH
   CASE KP_CTRL_SLASH
      RETURN Qt_Key_Slash
   CASE K_SPACE
      RETURN Qt_Key_Space
   CASE K_ALT_EQUALS
      RETURN Qt_Key_Equal
   CASE K_ALT_0
      RETURN Qt_Key_0
   CASE K_ALT_1
      RETURN Qt_Key_1
   CASE K_ALT_2
      RETURN Qt_Key_2
   CASE K_ALT_3
      RETURN Qt_Key_3
   CASE K_ALT_4
      RETURN Qt_Key_4
   CASE K_ALT_5
   CASE KP_CTRL_5
      RETURN Qt_Key_5
   CASE K_ALT_6
      RETURN Qt_Key_6
   CASE K_ALT_7
      RETURN Qt_Key_7
   CASE K_ALT_8
      RETURN Qt_Key_8
   CASE K_ALT_9
      RETURN Qt_Key_9
   CASE K_ALT_A
      RETURN Qt_Key_A
   CASE K_ALT_B
      RETURN Qt_Key_B
   CASE K_ALT_C
      RETURN Qt_Key_C
   CASE K_ALT_D
      RETURN Qt_Key_D
   CASE K_ALT_E
      RETURN Qt_Key_E
   CASE K_ALT_F
      RETURN Qt_Key_F
   CASE K_ALT_G
      RETURN Qt_Key_G
   CASE K_ALT_H
      RETURN Qt_Key_H
   CASE K_ALT_I
      RETURN Qt_Key_I
   CASE K_ALT_J
      RETURN Qt_Key_J
   CASE K_ALT_K
   CASE K_CTRL_K
      RETURN Qt_Key_K
   CASE K_ALT_L
   CASE K_CTRL_L
      RETURN Qt_Key_L
   CASE K_ALT_M
      RETURN Qt_Key_M
   CASE K_ALT_N
   CASE K_CTRL_N
      RETURN Qt_Key_N
   CASE K_ALT_O
   CASE K_CTRL_O
      RETURN Qt_Key_O
   CASE K_ALT_P
   CASE K_CTRL_P
      RETURN Qt_Key_P
   CASE K_ALT_Q
   CASE K_CTRL_Q
      RETURN Qt_Key_Q
   CASE K_ALT_R
      RETURN Qt_Key_R
   CASE K_ALT_S
      RETURN Qt_Key_S
   CASE K_ALT_T
   CASE K_CTRL_T
      RETURN Qt_Key_T
   CASE K_ALT_U
   CASE K_CTRL_U
      RETURN Qt_Key_U
   CASE K_ALT_V
      RETURN Qt_Key_V
   CASE K_ALT_W
      RETURN Qt_Key_W
   CASE K_ALT_X
      RETURN Qt_Key_X
   CASE K_ALT_Y
   CASE K_CTRL_Y
      RETURN Qt_Key_Y
   CASE K_ALT_Z
      RETURN Qt_Key_Z
   ENDSWITCH

   RETURN key


FUNCTION hbqt_EventModifier( key )

   SWITCH key

   CASE K_ALT_ENTER
      RETURN Qt_AltModifier
   CASE K_CTRL_ENTER
      RETURN Qt_ControlModifier
   CASE K_SH_TAB
      RETURN Qt_ShiftModifier
   CASE K_CTRL_TAB
      RETURN Qt_ControlModifier
   CASE K_SH_BS
      RETURN Qt_ShiftModifier
   CASE K_ALT_BS
      RETURN Qt_AltModifier
   CASE K_CTRL_BS
      RETURN Qt_ControlModifier
   CASE K_ALT_INS
      RETURN Qt_AltModifier
   CASE K_CTRL_INS
      RETURN Qt_ControlModifier
   CASE K_ALT_DEL
      RETURN Qt_AltModifier
   CASE K_CTRL_DEL
      RETURN Qt_ControlModifier
   CASE K_ALT_HOME
      RETURN Qt_AltModifier
   CASE K_CTRL_HOME
      RETURN Qt_ControlModifier
   CASE K_ALT_END
      RETURN Qt_AltModifier
   CASE K_CTRL_END
      RETURN Qt_ControlModifier
   CASE K_ALT_LEFT
      RETURN Qt_AltModifier
   CASE K_CTRL_LEFT
      RETURN Qt_ControlModifier
   CASE K_ALT_UP
      RETURN Qt_AltModifier
   CASE K_CTRL_UP
      RETURN Qt_ControlModifier
   CASE K_ALT_RIGHT
      RETURN Qt_AltModifier
   CASE K_CTRL_RIGHT
      RETURN Qt_ControlModifier
   CASE K_ALT_DOWN
      RETURN Qt_AltModifier
   CASE K_CTRL_DOWN
      RETURN Qt_ControlModifier
   CASE K_ALT_PGUP
      RETURN Qt_AltModifier
   CASE K_CTRL_PGUP
      RETURN Qt_ControlModifier
   CASE K_ALT_PGDN
      RETURN Qt_AltModifier
   CASE K_CTRL_PGDN
      RETURN Qt_ControlModifier
   CASE K_SH_F1
      RETURN Qt_ShiftModifier
   CASE K_ALT_F1
      RETURN Qt_AltModifier
   CASE K_CTRL_F1
      RETURN Qt_ControlModifier
   CASE K_SH_F2
      RETURN Qt_ShiftModifier
   CASE K_ALT_F2
      RETURN Qt_AltModifier
   CASE K_CTRL_F2
      RETURN Qt_ControlModifier
   CASE K_SH_F3
      RETURN Qt_ShiftModifier
   CASE K_ALT_F3
      RETURN Qt_AltModifier
   CASE K_CTRL_F3
      RETURN Qt_ControlModifier
   CASE K_SH_F4
      RETURN Qt_ShiftModifier
   CASE K_ALT_F4
      RETURN Qt_AltModifier
   CASE K_CTRL_F4
      RETURN Qt_ControlModifier
   CASE K_SH_F5
      RETURN Qt_ShiftModifier
   CASE K_ALT_F5
      RETURN Qt_AltModifier
   CASE K_CTRL_F5
      RETURN Qt_ControlModifier
   CASE K_SH_F6
      RETURN Qt_ShiftModifier
   CASE K_ALT_F6
      RETURN Qt_AltModifier
   CASE K_CTRL_F6
      RETURN Qt_ControlModifier
   CASE K_SH_F7
      RETURN Qt_ShiftModifier
   CASE K_ALT_F7
      RETURN Qt_AltModifier
   CASE K_CTRL_F7
      RETURN Qt_ControlModifier
   CASE K_SH_F8
      RETURN Qt_ShiftModifier
   CASE K_ALT_F8
      RETURN Qt_AltModifier
   CASE K_CTRL_F8
      RETURN Qt_ControlModifier
   CASE K_SH_F9
      RETURN Qt_ShiftModifier
   CASE K_ALT_F9
      RETURN Qt_AltModifier
   CASE K_CTRL_F9
      RETURN Qt_ControlModifier
   CASE K_SH_F10
      RETURN Qt_ShiftModifier
   CASE K_ALT_F10
      RETURN Qt_AltModifier
   CASE K_CTRL_F10
      RETURN Qt_ControlModifier
   CASE K_SH_F11
      RETURN Qt_ShiftModifier
   CASE K_ALT_F11
      RETURN Qt_AltModifier
   CASE K_CTRL_F11
      RETURN Qt_ControlModifier
   CASE K_SH_F12
      RETURN Qt_ShiftModifier
   CASE K_ALT_F12
      RETURN Qt_AltModifier
   CASE K_CTRL_F12
      RETURN Qt_ControlModifier
   CASE KP_ALT_ASTERISK
      RETURN Qt_AltModifier
   CASE KP_CTRL_ASTERISK
      RETURN Qt_ControlModifier
   CASE KP_ALT_PLUS
      RETURN Qt_AltModifier
   CASE KP_CTRL_PLUS
      RETURN Qt_ControlModifier
   CASE K_ALT_MINUS
      RETURN Qt_AltModifier
   CASE KP_ALT_MINUS
      RETURN Qt_AltModifier
   CASE KP_CTRL_MINUS
      RETURN Qt_ControlModifier
   CASE KP_ALT_SLASH
      RETURN Qt_AltModifier
   CASE KP_CTRL_SLASH
      RETURN Qt_ControlModifier
   CASE K_ALT_EQUALS
      RETURN Qt_AltModifier
   CASE KP_CTRL_5
      RETURN Qt_ControlModifier
   CASE K_ALT_0
   CASE K_ALT_1
   CASE K_ALT_2
   CASE K_ALT_3
   CASE K_ALT_4
   CASE K_ALT_5
   CASE KP_ALT_5
   CASE K_ALT_6
   CASE K_ALT_7
   CASE K_ALT_8
   CASE K_ALT_9
   CASE K_ALT_A
   CASE K_ALT_B
   CASE K_ALT_C
   CASE K_ALT_D
   CASE K_ALT_E
   CASE K_ALT_F
   CASE K_ALT_G
   CASE K_ALT_H
   CASE K_ALT_I
   CASE K_ALT_J
   CASE K_ALT_K
   CASE K_ALT_L
   CASE K_ALT_M
   CASE K_ALT_N
   CASE K_ALT_O
   CASE K_ALT_P
   CASE K_ALT_Q
   CASE K_ALT_R
   CASE K_ALT_S
   CASE K_ALT_T
   CASE K_ALT_U
   CASE K_ALT_V
   CASE K_ALT_W
   CASE K_ALT_X
   CASE K_ALT_Y
   CASE K_ALT_Z
      RETURN Qt_AltModifier
   CASE K_CTRL_A
   CASE K_CTRL_C
   CASE K_CTRL_D
   CASE K_CTRL_F
   CASE K_CTRL_G
   CASE K_CTRL_H
   CASE K_CTRL_I
   CASE K_CTRL_K
   CASE K_CTRL_L
   CASE K_CTRL_M
   CASE K_CTRL_N
   CASE K_CTRL_O
   CASE K_CTRL_P
   CASE K_CTRL_Q
   CASE K_CTRL_R
   CASE K_CTRL_S
   CASE K_CTRL_T
   CASE K_CTRL_U
   CASE K_CTRL_V
   CASE K_CTRL_X
   CASE K_CTRL_Y
      RETURN Qt_NoModifier

   ENDSWITCH

   RETURN Qt_NoModifier

